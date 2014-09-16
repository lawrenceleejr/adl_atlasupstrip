--
-- Opcode Block RAWSIGS
-- 
-- Update on RAWCOM to allow for multiple signal destinations
--
-- Uses first word of the payload as a mask to define signal routing
-- 
-- Matt Warren 2013
--
-- change log
-- 2013-01-25 copied ocb_rawcom to this file
-- 2013-05-22 made mask=0 enable all STT, STB and IDC COM.
--
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library utils;
use utils.pkg_types.all;

library hsio;
use hsio.pkg_core_globals.all;

library locallink;


entity ocb_rawsigs is
   port(
      running_o        : out    std_logic;
      reg_sigs_idle_i      : in     std_logic_vector (15 downto 0);
      --dl0_delay_i       : in     std_logic_vector (15 downto 0);
      --dl0_en_i          : in     std_logic;
      trg_all_mask_i    : in     std_logic_vector (15 downto 0);
      -- oc rx interface
      oc_valid_i        : in     std_logic;
      oc_data_i         : in     slv16;
      oc_dack_no        : out    std_logic;
      -- locallink tx interface
      lls_o             : out    t_llsrc;
      lld_i             : in     std_logic;
      -- payload functions
      sigs_o            : out    std_logic_vector (15 downto 0);
      pattern_go_i      : in     std_logic;
      -- infrastructure
      strobe40_i        : in     std_logic;
      clk               : in     std_logic;
      rst               : in     std_logic;
      ocrawsigs_start_o : out    std_logic
   );

-- Declarations

end ocb_rawsigs ;

architecture rtl of ocb_rawsigs is

  component cg_dram16x16
    port (
      a   : in  std_logic_vector(3 downto 0);
      d   : in  std_logic_vector(15 downto 0);
      clk : in  std_logic;
      we  : in  std_logic;
      spo : out std_logic_vector(15 downto 0)
      );
  end component;


  component ll_ack_gen
    port (
      -- input interface
      opcode_i  : in  slv16;
      ocseq_i   : in  slv16;
      ocsize_i  : in  slv16;
      payload_i : in  slv16;
      send_i    : in  std_logic;
      busy_o    : out std_logic;
      -- locallink tx interface
      lls_o     : out t_llsrc;
      lld_i     : in  std_logic;
      -- infrastucture
      clk       : in  std_logic;
      rst       : in  std_logic
      );
  end component;

  signal sig_out : std_logic;
  signal running : std_logic;

  signal bitcount40     : integer range 0 to 15;
  signal bitcount40_set : std_logic;

  signal ocseq_store_en : std_logic;
  signal rx_ocseq       : slv16;

  signal ack_busy    : std_logic;
  signal ack_send    : std_logic;
  signal sig_start   : std_logic;
  signal sig_start_q : std_logic_vector(1 downto 0);


  signal pattram_data : slv16;
  signal pattram_we   : std_logic;
  signal pattram_ad   : slv4;

  signal wcount     : integer range 0 to 15;
  signal wcount_en  : std_logic;
  signal wcount_clr : std_logic;

  --signal dl0count    : std_logic_vector(13 downto 0);
  --signal dl0mask     : std_logic_vector(15 downto 0);
  --signal dl0         : std_logic;
  --signal dl0_go      : std_logic;
  --signal dl0_running : std_logic;


  type oc_codes is ( RAWSIGS, SIGS_PATTERN, INVALID );

  signal oc_coded          : oc_codes;
  signal rx_oc_port        : slv4;
  signal rx_oc_coded       : oc_codes;
  signal rx_opcode         : slv16;
  signal rx_opcode0        : slv16;
  signal oc_data_opcodepl  : slv16;
  
  signal oc_coded_store_en : std_logic;

  signal destmask    : slv16;
  signal destmask_we : std_logic;


  type states is (Opcode, OCSeq, Size,
                  RawSigsStart, RawSigsGo,
                  Serialise, SerialLoad0, SerialLoad1,
                  PatternLoad, PatternWords,
                  PatternStart, PatternGo,
                  PattSerialise, PattSerialLoad0, PattSerialLoad1,

                  SendAck, WaitAckBusy,
                  Idle, WaitOCReady, OCDone
                  );

  signal state, nstate : states;

begin

  oc_data_opcodepl <= oc_get_opcodepl(oc_data_i);
  
  oc_coded <= RAWSIGS      when (oc_data_opcodepl = OC_RAWSIGS)      else
              SIGS_PATTERN when (oc_data_opcodepl = OC_SIGS_PATTERN) else
              INVALID;


  -- State Machine
  --------------------------------------------------------
  prc_sync_part : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        state <= WaitOCReady;
      else
        state <= nstate;

      end if;
    end if;
  end process;


  prc_async_machine : process (oc_valid_i, oc_data_i, oc_coded,
                               pattern_go_i, rx_oc_coded, pattram_data,
                               wcount, bitcount40, strobe40_i, ack_busy,
                               state
                               )
  begin

    -- defaults
    nstate            <= WaitOCReady;
    oc_dack_no        <= '1';
    bitcount40_set    <= '0';
    sig_out           <= '0';
    running           <= '0';
    ack_send          <= '0';
    ocseq_store_en    <= '0';
    sig_start         <= '0';
    oc_coded_store_en <= '0';
    pattram_we        <= '0';
    wcount_clr        <= '0';
    wcount_en         <= '0';
    destmask_we       <= '0';
    --dl0_go            <= '0';
    

    case state is

      -------------------------------------------------------------

      when WaitOCReady =>
        nstate     <= WaitOCReady;
        oc_dack_no <= 'Z';
        if (oc_valid_i = '0') then      -- wait for OC to be done
          nstate   <= Idle;
        end if;


      when Idle =>
        nstate                <= Idle;
        oc_dack_no            <= 'Z';
        if (pattern_go_i = '1') then
          nstate              <= PatternStart;
        elsif (oc_valid_i = '1') then
          if (oc_coded /= INVALID) then  -- check for opcode here
            oc_coded_store_en <= '1';
            nstate            <= Opcode;
          else
            nstate            <= WaitOCReady;
          end if;
        end if;


      when Opcode =>
        oc_dack_no <= '0';
        nstate     <= OCSeq;


      when OCSeq =>
        oc_dack_no     <= '0';
        ocseq_store_en <= '1';
        nstate         <= Size;


      when Size =>
        oc_dack_no <= '0';
        if (rx_oc_coded = RAWSIGS) then
          nstate   <= RawSigsStart;
        else
          nstate   <= PatternLoad;
        end if;


        ------------------------------------------------------------------
        -- OC_RAWSIGS
        ------------------------------------------------------------------

      when RawSigsStart =>
        oc_dack_no  <= '0';
        destmask_we <= '1';
        --dl0_go      <= '1';

        nstate <= RawSigsGo;


      when RawSigsGo =>
        nstate         <= RawSigsGo;
        bitcount40_set <= '1';
        if (strobe40_i = '0') then
          sig_start    <= '1';          -- must be sync'd with com
          nstate       <= Serialise;
        end if;


      when Serialise =>
        nstate   <= Serialise;
        sig_out  <= oc_data_i(bitcount40);
        running  <= '1';
        if (bitcount40 = 1) and (strobe40_i = '0') then
          nstate <= SerialLoad0;
        end if;


      when SerialLoad0 =>               -- strobe40 = 1
        sig_out <= oc_data_i(bitcount40);
        running  <= '1';
        nstate  <= SerialLoad1;


      when SerialLoad1 =>               --strobe40 = '0'
        sig_out    <= oc_data_i(bitcount40);
        running  <= '1';
        oc_dack_no <= '0';
        if (oc_valid_i = '0') then
          oc_dack_no <= '1';  -- wait til after ack
          nstate   <= SendAck;
        else
          nstate   <= Serialise;
        end if;


        ------------------------------------------------------------------
        -- OC_SIGS_PATTERN
        ------------------------------------------------------------------
      when PatternLoad =>
        wcount_clr <= '1';
        nstate     <= PatternWords;


      when PatternWords =>
        nstate     <= PatternWords;
        wcount_en  <= '1';
        oc_dack_no <= '0';
        pattram_we <= '1';
        if (wcount = 15) then
          nstate   <= SendAck;
        end if;

        ----------------------------------------------------------------

      when PatternStart =>
        oc_dack_no  <= 'Z';
        destmask_we <= '1';
        nstate      <= PatternGo;


      when PatternGo =>
        nstate     <= PatternGo;
        oc_dack_no <= 'Z';

        bitcount40_set <= '1';
        wcount_clr     <= '1';
        if (strobe40_i = '0') then
          sig_start    <= '1';          -- must be sync'd with com
          nstate       <= PattSerialise;
        end if;


      when PattSerialise =>
        oc_dack_no <= 'Z';

        nstate   <= PattSerialise;
        sig_out  <= pattram_data(bitcount40);
        running <= '1';
        if (bitcount40 = 1) and (strobe40_i = '0') then
          nstate <= PattSerialLoad0;
        end if;


      when PattSerialLoad0 =>           -- strobe40 = 1
        nstate     <= PattSerialLoad0;
        oc_dack_no <= 'Z';

        sig_out <= pattram_data(bitcount40);
        running <= '1';
        nstate  <= PattSerialLoad1;


      when PattSerialLoad1 =>           --strobe40 = '0'
        oc_dack_no <= 'Z';

        sig_out <= pattram_data(bitcount40);
        running <= '1';


        if (wcount = 15) then
          nstate    <= WaitOCReady;
        else
          wcount_en <= '1';
          nstate    <= PattSerialise;
        end if;



        ---------------------------------------------------------------


      when SendAck =>
        oc_dack_no <= '1';
        ack_send   <= '1';
        nstate     <= WaitAckBusy;


      when WaitAckBusy =>
        oc_dack_no <= '1';
        nstate     <= WaitAckBusy;
        if (ack_busy = '0') then
          nstate   <= OCDone;
        end if;



                   --=========================================================================
      when OCDone =>
        oc_dack_no   <= '0'; -- final oc_dack to release ocbus
        nstate <= Idle;



    end case;
  end process;


---------------------------------


  prc_clockout : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        sigs_o <= (others => '0');
      else
        -- default
        sigs_o <= reg_sigs_idle_i;
        running_o <= '0';


        if (running = '1') then
          running_o <= '1';
          if (sig_out = '1') then
            --sigs_o <= x"ffff" and (destmask or dl0mask);
            sigs_o <= (x"ffff" and destmask) or (reg_sigs_idle_i and not(destmask));
          else
            --sigs_o <= dl0mask;
            sigs_o <= (reg_sigs_idle_i and not(destmask));  --x"0000";
          end if;
        end if;
      end if;
    end if;
  end process;


--------------------------------------------------------------------


  prc_bit_counter40 : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') or (bitcount40_set = '1') then
        bitcount40     <= 15;
      else
        if (strobe40_i = '0') then
          if (bitcount40 = 0) then
            bitcount40 <= 15;
          else
            bitcount40 <= bitcount40 - 1;
          end if;
        end if;
      end if;
    end if;
  end process;

--------------------------------------------------------------------


  prc_wcount : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        wcount   <= 0;
      else
        if (wcount_clr = '1')
        then
          wcount <= 0;

        elsif (wcount_en = '1') and (wcount /= 15) then
          wcount <= wcount + 1;

        end if;
      end if;
    end if;

  end process;

  pattram_ad <= conv_std_logic_vector(wcount, 4);

  inst_ram : cg_dram16x16
    port map (
      a   => pattram_ad,
      d   => oc_data_i,
      clk => clk,
      we  => pattram_we,
      spo => pattram_data
      );


-----------------------------------------------------------
-- OC/Ack Interface

  prc_stores : process (clk)
  begin
    if rising_edge(clk) then
      if (oc_coded_store_en = '1') then
        rx_oc_coded <= oc_coded;
        rx_oc_port <= oc_get_port(oc_data_i);
      end if;

      if (ocseq_store_en = '1') then
        rx_ocseq <= oc_data_i;
      end if;

      if (destmask_we = '1') then
        if (oc_data_i = x"0000") then
          destmask <= BIT_MASK(RS_ID1_COM) or 
                      BIT_MASK(RS_ID0_COM) or 
                      BIT_MASK(RS_STB_COM) or 
                      BIT_MASK(RS_STT_COM); -- enable all COMs
        else
           destmask <= oc_data_i;
        end if;
      end if;

    end if;
  end process;



  rx_opcode0 <= OC_RAWSIGS when (rx_oc_coded = RAWSIGS) else
               OC_SIGS_PATTERN;

  rx_opcode <= oc_insert_port(rx_opcode0, rx_oc_port);


  ocbrawsigs_ack : ll_ack_gen
    port map (
      opcode_i  => rx_opcode,
      ocseq_i   => rx_ocseq,
      ocsize_i  => x"0002",
      payload_i => x"acac",
      send_i    => ack_send,
      busy_o    => ack_busy,
      lls_o     => lls_o,
      lld_i     => lld_i,
      clk       => clk,
      rst       => rst
      );


  prc_sig_start : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        sig_start_q <= (others => '0');
        ocrawsigs_start_o <= '0';
      else
        sig_start_q <= sig_start_q(0) & sig_start;  -- sync twice to align with bco and make 25ns pulse
        ocrawsigs_start_o <= sig_start_q(1) or sig_start_q(0) ;        
      end if;
    end if;
  end process;




--   prc_delayed_l0 : process (clk)
--   begin
--     if rising_edge(clk) then
--       if (rst = '1') then
--         dl0count    <= (others => '0');
--         dl0_running <= '0';
--         dl0 <= '0';
--       else
--         if (dl0_en_i = '0') then
--           dl0_running <= '0';
--         else
--           if (dl0_go = '1') then
--             dl0_running <= '1';
--           elsif (dl0 = '1') then
--             dl0_running <= '0';
--           end if;
--           if (dl0_go = '1') then
--             dl0count <= (others => '0');
--           elsif (strobe40_i = '0') then
--             -- default
--             dl0 <= '0';
--             if (dl0_running = '1')then
--               dl0count <= dl0count + '1';
--               if (dl0count = dl0_delay_i(13 downto 0)) then
--                 dl0 <= '1';
--               end if;
--             end if;
--           end if;
--         end if;
--       end if;
--     end if;
--   end process;


  -- uses the mask generated by outsigs_map_enc to send a trig 
  -- to all sigs that have a sync trigger function
--  dl0mask <= trg_all_mask_i when (dl0 = '1') else x"0000";


end architecture;


