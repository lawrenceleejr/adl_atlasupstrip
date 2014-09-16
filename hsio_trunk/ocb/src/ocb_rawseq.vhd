--
-- Opcode Block RAWSEQ
-- 
-- Modified RAWSIGS to allow any/all to be sent at once - a sequencer.
-- Operates at 80Mb though
--
-- 
-- Matt Warren 2013
--
-- change log
-- 2013-06-12 copied ocb_rawsigs to this file
-- 2013-10-08 converted to 80Mb with large RAM
-- 2014-03-12 fixed no cyclic bug
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


entity ocb_rawseq is
  port(
    running_o : out std_logic;

    reg_sigs_idle_i     : in  slv16;
    -- oc rx interface
    oc_valid_i    : in  std_logic;
    oc_data_i     : in  slv16;
    oc_dack_no    : out std_logic;
    -- locallink tx interface
    lls_o         : out t_llsrc;
    lld_i         : in  std_logic;
    -- payload functions
    sigs_o        : out std_logic_vector (15 downto 0);
    pattern_go_i  : in  std_logic;
    reg_sq_ctl_i      : in  std_logic_vector (15 downto 0);
    sq_stat_o     : out std_logic_vector (7 downto 0);
    sq_addr_o     : out std_logic_vector (15 downto 0);

    -- infrastructure
    strobe40_i       : in  std_logic;
    clk              : in  std_logic;
    rst              : in  std_logic;
    ocrawseq_start_o : out std_logic
    );

-- Declarations

end ocb_rawseq;

architecture rtl of ocb_rawseq is

  component cg_bram_8kx16
    port (
      clka  : in  std_logic;
      wea   : in  std_logic_vector(0 downto 0);
      addra : in  std_logic_vector(12 downto 0);
      dina  : in  std_logic_vector(15 downto 0);
      douta : out std_logic_vector(15 downto 0)
      );
  end component;

  component cg_bram_16kx16
    port (
      clka  : in  std_logic;
      wea   : in  std_logic_vector(0 downto 0);
      addra : in  std_logic_vector(13 downto 0);
      dina  : in  std_logic_vector(15 downto 0);
      douta : out std_logic_vector(15 downto 0)
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

  signal soq : std_logic_vector(15 downto 0);
  signal sigs_out : std_logic_vector(15 downto 0);

  signal ocseq_store_en : std_logic;
  signal rx_ocseq       : slv16;

  signal ack_busy     : std_logic;
  signal ack_send     : std_logic;
  signal sigs_start   : std_logic;
  signal sigs_start_q : std_logic;


  constant RAM_AD_WIDTH : integer := 14;
  
  signal pattram_dout : slv16;
  signal pattram_din  : slv16;
  signal pattram_we   : std_logic;
  signal pattram_we00   : std_logic_vector(0 downto 0);
  signal pattram_ad   : std_logic_vector(RAM_AD_WIDTH-1 downto 0);

  constant WCOUNT_MAX : integer := (2**RAM_AD_WIDTH-1);
  
  signal wcount     : integer range 0 to WCOUNT_MAX;
  signal wcount_en  : std_logic;
  signal wcount_clr : std_logic;
  signal wcount_load : std_logic;

  type oc_codes is (RAWSEQ, SEQ_PATTERN, INVALID);

  signal oc_coded          : oc_codes;
  signal rx_oc_coded       : oc_codes;
  signal rx_opcode         : slv16;
  signal rx_opcode0        : slv16;
  signal oc_coded_store_en : std_logic;
  signal oc_data_opcodepl  : slv16;
  signal rx_oc_port        : slv4;
  signal tx_payload        : slv16;

  signal sq_running  : std_logic;
  signal sq_ready    : std_logic;


  signal end_addr  : std_logic_vector(RAM_AD_WIDTH-1 downto 0);
  signal cyclic_en : std_logic;

  type states is (
    Opcode, OCSeq, Size,
    RawSeqStart, RawSeqRun,
    PatternAddr, PatternWords,
    PatternStart0, PatternStart1,  PatternRun,
    SendAck, WaitAckBusy,
    Idle, WaitOCReady, OCDone
    );

  signal state, nstate : states;

begin

  sq_stat_o <= "000000" & sq_running & sq_ready;
  sq_addr_o <= conv_std_logic_vector(wcount, 16);

  end_addr  <= reg_sq_ctl_i((RAM_AD_WIDTH-1) downto 0);
  cyclic_en <= reg_sq_ctl_i(B_SQ_CYCLIC_EN);


  oc_data_opcodepl <= oc_get_opcodepl(oc_data_i);

  oc_coded <= RAWSEQ      when (oc_data_opcodepl = OC_RAWSEQ)      else
              SEQ_PATTERN when (oc_data_opcodepl = OC_SEQ_PATTERN) else
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
                               pattern_go_i, rx_oc_coded, pattram_dout,
                               wcount, strobe40_i, ack_busy, end_addr,
                               reg_sigs_idle_i,
                               state
                               )
  begin

    -- defaults
    nstate            <= WaitOCReady;
    oc_dack_no        <= '1';
    --sigs_out          <= x"0000";
    sigs_out          <= reg_sigs_idle_i; --***
    ack_send          <= '0';
    ocseq_store_en    <= '0';
    sigs_start        <= '0';
    oc_coded_store_en <= '0';
    pattram_we        <= '0';
    wcount_clr        <= '0';
    wcount_load       <= '0';
    wcount_en         <= '0';
    sq_running        <= '0';
    sq_ready          <= '0';

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
        sq_running            <= '0';
        oc_dack_no            <= 'Z';
        if (pattern_go_i = '1') then
          nstate              <= PatternStart0;
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
        if (rx_oc_coded = RAWSEQ) then
          nstate   <= RawSeqStart;
        else
          nstate   <= PatternAddr;
        end if;


        ------------------------------------------------------------------
        -- OC_RAWSEQ
        ------------------------------------------------------------------

      when RawSeqStart =>               -- align with BCO          
        nstate       <= RawSeqStart;
        if (strobe40_i = '0') then
          sigs_start <= '1';
          --oc_dack_no <= '0';
          nstate     <= RawSeqRun;
        end if;

      when RawSeqRun =>
        nstate     <= RawSeqRun;
        sigs_out   <= oc_data_i;
        sq_running        <= '1';
        oc_dack_no <= '0';
        if (oc_valid_i = '0') then
          oc_dack_no <= '1';  -- wait til after ack
          nstate   <= SendAck;
        end if;


        ------------------------------------------------------------------
        -- OC_SEQ_PATTERN
        ------------------------------------------------------------------
        -- Load
        -------

      when PatternAddr =>               -- word 0 = address
        if (oc_data_i(15) = '0') then -- check is don't change address is enabled
          wcount_load <= '1';
        end if;
        oc_dack_no  <= '0';
        nstate      <= PatternWords;


      when PatternWords =>
        nstate     <= PatternWords;
        wcount_en  <= '1';
        oc_dack_no <= '0';
        pattram_we <= '1';
        if (oc_valid_i = '0') then
          oc_dack_no <= '1';  -- wait til after ack
          nstate   <= SendAck;
        end if;


        ----------------------------------------------------------------
        ----------------------------------------------------------------
        -- Run 

      when PatternStart0 =>
        oc_dack_no   <= 'Z';
        wcount_clr   <= '1';
        nstate     <= PatternStart1;

      when PatternStart1 =>  -- Wait for ram to produce data
        nstate       <= PatternStart1;
        oc_dack_no   <= 'Z';
        if (strobe40_i = '0') then      -- sync with BCO
          wcount_en  <= '1';
          sigs_start <= '1';
          nstate     <= PatternRun;
        end if;


      when PatternRun =>
        nstate     <= PatternRun;
        oc_dack_no <= 'Z';
        sigs_out   <= pattram_dout;
        sq_running        <= '1';
        wcount_en  <= '1';
        if (wcount >= conv_integer(end_addr)) then -- *** don't really like >=
          wcount_en  <= '0';
          if (cyclic_en = '1') then
            nstate   <= PatternStart0;
          else
            nstate   <= Idle; -- OCDone; -- started by a command, ot opcode
          end if;
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



--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==  --==
--------------------------------------------------------------------
  prc_wcount : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        wcount   <= 0;
      else
        if (wcount_clr = '1') then
          wcount <= 0;

        elsif (wcount_load = '1') then
          wcount <= conv_integer(oc_data_i);

        elsif (wcount_en = '1') and (wcount < WCOUNT_MAX) then
          wcount <= wcount + 1;

        end if;
      end if;
    end if;

  end process;


  pattram_ad <= conv_std_logic_vector(wcount, RAM_AD_WIDTH);
  pattram_we00 <= "1" when pattram_we = '1' else "0";  
  pattram_din <= oc_data_i;
    
  --inst_pattram : cg_bram_8kx16
  inst_pattram : cg_bram_16kx16
    port map (
      clka  => clk,
      wea   => pattram_we00,
      addra => pattram_ad,
      dina  => pattram_din,
      douta => pattram_dout
      );

-----------------------------------------------------------
-- OC/Ack Interface

  prc_stores : process (clk)
  begin
    if rising_edge(clk) then
      if (oc_coded_store_en = '1') then
        rx_oc_coded <= oc_coded;
        rx_oc_port  <= oc_get_port(oc_data_i);
      end if;

      if (ocseq_store_en = '1') then
        rx_ocseq <= oc_data_i;
      end if;

    end if;
  end process;



  rx_opcode0 <= OC_RAWSEQ when (rx_oc_coded = RAWSEQ) else
                OC_SEQ_PATTERN;

  rx_opcode <= oc_insert_port(rx_opcode0, rx_oc_port);

  tx_payload <= conv_std_logic_vector(wcount, 16); -- x"acac";


  ocbrawseq_ack : ll_ack_gen
    port map (
      opcode_i  => rx_opcode,
      ocseq_i   => rx_ocseq,
      ocsize_i  => x"0002",
      payload_i => tx_payload,
      send_i    => ack_send,
      busy_o    => ack_busy,
      lls_o     => lls_o,
      lld_i     => lld_i,
      clk       => clk,
      rst       => rst
      );


  ----------------------------------------------------
  prc_sig_start : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        sigs_start_q       <= '0';
        ocrawseq_start_o <= '0';

      else
        sigs_start_q   <= sigs_start;  -- sync to align with bco and make 25ns pulse
        ocrawseq_start_o <= sigs_start_q or sigs_start;

      end if;
    end if;
  end process;




  -----------------------------------------------------
  prc_sigs_out : process (clk)
  begin
    if rising_edge(clk) then
      --if (rst = '1') then
      --  soq <= (others => '0');
      --else
        soq <= sigs_out;
        running_o <= sq_running;
      --end if;
    end if;
  end process;


  sigs_o <= soq;




-------------------------------------------------------------------------------------------------
end architecture;


