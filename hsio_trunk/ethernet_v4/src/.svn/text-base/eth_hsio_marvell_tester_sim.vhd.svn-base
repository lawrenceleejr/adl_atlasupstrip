--
-- VHDL Architecture EthernetGMII.eth_hsio_marvell_tester.sim
--
-- Created:
--          by - warren.warren (fedxtron)
--          at - 16:08:15 06/04/09
--
-- using Mentor Graphics HDL Designer(TM) 2008.1 (Build 17)
--
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;

entity marvell_loopback_tester is
   port( 
      clk125             : out    std_logic;   -- ETH_GTX_CLK
      clk200             : out    std_logic;
      clk50              : out    std_logic;
      configuration_busy : out    boolean;
      eth_int_ni         : out    std_logic;
      -----------------------------------------------------------------------
      -- Signal Declarations
      -----------------------------------------------------------------------
      
      -- Global asynchronous reset
      rst                : out    std_logic;
      eth_md_io          : inout  std_logic    -- ETH_MDIO
   );

-- Declarations

end marvell_loopback_tester ;

--
architecture sim of marvell_loopback_tester is

  signal clk_125 : std_logic := '0';
  signal clk_200 : std_logic := '0';
  signal clk_50  : std_logic := '0';

begin

   clk_125 <= not clk_125 after 4000 ps;
   clk_200 <= not clk_200 after 2500 ps;
   clk_50  <= not clk_50  after 10 ns;

   clk125 <= clk_125;
   clk200 <= clk_200;
   clk50  <= clk_50;


   

   configuration_busy <= true,
                         false after 300 us;


   rst <= '1',
          '0' after 100 ns;

   eth_md_io <= '1';
    
end architecture sim;

