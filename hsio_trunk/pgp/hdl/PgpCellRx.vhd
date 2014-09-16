-------------------------------------------------------------------------------
-- Title         : Pretty Good Protocol, Cell Receive Interface
-- Project       : General Purpose Core
-------------------------------------------------------------------------------
-- File          : PgpCellRx.vhd
-- Author        : Ryan Herbst, rherbst@slac.stanford.edu
-- Created       : 10/24/2006
-------------------------------------------------------------------------------
-- Description:
-- Cell Receive interface module for the Pretty Good Protocol core. 
-------------------------------------------------------------------------------
-- Copyright (c) 2006 by Ryan Herbst. All rights reserved.
-------------------------------------------------------------------------------
-- Modification history:
-- 10/24/2006: created.
-- 04/18/2007: Added support to track the number of cells in a frame to detect
--             dropped cells.
-- 04/19/2007: Set initial states of buffer status bits to bad
-- 07/19/2007: Removed support to track the number of cells in a frame to detect
--             dropped cells.
-- 07/25/2007: Added support to terminate in progress frames on missed cell. Also
--             added ability to detect missing cells.
-- 09/18/2007: Data is only output for a VC if the VC is currently in frame.
--             Abort flag from rx tracker will end a cell if SOF is received
--             for a VC that is already in frame. SOF of new frame is blocked.
-- 09/18/2007: Added forceCellSize signal to make sure all outgoing cells are
--             512 bytes unless they are the last in a frame. Frame will be
--             ended with error if this occurs.
-- 09/19/2007: Changed force cell size signal to PIC mode signal
--             Add feature where the following cell after an errored cell will
--             be dropped as well. This ensures the PIC interface code has
--             enough clocks to abort all VCs.
-- 09/20/2007: Added fix so SOF is only aserted for received VC during certain
--             abort situations. SOF can only be asserted in a way that does not
--             violate the SOF-EOF ordering to external logic.
-- 09/21/2007: Converted PIC mode to generic.
-- 10/17/2007: CrcNotZero signal is now registered.
-- 10/24/2007: Fixed error where SOF was not clearing after first word.
-- 11/06/2007: Added cellRxShort flag to indicate to tracking logic that EOFE
--             was generated due to short cell.
-------------------------------------------------------------------------------

LIBRARY ieee;
USE work.ALL;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity PgpCellRx is 
   generic (
      PicMode    : integer := 0  -- PIC Interface Mode, 1=PIC, 0=Normal
   );
   port (

      -- System clock, reset & control
      pgpClk            : in  std_logic;                     -- Master clock
      pgpReset          : in  std_logic;                     -- Synchronous reset input
      pibLinkReady      : in  std_logic;                     -- PIB Link Ready

      -- Receive Tracking Block
      cellRxSOF         : out std_logic;                     -- Cell contained SOF
      cellRxDataVc      : out std_logic_vector(1  downto 0); -- Cell virtual channel
      cellRxEOF         : out std_logic;                     -- Cell contained EOF
      cellRxEOFE        : out std_logic;                     -- Cell contained EOFE
      cellRxEmpty       : out std_logic;                     -- Cell was empty
      cellVcInFrame     : in  std_logic_vector(3  downto 0); -- Cell VC in frame status
      cellVcAbort       : in  std_logic;                     -- Cell abort flag for current VC
      cellRxStart       : out std_logic;                     -- Cell reception start
      cellRxDone        : out std_logic;                     -- Cell reception done
      cellRxCellError   : out std_logic;                     -- Cell receieve CRC error
      cellRxShort       : out std_logic;                     -- Cell receieve is short (PIC Mode)
      cellRxSeq         : out std_logic_vector(7  downto 0); -- Cell receieve sequence
      cellRxAck         : out std_logic;                     -- Cell receieve ACK
      cellRxNAck        : out std_logic;                     -- Cell receieve NACK

      -- Frame Receive Interface, VC 0
      vc0FrameRxValid   : out std_logic;                     -- PGP frame data is valid
      vc0FrameRxSOF     : out std_logic;                     -- PGP frame data start of frame
      vc0FrameRxWidth   : out std_logic;                     -- PGP frame data width
      vc0FrameRxEOF     : out std_logic;                     -- PGP frame data end of frame
      vc0FrameRxEOFE    : out std_logic;                     -- PGP frame data error
      vc0FrameRxData    : out std_logic_vector(15 downto 0); -- PGP frame data
      vc0RemBuffAFull   : out std_logic;                     -- Remote buffer almost full
      vc0RemBuffFull    : out std_logic;                     -- Remote buffer full

      -- Frame Receive Interface, VC 1
      vc1FrameRxValid   : out std_logic;                     -- PGP frame data is valid
      vc1FrameRxSOF     : out std_logic;                     -- PGP frame data start of frame
      vc1FrameRxWidth   : out std_logic;                     -- PGP frame data width
      vc1FrameRxEOF     : out std_logic;                     -- PGP frame data end of frame
      vc1FrameRxEOFE    : out std_logic;                     -- PGP frame data error
      vc1FrameRxData    : out std_logic_vector(15 downto 0); -- PGP frame data
      vc1RemBuffAFull   : out std_logic;                     -- Remote buffer almost full
      vc1RemBuffFull    : out std_logic;                     -- Remote buffer full

      -- Frame Receive Interface, VC 2
      vc2FrameRxValid   : out std_logic;                     -- PGP frame data is valid
      vc2FrameRxSOF     : out std_logic;                     -- PGP frame data start of frame
      vc2FrameRxWidth   : out std_logic;                     -- PGP frame data width
      vc2FrameRxEOF     : out std_logic;                     -- PGP frame data end of frame
      vc2FrameRxEOFE    : out std_logic;                     -- PGP frame data error
      vc2FrameRxData    : out std_logic_vector(15 downto 0); -- PGP frame data
      vc2RemBuffAFull   : out std_logic;                     -- Remote buffer almost full
      vc2RemBuffFull    : out std_logic;                     -- Remote buffer full

      -- Frame Receive Interface, VC 3
      vc3FrameRxValid   : out std_logic;                     -- PGP frame data is valid
      vc3FrameRxSOF     : out std_logic;                     -- PGP frame data start of frame
      vc3FrameRxWidth   : out std_logic;                     -- PGP frame data width
      vc3FrameRxEOF     : out std_logic;                     -- PGP frame data end of frame
      vc3FrameRxEOFE    : out std_logic;                     -- PGP frame data error
      vc3FrameRxData    : out std_logic_vector(15 downto 0); -- PGP frame data
      vc3RemBuffAFull   : out std_logic;                     -- Remote buffer almost full
      vc3RemBuffFull    : out std_logic;                     -- Remote buffer full

      -- Receive CRC Interface
      crcRxIn           : out std_logic_vector(15 downto 0); -- Receive  data for CRC
      crcRxInit         : out std_logic;                     -- Receive  CRC value init
      crcRxValid        : out std_logic;                     -- Receive  data for CRC is valid
      crcRxWidth        : out std_logic;                     -- Receive  data for CRC width
      crcRxOut          : in  std_logic_vector(31 downto 0); -- Receive  calculated CRC value

      -- Cell Receive Interface
      pibRxSOC          : in  std_logic;                     -- Cell data start of cell
      pibRxWidth        : in  std_logic;                     -- Cell data width
      pibRxEOC          : in  std_logic;                     -- Cell data end of cell
      pibRxEOF          : in  std_logic;                     -- Cell data end of frame
      pibRxEOFE         : in  std_logic;                     -- Cell data end of frame error
      pibRxData         : in  std_logic_vector(15 downto 0)  -- Cell data data
   );

end PgpCellRx;


-- Define architecture
architecture PgpCellRx of PgpCellRx is

   -- Local Signals
   signal dly0SOC           : std_logic;
   signal dly0Width         : std_logic;
   signal dly0EOC           : std_logic;
   signal dly0EOF           : std_logic;
   signal dly0EOFE          : std_logic;
   signal dly0Data          : std_logic_vector(15 downto 0);
   signal dly1SOC           : std_logic;
   signal dly1Width         : std_logic;
   signal dly1EOC           : std_logic;
   signal dly1EOF           : std_logic;
   signal dly1EOFE          : std_logic;
   signal dly1Data          : std_logic_vector(15 downto 0);
   signal dly2SOC           : std_logic;
   signal dly2Width         : std_logic;
   signal dly2EOC           : std_logic;
   signal dly2EOF           : std_logic;
   signal dly2EOFE          : std_logic;
   signal dly2Data          : std_logic_vector(15 downto 0);
   signal dly3SOC           : std_logic;
   signal dly3Width         : std_logic;
   signal dly3EOC           : std_logic;
   signal dly3EOF           : std_logic;
   signal dly3EOFE          : std_logic;
   signal dly3Data          : std_logic_vector(15 downto 0);
   signal dly4SOC           : std_logic;
   signal dly4EOC           : std_logic;
   signal dly4Data          : std_logic_vector(15 downto 0);
   signal dly5SOC           : std_logic;
   signal dly5Data          : std_logic_vector(15 downto 0);
   signal dly6SOC           : std_logic;
   signal dly7SOC           : std_logic;
   signal inCellCrc         : std_logic;
   signal crcNotZero        : std_logic;
   signal intCellRxSOF      : std_logic;
   signal intCellRxEmpty    : std_logic;
   signal intCellRxDataVc   : std_logic_vector(1  downto 0);
   signal intBuffAFull      : std_logic_vector(3  downto 0);
   signal intBuffFull       : std_logic_vector(3  downto 0);
   signal intFrameRxValid   : std_logic_vector(3  downto 0);
   signal muxFrameRxValid   : std_logic_vector(3  downto 0);
   signal muxFrameRxSOF     : std_logic_vector(3  downto 0);
   signal intFrameRxSOF     : std_logic_vector(3  downto 0);
   signal intFrameRxWidth   : std_logic;
   signal intFrameRxEOF     : std_logic;
   signal intFrameRxEOFE    : std_logic;
   signal intFrameRxData    : std_logic_vector(15 downto 0);
   signal interCellCount    : std_logic_vector(4  downto 0);
   signal expSerial         : std_logic_vector(1  downto 0);
   signal cellSerial        : std_logic_vector(1  downto 0);
   signal inCellRx          : std_logic;
   signal linkReadyDly      : std_logic;
   signal intRxCellError    : std_logic;
   signal firstCellRx       : std_logic;
   signal cellRxSize        : std_logic_vector(7 downto 0);
   signal dropNextCell      : std_logic;
   signal intMode           : std_logic;

   -- Register delay for simulation
   constant tpd:time := 0.5 ns;

begin

   -- Convert Pic Mode Generic
   intMode <= '0' when PicMode = 0 else '1';

   -- Interface to CRC calculator
   crcRxInit  <= pibRxSOC;
   crcRxValid <= pibRxSOC or inCellCrc;
   crcRxWidth <= pibRxWidth and not pibRxSOC;
   --crcNotZero <= '0' when crcRxOut = 0 else '1';

   -- Crc data may be switched
   crcRxIn(7  downto 0) <= pibRxData(7  downto 0) when pibRxSOC='0' else pibRxData(15 downto 8);
   crcRxIn(15 downto 8) <= pibRxData(15 downto 8) when pibRxSOC='0' else pibRxData(7  downto 0);

   -- Outputs to tracking blocks
   cellRxStart     <= dly6SOC;
   cellRxEOF       <= intFrameRxEOF;
   cellRxEOFE      <= intFrameRxEOFE;
   cellRxEmpty     <= intCellRxEmpty;
   cellRxDataVc    <= intCellRxDataVc;
   cellRxSOF       <= intCellRxSOF;
   cellRxCellError <= intRxCellError;

   -- Frame Receive Interface, VC 0
   vc0FrameRxValid <= intFrameRxValid(0);
   vc0FrameRxSOF   <= intFrameRxSOF(0);
   vc0FrameRxWidth <= intFrameRxWidth;
   vc0FrameRxEOF   <= intFrameRxEOF;
   vc0FrameRxEOFE  <= intFrameRxEOFE;
   vc0FrameRxData  <= intFrameRxData;

   -- Frame Receive Interface, VC 1
   vc1FrameRxValid <= intFrameRxValid(1);
   vc1FrameRxSOF   <= intFrameRxSOF(1);
   vc1FrameRxWidth <= intFrameRxWidth;
   vc1FrameRxEOF   <= intFrameRxEOF;
   vc1FrameRxEOFE  <= intFrameRxEOFE;
   vc1FrameRxData  <= intFrameRxData;

   -- Frame Receive Interface, VC 2
   vc2FrameRxValid <= intFrameRxValid(2);
   vc2FrameRxSOF   <= intFrameRxSOF(2);
   vc2FrameRxWidth <= intFrameRxWidth;
   vc2FrameRxEOF   <= intFrameRxEOF;
   vc2FrameRxEOFE  <= intFrameRxEOFE;
   vc2FrameRxData  <= intFrameRxData;

   -- Frame Receive Interface, VC 3
   vc3FrameRxValid <= intFrameRxValid(3);
   vc3FrameRxSOF   <= intFrameRxSOF(3);
   vc3FrameRxWidth <= intFrameRxWidth;
   vc3FrameRxEOF   <= intFrameRxEOF;
   vc3FrameRxEOFE  <= intFrameRxEOFE;
   vc3FrameRxData  <= intFrameRxData;


   -- Delay stages to line up data with CRC calculation
   process ( pgpClk, pgpReset ) begin
      if pgpReset = '1' then
         dly0SOC       <= '0'           after tpd;
         dly0Width     <= '0'           after tpd;
         dly0EOC       <= '0'           after tpd;
         dly0EOF       <= '0'           after tpd;
         dly0EOFE      <= '0'           after tpd;
         dly0Data      <= (others=>'0') after tpd;
         dly1SOC       <= '0'           after tpd;
         dly1Width     <= '0'           after tpd;
         dly1EOC       <= '0'           after tpd;
         dly1EOF       <= '0'           after tpd;
         dly1EOFE      <= '0'           after tpd;
         dly1Data      <= (others=>'0') after tpd;
         dly2SOC       <= '0'           after tpd;
         dly2Width     <= '0'           after tpd;
         dly2EOC       <= '0'           after tpd;
         dly2EOF       <= '0'           after tpd;
         dly2EOFE      <= '0'           after tpd;
         dly2Data      <= (others=>'0') after tpd;
         dly3SOC       <= '0'           after tpd;
         dly3Width     <= '0'           after tpd;
         dly3EOC       <= '0'           after tpd;
         dly3EOF       <= '0'           after tpd;
         dly3EOFE      <= '0'           after tpd;
         dly3Data      <= (others=>'0') after tpd;
         dly4SOC       <= '0'           after tpd;
         dly4EOC       <= '0'           after tpd;
         dly4Data      <= (others=>'0') after tpd;
         dly5SOC       <= '0'           after tpd;
         dly5Data      <= (others=>'0') after tpd;
         dly6SOC       <= '0'           after tpd;
         dly7SOC       <= '0'           after tpd;
         inCellCrc     <= '0'           after tpd;
      elsif rising_edge(pgpClk) then

         -- CRC Enable
         if pibRxSOC = '1' then
           inCellCrc <= '1' after tpd;
         elsif pibRxEOC = '1' then
           inCellCrc <= '0' after tpd;
         end if;

         -- Delay stage 0
         dly0SOC   <= pibRxSOC    after tpd;
         dly0Width <= pibRxWidth  after tpd;
         dly0EOC   <= pibRxEOC    after tpd;
         dly0EOF   <= pibRxEOF    after tpd;
         dly0EOFE  <= pibRxEOFE   after tpd;
         dly0Data  <= pibRxData   after tpd;

         -- Delay stage 1
         dly1SOC   <= dly0SOC     after tpd;
         dly1Width <= dly0Width   after tpd;
         dly1EOC   <= dly0EOC     after tpd;
         dly1EOF   <= dly0EOF     after tpd;
         dly1EOFE  <= dly0EOFE    after tpd;
         dly1Data  <= dly0Data    after tpd;
        
         -- Delay stage 2
         dly2SOC   <= dly1SOC     after tpd;
         dly2Width <= dly1Width   after tpd;
         dly2EOC   <= dly1EOC     after tpd;
         dly2EOF   <= dly1EOF     after tpd;
         dly2EOFE  <= dly1EOFE    after tpd;
         dly2Data  <= dly1Data    after tpd;

         -- Delay stage 3
         dly3SOC   <= dly2SOC     after tpd;
         dly3Width <= dly2Width   after tpd;
         dly3EOC   <= dly2EOC     after tpd;
         dly3EOF   <= dly2EOF     after tpd;
         dly3EOFE  <= dly2EOFE    after tpd;
         dly3Data  <= dly2Data    after tpd;

         -- Delay stage 4
         dly4SOC   <= dly3SOC     after tpd;
         dly4EOC   <= dly3EOC     after tpd;
         dly4Data  <= dly3Data    after tpd;

         -- Delay stage 5
         dly5SOC   <= dly4SOC     after tpd;
         dly5Data  <= dly4Data    after tpd;

         -- Delay stage 6 & 7, extra for SOC to drop header
         dly6SOC   <= dly5SOC     after tpd;
         dly7SOC   <= dly6SOC     after tpd;
      end if;
   end process;


   -- MUX in frame status bits for transmit.
   -- Valid is asserted if current VC is active or the abort flag
   -- has been asserted.
   process ( intCellRxDataVc, cellVcInFrame, cellVcAbort ) begin
      case intCellRxDataVc is
         when "00"   => 
            muxFrameRxValid(0) <= cellVcInFrame(0) or cellVcAbort;
            muxFrameRxValid(1) <= '0';
            muxFrameRxValid(2) <= '0';
            muxFrameRxValid(3) <= '0';
         when "01"   => 
            muxFrameRxValid(0) <= '0';
            muxFrameRxValid(1) <= cellVcInFrame(1) or cellVcAbort;
            muxFrameRxValid(2) <= '0';
            muxFrameRxValid(3) <= '0';
         when "10"   => 
            muxFrameRxValid(0) <= '0';
            muxFrameRxValid(1) <= '0';
            muxFrameRxValid(2) <= cellVcInFrame(2) or cellVcAbort;
            muxFrameRxValid(3) <= '0';
         when "11"   => 
            muxFrameRxValid(0) <= '0';
            muxFrameRxValid(1) <= '0';
            muxFrameRxValid(2) <= '0';
            muxFrameRxValid(3) <= cellVcInFrame(3) or cellVcAbort;
         when others => muxFrameRxValid <= "0000";
      end case;
   end process;


   -- MUX SOF status bits for transmit.
   -- SOF is asserted if this is an SOF cell, the current VC is active 
   -- and the abort flag has not been asserted.
   process ( intCellRxDataVc, cellVcInFrame, cellVcAbort, intCellRxSOF ) begin
      case intCellRxDataVc is
         when "00"   => 
            muxFrameRxSOF(0) <= cellVcInFrame(0) and intCellRxSOF and not cellVcAbort;
            muxFrameRxSOF(1) <= '0';
            muxFrameRxSOF(2) <= '0';
            muxFrameRxSOF(3) <= '0';
         when "01"   => 
            muxFrameRxSOF(0) <= '0';
            muxFrameRxSOF(1) <= cellVcInFrame(1) and intCellRxSOF and not cellVcAbort;
            muxFrameRxSOF(2) <= '0';
            muxFrameRxSOF(3) <= '0';
         when "10"   => 
            muxFrameRxSOF(0) <= '0';
            muxFrameRxSOF(1) <= '0';
            muxFrameRxSOF(2) <= cellVcInFrame(2) and intCellRxSOF and not cellVcAbort;
            muxFrameRxSOF(3) <= '0';
         when "11"   => 
            muxFrameRxSOF(0) <= '0';
            muxFrameRxSOF(1) <= '0';
            muxFrameRxSOF(2) <= '0';
            muxFrameRxSOF(3) <= cellVcInFrame(3) and intCellRxSOF and not cellVcAbort;
         when others => muxFrameRxSOF <= "0000";
      end case;
   end process;


   -- Receive cell tracking
   process ( pgpClk, pgpReset ) begin
      if pgpReset = '1' then
         intCellRxSOF    <= '0'           after tpd;
         intCellRxDataVc <= "00"          after tpd;
         intCellRxEmpty  <= '0'           after tpd;
         cellRxSeq       <= (others=>'0') after tpd;
         cellRxAck       <= '0'           after tpd;
         cellRxNAck      <= '0'           after tpd;
         intBuffAFull    <= (others=>'0') after tpd;
         intBuffFull     <= (others=>'0') after tpd;
         cellSerial      <= "00"          after tpd;
         intFrameRxValid <= "0000"        after tpd;
         intFrameRxSOF   <= "0000"        after tpd;
         intFrameRxEOF   <= '0'           after tpd;
         intFrameRxEOFE  <= '0'           after tpd;
         intFrameRxWidth <= '0'           after tpd;
         intFrameRxData  <= (others=>'0') after tpd;
         cellRxDone      <= '0'           after tpd;
         intRxCellError  <= '0'           after tpd;
         interCellCount  <= (others=>'0') after tpd;
         expSerial       <= "00"          after tpd;
         inCellRx        <= '0'           after tpd;
         linkReadyDly    <= '0'           after tpd;
         firstCellRx     <= '0'           after tpd;
         cellRxSize      <= (others=>'0') after tpd;
         dropNextCell    <= '0'           after tpd;
         crcNotZero      <= '0'           after tpd;
         cellRxShort     <= '0'           after tpd;
      elsif rising_edge(pgpClk) then

         -- CRC Error
         if crcRxOut = 0 then 
            crcNotZero <= '0' after tpd;
         else
            crcNotZero <= '1' after tpd;
         end if;

         -- Delayed copy of link ready
         linkReadyDly <= pibLinkready after tpd;

         -- Register header data when enough data has been received
         if dly5SOC = '1' then

            -- Frame type, 
            -- Force empty flag if cell is marked to be dropped
            case dly5Data(15 downto 14) is
               when "00" => -- IDLE
                  intCellRxSOF   <= '0'          after tpd;
                  intCellRxEmpty <= '1'          after tpd;
                  cellRxAck      <= dly5Data(13) after tpd;
                  cellRxNAck     <= dly5Data(12) after tpd;
               when "01" => -- Payload
                  intCellRxSOF   <= '0'          after tpd;
                  intCellRxEmpty <= dropNextCell after tpd;
                  cellRxAck      <= dly5Data(13) after tpd;
                  cellRxNAck     <= dly5Data(12) after tpd;
               when "10" => -- Reserved
                  intCellRxSOF   <= '0'          after tpd;
                  intCellRxEmpty <= '1'          after tpd;
                  cellRxAck      <= '0'          after tpd;
                  cellRxNAck     <= '0'          after tpd;
               when "11" => -- SOF
                  intCellRxSOF   <= '1'          after tpd;
                  intCellRxEmpty <= dropNextCell after tpd;
                  cellRxAck      <= '0'          after tpd;
                  cellRxNAck     <= '0'          after tpd;
               when others =>
                  intCellRxSOF   <= '0'          after tpd;
                  intCellRxEmpty <= '0'          after tpd;
                  cellRxAck      <= '0'          after tpd;
                  cellRxNAck     <= '0'          after tpd;
            end case;

            -- Cell Flags
            intCellRxDataVc <= dly5Data(11 downto 10) after tpd;
            cellSerial      <= dly5Data(9  downto 8)  after tpd;
            cellRxSeq       <= dly4Data(7  downto 0)  after tpd;

            -- VC Flags
            intBuffFull  <= dly4Data(15 downto 12) after tpd;
            intBuffAFull <= dly4Data(11 downto  8) after tpd;
         end if;

         -- Inter cell counter, don't start count until first cell is received.
         if pibLinkReady = '0' then
            interCellCount <= (others=>'0') after tpd;
            firstCellRx    <= '0'           after tpd;
         elsif inCellRx = '1' then
            interCellCount <= (others=>'0') after tpd;
            firstCellRx    <= '1'           after tpd;
         elsif interCellCount /= 27 and firstCellRx = '1' then
            interCellCount <= interCellCount + 1 after tpd;
         end if;

         -- Count size of each cell received
         if inCellRx = '1' then
            cellRxSize <= cellRxSize + 1 after tpd;
         else
            cellRxSize <= (others=>'0') after tpd;
         end if;

         -- Link is down. 
         if pibLinkReady = '0' then

            -- Reset expected serial
            expSerial     <= "00"   after tpd;
            inCellRx      <= '0'    after tpd;
            dropNextCell  <= '0'    after tpd;
            intFrameRxSOF <= "0000" after tpd;

            -- Link just went down. Send EOFE to all active VCs
            if linkReadyDly = '1' then
               intFrameRxValid <= cellVcInFrame after tpd;
               intFrameRxEOF   <= '1'           after tpd;
               intFrameRxEOFE  <= '1'           after tpd;
            else
               intFrameRxValid <= "0000" after tpd;
               intFrameRxEOF   <= '0'    after tpd;
               intFrameRxEOFE  <= '0'    after tpd;
            end if;

        -- Special case for 1 or 2 byte cells. SOC in delay 7 pos and
        -- EOC in delay 3 pos.
        elsif dly7SOC = '1' and dly3EOC = '1' then

            -- Mark in frame
            inCellRx <= '1' after tpd;

            -- Receive is done
            cellRxDone <= '1' after tpd;

            -- Look for large gap between cells or cell number mismatch
            -- Mark all inFrame VCs as active and output error
            -- Set drop next cell flag if in pic mode
            -- Mark SOF for current VC if SOF Cell
            if interCellCount = 27 or expSerial /= cellSerial then
               intFrameRxValid <= cellVcInFrame   after tpd;
               intFrameRxEOF   <= '1'             after tpd;
               intFrameRxEOFE  <= '1'             after tpd;
               intRxCellError  <= '1'             after tpd;
               expSerial       <= cellSerial      after tpd;
               dropNextCell    <= intMode         after tpd;
               intFrameRxSOF   <= muxFrameRxSOF   after tpd;

            -- CRC Error, Mark all in frame VCs as active output EOF with error
            -- Set drop next cell flag if in pic mode
            -- Mark SOF for current VC if SOF Cell
            -- even if VC is in error, rx track will generate correct SOF
            -- which won't confuse external logic
            elsif crcNotZero = '1' then
               intFrameRxValid <= cellVcInFrame   after tpd;
               intFrameRxEOF   <= '1'             after tpd;
               intFrameRxEOFE  <= '1'             after tpd;
               intRxCellError  <= '1'             after tpd;
               dropNextCell    <= intMode         after tpd;
               intFrameRxSOF   <= muxFrameRxSOF   after tpd;

            -- Non-Errored Frame Reception,
            else

               -- Choose active VC if cell is not empty. 
               if intCellRxEmpty = '0' then
                  intFrameRxValid <= muxFrameRxValid after tpd;
                  intFrameRxSOF   <= muxFrameRxSOF   after tpd;
               end if;

               -- Clear drop next cell flag
               dropNextCell <= '0';

               -- Cell size enforecement. If cell is not an EOF and force cell
               -- size is asserted then end frame in error
               if intMode = '1' and dly3EOF = '0' and intCellRxEmpty = '0' then
                  intFrameRxEOF  <= '1' after tpd;
                  intFrameRxEOFE <= '1' after tpd;
                  cellRxShort    <= '1' after tpd;

               -- Set EOF and EOFE, force EOF and EOFE if abort is asserted
               else
                  intFrameRxEOF  <= dly3EOF  or cellVcAbort after tpd;
                  intFrameRxEOFE <= dly3EOFE or cellVcAbort after tpd;
               end if;
            end if;

         -- Start of data movement when SOC is in delay 7 position.
         elsif dly7SOC = '1' then

            -- Mark in frame
            inCellRx <= '1' after tpd;

            -- Look for large gap between cells or cell number mismatch
            -- Mark cell as in error and do not output to any VCs
            -- Mark SOF for current VC if SOF Cell
            if interCellCount = 27 or expSerial /= cellSerial then
               intFrameRxValid <= "0000"        after tpd;
               intRxCellError  <= '1'           after tpd;
               expSerial       <= cellSerial    after tpd;
               intFrameRxSOF   <= muxFrameRxSOF   after tpd;

            -- Normal cell reception, Choose active VC
            else

               -- Choose active VC if cell is not empty
               if intCellRxEmpty = '0' then
                  intFrameRxValid <= muxFrameRxValid after tpd;
                  intFrameRxSOF   <= muxFrameRxSOF   after tpd;
               end if;

               -- Clear drop next cell flag
               dropNextCell <= '0';
            end if;

         -- EOC arrives in delay position 3 when cell is done
         elsif dly3EOC = '1' then

            -- Receive is done
            cellRxDone    <= '1'    after tpd;
            intFrameRxSOF <= "0000" after tpd;

            -- End of frame forced by error, all active VCs get EOFE
            -- Set drop next cell flag if in pic mode
            if crcNotZero = '1' or intRxCellError = '1' then
               intFrameRxValid <= cellVcInFrame after tpd;
               intFrameRxEOF   <= '1'           after tpd;
               intFrameRxEOFE  <= '1'           after tpd;
               intRxCellError  <= '1'           after tpd;
               dropNextCell    <= intMode       after tpd;

            -- Cell size enforecement. If cell is not full, EOF is not asserted 
            -- and force cell size is asserted then end frame in error
            elsif intMode = '1' and dly3EOF = '0' and 
                  cellRxSize /= 254 and intCellRxEmpty = '0' then
               intFrameRxEOF  <= '1' after tpd;
               intFrameRxEOFE <= '1' after tpd;
               cellRxShort    <= '1' after tpd;

            -- Normal End of frame detected
            -- Set EOF and EOFE, force EOF and EOFE if abort is asserted
            else
               intFrameRxEOF  <= dly3EOF  or cellVcAbort after tpd;
               intFrameRxEOFE <= dly3EOFE or cellVcAbort after tpd;
            end if;

         -- Detect End Of Frame, clear flags
         elsif dly4EOC = '1' then

            -- Increment expected serial number for next cell
            expSerial <= expSerial + 1 after tpd;

            -- Clear EOF, Done, error and valid signals
            inCellRx        <= '0'    after tpd;
            intFrameRxSOF   <= "0000" after tpd;
            intFrameRxEOF   <= '0'    after tpd;
            intFrameRxEOFE  <= '0'    after tpd;
            cellRxDone      <= '0'    after tpd;
            intRxCellError  <= '0'    after tpd;
            intFrameRxValid <= "0000" after tpd;
            cellRxShort     <= '0'    after tpd;

         -- Clear SOF after first byte
         else 
            intFrameRxSOF <= "0000" after tpd;
         end if;

         -- Data output, width follows delay 4
         intFrameRxWidth <= dly3Width after tpd;
         intFrameRxData  <= dly5Data  after tpd;

      end if;
   end process;


   -- Update buffer status on successfull cell reception
   process ( pgpClk, pgpReset ) begin
      if pgpReset = '1' then
         vc0RemBuffAFull <= '1'           after tpd;
         vc0RemBuffFull  <= '1'           after tpd;
         vc1RemBuffAFull <= '1'           after tpd;
         vc1RemBuffFull  <= '1'           after tpd;
         vc2RemBuffAFull <= '1'           after tpd;
         vc2RemBuffFull  <= '1'           after tpd;
         vc3RemBuffAFull <= '1'           after tpd;
         vc3RemBuffFull  <= '1'           after tpd;
      elsif rising_edge(pgpClk) then

         -- Link is not ready, force buffer states to bad
         if pibLinkReady = '0' then
            vc0RemBuffAFull <= '1' after tpd;
            vc0RemBuffFull  <= '1' after tpd;
            vc1RemBuffAFull <= '1' after tpd;
            vc1RemBuffFull  <= '1' after tpd;
            vc2RemBuffAFull <= '1' after tpd;
            vc2RemBuffFull  <= '1' after tpd;
            vc3RemBuffAFull <= '1' after tpd;
            vc3RemBuffFull  <= '1' after tpd;

         -- Update buffer status if there was no CRC error
         elsif dly3EOC = '1' and crcNotZero = '0' then
            vc0RemBuffAFull <= intBuffAFull(0) after tpd;
            vc0RemBuffFull  <= intBuffFull(0)  after tpd;
            vc1RemBuffAFull <= intBuffAFull(1) after tpd;
            vc1RemBuffFull  <= intBuffFull(1)  after tpd;
            vc2RemBuffAFull <= intBuffAFull(2) after tpd;
            vc2RemBuffFull  <= intBuffFull(2)  after tpd;
            vc3RemBuffAFull <= intBuffAFull(3) after tpd;
            vc3RemBuffFull  <= intBuffFull(3)  after tpd;
         end if;
      end if;
   end process;

end PgpCellRx;

