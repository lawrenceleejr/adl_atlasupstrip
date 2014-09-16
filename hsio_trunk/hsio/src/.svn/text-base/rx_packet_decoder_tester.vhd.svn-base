--
--
--
--
--
--
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library utils;
use utils.pkg_types.all;

library hsio;
use hsio.pkg_hsio_globals.all;

entity rx_packet_decoder_tester is
  generic(
    USE_EXTERNAL_CLK80 :       integer := 0
    );
  port(
    rx_dst_rdy         : in    std_logic;
    rx_data_o          : out   std_logic_vector (15 downto 0);
    rx_eof             : out   std_logic;
    rx_sof             : out   std_logic;
    rx_src_rdy         : out   std_logic;
    tx_dst_rdy_o       : out   std_logic;
    tx_data_i          : in    std_logic_vector (15 downto 0);
    tx_eof_i           : in    std_logic;
    tx_sof_i           : in    std_logic;
    tx_src_rdy_i       : in    std_logic;
    clk40_out          : out   std_logic;
    clk80_out          : out   std_logic;
    clk80_in           : in    std_logic;
    clks_top_ready_o   : out   std_logic;
    clks_main_ready_i  : in    std_logic;
    clk125_out         : out   std_logic;
    clk156_out         : out   std_logic;
    st_hyb_data_o      : out   std_logic_vector (23 downto 0);
    pattern_go_o       : out   std_logic;
    sq_ctl_o           : out   slv16;
    sda_io             : inout std_logic;
    sck_io             : inout std_logic;
    sma_io             : inout std_logic_vector (8 downto 1);
    por                : out   std_logic;
    rst                : out   std_logic
    );

-- Declarations

end rx_packet_decoder_tester;

--
architecture sim of rx_packet_decoder_tester is


  constant POST_CLK_DELAY : time                          := 50 ps;
  signal   clk80          : std_logic                     := '1';
  signal   clk            : std_logic;
  signal   clk125         : std_logic                     := '0';
  signal   clk40          : std_logic                     := '0';
  signal   clk156         : std_logic                     := '0';
  signal   clk10          : std_logic                     := '0';
  signal   tx_dst_rdy     : std_logic                     := '1';
  signal   pattern17      : std_logic_vector(16 downto 0) := "00011111111001110";
  signal   pattern24      : std_logic_vector(23 downto 0) := "000000000000000000000001";
  signal   pattern_data   : std_logic_vector(23 downto 0) := "011101000011111111111101";

  signal seqid    : std_logic_vector(15 downto 0) := x"0000";
  signal oc_seqid : std_logic_vector(15 downto 0);

  signal NSTREAMS : integer;

  signal rx_data : std_logic_vector (15 downto 0);

  signal payload : slv16_array(750 downto 0) := (others => x"0000");

  signal sq_cyclic_en : std_logic;
  signal sq_end       : std_logic_vector(15 downto 0);


begin

  rx_data_o <= rx_data(7 downto 0) & rx_data(15 downto 8);  -- arrives swapped from net_usb in reality

  clk125     <= not(clk125) after 4000 ps;
  clk125_out <= clk125;

  clk156     <= not(clk156) after 3200 ps;
  clk156_out <= clk156;

  clk80 <= not(clk80) after 6250 ps;

  clk10 <= not(clk10) after 50 ns;

  clk <= clk80 when (USE_EXTERNAL_CLK80 = 0) else clk80_in;

  clk40_out <= clk40 when (USE_EXTERNAL_CLK80 = 0);
  clk80_out <= clk;

  clks_top_ready_o <= '0', '1' after 1000 ns;

  por <= '1', '0' after 1000 ns;

  rst <= not clks_main_ready_i;

  pattern17 <= (pattern17(0) & pattern17(16 downto 1)) when rising_edge(clk);

  --tx_dst_rdy   <= pattern17(0) after 50 ps;
  tx_dst_rdy   <= '1';                  --not(tx_dst_rdy) after 800 ns;
  tx_dst_rdy_o <= tx_dst_rdy;


  pattern24    <= (pattern24(22 downto 0) & pattern24(23))       when rising_edge(clk);
  pattern_data <= (pattern_data(22 downto 0) & pattern_data(23)) when rising_edge(clk);

  sq_ctl_o <= sq_cyclic_en & "00" & sq_end(12 downto 0);

  st_hyb_data_o <= pattern24 when (clk = '1') else pattern_data;

  sda_io <= 'H';
  sck_io <= 'H';


  sma_io(4) <= pattern24(0);            -- lemo_trig

  ----------------------------------------------------------------------------
  simulation                             :    process
    --------------------------------------------------
    -- Procedures 
    --------------------------------------------------
    procedure WaitClk is
    begin
      wait until rising_edge(clk);
      wait for POST_CLK_DELAY;
    end procedure;
    ----------------------------------------------------
    procedure WaitClks (nclks            : in integer) is
    begin
      for waitclkloops in 1 to nclks loop
        wait until rising_edge(clk);
        wait for POST_CLK_DELAY;
      end loop;
    end procedure;
    ----------------------------------------------------
    procedure WaitDstRdyClk is
    begin
      wait for POST_CLK_DELAY;
      if (rx_dst_rdy = '0') then
        wait until rising_edge(rx_dst_rdy);
      end if;
      wait until rising_edge(clk);
      wait for POST_CLK_DELAY;
    end procedure;
    ----------------------------------------------------
    procedure WaitEOF is                -- VERY simple for now ...
    begin
      wait until rising_edge(tx_eof_i);
      WaitClk;
    end procedure;
    -----------------------------------------------------
    procedure WaitEOFs(n_acks            : in integer := 1) is
    begin
      for n in 1 to n_acks loop
        WaitEOF;
      end loop;
    end procedure;
    -----------------------------------------------------
    procedure SendHeaderPreOpcode(portid :    integer := 5; cbcnt : integer := 1) is
    begin
      seqid      <= seqid + '1';
      oc_seqid   <= seqid + x"7e00";
      rx_src_rdy <= '1';
      -- dest mac
      rx_data    <= X"aabb"; rx_sof <= '1'; WaitDstRdyClk;
      rx_data    <= X"ccdd"; rx_sof <= '0'; WaitDstRdyClk;
      rx_data    <= X"eeff"; WaitDstRdyClk;
      --src mac
      rx_data    <= X"1122"; WaitDstRdyClk;
      rx_data    <= X"3344"; WaitDstRdyClk;
      rx_data    <= X"5566"; WaitDstRdyClk;
      -- type/magic number
      rx_data    <= X"876" & conv_std_logic_vector(portid, 4); WaitDstRdyClk;
      -- seq no
      rx_data    <= seqid; WaitDstRdyClk;
      -- len
      rx_data    <= X"0050"; WaitDstRdyClk;
      -- cb count
      rx_data    <= conv_std_logic_vector(cbcnt, 16); WaitDstRdyClk;
    end procedure;
    -----------------------------------------------------------------
    procedure SendPaddedtoEndofPacket is
    begin
      rx_data    <= X"0011"; WaitDstRdyClk;
      rx_data    <= X"2233"; WaitDstRdyClk;
      rx_data    <= X"4455"; WaitDstRdyClk;
      rx_data    <= X"6677"; WaitDstRdyClk;
      rx_data    <= X"8899"; WaitDstRdyClk;
      rx_data    <= X"aabb"; WaitDstRdyClk;
      rx_data    <= X"ccdd"; WaitDstRdyClk;
      rx_data    <= X"eeff"; WaitDstRdyClk;
      rx_data    <= X"0001"; WaitDstRdyClk;
      rx_data    <= X"0203"; WaitDstRdyClk;
      rx_data    <= X"0405"; WaitDstRdyClk;
      rx_data    <= X"0607"; WaitDstRdyClk;
      rx_data    <= X"0809"; WaitDstRdyClk;
      rx_data    <= X"0a0b"; WaitDstRdyClk;
      rx_data    <= X"0c0d"; WaitDstRdyClk;
      rx_data    <= X"0e0f"; WaitDstRdyClk;
      rx_data    <= X"0000"; WaitDstRdyClk;
      rx_data    <= X"ffff"; rx_eof <= '1'; WaitDstRdyClk;
      rx_eof     <= '0';
      rx_src_rdy <= '0';
      WaitClk;
    end procedure;
    --------------------------------------
    procedure SendZerotoEndofPacket is
    begin
      rx_data    <= x"0000"; WaitDstRdyClk;
      rx_data    <= x"0000"; WaitDstRdyClk;
      rx_data    <= x"0000"; WaitDstRdyClk;
      rx_data    <= x"0000"; WaitDstRdyClk;
      rx_data    <= x"0000"; WaitDstRdyClk;
      rx_data    <= x"0000"; WaitDstRdyClk;
      rx_data    <= x"0000"; WaitDstRdyClk;
      rx_data    <= x"0000"; WaitDstRdyClk;
      rx_data    <= x"0000"; WaitDstRdyClk;
      rx_data    <= x"0000"; WaitDstRdyClk;
      rx_data    <= x"0000"; WaitDstRdyClk;
      rx_data    <= x"0000"; WaitDstRdyClk;
      rx_data    <= x"0000"; WaitDstRdyClk;
      rx_data    <= x"0000"; WaitDstRdyClk;
      rx_data    <= x"0000"; WaitDstRdyClk;
      rx_data    <= x"0000"; WaitDstRdyClk;
      rx_data    <= x"0000"; WaitDstRdyClk;
      rx_data    <= x"0000"; WaitDstRdyClk;
      rx_data    <= x"0000"; rx_eof <= '1'; WaitDstRdyClk;
      rx_eof     <= '0';
      rx_src_rdy <= '0';
      WaitClk;
    end procedure;
    --------------------------------------
    procedure SendOnetoEndofPacket is
    begin
      for n in 0 to 14 loop
        rx_data  <= x"1111"; WaitDstRdyClk;
      end loop;
      rx_data    <= x"1111"; rx_eof <= '1'; WaitDstRdyClk;
      rx_eof     <= '0';
      rx_src_rdy <= '0';
      WaitClk;
    end procedure;

    -----------------------------------------------------------


    procedure WriteReg(rwa, rwd : integer) is
      variable rwa_slv          : std_logic_vector(15 downto 0);
      variable rwd_slv          : std_logic_vector(15 downto 0);
    begin
      rwa_slv := conv_std_logic_vector(rwa, 16);
      rwd_slv := conv_std_logic_vector(rwd, 16);
      SendHeaderPreOpcode;
      -- opcode
      rx_data <= X"0010"; WaitDstRdyClk;
      -- seq no
      rx_data <= oc_seqid; WaitDstRdyClk;
      -- size
      rx_data <= X"0004"; WaitDstRdyClk;
      -- rx_data
      rx_data <= rwa_slv; WaitDstRdyClk;
      rx_data <= rwd_slv; WaitDstRdyClk;
      SendPaddedtoEndofPacket;
      --WaitEOF;
      WaitClks(10);
    end procedure;

-----------------------------------------------------------

    procedure SendCommand (cmd0 : integer; cmd1 : integer := 0) is

      variable slv_cmd : std_logic_vector(15 downto 0);
    begin
      slv_cmd := BIT_MASK(cmd0) or BIT_MASK(cmd1);
      SendHeaderPreOpcode;
      -- opcode
      rx_data <= x"0030"; WaitDstRdyClk;
      -- seq no
      rx_data <= oc_seqid; WaitDstRdyClk;
      -- size
      rx_data <= x"0004"; WaitDstRdyClk;
      -- rx_data
      rx_data <= slv_cmd; WaitDstRdyClk;
      rx_data <= x"0000"; WaitDstRdyClk;
      SendZerotoEndofPacket;
      --WaitEOF;
      WaitClks(10);
    end procedure;


    --------------------------------------------------


    procedure RawComTrigger is
    begin
      SendHeaderPreOpcode;
      -- opcode
      rx_data <= X"0101"; WaitDstRdyClk;
      -- seq no
      rx_data <= oc_seqid; WaitDstRdyClk;
      -- size
      rx_data <= X"0004"; WaitDstRdyClk;
      -- rx_data
      rx_data <= X"0000"; WaitDstRdyClk;
      rx_data <= X"0300"; WaitDstRdyClk;
      SendZerotoEndofPacket;
      --WaitEOF;
      WaitClks(10);
    end procedure;

    -----------------------------------------------------------

    procedure RawComDoubleTrigger is
    begin
      SendHeaderPreOpcode;
      -- opcode
      rx_data <= X"0101"; WaitDstRdyClk;
      -- seq no
      rx_data <= oc_seqid; WaitDstRdyClk;
      -- size
      rx_data <= X"0004"; WaitDstRdyClk;
      -- rx_data
      rx_data <= X"0000"; WaitDstRdyClk;
      rx_data <= X"0300"; WaitDstRdyClk;
      rx_data <= X"0000"; WaitDstRdyClk;
      rx_data <= X"0300"; WaitDstRdyClk;
      SendZerotoEndofPacket;
      --WaitEOF;
      WaitClks(10);
    end procedure;

    -----------------------------------------------------------

    procedure RawComTripleTrigger is
    begin
      SendHeaderPreOpcode;
      -- opcode
      rx_data <= X"0101"; WaitDstRdyClk;
      -- seq no
      rx_data <= oc_seqid; WaitDstRdyClk;
      -- size
      rx_data <= X"0004"; WaitDstRdyClk;
      -- rx_data
      rx_data <= X"0000"; WaitDstRdyClk;
      rx_data <= X"0300"; WaitDstRdyClk;
      rx_data <= X"0000"; WaitDstRdyClk;
      rx_data <= X"0300"; WaitDstRdyClk;
      rx_data <= X"0000"; WaitDstRdyClk;
      rx_data <= X"0300"; WaitDstRdyClk;
      SendZerotoEndofPacket;
      --WaitEOF;
      WaitClks(10);
    end procedure;

    -----------------------------------------------------------

    procedure RawComData is
    begin
      SendHeaderPreOpcode;
      -- opcode
      rx_data <= X"0101"; WaitDstRdyClk;
      -- seq no
      rx_data <= oc_seqid; WaitDstRdyClk;
      -- size
      rx_data <= X"0020"; WaitDstRdyClk;
      -- rx_data
      rx_data <= X"8081"; WaitDstRdyClk;
      rx_data <= X"8283"; WaitDstRdyClk;
      rx_data <= X"8485"; WaitDstRdyClk;
      rx_data <= X"8687"; WaitDstRdyClk;
      rx_data <= X"8889"; WaitDstRdyClk;
      rx_data <= X"8a8b"; WaitDstRdyClk;
      rx_data <= X"8c8d"; WaitDstRdyClk;
      rx_data <= X"8e8f"; WaitDstRdyClk;
      rx_data <= X"9091"; WaitDstRdyClk;
      rx_data <= X"9293"; WaitDstRdyClk;
      rx_data <= X"9495"; WaitDstRdyClk;
      rx_data <= X"9697"; WaitDstRdyClk;
      rx_data <= X"9899"; WaitDstRdyClk;
      rx_data <= X"9a9b"; WaitDstRdyClk;
      rx_data <= X"9c9d"; WaitDstRdyClk;
      rx_data <= X"9e9f"; WaitDstRdyClk;
      rx_data <= X"0000"; WaitDstRdyClk;
      SendZerotoEndofPacket;
      --WaitEOF;
      WaitClks(10);
    end procedure;

    ------------------------------------------------------------------

    procedure SendMultiSteamConfig(strms, mask, stc : integer) is
    begin
      SendHeaderPreOpcode;
      -- opcode
      rx_data   <= X"0050"; WaitDstRdyClk;
      -- seq no
      rx_data   <= oc_seqid; WaitDstRdyClk;
      -- size
      rx_data   <= conv_std_logic_vector(2+(strms*4), 16); WaitDstRdyClk;
      -- mask
      rx_data   <= conv_std_logic_vector(mask, 16); WaitDstRdyClk;
      for i in 1 to strms loop
        -- stream-id
        rx_data <= conv_std_logic_vector(i-1, 16); WaitDstRdyClk;
        -- -- config
        rx_data <= conv_std_logic_vector(stc, 16); WaitDstRdyClk;
      end loop;
      SendZeroToEndofPacket;
      --WaitEOF;
      WaitClks(10);
    end procedure;

    -----------------------------------------------------------------

    procedure ReadRegBlock is
    begin
      SendHeaderPreOpcode;
      -- opcode
      rx_data <= X"0015"; WaitDstRdyClk;
      -- seq no
      rx_data <= X"5152"; WaitDstRdyClk;
      -- size
      rx_data <= X"0002"; WaitDstRdyClk;
      SendPaddedtoEndofPacket;
      --WaitEOF;
      WaitClks(200);
    end procedure;

    -----------------------------------------------------------------

    procedure ReadStatBlock is
    begin
      SendHeaderPreOpcode;
      -- opcode
      rx_data <= X"0019"; WaitDstRdyClk;
      -- seq no
      rx_data <= X"5152"; WaitDstRdyClk;
      -- size
      rx_data <= X"0002"; WaitDstRdyClk;
      SendPaddedtoEndofPacket;
      --WaitEOF;
      WaitClks(2);
    end procedure;

    ----------------------------------------------------------

    procedure ReadMonitorBlock is
    begin
      SendHeaderPreOpcode;
      -- opcode
      rx_data <= X"0041"; WaitDstRdyClk;
      -- seq no
      rx_data <= X"4321"; WaitDstRdyClk;
      -- size
      rx_data <= X"0004"; WaitDstRdyClk;
      SendPaddedtoEndofPacket;
      --WaitEOF;

    end procedure;

    ----------------------------------------------------------------

    procedure ReadRegAndStatBlock is
    begin

      SendHeaderPreOpcode(0, 2);

      -- REGBLOCK
      -- opcode
      rx_data <= X"0015"; WaitDstRdyClk;
      -- seq no
      rx_data <= X"5152"; WaitDstRdyClk;
      -- size
      rx_data <= X"0000"; WaitDstRdyClk;

      -- STATBLOCK
      -- opcode
      rx_data <= X"0019"; WaitDstRdyClk;
      -- seq no
      rx_data <= X"6162"; WaitDstRdyClk;
      -- size
      rx_data <= X"0000"; WaitDstRdyClk;


      SendPaddedtoEndofPacket;
      --WaitEOF;
      WaitClks(200);
    end procedure;


    ----------------------------------------------------------
    procedure SendEcho(words : integer := 5) is
    begin

      SendHeaderPreOpcode;

      rx_data <= X"0003"; WaitDstRdyClk;
      -- seq no
      rx_data <= X"5152"; WaitDstRdyClk;
      -- size
      rx_data <= conv_std_logic_vector((words*2), 16); WaitDstRdyClk;

      for n in 1 to words loop
        rx_data <= conv_std_logic_vector(n*2-1, 8) & conv_std_logic_vector(n*2, 8);
        WaitDstRdyClk;
      end loop;

      SendPaddedtoEndofPacket;
      --WaitEOF;
      WaitClks(200);

    end procedure;


    ----------------------------------------------------------
    procedure SendEcho2 is
    begin

      SendHeaderPreOpcode(0, 2);

      -- ECHO 1
      rx_data <= X"0003"; WaitDstRdyClk;
      -- seq no
      rx_data <= X"5152"; WaitDstRdyClk;
      -- size
      rx_data <= X"0008"; WaitDstRdyClk;

      rx_data <= X"0102"; WaitDstRdyClk;
      rx_data <= X"0304"; WaitDstRdyClk;
      rx_data <= X"0505"; WaitDstRdyClk;
      rx_data <= X"0708"; WaitDstRdyClk;

      -- ECHO 2
      -- opcode
      rx_data <= X"0003"; WaitDstRdyClk;
      -- seq no
      rx_data <= X"6162"; WaitDstRdyClk;
      -- size
      rx_data <= X"0008"; WaitDstRdyClk;

      rx_data <= X"1020"; WaitDstRdyClk;
      rx_data <= X"3040"; WaitDstRdyClk;
      rx_data <= X"5650"; WaitDstRdyClk;
      rx_data <= X"7080"; WaitDstRdyClk;


      SendPaddedtoEndofPacket;
      --WaitEOF;
      WaitClks(200);
    end procedure;


    ----------------------------------------------------------
    procedure SendArbOpcode (opcode : std_logic_vector(15 downto 0);
                             words  : integer := 3;
                             portid : integer := 5
                             ) is
    begin
      SendHeaderPreOpcode(portid);
      -- opcode
      rx_data   <= opcode; WaitDstRdyClk;
      -- seq no
      rx_data   <= oc_seqid; WaitDstRdyClk;
      -- size
      rx_data   <= conv_std_logic_vector(words*2, 16); WaitDstRdyClk;
      -- word0
      for n in 0 to (words-1) loop
        rx_data <= payload(n); WaitDstRdyClk;
      end loop;
      SendZerotoEndofPacket;
      --WaitEOF;
      WaitClks(10);
    end procedure;

    ----------------------------------------------------------


    --====================================================================
    --====================================================================
    --====================================================================

    procedure SeqTest is
    begin

      for n in 0 to 511 loop
        payload(n+1) <= x"1" & conv_std_logic_vector(n, 12);
      end loop;


      --payload(0) <= x"1234";

      --SendArbOpcode(OC_RAWSEQ, 16#100#+1);
      --WaitClks(1000);

      --payload(0) <= x"5678";

      --SendArbOpcode(OC_RAWSEQ, 16#100#+1);
      --WaitClks(2000);



      payload(0) <= x"0000";

      SendArbOpcode(OC_SEQ_PATTERN, 513);
      WaitClks(1000);

      sq_end <= x"0080";


      WriteReg(R_SQ_CTL, 16#8100#);     -- cyclic, seq len
      WriteReg(7, 100);                 -- len
      WriteReg(6, 16#0301#);            -- spy parallel capture rawsigs
      WriteReg(19, 16#0001#);           -- rawout_en


      --pattern_go_o <= '1'; WaitClk; pattern_go_o <= '0';
      SendCommand( CMD_SQPATT_GO, CMD_SINK_GO );
      WaitClks(10000);



      payload(0) <= x"8000";

      SendArbOpcode(OC_SEQ_PATTERN, 257);
      WaitClks(200);
      SendArbOpcode(OC_SEQ_PATTERN, 257);
      WaitClks(200);
      SendArbOpcode(OC_SEQ_PATTERN, 257);
      WaitClks(200);
      SendArbOpcode(OC_SEQ_PATTERN, 257);
      WaitClks(300);

      pattern_go_o <= '1'; WaitClk; pattern_go_o <= '0';
      WaitClks(600);

      payload(0) <= x"0010";
      SendArbOpcode(OC_SEQ_PATTERN, 257);
      WaitClks(200);

      pattern_go_o <= '1'; WaitClk; pattern_go_o <= '0';
      WaitClks(600);


      --WaitEOF;
      WaitClks(200);
    end procedure;

    ------------------------------------------------------------------------

    procedure TwoWireTest is
    begin

      payload(0) <= x"0001";
      payload(1) <= x"0e45";
      payload(2) <= x"ffff";            -- marker end + more to come

      payload(3) <= x"0002";
      payload(4) <= x"0e45";
      payload(5) <= x"ffff";

      payload(6) <= x"0003";
      payload(7) <= x"0e45";

      SendArbOpcode(OC_TWOWIRE, 8);

      WaitClks(160);
      for n in 0 to 100 loop
        sda_io <= 'Z'; WaitClks(320-n);
        sda_io <= '0'; WaitClks(220+n);
      end loop;
      sda_io   <= 'Z';

      WaitClks(10000);

      payload(0) <= x"000c";
      payload(1) <= x"4e03";
      payload(2) <= x"4e05";
      payload(3) <= x"4d07";

      SendArbOpcode(OC_TWOWIRE, 4);
      WaitClks(2200);

      sda_io <= '0'; WaitClks(100);
      sda_io <= 'Z'; WaitClks(600);
      sda_io <= '0'; WaitClks(100);
      sda_io <= 'Z'; WaitClks(100);

      WaitClks(10000);


      WaitClks(160);
      for n in 0 to 20 loop
        sda_io <= 'Z'; WaitClks(320);
        sda_io <= '0'; WaitClks(320);
      end loop;
      sda_io   <= 'Z';

      WaitClks(1000);

      payload(0) <= x"000c";
      payload(1) <= x"4e03";
      payload(2) <= x"4e05";
      payload(3) <= x"4d07";

      SendArbOpcode(OC_TWOWIRE, 4);
      WaitClks(160);
      for n in 0 to 20 loop
        sda_io <= 'Z'; WaitClks(320);
        sda_io <= '0'; WaitClks(320);
      end loop;
      sda_io   <= 'Z';

      WaitClks(5000);

      payload(0) <= x"5678";
      payload(1) <= x"0305";

      SendArbOpcode(OC_TWOWIRE, 2);

      WaitClks(500);

      sda_io <= '0'; WaitClks(100);
      sda_io <= 'Z'; WaitClks(500);
      sda_io <= '0'; WaitClks(100);
      sda_io <= 'Z'; WaitClks(500);
      sda_io <= '0'; WaitClks(100);
      sda_io <= 'Z'; WaitClks(500);
      sda_io <= '0'; WaitClks(100);
      sda_io <= 'Z'; WaitClks(500);
      sda_io <= '0'; WaitClks(100);
      sda_io <= 'Z'; WaitClks(100);

      WaitClks(1000);

      payload(0) <= x"9abc";
      payload(1) <= x"0305";

      SendArbOpcode(OC_TWOWIRE, 2);

      WaitClks(500);
      sda_io <= '0'; WaitClks(100);
      sda_io <= 'Z'; WaitClks(500);
      sda_io <= '0'; WaitClks(100);
      sda_io <= 'Z'; WaitClks(500);
      sda_io <= '0'; WaitClks(100);
      sda_io <= 'Z'; WaitClks(500);
      sda_io <= '0'; WaitClks(100);
      sda_io <= 'Z'; WaitClks(500);
      sda_io <= '0'; WaitClks(100);
      sda_io <= 'Z'; WaitClks(100);

      WaitClks(50000);

      pattern_go_o <= '1'; WaitClk;
      pattern_go_o <= '0'; WaitClk;
      WaitClks(600);

      pattern_go_o <= '1'; WaitClk;
      pattern_go_o <= '0'; WaitClk;
      WaitClks(600);

      pattern_go_o <= '1'; WaitClk;
      pattern_go_o <= '0'; WaitClk;

      WaitClks(600);

    end procedure;

    -------------------------------------------------------------------------
    procedure idelay_test is
    begin
      WaitClks(100);
      WriteReg(16#09#, 8);                  -- IDELAY set
      WaitClks(200);
      for yy in 0 to 32 loop
        WriteReg(16#09#, (yy*16#100#)+yy);  -- IDELAY set
        WaitClks(50);
      end loop;
      WriteReg(16#09#, 16);                 -- IDELAY set
      WaitClks(200);
      WriteReg(16#09#, 63);                 -- IDELAY set
      WaitClks(200);
    end procedure;

    ----------------------------------------------------------
    -------------------------------------------------------------------------
    procedure feout_test is
    begin
      WaitClks(100);
      WriteReg(R_COM_ENA, 16#38c7#);
      WaitClks(200);
      RawComData;
      WaitClks(200);

    end procedure;
    -------------------------------------------------------------------------
    procedure abc130_test is
    begin
      WriteReg(23, 16#00a0#);           -- CONTROL, enable dl0, ro13dg
      WaitClks(10);

      WriteReg(31, 13);                 -- DL0_DELAY, 13
      WaitClks(10);


      for n in 0 to 24 loop

        payload(0) <= x"1000";          -- COM
        payload(1) <= x"8000";
        SendArbOpcode(OC_RAWSIGS, 2);

        WaitClks(40);
      end loop;

      WriteReg(23, 16#a0#);             -- CONTROL, enable ro13dg
      WaitClks(10);

      SendMultiSteamConfig(144, 16#0fff#, 16#0101#);
      WaitClks(500);

-- RS_ABC_COM : integer := 12;
-- RS_ABC_L0 : integer := 13;
-- RS_ABC_L1 : integer := 14;
-- RS_ABC_R3S : integer := 15;


      -- Dflt    COM, 2#10100000#, 8);  --a0
      -- Idle    COM, 2#10100011#, 8);  --a3
      -- BCR     COM, 2#10100101#, 8);  --a5
      -- ECP     COM, 2#10100110#, 8);  --a6
      -- SRST    COM, 2#10101001#, 8);  --a9
      -- SEUR    COM, 2#10101010#, 8);  --aa
      -- HCC     COM, 2#10111101#, 8);  --ad
      -- ABC     COM, 2#10111110#, 8);  --ae

      for n in 0 to 99 loop
        payload(n) <= x"0000";
      end loop;

      payload(0) <= x"1000";            -- Destination ABC COM

      payload(10) <= x"00a5";           --BCR

      payload(20) <= x"00a9";           --SRST

      payload(31) <= x"02fb";           -- abc8 + 2hccid5
      payload(32) <= x"ff41";           -- 3hccid5 + chipid5 + addr7 + w1
      payload(33) <= x"0000";           -- dat 1
      payload(34) <= x"0F10";           -- dat 0

      payload(41) <= x"02fb";           -- abc8 + 2hccid5
      payload(42) <= x"ff45";           -- 3hccid5 + chipid5 + addr7 + w1
      payload(43) <= x"0000";           -- dat 1
      payload(44) <= x"0002";           -- dat 0



      SendArbOpcode(OC_RAWSIGS, 50);

-- hh hhhccccc aaaaaaar dddddddddddddddddddddddddddddddd
-- 0xAE 1111111111 00000001 x"00000000" 0
-- 10 11111011


      WaitClks(1000);

      for n in 0 to 24 loop

        payload(0) <= x"2000";          -- L0
        payload(1) <= x"1111";
        payload(2) <= x"1111";
        payload(3) <= x"0011";

        SendArbOpcode(OC_RAWSIGS, 4);

        WaitClks(10);
      end loop;

      WaitClks(20);

      for n in 0 to 24 loop

        payload(0)     <= x"4000";      -- L1
        for d in 0 to 9 loop
          payload(d+1) <= x"0C"&conv_std_logic_vector(n*10+d, 8);
        end loop;

        SendArbOpcode(OC_RAWSIGS, 11);

        WaitClks(5);
      end loop;

      payload(0) <= x"ffff";
      payload(1) <= x"ffff";
      payload(2) <= x"ffff";
      payload(3) <= x"ffff";
      payload(4) <= x"ffff";
      payload(5) <= x"ffff";
      payload(6) <= x"ffff";
      payload(7) <= x"ffff";
      payload(8) <= x"ffff";


      SendArbOpcode(OC_STRM_REQ_STAT, 9);

    end procedure;


    ----------------------------------------------------------------------------------
    procedure Mode40Test is
    begin


      SendMultiSteamConfig(4, 16#0fff#, 16#0011#);
      WaitClks(10);
      RawComTrigger;
      WaitClks(2500);
      WriteReg(23, 16#40a3#);           -- en mode40
      WaitClks(10);
      RawComTrigger;


    end procedure;

    -------------------------------------------------------------------------------
    procedure SigsIdleTest is
    begin


      WriteReg(R_OUTSIGS, 16#2222#);      -- ABC130 all round


      SendHeaderPreOpcode;
      -- opcode
      rx_data    <= X"0074";
      WaitDstRdyClk;
      -- seq no
      rx_data    <= oc_seqid;
      WaitDstRdyClk;
      -- size
      rx_data    <= conv_std_logic_vector(42, 16);
      WaitDstRdyClk;
      -- rx_payload0 (mask in this case)
      rx_data    <= x"0001"; WaitDstRdyClk;
      -- rx payloadn
      for n in 1 to 10 loop
        rx_data  <= x"0000"; WaitDstRdyClk;
        rx_data  <= x"ffff"; WaitDstRdyClk;
      end loop;
      rx_data    <= x"ffff"; rx_eof <= '1'; WaitDstRdyClk;
      rx_eof     <= '0';
      rx_src_rdy <= '0';
      WaitClk;

      WaitClks(1000);

      WriteReg(4, 16#555f#);            -- change idle

      WaitClks(200);

      SendHeaderPreOpcode;
      -- opcode
      rx_data    <= X"0074";
      WaitDstRdyClk;
      -- seq no
      rx_data    <= oc_seqid;
      WaitDstRdyClk;
      -- size
      rx_data    <= conv_std_logic_vector(42, 16);
      WaitDstRdyClk;
      -- rx_payload0 (mask in this case)
      rx_data    <= x"0001"; WaitDstRdyClk;
      -- rx payloadn
       for n in 1 to 10 loop
         rx_data  <= x"0000"; WaitDstRdyClk;
         rx_data  <= x"ffff"; WaitDstRdyClk;
       end loop;
      rx_data    <= x"ffff"; rx_eof <= '1'; WaitDstRdyClk;
      rx_eof     <= '0';
      rx_src_rdy <= '0';
      WaitClk;



      SendHeaderPreOpcode;
      -- opcode
      rx_data    <= X"0074";
      WaitDstRdyClk;
      -- seq no
      rx_data    <= oc_seqid;
      WaitDstRdyClk;
      -- size
      rx_data    <= conv_std_logic_vector(42, 16);
      WaitDstRdyClk;
      -- rx_payload0 (mask in this case)
      rx_data    <= x"0002"; WaitDstRdyClk;
      -- rx payloadn
       for n in 1 to 10 loop
         rx_data  <= x"0000"; WaitDstRdyClk;
         rx_data  <= x"ffff"; WaitDstRdyClk;
       end loop;
      rx_data    <= x"ffff"; rx_eof <= '1'; WaitDstRdyClk;
      rx_eof     <= '0';
      rx_src_rdy <= '0';
      WaitClk;



    end procedure;

    -------------------------------------------------------------------------

    --======================================================================
    -- Initialise
    --------------------------------------------------------------------
    procedure Init is
    begin


      --sma_io(4) <= '0';

      payload(0)  <= x"000c";
      payload(1)  <= x"0107";
      payload(2)  <= x"FFFF";
      payload(3)  <= x"0003";
      payload(4)  <= x"0004";
      payload(5)  <= x"0005";
      payload(6)  <= x"0006";
      payload(7)  <= x"0007";
      payload(8)  <= x"0008";
      payload(9)  <= x"0009";
      payload(10) <= x"1010";
      payload(11) <= x"1011";
      payload(12) <= x"1012";
      payload(13) <= x"1013";
      payload(14) <= x"1014";
      payload(15) <= x"1015";
      payload(16) <= x"1016";
      payload(17) <= x"1017";
      payload(18) <= x"1018";
      payload(19) <= x"1019";
      payload(20) <= x"2020";
      payload(21) <= x"2120";
      payload(22) <= x"2220";
      payload(23) <= x"2320";
      payload(24) <= x"2420";
      payload(25) <= x"2520";
      payload(26) <= x"2620";
      payload(27) <= x"2720";
      payload(28) <= x"2820";
      payload(29) <= x"2920";
      payload(30) <= x"3030";


      rx_data    <= x"0000";
      rx_eof     <= '0';
      rx_sof     <= '0';
      rx_src_rdy <= '0';

      pattern_go_o <= '0';
      sq_end       <= x"0100";
      sq_cyclic_en <= '0';

      sda_io <= 'Z';

      WaitClks(10);
    end procedure;





    ----------------------------------------------------------


    -- =======================================================================
  begin


    Init;

    WaitClks(300);
    SendMultiSteamConfig(144, 16#0fff#, 16#0101#);


    WaitClks(30000);


    SendCommand(CMD_TDC_START);
    WaitClks(10);
    
    SendCommand(CMD_TDC_START);
    WaitClks(10);
    
    SendCommand(CMD_TDC_START);
    WaitClks(10);
    
    SendCommand(CMD_TDC_START);
    WaitClks(10);
    
    SendCommand(CMD_TDC_START);
    WaitClks(10);
    
    SendCommand(CMD_TDC_START);
    WaitClks(10);
    
    SendCommand(CMD_TDC_START);
    WaitClks(10);
    
    SendCommand(CMD_TDC_START);
    WaitClks(10);
    
    SendCommand(CMD_TDC_START);
    WaitClks(10);
    
    SendCommand(CMD_TDC_START);
    WaitClks(10);
    
    SendCommand(CMD_TDC_START);
    WaitClks(10);
    


    SigsIdleTest;

    WaitClks(10000);




    WriteReg(R_OUTSIGS, 16#2222#);      -- ABC130 all round

    WriteReg(0, 1);                     -- ext trig en

    WaitClks(300);

    WriteReg(R_CONTROL1, 16#0400#);     -- enable L1 autogen

    WaitClks(300);

    WriteReg(R_CONTROL1, 16#0100#);     -- enable trig stretch

    WaitClks(300);


    SeqTest;
    WaitClks(2000);



    SendEcho(10);
    WaitClks(200);

    ReadRegAndStatBlock;
    WaitClks(200);

    ReadRegAndStatBlock;
    WaitClks(200);

    WaitClks(200);
    SendEcho(256);


    WaitClks(10000);

    ReadRegAndStatBlock;
    WaitClks(100);

    --WriteReg(16#00#, 1);              -- en ext trig
    SendArbOpcode(OC_RAWSIGS, 10);
    WaitClks(1000);
    --SendArbOpcode(OC_RAWCOM, 10, 1);
    SendArbOpcode(OC_RAWSEQ, 10);

    WaitClks(20000);



    --SendMultiSteamConfig(4, 16#0fff#, 16#0011#);
    WaitClks(10000);

    WriteReg(7, 100);                   -- len
    WriteReg(6, 16#0101#);              -- spy parallel capture

    WaitClks(20);


    payload(0) <= x"ffff";

    for n in 1 to 100 loop
      payload(n) <= conv_std_logic_vector(n, 4) &
                    conv_std_logic_vector(n, 4) &
                    conv_std_logic_vector(n, 4) &
                    conv_std_logic_vector(n, 4);
    end loop;


    SendArbOpcode(OC_RAWSIGS, 50);


    --RawComTrigger;

    WaitClks(25000);

    WriteReg(23, 16#40a3#);             -- en mode40

    WaitClks(10);

    RawComTrigger;








    --for n in 1 to 10 loop
    --  ReadStatBlock;
    --end loop;

    --feout_test;




    WaitClks(20000);




    wait;

  end process;

end architecture sim;

