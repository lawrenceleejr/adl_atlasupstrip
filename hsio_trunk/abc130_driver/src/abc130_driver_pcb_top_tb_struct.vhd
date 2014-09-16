-- VHDL Entity abc130_driver.abc130_driver_pcb_top_tb.symbol
--
-- Created by Matt Warren 2014
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2013.1 (Build 6)
--



entity abc130_driver_pcb_top_tb is
-- Declarations

end abc130_driver_pcb_top_tb ;

-- VHDL from Block Diagram 
-- Generated by Mentor Graphics HDL Designer(TM) 2013.1 (Build 6) 
--
-- abc130_driver.abc130_driver_pcb_top_tb.struct
--
-- Created by Matt Warren 2014
--

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.ALL;
library utils;
use utils.pkg_types.all;
library hsio;
use hsio.pkg_hsio_globals.all;


architecture struct of abc130_driver_pcb_top_tb is

   -- Architecture declarations

   -- Internal signal declarations
   signal ABCUP          : std_logic;
   -- HSIO EOS P2
-----------------------------------
   signal ABCUP_I        : std_logic;                        -- 22 Reg
   signal ADDR0          : std_logic;
   signal ADDR0_I        : std_logic;                        -- 13 Reg
   signal ADDR1          : std_logic;
   signal ADDR1_I        : std_logic;                        -- 14 Reg
   signal ADDR2          : std_logic;
   signal ADDR2_I        : std_logic;                        -- 15 Reg
   signal ADDR3          : std_logic;
   signal ADDR3_I        : std_logic;                        -- 16 Reg
   signal ADDR4          : std_logic;
   signal ADDR4_I        : std_logic;                        -- 17 Reg
   signal BCO_N          : std_logic;                        --
   signal BCO_P          : std_logic;                        --
   signal DRC_N          : std_logic;                        --
   signal DRC_P          : std_logic;                        --
   signal HI             : std_logic;
   signal HSIO_BCO_N     : std_logic;                        --
   -- HSIO EOS P1
-----------------------------------
   signal HSIO_BCO_P     : std_logic;                        -- 0 Seq 0
   signal HSIO_DXIN0_N   : std_logic;                        -- -
   signal HSIO_DXIN0_P   : std_logic;                        -- Sink 0
   signal HSIO_DXIN1_N   : std_logic;                        -- -
   signal HSIO_DXIN1_P   : std_logic;                        -- Sink 1
   signal HSIO_DXIN2_N   : std_logic;                        -- -
   signal HSIO_DXIN2_P   : std_logic;                        -- Sink 2
   signal HSIO_DXIN3_N   : std_logic;                        -- -
   signal HSIO_DXIN3_P   : std_logic;                        -- Sink 3
   signal HSIO_DXOUT0_N  : std_logic;                        -- -
   signal HSIO_DXOUT0_P  : std_logic;                        -- 4 Seq 4
   signal HSIO_DXOUT1_N  : std_logic;                        -- -
   signal HSIO_DXOUT1_P  : std_logic;                        -- 5 Seq 5
   signal HSIO_DXOUT2_N  : std_logic;                        --
   signal HSIO_DXOUT2_P  : std_logic;                        -- 6 Seq 6
   signal HSIO_DXOUT3_N  : std_logic;                        -- -
   signal HSIO_DXOUT3_P  : std_logic;                        -- 7 Seq 7
   signal HSIO_L0_CMD_N  : std_logic;                        -- 1 Seq 1
   signal HSIO_L0_CMD_P  : std_logic;                        --
   signal HSIO_R3_N      : std_logic;                        -- 2 Seq 2
   signal HSIO_R3_P      : std_logic;                        --
   signal HSIO_SP0_N     : std_logic;                        -- -
   signal HSIO_SP0_P     : std_logic;                        -- 3 Seq 3
   signal I2C_CLK        : std_logic;                        -- TWOWIRE
   signal I2C_DATA       : std_logic;                        -- TWOWIRE
   signal L0_CMD_N       : std_logic;                        --
   signal L0_CMD_P       : std_logic;                        --
   signal LO             : std_logic;
   signal R3_N           : std_logic;                        --
   signal R3_P           : std_logic;                        --
   signal REG_ENA_I      : std_logic;                        -- 10 Reg *
   signal REG_END_I      : std_logic;                        -- 11 Reg *
   signal REG_EN_A       : std_logic;                        --
   signal REG_EN_D       : std_logic;                        --
   signal RSTB           : std_logic;
   signal RSTB_I         : std_logic;                        -- 8 Reg
   signal SCAN_ENABLE    : std_logic;
   signal SCAN_EN_I      : std_logic;                        -- 18 Reg *
   signal SDI_BC         : std_logic;                        --SCN_I_BC
   signal SDI_BC_I       : std_logic;                        -- 19 TWOWIRE *
   signal SDI_CLK        : std_logic;                        --SCN_I_CK
   signal SDI_CLK_I      : std_logic;                        -- 21 TWOWIRE *
   signal SDO_BC_O       : std_logic;                        --SCN_O_BC
   -- HYBRID P3
-----------------------------------
   signal SHUNT_CTL_SW   : std_logic;                        -- becomes SHUNTCTL
   signal SHUNT_CTL_SW_I : std_logic;                        -- 9 Reg
   signal SPARE1         : std_logic;                        -- Unknown
   signal SPARE2         : std_logic;                        -- Unknown
   signal SPARE3         : std_logic;                        -- Unknown
   signal SPARE4         : std_logic;                        -- Unknown
   signal SPARE5         : std_logic;                        -- Unknown
   -- ASIC P4
------------------------------------
   signal TERM           : std_logic;
   signal TERM_I         : std_logic;                        -- 12 Reg
   signal abc_padID1     : std_logic_vector(4 downto 0);
   signal bco            : std_logic;
   signal bdp_n          : std_logic_vector(15 downto 8);    -- XOFF_R0_P
   signal bdp_p          : std_logic_vector(15 downto 8);    -- XOFF_R0_P
   signal capture_len    : std_logic_vector(9 downto 0);
   signal clk            : std_logic;
   signal com            : std_logic;
   signal coml0          : std_logic;
   signal datawd_l11bc   : t_datawd_l11bc;
   signal datawd_l13bc   : t_datawd_l13bc;
   signal datawd_r3      : t_datawd_r3;
   signal datawd_reg32   : slv32;
   signal drc            : std_logic;
   signal l0             : std_logic;
   signal l1             : std_logic;
   signal l1r3           : std_logic;
   -- Pkt Out
   signal packet         : std_logic_vector(63 downto 0);    --t_packet;
   signal pkt_a13        : t_pkt_a13;
   signal pkt_rdack      : std_logic;
   signal pkt_valid      : std_logic;
   signal r3s            : std_logic;
   signal rst            : std_logic;
   signal rst_ext        : std_logic;                        -- Status
   signal tmu_coml0_swap : std_logic;                        --SCN_O_CK
   signal tmu_data       : std_logic;                        -- Unknown
   signal tmu_data_slv2  : std_logic_vector(1 downto 0);     -- Unknown


   -- Component Declarations
   component abc130_driver_pcb_top
   port (
      -- HSIO EOS P1
      -----------------------------------
      HSIO_BCO_P     : in     std_logic ; -- 0 Seq 0
      HSIO_BCO_N     : in     std_logic ; --
      HSIO_L0_CMD_N  : in     std_logic ; -- 1 Seq 1
      HSIO_L0_CMD_P  : in     std_logic ; --
      HSIO_R3_N      : in     std_logic ; -- 2 Seq 2
      HSIO_R3_P      : in     std_logic ; --
      HSIO_SP0_P     : in     std_logic ; -- 3 Seq 3
      HSIO_SP0_N     : in     std_logic ; -- -
      HSIO_DXOUT0_P  : in     std_logic ; -- 4 Seq 4
      HSIO_DXOUT0_N  : in     std_logic ; -- -
      HSIO_DXIN0_P   : out    std_logic ; -- Sink 0
      HSIO_DXIN0_N   : out    std_logic ; -- -
      HSIO_DXOUT1_P  : in     std_logic ; -- 5 Seq 5
      HSIO_DXOUT1_N  : in     std_logic ; -- -
      HSIO_DXIN1_P   : out    std_logic ; -- Sink 1
      HSIO_DXIN1_N   : out    std_logic ; -- -
      HSIO_DXOUT2_P  : in     std_logic ; -- 6 Seq 6
      HSIO_DXOUT2_N  : in     std_logic ; --
      HSIO_DXIN2_P   : out    std_logic ; -- Sink 2
      HSIO_DXIN2_N   : out    std_logic ; -- -
      HSIO_DXOUT3_P  : in     std_logic ; -- 7 Seq 7
      HSIO_DXOUT3_N  : in     std_logic ; -- -
      HSIO_DXIN3_P   : out    std_logic ; -- Sink 3
      HSIO_DXIN3_N   : out    std_logic ; -- -
      -- HSIO EOS P2
      -----------------------------------
      ABCUP_I        : out    std_logic ; -- 22 Reg
      SPARE1         : out    std_logic ; -- Unknown
      SPARE2         : in     std_logic ; -- Unknown
      SPARE3         : in     std_logic ; -- Unknown
      SPARE4         : in     std_logic ; -- Unknown
      SPARE5         : in     std_logic ; -- Unknown
      I2C_CLK        : inout  std_logic ; -- TWOWIRE
      I2C_DATA       : inout  std_logic ; -- TWOWIRE
      -- HYBRID P3
      -----------------------------------
      SHUNT_CTL_SW   : out    std_logic ; -- becomes SHUNTCTL
      BDP8_P         : inout  std_logic ; -- XOFF_R0_P
      BDP8_N         : inout  std_logic ; -- XOFF_R0_N
      BDP9_P         : inout  std_logic ; -- DATA_R0_P___FCCLK_N
      BDP9_N         : inout  std_logic ; -- DATA_R0_N___FCCLK_P
      BCO_P          : out    std_logic ; --
      BCO_N          : out    std_logic ; --
      DRC_P          : out    std_logic ; --
      DRC_N          : out    std_logic ; --
      L0_CMD_P       : out    std_logic ; --
      L0_CMD_N       : out    std_logic ; --
      R3_P           : out    std_logic ; --
      R3_N           : out    std_logic ; --
      REG_EN_A       : out    std_logic ; --
      REG_EN_D       : out    std_logic ; --
      BDP10_P        : inout  std_logic ; -- DATA_1_P___DATA_L_N
      BDP10_N        : inout  std_logic ; -- DATA_1_N___DATA_L_P
      BDP11_P        : inout  std_logic ; -- XOFF_1_P___XOFF_L_P
      BDP11_N        : inout  std_logic ; -- XOFF_1_N___XOFF_L_N
      BDP12_P        : inout  std_logic ; -- XOFF_R2_P___XOFF_R_P
      BDP12_N        : inout  std_logic ; -- XOFF_R2_N___XOFF_R_N
      BDP13_P        : inout  std_logic ; -- DATA_R2_P___DATA_R_N
      BDP13_N        : inout  std_logic ; -- DATA_R2_N___DATA_R_P
      BDP14_P        : inout  std_logic ; -- DATA3_P___FC1_P
      BDP14_N        : inout  std_logic ; -- DATA3_N___FC1_N
      BDP15_P        : inout  std_logic ; -- XOFF_R3_P___FC2_P
      BDP15_N        : inout  std_logic ; -- XOFF_R3_N___FC2_N
      ABCUP          : out    std_logic ;
      ADDR0          : out    std_logic ;
      ADDR1          : out    std_logic ;
      ADDR2          : out    std_logic ;
      ADDR3          : out    std_logic ;
      ADDR4          : out    std_logic ;
      RSTB           : out    std_logic ;
      SCAN_ENABLE    : out    std_logic ;
      SDI_BC         : out    std_logic ; --SCN_I_BC
      SDI_CLK        : out    std_logic ; --SCN_I_CK
      SDO_BC         : in     std_logic ; --SCN_O_BC
      SDO_CLK        : in     std_logic ; --SCN_O_CK
      SWITCH1        : in     std_logic ;
      -- ASIC P4
      ------------------------------------
      TERM           : out    std_logic ;
      ADDR0_I        : in     std_logic ; -- 13 Reg
      ADDR1_I        : in     std_logic ; -- 14 Reg
      ADDR2_I        : in     std_logic ; -- 15 Reg
      ADDR3_I        : in     std_logic ; -- 16 Reg
      ADDR4_I        : in     std_logic ; -- 17 Reg
      REG_ENA_I      : in     std_logic ; -- 10 Reg *
      REG_END_I      : in     std_logic ; -- 11 Reg *
      RSTB_I         : in     std_logic ; -- 8 Reg
      SCAN_EN_I      : in     std_logic ; -- 18 Reg *
      SDI_BC_I       : in     std_logic ; -- 19 TWOWIRE *
      SDI_CLK_I      : in     std_logic ; -- 21 TWOWIRE *
      SDO_BC_O       : in     std_logic ; -- TWOWIRE *
      SDO_CLK_O      : in     std_logic ; -- TWOWIRE *
      SHUNT_CTL_SW_I : in     std_logic ; -- 9 Reg
      SW1_O          : in     std_logic ; -- Status
      TERM_I         : in     std_logic   -- 12 Reg
   );
   end component;
   component abc130_driver_pcb_top_tester
   port (
      addr_i         : in     std_logic_vector (4 downto 0);
      bco_i          : in     std_logic;
      coml0_i        : in     std_logic;
      drc_i          : in     std_logic;
      l1r3_i         : in     std_logic;
      rst_i          : in     std_logic;
      ABCUP_I        : out    std_logic;
      ADDR0_I        : out    std_logic;
      ADDR1_I        : out    std_logic;
      ADDR2_I        : out    std_logic;
      ADDR3_I        : out    std_logic;
      ADDR4_I        : out    std_logic;
      HSIO_BCO_N     : out    std_logic;
      HSIO_BCO_P     : out    std_logic;
      HSIO_DXOUT0_N  : out    std_logic;
      HSIO_DXOUT0_P  : out    std_logic;
      HSIO_DXOUT1_N  : out    std_logic;
      HSIO_DXOUT1_P  : out    std_logic;
      HSIO_DXOUT2_N  : out    std_logic;
      HSIO_DXOUT2_P  : out    std_logic;
      HSIO_DXOUT3_N  : out    std_logic;
      HSIO_DXOUT3_P  : out    std_logic;
      HSIO_L0_CMD_N  : out    std_logic;
      HSIO_L0_CMD_P  : out    std_logic;
      HSIO_R3_N      : out    std_logic;
      HSIO_R3_P      : out    std_logic;
      HSIO_SP0_N     : out    std_logic;
      HSIO_SP0_P     : out    std_logic;
      I2C_CLK        : out    std_logic;
      I2C_DATA       : out    std_logic;
      REG_ENA_I      : out    std_logic;
      REG_END_I      : out    std_logic;
      RSTB_I         : out    std_logic;
      SCAN_EN_I      : out    std_logic;
      SDI_BC_I       : out    std_logic;
      SDI_CLK_I      : out    std_logic;
      SDO_BC_O       : out    std_logic;
      SDO_CLK_O      : out    std_logic;
      SHUNT_CTL_SW_I : out    std_logic;
      SPARE1         : out    std_logic;
      SPARE2         : out    std_logic;
      SPARE3         : out    std_logic;
      SPARE4         : out    std_logic;
      SPARE5         : out    std_logic;
      SW1_O          : out    std_logic;
      TERM_I         : out    std_logic
   );
   end component;
   component abc130_top_tester
   port (
      clk80_o          : out    std_logic ;
      com_o            : out    std_logic ;
      l0_o             : out    std_logic ;
      l1_o             : out    std_logic ;
      r3s_o            : out    std_logic ;
      abc_powerUpRstb  : out    std_logic ;
      abc_RST          : out    std_logic ;
      abc_RSTB         : out    std_logic ;
      abc_BC           : out    std_logic ;
      abc_CLK          : out    std_logic ;
      abc_DIN          : out    std_logic_vector (255 downto 0);
      abc_FastCLK      : out    std_logic ;
      abc_FastCLK_div2 : out    std_logic ;
      abc_DATL         : out    std_logic ;
      abc_padID1       : out    std_logic_vector (4 downto 0);
      abc_padID2       : out    std_logic_vector (4 downto 0);
      abc_padID3       : out    std_logic_vector (4 downto 0);
      abc_padID4       : out    std_logic_vector (4 downto 0);
      abc_padID5       : out    std_logic_vector (4 downto 0);
      abc_padTerm      : out    std_logic 
   );
   end component;
   component packet_decode
   generic (
      PKT_TYPE : integer := 0      -- unused
   );
   port (
      clk            : in     std_logic;
      packet_i       : in     slv64;
      pkt_valid_i    : in     std_logic;
      rst            : in     std_logic;
      datawd_l11bc_o : out    t_datawd_l11bc;
      datawd_l13bc_o : out    t_datawd_l13bc;
      datawd_r3_o    : out    t_datawd_r3;
      datawd_reg32_o : out    slv32;
      pkt_a13_o      : out    t_pkt_a13;
      pkt_rdack_o    : out    std_logic
   );
   end component;
   component ro13_deser
   generic (
      LINK_ID : integer := 0
   );
   port (
      -- In
      ser_i           : in     slv2 ;
      -- Pkt Out
      packet_o        : out    std_logic_vector (63 downto 0); --t_packet;
      pkt_valid_o     : out    std_logic ;
      pkt_rdack_i     : in     std_logic ;
      --
      dropped_pkts_o  : out    std_logic_vector (7 downto 0);
      capture_mode_i  : in     std_logic ;
      capture_start_i : in     std_logic ;
      capture_len_i   : in     std_logic_vector (9 downto 0);
      -- infra
      mode80_i        : in     std_logic ;
      mode_abc_i      : in     std_logic ;
      en              : in     std_logic ;
      clk             : in     std_logic ;
      rst             : in     std_logic 
   );
   end component;


begin
   -- Architecture concurrent statements
   -- HDL Embedded Text Block 1 eb1
   -- eb1 1
   capture_len <= "0010000000";
   tmu_data_slv2 <= '0' & tmu_data;

   -- HDL Embedded Text Block 2 eb2
   HI <= '1';
   LO <= '0';

   -- HDL Embedded Text Block 3 eb3
   -- eb3 3
   bdp_p <= (others => 'Z');
   bdp_n <= (others => 'Z');


   -- ModuleWare code(v1.12) for instance 'U_0' of 'mux'
   prcu_0combo: process(l1, r3s, bco)
   begin
      case bco is
      when '0'|'L' => l1r3 <= l1;
      when '1'|'H' => l1r3 <= r3s;
      when others => l1r3 <= 'X';
      end case;
   end process prcu_0combo;

   -- ModuleWare code(v1.12) for instance 'U_1' of 'mux'
   prcu_1combo: process(com, l0, bco)
   begin
      case bco is
      when '0'|'L' => coml0 <= com;
      when '1'|'H' => coml0 <= l0;
      when others => coml0 <= 'X';
      end case;
   end process prcu_1combo;

   -- Instance port mappings.
   Udut : abc130_driver_pcb_top
      port map (
         HSIO_BCO_P     => HSIO_R3_P,
         HSIO_BCO_N     => HSIO_R3_N,
         HSIO_L0_CMD_N  => HSIO_L0_CMD_N,
         HSIO_L0_CMD_P  => HSIO_L0_CMD_P,
         HSIO_R3_N      => HSIO_BCO_N,
         HSIO_R3_P      => HSIO_BCO_P,
         HSIO_SP0_P     => HSIO_SP0_P,
         HSIO_SP0_N     => HSIO_SP0_N,
         HSIO_DXOUT0_P  => HSIO_DXOUT0_P,
         HSIO_DXOUT0_N  => HSIO_DXOUT0_N,
         HSIO_DXIN0_P   => HSIO_DXIN0_P,
         HSIO_DXIN0_N   => HSIO_DXIN0_N,
         HSIO_DXOUT1_P  => HSIO_DXOUT1_P,
         HSIO_DXOUT1_N  => HSIO_DXOUT1_N,
         HSIO_DXIN1_P   => HSIO_DXIN1_P,
         HSIO_DXIN1_N   => HSIO_DXIN1_N,
         HSIO_DXOUT2_P  => HSIO_DXOUT2_P,
         HSIO_DXOUT2_N  => HSIO_DXOUT2_N,
         HSIO_DXIN2_P   => HSIO_DXIN2_P,
         HSIO_DXIN2_N   => HSIO_DXIN2_N,
         HSIO_DXOUT3_P  => HSIO_DXOUT3_P,
         HSIO_DXOUT3_N  => HSIO_DXOUT3_N,
         HSIO_DXIN3_P   => HSIO_DXIN3_P,
         HSIO_DXIN3_N   => HSIO_DXIN3_N,
         RSTB_I         => RSTB_I,
         SHUNT_CTL_SW_I => SHUNT_CTL_SW_I,
         REG_ENA_I      => REG_ENA_I,
         REG_END_I      => REG_END_I,
         TERM_I         => TERM_I,
         ADDR0_I        => ADDR0_I,
         ADDR1_I        => ADDR1_I,
         ADDR2_I        => ADDR2_I,
         ADDR3_I        => ADDR3_I,
         ADDR4_I        => ADDR4_I,
         SCAN_EN_I      => SCAN_EN_I,
         SDI_BC_I       => SDI_BC_I,
         SDO_BC_O       => SDO_BC_O,
         SDI_CLK_I      => SDI_CLK_I,
         SDO_CLK_O      => tmu_coml0_swap,
         SW1_O          => rst_ext,
         ABCUP_I        => open,
         SPARE1         => tmu_data,
         SPARE2         => SPARE2,
         SPARE3         => SPARE3,
         SPARE4         => SPARE4,
         SPARE5         => SPARE5,
         I2C_CLK        => I2C_CLK,
         I2C_DATA       => I2C_DATA,
         SHUNT_CTL_SW   => SHUNT_CTL_SW,
         BDP8_P         => bdp_p(8),
         BDP8_N         => bdp_n(8),
         BDP9_P         => bdp_p(9),
         BDP9_N         => bdp_n(9),
         BCO_P          => BCO_P,
         BCO_N          => BCO_N,
         DRC_P          => DRC_P,
         DRC_N          => DRC_N,
         L0_CMD_P       => L0_CMD_P,
         L0_CMD_N       => L0_CMD_N,
         R3_P           => R3_P,
         R3_N           => R3_N,
         REG_EN_A       => REG_EN_A,
         REG_EN_D       => REG_EN_D,
         BDP10_P        => bdp_p(10),
         BDP10_N        => bdp_n(10),
         BDP11_P        => bdp_p(11),
         BDP11_N        => bdp_n(11),
         BDP12_P        => bdp_p(12),
         BDP12_N        => bdp_n(12),
         BDP13_P        => bdp_p(13),
         BDP13_N        => bdp_n(13),
         BDP14_P        => bdp_p(14),
         BDP14_N        => bdp_n(14),
         BDP15_P        => bdp_p(15),
         BDP15_N        => bdp_n(15),
         ABCUP          => ABCUP,
         ADDR0          => ADDR0,
         ADDR1          => ADDR1,
         ADDR2          => ADDR2,
         ADDR3          => ADDR3,
         ADDR4          => ADDR4,
         RSTB           => RSTB,
         SCAN_ENABLE    => SCAN_ENABLE,
         SDI_BC         => SDI_BC,
         SDI_CLK        => SDI_CLK,
         SDO_BC         => SDI_BC,
         SDO_CLK        => SDI_CLK,
         SWITCH1        => LO,
         TERM           => TERM
      );
   Utst : abc130_driver_pcb_top_tester
      port map (
         rst_i          => rst,
         bco_i          => bco,
         drc_i          => drc,
         coml0_i        => coml0,
         l1r3_i         => l1r3,
         addr_i         => abc_padID1,
         SHUNT_CTL_SW_I => SHUNT_CTL_SW_I,
         REG_ENA_I      => REG_ENA_I,
         ABCUP_I        => open,
         ADDR0_I        => ADDR0_I,
         ADDR1_I        => ADDR1_I,
         ADDR2_I        => ADDR2_I,
         ADDR3_I        => ADDR3_I,
         ADDR4_I        => ADDR4_I,
         HSIO_BCO_N     => HSIO_BCO_N,
         HSIO_BCO_P     => HSIO_BCO_P,
         HSIO_DXOUT0_N  => HSIO_DXOUT0_N,
         HSIO_DXOUT0_P  => HSIO_DXOUT0_P,
         HSIO_DXOUT1_N  => HSIO_DXOUT1_N,
         HSIO_DXOUT1_P  => HSIO_DXOUT1_P,
         HSIO_DXOUT2_N  => HSIO_DXOUT2_N,
         HSIO_DXOUT2_P  => HSIO_DXOUT2_P,
         HSIO_DXOUT3_N  => HSIO_DXOUT3_N,
         HSIO_DXOUT3_P  => HSIO_DXOUT3_P,
         HSIO_L0_CMD_N  => HSIO_L0_CMD_N,
         HSIO_L0_CMD_P  => HSIO_L0_CMD_P,
         HSIO_R3_N      => HSIO_R3_N,
         HSIO_R3_P      => HSIO_R3_P,
         HSIO_SP0_N     => HSIO_SP0_N,
         HSIO_SP0_P     => HSIO_SP0_P,
         I2C_CLK        => I2C_CLK,
         I2C_DATA       => I2C_DATA,
         REG_END_I      => REG_END_I,
         RSTB_I         => RSTB_I,
         SCAN_EN_I      => SCAN_EN_I,
         SDI_BC_I       => SDI_BC_I,
         SDI_CLK_I      => SDI_CLK_I,
         SDO_BC_O       => SDO_BC_O,
         SDO_CLK_O      => tmu_coml0_swap,
         SW1_O          => rst_ext,
         SPARE1         => open,
         SPARE2         => SPARE2,
         SPARE3         => SPARE3,
         SPARE4         => SPARE4,
         SPARE5         => SPARE5,
         TERM_I         => TERM_I
      );
   Utst1 : abc130_top_tester
      port map (
         clk80_o          => clk,
         com_o            => com,
         l0_o             => l0,
         l1_o             => l1,
         r3s_o            => r3s,
         abc_powerUpRstb  => open,
         abc_RST          => rst,
         abc_RSTB         => open,
         abc_BC           => bco,
         abc_CLK          => drc,
         abc_DIN          => open,
         abc_FastCLK      => open,
         abc_FastCLK_div2 => open,
         abc_DATL         => open,
         abc_padID1       => abc_padID1,
         abc_padID2       => open,
         abc_padID3       => open,
         abc_padID4       => open,
         abc_padID5       => open,
         abc_padTerm      => open
      );
   Updec : packet_decode
      generic map (
         PKT_TYPE => 0         -- unused
      )
      port map (
         packet_i       => packet,
         pkt_valid_i    => pkt_valid,
         pkt_rdack_o    => pkt_rdack,
         pkt_a13_o      => pkt_a13,
         datawd_l11bc_o => datawd_l11bc,
         datawd_l13bc_o => datawd_l13bc,
         datawd_r3_o    => datawd_r3,
         datawd_reg32_o => datawd_reg32,
         clk            => clk,
         rst            => rst
      );
   Uro13deser : ro13_deser
      generic map (
         LINK_ID => 0
      )
      port map (
         ser_i           => tmu_data_slv2,
         packet_o        => packet,
         pkt_valid_o     => pkt_valid,
         pkt_rdack_i     => pkt_rdack,
         dropped_pkts_o  => open,
         capture_mode_i  => LO,
         capture_start_i => LO,
         capture_len_i   => capture_len,
         mode80_i        => HI,
         mode_abc_i      => HI,
         en              => HI,
         clk             => clk,
         rst             => rst
      );

end struct;
