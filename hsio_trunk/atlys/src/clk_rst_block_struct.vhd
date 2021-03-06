-- VHDL Entity atlys.clk_rst_block.symbol
--
-- Created by Matt Warren 2014
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2013.1 (Build 6)
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library utils;
use utils.pkg_types.all;

entity clk_rst_block is
   port( 
      --#clockpinforAtlysrevCboard
      clk_i         : in     std_logic;
      rst_o         : out    std_logic;
      clkn40_o      : out    std_logic;
      clk160_o      : out    std_logic;
      clk80_o       : out    std_logic;
      clk40_o       : out    std_logic;
      vmodin_bco_i  : in     std_logic;
      rst_btn_ni    : in     std_logic;
      rst_no        : out    std_logic;
      clk_int_sel_i : in     std_logic;
      ext_por_no    : out    std_logic;
      strobe40_o    : out    std_logic
   );

-- Declarations

end clk_rst_block ;

-- VHDL from Block Diagram 
-- Generated by Mentor Graphics HDL Designer(TM) 2013.1 (Build 6) 
--
-- atlys.clk_rst_block.struct
--
-- Created by Matt Warren 2014
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library utils;
use utils.pkg_types.all;
library unisim;
use unisim.VCOMPONENTS.all;
use ieee.numeric_std.all;


architecture struct of clk_rst_block is

   -- Architecture declarations

   -- Internal signal declarations
   signal rst           : std_logic;
   signal clk40         : std_logic;
   signal clk80         : std_logic;
   signal clk160        : std_logic;
   signal clkn40        : std_logic;
   signal clk40a_locked : std_logic;
   signal ext_por       : std_logic;
   signal clk40a        : std_logic;
   signal clk40b        : std_logic;
   signal clk80a        : std_logic;
   signal clk80b        : std_logic;
   signal clk160a       : std_logic;
   signal clk160b       : std_logic;
   signal clk40b_locked : std_logic;
   signal clkn40a       : std_logic;
   signal clkn40b       : std_logic;
   signal clk100        : std_logic;
   signal rst40a        : std_logic;
   signal rst40b        : std_logic;


   -- Component Declarations
   component cg_clk_100_40
   port (
      -- Clock in ports
      CLK100_IN : in     std_logic ;
      -- Clock out ports
      CLK100    : out    std_logic ;
      CLK40     : out    std_logic ;
      CLK80     : out    std_logic ;
      CLKN40    : out    std_logic ;
      CLK160    : out    std_logic ;
      -- Status and control signals
      RESET     : in     std_logic ;
      LOCKED    : out    std_logic 
   );
   end component;
   component cg_dcm_40
   port (
      -- Clock in ports
      BCO_IN    : in     std_logic ;
      -- Clock out ports
      CLK40     : out    std_logic ;
      CLK80     : out    std_logic ;
      CLK160    : out    std_logic ;
      CLK40_180 : out    std_logic ;
      -- Status and control signals
      RESET     : in     std_logic ;
      LOCKED    : out    std_logic ;
      CLK_VALID : out    std_logic 
   );
   end component;
   component xilinx_reset
   generic (
      PIPE_LEN : integer := 15
   );
   port (
      clk      : in     std_ulogic ;
      ready_i  : in     std_logic ;
      reset_no : out    std_ulogic ;
      reset_o  : out    std_ulogic 
   );
   end component;
   component BUFGMUX
   generic (
      CLK_SEL_TYPE : string := "SYNC"
   );
   port (
      I0 : in     std_ulogic;
      I1 : in     std_ulogic;
      S  : in     std_ulogic;
      O  : out    std_ulogic
   );
   end component;
   component strobe40_gen
   port (
      clk        : in     std_logic;
      clk40      : in     std_logic;
      rst        : in     std_logic;
      strobe40_o : out    std_logic
   );
   end component;


begin

   -- ModuleWare code(v1.12) for instance 'U_1' of 'buff'
   clk40_o <= clk40;

   -- ModuleWare code(v1.12) for instance 'U_3' of 'buff'
   clk80_o <= clk80;

   -- ModuleWare code(v1.12) for instance 'U_4' of 'buff'
   clk160_o <= clk160;

   -- ModuleWare code(v1.12) for instance 'U_5' of 'buff'
   clkn40_o <= clkn40;

   -- ModuleWare code(v1.12) for instance 'U_6' of 'buff'
   rst_o <= rst;

   -- ModuleWare code(v1.12) for instance 'U_13' of 'inv'
   rst40a <= not(clk40a_locked);

   -- ModuleWare code(v1.12) for instance 'U_14' of 'inv'
   rst40b <= not(clk40b_locked);

   -- ModuleWare code(v1.12) for instance 'U_2' of 'mux'

   -- Instance port mappings.
   Udcm40a : cg_clk_100_40
      port map (
         CLK100_IN => clk_i,
         CLK100    => clk100,
         CLK40     => clk40a,
         CLK80     => clk80a,
         CLKN40    => clkn40a,
         CLK160    => clk160a,
         RESET     => ext_por,
         LOCKED    => clk40a_locked
      );
   Udcm40b : cg_dcm_40
      port map (
         BCO_IN    => vmodin_bco_i,
         CLK40     => clk40,
         CLK80     => clk80,
         CLK160    => clk160,
         CLK40_180 => clkn40,
         RESET     => ext_por,
         LOCKED    => clk40b_locked,
         CLK_VALID => open
      );
   Uxreset : xilinx_reset
      generic map (
         PIPE_LEN => 15
      )
      port map (
         clk      => clk_i,
         ready_i  => rst_btn_ni,
         reset_no => ext_por_no,
         reset_o  => ext_por
      );
   Uxreset1 : xilinx_reset
      generic map (
         PIPE_LEN => 15
      )
      port map (
         clk      => clk40,
         ready_i  => clk40b_locked,
         reset_no => rst_no,
         reset_o  => rst
      );
   Ubufgmux40 : BUFGMUX
      port map (
         O  => open,
         I0 => clk40b,
         I1 => clk40a,
         S  => clk_int_sel_i
      );
   Ubufgmux40n : BUFGMUX
      port map (
         O  => open,
         I0 => clkn40b,
         I1 => clkn40a,
         S  => clk_int_sel_i
      );
   Ubufgmux80 : BUFGMUX
      port map (
         O  => open,
         I0 => clk80b,
         I1 => clk80a,
         S  => clk_int_sel_i
      );
   Ubufgmux160 : BUFGMUX
      port map (
         O  => open,
         I0 => clk160b,
         I1 => clk160a,
         S  => clk_int_sel_i
      );
   Ustrb40 : strobe40_gen
      port map (
         strobe40_o => strobe40_o,
         clk40      => clk40,
         rst        => rst40b,
         clk        => clk80
      );

end struct;
