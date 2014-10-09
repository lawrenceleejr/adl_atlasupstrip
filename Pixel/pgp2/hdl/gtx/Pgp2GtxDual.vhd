-------------------------------------------------------------------------------
-- Title         : Pretty Good Protocol, V2, Dual Channel GTX Wrapper
-- Project       : General Purpose Core
-------------------------------------------------------------------------------
-- File          : Pgp2GtxDual.vhd
-- Author        : Ryan Herbst, rherbst@slac.stanford.edu
-- Created       : 09/24/2010
-------------------------------------------------------------------------------
-- Description:
-- VHDL source file containing the PGP, GTX and CRC blocks.
-- This module also contains the logic to control the reset of the GTX.
-------------------------------------------------------------------------------
-- Copyright (c) 2006 by Ryan Herbst. All rights reserved.
-------------------------------------------------------------------------------
-- Modification history:
-- 09/24/2010: created.
-------------------------------------------------------------------------------

LIBRARY ieee;
use work.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.Pgp2GtxPackage.all;
use work.Pgp2CorePackage.all;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;


entity Pgp2GtxDual is 
   generic (
      EnShortCells : integer := 1;         -- Enable short non-EOF cells
      VcInterleave : integer := 1          -- Interleave Frames
   );
   port (

      -- System clock, reset & control
      pgpClk             : in  std_logic;                     -- Pgp master clock
      pgpReset           : in  std_logic;                     -- Synchronous reset input
      pgpFlush           : in  std_logic;                     -- Frame state flash

      -- PLL Reset Control
      pll0TxRst          : in  std_logic;                     -- Reset transmit PLL logic
      pll0RxRst          : in  std_logic;                     -- Reset receive  PLL logic

      -- PLL Lock Status
      pll0RxReady        : out std_logic;                     -- MGT Receive logic is ready
      pll0TxReady        : out std_logic;                     -- MGT Transmit logic is ready

      -- Sideband data
      pgp0RemData        : out std_logic_vector(7 downto 0);  -- Far end side User Data
      pgp0LocData        : in  std_logic_vector(7 downto 0);  -- Far end side User Data

      -- Opcode Transmit Interface
      pgp0TxOpCodeEn     : in  std_logic;                     -- Opcode receive enable
      pgp0TxOpCode       : in  std_logic_vector(7 downto 0);  -- Opcode receive value

      -- Opcode Receive Interface
      pgp0RxOpCodeEn     : out std_logic;                     -- Opcode receive enable
      pgp0RxOpCode       : out std_logic_vector(7 downto 0);  -- Opcode receive value

      -- Link status
      pgp0LocLinkReady   : out std_logic;                     -- Local Link is ready
      pgp0RemLinkReady   : out std_logic;                     -- Far end side has link

      -- Error Flags, one pulse per event
      pgp0RxCellError    : out std_logic;                     -- A cell error has occured
      pgp0RxLinkDown     : out std_logic;                     -- A link down event has occured
      pgp0RxLinkError    : out std_logic;                     -- A link error has occured

      -- Frame Transmit Interface, VC 0
      vc00FrameTxValid   : in  std_logic;                     -- User frame data is valid
      vc00FrameTxReady   : out std_logic;                     -- PGP is ready
      vc00FrameTxSOF     : in  std_logic;                     -- User frame data start of frame
      vc00FrameTxEOF     : in  std_logic;                     -- User frame data end of frame
      vc00FrameTxEOFE    : in  std_logic;                     -- User frame data error
      vc00FrameTxData    : in  std_logic_vector(15 downto 0); -- User frame data
      vc00LocBuffAFull   : in  std_logic;                     -- Local buffer almost full
      vc00LocBuffFull    : in  std_logic;                     -- Local buffer full

      -- Frame Transmit Interface, VC 1
      vc01FrameTxValid   : in  std_logic;                     -- User frame data is valid
      vc01FrameTxReady   : out std_logic;                     -- PGP is ready
      vc01FrameTxSOF     : in  std_logic;                     -- User frame data start of frame
      vc01FrameTxEOF     : in  std_logic;                     -- User frame data end of frame
      vc01FrameTxEOFE    : in  std_logic;                     -- User frame data error
      vc01FrameTxData    : in  std_logic_vector(15 downto 0); -- User frame data
      vc01LocBuffAFull   : in  std_logic;                     -- Local buffer almost full
      vc01LocBuffFull    : in  std_logic;                     -- Local buffer full

      -- Frame Transmit Interface, VC 2
      vc02FrameTxValid   : in  std_logic;                     -- User frame data is valid
      vc02FrameTxReady   : out std_logic;                     -- PGP is ready
      vc02FrameTxSOF     : in  std_logic;                     -- User frame data start of frame
      vc02FrameTxEOF     : in  std_logic;                     -- User frame data end of frame
      vc02FrameTxEOFE    : in  std_logic;                     -- User frame data error
      vc02FrameTxData    : in  std_logic_vector(15 downto 0); -- User frame data
      vc02LocBuffAFull   : in  std_logic;                     -- Local buffer almost full
      vc02LocBuffFull    : in  std_logic;                     -- Local buffer full

      -- Frame Transmit Interface, VC 3
      vc03FrameTxValid   : in  std_logic;                     -- User frame data is valid
      vc03FrameTxReady   : out std_logic;                     -- PGP is ready
      vc03FrameTxSOF     : in  std_logic;                     -- User frame data start of frame
      vc03FrameTxEOF     : in  std_logic;                     -- User frame data end of frame
      vc03FrameTxEOFE    : in  std_logic;                     -- User frame data error
      vc03FrameTxData    : in  std_logic_vector(15 downto 0); -- User frame data
      vc03LocBuffAFull   : in  std_logic;                     -- Local buffer almost full
      vc03LocBuffFull    : in  std_logic;                     -- Local buffer full

      -- Common Frame Receive Interface For All VCs
      vc0FrameRxSOF      : out std_logic;                     -- PGP frame data start of frame
      vc0FrameRxEOF      : out std_logic;                     -- PGP frame data end of frame
      vc0FrameRxEOFE     : out std_logic;                     -- PGP frame data error
      vc0FrameRxData     : out std_logic_vector(15 downto 0); -- PGP frame data

      -- Frame Receive Interface, VC 0
      vc00FrameRxValid   : out std_logic;                     -- PGP frame data is valid
      vc00RemBuffAFull   : out std_logic;                     -- Remote buffer almost full
      vc00RemBuffFull    : out std_logic;                     -- Remote buffer full

      -- Frame Receive Interface, VC 1
      vc01FrameRxValid   : out std_logic;                     -- PGP frame data is valid
      vc01RemBuffAFull   : out std_logic;                     -- Remote buffer almost full
      vc01RemBuffFull    : out std_logic;                     -- Remote buffer full

      -- Frame Receive Interface, VC 2
      vc02FrameRxValid   : out std_logic;                     -- PGP frame data is valid
      vc02RemBuffAFull   : out std_logic;                     -- Remote buffer almost full
      vc02RemBuffFull    : out std_logic;                     -- Remote buffer full

      -- Frame Receive Interface, VC 3
      vc03FrameRxValid   : out std_logic;                     -- PGP frame data is valid
      vc03RemBuffAFull   : out std_logic;                     -- Remote buffer almost full
      vc03RemBuffFull    : out std_logic;                     -- Remote buffer full

      -- PLL Reset Control
      pll1TxRst          : in  std_logic;                     -- Reset transmit PLL logic
      pll1RxRst          : in  std_logic;                     -- Reset receive  PLL logic

      -- PLL Lock Status
      pll1RxReady        : out std_logic;                     -- MGT Receive logic is ready
      pll1TxReady        : out std_logic;                     -- MGT Transmit logic is ready

      -- Sideband data
      pgp1RemData        : out std_logic_vector(7 downto 0);  -- Far end side User Data
      pgp1LocData        : in  std_logic_vector(7 downto 0);  -- Far end side User Data

      -- Opcode Transmit Interface
      pgp1TxOpCodeEn     : in  std_logic;                     -- Opcode receive enable
      pgp1TxOpCode       : in  std_logic_vector(7 downto 0);  -- Opcode receive value

      -- Opcode Receive Interface
      pgp1RxOpCodeEn     : out std_logic;                     -- Opcode receive enable
      pgp1RxOpCode       : out std_logic_vector(7 downto 0);  -- Opcode receive value

      -- Link status
      pgp1LocLinkReady   : out std_logic;                     -- Local Link is ready
      pgp1RemLinkReady   : out std_logic;                     -- Far end side has link

      -- Error Flags, one pulse per event
      pgp1RxCellError    : out std_logic;                     -- A cell error has occured
      pgp1RxLinkDown     : out std_logic;                     -- A link down event has occured
      pgp1RxLinkError    : out std_logic;                     -- A link error has occured

      -- Frame Transmit Interface, VC 0
      vc10FrameTxValid   : in  std_logic;                     -- User frame data is valid
      vc10FrameTxReady   : out std_logic;                     -- PGP is ready
      vc10FrameTxSOF     : in  std_logic;                     -- User frame data start of frame
      vc10FrameTxEOF     : in  std_logic;                     -- User frame data end of frame
      vc10FrameTxEOFE    : in  std_logic;                     -- User frame data error
      vc10FrameTxData    : in  std_logic_vector(15 downto 0); -- User frame data
      vc10LocBuffAFull   : in  std_logic;                     -- Local buffer almost full
      vc10LocBuffFull    : in  std_logic;                     -- Local buffer full

      -- Frame Transmit Interface, VC 1
      vc11FrameTxValid   : in  std_logic;                     -- User frame data is valid
      vc11FrameTxReady   : out std_logic;                     -- PGP is ready
      vc11FrameTxSOF     : in  std_logic;                     -- User frame data start of frame
      vc11FrameTxEOF     : in  std_logic;                     -- User frame data end of frame
      vc11FrameTxEOFE    : in  std_logic;                     -- User frame data error
      vc11FrameTxData    : in  std_logic_vector(15 downto 0); -- User frame data
      vc11LocBuffAFull   : in  std_logic;                     -- Local buffer almost full
      vc11LocBuffFull    : in  std_logic;                     -- Local buffer full

      -- Frame Transmit Interface, VC 2
      vc12FrameTxValid   : in  std_logic;                     -- User frame data is valid
      vc12FrameTxReady   : out std_logic;                     -- PGP is ready
      vc12FrameTxSOF     : in  std_logic;                     -- User frame data start of frame
      vc12FrameTxEOF     : in  std_logic;                     -- User frame data end of frame
      vc12FrameTxEOFE    : in  std_logic;                     -- User frame data error
      vc12FrameTxData    : in  std_logic_vector(15 downto 0); -- User frame data
      vc12LocBuffAFull   : in  std_logic;                     -- Local buffer almost full
      vc12LocBuffFull    : in  std_logic;                     -- Local buffer full

      -- Frame Transmit Interface, VC 3
      vc13FrameTxValid   : in  std_logic;                     -- User frame data is valid
      vc13FrameTxReady   : out std_logic;                     -- PGP is ready
      vc13FrameTxSOF     : in  std_logic;                     -- User frame data start of frame
      vc13FrameTxEOF     : in  std_logic;                     -- User frame data end of frame
      vc13FrameTxEOFE    : in  std_logic;                     -- User frame data error
      vc13FrameTxData    : in  std_logic_vector(15 downto 0); -- User frame data
      vc13LocBuffAFull   : in  std_logic;                     -- Local buffer almost full
      vc13LocBuffFull    : in  std_logic;                     -- Local buffer full

      -- Common Frame Receive Interface For All VCs
      vc1FrameRxSOF      : out std_logic;                     -- PGP frame data start of frame
      vc1FrameRxEOF      : out std_logic;                     -- PGP frame data end of frame
      vc1FrameRxEOFE     : out std_logic;                     -- PGP frame data error
      vc1FrameRxData     : out std_logic_vector(15 downto 0); -- PGP frame data

      -- Frame Receive Interface, VC 0
      vc10FrameRxValid   : out std_logic;                     -- PGP frame data is valid
      vc10RemBuffAFull   : out std_logic;                     -- Remote buffer almost full
      vc10RemBuffFull    : out std_logic;                     -- Remote buffer full

      -- Frame Receive Interface, VC 1
      vc11FrameRxValid   : out std_logic;                     -- PGP frame data is valid
      vc11RemBuffAFull   : out std_logic;                     -- Remote buffer almost full
      vc11RemBuffFull    : out std_logic;                     -- Remote buffer full

      -- Frame Receive Interface, VC 2
      vc12FrameRxValid   : out std_logic;                     -- PGP frame data is valid
      vc12RemBuffAFull   : out std_logic;                     -- Remote buffer almost full
      vc12RemBuffFull    : out std_logic;                     -- Remote buffer full

      -- Frame Receive Interface, VC 3
      vc13FrameRxValid   : out std_logic;                     -- PGP frame data is valid
      vc13RemBuffAFull   : out std_logic;                     -- Remote buffer almost full
      vc13RemBuffFull    : out std_logic;                     -- Remote buffer full

      -- GTX Status & Control Signals
      gtxLoopback        : in  std_logic_vector(1 downto 0);  -- GTX Serial Loopback Control

      -- MGT Signals Clock & IO Signals
      gtxClkIn           : in  std_logic;                     -- GTX Reference Clock In
      gtxRefClkOut       : out std_logic;                     -- GTX Reference Clock Output
      gtxRxRecClk        : out std_logic_vector(1 downto 0);  -- GTX Rx Recovered Clock
      gtxRxN             : in  std_logic_vector(1 downto 0);  -- GTX Serial Receive Negative
      gtxRxP             : in  std_logic_vector(1 downto 0);  -- GTX Serial Receive Positive
      gtxTxN             : out std_logic_vector(1 downto 0);  -- GTX Serial Transmit Negative
      gtxTxP             : out std_logic_vector(1 downto 0);  -- GTX Serial Transmit Positive

      -- Debug
      debug              : out std_logic_vector(127 downto 0)
   );

end Pgp2GtxDual;


-- Define architecture
architecture Pgp2GtxDual of Pgp2GtxDual is

   -- Local Signals
   signal crc0TxIn           : std_logic_vector(15 downto 0);
   signal crc0TxInGtx        : std_logic_vector(31 downto 0);
   signal crc0TxInit         : std_logic;
   signal crc0TxRst          : std_logic;
   signal crc0TxValid        : std_logic;
   signal crc0TxWidth        : std_logic_vector(2  downto 0);
   signal crc0TxOut          : std_logic_vector(31 downto 0);
   signal crc0TxOutGtx       : std_logic_vector(31 downto 0);
   signal crc0RxIn           : std_logic_vector(15 downto 0);
   signal crc0RxInGtx        : std_logic_vector(31 downto 0);
   signal crc0RxInit         : std_logic;
   signal crc0RxRst          : std_logic;
   signal crc0RxValid        : std_logic;
   signal crc0RxWidth        : std_logic_vector(2  downto 0);
   signal crc0RxOut          : std_logic_vector(31 downto 0);
   signal crc0RxOutGtx       : std_logic_vector(31 downto 0);
   signal phy0RxPolarity     : std_logic_vector(0  downto 0);
   signal phy0RxData         : std_logic_vector(15 downto 0);
   signal phy0RxDataK        : std_logic_vector(1  downto 0);
   signal phy0TxData         : std_logic_vector(15 downto 0);
   signal phy0TxDataK        : std_logic_vector(1  downto 0);
   signal phy0RxDispErr      : std_logic_vector(1  downto 0);
   signal phy0RxDecErr       : std_logic_vector(1  downto 0);
   signal phy0RxReady        : std_logic;
   signal phy0RxInit         : std_logic;
   signal phy0TxReady        : std_logic;
   signal phy0RxReset        : std_logic;
   signal phy0RxElecIdle     : std_logic;
   signal phy0RxCdrReset     : std_logic;
   signal phy0RstDone        : std_logic;
   signal phy0RxBuffStatus   : std_logic_vector(2  downto 0);
   signal phy0TxReset        : std_logic;
   signal phy0TxBuffStatus   : std_logic_vector(1  downto 0);
   signal phyLockDetect      : std_logic;
   signal int0TxRst          : std_logic;
   signal int0RxRst          : std_logic;
   signal pgp0RxLinkReady    : std_logic;
   signal pgp0TxLinkReady    : std_logic;
   signal crc1TxIn           : std_logic_vector(15 downto 0);
   signal crc1TxInGtx        : std_logic_vector(31 downto 0);
   signal crc1TxInit         : std_logic;
   signal crc1TxRst          : std_logic;
   signal crc1TxValid        : std_logic;
   signal crc1TxWidth        : std_logic_vector(2  downto 0);
   signal crc1TxOut          : std_logic_vector(31 downto 0);
   signal crc1TxOutGtx       : std_logic_vector(31 downto 0);
   signal crc1RxIn           : std_logic_vector(15 downto 0);
   signal crc1RxInGtx        : std_logic_vector(31 downto 0);
   signal crc1RxInit         : std_logic;
   signal crc1RxRst          : std_logic;
   signal crc1RxValid        : std_logic;
   signal crc1RxWidth        : std_logic_vector(2  downto 0);
   signal crc1RxOut          : std_logic_vector(31 downto 0);
   signal crc1RxOutGtx       : std_logic_vector(31 downto 0);
   signal phy1RxPolarity     : std_logic_vector(0  downto 0);
   signal phy1RxData         : std_logic_vector(15 downto 0);
   signal phy1RxDataK        : std_logic_vector(1  downto 0);
   signal phy1TxData         : std_logic_vector(15 downto 0);
   signal phy1TxDataK        : std_logic_vector(1  downto 0);
   signal phy1RxDispErr      : std_logic_vector(1  downto 0);
   signal phy1RxDecErr       : std_logic_vector(1  downto 0);
   signal phy1RxReady        : std_logic;
   signal phy1RxInit         : std_logic;
   signal phy1TxReady        : std_logic;
   signal phy1RxReset        : std_logic;
   signal phy1RxElecIdle     : std_logic;
   signal phy1RxCdrReset     : std_logic;
   signal phy1RstDone        : std_logic;
   signal phy1RxBuffStatus   : std_logic_vector(2  downto 0);
   signal phy1TxReset        : std_logic;
   signal phy1TxBuffStatus   : std_logic_vector(1  downto 0);
   signal int1TxRst          : std_logic;
   signal int1RxRst          : std_logic;
   signal pgp1RxLinkReady    : std_logic;
   signal pgp1TxLinkReady    : std_logic;
   signal intRxRecClk       : std_logic;
   signal tmpRefClkOut      : std_logic;

   -- Register delay for simulation
   constant tpd:time := 0.5 ns;

begin

   ------------------------------------------
   -- PGP Lane 0
   ------------------------------------------

   -- PGP RX Block
   U_Pgp2Rx0: Pgp2CorePackage.Pgp2Rx 
      generic map (
         RxLaneCnt    => 1,
         EnShortCells => EnShortCells
      ) port map (
         pgpRxClk          => pgpClk,
         pgpRxReset        => pgpReset,
         pgpRxFlush        => pgpFlush,
         pgpRxLinkReady    => pgp0RxLinkReady,
         pgpRxCellError    => pgp0RxCellError,
         pgpRxLinkDown     => pgp0RxLinkDown,
         pgpRxLinkError    => pgp0RxLinkError,
         pgpRxOpCodeEn     => pgp0RxOpCodeEn,
         pgpRxOpCode       => pgp0RxOpCode,
         pgpRemLinkReady   => pgp0RemLinkReady,
         pgpRemData        => pgp0RemData,
         vcFrameRxSOF      => vc0FrameRxSOF,
         vcFrameRxEOF      => vc0FrameRxEOF,
         vcFrameRxEOFE     => vc0FrameRxEOFE,
         vcFrameRxData     => vc0FrameRxData,
         vc0FrameRxValid   => vc00FrameRxValid,
         vc0RemBuffAFull   => vc00RemBuffAFull,
         vc0RemBuffFull    => vc00RemBuffFull,
         vc1FrameRxValid   => vc01FrameRxValid,
         vc1RemBuffAFull   => vc01RemBuffAFull,
         vc1RemBuffFull    => vc01RemBuffFull,
         vc2FrameRxValid   => vc02FrameRxValid,
         vc2RemBuffAFull   => vc02RemBuffAFull,
         vc2RemBuffFull    => vc02RemBuffFull,
         vc3FrameRxValid   => vc03FrameRxValid,
         vc3RemBuffAFull   => vc03RemBuffAFull,
         vc3RemBuffFull    => vc03RemBuffFull,
         phyRxPolarity     => phy0RxPolarity,
         phyRxData         => phy0RxData,
         phyRxDataK        => phy0RxDataK,
         phyRxDispErr      => phy0RxDispErr,
         phyRxDecErr       => phy0RxDecErr,
         phyRxReady        => phy0RxReady,
         phyRxInit         => phy0RxInit,
         crcRxIn           => crc0RxIn,
         crcRxWidth        => open,
         crcRxInit         => crc0RxInit,
         crcRxValid        => crc0RxValid,
         crcRxOut          => crc0RxOut,
         debug             => debug(63 downto 0)
      );


   -- PGP TX Block
   U_Pgp2Tx0: Pgp2CorePackage.Pgp2Tx 
      generic map (
         TxLaneCnt    => 1,
         VcInterleave => VcInterleave
      ) port map ( 
         pgpTxClk          => pgpClk,
         pgpTxReset        => pgpReset,
         pgpTxFlush        => pgpFlush,
         pgpTxLinkReady    => pgp0TxLinkReady,
         pgpTxOpCodeEn     => pgp0TxOpCodeEn,
         pgpTxOpCode       => pgp0TxOpCode,
         pgpLocLinkReady   => pgp0RxLinkReady,
         pgpLocData        => pgp0LocData,
         vc0FrameTxValid   => vc00FrameTxValid,
         vc0FrameTxReady   => vc00FrameTxReady,
         vc0FrameTxSOF     => vc00FrameTxSOF,
         vc0FrameTxEOF     => vc00FrameTxEOF,
         vc0FrameTxEOFE    => vc00FrameTxEOFE,
         vc0FrameTxData    => vc00FrameTxData,
         vc0LocBuffAFull   => vc00LocBuffAFull,
         vc0LocBuffFull    => vc00LocBuffFull,
         vc1FrameTxValid   => vc01FrameTxValid,
         vc1FrameTxReady   => vc01FrameTxReady,
         vc1FrameTxSOF     => vc01FrameTxSOF,
         vc1FrameTxEOF     => vc01FrameTxEOF,
         vc1FrameTxEOFE    => vc01FrameTxEOFE,
         vc1FrameTxData    => vc01FrameTxData,
         vc1LocBuffAFull   => vc01LocBuffAFull,
         vc1LocBuffFull    => vc01LocBuffFull,
         vc2FrameTxValid   => vc02FrameTxValid,
         vc2FrameTxReady   => vc02FrameTxReady,
         vc2FrameTxSOF     => vc02FrameTxSOF,
         vc2FrameTxEOF     => vc02FrameTxEOF,
         vc2FrameTxEOFE    => vc02FrameTxEOFE,
         vc2FrameTxData    => vc02FrameTxData,
         vc2LocBuffAFull   => vc02LocBuffAFull,
         vc2LocBuffFull    => vc02LocBuffFull,
         vc3FrameTxValid   => vc03FrameTxValid,
         vc3FrameTxReady   => vc03FrameTxReady,
         vc3FrameTxSOF     => vc03FrameTxSOF,
         vc3FrameTxEOF     => vc03FrameTxEOF,
         vc3FrameTxEOFE    => vc03FrameTxEOFE,
         vc3FrameTxData    => vc03FrameTxData,
         vc3LocBuffAFull   => vc03LocBuffAFull,
         vc3LocBuffFull    => vc03LocBuffFull,
         phyTxData         => phy0TxData,
         phyTxDataK        => phy0TxDataK,
         phyTxReady        => phy0TxReady,
         crcTxIn           => crc0TxIn,
         crcTxInit         => crc0TxInit,
         crcTxValid        => crc0TxValid,
         crcTxOut          => crc0TxOut,
         debug             => open
      );


   -- Adapt CRC data width flag
   crc0TxWidth <= "001";
   crc0RxWidth <= "001";
   crc0RxRst   <= int0RxRst or crc0RxInit;
   crc0TxRst   <= int0TxRst or crc0TxInit;

   -- Pass CRC data in on proper bits
   crc0TxInGtx(31 downto 24) <= crc0TxIn(7  downto 0);
   crc0TxInGtx(23 downto 16) <= crc0TxIn(15 downto 8);
   crc0TxInGtx(15 downto  0) <= (others=>'0');
   crc0RxInGtx(31 downto 24) <= crc0RxIn(7  downto 0);
   crc0RxInGtx(23 downto 16) <= crc0RxIn(15 downto 8);
   crc0RxInGtx(15 downto  0) <= (others=>'0');

   -- Pll Resets
   int0TxRst <= pll0TxRst or pgpReset;
   int0RxRst <= pll0RxRst or pgpReset;

   -- PLL Lock
   pll0RxReady <= phy0RxReady;
   pll0TxReady <= phy0TxReady;

   -- Link Ready
   pgp0LocLinkReady <= pgp0RxLinkReady and pgp0TxLinkReady;

   -- Invert Output CRC
   crc0RxOut <= not crc0RxOutGtx;
   crc0TxOut <= not crc0TxOutGtx;


   -- TX CRC BLock
   Tx_CRC0: CRC32 
      generic map(
         CRC_INIT   => x"FFFFFFFF"
      ) port map(
         CRCOUT       => crc0TxOutGtx,
         CRCCLK       => pgpClk,
         CRCDATAVALID => crc0TxValid,
         CRCDATAWIDTH => crc0TxWidth,
         CRCIN        => crc0TxInGtx,
         CRCRESET     => crc0TxRst
      );


   -- RX CRC BLock
   Rx_CRC0: CRC32 
      generic map(
         CRC_INIT   => x"FFFFFFFF"
      ) port map(
         CRCOUT       => crc0RxOutGtx,
         CRCCLK       => pgpClk,
         CRCDATAVALID => crc0RxValid,
         CRCDATAWIDTH => crc0RxWidth,
         CRCIN        => crc0RxInGtx,
         CRCRESET     => crc0RxRst 
      );


   -- RX Reset Control
   U_Pgp2GtxRxRst0: Pgp2GtxPackage.Pgp2GtxRxRst
      port map (
         gtxRxClk          => pgpClk,
         gtxRxRst          => int0RxRst,
         gtxRxReady        => phy0RxReady,
         gtxRxInit         => phy0RxInit,
         gtxLockDetect     => phyLockDetect,
         gtxRxElecIdle     => phy0RxElecIdle,
         gtxRxBuffStatus   => phy0RxBuffStatus,
         gtxRstDone        => phy0RstDone,
         gtxRxReset        => phy0RxReset,
         gtxRxCdrReset     => phy0RxCdrReset
      );


   -- TX Reset Control
   U_Pgp2GtxTxRst0: Pgp2GtxPackage.Pgp2GtxTxRst
      port map (
         gtxTxClk          => pgpClk,
         gtxTxRst          => int0TxRst,
         gtxTxReady        => phy0TxReady,
         gtxLockDetect     => phyLockDetect,
         gtxTxBuffStatus   => phy0TxBuffStatus,
         gtxRstDone        => phy0RstDone,
         gtxTxReset        => phy0TxReset
      );


   ------------------------------------------
   -- PGP Lane 1
   ------------------------------------------

   -- PGP RX Block
   U_Pgp2Rx1: Pgp2CorePackage.Pgp2Rx 
      generic map (
         RxLaneCnt    => 1,
         EnShortCells => EnShortCells
      ) port map (
         pgpRxClk          => pgpClk,
         pgpRxReset        => pgpReset,
         pgpRxFlush        => pgpFlush,
         pgpRxLinkReady    => pgp1RxLinkReady,
         pgpRxCellError    => pgp1RxCellError,
         pgpRxLinkDown     => pgp1RxLinkDown,
         pgpRxLinkError    => pgp1RxLinkError,
         pgpRxOpCodeEn     => pgp1RxOpCodeEn,
         pgpRxOpCode       => pgp1RxOpCode,
         pgpRemLinkReady   => pgp1RemLinkReady,
         pgpRemData        => pgp1RemData,
         vcFrameRxSOF      => vc1FrameRxSOF,
         vcFrameRxEOF      => vc1FrameRxEOF,
         vcFrameRxEOFE     => vc1FrameRxEOFE,
         vcFrameRxData     => vc1FrameRxData,
         vc0FrameRxValid   => vc10FrameRxValid,
         vc0RemBuffAFull   => vc10RemBuffAFull,
         vc0RemBuffFull    => vc10RemBuffFull,
         vc1FrameRxValid   => vc11FrameRxValid,
         vc1RemBuffAFull   => vc11RemBuffAFull,
         vc1RemBuffFull    => vc11RemBuffFull,
         vc2FrameRxValid   => vc12FrameRxValid,
         vc2RemBuffAFull   => vc12RemBuffAFull,
         vc2RemBuffFull    => vc12RemBuffFull,
         vc3FrameRxValid   => vc13FrameRxValid,
         vc3RemBuffAFull   => vc13RemBuffAFull,
         vc3RemBuffFull    => vc13RemBuffFull,
         phyRxPolarity     => phy1RxPolarity,
         phyRxData         => phy1RxData,
         phyRxDataK        => phy1RxDataK,
         phyRxDispErr      => phy1RxDispErr,
         phyRxDecErr       => phy1RxDecErr,
         phyRxReady        => phy1RxReady,
         phyRxInit         => phy1RxInit,
         crcRxIn           => crc1RxIn,
         crcRxWidth        => open,
         crcRxInit         => crc1RxInit,
         crcRxValid        => crc1RxValid,
         crcRxOut          => crc1RxOut,
         debug             => debug(127 downto 64)
      );


   -- PGP TX Block
   U_Pgp2Tx1: Pgp2CorePackage.Pgp2Tx 
      generic map (
         TxLaneCnt    => 1,
         VcInterleave => VcInterleave
      ) port map ( 
         pgpTxClk          => pgpClk,
         pgpTxReset        => pgpReset,
         pgpTxFlush        => pgpFlush,
         pgpTxLinkReady    => pgp1TxLinkReady,
         pgpTxOpCodeEn     => pgp1TxOpCodeEn,
         pgpTxOpCode       => pgp1TxOpCode,
         pgpLocLinkReady   => pgp1RxLinkReady,
         pgpLocData        => pgp1LocData,
         vc0FrameTxValid   => vc10FrameTxValid,
         vc0FrameTxReady   => vc10FrameTxReady,
         vc0FrameTxSOF     => vc10FrameTxSOF,
         vc0FrameTxEOF     => vc10FrameTxEOF,
         vc0FrameTxEOFE    => vc10FrameTxEOFE,
         vc0FrameTxData    => vc10FrameTxData,
         vc0LocBuffAFull   => vc10LocBuffAFull,
         vc0LocBuffFull    => vc10LocBuffFull,
         vc1FrameTxValid   => vc11FrameTxValid,
         vc1FrameTxReady   => vc11FrameTxReady,
         vc1FrameTxSOF     => vc11FrameTxSOF,
         vc1FrameTxEOF     => vc11FrameTxEOF,
         vc1FrameTxEOFE    => vc11FrameTxEOFE,
         vc1FrameTxData    => vc11FrameTxData,
         vc1LocBuffAFull   => vc11LocBuffAFull,
         vc1LocBuffFull    => vc11LocBuffFull,
         vc2FrameTxValid   => vc12FrameTxValid,
         vc2FrameTxReady   => vc12FrameTxReady,
         vc2FrameTxSOF     => vc12FrameTxSOF,
         vc2FrameTxEOF     => vc12FrameTxEOF,
         vc2FrameTxEOFE    => vc12FrameTxEOFE,
         vc2FrameTxData    => vc12FrameTxData,
         vc2LocBuffAFull   => vc12LocBuffAFull,
         vc2LocBuffFull    => vc12LocBuffFull,
         vc3FrameTxValid   => vc13FrameTxValid,
         vc3FrameTxReady   => vc13FrameTxReady,
         vc3FrameTxSOF     => vc13FrameTxSOF,
         vc3FrameTxEOF     => vc13FrameTxEOF,
         vc3FrameTxEOFE    => vc13FrameTxEOFE,
         vc3FrameTxData    => vc13FrameTxData,
         vc3LocBuffAFull   => vc13LocBuffAFull,
         vc3LocBuffFull    => vc13LocBuffFull,
         phyTxData         => phy1TxData,
         phyTxDataK        => phy1TxDataK,
         phyTxReady        => phy1TxReady,
         crcTxIn           => crc1TxIn,
         crcTxInit         => crc1TxInit,
         crcTxValid        => crc1TxValid,
         crcTxOut          => crc1TxOut,
         debug             => open
      );


   -- Adapt CRC data width flag
   crc1TxWidth <= "001";
   crc1RxWidth <= "001";
   crc1RxRst   <= int1RxRst or crc1RxInit;
   crc1TxRst   <= int1TxRst or crc1TxInit;

   -- Pass CRC data in on proper bits
   crc1TxInGtx(31 downto 24) <= crc1TxIn(7  downto 0);
   crc1TxInGtx(23 downto 16) <= crc1TxIn(15 downto 8);
   crc1TxInGtx(15 downto  0) <= (others=>'0');
   crc1RxInGtx(31 downto 24) <= crc1RxIn(7  downto 0);
   crc1RxInGtx(23 downto 16) <= crc1RxIn(15 downto 8);
   crc1RxInGtx(15 downto  0) <= (others=>'0');

   -- Pll Resets
   int1TxRst <= pll1TxRst or pgpReset;
   int1RxRst <= pll1RxRst or pgpReset;

   -- PLL Lock
   pll1RxReady <= phy1RxReady;
   pll1TxReady <= phy1TxReady;

   -- Link Ready
   pgp1LocLinkReady <= pgp1RxLinkReady and pgp1TxLinkReady;

   -- Invert Output CRC
   crc1RxOut <= not crc1RxOutGtx;
   crc1TxOut <= not crc1TxOutGtx;


   -- TX CRC BLock
   Tx_CRC1: CRC32 
      generic map(
         CRC_INIT   => x"FFFFFFFF"
      ) port map(
         CRCOUT       => crc1TxOutGtx,
         CRCCLK       => pgpClk,
         CRCDATAVALID => crc1TxValid,
         CRCDATAWIDTH => crc1TxWidth,
         CRCIN        => crc1TxInGtx,
         CRCRESET     => crc1TxRst
      );


   -- RX CRC BLock
   Rx_CRC1: CRC32 
      generic map(
         CRC_INIT   => x"FFFFFFFF"
      ) port map(
         CRCOUT       => crc1RxOutGtx,
         CRCCLK       => pgpClk,
         CRCDATAVALID => crc1RxValid,
         CRCDATAWIDTH => crc1RxWidth,
         CRCIN        => crc1RxInGtx,
         CRCRESET     => crc1RxRst 
      );


   -- RX Reset Control
   U_Pgp2GtxRxRst1: Pgp2GtxPackage.Pgp2GtxRxRst
      port map (
         gtxRxClk          => pgpClk,
         gtxRxRst          => int1RxRst,
         gtxRxReady        => phy1RxReady,
         gtxRxInit         => phy1RxInit,
         gtxLockDetect     => phyLockDetect,
         gtxRxElecIdle     => phy1RxElecIdle,
         gtxRxBuffStatus   => phy1RxBuffStatus,
         gtxRstDone        => phy1RstDone,
         gtxRxReset        => phy1RxReset,
         gtxRxCdrReset     => phy1RxCdrReset
      );


   -- TX Reset Control
   U_Pgp2GtxTxRst1: Pgp2GtxPackage.Pgp2GtxTxRst
      port map (
         gtxTxClk          => pgpClk,
         gtxTxRst          => int1TxRst,
         gtxTxReady        => phy1TxReady,
         gtxLockDetect     => phyLockDetect,
         gtxTxBuffStatus   => phy1TxBuffStatus,
         gtxRstDone        => phy1RstDone,
         gtxTxReset        => phy1TxReset
      );


   ----------------------------- GTX_DUAL Instance  --------------------------   
   UGtxDual:GTX_DUAL
      generic map (

         --_______________________ Simulation-Only Attributes ___________________

         SIM_RECEIVER_DETECT_PASS_0  =>       TRUE,
         SIM_RECEIVER_DETECT_PASS_1  =>       TRUE,
         SIM_MODE                    =>       "FAST",
         SIM_GTXRESET_SPEEDUP        =>       1,
         SIM_PLL_PERDIV2             =>       x"140",

         --___________________________ Shared Attributes ________________________

         -------------------------- Tile and PLL Attributes ---------------------

         CLK25_DIVIDER               =>       10, 
         CLKINDC_B                   =>       TRUE,
         OOB_CLK_DIVIDER             =>       6,
         OVERSAMPLE_MODE             =>       FALSE,
         PLL_DIVSEL_FB               =>       2,
         PLL_DIVSEL_REF              =>       1,
         CLKRCV_TRST                 =>       TRUE,
         PLL_COM_CFG                 =>       x"21680a",
         PLL_CP_CFG                  =>       x"00",
         PLL_FB_DCCEN                =>       FALSE,
         PLL_LKDET_CFG               =>       "101",
         PLL_TDCC_CFG                =>       "000",
         PMA_COM_CFG                 =>       x"000000000000000000",

         --____________________ Transmit Interface Attributes ___________________

         ------------------- TX Buffering and Phase Alignment -------------------   

         TX_BUFFER_USE_0             =>       TRUE,
         TX_XCLK_SEL_0               =>       "TXOUT",
         TXRX_INVERT_0               =>       "011",        

         TX_BUFFER_USE_1             =>       TRUE,
         TX_XCLK_SEL_1               =>       "TXOUT",
         TXRX_INVERT_1               =>       "011",        

         --------------------- TX Gearbox Settings -----------------------------

         GEARBOX_ENDEC_0             =>       "000", 
         TXGEARBOX_USE_0             =>       FALSE,

         GEARBOX_ENDEC_1             =>       "000", 
         TXGEARBOX_USE_1             =>       FALSE,

         --------------------- TX Serial Line Rate settings ---------------------   
 
         PLL_TXDIVSEL_OUT_0          =>       1,
         PLL_TXDIVSEL_OUT_1          =>       1,

         --------------------- TX Driver and OOB signalling --------------------  

         CM_TRIM_0                   =>       "10",
         PMA_TX_CFG_0                =>       x"80082",
         TX_DETECT_RX_CFG_0          =>       x"1832",
         TX_IDLE_DELAY_0             =>       "010",
         CM_TRIM_1                   =>       "10",
         PMA_TX_CFG_1                =>       x"80082",
         TX_DETECT_RX_CFG_1          =>       x"1832",
         TX_IDLE_DELAY_1             =>       "010",

         ------------------ TX Pipe Control for PCI Express/SATA ---------------

         COM_BURST_VAL_0             =>       "1111",
         COM_BURST_VAL_1             =>       "1111",

         --_______________________ Receive Interface Attributes ________________
 
         ------------ RX Driver,OOB signalling,Coupling and Eq,CDR -------------  

         AC_CAP_DIS_0                =>       TRUE,
         OOBDETECT_THRESHOLD_0       =>       "111",
         PMA_CDR_SCAN_0              =>       x"640403a",
         PMA_RX_CFG_0                =>       x"0f44088",
         RCV_TERM_GND_0              =>       FALSE,
         RCV_TERM_VTTRX_0            =>       TRUE,
         TERMINATION_IMP_0           =>       50,
         AC_CAP_DIS_1                =>       TRUE,
         OOBDETECT_THRESHOLD_1       =>       "111",
         PMA_CDR_SCAN_1              =>       x"640403a",
         PMA_RX_CFG_1                =>       x"0f44088",  
         RCV_TERM_GND_1              =>       FALSE,
         RCV_TERM_VTTRX_1            =>       TRUE,
         TERMINATION_IMP_1           =>       50,
         TERMINATION_CTRL            =>       "10100",
         TERMINATION_OVRD            =>       FALSE,

         ---------------- RX Decision Feedback Equalizer(DFE)  ----------------  

         DFE_CFG_0                   =>       "1001111011",
         DFE_CFG_1                   =>       "1001111011",
         DFE_CAL_TIME                =>       "00110",

         --------------------- RX Serial Line Rate Attributes ------------------   
 
         PLL_RXDIVSEL_OUT_0          =>       1,
         PLL_SATA_0                  =>       FALSE,
         PLL_RXDIVSEL_OUT_1          =>       1,
         PLL_SATA_1                  =>       FALSE,
 
         ----------------------- PRBS Detection Attributes ---------------------  
 
         PRBS_ERR_THRESHOLD_0        =>       x"00000001",
         PRBS_ERR_THRESHOLD_1        =>       x"00000001",
 
         ---------------- Comma Detection and Alignment Attributes -------------  
 
         ALIGN_COMMA_WORD_0          =>       2,
         COMMA_10B_ENABLE_0          =>       "1111111111",
         COMMA_DOUBLE_0              =>       FALSE,
         DEC_MCOMMA_DETECT_0         =>       TRUE,
         DEC_PCOMMA_DETECT_0         =>       TRUE,
         DEC_VALID_COMMA_ONLY_0      =>       FALSE,
         MCOMMA_10B_VALUE_0          =>       "1010000011",
         MCOMMA_DETECT_0             =>       TRUE,
         PCOMMA_10B_VALUE_0          =>       "0101111100",
         PCOMMA_DETECT_0             =>       TRUE,
         RX_SLIDE_MODE_0             =>       "PCS",
 
         ALIGN_COMMA_WORD_1          =>       2,
         COMMA_10B_ENABLE_1          =>       "1111111111",
         COMMA_DOUBLE_1              =>       FALSE,
         DEC_MCOMMA_DETECT_1         =>       TRUE,
         DEC_PCOMMA_DETECT_1         =>       TRUE,
         DEC_VALID_COMMA_ONLY_1      =>       FALSE,
         MCOMMA_10B_VALUE_1          =>       "1010000011",
         MCOMMA_DETECT_1             =>       TRUE,
         PCOMMA_10B_VALUE_1          =>       "0101111100",
         PCOMMA_DETECT_1             =>       TRUE,
         RX_SLIDE_MODE_1             =>       "PCS",
 
         ------------------ RX Loss-of-sync State Machine Attributes -----------  
 
         RX_LOSS_OF_SYNC_FSM_0       =>       FALSE,
         RX_LOS_INVALID_INCR_0       =>       8,
         RX_LOS_THRESHOLD_0          =>       128,
         RX_LOSS_OF_SYNC_FSM_1       =>       FALSE,
         RX_LOS_INVALID_INCR_1       =>       8,
         RX_LOS_THRESHOLD_1          =>       128,

         --------------------- RX Gearbox Settings -----------------------------

         RXGEARBOX_USE_0             =>       FALSE,
         RXGEARBOX_USE_1             =>       FALSE,
 
         -------------- RX Elastic Buffer and Phase alignment Attributes -------   
 
         PMA_RXSYNC_CFG_0            =>       x"00",
         RX_BUFFER_USE_0             =>       TRUE,
         RX_XCLK_SEL_0               =>       "RXREC",
         PMA_RXSYNC_CFG_1            =>       x"00",
         RX_BUFFER_USE_1             =>       TRUE,
         RX_XCLK_SEL_1               =>       "RXREC",                   
 
         ------------------------ Clock Correction Attributes ------------------   
 
         CLK_CORRECT_USE_0           =>       TRUE,
         CLK_COR_ADJ_LEN_0           =>       4,
         CLK_COR_DET_LEN_0           =>       4,
         CLK_COR_INSERT_IDLE_FLAG_0  =>       FALSE,
         CLK_COR_KEEP_IDLE_0         =>       FALSE,
         CLK_COR_MAX_LAT_0           =>       48,
         CLK_COR_MIN_LAT_0           =>       36,
         CLK_COR_PRECEDENCE_0        =>       TRUE,
         CLK_COR_REPEAT_WAIT_0       =>       0,
         CLK_COR_SEQ_1_1_0           =>       "0110111100",
         CLK_COR_SEQ_1_2_0           =>       "0100011100",
         CLK_COR_SEQ_1_3_0           =>       "0100011100",
         CLK_COR_SEQ_1_4_0           =>       "0100011100",
         CLK_COR_SEQ_1_ENABLE_0      =>       "1111",
         CLK_COR_SEQ_2_1_0           =>       "0000000000",
         CLK_COR_SEQ_2_2_0           =>       "0000000000",
         CLK_COR_SEQ_2_3_0           =>       "0000000000",
         CLK_COR_SEQ_2_4_0           =>       "0000000000",
         CLK_COR_SEQ_2_ENABLE_0      =>       "0000",
         CLK_COR_SEQ_2_USE_0         =>       FALSE,
         RX_DECODE_SEQ_MATCH_0       =>       TRUE,
 
         CLK_CORRECT_USE_1           =>       TRUE,
         CLK_COR_ADJ_LEN_1           =>       4,
         CLK_COR_DET_LEN_1           =>       4,
         CLK_COR_INSERT_IDLE_FLAG_1  =>       FALSE,
         CLK_COR_KEEP_IDLE_1         =>       FALSE,
         CLK_COR_MAX_LAT_1           =>       48,
         CLK_COR_MIN_LAT_1           =>       36,
         CLK_COR_PRECEDENCE_1        =>       TRUE,
         CLK_COR_REPEAT_WAIT_1       =>       0,
         CLK_COR_SEQ_1_1_1           =>       "0110111100",
         CLK_COR_SEQ_1_2_1           =>       "0100011100",
         CLK_COR_SEQ_1_3_1           =>       "0100011100",
         CLK_COR_SEQ_1_4_1           =>       "0100011100",
         CLK_COR_SEQ_1_ENABLE_1      =>       "1111",
         CLK_COR_SEQ_2_1_1           =>       "0000000000",
         CLK_COR_SEQ_2_2_1           =>       "0000000000",
         CLK_COR_SEQ_2_3_1           =>       "0000000000",
         CLK_COR_SEQ_2_4_1           =>       "0000000000",
         CLK_COR_SEQ_2_ENABLE_1      =>       "0000",
         CLK_COR_SEQ_2_USE_1         =>       FALSE,
         RX_DECODE_SEQ_MATCH_1       =>       TRUE,
 
         ------------------------ Channel Bonding Attributes -------------------   
 
         CB2_INH_CC_PERIOD_0         =>       8,
         CHAN_BOND_KEEP_ALIGN_0      =>       FALSE,
         CHAN_BOND_1_MAX_SKEW_0      =>       1,
         CHAN_BOND_2_MAX_SKEW_0      =>       1,
         CHAN_BOND_LEVEL_0           =>       0,
         CHAN_BOND_MODE_0            =>       "OFF",
         CHAN_BOND_SEQ_1_1_0         =>       "0000000000",
         CHAN_BOND_SEQ_1_2_0         =>       "0000000000",
         CHAN_BOND_SEQ_1_3_0         =>       "0000000000",
         CHAN_BOND_SEQ_1_4_0         =>       "0000000000",
         CHAN_BOND_SEQ_1_ENABLE_0    =>       "0000",
         CHAN_BOND_SEQ_2_1_0         =>       "0000000000",
         CHAN_BOND_SEQ_2_2_0         =>       "0000000000",
         CHAN_BOND_SEQ_2_3_0         =>       "0000000000",
         CHAN_BOND_SEQ_2_4_0         =>       "0000000000",
         CHAN_BOND_SEQ_2_ENABLE_0    =>       "0000",
         CHAN_BOND_SEQ_2_USE_0       =>       FALSE,  
         CHAN_BOND_SEQ_LEN_0         =>       1,
         PCI_EXPRESS_MODE_0          =>       FALSE,   
      
         CB2_INH_CC_PERIOD_1         =>       8,
         CHAN_BOND_KEEP_ALIGN_1      =>       FALSE,
         CHAN_BOND_1_MAX_SKEW_1      =>       1,
         CHAN_BOND_2_MAX_SKEW_1      =>       1,
         CHAN_BOND_LEVEL_1           =>       0,
         CHAN_BOND_MODE_1            =>       "OFF",
         CHAN_BOND_SEQ_1_1_1         =>       "0000000000",
         CHAN_BOND_SEQ_1_2_1         =>       "0000000000",
         CHAN_BOND_SEQ_1_3_1         =>       "0000000000",
         CHAN_BOND_SEQ_1_4_1         =>       "0000000000",
         CHAN_BOND_SEQ_1_ENABLE_1    =>       "0000",
         CHAN_BOND_SEQ_2_1_1         =>       "0000000000",
         CHAN_BOND_SEQ_2_2_1         =>       "0000000000",
         CHAN_BOND_SEQ_2_3_1         =>       "0000000000",
         CHAN_BOND_SEQ_2_4_1         =>       "0000000000",
         CHAN_BOND_SEQ_2_ENABLE_1    =>       "0000",
         CHAN_BOND_SEQ_2_USE_1       =>       FALSE,  
         CHAN_BOND_SEQ_LEN_1         =>       1,
         PCI_EXPRESS_MODE_1          =>       FALSE,

         -------- RX Attributes to Control Reset after Electrical Idle  ------

         RX_EN_IDLE_HOLD_DFE_0       =>       TRUE,
         RX_EN_IDLE_RESET_BUF_0      =>       TRUE,
         RX_IDLE_HI_CNT_0            =>       "1000",
         RX_IDLE_LO_CNT_0            =>       "0000",
         RX_EN_IDLE_HOLD_DFE_1       =>       TRUE,
         RX_EN_IDLE_RESET_BUF_1      =>       TRUE,
         RX_IDLE_HI_CNT_1            =>       "1000",
         RX_IDLE_LO_CNT_1            =>       "0000",
         CDR_PH_ADJ_TIME             =>       "01010",
         RX_EN_IDLE_RESET_FR         =>       TRUE,
         RX_EN_IDLE_HOLD_CDR         =>       FALSE,
         RX_EN_IDLE_RESET_PH         =>       TRUE,

         ------------------ RX Attributes for PCI Express/SATA ---------------
 
         RX_STATUS_FMT_0             =>       "PCIE",
         SATA_BURST_VAL_0            =>       "100",
         SATA_IDLE_VAL_0             =>       "100",
         SATA_MAX_BURST_0            =>       7,
         SATA_MAX_INIT_0             =>       22,
         SATA_MAX_WAKE_0             =>       7,
         SATA_MIN_BURST_0            =>       4,
         SATA_MIN_INIT_0             =>       12,
         SATA_MIN_WAKE_0             =>       4,
         TRANS_TIME_FROM_P2_0        =>       x"003C",
         TRANS_TIME_NON_P2_0         =>       x"0019",
         TRANS_TIME_TO_P2_0          =>       x"0064",
 
         RX_STATUS_FMT_1             =>       "PCIE",
         SATA_BURST_VAL_1            =>       "100",
         SATA_IDLE_VAL_1             =>       "100",
         SATA_MAX_BURST_1            =>       7,
         SATA_MAX_INIT_1             =>       22,
         SATA_MAX_WAKE_1             =>       7,
         SATA_MIN_BURST_1            =>       4,
         SATA_MIN_INIT_1             =>       12,
         SATA_MIN_WAKE_1             =>       4,
         TRANS_TIME_FROM_P2_1        =>       x"003C",
         TRANS_TIME_NON_P2_1         =>       x"0019",
         TRANS_TIME_TO_P2_1          =>       x"0064"

      ) port map (

         ------------------------ Loopback and Powerdown Ports ----------------------
         LOOPBACK0(0)                    =>      '0',
         LOOPBACK0(1)                    =>      gtxLoopback(0),
         LOOPBACK0(2)                    =>      '0',
         LOOPBACK1(0)                    =>      '0',
         LOOPBACK1(1)                    =>      gtxLoopback(1),
         LOOPBACK1(2)                    =>      '0',
         RXPOWERDOWN0                    =>      (others=>'0'),
         RXPOWERDOWN1                    =>      (others=>'0'),
         TXPOWERDOWN0                    =>      (others=>'0'),
         TXPOWERDOWN1                    =>      (others=>'0'),
         -------------- Receive Ports - 64b66b and 64b67b Gearbox Ports -------------
         RXDATAVALID0                    =>      open,
         RXDATAVALID1                    =>      open,
         RXGEARBOXSLIP0                  =>      '0',
         RXGEARBOXSLIP1                  =>      '0',
         RXHEADER0                       =>      open,
         RXHEADER1                       =>      open,
         RXHEADERVALID0                  =>      open,
         RXHEADERVALID1                  =>      open,
         RXSTARTOFSEQ0                   =>      open,
         RXSTARTOFSEQ1                   =>      open,
         ----------------------- Receive Ports - 8b10b Decoder ----------------------
         RXCHARISCOMMA0                  =>      open,
         RXCHARISCOMMA1                  =>      open,
         RXCHARISK0(1 downto 0)          =>      phy0RxDataK,
         RXCHARISK0(3 downto 2)          =>      open,
         RXCHARISK1(1 downto 0)          =>      phy1RxDataK,
         RXCHARISK1(3 downto 2)          =>      open,
         RXDEC8B10BUSE0                  =>      '1',
         RXDEC8B10BUSE1                  =>      '1',
         RXDISPERR0(1 downto 0)          =>      phy0RxDispErr,
         RXDISPERR0(3 downto 2)          =>      open,
         RXDISPERR1(1 downto 0)          =>      phy1RxDispErr,
         RXDISPERR1(3 downto 2)          =>      open,
         RXNOTINTABLE0(1 downto 0)       =>      phy0RxDecErr,
         RXNOTINTABLE0(3 downto 2)       =>      open,
         RXNOTINTABLE1(1 downto 0)       =>      phy1RxDecErr,
         RXNOTINTABLE1(3 downto 2)       =>      open,
         RXRUNDISP0                      =>      open,
         RXRUNDISP1                      =>      open,
         ------------------- Receive Ports - Channel Bonding Ports ------------------
         RXCHANBONDSEQ0                  =>      open,
         RXCHANBONDSEQ1                  =>      open,
         RXCHBONDI0                      =>      (others=>'0'),
         RXCHBONDI1                      =>      (others=>'0'),
         RXCHBONDO0                      =>      open,
         RXCHBONDO1                      =>      open,
         RXENCHANSYNC0                   =>      '0',
         RXENCHANSYNC1                   =>      '0',
         ------------------- Receive Ports - Clock Correction Ports -----------------
         RXCLKCORCNT0                    =>      open,
         RXCLKCORCNT1                    =>      open,
         --------------- Receive Ports - Comma Detection and Alignment --------------
         RXBYTEISALIGNED0                =>      open,
         RXBYTEISALIGNED1                =>      open,
         RXBYTEREALIGN0                  =>      open,
         RXBYTEREALIGN1                  =>      open,
         RXCOMMADET0                     =>      open,
         RXCOMMADET1                     =>      open,
         RXCOMMADETUSE0                  =>      '1',
         RXCOMMADETUSE1                  =>      '1',
         RXENMCOMMAALIGN0                =>      '1',
         RXENMCOMMAALIGN1                =>      '1',
         RXENPCOMMAALIGN0                =>      '1',
         RXENPCOMMAALIGN1                =>      '1',
         RXSLIDE0                        =>      '0',
         RXSLIDE1                        =>      '0',
         ----------------------- Receive Ports - PRBS Detection ---------------------
         PRBSCNTRESET0                   =>      '0',
         PRBSCNTRESET1                   =>      '0',
         RXENPRBSTST0                    =>      (others=>'0'),
         RXENPRBSTST1                    =>      (others=>'0'),
         RXPRBSERR0                      =>      open,
         RXPRBSERR1                      =>      open,
         ------------------- Receive Ports - RX Data Path interface -----------------
         RXDATA0(15 downto 0)            =>      phy0RxData,
         RXDATA0(31 downto 16)           =>      open,
         RXDATA1(15 downto 0)            =>      phy1RxData,
         RXDATA1(31 downto 16)           =>      open,
         RXDATAWIDTH0                    =>      "01",
         RXDATAWIDTH1                    =>      "01",
         RXRECCLK0                       =>      int0RxRecClk,
         RXRECCLK1                       =>      int1RxRecClk,
         RXRESET0                        =>      phy0RxReset,
         RXRESET1                        =>      phy1RxReset,
         RXUSRCLK0                       =>      pgpClk,
         RXUSRCLK1                       =>      pgpClk,
         RXUSRCLK20                      =>      pgpClk,
         RXUSRCLK21                      =>      pgpClk,
         ------------ Receive Ports - RX Decision Feedback Equalizer(DFE) -----------
         DFECLKDLYADJ0                   =>      (others=>'0'),
         DFECLKDLYADJ1                   =>      (others=>'0'),
         DFECLKDLYADJMONITOR0            =>      open,
         DFECLKDLYADJMONITOR1            =>      open,
         DFEEYEDACMONITOR0               =>      open,
         DFEEYEDACMONITOR1               =>      open,
         DFESENSCAL0                     =>      open,
         DFESENSCAL1                     =>      open,
         DFETAP10                        =>      (others=>'0'),
         DFETAP11                        =>      (others=>'0'),
         DFETAP1MONITOR0                 =>      open,
         DFETAP1MONITOR1                 =>      open,
         DFETAP20                        =>      (others=>'0'),
         DFETAP21                        =>      (others=>'0'),
         DFETAP2MONITOR0                 =>      open,
         DFETAP2MONITOR1                 =>      open,
         DFETAP30                        =>      (others=>'0'),
         DFETAP31                        =>      (others=>'0'),
         DFETAP3MONITOR0                 =>      open,
         DFETAP3MONITOR1                 =>      open,
         DFETAP40                        =>      (others=>'0'),
         DFETAP41                        =>      (others=>'0'),
         DFETAP4MONITOR0                 =>      open,
         DFETAP4MONITOR1                 =>      open,
         ------- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
         RXCDRRESET0                     =>      phy0RxCdrReset,
         RXCDRRESET1                     =>      phy1RxCdrReset,
         RXELECIDLE0                     =>      phy0RxElecIdle,
         RXELECIDLE1                     =>      phy1RxElecIdle,
         RXENEQB0                        =>      '0',
         RXENEQB1                        =>      '0',
         RXEQMIX0                        =>      (others=>'0'),
         RXEQMIX1                        =>      (others=>'0'),
         RXEQPOLE0                       =>      (others=>'0'),
         RXEQPOLE1                       =>      (others=>'0'),
         RXN0                            =>      gtxRxN(0),
         RXN1                            =>      gtxRxN(1),
         RXP0                            =>      gtxRxP(0),
         RXP1                            =>      gtxRxP(1),
         -------- Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
         RXBUFRESET0                     =>      '0',
         RXBUFRESET1                     =>      '0',
         RXBUFSTATUS0                    =>      phy0RxBuffStatus,
         RXBUFSTATUS1                    =>      phy1RxBuffStatus,
         RXCHANISALIGNED0                =>      open,
         RXCHANISALIGNED1                =>      open,
         RXCHANREALIGN0                  =>      open,
         RXCHANREALIGN1                  =>      open,
         RXENPMAPHASEALIGN0              =>      '0',
         RXENPMAPHASEALIGN1              =>      '0',
         RXPMASETPHASE0                  =>      '0',
         RXPMASETPHASE1                  =>      '0',
         RXSTATUS0                       =>      open,
         RXSTATUS1                       =>      open,
         --------------- Receive Ports - RX Loss-of-sync State Machine --------------
         RXLOSSOFSYNC0                   =>      open,
         RXLOSSOFSYNC1                   =>      open,
         ---------------------- Receive Ports - RX Oversampling ---------------------
         RXENSAMPLEALIGN0                =>      '0',
         RXENSAMPLEALIGN1                =>      '0',
         RXOVERSAMPLEERR0                =>      open,
         RXOVERSAMPLEERR1                =>      open,
         -------------- Receive Ports - RX Pipe Control for PCI Express -------------
         PHYSTATUS0                      =>      open,
         PHYSTATUS1                      =>      open,
         RXVALID0                        =>      open,
         RXVALID1                        =>      open,
         ----------------- Receive Ports - RX Polarity Control Ports ----------------
         RXPOLARITY0                     =>      phyRxPolarity(0),
         RXPOLARITY1                     =>      phyRxPolarity(1),
         ------------- Shared Ports - Dynamic Reconfiguration Port (DRP) ------------
         DADDR                           =>      (others=>'0'),
         DCLK                            =>      '0',
         DEN                             =>      '0',
         DI                              =>      (others=>'0'),
         DO                              =>      open,
         DRDY                            =>      open,
         DWE                             =>      '0',
         --------------------- Shared Ports - Tile and PLL Ports --------------------
         CLKIN                           =>      gtxClkIn,
         GTXRESET                        =>      pgpReset,
         GTXTEST                         =>      "10000000000000",
         INTDATAWIDTH                    =>      '1',
         PLLLKDET                        =>      phyLockDetect,
         PLLLKDETEN                      =>      '1',
         PLLPOWERDOWN                    =>      '0',
         REFCLKOUT                       =>      tmpRefClkOut,
         REFCLKPWRDNB                    =>      '1',
         RESETDONE0                      =>      phy0RstDone,
         RESETDONE1                      =>      phy1RstDone,
         -------------- Transmit Ports - 64b66b and 64b67b Gearbox Ports ------------
         TXGEARBOXREADY0                 =>      open,
         TXGEARBOXREADY1                 =>      open,
         TXHEADER0                       =>      (others=>'0'),
         TXHEADER1                       =>      (others=>'0'),
         TXSEQUENCE0                     =>      (others=>'0'),
         TXSEQUENCE1                     =>      (others=>'0'),
         TXSTARTSEQ0                     =>      '0',
         TXSTARTSEQ1                     =>      '0',
         ---------------- Transmit Ports - 8b10b Encoder Control Ports --------------
         TXBYPASS8B10B0                  =>      (others=>'0'),
         TXBYPASS8B10B1                  =>      (others=>'0'),
         TXCHARDISPMODE0                 =>      (others=>'0'),
         TXCHARDISPMODE1                 =>      (others=>'0'),
         TXCHARDISPVAL0                  =>      (others=>'0'),
         TXCHARDISPVAL1                  =>      (others=>'0'),
         TXCHARISK0(1 downto 0)          =>      phy0TxDataK,
         TXCHARISK0(3 downto 2)          =>      (others=>'0'),
         TXCHARISK1(1 downto 0)          =>      phy1TxDataK,
         TXCHARISK1(3 downto 2)          =>      (others=>'0'),
         TXENC8B10BUSE0                  =>      '1',
         TXENC8B10BUSE1                  =>      '1',
         TXKERR0                         =>      open,
         TXKERR1                         =>      open,
         TXRUNDISP0                      =>      open,
         TXRUNDISP1                      =>      open,
         ------------- Transmit Ports - TX Buffering and Phase Alignment ------------
         TXBUFSTATUS0                    =>      phy0TxBuffStatus,
         TXBUFSTATUS1                    =>      phy1TxBuffStatus,
         ------------------ Transmit Ports - TX Data Path interface -----------------
         TXDATA0(15 downto 0)            =>      phy0TxData,
         TXDATA0(31 downto 16)           =>      (others=>'0'),
         TXDATA1(15 downto 0)            =>      phy1TxData,
         TXDATA1(31 downto 16)           =>      (others=>'0'),
         TXDATAWIDTH0                    =>      "01",
         TXDATAWIDTH1                    =>      "01",
         TXOUTCLK0                       =>      open,
         TXOUTCLK1                       =>      open,
         TXRESET0                        =>      phy0TxReset,
         TXRESET1                        =>      phy1TxReset,
         TXUSRCLK0                       =>      pgpClk,
         TXUSRCLK1                       =>      pgpClk,
         TXUSRCLK20                      =>      pgpClk,
         TXUSRCLK21                      =>      pgpClk,
         --------------- Transmit Ports - TX Driver and OOB signalling --------------
         TXBUFDIFFCTRL0                  =>      "100", -- 800mV
         TXBUFDIFFCTRL1                  =>      "100",
         TXDIFFCTRL0                     =>      "100",
         TXDIFFCTRL1                     =>      "100",
         TXINHIBIT0                      =>      '0',
         TXINHIBIT1                      =>      '0',
         TXN0                            =>      gtxTxN(0),
         TXN1                            =>      gtxTxN(1),
         TXP0                            =>      gtxTxP(0),
         TXP1                            =>      gtxTxP(1),
         TXPREEMPHASIS0                  =>      "0011", -- 4.5%
         TXPREEMPHASIS1                  =>      "0011",
         -------- Transmit Ports - TX Elastic Buffer and Phase Alignment Ports ------
         TXENPMAPHASEALIGN0              =>      '0',
         TXENPMAPHASEALIGN1              =>      '0',
         TXPMASETPHASE0                  =>      '0',
         TXPMASETPHASE1                  =>      '0',
         --------------------- Transmit Ports - TX PRBS Generator -------------------
         TXENPRBSTST0                    =>      (others=>'0'),
         TXENPRBSTST1                    =>      (others=>'0'),
         -------------------- Transmit Ports - TX Polarity Control ------------------
         TXPOLARITY0                     =>      '0',
         TXPOLARITY1                     =>      '0',
         ----------------- Transmit Ports - TX Ports for PCI Express ----------------
         TXDETECTRX0                     =>      '0',
         TXDETECTRX1                     =>      '0',
         TXELECIDLE0                     =>      '0',
         TXELECIDLE1                     =>      '0',
         --------------------- Transmit Ports - TX Ports for SATA -------------------
         TXCOMSTART0                     =>      '0',
         TXCOMSTART1                     =>      '0',
         TXCOMTYPE0                      =>      '0',
         TXCOMTYPE1                      =>      '0'
      );

   -- Global Buffer For Ref Clock Output
   U_RefClkBuff: BUFG port map (
      O => gtxRefClkOut,
      I => tmpRefClkOut
   );
   gtxRxRecClk(0) <= int0RxRecClk;
   gtxRxRecClk(1) <= int1RxRecClk;

end Pgp2GtxDual;
