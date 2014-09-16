--
-- VHDL Architecture hsio.clocks_top_tester.sim
--
-- Created:
--          by - warren.man (pc140.hep.ucl.ac.uk)
--          at - 15:30:03 03/07/14
--
-- using Mentor Graphics HDL Designer(TM) 2013.1 (Build 6)
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library hsio;
use hsio.pkg_hsio_globals.all;

entity clocks_top_tester is
  port(
    clk125_o        : out std_logic;
    clk156_o        : out std_logic;
    clk40_ext0_o    : out std_logic;
    clk40_ext1_o    : out std_logic;
    net_usb_ready_o : out std_logic;
    por_sw_no       : out std_ulogic;
    -- registers
    reg             : out t_reg_bus;
    rst_local_o     : out std_ulogic
    );

-- Declarations

end clocks_top_tester;

--
architecture sim of clocks_top_tester is

  signal clk125 : std_logic := '1';
  signal clk156 : std_logic := '1';
  signal clk40  : std_logic := '1';

  signal clk_mode : std_logic_vector(1 downto 0);



begin

  clk40 <= not(clk40) after 12500 ps;

  clk125   <= not(clk125) after 4000 ps;
  clk125_o <= clk125;


  clk156_o     <= '0';
  clk40_ext0_o <= clk40;
  clk40_ext1_o <= clk40 after 4 ns;

  net_usb_ready_o <= '1';

  por_sw_no <= '0', '1' after 200 ns;

  --reg                                     <= (others => (others => '0'));
  reg(R_IN_ENA)(ENA_CLK1 downto ENA_CLK0) <= clk_mode;


  ----------------------------------------------------------------------------
  simulation                  :    process
    --------------------------------------------------
    -- Procedures 
    --------------------------------------------------
    procedure WaitClk is
    begin
      wait until rising_edge(clk125);
      wait for 100 ps;
    end procedure;
    ----------------------------------------------------
    procedure WaitClks (nclks : in integer) is
    begin
      for waitclkloops in 1 to nclks loop
        wait until rising_edge(clk125);
        wait for 100 ps;
      end loop;
    end procedure;
    ----------------------------------------------------

    -- =======================================================================
  begin


    clk_mode    <= "00";
    rst_local_o <= '0';

    WaitClks(10000);

    clk_mode <= "01";

    WaitClks(20000);

    clk_mode <= "00";

    WaitClks(10000);

    clk_mode <= "10";

    WaitClks(10000);


    wait;

  end process;


end architecture sim;

