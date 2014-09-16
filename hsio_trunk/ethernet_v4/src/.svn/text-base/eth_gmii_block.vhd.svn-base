-------------------------------------------------------------------------------
-- Title      : Virtex-4 Ethernet MAC Wrapper Top Level
-- Project    : Virtex-4 Ethernet MAC Wrappers
-------------------------------------------------------------------------------
-- File       : eth_gmii_block.vhd
-------------------------------------------------------------------------------
-- Copyright (c) 2004-2008 byXilinx, Inc. All rights reserved.
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
entity eth_gmii_block is
   port(
      -- Client Receiver Interface - EMAC0
      RX_CLIENT_CLK_0                 : out std_logic;
      EMAC0CLIENTRXD                  : out std_logic_vector(7 downto 0);
      EMAC0CLIENTRXDVLD               : out std_logic;
      EMAC0CLIENTRXGOODFRAME          : out std_logic;
      EMAC0CLIENTRXBADFRAME           : out std_logic;
      EMAC0CLIENTRXFRAMEDROP          : out std_logic;
      EMAC0CLIENTRXSTATS              : out std_logic_vector(6 downto 0);
      EMAC0CLIENTRXSTATSVLD           : out std_logic;
      EMAC0CLIENTRXSTATSBYTEVLD       : out std_logic;

      -- Client Transmitter Interface - EMAC0
      TX_CLIENT_CLK_0                 : out std_logic;
      CLIENTEMAC0TXD                  : in  std_logic_vector(7 downto 0);
      CLIENTEMAC0TXDVLD               : in  std_logic;
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
      MDIO_0_I                        : in  std_logic;
      MDIO_0_O                        : out std_logic;
      MDIO_0_T                        : out std_logic;
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
      -- Reference clock for RGMII IODELAYs
      REFCLK                          : in  std_logic;
        
        
      -- Asynchronous Reset
      RESET                           : in  std_logic
   );
end eth_gmii_block;


architecture TOP_LEVEL of eth_gmii_block is


-------------------------------------------------------------------------------
-- Component Declarations for lower hierarchial level entities
-------------------------------------------------------------------------------


  -- Component Declaration for the main EMAC wrapper
  component eth_gmii is
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

      -- Clock Signals - EMAC0
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

      DCM_LOCKED_0                    : in  std_logic;

      -- Asynchronous Reset
      RESET                           : in  std_logic
    );
  end component;



  -- Component Declaration for the GMII Physcial Interface
  component gmii_if
    port(
      RESET                           : in  std_logic;
      -- GMII Interface
      GMII_TXD                        : out std_logic_vector(7 downto 0);
      GMII_TX_EN                      : out std_logic;
      GMII_TX_ER                      : out std_logic;
      GMII_TX_CLK                     : out std_logic;
      GMII_RXD                        : in  std_logic_vector(7 downto 0);
      GMII_RX_DV                      : in  std_logic;
      GMII_RX_ER                      : in  std_logic;
      -- MAC Interface
      TXD_FROM_MAC                    : in  std_logic_vector(7 downto 0);
      TX_EN_FROM_MAC                  : in  std_logic;
      TX_ER_FROM_MAC                  : in  std_logic;
      TX_CLK                          : in  std_logic;
      RXD_TO_MAC                      : out std_logic_vector(7 downto 0);
      RX_DV_TO_MAC                    : out std_logic;
      RX_ER_TO_MAC                    : out std_logic;
      RX_CLK                          : in  std_logic);
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

    signal refclk_ibufg_i                 : std_logic;
    signal refclk_bufg_i                  : std_logic;

    signal rx_client_clk_out_0_i          : std_logic;
    signal rx_client_clk_in_0_i           : std_logic;
    signal tx_client_clk_out_0_i          : std_logic;
    signal tx_client_clk_fb_0_i           : std_logic;
    signal tx_client_clk_in_0_i           : std_logic;
    signal tx_gmii_mii_clk_out_0_i        : std_logic;
    signal tx_gmii_mii_clk_in_0_i         : std_logic;
    signal idelayctrl_reset_0_r1          : std_logic;
    signal idelayctrl_reset_0_r2          : std_logic;
    signal idelayctrl_reset_0_r3          : std_logic;
    signal idelayctrl_reset_0_r           : std_logic;
    signal gmii_tx_clk_0_i                : std_logic;
    signal gmii_tx_clk_0_i2               : std_logic;
    signal gmii_tx_en_0_i                 : std_logic;
    signal gmii_tx_er_0_i                 : std_logic;
    signal gmii_txd_0_i                   : std_logic_vector(7 downto 0);
    signal gmii_tx_en_0_r                 : std_logic;
    signal gmii_tx_er_0_r                 : std_logic;
    signal gmii_txd_0_r                   : std_logic_vector(7 downto 0);
    signal mii_tx_clk_0_i                 : std_logic;
    signal gmii_col_0_i                   : std_logic;
    signal reg_gmii_col_0                 : std_logic;
    signal reg_reg_gmii_col_0             : std_logic;
    signal gmii_col_int_0                 : std_logic;
    signal gmii_crs_0_i                   : std_logic;
    signal gmii_rx_clk_ibufg_0_i          : std_logic;
    signal gmii_rx_clk_delay_0_i          : std_logic;
    signal gmii_rx_clk_0_i                : std_logic;
    signal gmii_rx_dv_0_i                 : std_logic;
    signal gmii_rx_er_0_i                 : std_logic;
    signal gmii_rxd_0_i                   : std_logic_vector(7 downto 0);
    signal gmii_rx_dv_0_r                 : std_logic;
    signal gmii_rx_er_0_r                 : std_logic;
    signal gmii_rxd_0_r                   : std_logic_vector(7 downto 0);
    signal idelayctrl_reset_0_i           : std_logic;



    signal txpmareset                      : std_logic;

    signal gtx_clk_ibufg_0_i              : std_logic;

    signal tx_data_0_i                    : std_logic_vector(7 downto 0);
    signal tx_data_valid_0_i              : std_logic;
    signal rx_data_0_i                    : std_logic_vector(7 downto 0);
    signal rx_data_valid_0_i              : std_logic;
    signal tx_underrun_0_i                : std_logic;
    signal tx_ack_0_i                     : std_logic;
    signal rx_good_frame_0_i              : std_logic;
    signal rx_bad_frame_0_i               : std_logic;
    signal tx_collision_0_i               : std_logic;
    signal tx_retransmit_0_i              : std_logic;
    signal mdc_out_0_i                    : std_logic;
    signal mdio_in_0_i                    : std_logic;
    signal mdio_out_0_i                   : std_logic;
    signal mdio_tri_0_i                   : std_logic;
    signal host_clk_i                     : std_logic;
    signal speed_vector_0_i               : std_logic_vector(1 downto 0);


-------------------------------------------------------------------------------
-- Attribute Declarations
-------------------------------------------------------------------------------

-- Setting attribute for RGMII/GMII IDELAY
-- Please modify the LOC constraint of the IDELAYCTRL according to your
-- design.
--
-- For more information on IDELAYCTRL and IDELAY, please refer to
-- the Virtex-4 User Guide.

  attribute syn_noprune              : boolean;
  attribute loc                      : string;
  attribute IOBDELAY_TYPE            : string;
  attribute IOBDELAY_VALUE           : integer;
  --attribute syn_noprune of dlyctrl_0 : label is true;

  attribute ASYNC_REG : string;
  attribute ASYNC_REG of reset_r  : signal is "TRUE";

-- Force xst to preserve the clock net names in the design
-- These clock names are referenced in the UCF file
  attribute KEEP : string;
  attribute KEEP of tx_gmii_mii_clk_in_0_i : signal is "TRUE";
  attribute KEEP of gmii_rx_clk_0_i     : signal is "TRUE";
  attribute KEEP of tx_client_clk_in_0_i   : signal is "TRUE";
  attribute KEEP of rx_client_clk_in_0_i   : signal is "TRUE";
  attribute KEEP of mii_tx_clk_0_i      : signal is "TRUE";


 signal  emac0_mode_write       : std_logic;
 signal  capture_speed_vector_0 : std_logic_vector(1 downto 0);




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



    ---------------------------------------------------------------------------
    -- GMII circuitry for the Physical Interface of EMAC0
    ---------------------------------------------------------------------------

    gmii0 : gmii_if port map (
        RESET                         => reset_i,
        GMII_TXD                      => GMII_TXD_0,
        GMII_TX_EN                    => GMII_TX_EN_0,
        GMII_TX_ER                    => GMII_TX_ER_0,
        GMII_TX_CLK                   => GMII_TX_CLK_0,
        GMII_RXD                      => GMII_RXD_0,
        GMII_RX_DV                    => GMII_RX_DV_0,
        GMII_RX_ER                    => GMII_RX_ER_0,
        TXD_FROM_MAC                  => gmii_txd_0_i,
        TX_EN_FROM_MAC                => gmii_tx_en_0_i,
        TX_ER_FROM_MAC                => gmii_tx_er_0_i,
        TX_CLK                        => tx_gmii_mii_clk_in_0_i,
        RXD_TO_MAC                    => gmii_rxd_0_r,
        RX_DV_TO_MAC                  => gmii_rx_dv_0_r,
        RX_ER_TO_MAC                  => gmii_rx_er_0_r,
        RX_CLK                        => gmii_rx_clk_0_i);


    -- Half Duplex signals for tri-speed mode
    gmii_col_obuf0 : IBUF port map (I => GMII_COL_0, O => gmii_col_int_0);
    gmii_crs_obuf0 : IBUF port map (I => GMII_CRS_0, O => gmii_crs_0_i);

    -- Stretch out the GMII collision signal
    reggmiicolgen0 : process(reset_i, tx_gmii_mii_clk_in_0_i)
    begin
      if reset_i = '1' then
          reg_gmii_col_0     <= '0';
          reg_reg_gmii_col_0 <= '0';
      elsif tx_gmii_mii_clk_in_0_i'event and tx_gmii_mii_clk_in_0_i = '1' then
          reg_gmii_col_0     <= gmii_col_int_0;
          reg_reg_gmii_col_0 <= reg_gmii_col_0;
      end if;
    end process reggmiicolgen0;

    gmii_col_0_i <= gmii_col_int_0 or reg_gmii_col_0 or reg_reg_gmii_col_0;







    --------------------------------------------------------------------------
    -- REFCLK used for IODELAYCTRL primitive - Need to supply a 200MHz clcok
    --------------------------------------------------------------------------

    refclk_ibufg_i <= REFCLK;
    refclk_bufg_i  <= refclk_ibufg_i;

    --------------------------------------------------------------------------
    -- GTX_CLK Clock Management - 125 MHz clock frequency supplied by the user
    -- (Connected to PHYEMAC#GTXCLK of the EMAC primitive)
    --------------------------------------------------------------------------

    gtx_clk_ibufg_0_i <= GTX_CLK_0;

    --------------------------------------------------------------------------
    -- IDELAYCTRL for EMAC0
    --------------------------------------------------------------------------
    -- In order to meet setup and hold timing on the PHY interface, the data
    -- is delayed relative to the clock by using the IDELAY primitive (see
    -- PHY instantiation in the /physical directory of the example design).
    -- It is set to Fixed Tap Delay mode.
    --
    -- IDELAYCTRL primitives need to be instantiated for the Fixed Tap Delay
    -- mode of the IDELAY.  Each tap is 78ps in Fixed mode.
    -- The IDELAY and the IDELAYCTRL primitive have to be LOC'ed in the same
    -- clock region.  This, and the tap settings are done in the UCF file.
    --
    -- An alternative is to delay the clock in relation to the data.
    -- See the Virtex 4 Users Guide for more information on using the IDELAY.

    -- Instantiate IDELAYCTRL for the IDELAY in Fixed Tap Delay Mode
    dlyctrl_0 : IDELAYCTRL
    port map (
        RDY    => open,
        REFCLK => refclk_bufg_i,
        RST    => idelayctrl_reset_0_i
        );
    
    -- Instantiate IDELAYCTRL for the clock IDELAY
    dlyctrl_clk_0 : IDELAYCTRL
    port map (
        RDY    => open,
        REFCLK => refclk_bufg_i,
        RST    => idelayctrl_reset_0_i
        );


    -- The IDELAYCTRL needs to have a reset pulse of 50ns minimum width
    -- Use a 10 bit long shift register to create the pulse off the 200 MHz ref clock
    idelayctrl_sr_0 : SRL16
    generic map (
      INIT => X"FFFF")
    port map (
      D =>  '0',
      A3 => '1',
      A2 => '0',
      A1 => '1',
      A0 => '0',
      CLK => refclk_bufg_i,
      Q => idelayctrl_reset_0_i
    );

    --------------------------------------------------------------------------
    -- GMII PHY side transmit clock for EMAC0
    --------------------------------------------------------------------------


    tx_gmii_mii_clk_0_bufg : BUFGMUX
    port map (
        I0 => mii_tx_clk_0_i,
        I1 => tx_gmii_mii_clk_out_0_i,
        S  => speed_vector_0_i(1),
        O  => tx_gmii_mii_clk_in_0_i
      );


    --------------------------------------------------------------------------
    -- GMII PHY side Receiver Clock Management for EMAC0
    --------------------------------------------------------------------------
    gmii_rx_clk_0_ibufg : IBUFG --BUFIO --*** IBUFG (thanks matt weaver)
    port map (
        I => GMII_RX_CLK_0,
        O => gmii_rx_clk_ibufg_0_i
        );

    --*** comment on
    gmii_rx_clk_0_delay : IDELAY
    port map (
        I =>   gmii_rx_clk_ibufg_0_i,
        O =>   gmii_rx_clk_delay_0_i,
        C =>   gnd_i,
        CE =>  gnd_i,
        INC => gnd_i,
        RST => gnd_i
        );
    --*** comment off

    gmii_rx_clk_0_bufg : BUFG --BUFR --*** BUFG (thanks matt weaver)
    port map (
        I => gmii_rx_clk_delay_0_i, -- gmii_rx_clk_ibufg_0_i, --***gmii_rx_clk_delay_0_i,
        O => gmii_rx_clk_0_i
        --CE => '1',
        --CLR => '0'
        );

    --------------------------------------------------------------------------
    -- GMII client side transmit clock for EMAC0
    --------------------------------------------------------------------------
    --***mrmw
    --tx_client_clk_0_bufg : BUFG
    --port map (
    --    I => tx_client_clk_out_0_i,
    --    O => tx_client_clk_in_0_i
    --    );
    tx_client_clk_in_0_i <= tx_client_clk_out_0_i;

    --------------------------------------------------------------------------
    -- GMII client side receive clock for EMAC0
    --------------------------------------------------------------------------
    --***mrmw
    --rx_client_clk_0_bufg : BUFG
    --port map (
    --    I => rx_client_clk_out_0_i,
    --    O => rx_client_clk_in_0_i
    --    );
    rx_client_clk_in_0_i <= rx_client_clk_out_0_i;


    --------------------------------------------------------------------------
    -- MII PHY side Transmitter Clock Management for EMAC0
    --------------------------------------------------------------------------
    mii_tx_clk_0_ibufg : IBUFG
    port map (
        I => MII_TX_CLK_0,
        O => mii_tx_clk_0_i
        );


    --------------------------------------------------------------------------
    -- Connect previously derived client clocks to example design output ports
    --------------------------------------------------------------------------
    RX_CLIENT_CLK_0 <= rx_client_clk_in_0_i;
    TX_CLIENT_CLK_0 <= tx_client_clk_in_0_i;


    --------------------------------------------------------------------------
    -- Instantiate the EMAC Wrapper (eth_gmii.vhd)
    --------------------------------------------------------------------------
    v4_emac_top : eth_gmii
    port map (
        -- Client Receiver Interface - EMAC0
        EMAC0CLIENTRXCLIENTCLKOUT       => rx_client_clk_out_0_i,
        CLIENTEMAC0RXCLIENTCLKIN        => rx_client_clk_in_0_i,
        EMAC0CLIENTRXD                  => EMAC0CLIENTRXD,
        EMAC0CLIENTRXDVLD               => EMAC0CLIENTRXDVLD,
        EMAC0CLIENTRXDVLDMSW            => open,
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
        CLIENTEMAC0TXD                  => CLIENTEMAC0TXD,
        CLIENTEMAC0TXDVLD               => CLIENTEMAC0TXDVLD,
        CLIENTEMAC0TXDVLDMSW            => gnd_i,
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

        EMAC0CLIENTTXGMIIMIICLKOUT      => tx_gmii_mii_clk_out_0_i,
        CLIENTEMAC0TXGMIIMIICLKIN       => tx_gmii_mii_clk_in_0_i,

        -- GMII Interface - EMAC0
        GMII_TXD_0                      => gmii_txd_0_i,
        GMII_TX_EN_0                    => gmii_tx_en_0_i,
        GMII_TX_ER_0                    => gmii_tx_er_0_i,
        GMII_TX_CLK_0                   => gmii_tx_clk_0_i,
        GMII_RXD_0                      => gmii_rxd_0_r,
        GMII_RX_DV_0                    => gmii_rx_dv_0_r,
        GMII_RX_ER_0                    => gmii_rx_er_0_r,
        GMII_RX_CLK_0                   => gmii_rx_clk_0_i,

        --MII_TX_CLK_0                    => mii_tx_clk_0_i,
        MII_TX_CLK_0                    => tx_gmii_mii_clk_in_0_i,
        GMII_COL_0                      => gmii_col_0_i,
        GMII_CRS_0                      => gmii_crs_0_i,

        -- MDIO Interface - EMAC0
        MDC_0                           => mdc_out_0_i,
        MDIO_IN_0                       => mdio_in_0_i,
        MDIO_OUT_0                      => mdio_out_0_i,
        MDIO_TRI_0                      => mdio_tri_0_i,

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

        DCM_LOCKED_0                    => vcc_i,

        -- Asynchronous Reset
        RESET                           => reset_i
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




  -- The Host clock (HOSTCLK on EMAC primitive) must always be driven.
  -- In this example design it is kept as a standalone signal.  However,
  -- this can be shared with one of the other clock sources, for
  -- example, one of the 125MHz PHYEMAC#GTX clock inputs.

  -- host_clk : IBUF port map (I => HOSTCLK, O => host_clk_i);
  
  host_clk_i <= HOSTCLK;
    





 process_emac0_mode_write : process (HOSTOPCODE , HOSTEMAC1SEL, HOSTADDR, HOSTMIIMSEL) begin
    if (HOSTADDR(9 downto 0) = "1100000000") then
         emac0_mode_write <= not(HOSTOPCODE(1)) and not(HOSTEMAC1SEL) and not(HOSTMIIMSEL);
    else
         emac0_mode_write <= '0';
    end if;
 end process process_emac0_mode_write;


 process_capture_speed_vector_0: process(host_clk_i, reset_i) begin 
   if (reset_i = '1') then 
      capture_speed_vector_0 <= "00";
   elsif host_clk_i'event and host_clk_i = '1' then    
      if emac0_mode_write = '1' then
         capture_speed_vector_0 <= HOSTWRDATA(31 downto 30);
      end if;
   end if;
 end process process_capture_speed_vector_0;

 speed_vector_0_i <= capture_speed_vector_0;




end TOP_LEVEL;
