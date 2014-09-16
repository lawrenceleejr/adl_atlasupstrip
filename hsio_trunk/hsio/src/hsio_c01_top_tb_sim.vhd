-- VHDL Entity hsio.hsio_c01_top_tb.symbol
--
-- Created:
--          by - warren.warren (mbb)
--          at - 14:37:53 03/18/11
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2010.2a (Build 7)
--


ENTITY hsio_c01_top_tb IS
-- Declarations

END hsio_c01_top_tb ;

--
-- VHDL Architecture hsio.hsio_c01_top_tb.sim
--
-- Created:
--          by - warren.warren (mbb)
--          at - 14:37:54 03/18/11
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2010.2a (Build 7)
--
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.ALL;


ARCHITECTURE sim OF hsio_c01_top_tb IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL clk40                 : std_logic;
   SIGNAL clk_diff_156_m        : std_logic;
   SIGNAL clk_diff_156_p        : std_logic;
   SIGNAL clk_mgt0_125_m        : std_logic;                        --MGTCLK0A_M
   SIGNAL clk_mgt0_125_p        : std_logic;                        --MGTCLK0A_M
   SIGNAL clk_mgt0_250_m        : std_logic;
   SIGNAL clk_mgt0_250_p        : std_logic;
   SIGNAL clk_mgt1a_mi          : std_logic;                        --MGTCLK0A_M
   SIGNAL clk_mgt1a_pi          : std_logic;                        --MGTCLK0A_M
   -- CLOCKS
   SIGNAL clk_xtal_125_m        : std_logic;                        --CRYSTAL_CLK_M
   SIGNAL clk_xtal_125_p        : std_logic;                        --CRYSTAL_CLK_P
   -- ETHERNET INTERFACE
   SIGNAL eth_col_i             : std_logic;                        --ETH_COL
   SIGNAL eth_crs_i             : std_logic;                        --ETH_CRS
   SIGNAL eth_int_ni            : std_logic;                        --ETH_INT_N
   SIGNAL eth_md_io             : std_logic;                        --ETH_MDIO
   SIGNAL eth_rx_clk_rxc_i      : std_logic;                        --ETH_RX_CLK
   SIGNAL eth_rx_dv_ctl_i       : std_logic;                        --ETH_RX_DV
   SIGNAL eth_rx_er_i           : std_logic;                        --ETH_RX_ER
   SIGNAL eth_rxd_i             : std_logic_vector(7 DOWNTO 0);     --ETH_RXD_7
   SIGNAL eth_tx_clk_i          : std_logic;                        --ETH_TX_CLK
   SIGNAL hi                    : std_logic;                        -- ID0_1B (J33.12) ID0_1B_BUF (J26.B4)
   SIGNAL ibe_dot_mi            : std_logic_vector(23 DOWNTO 0);    -- ID0_1 (J33.11) ID0_1_BUF (J26.A4)
   SIGNAL ibe_dot_pi            : std_logic_vector(23 DOWNTO 0);    -- ID0_1 (J33.11) ID0_1_BUF (J26.A4)
   -- CLOCKS
   SIGNAL ibe_osc0_mi           : std_logic;                        --CRYSTAL_CLK_M
   SIGNAL ibe_osc0_pi           : std_logic;                        --CRYSTAL_CLK_P
   SIGNAL ibfi_moddef1          : std_logic_vector(1 DOWNTO 0);     --GPIO_18  IB09 net: IB09 Net: CD_FO_SCLK1 (SCL)
   SIGNAL ibfi_moddef2          : std_logic_vector(1 DOWNTO 0);     --GPIO_19  IB09 net: IB09 Net: CD_FO_SDAT1 (SDA)
   SIGNAL ibpp_ido0_mi          : std_logic;                        -- ID0_0B (J32.14/J33.10) ID0_0B_BUF (J26.H3)
   SIGNAL ibpp_ido0_pi          : std_logic;                        -- ID0_0 (J32.13/J33.9) ID0_0_BUF (J26.G3)
   -- IDC CONNECTORS (P2-5)
   SIGNAL idc_p2_io             : std_logic_vector(31 DOWNTO 0);    --IDC_P2
   SIGNAL idc_p3_io             : std_logic_vector(31 DOWNTO 0);    --IDC_P3
   SIGNAL idc_p4_io             : std_logic_vector(31 DOWNTO 0);    --IDC_P4
   SIGNAL idc_p5_io             : std_logic_vector(31 DOWNTO 0);    --IDC_P5
   SIGNAL lo                    : std_logic;                        -- ID0_1 (J33.11) ID0_1_BUF (J26.A4)
   SIGNAL monitor_finished_100m : boolean;
   SIGNAL monitor_finished_10m  : boolean;
   SIGNAL monitor_finished_1g   : boolean;
   SIGNAL rst                   : std_logic;
   SIGNAL rst_poweron_n         : std_logic;                        --PORESET_N
   -- ZONE3 (ATCA) CONNECTOR
   SIGNAL sf_los_i              : std_logic_vector(1 DOWNTO 0);     --GPIO_13  IB09 net: IB09 Net: CE1_FO_TX_DIS1 (TX_DISABLE)
   -- ZONE3 (ATCA) CONNECTOR
   SIGNAL sf_mod_abs_i          : std_logic_vector(1 DOWNTO 0);     --GPIO_13  IB09 net: IB09 Net: CE1_FO_TX_DIS1 (TX_DISABLE)
   SIGNAL sf_rxm                : std_logic_vector(3 DOWNTO 0);     --LANE_7_RX_M  IB09 net: IB09 Net: CE1_LANE6_RX_M (RD-)
   SIGNAL sf_rxp                : std_logic_vector(3 DOWNTO 0);     --LANE_7_RX_P  IB09 net: IB09 Net: CE1_LANE6_RX_P (RD+)
   -- ZONE3 (ATCA) CONNECTOR
   SIGNAL sf_tx_fault_i         : std_logic_vector(1 DOWNTO 0);     --GPIO_13  IB09 net: IB09 Net: CE1_FO_TX_DIS1 (TX_DISABLE)
   SIGNAL sf_txm                : std_logic_vector(3 DOWNTO 0);     --LANE_7_TX_M  IB09 net: IB09 Net: CE1_LANE6_TX_M (TD-)
   SIGNAL sf_txp                : std_logic_vector(3 DOWNTO 0);     --LANE_7_TX_M  IB09 net: IB09 Net: CE1_LANE6_TX_M (TD-)
   SIGNAL sim_conf_busy         : boolean;
   SIGNAL sw_hex_n              : std_logic_vector(3 DOWNTO 0);
   -- USB INTERFACE
   SIGNAL usb_d_io              : std_logic_vector(7 DOWNTO 0);     --USB_D7
   SIGNAL usb_rd_o              : std_logic;                        --USB_RD_N
   SIGNAL usb_rxf_i             : std_logic;                        --USB_RXF_N
   SIGNAL usb_txe_i             : std_logic;                        --USB_TXE_N
   SIGNAL usb_wr_o              : std_logic;                        --USB_WR


   -- Component Declarations
   COMPONENT emac0_phy_tb_hsio
   PORT (
      clk125m               : IN     std_logic ;
      ------------------------------------------------------------------
      -- Gigabit Transceiver Interface
      ------------------------------------------------------------------
      txp                   : IN     std_logic ;
      txn                   : IN     std_logic ;
      rxp                   : OUT    std_logic ;
      rxn                   : OUT    std_logic ;
      ------------------------------------------------------------------
      -- Test Bench Semaphores
      ------------------------------------------------------------------
      configuration_busy    : IN     boolean ;
      monitor_finished_1g   : OUT    boolean ;
      monitor_finished_100m : OUT    boolean ;
      monitor_finished_10m  : OUT    boolean 
   );
   END COMPONENT;
   COMPONENT hsio_c01_eos_top
   GENERIC (
      SIM_MODE : integer := 0
   );
   PORT (
      -- CLOCKS
      clk_xtal_125_mi   : IN     std_logic ;                     --CRYSTAL_CLK_M
      clk_xtal_125_pi   : IN     std_logic ;                     --CRYSTAL_CLK_P
      -- ETHERNET INTERFACE
      eth_col_i         : IN     std_logic ;                     --ETH_COL
      eth_coma_o        : OUT    std_logic ;                     --ETH_COMA
      eth_crs_i         : IN     std_logic ;                     --ETH_CRS
      eth_gtxclk_txc_o  : OUT    std_logic ;                     --ETH_GTX_CLK
      eth_int_ni        : IN     std_logic ;                     --ETH_INT_N
      eth_mdc_o         : OUT    std_logic ;                     --ETH_MDC
      eth_md_io         : INOUT  std_logic ;                     --ETH_MDIO
      eth_reset_no      : OUT    std_logic ;                     --ETH_RESET_N
      eth_rx_clk_rxc_i  : IN     std_logic ;                     --ETH_RX_CLK
      eth_rx_dv_ctl_i   : IN     std_logic ;                     --ETH_RX_DV
      eth_rx_er_i       : IN     std_logic ;                     --ETH_RX_ER
      eth_rxd_i         : IN     std_logic_vector (7 DOWNTO 0);  --ETH_RXD_7
      eth_tx_clk_o      : OUT    std_logic ;                     --ETH_TX_CLK
      eth_tx_en_ctl_o   : OUT    std_logic ;                     --ETH_TX_EN
      eth_tx_er_o       : OUT    std_logic ;                     --ETH_TX_ER
      eth_txd_o         : OUT    std_logic_vector (7 DOWNTO 0);  --ETH_TXD_7
      rst_poweron_ni    : IN     std_logic ;                     --PORESET_N
      -- USB INTERFACE
      usb_d_io          : INOUT  std_logic_vector (7 DOWNTO 0);  --USB_D7
      usb_rd_o          : OUT    std_logic ;                     --USB_RD_N
      usb_rxf_i         : IN     std_logic ;                     --USB_RXF_N
      usb_txe_i         : IN     std_logic ;                     --USB_TXE_N
      usb_wr_o          : OUT    std_logic ;                     --USB_WR
      sf_scl_o          : OUT    std_logic_vector (3 DOWNTO 0);  --GPIO_18  IB09 net: IB09 Net: CD_FO_SCLK1 (SCL)
      sf_sda_io         : INOUT  std_logic_vector (3 DOWNTO 0);  --GPIO_19  IB09 net: IB09 Net: CD_FO_SDAT1 (SDA)
      sf_rxm            : IN     std_logic_vector (3 DOWNTO 0);  --LANE_7_RX_M  IB09 net: IB09 Net: CE1_LANE6_RX_M (RD-)
      sf_rxp            : IN     std_logic_vector (3 DOWNTO 0);  --LANE_7_RX_P  IB09 net: IB09 Net: CE1_LANE6_RX_P (RD+)
      -- ZONE3 (ATCA) CONNECTOR
      sf_tx_dis_o       : OUT    std_logic_vector (3 DOWNTO 0);  --GPIO_13  IB09 net: IB09 Net: CE1_FO_TX_DIS1 (TX_DISABLE)
      sf_txm            : OUT    std_logic_vector (3 DOWNTO 0);  --LANE_7_TX_M  IB09 net: IB09 Net: CE1_LANE6_TX_M (TD-)
      sf_txp            : OUT    std_logic_vector (3 DOWNTO 0);  --LANE_7_TX_M  IB09 net: IB09 Net: CE1_LANE6_TX_M (TD-)
      eth_tx_clk_i      : IN     std_logic ;                     --ETH_TX_CLK
      sw_hex_ni         : IN     std_logic_vector (3 DOWNTO 0);
      idc_p5_io         : INOUT  std_logic_vector (31 DOWNTO 0); --IDC_P5
      ibepp1_data1_mi   : IN     std_logic ;                     -- ID0_1B (J33.12) ID0_1B_BUF (J26.B4)
      ibepp1_bc_po      : OUT    std_logic ;                     -- CLK (J33.3) CLKL (J26.C4)
      ibepp1_bc_mo      : OUT    std_logic ;                     -- CLKB (J33.4) CLKLB (J26.D4)
      ibepp1_clk_po     : OUT    std_logic ;                     -- BC (J32.3/J33.7) SW_CLK (J26.E4)
      ibepp1_clk_mo     : OUT    std_logic ;                     -- BCB (J32.4/J33.8) SW_CLKB (J26.F4)
      ibepp1_hrst_mo    : OUT    std_logic ;                     -- HARDRESETB (J32.6/J33.14) HRSTB (J26.B3)
      ibepp1_hrst_po    : OUT    std_logic ;                     -- HARDRESET (J32.5/J33.13) HRST (J26.A3)
      ibepp1_com_po     : OUT    std_logic ;                     -- COMMAND (J32.5/J33.1) COM_IN (J26.C3)
      ibepp1_com_mo     : OUT    std_logic ;                     -- COMMANB (J32.6/J33.2) COM_INB (J26.D3)
      ibepp1_lone_mo    : OUT    std_logic ;                     -- LONEB (J32.10/J33.6) LONE_INB (J26.F3)
      ibepp1_lone_po    : OUT    std_logic ;                     -- LONE (J32.9/J33.5) LONE_IN (J26.E3)
      ibepp1_data0_pi   : IN     std_logic ;                     -- ID0_0 (J32.13/J33.9) ID0_0_BUF (J26.G3)
      ibepp1_data0_mi   : IN     std_logic ;                     -- ID0_0B (J32.14/J33.10) ID0_0B_BUF (J26.H3)
      ibepp1_data1_pi   : IN     std_logic ;                     -- ID0_1 (J33.11) ID0_1_BUF (J26.A4)
      ibemon_sclt_o     : OUT    std_logic_vector (2 DOWNTO 0);
      ibemon_sdat_io    : INOUT  std_logic_vector (2 DOWNTO 0);
      ibemon_convstt_no : OUT    std_logic_vector (2 DOWNTO 0);
      ibe_bcot_po       : OUT    std_logic ;                     -- HARDRESET (J32.5/J33.13) HRST (J26.A3)
      ibe_l1rt_po       : OUT    std_logic ;                     -- LONE (J32.9/J33.5) LONE_IN (J26.E3)
      ibe_dot_mi        : IN     std_logic_vector (23 DOWNTO 0); -- ID0_1 (J33.11) ID0_1_BUF (J26.A4)
      ibe_cmdt_mo       : OUT    std_logic ;                     -- COMMANB (J32.6/J33.2) COM_INB (J26.D3)
      ibe_l1rt_mo       : OUT    std_logic ;                     -- LONEB (J32.10/J33.6) LONE_INB (J26.F3)
      ibe_dot_pi        : IN     std_logic_vector (23 DOWNTO 0); -- ID0_1 (J33.11) ID0_1_BUF (J26.A4)
      ibe_cmdt_po       : OUT    std_logic ;                     -- COMMAND (J32.5/J33.1) COM_IN (J26.C3)
      ibe_bcot_mo       : OUT    std_logic ;                     -- HARDRESETB (J32.6/J33.14) HRSTB (J26.B3)
      -- DISPLAY
      disp_clk_o        : OUT    std_logic ;                     --DISP_CLK
      disp_dat_o        : OUT    std_logic ;                     --DISP_DAT
      disp_load_no      : OUT    std_logic_vector (1 DOWNTO 0);  --DISP_LOAD1_N
      disp_rst_no       : OUT    std_logic ;                     --DISP_RST_N
      ibepp0_bc_po      : OUT    std_logic ;                     -- CLK (J33.3) CLKL (J26.C4)
      ibepp0_bc_mo      : OUT    std_logic ;                     -- CLKB (J33.4) CLKLB (J26.D4)
      ibepp0_clk_po     : OUT    std_logic ;                     -- CLK (J33.3) CLKL (J26.C4)
      ibepp0_clk_mo     : OUT    std_logic ;                     -- CLKB (J33.4) CLKLB (J26.D4)
      sma_io            : INOUT  std_logic_vector (8 DOWNTO 1);  --IDC_P5
      led_status_o      : OUT    std_logic ;                     --LED_FPGA_STATUS
      ibepp0_hrst_mo    : OUT    std_logic ;                     -- HARDRESETB (J32.6/J33.14) HRSTB (J26.B3)
      ibepp0_hrst_po    : OUT    std_logic ;                     -- HARDRESET (J32.5/J33.13) HRST (J26.A3)
      ibepp0_com_po     : OUT    std_logic ;                     -- COMMAND (J32.5/J33.1) COM_IN (J26.C3)
      ibepp0_com_mo     : OUT    std_logic ;                     -- COMMANB (J32.6/J33.2) COM_INB (J26.D3)
      ibepp0_lone_mo    : OUT    std_logic ;                     -- LONEB (J32.10/J33.6) LONE_INB (J26.F3)
      ibepp0_lone_po    : OUT    std_logic ;                     -- LONE (J32.9/J33.5) LONE_IN (J26.E3)
      ibepp0_data0_pi   : IN     std_logic ;                     -- ID0_0 (J32.13/J33.9) ID0_0_BUF (J26.G3)
      ibepp0_data0_mi   : IN     std_logic ;                     -- ID0_0B (J32.14/J33.10) ID0_0B_BUF (J26.H3)
      ibepp0_data1_pi   : IN     std_logic ;                     -- ID0_1 (J33.11) ID0_1_BUF (J26.A4)
      ibepp0_data1_mi   : IN     std_logic ;                     -- ID0_1B (J33.12) ID0_1B_BUF (J26.B4)
      -- IDC CONNECTORS (P2-5)
      idc_p2_io         : INOUT  std_logic_vector (31 DOWNTO 0); --IDC_P2
      idc_p3_io         : INOUT  std_logic_vector (31 DOWNTO 0); --IDC_P3
      idc_p4_io         : INOUT  std_logic_vector (31 DOWNTO 0); --IDC_P4
      clk_mgt0a_mi      : IN     std_logic ;                     --MGTCLK0A_M
      clk_mgt0a_pi      : IN     std_logic ;                     --MGTCLK0A_M
      clk_mgt1a_mi      : IN     std_logic ;                     --MGTCLK0A_M
      clk_mgt1a_pi      : IN     std_logic ;                     --MGTCLK0A_M
      ibe_noiset_mo     : OUT    std_logic ;                     -- COMMANB (J32.6/J33.2) COM_INB (J26.D3)
      ibe_noiset_po     : OUT    std_logic ;                     -- COMMAND (J32.5/J33.1) COM_IN (J26.C3)
      ibe_osc0_pi       : IN     std_logic ;                     --CRYSTAL_CLK_P
      -- CLOCKS
      ibe_osc0_mi       : IN     std_logic ;                     --CRYSTAL_CLK_M
      clk_mgt0b_mi      : IN     std_logic ;                     --MGTCLK0A_M
      clk_mgt0b_pi      : IN     std_logic ;                     --MGTCLK0A_M
      clk_mgt1b_pi      : IN     std_logic ;                     --MGTCLK0A_M
      clk_mgt1b_mi      : IN     std_logic ;                     --MGTCLK0A_M
      -- ZONE3 (ATCA) CONNECTOR
      sf_los_i          : IN     std_logic_vector (1 DOWNTO 0);  --GPIO_13  IB09 net: IB09 Net: CE1_FO_TX_DIS1 (TX_DISABLE)
      -- ZONE3 (ATCA) CONNECTOR
      sf_rx_ratesel_o   : OUT    std_logic_vector (1 DOWNTO 0);  --GPIO_13  IB09 net: IB09 Net: CE1_FO_TX_DIS1 (TX_DISABLE)
      -- ZONE3 (ATCA) CONNECTOR
      sf_mod_abs_i      : IN     std_logic_vector (1 DOWNTO 0);  --GPIO_13  IB09 net: IB09 Net: CE1_FO_TX_DIS1 (TX_DISABLE)
      -- ZONE3 (ATCA) CONNECTOR
      sf_tx_fault_i     : IN     std_logic_vector (1 DOWNTO 0);  --GPIO_13  IB09 net: IB09 Net: CE1_FO_TX_DIS1 (TX_DISABLE)
      -- ZONE3 (ATCA) CONNECTOR
      sf_tx_ratesel_o   : OUT    std_logic_vector (1 DOWNTO 0)   --GPIO_13  IB09 net: IB09 Net: CE1_FO_TX_DIS1 (TX_DISABLE)
   );
   END COMPONENT;
   COMPONENT hsio_top_tester
   PORT (
      rst_poweron_n  : OUT    std_logic ;
      rst            : OUT    std_logic ;
      clk40          : OUT    std_logic ;
      clk25          : OUT    std_logic ;
      clk_mgt0_125_p : OUT    std_logic ;
      clk_mgt0_125_m : OUT    std_logic ;
      clk_xtal_125_p : OUT    std_logic ;
      clk_xtal_125_m : OUT    std_logic ;
      clk_mgt0_250_p : OUT    std_logic ;
      clk_mgt0_250_m : OUT    std_logic ;
      clk_diff_156_p : OUT    std_logic ;
      clk_diff_156_m : OUT    std_logic ;
      ibfi_moddef1   : IN     std_logic_vector ( 1 DOWNTO 0);
      ibfi_moddef2   : INOUT  std_logic_vector ( 1 DOWNTO 0);
      hex_sw_n       : OUT    std_logic_vector (3 DOWNTO 0);
      eth_md_io      : OUT    std_logic ;
      sim_conf_busy  : OUT    boolean 
   );
   END COMPONENT;
   COMPONENT m_power
   PORT (
      hi : OUT    std_logic ;
      lo : OUT    std_logic 
   );
   END COMPONENT;


BEGIN

   -- Instance port mappings.
   -- --------------------------------------------------------------------
   --    Instantiate the EMAC0 PHY stimulus and monitor
   --   --------------------------------------------------------------------
   -- 
   sf0_test : emac0_phy_tb_hsio
      PORT MAP (
         clk125m               => clk_xtal_125_p,
         txp                   => sf_txp(0),
         txn                   => sf_txm(0),
         rxp                   => sf_rxp(0),
         rxn                   => sf_rxm(0),
         configuration_busy    => sim_conf_busy,
         monitor_finished_1g   => monitor_finished_1g,
         monitor_finished_100m => monitor_finished_100m,
         monitor_finished_10m  => monitor_finished_10m
      );
   -- --------------------------------------------------------------------
   --    Instantiate the EMAC0 PHY stimulus and monitor
   --   --------------------------------------------------------------------
   -- 
   sf1_test : emac0_phy_tb_hsio
      PORT MAP (
         clk125m               => clk_xtal_125_p,
         txp                   => sf_txp(3),
         txn                   => sf_txm(3),
         rxp                   => sf_rxp(3),
         rxn                   => sf_rxm(3),
         configuration_busy    => sim_conf_busy,
         monitor_finished_1g   => OPEN,
         monitor_finished_100m => OPEN,
         monitor_finished_10m  => OPEN
      );
   Udut : hsio_c01_eos_top
      GENERIC MAP (
         SIM_MODE => 1
      )
      PORT MAP (
         clk_xtal_125_mi   => clk_xtal_125_m,
         clk_xtal_125_pi   => clk_xtal_125_p,
         eth_col_i         => eth_col_i,
         eth_coma_o        => OPEN,
         eth_crs_i         => eth_crs_i,
         eth_gtxclk_txc_o  => OPEN,
         eth_int_ni        => eth_int_ni,
         eth_mdc_o         => OPEN,
         eth_md_io         => eth_md_io,
         eth_reset_no      => OPEN,
         eth_rx_clk_rxc_i  => eth_rx_clk_rxc_i,
         eth_rx_dv_ctl_i   => eth_rx_dv_ctl_i,
         eth_rx_er_i       => eth_rx_er_i,
         eth_rxd_i         => eth_rxd_i,
         eth_tx_clk_o      => OPEN,
         eth_tx_en_ctl_o   => OPEN,
         eth_tx_er_o       => OPEN,
         eth_txd_o         => OPEN,
         rst_poweron_ni    => rst_poweron_n,
         usb_d_io          => usb_d_io,
         usb_rd_o          => usb_rd_o,
         usb_rxf_i         => usb_rxf_i,
         usb_txe_i         => usb_txe_i,
         usb_wr_o          => usb_wr_o,
         sf_scl_o          => OPEN,
         sf_sda_io         => OPEN,
         sf_rxm            => sf_rxm,
         sf_rxp            => sf_rxp,
         sf_tx_dis_o       => OPEN,
         sf_txm            => OPEN,
         sf_txp            => OPEN,
         eth_tx_clk_i      => eth_tx_clk_i,
         sw_hex_ni         => sw_hex_n,
         idc_p5_io         => idc_p5_io,
         ibepp1_data1_mi   => ibpp_ido0_mi,
         ibepp1_bc_po      => OPEN,
         ibepp1_bc_mo      => OPEN,
         ibepp1_clk_po     => OPEN,
         ibepp1_clk_mo     => OPEN,
         ibepp1_hrst_mo    => OPEN,
         ibepp1_hrst_po    => OPEN,
         ibepp1_com_po     => OPEN,
         ibepp1_com_mo     => OPEN,
         ibepp1_lone_mo    => OPEN,
         ibepp1_lone_po    => OPEN,
         ibepp1_data0_pi   => ibpp_ido0_pi,
         ibepp1_data0_mi   => ibpp_ido0_mi,
         ibepp1_data1_pi   => ibpp_ido0_pi,
         ibemon_sclt_o     => OPEN,
         ibemon_sdat_io    => OPEN,
         ibemon_convstt_no => OPEN,
         ibe_bcot_po       => OPEN,
         ibe_l1rt_po       => OPEN,
         ibe_dot_mi        => ibe_dot_mi,
         ibe_cmdt_mo       => OPEN,
         ibe_l1rt_mo       => OPEN,
         ibe_dot_pi        => ibe_dot_pi,
         ibe_cmdt_po       => OPEN,
         ibe_bcot_mo       => OPEN,
         disp_clk_o        => OPEN,
         disp_dat_o        => OPEN,
         disp_load_no      => OPEN,
         disp_rst_no       => OPEN,
         ibepp0_bc_po      => OPEN,
         ibepp0_bc_mo      => OPEN,
         ibepp0_clk_po     => OPEN,
         ibepp0_clk_mo     => OPEN,
         sma_io            => OPEN,
         led_status_o      => OPEN,
         ibepp0_hrst_mo    => OPEN,
         ibepp0_hrst_po    => OPEN,
         ibepp0_com_po     => ibpp_ido0_pi,
         ibepp0_com_mo     => ibpp_ido0_mi,
         ibepp0_lone_mo    => OPEN,
         ibepp0_lone_po    => OPEN,
         ibepp0_data0_pi   => ibpp_ido0_pi,
         ibepp0_data0_mi   => ibpp_ido0_mi,
         ibepp0_data1_pi   => ibpp_ido0_pi,
         ibepp0_data1_mi   => ibpp_ido0_mi,
         idc_p2_io         => idc_p2_io,
         idc_p3_io         => idc_p3_io,
         idc_p4_io         => idc_p4_io,
         clk_mgt0a_mi      => clk_mgt0_125_m,
         clk_mgt0a_pi      => clk_mgt0_125_p,
         clk_mgt1a_mi      => clk_mgt1a_mi,
         clk_mgt1a_pi      => clk_mgt1a_pi,
         ibe_noiset_mo     => OPEN,
         ibe_noiset_po     => OPEN,
         ibe_osc0_pi       => ibe_osc0_pi,
         ibe_osc0_mi       => ibe_osc0_mi,
         clk_mgt0b_mi      => clk_diff_156_m,
         clk_mgt0b_pi      => clk_diff_156_p,
         clk_mgt1b_pi      => clk_diff_156_p,
         clk_mgt1b_mi      => clk_diff_156_m,
         sf_los_i          => sf_los_i,
         sf_rx_ratesel_o   => OPEN,
         sf_mod_abs_i      => sf_mod_abs_i,
         sf_tx_fault_i     => sf_tx_fault_i,
         sf_tx_ratesel_o   => OPEN
      );
   Utstr : hsio_top_tester
      PORT MAP (
         rst_poweron_n  => rst_poweron_n,
         rst            => rst,
         clk40          => clk40,
         clk25          => eth_tx_clk_i,
         clk_mgt0_125_p => clk_mgt0_125_p,
         clk_mgt0_125_m => clk_mgt0_125_m,
         clk_xtal_125_p => clk_xtal_125_p,
         clk_xtal_125_m => clk_xtal_125_m,
         clk_mgt0_250_p => clk_mgt0_250_p,
         clk_mgt0_250_m => clk_mgt0_250_m,
         clk_diff_156_p => clk_diff_156_p,
         clk_diff_156_m => clk_diff_156_m,
         ibfi_moddef1   => ibfi_moddef1,
         ibfi_moddef2   => ibfi_moddef2,
         hex_sw_n       => sw_hex_n,
         eth_md_io      => eth_md_io,
         sim_conf_busy  => sim_conf_busy
      );
   Um_power : m_power
      PORT MAP (
         hi => hi,
         lo => lo
      );

END sim;
