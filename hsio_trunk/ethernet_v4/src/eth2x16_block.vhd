-------------------------------------------------------------------------------
-- Title      : Virtex-4 Ethernet MAC Wrapper Top Level
-- Project    : Virtex-4 Embedded Tri-Mode Ethernet MAC Wrapper
-- File       : eth2x16_block.vhd
-- Version    : 4.8
-------------------------------------------------------------------------------
--
-- (c) Copyright 2004-2010 Xilinx, Inc. All rights reserved.
--
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
--
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
--
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
--
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
--
-------------------------------------------------------------------------------
-- Description:  This is the EMAC block level VHDL design for the Virtex-4 
--               Embedded Ethernet MAC Example Design.  It is intended that
--               this example design can be quickly adapted and downloaded onto
--               an FPGA to provide a real hardware test environment.
--
--               The block level:
--
--               * instantiates all clock management logic required (BUFGs, 
--                 DCMs) to operate the EMAC and its example design;
--
--               * instantiates appropriate PHY interface modules (GMII, MII,
--                 RGMII, SGMII or 1000BASE-X) as required based on the user
--                 configuration.
--
--
--               Please refer to the Datasheet, Getting Started Guide, and
--               the Virtex-4 Embedded Tri-Mode Ethernet MAC User Gude for
--               further information.
-------------------------------------------------------------------------------


library unisim;
use unisim.vcomponents.all;

library ieee;
use ieee.std_logic_1164.all;



-------------------------------------------------------------------------------
-- The entity declaration for the top level design.
-------------------------------------------------------------------------------
entity eth2x16_block is
   port(
      -- Client Receiver Interface - EMAC0
      RX_CLIENT_CLK_0                 : out std_logic;
      EMAC0CLIENTRXD                  : out std_logic_vector(15 downto 0);
      EMAC0CLIENTRXDVLD               : out std_logic;
      EMAC0CLIENTRXDVLDMSW            : out std_logic;
      EMAC0CLIENTRXGOODFRAME          : out std_logic;
      EMAC0CLIENTRXBADFRAME           : out std_logic;
      EMAC0CLIENTRXFRAMEDROP          : out std_logic;
      EMAC0CLIENTRXSTATS              : out std_logic_vector(6 downto 0);
      EMAC0CLIENTRXSTATSVLD           : out std_logic;
      EMAC0CLIENTRXSTATSBYTEVLD       : out std_logic;

      -- Client Transmitter Interface - EMAC0
      TX_CLIENT_CLK_0                 : out std_logic;
      CLIENTEMAC0TXD                  : in  std_logic_vector(15 downto 0);
      CLIENTEMAC0TXDVLD               : in  std_logic;
      CLIENTEMAC0TXDVLDMSW            : in  std_logic;
      EMAC0CLIENTTXACK                : out std_logic;
      CLIENTEMAC0TXFIRSTBYTE          : in  std_logic;
      CLIENTEMAC0TXUNDERRUN           : in  std_logic;
      EMAC0CLIENTTXCOLLISION          : out std_logic;
      EMAC0CLIENTTXRETRANSMIT         : out std_logic;
      CLIENTEMAC0TXIFGDELAY           : in  std_logic_vector(7 downto 0);
      EMAC0CLIENTTXSTATS              : out std_logic;
      EMAC0CLIENTTXSTATSVLD           : out std_logic;
      EMAC0CLIENTTXSTATSBYTEVLD       : out std_logic;

      -- MAC Control Interface - EMAC0
      CLIENTEMAC0PAUSEREQ             : in  std_logic;
      CLIENTEMAC0PAUSEVAL             : in  std_logic_vector(15 downto 0);

      --EMAC-MGT link status
      EMAC0CLIENTSYNCACQSTATUS        : out std_logic;

 
      -- Clock Signals - EMAC0
      -- 1000BASE-X PCS/PMA Interface - EMAC0
      TXP_0                           : out std_logic;
      TXN_0                           : out std_logic;
      RXP_0                           : in  std_logic;
      RXN_0                           : in  std_logic;
      PHYAD_0                         : in  std_logic_vector(4 downto 0);
      RESETDONE_0                     : out std_logic;

      -- MDIO Interface - EMAC0
      MDC_0                           : out std_logic;
      MDIO_0_I                        : in  std_logic;
      MDIO_0_O                        : out std_logic;
      MDIO_0_T                        : out std_logic;
      -- Client Receiver Interface - EMAC1
      RX_CLIENT_CLK_1                 : out std_logic;
      EMAC1CLIENTRXD                  : out std_logic_vector(15 downto 0);
      EMAC1CLIENTRXDVLD               : out std_logic;
      EMAC1CLIENTRXDVLDMSW            : out std_logic;
      EMAC1CLIENTRXGOODFRAME          : out std_logic;
      EMAC1CLIENTRXBADFRAME           : out std_logic;
      EMAC1CLIENTRXFRAMEDROP          : out std_logic;
      EMAC1CLIENTRXSTATS              : out std_logic_vector(6 downto 0);
      EMAC1CLIENTRXSTATSVLD           : out std_logic;
      EMAC1CLIENTRXSTATSBYTEVLD       : out std_logic;

      -- Client Transmitter Interface - EMAC1
      TX_CLIENT_CLK_1                 : out std_logic;
      CLIENTEMAC1TXD                  : in  std_logic_vector(15 downto 0);
      CLIENTEMAC1TXDVLD               : in  std_logic;
      CLIENTEMAC1TXDVLDMSW            : in  std_logic;
      EMAC1CLIENTTXACK                : out std_logic;
      CLIENTEMAC1TXFIRSTBYTE          : in  std_logic;
      CLIENTEMAC1TXUNDERRUN           : in  std_logic;
      EMAC1CLIENTTXCOLLISION          : out std_logic;
      EMAC1CLIENTTXRETRANSMIT         : out std_logic;
      CLIENTEMAC1TXIFGDELAY           : in  std_logic_vector(7 downto 0);
      EMAC1CLIENTTXSTATS              : out std_logic;
      EMAC1CLIENTTXSTATSVLD           : out std_logic;
      EMAC1CLIENTTXSTATSBYTEVLD       : out std_logic;

      -- MAC Control Interface - EMAC1
      CLIENTEMAC1PAUSEREQ             : in  std_logic;
      CLIENTEMAC1PAUSEVAL             : in  std_logic_vector(15 downto 0);

      --EMAC-MGT link status
      EMAC1CLIENTSYNCACQSTATUS        : out std_logic;

           
      -- Clock Signals - EMAC1
      -- 1000BASE-X PCS/PMA Interface - EMAC1
      TXP_1                           : out std_logic;
      TXN_1                           : out std_logic;
      RXP_1                           : in  std_logic;
      RXN_1                           : in  std_logic;
      PHYAD_1                         : in  std_logic_vector(4 downto 0);
      RESETDONE_1                     : out std_logic;

      -- MDIO Interface - EMAC1
      MDC_1                           : out std_logic;
      MDIO_1_I                        : in  std_logic;
      MDIO_1_O                        : out std_logic;
      MDIO_1_T                        : out std_logic;
      -- Generic Host Interface
      HOSTOPCODE                      : in  std_logic_vector(1 downto 0);
      HOSTREQ                         : in  std_logic;
      HOSTMIIMSEL                     : in  std_logic;
      HOSTADDR                        : in  std_logic_vector(9 downto 0);
      HOSTWRDATA                      : in  std_logic_vector(31 downto 0);
      HOSTMIIMRDY                     : out std_logic;
      HOSTRDDATA                      : out std_logic_vector(31 downto 0);
      HOSTEMAC1SEL                    : in  std_logic;
      HOSTCLK                         : in  std_logic;
      -- 1000BASE-X PCS/PMA RocketIO Reference Clock buffer inputs 
      MGTCLK_P                        : in  std_logic;
      MGTCLK_N                        : in  std_logic;

      DCLK                            : in  std_logic;

      -- *** mod start
      REFCLK1_i       : in  std_logic;
      REFCLK2_i       : in  std_logic;
      an_interrupt0_o : out std_logic;
      an_interrupt1_o : out std_logic;
      -- *** mod end 		  
        
      -- The following two ports are to enable the 200ms reset for the 
      -- DCM in the Tx Client Clock path to be bypassed during simulation
      -- NOTE: These should be tied together for normal operation
      RESET_200MS                     : out std_logic;
      RESET_200MS_IN                  : in  std_logic;
      -- Asynchronous Reset
      RESET                           : in  std_logic
   );
end eth2x16_block;


architecture TOP_LEVEL of eth2x16_block is


-------------------------------------------------------------------------------
-- Component Declarations for lower hierarchial level entities
-------------------------------------------------------------------------------


  -- Component Declaration for the main EMAC wrapper
  component eth2x16 is
    port(
      -- Client Receiver Interface - EMAC0
      EMAC0CLIENTRXCLIENTCLKOUT       : out std_logic;
      CLIENTEMAC0RXCLIENTCLKIN        : in  std_logic;
      CLIENTEMAC0RXCLIENTCLKINDIV2    : in  std_logic;
      EMAC0CLIENTRXD                  : out std_logic_vector(15 downto 0);
      EMAC0CLIENTRXDVLD               : out std_logic;
      EMAC0CLIENTRXDVLDMSW            : out std_logic;
      EMAC0CLIENTRXGOODFRAME          : out std_logic;
      EMAC0CLIENTRXBADFRAME           : out std_logic;
      EMAC0CLIENTRXFRAMEDROP          : out std_logic;
      EMAC0CLIENTRXDVREG6             : out std_logic;
      EMAC0CLIENTRXSTATS              : out std_logic_vector(6 downto 0);
      EMAC0CLIENTRXSTATSVLD           : out std_logic;
      EMAC0CLIENTRXSTATSBYTEVLD       : out std_logic;

      -- Client Transmitter Interface - EMAC0
      EMAC0CLIENTTXCLIENTCLKOUT       : out std_logic;
      CLIENTEMAC0TXCLIENTCLKIN        : in  std_logic;
      CLIENTEMAC0TXCLIENTCLKINDIV2    : in  std_logic;
      CLIENTEMAC0TXD                  : in  std_logic_vector(15 downto 0);
      CLIENTEMAC0TXDVLD               : in  std_logic;
      CLIENTEMAC0TXDVLDMSW            : in  std_logic;
      EMAC0CLIENTTXACK                : out std_logic;
      CLIENTEMAC0TXFIRSTBYTE          : in  std_logic;
      CLIENTEMAC0TXUNDERRUN           : in  std_logic;
      EMAC0CLIENTTXCOLLISION          : out std_logic;
      EMAC0CLIENTTXRETRANSMIT         : out std_logic;
      CLIENTEMAC0TXIFGDELAY           : in  std_logic_vector(7 downto 0);
      EMAC0CLIENTTXSTATS              : out std_logic;
      EMAC0CLIENTTXSTATSVLD           : out std_logic;
      EMAC0CLIENTTXSTATSBYTEVLD       : out std_logic;

      -- MAC Control Interface - EMAC0
      CLIENTEMAC0PAUSEREQ             : in  std_logic;
      CLIENTEMAC0PAUSEVAL             : in  std_logic_vector(15 downto 0);

      -- Clock Signals - EMAC0
      GTX_CLK_0                       : in  std_logic;
      EMAC0CLIENTTXGMIIMIICLKOUT      : out std_logic;
      CLIENTEMAC0TXGMIIMIICLKIN       : in  std_logic;

      -- 1000BASE-X PCS/PMA Interface - EMAC0
      RXDATA_0                        : in  std_logic_vector(7 downto 0);
      TXDATA_0                        : out std_logic_vector(7 downto 0);
      DCM_LOCKED_0                    : in  std_logic;
      AN_INTERRUPT_0                  : out std_logic;
      SIGNAL_DETECT_0                 : in  std_logic;
      PHYAD_0                         : in  std_logic_vector(4 downto 0);
      ENCOMMAALIGN_0                  : out std_logic;
      LOOPBACKMSB_0                   : out std_logic;
      MGTRXRESET_0                    : out std_logic;
      MGTTXRESET_0                    : out std_logic;
      POWERDOWN_0                     : out std_logic;
      SYNCACQSTATUS_0                 : out std_logic;
      RXCLKCORCNT_0                   : in  std_logic_vector(2 downto 0);
      RXBUFSTATUS_0                   : in  std_logic_vector(1 downto 0);
      RXBUFERR_0                      : in  std_logic;
      RXCHARISCOMMA_0                 : in  std_logic;
      RXCHARISK_0                     : in  std_logic;
      RXCHECKINGCRC_0                 : in  std_logic;
      RXCOMMADET_0                    : in  std_logic;
      RXDISPERR_0                     : in  std_logic;
      RXLOSSOFSYNC_0                  : in  std_logic_vector(1 downto 0);
      RXNOTINTABLE_0                  : in  std_logic;
      RXREALIGN_0                     : in  std_logic;
      RXRUNDISP_0                     : in  std_logic;
      TXBUFERR_0                      : in  std_logic;
      TXCHARDISPMODE_0                : out std_logic;
      TXCHARDISPVAL_0                 : out std_logic;
      TXCHARISK_0                     : out std_logic;
      TXRUNDISP_0                     : in std_logic;

      -- MDIO Interface - EMAC0
      MDC_0                           : out std_logic;
      MDIO_IN_0                       : in  std_logic;
      MDIO_OUT_0                      : out std_logic;
      MDIO_TRI_0                      : out std_logic;

      -- Client Receiver Interface - EMAC1
      EMAC1CLIENTRXCLIENTCLKOUT       : out std_logic;
      CLIENTEMAC1RXCLIENTCLKIN        : in  std_logic;
      CLIENTEMAC1RXCLIENTCLKINDIV2    : in  std_logic;
      EMAC1CLIENTRXD                  : out std_logic_vector(15 downto 0);
      EMAC1CLIENTRXDVLD               : out std_logic;
      EMAC1CLIENTRXDVLDMSW            : out std_logic;
      EMAC1CLIENTRXGOODFRAME          : out std_logic;
      EMAC1CLIENTRXBADFRAME           : out std_logic;
      EMAC1CLIENTRXFRAMEDROP          : out std_logic;
      EMAC1CLIENTRXDVREG6             : out std_logic;
      EMAC1CLIENTRXSTATS              : out std_logic_vector(6 downto 0);
      EMAC1CLIENTRXSTATSVLD           : out std_logic;
      EMAC1CLIENTRXSTATSBYTEVLD       : out std_logic;

      -- Client Transmitter Interface - EMAC1
      EMAC1CLIENTTXCLIENTCLKOUT       : out std_logic;
      CLIENTEMAC1TXCLIENTCLKIN        : in  std_logic;
      CLIENTEMAC1TXCLIENTCLKINDIV2    : in  std_logic;
      CLIENTEMAC1TXD                  : in  std_logic_vector(15 downto 0);
      CLIENTEMAC1TXDVLD               : in  std_logic;
      CLIENTEMAC1TXDVLDMSW            : in  std_logic;
      EMAC1CLIENTTXACK                : out std_logic;
      CLIENTEMAC1TXFIRSTBYTE          : in  std_logic;
      CLIENTEMAC1TXUNDERRUN           : in  std_logic;
      EMAC1CLIENTTXCOLLISION          : out std_logic;
      EMAC1CLIENTTXRETRANSMIT         : out std_logic;
      CLIENTEMAC1TXIFGDELAY           : in  std_logic_vector(7 downto 0);
      EMAC1CLIENTTXSTATS              : out std_logic;
      EMAC1CLIENTTXSTATSVLD           : out std_logic;
      EMAC1CLIENTTXSTATSBYTEVLD       : out std_logic;

      -- MAC Control Interface - EMAC1
      CLIENTEMAC1PAUSEREQ             : in  std_logic;
      CLIENTEMAC1PAUSEVAL             : in  std_logic_vector(15 downto 0);

      -- Clock Signals - EMAC1
      GTX_CLK_1                       : in  std_logic;
      EMAC1CLIENTTXGMIIMIICLKOUT      : out std_logic;
      CLIENTEMAC1TXGMIIMIICLKIN       : in  std_logic;

      -- 1000BASE-X PCS/PMA Interface - EMAC1
      RXDATA_1                        : in  std_logic_vector(7 downto 0);
      TXDATA_1                        : out std_logic_vector(7 downto 0);
      DCM_LOCKED_1                    : in  std_logic;
      AN_INTERRUPT_1                  : out std_logic;
      SIGNAL_DETECT_1                 : in  std_logic;
      PHYAD_1                         : in  std_logic_vector(4 downto 0);
      ENCOMMAALIGN_1                  : out std_logic;
      LOOPBACKMSB_1                   : out std_logic;
      MGTRXRESET_1                    : out std_logic;
      MGTTXRESET_1                    : out std_logic;
      POWERDOWN_1                     : out std_logic;
      SYNCACQSTATUS_1                 : out std_logic;
      RXCLKCORCNT_1                   : in  std_logic_vector(2 downto 0);
      RXBUFSTATUS_1                   : in  std_logic_vector(1 downto 0);
      RXBUFERR_1                      : in  std_logic;
      RXCHARISCOMMA_1                 : in  std_logic;
      RXCHARISK_1                     : in  std_logic;
      RXCHECKINGCRC_1                 : in  std_logic;
      RXCOMMADET_1                    : in  std_logic;
      RXDISPERR_1                     : in  std_logic;
      RXLOSSOFSYNC_1                  : in  std_logic_vector(1 downto 0);
      RXNOTINTABLE_1                  : in  std_logic;
      RXREALIGN_1                     : in  std_logic;
      RXRUNDISP_1                     : in  std_logic;
      TXBUFERR_1                      : in  std_logic;
      TXCHARDISPMODE_1                : out std_logic;
      TXCHARDISPVAL_1                 : out std_logic;
      TXCHARISK_1                     : out std_logic;
      TXRUNDISP_1                     : in std_logic;

      -- MDIO Interface - EMAC1
      MDC_1                           : out std_logic;
      MDIO_IN_1                       : in  std_logic;
      MDIO_OUT_1                      : out std_logic;
      MDIO_TRI_1                      : out std_logic;

      -- Generic Host Interface
      HOSTOPCODE                      : in  std_logic_vector(1 downto 0);
      HOSTREQ                         : in  std_logic;
      HOSTMIIMSEL                     : in  std_logic;
      HOSTADDR                        : in  std_logic_vector(9 downto 0);
      HOSTWRDATA                      : in  std_logic_vector(31 downto 0);
      HOSTMIIMRDY                     : out std_logic;
      HOSTRDDATA                      : out std_logic_vector(31 downto 0);
      HOSTEMAC1SEL                    : in  std_logic;
      -- Must always be connected
      HOSTCLK                         : in  std_logic;


      -- Asynchronous Reset
      RESET                           : in  std_logic
    );
  end component;


   ---------------------------------------------------------------------
   -- Component Declaration for the RocketIO Reset/Initialisation Block
   ---------------------------------------------------------------------

   component gt11_init_tx
   port (
      clk                         :  in  std_logic;
      usrclk2                     :  in  std_logic;
      start_init                  :  in  std_logic;
      lock                        :  in  std_logic;
      usrclk_stable               :  in  std_logic;
      pcs_error                   :  in  std_logic;
      pma_reset                   :  out std_logic;
      pcs_reset                   :  out std_logic;
      ready                       :  out std_logic);
   end component;

   ---------------------------------------------------------------------
   -- Component Declaration for the RocketIO Reset/Initialisation Block
   ---------------------------------------------------------------------

   component gt11_init_rx
   port (
      clk                         :  in  std_logic;
      usrclk2                     :  in  std_logic;
      start_init                  :  in  std_logic;
      lock                        :  in  std_logic;
      usrclk_stable               :  in  std_logic;
      pcs_error                   :  in  std_logic;
      pma_reset                   :  out std_logic;
      sync                        :  out std_logic;
      pcs_reset                   :  out std_logic;
      ready                       :  out std_logic);
   end component;


  -- Component Declaration for the RocketIO wrapper
  component GT11_DUAL_1000X is
    port(
          ENMCOMMAALIGN_0       : in    std_logic;
          ENPCOMMAALIGN_0       : in    std_logic;
          LOOPBACK_0            : in    std_logic_vector (1 downto 0);
          REFCLK1_0             : in    std_logic;
          REFCLK2_0             : in    std_logic;
          RXUSRCLK_0            : in    std_logic;
          RXUSRCLK2_0           : in    std_logic;
          RXRESET_0             : in    std_logic;
          RXPMARESET0           : in    std_logic;
          TXCHARDISPMODE_0      : in    std_logic;
          TXCHARDISPVAL_0       : in    std_logic;
          TXCHARISK_0           : in    std_logic;
          TXDATA_0              : in    std_logic_vector (7 downto 0);
          TXUSRCLK_0            : in    std_logic;
          TXUSRCLK2_0           : in    std_logic;
          TXRESET_0             : in    std_logic;
          DO_0                  : out   std_logic_vector (15 downto 0);
          DRDY_0                : out   std_logic;
          RXBUFERR_0            : out   std_logic;
          RXCHARISCOMMA_0       : out   std_logic;
          RXCHARISK_0           : out   std_logic;
          RXCLKCORCNT_0         : out   std_logic_vector (2 downto 0);
          RXCOMMADET_0          : out   std_logic;
          RXDATA_0              : out   std_logic_vector (7 downto 0);
          RXDISPERR_0           : out   std_logic;
          RXNOTINTABLE_0        : out   std_logic;
          RXREALIGN_0           : out   std_logic;
          RXRECCLK1_0           : out   std_logic;
          RXRUNDISP_0           : out   std_logic;
          RXSTATUS_0            : out   std_logic_vector (5 downto 0);
          TXBUFERR_0            : out   std_logic;
          TX_PLLLOCK_0             : out   std_logic;
          RX_PLLLOCK_0             : out   std_logic;
          TXOUTCLK1_0           : out   std_logic;
          TXRUNDISP_0           : out   std_logic;
          RX_SIGNAL_DETECT_0    : in    std_logic;
          RXSYNC_0              : in    std_logic;
          TX1N_0                : out   std_logic;
          TX1P_0                : out   std_logic;
          RX1N_0                : in    std_logic;
          RX1P_0                : in    std_logic;

          ENMCOMMAALIGN_1       : in    std_logic;
          ENPCOMMAALIGN_1       : in    std_logic;
          LOOPBACK_1            : in    std_logic_vector (1 downto 0);
          REFCLK1_1             : in    std_logic;
          REFCLK2_1             : in    std_logic;
          RXUSRCLK_1            : in    std_logic;
          RXUSRCLK2_1           : in    std_logic;
          RXRESET_1             : in    std_logic;
          RXPMARESET1           : in    std_logic;
          TXCHARDISPMODE_1      : in    std_logic;
          TXCHARDISPVAL_1       : in    std_logic;
          TXCHARISK_1           : in    std_logic;
          TXDATA_1              : in    std_logic_vector (7 downto 0);
          TXUSRCLK_1            : in    std_logic;
          TXUSRCLK2_1           : in    std_logic;
          TXRESET_1             : in    std_logic;
          DO_1                  : out   std_logic_vector (15 downto 0);
          DRDY_1                : out   std_logic;
          RXBUFERR_1            : out   std_logic;
          RXCHARISCOMMA_1       : out   std_logic;
          RXCHARISK_1           : out   std_logic;
          RXCLKCORCNT_1         : out   std_logic_vector (2 downto 0);
          RXCOMMADET_1          : out   std_logic;
          RXDATA_1              : out   std_logic_vector (7 downto 0);
          RXDISPERR_1           : out   std_logic;
          RXNOTINTABLE_1        : out   std_logic;
          RXREALIGN_1           : out   std_logic;
          RXRECCLK1_1           : out   std_logic;
          RXRUNDISP_1           : out   std_logic;
          RXSTATUS_1            : out   std_logic_vector (5 downto 0);
          TXBUFERR_1            : out   std_logic;
          TX_PLLLOCK_1             : out   std_logic;
          RX_PLLLOCK_1             : out   std_logic;
          TXOUTCLK1_1           : out   std_logic;
          TXRUNDISP_1           : out   std_logic;
          RX_SIGNAL_DETECT_1    : in    std_logic;
          RXSYNC_1              : in    std_logic;
          TX1N_1                : out   std_logic;
          TX1P_1                : out   std_logic;
          RX1N_1                : in    std_logic;
          RX1P_1                : in    std_logic;


          PMARESET_TX0           : in  std_logic;
          PMARESET_TX1           : in  std_logic;
          DCLK                  : in  std_logic;
          DCM_LOCKED            : in  std_logic
          );
  end component;


  -- Component Declaration for the RocketIO clock module
  component GT11CLK_MGT is
   generic (
      SYNCLK1OUTEN                    : string := "ENABLE";
      SYNCLK2OUTEN                    : string := "DISABLE"
      );

   port (
      SYNCLK1OUT                      : out std_ulogic;
      SYNCLK2OUT                      : out std_ulogic;

      MGTCLKN                         : in std_ulogic;
      MGTCLKP                         : in std_ulogic
    );
  end component;




  -- Component Declaration for the DCM Reset generation logic
  component dcm_reset
    port(
      ref_reset                   : in  std_logic;
      ref_clk                     : in  std_logic;
      dcm_locked                  : in  std_logic;
      dcm_reset                   : out std_logic);
  end component;

  -- Component Declaration for the synchronizer logic
  component sync_block
    port(
      clk         : in  std_logic;
      data_in     : in  std_logic;  
      data_out    : out std_logic);
  end component;

-------------------------------------------------------------------------------
-- Signals Declarations
-------------------------------------------------------------------------------

    signal gnd_i                          : std_logic;
    signal gnd_v48_i                      : std_logic_vector(47 downto 0);
    signal vcc_i                          : std_logic;

    signal reset_ibuf_i                   : std_logic;
    signal reset_i                        : std_logic;
    signal emac_reset                     : std_logic;
    signal reset_r                        : std_logic_vector(3 downto 0);

    signal rx_client_clk_out_0_i          : std_logic;
    signal rx_client_clk_in_0_i           : std_logic;
    signal tx_client_clk_out_0_i          : std_logic;
    signal tx_client_clk_fb_0_i           : std_logic;
    signal tx_client_clk_in_0_i           : std_logic;
    signal tx_gmii_mii_clk_out_0_i        : std_logic;
    signal tx_gmii_mii_clk_in_0_i         : std_logic;
    signal pll_not_locked_0_i             : std_logic;
    signal tx_pcs_reset_0_i               : std_logic;
    signal rx_pcs_reset_0_i               : std_logic;
    signal rx_rdy0                        : std_logic;
    signal tx_rdy0                        : std_logic;
    signal emac0_reset                    : std_logic;
    signal emac_locked_0_i                : std_logic;
    signal mgt_rx_data_0_i                : std_logic_vector(7 downto 0);
    signal mgt_tx_data_0_i                : std_logic_vector(7 downto 0);
    signal an_interrupt_0_i               : std_logic;
    signal signal_detect_0_i              : std_logic;
    signal phy_ad_0_i                     : std_logic_vector(4 downto 0);
    signal encommaalign_0_i               : std_logic;
    signal loopback_0_i                   : std_logic;
    signal loopback_0_sig                 : std_logic_vector (1 downto 0);
    signal mgt_rx_reset_0_i               : std_logic;
    signal mgt_tx_reset_0_i               : std_logic;
    signal powerdown_0_i                  : std_logic;
    signal sync_acq_status_0_i            : std_logic;
    signal rxclkcorcnt_0_i                : std_logic_vector(2 downto 0);
    signal rxbufstatus_0_i                : std_logic_vector(5 downto 0);
    signal rxbuferr_0_i                   : std_logic;
    signal rxbuferr_0                     : std_logic;
    signal rxpmareset0                    : std_logic;
    signal rxchariscomma_0_i              : std_logic;
    signal rxcharisk_0_i                  : std_logic;
    signal rxcheckingcrc_0_i              : std_logic;
    signal rxcommadet_0_i                 : std_logic;
    signal rxdisperr_0_i                  : std_logic;
    signal rxlossofsync_0_i               : std_logic_vector(1 downto 0);
    signal rxnotintable_0_i               : std_logic;
    signal rxrealign_0_i                  : std_logic;
    signal rxrundisp_0_i                  : std_logic;
    signal txbuferr_0_i                   : std_logic;
    signal txchardispmode_0_i             : std_logic;
    signal txchardispval_0_i              : std_logic;
    signal txcharisk_0_i                  : std_logic;
    signal txrundisp_0_i                  : std_logic;
    signal gtx_clk_ibufg_0_i              : std_logic;
    signal rxbuferr_cat_0_i               : std_logic_vector(1 downto 0);

    signal rx_client_clk_in_div2_0_i      : std_logic;
    signal rx_client_dcm_locked_0_i       : std_logic;
    signal tx_client_clk_in_div2_0_i      : std_logic;
    signal tx_client_dcm_locked_0_i       : std_logic;
    signal tx_client_clk0_out_0_i         : std_logic;
    signal dcm_clkin                      : std_logic;
    signal dcm_clk0_out                   : std_logic;
    signal dcm_clkdv_out                  : std_logic;
    signal dcm_clk0_bufg                  : std_logic;
    signal dcm_clkdv_bufg                 : std_logic;
    signal dcm_reset_0_r1                 : std_logic;
    signal dcm_reset_0_r2                 : std_logic;
    signal dcm_reset_0_i                  : std_logic;

    signal rx_client_clk_out_1_i          : std_logic;
    signal rx_client_clk_in_1_i           : std_logic;
    signal tx_client_clk_out_1_i          : std_logic;
    signal tx_client_clk_in_1_i           : std_logic;
    signal tx_client_clk_fb_1_i           : std_logic;
    signal dcm_reset_1_r1                 : std_logic;
    signal dcm_reset_1_r2                 : std_logic;
    signal dcm_reset_1_i                  : std_logic;
    signal pll_not_locked_1_i             : std_logic;
    signal tx_pcs_reset_1_i               : std_logic;
    signal rx_pcs_reset_1_i               : std_logic;
    signal rx_rdy1                        : std_logic;
    signal tx_rdy1                        : std_logic;
    signal emac1_reset                    : std_logic;
    signal rxpmareset1                    : std_logic;
    signal emac_locked_1_i                : std_logic;
    signal mgt_rx_data_1_i                : std_logic_vector(7 downto 0);
    signal mgt_tx_data_1_i                : std_logic_vector(7 downto 0);
    signal dcm_locked_1_i                 : std_logic;
    signal an_interrupt_1_i               : std_logic;
    signal signal_detect_1_i              : std_logic;
    signal phy_ad_1_i                     : std_logic_vector(4 downto 0);
    signal encommaalign_1_i               : std_logic;
    signal loopback_1_sig                 : std_logic_vector(1 downto 0);
    signal loopback_1_i                   : std_logic;
    signal mgt_rx_reset_1_i               : std_logic;
    signal mgt_tx_reset_1_i               : std_logic;
    signal powerdown_1_i                  : std_logic;
    signal sync_acq_status_1_i            : std_logic;
    signal rxclkcorcnt_1_i                : std_logic_vector(2 downto 0);
    signal rxbufstatus_1_i                : std_logic_vector(5 downto 0);
    signal rxbuferr_1_i                   : std_logic;
    signal rxbuferr_1                     : std_logic;
    signal rxchariscomma_1_i              : std_logic;
    signal rxcharisk_1_i                  : std_logic;
    signal rxcheckingcrc_1_i              : std_logic;
    signal rxcommadet_1_i                 : std_logic;
    signal rxdisperr_1_i                  : std_logic;
    signal rxlossofsync_1_i               : std_logic_vector(1 downto 0);
    signal rxnotintable_1_i               : std_logic;
    signal rxrealign_1_i                  : std_logic;
    signal rxrundisp_1_i                  : std_logic;
    signal txbuferr_1_i                   : std_logic;
    signal txchardispmode_1_i             : std_logic;
    signal txchardispval_1_i              : std_logic;
    signal txcharisk_1_i                  : std_logic;
    signal txrundisp_1_i                  : std_logic;
    signal gtx_clk_ibufg_1_i              : std_logic;
    signal rxbuferr_cat_1_i               : std_logic_vector(1 downto 0);
    signal rx_client_clk_in_div2_1_i      : std_logic;
    signal rx_client_dcm_locked_1_i       : std_logic;
    signal tx_client_clk_in_div2_1_i      : std_logic;
    signal tx_client_dcm_locked_1_i       : std_logic;

    signal txpmareset                      : std_logic;
    signal reset_pma_sm                   : std_logic_vector(3 downto 0);
    signal usrclk2                        : std_logic;
    signal dclk_bufg                      : std_logic;
    signal txoutclk1                      : std_logic;
    signal txpmareset0                     : std_logic;
    signal txpmareset1                     : std_logic;
    signal tx_plllock_0                      : std_logic;
    signal rx_plllock_0                      : std_logic;
    signal phy_config_vector_0_i          : std_logic_vector(4 downto 0);
    signal has_mdio_0_i                   : std_logic;
    signal speed_0_i                      : std_logic_vector(1 downto 0);
    signal has_rgmii_0_i                  : std_logic;
    signal has_sgmii_0_i                  : std_logic;
    signal has_gpcs_0_i                   : std_logic;
    signal has_host_0_i                   : std_logic;
    signal tx_client_16_0_i               : std_logic;
    signal rx_client_16_0_i               : std_logic;
    signal addr_filter_enable_0_i         : std_logic;
    signal rx_lt_check_dis_0_i            : std_logic;
    signal flow_control_config_vector_0_i : std_logic_vector(1 downto 0);
    signal tx_config_vector_0_i           : std_logic_vector(6 downto 0);
    signal rx_config_vector_0_i           : std_logic_vector(5 downto 0);
    signal pause_address_0_i              : std_logic_vector(47 downto 0);

    signal unicast_address_0_i            : std_logic_vector(47 downto 0);
    signal tx_plllock_1                      : std_logic;
    signal rx_plllock_1                      : std_logic;

    signal phy_config_vector_1_i          : std_logic_vector(4 downto 0);
    signal has_mdio_1_i                   : std_logic;
    signal speed_1_i                      : std_logic_vector(1 downto 0);
    signal has_rgmii_1_i                  : std_logic;
    signal has_sgmii_1_i                  : std_logic;
    signal has_gpcs_1_i                   : std_logic;
    signal has_host_1_i                   : std_logic;
    signal tx_client_16_1_i               : std_logic;
    signal rx_client_16_1_i               : std_logic;
    signal addr_filter_enable_1_i         : std_logic;
    signal rx_lt_check_dis_1_i            : std_logic;
    signal flow_control_config_vector_1_i : std_logic_vector(1 downto 0);
    signal tx_config_vector_1_i           : std_logic_vector(6 downto 0);
    signal rx_config_vector_1_i           : std_logic_vector(5 downto 0);
    signal pause_address_1_i              : std_logic_vector(47 downto 0);
    signal unicast_address_1_i            : std_logic_vector(47 downto 0);

    signal refclk1                        : std_logic;
    signal refclk2                        : std_logic;

    signal refclk1_bufg                   : std_logic;
    signal tx_reset_sm_0_r                : std_logic_vector(3 downto 0);
    signal tx_pcs_reset_0_r               : std_logic;
    signal rx_reset_sm_0_r                : std_logic_vector(3 downto 0);
    signal rx_pcs_reset_0_r               : std_logic;
    signal tx_reset_sm_1_r                : std_logic_vector(3 downto 0);
    signal tx_pcs_reset_1_r               : std_logic;
    signal rx_reset_sm_1_r                : std_logic_vector(3 downto 0);
    signal rx_pcs_reset_1_r               : std_logic;


    signal tx_data_0_i                    : std_logic_vector(15 downto 0);
    signal tx_data_valid_0_i              : std_logic;
    signal tx_data_valid_msb_0_i          : std_logic;
    signal rx_data_0_i                    : std_logic_vector(15 downto 0);
    signal rx_data_valid_0_i              : std_logic;
    signal rx_data_valid_msb_0_i          : std_logic;
    signal tx_underrun_0_i                : std_logic;
    signal tx_ack_0_i                     : std_logic;
    signal rx_good_frame_0_i              : std_logic;
    signal rx_bad_frame_0_i               : std_logic;
    signal tx_retransmit_0_i              : std_logic;
    signal mdc_out_0_i                    : std_logic;
    signal mdio_in_0_i                    : std_logic;
    signal mdio_out_0_i                   : std_logic;
    signal mdio_tri_0_i                   : std_logic;
    signal tx_data_1_i                    : std_logic_vector(15 downto 0);
    signal tx_data_valid_1_i              : std_logic;
    signal tx_data_valid_msb_1_i          : std_logic;
    signal rx_data_1_i                    : std_logic_vector(15 downto 0);
    signal rx_data_valid_1_i              : std_logic;
    signal rx_data_valid_msb_1_i          : std_logic;
    signal tx_underrun_1_i                : std_logic;
    signal tx_ack_1_i                     : std_logic;
    signal rx_good_frame_1_i              : std_logic;
    signal rx_bad_frame_1_i               : std_logic;
    signal tx_retransmit_1_i              : std_logic;
    signal mdc_out_1_i                    : std_logic;
    signal mdio_in_1_i                    : std_logic;
    signal mdio_out_1_i                   : std_logic;
    signal mdio_tri_1_i                   : std_logic;
    signal host_clk_i                     : std_logic;
    signal speed_vector_0_i               : std_logic_vector(1 downto 0);
    signal speed_vector_1_i               : std_logic_vector(1 downto 0);
    signal rxsync_0                       : std_logic;
    signal rxsync_1                       : std_logic;

  attribute ASYNC_REG : string;
  attribute ASYNC_REG of reset_r  : signal is "TRUE";

-- Force xst to preserve the clock net names in the design
-- These clock names are referenced in the UCF file
  attribute KEEP : string;
  attribute KEEP of tx_client_clk_in_0_i   : signal is "TRUE";
  attribute KEEP of usrclk2   : signal is "TRUE";
 attribute KEEP of tx_client_clk_in_div2_0_i : signal is "TRUE";

-- attribute KEEP : string;
-- attribute KEEP of usrclk2   : signal is "TRUE";




-------------------------------------------------------------------------------
-- Main Body of Code
-------------------------------------------------------------------------------


begin


    gnd_i     <= '0';
    gnd_v48_i <= (others => '0');
    vcc_i     <= '1';

    ---------------------------------------------------------------------------
    -- Main Reset Circuitry
    ---------------------------------------------------------------------------

    reset_ibuf_i <= RESET;

    -- Asserting the reset of the EMAC for four clock cycles
    -- This clock can be changed to any clock that is not derived
    -- from an output clock of the GT11.
    process(host_clk_i, reset_ibuf_i)
    begin
        if (reset_ibuf_i = '1') then
            reset_r <= "1111";
        elsif host_clk_i'event and host_clk_i = '1' then
            reset_r <= reset_r(2 downto 0) & reset_ibuf_i;
        end if;
    end process;

    -- The reset pulse is now several clock cycles in duration
    reset_i <= reset_r(3);

    RESETDONE_0 <= not reset_i;

    RESETDONE_1 <= not reset_i;

    ---------------------------------------------------------------------------
    -- Instantiate RocketIO tile for SGMII or 1000BASE-X PCS/PMA Physical I/F
    ---------------------------------------------------------------------------

    loopback_1_sig         <=  '0' & loopback_1_i;
    loopback_0_sig         <=  '0' & loopback_0_i;

    --EMAC0 and EMAC1 instances
    GT11_DUAL_1000X_inst : GT11_DUAL_1000X
      PORT MAP (
         ENMCOMMAALIGN_1       =>   encommaalign_1_i,
         ENPCOMMAALIGN_1       =>   encommaalign_1_i,
         LOOPBACK_1            =>   loopback_1_sig,
         REFCLK1_1             =>   REFCLK1_i, -- refclk1,  --Erdem
         REFCLK2_1             =>   REFCLK2_i, -- '0', -- Erdem 
         RXCLKCORCNT_1         =>   rxclkcorcnt_1_i,
         RXUSRCLK_1            =>   '0',
         RXUSRCLK2_1           =>   usrclk2,
         RXRESET_1             =>   rx_pcs_reset_1_i,
         RXPMARESET1           =>   rxpmareset1,
         RX1P_1                =>   RXP_1,
         RX1N_1                =>   RXN_1,
         TXCHARDISPMODE_1      =>   txchardispmode_1_i,
         TXCHARDISPVAL_1       =>   txchardispval_1_i,
         TXCHARISK_1           =>   txcharisk_1_i,
         TXDATA_1              =>   mgt_tx_data_1_i,
         TXUSRCLK_1            =>   '1',
         TXUSRCLK2_1           =>   usrclk2,

         ENMCOMMAALIGN_0       =>   encommaalign_0_i,
         ENPCOMMAALIGN_0       =>   encommaalign_0_i,
         LOOPBACK_0            =>   loopback_0_sig,
         REFCLK1_0             =>   REFCLK1_i, --refclk1,  -- Erdem
         REFCLK2_0             =>   REFCLK2_i, -- Erdem '0',    
         RXCLKCORCNT_0         =>   rxclkcorcnt_0_i,
         RXUSRCLK_0            =>   '0',
         RXUSRCLK2_0           =>   usrclk2,
         RXRESET_0             =>   rx_pcs_reset_0_i,
         RXPMARESET0           =>   rxpmareset0,
         RX1P_0                =>   RXP_0,
         RX1N_0                =>   RXN_0,
         TXCHARDISPMODE_0      =>   txchardispmode_0_i,
         TXCHARDISPVAL_0       =>   txchardispval_0_i,
         TXCHARISK_0           =>   txcharisk_0_i,
         TXDATA_0              =>   mgt_tx_data_0_i,
         TXUSRCLK_0            =>   '0',
         TXUSRCLK2_0           =>   usrclk2,
         RXSYNC_0              =>   rxsync_0,

         RXBUFERR_1 	         =>   rxbuferr_1_i,
         RXCHARISCOMMA_1       =>   rxchariscomma_1_i,
         RXCHARISK_1           =>   rxcharisk_1_i,
         RXCOMMADET_1          =>   rxcommadet_1_i,
         RXDATA_1              =>   mgt_rx_data_1_i,
         RXDISPERR_1           =>   rxdisperr_1_i,
         RXNOTINTABLE_1        =>   rxnotintable_1_i,
         RXREALIGN_1           =>   rxrealign_1_i,
         RXRECCLK1_1           =>   open,
         RXRUNDISP_1           =>   rxrundisp_1_i,
         RXSTATUS_1            =>   rxbufstatus_1_i,
         TX_PLLLOCK_1             =>   tx_plllock_1,
         RX_PLLLOCK_1             =>   rx_plllock_1,
         TX1N_1                =>   TXN_1,
         TX1P_1                =>   TXP_1,
         TXBUFERR_1            =>   txbuferr_1_i,
         TXRUNDISP_1           =>   txrundisp_1_i,
         TXOUTCLK1_1           =>   open,
         TXRESET_1             =>   tx_pcs_reset_1_i,
         RXSYNC_1              =>   rxsync_1,

         RXBUFERR_0 	         =>   rxbuferr_0_i,
         RXCHARISCOMMA_0       =>   rxchariscomma_0_i,
         RXCHARISK_0           =>   rxcharisk_0_i,
         RXCOMMADET_0          =>   rxcommadet_0_i,
         RXDATA_0              =>   mgt_rx_data_0_i,
         RXDISPERR_0           =>   rxdisperr_0_i,
         RXNOTINTABLE_0        =>   rxnotintable_0_i,
         RXREALIGN_0           =>   rxrealign_0_i,
         RXRECCLK1_0           =>   open,
         RXRUNDISP_0           =>   rxrundisp_0_i,
         RXSTATUS_0            =>   rxbufstatus_0_i,
         TX_PLLLOCK_0             =>   tx_plllock_0,
         RX_PLLLOCK_0             =>   rx_plllock_0,
         TX1N_0                =>   TXN_0,
         TX1P_0                =>   TXP_0,
         TXBUFERR_0            =>   txbuferr_0_i,
         TXRUNDISP_0           =>   txrundisp_0_i,
         TXOUTCLK1_0           =>   txoutclk1,
         TXRESET_0             =>   tx_pcs_reset_0_i,

         RX_SIGNAL_DETECT_0    =>   '1',
         RX_SIGNAL_DETECT_1    =>   '1',
         PMARESET_TX0          =>   txpmareset0,
         PMARESET_TX1          =>   txpmareset1,
         DCLK                  =>   dclk_bufg,
         DCM_LOCKED            =>   '1'
    );




  -- Implement the reset state machine described in the RocketIO User
  -- Guide (figure 2-18 "Flow Chart of Receiver Reset Sequence Where RX
  -- Buffer is Used" in UG076 v3.0 May 23, 2006)
  reset_receiver0: gt11_init_rx 
     port map (
         clk           => dclk_bufg,
         usrclk2       => usrclk2,
         start_init    => reset_i,
         lock          => rx_plllock_0,
         usrclk_stable => tx_plllock_0,
         pcs_error     => rxbuferr_0_i,
         pma_reset     => rxpmareset0,
         sync          => rxsync_0,
         pcs_reset     => rx_pcs_reset_0_i,
         ready         => rx_rdy0
     );


  -- Implement the reset state machine described in the RocketIO User
  -- Guide (figure 2-13 "Flow Chart ot TX Reset Sequence Where TX Buffer
  -- is Used" in UG076 v3.0 May 23, 2006)
  reset_transmitter0: gt11_init_tx
     port map (
         clk           => dclk_bufg,
         usrclk2       => usrclk2,
         start_init    => reset_i,
         lock          => tx_plllock_0,
         usrclk_stable => tx_plllock_0,
         pcs_error     => txbuferr_0_i,
         pma_reset     => txpmareset0,
         pcs_reset     => tx_pcs_reset_0_i,
         ready         => tx_rdy0
     );


  -- The assertion of RXBUFERR from the GT11 is detected and held static until
  -- The Rx reset state machine (gt11_init) has completed
    process(dclk_bufg,reset_i)
    begin
      if (reset_i = '1') then
         rxbuferr_0 <= '1';
      elsif dclk_bufg'event and dclk_bufg = '1' then
          if (rxbuferr_0_i = '1') then
              rxbuferr_0 <= '1';
          elsif rx_rdy0 = '1' then
              rxbuferr_0 <= '0';
          end if;
      end if;
    end process;

    rxbuferr_cat_0_i <= (rxbuferr_0 & '0');


    emac0_reset <= (not tx_rdy0);

    ---------------------------------------------------------------------------
    -- RocketIO PCS reset circuitry for that attached to EMAC1
    ---------------------------------------------------------------------------

  -- Implement the reset state machine described in the RocketIO User
  -- Guide (figure 2-18 "Flow Chart of Receiver Reset Sequence Where RX
  -- Buffer is Used" in UG076 v3.0 May 23, 2006)
  reset_receiver1: gt11_init_rx
     port map (
         clk           => dclk_bufg,
         usrclk2       => usrclk2,
         start_init    => reset_i,
         lock          => rx_plllock_1,
         usrclk_stable => tx_plllock_1,
         pcs_error     => rxbuferr_1_i,
         pma_reset     => rxpmareset1,
         sync          => rxsync_1,
         pcs_reset     => rx_pcs_reset_1_i,
         ready         => rx_rdy1
     );


  -- Implement the reset state machine described in the RocketIO User
  -- Guide (figure 2-13 "Flow Chart ot TX Reset Sequence Where TX Buffer
  -- is Used" in UG076 v3.0 May 23, 2006)
  reset_transmitter1: gt11_init_tx
     port map (
         clk           => dclk_bufg,
         usrclk2       => usrclk2,
         start_init    => reset_i,
         lock          => tx_plllock_1,
         usrclk_stable => tx_plllock_1,
         pcs_error     => txbuferr_1_i,
         pma_reset     => txpmareset1,
         pcs_reset     => tx_pcs_reset_1_i,
         ready         => tx_rdy1
     );


  -- The assertion of RXBUFERR from the GT11 is detected and held static until
  -- The Rx reset state machine (gt11_init) has completed
    process(dclk_bufg,reset_i)
    begin
      if (reset_i = '1' ) then
         rxbuferr_1 <= '1';
      elsif dclk_bufg'event and dclk_bufg = '1' then
        if (rxbuferr_1_i = '1') then
            rxbuferr_1 <= '1';
        elsif rx_rdy1 = '1' then
            rxbuferr_1 <= '0';
        end if;
      end if;
    end process;

    rxbuferr_cat_1_i <= (rxbuferr_1 & '0');


    emac1_reset <= (not tx_rdy1);


  --emac_reset <= emac0_reset or emac1_reset or reset_i;
  emac_reset <= emac0_reset or reset_i;

  --txpmareset <= txpmareset0 or txpmareset1;






    ----------------------------------------------------------------------
    -- Virtex4 Rocket I/O Clock Management
    ----------------------------------------------------------------------

    -- The RocketIO transceivers are available in pairs with shared
    -- clock resources

--    GT11CLK_MGT_inst : GT11CLK_MGT  Erdem
--    GENERIC MAP (
--         SYNCLK1OUTEN   =>   "ENABLE",
--         SYNCLK2OUTEN   =>   "DISABLE")
--    PORT MAP (
--         SYNCLK1OUT     =>    refclk1,
--         SYNCLK2OUT     =>    open,
--         MGTCLKN        =>    MGTCLK_N,
--         MGTCLKP        =>    MGTCLK_P);



    -- refclk1 is obtained from the GT11 clock module at 250MHz.

    -- refclk1 is globally buffered to be used as a reference clock for the 
    -- Client DCM reset logic
    synclk1out_bufg  : BUFG port map (I => REFCLK1_i, O => refclk1_bufg); -- Erdem 

    -- Dynamic Reconfiguration Port Clock
    -- Must be between 25MHz - 50 MHz
    --***mrmwbufg_dclk  : BUFG port map (I => DCLK, O => dclk_bufg);
    dclk_bufg <= DCLK; 
    
    -- Clock provided for GT11
    -- Must be between 25MHz - 50 MHz
    --***bufg_userclk2  : BUFG port map (I => txoutclk1, O => usrclk2);
    usrclk2 <= txoutclk1;

    --EMAC0: PLL locks and Synchronisation status
    -- Erdem sync0_obuf : OBUF port map (I => sync_acq_status_0_i, O => EMAC0CLIENTSYNCACQSTATUS);
    EMAC0CLIENTSYNCACQSTATUS <= sync_acq_status_0_i; -- Erdem 
	-- Erdem emac_locked_0_i          <= tx_rdy0 and tx_client_dcm_locked_0_i;
    emac_locked_0_i          <= tx_rdy0 and tx_client_dcm_locked_0_i; -- Erdem 
	 
    -- Erdem sync1_obuf : OBUF port map (I => sync_acq_status_1_i, O => EMAC1CLIENTSYNCACQSTATUS);
    EMAC1CLIENTSYNCACQSTATUS <= sync_acq_status_1_i; -- Erdem 
	 -- Erdem emac_locked_1_i          <= tx_rdy1 and tx_client_dcm_locked_0_i;
    emac_locked_1_i          <= tx_rdy1; -- Erdem

    --------------------------------------------------------------------------
    -- GTX_CLK Clock Management for EMAC1
    -- (Connected to PHYEMAC0GTXCLK of the EMAC primitive)
    --------------------------------------------------------------------------
    gtx_clk_ibufg_0_i        <= usrclk2;


    --------------------------------------------------------------------------
    -- GTX_CLK Clock Management for EMAC1
    -- (Connected to PHYEMAC1GTXCLK of the EMAC primitive)
    --------------------------------------------------------------------------
    gtx_clk_ibufg_1_i        <= usrclk2;


    --------------------------------------------------------------------------
    -- Receive and Transmit Client Clock Management when configured in
    -- 16-bit mode
    --------------------------------------------------------------------------
    tx_client_dcm : DCM_BASE
    generic map (
                 CLKOUT_PHASE_SHIFT => "FIXED",
                 PHASE_SHIFT => 5
                )
    port map(
        CLKIN    => dcm_clkin,
        CLKFB    => dcm_clk0_bufg,
        RST      => dcm_reset_0_i,
        CLK0     => dcm_clk0_out,
        CLK90    => open,
        CLK180   => open,
        CLK270   => open,
        CLK2X    => open,
        CLK2X180 => open,
        CLKDV    => dcm_clkdv_out,
        CLKFX    => open,
        CLKFX180 => open,
        LOCKED   => tx_client_dcm_locked_0_i
        );

   -- Synchronize the reset with dcm_clkin. This is done to meet the reset requirements
   -- of DCM that the reset should be asserted for atleast 3 CLKIN cycles. 
    reset_dcm_0: process (dcm_clkin, reset_i)
    begin
        if reset_i = '1' then
            dcm_reset_0_r1  <= '1';
            dcm_reset_0_r2  <= '1';
            dcm_reset_0_i   <= '1';
        elsif dcm_clkin'event and dcm_clkin = '1' then
            dcm_reset_0_r1  <= RESET_200MS_IN;
            dcm_reset_0_r2  <= dcm_reset_0_r1;
            dcm_reset_0_i   <= dcm_reset_0_r2;
        end if;
    end process reset_dcm_0;

    -----------------------------------------------------------------------------
    -- Tx Client DCM Reset Logic for EMAC0 and EMAC1
    -----------------------------------------------------------------------------
    -- The component instatiation for the DCM Reset Module.  This generates a
    -- DCM reset signal based on DCM loss of lock
    -- ref_clk for the reset logic is the globally buffered 250MHz SYNCCLK1OUT 
    -- from the GT11CLK_MGT block.
   
    tx_client_dcm_reset : dcm_reset 
     port map (
       ref_reset   => reset_i,
       ref_clk     => refclk1_bufg,
       dcm_locked  => tx_client_dcm_locked_0_i,
       dcm_reset   => RESET_200MS
     ); 

    tx_client_clk_in_0_bufg : BUFG
    port map(
       I => tx_client_clk_out_0_i,
        O => dcm_clkin
        );

    tx_client_clk_out_0_bufg : BUFG
    port map(
        I => dcm_clk0_out,
        O => dcm_clk0_bufg
        );

    tx_client_clk_in_div2_0_bufg : BUFG
    port map(
        I => dcm_clkdv_out,
        O => dcm_clkdv_bufg
        );


    tx_client_clk_in_div2_0_i <= dcm_clkdv_bufg;
    tx_client_clk_in_0_i      <= dcm_clk0_bufg;
    rx_client_clk_in_div2_0_i <= dcm_clkdv_bufg;
    rx_client_clk_in_0_i      <= dcm_clk0_bufg;

    tx_client_clk_in_div2_1_i <= dcm_clkdv_bufg;
    tx_client_clk_in_1_i      <= dcm_clk0_bufg;
    rx_client_clk_in_div2_1_i <= dcm_clkdv_bufg;
    rx_client_clk_in_1_i      <= dcm_clk0_bufg;


    --------------------------------------------------------------------------
    -- Connect previously derived client clocks to example design output ports
    --------------------------------------------------------------------------
    RX_CLIENT_CLK_0 <= rx_client_clk_in_div2_0_i;
    TX_CLIENT_CLK_0 <= tx_client_clk_in_div2_0_i;
    RX_CLIENT_CLK_1 <= rx_client_clk_in_div2_1_i;
    TX_CLIENT_CLK_1 <= tx_client_clk_in_div2_1_i;


    --------------------------------------------------------------------------
    -- Instantiate the EMAC Wrapper (eth2x16.vhd)
    --------------------------------------------------------------------------
    v4_emac_top : eth2x16
    port map (
        -- Client Receiver Interface - EMAC0
        EMAC0CLIENTRXCLIENTCLKOUT       => rx_client_clk_out_0_i,
        CLIENTEMAC0RXCLIENTCLKIN        => rx_client_clk_in_0_i,
        CLIENTEMAC0RXCLIENTCLKINDIV2    => rx_client_clk_in_div2_0_i,
        EMAC0CLIENTRXD                  => EMAC0CLIENTRXD,
        EMAC0CLIENTRXDVLD               => EMAC0CLIENTRXDVLD,
        EMAC0CLIENTRXDVLDMSW            => EMAC0CLIENTRXDVLDMSW,
        EMAC0CLIENTRXGOODFRAME          => EMAC0CLIENTRXGOODFRAME,
        EMAC0CLIENTRXBADFRAME           => EMAC0CLIENTRXBADFRAME,
        EMAC0CLIENTRXFRAMEDROP          => EMAC0CLIENTRXFRAMEDROP,
        EMAC0CLIENTRXDVREG6             => open,
        EMAC0CLIENTRXSTATS              => EMAC0CLIENTRXSTATS,
        EMAC0CLIENTRXSTATSVLD           => EMAC0CLIENTRXSTATSVLD,
        EMAC0CLIENTRXSTATSBYTEVLD       => EMAC0CLIENTRXSTATSBYTEVLD,

        -- Client Transmitter Interface - EMAC0
        EMAC0CLIENTTXCLIENTCLKOUT       => tx_client_clk_out_0_i,
        CLIENTEMAC0TXCLIENTCLKIN        => tx_client_clk_in_0_i,
        CLIENTEMAC0TXCLIENTCLKINDIV2    => tx_client_clk_in_div2_0_i,
        CLIENTEMAC0TXD                  => CLIENTEMAC0TXD,
        CLIENTEMAC0TXDVLD               => CLIENTEMAC0TXDVLD,
        CLIENTEMAC0TXDVLDMSW            => CLIENTEMAC0TXDVLDMSW,
        EMAC0CLIENTTXACK                => EMAC0CLIENTTXACK,
        CLIENTEMAC0TXFIRSTBYTE          => CLIENTEMAC0TXFIRSTBYTE,
        CLIENTEMAC0TXUNDERRUN           => CLIENTEMAC0TXUNDERRUN,
        EMAC0CLIENTTXCOLLISION          => EMAC0CLIENTTXCOLLISION,
        EMAC0CLIENTTXRETRANSMIT         => EMAC0CLIENTTXRETRANSMIT,
        CLIENTEMAC0TXIFGDELAY           => CLIENTEMAC0TXIFGDELAY,
        EMAC0CLIENTTXSTATS              => EMAC0CLIENTTXSTATS,
        EMAC0CLIENTTXSTATSVLD           => EMAC0CLIENTTXSTATSVLD,
        EMAC0CLIENTTXSTATSBYTEVLD       => EMAC0CLIENTTXSTATSBYTEVLD,

        -- MAC Control Interface - EMAC0
        CLIENTEMAC0PAUSEREQ             => CLIENTEMAC0PAUSEREQ,
        CLIENTEMAC0PAUSEVAL             => CLIENTEMAC0PAUSEVAL,

        -- Clock Signals - EMAC0
        GTX_CLK_0                       => gtx_clk_ibufg_0_i,
        EMAC0CLIENTTXGMIIMIICLKOUT      => open,
        CLIENTEMAC0TXGMIIMIICLKIN       => gnd_i,

        -- 1000BASE-X PCS/PMA Interface - EMAC0
        RXDATA_0                        => mgt_rx_data_0_i,
        TXDATA_0                        => mgt_tx_data_0_i,
        DCM_LOCKED_0                    => emac_locked_0_i,
        AN_INTERRUPT_0                  => an_interrupt_0_i,
        SIGNAL_DETECT_0                 => '1',
        PHYAD_0                         => PHYAD_0,
        ENCOMMAALIGN_0                  => encommaalign_0_i,
        LOOPBACKMSB_0                   => loopback_0_i,
        MGTRXRESET_0                    => mgt_rx_reset_0_i,
        MGTTXRESET_0                    => mgt_tx_reset_0_i,
        POWERDOWN_0                     => powerdown_0_i,
        SYNCACQSTATUS_0                 => sync_acq_status_0_i,
        RXCLKCORCNT_0                   => rxclkcorcnt_0_i,
        RXBUFSTATUS_0                   => rxbuferr_cat_0_i(1 downto 0),
        RXBUFERR_0                      => '0',
        RXCHARISCOMMA_0                 => rxchariscomma_0_i,
        RXCHARISK_0                     => rxcharisk_0_i,
        RXCHECKINGCRC_0                 => '0',
        RXCOMMADET_0                    => '0',
        RXDISPERR_0                     => rxdisperr_0_i,
        RXLOSSOFSYNC_0                  => (others=>'0'),
        RXNOTINTABLE_0                  => rxnotintable_0_i,
        RXREALIGN_0                     => rxrealign_0_i,
        RXRUNDISP_0                     => rxrundisp_0_i,
        TXBUFERR_0                      => txbuferr_0_i,
        TXCHARDISPMODE_0                => txchardispmode_0_i,
        TXCHARDISPVAL_0                 => txchardispval_0_i,
        TXCHARISK_0                     => txcharisk_0_i,
        TXRUNDISP_0                     => txrundisp_0_i,

        -- MDIO Interface - EMAC0
        MDC_0                           => mdc_out_0_i,
        MDIO_IN_0                       => mdio_in_0_i,
        MDIO_OUT_0                      => mdio_out_0_i,
        MDIO_TRI_0                      => mdio_tri_0_i,

        -- Client Receiver Interface - EMAC1
        EMAC1CLIENTRXCLIENTCLKOUT       => rx_client_clk_out_1_i,
        CLIENTEMAC1RXCLIENTCLKIN        => rx_client_clk_in_1_i,
        CLIENTEMAC1RXCLIENTCLKINDIV2    => rx_client_clk_in_div2_1_i,
        EMAC1CLIENTRXD                  => EMAC1CLIENTRXD,
        EMAC1CLIENTRXDVLD               => EMAC1CLIENTRXDVLD,
        EMAC1CLIENTRXDVLDMSW            => EMAC1CLIENTRXDVLDMSW,
        EMAC1CLIENTRXGOODFRAME          => EMAC1CLIENTRXGOODFRAME,
        EMAC1CLIENTRXBADFRAME           => EMAC1CLIENTRXBADFRAME,
        EMAC1CLIENTRXFRAMEDROP          => EMAC1CLIENTRXFRAMEDROP,
        EMAC1CLIENTRXDVREG6             => open,
        EMAC1CLIENTRXSTATS              => EMAC1CLIENTRXSTATS,
        EMAC1CLIENTRXSTATSVLD           => EMAC1CLIENTRXSTATSVLD,
        EMAC1CLIENTRXSTATSBYTEVLD       => EMAC1CLIENTRXSTATSBYTEVLD,

        -- Client Transmitter Interface - EMAC1
        EMAC1CLIENTTXCLIENTCLKOUT       => tx_client_clk_out_1_i,
        CLIENTEMAC1TXCLIENTCLKIN        => tx_client_clk_in_1_i,
        CLIENTEMAC1TXCLIENTCLKINDIV2    => tx_client_clk_in_div2_1_i,
        CLIENTEMAC1TXD                  => CLIENTEMAC1TXD,
        CLIENTEMAC1TXDVLD               => CLIENTEMAC1TXDVLD,
        CLIENTEMAC1TXDVLDMSW            => CLIENTEMAC1TXDVLDMSW,
        EMAC1CLIENTTXACK                => EMAC1CLIENTTXACK,
        CLIENTEMAC1TXFIRSTBYTE          => CLIENTEMAC1TXFIRSTBYTE,
        CLIENTEMAC1TXUNDERRUN           => CLIENTEMAC1TXUNDERRUN,
        EMAC1CLIENTTXCOLLISION          => EMAC1CLIENTTXCOLLISION,
        EMAC1CLIENTTXRETRANSMIT         => EMAC1CLIENTTXRETRANSMIT,
        CLIENTEMAC1TXIFGDELAY           => CLIENTEMAC1TXIFGDELAY,
        EMAC1CLIENTTXSTATS              => EMAC1CLIENTTXSTATS,
        EMAC1CLIENTTXSTATSVLD           => EMAC1CLIENTTXSTATSVLD,
        EMAC1CLIENTTXSTATSBYTEVLD       => EMAC1CLIENTTXSTATSBYTEVLD,

        -- MAC Control Interface - EMAC1
        CLIENTEMAC1PAUSEREQ             => CLIENTEMAC1PAUSEREQ,
        CLIENTEMAC1PAUSEVAL             => CLIENTEMAC1PAUSEVAL,

        -- Clock Signals - EMAC1
        GTX_CLK_1                       => gtx_clk_ibufg_1_i,
        EMAC1CLIENTTXGMIIMIICLKOUT      => open,
        CLIENTEMAC1TXGMIIMIICLKIN       => gnd_i,

        -- 1000BASE-X PCS/PMA Interface - EMAC1
        RXDATA_1                        => mgt_rx_data_1_i,
        TXDATA_1                        => mgt_tx_data_1_i,
        DCM_LOCKED_1                    => emac_locked_1_i,
        AN_INTERRUPT_1                  => an_interrupt_1_i,
        SIGNAL_DETECT_1                 => '1',
        PHYAD_1                         => PHYAD_1,
        ENCOMMAALIGN_1                  => encommaalign_1_i,
        LOOPBACKMSB_1                   => loopback_1_i,
        MGTRXRESET_1                    => mgt_rx_reset_1_i,
        MGTTXRESET_1                    => mgt_tx_reset_1_i,
        POWERDOWN_1                     => powerdown_1_i,
        SYNCACQSTATUS_1                 => sync_acq_status_1_i,
        RXCLKCORCNT_1                   => rxclkcorcnt_1_i,
        RXBUFSTATUS_1                   => rxbuferr_cat_1_i(1 downto 0),
        RXBUFERR_1                      => '0',
        RXCHARISCOMMA_1                 => rxchariscomma_1_i,
        RXCHARISK_1                     => rxcharisk_1_i,
        RXCHECKINGCRC_1                 => '0',
        RXCOMMADET_1                    => '0',
        RXDISPERR_1                     => rxdisperr_1_i,
        RXLOSSOFSYNC_1                  => (others => '0'),
        RXNOTINTABLE_1                  => rxnotintable_1_i,
        RXREALIGN_1                     => rxrealign_1_i,
        RXRUNDISP_1                     => rxrundisp_1_i,
        TXBUFERR_1                      => txbuferr_1_i,
        TXCHARDISPMODE_1                => txchardispmode_1_i,
        TXCHARDISPVAL_1                 => txchardispval_1_i,
        TXCHARISK_1                     => txcharisk_1_i,
        TXRUNDISP_1                     => txrundisp_1_i,

        -- MDIO Interface - EMAC1
        MDC_1                           => mdc_out_1_i,
        MDIO_IN_1                       => mdio_in_1_i,
        MDIO_OUT_1                      => mdio_out_1_i,
        MDIO_TRI_1                      => mdio_tri_1_i,

        -- Host Interface
        HOSTOPCODE                      => HOSTOPCODE,
        HOSTREQ                         => HOSTREQ,
        HOSTMIIMSEL                     => HOSTMIIMSEL,
        HOSTADDR                        => HOSTADDR,
        HOSTWRDATA                      => HOSTWRDATA,
        HOSTMIIMRDY                     => HOSTMIIMRDY,
        HOSTRDDATA                      => HOSTRDDATA,
        HOSTEMAC1SEL                    => HOSTEMAC1SEL,
        HOSTCLK                         => HOSTCLK,


        -- Asynchronous Reset
        RESET                           => emac_reset
        );


  ----------------------------------------------------------------------
  -- MDIO interface for EMAC0
  ----------------------------------------------------------------------
  -- This example keeps the mdio_in, mdio_out, mdio_tri signals as
  -- separate connections: these could be connected to an external
  -- Tri-state buffer.  Alternatively they could be connected to a
  -- Tri-state buffer in a Xilinx IOB and an appropriate SelectIO
  -- standard chosen.

  MDC_0       <= mdc_out_0_i;
  mdio_in_0_i <= MDIO_0_I;
  MDIO_0_O  <= mdio_out_0_i;
  MDIO_0_T  <= mdio_tri_0_i;



  ----------------------------------------------------------------------
  -- MDIO interface for EMAC1
  ----------------------------------------------------------------------
  -- This example keeps the mdio_in, mdio_out, mdio_tri signals as
  -- separate connections: these could be connected to an external
  -- Tri-state buffer.  Alternatively they could be connected to a
  -- Tri-state buffer in a Xilinx IOB and an appropriate SelectIO
  -- standard chosen.

  MDC_1       <= mdc_out_1_i;
  mdio_in_1_i <= MDIO_1_I;
  MDIO_1_O  <= mdio_out_1_i;
  MDIO_1_T  <= mdio_tri_1_i;


  -- The Host clock (HOSTCLK on EMAC primitive) must always be driven.
  -- In this example design it is kept as a standalone signal.  However,
  -- this can be shared with one of the other clock sources, for
  -- example, one of the 125MHz PHYEMAC#GTX clock inputs.

  -- host_clk : IBUF port map (I => HOSTCLK, O => host_clk_i);
  
  host_clk_i <= HOSTCLK;
    





end TOP_LEVEL;
