--
-- VHDL Architecture hsio.main_fe_out_tester.sim
--
-- Created:
--          by - warren.man (pc140.hep.ucl.ac.uk)
--          at - 12:10:54 08/03/11
--
-- using Mentor Graphics HDL Designer(TM) 2010.2a (Build 7)
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity main_fe_out_tester is
  port(
    ibpp0_bco      : in  std_logic;
    ibpp0_com      : in  std_logic;
    ibpp0_dclk     : in  std_logic;
    ibpp0_l1       : in  std_logic;
    ibpp0_reset    : in  std_logic;
    ibpp1_bco      : in  std_logic;
    ibpp1_com      : in  std_logic;
    ibpp1_dclk     : in  std_logic;
    ibpp1_l1       : in  std_logic;
    ibpp1_reset    : in  std_logic;
    ibst_bco       : in  std_logic;
    ibst_bco_raw   : in  std_logic;
    ibst_com       : in  std_logic;
    ibst_com_raw   : in  std_logic;
    ibst_l1r       : in  std_logic;
    ibst_l1r_raw   : in  std_logic;
    ibst_noise     : in  std_logic;
    com            : out std_logic;
    l1r            : out std_logic;
    clk_o          : out std_logic;
    clk_40         : out std_logic;
    clk_bco        : out std_logic;
    clkn_bco       : out std_logic;
    reg_com_enable : out std_logic_vector (15 downto 0);
    reg_control    : out std_logic_vector (15 downto 0);
    rst_o          : out std_logic;
    strobe40       : out std_logic
    );

-- Declarations

end main_fe_out_tester;

--
architecture sim of main_fe_out_tester is



  constant POST_CLK_DELAY : time := 50 ps;

  signal rst : std_logic := '1';
  signal clk : std_logic := '1';

  signal clk40 : std_logic := '1';


begin

  clk <= not(clk) after 6250 ps;

  clk_o  <= clk;
  clk_40 <= clk40;

  rst_o <= rst;

  clk40 <= not(clk40) after 12500 ps;

  clk_bco  <= clk40;
  clkn_bco <= not(clk40);

  strobe40 <= clk40;


  ----------------------------------------------------------------------------
  simulation : process
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
    procedure SendComTrig is
    begin
      com <= '1';
      WaitClks(4);
      com <= '0';
    end procedure;
    ----------------------------------------------------
    procedure SendL1R is
    begin
      l1r <= '1';
      WaitClks(2);
      l1r <= '0';
    end procedure;
    ----------------------------------------------------



    -- =======================================================================
  begin

    -- Initialise
    --------------------------------------------------------------------

    com <= '0';
    l1r <= '0';
    rst <= '1';
    Waitclks(10);
    rst <= '0';
   waitClks(10);
    reg_com_enable <= x"333f";          --all sigs
    reg_control    <= x"0040";          --noise
   waitClks(10);
    SendComTrig;
    waitClks(10);
    SendL1R;
    waitClks(1000);



    -- 3
    reg_com_enable <= x"2000";
    SendComTrig;
    Waitclks(100);

    -- 4
    reg_com_enable <= x"2080";
    SendComTrig;
    Waitclks(500);






    -- 10
    reg_com_enable <= x"0100";
    SendComTrig;
    Waitclks(100);

    -- 11
    reg_com_enable <= x"0200";
    SendComTrig;
    Waitclks(500);



    -- 12a
    reg_com_enable <= x"1000";
    SendComTrig;
    Waitclks(100);

    -- 12b
    reg_com_enable <= x"0004";
    SendComTrig;
    Waitclks(100);

    -- 13
    reg_com_enable <= x"0008";
    SendComTrig;
    Waitclks(300);



    --14
    reg_control <= x"0280";
    SendComTrig;
    Waitclks(300);



    --15a
    reg_com_enable <= x"1000";
    SendComTrig;
    Waitclks(100);

    --15b
    reg_com_enable <= x"0004";
    SendComTrig;
    Waitclks(100);

    -- 16
    reg_com_enable <= x"0008";
    SendComTrig;
    Waitclks(100);


    -- 17
    reg_control <= x"00c0";
    SendComTrig;
    Waitclks(100);



    WaitClks(1000);



    for n in 0 to 99 loop
      SendL1R;
      WaitClks(10);
    end loop;


    wait;

  end process;

  
end architecture sim;

