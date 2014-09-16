-------------------------------------------------------------------------------
-- Title      : Virtex-4 FX Ethernet MAC Wrapper
-------------------------------------------------------------------------------
-- File       : eth_gmii.vhd
-- Author     : Xilinx
-------------------------------------------------------------------------------
-- Copyright (c) 2004-2008 by Xilinx, Inc. All rights reserved.
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
-- of this text at all times. (c) Copyright 2004-2008 Xilinx, Inc.
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

entity eth_gmii is
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

        -- GMII Interface - EMAC0
        GMII_TXD_0                      : out std_logic_vector(7 downto 0);
        GMII_TX_EN_0                    : out std_logic;
        GMII_TX_ER_0                    : out std_logic;
        GMII_TX_CLK_0                   : out std_logic;
        GMII_RXD_0                      : in  std_logic_vector(7 downto 0);
        GMII_RX_DV_0                    : in  std_logic;
        GMII_RX_ER_0                    : in  std_logic;
        GMII_RX_CLK_0                   : in  std_logic;
        MII_TX_CLK_0                    : in  std_logic;
        GMII_COL_0                      : in  std_logic;
        GMII_CRS_0                      : in  std_logic;

        -- MDIO Interface - EMAC0
        MDC_0                           : out std_logic;
        MDIO_IN_0                       : in  std_logic;
        MDIO_OUT_0                      : out std_logic;
        MDIO_TRI_0                      : out std_logic;


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

        DCM_LOCKED_0                    : in  std_logic;

        -- Asynchronous Reset
        RESET                           : in  std_logic
        );

end eth_gmii;



architecture WRAPPER of eth_gmii is


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




begin


    ----------------------------------------------------------------------------
    -- Main Body of Code
    ----------------------------------------------------------------------------


    gnd_v48_i <= "000000000000000000000000000000000000000000000000";

    -- 8-bit client data on EMAC0
    EMAC0CLIENTRXD <= client_rx_data_0_i(7 downto 0);
    client_tx_data_0_i <= "00000000" & CLIENTEMAC0TXD;




    -- Set the Unicast Address of the MAC
    unicast_address_0_i <= x"FFEEDDCCBBAA";


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

    phy_config_vector_0_i             <= "10000"; -- PCS/PMA logic is not in use, hold in reset

    -- Configure the MAC operating mode
    has_mdio_0_i                      <= '1';  -- MDIO is enabled
    speed_0_i                         <= "10"; -- Speed is defaulted to 1000Mb/s
    has_rgmii_0_i                     <= '0';
    has_sgmii_0_i                     <= '0';
    has_gpcs_0_i                      <= '0';
    has_host_0_i                      <= '1';  -- The Host I/F is used to configure the MAC
    tx_client_16_0_i                  <= '0';  -- 8-bit interface for Tx client
    rx_client_16_0_i                  <= '0';  -- 8-bit interface for Rx client
    addr_filter_enable_0_i            <= '0';  -- The Address Filter (not enabled)

    -- MAC configuration defaults
    rx_lt_check_dis_0_i               <= '0';  -- Rx Length/Type checking enabled (standard IEEE operation)
    flow_control_config_vector_0_i(1) <= '0';  -- Rx Flow Control (not enabled)
    flow_control_config_vector_0_i(0) <= '0';  -- Tx Flow Control (not enabled)
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
    pause_address_0_i                 <= x"FFEEDDCCBBAA";





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

        PHYEMAC0RXCLK                   => GMII_RX_CLK_0,
        PHYEMAC0RXD                     => GMII_RXD_0,
        PHYEMAC0RXDV                    => GMII_RX_DV_0,
        PHYEMAC0RXER                    => GMII_RX_ER_0,
        EMAC0PHYTXCLK                   => GMII_TX_CLK_0,
        EMAC0PHYTXD                     => GMII_TXD_0,
        EMAC0PHYTXEN                    => GMII_TX_EN_0,
        EMAC0PHYTXER                    => GMII_TX_ER_0,
        PHYEMAC0MIITXCLK                => MII_TX_CLK_0,
        PHYEMAC0COL                     => GMII_COL_0,
        PHYEMAC0CRS                     => GMII_CRS_0,

        CLIENTEMAC0DCMLOCKED            => DCM_LOCKED_0,
        EMAC0CLIENTANINTERRUPT          => open,
        PHYEMAC0SIGNALDET               => '0',
        PHYEMAC0PHYAD                   => gnd_v48_i(4 downto 0),
        EMAC0PHYENCOMMAALIGN            => open,
        EMAC0PHYLOOPBACKMSB             => open,
        EMAC0PHYMGTRXRESET              => open,
        EMAC0PHYMGTTXRESET              => open,
        EMAC0PHYPOWERDOWN               => open,
        EMAC0PHYSYNCACQSTATUS           => open,
        PHYEMAC0RXCLKCORCNT             => gnd_v48_i(2 downto 0),
        PHYEMAC0RXBUFSTATUS             => gnd_v48_i(1 downto 0),
        PHYEMAC0RXBUFERR                => '0',
        PHYEMAC0RXCHARISCOMMA           => '0',
        PHYEMAC0RXCHARISK               => '0',
        PHYEMAC0RXCHECKINGCRC           => '0',
        PHYEMAC0RXCOMMADET              => '0',
        PHYEMAC0RXDISPERR               => '0',
        PHYEMAC0RXLOSSOFSYNC            => gnd_v48_i(1 downto 0),
        PHYEMAC0RXNOTINTABLE            => '0',
        PHYEMAC0RXRUNDISP               => '0',
        PHYEMAC0TXBUFERR                => '0',
        EMAC0PHYTXCHARDISPMODE          => open,
        EMAC0PHYTXCHARDISPVAL           => open,
        EMAC0PHYTXCHARISK               => open,

        EMAC0PHYMCLKOUT                 => MDC_0,
        PHYEMAC0MCLKIN                  => '0',
        PHYEMAC0MDIN                    => MDIO_IN_0,
        EMAC0PHYMDOUT                   => MDIO_OUT_0,
        EMAC0PHYMDTRI                   => MDIO_TRI_0,

        TIEEMAC0CONFIGVEC               => tieemac0configvector_i,
        TIEEMAC0UNICASTADDR             => gnd_v48_i,

        -- EMAC1
        EMAC1CLIENTRXCLIENTCLKOUT       => open,
        CLIENTEMAC1RXCLIENTCLKIN        => '0',
        EMAC1CLIENTRXD                  => open,
        EMAC1CLIENTRXDVLD               => open,
        EMAC1CLIENTRXDVLDMSW            => open,
        EMAC1CLIENTRXGOODFRAME          => open,
        EMAC1CLIENTRXBADFRAME           => open,
        EMAC1CLIENTRXFRAMEDROP          => open,
        EMAC1CLIENTRXDVREG6             => open,
        EMAC1CLIENTRXSTATS              => open,
        EMAC1CLIENTRXSTATSVLD           => open,
        EMAC1CLIENTRXSTATSBYTEVLD       => open,

        EMAC1CLIENTTXCLIENTCLKOUT       => open,
        CLIENTEMAC1TXCLIENTCLKIN        => '0',
        CLIENTEMAC1TXD                  => gnd_v48_i(15 downto 0),
        CLIENTEMAC1TXDVLD               => '0',
        CLIENTEMAC1TXDVLDMSW            => '0',
        EMAC1CLIENTTXACK                => open,
        CLIENTEMAC1TXFIRSTBYTE          => '0',
        CLIENTEMAC1TXUNDERRUN           => '0',
        EMAC1CLIENTTXCOLLISION          => open,
        EMAC1CLIENTTXRETRANSMIT         => open,
        CLIENTEMAC1TXIFGDELAY           => gnd_v48_i(7 downto 0),
        EMAC1CLIENTTXSTATS              => open,
        EMAC1CLIENTTXSTATSVLD           => open,
        EMAC1CLIENTTXSTATSBYTEVLD       => open,

        CLIENTEMAC1PAUSEREQ             => '0',
        CLIENTEMAC1PAUSEVAL             => gnd_v48_i(15 downto 0),

        PHYEMAC1GTXCLK                  => '0',
        EMAC1CLIENTTXGMIIMIICLKOUT      => open,
        CLIENTEMAC1TXGMIIMIICLKIN       => '0',

        PHYEMAC1RXCLK                   => '0',
        PHYEMAC1RXD                     => gnd_v48_i(7 downto 0),
        PHYEMAC1RXDV                    => '0',
        PHYEMAC1RXER                    => '0',
        PHYEMAC1MIITXCLK                => '0',
        EMAC1PHYTXCLK                   => open,
        EMAC1PHYTXD                     => open,
        EMAC1PHYTXEN                    => open,
        EMAC1PHYTXER                    => open,
        PHYEMAC1COL                     => '0',
        PHYEMAC1CRS                     => '0',

        CLIENTEMAC1DCMLOCKED            => '1',
        EMAC1CLIENTANINTERRUPT          => open,

        PHYEMAC1SIGNALDET               => '0',
        PHYEMAC1PHYAD                   => gnd_v48_i(4 downto 0),
        EMAC1PHYENCOMMAALIGN            => open,
        EMAC1PHYLOOPBACKMSB             => open,
        EMAC1PHYMGTRXRESET              => open,
        EMAC1PHYMGTTXRESET              => open,
        EMAC1PHYPOWERDOWN               => open,
        EMAC1PHYSYNCACQSTATUS           => open,
        PHYEMAC1RXCLKCORCNT             => gnd_v48_i(2 downto 0),
        PHYEMAC1RXBUFSTATUS             => gnd_v48_i(1 downto 0),
        PHYEMAC1RXBUFERR                => '0',
        PHYEMAC1RXCHARISCOMMA           => '0',
        PHYEMAC1RXCHARISK               => '0',
        PHYEMAC1RXCHECKINGCRC           => '0',
        PHYEMAC1RXCOMMADET              => '0',
        PHYEMAC1RXDISPERR               => '0',
        PHYEMAC1RXLOSSOFSYNC            => gnd_v48_i(1 downto 0),
        PHYEMAC1RXNOTINTABLE            => '0',
        PHYEMAC1RXRUNDISP               => '0',
        PHYEMAC1TXBUFERR                => '0',
        EMAC1PHYTXCHARDISPMODE          => open,
        EMAC1PHYTXCHARDISPVAL           => open,
        EMAC1PHYTXCHARISK               => open,

        EMAC1PHYMCLKOUT                 => open,
        PHYEMAC1MCLKIN                  => '0',
        PHYEMAC1MDIN                    => '0',
        EMAC1PHYMDOUT                   => open,
        EMAC1PHYMDTRI                   => open,

        TIEEMAC1CONFIGVEC               => (others => '0'),
        TIEEMAC1UNICASTADDR             => gnd_v48_i,

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
