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

entity trigger_top_tester is
  port(
    --bcid_l1a       : in     std_logic_vector (15 downto 0);
    --com_abc_o      : in     std_logic;
    --l1id           : in     slv16;
    --l1r_abc_o      : in     std_logic;
    tdc_edge0   : out std_logic;
    tlu_trig    : out std_logic;
    lemo_trig   : out std_logic;
    lemo_ecr    : out std_logic;
    lemo_bcr    : out std_logic;
    busy        : out std_logic;
    ocraw_start : out std_logic;

    command  : out slv16;
    reg      : out t_reg_bus;
    rawsigs  : out std_logic_vector (15 downto 0);
    strobe40 : out std_logic;
    clk40_o    : out std_logic;
    clk160_o    : out std_logic;
    clk_o    : out std_logic;
    rst_o    : out std_logic
    );

-- Declarations

end trigger_top_tester;

--
architecture sim of trigger_top_tester is

  constant POST_CLK_DELAY : time := 50 ps;

  signal rst : std_logic := '1';
  signal clk : std_logic := '1';

  signal clk40 : std_logic := '1';
  signal clk160 : std_logic := '1';
  signal ring : std_logic_vector(7 downto 0) := "00000001";
  

  signal clk_slow : std_logic := '1';


begin

  ring <= (ring(0) & ring(7 downto 1)) when rising_edge(clk40); 

  clk <= not(clk) after 6250 ps;

  clk40 <= not(clk40) after 12500 ps;
  clk160 <= not(clk160) after 3125 ps;

  clk_slow <= not(clk_slow) after 10 us;

  clk_o <= clk;
  clk40_o <= clk40;
  clk160_o <= clk160;
  rst_o <= rst;

  strobe40 <= clk40 after POST_CLK_DELAY;


  tdc_edge0 <= clk_slow after 12 ns;



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
    procedure SendCommand(cmd :    integer ) is
    begin
      WaitClks(1);
      command <= conv_std_logic_vector(2**cmd, 16);
      WaitClks(1);
      command <= x"0000";
      WaitClks(4);

    end procedure;
    ----------------------------------------------------

    ----------------------------------------------------



    -- =======================================================================
  begin

    -- Initialise
    --------------------------------------------------------------------

    lemo_trig   <= '0';
    tlu_trig    <= '0';
    lemo_ecr    <= '0';
    lemo_bcr    <= '0';
    busy        <= '0';
    command     <= x"0000";
    rawsigs     <= x"0000";
    ocraw_start <= '0';

    reg <= (others => x"0000");
    rst <= '1';
    Waitclks(10);
    rst <= '0';
    Waitclks(100);


    reg(R_OUTSIGS)  <= x"2222";
    reg(R_CONTROL1) <= x"3c00";         -- tdc_calib, tlu debug, tlu en, l1 auto
    reg(R_IN_ENA)   <= x"00FF";

    WaitClks(100);


    for n in 1 to 200 loop

      wait for 8 ns;

   -- tlu_trig <= '1', '0' after 103 ns;
      SendCommand(CMD_TRIG);
      WaitClks(1000);

   -- tlu_trig <= '1', '0' after 15 ns;
      SendCommand(CMD_TRIG);
      WaitClks(1000);

   -- tlu_trig <= '1', '0' after 43 ns;
      SendCommand(CMD_TRIG);
      WaitClks(2000);

    end loop;


    WaitClks(10000);



    WaitClks(303);

    lemo_ecr <= '1', '0' after 44 ns;
    WaitClks(277);

    tlu_trig <= '1', '0' after 203 ns;



    WaitClks(10);

    rawsigs(RS_STT_L0) <= '1', '0' after 25*10 ns;
    ocraw_start        <= '1', '0' after 12500 ps;


    WaitClks(1000);

    busy <= '1';
    WaitClks(1000);
    busy <= '0';
    WaitClks(1000);


    lemo_trig <= '1', '0' after 27 ns;
    WaitClks(10);


    lemo_trig <= '1', '0' after 25 ns;
    WaitClks(200);


    WaitClks(1000); wait for 8 ns;
    lemo_trig <= '1', '0' after 13 ns;
    WaitClks(100);


    lemo_trig <= '1', '0' after 25 ns;
    WaitClks(100);

    lemo_trig <= '1', '0' after 40 ns;

    WaitClks(1000);

    lemo_ecr <= '1', '0' after 40 ns;
    WaitClks(100);

    lemo_trig <= '1', '0' after 40 ns;
    WaitClks(100);

    lemo_trig <= '1', '0' after 27 ns;
    WaitClks(10);


    lemo_trig <= '1', '0' after 25 ns;
    WaitClks(200);



    WaitClks(1000);
    wait for 8 ns;
    lemo_trig <= '1', '0' after 13 ns;
    WaitClks(100);


    lemo_trig <= '1', '0' after 25 ns;
    WaitClks(100);

    lemo_trig <= '1', '0' after 40 ns;

    WaitClks(1000);

    -- ecr raw
    rawsigs(RS_STT_COM) <= '0'; WaitClks(2);
    rawsigs(RS_STT_COM) <= '1'; WaitClks(2);
    rawsigs(RS_STT_COM) <= '0'; WaitClks(2);
    rawsigs(RS_STT_COM) <= '1'; WaitClks(2);
    rawsigs(RS_STT_COM) <= '0'; WaitClks(2);
    rawsigs(RS_STT_COM) <= '0'; WaitClks(2);
    rawsigs(RS_STT_COM) <= '1'; WaitClks(2);
    rawsigs(RS_STT_COM) <= '1'; WaitClks(2);
    rawsigs(RS_STT_COM) <= '0'; WaitClks(2);
    rawsigs(RS_STT_COM) <= '0'; WaitClks(2);



    lemo_trig <= '1', '0' after 40 ns;
    WaitClks(100);

    lemo_trig <= '1', '0' after 27 ns;
    WaitClks(10);


    lemo_trig <= '1', '0' after 25 ns;
    WaitClks(200);



    WaitClks(1000);


    reg(R_TDELAY) <= x"0020";
    wait for 3 ns;
    lemo_trig     <= '1', '0' after 13 ns;
    WaitClks(1000);


    reg(R_TB_TRIGS)  <= x"0002";
    reg(R_TB_BURSTS) <= x"0002";
    reg(R_TB_PMIN)   <= x"000a";
    reg(R_TB_PMAX)   <= x"000a";
    reg(R_TB_PDEAD)  <= x"0020";

    WaitClks(10);

    SendCommand(CMD_TB_RST);
    SendCommand(CMD_TB_START);

    WaitClks(5000);

    reg(R_CONTROL) <= x"0400";          -- enable triggers to L1R

    SendCommand(CMD_TB_RST);
    SendCommand(CMD_TB_START);

    WaitClks(5000);





    wait;

  end process;
end architecture sim;

