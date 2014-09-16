--
-- VHDL Architecture hsio.readout_top_tester.sim
--
-- Created:
--          by - warren.man (pc140.hep.ucl.ac.uk)
--          at - 13:25:13 10/09/12
--
-- using Mentor Graphics HDL Designer(TM) 2010.2a (Build 7)
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library utils;
use utils.pkg_types.all;
library hsio;
use hsio.pkg_hsio_globals.all;

entity readout_top_tester is
  port(
    -- outputs
    ocrawcom_start_o : out std_logic;
    stt_hyb_data_o   : out std_logic_vector (23 downto 0);
    stb_hyb_data_o   : out std_logic_vector (23 downto 0);
    pp0_hyb_data_o   : out std_logic_vector (1 downto 0);
    pp1_hyb_data_o   : out std_logic_vector (1 downto 0);
    command_o        : out slv16;
    -- registers
    reg              : out t_reg_bus;
    s_lld_o          : out std_logic_vector(135 downto 0);
    strm_cmd_o       : out slv16_array (143 downto 0);
    strm_reg_o       : out slv16_array (143 downto 0);
    db_data_o        : out slv16;
    db_wr_idelay_o   : out std_logic;
    -- streams interface
    strm_req_stat_o  : out std_logic_vector (143 downto 0);
    strobe40_o       : out std_logic;
    lemo_trig_o      : out std_logic;
    --infra
    clk_out          : out std_logic;
    rst              : out std_logic

    );

-- Declarations

end readout_top_tester;

--
architecture sim of readout_top_tester is

  constant POST_CLK_DELAY : time      := 50 ps;
  signal   clk            : std_logic := '0';
  signal   strobe40       : std_logic := '0';

  signal pattern      : std_logic_vector(15 downto 0) := "0111111110011101";
  signal pattern24    : std_logic_vector(23 downto 0) := "000000000000000000000001";
  signal pattern_data : std_logic_vector(23 downto 0) := "011101000011111111111101";


begin

  rst <= '1', '0' after 100 ns;

  clk     <= not(clk) after 6250 ps;
  clk_out <= clk;

  strobe40   <= not(strobe40) after 12500 ps;
  strobe40_o <= strobe40      after POST_CLK_DELAY;


  pattern      <= (pattern(0) & pattern(15 downto 1))            when rising_edge(clk);
  pattern24    <= (pattern24(22 downto 0) & pattern24(23))       when rising_edge(clk);
  pattern_data <= (pattern_data(22 downto 0) & pattern_data(23)) when rising_edge(clk);

  stt_hyb_data_o <= pattern24 when (clk = '1') else pattern_data;
  stb_hyb_data_o <= pattern24 when (clk = '1') else pattern_data;

  pp0_hyb_data_o <= pattern24(1 downto 0) when (clk = '1') else pattern_data(1 downto 0);
  pp1_hyb_data_o <= pattern24(1 downto 0) when (clk = '1') else pattern_data(1 downto 0);


  ----------------------------------------------------------------------------
  simulation                  :    process
    --------------------------------------------------
    -- Procedures 
    --------------------------------------------------
    procedure WaitClk is
    begin
      wait until rising_edge(clk);
      wait for POST_CLK_DELAY;
    end procedure;
    ----------------------------------------------------
    procedure WaitClks (nclks : in integer) is
    begin
      for waitclkloops in 1 to nclks loop
        wait until rising_edge(clk);
        wait for POST_CLK_DELAY;
      end loop;
    end procedure;
    ----------------------------------------------------

  begin


    db_data_o        <= (others => '0');
    db_wr_idelay_o   <= '0';
    ocrawcom_start_o <= '0';
    reg              <= (others => (others => '0'));
    s_lld_o          <= (others => '1');
    strm_cmd_o       <= (others => (others => '0'));
    strm_reg_o       <= (others => (others => '0'));
    strm_req_stat_o  <= (others => '0');
    lemo_trig_o      <= '0';
    command_o        <= (others => '0');


    reg(R_IN_ENA)      <= x"0000";  --   0;  -- 0x00  -- inputs enables
    reg(R_OUT_ENA)     <= x"0000";  --   1;  -- 0x02  -- not yet used
    reg(R_INT_ENA)     <= x"0000";  --   2;  -- 0x04  -- internal signals ena
    reg(R_IN_INV)      <= x"0000";  --   3;  -- 0x06  -- input inverts
    reg(R_04)          <= x"0000";  --   4;  -- 0x08 
    reg(R_05)          <= x"0000";  --   5;  -- 0x0a
    reg(R_SPYSIG_CTL)  <= x"0000";  --   6;  -- 0x0c
    reg(R_LEN0)        <= x"007f";  --   7;  -- 0x0e
    reg(R_LEN1)        <= x"008f";  --   8;  -- 0x10
    reg(R_IDELAY)      <= x"0000";  --   9;  -- 0x12
    reg(R_SG0_CONF_LO) <= x"0000";  --  10;  -- 0x14
    reg(R_SG0_CONF_HI) <= x"0000";  --  11;  -- 0x16
    reg(R_SG1_CONF_LO) <= x"0000";  --  12;  -- 0x18
    reg(R_SG1_CONF_HI) <= x"0000";  --  13;  -- 0x1a
    reg(R_SG_RNDSEEDS) <= x"0112";  --  14;  -- 0x1c
    reg(R_15)          <= x"0000";  --  15;  -- 0x1e
    reg(R_COM_ENA)     <= x"9c01";  --  16;  -- 0x20
    reg(R_BUSY_DELTA)  <= x"2010";  --  17;  -- 0x22  -- levels for delta busy (global)
    reg(R_18)          <= x"0000";  --  18;  -- 0x24
    reg(R_19)          <= x"0000";  --  19;  -- 0x26
    reg(R_DISP_SEL)    <= x"0015";  --  20;  -- 0x28
    reg(R_LEMO_STRM)   <= x"0000";  --  21;  -- 0x2a  -- stream to present on dbg lemo 1,2
    reg(R_22)          <= x"0000";  --  22;  -- 0x2c
    reg(R_CONTROL)     <= x"0080";  --  23;  -- 0x2e
    reg(R_TB_TRIGS)    <= x"000a";  --  24;  -- 0x30  -- number of trigger in a burst
    reg(R_TB_BURSTS)   <= x"0001";  --  25;  -- 0x32  -- number of bursts
    reg(R_TB_PMIN)     <= x"0010";  --  26;  -- 0x34  -- trigger period min (400ns steps)
    reg(R_TB_PMAX)     <= x"0010";  --  27;  -- 0x36  -- trigger perid max (400ns steps)
    reg(R_TB_PDEAD)    <= x"1000";  --  28;  -- 0x38  -- intra-burst deadtime (6.4us steps)
    reg(R_TDELAY)      <= x"0000";  --  29;  -- 0x3a  -- trigger delay
    reg(R_30)          <= x"0000";  --  30;  -- 0x3c
    reg(R_31)          <= x"0000";  --  31;  -- 0x3e


    --------------------

    WaitClks(100);

    for n in 0 to 140 loop
      strm_reg_o(n) <= x"0009";

    end loop;

    reg(R_LEN0)        <= conv_std_logic_vector(90,16);
    reg(R_LEN1)        <= conv_std_logic_vector(90,16);

    reg(R_CONTROL)     <= x"00a0";
    
    WaitClks(100);

    for t in 1 to 5 loop
      command_o(CMD_TRIG) <= '1';
      WaitClk;
      command_o           <= x"0000";

      WaitClks(1000);

    end loop;
    
      WaitClks(5000);
    
      command_o(CMD_TRIG) <= '1';
      WaitClk;
      command_o           <= x"0000";

    

    WaitClks(1000000);

    -- Sequ setup :

    reg(R_TB_TRIGS)   <= x"09c3";
    reg( R_TB_BURSTS) <= x"0000";
    reg(R_TB_PMIN)    <= x"0019";
    reg(R_TB_PMAX)    <= x"0019";
    reg(R_TB_PDEAD)   <= x"2710";


    command_o(CMD_TB_RST) <= '1';
    WaitClk;
    command_o             <= x"0000";

    WaitClks(10);

    command_o(CMD_TB_START) <= '1';
    WaitClk;
    command_o               <= x"0000";



    wait;


  end process;
end architecture sim;

