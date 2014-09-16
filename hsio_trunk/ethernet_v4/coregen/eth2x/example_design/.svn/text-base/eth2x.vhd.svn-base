-------------------------------------------------------------------------------
-- Title      : Virtex-4 FX Ethernet MAC Wrapper
-------------------------------------------------------------------------------
-- File       : eth2x.vhd
-- Author     : Xilinx
-------------------------------------------------------------------------------
-- Copyright (c) 2004-2005 by Xilinx, Inc. All rights reserved.
-- This text/file contains proprietary, confidential
-- information of Xilinx, Inc., is distributed under license
-- from Xilinx, Inc., and may be used, copied and/or
-- disclosed only pursuant to the terms of a valid license
-- agreement with Xilinx, Inc. Xilinx hereby grants you
-- a license to use this text/file solely for design, simulation,
-- implementation and creation of design files limited
-- to Xilinx devices or technologies. Use with non-Xilinx
-- devices or technologies is expressly prohibited and
-- immediately terminates your license unless covered by
-- a separate agreement.
--
-- Xilinx is providing this design, code, or information
-- "as is" solely for use in developing programs and
-- solutions for Xilinx devices. By providing this design,
-- code, or information as one possible implementation of
-- this feature, application or standard, Xilinx is making no
-- representation that this implementation is free from any
-- claims of infringement. You are responsible for
-- obtaining any rights you may require for your implementation.
-- Xilinx expressly disclaims any warranty whatsoever with
-- respect to the adequacy of the implementation, including
-- but not limited to any warranties or representations that this
-- implementation is free from claims of infringement, implied
-- warranties of merchantability or fitness for a particular
-- purpose.
--
-- Xilinx products are not intended for use in life support
-- appliances, devices, or systems. Use in such applications are
-- expressly prohibited.
--
-- This copyright and support notice must be retained as part
-- of this text at all times. (c) Copyright 2004-2005 Xilinx, Inc.
-- All rights reserved.

--------------------------------------------------------------------------------
-- Description:  This wrapper file instantiates the full Virtex-4 FX Ethernet 
--               MAC (EMAC) primitive.  For one or both of the two Ethernet MACs
--               (EMAC0/EMAC1):
--
--               * all unused input ports on the primitive will be tied to the
--                 appropriate logic level;
--
--               * all unused output ports on the primitive will be left 
--                 unconnected;
--
--               * the Tie-off Vector will be connected based on the options 
--                 selected from CORE Generator;
--
--               * only used ports will be connected to the ports of this 
--                 wrapper file.
--
--               This simplified wrapper should therefore be used as the 
--               instantiation template for the EMAC in customer designs.
--------------------------------------------------------------------------------

library unisim;
use unisim.vcomponents.all;

library ieee;
use ieee.std_logic_1164.all;

--------------------------------------------------------------------------------
-- The entity declaration for the Virtex-4 FX Embedded Ethernet MAC wrapper.
--------------------------------------------------------------------------------

entity eth2x is
    port(
        -- Client Receiver Interface - EMAC0
        EMAC0CLIENTRXCLIENTCLKOUT       : out std_logic;
        CLIENTEMAC0RXCLIENTCLKIN        : in  std_logic;
        EMAC0CLIENTRXD                  : out std_logic_vector(7 downto 0);
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
        CLIENTEMAC0TXD                  : in  std_logic_vector(7 downto 0);
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

        -- Clock Signal - EMAC0
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
        TXRUNDISP_0                     : in  std_logic;

        -- MDIO Interface - EMAC0
        MDC_0                           : out std_logic;
        MDIO_IN_0                       : in  std_logic;
        MDIO_OUT_0                      : out std_logic;
        MDIO_TRI_0                      : out std_logic;

        -- Client Receiver Interface - EMAC1
        EMAC1CLIENTRXCLIENTCLKOUT       : out std_logic;
        CLIENTEMAC1RXCLIENTCLKIN        : in  std_logic;
        EMAC1CLIENTRXD                  : out std_logic_vector(7 downto 0);
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
        CLIENTEMAC1TXD                  : in  std_logic_vector(7 downto 0);
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

        -- Clock Signal - EMAC1
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
        TXRUNDISP_1                     : in  std_logic;

        -- MDIO Interface - EMAC1
        MDC_1                           : out std_logic;
        MDIO_IN_1                       : in  std_logic;
        MDIO_OUT_1                      : out std_logic;
        MDIO_TRI_1                      : out std_logic;

        -- Host Interface
        HOSTOPCODE                      : in  std_logic_vector(1 downto 0);
        HOSTREQ                         : in  std_logic;
        HOSTMIIMSEL                     : in  std_logic;
        HOSTADDR                        : in  std_logic_vector(9 downto 0);
        HOSTWRDATA                      : in  std_logic_vector(31 downto 0);
        HOSTMIIMRDY                     : out std_logic;
        HOSTRDDATA                      : out std_logic_vector(31 downto 0);
        HOSTEMAC1SEL                    : in  std_logic;

        HOSTCLK                         : in  std_logic;


        -- Asynchronous Reset
        RESET                           : in  std_logic
        );

end eth2x;



architecture WRAPPER of eth2x is


    ----------------------------------------------------------------------------
    -- Component Declaration for the Virtex-4 FX Embedded Ethernet MAC
    ----------------------------------------------------------------------------

    component EMAC is
    port (
		DCRHOSTDONEIR : out std_ulogic;
		EMAC0CLIENTANINTERRUPT : out std_ulogic;
		EMAC0CLIENTRXBADFRAME : out std_ulogic;
		EMAC0CLIENTRXCLIENTCLKOUT : out std_ulogic;
		EMAC0CLIENTRXD : out std_logic_vector(15 downto 0);
		EMAC0CLIENTRXDVLD : out std_ulogic;
		EMAC0CLIENTRXDVLDMSW : out std_ulogic;
		EMAC0CLIENTRXDVREG6 : out std_ulogic;
		EMAC0CLIENTRXFRAMEDROP : out std_ulogic;
		EMAC0CLIENTRXGOODFRAME : out std_ulogic;
		EMAC0CLIENTRXSTATS : out std_logic_vector(6 downto 0);
		EMAC0CLIENTRXSTATSBYTEVLD : out std_ulogic;
		EMAC0CLIENTRXSTATSVLD : out std_ulogic;
		EMAC0CLIENTTXACK : out std_ulogic;
		EMAC0CLIENTTXCLIENTCLKOUT : out std_ulogic;
		EMAC0CLIENTTXCOLLISION : out std_ulogic;
		EMAC0CLIENTTXGMIIMIICLKOUT : out std_ulogic;
		EMAC0CLIENTTXRETRANSMIT : out std_ulogic;
		EMAC0CLIENTTXSTATS : out std_ulogic;
		EMAC0CLIENTTXSTATSBYTEVLD : out std_ulogic;
		EMAC0CLIENTTXSTATSVLD : out std_ulogic;
		EMAC0PHYENCOMMAALIGN : out std_ulogic;
		EMAC0PHYLOOPBACKMSB : out std_ulogic;
		EMAC0PHYMCLKOUT : out std_ulogic;
		EMAC0PHYMDOUT : out std_ulogic;
		EMAC0PHYMDTRI : out std_ulogic;
		EMAC0PHYMGTRXRESET : out std_ulogic;
		EMAC0PHYMGTTXRESET : out std_ulogic;
		EMAC0PHYPOWERDOWN : out std_ulogic;
		EMAC0PHYSYNCACQSTATUS : out std_ulogic;
		EMAC0PHYTXCHARDISPMODE : out std_ulogic;
		EMAC0PHYTXCHARDISPVAL : out std_ulogic;
		EMAC0PHYTXCHARISK : out std_ulogic;
		EMAC0PHYTXCLK : out std_ulogic;
		EMAC0PHYTXD : out std_logic_vector(7 downto 0);
		EMAC0PHYTXEN : out std_ulogic;
		EMAC0PHYTXER : out std_ulogic;
		EMAC1CLIENTANINTERRUPT : out std_ulogic;
		EMAC1CLIENTRXBADFRAME : out std_ulogic;
		EMAC1CLIENTRXCLIENTCLKOUT : out std_ulogic;
		EMAC1CLIENTRXD : out std_logic_vector(15 downto 0);
		EMAC1CLIENTRXDVLD : out std_ulogic;
		EMAC1CLIENTRXDVLDMSW : out std_ulogic;
		EMAC1CLIENTRXDVREG6 : out std_ulogic;
		EMAC1CLIENTRXFRAMEDROP : out std_ulogic;
		EMAC1CLIENTRXGOODFRAME : out std_ulogic;
		EMAC1CLIENTRXSTATS : out std_logic_vector(6 downto 0);
		EMAC1CLIENTRXSTATSBYTEVLD : out std_ulogic;
		EMAC1CLIENTRXSTATSVLD : out std_ulogic;
		EMAC1CLIENTTXACK : out std_ulogic;
		EMAC1CLIENTTXCLIENTCLKOUT : out std_ulogic;
		EMAC1CLIENTTXCOLLISION : out std_ulogic;
		EMAC1CLIENTTXGMIIMIICLKOUT : out std_ulogic;
		EMAC1CLIENTTXRETRANSMIT : out std_ulogic;
		EMAC1CLIENTTXSTATS : out std_ulogic;
		EMAC1CLIENTTXSTATSBYTEVLD : out std_ulogic;
		EMAC1CLIENTTXSTATSVLD : out std_ulogic;
		EMAC1PHYENCOMMAALIGN : out std_ulogic;
		EMAC1PHYLOOPBACKMSB : out std_ulogic;
		EMAC1PHYMCLKOUT : out std_ulogic;
		EMAC1PHYMDOUT : out std_ulogic;
		EMAC1PHYMDTRI : out std_ulogic;
		EMAC1PHYMGTRXRESET : out std_ulogic;
		EMAC1PHYMGTTXRESET : out std_ulogic;
		EMAC1PHYPOWERDOWN : out std_ulogic;
		EMAC1PHYSYNCACQSTATUS : out std_ulogic;
		EMAC1PHYTXCHARDISPMODE : out std_ulogic;
		EMAC1PHYTXCHARDISPVAL : out std_ulogic;
		EMAC1PHYTXCHARISK : out std_ulogic;
		EMAC1PHYTXCLK : out std_ulogic;
		EMAC1PHYTXD : out std_logic_vector(7 downto 0);
		EMAC1PHYTXEN : out std_ulogic;
		EMAC1PHYTXER : out std_ulogic;
		EMACDCRACK : out std_ulogic;
		EMACDCRDBUS : out std_logic_vector(0 to 31);
		HOSTMIIMRDY : out std_ulogic;
		HOSTRDDATA : out std_logic_vector(31 downto 0);

		CLIENTEMAC0DCMLOCKED : in std_ulogic;
		CLIENTEMAC0PAUSEREQ : in std_ulogic;
		CLIENTEMAC0PAUSEVAL : in std_logic_vector(15 downto 0);
		CLIENTEMAC0RXCLIENTCLKIN : in std_ulogic;
		CLIENTEMAC0TXCLIENTCLKIN : in std_ulogic;
		CLIENTEMAC0TXD : in std_logic_vector(15 downto 0);
		CLIENTEMAC0TXDVLD : in std_ulogic;
		CLIENTEMAC0TXDVLDMSW : in std_ulogic;
		CLIENTEMAC0TXFIRSTBYTE : in std_ulogic;
		CLIENTEMAC0TXGMIIMIICLKIN : in std_ulogic;
		CLIENTEMAC0TXIFGDELAY : in std_logic_vector(7 downto 0);
		CLIENTEMAC0TXUNDERRUN : in std_ulogic;
		CLIENTEMAC1DCMLOCKED : in std_ulogic;
		CLIENTEMAC1PAUSEREQ : in std_ulogic;
		CLIENTEMAC1PAUSEVAL : in std_logic_vector(15 downto 0);
		CLIENTEMAC1RXCLIENTCLKIN : in std_ulogic;
		CLIENTEMAC1TXCLIENTCLKIN : in std_ulogic;
		CLIENTEMAC1TXD : in std_logic_vector(15 downto 0);
		CLIENTEMAC1TXDVLD : in std_ulogic;
		CLIENTEMAC1TXDVLDMSW : in std_ulogic;
		CLIENTEMAC1TXFIRSTBYTE : in std_ulogic;
		CLIENTEMAC1TXGMIIMIICLKIN : in std_ulogic;
		CLIENTEMAC1TXIFGDELAY : in std_logic_vector(7 downto 0);
		CLIENTEMAC1TXUNDERRUN : in std_ulogic;
		DCREMACABUS : in std_logic_vector(8 to 9);
		DCREMACCLK : in std_ulogic;
		DCREMACDBUS : in std_logic_vector(0 to 31);
		DCREMACENABLE : in std_ulogic;
		DCREMACREAD : in std_ulogic;
		DCREMACWRITE : in std_ulogic;
		HOSTADDR : in std_logic_vector(9 downto 0);
		HOSTCLK : in std_ulogic;
		HOSTEMAC1SEL : in std_ulogic;
		HOSTMIIMSEL : in std_ulogic;
		HOSTOPCODE : in std_logic_vector(1 downto 0);
		HOSTREQ : in std_ulogic;
		HOSTWRDATA : in std_logic_vector(31 downto 0);
		PHYEMAC0COL : in std_ulogic;
		PHYEMAC0CRS : in std_ulogic;
		PHYEMAC0GTXCLK : in std_ulogic;
		PHYEMAC0MCLKIN : in std_ulogic;
		PHYEMAC0MDIN : in std_ulogic;
		PHYEMAC0MIITXCLK : in std_ulogic;
		PHYEMAC0PHYAD : in std_logic_vector(4 downto 0);
		PHYEMAC0RXBUFERR : in std_ulogic;
		PHYEMAC0RXBUFSTATUS : in std_logic_vector(1 downto 0);
		PHYEMAC0RXCHARISCOMMA : in std_ulogic;
		PHYEMAC0RXCHARISK : in std_ulogic;
		PHYEMAC0RXCHECKINGCRC : in std_ulogic;
		PHYEMAC0RXCLK : in std_ulogic;
		PHYEMAC0RXCLKCORCNT : in std_logic_vector(2 downto 0);
		PHYEMAC0RXCOMMADET : in std_ulogic;
		PHYEMAC0RXD : in std_logic_vector(7 downto 0);
		PHYEMAC0RXDISPERR : in std_ulogic;
		PHYEMAC0RXDV : in std_ulogic;
		PHYEMAC0RXER : in std_ulogic;
		PHYEMAC0RXLOSSOFSYNC : in std_logic_vector(1 downto 0);
		PHYEMAC0RXNOTINTABLE : in std_ulogic;
		PHYEMAC0RXRUNDISP : in std_ulogic;
		PHYEMAC0SIGNALDET : in std_ulogic;
		PHYEMAC0TXBUFERR : in std_ulogic;
		PHYEMAC1COL : in std_ulogic;
		PHYEMAC1CRS : in std_ulogic;
		PHYEMAC1GTXCLK : in std_ulogic;
		PHYEMAC1MCLKIN : in std_ulogic;
		PHYEMAC1MDIN : in std_ulogic;
		PHYEMAC1MIITXCLK : in std_ulogic;
		PHYEMAC1PHYAD : in std_logic_vector(4 downto 0);
		PHYEMAC1RXBUFERR : in std_ulogic;
		PHYEMAC1RXBUFSTATUS : in std_logic_vector(1 downto 0);
		PHYEMAC1RXCHARISCOMMA : in std_ulogic;
		PHYEMAC1RXCHARISK : in std_ulogic;
		PHYEMAC1RXCHECKINGCRC : in std_ulogic;
		PHYEMAC1RXCLK : in std_ulogic;
		PHYEMAC1RXCLKCORCNT : in std_logic_vector(2 downto 0);
		PHYEMAC1RXCOMMADET : in std_ulogic;
		PHYEMAC1RXD : in std_logic_vector(7 downto 0);
		PHYEMAC1RXDISPERR : in std_ulogic;
		PHYEMAC1RXDV : in std_ulogic;
		PHYEMAC1RXER : in std_ulogic;
		PHYEMAC1RXLOSSOFSYNC : in std_logic_vector(1 downto 0);
		PHYEMAC1RXNOTINTABLE : in std_ulogic;
		PHYEMAC1RXRUNDISP : in std_ulogic;
		PHYEMAC1SIGNALDET : in std_ulogic;
		PHYEMAC1TXBUFERR : in std_ulogic;
		RESET : in std_ulogic;
		TIEEMAC0CONFIGVEC : in std_logic_vector(79 downto 0);
		TIEEMAC0UNICASTADDR : in std_logic_vector(47 downto 0);
		TIEEMAC1CONFIGVEC : in std_logic_vector(79 downto 0);
		TIEEMAC1UNICASTADDR : in std_logic_vector(47 downto 0)
    );
    end component;


    ----------------------------------------------------------------------------
    -- Signals Declarations
    ----------------------------------------------------------------------------


    signal gnd_v48_i                      : std_logic_vector(47 downto 0);

    signal client_rx_data_0_i             : std_logic_vector(15 downto 0);
    signal client_tx_data_0_i             : std_logic_vector(15 downto 0);

    signal tieemac0configvector_i         : std_logic_vector(79 downto 0);
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


    signal client_rx_data_1_i             : std_logic_vector(15 downto 0);
    signal client_tx_data_1_i             : std_logic_vector(15 downto 0);

    signal tieemac1configvector_i         : std_logic_vector(79 downto 0);
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



begin


    ----------------------------------------------------------------------------
    -- Main Body of Code
    ----------------------------------------------------------------------------


    gnd_v48_i <= "000000000000000000000000000000000000000000000000";

    -- 8-bit client data on EMAC0
    EMAC0CLIENTRXD <= client_rx_data_0_i(7 downto 0);
    client_tx_data_0_i <= "00000000" & CLIENTEMAC0TXD;

    -- 8-bit client data on EMAC1
    EMAC1CLIENTRXD <= client_rx_data_1_i(7 downto 0);
    client_tx_data_1_i <= "00000000" & CLIENTEMAC1TXD;



    -- Set the Unicast Address of the MAC
    unicast_address_0_i <= x"000000000000";
    unicast_address_1_i <= x"00AABBCCDDE0";


    ----------------------------------------------------------------------------
    -- Construct the tie-off vectors
    --------------------------------

    -- tieemac#configvector_i[79]: Reserved - Tie to "1"

    -- tieemac#configvector_i[78:74]: phy_configuration_vector[4:0] that is used
    --     to configure the PCS/PMA logic either when the MDIO is not present or 
    --     as initial values loaded upon reset that can be modified through the
    --     MDIO.

    -- tieemac#configvector_i[73:65]: tie_off_vector[8:0] that is used to 
    --     configure the mode of the EMAC.

    -- tieemac#configvector_i[64:0]  mac_configuration_vector[64:0] that is used
    --     to configure the EMAC either when the Host interface is not present
    --     or as initial values loaded upon reset that can be modified through
    --     the Host interface.
    ----------------------------------------------------------------------------

    ---------
    -- EMAC0
    ---------

    -- Connect the Tie-off Pins
    ---------------------------

    tieemac0configvector_i <= '1' & phy_config_vector_0_i &
                              has_mdio_0_i &
                              speed_0_i &
                              has_rgmii_0_i &
                              has_sgmii_0_i &
                              has_gpcs_0_i &
                              has_host_0_i &
                              tx_client_16_0_i &
                              rx_client_16_0_i &
                              addr_filter_enable_0_i &
                              rx_lt_check_dis_0_i &
                              flow_control_config_vector_0_i &
                              tx_config_vector_0_i &
                              rx_config_vector_0_i &
                              pause_address_0_i;


    -- Assign the Tie-off Pins
    ---------------------------

    -- Configure the PCS/PMA logic
    phy_config_vector_0_i(4)          <= '0';  -- PCS/PMA Reset not asserted (normal operating mode)
    phy_config_vector_0_i(3)          <= '1';  -- PCS/PMA Auto-Negotiation Enable (enabled)
    phy_config_vector_0_i(2)          <= '1';  -- PCS/PMA Isolate (enabled)
    phy_config_vector_0_i(1)          <= '0';  -- PCS/PMA Powerdown (not in power down: normal operating mode)
    phy_config_vector_0_i(0)          <= '0';  -- PCS/PMA Loopback (not enabled)

    -- Configure the MAC operating mode
    has_mdio_0_i                      <= '1';  -- MDIO is enabled
    speed_0_i                         <= "10"; -- Speed is defaulted to 1000Mb/s
    has_rgmii_0_i                     <= '0';
    has_sgmii_0_i                     <= '0';
    has_gpcs_0_i                      <= '1';  -- 1000BASE-X PCS/PMA is used as the PHY
    has_host_0_i                      <= '1';  -- The Host I/F is used to configure the MAC
    tx_client_16_0_i                  <= '0';  -- 8-bit interface for Tx client
    rx_client_16_0_i                  <= '0';  -- 8-bit interface for Rx client
    addr_filter_enable_0_i            <= '1';  -- The Address Filter (enabled)

    -- MAC configuration defaults
    rx_lt_check_dis_0_i               <= '0';  -- Rx Length/Type checking enabled (standard IEEE operation)
    flow_control_config_vector_0_i(1) <= '1';  -- Rx Flow Control (enabled)
    flow_control_config_vector_0_i(0) <= '1';  -- Tx Flow Control (enabled)
    tx_config_vector_0_i(6)           <= '0';  -- Transmitter is not held in reset not asserted (normal operating mode)
    tx_config_vector_0_i(5)           <= '0';  -- Transmitter Jumbo Frames (not enabled)
    tx_config_vector_0_i(4)           <= '0';  -- Transmitter In-band FCS (not enabled)
    tx_config_vector_0_i(3)           <= '1';  -- Transmitter Enabled
    tx_config_vector_0_i(2)           <= '0';  -- Transmitter VLAN mode (not enabled)
    tx_config_vector_0_i(1)           <= '0';  -- Transmitter Half Duplex mode (not enabled)
    tx_config_vector_0_i(0)           <= '0';  -- Transmitter IFG Adjust (not enabled)
    rx_config_vector_0_i(5)           <= '0';  -- Receiver is not held in reset not asserted (normal operating mode)
    rx_config_vector_0_i(4)           <= '0';  -- Receiver Jumbo Frames (not enabled)
    rx_config_vector_0_i(3)           <= '0';  -- Receiver In-band FCS (not enabled)
    rx_config_vector_0_i(2)           <= '1';  -- Receiver Enabled
    rx_config_vector_0_i(1)           <= '0';  -- Receiver VLAN mode (not enabled)
    rx_config_vector_0_i(0)           <= '0';  -- Receiver Half Duplex mode (not enabled)

    -- Set the Pause Address Default
    pause_address_0_i                 <= x"000000000000";




    ---------
    -- EMAC1
    ---------

    -- Connect the Tie-off Pins
    ---------------------------

    tieemac1configvector_i <= '1' & phy_config_vector_1_i &
                              has_mdio_1_i &
                              speed_1_i &
                              has_rgmii_1_i &
                              has_sgmii_1_i &
                              has_gpcs_1_i &
                              has_host_1_i &
                              tx_client_16_1_i &
                              rx_client_16_1_i &
                              addr_filter_enable_1_i &
                              rx_lt_check_dis_1_i &
                              flow_control_config_vector_1_i &
                              tx_config_vector_1_i &
                              rx_config_vector_1_i &
                              pause_address_1_i;


    -- Assign the Tie-off Pins
    ---------------------------

    -- Configure the PCS/PMA logic
    phy_config_vector_1_i(4)          <= '0';  -- PCS/PMA Reset (normal operating mode)
    phy_config_vector_1_i(3)          <= '1';  -- PCS/PMA Auto-Negotiation Enable (enabled)
    phy_config_vector_1_i(2)          <= '1';  -- PCS/PMA Isolate (enabled)
    phy_config_vector_1_i(1)          <= '0';  -- PCS/PMA Powerdown (not in power down: normal operating mode)
    phy_config_vector_1_i(0)          <= '0';  -- PCS/PMA Loopback (not enabled)

    -- Configure the MAC operating mode
    has_mdio_1_i                      <= '1';  -- MDIO is enabled
    speed_1_i                         <= "10"; -- Speed is defaulted to 1000Mb/s
 
    has_rgmii_1_i                     <= '0';
    has_sgmii_1_i                     <= '0';
    has_gpcs_1_i                      <= '1';  -- 1000BASE-X PCS/PMA is used as the PHY
    has_host_1_i                      <= '1';  -- The Host I/F is used to configure the MAC
    tx_client_16_1_i                  <= '0';  -- 8-bit interface for Tx client
    rx_client_16_1_i                  <= '0';  -- 8-bit interface for Rx client
    addr_filter_enable_1_i            <= '1';  -- The Address Filter (enabled)

    -- MAC configuration defaults
    rx_lt_check_dis_1_i               <= '0';  -- Rx Length/Type checking enabled (standard IEEE operation)
    flow_control_config_vector_1_i(1) <= '1';  -- Rx Flow Control (enabled)
    flow_control_config_vector_1_i(0) <= '1';  -- Tx Flow Control (enabled)
    tx_config_vector_1_i(6)           <= '0';  -- Transmitter is not held in reset not asserted (normal operating mode)
    tx_config_vector_1_i(5)           <= '0';  -- Transmitter Jumbo Frames (not enabled)
    tx_config_vector_1_i(4)           <= '0';  -- Transmitter In-band FCS (not enabled)
    tx_config_vector_1_i(3)           <= '1';  -- Transmitter Enabled
    tx_config_vector_1_i(2)           <= '0';  -- Transmitter VLAN mode (not enabled)
    tx_config_vector_1_i(1)           <= '0';  -- Transmitter Half Duplex mode (not enabled)
    tx_config_vector_1_i(0)           <= '0';  -- Transmitter IFG Adjust (not enabled)
    rx_config_vector_1_i(5)           <= '0';  -- Receiver is not held in reset not asserted (normal operating mode)
    rx_config_vector_1_i(4)           <= '0';  -- Receiver Jumbo Frames (not enabled)
    rx_config_vector_1_i(3)           <= '0';  -- Receiver In-band FCS (not enabled)
    rx_config_vector_1_i(2)           <= '1';  -- Receiver Enabled
    rx_config_vector_1_i(1)           <= '0';  -- Receiver VLAN mode (not enabled)
    rx_config_vector_1_i(0)           <= '0';  -- Receiver Half Duplex mode (not enabled)

    -- Set the Pause Address Default
    pause_address_1_i                 <= x"00AABBCCDDE0";




    ----------------------------------------------------------------------------
    -- Instantiate the Virtex-4 FX Embedded Ethernet EMAC
    ----------------------------------------------------------------------------
    v4_emac : EMAC
    port map (
        RESET                           => RESET,

        -- EMAC0
        EMAC0CLIENTRXCLIENTCLKOUT       => EMAC0CLIENTRXCLIENTCLKOUT,
        CLIENTEMAC0RXCLIENTCLKIN        => CLIENTEMAC0RXCLIENTCLKIN,
        EMAC0CLIENTRXD                  => client_rx_data_0_i,
        EMAC0CLIENTRXDVLD               => EMAC0CLIENTRXDVLD,
        EMAC0CLIENTRXDVLDMSW            => EMAC0CLIENTRXDVLDMSW,
        EMAC0CLIENTRXGOODFRAME          => EMAC0CLIENTRXGOODFRAME,
        EMAC0CLIENTRXBADFRAME           => EMAC0CLIENTRXBADFRAME,
        EMAC0CLIENTRXFRAMEDROP          => EMAC0CLIENTRXFRAMEDROP,
        EMAC0CLIENTRXDVREG6             => EMAC0CLIENTRXDVREG6,
        EMAC0CLIENTRXSTATS              => EMAC0CLIENTRXSTATS,
        EMAC0CLIENTRXSTATSVLD           => EMAC0CLIENTRXSTATSVLD,
        EMAC0CLIENTRXSTATSBYTEVLD       => EMAC0CLIENTRXSTATSBYTEVLD,

        EMAC0CLIENTTXCLIENTCLKOUT       => EMAC0CLIENTTXCLIENTCLKOUT,
        CLIENTEMAC0TXCLIENTCLKIN        => CLIENTEMAC0TXCLIENTCLKIN,
        CLIENTEMAC0TXD                  => client_tx_data_0_i,
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

        CLIENTEMAC0PAUSEREQ             => CLIENTEMAC0PAUSEREQ,
        CLIENTEMAC0PAUSEVAL             => CLIENTEMAC0PAUSEVAL,

        PHYEMAC0GTXCLK                  => GTX_CLK_0,
        EMAC0CLIENTTXGMIIMIICLKOUT      => EMAC0CLIENTTXGMIIMIICLKOUT,
        CLIENTEMAC0TXGMIIMIICLKIN       => CLIENTEMAC0TXGMIIMIICLKIN,

        PHYEMAC0RXCLK                   => GTX_CLK_0, --'0',
        PHYEMAC0MIITXCLK                => '0',
        PHYEMAC0RXD                     => RXDATA_0,
        PHYEMAC0RXDV                    => RXREALIGN_0,
        PHYEMAC0RXER                    => '0',
        EMAC0PHYTXCLK                   => open,
        EMAC0PHYTXD                     => TXDATA_0,
        EMAC0PHYTXEN                    => open,
        EMAC0PHYTXER                    => open,
        PHYEMAC0COL                     => TXRUNDISP_0,
        PHYEMAC0CRS                     => '0',
        CLIENTEMAC0DCMLOCKED            => DCM_LOCKED_0,
        EMAC0CLIENTANINTERRUPT          => AN_INTERRUPT_0,
        PHYEMAC0SIGNALDET               => SIGNAL_DETECT_0,
        PHYEMAC0PHYAD                   => PHYAD_0,
        EMAC0PHYENCOMMAALIGN            => ENCOMMAALIGN_0,
        EMAC0PHYLOOPBACKMSB             => LOOPBACKMSB_0,
        EMAC0PHYMGTRXRESET              => MGTRXRESET_0,
        EMAC0PHYMGTTXRESET              => MGTTXRESET_0,
        EMAC0PHYPOWERDOWN               => POWERDOWN_0,
        EMAC0PHYSYNCACQSTATUS           => SYNCACQSTATUS_0,
        PHYEMAC0RXCLKCORCNT             => RXCLKCORCNT_0,
        PHYEMAC0RXBUFSTATUS             => RXBUFSTATUS_0,
        PHYEMAC0RXBUFERR                => RXBUFERR_0,
        PHYEMAC0RXCHARISCOMMA           => RXCHARISCOMMA_0,
        PHYEMAC0RXCHARISK               => RXCHARISK_0,
        PHYEMAC0RXCHECKINGCRC           => RXCHECKINGCRC_0,
        PHYEMAC0RXCOMMADET              => RXCOMMADET_0,
        PHYEMAC0RXDISPERR               => RXDISPERR_0,
        PHYEMAC0RXLOSSOFSYNC            => RXLOSSOFSYNC_0,
        PHYEMAC0RXNOTINTABLE            => RXNOTINTABLE_0,
        PHYEMAC0RXRUNDISP               => RXRUNDISP_0,
        PHYEMAC0TXBUFERR                => TXBUFERR_0,
        EMAC0PHYTXCHARDISPMODE          => TXCHARDISPMODE_0,
        EMAC0PHYTXCHARDISPVAL           => TXCHARDISPVAL_0,
        EMAC0PHYTXCHARISK               => TXCHARISK_0,

        EMAC0PHYMCLKOUT                 => MDC_0,
        PHYEMAC0MCLKIN                  => '0',
        PHYEMAC0MDIN                    => MDIO_IN_0,
        EMAC0PHYMDOUT                   => MDIO_OUT_0,
        EMAC0PHYMDTRI                   => MDIO_TRI_0,

        TIEEMAC0CONFIGVEC               => tieemac0configvector_i,
        TIEEMAC0UNICASTADDR             => unicast_address_0_i,

        -- EMAC1
        EMAC1CLIENTRXCLIENTCLKOUT       => EMAC1CLIENTRXCLIENTCLKOUT,
        CLIENTEMAC1RXCLIENTCLKIN        => CLIENTEMAC1RXCLIENTCLKIN,
        EMAC1CLIENTRXD                  => client_rx_data_1_i,
        EMAC1CLIENTRXDVLD               => EMAC1CLIENTRXDVLD,
        EMAC1CLIENTRXDVLDMSW            => EMAC1CLIENTRXDVLDMSW,
        EMAC1CLIENTRXGOODFRAME          => EMAC1CLIENTRXGOODFRAME,
        EMAC1CLIENTRXBADFRAME           => EMAC1CLIENTRXBADFRAME,
        EMAC1CLIENTRXFRAMEDROP          => EMAC1CLIENTRXFRAMEDROP,
        EMAC1CLIENTRXDVREG6             => EMAC1CLIENTRXDVREG6,
        EMAC1CLIENTRXSTATS              => EMAC1CLIENTRXSTATS,
        EMAC1CLIENTRXSTATSVLD           => EMAC1CLIENTRXSTATSVLD,
        EMAC1CLIENTRXSTATSBYTEVLD       => EMAC1CLIENTRXSTATSBYTEVLD,

        EMAC1CLIENTTXCLIENTCLKOUT       => EMAC1CLIENTTXCLIENTCLKOUT,
        CLIENTEMAC1TXCLIENTCLKIN        => CLIENTEMAC1TXCLIENTCLKIN,
        CLIENTEMAC1TXD                  => client_tx_data_1_i,
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

        CLIENTEMAC1PAUSEREQ             => CLIENTEMAC1PAUSEREQ,
        CLIENTEMAC1PAUSEVAL             => CLIENTEMAC1PAUSEVAL,

        PHYEMAC1GTXCLK                  => GTX_CLK_1,
        EMAC1CLIENTTXGMIIMIICLKOUT      => EMAC1CLIENTTXGMIIMIICLKOUT,
        CLIENTEMAC1TXGMIIMIICLKIN       => CLIENTEMAC1TXGMIIMIICLKIN,

        PHYEMAC1RXCLK                   => GTX_CLK_1, --'0',
        PHYEMAC1MIITXCLK                => '0',
        PHYEMAC1RXD                     => RXDATA_1,
        PHYEMAC1RXDV                    => RXREALIGN_1,
        PHYEMAC1RXER                    => '0',
        EMAC1PHYTXCLK                   => open,
        EMAC1PHYTXD                     => TXDATA_1,
        EMAC1PHYTXEN                    => open,
        EMAC1PHYTXER                    => open,
        PHYEMAC1COL                     => TXRUNDISP_1,
        PHYEMAC1CRS                     => '0',
        CLIENTEMAC1DCMLOCKED            => DCM_LOCKED_1,
        EMAC1CLIENTANINTERRUPT          => AN_INTERRUPT_1,
        PHYEMAC1SIGNALDET               => SIGNAL_DETECT_1,
        PHYEMAC1PHYAD                   => PHYAD_1,
        EMAC1PHYENCOMMAALIGN            => ENCOMMAALIGN_1,
        EMAC1PHYLOOPBACKMSB             => LOOPBACKMSB_1,
        EMAC1PHYMGTRXRESET              => MGTRXRESET_1,
        EMAC1PHYMGTTXRESET              => MGTTXRESET_1,
        EMAC1PHYPOWERDOWN               => POWERDOWN_1,
        EMAC1PHYSYNCACQSTATUS           => SYNCACQSTATUS_1,
        PHYEMAC1RXCLKCORCNT             => RXCLKCORCNT_1,
        PHYEMAC1RXBUFSTATUS             => RXBUFSTATUS_1,
        PHYEMAC1RXBUFERR                => RXBUFERR_1,
        PHYEMAC1RXCHARISCOMMA           => RXCHARISCOMMA_1,
        PHYEMAC1RXCHARISK               => RXCHARISK_1,
        PHYEMAC1RXCHECKINGCRC           => RXCHECKINGCRC_1,
        PHYEMAC1RXCOMMADET              => RXCOMMADET_1,
        PHYEMAC1RXDISPERR               => RXDISPERR_1,
        PHYEMAC1RXLOSSOFSYNC            => RXLOSSOFSYNC_1,
        PHYEMAC1RXNOTINTABLE            => RXNOTINTABLE_1,
        PHYEMAC1RXRUNDISP               => RXRUNDISP_1,
        PHYEMAC1TXBUFERR                => TXBUFERR_1,
        EMAC1PHYTXCHARDISPMODE          => TXCHARDISPMODE_1,
        EMAC1PHYTXCHARDISPVAL           => TXCHARDISPVAL_1,
        EMAC1PHYTXCHARISK               => TXCHARISK_1,

        EMAC1PHYMCLKOUT                 => MDC_1,
        PHYEMAC1MCLKIN                  => '0',
        PHYEMAC1MDIN                    => MDIO_IN_1,
        EMAC1PHYMDOUT                   => MDIO_OUT_1,
        EMAC1PHYMDTRI                   => MDIO_TRI_1,

        TIEEMAC1CONFIGVEC               => tieemac1configvector_i,
        TIEEMAC1UNICASTADDR             => unicast_address_1_i,

        -- Host Interface
        HOSTCLK                         => HOSTCLK,
        HOSTOPCODE                      => HOSTOPCODE,
        HOSTREQ                         => HOSTREQ,
        HOSTMIIMSEL                     => HOSTMIIMSEL,
        HOSTADDR                        => HOSTADDR,
        HOSTWRDATA                      => HOSTWRDATA,
        HOSTMIIMRDY                     => HOSTMIIMRDY,
        HOSTRDDATA                      => HOSTRDDATA,
        HOSTEMAC1SEL                    => HOSTEMAC1SEL,

        -- DCR Interface
        DCREMACCLK                      => '0',
        DCREMACABUS                     => gnd_v48_i(1 downto 0),
        DCREMACREAD                     => '0',
        DCREMACWRITE                    => '0',
        DCREMACDBUS                     => gnd_v48_i(31 downto 0),
        EMACDCRACK                      => open,
        EMACDCRDBUS                     => open,
        DCREMACENABLE                   => '0',
        DCRHOSTDONEIR                   => open
        );

end WRAPPER;
