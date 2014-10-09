-------------------------------------------------------------------------------
-- Title         : Pretty Good Protocol, MGT Wrapper
-- Project       : General Purpose Core
-------------------------------------------------------------------------------
-- File          : PgpMgtWrap.vhd
-- Author        : Ryan Herbst, rherbst@slac.stanford.edu
-- Created       : 03/15/2007
-------------------------------------------------------------------------------
-- Description:
-- VHDL source file containing the PGP, MGT and CRC blocks.
-- This module also contains the logic to control the reset of the MGT.
-------------------------------------------------------------------------------
-- Copyright (c) 2006 by Ryan Herbst. All rights reserved.
-------------------------------------------------------------------------------
-- Modification history:
-- 03/15/2007: created.
-- 06/01/2007: Included MGT block instead of using xilinx wrapper.
-- 06/08/2007: CRC blocks now held in reset when link is down.
-- 06/08/2007: Added Lock Bits
-- 08/25/2007: Changed error count signals.
-- 09/18/2007: Added force cell size signal
-- 09/19/2007: Changed force cell size signal to PIC mode signal
-- 09/21/2007: Ack timeout & Pic Mode converted to generics, 
--             Added Generic for reference clock selection and ref clock 2 in
-- 01/25/2008: Added MGT Recovered Clock Output
-- 11/05/2008: Added reset state machine logic.
-------------------------------------------------------------------------------

LIBRARY ieee;
use work.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
-- synopsys translate_off
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
-- synopsys translate_on


entity PgpMgtWrap is 
   generic (
      MgtMode     : string  := "A";       -- Default Location
      AckTimeout  : natural := 8;         -- Ack/Nack Not Received Timeout, 8.192uS Steps
      PicMode     : natural := 1;         -- PIC Interface Mode, 1=PIC, 0=Normal
      RefClkSel   : string  := "REFCLK1"; -- Reference Clock To Use "REFCLK1" or "REFCLK2"
      CScopeEnPhy : string  := "DISABLE"  -- Insert ChipScope, Enable or Disable
   );
   port (

      -- System clock, reset & control
      pgpClk            : in  std_logic;                     -- 125Mhz master clock
      pgpReset          : in  std_logic;                     -- Synchronous reset input
      pibReLink         : in  std_logic;                     -- Re-Link control signal

      -- Frame Transmit Interface, VC 0
      vc0FrameTxValid   : in  std_logic;                     -- User frame data is valid
      vc0FrameTxReady   : out std_logic;                     -- PGP is ready
      vc0FrameTxSOF     : in  std_logic;                     -- User frame data start of frame
      vc0FrameTxWidth   : in  std_logic;                     -- User frame data width
      vc0FrameTxEOF     : in  std_logic;                     -- User frame data end of frame
      vc0FrameTxEOFE    : in  std_logic;                     -- User frame data error
      vc0FrameTxData    : in  std_logic_vector(15 downto 0); -- User frame data
      vc0FrameTxCid     : in  std_logic_vector(31 downto 0); -- User frame data, context ID
      vc0FrameTxAckCid  : out std_logic_vector(31 downto 0); -- PGP ACK/NACK context ID
      vc0FrameTxAckEn   : out std_logic;                     -- PGP ACK/NACK enable
      vc0FrameTxAck     : out std_logic;                     -- PGP ACK/NACK
      vc0RemBuffAFull   : out std_logic;                     -- Remote buffer almost full
      vc0RemBuffFull    : out std_logic;                     -- Remote buffer full

      -- Frame Transmit Interface, VC 1
      vc1FrameTxValid   : in  std_logic;                     -- User frame data is valid
      vc1FrameTxReady   : out std_logic;                     -- PGP is ready
      vc1FrameTxSOF     : in  std_logic;                     -- User frame data start of frame
      vc1FrameTxWidth   : in  std_logic;                     -- User frame data width
      vc1FrameTxEOF     : in  std_logic;                     -- User frame data end of frame
      vc1FrameTxEOFE    : in  std_logic;                     -- User frame data error
      vc1FrameTxData    : in  std_logic_vector(15 downto 0); -- User frame data
      vc1FrameTxCid     : in  std_logic_vector(31 downto 0); -- User frame data, context ID
      vc1FrameTxAckCid  : out std_logic_vector(31 downto 0); -- PGP ACK/NACK context ID
      vc1FrameTxAckEn   : out std_logic;                     -- PGP ACK/NACK enable
      vc1FrameTxAck     : out std_logic;                     -- PGP ACK/NACK
      vc1RemBuffAFull   : out std_logic;                     -- Remote buffer almost full
      vc1RemBuffFull    : out std_logic;                     -- Remote buffer full

      -- Frame Transmit Interface, VC 2
      vc2FrameTxValid   : in  std_logic;                     -- User frame data is valid
      vc2FrameTxReady   : out std_logic;                     -- PGP is ready
      vc2FrameTxSOF     : in  std_logic;                     -- User frame data start of frame
      vc2FrameTxWidth   : in  std_logic;                     -- User frame data width
      vc2FrameTxEOF     : in  std_logic;                     -- User frame data end of frame
      vc2FrameTxEOFE    : in  std_logic;                     -- User frame data error
      vc2FrameTxData    : in  std_logic_vector(15 downto 0); -- User frame data
      vc2FrameTxCid     : in  std_logic_vector(31 downto 0); -- User frame data, context ID
      vc2FrameTxAckCid  : out std_logic_vector(31 downto 0); -- PGP ACK/NACK context ID
      vc2FrameTxAckEn   : out std_logic;                     -- PGP ACK/NACK enable
      vc2FrameTxAck     : out std_logic;                     -- PGP ACK/NACK
      vc2RemBuffAFull   : out std_logic;                     -- Remote buffer almost full
      vc2RemBuffFull    : out std_logic;                     -- Remote buffer full

      -- Frame Transmit Interface, VC 3
      vc3FrameTxValid   : in  std_logic;                     -- User frame data is valid
      vc3FrameTxReady   : out std_logic;                     -- PGP is ready
      vc3FrameTxSOF     : in  std_logic;                     -- User frame data start of frame
      vc3FrameTxWidth   : in  std_logic;                     -- User frame data width
      vc3FrameTxEOF     : in  std_logic;                     -- User frame data end of frame
      vc3FrameTxEOFE    : in  std_logic;                     -- User frame data error
      vc3FrameTxData    : in  std_logic_vector(15 downto 0); -- User frame data
      vc3FrameTxCid     : in  std_logic_vector(31 downto 0); -- User frame data, context ID
      vc3FrameTxAckCid  : out std_logic_vector(31 downto 0); -- PGP ACK/NACK context ID
      vc3FrameTxAckEn   : out std_logic;                     -- PGP ACK/NACK enable
      vc3FrameTxAck     : out std_logic;                     -- PGP ACK/NACK
      vc3RemBuffAFull   : out std_logic;                     -- Remote buffer almost full
      vc3RemBuffFull    : out std_logic;                     -- Remote buffer full

      -- Frame Receive Interface, VC 0
      vc0FrameRxValid   : out std_logic;                     -- PGP frame data is valid
      vc0FrameRxSOF     : out std_logic;                     -- PGP frame data start of frame
      vc0FrameRxWidth   : out std_logic;                     -- PGP frame data width
      vc0FrameRxEOF     : out std_logic;                     -- PGP frame data end of frame
      vc0FrameRxEOFE    : out std_logic;                     -- PGP frame data error
      vc0FrameRxData    : out std_logic_vector(15 downto 0); -- PGP frame data
      vc0LocBuffAFull   : in  std_logic;                     -- Local buffer almost full
      vc0LocBuffFull    : in  std_logic;                     -- Local buffer full

      -- Frame Receive Interface, VC 1
      vc1FrameRxValid   : out std_logic;                     -- PGP frame data is valid
      vc1FrameRxSOF     : out std_logic;                     -- PGP frame data start of frame
      vc1FrameRxWidth   : out std_logic;                     -- PGP frame data width
      vc1FrameRxEOF     : out std_logic;                     -- PGP frame data end of frame
      vc1FrameRxEOFE    : out std_logic;                     -- PGP frame data error
      vc1FrameRxData    : out std_logic_vector(15 downto 0); -- PGP frame data
      vc1LocBuffAFull   : in  std_logic;                     -- Local buffer almost full
      vc1LocBuffFull    : in  std_logic;                     -- Local buffer full

      -- Frame Receive Interface, VC 2
      vc2FrameRxValid   : out std_logic;                     -- PGP frame data is valid
      vc2FrameRxSOF     : out std_logic;                     -- PGP frame data start of frame
      vc2FrameRxWidth   : out std_logic;                     -- PGP frame data width
      vc2FrameRxEOF     : out std_logic;                     -- PGP frame data end of frame
      vc2FrameRxEOFE    : out std_logic;                     -- PGP frame data error
      vc2FrameRxData    : out std_logic_vector(15 downto 0); -- PGP frame data
      vc2LocBuffAFull   : in  std_logic;                     -- Local buffer almost full
      vc2LocBuffFull    : in  std_logic;                     -- Local buffer full

      -- Frame Receive Interface, VC 3
      vc3FrameRxValid   : out std_logic;                     -- PGP frame data is valid
      vc3FrameRxSOF     : out std_logic;                     -- PGP frame data start of frame
      vc3FrameRxWidth   : out std_logic;                     -- PGP frame data width
      vc3FrameRxEOF     : out std_logic;                     -- PGP frame data end of frame
      vc3FrameRxEOFE    : out std_logic;                     -- PGP frame data error
      vc3FrameRxData    : out std_logic_vector(15 downto 0); -- PGP frame data
      vc3LocBuffAFull   : in  std_logic;                     -- Local buffer almost full
      vc3LocBuffFull    : in  std_logic;                     -- Local buffer full

      -- Event Counters & Status Signals
      localVersion      : out std_logic_vector(7  downto 0); -- Local version ID
      remoteVersion     : out std_logic_vector(7  downto 0); -- Remote version ID
      pibFail           : out std_logic;                     -- PIB fail indication
      pibState          : out std_logic_vector(2  downto 0); -- PIB State
      pibLock           : out std_logic_vector(1  downto 0); -- PIB Lock Bits, 0=Rx, 1=Tx
      pibLinkReady      : out std_logic;                     -- PIB link is ready
      pgpSeqError       : out std_logic;                     -- PGP Sequence Logic Error Occured
      countLinkDown     : out std_logic;                     -- Link down count increment
      countLinkError    : out std_logic;                     -- Disparity/Decode err count
      countNack         : out std_logic;                     -- NACK count increment
      countCellError    : out std_logic;                     -- Receive cell error count

      -- MGT Configuration Port
      mgtDAddr          : in  std_logic_vector( 7 downto 0); -- MGT Configuration Address
      mgtDClk           : in  std_logic;                     -- MGT Configuration Clock
      mgtDEn            : in  std_logic;                     -- MGT Configuration Data Enable
      mgtDI             : in  std_logic_vector(15 downto 0); -- MGT Configuration Data In
      mgtDO             : out std_logic_vector(15 downto 0); -- MGT Configuration Data Out
      mgtDRdy           : out std_logic;                     -- MGT Configuration Ready
      mgtDWe            : in  std_logic;                     -- MGT Configuration Write Enable

      -- MGT Status & Control Signals
      mgtLoopback       : in  std_logic;                     -- MGT Serial Loopback Control
      mgtInverted       : out std_logic;                     -- MGT Received Data Is Inverted

      -- MGT Signals, Drive Ref Clock Which Matches RefClkSel Generic Above
      mgtRefClk1        : in  std_logic;                     -- MGT Reference Clock In 1
      mgtRefClk2        : in  std_logic;                     -- MGT Reference Clock In 2
      mgtRxRecClk       : out std_logic;                     -- MGT Rx Recovered Clock
      mgtRxN            : in  std_logic;                     -- MGT Serial Receive Negative
      mgtRxP            : in  std_logic;                     -- MGT Serial Receive Positive
      mgtTxN            : out std_logic;                     -- MGT Serial Transmit Negative
      mgtTxP            : out std_logic;                     -- MGT Serial Transmit Positive

      -- MGT Signals For Simulation, 
      -- Drive mgtCombusIn to 0's, Leave mgtCombusOut open for real use
      mgtCombusIn       : in  std_logic_vector(15 downto 0);
      mgtCombusOut      : out std_logic_vector(15 downto 0)
   );

end PgpMgtWrap;


-- Define architecture
architecture PgpMgtWrap of PgpMgtWrap is

   -- PGP Core
   component PgpTop
      generic (
         AckTimeout : natural := 8; -- Ack/Nack Not Received Timeout, 8.192uS Steps
         PicMode    : natural := 0  -- PIC Interface Mode, 1=PIC, 0=Normal
      );
      port ( 
         pgpClk            : in  std_logic;
         pgpReset          : in  std_logic;
         pibReLink         : in  std_logic;
         vc0FrameTxValid   : in  std_logic;
         vc0FrameTxReady   : out std_logic;
         vc0FrameTxSOF     : in  std_logic;
         vc0FrameTxWidth   : in  std_logic;
         vc0FrameTxEOF     : in  std_logic;
         vc0FrameTxEOFE    : in  std_logic;
         vc0FrameTxData    : in  std_logic_vector(15 downto 0);
         vc0FrameTxCid     : in  std_logic_vector(31 downto 0);
         vc0FrameTxAckCid  : out std_logic_vector(31 downto 0);
         vc0FrameTxAckEn   : out std_logic;
         vc0FrameTxAck     : out std_logic;
         vc0RemBuffAFull   : out std_logic;
         vc0RemBuffFull    : out std_logic;
         vc1FrameTxValid   : in  std_logic;
         vc1FrameTxReady   : out std_logic;
         vc1FrameTxSOF     : in  std_logic;
         vc1FrameTxWidth   : in  std_logic;
         vc1FrameTxEOF     : in  std_logic;
         vc1FrameTxEOFE    : in  std_logic;
         vc1FrameTxData    : in  std_logic_vector(15 downto 0);
         vc1FrameTxCid     : in  std_logic_vector(31 downto 0);
         vc1FrameTxAckCid  : out std_logic_vector(31 downto 0);
         vc1FrameTxAckEn   : out std_logic;
         vc1FrameTxAck     : out std_logic;
         vc1RemBuffAFull   : out std_logic;
         vc1RemBuffFull    : out std_logic;
         vc2FrameTxValid   : in  std_logic;
         vc2FrameTxReady   : out std_logic;
         vc2FrameTxSOF     : in  std_logic;
         vc2FrameTxWidth   : in  std_logic;
         vc2FrameTxEOF     : in  std_logic;
         vc2FrameTxEOFE    : in  std_logic;
         vc2FrameTxData    : in  std_logic_vector(15 downto 0);
         vc2FrameTxCid     : in  std_logic_vector(31 downto 0);
         vc2FrameTxAckCid  : out std_logic_vector(31 downto 0);
         vc2FrameTxAckEn   : out std_logic;
         vc2FrameTxAck     : out std_logic;
         vc2RemBuffAFull   : out std_logic;
         vc2RemBuffFull    : out std_logic;
         vc3FrameTxValid   : in  std_logic;
         vc3FrameTxReady   : out std_logic;
         vc3FrameTxSOF     : in  std_logic;
         vc3FrameTxWidth   : in  std_logic;
         vc3FrameTxEOF     : in  std_logic;
         vc3FrameTxEOFE    : in  std_logic;
         vc3FrameTxData    : in  std_logic_vector(15 downto 0);
         vc3FrameTxCid     : in  std_logic_vector(31 downto 0);
         vc3FrameTxAckCid  : out std_logic_vector(31 downto 0);
         vc3FrameTxAckEn   : out std_logic;
         vc3FrameTxAck     : out std_logic;
         vc3RemBuffAFull   : out std_logic;
         vc3RemBuffFull    : out std_logic;
         vc0FrameRxValid   : out std_logic;
         vc0FrameRxSOF     : out std_logic;
         vc0FrameRxWidth   : out std_logic;
         vc0FrameRxEOF     : out std_logic;
         vc0FrameRxEOFE    : out std_logic;
         vc0FrameRxData    : out std_logic_vector(15 downto 0);
         vc0LocBuffAFull   : in  std_logic;
         vc0LocBuffFull    : in  std_logic;
         vc1FrameRxValid   : out std_logic;
         vc1FrameRxSOF     : out std_logic;
         vc1FrameRxWidth   : out std_logic;
         vc1FrameRxEOF     : out std_logic;
         vc1FrameRxEOFE    : out std_logic;
         vc1FrameRxData    : out std_logic_vector(15 downto 0);
         vc1LocBuffAFull   : in  std_logic;
         vc1LocBuffFull    : in  std_logic;
         vc2FrameRxValid   : out std_logic;
         vc2FrameRxSOF     : out std_logic;
         vc2FrameRxWidth   : out std_logic;
         vc2FrameRxEOF     : out std_logic;
         vc2FrameRxEOFE    : out std_logic;
         vc2FrameRxData    : out std_logic_vector(15 downto 0);
         vc2LocBuffAFull   : in  std_logic;
         vc2LocBuffFull    : in  std_logic;
         vc3FrameRxValid   : out std_logic;
         vc3FrameRxSOF     : out std_logic;
         vc3FrameRxWidth   : out std_logic;
         vc3FrameRxEOF     : out std_logic;
         vc3FrameRxEOFE    : out std_logic;
         vc3FrameRxData    : out std_logic_vector(15 downto 0);
         vc3LocBuffAFull   : in  std_logic;
         vc3LocBuffFull    : in  std_logic;
         crcTxIn           : out std_logic_vector(15 downto 0);
         crcTxInit         : out std_logic;
         crcTxValid        : out std_logic;
         crcTxWidth        : out std_logic;
         crcTxOut          : in  std_logic_vector(31 downto 0);
         crcRxIn           : out std_logic_vector(15 downto 0);
         crcRxInit         : out std_logic;
         crcRxValid        : out std_logic;
         crcRxWidth        : out std_logic;
         crcRxOut          : in  std_logic_vector(31 downto 0);
         phyRxPolarity     : out std_logic;
         phyRxData         : in  std_logic_vector(15 downto 0);
         phyRxDataK        : in  std_logic_vector(1  downto 0);
         phyTxData         : out std_logic_vector(15 downto 0);
         phyTxDataK        : out std_logic_vector(1  downto 0);
         phyLinkError      : in  std_logic;
         phyInitDone       : in  std_logic;
         localVersion      : out std_logic_vector(7  downto 0);
         remoteVersion     : out std_logic_vector(7  downto 0);
         pibFail           : out std_logic;
         pibState          : out std_logic_vector(2  downto 0);
         pibLinkReady      : out std_logic;
         pgpSeqError       : out std_logic;
         countLinkError    : out std_logic;
         countLinkDown     : out std_logic;
         countNack         : out std_logic;
         countCellError    : out std_logic 
      );
   end component;


   -- MGT Block
   component 
      GT11 generic ( 
         ALIGN_COMMA_WORD        : integer    :=  1;
         BANDGAPSEL              : boolean    :=  FALSE;
         BIASRESSEL              : boolean    :=  TRUE;
         CCCB_ARBITRATOR_DISABLE : boolean    :=  FALSE;
         CHAN_BOND_LIMIT         : integer    :=  16;
         CHAN_BOND_MODE          : string     :=  "NONE";
         CHAN_BOND_ONE_SHOT      : boolean    :=  FALSE;
         CHAN_BOND_SEQ_1_1       : bit_vector :=  "00000000000";
         CHAN_BOND_SEQ_1_2       : bit_vector :=  "00000000000";
         CHAN_BOND_SEQ_1_3       : bit_vector :=  "00000000000";
         CHAN_BOND_SEQ_1_4       : bit_vector :=  "00000000000";
         CHAN_BOND_SEQ_1_MASK    : bit_vector :=  "0000";
         CHAN_BOND_SEQ_2_1       : bit_vector :=  "00000000000";
         CHAN_BOND_SEQ_2_2       : bit_vector :=  "00000000000";
         CHAN_BOND_SEQ_2_3       : bit_vector :=  "00000000000";
         CHAN_BOND_SEQ_2_4       : bit_vector :=  "00000000000";
         CHAN_BOND_SEQ_2_MASK    : bit_vector :=  "0000";
         CHAN_BOND_SEQ_2_USE     : boolean    :=  FALSE;
         CHAN_BOND_SEQ_LEN       : integer    :=  1;
         CLK_COR_8B10B_DE        : boolean    :=  FALSE;
         CLK_COR_MAX_LAT         : integer    :=  48;
         CLK_COR_MIN_LAT         : integer    :=  36;
         CLK_COR_SEQ_1_1         : bit_vector :=  "00000000000";
         CLK_COR_SEQ_1_2         : bit_vector :=  "00000000000";
         CLK_COR_SEQ_1_3         : bit_vector :=  "00000000000";
         CLK_COR_SEQ_1_4         : bit_vector :=  "00000000000";
         CLK_COR_SEQ_1_MASK      : bit_vector :=  "0000";
         CLK_COR_SEQ_2_1         : bit_vector :=  "00000000000";
         CLK_COR_SEQ_2_2         : bit_vector :=  "00000000000";
         CLK_COR_SEQ_2_3         : bit_vector :=  "00000000000";
         CLK_COR_SEQ_2_4         : bit_vector :=  "00000000000";
         CLK_COR_SEQ_2_MASK      : bit_vector :=  "0000";
         CLK_COR_SEQ_2_USE       : boolean    :=  FALSE;
         CLK_COR_SEQ_DROP        : boolean    :=  FALSE;
         CLK_COR_SEQ_LEN         : integer    :=  1;
         CLK_CORRECT_USE         : boolean    :=  TRUE;
         COMMA_10B_MASK          : bit_vector :=  x"3FF";
         COMMA32                 : boolean    :=  FALSE;
         CYCLE_LIMIT_SEL         : bit_vector :=  "00";
         DCDR_FILTER             : bit_vector :=  "010";
         DEC_MCOMMA_DETECT       : boolean    :=  TRUE;
         DEC_PCOMMA_DETECT       : boolean    :=  TRUE;
         DEC_VALID_COMMA_ONLY    : boolean    :=  TRUE;
         DIGRX_FWDCLK            : bit_vector :=  "00";
         DIGRX_SYNC_MODE         : boolean    :=  FALSE;
         ENABLE_DCDR             : boolean    :=  FALSE;
         FDET_HYS_CAL            : bit_vector :=  "110";
         FDET_HYS_SEL            : bit_vector :=  "110";
         FDET_LCK_CAL            : bit_vector :=  "101";
         FDET_LCK_SEL            : bit_vector :=  "101";
         GT11_MODE               : string     :=  "DONT_CARE";
         IREFBIASMODE            : bit_vector :=  "11";
         LOOPCAL_WAIT            : bit_vector :=  "00";
         MCOMMA_32B_VALUE        : bit_vector :=  x"000000F6";
         MCOMMA_DETECT           : boolean    :=  TRUE;
         OPPOSITE_SELECT         : boolean    :=  FALSE;
         PCOMMA_32B_VALUE        : bit_vector :=  x"F6F62828";
         PCOMMA_DETECT           : boolean    :=  TRUE;
         PCS_BIT_SLIP            : boolean    :=  FALSE;
         PMA_BIT_SLIP            : boolean    :=  FALSE;
         PMACLKENABLE            : boolean    :=  TRUE;
         PMACOREPWRENABLE        : boolean    :=  TRUE;
         PMAIREFTRIM             : bit_vector :=  "0111";
         PMAVBGCTRL              : bit_vector :=  "00000";
         PMAVREFTRIM             : bit_vector :=  "0111";
         POWER_ENABLE            : boolean    :=  TRUE;
         REPEATER                : boolean    :=  FALSE;
         RX_BUFFER_USE           : boolean    :=  TRUE;
         RX_CLOCK_DIVIDER        : bit_vector :=  "00";
         RXACTST                 : boolean    :=  FALSE;
         RXAFEEQ                 : bit_vector :=  "000000000";
         RXAFEPD                 : boolean    :=  FALSE;
         RXAFETST                : boolean    :=  FALSE;
         RXAPD                   : boolean    :=  FALSE;
         RXASYNCDIVIDE           : bit_vector :=  "11";
         RXBY_32                 : boolean    :=  TRUE;
         RXCDRLOS                : bit_vector :=  "000000";
         RXCLK0_FORCE_PMACLK     : boolean    :=  FALSE;
         RXCLKMODE               : bit_vector :=  "000010";
         RXCMADJ                 : bit_vector :=  "10";
         RXCPSEL                 : boolean    :=  TRUE;
         RXCPTST                 : boolean    :=  FALSE;
         RXCRCCLOCKDOUBLE        : boolean    :=  FALSE;
         RXCRCENABLE             : boolean    :=  FALSE;
         RXCRCINITVAL            : bit_vector :=  x"00000000";
         RXCRCINVERTGEN          : boolean    :=  FALSE;
         RXCRCSAMECLOCK          : boolean    :=  FALSE;
         RXCTRL1                 : bit_vector :=  x"200";
         RXCYCLE_LIMIT_SEL       : bit_vector :=  "00";
         RXDATA_SEL              : bit_vector :=  "00";
         RXDCCOUPLE              : boolean    :=  FALSE;
         RXDIGRESET              : boolean    :=  FALSE;
         RXDIGRX                 : boolean    :=  FALSE;
         RXEQ                    : bit_vector :=  x"4000000000000000";
         RXFDCAL_CLOCK_DIVIDE    : string     :=  "NONE";
         RXFDET_HYS_CAL          : bit_vector :=  "110";
         RXFDET_HYS_SEL          : bit_vector :=  "110";
         RXFDET_LCK_CAL          : bit_vector :=  "101";
         RXFDET_LCK_SEL          : bit_vector :=  "101";
         RXFECONTROL1            : bit_vector :=  "00";
         RXFECONTROL2            : bit_vector :=  "000";
         RXFETUNE                : bit_vector :=  "01";
         RXLB                    : boolean    :=  FALSE;
         RXLKADJ                 : bit_vector :=  "00000";
         RXLKAPD                 : boolean    :=  FALSE;
         RXLOOPCAL_WAIT          : bit_vector :=  "00";
         RXLOOPFILT              : bit_vector :=  "0111";
         RXOUTDIV2SEL            : integer    :=  1;
         RXPD                    : boolean    :=  FALSE;
         RXPDDTST                : boolean    :=  FALSE;
         RXPLLNDIVSEL            : integer    :=  8;
         RXPMACLKSEL             : string     :=  "REFCLK1";
         RXRCPADJ                : bit_vector :=  "011";
         RXRCPPD                 : boolean    :=  FALSE;
         RXRECCLK1_USE_SYNC      : boolean    :=  FALSE;
         RXRIBADJ                : bit_vector :=  "11";
         RXRPDPD                 : boolean    :=  FALSE;
         RXRSDPD                 : boolean    :=  FALSE;
         RXSLOWDOWN_CAL          : bit_vector :=  "00";
         RXUSRDIVISOR            : integer    :=  1;
         RXVCO_CTRL_ENABLE       : boolean    :=  TRUE;
         RXVCODAC_INIT           : bit_vector :=  "1010000000";
         SAMPLE_8X               : boolean    :=  FALSE;
         SH_CNT_MAX              : integer    :=  64;
         SH_INVALID_CNT_MAX      : integer    :=  16;
         SLOWDOWN_CAL            : bit_vector :=  "00";
         TX_BUFFER_USE           : boolean    :=  TRUE;
         TX_CLOCK_DIVIDER        : bit_vector :=  "00";
         TXABPMACLKSEL           : string     :=  "REFCLK1";
         TXAPD                   : boolean    :=  FALSE;
         TXAREFBIASSEL           : boolean    :=  FALSE;
         TXASYNCDIVIDE           : bit_vector :=  "11";
         TXCLK0_FORCE_PMACLK     : boolean    :=  FALSE;
         TXCLKMODE               : bit_vector :=  "1001";
         TXCPSEL                 : boolean    :=  TRUE;
         TXCRCCLOCKDOUBLE        : boolean    :=  FALSE;
         TXCRCENABLE             : boolean    :=  FALSE;
         TXCRCINITVAL            : bit_vector :=  x"00000000";
         TXCRCINVERTGEN          : boolean    :=  FALSE;
         TXCRCSAMECLOCK          : boolean    :=  FALSE;
         TXCTRL1                 : bit_vector :=  x"200";
         TXDAT_PRDRV_DAC         : bit_vector :=  "111";
         TXDAT_TAP_DAC           : bit_vector :=  "10110";
         TXDATA_SEL              : bit_vector :=  "00";
         TXDIGPD                 : boolean    :=  FALSE;
         TXFDCAL_CLOCK_DIVIDE    : string     :=  "NONE";
         TXHIGHSIGNALEN          : boolean    :=  TRUE;
         TXLOOPFILT              : bit_vector :=  "0111";
         TXLVLSHFTPD             : boolean    :=  FALSE;
         TXOUTCLK1_USE_SYNC      : boolean    :=  FALSE;
         TXOUTDIV2SEL            : integer    :=  1;
         TXPD                    : boolean    :=  FALSE;
         TXPHASESEL              : boolean    :=  FALSE;
         TXPLLNDIVSEL            : integer    :=  8;
         TXPOST_PRDRV_DAC        : bit_vector :=  "111";
         TXPOST_TAP_DAC          : bit_vector :=  "01110";
         TXPOST_TAP_PD           : boolean    :=  TRUE;
         TXPRE_PRDRV_DAC         : bit_vector :=  "111";
         TXPRE_TAP_DAC           : bit_vector :=  "00000";
         TXPRE_TAP_PD            : boolean    :=  TRUE;
         TXSLEWRATE              : boolean    :=  FALSE;
         TXTERMTRIM              : bit_vector :=  "1100";
         VCO_CTRL_ENABLE         : boolean    :=  TRUE;
         VCODAC_INIT             : bit_vector :=  "1010000000";
         VREFBIASMODE            : bit_vector :=  "11"
      );
      port (   
         CHBONDI                 : in    std_logic_vector (4 downto 0); 
         ENCHANSYNC              : in    std_logic; 
         ENMCOMMAALIGN           : in    std_logic; 
         ENPCOMMAALIGN           : in    std_logic; 
         LOOPBACK                : in    std_logic_vector (1 downto 0); 
         POWERDOWN               : in    std_logic; 
         RXBLOCKSYNC64B66BUSE    : in    std_logic; 
         RXCOMMADETUSE           : in    std_logic; 
         RXDATAWIDTH             : in    std_logic_vector (1 downto 0); 
         RXDEC64B66BUSE          : in    std_logic; 
         RXDEC8B10BUSE           : in    std_logic; 
         RXDESCRAM64B66BUSE      : in    std_logic; 
         RXIGNOREBTF             : in    std_logic; 
         RXINTDATAWIDTH          : in    std_logic_vector (1 downto 0); 
         RXPOLARITY              : in    std_logic; 
         RXRESET                 : in    std_logic; 
         RXSLIDE                 : in    std_logic; 
         RXUSRCLK                : in    std_logic; 
         RXUSRCLK2               : in    std_logic; 
         TXBYPASS8B10B           : in    std_logic_vector (7 downto 0); 
         TXCHARDISPMODE          : in    std_logic_vector (7 downto 0); 
         TXCHARDISPVAL           : in    std_logic_vector (7 downto 0); 
         TXCHARISK               : in    std_logic_vector (7 downto 0); 
         TXDATA                  : in    std_logic_vector (63 downto 0); 
         TXDATAWIDTH             : in    std_logic_vector (1 downto 0); 
         TXENC64B66BUSE          : in    std_logic; 
         TXENC8B10BUSE           : in    std_logic; 
         TXGEARBOX64B66BUSE      : in    std_logic; 
         TXINHIBIT               : in    std_logic; 
         TXINTDATAWIDTH          : in    std_logic_vector (1 downto 0); 
         TXPOLARITY              : in    std_logic; 
         TXRESET                 : in    std_logic; 
         TXSCRAM64B66BUSE        : in    std_logic; 
         TXUSRCLK                : in    std_logic; 
         TXUSRCLK2               : in    std_logic; 
         RXCLKSTABLE             : in    std_logic; 
         RXPMARESET              : in    std_logic; 
         TXCLKSTABLE             : in    std_logic; 
         TXPMARESET              : in    std_logic; 
         RXCRCIN                 : in    std_logic_vector (63 downto 0); 
         RXCRCDATAWIDTH          : in    std_logic_vector (2 downto 0); 
         RXCRCDATAVALID          : in    std_logic; 
         RXCRCINIT               : in    std_logic; 
         RXCRCRESET              : in    std_logic; 
         RXCRCPD                 : in    std_logic; 
         RXCRCCLK                : in    std_logic; 
         RXCRCINTCLK             : in    std_logic; 
         TXCRCIN                 : in    std_logic_vector (63 downto 0); 
         TXCRCDATAWIDTH          : in    std_logic_vector (2 downto 0); 
         TXCRCDATAVALID          : in    std_logic; 
         TXCRCINIT               : in    std_logic; 
         TXCRCRESET              : in    std_logic; 
         TXCRCPD                 : in    std_logic; 
         TXCRCCLK                : in    std_logic; 
         TXCRCINTCLK             : in    std_logic; 
         TXSYNC                  : in    std_logic; 
         RXSYNC                  : in    std_logic; 
         TXENOOB                 : in    std_logic; 
         DCLK                    : in    std_logic; 
         DADDR                   : in    std_logic_vector (7 downto 0); 
         DEN                     : in    std_logic; 
         DWE                     : in    std_logic; 
         DI                      : in    std_logic_vector (15 downto 0); 
         RX1P                    : in    std_logic; 
         RX1N                    : in    std_logic; 
         GREFCLK                 : in    std_logic; 
         REFCLK1                 : in    std_logic; 
         REFCLK2                 : in    std_logic; 
         CHBONDO                 : out   std_logic_vector (4 downto 0); 
         RXSTATUS                : out   std_logic_vector (5 downto 0); 
         RXCHARISCOMMA           : out   std_logic_vector (7 downto 0); 
         RXCHARISK               : out   std_logic_vector (7 downto 0); 
         RXCOMMADET              : out   std_logic; 
         RXDATA                  : out   std_logic_vector (63 downto 0); 
         RXDISPERR               : out   std_logic_vector (7 downto 0); 
         RXLOSSOFSYNC            : out   std_logic_vector (1 downto 0); 
         RXNOTINTABLE            : out   std_logic_vector (7 downto 0); 
         RXREALIGN               : out   std_logic; 
         RXRUNDISP               : out   std_logic_vector (7 downto 0); 
         RXBUFERR                : out   std_logic; 
         TXBUFERR                : out   std_logic; 
         TXKERR                  : out   std_logic_vector (7 downto 0); 
         TXRUNDISP               : out   std_logic_vector (7 downto 0); 
         RXRECCLK1               : out   std_logic; 
         RXRECCLK2               : out   std_logic; 
         TXOUTCLK1               : out   std_logic; 
         TXOUTCLK2               : out   std_logic; 
         RXLOCK                  : out   std_logic; 
         TXLOCK                  : out   std_logic; 
         RXCYCLELIMIT            : out   std_logic; 
         TXCYCLELIMIT            : out   std_logic; 
         RXCALFAIL               : out   std_logic; 
         TXCALFAIL               : out   std_logic; 
         RXCRCOUT                : out   std_logic_vector (31 downto 0); 
         TXCRCOUT                : out   std_logic_vector (31 downto 0); 
         RXSIGDET                : out   std_logic; 
         DRDY                    : out   std_logic; 
         DO                      : out   std_logic_vector (15 downto 0); 
         RXMCLK                  : out   std_logic; 
         TX1P                    : out   std_logic; 
         TX1N                    : out   std_logic; 
         TXPCSHCLKOUT            : out   std_logic; 
         RXPCSHCLKOUT            : out   std_logic; 
         COMBUSIN                : in    std_logic_vector (15 downto 0); 
         COMBUSOUT               : out   std_logic_vector (15 downto 0)
      );
   end component;              


   -- Local Signals
   signal crcTxIn           : std_logic_vector(15 downto 0);
   signal crcTxInMgt        : std_logic_vector(63 downto 0);
   signal crcTxInit         : std_logic;
   signal crcTxValid        : std_logic;
   signal crcTxWidth        : std_logic;
   signal crcTxWidthMgt     : std_logic_vector(2  downto 0);
   signal crcTxOut          : std_logic_vector(31 downto 0);
   signal crcRxIn           : std_logic_vector(15 downto 0);
   signal crcRxInMgt        : std_logic_vector(63 downto 0);
   signal crcRxInit         : std_logic;
   signal crcRxValid        : std_logic;
   signal crcRxWidth        : std_logic;
   signal crcRxWidthMgt     : std_logic_vector(2  downto 0);
   signal crcRxOut          : std_logic_vector(31 downto 0);
   signal phyRxPolarity     : std_logic;
   signal phyRxData         : std_logic_vector(15 downto 0);
   signal phyRxDataK        : std_logic_vector(1  downto 0);
   signal phyTxData         : std_logic_vector(15 downto 0);
   signal phyTxDataK        : std_logic_vector(1  downto 0);
   signal mgtRxPmaReset     : std_logic;
   signal mgtTxPmaReset     : std_logic;
   signal mgtRxReset        : std_logic;
   signal mgtTxReset        : std_logic;
   signal mgtRxBuffError    : std_logic;
   signal mgtTxBuffError    : std_logic;
   signal mgtRxDispErr      : std_logic_vector(1  downto 0);
   signal mgtRxDecErr       : std_logic_vector(1  downto 0);
   signal mgtRxLock         : std_logic;
   signal mgtTxLock         : std_logic;
   signal crcRxReset        : std_logic;
   signal crcTxReset        : std_logic;
   signal txPcsResetCnt     : std_logic_vector(3 downto 0);
   signal txPcsResetCntRst  : std_logic;
   signal txPcsResetCntEn   : std_logic;
   signal txStateCnt        : std_logic_vector(5 downto 0);
   signal txStateCntRst     : std_logic;
   signal rxPcsResetCnt     : std_logic_vector(3 downto 0);
   signal rxPcsResetCntRst  : std_logic;
   signal rxPcsResetCntEn   : std_logic;
   signal rxStateCnt        : std_logic_vector(13 downto 0);
   signal rxStateCntRst     : std_logic;
   signal intRxPmaReset     : std_logic;
   signal intTxPmaReset     : std_logic;
   signal intRxReset        : std_logic;
   signal intTxReset        : std_logic;
   signal txClockReady      : std_logic;
   signal rxClockReady      : std_logic;
   signal intLinkReady      : std_logic;
   signal phyLinkError      : std_logic;
   signal phyInitDone       : std_logic;

   -- RX Reset State Machine
   constant RX_SYSTEM_RESET : std_logic_vector(2 downto 0) := "000";
   constant RX_PMA_RESET    : std_logic_vector(2 downto 0) := "001";
   constant RX_WAIT_LOCK    : std_logic_vector(2 downto 0) := "010";
   constant RX_PCS_RESET    : std_logic_vector(2 downto 0) := "011";
   constant RX_WAIT_PCS     : std_logic_vector(2 downto 0) := "100";
   constant RX_ALMOST_READY : std_logic_vector(2 downto 0) := "101";
   constant RX_READY        : std_logic_vector(2 downto 0) := "110";
   signal   curRxState      : std_logic_vector(2 downto 0);
   signal   nxtRxState      : std_logic_vector(2 downto 0);

   -- TX Reset State Machine
   constant TX_SYSTEM_RESET : std_logic_vector(2 downto 0) := "000";
   constant TX_PMA_RESET    : std_logic_vector(2 downto 0) := "001";
   constant TX_WAIT_LOCK    : std_logic_vector(2 downto 0) := "010";
   constant TX_PCS_RESET    : std_logic_vector(2 downto 0) := "011";
   constant TX_WAIT_PCS     : std_logic_vector(2 downto 0) := "100";
   constant TX_ALMOST_READY : std_logic_vector(2 downto 0) := "101";
   constant TX_READY        : std_logic_vector(2 downto 0) := "110";
   signal   curTxState      : std_logic_vector(2 downto 0);
   signal   nxtTxState      : std_logic_vector(2 downto 0);

   -- Black Box Attributes
   attribute syn_black_box : boolean;
   attribute syn_noprune   : boolean;
   attribute syn_black_box of GT11 : component is TRUE;
   attribute syn_noprune   of GT11 : component is TRUE;

   -- Register delay for simulation
   constant tpd:time := 0.5 ns;

begin

   -- Pgp
   U_PgpTop: PgpTop 
      generic map (AckTimeout  => AckTimeout, 
                   PicMode     => PicMode ) port map (
      pgpClk            => pgpClk,
      pgpReset          => pgpReset,
      pibReLink         => pibReLink,          
      vc0FrameTxValid   => vc0FrameTxValid,    vc0FrameTxReady   => vc0FrameTxReady,
      vc0FrameTxSOF     => vc0FrameTxSOF,      vc0FrameTxWidth   => vc0FrameTxWidth,
      vc0FrameTxEOF     => vc0FrameTxEOF,      vc0FrameTxEOFE    => vc0FrameTxEOFE,
      vc0FrameTxData    => vc0FrameTxData,     vc0FrameTxCid     => vc0FrameTxCid,
      vc0FrameTxAckCid  => vc0FrameTxAckCid,   vc0FrameTxAckEn   => vc0FrameTxAckEn,
      vc0FrameTxAck     => vc0FrameTxAck,      vc0RemBuffAFull   => vc0RemBuffAFull,
      vc0RemBuffFull    => vc0RemBuffFull,     vc1FrameTxValid   => vc1FrameTxValid,
      vc1FrameTxReady   => vc1FrameTxReady,    vc1FrameTxSOF     => vc1FrameTxSOF,
      vc1FrameTxWidth   => vc1FrameTxWidth,    vc1FrameTxEOF     => vc1FrameTxEOF,
      vc1FrameTxEOFE    => vc1FrameTxEOFE,     vc1FrameTxData    => vc1FrameTxData,
      vc1FrameTxCid     => vc1FrameTxCid,      vc1FrameTxAckCid  => vc1FrameTxAckCid,
      vc1FrameTxAckEn   => vc1FrameTxAckEn,    vc1FrameTxAck     => vc1FrameTxAck,
      vc1RemBuffAFull   => vc1RemBuffAFull,    vc1RemBuffFull    => vc1RemBuffFull,
      vc2FrameTxValid   => vc2FrameTxValid,    vc2FrameTxReady   => vc2FrameTxReady,
      vc2FrameTxSOF     => vc2FrameTxSOF,      vc2FrameTxWidth   => vc2FrameTxWidth,
      vc2FrameTxEOF     => vc2FrameTxEOF,      vc2FrameTxEOFE    => vc2FrameTxEOFE,
      vc2FrameTxData    => vc2FrameTxData,     vc2FrameTxCid     => vc2FrameTxCid,
      vc2FrameTxAckCid  => vc2FrameTxAckCid,   vc2FrameTxAckEn   => vc2FrameTxAckEn,
      vc2FrameTxAck     => vc2FrameTxAck,      vc2RemBuffAFull   => vc2RemBuffAFull,
      vc2RemBuffFull    => vc2RemBuffFull,     vc3FrameTxValid   => vc3FrameTxValid,
      vc3FrameTxReady   => vc3FrameTxReady,    vc3FrameTxSOF     => vc3FrameTxSOF,
      vc3FrameTxWidth   => vc3FrameTxWidth,    vc3FrameTxEOF     => vc3FrameTxEOF,
      vc3FrameTxEOFE    => vc3FrameTxEOFE,     vc3FrameTxData    => vc3FrameTxData,
      vc3FrameTxCid     => vc3FrameTxCid,      vc3FrameTxAckCid  => vc3FrameTxAckCid,
      vc3FrameTxAckEn   => vc3FrameTxAckEn,    vc3FrameTxAck     => vc3FrameTxAck,
      vc3RemBuffAFull   => vc3RemBuffAFull,    vc3RemBuffFull    => vc3RemBuffFull,
      vc0FrameRxValid   => vc0FrameRxValid,    vc0FrameRxSOF     => vc0FrameRxSOF,
      vc0FrameRxWidth   => vc0FrameRxWidth,    vc0FrameRxEOF     => vc0FrameRxEOF,
      vc0FrameRxEOFE    => vc0FrameRxEOFE,     vc0FrameRxData    => vc0FrameRxData,
      vc0LocBuffAFull   => vc0LocBuffAFull,    vc0LocBuffFull    => vc0LocBuffFull,
      vc1FrameRxValid   => vc1FrameRxValid,    vc1FrameRxSOF     => vc1FrameRxSOF,
      vc1FrameRxWidth   => vc1FrameRxWidth,    vc1FrameRxEOF     => vc1FrameRxEOF,
      vc1FrameRxEOFE    => vc1FrameRxEOFE,     vc1FrameRxData    => vc1FrameRxData,
      vc1LocBuffAFull   => vc1LocBuffAFull,    vc1LocBuffFull    => vc1LocBuffFull,
      vc2FrameRxValid   => vc2FrameRxValid,    vc2FrameRxSOF     => vc2FrameRxSOF,
      vc2FrameRxWidth   => vc2FrameRxWidth,    vc2FrameRxEOF     => vc2FrameRxEOF,
      vc2FrameRxEOFE    => vc2FrameRxEOFE,     vc2FrameRxData    => vc2FrameRxData,
      vc2LocBuffAFull   => vc2LocBuffAFull,    vc2LocBuffFull    => vc2LocBuffFull,
      vc3FrameRxValid   => vc3FrameRxValid,    vc3FrameRxSOF     => vc3FrameRxSOF,
      vc3FrameRxWidth   => vc3FrameRxWidth,    vc3FrameRxEOF     => vc3FrameRxEOF,
      vc3FrameRxEOFE    => vc3FrameRxEOFE,     vc3FrameRxData    => vc3FrameRxData,
      vc3LocBuffAFull   => vc3LocBuffAFull,    vc3LocBuffFull    => vc3LocBuffFull,
      crcTxIn           => crcTxIn,            crcTxInit         => crcTxInit,
      crcTxValid        => crcTxValid,         crcTxWidth        => crcTxWidth,
      crcTxOut          => crcTxOut,           crcRxIn           => crcRxIn,
      crcRxInit         => crcRxInit,          crcRxValid        => crcRxValid,
      crcRxWidth        => crcRxWidth,         crcRxOut          => crcRxOut,
      phyRxPolarity     => phyRxPolarity,      phyRxData         => phyRxData,
      phyRxDataK        => phyRxDataK,         phyTxData         => phyTxData,
      phyTxDataK        => phyTxDataK,         phyLinkError      => phyLinkError,
      phyInitDone       => phyInitDone,        localVersion      => localVersion,
      remoteVersion     => remoteVersion,      pibFail           => pibFail,
      pibState          => pibState,           pibLinkReady      => intLinkReady,
      pgpSeqError       => pgpSeqError,        countLinkDown     => countLinkDown,
      countLinkError    => countLinkError,     countNack         => countNack,
      countCellError    => countCellError
   );


   -- Lock & Polarity Signals
   mgtInverted  <= phyRxPolarity;
   pibLinkReady <= intLinkReady;

   -- Adapt CRC data width flag
   crcTxWidthMgt(2 downto 1) <= "00";
   crcTxWidthMgt(0)          <= crcTxWidth;
   crcRxWidthMgt(2 downto 1) <= "00";
   crcRxWidthMgt(0)          <= crcRxWidth;
   crcRxReset                <= mgtRxReset;
   crcTxReset                <= mgtTxReset;

   -- Pass CRC data in on proper bits
   crcTxInMgt(63 downto 56) <= crcTxIn(7  downto 0);
   crcTxInMgt(55 downto 48) <= crcTxIn(15 downto 8);
   crcTxInMgt(47 downto  0) <= (others=>'0');
   crcRxInMgt(63 downto 56) <= crcRxIn(7  downto 0);
   crcRxInMgt(55 downto 48) <= crcRxIn(15 downto 8);
   crcRxInMgt(47 downto  0) <= (others=>'0');

   
    --------------------------- GT11 Instantiations  ---------------------------   
    U_MGT : GT11
    generic map
    (
    
    ---------- RocketIO MGT 64B66B Block Sync State Machine Attributes --------- 

        SH_CNT_MAX                 =>      64,
        SH_INVALID_CNT_MAX         =>      16,
        
    ----------------------- RocketIO MGT Alignment Atrributes ------------------   

        ALIGN_COMMA_WORD           =>      2,
        COMMA_10B_MASK             =>      x"3ff",
        COMMA32                    =>      FALSE,
        DEC_MCOMMA_DETECT          =>      FALSE,
        DEC_PCOMMA_DETECT          =>      FALSE,
        DEC_VALID_COMMA_ONLY       =>      FALSE,
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
        CHAN_BOND_SEQ_1_MASK       =>      "1110",
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
        CLK_COR_SEQ_1_2            =>      "00100011100",
        CLK_COR_SEQ_1_3            =>      "00100011100",
        CLK_COR_SEQ_1_4            =>      "00100011100",
        CLK_COR_SEQ_1_MASK         =>      "0000",
        CLK_COR_SEQ_2_1            =>      "00000000000",
        CLK_COR_SEQ_2_2            =>      "00000000000",
        CLK_COR_SEQ_2_3            =>      "00000000000",
        CLK_COR_SEQ_2_4            =>      "00000000000",
        CLK_COR_SEQ_2_MASK         =>      "1111",
        CLK_COR_SEQ_2_USE          =>      FALSE,
        CLK_COR_SEQ_DROP           =>      FALSE,
        CLK_COR_SEQ_LEN            =>      4,
        CLK_CORRECT_USE            =>      TRUE,
        
    ---------------------- RocketIO MGT Clocking Atrributes --------------------      
                                        
        RX_CLOCK_DIVIDER           =>      "01",
        RXASYNCDIVIDE              =>      "01",
        RXCLK0_FORCE_PMACLK        =>      TRUE,
        RXCLKMODE                  =>      "000011",
        RXOUTDIV2SEL               =>      2,
        RXPLLNDIVSEL               =>      20,   -- 8=1.25, 16=2.5, 20=3.125
        RXPMACLKSEL                =>      RefClkSel,
        RXRECCLK1_USE_SYNC         =>      FALSE,
        RXUSRDIVISOR               =>      1,
        TX_CLOCK_DIVIDER           =>      "01",
        TXABPMACLKSEL              =>      RefClkSel,
        TXASYNCDIVIDE              =>      "01",
        TXCLK0_FORCE_PMACLK        =>      TRUE,
        TXCLKMODE                  =>      "0100",
        TXOUTCLK1_USE_SYNC         =>      FALSE,
        TXOUTDIV2SEL               =>      2,
        TXPHASESEL                 =>      FALSE, 
        TXPLLNDIVSEL               =>      20,   -- 8=1.25, 16=2.5, 20=3.125

    -------------------------- RocketIO MGT CRC Atrributes ---------------------   

        RXCRCCLOCKDOUBLE           =>      FALSE,
        RXCRCENABLE                =>      TRUE,
        RXCRCINITVAL               =>      x"FFFFFFFF",
        RXCRCINVERTGEN             =>      TRUE,
        RXCRCSAMECLOCK             =>      TRUE,
        TXCRCCLOCKDOUBLE           =>      FALSE,
        TXCRCENABLE                =>      TRUE,
        TXCRCINITVAL               =>      x"FFFFFFFF",
        TXCRCINVERTGEN             =>      TRUE,
        TXCRCSAMECLOCK             =>      TRUE,
        
    --------------------- RocketIO MGT Data Path Atrributes --------------------   
    
        RXDATA_SEL                 =>      "00",
        TXDATA_SEL                 =>      "00",

    ---------------- RocketIO MGT Digital Receiver Attributes ------------------   

        DIGRX_FWDCLK               =>      "01",
        DIGRX_SYNC_MODE            =>      FALSE,
        ENABLE_DCDR                =>      FALSE,
        RXBY_32                    =>      FALSE,
        RXDIGRESET                 =>      FALSE,
        RXDIGRX                    =>      FALSE,
        SAMPLE_8X                  =>      FALSE,
                                        
    ----------------- Rocket IO MGT Miscellaneous Attributes ------------------     

        GT11_MODE                  =>      MgtMode,
        OPPOSITE_SELECT            =>      FALSE,
        PMA_BIT_SLIP               =>      FALSE,
        REPEATER                   =>      FALSE,
        RX_BUFFER_USE              =>      TRUE,
        RXCDRLOS                   =>      "000000",
        RXDCCOUPLE                 =>      TRUE,
        RXFDCAL_CLOCK_DIVIDE       =>      "NONE",
        TX_BUFFER_USE              =>      TRUE,   
        TXFDCAL_CLOCK_DIVIDE       =>      "NONE",
        TXSLEWRATE                 =>      FALSE,

     ----------------- Rocket IO MGT Preemphasis and Equalization --------------
     
        RXAFEEQ                    =>       "000000000",
        RXEQ                       =>       x"4000FF0303030101",
        TXDAT_PRDRV_DAC            =>       "111",
        TXDAT_TAP_DAC              =>       "11011",  -- = TXPOST_TAP_DAC * 4
        TXHIGHSIGNALEN             =>       TRUE,
        TXPOST_PRDRV_DAC           =>       "111",
        TXPOST_TAP_DAC             =>       "00010",
        TXPOST_TAP_PD              =>       FALSE,
        TXPRE_PRDRV_DAC            =>       "111",
        TXPRE_TAP_DAC              =>       "00001",  -- = TXPOST_TAP_DAC / 2     
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
        FDET_HYS_SEL               =>       "001",
        FDET_LCK_CAL               =>       "101",
        FDET_LCK_SEL               =>       "111",
        LOOPCAL_WAIT               =>       "00",
        RXCYCLE_LIMIT_SEL          =>       "00",
        RXFDET_HYS_CAL             =>       "010",
        RXFDET_HYS_SEL             =>       "001",
        RXFDET_LCK_CAL             =>       "101",   
        RXFDET_LCK_SEL             =>       "100",
        RXLOOPCAL_WAIT             =>       "00",
        RXSLOWDOWN_CAL             =>       "00",
        SLOWDOWN_CAL               =>       "00",

     --------------------------- Restricted: PLL Settings ---------------------
     
        PMACLKENABLE               =>       TRUE,
        PMACOREPWRENABLE           =>       TRUE,
        PMAVBGCTRL                 =>       "00000",
        RXACTST                    =>       TRUE,          
        RXAFETST                   =>       TRUE,         
        RXCMADJ                    =>       "10",
        RXCPSEL                    =>       TRUE,
        RXCPTST                    =>       FALSE,
        RXCTRL1                    =>       x"200",
        RXFECONTROL1               =>       "10",  
        RXFECONTROL2               =>       "111",  
        RXFETUNE                   =>       "00", 
        RXLKADJ                    =>       "00000",
        RXLOOPFILT                 =>       "1111",
        RXPDDTST                   =>       FALSE,          
        RXRCPADJ                   =>       "011",   
        RXRIBADJ                   =>       "11",
        RXVCO_CTRL_ENABLE          =>       TRUE,
        RXVCODAC_INIT              =>       "0000101001",
        TXCPSEL                    =>       TRUE,
        TXCTRL1                    =>       x"200",
        TXLOOPFILT                 =>       "0101",   
        VCO_CTRL_ENABLE            =>       TRUE,
        VCODAC_INIT                =>       "0000101001",
        
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
    port map
    (
        ------------------------------- CRC Ports ------------------------------  

        RXCRCCLK                   =>      pgpClk,
        RXCRCDATAVALID             =>      crcRxValid,
        RXCRCDATAWIDTH             =>      crcRxWidthMgt,
        RXCRCIN                    =>      crcRxInMgt,
        RXCRCINIT                  =>      crcRxInit,
        RXCRCINTCLK                =>      pgpClk,
        RXCRCOUT                   =>      crcRxOut,
        RXCRCPD                    =>      '0',
        RXCRCRESET                 =>      crcRxReset,
                                   
        TXCRCCLK                   =>      pgpClk,
        TXCRCDATAVALID             =>      crcTxValid,
        TXCRCDATAWIDTH             =>      crcTxWidthMgt,
        TXCRCIN                    =>      crcTxInMgt,
        TXCRCINIT                  =>      crcTxInit,
        TXCRCINTCLK                =>      pgpClk,
        TXCRCOUT                   =>      crcTxOut,
        TXCRCPD                    =>      '0',
        TXCRCRESET                 =>      crcTxReset,

         ---------------------------- Calibration Ports ------------------------   

        RXCALFAIL                  =>      open,
        RXCYCLELIMIT               =>      open,
        TXCALFAIL                  =>      open,
        TXCYCLELIMIT               =>      open,

        ------------------------------ Serial Ports ----------------------------   

        RX1N                       =>      mgtRxN,
        RX1P                       =>      mgtRxP,
        TX1N                       =>      mgtTxN,
        TX1P                       =>      mgtTxP,

        ------------------------------- PLL Lock -------------------------------   

        RXLOCK                     =>      mgtRxLock,
        TXLOCK                     =>      mgtTxLock,

        -------------------------------- Resets -------------------------------  

        RXPMARESET                 =>      mgtRxPmaReset,
        RXRESET                    =>      mgtRxReset,
        TXPMARESET                 =>      mgtTxPmaReset,
        TXRESET                    =>      mgtTxReset,

        ---------------------------- Synchronization ---------------------------   
                                
        RXSYNC                     =>      '0',
        TXSYNC                     =>      '0',
                                
        ---------------------------- Out of Band Signalling -------------------   

        RXSIGDET                   =>      open,                      
        TXENOOB                    =>      '0',
 
        -------------------------------- Status --------------------------------   

        RXBUFERR                   =>      mgtRxBuffError,
        RXCLKSTABLE                =>      '1',
        RXSTATUS                   =>      open,
        TXBUFERR                   =>      mgtTxBuffError,
        TXCLKSTABLE                =>      '1',
  
        ---------------------------- Polarity Control Ports -------------------- 

        RXPOLARITY                 =>      phyRxPolarity,
        TXINHIBIT                  =>      '0',
        TXPOLARITY                 =>      '0',

        ------------------------------- Channel Bonding Ports ------------------   

        CHBONDI                    =>      (others=>'0'),
        CHBONDO                    =>      open,
        ENCHANSYNC                 =>      '0',
 
        ---------------------------- 64B66B Blocks Use Ports -------------------   

        RXBLOCKSYNC64B66BUSE       =>      '0',
        RXDEC64B66BUSE             =>      '0',
        RXDESCRAM64B66BUSE         =>      '0',
        RXIGNOREBTF                =>      '0',
        TXENC64B66BUSE             =>      '0',
        TXGEARBOX64B66BUSE         =>      '0',
        TXSCRAM64B66BUSE           =>      '0',

        ---------------------------- 8B10B Blocks Use Ports --------------------   

        RXDEC8B10BUSE              =>      '1',
        TXBYPASS8B10B(7 downto 2)  =>      "000000",
        TXBYPASS8B10B(1 downto 0)  =>      "00",
        TXENC8B10BUSE              =>      '1',
                                    
        ------------------------------ Transmit Control Ports ------------------   

        TXCHARDISPMODE(7 downto 0) =>      x"00",
        TXCHARDISPVAL(7 downto 0)  =>      x"00",
        TXCHARISK(7 downto 2)      =>      "000000",
        TXCHARISK(1 downto 0)      =>      phyTxDataK,
        TXKERR(7 downto 0)         =>      open,
        TXRUNDISP(7 downto 0)      =>      open,

        ------------------------------ Receive Control Ports -------------------   

        RXCHARISCOMMA              =>      open, 
        RXCHARISK(7 downto 2)      =>      open,
        RXCHARISK(1 downto 0)      =>      phyRxDataK,
        RXDISPERR(7 downto 2)      =>      open,
        RXDISPERR(1 downto 0)      =>      mgtRxDispErr,
        RXNOTINTABLE(7 downto 2)   =>      open,
        RXNOTINTABLE(1 downto 0)   =>      mgtRxDecErr,
        RXRUNDISP(7 downto 0)      =>      open,

        ------------------------------- Serdes Alignment -----------------------  

        ENMCOMMAALIGN              =>      '1',
        ENPCOMMAALIGN              =>      '1',
        RXCOMMADET                 =>      open,
        RXCOMMADETUSE              =>      '1',
        RXLOSSOFSYNC               =>      open,           
        RXREALIGN                  =>      open,
        RXSLIDE                    =>      '0',

        ----------- Data Width Settings - Internal and fabric interface -------- 

        RXDATAWIDTH                =>      "01",
        RXINTDATAWIDTH             =>      "11",
        TXDATAWIDTH                =>      "01",
        TXINTDATAWIDTH             =>      "11",

        ------------------------------- Data Ports -----------------------------    

        RXDATA(63 downto 16)       =>      open,
        RXDATA(15 downto 0)        =>      phyRxData,
        TXDATA(63 downto 16)       =>      x"000000000000",
        TXDATA(15 downto 0)        =>      phyTxData,

         ------------------------------- User Clocks -----------------------------   

        RXMCLK                     =>      open, 
        RXPCSHCLKOUT               =>      open, 
        RXRECCLK1                  =>      mgtRxRecClk,
        RXRECCLK2                  =>      open,
        RXUSRCLK                   =>      '0',
        RXUSRCLK2                  =>      pgpClk,
        TXOUTCLK1                  =>      open,
        TXOUTCLK2                  =>      open,
        TXPCSHCLKOUT               =>      open,
        TXUSRCLK                   =>      '0',
        TXUSRCLK2                  =>      pgpClk,
   
         ---------------------------- Reference Clocks --------------------------   

        GREFCLK                    =>      '0',
        REFCLK1                    =>      mgtRefClk1,
        REFCLK2                    =>      mgtRefClk2,

        ---------------------------- Powerdown and Loopback Ports --------------  

        LOOPBACK(1)                =>      mgtLoopback,
        LOOPBACK(0)                =>      mgtLoopback,
        POWERDOWN                  =>      '0',

       ------------------- Dynamic Reconfiguration Port (DRP) ------------------
 
        DADDR                      =>      mgtDAddr,
        DCLK                       =>      mgtDClk,
        DEN                        =>      mgtDEn,
        DI                         =>      mgtDI,
        DO                         =>      mgtDO,
        DRDY                       =>      mgtDRdy,
        DWE                        =>      mgtDWe,

           --------------------- MGT Tile Communication Ports ------------------       

        COMBUSIN                   =>      mgtCombusIn,
        COMBUSOUT                  =>      mgtCombusOut
    );


   -- TX & RX State Machine Synchronous Logic
   process ( pgpClk, pgpReset ) begin
      if pgpReset = '1' then
         curTxState    <= TX_SYSTEM_RESET after tpd;
         curRxState    <= RX_SYSTEM_RESET after tpd;
         txPcsResetCnt <= (others=>'0')   after tpd;
         txStateCnt    <= (others=>'0')   after tpd;
         rxPcsResetCnt <= (others=>'0')   after tpd;
         rxStateCnt    <= (others=>'0')   after tpd;
         mgtRxPmaReset <= '1'             after tpd;
         mgtTxPmaReset <= '1'             after tpd;
         mgtRxReset    <= '0'             after tpd;
         mgtTxReset    <= '0'             after tpd;
         phyLinkError  <= '0'             after tpd;
         pibLock       <= (others=>'0')   after tpd;
         phyInitDone   <= '0'             after tpd;
      elsif rising_edge(pgpClk) then

         -- Drive PIB Lock 
         pibLock(0) <= rxClockReady after tpd;
         pibLock(1) <= txClockReady after tpd;

         -- Phy Init Is Done
         phyInitDone <= rxClockReady and txClockReady after tpd;

         -- Error signals, only drive during normal operation
         if mgtRxDecErr /= "00" or mgtRxDispErr /= "00" then
            phyLinkError <= intLinkReady after tpd;
         else
            phyLinkError <= '0' after tpd;
         end if;

         -- Pass on reset signals
         mgtRxPmaReset <= intRxPmaReset after tpd;
         mgtTxPmaReset <= intTxPmaReset after tpd;
         mgtRxReset    <= intRxReset    after tpd;
         mgtTxReset    <= intTxReset    after tpd;

         -- Update state
         if pibReLink = '1' then
            curTxState <= TX_WAIT_LOCK after tpd;
            curRxState <= RX_WAIT_LOCK after tpd;
         else
            curTxState <= nxtTxState after tpd;
            curRxState <= nxtRxState after tpd;
         end if;

         -- Tx State Counter
         if txStateCntRst = '1' or pibReLink = '1' then
            txStateCnt <= (others=>'0') after tpd;
         else
            txStateCnt <= txStateCnt + 1 after tpd;
         end if;

         -- TX Loop Counter
         if txPcsResetCntRst = '1' or pibReLink = '1' then
            txPcsResetCnt <= (others=>'0') after tpd;
         elsif txPcsResetCntEn = '1' then
            txPcsResetCnt <= txPcsResetCnt + 1 after tpd;
         end if;

         -- Rx State Counter
         if rxStateCntRst = '1' or pibReLink = '1' then
            rxStateCnt <= (others=>'0') after tpd;
         else
            rxStateCnt <= rxStateCnt + 1 after tpd;
         end if;

         -- RX Loop Counter
         if rxPcsResetCntRst = '1' or pibReLink = '1' then
            rxPcsResetCnt <= (others=>'0') after tpd;
         elsif rxPcsResetCntEn = '1' then
            rxPcsResetCnt <= rxPcsResetCnt + 1 after tpd;
         end if;
      end if;
   end process;


   -- Async TX State Logic
   process ( curTxState, txStateCnt, mgtTxLock, mgtTxBuffError, txPcsResetCnt ) begin
      case curTxState is 

         -- System Reset State
         when TX_SYSTEM_RESET =>
            txPcsResetCntRst <= '1';
            txPcsResetCntEn  <= '0';
            txStateCntRst    <= '1';
            intTxPmaReset    <= '0';
            intTxReset       <= '0';
            txClockReady     <= '0';
            nxtTxState       <= TX_PMA_RESET;

         -- PMA Reset State
         when TX_PMA_RESET =>
            txPcsResetCntRst <= '0';
            txPcsResetCntEn  <= '0';
            intTxPmaReset    <= '1';
            intTxReset       <= '0';
            txClockReady     <= '0';

            -- Wait for three clocks
            if txStateCnt = 3 then
               nxtTxState    <= TX_WAIT_LOCK;
               txStateCntRst <= '1';
            else
               nxtTxState    <= curTxState;
               txStateCntRst <= '0';
            end if;

         -- Wait for TX Lock
         when TX_WAIT_LOCK =>
            txPcsResetCntRst <= '0';
            txPcsResetCntEn  <= '0';
            intTxPmaReset    <= '0';
            intTxReset       <= '0';
            txStateCntRst    <= '1';
            txClockReady     <= '0';

            -- Wait for three clocks
            if mgtTxLock = '1' then
               nxtTxState <= TX_PCS_RESET;
            else
               nxtTxState <= curTxState;
            end if;
 
         -- Assert PCS Reset
         when TX_PCS_RESET =>
            txPcsResetCntRst <= '0';
            txPcsResetCntEn  <= '0';
            intTxPmaReset    <= '0';
            intTxReset       <= '1';
            txClockReady     <= '0';

            -- Loss of Lock
            if mgtTxLock = '0' then
               nxtTxState    <= TX_WAIT_LOCK;
               txStateCntRst <= '1';

            -- Wait for three clocks
            elsif txStateCnt = 3 then
               nxtTxState    <= TX_WAIT_PCS;
               txStateCntRst <= '1';
            else
               nxtTxState    <= curTxState;
               txStateCntRst <= '0';
            end if;

         -- Wait 5 clocks after PCS reset
         when TX_WAIT_PCS =>
            txPcsResetCntRst <= '0';
            txPcsResetCntEn  <= '0';
            intTxPmaReset    <= '0';
            intTxReset       <= '0';
            txClockReady     <= '0';

            -- Loss of Lock
            if mgtTxLock = '0' then
               nxtTxState    <= TX_WAIT_LOCK;
               txStateCntRst <= '1';

            -- Wait for three clocks
            elsif txStateCnt = 5 then
               nxtTxState    <= TX_ALMOST_READY;
               txStateCntRst <= '1';
            else
               nxtTxState    <= curTxState;
               txStateCntRst <= '0';
            end if;

         -- Almost Ready State
         when TX_ALMOST_READY =>
            intTxPmaReset    <= '0';
            intTxReset       <= '0';
            txClockReady     <= '0';

            -- Loss of Lock
            if mgtTxLock = '0' then
               nxtTxState       <= TX_WAIT_LOCK;
               txStateCntRst    <= '1';
               txPcsResetCntEn  <= '0';
               txPcsResetCntRst <= '0';

            -- TX Buffer Error
            elsif mgtTxBuffError = '1' then
               txStateCntRst   <= '1';
               txPcsResetCntEn <= '1';

               -- 16 Cycles have occured, reset PLL
               if txPcsResetCnt = 15 then
                  nxtTxState       <= TX_PMA_RESET;
                  txPcsResetCntRst <= '1';

               -- Go back to PCS Reset
               else
                  nxtTxState       <= TX_PCS_RESET;
                  txPcsResetCntRst <= '0';
               end if;

            -- Wait for 64 clocks
            elsif txStateCnt = 63 then
               nxtTxState       <= TX_READY;
               txStateCntRst    <= '1';
               txPcsResetCntEn  <= '0';
               txPcsResetCntRst <= '0';
            else
               nxtTxState       <= curTxState;
               txStateCntRst    <= '0';
               txPcsResetCntEn  <= '0';
               txPcsResetCntRst <= '0';
            end if;

         -- Ready State
         when TX_READY =>
            txPcsResetCntRst <= '1';
            txPcsResetCntEn  <= '0';
            intTxPmaReset    <= '0';
            intTxReset       <= '0';
            txStateCntRst    <= '1';
            txClockReady     <= '1';

            -- Loss of Lock
            if mgtTxLock = '0' then
               nxtTxState <= TX_WAIT_LOCK;

            -- Buffer error has occured
            elsif mgtTxBuffError = '1' then
               nxtTxState <= TX_PCS_RESET;
            else
               nxtTxState <= curTxState;
            end if;

         -- Just in case
         when others =>
            txPcsResetCntRst <= '0';
            txPcsResetCntEn  <= '0';
            intTxPmaReset    <= '0';
            intTxReset       <= '0';
            txStateCntRst    <= '0';
            txClockReady     <= '0';
            nxtTxState       <= TX_SYSTEM_RESET;
      end case;
   end process;


   -- Async RX State Logic
   process ( curRxState, rxStateCnt, mgtRxLock, mgtRxBuffError, rxPcsResetCnt ) begin
      case curRxState is 

         -- System Reset State
         when RX_SYSTEM_RESET =>
            rxPcsResetCntRst <= '1';
            rxPcsResetCntEn  <= '0';
            rxStateCntRst    <= '1';
            intRxPmaReset    <= '0';
            intRxReset       <= '0';
            rxClockReady     <= '0';
            nxtRxState       <= RX_PMA_RESET;

         -- PMA Reset State
         when RX_PMA_RESET =>
            rxPcsResetCntRst <= '0';
            rxPcsResetCntEn  <= '0';
            intRxPmaReset    <= '1';
            intRxReset       <= '0';
            rxClockReady     <= '0';

            -- Wait for three clocks
            if rxStateCnt = 3 then
               nxtRxState    <= RX_WAIT_LOCK;
               rxStateCntRst <= '1';
            else
               nxtRxState    <= curRxState;
               rxStateCntRst <= '0';
            end if;

         -- Wait for RX Lock
         when RX_WAIT_LOCK =>
            rxPcsResetCntRst <= '0';
            rxPcsResetCntEn  <= '0';
            intRxPmaReset    <= '0';
            intRxReset       <= '0';
            rxStateCntRst    <= not mgtRxLock;
            rxClockReady     <= '0';

            -- Wait for rx to be locked for 16K clock cycles
            if rxStateCnt = "11111111111111" then
               nxtRxState <= RX_PCS_RESET;
            else
               nxtRxState <= curRxState;
            end if;
 
         -- Assert PCS Reset
         when RX_PCS_RESET =>
            rxPcsResetCntRst <= '0';
            rxPcsResetCntEn  <= '0';
            intRxPmaReset    <= '0';
            intRxReset       <= '1';
            rxClockReady     <= '0';

            -- Loss of Lock
            if mgtRxLock = '0' then
               nxtRxState    <= RX_WAIT_LOCK;
               rxStateCntRst <= '1';

            -- Wait for three clocks
            elsif rxStateCnt = 3 then
               nxtRxState    <= RX_WAIT_PCS;
               rxStateCntRst <= '1';
            else
               nxtRxState    <= curRxState;
               rxStateCntRst <= '0';
            end if;

         -- Wait 5 clocks after PCS reset
         when RX_WAIT_PCS =>
            rxPcsResetCntRst <= '0';
            rxPcsResetCntEn  <= '0';
            intRxPmaReset    <= '0';
            intRxReset       <= '0';
            rxClockReady     <= '0';

            -- Loss of Lock
            if mgtRxLock = '0' then
               nxtRxState    <= RX_WAIT_LOCK;
               rxStateCntRst <= '1';

            -- Wait for five clocks
            elsif rxStateCnt = 5 then
               nxtRxState    <= RX_ALMOST_READY;
               rxStateCntRst <= '1';
            else
               nxtRxState    <= curRxState;
               rxStateCntRst <= '0';
            end if;

         -- Almost Ready State
         when RX_ALMOST_READY =>
            intRxPmaReset    <= '0';
            intRxReset       <= '0';
            rxClockReady     <= '0';

            -- Loss of Lock
            if mgtRxLock = '0' then
               nxtRxState       <= RX_WAIT_LOCK;
               rxStateCntRst    <= '1';
               rxPcsResetCntEn  <= '0';
               rxPcsResetCntRst <= '0';

            -- RX Buffer Error
            elsif mgtRxBuffError = '1' then
               rxStateCntRst   <= '1';
               rxPcsResetCntEn <= '1';

               -- 16 Cycles have occured, reset PLL
               if rxPcsResetCnt = 15 then
                  nxtRxState       <= RX_PMA_RESET;
                  rxPcsResetCntRst <= '1';

               -- Go back to PCS Reset
               else
                  nxtRxState       <= RX_PCS_RESET;
                  rxPcsResetCntRst <= '0';
               end if;

            -- Wait for 64 clocks
            elsif rxStateCnt = 63 then
               nxtRxState       <= RX_READY;
               rxStateCntRst    <= '1';
               rxPcsResetCntEn  <= '0';
               rxPcsResetCntRst <= '0';
            else
               nxtRxState       <= curRxState;
               rxStateCntRst    <= '0';
               rxPcsResetCntEn  <= '0';
               rxPcsResetCntRst <= '0';
            end if;

         -- Ready State
         when RX_READY =>
            rxPcsResetCntRst <= '1';
            rxPcsResetCntEn  <= '0';
            intRxPmaReset    <= '0';
            intRxReset       <= '0';
            rxStateCntRst    <= '1';
            rxClockReady     <= '1';

            -- Loss of Lock
            if mgtRxLock = '0' then
               nxtRxState <= RX_WAIT_LOCK;

            -- Buffer error has occured
            elsif mgtRxBuffError = '1' then
               nxtRxState <= RX_PCS_RESET;
            else
               nxtRxState <= curRxState;
            end if;

         -- Just in case
         when others =>
            rxPcsResetCntRst <= '0';
            rxPcsResetCntEn  <= '0';
            intRxPmaReset    <= '0';
            intRxReset       <= '0';
            rxStateCntRst    <= '0';
            rxClockReady     <= '0';
            nxtRxState       <= RX_SYSTEM_RESET;
      end case;
   end process;

end PgpMgtWrap;

