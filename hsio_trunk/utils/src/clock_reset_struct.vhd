-- VHDL Entity utils.clock_reset.symbol
--
-- Created by Matt Warren 2014
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2013.1 (Build 6)
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity clock_reset is
   port( 
      clk50_i         : in     std_logic;
      ext_clk_i       : in     std_logic;
      ext_clock_sel_i : in     std_logic;
      ext_reset_i     : in     std_logic;
      clk2x_o         : out    std_logic;
      clk_o           : out    std_logic;
      reset_o         : out    std_logic;
      rst_early       : out    std_logic
   );

-- Declarations

end clock_reset ;

-- VHDL from Block Diagram 
-- Generated by Mentor Graphics HDL Designer(TM) 2013.1 (Build 6) 
--
-- utils.clock_reset.struct
--
-- Created by Matt Warren 2014
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


architecture struct of clock_reset is

   -- Architecture declarations

   -- Internal signal declarations
   signal clk         : std_logic;
   signal clk40       : std_ulogic;
   signal clk50_ibufg : std_logic;
   signal clk_raw     : std_logic;
   signal dcm1_locked : std_logic;
   signal dcm2_locked : std_logic;
   signal por_q0      : std_logic;
   signal por_q1      : std_logic;
   signal por_q2      : std_logic;
   signal rpq         : std_logic;
   signal rpq2        : std_logic;
   signal rq0         : std_ulogic;
   signal rq1         : std_ulogic;
   signal rq2         : std_ulogic;
   signal rq3         : std_ulogic;
   signal rst_dcm1    : std_logic;
   signal rst_po      : std_logic;

   -- Implicit buffer signal declarations
   signal rst_early_internal : std_logic;


   -- Component Declarations
   component cg_dcm2x
   port (
      CLKIN_IN   : in     std_logic;
      RST_IN     : in     std_logic;
      CLK0_OUT   : out    std_logic;
      CLK2X_OUT  : out    std_logic;
      LOCKED_OUT : out    std_logic
   );
   end component;
   component cg_dcm_50to40
   port (
      CLKIN_IN        : in     std_logic;
      RST_IN          : in     std_logic;
      CLK0_OUT        : out    std_logic;
      CLK2X_OUT       : out    std_logic;
      CLKFX_OUT       : out    std_logic;
      CLKIN_IBUFG_OUT : out    std_logic;
      LOCKED_OUT      : out    std_logic
   );
   end component;
   component m_inv
   port (
      i : in     std_logic;
      o : out    std_logic
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
   component FD
   generic (
      INIT : bit := '0'
   );
   port (
      C : in     std_ulogic;
      D : in     std_ulogic;
      Q : out    std_ulogic
   );
   end component;


begin

   -- ModuleWare code(v1.12) for instance 'U_0' of 'buff'
   clk_o <= clk;

   -- Instance port mappings.
   Ucg_dcm_2x : cg_dcm2x
      port map (
         CLKIN_IN   => clk_raw,
         RST_IN     => rst_dcm1,
         CLK0_OUT   => clk,
         CLK2X_OUT  => clk2x_o,
         LOCKED_OUT => dcm2_locked
      );
   Ucg_dcm_50to40 : cg_dcm_50to40
      port map (
         CLKIN_IN        => clk50_i,
         RST_IN          => rst_po,
         CLKFX_OUT       => clk40,
         CLKIN_IBUFG_OUT => clk50_ibufg,
         CLK0_OUT        => open,
         CLK2X_OUT       => open,
         LOCKED_OUT      => dcm1_locked
      );
   U_7 : m_inv
      port map (
         i => dcm1_locked,
         o => rq0
      );
   U_10 : m_inv
      port map (
         i => dcm2_locked,
         o => rst_early_internal
      );
   Ubufgmux : BUFGMUX
      port map (
         O  => clk_raw,
         I0 => clk40,
         I1 => ext_clk_i,
         S  => ext_clock_sel_i
      );
   Ufd0 : FD
      generic map (
         INIT => '1'
      )
      port map (
         Q => rq1,
         C => clk50_ibufg,
         D => rq0
      );
   Ufd1 : FD
      generic map (
         INIT => '1'
      )
      port map (
         Q => rq2,
         C => clk50_ibufg,
         D => rq1
      );
   Ufd2 : FD
      generic map (
         INIT => '1'
      )
      port map (
         Q => rq3,
         C => clk50_ibufg,
         D => rq2
      );
   Ufd3 : FD
      generic map (
         INIT => '1'
      )
      port map (
         Q => rst_dcm1,
         C => clk50_ibufg,
         D => rq3
      );
   Upor0 : FD
      generic map (
         INIT => '1'
      )
      port map (
         Q => por_q0,
         C => clk50_ibufg,
         D => ext_reset_i
      );
   Upor1 : FD
      generic map (
         INIT => '1'
      )
      port map (
         Q => por_q1,
         C => clk50_ibufg,
         D => por_q0
      );
   Upor2 : FD
      generic map (
         INIT => '1'
      )
      port map (
         Q => por_q2,
         C => clk50_ibufg,
         D => por_q1
      );
   Upor3 : FD
      generic map (
         INIT => '1'
      )
      port map (
         Q => rst_po,
         C => clk50_ibufg,
         D => por_q2
      );
   Upr0 : FD
      generic map (
         INIT => '0'
      )
      port map (
         Q => rpq,
         C => clk,
         D => rst_early_internal
      );
   Upr1 : FD
      generic map (
         INIT => '0'
      )
      port map (
         Q => rpq2,
         C => clk,
         D => rpq
      );
   Upr2 : FD
      generic map (
         INIT => '0'
      )
      port map (
         Q => reset_o,
         C => clk,
         D => rpq2
      );

   -- Implicit buffered output assignments
   rst_early <= rst_early_internal;

end struct;
