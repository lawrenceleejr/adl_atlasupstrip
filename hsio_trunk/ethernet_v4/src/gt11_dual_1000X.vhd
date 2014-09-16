-------------------------------------------------------------------------------
-- Title      : 1000BASE-X RocketIO wrapper
-- Project    : Virtex-4 Embedded Tri-Mode Ethernet MAC Wrapper
-- File       : gt11_dual_1000X.vhd
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
------------------------------------------------------------------------
-- Description:  This is the VHDL instantiation of a Virtex-4 FX GT11
--               RocketIO tile for the Embedded Ethernet MAC.
--
--               This design also instantiates "rxclkcorcnt_shim" to
--               emulate the rxnotintable function and the clock
--               correction indication signalling of the Virtex-2 Pro
--               RocketIO tranceiver.

--               Two GT11's must be instantiated regardless of how many
--               GT11s are used in the MGT tile.
------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

library UNISIM;
use UNISIM.Vcomponents.ALL;


entity GT11_dual_1000X is
   port (
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
          TX_PLLLOCK_0          : out   std_logic;
          RX_PLLLOCK_0          : out   std_logic;
          TXOUTCLK1_0           : out   std_logic;
          TXRUNDISP_0           : out   std_logic;
          RX_SIGNAL_DETECT_0    : in    std_logic;
          TX1N_0                : out   std_logic;
          TX1P_0                : out   std_logic;
          RX1N_0                : in    std_logic;
          RX1P_0                : in    std_logic;
          RXSYNC_0              : in    std_logic;

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
          TX_PLLLOCK_1          : out   std_logic;
          RX_PLLLOCK_1          : out   std_logic;
          TXOUTCLK1_1           : out   std_logic;
          TXRUNDISP_1           : out   std_logic;
          RX_SIGNAL_DETECT_1    : in    std_logic;
          TX1N_1                : out   std_logic;
          TX1P_1                : out   std_logic;
          RX1N_1                : in    std_logic;
          RX1P_1                : in    std_logic;
          RXSYNC_1              : in    std_logic;


          PMARESET_TX0           : in  std_logic;
          PMARESET_TX1           : in  std_logic;
          DCLK                  : in  std_logic;
          DCM_LOCKED            : in  std_logic
          );
end GT11_dual_1000X;


architecture structural of GT11_dual_1000X is


  ----------------------------------------------------------------------
  -- Component Declaration for Virtex-4 FX GT11 <=> Virtex-II Pro MGT
  -- RocketIO shim
  ----------------------------------------------------------------------
  component gt11togt_rxclkcorcnt_shim
    port (
      rxusrclk2                 : in  std_logic;
      rxstatus                  : in  std_logic_vector(5 downto 0);
      rxnotintable              : in  std_logic;
      rxd_in                    : in  std_logic_vector(7 downto 0);
      rxcharisk_in              : in  std_logic;
      rxrundisp_in              : in  std_logic;
      rxclkcorcnt               : out std_logic_vector(2 downto 0);
      rxd_out                   : out std_logic_vector(7 downto 0);
      rxcharisk_out             : out std_logic;
      rxrundisp_out             : out std_logic);
  end component;


  ---------------------------------------------------------------------
  -- Component Declaration for the version 1.4.1 Calibration Block
  ---------------------------------------------------------------------

  component cal_block_v1_4_1
    generic (
      C_MGT_ID          : integer := 0;       -- 0 = MGTA | 1 = MGTB
      C_TXPOST_TAP_PD   : string  := "TRUE";  -- Default POST TAP PD
      C_RXDIGRX         : string  := "FALSE"  -- Default RXDIGRX
    );

    port (
      -- User DRP Interface (destination/slave interface)
      USER_DO             : out std_logic_vector(16-1 downto 0);
      USER_DI             : in  std_logic_vector(16-1 downto 0);
      USER_DADDR          : in  std_logic_vector(8-1 downto 0);
      USER_DEN            : in  std_logic;
      USER_DWE            : in  std_logic;
      USER_DRDY           : out std_logic;

      -- MGT DRP Interface (source/master interface)
      GT_DO               : out std_logic_vector(16-1 downto 0);
      GT_DI               : in  std_logic_vector(16-1 downto 0);
      GT_DADDR            : out std_logic_vector(8-1 downto 0);
      GT_DEN              : out std_logic;
      GT_DWE              : out std_logic;
      GT_DRDY             : in  std_logic;

      -- DRP Clock and Reset
      DCLK                : in  std_logic;
      RESET               : in  std_logic;

      -- Calibration Block Active and Disable Signals (legacy)
      ACTIVE              : out std_logic;

      -- User side MGT Pass through Signals
      USER_LOOPBACK       : in  std_logic_vector(1 downto 0);
      USER_TXENC8B10BUSE  : in  std_logic;
      USER_TXBYPASS8B10B  : in  std_logic_vector(7 downto 0);

      -- GT side MGT Pass through Signals
      GT_LOOPBACK         : out std_logic_vector(1 downto 0);
      GT_TXENC8B10BUSE    : out std_logic;
      GT_TXBYPASS8B10B    : out std_logic_vector(7 downto 0);

      -- Signal Detect Ports
      TX_SIGNAL_DETECT    : in  std_logic;
      RX_SIGNAL_DETECT    : in  std_logic

    );
  end component;


  ----------------------------------------------------------------------
  -- Signal declarations for GT11
  ----------------------------------------------------------------------

   signal COMBUSOUT_1           : std_logic_vector (15 downto 0);
   signal COMBUSOUT_0           : std_logic_vector (15 downto 0);
   signal GND_BUS               : std_logic_vector (55 downto 0);

   signal TXLOCK_0              : std_logic;
   signal RXLOCK_0              : std_logic;
   signal RXNOTINTABLE_0_INT    : std_logic;
   signal RXSTATUS_0_INT        : std_logic_vector (5 downto 0);
   signal RXDATA_0_INT          : std_logic_vector (7 downto 0);
   signal RXCHARISK_0_INT       : std_logic;
   signal RXRUNDISP_0_INT       : std_logic;

   signal RXNOTINTABLE_0_REG    : std_logic;
   signal RXDATA_0_REG          : std_logic_vector (7 downto 0);
   signal RXCHARISK_0_REG       : std_logic;
   signal RXRUNDISP_0_REG       : std_logic;
   signal RXCLKCORCNT_0_REG     : std_logic_vector (2 downto 0);

   signal RXCHARISCOMMA_0_INT   : std_logic;
   signal RXCOMMADET_0_INT      : std_logic;
   signal RXDISPERR_0_INT       : std_logic;
   signal RXREALIGN_0_INT       : std_logic;

   signal TXCHARDISPMODE_0_INT  : std_logic;
   signal TXCHARDISPVAL_0_INT   : std_logic;
   signal TXCHARISK_0_INT       : std_logic;
   signal TXDATA_0_INT          : std_logic_vector (7 downto 0);
   signal TXRUNDISP_0_INT       : std_logic;
   signal TXBUFERR_0_INT        : std_logic;
   signal ENPCOMMAALIGN_0_INT   : std_logic;
   signal ENMCOMMAALIGN_0_INT   : std_logic;

   signal RXCHARISCOMMA_float0  : std_logic_vector (6 downto 0);
   signal RXCHARISK_float0      : std_logic_vector (6 downto 0);
   signal RXDATA_float0         : std_logic_vector (55 downto 0);
   signal RXDISPERR_float0      : std_logic_vector (6 downto 0);
   signal RXNOTINTABLE_float0   : std_logic_vector (6 downto 0);
   signal RXRUNDISP_float0      : std_logic_vector (6 downto 0);
   signal TXKERR_float0         : std_logic_vector (6 downto 0);
   signal TXRUNDISP_float0      : std_logic_vector (6 downto 0);

   signal TXLOCK_1              : std_logic;
   signal RXLOCK_1              : std_logic;
   signal RXNOTINTABLE_1_INT    : std_logic;
   signal RXSTATUS_1_INT        : std_logic_vector (5 downto 0);
   signal RXDATA_1_INT          : std_logic_vector (7 downto 0);
   signal RXCHARISK_1_INT       : std_logic;
   signal RXRUNDISP_1_INT       : std_logic;

   signal RXNOTINTABLE_1_REG    : std_logic;
   signal RXDATA_1_REG          : std_logic_vector (7 downto 0);
   signal RXCHARISK_1_REG       : std_logic;
   signal RXRUNDISP_1_REG       : std_logic;
   signal RXCLKCORCNT_1_REG     : std_logic_vector (2 downto 0);

   signal RXCHARISCOMMA_1_INT   : std_logic;
   signal RXCOMMADET_1_INT      : std_logic;
   signal RXDISPERR_1_INT       : std_logic;
   signal RXREALIGN_1_INT       : std_logic;

   signal TXCHARDISPMODE_1_INT  : std_logic;
   signal TXCHARDISPVAL_1_INT   : std_logic;
   signal TXCHARISK_1_INT       : std_logic;
   signal TXDATA_1_INT          : std_logic_vector (7 downto 0);
   signal TXRUNDISP_1_INT       : std_logic;
   signal TXBUFERR_1_INT        : std_logic;
   signal ENPCOMMAALIGN_1_INT   : std_logic;
   signal ENMCOMMAALIGN_1_INT   : std_logic;

   signal RXCHARISCOMMA_float1  : std_logic_vector (6 downto 0);
   signal RXCHARISK_float1      : std_logic_vector (6 downto 0);
   signal RXDATA_float1         : std_logic_vector (55 downto 0);
   signal RXDISPERR_float1      : std_logic_vector (6 downto 0);
   signal RXNOTINTABLE_float1   : std_logic_vector (6 downto 0);
   signal RXRUNDISP_float1      : std_logic_vector (6 downto 0);
   signal TXKERR_float1         : std_logic_vector (6 downto 0);
   signal TXRUNDISP_float1      : std_logic_vector (6 downto 0);



   ---------------------------------------------------------------------
   -- Signal Declarations for GT11 <=> Calibration block
   ---------------------------------------------------------------------

   signal CAL_BLOCK_RESET       : std_logic;

   -- GT11 connected to EMAC0
   signal gt_do_0               : std_logic_vector(15 downto 0);
   signal gt_di_0               : std_logic_vector(15 downto 0);
   signal gt_daddr_0            : std_logic_vector(7 downto 0);
   signal gt_den_0              : std_logic;
   signal gt_dwe_0              : std_logic;
   signal gt_drdy_0             : std_logic;

   signal gt_rxlock_0           : std_logic;
   signal gt_txpmareset_0       : std_logic;
   signal gt_txlock_0           : std_logic;
   signal gt_loopback_0         : std_logic_vector(1 downto 0);
   signal gt_txenc8b10buse_0    : std_logic;
   signal gt_txbypass8b10b_0    : std_logic_vector(7 downto 0);
   signal gt_txoutclk1_0        : std_logic;
   signal gt_rxrecclk2_0        : std_logic;

   -- GT11 connected to EMAC1
   signal gt_do_1               : std_logic_vector(15 downto 0);
   signal gt_di_1               : std_logic_vector(15 downto 0);
   signal gt_daddr_1            : std_logic_vector(7 downto 0);
   signal gt_den_1              : std_logic;
   signal gt_dwe_1              : std_logic;
   signal gt_drdy_1             : std_logic;

   signal gt_rxlock_1           : std_logic;
   signal gt_txpmareset_1       : std_logic;
   signal gt_txlock_1           : std_logic;
   signal gt_loopback_1         : std_logic_vector(1 downto 0);
   signal gt_txenc8b10buse_1    : std_logic;
   signal gt_txbypass8b10b_1    : std_logic_vector(7 downto 0);
   signal gt_txoutclk1_1        : std_logic;
   signal gt_rxrecclk2_1        : std_logic;



begin


   GND_BUS(55 downto 0) <= (others => '0');


  ----------------------------------------------------------------------
  -- Wait for both PLL's to lock
  ----------------------------------------------------------------------

   TX_PLLLOCK_0        <=   gt_txlock_0;
   RX_PLLLOCK_0        <=   gt_rxlock_0;

   TX_PLLLOCK_1        <=   gt_txlock_1;
   RX_PLLLOCK_1        <=   gt_rxlock_1;


  ----------------------------------------------------------------------
  -- Wire internal signals to outputs
  ----------------------------------------------------------------------

   RXNOTINTABLE_0  <=   RXNOTINTABLE_0_REG;
   RXSTATUS_0      <=   RXSTATUS_0_INT;

   RXNOTINTABLE_1  <=   RXNOTINTABLE_1_REG;
   RXSTATUS_1      <=   RXSTATUS_1_INT;


  ----------------------------------------------------------------------
  -- Instantiate the Virtex-4 FX GT11 <=> Virtex-II Pro MGT RocketIO
  -- shim for EMAC0
  ----------------------------------------------------------------------
   shim_A : gt11togt_rxclkcorcnt_shim
   port map (
                rxusrclk2                    => TXUSRCLK2_0,
                rxstatus                     => RXSTATUS_0_INT,
                rxnotintable                 => RXNOTINTABLE_0_REG,
                rxd_in                       => RXDATA_0_REG,
                rxcharisk_in                 => RXCHARISK_0_REG,
                rxrundisp_in                 => RXRUNDISP_0_REG,
                rxclkcorcnt                  => RXCLKCORCNT_0,
                rxd_out                      => RXDATA_0,
                rxcharisk_out                => RXCHARISK_0,
                rxrundisp_out                => RXRUNDISP_0);

   -- Register the RX and TX interface between the MGT and EMAC
   PHYRXREG0 : process(TXUSRCLK2_0, RXRESET_0)
   begin
     if (RXRESET_0 = '1') then
       RXDATA_0_REG       <= (others => '0');
       RXCHARISK_0_REG    <= '0';
       RXRUNDISP_0_REG    <= '0';
       RXNOTINTABLE_0_REG <= '0';
       RXREALIGN_0        <= '0';
       RXCHARISCOMMA_0    <= '0';
       RXDISPERR_0        <= '0';
       RXCOMMADET_0       <= '0';
     elsif TXUSRCLK2_0'event and TXUSRCLK2_0 = '1' then
       RXDATA_0_REG       <= RXDATA_0_INT;
       RXCHARISK_0_REG    <= RXCHARISK_0_INT;
       RXRUNDISP_0_REG    <= RXRUNDISP_0_INT;
       RXNOTINTABLE_0_REG <= RXNOTINTABLE_0_INT;
       RXREALIGN_0        <= RXREALIGN_0_INT;
       RXCHARISCOMMA_0    <= RXCHARISCOMMA_0_INT;
       RXDISPERR_0        <= RXDISPERR_0_INT;
       RXCOMMADET_0       <= RXCOMMADET_0_INT;
     end if;
   end process;

   PHYTXREG0 : process(TXUSRCLK2_0, TXRESET_0)
   begin
     if (TXRESET_0 = '1') then
       TXCHARDISPMODE_0_INT <= '0';
       TXCHARDISPVAL_0_INT  <= '0';
       TXCHARISK_0_INT      <= '0';
       TXDATA_0_INT         <= (others => '0');
       ENPCOMMAALIGN_0_INT  <= '0';
       ENMCOMMAALIGN_0_INT  <= '0';
       TXRUNDISP_0          <= '0';
       TXBUFERR_0           <= '0';
     elsif TXUSRCLK2_0'event and TXUSRCLK2_0 = '1' then
       TXCHARDISPMODE_0_INT <= TXCHARDISPMODE_0;
       TXCHARDISPVAL_0_INT  <= TXCHARDISPVAL_0;
       TXCHARISK_0_INT      <= TXCHARISK_0;
       TXDATA_0_INT         <= TXDATA_0;
       ENPCOMMAALIGN_0_INT  <= ENPCOMMAALIGN_0;
       ENMCOMMAALIGN_0_INT  <= ENMCOMMAALIGN_0;
       TXRUNDISP_0          <= TXRUNDISP_0_INT;
       TXBUFERR_0           <= TXBUFERR_0_INT;
     end if;
   end process;

  ----------------------------------------------------------------------
  -- Instantiate the Virtex-4 FX GT11 <=> Virtex-II Pro MGT RocketIO
  -- shim for EMAC1
  ----------------------------------------------------------------------
   shim_B : gt11togt_rxclkcorcnt_shim
   port map (
                rxusrclk2                    => TXUSRCLK2_1,
                rxstatus                     => RXSTATUS_1_INT,
                rxnotintable                 => RXNOTINTABLE_1_REG,
                rxd_in                       => RXDATA_1_REG,
                rxcharisk_in                 => RXCHARISK_1_REG,
                rxrundisp_in                 => RXRUNDISP_1_REG,
                rxclkcorcnt                  => RXCLKCORCNT_1,
                rxd_out                      => RXDATA_1,
                rxcharisk_out                => RXCHARISK_1,
                rxrundisp_out                => RXRUNDISP_1);

   PHYRXREG1 : process(TXUSRCLK2_1, RXRESET_1)
   begin
     if (RXRESET_1 = '1') then
       RXDATA_1_REG       <= (others => '0');
       RXCHARISK_1_REG    <= '0';
       RXRUNDISP_1_REG    <= '0';
       RXNOTINTABLE_1_REG <= '0';
       RXREALIGN_1        <= '0';
       RXCHARISCOMMA_1    <= '0';
       RXDISPERR_1        <= '0';
       RXCOMMADET_1       <= '0';
     elsif TXUSRCLK2_1'event and TXUSRCLK2_1 = '1' then
       RXDATA_1_REG       <= RXDATA_1_INT;
       RXCHARISK_1_REG    <= RXCHARISK_1_INT;
       RXRUNDISP_1_REG    <= RXRUNDISP_1_INT;
       RXNOTINTABLE_1_REG <= RXNOTINTABLE_1_INT;
       RXREALIGN_1        <= RXREALIGN_1_INT;
       RXCHARISCOMMA_1    <= RXCHARISCOMMA_1_INT;
       RXDISPERR_1        <= RXDISPERR_1_INT;
       RXCOMMADET_1       <= RXCOMMADET_1_INT;
     end if;
   end process;

   -- Register the TX interface between the MGT and EMAC (after shim)
   PHYTXREG1 : process(TXUSRCLK2_1, TXRESET_1)
   begin
     if (TXRESET_1 = '1') then
       TXCHARDISPMODE_1_INT <= '0';
       TXCHARDISPVAL_1_INT  <= '0';
       TXCHARISK_1_INT      <= '0';
       TXDATA_1_INT         <= (others => '0');
       ENPCOMMAALIGN_1_INT  <= '0';
       ENMCOMMAALIGN_1_INT  <= '0';
       TXRUNDISP_1          <= '0';
       TXBUFERR_1           <= '0';
     elsif TXUSRCLK2_1'event and TXUSRCLK2_1 = '1' then
       TXCHARDISPMODE_1_INT <= TXCHARDISPMODE_1;
       TXCHARDISPVAL_1_INT  <= TXCHARDISPVAL_1;
       TXCHARISK_1_INT      <= TXCHARISK_1;
       TXDATA_1_INT         <= TXDATA_1;
       ENPCOMMAALIGN_1_INT  <= ENPCOMMAALIGN_1;
       ENMCOMMAALIGN_1_INT  <= ENMCOMMAALIGN_1;
       TXRUNDISP_1          <= TXRUNDISP_1_INT;
       TXBUFERR_1           <= TXBUFERR_1_INT;
     end if;
   end process;

  ----------------------------------------------------------------------
  -- Instantiate the Virtex-4 FX GT11 A for EMAC0
  ----------------------------------------------------------------------

   GT11_1000X_A : GT11
   generic map( 
    
    ---------- RocketIO MGT 64B66B Block Sync State Machine Attributes --------- 

        SH_CNT_MAX                 =>      64,
        SH_INVALID_CNT_MAX         =>      16,
        
    ----------------------- RocketIO MGT Alignment Atrributes ------------------   

        ALIGN_COMMA_WORD           =>      1, 
        COMMA_10B_MASK             =>      x"07f",
        COMMA32                    =>      FALSE,
        DEC_MCOMMA_DETECT          =>      TRUE,
        DEC_PCOMMA_DETECT          =>      TRUE,
        DEC_VALID_COMMA_ONLY       =>      TRUE,
        MCOMMA_32B_VALUE           =>      x"00000283",
        MCOMMA_DETECT              =>      TRUE,
        PCOMMA_32B_VALUE           =>      x"0000017c",
        PCOMMA_DETECT              =>      TRUE,
        PCS_BIT_SLIP               =>      FALSE,        
        
    ---- RocketIO MGT Atrributes Common to Clk Correction & Channel Bonding ----   

        CCCB_ARBITRATOR_DISABLE    =>      FALSE,
        CLK_COR_8B10B_DE           =>      TRUE,        

    ------------------- RocketIO MGT Channel Bonding Atrributes ----------------   
    
        CHAN_BOND_LIMIT            =>      16,
        CHAN_BOND_MODE             =>      "NONE",
        CHAN_BOND_ONE_SHOT         =>      FALSE,
        CHAN_BOND_SEQ_1_1          =>      "00000000000",
        CHAN_BOND_SEQ_1_2          =>      "00000000000",
        CHAN_BOND_SEQ_1_3          =>      "00000000000",
        CHAN_BOND_SEQ_1_4          =>      "00000000000",
        CHAN_BOND_SEQ_1_MASK       =>      "1111",
        CHAN_BOND_SEQ_2_1          =>      "00000000000",
        CHAN_BOND_SEQ_2_2          =>      "00000000000",
        CHAN_BOND_SEQ_2_3          =>      "00000000000",
        CHAN_BOND_SEQ_2_4          =>      "00000000000",
        CHAN_BOND_SEQ_2_MASK       =>      "1111",
        CHAN_BOND_SEQ_2_USE        =>      FALSE,
        CHAN_BOND_SEQ_LEN          =>      1,
 
    ------------------ RocketIO MGT Clock Correction Atrributes ----------------   

        CLK_COR_MAX_LAT            =>      48,
        CLK_COR_MIN_LAT            =>      36,
        CLK_COR_SEQ_1_1            =>      "00110111100",
        CLK_COR_SEQ_1_2            =>      "00001010000",
        CLK_COR_SEQ_1_3            =>      "00000000000",
        CLK_COR_SEQ_1_4            =>      "00000000000",
        CLK_COR_SEQ_1_MASK         =>      "1100",
        CLK_COR_SEQ_2_1            =>      "00110111100",
        CLK_COR_SEQ_2_2            =>      "00010110101",
        CLK_COR_SEQ_2_3            =>      "00000000000",
        CLK_COR_SEQ_2_4            =>      "00000000000",
        CLK_COR_SEQ_2_MASK         =>      "1100",
        CLK_COR_SEQ_2_USE          =>      FALSE,
        CLK_COR_SEQ_DROP           =>      FALSE,
        CLK_COR_SEQ_LEN            =>      2,
        CLK_CORRECT_USE            =>      TRUE, 
        
    ---------------------- RocketIO MGT Clocking Atrributes --------------------      
                                        
        RX_CLOCK_DIVIDER           =>      "10",
        RXASYNCDIVIDE              =>      "00", 
        RXCLK0_FORCE_PMACLK        =>      TRUE,
        RXCLKMODE                  =>      "000011",
        RXOUTDIV2SEL               =>      4, --2, -- Erdem 
        RXPLLNDIVSEL               =>      20, --10, -- Erdem 
        RXPMACLKSEL                =>      "REFCLK1",
        RXRECCLK1_USE_SYNC         =>      FALSE,
        RXUSRDIVISOR               =>      1,
        TX_CLOCK_DIVIDER           =>      "10",
        TXABPMACLKSEL              =>      "REFCLK1",
        TXASYNCDIVIDE              =>      "00",
        TXCLK0_FORCE_PMACLK        =>      TRUE,
        TXCLKMODE                  =>      "0100",
        TXOUTCLK1_USE_SYNC         =>      FALSE,
        TXOUTDIV2SEL               =>      4, --2, -- Erdem 
        TXPHASESEL                 =>      FALSE, 
        TXPLLNDIVSEL               =>      20, --10, -- Erdem

    -------------------------- RocketIO MGT CRC Atrributes ---------------------   

        RXCRCCLOCKDOUBLE           =>      FALSE,
        RXCRCENABLE                =>      FALSE,
        RXCRCINITVAL               =>      x"FFFFFFFF",
        RXCRCINVERTGEN             =>      FALSE,
        RXCRCSAMECLOCK             =>      TRUE,
        TXCRCCLOCKDOUBLE           =>      FALSE,
        TXCRCENABLE                =>      FALSE,
        TXCRCINITVAL               =>      x"FFFFFFFF",
        TXCRCINVERTGEN             =>      FALSE,
        TXCRCSAMECLOCK             =>      TRUE,
        
    --------------------- RocketIO MGT Data Path Atrributes --------------------   
    
        RXDATA_SEL                 =>      "00",
        TXDATA_SEL                 =>      "00",

    ---------------- RocketIO MGT Digital Receiver Attributes ------------------   

        DIGRX_FWDCLK               =>      "10",
        DIGRX_SYNC_MODE            =>      FALSE,
        ENABLE_DCDR                =>      FALSE,
        RXBY_32                    =>      FALSE,
        RXDIGRESET                 =>      FALSE,
        RXDIGRX                    =>      FALSE,
        SAMPLE_8X                  =>      FALSE,
                                        
    ----------------- Rocket IO MGT Miscellaneous Attributes ------------------     

        GT11_MODE                  =>      "A",
        OPPOSITE_SELECT            =>      FALSE,
        PMA_BIT_SLIP               =>      FALSE,
        REPEATER                   =>      FALSE,
        RX_BUFFER_USE              =>      TRUE,
        RXCDRLOS                   =>      "000000",
        RXDCCOUPLE                 =>      FALSE,
        RXFDCAL_CLOCK_DIVIDE       =>      "NONE",
        TX_BUFFER_USE              =>      TRUE,   
        TXFDCAL_CLOCK_DIVIDE       =>      "NONE",
        TXSLEWRATE                 =>      TRUE,

     ----------------- Rocket IO MGT Preemphasis and Equalization --------------
     
        RXAFEEQ                    =>       "000000000",
        RXEQ                       =>       x"4000000000000000",
        TXDAT_PRDRV_DAC            =>       "111",
        TXDAT_TAP_DAC              =>       "10110",
        TXHIGHSIGNALEN             =>       TRUE,
        TXPOST_PRDRV_DAC           =>       "111",
        TXPOST_TAP_DAC             =>       "00001",
        TXPOST_TAP_PD              =>       TRUE,
        TXPRE_PRDRV_DAC            =>       "111",
        TXPRE_TAP_DAC              =>       "00000",      
        TXPRE_TAP_PD               =>       TRUE,        
                                        
                                        
                                          
    ----------------------- Restricted RocketIO MGT Attributes -------------------  

    ---Note : THE FOLLOWING ATTRIBUTES ARE RESTRICTED. PLEASE DO NOT EDIT.

     ----------------------------- Restricted: Biasing -------------------------
     
        BANDGAPSEL                 =>       FALSE,
        BIASRESSEL                 =>       FALSE,    
        IREFBIASMODE               =>       "11",
        PMAIREFTRIM                =>       "0111",
        PMAVREFTRIM                =>       "0111",
        TXAREFBIASSEL              =>       TRUE, 
        TXTERMTRIM                 =>       "1100",
        VREFBIASMODE               =>       "11",

     ---------------- Restricted: Frequency Detector and Calibration -----------  
     
        CYCLE_LIMIT_SEL            =>       "00",
        FDET_HYS_CAL               =>       "010",
        FDET_HYS_SEL               =>       "100",
        FDET_LCK_CAL               =>       "101",
        FDET_LCK_SEL               =>       "001",
        LOOPCAL_WAIT               =>       "00",
        RXCYCLE_LIMIT_SEL          =>       "00",
        RXFDET_HYS_CAL             =>       "010",
        RXFDET_HYS_SEL             =>       "100",
        RXFDET_LCK_CAL             =>       "101",   
        RXFDET_LCK_SEL             =>       "001",
        RXLOOPCAL_WAIT             =>       "00",
        RXSLOWDOWN_CAL             =>       "00",
        SLOWDOWN_CAL               =>       "00",

     --------------------------- Restricted: PLL Settings ---------------------
     
        PMACLKENABLE               =>       TRUE,
        PMACOREPWRENABLE           =>       TRUE,
        PMAVBGCTRL                 =>       "00000",
        RXACTST                    =>       FALSE,          
        RXAFETST                   =>       FALSE,         
        RXCMADJ                    =>       "01",
        RXCPSEL                    =>       FALSE,
        RXCPTST                    =>       FALSE,
        RXCTRL1                    =>       x"200",
        RXFECONTROL1               =>       "00",  
        RXFECONTROL2               =>       "000",  
        RXFETUNE                   =>       "01", 
        RXLKADJ                    =>       "00000",
        RXLOOPFILT                 =>       "1111",
        RXPDDTST                   =>       TRUE,          
        RXRCPADJ                   =>       "010",   
        RXRIBADJ                   =>       "11",
        RXVCO_CTRL_ENABLE          =>       TRUE,
        RXVCODAC_INIT              =>       "0000000101",   
        TXCPSEL                    =>       FALSE,
        TXCTRL1                    =>       x"200",
        TXLOOPFILT                 =>       "1101",   
        VCO_CTRL_ENABLE            =>       TRUE,
        VCODAC_INIT                =>       "0000000101",
        
    --------------------------- Restricted: Powerdowns ------------------------  
    
        POWER_ENABLE               =>       TRUE,
        RXAFEPD                    =>       FALSE,
        RXAPD                      =>       FALSE,
        RXLKAPD                    =>       FALSE,
        RXPD                       =>       FALSE,
        RXRCPPD                    =>       FALSE,
        RXRPDPD                    =>       FALSE,
        RXRSDPD                    =>       FALSE,
        TXAPD                      =>       FALSE,
        TXDIGPD                    =>       FALSE,
        TXLVLSHFTPD                =>       FALSE,
        TXPD                       =>       FALSE
      )

      -- Connect to EMAC0 (1000BASE-X)
       port map (
                CHBONDO                      => open,
                COMBUSIN(15 downto 0)        => COMBUSOUT_1(15 downto 0),
                DRDY                         => gt_drdy_0,
                RXBUFERR                     => RXBUFERR_0,
                RXCALFAIL                    => open,
                RXCHARISCOMMA(7 downto 1)    => RXCHARISCOMMA_float0(6 downto 0),
                RXCHARISCOMMA(0)             => RXCHARISCOMMA_0_INT,
                RXCHARISK(7 downto 1)        => RXCHARISK_float0(6 downto 0),
                RXCHARISK(0)                 => RXCHARISK_0_INT,
                RXCOMMADET                   => RXCOMMADET_0_INT,
                RXCRCOUT                     => open,
                RXCYCLELIMIT                 => open,
                RXDATA(63 downto 8)          => RXDATA_float0(55 downto 0),
                RXDATA(7 downto 0)           => RXDATA_0_INT (7 downto 0) ,
                RXDISPERR(7 downto 1)        => RXDISPERR_float0(6 downto 0),
                RXDISPERR(0)                 => RXDISPERR_0_INT,
                RXLOCK                       => gt_rxlock_0,
                RXLOSSOFSYNC                 => open,
                RXMCLK                       => open,
                RXNOTINTABLE(7 downto 1)     => RXNOTINTABLE_float0(6 downto 0),
                RXNOTINTABLE(0)              => RXNOTINTABLE_0_INT,
                RXPCSHCLKOUT                 => open,
                RXREALIGN                    => RXREALIGN_0_INT,
                RXRECCLK1                    => RXRECCLK1_0,
                RXRECCLK2                    => gt_rxrecclk2_0,
                RXRUNDISP(7 downto 1)        => RXRUNDISP_float0(6 downto 0),
                RXRUNDISP(0)                 => RXRUNDISP_0_INT,
                RXSIGDET                     => open,
                RXSTATUS(5 downto 0)         => RXSTATUS_0_INT (5 downto 0),
                TXBUFERR                     => TXBUFERR_0_INT,
                TXCALFAIL                    => open,
                TXCRCOUT                     => open,
                TXCYCLELIMIT                 => open,
                TXKERR                       => open,
                TXLOCK                       => gt_txlock_0,
                TXOUTCLK1                    => gt_txoutclk1_0,
                TXOUTCLK2                    => open,
                TXPCSHCLKOUT                 => open,
                TXRUNDISP(7 downto 1)        => TXRUNDISP_float0(6 downto 0),
                TXRUNDISP(0)                 => TXRUNDISP_0_INT,
                TX1N                         => TX1N_0,
                TX1P                         => TX1P_0,

                CHBONDI                      => (others => '0'),
                COMBUSOUT(15 downto 0)       => COMBUSOUT_0(15 downto 0),
                DADDR(7 downto 0)            => gt_daddr_0,
                DCLK                         => DCLK,
                DEN                          => gt_den_0,
                DI(15 downto 0)              => gt_do_0,
                DWE                          => gt_dwe_0,
                ENCHANSYNC                   => '0',
                ENMCOMMAALIGN                => ENMCOMMAALIGN_0_INT,
                ENPCOMMAALIGN                => ENPCOMMAALIGN_0_INT,
                GREFCLK                      => '0',
                LOOPBACK(1 downto 0)         => gt_loopback_0,
                POWERDOWN                    => '0',
                REFCLK1                      => REFCLK1_0,
                REFCLK2                      => REFCLK2_0,
                RXBLOCKSYNC64B66BUSE         => '0',
                RXCLKSTABLE                  => '1',
                RXCOMMADETUSE                => '1',
                RXCRCCLK                     => TXUSRCLK2_0,
                RXCRCDATAVALID               => '0',
                RXCRCDATAWIDTH               => "000",
                RXCRCIN                      => X"0000000000000000",
                RXCRCINIT                    => '0',
                RXCRCINTCLK                  => TXUSRCLK2_0,
                RXCRCPD                      => '1',
                RXCRCRESET                   => '0',
                RXDATAWIDTH                  => "00",
                RXDEC8B10BUSE                => '1',
                RXDEC64B66BUSE               => '0',
                RXDESCRAM64B66BUSE           => '0',
                RXIGNOREBTF                  => '0',
                RXINTDATAWIDTH               => "11",
                RXPMARESET                   => RXPMARESET0,
                RXPOLARITY                   => '0',
                RXRESET                      => RXRESET_0,
                RXSLIDE                      => '0',
                RXSYNC                       => '0',
                RXUSRCLK                     => RXUSRCLK_0,
                RXUSRCLK2                    => RXUSRCLK2_0,
                RX1N                         => RX1N_0,
                RX1P                         => RX1P_0,
                TXBYPASS8B10B                => gt_txbypass8b10b_0,
                TXCHARDISPMODE(7 downto 1)   => "0000000",
                TXCHARDISPMODE(0)            => TXCHARDISPMODE_0_INT,
                TXCHARDISPVAL(7 downto 1)    => "0000000",
                TXCHARDISPVAL(0)             => TXCHARDISPVAL_0_INT,
                TXCHARISK(7 downto 1)        => "0000000",
                TXCHARISK(0)                 => TXCHARISK_0_INT,
                TXCLKSTABLE                  => '1',
                TXCRCCLK                     => TXUSRCLK2_0,
                TXCRCDATAVALID               => '0',
                TXCRCDATAWIDTH               => "000",
                TXCRCIN                      => X"0000000000000000",
                TXCRCINIT                    => '0',
                TXCRCINTCLK                  => TXUSRCLK2_0,
                TXCRCPD                      => '1',
                TXCRCRESET                   => '0',
                TXDATA(63 downto 8)          => GND_BUS(55 downto 0),
                TXDATA(7 downto 0)           => TXDATA_0_INT (7 downto 0),
                TXDATAWIDTH                  => "00",
                TXENC8B10BUSE                => gt_txenc8b10buse_0,
                TXENC64B66BUSE               => '0',
                TXENOOB                      => '0',
                TXGEARBOX64B66BUSE           => '0',
                TXINHIBIT                    => '0',
                TXINTDATAWIDTH               => "11",
                TXPMARESET                   => PMARESET_TX0,
                TXPOLARITY                   => '0',
                TXRESET                      => TXRESET_0,
                TXSCRAM64B66BUSE             => '0',
                TXSYNC                       => '0',
                TXUSRCLK                     => TXUSRCLK_0,
                TXUSRCLK2                    => TXUSRCLK2_0,
                DO                           => gt_di_0
      );

      TXOUTCLK1_0 <= gt_txoutclk1_0;



      ---------------------------------------------------------------------
      -- Component Instantiation for the version 1.4.1 Calibration Block
      -- Applied to the GT11 A connected to EMAC0
      ---------------------------------------------------------------------

      CAL_BLOCK_RESET <= not DCM_LOCKED;

cal_block_A : cal_block_v1_4_1
  generic map (
    C_MGT_ID            => 0,                     -- 0 = MGTA | 1 = MGTB
    C_TXPOST_TAP_PD     => "TRUE",                -- "TRUE" or "FALSE"
    C_RXDIGRX           => "FALSE"                 -- "TRUE" or "FALSE"
  )
  port map (
    -- User DRP Interface (destination/slave interface)
    USER_DO             => open,                  -- O [15:0]
    USER_DI             => X"0000",               -- I [15:0]
    USER_DADDR          => X"00",                 -- I [7:0]
    USER_DEN            => '0',                   -- I
    USER_DWE            => '0',                   -- I
    USER_DRDY           => open,                  -- O

    -- MGT DRP Interface (source/master interface)
    GT_DO               => gt_do_0,               -- O [15:0]
    GT_DI               => gt_di_0,               -- I [15:0]
    GT_DADDR            => gt_daddr_0,            -- O [7:0]
    GT_DEN              => gt_den_0,              -- O
    GT_DWE              => gt_dwe_0,              -- O
    GT_DRDY             => gt_drdy_0,             -- I

    -- Clock and Reset
    DCLK                => DCLK,                  -- I
    RESET               => CAL_BLOCK_RESET,       -- I

    -- Calibration Block Active and Disable Signals (legacy)
    ACTIVE              => open,                  -- O

    -- User side MGT Pass through Signals
    USER_LOOPBACK       =>  LOOPBACK_0,           -- I [1:0]
    USER_TXENC8B10BUSE  =>  '1',                  -- I
    USER_TXBYPASS8B10B  =>  X"00",                -- I [7:0]

    -- GT side MGT Pass through Signals
    GT_LOOPBACK         => gt_loopback_0,         -- O [1:0]
    GT_TXENC8B10BUSE    => gt_txenc8b10buse_0,    -- O
    GT_TXBYPASS8B10B    => gt_txbypass8b10b_0,    -- O [7:0]

    -- Signal Detect Ports
    TX_SIGNAL_DETECT    => '1',                   -- I
    RX_SIGNAL_DETECT    => RX_SIGNAL_DETECT_0     -- I

  );

  ----------------------------------------------------------------------
  -- Instantiate the Virtex-4 FX GT11 B for EMAC1
  ----------------------------------------------------------------------


   GT11_1000X_B : GT11
   generic map( 
    
    ---------- RocketIO MGT 64B66B Block Sync State Machine Attributes --------- 

        SH_CNT_MAX                 =>      64,
        SH_INVALID_CNT_MAX         =>      16,
        
    ----------------------- RocketIO MGT Alignment Atrributes ------------------   

        ALIGN_COMMA_WORD           =>      1,
        COMMA_10B_MASK             =>      x"07f",
        COMMA32                    =>      FALSE,
        DEC_MCOMMA_DETECT          =>      TRUE,
        DEC_PCOMMA_DETECT          =>      TRUE,
        DEC_VALID_COMMA_ONLY       =>      TRUE,
        MCOMMA_32B_VALUE           =>      x"00000283",
        MCOMMA_DETECT              =>      TRUE,
        PCOMMA_32B_VALUE           =>      x"0000017c",
        PCOMMA_DETECT              =>      TRUE,
        PCS_BIT_SLIP               =>      FALSE,        
        
    ---- RocketIO MGT Atrributes Common to Clk Correction & Channel Bonding ----   

        CCCB_ARBITRATOR_DISABLE    =>      FALSE,
        CLK_COR_8B10B_DE           =>      TRUE,        

    ------------------- RocketIO MGT Channel Bonding Atrributes ----------------   
    
        CHAN_BOND_LIMIT            =>      16,
        CHAN_BOND_MODE             =>      "NONE",
        CHAN_BOND_ONE_SHOT         =>      FALSE,
        CHAN_BOND_SEQ_1_1          =>      "00000000000",
        CHAN_BOND_SEQ_1_2          =>      "00000000000",
        CHAN_BOND_SEQ_1_3          =>      "00000000000",
        CHAN_BOND_SEQ_1_4          =>      "00000000000",
        CHAN_BOND_SEQ_1_MASK       =>      "1111",
        CHAN_BOND_SEQ_2_1          =>      "00000000000",
        CHAN_BOND_SEQ_2_2          =>      "00000000000",
        CHAN_BOND_SEQ_2_3          =>      "00000000000",
        CHAN_BOND_SEQ_2_4          =>      "00000000000",
        CHAN_BOND_SEQ_2_MASK       =>      "1111",
        CHAN_BOND_SEQ_2_USE        =>      FALSE,
        CHAN_BOND_SEQ_LEN          =>      1,
 
    ------------------ RocketIO MGT Clock Correction Atrributes ----------------   

        CLK_COR_MAX_LAT            =>      48,
        CLK_COR_MIN_LAT            =>      36,
        CLK_COR_SEQ_1_1            =>      "00110111100",
        CLK_COR_SEQ_1_2            =>      "00001010000",
        CLK_COR_SEQ_1_3            =>      "00000000000",
        CLK_COR_SEQ_1_4            =>      "00000000000",
        CLK_COR_SEQ_1_MASK         =>      "1100",
        CLK_COR_SEQ_2_1            =>      "00110111100",
        CLK_COR_SEQ_2_2            =>      "00010110101",
        CLK_COR_SEQ_2_3            =>      "00000000000",
        CLK_COR_SEQ_2_4            =>      "00000000000",
        CLK_COR_SEQ_2_MASK         =>      "1100",
        CLK_COR_SEQ_2_USE          =>      FALSE,
        CLK_COR_SEQ_DROP           =>      FALSE,
        CLK_COR_SEQ_LEN            =>      2,
        CLK_CORRECT_USE            =>      TRUE,
        
    ---------------------- RocketIO MGT Clocking Atrributes --------------------      
                                        
        RX_CLOCK_DIVIDER           =>      "10",
        RXASYNCDIVIDE              =>      "00",
        RXCLK0_FORCE_PMACLK        =>      TRUE,
        RXCLKMODE                  =>      "000011",
        RXOUTDIV2SEL               =>      4, --2, -- Erdem 
        RXPLLNDIVSEL               =>      20, --10, -- Erdem
        RXPMACLKSEL                =>      "REFCLK1",
        RXRECCLK1_USE_SYNC         =>      FALSE,
        RXUSRDIVISOR               =>      1,
        TX_CLOCK_DIVIDER           =>      "10",
        TXABPMACLKSEL              =>      "REFCLK1",
        TXASYNCDIVIDE              =>      "00",
        TXCLK0_FORCE_PMACLK        =>      TRUE,
        TXCLKMODE                  =>      "0100",
        TXOUTCLK1_USE_SYNC         =>      FALSE,
        TXOUTDIV2SEL               =>      4, --2,  -- Erdem 
        TXPHASESEL                 =>      FALSE, 
        TXPLLNDIVSEL               =>      20, --10,  -- Erdem

    -------------------------- RocketIO MGT CRC Atrributes ---------------------   

        RXCRCCLOCKDOUBLE           =>      FALSE,
        RXCRCENABLE                =>      FALSE,
        RXCRCINITVAL               =>      x"FFFFFFFF",
        RXCRCINVERTGEN             =>      FALSE,
        RXCRCSAMECLOCK             =>      TRUE,
        TXCRCCLOCKDOUBLE           =>      FALSE,
        TXCRCENABLE                =>      FALSE,
        TXCRCINITVAL               =>      x"FFFFFFFF",
        TXCRCINVERTGEN             =>      FALSE,
        TXCRCSAMECLOCK             =>      TRUE,
        
    --------------------- RocketIO MGT Data Path Atrributes --------------------   
    
        RXDATA_SEL                 =>      "00",
        TXDATA_SEL                 =>      "00",

    ---------------- RocketIO MGT Digital Receiver Attributes ------------------   

        DIGRX_FWDCLK               =>      "10",
        DIGRX_SYNC_MODE            =>      FALSE,
        ENABLE_DCDR                =>      FALSE,
        RXBY_32                    =>      FALSE,
        RXDIGRESET                 =>      FALSE,
        RXDIGRX                    =>      FALSE,
        SAMPLE_8X                  =>      FALSE,
                                        
    ----------------- Rocket IO MGT Miscellaneous Attributes ------------------     

        GT11_MODE                  =>      "B",
        OPPOSITE_SELECT            =>      FALSE,
        PMA_BIT_SLIP               =>      FALSE,
        REPEATER                   =>      FALSE,
        RX_BUFFER_USE              =>      TRUE,
        RXCDRLOS                   =>      "000000",
        RXDCCOUPLE                 =>      FALSE,
        RXFDCAL_CLOCK_DIVIDE       =>      "NONE",
        TX_BUFFER_USE              =>      TRUE,   
        TXFDCAL_CLOCK_DIVIDE       =>      "NONE",
        TXSLEWRATE                 =>      TRUE,

     ----------------- Rocket IO MGT Preemphasis and Equalization --------------
     
        RXAFEEQ                    =>       "000000000",
        RXEQ                       =>       x"4000000000000000",
        TXDAT_PRDRV_DAC            =>       "111",
        TXDAT_TAP_DAC              =>       "10110",
        TXHIGHSIGNALEN             =>       TRUE,
        TXPOST_PRDRV_DAC           =>       "111",
        TXPOST_TAP_DAC             =>       "00001",
        TXPOST_TAP_PD              =>       TRUE,
        TXPRE_PRDRV_DAC            =>       "111",
        TXPRE_TAP_DAC              =>       "00000",      
        TXPRE_TAP_PD               =>       TRUE,        
                                        
                                        
                                          
    ----------------------- Restricted RocketIO MGT Attributes -------------------  

    ---Note : THE FOLLOWING ATTRIBUTES ARE RESTRICTED. PLEASE DO NOT EDIT.

     ----------------------------- Restricted: Biasing -------------------------
     
        BANDGAPSEL                 =>       FALSE,
        BIASRESSEL                 =>       FALSE,    
        IREFBIASMODE               =>       "11",
        PMAIREFTRIM                =>       "0111",
        PMAVREFTRIM                =>       "0111",
        TXAREFBIASSEL              =>       TRUE, 
        TXTERMTRIM                 =>       "1100",
        VREFBIASMODE               =>       "11",

     ---------------- Restricted: Frequency Detector and Calibration -----------  
     
        CYCLE_LIMIT_SEL            =>       "00",
        FDET_HYS_CAL               =>       "010",
        FDET_HYS_SEL               =>       "100",
        FDET_LCK_CAL               =>       "101",
        FDET_LCK_SEL               =>       "001",
        LOOPCAL_WAIT               =>       "00",
        RXCYCLE_LIMIT_SEL          =>       "00",
        RXFDET_HYS_CAL             =>       "010",
        RXFDET_HYS_SEL             =>       "100",
        RXFDET_LCK_CAL             =>       "101",   
        RXFDET_LCK_SEL             =>       "001",
        RXLOOPCAL_WAIT             =>       "00",
        RXSLOWDOWN_CAL             =>       "00",
        SLOWDOWN_CAL               =>       "00",

     --------------------------- Restricted: PLL Settings ---------------------
     
        PMACLKENABLE               =>       TRUE,
        PMACOREPWRENABLE           =>       TRUE,
        PMAVBGCTRL                 =>       "00000",
        RXACTST                    =>       FALSE,          
        RXAFETST                   =>       FALSE,         
        RXCMADJ                    =>       "01",
        RXCPSEL                    =>       FALSE,
        RXCPTST                    =>       FALSE,
        RXCTRL1                    =>       x"200",
        RXFECONTROL1               =>       "00",  
        RXFECONTROL2               =>       "000",  
        RXFETUNE                   =>       "01", 
        RXLKADJ                    =>       "00000",
        RXLOOPFILT                 =>       "1111",
        RXPDDTST                   =>       TRUE,          
        RXRCPADJ                   =>       "010",   
        RXRIBADJ                   =>       "11",
        RXVCO_CTRL_ENABLE          =>       TRUE,
        RXVCODAC_INIT              =>       "0000000101",   
        TXCPSEL                    =>       FALSE,
        TXCTRL1                    =>       x"200",
        TXLOOPFILT                 =>       "1101",   
        VCO_CTRL_ENABLE            =>       TRUE,
        VCODAC_INIT                =>       "0000000101",
        
    --------------------------- Restricted: Powerdowns ------------------------  
    
        POWER_ENABLE               =>       TRUE,
        RXAFEPD                    =>       FALSE,
        RXAPD                      =>       FALSE,
        RXLKAPD                    =>       FALSE,
        RXPD                       =>       FALSE,
        RXRCPPD                    =>       FALSE,
        RXRPDPD                    =>       FALSE,
        RXRSDPD                    =>       FALSE,
        TXAPD                      =>       FALSE,
        TXDIGPD                    =>       FALSE,
        TXLVLSHFTPD                =>       FALSE,
        TXPD                       =>       FALSE
      )

      -- Connect to EMAC1 (1000BASE-X)
       port map (
                CHBONDO                      => open,
                COMBUSIN(15 downto 0)        => COMBUSOUT_0(15 downto 0),
                DRDY                         => gt_drdy_1,
                RXBUFERR                     => RXBUFERR_1,
                RXCALFAIL                    => open,
                RXCHARISCOMMA(7 downto 1)    => RXCHARISCOMMA_float1(6 downto 0),
                RXCHARISCOMMA(0)             => RXCHARISCOMMA_1_INT,
                RXCHARISK(7 downto 1)        => RXCHARISK_float1(6 downto 0),
                RXCHARISK(0)                 => RXCHARISK_1_INT,
                RXCOMMADET                   => RXCOMMADET_1_INT,
                RXCRCOUT                     => open,
                RXCYCLELIMIT                 => open,
                RXDATA(63 downto 8)          => RXDATA_float1(55 downto 0),
                RXDATA(7 downto 0)           => RXDATA_1_INT (7 downto 0) ,
                RXDISPERR(7 downto 1)        => RXDISPERR_float1(6 downto 0),
                RXDISPERR(0)                 => RXDISPERR_1_INT,
                RXLOCK                       => gt_rxlock_1,
                RXLOSSOFSYNC                 => open,
                RXMCLK                       => open,
                RXNOTINTABLE(7 downto 1)     => RXNOTINTABLE_float1(6 downto 0),
                RXNOTINTABLE(0)              => RXNOTINTABLE_1_INT,
                RXPCSHCLKOUT                 => open,
                RXREALIGN                    => RXREALIGN_1_INT,
                RXRECCLK1                    => RXRECCLK1_1,
                RXRECCLK2                    => gt_rxrecclk2_1,
                RXRUNDISP(7 downto 1)        => RXRUNDISP_float1(6 downto 0),
                RXRUNDISP(0)                 => RXRUNDISP_1_INT,
                RXSIGDET                     => open,
                RXSTATUS(5 downto 0)         => RXSTATUS_1_INT (5 downto 0),
                TXBUFERR                     => TXBUFERR_1_INT,
                TXCALFAIL                    => open,
                TXCRCOUT                     => open,
                TXCYCLELIMIT                 => open,
                TXKERR                       => open,
                TXLOCK                       => gt_txlock_1,
                TXOUTCLK1                    => gt_txoutclk1_1,
                TXOUTCLK2                    => open,
                TXPCSHCLKOUT                 => open,
                TXRUNDISP(7 downto 1)        => TXRUNDISP_float1(6 downto 0),
                TXRUNDISP(0)                 => TXRUNDISP_1_INT,
                TX1N                         => TX1N_1,
                TX1P                         => TX1P_1,

                CHBONDI                      => (others => '0'),
                COMBUSOUT(15 downto 0)       => COMBUSOUT_1(15 downto 0),
                DADDR(7 downto 0)            => gt_daddr_1,
                DCLK                         => DCLK,
                DEN                          => gt_den_1,
                DI(15 downto 0)              => gt_do_1,
                DWE                          => gt_dwe_1,
                ENCHANSYNC                   => '0',
                ENMCOMMAALIGN                => ENMCOMMAALIGN_1_INT,
                ENPCOMMAALIGN                => ENPCOMMAALIGN_1_INT,
                GREFCLK                      => '0',
                LOOPBACK(1 downto 0)         => gt_loopback_1,
                POWERDOWN                    => '0',
                REFCLK1                      => REFCLK1_1,
                REFCLK2                      => REFCLK2_1,
                RXBLOCKSYNC64B66BUSE         => '0',
                RXCLKSTABLE                  => '1',
                RXCOMMADETUSE                => '1',
                RXCRCCLK                     => TXUSRCLK2_1,
                RXCRCDATAVALID               => '0',
                RXCRCDATAWIDTH               => "000",
                RXCRCIN                      => X"0000000000000000",
                RXCRCINIT                    => '0',
                RXCRCINTCLK                  => TXUSRCLK2_1,
                RXCRCPD                      => '1',
                RXCRCRESET                   => '0',
                RXDATAWIDTH                  => "00",
                RXDEC8B10BUSE                => '1',
                RXDEC64B66BUSE               => '0',
                RXDESCRAM64B66BUSE           => '0',
                RXIGNOREBTF                  => '0',
                RXINTDATAWIDTH               => "11",
                RXPMARESET                   => RXPMARESET1,
                RXPOLARITY                   => '0',
                RXRESET                      => RXRESET_1,
                RXSLIDE                      => '0',
                RXSYNC                       => '0', 
                RXUSRCLK                     => RXUSRCLK_1,
                RXUSRCLK2                    => RXUSRCLK2_1,
                RX1N                         => RX1N_1,
                RX1P                         => RX1P_1,
                TXBYPASS8B10B                => gt_txbypass8b10b_1,
                TXCHARDISPMODE(7 downto 1)   => "0000000",
                TXCHARDISPMODE(0)            => TXCHARDISPMODE_1_INT,
                TXCHARDISPVAL(7 downto 1)    => "0000000",
                TXCHARDISPVAL(0)             => TXCHARDISPVAL_1_INT,
                TXCHARISK(7 downto 1)        => "0000000",
                TXCHARISK(0)                 => TXCHARISK_1_INT,
                TXCLKSTABLE                  => '1',
                TXCRCCLK                     => TXUSRCLK2_1,
                TXCRCDATAVALID               => '0',
                TXCRCDATAWIDTH               => "000",
                TXCRCIN                      => X"0000000000000000",
                TXCRCINIT                    => '0',
                TXCRCINTCLK                  => TXUSRCLK2_1,
                TXCRCPD                      => '1',
                TXCRCRESET                   => '0',
                TXDATA(63 downto 8)          => GND_BUS(55 downto 0),
                TXDATA(7 downto 0)           => TXDATA_1_INT (7 downto 0),
                TXDATAWIDTH                  => "00",
                TXENC8B10BUSE                => gt_txenc8b10buse_1,
                TXENC64B66BUSE               => '0',
                TXENOOB                      => '0',
                TXGEARBOX64B66BUSE           => '0',
                TXINHIBIT                    => '0',
                TXINTDATAWIDTH               => "11",
                TXPMARESET                   => PMARESET_TX1,
                TXPOLARITY                   => '0',
                TXRESET                      => TXRESET_1,
                TXSCRAM64B66BUSE             => '0',
                TXSYNC                       => '0',
                TXUSRCLK                     => TXUSRCLK_1,
                TXUSRCLK2                    => TXUSRCLK2_1,
                DO                           => gt_di_1
      );

      TXOUTCLK1_1 <= gt_txoutclk1_1;



      ---------------------------------------------------------------------
      -- Component Instantiation for the version 1.4.1 Calibration Block
      -- Applied to the GT11 B connected to EMAC1
      ---------------------------------------------------------------------

      cal_block_B : cal_block_v1_4_1
        generic map (
          C_MGT_ID            => 1,                     -- 0 = MGTA | 1 = MGTB
          C_TXPOST_TAP_PD     => "TRUE",                -- "TRUE" or "FALSE"
          C_RXDIGRX           => "TRUE"                 -- "TRUE" or "FALSE"
        )
        port map (
          -- User DRP Interface (destination/slave interface)
          USER_DO             => open,                  -- O [15:0]
          USER_DI             => X"0000",               -- I [15:0]
          USER_DADDR          => X"00",                 -- I [7:0]
          USER_DEN            => '0',                   -- I
          USER_DWE            => '0',                   -- I
          USER_DRDY           => open,                  -- O

          -- MGT DRP Interface (source/master interface)
          GT_DO               => gt_do_1,               -- O [15:0]
          GT_DI               => gt_di_1,               -- I [15:0]
          GT_DADDR            => gt_daddr_1,            -- O [7:0]
          GT_DEN              => gt_den_1,              -- O
          GT_DWE              => gt_dwe_1,              -- O
          GT_DRDY             => gt_drdy_1,             -- I

          -- Clock and Reset
          DCLK                => DCLK,                  -- I
          RESET               => cal_block_reset,       -- I

          -- Calibration Block Active and Disable Signals (legacy)
          ACTIVE              => open,                  -- O

          -- User side MGT Pass through Signals
          USER_LOOPBACK       =>  LOOPBACK_1,           -- I [1:0]
          USER_TXENC8B10BUSE  =>  '1',                  -- I
          USER_TXBYPASS8B10B  =>  X"00",                -- I [7:0]

          -- GT side MGT Pass through Signals
          GT_LOOPBACK         => gt_loopback_1,         -- O [1:0]
          GT_TXENC8B10BUSE    => gt_txenc8b10buse_1,    -- O
          GT_TXBYPASS8B10B    => gt_txbypass8b10b_1,    -- O [7:0]

          -- Signal Detect Ports
          TX_SIGNAL_DETECT    => '1',                   -- I
          RX_SIGNAL_DETECT    => RX_SIGNAL_DETECT_1     -- I

        );


 end structural;
