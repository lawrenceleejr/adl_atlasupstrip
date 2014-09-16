--------------------------------------------------------------------------------
-- Copyright (c) 1995-2013 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /    Vendor: Xilinx 
-- \   \   \/     Version : 14.7
--  \   \         Application : xaw2vhdl
--  /   /         Filename : cg_dcm_125div3.vhd
-- /___/   /\     Timestamp : 06/05/2014 13:36:18
-- \   \  /  \ 
--  \___\/\___\ 
--
--Command: xaw2vhdl-st /home/warren/slhc/trunk/hsio/coregen/./cg_dcm_125div3.xaw /home/warren/slhc/trunk/hsio/coregen/./cg_dcm_125div3
--Design Name: cg_dcm_125div3
--Device: xc4vfx60-11ff1152
--
-- Module cg_dcm_125div3
-- Generated by Xilinx Architecture Wizard
-- Written for synthesis tool: Precision

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity cg_dcm_125div3 is
   port ( CLKIN_IN          : in    std_logic; 
          RST_IN            : in    std_logic; 
          CLKDV_CLKA1D2_OUT : out   std_logic; 
          CLKDV_CLKA1D4_OUT : out   std_logic; 
          CLKDV_CLKA1_OUT   : out   std_logic; 
          CLK0_CLKB1_OUT    : out   std_logic; 
          LOCKED_OUT        : out   std_logic);
end cg_dcm_125div3;

architecture BEHAVIORAL of cg_dcm_125div3 is
   attribute CLK_FEEDBACK          : string ;
   attribute CLKDV_DIVIDE          : string ;
   attribute CLKFX_DIVIDE          : string ;
   attribute CLKFX_MULTIPLY        : string ;
   attribute CLKIN_DIVIDE_BY_2     : string ;
   attribute CLKIN_PERIOD          : string ;
   attribute CLKOUT_PHASE_SHIFT    : string ;
   attribute DCM_AUTOCALIBRATION   : string ;
   attribute DCM_PERFORMANCE_MODE  : string ;
   attribute DESKEW_ADJUST         : string ;
   attribute DFS_FREQUENCY_MODE    : string ;
   attribute DLL_FREQUENCY_MODE    : string ;
   attribute DUTY_CYCLE_CORRECTION : string ;
   attribute FACTORY_JF            : string ;
   attribute PHASE_SHIFT           : string ;
   attribute STARTUP_WAIT          : string ;
   attribute RST_DEASSERT_CLK      : string ;
   attribute EN_REL                : string ;
   signal CLKDV_CLKA        : std_logic;
   signal CLKDV_CLKA1D2_BUF : std_logic;
   signal CLKDV_CLKA1D4_BUF : std_logic;
   signal CLKDV_CLKA1_BUF   : std_logic;
   signal CLKFB_IN          : std_logic;
   signal CLK0_CLKB         : std_logic;
   signal CLK0_CLKB1_BUF    : std_logic;
   signal GND_BIT           : std_logic;
   signal GND_BUS_7         : std_logic_vector (6 downto 0);
   signal GND_BUS_16        : std_logic_vector (15 downto 0);
   component BUFG
      port ( I : in    std_logic; 
             O : out   std_logic);
   end component;
   
   -- Period Jitter (unit interval) for block DCM_ADV_INST = 0.009 UI
   -- Period Jitter (Peak-to-Peak) for block DCM_ADV_INST = 0.236 ns
   component DCM_ADV
      -- synopsys translate_off
      generic( CLK_FEEDBACK : string :=  "1X";
               CLKDV_DIVIDE : real :=  2.0;
               CLKFX_DIVIDE : integer :=  1;
               CLKFX_MULTIPLY : integer :=  4;
               CLKIN_DIVIDE_BY_2 : boolean :=  FALSE;
               CLKIN_PERIOD : real :=  10.0;
               CLKOUT_PHASE_SHIFT : string :=  "NONE";
               DCM_AUTOCALIBRATION : boolean :=  TRUE;
               DCM_PERFORMANCE_MODE : string :=  "MAX_SPEED";
               DESKEW_ADJUST : string :=  "SYSTEM_SYNCHRONOUS";
               DFS_FREQUENCY_MODE : string :=  "LOW";
               DLL_FREQUENCY_MODE : string :=  "LOW";
               DUTY_CYCLE_CORRECTION : boolean :=  TRUE;
               FACTORY_JF : bit_vector :=  x"F0F0";
               PHASE_SHIFT : integer :=  0;
               STARTUP_WAIT : boolean :=  FALSE;
               SIM_DEVICE : string :=  "VIRTEX4");
      -- synopsys translate_on
      port ( CLKIN    : in    std_logic; 
             CLKFB    : in    std_logic; 
             DADDR    : in    std_logic_vector (6 downto 0); 
             DI       : in    std_logic_vector (15 downto 0); 
             DWE      : in    std_logic; 
             DEN      : in    std_logic; 
             DCLK     : in    std_logic; 
             RST      : in    std_logic; 
             PSEN     : in    std_logic; 
             PSINCDEC : in    std_logic; 
             PSCLK    : in    std_logic; 
             CLK0     : out   std_logic; 
             CLK90    : out   std_logic; 
             CLK180   : out   std_logic; 
             CLK270   : out   std_logic; 
             CLKDV    : out   std_logic; 
             CLK2X    : out   std_logic; 
             CLK2X180 : out   std_logic; 
             CLKFX    : out   std_logic; 
             CLKFX180 : out   std_logic; 
             DRDY     : out   std_logic; 
             DO       : out   std_logic_vector (15 downto 0); 
             LOCKED   : out   std_logic; 
             PSDONE   : out   std_logic);
   end component;
   
   component PMCD
      -- synopsys translate_off
      generic( RST_DEASSERT_CLK : string :=  "CLKA";
               EN_REL : boolean :=  FALSE);
      -- synopsys translate_on
      port ( CLKA    : in    std_logic; 
             CLKB    : in    std_logic; 
             CLKC    : in    std_logic; 
             CLKD    : in    std_logic; 
             REL     : in    std_logic; 
             RST     : in    std_logic; 
             CLKA1   : out   std_logic; 
             CLKA1D2 : out   std_logic; 
             CLKA1D4 : out   std_logic; 
             CLKA1D8 : out   std_logic; 
             CLKB1   : out   std_logic; 
             CLKC1   : out   std_logic; 
             CLKD1   : out   std_logic);
   end component;
   
   attribute CLK_FEEDBACK of DCM_ADV_INST : label is "1X";
   attribute CLKDV_DIVIDE of DCM_ADV_INST : label is "1.5";
   attribute CLKFX_DIVIDE of DCM_ADV_INST : label is "10";
   attribute CLKFX_MULTIPLY of DCM_ADV_INST : label is "3";
   attribute CLKIN_DIVIDE_BY_2 of DCM_ADV_INST : label is "FALSE";
   attribute CLKIN_PERIOD of DCM_ADV_INST : label is "8.000";
   attribute CLKOUT_PHASE_SHIFT of DCM_ADV_INST : label is "NONE";
   attribute DCM_AUTOCALIBRATION of DCM_ADV_INST : label is "TRUE";
   attribute DCM_PERFORMANCE_MODE of DCM_ADV_INST : label is "MAX_SPEED";
   attribute DESKEW_ADJUST of DCM_ADV_INST : label is "SYSTEM_SYNCHRONOUS";
   attribute DFS_FREQUENCY_MODE of DCM_ADV_INST : label is "LOW";
   attribute DLL_FREQUENCY_MODE of DCM_ADV_INST : label is "LOW";
   attribute DUTY_CYCLE_CORRECTION of DCM_ADV_INST : label is "TRUE";
   attribute FACTORY_JF of DCM_ADV_INST : label is "F0F0";
   attribute PHASE_SHIFT of DCM_ADV_INST : label is "0";
   attribute STARTUP_WAIT of DCM_ADV_INST : label is "FALSE";
   attribute RST_DEASSERT_CLK of PMCD_INST : label is "CLKB";
   attribute EN_REL of PMCD_INST : label is "FALSE";
begin
   GND_BIT <= '0';
   GND_BUS_7(6 downto 0) <= "0000000";
   GND_BUS_16(15 downto 0) <= "0000000000000000";
   CLK0_CLKB1_OUT <= CLKFB_IN;
   CLKA1D2_BUFG_INST : BUFG
      port map (I=>CLKDV_CLKA1D2_BUF,
                O=>CLKDV_CLKA1D2_OUT);
   
   CLKA1D4_BUFG_INST : BUFG
      port map (I=>CLKDV_CLKA1D4_BUF,
                O=>CLKDV_CLKA1D4_OUT);
   
   CLKA1_BUFG_INST : BUFG
      port map (I=>CLKDV_CLKA1_BUF,
                O=>CLKDV_CLKA1_OUT);
   
   CLKB1_BUFG_INST : BUFG
      port map (I=>CLK0_CLKB1_BUF,
                O=>CLKFB_IN);
   
   DCM_ADV_INST : DCM_ADV
   -- synopsys translate_off
   generic map( CLK_FEEDBACK => "1X",
            CLKDV_DIVIDE => 1.5,
            CLKFX_DIVIDE => 10,
            CLKFX_MULTIPLY => 3,
            CLKIN_DIVIDE_BY_2 => FALSE,
            CLKIN_PERIOD => 8.000,
            CLKOUT_PHASE_SHIFT => "NONE",
            DCM_AUTOCALIBRATION => TRUE,
            DCM_PERFORMANCE_MODE => "MAX_SPEED",
            DESKEW_ADJUST => "SYSTEM_SYNCHRONOUS",
            DFS_FREQUENCY_MODE => "LOW",
            DLL_FREQUENCY_MODE => "LOW",
            DUTY_CYCLE_CORRECTION => TRUE,
            FACTORY_JF => x"F0F0",
            PHASE_SHIFT => 0,
            STARTUP_WAIT => FALSE)
   -- synopsys translate_on
      port map (CLKFB=>CLKFB_IN,
                CLKIN=>CLKIN_IN,
                DADDR(6 downto 0)=>GND_BUS_7(6 downto 0),
                DCLK=>GND_BIT,
                DEN=>GND_BIT,
                DI(15 downto 0)=>GND_BUS_16(15 downto 0),
                DWE=>GND_BIT,
                PSCLK=>GND_BIT,
                PSEN=>GND_BIT,
                PSINCDEC=>GND_BIT,
                RST=>RST_IN,
                CLKDV=>CLKDV_CLKA,
                CLKFX=>open,
                CLKFX180=>open,
                CLK0=>CLK0_CLKB,
                CLK2X=>open,
                CLK2X180=>open,
                CLK90=>open,
                CLK180=>open,
                CLK270=>open,
                DO=>open,
                DRDY=>open,
                LOCKED=>LOCKED_OUT,
                PSDONE=>open);
   
   PMCD_INST : PMCD
   -- synopsys translate_off
   generic map( RST_DEASSERT_CLK => "CLKB",
            EN_REL => FALSE)
   -- synopsys translate_on
      port map (CLKA=>CLKDV_CLKA,
                CLKB=>CLK0_CLKB,
                CLKC=>GND_BIT,
                CLKD=>GND_BIT,
                REL=>GND_BIT,
                RST=>RST_IN,
                CLKA1=>CLKDV_CLKA1_BUF,
                CLKA1D2=>CLKDV_CLKA1D2_BUF,
                CLKA1D4=>CLKDV_CLKA1D4_BUF,
                CLKA1D8=>open,
                CLKB1=>CLK0_CLKB1_BUF,
                CLKC1=>open,
                CLKD1=>open);
   
end BEHAVIORAL;


