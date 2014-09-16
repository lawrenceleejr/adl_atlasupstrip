------------------------------------------------------------------------
-- Title      : Demo testbench
-- Project    : Virtex-4 FX Ethernet MAC Wrappers
------------------------------------------------------------------------
-- File       : demo_tb.vhd
------------------------------------------------------------------------
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
------------------------------------------------------------------------
-- Description: This testbench will exercise the PHY ports of the EMAC
--              to demonstrate the functionality.
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity testbench is
end testbench;


architecture behavioral of testbench is


  ----------------------------------------------------------------------
  -- Component Declaration for eth2x_top
  --                           (the top level EMAC example deisgn)
  ----------------------------------------------------------------------
  component eth2x_example_design 
    port(
--        RX_CLIENT_CLK_0                 : out std_logic;
--        TX_CLIENT_CLK_0                 : out std_logic;
        -- 1000BASE-X PCS/PMA Interface - EMAC0
        TXP_0                           : out std_logic;
        TXN_0                           : out std_logic;
        RXP_0                           : in  std_logic;
        RXN_0                           : in  std_logic;
        EMAC0CLIENTSYNCACQSTATUS        : out std_logic;

        -- MDIO Interface - EMAC0
        MDC_0                           : out std_logic;
        MDIO_0_I                       : in  std_logic;
        MDIO_0_O                      : out std_logic;
        MDIO_0_T                      : out std_logic;

--        RX_CLIENT_CLK_1                 : out std_logic;
--        TX_CLIENT_CLK_1                 : out std_logic;
        -- 1000BASE-X PCS/PMA Interface - EMAC1
        TXP_1                           : out std_logic;
        TXN_1                           : out std_logic;
        RXP_1                           : in  std_logic;
        RXN_1                           : in  std_logic;
        EMAC1CLIENTSYNCACQSTATUS        : out std_logic;

        -- MDIO Interface - EMAC1
        MDC_1                           : out std_logic;
        MDIO_1_I                       : in  std_logic;
        MDIO_1_O                      : out std_logic;
        MDIO_1_T                      : out std_logic;
        MGTCLK_P                        : in  std_logic;
        MGTCLK_N                        : in  std_logic;

       -- Calibration Block clock
        DCLK                            : in  std_logic;

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
  end component;


  component configuration_tb is
    port(
      reset                       : out std_logic;
      ------------------------------------------------------------------
      -- Host Interface
      ------------------------------------------------------------------
      host_clk                    : out std_logic;
      host_opcode                 : out std_logic_vector(1 downto 0);
      host_req                    : out std_logic;
      host_miim_sel               : out std_logic;
      host_addr                   : out std_logic_vector(9 downto 0);
      host_wr_data                : out std_logic_vector(31 downto 0);
      host_miim_rdy               : in  std_logic;
      host_rd_data                : in  std_logic_vector(31 downto 0);
      host_emac1_sel              : out std_logic;

      ------------------------------------------------------------------
      -- Test Bench Semaphores
      ------------------------------------------------------------------
      sync_acq_status_0           : in  std_logic;
      sync_acq_status_1           : in  std_logic;

      emac0_configuration_busy    : out boolean;
      emac0_monitor_finished_1g   : in  boolean;
      emac0_monitor_finished_100m : in  boolean;
      emac0_monitor_finished_10m  : in  boolean;

      emac1_configuration_busy    : out boolean;
      emac1_monitor_finished_1g   : in  boolean;
      emac1_monitor_finished_100m : in  boolean;
      emac1_monitor_finished_10m  : in  boolean

      );
  end component;


  ----------------------------------------------------------------------
  -- Component Declaration for the EMAC0 PHY stimulus and monitor
  ----------------------------------------------------------------------

  component emac0_phy_tb is
    port(
      clk125m                 : in std_logic;

      ------------------------------------------------------------------
      -- GMII Interface
      ------------------------------------------------------------------
      txp                     : in  std_logic;
      txn                     : in  std_logic;
      rxp                     : out std_logic;
      rxn                     : out std_logic;

      ------------------------------------------------------------------
      -- Test Bench Semaphores
      ------------------------------------------------------------------
      configuration_busy      : in  boolean;
      monitor_finished_1g     : out boolean;
      monitor_finished_100m   : out boolean;
      monitor_finished_10m    : out boolean
      );
  end component;



  ----------------------------------------------------------------------
  -- Component Declaration for the EMAC1 PHY stimulus and monitor
  ----------------------------------------------------------------------

  component emac1_phy_tb is
    port(
      clk125m                 : in std_logic;

      ------------------------------------------------------------------
      -- GMII Interface
      ------------------------------------------------------------------
      txp                     : in  std_logic;
      txn                     : in  std_logic;
      rxp                     : out std_logic;
      rxn                     : out std_logic;

      ------------------------------------------------------------------
      -- Test Bench Semaphores
      ------------------------------------------------------------------
      configuration_busy      : in  boolean;
      monitor_finished_1g     : out boolean;
      monitor_finished_100m   : out boolean;
      monitor_finished_10m    : out boolean
      );
  end component;


  ----------------------------------------------------------------------
  -- testbench signals
  ----------------------------------------------------------------------
    signal reset                : std_logic                     := '1';

    -- EMAC0
    signal tx_client_clk_0      : std_logic;
    signal tx_ifg_delay_0       : std_logic_vector(7 downto 0)  := (others => '0'); -- IFG stretching not used in demo.
    signal rx_client_clk_0      : std_logic;
    signal pause_val_0          : std_logic_vector(15 downto 0) := (others => '0');
    signal pause_req_0          : std_logic                     := '0';

    -- 1000BASE-X PCS/PMA Signals
    signal txp_0                : std_logic;
    signal txn_0                : std_logic;
    signal rxp_0                : std_logic;
    signal rxn_0                : std_logic;
    signal sync_acq_status_0    : std_logic;

    -- MDIO Signals
    signal mdc_0                : std_logic;
    signal mdc_in_0             : std_logic                     := '1';
    signal mdio_in_0            : std_logic;
    signal mdio_out_0           : std_logic;
    signal mdio_tri_0           : std_logic;

    -- EMAC1
    signal tx_client_clk_1      : std_logic;
    signal tx_ifg_delay_1       : std_logic_vector(7 downto 0)  := (others => '0'); -- IFG stretching not used in demo.
    signal rx_client_clk_1      : std_logic;
    signal pause_val_1          : std_logic_vector(15 downto 0) := (others => '0');
    signal pause_req_1          : std_logic                     := '0';

    -- 1000BASE-X PCS/PMA Signals
    signal txp_1                : std_logic;
    signal txn_1                : std_logic;
    signal rxp_1                : std_logic;
    signal rxn_1                : std_logic;
    signal sync_acq_status_1    : std_logic;

    -- MDIO Signals
    signal mdc_1                : std_logic;
    signal mdc_in_1             : std_logic                     := '1';
    signal mdio_in_1            : std_logic;
    signal mdio_out_1           : std_logic;
    signal mdio_tri_1           : std_logic;

    -- Host Signals
    signal host_opcode          : std_logic_vector(1 downto 0)  := (others => '1');
    signal host_addr            : std_logic_vector(9 downto 0)  := (others => '1');
    signal host_wr_data         : std_logic_vector(31 downto 0) := (others => '0');
    signal host_rd_data         : std_logic_vector(31 downto 0);
    signal host_miim_sel        : std_logic                     := '0';
    signal host_req             : std_logic                     := '0';
    signal host_miim_rdy        : std_logic;
    signal host_emac1_sel       : std_logic                     := '0';


    -- Clock signals
    signal host_clk             : std_logic                     := '0';
    signal gtx_clk              : std_logic;
    signal clk250m              : std_logic;
    signal dclk                 : std_logic;

    signal mgtclk_p             : std_logic := '0';
    signal mgtclk_n             : std_logic := '1';

    ------------------------------------------------------------------
    -- Test Bench Semaphores
    ------------------------------------------------------------------
    signal emac0_configuration_busy    : boolean := false;
    signal emac0_monitor_finished_1g   : boolean := false;
    signal emac0_monitor_finished_100m : boolean := false;
    signal emac0_monitor_finished_10m  : boolean := false;

    signal emac1_configuration_busy    : boolean := false;
    signal emac1_monitor_finished_1g   : boolean := false;
    signal emac1_monitor_finished_100m : boolean := false;
    signal emac1_monitor_finished_10m  : boolean := false;


begin


  ----------------------------------------------------------------------
  -- Wire up Device Under Test
  ----------------------------------------------------------------------
  dut : eth2x_example_design 
  port map (
    EMAC0CLIENTSYNCACQSTATUS        => sync_acq_status_0,
--    RX_CLIENT_CLK_0                 => rx_client_clk_0,
--    TX_CLIENT_CLK_0                 => tx_client_clk_0,
    -- 1000BASE-X PCS/PMA Interface - EMAC0
    TXP_0                           => txp_0,
    TXN_0                           => txn_0,
    RXP_0                           => rxp_0,
    RXN_0                           => rxn_0,

    -- MDIO Interface - EMAC0
    MDC_0                           => mdc_0,
    MDIO_0_I                       => mdio_in_0,
    MDIO_0_O                      => mdio_out_0,
    MDIO_0_T                      => mdio_tri_0,

    EMAC1CLIENTSYNCACQSTATUS        => sync_acq_status_1,
--    RX_CLIENT_CLK_1                 => rx_client_clk_1,
--    TX_CLIENT_CLK_1                 => tx_client_clk_1,
    -- 1000BASE-X PCS/PMA Interface - EMAC1
    TXP_1                           => txp_1,
    TXN_1                           => txn_1,
    RXP_1                           => rxp_1,
    RXN_1                           => rxn_1,

    -- MDIO Interface - EMAC1
    MDC_1                           => mdc_1,
    MDIO_1_I                       => mdio_in_1,
    MDIO_1_O                      => mdio_out_1,
    MDIO_1_T                      => mdio_tri_1,

    MGTCLK_P                        =>  mgtclk_p,
    MGTCLK_N                        =>  mgtclk_n,

   -- Calibration Block Clock
    DCLK                            => dclk,

    -- Host Interface
    HOSTOPCODE                      => host_opcode,
    HOSTREQ                         => host_req,
    HOSTMIIMSEL                     => host_miim_sel,
    HOSTADDR                        => host_addr,
    HOSTWRDATA                      => host_wr_data,
    HOSTMIIMRDY                     => host_miim_rdy,
    HOSTRDDATA                      => host_rd_data,
    HOSTEMAC1SEL                    => host_emac1_sel,


    HOSTCLK                         => host_clk,


    -- Asynchronous Reset
    RESET                           => reset
    );


    ----------------------------------------------------------------------------
    -- Flow Control is unused in this demonstration
    ----------------------------------------------------------------------------
    pause_req_0 <= '0';
    pause_val_0 <= "0000000000000000";
    pause_req_1 <= '0';
    pause_val_1 <= "0000000000000000";



    ----------------------------------------------------------------------------
    -- Simulate the MDIO_IN port floating high
    ----------------------------------------------------------------------------
    mdio_in_0 <= 'H';
    mdio_in_1 <= 'H';


    ----------------------------------------------------------------------------
    -- Clock drivers
    ----------------------------------------------------------------------------

    -- Drive GTX_CLK at 125 MHz
    p_gtx_clk : process
    begin
        gtx_clk <= '0';
        wait for 10 ns;
        loop
            wait for 4 ns;
            gtx_clk <= '1';
            wait for 4 ns;
            gtx_clk <= '0';
        end loop;
    end process p_gtx_clk;


    -- Drive MGT clock at 250 MHz
    p_clk250m : process
    begin
        clk250m <= '0';
        wait for 10 ns;
        loop
            wait for 2 ns;
            clk250m <= '1';
            wait for 2 ns;
            clk250m <= '0';
        end loop;
    end process p_clk250m;


    -- Drive Calibration Block clock at 50 MHz
    p_dclk : process
    begin
        dclk <= '0';
        wait for 10 ns;
        loop
            wait for 10 ns;
            dclk <= '1';
            wait for 10 ns;
            dclk <= '0';
        end loop;
    end process p_dclk;


    -- Drive Gigabit Transceiver differential clock with 125MHz
    mgtclk_p <= clk250m;
    mgtclk_n <= not clk250m;


  ----------------------------------------------------------------------
  -- Instantiate the EMAC0 PHY stimulus and monitor
  ----------------------------------------------------------------------

  phy0_test: emac0_phy_tb
    port map (
      clk125m                 => gtx_clk,

      ------------------------------------------------------------------
      -- GMII Interface
      ------------------------------------------------------------------
      txp                     => txp_0,
      txn                     => txn_0,
      rxp                     => rxp_0,
      rxn                     => rxn_0,

      ------------------------------------------------------------------
      -- Test Bench Semaphores
      ------------------------------------------------------------------
      configuration_busy      => emac0_configuration_busy,
      monitor_finished_1g     => emac0_monitor_finished_1g,
      monitor_finished_100m   => emac0_monitor_finished_100m,
      monitor_finished_10m    => emac0_monitor_finished_10m
      );



  ----------------------------------------------------------------------
  -- Instantiate the EMAC1 PHY stimulus and monitor
  ----------------------------------------------------------------------

  phy1_test: emac1_phy_tb
    port map (
      clk125m                 => gtx_clk,

      ------------------------------------------------------------------
      -- GMII Interface
      ------------------------------------------------------------------
      txp                     => txp_1,
      txn                     => txn_1,
      rxp                     => rxp_1,
      rxn                     => rxn_1,

      ------------------------------------------------------------------
      -- Test Bench Semaphores
      ------------------------------------------------------------------
      configuration_busy      => emac1_configuration_busy,
      monitor_finished_1g     => emac1_monitor_finished_1g,
      monitor_finished_100m   => emac1_monitor_finished_100m,
      monitor_finished_10m    => emac1_monitor_finished_10m
      );



  ----------------------------------------------------------------------
  -- Instantiate the Host Configuration Stimulus
  ----------------------------------------------------------------------

  config_test: configuration_tb
    port map (
      reset                       => reset,
      ------------------------------------------------------------------
      -- Host Interface
      ------------------------------------------------------------------
      host_clk                    => host_clk,
      host_opcode                 => host_opcode,
      host_req                    => host_req,
      host_miim_sel               => host_miim_sel,
      host_addr                   => host_addr,
      host_wr_data                => host_wr_data,
      host_miim_rdy               => host_miim_rdy,
      host_rd_data                => host_rd_data,
      host_emac1_sel              => host_emac1_sel,

      ------------------------------------------------------------------
      -- Test Bench Semaphores
      ------------------------------------------------------------------
      sync_acq_status_0           => sync_acq_status_0,
      sync_acq_status_1           => sync_acq_status_1,

      emac0_configuration_busy    => emac0_configuration_busy,
      emac0_monitor_finished_1g   => emac0_monitor_finished_1g,
      emac0_monitor_finished_100m => emac0_monitor_finished_100m,
      emac0_monitor_finished_10m  => emac0_monitor_finished_10m,

      emac1_configuration_busy    => emac1_configuration_busy,
      emac1_monitor_finished_1g   => emac1_monitor_finished_1g,
      emac1_monitor_finished_100m => emac1_monitor_finished_100m,
      emac1_monitor_finished_10m  => emac1_monitor_finished_10m

      );





end behavioral;

