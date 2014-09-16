-------------------------------------------------------------------------------
-- Title      : Virtex-4 Ethernet MAC Local Link Wrapper
-- Project    : Virtex-4 Ethernet MAC Wrappers
-------------------------------------------------------------------------------
-- File       : eth2x16_locallink.vhd
-------------------------------------------------------------------------------
-- Copyright (c) 2004-2006 by Xilinx, Inc. All rights reserved.
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
-- of this text at all times. (c) Copyright 2004-2006 Xilinx, Inc.
-- All rights reserved.

-------------------------------------------------------------------------------
-- Description: This level:
--
-- * instantiates the TEMAC top level file (the TEMAC
-- wrapper with the clocking and physical interface
-- logic;
--
-- * instantiates TX and RX reference design FIFO's with
-- a local link interface.
--
-- Please refer to the Datasheet, Getting Started Guide, and
-- the Virtex-4 Embedded Tri-Mode Ethernet MAC User Gude for
-- further information.
-------------------------------------------------------------------------------


-- hds interface_start
library unisim;
use unisim.vcomponents.all;

library ieee;
use ieee.std_logic_1164.all;

-- *** mod start
use work.eth_types.all;

-- *** mod end

-------------------------------------------------------------------------------
-- The entity declaration for the local link design.
-------------------------------------------------------------------------------
entity eth2x16_locallink is
   port( 
      -- Local link Receiver Interface - EMAC0
      RX_LL_CLOCK_0             : in     std_logic;
      RX_LL_RESET_0             : in     std_logic;
      RX_LL_DATA_0              : out    std_logic_vector (15 downto 0);
      RX_LL_SOF_N_0             : out    std_logic;
      RX_LL_EOF_N_0             : out    std_logic;
      RX_LL_SRC_RDY_N_0         : out    std_logic;
      RX_LL_DST_RDY_N_0         : in     std_logic;
      RX_LL_FIFO_STATUS_0       : out    std_logic_vector (3 downto 0);
      -- Local link Transmitter Interface - EMAC0
      TX_LL_CLOCK_0             : in     std_logic;
      TX_LL_RESET_0             : in     std_logic;
      TX_LL_DATA_0              : in     std_logic_vector (15 downto 0);
      TX_LL_SOF_N_0             : in     std_logic;
      TX_LL_EOF_N_0             : in     std_logic;
      TX_LL_SRC_RDY_N_0         : in     std_logic;
      TX_LL_DST_RDY_N_0         : out    std_logic;
		TX_LL_REM_0                     : in  std_logic;  -- Erdem 
      -- Client Receiver Interface - EMAC0
      EMAC0CLIENTRXDVLD         : out    std_logic;
      EMAC0CLIENTRXFRAMEDROP    : out    std_logic;
      EMAC0CLIENTRXSTATS        : out    std_logic_vector (6 downto 0);
      EMAC0CLIENTRXSTATSVLD     : out    std_logic;
      EMAC0CLIENTRXSTATSBYTEVLD : out    std_logic;
      -- Client Transmitter Interface - EMAC0
      CLIENTEMAC0TXIFGDELAY     : in     std_logic_vector (7 downto 0);
      EMAC0CLIENTTXSTATS        : out    std_logic;
      EMAC0CLIENTTXSTATSVLD     : out    std_logic;
      EMAC0CLIENTTXSTATSBYTEVLD : out    std_logic;
      -- MAC Control Interface - EMAC0
      CLIENTEMAC0PAUSEREQ       : in     std_logic;
      CLIENTEMAC0PAUSEVAL       : in     std_logic_vector (15 downto 0);
      --EMAC-MGT link status
      EMAC0CLIENTSYNCACQSTATUS  : out    std_logic;
      -- Clock Signals - EMAC0
      RX_CLIENT_CLK_0           : out    std_logic;
      TX_CLIENT_CLK_0           : out    std_logic;
      -- 1000BASE-X PCS/PMA Interface - EMAC0
      TXP_0                     : out    std_logic;
      TXN_0                     : out    std_logic;
      RXP_0                     : in     std_logic;
      RXN_0                     : in     std_logic;
      PHYAD_0                   : in     std_logic_vector (4 downto 0);
      RESETDONE_0               : out    std_logic;
      -- MDIO Interface - EMAC0
      MDC_0                     : out    std_logic;
      MDIO_0_I                  : in     std_logic;
      MDIO_0_O                  : out    std_logic;
      MDIO_0_T                  : out    std_logic;
      -- Local link Receiver Interface - EMAC1
      RX_LL_CLOCK_1             : in     std_logic;
      RX_LL_RESET_1             : in     std_logic;
      RX_LL_DATA_1              : out    std_logic_vector (15 downto 0);
      RX_LL_SOF_N_1             : out    std_logic;
      RX_LL_EOF_N_1             : out    std_logic;
      RX_LL_SRC_RDY_N_1         : out    std_logic;
      RX_LL_DST_RDY_N_1         : in     std_logic;
      RX_LL_FIFO_STATUS_1       : out    std_logic_vector (3 downto 0);
      -- Local link Transmitter Interface - EMAC1
      TX_LL_CLOCK_1             : in     std_logic;
      TX_LL_RESET_1             : in     std_logic;
      TX_LL_DATA_1              : in     std_logic_vector (15 downto 0);
      TX_LL_SOF_N_1             : in     std_logic;
      TX_LL_EOF_N_1             : in     std_logic;
      TX_LL_SRC_RDY_N_1         : in     std_logic;
      TX_LL_DST_RDY_N_1         : out    std_logic;
		TX_LL_REM_1                     : in  std_logic; -- Erdem
      -- Client Receiver Interface - EMAC1
      EMAC1CLIENTRXDVLD         : out    std_logic;
      EMAC1CLIENTRXFRAMEDROP    : out    std_logic;
      EMAC1CLIENTRXSTATS        : out    std_logic_vector (6 downto 0);
      EMAC1CLIENTRXSTATSVLD     : out    std_logic;
      EMAC1CLIENTRXSTATSBYTEVLD : out    std_logic;
      -- Client Transmitter Interface - EMAC1
      CLIENTEMAC1TXIFGDELAY     : in     std_logic_vector (7 downto 0);
      EMAC1CLIENTTXSTATS        : out    std_logic;
      EMAC1CLIENTTXSTATSVLD     : out    std_logic;
      EMAC1CLIENTTXSTATSBYTEVLD : out    std_logic;
      -- MAC Control Interface - EMAC1
      CLIENTEMAC1PAUSEREQ       : in     std_logic;
      CLIENTEMAC1PAUSEVAL       : in     std_logic_vector (15 downto 0);
      --EMAC-MGT link status
      EMAC1CLIENTSYNCACQSTATUS  : out    std_logic;
      -- Clock Signals - EMAC1
      RX_CLIENT_CLK_1           : out    std_logic;
      TX_CLIENT_CLK_1           : out    std_logic;
      -- 1000BASE-X PCS/PMA Interface - EMAC1
      TXP_1                     : out    std_logic;
      TXN_1                     : out    std_logic;
      RXP_1                     : in     std_logic;
      RXN_1                     : in     std_logic;
      PHYAD_1                   : in     std_logic_vector (4 downto 0);
      RESETDONE_1               : out    std_logic;
      -- MDIO Interface - EMAC1
      MDC_1                     : out    std_logic;
      MDIO_1_I                  : in     std_logic;
      MDIO_1_O                  : out    std_logic;
      MDIO_1_T                  : out    std_logic;
      -- Generic Host Interface
      HOSTOPCODE                : in     std_logic_vector (1 downto 0);
      HOSTREQ                   : in     std_logic;
      HOSTMIIMSEL               : in     std_logic;
      HOSTADDR                  : in     std_logic_vector (9 downto 0);
      HOSTWRDATA                : in     std_logic_vector (31 downto 0);
      HOSTMIIMRDY               : out    std_logic;
      HOSTRDDATA                : out    std_logic_vector (31 downto 0);
      HOSTEMAC1SEL              : in     std_logic;
      HOSTCLK                   : in     std_logic;
      -- 1000BASE-X PCS/PMA RocketIO Reference Clock buffer inputs
      MGTCLK_P                  : in     std_logic;
      MGTCLK_N                  : in     std_logic;
      DCLK                      : in     std_logic;
      -- *** mod start
      REFCLK1_i                 : in     std_logic;
      REFCLK2_i                 : in     std_logic;
      tx0_fifo_stat             : out    std_logic_vector (3 downto 0);
      tx0_overflow              : out    std_logic;
      rx0_overflow              : out    std_logic;
      tx1_fifo_stat             : out    std_logic_vector (3 downto 0);
      tx1_overflow              : out    std_logic;
      rx1_overflow              : out    std_logic;
      tx0_ack                   : out    std_logic;
      tx0_collision             : out    std_logic;
      tx0_retransmit            : out    std_logic;
      tx1_ack                   : out    std_logic;
      tx1_collision             : out    std_logic;
      tx1_retransmit            : out    std_logic;
      an0_interrupt_o           : out    std_logic;
      an1_interrupt_o           : out    std_logic;
      rx0_goodframe_o : out std_logic;
      rx1_goodframe_o : out std_logic;

      -- *** mod end
      
      -- Asynchronous Reset
      RESET                     : in     std_logic
   );

-- Declarations

end eth2x16_locallink ;
-- hds interface_end


architecture TOP_LEVEL of eth2x16_locallink is

-------------------------------------------------------------------------------
-- Component Declarations for lower hierarchial level entities
-------------------------------------------------------------------------------
  -- Component Declaration for the main EMAC wrapper
--  component eth2x16_block
--    port(
--      -- Client Receiver Interface - EMAC0
--      RX_CLIENT_CLK_0           : out std_logic;
--      EMAC0CLIENTRXD            : out std_logic_vector(7 downto 0);
--      EMAC0CLIENTRXDVLD         : out std_logic;
--      EMAC0CLIENTRXGOODFRAME    : out std_logic;
--      EMAC0CLIENTRXBADFRAME     : out std_logic;
--      EMAC0CLIENTRXFRAMEDROP    : out std_logic;
--      EMAC0CLIENTRXSTATS        : out std_logic_vector(6 downto 0);
--      EMAC0CLIENTRXSTATSVLD     : out std_logic;
--      EMAC0CLIENTRXSTATSBYTEVLD : out std_logic;
--
--      -- Client Transmitter Interface - EMAC0
--      TX_CLIENT_CLK_0           : out std_logic;
--      CLIENTEMAC0TXD            : in  std_logic_vector(7 downto 0);
--      CLIENTEMAC0TXDVLD         : in  std_logic;
--      EMAC0CLIENTTXACK          : out std_logic;
--      CLIENTEMAC0TXFIRSTBYTE    : in  std_logic;
--      CLIENTEMAC0TXUNDERRUN     : in  std_logic;
--      EMAC0CLIENTTXCOLLISION    : out std_logic;
--      EMAC0CLIENTTXRETRANSMIT   : out std_logic;
--      CLIENTEMAC0TXIFGDELAY     : in  std_logic_vector(7 downto 0);
--      EMAC0CLIENTTXSTATS        : out std_logic;
--      EMAC0CLIENTTXSTATSVLD     : out std_logic;
--      EMAC0CLIENTTXSTATSBYTEVLD : out std_logic;
--
--      -- MAC Control Interface - EMAC0
--      CLIENTEMAC0PAUSEREQ : in std_logic;
--      CLIENTEMAC0PAUSEVAL : in std_logic_vector(15 downto 0);
--
--      --EMAC-MGT link status
--      EMAC0CLIENTSYNCACQSTATUS : out std_logic;
--
--
--      -- Clock Signals - EMAC0
--      -- 1000BASE-X PCS/PMA Interface - EMAC0
--      TXP_0       : out std_logic;
--      TXN_0       : out std_logic;
--      RXP_0       : in  std_logic;
--      RXN_0       : in  std_logic;
--      PHYAD_0     : in  std_logic_vector(4 downto 0);
--      RESETDONE_0 : out std_logic;
--
--      -- MDIO Interface - EMAC0
--      MDC_0                     : out std_logic;
--      MDIO_0_I                  : in  std_logic;
--      MDIO_0_O                  : out std_logic;
--      MDIO_0_T                  : out std_logic;
--      -- Client Receiver Interface - EMAC1
--      RX_CLIENT_CLK_1           : out std_logic;
--      EMAC1CLIENTRXD            : out std_logic_vector(7 downto 0);
--      EMAC1CLIENTRXDVLD         : out std_logic;
--      EMAC1CLIENTRXGOODFRAME    : out std_logic;
--      EMAC1CLIENTRXBADFRAME     : out std_logic;
--      EMAC1CLIENTRXFRAMEDROP    : out std_logic;
--      EMAC1CLIENTRXSTATS        : out std_logic_vector(6 downto 0);
--      EMAC1CLIENTRXSTATSVLD     : out std_logic;
--      EMAC1CLIENTRXSTATSBYTEVLD : out std_logic;
--
--      -- Client Transmitter Interface - EMAC1
--      TX_CLIENT_CLK_1           : out std_logic;
--      CLIENTEMAC1TXD            : in  std_logic_vector(7 downto 0);
--      CLIENTEMAC1TXDVLD         : in  std_logic;
--      EMAC1CLIENTTXACK          : out std_logic;
--      CLIENTEMAC1TXFIRSTBYTE    : in  std_logic;
--      CLIENTEMAC1TXUNDERRUN     : in  std_logic;
--      EMAC1CLIENTTXCOLLISION    : out std_logic;
--      EMAC1CLIENTTXRETRANSMIT   : out std_logic;
--      CLIENTEMAC1TXIFGDELAY     : in  std_logic_vector(7 downto 0);
--      EMAC1CLIENTTXSTATS        : out std_logic;
--      EMAC1CLIENTTXSTATSVLD     : out std_logic;
--      EMAC1CLIENTTXSTATSBYTEVLD : out std_logic;
--
--      -- MAC Control Interface - EMAC1
--      CLIENTEMAC1PAUSEREQ : in std_logic;
--      CLIENTEMAC1PAUSEVAL : in std_logic_vector(15 downto 0);
--
--      --EMAC-MGT link status
--      EMAC1CLIENTSYNCACQSTATUS : out std_logic;
--
--
--      -- Clock Signals - EMAC1
--      -- 1000BASE-X PCS/PMA Interface - EMAC1
--      TXP_1       : out std_logic;
--      TXN_1       : out std_logic;
--      RXP_1       : in  std_logic;
--      RXN_1       : in  std_logic;
--      PHYAD_1     : in  std_logic_vector(4 downto 0);
--      RESETDONE_1 : out std_logic;
--
--      -- MDIO Interface - EMAC1
--      MDC_1        : out std_logic;
--      MDIO_1_I     : in  std_logic;
--      MDIO_1_O     : out std_logic;
--      MDIO_1_T     : out std_logic;
--      -- Generic Host Interface
--      HOSTOPCODE   : in  std_logic_vector(1 downto 0);
--      HOSTREQ      : in  std_logic;
--      HOSTMIIMSEL  : in  std_logic;
--      HOSTADDR     : in  std_logic_vector(9 downto 0);
--      HOSTWRDATA   : in  std_logic_vector(31 downto 0);
--      HOSTMIIMRDY  : out std_logic;
--      HOSTRDDATA   : out std_logic_vector(31 downto 0);
--      HOSTEMAC1SEL : in  std_logic;
--      HOSTCLK      : in  std_logic;
--      -- 1000BASE-X PCS/PMA RocketIO Reference Clock buffer inputs 
--      MGTCLK_P     : in  std_logic;
--      MGTCLK_N     : in  std_logic;
--      DCLK         : in  std_logic;
--
--      -- *** mod start
--      REFCLK1_i       : in  std_logic;
--      REFCLK2_i       : in  std_logic;
--      an_interrupt0_o : out std_logic;
--      an_interrupt1_o : out std_logic;
--      -- *** mod end 
--
--      -- Asynchronous Reset
--      RESET : in std_logic
--      );
--  end component;
  
  component eth_mac_block is
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
  end component;
  
  
  ---------------------------------------------------------------------
  -- Component Declaration for the 8-bit client side FIFO
  ---------------------------------------------------------------------
  component eth_fifo_16
   generic (
        FULL_DUPLEX_ONLY    : boolean);
   port (
        -- Transmit FIFO MAC TX Interface
        tx_clk              : in  std_logic;
        tx_reset            : in  std_logic;
        tx_enable           : in  std_logic;
        tx_data             : out std_logic_vector(15 downto 0);
        tx_data_valid       : out std_logic_vector(1 downto 0);
        tx_ack              : in  std_logic;
        tx_underrun         : out std_logic;
        tx_collision        : in  std_logic;
        tx_retransmit       : in  std_logic;

        -- Transmit FIFO Local-link Interface
        tx_ll_clock         : in  std_logic;
        tx_ll_reset         : in  std_logic;
        tx_ll_data_in       : in  std_logic_vector(15 downto 0);
        tx_ll_sof_in_n      : in  std_logic;
        tx_ll_eof_in_n      : in  std_logic;
        tx_ll_src_rdy_in_n  : in  std_logic;
        tx_ll_rem_in        : in  std_logic_vector(0 downto 0);
        tx_ll_dst_rdy_out_n : out std_logic;
        tx_fifo_status      : out std_logic_vector(3 downto 0);
        tx_overflow         : out std_logic;

        -- Receive FIFO MAC RX Interface
        rx_clk              : in  std_logic;
        rx_reset            : in  std_logic;
        rx_enable           : in  std_logic;
        rx_data             : in  std_logic_vector(15 downto 0);
        rx_data_valid       : in  std_logic_vector(1 downto 0);
        rx_good_frame       : in  std_logic;
        rx_bad_frame        : in  std_logic;
        rx_overflow         : out std_logic;

        -- Receive FIFO Local-link Interface
        rx_ll_clock         : in  std_logic;
        rx_ll_reset         : in  std_logic;
        rx_ll_data_out      : out std_logic_vector(15 downto 0);
        rx_ll_sof_out_n     : out std_logic;
        rx_ll_eof_out_n     : out std_logic;
        rx_ll_src_rdy_out_n : out std_logic;
        rx_ll_rem_out       : out std_logic_vector(0 downto 0);
        rx_ll_dst_rdy_in_n  : in  std_logic;
        rx_fifo_status      : out std_logic_vector(3 downto 0)
        );
   end component;
  
  
  component eth_fifo_8
    generic (
      FULL_DUPLEX_ONLY :     boolean);
    port (
      -- Transmit FIFO MAC TX Interface
      tx_clk           : in  std_logic;
      tx_reset         : in  std_logic;
      tx_enable        : in  std_logic;
      tx_data          : out std_logic_vector(7 downto 0);
      tx_data_valid    : out std_logic;
      tx_ack           : in  std_logic;
      tx_underrun      : out std_logic;
      tx_collision     : in  std_logic;
      tx_retransmit    : in  std_logic;

      -- Transmit FIFO Local-link Interface
      tx_ll_clock         : in  std_logic;
      tx_ll_reset         : in  std_logic;
      tx_ll_data_in       : in  std_logic_vector(7 downto 0);
      tx_ll_sof_in_n      : in  std_logic;
      tx_ll_eof_in_n      : in  std_logic;
      tx_ll_src_rdy_in_n  : in  std_logic;
      tx_ll_dst_rdy_out_n : out std_logic;
      tx_fifo_status      : out std_logic_vector(3 downto 0);
      tx_overflow         : out std_logic;

      -- Receive FIFO MAC RX Interface
      rx_clk        : in  std_logic;
      rx_reset      : in  std_logic;
      rx_enable     : in  std_logic;
      rx_data       : in  std_logic_vector(7 downto 0);
      rx_data_valid : in  std_logic;
      rx_good_frame : in  std_logic;
      rx_bad_frame  : in  std_logic;
      rx_overflow   : out std_logic;

      -- Receive FIFO Local-link Interface
      rx_ll_clock         : in  std_logic;
      rx_ll_reset         : in  std_logic;
      rx_ll_data_out      : out std_logic_vector(7 downto 0);
      rx_ll_sof_out_n     : out std_logic;
      rx_ll_eof_out_n     : out std_logic;
      rx_ll_src_rdy_out_n : out std_logic;
      rx_ll_dst_rdy_in_n  : in  std_logic;
      rx_fifo_status      : out std_logic_vector(3 downto 0)
      );
  end component;

-------------------------------------------------------------------------------
-- Signal Declarations
-------------------------------------------------------------------------------

  -- Global asynchronous reset
  signal reset_i : std_logic;

  -- client interface clocking signals - EMAC0
  signal tx_clk_0_i : std_logic;
  signal rx_clk_0_i : std_logic;

  -- internal client interface connections - EMAC0
  -- transmitter interface
  signal tx_data_0_i       : std_logic_vector(15 downto 0);
  signal tx_data_valid_0_i : std_logic;
  signal tx_underrun_0_i   : std_logic;
  signal tx_ack_0_i        : std_logic;
  signal tx_collision_0_i  : std_logic;
  signal tx_retransmit_0_i : std_logic;
  -- receiver interface
  signal rx_data_0_i       : std_logic_vector(15 downto 0);
  signal rx_data_valid_0_i : std_logic;
  signal rx_good_frame_0_i : std_logic;
  signal rx_bad_frame_0_i  : std_logic;
  -- registers for the MAC receiver output
  signal rx_data_0_r       : std_logic_vector(15 downto 0);
  signal rx_data_valid_0_r : std_logic_vector(1 downto 0); -- Erdem std_logic;
  signal rx_good_frame_0_r : std_logic;
  signal rx_bad_frame_0_r  : std_logic;

  -- create a synchronous reset in the transmitter clock domain
  signal tx_pre_reset_0_i : std_logic_vector(5 downto 0);
  signal tx_reset_0_i     : std_logic;

  -- create a synchronous reset in the receiver clock domain
  signal rx_pre_reset_0_i : std_logic_vector(5 downto 0);
  signal rx_reset_0_i     : std_logic;

  attribute async_reg                     : string;
  attribute async_reg of rx_pre_reset_0_i : signal is "true";
  attribute async_reg of tx_pre_reset_0_i : signal is "true";

  signal resetdone_0_i : std_logic;

  -- client interface clocking signals - EMAC1
  signal tx_clk_1_i : std_logic;
  signal rx_clk_1_i : std_logic;

  -- internal client interface connections - EMAC1
  -- transmitter interface
  signal tx_data_1_i       : std_logic_vector(15 downto 0);
  signal tx_data_valid_1_i : std_logic;
  signal tx_underrun_1_i   : std_logic;
  signal tx_ack_1_i        : std_logic;
  signal tx_collision_1_i  : std_logic;
  signal tx_retransmit_1_i : std_logic;
  -- receiver interface
  signal rx_data_1_i       : std_logic_vector(15 downto 0);
  signal rx_data_valid_1_i : std_logic;
  signal rx_good_frame_1_i : std_logic;
  signal rx_bad_frame_1_i  : std_logic;
  -- registers for the MAC receiver output
  signal rx_data_1_r       : std_logic_vector(15 downto 0);
  signal rx_data_valid_1_r : std_logic_vector(1 downto 0); --std_logic;
  signal rx_good_frame_1_r : std_logic;
  signal rx_bad_frame_1_r  : std_logic;

  -- create a synchronous reset in the transmitter clock domain
  signal tx_pre_reset_1_i : std_logic_vector(5 downto 0);
  signal tx_reset_1_i     : std_logic;

  -- create a synchronous reset in the receiver clock domain
  signal rx_pre_reset_1_i : std_logic_vector(5 downto 0);
  signal rx_reset_1_i     : std_logic;

  signal resetdone_1_i : std_logic;
  
  signal reset_200ms   : std_logic;
  
  signal tx_data_valid_0_int   : std_logic_vector (1 downto 0);
  signal tx_data_valid_1_int   : std_logic_vector (1 downto 0);
  signal rx_data_valid_msb_0_i : std_logic;
  signal tx_data_valid_msb_0_i : std_logic;
  signal rx_data_valid_msb_1_i : std_logic;
  signal tx_data_valid_msb_1_i : std_logic;
  signal tx_ll_rem_0_i         : std_logic_vector (0 downto 0);
  signal rx_data_valid_0_int   : std_logic_vector (1 downto 0);
  signal rx_data_valid_1_int   : std_logic_vector (1 downto 0);
  signal RX_LL_REM_0           : std_logic;
  signal rx_ll_rem_0_i         : std_logic_vector (0 downto 0);
  signal tx_ll_rem_1_i         : std_logic_vector(0 downto 0);
  signal rx_ll_rem_1_i         : std_logic_vector(0 downto 0);
  
  attribute async_reg of rx_pre_reset_1_i : signal is "true";
  attribute async_reg of tx_pre_reset_1_i : signal is "true";
  attribute keep                          : string;
  attribute keep of tx_data_0_i           : signal           is "true";
  attribute keep of tx_data_valid_0_i     : signal     is "true";
  attribute keep of tx_ack_0_i            : signal            is "true";
  attribute keep of rx_data_0_i           : signal           is "true";
  attribute keep of rx_data_valid_0_i     : signal     is "true";
  attribute keep of tx_data_1_i           : signal           is "true";
  attribute keep of tx_data_valid_1_i     : signal     is "true";
  attribute keep of tx_ack_1_i            : signal            is "true";
  attribute keep of rx_data_1_i           : signal           is "true";
  attribute keep of rx_data_valid_1_i     : signal     is "true";

-------------------------------------------------------------------------------
-- Main Body of Code
-------------------------------------------------------------------------------
begin

  -- *** mod start
  tx0_ack        <= tx_ack_0_i;
  tx0_collision  <= tx_collision_0_i;
  tx0_retransmit <= tx_retransmit_0_i;
  tx1_ack        <= tx_ack_1_i;
  tx1_collision  <= tx_collision_1_i;
  tx1_retransmit <= tx_retransmit_1_i;
  rx0_goodframe_o <= rx_good_frame_0_r;
  rx1_goodframe_o <= rx_good_frame_1_r;
  -- *** mod end

  ---------------------------------------------------------------------------
  -- Asynchronous Reset Input
  ---------------------------------------------------------------------------
  reset_i <= RESET;

  --------------------------------------------------------------------------
  -- Instantiate the EMAC Wrapper (eth2x16_block.vhd)
  --------------------------------------------------------------------------
--  v4_emac_block : eth2x16_block
--    port map (
--      -- Client Receiver Interface - EMAC0
--      RX_CLIENT_CLK_0           => rx_clk_0_i,
--      EMAC0CLIENTRXD            => rx_data_0_i,
--      EMAC0CLIENTRXDVLD         => rx_data_valid_0_i,
--      EMAC0CLIENTRXGOODFRAME    => rx_good_frame_0_i,
--      EMAC0CLIENTRXBADFRAME     => rx_bad_frame_0_i,
--      EMAC0CLIENTRXFRAMEDROP    => EMAC0CLIENTRXFRAMEDROP,
--      EMAC0CLIENTRXSTATS        => EMAC0CLIENTRXSTATS,
--      EMAC0CLIENTRXSTATSVLD     => EMAC0CLIENTRXSTATSVLD,
--      EMAC0CLIENTRXSTATSBYTEVLD => EMAC0CLIENTRXSTATSBYTEVLD,
--
--      -- Client Transmitter Interface - EMAC0
--      TX_CLIENT_CLK_0           => tx_clk_0_i,
--      CLIENTEMAC0TXD            => tx_data_0_i,
--      CLIENTEMAC0TXDVLD         => tx_data_valid_0_i,
--      EMAC0CLIENTTXACK          => tx_ack_0_i,
--      CLIENTEMAC0TXFIRSTBYTE    => '0',
--      CLIENTEMAC0TXUNDERRUN     => tx_underrun_0_i,
--      EMAC0CLIENTTXCOLLISION    => tx_collision_0_i,
--      EMAC0CLIENTTXRETRANSMIT   => tx_retransmit_0_i,
--      CLIENTEMAC0TXIFGDELAY     => CLIENTEMAC0TXIFGDELAY,
--      EMAC0CLIENTTXSTATS        => EMAC0CLIENTTXSTATS,
--      EMAC0CLIENTTXSTATSVLD     => EMAC0CLIENTTXSTATSVLD,
--      EMAC0CLIENTTXSTATSBYTEVLD => EMAC0CLIENTTXSTATSBYTEVLD,
--
--      -- MAC Control Interface - EMAC0
--      CLIENTEMAC0PAUSEREQ => CLIENTEMAC0PAUSEREQ,
--      CLIENTEMAC0PAUSEVAL => CLIENTEMAC0PAUSEVAL,
--
--      --EMAC-MGT link status
--      EMAC0CLIENTSYNCACQSTATUS => EMAC0CLIENTSYNCACQSTATUS,
--
--
--      -- Clock Signals - EMAC0
--      -- 1000BASE-X PCS/PMA Interface - EMAC0
--      TXP_0       => TXP_0,
--      TXN_0       => TXN_0,
--      RXP_0       => RXP_0,
--      RXN_0       => RXN_0,
--      PHYAD_0     => PHYAD_0,
--      RESETDONE_0 => resetdone_0_i,
--
--      -- MDIO Interface - EMAC0
--      MDC_0                     => MDC_0,
--      MDIO_0_I                  => MDIO_0_I,
--      MDIO_0_O                  => MDIO_0_O,
--      MDIO_0_T                  => MDIO_0_T,
--      -- Client Receiver Interface - EMAC1
--      RX_CLIENT_CLK_1           => rx_clk_1_i,
--      EMAC1CLIENTRXD            => rx_data_1_i,
--      EMAC1CLIENTRXDVLD         => rx_data_valid_1_i,
--      EMAC1CLIENTRXGOODFRAME    => rx_good_frame_1_i,
--      EMAC1CLIENTRXBADFRAME     => rx_bad_frame_1_i,
--      EMAC1CLIENTRXFRAMEDROP    => EMAC1CLIENTRXFRAMEDROP,
--      EMAC1CLIENTRXSTATS        => EMAC1CLIENTRXSTATS,
--      EMAC1CLIENTRXSTATSVLD     => EMAC1CLIENTRXSTATSVLD,
--      EMAC1CLIENTRXSTATSBYTEVLD => EMAC1CLIENTRXSTATSBYTEVLD,
--
--      -- Client Transmitter Interface - EMAC1
--      TX_CLIENT_CLK_1           => tx_clk_1_i,
--      CLIENTEMAC1TXD            => tx_data_1_i,
--      CLIENTEMAC1TXDVLD         => tx_data_valid_1_i,
--      EMAC1CLIENTTXACK          => tx_ack_1_i,
--      CLIENTEMAC1TXFIRSTBYTE    => '0',
--      CLIENTEMAC1TXUNDERRUN     => tx_underrun_1_i,
--      EMAC1CLIENTTXCOLLISION    => tx_collision_1_i,
--      EMAC1CLIENTTXRETRANSMIT   => tx_retransmit_1_i,
--      CLIENTEMAC1TXIFGDELAY     => CLIENTEMAC1TXIFGDELAY,
--      EMAC1CLIENTTXSTATS        => EMAC1CLIENTTXSTATS,
--      EMAC1CLIENTTXSTATSVLD     => EMAC1CLIENTTXSTATSVLD,
--      EMAC1CLIENTTXSTATSBYTEVLD => EMAC1CLIENTTXSTATSBYTEVLD,
--
--      -- MAC Control Interface - EMAC1
--      CLIENTEMAC1PAUSEREQ => CLIENTEMAC1PAUSEREQ,
--      CLIENTEMAC1PAUSEVAL => CLIENTEMAC1PAUSEVAL,
--
--      --EMAC-MGT link status
--      EMAC1CLIENTSYNCACQSTATUS => EMAC1CLIENTSYNCACQSTATUS,
--
--
--      -- Clock Signals - EMAC1
--      -- 1000BASE-X PCS/PMA Interface - EMAC1
--      TXP_1       => TXP_1,
--      TXN_1       => TXN_1,
--      RXP_1       => RXP_1,
--      RXN_1       => RXN_1,
--      PHYAD_1     => PHYAD_1,
--      RESETDONE_1 => resetdone_1_i,
--
--      -- MDIO Interface - EMAC1
--      MDC_1        => MDC_1,
--      MDIO_1_I     => MDIO_1_I,
--      MDIO_1_O     => MDIO_1_O,
--      MDIO_1_T     => MDIO_1_T,
--      -- Generic Host Interface
--      HOSTOPCODE   => HOSTOPCODE,
--      HOSTREQ      => HOSTREQ,
--      HOSTMIIMSEL  => HOSTMIIMSEL,
--      HOSTADDR     => HOSTADDR,
--      HOSTWRDATA   => HOSTWRDATA,
--      HOSTMIIMRDY  => HOSTMIIMRDY,
--      HOSTRDDATA   => HOSTRDDATA,
--      HOSTEMAC1SEL => HOSTEMAC1SEL,
--      HOSTCLK      => HOSTCLK,
--      -- 1000BASE-X PCS/PMA RocketIO Reference Clock buffer inputs 
--      MGTCLK_P     => MGTCLK_P,
--      MGTCLK_N     => MGTCLK_N,
--      DCLK         => DCLK,
--
--      -- *** mod start
--      REFCLK1_i       => REFCLK1_i,
--      REFCLK2_i       => REFCLK2_i,
--      an_interrupt0_o => an0_interrupt_o,
--      an_interrupt1_o => an1_interrupt_o,
--      -- *** mod end  
--
--      -- Asynchronous Reset
--      RESET => reset_i
--      );


  v4_emac_block : eth_mac_block
    port map (
      -- Client Receiver Interface - EMAC0
      RX_CLIENT_CLK_0           => rx_clk_0_i,
      EMAC0CLIENTRXD            => rx_data_0_i,
      EMAC0CLIENTRXDVLD         => rx_data_valid_0_i,
		EMAC0CLIENTRXDVLDMSW      => rx_data_valid_msb_0_i,  -- Erdem 
      EMAC0CLIENTRXGOODFRAME    => rx_good_frame_0_i,
      EMAC0CLIENTRXBADFRAME     => rx_bad_frame_0_i,
      EMAC0CLIENTRXFRAMEDROP    => EMAC0CLIENTRXFRAMEDROP,
      EMAC0CLIENTRXSTATS        => EMAC0CLIENTRXSTATS,
      EMAC0CLIENTRXSTATSVLD     => EMAC0CLIENTRXSTATSVLD,
      EMAC0CLIENTRXSTATSBYTEVLD => EMAC0CLIENTRXSTATSBYTEVLD,

      -- Client Transmitter Interface - EMAC0
      TX_CLIENT_CLK_0           => tx_clk_0_i,
      CLIENTEMAC0TXD            => tx_data_0_i,
      CLIENTEMAC0TXDVLD         => tx_data_valid_0_i,
		CLIENTEMAC0TXDVLDMSW            => tx_data_valid_msb_0_i, -- Erdem
      EMAC0CLIENTTXACK          => tx_ack_0_i,
      CLIENTEMAC0TXFIRSTBYTE    => '0',
      CLIENTEMAC0TXUNDERRUN     => tx_underrun_0_i,
      EMAC0CLIENTTXCOLLISION    => tx_collision_0_i,
      EMAC0CLIENTTXRETRANSMIT   => tx_retransmit_0_i,
      CLIENTEMAC0TXIFGDELAY     => CLIENTEMAC0TXIFGDELAY,
      EMAC0CLIENTTXSTATS        => EMAC0CLIENTTXSTATS,
      EMAC0CLIENTTXSTATSVLD     => EMAC0CLIENTTXSTATSVLD,
      EMAC0CLIENTTXSTATSBYTEVLD => EMAC0CLIENTTXSTATSBYTEVLD,

      -- MAC Control Interface - EMAC0
      CLIENTEMAC0PAUSEREQ => CLIENTEMAC0PAUSEREQ,
      CLIENTEMAC0PAUSEVAL => CLIENTEMAC0PAUSEVAL,

      --EMAC-MGT link status
      EMAC0CLIENTSYNCACQSTATUS => EMAC0CLIENTSYNCACQSTATUS,


      -- Clock Signals - EMAC0
      -- 1000BASE-X PCS/PMA Interface - EMAC0
      TXP_0       => TXP_0,
      TXN_0       => TXN_0,
      RXP_0       => RXP_0,
      RXN_0       => RXN_0,
      PHYAD_0     => PHYAD_0,
      RESETDONE_0 => resetdone_0_i,

      -- MDIO Interface - EMAC0
      MDC_0                     => MDC_0,
      MDIO_0_I                  => MDIO_0_I,
      MDIO_0_O                  => MDIO_0_O,
      MDIO_0_T                  => MDIO_0_T,
      -- Client Receiver Interface - EMAC1
      RX_CLIENT_CLK_1           => rx_clk_1_i,
      EMAC1CLIENTRXD            => rx_data_1_i,
      EMAC1CLIENTRXDVLD         => rx_data_valid_1_i,
		EMAC1CLIENTRXDVLDMSW            => rx_data_valid_msb_1_i, -- Erdem
      EMAC1CLIENTRXGOODFRAME    => rx_good_frame_1_i,
      EMAC1CLIENTRXBADFRAME     => rx_bad_frame_1_i,
      EMAC1CLIENTRXFRAMEDROP    => EMAC1CLIENTRXFRAMEDROP,
      EMAC1CLIENTRXSTATS        => EMAC1CLIENTRXSTATS,
      EMAC1CLIENTRXSTATSVLD     => EMAC1CLIENTRXSTATSVLD,
      EMAC1CLIENTRXSTATSBYTEVLD => EMAC1CLIENTRXSTATSBYTEVLD,

      -- Client Transmitter Interface - EMAC1
      TX_CLIENT_CLK_1           => tx_clk_1_i,
      CLIENTEMAC1TXD            => tx_data_1_i,
      CLIENTEMAC1TXDVLD         => tx_data_valid_1_i,
		CLIENTEMAC1TXDVLDMSW            => tx_data_valid_msb_1_i, -- Erdem
      EMAC1CLIENTTXACK          => tx_ack_1_i,
      CLIENTEMAC1TXFIRSTBYTE    => '0',
      CLIENTEMAC1TXUNDERRUN     => tx_underrun_1_i,
      EMAC1CLIENTTXCOLLISION    => tx_collision_1_i,
      EMAC1CLIENTTXRETRANSMIT   => tx_retransmit_1_i,
      CLIENTEMAC1TXIFGDELAY     => CLIENTEMAC1TXIFGDELAY,
      EMAC1CLIENTTXSTATS        => EMAC1CLIENTTXSTATS,
      EMAC1CLIENTTXSTATSVLD     => EMAC1CLIENTTXSTATSVLD,
      EMAC1CLIENTTXSTATSBYTEVLD => EMAC1CLIENTTXSTATSBYTEVLD,

      -- MAC Control Interface - EMAC1
      CLIENTEMAC1PAUSEREQ => CLIENTEMAC1PAUSEREQ,
      CLIENTEMAC1PAUSEVAL => CLIENTEMAC1PAUSEVAL,

      --EMAC-MGT link status
      EMAC1CLIENTSYNCACQSTATUS => EMAC1CLIENTSYNCACQSTATUS,


      -- Clock Signals - EMAC1
      -- 1000BASE-X PCS/PMA Interface - EMAC1
      TXP_1       => TXP_1,
      TXN_1       => TXN_1,
      RXP_1       => RXP_1,
      RXN_1       => RXN_1,
      PHYAD_1     => PHYAD_1,
      RESETDONE_1 => resetdone_1_i,

      -- MDIO Interface - EMAC1
      MDC_1        => MDC_1,
      MDIO_1_I     => MDIO_1_I,
      MDIO_1_O     => MDIO_1_O,
      MDIO_1_T     => MDIO_1_T,
      -- Generic Host Interface
      HOSTOPCODE   => HOSTOPCODE,
      HOSTREQ      => HOSTREQ,
      HOSTMIIMSEL  => HOSTMIIMSEL,
      HOSTADDR     => HOSTADDR,
      HOSTWRDATA   => HOSTWRDATA,
      HOSTMIIMRDY  => HOSTMIIMRDY,
      HOSTRDDATA   => HOSTRDDATA,
      HOSTEMAC1SEL => HOSTEMAC1SEL,
      HOSTCLK      => HOSTCLK,
      -- 1000BASE-X PCS/PMA RocketIO Reference Clock buffer inputs 
      MGTCLK_P     => MGTCLK_P,
      MGTCLK_N     => MGTCLK_N,
      DCLK         => DCLK,

      -- *** mod start
      REFCLK1_i       => REFCLK1_i,
      REFCLK2_i       => REFCLK2_i,
      an_interrupt0_o => an0_interrupt_o,
      an_interrupt1_o => an1_interrupt_o,
      -- *** mod end  
      
		RESET_200MS       => reset_200ms,               
      RESET_200MS_IN    => reset_200ms,             
      -- Asynchronous Reset
      RESET => reset_i
      ); 
	
  tx_ll_rem_0_i(0) <= TX_LL_REM_0;
  --RX_LL_REM_0 <= rx_ll_rem_0_i(0);
  
  ----------------------------------------------------------------------
  -- Instantiate the client side FIFO for EMAC0
  ----------------------------------------------------------------------
  client_side_FIFO_emac0 : eth_fifo_16
    generic map (
      FULL_DUPLEX_ONLY => false)
    port map (
      -- Transmitter MAC Client Interface
      tx_clk           => tx_clk_0_i,
      tx_reset         => tx_reset_0_i,
      tx_enable        => '1',
      tx_data          => tx_data_0_i,
      tx_data_valid    => tx_data_valid_0_int, -- Erdem  tx_data_valid_0_i,
      tx_ack           => tx_ack_0_i,
      tx_underrun      => tx_underrun_0_i,
      tx_collision     => tx_collision_0_i,
      tx_retransmit    => tx_retransmit_0_i,

      -- Transmitter Local Link Interface
      tx_ll_clock         => TX_LL_CLOCK_0,
      tx_ll_reset         => TX_LL_RESET_0,
      tx_ll_data_in       => TX_LL_DATA_0,
      tx_ll_sof_in_n      => TX_LL_SOF_N_0,
		tx_ll_rem_in         => tx_ll_rem_0_i, -- Erdem 
      tx_ll_eof_in_n      => TX_LL_EOF_N_0,
      tx_ll_src_rdy_in_n  => TX_LL_SRC_RDY_N_0,
      tx_ll_dst_rdy_out_n => TX_LL_DST_RDY_N_0,
		
      -- *** mod start
      tx_fifo_status => tx0_fifo_stat,  --open,
      tx_overflow    => tx0_overflow,   --open,
      -- *** mod end

      -- Receiver MAC Client Interface
      rx_clk        => rx_clk_0_i,
      rx_reset      => rx_reset_0_i,
      rx_enable     => '1',
      rx_data       => rx_data_0_r,
      rx_data_valid => rx_data_valid_0_r,
      rx_good_frame => rx_good_frame_0_r,
      rx_bad_frame  => rx_bad_frame_0_r,

      -- *** mod start
      rx_overflow => rx0_overflow,      --open,
      -- *** mod end

      -- Receiver Local Link Interface
      rx_ll_clock         => RX_LL_CLOCK_0,
      rx_ll_reset         => RX_LL_RESET_0,
      rx_ll_data_out      => RX_LL_DATA_0,
      rx_ll_sof_out_n     => RX_LL_SOF_N_0,
      rx_ll_eof_out_n     => RX_LL_EOF_N_0,
      rx_ll_src_rdy_out_n => RX_LL_SRC_RDY_N_0,
		rx_ll_rem_out        => rx_ll_rem_0_i,  -- Erdem 
      rx_ll_dst_rdy_in_n  => RX_LL_DST_RDY_N_0,
      rx_fifo_status      => RX_LL_FIFO_STATUS_0
      );

  ----------------------------------------------------------------------
   -- Create 2-bit valid vector for the FIFO from the
   -- the MSB and LSB valid outputs from EMAC0
   ---------------------------------------------------------------------- 
   rx_data_valid_0_int     <= rx_data_valid_msb_0_i & rx_data_valid_0_i;

   ----------------------------------------------------------------------
   -- Seperate the 2-bit transmitter valid vector from the 
   -- FIFO into MSB and LSB valid inputs to EMAC0
   ---------------------------------------------------------------------- 
   tx_data_valid_0_i       <= tx_data_valid_0_int(0);
   tx_data_valid_msb_0_i   <= tx_data_valid_0_int(1);




  -- Create synchronous reset in the transmitter clock domain.
  gen_tx_reset_emac0 : process (tx_clk_0_i, reset_i)
  begin
    if reset_i = '1' then
      tx_pre_reset_0_i               <= (others => '1');
      tx_reset_0_i                   <= '1';
    elsif tx_clk_0_i'event and tx_clk_0_i = '1' then
      if resetdone_0_i = '1' then
        tx_pre_reset_0_i(0)          <= '0';
        tx_pre_reset_0_i(5 downto 1) <= tx_pre_reset_0_i(4 downto 0);
        tx_reset_0_i                 <= tx_pre_reset_0_i(5);
      end if;
    end if;
  end process gen_tx_reset_emac0;

  -- Create synchronous reset in the receiver clock domain.
  gen_rx_reset_emac0 : process (rx_clk_0_i, reset_i)
  begin
    if reset_i = '1' then
      rx_pre_reset_0_i               <= (others => '1');
      rx_reset_0_i                   <= '1';
    elsif rx_clk_0_i'event and rx_clk_0_i = '1' then
      if resetdone_0_i = '1' then
        rx_pre_reset_0_i(0)          <= '0';
        rx_pre_reset_0_i(5 downto 1) <= rx_pre_reset_0_i(4 downto 0);
        rx_reset_0_i                 <= rx_pre_reset_0_i(5);
      end if;
    end if;
  end process gen_rx_reset_emac0;

  ----------------------------------------------------------------------
  -- Register the receiver outputs from EMAC0 before routing 
  -- to the FIFO
  ----------------------------------------------------------------------
  regipgen_emac0 : process(rx_clk_0_i, reset_i)
  begin
    if reset_i = '1' then
      rx_data_0_r         <= (others => '0');
      rx_data_valid_0_r   <= (others => '0'); -- Erdem '0';
      rx_good_frame_0_r   <= '0';
      rx_bad_frame_0_r    <= '0';
    elsif rx_clk_0_i'event and rx_clk_0_i = '1' then
      if resetdone_0_i = '1' then
        rx_data_0_r       <= rx_data_0_i;
        rx_data_valid_0_r <= rx_data_valid_0_int; -- Erdem rx_data_valid_0_i;
        rx_good_frame_0_r <= rx_good_frame_0_i;
        rx_bad_frame_0_r  <= rx_bad_frame_0_i;
      end if;
    end if;
  end process regipgen_emac0;


  tx_ll_rem_1_i(0) <= TX_LL_REM_1;
  --RX_LL_REM_1 <= rx_ll_rem_1_i(0);
  
  ----------------------------------------------------------------------
  -- Instantiate the client side FIFO for EMAC1
  ----------------------------------------------------------------------
  client_side_FIFO_emac1 : eth_fifo_16
    generic map (
      FULL_DUPLEX_ONLY => false)
    port map (
      -- Transmitter MAC Client Interface
      tx_clk           => tx_clk_1_i,
      tx_reset         => tx_reset_1_i,
      tx_enable        => '1',
      tx_data          => tx_data_1_i,
      tx_data_valid    => tx_data_valid_1_int, -- Erdem tx_data_valid_1_i,
      tx_ack           => tx_ack_1_i,
      tx_underrun      => tx_underrun_1_i,
      tx_collision     => tx_collision_1_i,
      tx_retransmit    => tx_retransmit_1_i,

      -- Transmitter Local Link Interface
      tx_ll_clock         => TX_LL_CLOCK_1,
      tx_ll_reset         => TX_LL_RESET_1,
      tx_ll_data_in       => TX_LL_DATA_1,
      tx_ll_sof_in_n      => TX_LL_SOF_N_1,
		tx_ll_rem_in         => tx_ll_rem_1_i, -- Erdem 
      tx_ll_eof_in_n      => TX_LL_EOF_N_1,
      tx_ll_src_rdy_in_n  => TX_LL_SRC_RDY_N_1,
      tx_ll_dst_rdy_out_n => TX_LL_DST_RDY_N_1,

      -- *** mod start
      tx_fifo_status => tx1_fifo_stat,  --open,
      tx_overflow    => tx1_overflow,   --open,
      -- *** mod end


      -- Receiver MAC Client Interface
      rx_clk        => rx_clk_1_i,
      rx_reset      => rx_reset_1_i,
      rx_enable     => '1',
      rx_data       => rx_data_1_r,
      rx_data_valid => rx_data_valid_1_r,
      rx_good_frame => rx_good_frame_1_r,
      rx_bad_frame  => rx_bad_frame_1_r,

      -- *** mod start
      rx_overflow => rx1_overflow,      --open,
      -- *** mod end

      -- Receiver Local Link Interface
      rx_ll_clock         => RX_LL_CLOCK_1,
      rx_ll_reset         => RX_LL_RESET_1,
      rx_ll_data_out      => RX_LL_DATA_1,
      rx_ll_sof_out_n     => RX_LL_SOF_N_1,
      rx_ll_eof_out_n     => RX_LL_EOF_N_1,
      rx_ll_src_rdy_out_n => RX_LL_SRC_RDY_N_1,
		rx_ll_rem_out        => rx_ll_rem_1_i,  -- Erdem 
      rx_ll_dst_rdy_in_n  => RX_LL_DST_RDY_N_1,
      rx_fifo_status      => RX_LL_FIFO_STATUS_1
      );
  
  
  ----------------------------------------------------------------------
   -- Create 2-bit valid vector for the FIFO from the
   -- the MSB and LSB valid outputs from the EMAC1
   ----------------------------------------------------------------------
   rx_data_valid_1_int     <= rx_data_valid_msb_1_i & rx_data_valid_1_i;

   ----------------------------------------------------------------------
   -- Seperate the 2-bit transmitter valid vector from the 
   -- FIFO into MSB and LSB valid inputs to EMAC1
   ----------------------------------------------------------------------
   tx_data_valid_1_i       <= tx_data_valid_1_int(0);
   tx_data_valid_msb_1_i   <= tx_data_valid_1_int(1);
	
	

  -- Create synchronous reset in the transmitter clock domain.
  gen_tx_reset_emac1 : process (tx_clk_1_i, reset_i)
  begin
    if reset_i = '1' then
      tx_pre_reset_1_i               <= (others => '1');
      tx_reset_1_i                   <= '1';
    elsif tx_clk_1_i'event and tx_clk_1_i = '1' then
      if resetdone_1_i = '1' then
        tx_pre_reset_1_i(0)          <= '0';
        tx_pre_reset_1_i(5 downto 1) <= tx_pre_reset_1_i(4 downto 0);
        tx_reset_1_i                 <= tx_pre_reset_1_i(5);
      end if;
    end if;
  end process gen_tx_reset_emac1;

  -- Create synchronous reset in the receiver clock domain.
  gen_rx_reset_emac1 : process (rx_clk_1_i, reset_i)
  begin
    if reset_i = '1' then
      rx_pre_reset_1_i               <= (others => '1');
      rx_reset_1_i                   <= '1';
    elsif rx_clk_1_i'event and rx_clk_1_i = '1' then
      if resetdone_1_i = '1' then
        rx_pre_reset_1_i(0)          <= '0';
        rx_pre_reset_1_i(5 downto 1) <= rx_pre_reset_1_i(4 downto 0);
        rx_reset_1_i                 <= rx_pre_reset_1_i(5);
      end if;
    end if;
  end process gen_rx_reset_emac1;

  ----------------------------------------------------------------------
  -- Register the receiver outputs from EMAC1 before routing 
  -- to the FIFO
  ----------------------------------------------------------------------
  regipgen_emac1 : process(rx_clk_1_i, reset_i)
  begin
    if reset_i = '1' then
      rx_data_1_r         <= (others => '0');
      rx_data_valid_1_r   <= (others => '0'); -- Erdem '0';
      rx_good_frame_1_r   <= '0';
      rx_bad_frame_1_r    <= '0';
    elsif rx_clk_1_i'event and rx_clk_1_i = '1' then
      if resetdone_1_i = '1' then
        rx_data_1_r       <= rx_data_1_i;
        rx_data_valid_1_r <= rx_data_valid_1_int; -- Erdem rx_data_valid_1_i;
        rx_good_frame_1_r <= rx_good_frame_1_i;
        rx_bad_frame_1_r  <= rx_bad_frame_1_i;
      end if;
    end if;
  end process regipgen_emac1;


  -- EMAC0 Client outputs to upper levels and user logic
  EMAC0CLIENTRXDVLD <= rx_data_valid_0_i;
  RX_CLIENT_CLK_0   <= rx_clk_0_i;
  TX_CLIENT_CLK_0   <= tx_clk_0_i;
  RESETDONE_0       <= resetdone_0_i;

  -- EMAC1 Client clock outputs to upper levels and user logic
  EMAC1CLIENTRXDVLD <= rx_data_valid_1_i;
  RX_CLIENT_CLK_1   <= rx_clk_1_i;
  TX_CLIENT_CLK_1   <= tx_clk_1_i;
  RESETDONE_1       <= resetdone_1_i;

end TOP_LEVEL;
