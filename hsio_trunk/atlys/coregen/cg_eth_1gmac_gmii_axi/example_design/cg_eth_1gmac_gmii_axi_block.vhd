--------------------------------------------------------------------------------
-- File       : cg_eth_1gmac_gmii_axi_block.vhd
-- Author     : Xilinx Inc.
-- -----------------------------------------------------------------------------
-- (c) Copyright 2004-2009 Xilinx, Inc. All rights reserved.
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
-- -----------------------------------------------------------------------------
-- Description: This is the block level VHDL design for the Tri-Mode
--              Ethernet MAC Example Design.
--
--              This block level:
--
--              * instantiates appropriate PHY interface module (GMII/MII/RGMII)
--                as required based on the user configuration;
--
--              * instantiates appropriate PHY interface module (GMII/MII/RGMII)
--                as required based on the user configuration;
--
--              Please refer to the Datasheet, Getting Started Guide, and
--              the Tri-Mode Ethernet MAC User Gude for further information.
--
--
--              -----------------------------------------|
--              | BLOCK LEVEL WRAPPER                    |
--              |                                        |
--              |    ---------------------               |
--              |    | ETHERNET MAC      |               |
--              |    | CORE              |  ---------    |
--              |    |                   |  |       |    |
--            --|--->| Tx            Tx  |--|       |--->|
--              |    | AXI           PHY |  |       |    |
--              |    | I/F           I/F |  |       |    |
--              |    |                   |  | PHY   |    |
--              |    |                   |  | I/F   |    |
--              |    |                   |  |       |    |
--              |    | Rx            Rx  |  |       |    |
--              |    | AXI           PHY |  |       |    |
--            <-|----| I/F           I/F |<-|       |<---|
--              |    |                   |  ---------    |
--              |    |                   |               |
--              |    ---------------------               |
--              |                                        |
--              -----------------------------------------|
--


library unisim;
use unisim.vcomponents.all;

library ieee;
use ieee.std_logic_1164.all;


--------------------------------------------------------------------------------
-- The entity declaration for the block level example design.
--------------------------------------------------------------------------------

entity cg_eth_1gmac_gmii_axi_block is
   port(
      gtx_clk                    : in  std_logic;
      -- asynchronous reset
      glbl_rstn                  : in  std_logic;
      rx_axi_rstn                : in  std_logic;
      tx_axi_rstn                : in  std_logic;

      -- Receiver Interface
      ----------------------------
      rx_statistics_vector       : out std_logic_vector(27 downto 0);
      rx_statistics_valid        : out std_logic;

      rx_mac_aclk                : out std_logic;
      rx_reset                   : out std_logic;
      rx_axis_mac_tdata          : out std_logic_vector(7 downto 0);
      rx_axis_mac_tvalid         : out std_logic;
      rx_axis_mac_tlast          : out std_logic;
      rx_axis_mac_tuser          : out std_logic;

      -- Transmitter Interface
      -------------------------------
      tx_ifg_delay               : in  std_logic_vector(7 downto 0);
      tx_statistics_vector       : out std_logic_vector(31 downto 0);
      tx_statistics_valid        : out std_logic;

      tx_mac_aclk                : out std_logic;
      tx_reset                   : out std_logic;
      tx_axis_mac_tdata          : in  std_logic_vector(7 downto 0);
      tx_axis_mac_tvalid         : in  std_logic;
      tx_axis_mac_tlast          : in  std_logic;
      tx_axis_mac_tuser          : in  std_logic;
      tx_axis_mac_tready         : out std_logic;
      tx_collision               : out std_logic;
      tx_retransmit              : out std_logic;

      -- MAC Control Interface
      ------------------------
      pause_req                  : in  std_logic;
      pause_val                  : in  std_logic_vector(15 downto 0);

      -- GMII Interface
      -----------------
      gmii_txd                   : out std_logic_vector(7 downto 0);
      gmii_tx_en                 : out std_logic;
      gmii_tx_er                 : out std_logic;
      gmii_tx_clk                : out std_logic;
      gmii_rxd                   : in  std_logic_vector(7 downto 0);
      gmii_rx_dv                 : in  std_logic;
      gmii_rx_er                 : in  std_logic;
      gmii_rx_clk                : in  std_logic;
      gmii_col                   : in  std_logic;
      gmii_crs                   : in  std_logic;

      -- Configuration Vector
      -----------------------
      rx_configuration_vector    : in  std_logic_vector(79 downto 0);
      tx_configuration_vector    : in  std_logic_vector(79 downto 0)
   );
end cg_eth_1gmac_gmii_axi_block;


architecture wrapper of cg_eth_1gmac_gmii_axi_block is


   -----------------------------------------------------------------------------
   -- Component Declaration for TEMAC (the Tri-Mode EMAC core).
   -----------------------------------------------------------------------------
   component cg_eth_1gmac_gmii_axi
    port(
      glbl_rstn                   : in  std_logic;
      rx_axi_rstn                 : in  std_logic;
      tx_axi_rstn                 : in  std_logic;

      -- Receiver Interface
      ----------------------------
      rx_axi_clk                  : in std_logic;
      rx_reset_out                : out std_logic;
      rx_axis_mac_tdata           : out std_logic_vector(7 downto 0);
      rx_axis_mac_tvalid          : out std_logic;
      rx_axis_mac_tlast           : out std_logic;
      rx_axis_mac_tuser           : out std_logic;

      rx_statistics_vector        : out std_logic_vector(27 downto 0);
      rx_statistics_valid         : out std_logic;

      -- Transmitter Interface
      -------------------------------
      tx_axi_clk                  : in std_logic;
      tx_reset_out                : out std_logic;
      tx_axis_mac_tdata           : in  std_logic_vector(7 downto 0);
      tx_axis_mac_tvalid          : in  std_logic;
      tx_axis_mac_tlast           : in  std_logic;
      tx_axis_mac_tuser           : in  std_logic_vector(0 downto 0);
      tx_axis_mac_tready          : out std_logic;

      tx_retransmit               : out std_logic;
      tx_collision                : out std_logic;
      tx_ifg_delay                : in  std_logic_vector(7 downto 0);
      tx_statistics_vector        : out std_logic_vector(31 downto 0);
      tx_statistics_valid         : out std_logic;

      -- MAC Control Interface
      ------------------------
      pause_req                   : in  std_logic;
      pause_val                   : in  std_logic_vector(15 downto 0);

      -- Current Speed Indication
      ---------------------------
      speed_is_100                : out std_logic;
      speed_is_10_100             : out std_logic;

      -- Physical Interface of the core
      --------------------------------
      gmii_txd                    : out std_logic_vector(7 downto 0);
      gmii_tx_en                  : out std_logic;
      gmii_tx_er                  : out std_logic;
      gmii_col                    : in  std_logic;
      gmii_crs                    : in  std_logic;
      gmii_rxd                    : in  std_logic_vector(7 downto 0);
      gmii_rx_dv                  : in  std_logic;
      gmii_rx_er                  : in  std_logic;

      -- Configuration Vector
      -----------------------
      rx_mac_config_vector        : in std_logic_vector(79 downto 0);
      tx_mac_config_vector        : in std_logic_vector(79 downto 0)
   );
   end component;


   -----------------------------------------------------------------------------
   -- Component Declaration for the GMII IOB logic
   -----------------------------------------------------------------------------
   component cg_eth_1gmac_gmii_axi_gmii_if
   port(
      -- Synchronous resets
      tx_reset             : in  std_logic;
      rx_reset             : in  std_logic;

      -- The following ports are the GMII physical interface: these will be at
      -- pins on the FPGA
      gmii_txd             : out std_logic_vector(7 downto 0);
      gmii_tx_en           : out std_logic;
      gmii_tx_er           : out std_logic;
      gmii_tx_clk          : out std_logic;
      gmii_crs             : in  std_logic;
      gmii_col             : in  std_logic;
      gmii_rxd             : in  std_logic_vector(7 downto 0);
      gmii_rx_dv           : in  std_logic;
      gmii_rx_er           : in  std_logic;
      gmii_rx_clk          : in  std_logic;

      -- The following ports are the internal GMII connections from IOB logic
      -- to the TEMAC core
      txd_from_mac         : in  std_logic_vector(7 downto 0);
      tx_en_from_mac       : in  std_logic;
      tx_er_from_mac       : in  std_logic;
      tx_clk               : in  std_logic;
      crs_to_mac           : out std_logic;
      col_to_mac           : out std_logic;
      rxd_to_mac           : out std_logic_vector(7 downto 0);
      rx_dv_to_mac         : out std_logic;
      rx_er_to_mac         : out std_logic;

      -- Receiver clock for the MAC and Client Logic
      rx_clk               : out  std_logic
   );
   end component;


  ------------------------------------------------------------------------------
  -- Component declaration for the synchronisation flip-flop pair
  ------------------------------------------------------------------------------
  component cg_eth_1gmac_gmii_axi_sync_block
  port (
    clk                    : in  std_logic;    -- clock to be sync'ed to
    data_in                : in  std_logic;    -- Data to be 'synced'
    data_out               : out std_logic     -- synced data
    );
  end component;


  ------------------------------------------------------------------------------
  -- Component declaration for the reset synchroniser
  ------------------------------------------------------------------------------
  component cg_eth_1gmac_gmii_axi_reset_sync
  port (
    reset_in               : in  std_logic;    -- Active high asynchronous reset
    enable                 : in  std_logic;
    clk                    : in  std_logic;    -- clock to be sync'ed to
    reset_out              : out std_logic     -- "Synchronised" reset signal
    );
  end component;


  ------------------------------------------------------------------------------
  -- internal signals used in this block level wrapper.
  ------------------------------------------------------------------------------

  attribute keep : string;

  signal glbl_rst                : std_logic;
  signal gmii_tx_en_int          : std_logic;                     -- Internal gmii_tx_en signal.
  signal gmii_tx_er_int          : std_logic;                     -- Internal gmii_tx_er signal.
  signal gmii_txd_int            : std_logic_vector(7 downto 0);  -- Internal gmii_txd signal.
  signal gmii_rx_dv_int          : std_logic;                     -- gmii_rx_dv registered in IOBs.
  signal gmii_rx_er_int          : std_logic;                     -- gmii_rx_er registered in IOBs.
  signal gmii_rxd_int            : std_logic_vector(7 downto 0);  -- gmii_rxd registered in IOBs.
  signal gmii_col_int            : std_logic;                     -- Collision signal from the PHY module
  signal gmii_crs_int            : std_logic;                     -- Carrier Sense signal from the PHY module


  signal speedis100              : std_logic;                     -- Asserted when speed is 100Mb/s.
  signal speedis10100            : std_logic;                     -- Asserted when speed is 10Mb/s or 100Mb/s.
  signal rx_mac_aclk_int         : std_logic;                     -- Internal receive gmii/mii clock signal.
  signal tx_mac_aclk_int         : std_logic;                     -- Internal transmit gmii/mii clock signal.

  signal tx_reset_int            : std_logic;                     -- Synchronous reset in the MAC and gmii Tx domain
  signal rx_reset_int            : std_logic;                     -- Synchronous reset in the MAC and gmii Rx domain


  signal rx_statistics_vector_int : std_logic_vector(27 downto 0);
  signal rx_statistics_valid_int  : std_logic;
  signal tx_statistics_vector_int : std_logic_vector(31 downto 0);
  signal tx_statistics_valid_int  : std_logic;

  signal bus2ip_clk                 : std_logic;
  signal bus2ip_reset               : std_logic;

  signal bus2ip_addr                : std_logic_vector(31 downto 0);
  signal bus2ip_cs                  : std_logic;
  signal bus2ip_rdce                : std_logic;
  signal bus2ip_wrce                : std_logic;
  signal bus2ip_data                : std_logic_vector(31 downto 0);
  signal ip2bus_data                : std_logic_vector(31 downto 0);
  signal ip2bus_wrack               : std_logic;
  signal ip2bus_rdack               : std_logic;
  signal ip2bus_error               : std_logic;
  signal tx_axis_mac_tuser_int      : std_logic_vector(0 downto 0);
  attribute keep of tx_mac_aclk_int    : signal is "true";
  attribute keep of rx_mac_aclk_int    : signal is "true";

begin

   -- assign outputs
   rx_reset <= rx_reset_int;
   tx_reset <= tx_reset_int;
   -- Assign the internal clock signals to output ports.
   tx_mac_aclk <= tx_mac_aclk_int;
   rx_mac_aclk <= rx_mac_aclk_int;

   glbl_rst <= not glbl_rstn;

   tx_mac_aclk_int <= gtx_clk after 1 ps;


   -----------------------------------------------------------------------------
   -- Instantiate GMII Interface
   -----------------------------------------------------------------------------

   -- Instantiate the GMII physical interface logic
   gmii_interface : cg_eth_1gmac_gmii_axi_gmii_if
   port map (
      -- Synchronous resets
      tx_reset          => tx_reset_int,
      rx_reset          => rx_reset_int,

      -- The following ports are the GMII physical interface: these will be at
      -- pins on the FPGA
      gmii_txd          => gmii_txd,
      gmii_tx_en        => gmii_tx_en,
      gmii_tx_er        => gmii_tx_er,
      gmii_tx_clk       => gmii_tx_clk,
      gmii_col          => gmii_col,
      gmii_crs          => gmii_crs,
      gmii_rxd          => gmii_rxd,
      gmii_rx_dv        => gmii_rx_dv,
      gmii_rx_er        => gmii_rx_er,
      gmii_rx_clk       => gmii_rx_clk,

      -- The following ports are the internal GMII connections from IOB logic
      -- to the TEMAC core
      txd_from_mac      => gmii_txd_int,
      tx_en_from_mac    => gmii_tx_en_int,
      tx_er_from_mac    => gmii_tx_er_int,
      tx_clk            => tx_mac_aclk_int,
      col_to_mac        => gmii_col_int,
      crs_to_mac        => gmii_crs_int,
      rxd_to_mac        => gmii_rxd_int,
      rx_dv_to_mac      => gmii_rx_dv_int,
      rx_er_to_mac      => gmii_rx_er_int,

      -- Receiver clock for the MAC and Client Logic
      rx_clk            => rx_mac_aclk_int
   );




   rx_statistics_vector <= rx_statistics_vector_int;
   rx_statistics_valid  <= rx_statistics_valid_int;
   tx_statistics_vector <= tx_statistics_vector_int;
   tx_statistics_valid  <= tx_statistics_valid_int;




   -----------------------------------------------------------------------------
   -- Instantiate the TEMAC core
   -----------------------------------------------------------------------------
   trimac_core : cg_eth_1gmac_gmii_axi
   port map (
      -- asynchronous reset
      glbl_rstn               => glbl_rstn,
      rx_axi_rstn             => rx_axi_rstn,
      tx_axi_rstn             => tx_axi_rstn,

      -- Receiver Interface
      rx_axi_clk              => rx_mac_aclk_int,
      rx_reset_out            => rx_reset_int,
      rx_axis_mac_tdata       => rx_axis_mac_tdata,
      rx_axis_mac_tvalid      => rx_axis_mac_tvalid,
      rx_axis_mac_tlast       => rx_axis_mac_tlast,
      rx_axis_mac_tuser       => rx_axis_mac_tuser,
      -- Receiver Statistics
      rx_statistics_vector    => rx_statistics_vector_int,
      rx_statistics_valid     => rx_statistics_valid_int,

      -- Transmitter Interface
      tx_axi_clk              => tx_mac_aclk_int,
      tx_reset_out            => tx_reset_int,
      tx_axis_mac_tdata       => tx_axis_mac_tdata,
      tx_axis_mac_tvalid      => tx_axis_mac_tvalid,
      tx_axis_mac_tlast       => tx_axis_mac_tlast,
      tx_axis_mac_tuser       => tx_axis_mac_tuser_int,
      tx_axis_mac_tready      => tx_axis_mac_tready,

      tx_collision            => tx_collision,
      tx_retransmit           => tx_retransmit,
      tx_ifg_delay            => tx_ifg_delay,
      -- Transmitter Statistics
      tx_statistics_vector    => tx_statistics_vector_int,
      tx_statistics_valid     => tx_statistics_valid_int,

      -- MAC Control Interface
      pause_req               => pause_req,
      pause_val               => pause_val,

      -- Current Speed Indication
      speed_is_100              => speedis100,
      speed_is_10_100           => speedis10100,

      -- Physical Interface of the core
      gmii_txd                => gmii_txd_int,
      gmii_tx_en              => gmii_tx_en_int,
      gmii_tx_er              => gmii_tx_er_int,
      gmii_crs                => gmii_crs_int,
      gmii_col                => gmii_col_int,
      gmii_rxd                => gmii_rxd_int,
      gmii_rx_dv              => gmii_rx_dv_int,
      gmii_rx_er              => gmii_rx_er_int,

      -- Configuration Vectors
      rx_mac_config_vector    => rx_configuration_vector,
      tx_mac_config_vector    => tx_configuration_vector


      );

	
   tx_axis_mac_tuser_int(0) <= tx_axis_mac_tuser;
  
  
end wrapper;
