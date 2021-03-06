-- VHDL Entity hsio.top_outputs.symbol
--
-- Created by Matt Warren 2014
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2013.1 (Build 6)
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity top_outputs is
   port( 
      clk              : in     std_logic;
      clk_bco_i        : in     std_logic;
      com_i            : in     std_logic;
      outsigs_i        : in     std_logic_vector (15 downto 0);
      reg_com_enable_i : in     std_logic_vector (15 downto 0);
      reg_control_i    : in     std_logic_vector (15 downto 0);
      rst              : in     std_logic;
      strobe40_i       : in     std_logic;
      dbg_outsigs_o    : out    std_logic_vector (15 downto 0);
      ibe_bco_mo       : out    std_logic;                       -- HARDRESETB (J32.6/J33.14) HRSTB (J26.B3)
      ibe_bco_po       : out    std_logic;                       -- HARDRESET (J32.5/J33.13) HRST (J26.A3)
      ibe_bcot_mo      : out    std_logic;                       -- HARDRESETB (J32.6/J33.14) HRSTB (J26.B3)
      ibe_bcot_po      : out    std_logic;                       -- HARDRESET (J32.5/J33.13) HRST (J26.A3)
      ibepp0_bc_mo     : out    std_logic;                       -- CLKB (J33.4) CLKLB (J26.D4)
      ibepp0_bc_po     : out    std_logic;                       -- CLK (J33.3) CLKL (J26.C4)
      ibepp0_clk_mo    : out    std_logic;                       -- CLKB (J33.4) CLKLB (J26.D4)
      ibepp0_clk_po    : out    std_logic;                       -- CLK (J33.3) CLKL (J26.C4)
      ibepp1_bc_mo     : out    std_logic;                       -- CLKB (J33.4) CLKLB (J26.D4)
      ibepp1_bc_po     : out    std_logic;                       -- CLK (J33.3) CLKL (J26.C4)
      ibepp1_clk_mo    : out    std_logic;                       -- BCB (J32.4/J33.8) SW_CLKB (J26.F4)
      ibepp1_clk_po    : out    std_logic;                       -- BC (J32.3/J33.7) SW_CLK (J26.E4)
      ibpp0_o          : out    std_logic_vector (7 downto 0);
      ibpp1_o          : out    std_logic_vector (7 downto 0);
      ibstb_com_o      : out    std_logic;
      ibstb_l1r_o      : out    std_logic;
      ibstb_noise_o    : out    std_logic;
      ibstt_com_o      : out    std_logic;
      ibstt_l1r_o      : out    std_logic;
      ibstt_noise_o    : out    std_logic
   );

-- Declarations

end top_outputs ;

-- VHDL from Block Diagram 
-- Generated by Mentor Graphics HDL Designer(TM) 2013.1 (Build 6) 
--
-- hsio.top_outputs.struct
--
-- Created by Matt Warren 2014
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library utils;
use utils.pkg_types.all;
library hsio;
use hsio.pkg_hsio_globals.all;

library unisim;
use unisim.VCOMPONENTS.all;


architecture struct of top_outputs is

   -- Architecture declarations

   -- Internal signal declarations
   signal LO          : std_logic;
   signal bco_en      : std_logic;
   signal bco_inv     : std_logic;
   signal bco_inv_n   : std_logic;
   signal dclk_ddr_d1 : std_logic;
   signal dclk_ddr_d2 : std_logic;
   signal dclk_en     : std_logic;
   signal dclk_inv    : std_logic;
   signal dclk_mode40 : std_logic;
   signal ibpp0_out   : std_logic_vector(7 downto 0);
   signal ibpp1_out   : std_logic_vector(7 downto 0);
   signal ibstb_bco   : std_logic;
   signal ibstt_bco   : std_logic;


attribute KEEP : string;
attribute KEEP of reg_control_i : signal is "true";
attribute KEEP of reg_com_enable_i : signal is "true";
--attribute KEEP of dbg_sig_o : signal is "true";
--attribute KEEP of sink_sig_o : signal is "true";

   -- Component Declarations
   component four_phase
   port (
      sig_i      : in     std_logic ;
      sig_o      : out    std_logic ;
      --dbg_sig_o  : out    std_logic;
      dbg_sig0_o : out    std_logic ;
      --    sig_0_o   : out std_logic;
      --    sig_90_o  : out std_logic;
      --    sig_180_o : out std_logic;
      --    sig_270_o : out std_logic;
      sel_i      : in     std_logic_vector (1 downto 0);
      invert_i   : in     std_logic ;
      com_i      : in     std_logic ;
      com_en     : in     std_logic ;
      rst        : in     std_logic ;
      clk        : in     std_logic 
   );
   end component;
   component OBUFDS
   generic (
      CAPACITANCE : string := "DONT_CARE";
      IOSTANDARD  : string := "DEFAULT";
      SLEW        : string := "SLOW"
   );
   port (
      I  : in     std_ulogic;
      O  : out    std_ulogic;
      OB : out    std_ulogic
   );
   end component;
   component ODDR
   generic (
      DDR_CLK_EDGE : string := "OPPOSITE_EDGE";
      INIT         : bit    := '0';
      SRTYPE       : string := "SYNC"
   );
   port (
      C  : in     std_ulogic;
      CE : in     std_ulogic;
      D1 : in     std_ulogic;
      D2 : in     std_ulogic;
      R  : in     std_ulogic;
      S  : in     std_ulogic;
      Q  : out    std_ulogic
   );
   end component;
   component m_power
   port (
      hi : out    std_logic ;
      lo : out    std_logic 
   );
   end component;


begin
   -- Architecture concurrent statements
   -- HDL Embedded Text Block 1 eb1
   -- eb1 1
   bco_en <= reg_com_enable_i(B_BCO_EN);
   -- for compat reasons bco is inverted
   bco_inv_n <= reg_com_enable_i(B_BCO_INV);
   bco_inv <= not reg_com_enable_i(B_BCO_INV);
   
   dclk_en <= reg_com_enable_i(B_DCLK_EN);
   dclk_inv <= reg_com_enable_i(B_DCLK_INV);
   --dclk_inv_n <= not(reg_com_enable_i(B_DCLK_INV));
   
   dclk_mode40 <= reg_control_i(CTL_DCLK40_MODE);

   -- HDL Embedded Text Block 2 eb2
   -- eb2 2
   dclk_ddr_d1 <= not(dclk_inv) 
               when 
                 (dclk_mode40 = '0')
               else
                  (strobe40_i xor dclk_inv) 
                      after 100 ps;
   
   dclk_ddr_d2 <= dclk_inv  
               when 
                  (dclk_mode40 = '0') 
               else
                  not (strobe40_i xor dclk_inv)
                     after 100 ps;

   -- HDL Embedded Text Block 3 eb3
   -- eb3 3
   dbg_outsigs_o(7) <= '0';
   dbg_outsigs_o(5) <= '0';
   dbg_outsigs_o(3) <= '0';
   dbg_outsigs_o(1) <= '0';


   -- Instance port mappings.
   Ufourphase0 : four_phase
      port map (
         sig_i      => outsigs_i(OS_ID0_COM),
         sig_o      => ibpp0_o(PP_COM),
         dbg_sig0_o => dbg_outsigs_o(OS_ID0_COM),
         sel_i      => reg_com_enable_i(15 DOWNTO 14),
         invert_i   => LO,
         com_i      => com_i,
         com_en     => reg_com_enable_i(B_J37_COM_EN),
         rst        => rst,
         clk        => clk
      );
   Ufourphase1 : four_phase
      port map (
         sig_i      => outsigs_i(OS_ID0_L1R),
         sig_o      => ibpp0_o(PP_L1),
         dbg_sig0_o => dbg_outsigs_o(OS_ID0_L1R),
         sel_i      => reg_com_enable_i(15 DOWNTO 14),
         invert_i   => LO,
         com_i      => com_i,
         com_en     => reg_com_enable_i(B_COM_J37_L1),
         rst        => rst,
         clk        => clk
      );
   Ufourphase2 : four_phase
      port map (
         sig_i      => outsigs_i(OS_ID0_RST),
         sig_o      => ibpp0_o(PP_RESET),
         dbg_sig0_o => dbg_outsigs_o(OS_ID0_RST),
         sel_i      => reg_com_enable_i(15 DOWNTO 14),
         invert_i   => reg_com_enable_i(B_RST_INV),
         com_i      => com_i,
         com_en     => reg_com_enable_i(B_COM_J37_RST),
         rst        => rst,
         clk        => clk
      );
   Ufourphase3 : four_phase
      port map (
         sig_i      => outsigs_i(OS_ID1_COM),
         sig_o      => ibpp1_o(PP_COM),
         dbg_sig0_o => dbg_outsigs_o(OS_ID1_COM),
         sel_i      => reg_com_enable_i(15 DOWNTO 14),
         invert_i   => LO,
         com_i      => com_i,
         com_en     => reg_com_enable_i(B_J38_COM_EN),
         rst        => rst,
         clk        => clk
      );
   Ufourphase4 : four_phase
      port map (
         sig_i      => outsigs_i(OS_ID1_L1R),
         sig_o      => ibpp1_o(PP_L1),
         dbg_sig0_o => dbg_outsigs_o(OS_ID1_L1R),
         sel_i      => reg_com_enable_i(15 DOWNTO 14),
         invert_i   => LO,
         com_i      => com_i,
         com_en     => reg_com_enable_i(B_COM_J38_L1),
         rst        => rst,
         clk        => clk
      );
   Ufourphase5 : four_phase
      port map (
         sig_i      => outsigs_i(OS_ID1_RST),
         sig_o      => ibpp1_o(PP_RESET),
         dbg_sig0_o => dbg_outsigs_o(OS_ID1_RST),
         sel_i      => reg_com_enable_i(15 DOWNTO 14),
         invert_i   => reg_com_enable_i(B_RST_INV),
         com_i      => com_i,
         com_en     => reg_com_enable_i(B_COM_J38_RST),
         rst        => rst,
         clk        => clk
      );
   Ufourphase7 : four_phase
      port map (
         sig_i      => outsigs_i(OS_STB_COM),
         sig_o      => ibstb_com_o,
         dbg_sig0_o => dbg_outsigs_o(OS_STB_COM),
         sel_i      => reg_com_enable_i(15 DOWNTO 14),
         invert_i   => LO,
         com_i      => com_i,
         com_en     => reg_com_enable_i(B_ST_COM_EN),
         rst        => rst,
         clk        => clk
      );
   Ufourphase8 : four_phase
      port map (
         sig_i      => outsigs_i(OS_STB_NOS),
         sig_o      => ibstb_noise_o,
         dbg_sig0_o => dbg_outsigs_o(OS_STB_NOS),
         sel_i      => reg_com_enable_i(15 DOWNTO 14),
         invert_i   => LO,
         com_i      => com_i,
         com_en     => reg_control_i(CTL_COM_NOISE_EN),
         rst        => rst,
         clk        => clk
      );
   Ufourphase9 : four_phase
      port map (
         sig_i      => outsigs_i(OS_STT_NOS),
         sig_o      => ibstt_noise_o,
         dbg_sig0_o => dbg_outsigs_o(OS_STT_NOS),
         sel_i      => reg_com_enable_i(15 DOWNTO 14),
         invert_i   => LO,
         com_i      => com_i,
         com_en     => reg_control_i(CTL_COM_NOISE_EN),
         rst        => rst,
         clk        => clk
      );
   Ufourphase10 : four_phase
      port map (
         sig_i      => outsigs_i(OS_STT_L1R),
         sig_o      => ibstt_l1r_o,
         dbg_sig0_o => dbg_outsigs_o(OS_STT_L1R),
         sel_i      => reg_com_enable_i(15 DOWNTO 14),
         invert_i   => LO,
         com_i      => com_i,
         com_en     => reg_com_enable_i(B_COM_ST_L1R),
         rst        => rst,
         clk        => clk
      );
   Ufourphase11 : four_phase
      port map (
         sig_i      => outsigs_i(OS_STT_COM),
         sig_o      => ibstt_com_o,
         dbg_sig0_o => dbg_outsigs_o(OS_STT_COM),
         sel_i      => reg_com_enable_i(15 DOWNTO 14),
         invert_i   => LO,
         com_i      => com_i,
         com_en     => reg_com_enable_i(B_ST_COM_EN),
         rst        => rst,
         clk        => clk
      );
   Ufourphase12 : four_phase
      port map (
         sig_i      => outsigs_i(OS_STB_L1R),
         sig_o      => ibstb_l1r_o,
         dbg_sig0_o => dbg_outsigs_o(OS_STB_L1R),
         sel_i      => reg_com_enable_i(15 DOWNTO 14),
         invert_i   => LO,
         com_i      => com_i,
         com_en     => reg_com_enable_i(B_COM_ST_L1R),
         rst        => rst,
         clk        => clk
      );
   Uob3 : OBUFDS
      generic map (
         CAPACITANCE => "DONT_CARE",
         IOSTANDARD  => "LVDS_25"
      )
      port map (
         O  => ibepp0_bc_po,
         OB => ibepp0_bc_mo,
         I  => ibpp0_out(PP_DCLK)
      );
   Uob5 : OBUFDS
      generic map (
         CAPACITANCE => "DONT_CARE",
         IOSTANDARD  => "LVDS_25"
      )
      port map (
         O  => ibepp0_clk_po,
         OB => ibepp0_clk_mo,
         I  => ibpp0_out(PP_BCO)
      );
   Uob8 : OBUFDS
      generic map (
         CAPACITANCE => "DONT_CARE",
         IOSTANDARD  => "LVDS_25"
      )
      port map (
         O  => ibepp1_clk_po,
         OB => ibepp1_clk_mo,
         I  => ibpp1_out(PP_BCO)
      );
   Uob9 : OBUFDS
      generic map (
         CAPACITANCE => "DONT_CARE",
         IOSTANDARD  => "LVDS_25"
      )
      port map (
         O  => ibepp1_bc_po,
         OB => ibepp1_bc_mo,
         I  => ibpp1_out(PP_DCLK)
      );
   Uob11 : OBUFDS
      generic map (
         CAPACITANCE => "DONT_CARE",
         IOSTANDARD  => "LVDS_25"
      )
      port map (
         O  => ibe_bcot_po,
         OB => ibe_bcot_mo,
         I  => ibstt_bco
      );
   Uob14 : OBUFDS
      generic map (
         CAPACITANCE => "DONT_CARE",
         IOSTANDARD  => "LVDS_25"
      )
      port map (
         O  => ibe_bco_po,
         OB => ibe_bco_mo,
         I  => ibstb_bco
      );
   Uoddrbcopp0 : ODDR
      generic map (
         DDR_CLK_EDGE => "SAME_EDGE",
         INIT         => '0',
         SRTYPE       => "SYNC"
      )
      port map (
         Q  => ibpp0_out(PP_BCO),
         C  => clk_bco_i,
         CE => bco_en,
         D1 => bco_inv_n,
         D2 => bco_inv,
         R  => rst,
         S  => LO
      );
   Uoddrbcopp1 : ODDR
      generic map (
         DDR_CLK_EDGE => "SAME_EDGE",
         INIT         => '0',
         SRTYPE       => "SYNC"
      )
      port map (
         Q  => ibpp1_out(PP_BCO),
         C  => clk_bco_i,
         CE => bco_en,
         D1 => bco_inv_n,
         D2 => bco_inv,
         R  => rst,
         S  => LO
      );
   Uoddrbcopp5 : ODDR
      generic map (
         DDR_CLK_EDGE => "SAME_EDGE",
         INIT         => '0',
         SRTYPE       => "SYNC"
      )
      port map (
         Q  => ibstt_bco,
         C  => clk_bco_i,
         CE => bco_en,
         D1 => bco_inv_n,
         D2 => bco_inv,
         R  => rst,
         S  => LO
      );
   Uoddrbcopp6 : ODDR
      generic map (
         DDR_CLK_EDGE => "SAME_EDGE",
         INIT         => '0',
         SRTYPE       => "SYNC"
      )
      port map (
         Q  => ibstb_bco,
         C  => clk_bco_i,
         CE => bco_en,
         D1 => bco_inv_n,
         D2 => bco_inv,
         R  => rst,
         S  => LO
      );
   Uoddrdclkpp0 : ODDR
      generic map (
         DDR_CLK_EDGE => "SAME_EDGE",
         INIT         => '0',
         SRTYPE       => "SYNC"
      )
      port map (
         Q  => ibpp0_out(PP_DCLK),
         C  => clk,
         CE => dclk_en,
         D1 => dclk_ddr_d1,
         D2 => dclk_ddr_d2,
         R  => rst,
         S  => LO
      );
   Uoddrdclkpp1 : ODDR
      generic map (
         DDR_CLK_EDGE => "SAME_EDGE",
         INIT         => '0',
         SRTYPE       => "SYNC"
      )
      port map (
         Q  => ibpp1_out(PP_DCLK),
         C  => clk,
         CE => dclk_en,
         D1 => dclk_ddr_d1,
         D2 => dclk_ddr_d2,
         R  => rst,
         S  => LO
      );
   Umpower : m_power
      port map (
         hi => open,
         lo => LO
      );

end struct;
