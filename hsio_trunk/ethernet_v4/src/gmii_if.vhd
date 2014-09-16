------------------------------------------------------------------------
-- Title      : Gigabit Media Independent Interface (GMII) Physical I/F
-- Project    : Virtex-4 FX Ethernet MAC Wrappers
------------------------------------------------------------------------
-- File       : gmii_if.vhd
------------------------------------------------------------------------
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

------------------------------------------------------------------------
-- Description:  This module creates a Gigabit Media Independent 
--               Interface (GMII) by instantiating Input/Output buffers  
--               and Input/Output flip-flops as required.
--
--               This interface is used to connect the Ethernet MAC to
--               an external 1000Mb/s (or Tri-speed) Ethernet PHY.
------------------------------------------------------------------------

library unisim;
use unisim.vcomponents.all;

library ieee;
use ieee.std_logic_1164.all;

------------------------------------------------------------------------------
-- The entity declaration for the PHY IF design.
------------------------------------------------------------------------------
entity gmii_if is
    port(
        RESET                         : in  std_logic;
        -- GMII Interface
        GMII_TXD                      : out std_logic_vector(7 downto 0);
        GMII_TX_EN                    : out std_logic;
        GMII_TX_ER                    : out std_logic;
        GMII_TX_CLK                   : out std_logic;
        GMII_RXD                      : in  std_logic_vector(7 downto 0);
        GMII_RX_DV                    : in  std_logic;
        GMII_RX_ER                    : in  std_logic;
        -- MAC Interface
        TXD_FROM_MAC                  : in  std_logic_vector(7 downto 0);
        TX_EN_FROM_MAC                : in  std_logic;
        TX_ER_FROM_MAC                : in  std_logic;
        TX_CLK                        : in  std_logic;
        RXD_TO_MAC                    : out std_logic_vector(7 downto 0);
        RX_DV_TO_MAC                  : out std_logic;
        RX_ER_TO_MAC                  : out std_logic;
        RX_CLK                        : in  std_logic);
end gmii_if;

architecture PHY_IF of gmii_if is

  signal gmii_tx_clk_i      : std_logic;
  signal vcc_i              : std_logic;
  signal gnd_i              : std_logic;

  signal gmii_tx_en_r       : std_logic;
  signal gmii_tx_er_r       : std_logic;
  signal gmii_txd_r         : std_logic_vector(7 downto 0);

  signal gmii_rx_dv_i       : std_logic;
  signal gmii_rx_er_i       : std_logic;
  signal gmii_rxd_i         : std_logic_vector(7 downto 0);
  signal gmii_rx_dv_delay_i : std_logic;
  signal gmii_rx_er_delay_i : std_logic;
  signal gmii_rxd_delay_i   : std_logic_vector(7 downto 0);

begin

  vcc_i <= '1';
  gnd_i <= '0';

  --------------------------------------------------------------------------
  -- GMII Transmitter Clock Management
  --------------------------------------------------------------------------
  -- Instantiate a DDR output register.  This is a good way to drive
  -- GMII_TX_CLK since the clock-to-PAD delay will be the same as that for
  -- data driven from IOB Ouput flip-flops eg GMII_TXD[7:0].
  gmii_tx_clk_oddr : ODDR
  port map (
      Q => gmii_tx_clk_i,
      C => TX_CLK,
      CE => vcc_i,
      D1 => gnd_i,
      D2 => vcc_i,
      R => RESET,
      S => gnd_i
  );

  gmii_tx_clk_obuf : OBUF 
  port map (
      I => gmii_tx_clk_i, 
      O => GMII_TX_CLK
      );

  --------------------------------------------------------------------------
  -- GMII Transmitter Logic : Drive TX signals through IOBs onto GMII
  -- interface
  --------------------------------------------------------------------------
  -- Infer IOB Output flip-flops.
  gmii_output_ffs : process (TX_CLK, RESET)
  begin
      if RESET = '1' then
          gmii_tx_en_r <= '0';
          gmii_tx_er_r <= '0';
          gmii_txd_r   <= (others => '0');
      elsif TX_CLK'event and TX_CLK = '1' then
          gmii_tx_en_r <= TX_EN_FROM_MAC;
          gmii_tx_er_r <= TX_ER_FROM_MAC;
          gmii_txd_r   <= TXD_FROM_MAC;
      end if;
  end process gmii_output_ffs;

  -- Drive GMII TX signals through Output Buffers and onto PADS
  gmii_tx_en_obuf : OBUF port map (I => gmii_tx_en_r, O => GMII_TX_EN);
  gmii_tx_er_obuf : OBUF port map (I => gmii_tx_er_r, O => GMII_TX_ER);

  gmii_txd_bus: for I in 7 downto 0 generate
      gmii_txd_0_obuf : OBUF 
      port map (
          I => gmii_txd_r(I),
          O => GMII_TXD(I)
          );
  end generate;

  --------------------------------------------------------------------------
  -- GMII Receiver Logic : Receive RX signals through IOBs from GMII
  -- interface
  --------------------------------------------------------------------------
  -- Drive input GMII Rx signals from PADS through Input Buffers and then 
  -- use IDELAYs to provide Zero-Hold Time Delay 
  gmii_rx_dv_ibuf: IBUF port map (I => GMII_RX_DV, O => gmii_rx_dv_i);

  gmii_rx_er_ibuf: IBUF port map (I => GMII_RX_ER, O => gmii_rx_er_i);

  gmii_rxd_bus: for I in 7 downto 0 generate
      gmii_rxd_ibuf: IBUF
      port map (
          I => GMII_RXD(I),
          O => gmii_rxd_i(I)
          );
  end generate;

  -- Use IDELAY to delay the data relative to the clock.
  -- The IDELAY is configured in Fixed Tap Delay Mode.  Each tap delay is 78 ps.
  -- The attributes can be changed in the UCF file.
  gmii_rxd_delay_bus: for I in 7 downto 0 generate
    gmii_rxd0_delay : IDELAY
    generic map (
        IOBDELAY_TYPE => "FIXED",
        IOBDELAY_VALUE => 0
        )
    port map (
        I   => gmii_rxd_i(I),
        O   => gmii_rxd_delay_i(I),
        C   => gnd_i,
        CE  => gnd_i,
        INC => gnd_i,
        RST => gnd_i
        );
  end generate;

  gmii_rx_dv_delay : IDELAY
  generic map (
      IOBDELAY_TYPE => "FIXED",
      IOBDELAY_VALUE => 0
      )
  port map (
      I   => gmii_rx_dv_i,
      O   => gmii_rx_dv_delay_i,
      C   => gnd_i,
      CE  => gnd_i,
      INC => gnd_i,
      RST => gnd_i
      );

  gmii_rx_er_delay : IDELAY
  generic map (
      IOBDELAY_TYPE => "FIXED",
      IOBDELAY_VALUE => 0
      )
  port map (
      I   => gmii_rx_er_i,
      O   => gmii_rx_er_delay_i,
      C   => gnd_i,
      CE  => gnd_i,
      INC => gnd_i,
      RST => gnd_i
      );
  
  -- Infer IOB Input flip-flops
  gmii_input_ffs : process (RX_CLK, RESET)
  begin
      if RESET = '1' then
          RX_DV_TO_MAC <= '0';
          RX_ER_TO_MAC <= '0';
          RXD_TO_MAC   <= (others => '0');
      elsif RX_CLK'event and RX_CLK = '1' then
          RX_DV_TO_MAC <= gmii_rx_dv_delay_i;
          RX_ER_TO_MAC <= gmii_rx_er_delay_i;
          RXD_TO_MAC   <= gmii_rxd_delay_i;
      end if;
  end process gmii_input_ffs;

end PHY_IF;
