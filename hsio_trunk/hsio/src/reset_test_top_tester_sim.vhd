--
-- VHDL Architecture hsio.reset_test_top_tester.sim
--
-- Created:
--          by - warren.man (pc164.hep.ucl.ac.uk)
--          at - 17:05:54 08/11/10
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity reset_test_top_tester is
  port(
    led_status_o    : in    std_logic;                       --LED_FPGA_STATUS
    -- CLOCKS
    clk_xtal_125_mi : out   std_logic;                       --CRYSTAL_CLK_M
    clk_xtal_125_pi : out   std_logic;                       --CRYSTAL_CLK_P
    rst_poweron_ni  : out   std_logic;                       --PORESET_N
    -- IDC CONNECTORS (P2-5)
    idc_p2_io       : inout std_logic_vector (31 downto 0);  --IDC_P2
    idc_p3_io       : inout std_logic_vector (31 downto 0);  --IDC_P3
    idc_p4_io       : inout std_logic_vector (31 downto 0);  --IDC_P4
    idc_p5_io       : inout std_logic_vector (31 downto 0)   --IDC_P5
    );

-- Declarations

end reset_test_top_tester;

--
architecture sim of reset_test_top_tester is



  signal clk : std_logic := '0';
  signal rst : std_logic := '1';

begin

  clk <= not(clk) after 4000 ps;

  clk_xtal_125_mi <= not(clk);
  clk_xtal_125_pi <= clk;
  rst_poweron_ni  <= not(rst);

  ----------------------------------------------------------------------------
  simulation                  :    process
    --------------------------------------------------
    -- Procedures 
    --------------------------------------------------
    procedure WaitClk is
    begin
      wait until rising_edge(clk);
      wait for 100 ps;
    end procedure;
    ----------------------------------------------------
    procedure WaitClks (nclks : in integer) is
    begin
      for waitclkloops in 1 to nclks loop
        wait until rising_edge(clk);
        wait for 100 ps;
      end loop;
    end procedure;
    ----------------------------------------------------


    -- =======================================================================
  begin

    -- Initialise
    --------------------------------------------------------------------

    rst <= '1', '0' after 1000 ns;


    wait;

  end process;

end architecture sim;

