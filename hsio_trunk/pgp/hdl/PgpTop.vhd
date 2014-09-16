-------------------------------------------------------------------------------
-- Title         : Pretty Good Protocol, Top Level Module
-- Project       : General Purpose Core
-------------------------------------------------------------------------------
-- File          : PgpTop.vhd
-- Author        : Ryan Herbst, rherbst@slac.stanford.edu
-- Created       : 10/24/2006
-------------------------------------------------------------------------------
-- Description:
-- Top level VHDL source file for Pretty Good Protocol core. 
-------------------------------------------------------------------------------
-- Copyright (c) 2006 by Ryan Herbst. All rights reserved.
-------------------------------------------------------------------------------
-- Modification history:
-- 10/24/2006: created.
-- 04/18/2007: Added support to track the number of cells in a frame to detect
--             dropped cells.
-- 04/19/2007: Added link ready flag to cell receiver
-- 05/30/2007: Added lock bits and inverted flag outputs.
-- 05/31/2007: Removed lock bits
-- 06/08/2007: Added lock bits
-- 06/19/2007: Removed PgpRandData, PpgAckTx, PgpErrorCount blocks
-- 07/19/2007: Removed cellTxCount
-- 08/25/2007: Changed error count signals.
-- 09/18/2007: Added forceCellSize signal to make sure all outgoing cells are
--             512 bytes unless they are the last in a frame.
-- 09/19/2007: Changed force cell size signal to PIC mode signal
-- 09/21/2007: Ack timeout & Pic Mode converted to generics.
-- 09/21/2007: Removed payload imput
-- 11/06/2007: Added cellRxShort flag to indicate to tracking logic that EOFE
--             was generated due to short cell.
-- 11/05/2008: Removed chipscope. Removed rx/tx pll and reset logic.
-------------------------------------------------------------------------------

LIBRARY ieee;
use work.all;
use work.PgpVersion.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity PgpTop is 
   generic (
      AckTimeout : natural := 8; -- Ack/Nack Not Received Timeout, 8.192uS Steps
      PicMode    : natural := 0  -- PIC Interface Mode, 1=PIC, 0=Normal
   );
   port ( 

      -- System clock, reset & control
      pgpClk            : in  std_logic;                     -- Master clock
      pgpReset          : in  std_logic;                     -- Synchronous reset input
      pibReLink         : in  std_logic;                     -- Re-Link control signal

      -- Frame Transmit Interface, VC 0
      vc0FrameTxValid   : in  std_logic;                     -- User frame data is valid
      vc0FrameTxReady   : out std_logic;                     -- PGP is ready
      vc0FrameTxSOF     : in  std_logic;                     -- User frame data start of frame
      vc0FrameTxWidth   : in  std_logic;                     -- User frame data width
      vc0FrameTxEOF     : in  std_logic;                     -- User frame data end of frame
      vc0FrameTxEOFE    : in  std_logic;                     -- User frame data end of frame error
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
      vc1FrameTxEOFE    : in  std_logic;                     -- User frame data end of frame error
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
      vc2FrameTxEOFE    : in  std_logic;                     -- User frame data end of frame error
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
      vc3FrameTxEOFE    : in  std_logic;                     -- User frame data end of frame error
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
      vc0FrameRxEOFE    : out std_logic;                     -- PGP frame data end of frame error
      vc0FrameRxData    : out std_logic_vector(15 downto 0); -- PGP frame data
      vc0LocBuffAFull   : in  std_logic;                     -- Local buffer almost full
      vc0LocBuffFull    : in  std_logic;                     -- Local buffer full

      -- Frame Receive Interface, VC 1
      vc1FrameRxValid   : out std_logic;                     -- PGP frame data is valid
      vc1FrameRxSOF     : out std_logic;                     -- PGP frame data start of frame
      vc1FrameRxWidth   : out std_logic;                     -- PGP frame data width
      vc1FrameRxEOF     : out std_logic;                     -- PGP frame data end of frame
      vc1FrameRxEOFE    : out std_logic;                     -- PGP frame data end of frame error
      vc1FrameRxData    : out std_logic_vector(15 downto 0); -- PGP frame data
      vc1LocBuffAFull   : in  std_logic;                     -- Local buffer almost full
      vc1LocBuffFull    : in  std_logic;                     -- Local buffer full

      -- Frame Receive Interface, VC 2
      vc2FrameRxValid   : out std_logic;                     -- PGP frame data is valid
      vc2FrameRxSOF     : out std_logic;                     -- PGP frame data start of frame
      vc2FrameRxWidth   : out std_logic;                     -- PGP frame data width
      vc2FrameRxEOF     : out std_logic;                     -- PGP frame data end of frame
      vc2FrameRxEOFE    : out std_logic;                     -- PGP frame data end of frame error
      vc2FrameRxData    : out std_logic_vector(15 downto 0); -- PGP frame data
      vc2LocBuffAFull   : in  std_logic;                     -- Local buffer almost full
      vc2LocBuffFull    : in  std_logic;                     -- Local buffer full

      -- Frame Receive Interface, VC 3
      vc3FrameRxValid   : out std_logic;                     -- PGP frame data is valid
      vc3FrameRxSOF     : out std_logic;                     -- PGP frame data start of frame
      vc3FrameRxWidth   : out std_logic;                     -- PGP frame data width
      vc3FrameRxEOF     : out std_logic;                     -- PGP frame data end of frame
      vc3FrameRxEOFE    : out std_logic;                     -- PGP frame data end of frame error
      vc3FrameRxData    : out std_logic_vector(15 downto 0); -- PGP frame data
      vc3LocBuffAFull   : in  std_logic;                     -- Local buffer almost full
      vc3LocBuffFull    : in  std_logic;                     -- Local buffer full

      -- Transmit CRC Interface
      crcTxIn           : out std_logic_vector(15 downto 0); -- Transmit data for CRC
      crcTxInit         : out std_logic;                     -- Transmit CRC value init
      crcTxValid        : out std_logic;                     -- Transmit data for CRC is valid
      crcTxWidth        : out std_logic;                     -- Transmit data for CRC width
      crcTxOut          : in  std_logic_vector(31 downto 0); -- Transmit calculated CRC value

      -- Receive CRC Interface
      crcRxIn           : out std_logic_vector(15 downto 0); -- Receive  data for CRC
      crcRxInit         : out std_logic;                     -- Receive  CRC value init
      crcRxValid        : out std_logic;                     -- Receive  data for CRC is valid
      crcRxWidth        : out std_logic;                     -- Receive  data for CRC width
      crcRxOut          : in  std_logic_vector(31 downto 0); -- Receive  calculated CRC value

      -- Physical Interface Signals
      phyRxPolarity     : out std_logic;                     -- PHY receive signal polarity
      phyRxData         : in  std_logic_vector(15 downto 0); -- PHY receive data
      phyRxDataK        : in  std_logic_vector(1  downto 0); -- PHY receive data is K character
      phyTxData         : out std_logic_vector(15 downto 0); -- PHY transmit data
      phyTxDataK        : out std_logic_vector(1  downto 0); -- PHY transmit data is K character
      phyLinkError      : in  std_logic;                     -- PHY 8B10B or disparity error
      phyInitDone       : in  std_logic;                     -- PHY init is done

      -- Event Counters & Status Signals
      localVersion      : out std_logic_vector(7  downto 0); -- Local version ID
      remoteVersion     : out std_logic_vector(7  downto 0); -- Remote version ID
      pibFail           : out std_logic;                     -- PIB fail indication
      pibState          : out std_logic_vector(2  downto 0); -- PIB State
      pibLinkReady      : out std_logic;                     -- PIB link is ready
      pgpSeqError       : out std_logic;                     -- PGP Sequence Logic Error Occured
      countLinkDown     : out std_logic;                     -- Link down count increment
      countLinkError    : out std_logic;                     -- Disparity/Decode error count
      countNack         : out std_logic;                     -- NACK count increment
      countCellError    : out std_logic                      -- Receive Cell error count
   );

end PgpTop;


-- Define architecture
architecture PgpTop of PgpTop is

   -- ACK/NACK Receiver Logic
   component PgpAckRx
      generic (
         AckTimeout : natural := 8  -- Ack/Nack Not Received Timeout, 8.192uS Steps
      );
      port ( 
         pgpClk            : in  std_logic;                     -- Master clock
         pgpReset          : in  std_logic;                     -- Synchronous reset input
         pibLinkReady      : in  std_logic;                     -- PIB Link Ready
         seqFifoEmpty      : out std_logic;                     -- Sequence number fifo is empty
         nackCountInc      : out std_logic;                     -- Nack received count increment
         cellRxDone        : in  std_logic;                     -- Cell reception done
         cellRxCellError   : in  std_logic;                     -- Cell receieve error
         cellRxSeq         : in  std_logic_vector(7  downto 0); -- Cell receieve sequence
         cellRxAck         : in  std_logic;                     -- Cell receieve ACK
         cellRxNAck        : in  std_logic;                     -- Cell receieve NACK
         cidReady          : out std_logic;                     -- CID Engine is ready
         cidTimerStart     : in  std_logic;                     -- CID timer start
         cellTxDataVc      : in  std_logic_vector(1  downto 0); -- Cell transmit virtual channel
         cidSave           : in  std_logic;                     -- CID value store signal
         cellTxSOF         : in  std_logic;                     -- Cell contained SOF
         cellTxDataSeq     : out std_logic_vector(7  downto 0); -- Transmit sequence number
         vc0FrameTxCid     : in  std_logic_vector(31 downto 0); -- User frame data, context ID
         vc0FrameTxAckCid  : out std_logic_vector(31 downto 0); -- PGP ACK/NACK context ID
         vc0FrameTxAckEn   : out std_logic;                     -- PGP ACK/NACK enable
         vc0FrameTxAck     : out std_logic;                     -- PGP ACK/NACK
         vc1FrameTxCid     : in  std_logic_vector(31 downto 0); -- User frame data, context ID
         vc1FrameTxAckCid  : out std_logic_vector(31 downto 0); -- PGP ACK/NACK context ID
         vc1FrameTxAckEn   : out std_logic;                     -- PGP ACK/NACK enable
         vc1FrameTxAck     : out std_logic;                     -- PGP ACK/NACK
         vc2FrameTxCid     : in  std_logic_vector(31 downto 0); -- User frame data, context ID
         vc2FrameTxAckCid  : out std_logic_vector(31 downto 0); -- PGP ACK/NACK context ID
         vc2FrameTxAckEn   : out std_logic;                     -- PGP ACK/NACK enable
         vc2FrameTxAck     : out std_logic;                     -- PGP ACK/NACK
         vc3FrameTxCid     : in  std_logic_vector(31 downto 0); -- User frame data, context ID
         vc3FrameTxAckCid  : out std_logic_vector(31 downto 0); -- PGP ACK/NACK context ID
         vc3FrameTxAckEn   : out std_logic;                     -- PGP ACK/NACK enable
         vc3FrameTxAck     : out std_logic                      -- PGP ACK/NACK
      );
   end component;


   -- Cell Receiver Logic
   component PgpCellRx
      generic (
         PicMode    : natural := 0  -- PIC Interface Mode, 1=PIC, 0=Normal
      );
      port (
         pgpClk            : in  std_logic;                     -- Master clock
         pgpReset          : in  std_logic;                     -- Synchronous reset input
         pibLinkReady      : in  std_logic;                     -- PIB Link Ready
         cellRxSOF         : out std_logic;                     -- Cell contained SOF
         cellRxDataVc      : out std_logic_vector(1  downto 0); -- Cell virtual channel
         cellRxEOF         : out std_logic;                     -- Cell contained EOF
         cellRxEOFE        : out std_logic;                     -- Cell contained EOFE
         cellRxEmpty       : out std_logic;                     -- Cell was empty
         cellVcInFrame     : in  std_logic_vector(3  downto 0); -- Cell VC in frame status
         cellVcAbort       : in  std_logic;                     -- Cell abort flag for current VC
         cellRxDone        : out std_logic;                     -- Cell reception done
         cellRxShort       : out std_logic;                     -- Cell receieve is short (PIC Mode)
         cellRxStart       : out std_logic;                     -- Cell reception start
         cellRxCellError   : out std_logic;                     -- Cell receieve CRC error
         cellRxSeq         : out std_logic_vector(7  downto 0); -- Cell receieve sequence
         cellRxAck         : out std_logic;                     -- Cell receieve ACK
         cellRxNAck        : out std_logic;                     -- Cell receieve NACK
         vc0FrameRxValid   : out std_logic;                     -- PGP frame data is valid
         vc0FrameRxSOF     : out std_logic;                     -- PGP frame data start of frame
         vc0FrameRxWidth   : out std_logic;                     -- PGP frame data width
         vc0FrameRxEOF     : out std_logic;                     -- PGP frame data end of frame
         vc0FrameRxEOFE    : out std_logic;                     -- PGP frame data error
         vc0FrameRxData    : out std_logic_vector(15 downto 0); -- PGP frame data
         vc0RemBuffAFull   : out std_logic;                     -- Remote buffer almost full
         vc0RemBuffFull    : out std_logic;                     -- Remote buffer full
         vc1FrameRxValid   : out std_logic;                     -- PGP frame data is valid
         vc1FrameRxSOF     : out std_logic;                     -- PGP frame data start of frame
         vc1FrameRxWidth   : out std_logic;                     -- PGP frame data width
         vc1FrameRxEOF     : out std_logic;                     -- PGP frame data end of frame
         vc1FrameRxEOFE    : out std_logic;                     -- PGP frame data error
         vc1FrameRxData    : out std_logic_vector(15 downto 0); -- PGP frame data
         vc1RemBuffAFull   : out std_logic;                     -- Remote buffer almost full
         vc1RemBuffFull    : out std_logic;                     -- Remote buffer full
         vc2FrameRxValid   : out std_logic;                     -- PGP frame data is valid
         vc2FrameRxSOF     : out std_logic;                     -- PGP frame data start of frame
         vc2FrameRxWidth   : out std_logic;                     -- PGP frame data width
         vc2FrameRxEOF     : out std_logic;                     -- PGP frame data end of frame
         vc2FrameRxEOFE    : out std_logic;                     -- PGP frame data error
         vc2FrameRxData    : out std_logic_vector(15 downto 0); -- PGP frame data
         vc2RemBuffAFull   : out std_logic;                     -- Remote buffer almost full
         vc2RemBuffFull    : out std_logic;                     -- Remote buffer full
         vc3FrameRxValid   : out std_logic;                     -- PGP frame data is valid
         vc3FrameRxSOF     : out std_logic;                     -- PGP frame data start of frame
         vc3FrameRxWidth   : out std_logic;                     -- PGP frame data width
         vc3FrameRxEOF     : out std_logic;                     -- PGP frame data end of frame
         vc3FrameRxEOFE    : out std_logic;                     -- PGP frame data error
         vc3FrameRxData    : out std_logic_vector(15 downto 0); -- PGP frame data
         vc3RemBuffAFull   : out std_logic;                     -- Remote buffer almost full
         vc3RemBuffFull    : out std_logic;                     -- Remote buffer full
         crcRxIn           : out std_logic_vector(15 downto 0); -- Receive  data for CRC
         crcRxInit         : out std_logic;                     -- Receive  CRC value init
         crcRxValid        : out std_logic;                     -- Receive  data for CRC is valid
         crcRxWidth        : out std_logic;                     -- Receive  data for CRC width
         crcRxOut          : in  std_logic_vector(31 downto 0); -- Receive  calculated CRC value
         pibRxSOC          : in  std_logic;                     -- Cell data start of cell
         pibRxWidth        : in  std_logic;                     -- Cell data width
         pibRxEOC          : in  std_logic;                     -- Cell data end of cell
         pibRxEOF          : in  std_logic;                     -- Cell data end of frame
         pibRxEOFE         : in  std_logic;                     -- Cell data end of frame error
         pibRxData         : in  std_logic_vector(15 downto 0)  -- Cell data data
      );
   end component;

   -- Cell Transmit Logic
   component PgpCellTx
      port (
         pgpClk            : in  std_logic;                     -- Master clock
         pgpReset          : in  std_logic;                     -- Synchronous reset input
         pibLinkReady      : in  std_logic;                     -- PIB Link Ready
         cellTxDataSeq     : in  std_logic_vector(7  downto 0); -- Transmit sequence number
         cellTxSOF         : out std_logic;                     -- Cell contained SOF
         cellTxEOF         : out std_logic;                     -- Cell contained EOF
         cellTxIdle        : in  std_logic;                     -- Force IDLE transmit
         cellTxReq         : in  std_logic;                     -- Cell transmit request
         cellTxInp         : out std_logic;                     -- Cell transmit in progress
         cellTxDataVc      : in  std_logic_vector(1  downto 0); -- Cell transmit virtual channel
         cellTxNAck        : in  std_logic;                     -- Cell transmit NACK request
         cellTxAck         : in  std_logic;                     -- Cell transmit ACK request
         cellTxAckSeq      : in  std_logic_vector(7 downto 0);  -- Cell transmit ACK sequence
         cellTxAcked       : out std_logic;                     -- Cell transmit ACK was sent
         vc0FrameTxValid   : in  std_logic;                     -- User frame data is valid
         vc0FrameTxReady   : out std_logic;                     -- PGP is ready
         vc0FrameTxSOF     : in  std_logic;                     -- User frame data start of frame
         vc0FrameTxWidth   : in  std_logic;                     -- User frame data width
         vc0FrameTxEOF     : in  std_logic;                     -- User frame data end of frame
         vc0FrameTxEOFE    : in  std_logic;                     -- User frame data error
         vc0FrameTxData    : in  std_logic_vector(15 downto 0); -- User frame data
         vc0LocBuffAFull   : in  std_logic;                     -- Local buffer almost full
         vc0LocBuffFull    : in  std_logic;                     -- Local buffer full
         vc1FrameTxValid   : in  std_logic;                     -- User frame data is valid
         vc1FrameTxReady   : out std_logic;                     -- PGP is ready
         vc1FrameTxSOF     : in  std_logic;                     -- User frame data start of frame
         vc1FrameTxWidth   : in  std_logic;                     -- User frame data width
         vc1FrameTxEOF     : in  std_logic;                     -- User frame data end of frame
         vc1FrameTxEOFE    : in  std_logic;                     -- User frame data error
         vc1FrameTxData    : in  std_logic_vector(15 downto 0); -- User frame data
         vc1LocBuffAFull   : in  std_logic;                     -- Local buffer almost full
         vc1LocBuffFull    : in  std_logic;                     -- Local buffer full
         vc2FrameTxValid   : in  std_logic;                     -- User frame data is valid
         vc2FrameTxReady   : out std_logic;                     -- PGP is ready
         vc2FrameTxSOF     : in  std_logic;                     -- User frame data start of frame
         vc2FrameTxWidth   : in  std_logic;                     -- User frame data width
         vc2FrameTxEOF     : in  std_logic;                     -- User frame data end of frame
         vc2FrameTxEOFE    : in  std_logic;                     -- User frame data error
         vc2FrameTxData    : in  std_logic_vector(15 downto 0); -- User frame data
         vc2LocBuffAFull   : in  std_logic;                     -- Local buffer almost full
         vc2LocBuffFull    : in  std_logic;                     -- Local buffer full
         vc3FrameTxValid   : in  std_logic;                     -- User frame data is valid
         vc3FrameTxReady   : out std_logic;                     -- PGP is ready
         vc3FrameTxSOF     : in  std_logic;                     -- User frame data start of frame
         vc3FrameTxWidth   : in  std_logic;                     -- User frame data width
         vc3FrameTxEOF     : in  std_logic;                     -- User frame data end of frame
         vc3FrameTxEOFE    : in  std_logic;                     -- User frame data error
         vc3FrameTxData    : in  std_logic_vector(15 downto 0); -- User frame data
         vc3LocBuffAFull   : in  std_logic;                     -- Local buffer almost full
         vc3LocBuffFull    : in  std_logic;                     -- Local buffer full
         pibTxSOC          : out std_logic;                     -- Cell data start of cell
         pibTxWidth        : out std_logic;                     -- Cell data width
         pibTxEOC          : out std_logic;                     -- Cell data end of cell
         pibTxEOF          : out std_logic;                     -- Cell data end of frame
         pibTxEOFE         : out std_logic;                     -- Cell data end of frame error
         pibTxData         : out std_logic_vector(15 downto 0); -- Cell data data
         crcTxIn           : out std_logic_vector(15 downto 0); -- Transmit data for CRC
         crcTxInit         : out std_logic;                     -- Transmit CRC value init
         crcTxValid        : out std_logic;                     -- Transmit data for CRC is valid
         crcTxWidth        : out std_logic;                     -- Transmit data for CRC width
         crcTxOut          : in  std_logic_vector(31 downto 0)  -- Transmit calculated CRC value
      );
   end component;


   -- Physical Interface Block
   component PgpPhy
      port (
         pgpClk            : in  std_logic;                     -- Master clock
         pgpReset          : in  std_logic;                     -- Synchronous reset input
         pibReLink         : in  std_logic;                     -- Re-Link control signal
         localVersion      : in  std_logic_vector(7  downto 0); -- Local version ID
         remoteVersion     : out std_logic_vector(7  downto 0); -- Remote version ID
         pibFail           : out std_logic;                     -- PIB fail indication
         pibLinkReady      : out std_logic;                     -- PIB link is ready
         pibState          : out std_logic_vector(2  downto 0); -- PIB State
         pibTxSOC          : in  std_logic;                     -- Cell data start of cell
         pibTxWidth        : in  std_logic;                     -- Cell data width
         pibTxEOC          : in  std_logic;                     -- Cell data end of cell
         pibTxEOF          : in  std_logic;                     -- Cell data end of frame
         pibTxEOFE         : in  std_logic;                     -- Cell data end of frame error
         pibTxData         : in  std_logic_vector(15 downto 0); -- Cell data data
         pibRxSOC          : out std_logic;                     -- Cell data start of cell
         pibRxWidth        : out std_logic;                     -- Cell data width
         pibRxEOC          : out std_logic;                     -- Cell data end of cell
         pibRxEOF          : out std_logic;                     -- Cell data end of frame
         pibRxEOFE         : out std_logic;                     -- Cell data end of frame error
         pibRxData         : out std_logic_vector(15 downto 0); -- Cell data data
         phyRxPolarity     : out std_logic;                     -- PHY receive signal polarity
         phyRxData         : in  std_logic_vector(15 downto 0); -- PHY receive data
         phyRxDataK        : in  std_logic_vector(1  downto 0); -- PHY receive data is K char
         phyTxData         : out std_logic_vector(15 downto 0); -- PHY transmit data
         phyTxDataK        : out std_logic_vector(1  downto 0); -- PHY transmit data is K char
         phyInitDone       : in  std_logic                      -- PHY init is done
      );
   end component;

   -- Receiver Tracking Logic
   component PgpRxTrack
      port (
         pgpClk            : in  std_logic;                     -- Master clock
         pgpReset          : in  std_logic;                     -- Synchronous reset input
         pibLinkReady      : in  std_logic;                     -- PIB Link Ready
         ackFifoFull       : out std_logic;                     -- ACK FIFO is full
         cellRxSOF         : in  std_logic;                     -- Cell contained SOF
         cellRxDataVc      : in  std_logic_vector(1  downto 0); -- Cell virtual channel
         cellRxEOF         : in  std_logic;                     -- Cell contained EOF
         cellRxEOFE        : in  std_logic;                     -- Cell contained EOFE
         cellRxEmpty       : in  std_logic;                     -- Cell was empty
         cellRxDone        : in  std_logic;                     -- Cell reception done
         cellRxShort       : in  std_logic;                     -- Cell receieve is short (PIC Mode)
         cellRxStart       : in  std_logic;                     -- Cell reception start
         cellRxCellError   : in  std_logic;                     -- Cell receieve error
         cellRxSeq         : in  std_logic_vector(7  downto 0); -- Cell receieve sequence
         cellVcInFrame     : out std_logic_vector(3  downto 0); -- Cell VC in frame status
         cellVcAbort       : out std_logic;                    -- Cell abort flag for current VC
         cellTxNAck        : out std_logic;                     -- Cell transmit NACK request
         cellTxAck         : out std_logic;                     -- Cell transmit ACK request
         cellTxAckSeq      : out std_logic_vector(7 downto 0);  -- Cell transmit ACK sequence
         cellTxAcked       : in  std_logic;                     -- Cell transmit ACK was sent
         cellTxAckReq      : out std_logic                      -- Cell transmit ACK request
      );
   end component;

   -- Transmit Schedular
   component PgpTxSched
      port (
         pgpClk            : in  std_logic;                     -- Master clock
         pgpReset          : in  std_logic;                     -- Synchronous reset input
         pibLinkReady      : in  std_logic;                     -- PIB Link Ready
         cidReady          : in  std_logic;                     -- CID Engine is ready
         cidTimerStart     : out std_logic;                     -- CID timer start
         cidSave           : out std_logic;                     -- CID value store signal
         cellTxAckReq      : in  std_logic;                     -- Cell ACK/NACK transmit request
         cellTxSOF         : in  std_logic;                     -- Cell contained SOF
         cellTxEOF         : in  std_logic;                     -- Cell contained EOF
         cellTxIdle        : out std_logic;                     -- Force IDLE transmit
         cellTxReq         : out std_logic;                     -- Cell transmit request
         cellTxInp         : in  std_logic;                     -- Cell transmit in progress
         cellTxDataVc      : out std_logic_vector(1  downto 0); -- Cell transmit virtual channel
         vc0FrameTxValid   : in  std_logic;                     -- User frame data is valid
         vc1FrameTxValid   : in  std_logic;                     -- User frame data is valid
         vc2FrameTxValid   : in  std_logic;                     -- User frame data is valid
         vc3FrameTxValid   : in  std_logic                      -- User frame data is valid
      );
   end component;


   -- Local Signals
   signal intLinkReady       : std_logic;                     -- PIB Link Ready
   signal seqFifoEmpty       : std_logic;                     -- Sequence number fifo is empty
   signal nackCountInc       : std_logic;                     -- Nack received count increment
   signal cellRxDone         : std_logic;                     -- Cell reception done
   signal cellRxShort        : std_logic;                     -- Cell receieve is short (PIC Mode)
   signal cellRxStart        : std_logic;                     -- Cell reception start
   signal cellRxCellError    : std_logic;                     -- Cell receieve CRC error
   signal cellVcInFrame      : std_logic_vector(3  downto 0); -- Cell VC in frame status
   signal cellVcAbort        : std_logic;                     -- Cell VC abort control
   signal cellRxSeq          : std_logic_vector(7  downto 0); -- Cell receieve sequence
   signal cellRxAck          : std_logic;                     -- Cell receieve ACK
   signal cellRxNAck         : std_logic;                     -- Cell receieve NACK
   signal cidTimerStart      : std_logic;                     -- CID timer start
   signal cidReady           : std_logic;                     -- Sequence FIFO ready
   signal cidSave            : std_logic;                     -- CID save for later
   signal ackFifoFull        : std_logic;                     -- ACK FIFO is full
   signal cellTxNAck         : std_logic;                     -- Cell transmit NACK request
   signal cellTxAck          : std_logic;                     -- Cell transmit ACK request
   signal cellTxAckSeq       : std_logic_vector(7 downto 0);  -- Cell transmit ACK sequence
   signal cellTxAcked        : std_logic;                     -- Cell transmit ACK was sent
   signal cellTxAckReq       : std_logic;                     -- Cell transmit ACK request
   signal cellRxSOF          : std_logic;                     -- Cell contained SOF
   signal cellRxDataVc       : std_logic_vector(1  downto 0); -- Cell virtual channel
   signal cellRxEOF          : std_logic;                     -- Cell contained EOF
   signal cellRxEOFE         : std_logic;                     -- Cell contained EOFE
   signal cellRxEmpty        : std_logic;                     -- Cell was empty
   signal pibRxSOC           : std_logic;                     -- Cell data start of cell
   signal pibRxWidth         : std_logic;                     -- Cell data width
   signal pibRxEOC           : std_logic;                     -- Cell data end of cell
   signal pibRxEOF           : std_logic;                     -- Cell data end of frame
   signal pibRxEOFE          : std_logic;                     -- Cell data end of frame error
   signal pibRxData          : std_logic_vector(15 downto 0); -- Cell data data
   signal cellTxDataSeq      : std_logic_vector(7  downto 0); -- Transmit sequence number
   signal cellTxSOF          : std_logic;                     -- Cell contained SOF
   signal cellTxEOF          : std_logic;                     -- Cell contained EOF
   signal cellTxIdle         : std_logic;                     -- Force IDLE transmit
   signal cellTxReq          : std_logic;                     -- Cell transmit request
   signal cellTxInp          : std_logic;                     -- Cell transmit in progress
   signal cellTxDataVc       : std_logic_vector(1  downto 0); -- Cell transmit virtual channel
   signal pibTxSOC           : std_logic;                     -- Cell data start of cell
   signal pibTxWidth         : std_logic;                     -- Cell data width
   signal pibTxEOC           : std_logic;                     -- Cell data end of cell
   signal pibTxEOF           : std_logic;                     -- Cell data end of frame
   signal pibTxEOFE          : std_logic;                     -- Cell data end of frame error
   signal pibTxData          : std_logic_vector(15 downto 0); -- Cell data data
   signal intVersion         : std_logic_vector(7  downto 0); -- Local version ID
   signal phyLinkErrorDly    : std_logic;                     -- Delayed copy of PIB link error
   signal nackCountIncDly    : std_logic;                     -- Delayed copy of nack counter
   signal cellRxCellErrorDly : std_logic;                     -- Delayed copy of error
   signal linkDownBlock      : std_logic_vector(7 downto 0);  -- Delayed copy of link ready signal

   -- Register delay for simulation
   constant tpd:time := 0.5 ns;

begin


   -- Set version value
   intVersion <= work.pgpVersion.PgpVersion;

   -- Version & Link Failure
   localVersion <= intVersion;
   pibLinkReady <= intLinkReady;


   -- ACK/NACK Receive Logic
   U_PgpAckRx: PgpAckRx generic map ( AckTimeout => AckTimeout ) port map (
      pgpClk           => pgpClk,            pgpReset         => pgpReset,
      pibLinkReady     => intLinkReady,      seqFifoEmpty     => seqFifoEmpty,
      nackCountInc     => nackCountInc,      cellRxDone       => cellRxDone,
      cellRxCellError  => cellRxCellError,   cellRxSeq        => cellRxSeq,
      cellRxAck        => cellRxAck,         cellRxNAck       => cellRxNAck,
      cidReady         => cidReady,          cellTxDataSeq    => cellTxDataSeq,
      cellTxSOF        => cellTxSOF,         cidTimerStart    => cidTimerStart,
      cellTxDataVc     => cellTxDataVc,      cidSave          => cidSave,
      vc0FrameTxCid    => vc0FrameTxCid,     vc1FrameTxCid    => vc1FrameTxCid,
      vc2FrameTxCid    => vc2FrameTxCid,     vc3FrameTxCid    => vc3FrameTxCid,
      vc0FrameTxAckCid => vc0FrameTxAckCid,  vc0FrameTxAckEn  => vc0FrameTxAckEn,
      vc0FrameTxAck    => vc0FrameTxAck,     vc1FrameTxAckCid => vc1FrameTxAckCid,
      vc1FrameTxAckEn  => vc1FrameTxAckEn,   vc1FrameTxAck    => vc1FrameTxAck,
      vc2FrameTxAckCid => vc2FrameTxAckCid,  vc2FrameTxAckEn  => vc2FrameTxAckEn,
      vc2FrameTxAck    => vc2FrameTxAck,     vc3FrameTxAckCid => vc3FrameTxAckCid,
      vc3FrameTxAckEn  => vc3FrameTxAckEn,   vc3FrameTxAck    => vc3FrameTxAck
   );

   -- Cell Receiver Logic
   U_PgpCellRx: PgpCellRx generic map ( PicMode => PicMode ) port map (
      pgpClk          => pgpClk,           pgpReset        => pgpReset,
      cellRxSOF       => cellRxSOF,        cellRxDataVc    => cellRxDataVc,
      cellRxEOF       => cellRxEOF,        cellRxEOFE      => cellRxEOFE,
      cellRxEmpty     => cellRxEmpty,      cellVcInFrame   => cellVcInFrame,
      cellRxDone      => cellRxDone,       cellRxCellError => cellRxCellError,
      cellRxSeq       => cellRxSeq,        cellRxAck       => cellRxAck,
      cellRxNAck      => cellRxNAck,       vc0FrameRxValid => vc0FrameRxValid,
      vc0FrameRxSOF   => vc0FrameRxSOF,    vc0FrameRxWidth => vc0FrameRxWidth,
      vc0FrameRxEOF   => vc0FrameRxEOF,    vc0FrameRxEOFE  => vc0FrameRxEOFE,
      vc0FrameRxData  => vc0FrameRxData,   vc0RemBuffAFull => vc0RemBuffAFull,
      vc0RemBuffFull  => vc0RemBuffFull,   vc1FrameRxValid => vc1FrameRxValid,
      vc1FrameRxSOF   => vc1FrameRxSOF,    vc1FrameRxWidth => vc1FrameRxWidth,
      vc1FrameRxEOF   => vc1FrameRxEOF,    vc1FrameRxEOFE  => vc1FrameRxEOFE,
      vc1FrameRxData  => vc1FrameRxData,   vc1RemBuffAFull => vc1RemBuffAFull,
      vc1RemBuffFull  => vc1RemBuffFull,   vc2FrameRxValid => vc2FrameRxValid,
      vc2FrameRxSOF   => vc2FrameRxSOF,    vc2FrameRxWidth => vc2FrameRxWidth,
      vc2FrameRxEOF   => vc2FrameRxEOF,    vc2FrameRxEOFE  => vc2FrameRxEOFE,
      vc2FrameRxData  => vc2FrameRxData,   vc2RemBuffAFull => vc2RemBuffAFull,
      vc2RemBuffFull  => vc2RemBuffFull,   vc3FrameRxValid => vc3FrameRxValid,
      vc3FrameRxSOF   => vc3FrameRxSOF,    vc3FrameRxWidth => vc3FrameRxWidth,
      vc3FrameRxEOF   => vc3FrameRxEOF,    vc3FrameRxEOFE  => vc3FrameRxEOFE,
      vc3FrameRxData  => vc3FrameRxData,   vc3RemBuffAFull => vc3RemBuffAFull,
      vc3RemBuffFull  => vc3RemBuffFull,   crcRxIn         => crcRxIn,
      crcRxInit       => crcRxInit,        crcRxValid      => crcRxValid,
      crcRxWidth      => crcRxWidth,       crcRxOut        => crcRxOut,
      pibRxSOC        => pibRxSOC,         pibRxWidth      => pibRxWidth,
      pibRxEOC        => pibRxEOC,         pibRxEOF        => pibRxEOF,
      pibRxEOFE       => pibRxEOFE,        pibRxData       => pibRxData,
      cellRxStart     => cellRxStart,      pibLinkReady    => intLinkReady,
      cellVcAbort     => cellVcAbort,      cellRxShort     => cellRxShort
   );

   -- Cell Transmitter Logic
   U_PgpCellTx: PgpCellTx port map (
      pgpClk           => pgpClk,            pgpReset         => pgpReset,
      cellTxDataSeq    => cellTxDataSeq,     cellTxSOF        => cellTxSOF,
      cellTxEOF        => cellTxEOF,         cellTxIdle       => cellTxIdle,
      cellTxReq        => cellTxReq,         cellTxInp        => cellTxInp,
      cellTxDataVc     => cellTxDataVc,      cellTxNAck       => cellTxNAck,
      cellTxAck        => cellTxAck,         cellTxAckSeq     => cellTxAckSeq,
      cellTxAcked      => cellTxAcked,       vc0FrameTxValid  => vc0FrameTxValid,
      vc0FrameTxReady  => vc0FrameTxReady,   vc0FrameTxSOF    => vc0FrameTxSOF,
      vc0FrameTxWidth  => vc0FrameTxWidth,   vc0FrameTxEOF    => vc0FrameTxEOF,
      vc0FrameTxEOFE   => vc0FrameTxEOFE,    vc0FrameTxData   => vc0FrameTxData,
      vc0LocBuffAFull  => vc0LocBuffAFull,   vc0LocBuffFull   => vc0LocBuffFull,
      vc1FrameTxValid  => vc1FrameTxValid,   vc1FrameTxReady  => vc1FrameTxReady,
      vc1FrameTxSOF    => vc1FrameTxSOF,     vc1FrameTxWidth  => vc1FrameTxWidth,
      vc1FrameTxEOF    => vc1FrameTxEOF,     vc1FrameTxEOFE   => vc1FrameTxEOFE,
      vc1FrameTxData   => vc1FrameTxData,    vc1LocBuffAFull  => vc1LocBuffAFull,
      vc1LocBuffFull   => vc1LocBuffFull,    vc2FrameTxValid  => vc2FrameTxValid,
      vc2FrameTxReady  => vc2FrameTxReady,   vc2FrameTxSOF    => vc2FrameTxSOF,
      vc2FrameTxWidth  => vc2FrameTxWidth,   vc2FrameTxEOF    => vc2FrameTxEOF,
      vc2FrameTxEOFE   => vc2FrameTxEOFE,    vc2FrameTxData   => vc2FrameTxData,
      vc2LocBuffAFull  => vc2LocBuffAFull,   vc2LocBuffFull   => vc2LocBuffFull,
      vc3FrameTxValid  => vc3FrameTxValid,   vc3FrameTxReady  => vc3FrameTxReady,
      vc3FrameTxSOF    => vc3FrameTxSOF,     vc3FrameTxWidth  => vc3FrameTxWidth,
      vc3FrameTxEOF    => vc3FrameTxEOF,     vc3FrameTxEOFE   => vc3FrameTxEOFE,
      vc3FrameTxData   => vc3FrameTxData,    vc3LocBuffAFull  => vc3LocBuffAFull,
      vc3LocBuffFull   => vc3LocBuffFull,    pibTxSOC         => pibTxSOC,
      pibTxWidth       => pibTxWidth,        pibTxEOC         => pibTxEOC,
      pibTxEOF         => pibTxEOF,          pibTxEOFE        => pibTxEOFE,
      pibTxData        => pibTxData,         crcTxIn          => crcTxIn,
      crcTxInit        => crcTxInit,         crcTxValid       => crcTxValid,
      crcTxWidth       => crcTxWidth,        crcTxOut         => crcTxOut,
      pibLinkReady     => intLinkReady
   );

   -- Physical Interface Block
   U_PgpPhy: PgpPhy port map (
      pgpClk         => pgpClk,          pgpReset       => pgpReset,
      pibReLink      => pibReLink,       localVersion   => intVersion,
      remoteVersion  => remoteVersion,   pibFail        => pibFail,
      pibLinkReady   => intLinkReady,    pibState       => pibState,
      pibTxSOC       => pibTxSOC,        pibTxWidth     => pibTxWidth,
      pibTxEOC       => pibTxEOC,        pibTxEOF       => pibTxEOF,
      pibTxEOFE      => pibTxEOFE,       pibTxData      => pibTxData,
      pibRxSOC       => pibRxSOC,        pibRxWidth     => pibRxWidth,
      pibRxEOC       => pibRxEOC,        pibRxEOF       => pibRxEOF,
      pibRxEOFE      => pibRxEOFE,       pibRxData      => pibRxData,
      phyRxPolarity  => phyRxPolarity,   phyRxData      => phyRxData,
      phyRxDataK     => phyRxDataK,      phyTxData      => phyTxData,
      phyTxDataK     => phyTxDataK,      phyInitDone    => phyInitDone
   );

   -- Receiver Tracking Logic
   U_PgpRxTrack: PgpRxTrack port map (
      pgpClk         => pgpClk,          pgpReset        => pgpReset,
      pibLinkReady   => intLinkReady,    ackFifoFull     => ackFifoFull,
      cellRxSOF      => cellRxSOF,       cellRxDataVc    => cellRxDataVc,
      cellRxEOF      => cellRxEOF,       cellRxEOFE      => cellRxEOFE,
      cellRxEmpty    => cellRxEmpty,     cellRxStart     => cellRxStart,
      cellRxDone     => cellRxDone,      cellRxCellError => cellRxCellError,
      cellRxSeq      => cellRxSeq,       cellVcInFrame   => cellVcInFrame,
      cellTxNAck     => cellTxNAck,      cellTxAck       => cellTxAck,
      cellTxAckSeq   => cellTxAckSeq,    cellTxAcked     => cellTxAcked,
      cellTxAckReq   => cellTxAckReq,    cellVcAbort     => cellVcAbort,
      cellRxShort    => cellRxShort
   );

   -- Transmit Schedular Logic
   U_PgpTxSched: PgpTxSched port map (
      pgpClk          => pgpClk,           pgpReset        => pgpReset,
      pibLinkReady    => intLinkReady,     cidReady        => cidReady,
      cidTimerStart   => cidTimerStart,    cidSave         => cidSave,
      cellTxAckReq    => cellTxAckReq,     cellTxSOF       => cellTxSOF,
      cellTxEOF       => cellTxEOF,        cellTxIdle      => cellTxIdle,
      cellTxReq       => cellTxReq,        cellTxInp       => cellTxInp,
      cellTxDataVc    => cellTxDataVc,     vc0FrameTxValid => vc0FrameTxValid,
      vc1FrameTxValid => vc1FrameTxValid,  vc2FrameTxValid => vc2FrameTxValid,
      vc3FrameTxValid => vc3FrameTxValid
   );


   -- Generate error count pulses
   process ( pgpClk, pgpReset ) begin
      if pgpReset = '1' then
         phyLinkErrorDly    <= '0'           after tpd;
         nackCountIncDly    <= '0'           after tpd;
         cellRxCellErrorDly <= '0'           after tpd;
         countLinkDown      <= '0'           after tpd;
         countLinkError     <= '0'           after tpd;
         countNack          <= '0'           after tpd;
         countCellError     <= '0'           after tpd;
         pgpSeqError        <= '0'           after tpd;
         linkDownBlock      <= (others=>'0') after tpd;

      elsif rising_edge(pgpClk) then

         -- Delay chain to block counts when link is down
         if intLinkReady = '0' then
            linkDownBlock <= (others=>'0') after tpd;
         else
            linkDownBlock(7 downto 1) <= linkDownBlock(6 downto 0) after tpd;
            linkDownBlock(0)          <= '1'                       after tpd;
         end if;

         -- Detect error in sequence logic. Latch until re-link
         if linkDownBlock(7) = '0' then
            pgpSeqError <= '0' after tpd;
         elsif ackFifoFull = '1' or seqFifoEmpty = '1' then
            pgpSeqError <= '1' after tpd;
         end if;
            
         -- Delayed copy of signals
         phyLinkErrorDly    <= phyLinkError    after tpd;
         nackCountIncDly    <= nackCountInc    after tpd;
         cellRxCellErrorDly <= cellRxCellError after tpd;

         -- Only count when link has been up and is stable
         if linkDownBlock(7) = '1' then

            -- Edge detect
            countLinkError    <= not phyLinkErrorDly    and phyLinkError    after tpd;
            countNack         <= not nackCountIncDly    and nackCountInc    after tpd;
            countCellError    <= not cellRxCellErrorDly and cellRxCellError after tpd;
         else
            countLinkError    <= '0' after tpd;
            countNack         <= '0' after tpd;
            countCellError    <= '0' after tpd;
         end if;

         -- Link down counter
         countLinkDown <= (not intLinkReady) and linkDownBlock(0) after tpd;

      end if;
   end process;

end PgpTop;

