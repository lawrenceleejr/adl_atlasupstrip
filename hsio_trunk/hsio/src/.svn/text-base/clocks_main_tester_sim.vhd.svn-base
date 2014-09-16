--
-- VHDL Architecture hsio.clocks_main_tester.sim
--
-- Created:
--          by - warren.man (pc140.hep.ucl.ac.uk)
--          at - 17:09:51 04/28/10
--
-- using Mentor Graphics HDL Designer(TM) 2008.1b (Build 7)
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library utils;
use utils.pkg_types.all;
library hsio;
use hsio.pkg_hsio_globals.all;

entity clocks_main_tester is
  port(
    reg        : out t_reg_bus;
    clk80_o       : out std_logic;
    clk40_o       : out std_logic;
    dcm_conf_data : out std_logic_vector (15 downto 0);
    dcm_conf_wr   : out std_logic;
    rst           : out std_logic
    );

-- Declarations

end clocks_main_tester;

--
architecture sim of clocks_main_tester is

  signal clk40 : std_logic := '1';
  signal clk80 : std_logic := '1';
  signal clk   : std_logic;




begin

  clk40   <= not(clk40) after 12500 ps;
  clk40_o <= clk40;

  clk80   <= not(clk80) after 6250 ps;
  clk80_o <= clk80;

  clk <= clk80;




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

    WaitClks(100);
    rst <= '0';
    WaitClks(100);


    -- Initialise
    --------------------------------------------------------------------
    rst           <= '1';
    dcm_conf_data <= x"0000";
    dcm_conf_wr   <= '0';
    reg(R_CONTROL)(CTL_BCO_DC_EN) <= '1';

      
    WaitClks(100);

    rst <= '0';

    WaitClks(3000);



    for n in 0 to 15 loop
      dcm_conf_data <= conv_std_logic_vector((n*127)+1, 16);
      WaitClks(2);
      dcm_conf_wr   <= '1'; WaitClk; dcm_conf_wr <= '0';


      WaitClks(2000*(n+1));

    end loop;





    WaitClks(10);


    wait;

  end process;

end architecture sim;

