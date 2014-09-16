--
-- Opcode Block RAWCOM
-- 
-- Send payload as COM data
--
-- An example of an opcode that only sends an Ack as response
-- (using ll_ack_gen)
-- 
--
-- change log
-- 2012-05-15 syncd ocrawcom_start
-- 2012-05-24 added OC_COM_PATTERN

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library utils;
use utils.pkg_types.all;

library hsio;
use hsio.pkg_core_globals.all;

library locallink;


entity ocb_rawcom is
   port( 
      -- oc rx interface
      oc_valid_i       : in     std_logic;
      oc_data_i        : in     slv16;
      oc_dack_no       : out    std_logic;
      -- locallink tx interface
      lls_o            : out    t_llsrc;
      lld_i            : in     std_logic;
      -- payload functions
      abc_com_o        : out    std_logic;
      ocrawcom_start_o : out    std_logic;
      pattern_go_i     : in     std_logic;
      -- infrastructure
      strobe40_i       : in     std_logic;
      clk              : in     std_logic;
      rst              : in     std_logic
   );

-- Declarations

end ocb_rawcom ;

architecture rtl of ocb_rawcom is

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

  signal abc_com : std_logic;

  signal bitcount40     : integer range 0 to 15;
  signal bitcount40_set : std_logic;

  signal ocseq_store_en : std_logic;
  signal rx_ocseq       : slv16;

  signal ack_busy    : std_logic;
  signal ack_send    : std_logic;
  signal com_start   : std_logic;
  signal com_start_q : std_logic_vector(1 downto 0);


  signal pattram_data : slv16;
  signal pattram_we   : std_logic;
  signal pattram_ad   : slv4;

  signal wcount     : integer range 0 to 15;
  signal wcount_en  : std_logic;
  signal wcount_clr : std_logic;



  type oc_codes is (RAWCOM, COM_PATTERN, INVALID
                    );

  signal oc_coded          : oc_codes;
  signal rx_oc_port        : slv4;
  signal rx_oc_coded       : oc_codes;
  signal rx_opcode         : slv16;
  signal rx_opcode0        : slv16;
  signal oc_data_opcodepl  : slv16;
  
  signal oc_coded_store_en : std_logic;


  type states is (Opcode, OCSeq, Size,
                  RawComStart,
                  Serialise, SerialLoad0, SerialLoad1,
                  PatternLoad, PatternWords,
                  PatternStart,
                  PattSerialise, PattSerialLoad0, PattSerialLoad1,

                  SendAck, WaitAckBusy,
                  Idle, WaitOCReady, OCDone
                  );

  signal state, nstate : states;

begin

  oc_data_opcodepl <= oc_get_opcodepl(oc_data_i);

  oc_coded <= RAWCOM      when (oc_data_opcodepl = OC_RAWCOM)      else
              COM_PATTERN when (oc_data_opcodepl = OC_COM_PATTERN) else
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
    abc_com           <= '0';
    ack_send          <= '0';
    ocseq_store_en    <= '0';
    com_start         <= '0';
    oc_coded_store_en <= '0';
    pattram_we        <= '0';
    wcount_clr        <= '0';
    wcount_en         <= '0';


    case state is

      -------------------------------------------------------------

      when WaitOCReady =>
        nstate     <= WaitOCReady;
        oc_dack_no <= 'Z';
        if (oc_valid_i = '0') then  -- wait for OC to be done
          nstate   <= Idle;
        end if;


      when Idle =>
        nstate     <= Idle;
        oc_dack_no <= 'Z';
        if (pattern_go_i = '1') then
          nstate   <= PatternStart;

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
        if (rx_oc_coded = RAWCOM) then
          nstate   <= RawComStart;
        else
          nstate   <= PatternLoad;
        end if;


        ------------------------------------------------------------------
        -- OC_RAWCOM
        ------------------------------------------------------------------

      when RawComStart =>
        nstate         <= RawComStart;
        bitcount40_set <= '1';
        if (strobe40_i = '0') then
          com_start    <= '1';          -- must be sync'd with com
          nstate       <= Serialise;
        end if;


      when Serialise =>
        nstate   <= Serialise;
        abc_com  <= oc_data_i(bitcount40);
        if (bitcount40 = 1) and (strobe40_i = '0') then
          nstate <= SerialLoad0;
        end if;


      when SerialLoad0 =>               -- strobe40 = 1
        nstate  <= SerialLoad0;
        abc_com <= oc_data_i(bitcount40);
        nstate  <= SerialLoad1;


      when SerialLoad1 =>               --strobe40 = '0'
        abc_com <= oc_data_i(bitcount40);
        oc_dack_no <= '0';
        if (oc_valid_i = '0') then
           oc_dack_no <= '1';  -- wait til after ack

          nstate     <= SendAck;
        else
          nstate     <= Serialise;
        end if;


        ------------------------------------------------------------------
        -- OC_COM_PATTERN
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
        nstate         <= PatternStart;
        oc_dack_no <= 'Z';
        bitcount40_set <= '1';
        wcount_clr     <= '1';
        if (strobe40_i = '0') then
          com_start    <= '1';          -- must be sync'd with com
          nstate       <= PattSerialise;
        end if;


      when PattSerialise =>
        oc_dack_no <= 'Z';
        nstate   <= PattSerialise;
        abc_com  <= pattram_data(bitcount40);
        if (bitcount40 = 1) and (strobe40_i = '0') then
          nstate <= PattSerialLoad0;
        end if;


      when PattSerialLoad0 =>           -- strobe40 = 1
        nstate  <= PattSerialLoad0;
        oc_dack_no <= 'Z';
        abc_com <= pattram_data(bitcount40);
        nstate  <= PattSerialLoad1;


      when PattSerialLoad1 =>           --strobe40 = '0'
        oc_dack_no <= 'Z';
        abc_com <= pattram_data(bitcount40);

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
        nstate <= WaitAckBusy;
        if (ack_busy = '0') then
          nstate     <= OCDone;
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
        abc_com_o <= '0';
      else
        abc_com_o <= abc_com;
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
-- Ack Interface

  prc_occoded_store : process (clk)
  begin
    if rising_edge(clk) then
      if (oc_coded_store_en = '1') then
        rx_oc_coded <= oc_coded;
        rx_oc_port <= oc_get_port(oc_data_i);
      end if;
    end if;
  end process;

  prc_ocseq_store : process (clk)
  begin
    if rising_edge(clk) then
      if (ocseq_store_en = '1') then
        rx_ocseq <= oc_data_i;
      end if;
    end if;
  end process;



  rx_opcode0 <= OC_RAWCOM when (rx_oc_coded = RAWCOM) else OC_COM_PATTERN;

  rx_opcode <= oc_insert_port(rx_opcode0, rx_oc_port);


  ocbrawcom_ack : ll_ack_gen
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


  prc_com_start : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        com_start_q <= (others => '0');
      else
        com_start_q <= com_start_q(0) & com_start;  -- sync twice to align with bco and make 25ns pulse
      end if;
    end if;
  end process;

--ocrawcom_start_o <= '1' when com_start_q = "11" else '0';
  ocrawcom_start_o <= com_start_q(1);

end architecture;


