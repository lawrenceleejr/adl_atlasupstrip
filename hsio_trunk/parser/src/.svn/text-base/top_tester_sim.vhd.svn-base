
--
-- VHDL Architecture parser.top_tester.sim
--
-- Created:
--          by - warren.man (pc140.hep.ucl.ac.uk)
--          at - 16:42:10 12/17/09
--
-- using Mentor Graphics HDL Designer(TM) 2008.1b (Build 7)
--
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
library UNISIM;
use UNISIM.VComponents.all;

entity top_tester is
  port(
    ftdi_TXE_in : out std_logic;
    start_hstro : out std_logic;
    clock40     : out std_logic;
    abcdata_o   : out std_logic;
    dst_rdy     : out std_logic;
    reset_in    : out std_logic

    );

-- Declarations

end top_tester;

--
architecture sim of top_tester is

  signal clk40   : std_logic := '0';
  signal clk     : std_logic := '0';
  signal abcdata : std_logic := '0';



------------------------------------------------------------------------------
begin

  clk40 <= not(clk40) after 12500 ps;
  clk   <= clk40;

  clock40     <= clk40;
  ftdi_TXE_in <= '0';
  abcdata_o   <= abcdata;



  --------------------------------------------------------------------------
  simulation : process
    ----------------------------------------------------
    procedure WaitClk is
    begin
      wait until rising_edge(clk);
      wait for 1 ns;
    end procedure;
    ----------------------------------------------------
    procedure WaitClks (nclks : in integer) is
    begin
      for waitclkloops in 1 to nclks loop
        wait until rising_edge(clk);
        wait for 1 ns;
      end loop;
    end procedure;
    ----------------------------------------------------


  begin

    dst_rdy     <= '1';
    start_hstro <= '0';

    reset_in <= '1', '0' after 8 us;


    WaitClks(1000);

    start_hstro <= '1';
    WaitClk;
    start_hstro <= '0';


    wait for 50 us;
    WaitClk;

    start_hstro <= '1';
    WaitClk;
    start_hstro <= '0';


    wait;

  end process;
  

  
end architecture sim;



