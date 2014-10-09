-------------------------------------------------------------------------------
-- Title         : Pretty Good Protocol Applications, Front End Wrapper
-- Project       : General Purpose Core
-------------------------------------------------------------------------------
-- File          : PgpFrontEnd.vhd
-- Author        : Ryan Herbst, rherbst@slac.stanford.edu
-- Created       : 09/24/2007
-------------------------------------------------------------------------------
-- Description:
-- Wrapper for front end logic connection to the RCE. 
-------------------------------------------------------------------------------
-- Copyright (c) 2007 by Ryan Herbst. All rights reserved.
-------------------------------------------------------------------------------
-- Modification history:
-- 09/24/2007: created.
-- 03/06/2008: Removed width signal.
-------------------------------------------------------------------------------

LIBRARY ieee;
use work.all;
use work.Version.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity PgpFrontEnd is 
   generic (
      MgtMode    : string  := "A";       -- Default Location
      RefClkSel  : string  := "REFCLK1"  -- Reference Clock To Use "REFCLK1" or "REFCLK2"
   );
   port ( 
      
      -- Reference Clock, PGP Clock & Reset Signals
      -- Use one ref clock, tie other to 0, see RefClkSel above
      pgpRefClk1       : in  std_logic;
      pgpRefClk2       : in  std_logic;
      mgtRxRecClk      : out std_logic;
      pgpClk           : in  std_logic;
      pgpReset         : in  std_logic;

      -- Display Digits
      pgpDispA         : out std_logic_vector(7 downto 0);
      pgpDispB         : out std_logic_vector(7 downto 0);

      -- Reset output
      resetOut         : out std_logic;

      -- Local clock and reset
      locClk           : in  std_logic;
      locReset         : in  std_logic;

      -- Local command signal
      cmdEn            : out std_logic;
      cmdOpCode        : out std_logic_vector(7  downto 0);
      cmdCtxOut        : out std_logic_vector(23 downto 0);

      -- Local register control signals
      regReq           : out std_logic;
      regOp            : out std_logic;
      regInp           : out std_logic;
      regAck           : in  std_logic;
      regFail          : in  std_logic;
      regAddr          : out std_logic_vector(23 downto 0);
      regDataOut       : out std_logic_vector(31 downto 0);
      regDataIn        : in  std_logic_vector(31 downto 0);

      -- Local data transfer signals
      frameTxEnable    : in  std_logic;
      frameTxSOF       : in  std_logic;
      frameTxEOF       : in  std_logic;
      frameTxEOFE      : in  std_logic;
      frameTxData      : in  std_logic_vector(15 downto 0);
      frameTxAFull     : out std_logic;
      frameRxValid     : out std_logic;
      frameRxReady     : in  std_logic;
      frameRxSOF       : out std_logic;
      frameRxEOF       : out std_logic;
      frameRxEOFE      : out std_logic;
      frameRxData      : out std_logic_vector(15 downto 0);
      valid            : out std_logic;
      eof              : out std_logic;
      sof              : out std_logic;

      -- MGT Serial Pins
      mgtRxN           : in  std_logic;
      mgtRxP           : in  std_logic;
      mgtTxN           : out std_logic;
      mgtTxP           : out std_logic;

      -- MGT Signals For Simulation, 
      -- Drive mgtCombusIn to 0's, Leave mgtCombusOut open for real use
      mgtCombusIn      : in  std_logic_vector(15 downto 0);
      mgtCombusOut     : out std_logic_vector(15 downto 0)
   );
end PgpFrontEnd;


-- Define architecture
architecture PgpFrontEnd of PgpFrontEnd is

   -- PGP Block
   component PgpMgtWrap
      generic (
         MgtMode     : string  := "A";       -- Default Location
         AckTimeout  : natural := 8;         -- Ack/Nack Not Received Timeout, 8.192uS Steps
         PicMode     : natural := 0;         -- PIC Interface Mode, 1=PIC, 0=Normal
         RefClkSel   : string  := "REFCLK1"; -- Reference Clock To Use "REFCLK1" or "REFCLK2"
         CScopeEnPhy : string  := "DISABLE"  -- Insert ChipScope, Enable or Disable
      );
      port (
         pgpClk            : in  std_logic;                     -- 125Mhz master clock
         pgpReset          : in  std_logic;                     -- Synchronous reset input
         pibReLink         : in  std_logic;                     -- Re-Link control signal
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
         vc0FrameRxValid   : out std_logic;                     -- PGP frame data is valid
         vc0FrameRxSOF     : out std_logic;                     -- PGP frame data start of frame
         vc0FrameRxWidth   : out std_logic;                     -- PGP frame data width
         vc0FrameRxEOF     : out std_logic;                     -- PGP frame data end of frame
         vc0FrameRxEOFE    : out std_logic;                     -- PGP frame data error
         vc0FrameRxData    : out std_logic_vector(15 downto 0); -- PGP frame data
         vc0LocBuffAFull   : in  std_logic;                     -- Local buffer almost full
         vc0LocBuffFull    : in  std_logic;                     -- Local buffer full
         vc1FrameRxValid   : out std_logic;                     -- PGP frame data is valid
         vc1FrameRxSOF     : out std_logic;                     -- PGP frame data start of frame
         vc1FrameRxWidth   : out std_logic;                     -- PGP frame data width
         vc1FrameRxEOF     : out std_logic;                     -- PGP frame data end of frame
         vc1FrameRxEOFE    : out std_logic;                     -- PGP frame data error
         vc1FrameRxData    : out std_logic_vector(15 downto 0); -- PGP frame data
         vc1LocBuffAFull   : in  std_logic;                     -- Local buffer almost full
         vc1LocBuffFull    : in  std_logic;                     -- Local buffer full
         vc2FrameRxValid   : out std_logic;                     -- PGP frame data is valid
         vc2FrameRxSOF     : out std_logic;                     -- PGP frame data start of frame
         vc2FrameRxWidth   : out std_logic;                     -- PGP frame data width
         vc2FrameRxEOF     : out std_logic;                     -- PGP frame data end of frame
         vc2FrameRxEOFE    : out std_logic;                     -- PGP frame data error
         vc2FrameRxData    : out std_logic_vector(15 downto 0); -- PGP frame data
         vc2LocBuffAFull   : in  std_logic;                     -- Local buffer almost full
         vc2LocBuffFull    : in  std_logic;                     -- Local buffer full
         vc3FrameRxValid   : out std_logic;                     -- PGP frame data is valid
         vc3FrameRxSOF     : out std_logic;                     -- PGP frame data start of frame
         vc3FrameRxWidth   : out std_logic;                     -- PGP frame data width
         vc3FrameRxEOF     : out std_logic;                     -- PGP frame data end of frame
         vc3FrameRxEOFE    : out std_logic;                     -- PGP frame data error
         vc3FrameRxData    : out std_logic_vector(15 downto 0); -- PGP frame data
         vc3LocBuffAFull   : in  std_logic;                     -- Local buffer almost full
         vc3LocBuffFull    : in  std_logic;                     -- Local buffer full
         localVersion      : out std_logic_vector(7  downto 0); -- Local version ID
         remoteVersion     : out std_logic_vector(7  downto 0); -- Remote version ID
         pibFail           : out std_logic;                     -- PIB fail indication
         pibState          : out std_logic_vector(2  downto 0); -- PIB State
         pibLock           : out std_logic_vector(1  downto 0); -- PIB Lock Bits, 0=Rx, 1=Tx
         pibLinkReady      : out std_logic;                     -- PIB link is ready
         pgpSeqError       : out std_logic;                     -- PGP Sequence Logic Error Occured
         countLinkDown     : out std_logic;                     -- Link down count increment
         countLinkError    : out std_logic;                     -- Link error count increment
         countNack         : out std_logic;                     -- NACK count increment
         countCellError    : out std_logic;                     -- Receive Cell error count increment
         mgtDAddr          : in  std_logic_vector( 7 downto 0); -- MGT Configuration Address
         mgtDClk           : in  std_logic;                     -- MGT Configuration Clock
         mgtDEn            : in  std_logic;                     -- MGT Configuration Data Enable
         mgtDI             : in  std_logic_vector(15 downto 0); -- MGT Configuration Data In
         mgtDO             : out std_logic_vector(15 downto 0); -- MGT Configuration Data Out
         mgtDRdy           : out std_logic;                     -- MGT Configuration Ready
         mgtDWe            : in  std_logic;                     -- MGT Configuration Write Enable
         mgtLoopback       : in  std_logic;                     -- MGT Serial Loopback Control
         mgtInverted       : out std_logic;                     -- MGT Received Data Is Inverted
         mgtRefClk1        : in  std_logic;                     -- MGT Reference Clock In 1
         mgtRefClk2        : in  std_logic;                     -- MGT Reference Clock In 2
         mgtRxRecClk       : out std_logic;                     -- MGT Rx Recovered Clock
         mgtRxN            : in  std_logic;                     -- MGT Serial Receive Negative
         mgtRxP            : in  std_logic;                     -- MGT Serial Receive Positive
         mgtTxN            : out std_logic;                     -- MGT Serial Transmit Negative
         mgtTxP            : out std_logic;                     -- MGT Serial Transmit Positive
         mgtCombusIn       : in  std_logic_vector(15 downto 0);
         mgtCombusOut      : out std_logic_vector(15 downto 0)
      );
   end component;

   -- Command Block
   component PgpCmdSlave
      generic (
         DestId      : natural := 0;     -- Destination ID Value To Match
         DestMask    : natural := 0;     -- Destination ID Mask For Match
         AsyncFIFO   : string  := "TRUE" -- Use Async FIFOs, TRUE or FALSE
      );
      port (
         pgpClk           : in  std_logic;                      -- PGP Clock
         pgpReset         : in  std_logic;                      -- Synchronous PGP Reset
         locClk           : in  std_logic;                      -- Local Clock
         locReset         : in  std_logic;                      -- Synchronous Local Reset
         vcFrameRxValid   : in  std_logic;                      -- Data is valid
         vcFrameRxSOF     : in  std_logic;                      -- Data is SOF
         vcFrameRxWidth   : in  std_logic;                      -- Data is 16-bits
         vcFrameRxEOF     : in  std_logic;                      -- Data is EOF
         vcFrameRxEOFE    : in  std_logic;                      -- Data is EOF with Error
         vcFrameRxData    : in  std_logic_vector(15 downto 0);  -- Data
         vcLocBuffAFull   : out std_logic;                      -- Local buffer almost full
         vcLocBuffFull    : out std_logic;                      -- Local buffer full
         cmdEn            : out std_logic;                      -- Command Enable
         cmdOpCode        : out std_logic_vector(7  downto 0);  -- Command OpCode
         cmdCtxOut        : out std_logic_vector(23 downto 0)   -- Command Context
      );
   end component;

   -- Register access block
   component PgpRegSlave
      generic (
         AsyncFIFO   : string  := "TRUE"   -- Use Async FIFOs, TRUE or FALSE
      );
      port (
         pgpClk           : in  std_logic;                     -- PGP Clock
         pgpReset         : in  std_logic;                     -- Synchronous PGP Reset
         locClk           : in  std_logic;                     -- Local Clock
         locReset         : in  std_logic;                     -- Synchronous Local Reset
         vcFrameRxValid   : in  std_logic;                     -- Data is valid
         vcFrameRxSOF     : in  std_logic;                     -- Data is SOF
         vcFrameRxWidth   : in  std_logic;                     -- Data is 16-bits
         vcFrameRxEOF     : in  std_logic;                     -- Data is EOF
         vcFrameRxEOFE    : in  std_logic;                     -- Data is EOF with Error
         vcFrameRxData    : in  std_logic_vector(15 downto 0); -- Data
         vcLocBuffAFull   : out std_logic;                     -- Local buffer almost full
         vcLocBuffFull    : out std_logic;                     -- Local buffer full
         vcFrameTxValid   : out std_logic;                     -- User frame data is valid
         vcFrameTxReady   : in  std_logic;                     -- PGP is ready
         vcFrameTxSOF     : out std_logic;                     -- User frame data start of frame
         vcFrameTxWidth   : out std_logic;                     -- User frame data width
         vcFrameTxEOF     : out std_logic;                     -- User frame data end of frame
         vcFrameTxEOFE    : out std_logic;                     -- User frame data error
         vcFrameTxData    : out std_logic_vector(15 downto 0); -- User frame data
         vcFrameTxCid     : out std_logic_vector(31 downto 0); -- User frame data, context ID
         vcFrameTxAckCid  : in  std_logic_vector(31 downto 0); -- PGP ACK/NACK context ID
         vcFrameTxAckEn   : in  std_logic;                     -- PGP ACK/NACK enable
         vcFrameTxAck     : in  std_logic;                     -- PGP ACK/NACK
         vcRemBuffAFull   : in  std_logic;                     -- Remote buffer almost full
         vcRemBuffFull    : in  std_logic;                     -- Remote buffer full
         regInp           : out std_logic;                     -- Register Access In Progress Flag
         regReq           : out std_logic;                     -- Register Access Request
         regOp            : out std_logic;                     -- Register OpCode, 0=Read, 1=Write
         regAck           : in  std_logic;                     -- Register Access Acknowledge
         regFail          : in  std_logic;                     -- Register Access Fail
         regAddr          : out std_logic_vector(23 downto 0); -- Register Address
         regDataOut       : out std_logic_vector(31 downto 0); -- Register Data Out
         regDataIn        : in  std_logic_vector(31 downto 0)  -- Register Data In
      );
   end component;

   -- Data buffer
   component PgpDataBuffer
      port (
         pgpClk           : in  std_logic;
         pgpReset         : in  std_logic;
         locClk           : in  std_logic;
         locReset         : in  std_logic;
         frameTxEnable    : in  std_logic;
         frameTxSOF       : in  std_logic;
         frameTxEOF       : in  std_logic;
         frameTxEOFE      : in  std_logic;
         frameTxData      : in  std_logic_vector(15 downto 0);
         frameTxAFull     : out std_logic;
         vcFrameTxValid   : out std_logic;
         vcFrameTxReady   : in  std_logic;
         vcFrameTxSOF     : out std_logic;
         vcFrameTxWidth   : out std_logic;
         vcFrameTxEOF     : out std_logic;
         vcFrameTxEOFE    : out std_logic;
         vcFrameTxData    : out std_logic_vector(15 downto 0);
         vcFrameTxCid     : out std_logic_vector(31 downto 0);
         vcFrameTxAckCid  : in  std_logic_vector(31 downto 0);
         vcFrameTxAckEn   : in  std_logic;
         vcFrameTxAck     : in  std_logic;
         vcRemBuffAFull   : in  std_logic;
         vcRemBuffFull    : in  std_logic;
         dataOverFlow     : out std_logic
      );
   end component;

   -- Downstream buffer
   component PgpDsBuff
      port (
         pgpClk           : in  std_logic;
         pgpReset         : in  std_logic;
         locClk           : in  std_logic;
         locReset         : in  std_logic;
         vcFrameRxValid   : in  std_logic;
         vcFrameRxSOF     : in  std_logic;
         vcFrameRxWidth   : in  std_logic;
         vcFrameRxEOF     : in  std_logic;
         vcFrameRxEOFE    : in  std_logic;
         vcFrameRxData    : in  std_logic_vector(15 downto 0);
         vcLocBuffAFull   : out std_logic;
         vcLocBuffFull    : out std_logic;
         frameRxValid     : out std_logic;
         frameRxReady     : in  std_logic;
         frameRxSOF       : out std_logic;
         frameRxEOF       : out std_logic;
         frameRxEOFE      : out std_logic;
         frameRxData      : out std_logic_vector(15 downto 0)
      );
   end component;

   -- Local Signals
   signal pibReLink         : std_logic;
   signal vc0FrameTxValid   : std_logic;
   signal vc0FrameTxReady   : std_logic;
   signal vc0FrameTxSOF     : std_logic;
   signal vc0FrameTxWidth   : std_logic;
   signal vc0FrameTxEOF     : std_logic;
   signal vc0FrameTxEOFE    : std_logic;
   signal vc0FrameTxData    : std_logic_vector(15 downto 0);
   signal vc0FrameTxCid     : std_logic_vector(31 downto 0);
   signal vc0FrameTxAckCid  : std_logic_vector(31 downto 0);
   signal vc0FrameTxAckEn   : std_logic;
   signal vc0FrameTxAck     : std_logic;
   signal vc0RemBuffAFull   : std_logic;
   signal vc0RemBuffFull    : std_logic;
   signal vc1FrameTxValid   : std_logic;
   signal vc1FrameTxReady   : std_logic;
   signal vc1FrameTxSOF     : std_logic;
   signal vc1FrameTxWidth   : std_logic;
   signal vc1FrameTxEOF     : std_logic;
   signal vc1FrameTxEOFE    : std_logic;
   signal vc1FrameTxData    : std_logic_vector(15 downto 0);
   signal vc1FrameTxCid     : std_logic_vector(31 downto 0);
   signal vc1FrameTxAckCid  : std_logic_vector(31 downto 0);
   signal vc1FrameTxAckEn   : std_logic;
   signal vc1FrameTxAck     : std_logic;
   signal vc1RemBuffAFull   : std_logic;
   signal vc1RemBuffFull    : std_logic;
   signal vc2FrameTxValid   : std_logic;
   signal vc2FrameTxReady   : std_logic;
   signal vc2FrameTxSOF     : std_logic;
   signal vc2FrameTxWidth   : std_logic;
   signal vc2FrameTxEOF     : std_logic;
   signal vc2FrameTxEOFE    : std_logic;
   signal vc2FrameTxData    : std_logic_vector(15 downto 0);
   signal vc2FrameTxCid     : std_logic_vector(31 downto 0);
   signal vc2FrameTxAckCid  : std_logic_vector(31 downto 0);
   signal vc2FrameTxAckEn   : std_logic;
   signal vc2FrameTxAck     : std_logic;
   signal vc2RemBuffAFull   : std_logic;
   signal vc2RemBuffFull    : std_logic;
   signal vc3FrameTxValid   : std_logic;
   signal vc3FrameTxReady   : std_logic;
   signal vc3FrameTxSOF     : std_logic;
   signal vc3FrameTxWidth   : std_logic;
   signal vc3FrameTxEOF     : std_logic;
   signal vc3FrameTxEOFE    : std_logic;
   signal vc3FrameTxData    : std_logic_vector(15 downto 0);
   signal vc3FrameTxCid     : std_logic_vector(31 downto 0);
   signal vc3FrameTxAckCid  : std_logic_vector(31 downto 0);
   signal vc3FrameTxAckEn   : std_logic;
   signal vc3FrameTxAck     : std_logic;
   signal vc3RemBuffAFull   : std_logic;
   signal vc3RemBuffFull    : std_logic;
   signal vc0FrameRxValid   : std_logic;
   signal vc0FrameRxSOF     : std_logic;
   signal vc0FrameRxWidth   : std_logic;
   signal vc0FrameRxEOF     : std_logic;
   signal vc0FrameRxEOFE    : std_logic;
   signal vc0FrameRxData    : std_logic_vector(15 downto 0);
   signal vc0LocBuffAFull   : std_logic;
   signal vc0LocBuffFull    : std_logic;
   signal vc1FrameRxValid   : std_logic;
   signal vc1FrameRxSOF     : std_logic;
   signal vc1FrameRxWidth   : std_logic;
   signal vc1FrameRxEOF     : std_logic;
   signal vc1FrameRxEOFE    : std_logic;
   signal vc1FrameRxData    : std_logic_vector(15 downto 0);
   signal vc1LocBuffAFull   : std_logic;
   signal vc1LocBuffFull    : std_logic;
   signal vc2FrameRxValid   : std_logic;
   signal vc2FrameRxSOF     : std_logic;
   signal vc2FrameRxWidth   : std_logic;
   signal vc2FrameRxEOF     : std_logic;
   signal vc2FrameRxEOFE    : std_logic;
   signal vc2FrameRxData    : std_logic_vector(15 downto 0);
   signal vc2LocBuffAFull   : std_logic;
   signal vc2LocBuffFull    : std_logic;
   signal vc3FrameRxValid   : std_logic;
   signal vc3FrameRxSOF     : std_logic;
   signal vc3FrameRxWidth   : std_logic;
   signal vc3FrameRxEOF     : std_logic;
   signal vc3FrameRxEOFE    : std_logic;
   signal vc3FrameRxData    : std_logic_vector(15 downto 0);
   signal vc3LocBuffAFull   : std_logic;
   signal vc3LocBuffFull    : std_logic;
   signal pibState          : std_logic_vector(2  downto 0);
   signal pibLock           : std_logic_vector(1  downto 0);
   signal countLinkDown     : std_logic;
   signal countLinkError    : std_logic;
   signal countNack         : std_logic;
   signal countCellError    : std_logic;
   signal mgtInverted       : std_logic;
   signal cntLinkError      : std_logic_vector(3  downto 0);
   signal cntNack           : std_logic_vector(3  downto 0);
   signal cntCellError      : std_logic_vector(3  downto 0);
   signal cntLinkDown       : std_logic_vector(3  downto 0);
   signal cntOverFlow       : std_logic_vector(3  downto 0);
   signal pllLock           : std_logic;
   signal pllLockDly        : std_logic;
   signal cntPllLock        : std_logic_vector(3  downto 0);
   signal pgpSeqError       : std_logic;
   signal intRegReq         : std_logic;
   signal intRegOp          : std_logic;
   signal intRegAck         : std_logic;
   signal intRegFail        : std_logic;
   signal intRegAddr        : std_logic_vector(23 downto 0);
   signal intRegDataOut     : std_logic_vector(31 downto 0);
   signal intRegDataIn      : std_logic_vector(31 downto 0);
   signal intCmdEn          : std_logic;
   signal intCmdOpCode      : std_logic_vector(7  downto 0);
   signal intCmdCtxOut      : std_logic_vector(23 downto 0);
   signal scratchPad        : std_logic_vector(31 downto 0);
   signal countReset        : std_logic;
   signal dataOverFlow      : std_logic;
   signal intCmdAFull       : std_logic;
   signal intCmdFull        : std_logic;
   signal extCmdAFull       : std_logic;
   signal extCmdFull        : std_logic;
   signal pibError          : std_logic;
   signal txCount           : std_logic_vector(31 downto 0);
   signal pibLinkReady      : std_logic;
   signal pibFail           : std_logic;

   -- Register delay for simulation
   constant tpd:time := 0.5 ns;

begin

   -- Display values
   pgpDispB <= x"0" & txCount(3 downto 0);
   pgpDispA <= x"10" when pllLock      = '0' else  -- Display 'P'
               x"0F" when pibFail      = '1' else  -- Display 'F'
               x"11" when pibLinkReady = '0' else  -- Display 'N'
               x"0E" when pibError     = '1' else  -- Display 'E'
               x"12";                              -- Display 'L'
   
   -- Detect error status
   pibError <= '1' when (cntLinkError & cntCellError & cntNack) /= 0 else pgpSeqError;

   -- Transaction Counter
   process ( pgpClk, pgpReset ) begin
      if pgpReset = '1' then
         txCount <= (others=>'0') after tpd;
      elsif rising_edge(pgpClk) then
         if pibLinkReady = '0' then
            txCount <= (others=>'0') after tpd;
         else
            if (vc0FrameTxReady = '1' and vc0FrameTxEOF = '1') or
               (vc1FrameTxReady = '1' and vc1FrameTxEOF = '1') or
               (vc2FrameTxReady = '1' and vc2FrameTxEOF = '1') or
               (vc3FrameTxReady = '1' and vc3FrameTxEOF = '1') then
               txCount <= txCount + 1 after tpd;
            end if;
         end if;
      end if;
   end process;


   -- Register read and write
   process ( pgpClk, pgpReset ) begin
      if pgpReset = '1' then
         intRegDataIn <= (others=>'0') after tpd;
         intRegAck    <= '0'           after tpd;
         intRegFail   <= '0'           after tpd;
         scratchPad   <= (others=>'0') after tpd;
      elsif rising_edge(pgpClk) then

         -- Register request is pending
         if intRegReq = '1' then

            -- Drive ack
            intRegAck <= '1' after tpd;

            -- Read
            if intRegOp = '0' then

               -- Which register
               case intRegAddr is

                  when x"000000" =>
                     intRegDataIn <= FpgaVersion after tpd;
                     intRegFail   <= '0'         after tpd;

                  when x"000001" =>
                     intRegDataIn <= scratchPad after tpd;
                     intRegFail   <= '0'        after tpd;

                  when x"000002" =>
                     intRegDataIn(31)           <= '0'             after tpd;
                     intRegDataIn(30)           <= '0'             after tpd;
                     intRegDataIn(29)           <= mgtInverted     after tpd;
                     intRegDataIn(28)           <= pgpSeqError     after tpd;
                     intRegDataIn(27 downto 24) <= cntOverFlow     after tpd;
                     intRegDataIn(23 downto 20) <= cntPllLock      after tpd;
                     intRegDataIn(19 downto 16) <= cntLinkDown     after tpd;
                     intRegDataIn(15 downto 12) <= cntLinkError    after tpd;
                     intRegDataIn(11 downto  8) <= cntNack         after tpd;
                     intRegDataIn( 7 downto  4) <= cntCellError    after tpd;
                     intRegDataIn( 3 downto  0) <= "0000"          after tpd;
                     intRegFail                 <= '0'             after tpd;

                  when x"000003" =>
                     intRegDataIn               <= txCount         after tpd;
                     intRegFail                 <= '0'             after tpd;

                  when others =>
                     intRegFail   <= '1'           after tpd;
                     intRegDataIn <= (others=>'0') after tpd;
               end case;
            
            -- Write
            else

               -- Scratchpad write
               if intRegAddr = x"000001" then
                  intRegFail <= '0'           after tpd;
                  scratchPad <= intRegDataOut after tpd;
               else
                  intRegFail <= '1'           after tpd;
               end if;
            end if;
         
         -- No Request
         else
            intRegAck    <= '0'           after tpd;
            intRegFail   <= '0'           after tpd;
            intRegDataIn <= (others=>'0') after tpd;
         end if;
      end if;
   end process;


   -- Internal command receiver
   process ( pgpClk, pgpReset ) begin
      if pgpReset = '1' then
         countReset <= '0' after tpd;
         pibReLink  <= '0' after tpd;
         resetOut   <= '0' after tpd;
      elsif rising_edge(pgpClk) then

         -- Internal command received
         if intCmdEn = '1' then

            -- Reset
            if intCmdOpCode = "00000000" then
               resetOut   <= '1' after tpd;
               countReset <= '0' after tpd;
               pibReLink  <= '0' after tpd;

            -- Count Reset
            elsif intCmdOpCode = "00000001" then
               countReset <= '1' after tpd;
               pibReLink  <= '0' after tpd;

            -- PGP Relink
            elsif intCmdOpCode = "00000010" then
               countReset <= '0' after tpd;
               pibReLink  <= '1' after tpd;

            else
               countReset <= '0' after tpd;
               pibReLink  <= '0' after tpd;
            end if;
         else
            countReset <= '0' after tpd;
            pibReLink  <= '0' after tpd;
         end if;
      end if;
   end process;


   -- Error Counters
   process ( pgpClk, pgpReset ) begin
      if pgpReset = '1' then
         cntLinkError     <= (others=>'0') after tpd;
         cntNack          <= (others=>'0') after tpd;
         cntCellError     <= (others=>'0') after tpd;
         cntLinkDown      <= (others=>'0') after tpd;
         cntPllLock       <= (others=>'0') after tpd;
         cntOverFlow      <= (others=>'0') after tpd;
         pllLock          <= '0'           after tpd;
         pllLockDly       <= '0'           after tpd;
      elsif rising_edge(pgpClk) then

         -- Link Error Counter, 8-bits
         if countReset = '1' or pibLinkReady = '0' then
            cntLinkError <= (others=>'0') after tpd;
         elsif countLinkError = '1' and cntLinkError /= x"F" then
            cntLinkError <= cntLinkError + 1 after tpd;
         end if;
          
         -- Nack Counter, 8-bits
         if countReset = '1'  or pibLinkReady = '0' then
            cntNack <= (others=>'0') after tpd;
         elsif countNack = '1' and cntNack /= x"F" then
            cntNack <= cntNack + 1 after tpd;
         end if;

         -- Cell Error Counter, 8-bits
         if countReset = '1'  or pibLinkReady = '0' then
            cntCellError <= (others=>'0') after tpd;
         elsif countCellError = '1' and cntCellError /= x"F" then
            cntCellError <= cntCellError + 1 after tpd;
         end if;

         -- Link Down Counter, 8-bits
         if countReset = '1' then
            cntLinkDown <= (others=>'0') after tpd;
         elsif countLinkDown = '1' and cntLinkDown /= x"F" then
            cntLinkDown <= cntLinkDown + 1 after tpd;
         end if;

         -- PLL Unlock Counter
         if countReset = '1'  or pibLinkReady = '0' then
            cntPllLock <= (others=>'0') after tpd;
         elsif pllLock = '0' and pllLockDly = '1' and cntPllLock /= x"F" then
            cntPllLock <= cntPllLock + 1 after tpd;
         end if;

         -- PLL Lock Edge Detection
         pllLock    <= pibLock(1) and pibLock(0) after tpd;
         pllLockDly <= pllLock after tpd;

         -- Data overflow counter
         if countReset = '1' then
            cntOverFlow <= (others=>'0') after tpd;
         elsif dataOverFlow = '1'and cntOverFlow /= x"F" then
            cntOverFlow <= cntOverFlow + 1 after tpd;
         end if;

      end if;
   end process;


   -- PGP Wrap
   U_PgpMgtWrap: PgpMgtWrap 
      generic map ( MgtMode => MgtMode, AckTimeout => 8,
                    PicMode => 0,       RefClkSel  => RefClkSel,
                    CScopeEnPhy => "DISABLE" ) port map (
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
      localVersion      => open,               remoteVersion     => open,
      pibFail           => pibFail,            pibState          => pibState,
      pibLinkReady      => pibLinkReady,       pgpSeqError       => pgpSeqError,
      countLinkDown     => countLinkDown,      countLinkError    => countLinkError,
      countNack         => countNack,          countCellError    => countCellError,     
      mgtDAddr          => (others=>'0'),      mgtDClk           => '0',
      mgtDEn            => '0',                mgtDI             => (others=>'0'),
      mgtDO             => open,               mgtDRdy           => open,
      mgtDWe            => '0',                mgtLoopback       => '0',
      mgtInverted       => mgtInverted,        mgtRefClk1        => pgpRefClk1,
      mgtRefClk2        => pgpRefClk2,         mgtRxN            => mgtRxN,
      mgtRxP            => mgtRxP,             mgtTxN            => mgtTxN,
      mgtTxP            => mgtTxP,             mgtCombusIn       => mgtCombusIn,
      mgtCombusOut      => mgtCombusOut,       pibLock           => pibLock,
      mgtRxRecClk       => mgtRxRecClk
   );


   -- VC0, External command processor
   U_ExtCmd: PgpCmdSlave 
      generic map ( 
         DestId    => 0,
         DestMask  => 1,
         AsyncFIFO => "TRUE"
      ) port map ( 
         pgpClk         => pgpClk,          pgpReset       => pgpReset,
         locClk         => locClk,          locReset       => locReset,
         vcFrameRxValid => vc0FrameRxValid, vcFrameRxSOF   => vc0FrameRxSOF,
         vcFrameRxWidth => vc0FrameRxWidth, vcFrameRxEOF   => vc0FrameRxEOF,
         vcFrameRxEOFE  => vc0FrameRxEOFE,  vcFrameRxData  => vc0FrameRxData,
         vcLocBuffAFull => extCmdAFull,     vcLocBuffFull  => extCmdFull,
         cmdEn          => cmdEn,           cmdOpCode      => cmdOpCode,
         cmdCtxOut      => cmdCtxOut
      );


   -- VC0, Internal command processor
   U_IntCmd: PgpCmdSlave
      generic map ( 
         DestId    => 1,
         DestMask  => 1,
         AsyncFIFO => "FALSE"
      ) port map ( 
         pgpClk         => pgpClk,          pgpReset       => pgpReset,
         locClk         => pgpClk,          locReset       => pgpReset,
         vcFrameRxValid => vc0FrameRxValid, vcFrameRxSOF   => vc0FrameRxSOF,
         vcFrameRxWidth => vc0FrameRxWidth, vcFrameRxEOF   => vc0FrameRxEOF,
         vcFrameRxEOFE  => vc0FrameRxEOFE,  vcFrameRxData  => vc0FrameRxData,
         vcLocBuffAFull => intCmdAFull,     vcLocBuffFull  => intCmdFull,
         cmdEn          => intCmdEn,        cmdOpCode      => intCmdOpCode,
         cmdCtxOut      => intCmdCtxOut
      );

   -- Generate flow control
   vc0LocBuffAFull <= extCmdAFull or intCmdAFull;
   vc0LocBuffFull  <= extCmdFull  or intCmdFull;


   -- Return data, VC0
   U_DataBuff: PgpDataBuffer port map (
      pgpClk          => pgpClk,           pgpReset        => pgpReset,
      locClk          => locClk,           locReset        => locReset,
      frameTxEnable   => frameTxEnable,    frameTxSOF      => frameTxSOF,
      frameTxEOF      => frameTxEOF,       frameTxEOFE     => frameTxEOFE,
      frameTxData     => frameTxData,      frameTxAFull    => frameTxAFull,
      vcFrameTxValid  => vc0FrameTxValid,
      vcFrameTxReady  => vc0FrameTxReady,  vcFrameTxSOF    => vc0FrameTxSOF,
      vcFrameTxWidth  => vc0FrameTxWidth,  vcFrameTxEOF    => vc0FrameTxEOF,
      vcFrameTxEOFE   => vc0FrameTxEOFE,   vcFrameTxData   => vc0FrameTxData,
      vcFrameTxCid    => vc0FrameTxCid,    vcFrameTxAckCid => vc0FrameTxAckCid,
      vcFrameTxAckEn  => vc0FrameTxAckEn,  vcFrameTxAck    => vc0FrameTxAck,
      vcRemBuffAFull  => vc0RemBuffAFull,  vcRemBuffFull   => vc0RemBuffFull,
      dataOverFlow    => dataOverFlow
   );

   valid<=vc0FrameTxValid;
   eof<=vc0FrameTxEOF;
   sof<=vc0FrameTxSOF;

   -- VC1, External register access control
   U_ExtReg: PgpRegSlave generic map ( AsyncFIFO => "TRUE" ) port map (
      pgpClk          => pgpClk,           pgpReset        => pgpReset,
      locClk          => locClk,           locReset        => locReset,
      vcFrameRxValid  => vc1FrameRxValid,  vcFrameRxSOF    => vc1FrameRxSOF,
      vcFrameRxWidth  => vc1FrameRxWidth,  vcFrameRxEOF    => vc1FrameRxEOF,
      vcFrameRxEOFE   => vc1FrameRxEOFE,   vcFrameRxData   => vc1FrameRxData,
      vcLocBuffAFull  => vc1LocBuffAFull,  vcLocBuffFull   => vc1LocBuffFull,
      vcFrameTxValid  => vc1FrameTxValid,  vcFrameTxReady  => vc1FrameTxReady,
      vcFrameTxSOF    => vc1FrameTxSOF,    vcFrameTxWidth  => vc1FrameTxWidth,
      vcFrameTxEOF    => vc1FrameTxEOF,    vcFrameTxEOFE   => vc1FrameTxEOFE,
      vcFrameTxData   => vc1FrameTxData,   vcFrameTxCid    => vc1FrameTxCid,
      vcFrameTxAckCid => vc1FrameTxAckCid, vcFrameTxAckEn  => vc1FrameTxAckEn,
      vcFrameTxAck    => vc1FrameTxAck,    vcRemBuffAFull  => vc1RemBuffAFull,
      vcRemBuffFull   => vc1RemBuffFull,   regReq          => regReq,
      regOp           => regOp,            regAck          => regAck,
      regFail         => regFail,          regAddr         => regAddr,
      regDataOut      => regDataOut,       regDataIn       => regDataIn,
      regInp          => regInp
   );


   -- VC2, Internal register access control
   U_IntReg: PgpRegSlave generic map ( AsyncFIFO => "FALSE" ) port map (
      pgpClk          => pgpClk,           pgpReset        => pgpReset,
      locClk          => pgpClk,           locReset        => pgpReset,
      vcFrameRxValid  => vc2FrameRxValid,  vcFrameRxSOF    => vc2FrameRxSOF,
      vcFrameRxWidth  => vc2FrameRxWidth,  vcFrameRxEOF    => vc2FrameRxEOF,
      vcFrameRxEOFE   => vc2FrameRxEOFE,   vcFrameRxData   => vc2FrameRxData,
      vcLocBuffAFull  => vc2LocBuffAFull,  vcLocBuffFull   => vc2LocBuffFull,
      vcFrameTxValid  => vc2FrameTxValid,  vcFrameTxReady  => vc2FrameTxReady,
      vcFrameTxSOF    => vc2FrameTxSOF,    vcFrameTxWidth  => vc2FrameTxWidth,
      vcFrameTxEOF    => vc2FrameTxEOF,    vcFrameTxEOFE   => vc2FrameTxEOFE,
      vcFrameTxData   => vc2FrameTxData,   vcFrameTxCid    => vc2FrameTxCid,
      vcFrameTxAckCid => vc2FrameTxAckCid, vcFrameTxAckEn  => vc2FrameTxAckEn,
      vcFrameTxAck    => vc2FrameTxAck,    vcRemBuffAFull  => vc2RemBuffAFull,
      vcRemBuffFull   => vc2RemBuffFull,   regReq          => intRegReq,
      regOp           => intRegOp,         regAck          => intRegAck,
      regFail         => intRegFail,       regAddr         => intRegAddr,
      regDataOut      => intRegDataOut,    regDataIn       => intRegDataIn
   );

   -- VC3, Downstream data
   U_DsBuff: PgpDsBuff port map (
      pgpClk           => pgpClk,
      pgpReset         => pgpReset,
      locClk           => locClk,
      locReset         => locReset,
      vcFrameRxValid   => vc3FrameRxValid,
      vcFrameRxSOF     => vc3FrameRxSOF,
      vcFrameRxWidth   => vc3FrameRxWidth,
      vcFrameRxEOF     => vc3FrameRxEOF,
      vcFrameRxEOFE    => vc3FrameRxEOFE,
      vcFrameRxData    => vc3FrameRxData,
      vcLocBuffAFull   => vc3LocBuffAFull,
      vcLocBuffFull    => vc3LocBuffFull,
      frameRxValid     => frameRxValid,
      frameRxReady     => frameRxReady,
      frameRxSOF       => frameRxSOF,
      frameRxEOF       => frameRxEOF,
      frameRxEOFE      => frameRxEOFE,
      frameRxData      => frameRxData
   );

   -- VC3 transmit is unused
   vc3FrameTxValid <= '0';
   vc3FrameTxEOFE  <= '0';
   vc3FrameTxEOF   <= '0';
   vc3FrameTxWidth <= '0';
   vc3FrameTxSOF   <= '0';
   vc3FrameTxData  <= (others=>'0');
   vc3FrameTxCid   <= (others=>'0');

end PgpFrontEnd;

