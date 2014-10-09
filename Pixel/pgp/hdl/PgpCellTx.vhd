-------------------------------------------------------------------------------
-- Title         : Pretty Good Protocol, Cell Transmit Interface
-- Project       : General Purpose Core
-------------------------------------------------------------------------------
-- File          : PgpCellTx.vhd
-- Author        : Ryan Herbst, rherbst@slac.stanford.edu
-- Created       : 10/24/2006
-------------------------------------------------------------------------------
-- Description:
-- Cell Transmit interface module for the Pretty Good Protocol core. 
-------------------------------------------------------------------------------
-- Copyright (c) 2006 by Ryan Herbst. All rights reserved.
-------------------------------------------------------------------------------
-- Modification history:
-- 10/24/2006: created.
-- 04/16/2007: Modified to a more pipelined design alloing back to back cell
--             tranmission as well as fixing some bugs related to short frames
-- 04/18/2007: Added support to track the number of cells in a frame to detect
--             dropped cells.
-- 06/19/2007: Moved rand data logic into this block.
-- 07/19/2007: Removed support to track the number of cells in a frame. Added
--             cell sequence number.
-- 09/18/2007: Added logic to force error if width='0' without EOF
-- 09/21/2007: Removed payload imput
-------------------------------------------------------------------------------

LIBRARY ieee;
USE work.ALL;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity PgpCellTx is port ( 

      -- System clock, reset & control
      pgpClk            : in  std_logic;                     -- Master clock
      pgpReset          : in  std_logic;                     -- Synchronous reset input

      -- PIB Interface
      pibLinkReady      : in  std_logic;                     -- PIB Link Ready

      -- Transmit Scheduler Interface
      cellTxDataSeq     : in  std_logic_vector(7  downto 0); -- Transmit sequence number
      cellTxSOF         : out std_logic;                     -- Cell contained SOF
      cellTxEOF         : out std_logic;                     -- Cell contained EOF
      cellTxIdle        : in  std_logic;                     -- Force IDLE transmit
      cellTxReq         : in  std_logic;                     -- Cell transmit request
      cellTxInp         : out std_logic;                     -- Cell transmit in progress
      cellTxDataVc      : in  std_logic_vector(1  downto 0); -- Cell transmit virtual channel

      -- ACK/NACK Transmit Logic
      cellTxNAck        : in  std_logic;                     -- Cell transmit NACK request
      cellTxAck         : in  std_logic;                     -- Cell transmit ACK request
      cellTxAckSeq      : in  std_logic_vector(7 downto 0);  -- Cell transmit ACK sequence
      cellTxAcked       : out std_logic;                     -- Cell transmit ACK was sent

      -- Frame Transmit Interface, VC 0
      vc0FrameTxValid   : in  std_logic;                     -- User frame data is valid
      vc0FrameTxReady   : out std_logic;                     -- PGP is ready
      vc0FrameTxSOF     : in  std_logic;                     -- User frame data start of frame
      vc0FrameTxWidth   : in  std_logic;                     -- User frame data width
      vc0FrameTxEOF     : in  std_logic;                     -- User frame data end of frame
      vc0FrameTxEOFE    : in  std_logic;                     -- User frame data error
      vc0FrameTxData    : in  std_logic_vector(15 downto 0); -- User frame data
      vc0LocBuffAFull   : in  std_logic;                     -- Remote buffer almost full
      vc0LocBuffFull    : in  std_logic;                     -- Remote buffer full

      -- Frame Transmit Interface, VC 1
      vc1FrameTxValid   : in  std_logic;                     -- User frame data is valid
      vc1FrameTxReady   : out std_logic;                     -- PGP is ready
      vc1FrameTxSOF     : in  std_logic;                     -- User frame data start of frame
      vc1FrameTxWidth   : in  std_logic;                     -- User frame data width
      vc1FrameTxEOF     : in  std_logic;                     -- User frame data end of frame
      vc1FrameTxEOFE    : in  std_logic;                     -- User frame data error
      vc1FrameTxData    : in  std_logic_vector(15 downto 0); -- User frame data
      vc1LocBuffAFull   : in  std_logic;                     -- Remote buffer almost full
      vc1LocBuffFull    : in  std_logic;                     -- Remote buffer full

      -- Frame Transmit Interface, VC 2
      vc2FrameTxValid   : in  std_logic;                     -- User frame data is valid
      vc2FrameTxReady   : out std_logic;                     -- PGP is ready
      vc2FrameTxSOF     : in  std_logic;                     -- User frame data start of frame
      vc2FrameTxWidth   : in  std_logic;                     -- User frame data width
      vc2FrameTxEOF     : in  std_logic;                     -- User frame data end of frame
      vc2FrameTxEOFE    : in  std_logic;                     -- User frame data error
      vc2FrameTxData    : in  std_logic_vector(15 downto 0); -- User frame data
      vc2LocBuffAFull   : in  std_logic;                     -- Remote buffer almost full
      vc2LocBuffFull    : in  std_logic;                     -- Remote buffer full

      -- Frame Transmit Interface, VC 3
      vc3FrameTxValid   : in  std_logic;                     -- User frame data is valid
      vc3FrameTxReady   : out std_logic;                     -- PGP is ready
      vc3FrameTxSOF     : in  std_logic;                     -- User frame data start of frame
      vc3FrameTxWidth   : in  std_logic;                     -- User frame data width
      vc3FrameTxEOF     : in  std_logic;                     -- User frame data end of frame
      vc3FrameTxEOFE    : in  std_logic;                     -- User frame data error
      vc3FrameTxData    : in  std_logic_vector(15 downto 0); -- User frame data
      vc3LocBuffAFull   : in  std_logic;                     -- Remote buffer almost full
      vc3LocBuffFull    : in  std_logic;                     -- Remote buffer full

      -- PHY Interface
      pibTxSOC          : out std_logic;                     -- Cell data start of cell
      pibTxWidth        : out std_logic;                     -- Cell data width
      pibTxEOC          : out std_logic;                     -- Cell data end of cell
      pibTxEOF          : out std_logic;                     -- Cell data end of frame
      pibTxEOFE         : out std_logic;                     -- Cell data end of frame error
      pibTxData         : out std_logic_vector(15 downto 0); -- Cell data data

      -- Transmit CRC Interface
      crcTxIn           : out std_logic_vector(15 downto 0); -- Transmit data for CRC
      crcTxInit         : out std_logic;                     -- Transmit CRC value init
      crcTxValid        : out std_logic;                     -- Transmit data for CRC is valid
      crcTxWidth        : out std_logic;                     -- Transmit data for CRC width
      crcTxOut          : in  std_logic_vector(31 downto 0)  -- Transmit calculated CRC value
   );

end PgpCellTx;


-- Define architecture
architecture PgpCellTx of PgpCellTx is

   -- Local Signals
   signal muxFrameTxValid    : std_logic;
   signal muxFrameTxSOF      : std_logic;
   signal muxFrameTxWidth    : std_logic;
   signal muxFrameTxEOF      : std_logic;
   signal muxFrameTxEOFE     : std_logic;
   signal muxFrameTxData     : std_logic_vector(15 downto 0);
   signal dlyFrameTxData     : std_logic_vector(15 downto 0);
   signal dlyFrameTxEOF      : std_logic;
   signal dlyFrameTxEOFE     : std_logic;
   signal dlyFrameTxWidth    : std_logic;
   signal selSOC             : std_logic;
   signal selValid           : std_logic;
   signal selWidth           : std_logic;
   signal selEOF             : std_logic;
   signal selEOFE            : std_logic;
   signal selCrcMask         : std_logic_vector(3  downto 0);
   signal selData            : std_logic_vector(15 downto 0);
   signal frameReadyOut      : std_logic;
   signal payloadCount       : std_logic_vector(8  downto 0);
   signal dly1TxSOC          : std_logic;
   signal dly1TxEOF          : std_logic;
   signal dly1TxEOFE         : std_logic;
   signal dly1CrcMask        : std_logic_vector(3  downto 0);
   signal dly1TxData         : std_logic_vector(15 downto 0);
   signal dly2TxSOC          : std_logic;
   signal dly2TxEOF          : std_logic;
   signal dly2TxEOFE         : std_logic;
   signal dly2CrcMask        : std_logic_vector(3  downto 0);
   signal dly2TxData         : std_logic_vector(15 downto 0);
   signal dly3TxSOC          : std_logic;
   signal dly3TxEOF          : std_logic;
   signal dly3TxEOFE         : std_logic;
   signal dly3CrcMask        : std_logic_vector(3  downto 0);
   signal dly3TxData         : std_logic_vector(15 downto 0);
   signal dly4TxSOC          : std_logic;
   signal dly4TxEOF          : std_logic;
   signal dly4TxEOFE         : std_logic;
   signal dly4CrcMask        : std_logic_vector(3  downto 0);
   signal dly4TxData         : std_logic_vector(15 downto 0);
   signal nextAcked          : std_logic;
   signal randData           : std_logic_vector(15 downto 0);
   signal cellSerial         : std_logic_vector(1  downto 0);

   -- Transmit states
   signal   txState  : std_logic_vector(2 downto 0);
   constant ST_IDLE  : std_logic_vector(2 downto 0) := "000";
   constant ST_HEAD0 : std_logic_vector(2 downto 0) := "001";
   constant ST_HEAD1 : std_logic_vector(2 downto 0) := "010";
   constant ST_PAYLD : std_logic_vector(2 downto 0) := "011";
   constant ST_CRC01 : std_logic_vector(2 downto 0) := "100";
   constant ST_CRC23 : std_logic_vector(2 downto 0) := "101";
   constant ST_CRC12 : std_logic_vector(2 downto 0) := "110";
   constant ST_CRC3  : std_logic_vector(2 downto 0) := "111";

   -- Register delay for simulation
   constant tpd:time := 0.5 ns;

begin

   -- Interface to CRC calculator
   crcTxInit  <= selSOC;
   crcTxValid <= selValid;
   crcTxWidth <= selWidth;

   -- Crc data may be switched
   crcTxIn(7  downto 0) <= selData(7  downto 0) when selSOC = '0' else selData(15 downto 8);
   crcTxIn(15 downto 8) <= selData(15 downto 8) when selSOC = '0' else selData(7  downto 0);


   -- Mux incoming data depending on squence number, drive outgoing ready
   process ( cellTxDataVc, vc0FrameTxValid, vc0FrameTxSOF, vc0FrameTxWidth, 
             vc0FrameTxEOF, vc0FrameTxEOFE, vc0FrameTxData, vc1FrameTxValid, 
             vc1FrameTxSOF, vc1FrameTxWidth, vc1FrameTxEOF, vc1FrameTxEOFE, 
             vc1FrameTxData, vc2FrameTxValid, vc2FrameTxSOF, vc2FrameTxWidth,
             vc2FrameTxEOF, vc2FrameTxEOFE, vc2FrameTxData, vc3FrameTxValid, 
             vc3FrameTxSOF, vc3FrameTxWidth, vc3FrameTxEOF, vc3FrameTxEOFE,
             vc3FrameTxData, frameReadyOut, cellTxIdle, randData ) begin

      -- Use random data when not transmitting a frame or when
      -- transmitting the payload of an IDLE cell
      if cellTxIdle = '1' then
         muxFrameTxValid <= '1';
         muxFrameTxSOF   <= '0';
         muxFrameTxWidth <= '1';
         muxFrameTxEOF   <= '0';
         muxFrameTxEOFE  <= '0';
         muxFrameTxData  <= randData;
         vc0FrameTxReady <= '0';
         vc1FrameTxReady <= '0';
         vc2FrameTxReady <= '0';
         vc3FrameTxReady <= '0';

      -- Choose virtual channel when not transmitting IDLE cell and when
      -- scheduler wants a frame transmitted.
      else case cellTxDataVc is
         when "00" =>
            muxFrameTxValid <= vc0FrameTxValid;
            muxFrameTxSOF   <= vc0FrameTxSOF;
            muxFrameTxWidth <= vc0FrameTxWidth;
            muxFrameTxEOF   <= vc0FrameTxEOF;
            muxFrameTxEOFE  <= vc0FrameTxEOFE;
            muxFrameTxData  <= vc0FrameTxData;
            vc0FrameTxReady <= frameReadyOut;
            vc1FrameTxReady <= '0';
            vc2FrameTxReady <= '0';
            vc3FrameTxReady <= '0';
         when "01" =>
            muxFrameTxValid <= vc1FrameTxValid;
            muxFrameTxSOF   <= vc1FrameTxSOF;
            muxFrameTxWidth <= vc1FrameTxWidth;
            muxFrameTxEOF   <= vc1FrameTxEOF;
            muxFrameTxEOFE  <= vc1FrameTxEOFE;
            muxFrameTxData  <= vc1FrameTxData;
            vc0FrameTxReady <= '0';
            vc1FrameTxReady <= frameReadyOut;
            vc2FrameTxReady <= '0';
            vc3FrameTxReady <= '0';
         when "10" =>
            muxFrameTxValid <= vc2FrameTxValid;
            muxFrameTxSOF   <= vc2FrameTxSOF;
            muxFrameTxWidth <= vc2FrameTxWidth;
            muxFrameTxEOF   <= vc2FrameTxEOF;
            muxFrameTxEOFE  <= vc2FrameTxEOFE;
            muxFrameTxData  <= vc2FrameTxData;
            vc0FrameTxReady <= '0';
            vc1FrameTxReady <= '0';
            vc2FrameTxReady <= frameReadyOut;
            vc3FrameTxReady <= '0';
         when "11" =>
            muxFrameTxValid <= vc3FrameTxValid;
            muxFrameTxSOF   <= vc3FrameTxSOF;
            muxFrameTxWidth <= vc3FrameTxWidth;
            muxFrameTxEOF   <= vc3FrameTxEOF;
            muxFrameTxEOFE  <= vc3FrameTxEOFE;
            muxFrameTxData  <= vc3FrameTxData;
            vc0FrameTxReady <= '0';
            vc1FrameTxReady <= '0';
            vc2FrameTxReady <= '0';
            vc3FrameTxReady <= frameReadyOut;
         when others =>
            muxFrameTxValid <= '0';
            muxFrameTxSOF   <= '0';
            muxFrameTxWidth <= '0';
            muxFrameTxEOF   <= '0';
            muxFrameTxEOFE  <= '0';
            muxFrameTxData  <= (others=>'0');
            vc0FrameTxReady <= '0';
            vc1FrameTxReady <= '0';
            vc2FrameTxReady <= '0';
            vc3FrameTxReady <= '0';
      end case;
      end if;
   end process;


   -- Payload counter used to limit payload size of frames
   process ( pgpClk, pgpReset ) begin
      if pgpReset = '1' then
         payloadCount <= (others=>'0') after tpd;
      elsif rising_edge(pgpClk) then
         if txState = ST_PAYLD then
            payloadCount <= payloadCount + 1 after tpd;
         else
            payloadCount <= (others=>'0') after tpd;
         end if;
      end if;
   end process;


   -- Simple state machine to control transmission of data frames
   -- Control input state of delay chain
   process ( pgpClk, pgpReset ) begin
      if pgpReset = '1' then
         dlyFrameTxData   <= (others=>'0') after tpd;
         dlyFrameTxEOF    <= '0'           after tpd;
         dlyFrameTxEOFE   <= '0'           after tpd;
         dlyFrameTxWidth  <= '0'           after tpd;
         cellTxSOF        <= '0'           after tpd;
         cellTxEOF        <= '0'           after tpd;
         cellTxInp        <= '0'           after tpd;
         cellTxAcked      <= '0'           after tpd;
         nextAcked        <= '0'           after tpd;
         frameReadyOut    <= '0'           after tpd;
         selSOC           <= '0'           after tpd;
         selValid         <= '0'           after tpd;
         selWidth         <= '0'           after tpd;
         selEOF           <= '0'           after tpd;
         selEOFE          <= '0'           after tpd;
         selCrcMask       <= "0000"        after tpd;
         selData          <= (others=>'0') after tpd;
         txState          <= ST_IDLE       after tpd;
         cellSerial       <= "00"          after tpd;

      elsif rising_edge(pgpClk) then

         -- Muxed data delay stage
         dlyFrameTxData  <= muxFrameTxData  after tpd;
         dlyFrameTxEOF   <= muxFrameTxEOF   after tpd;
         dlyFrameTxEOFE  <= muxFrameTxEOFE  after tpd;
         dlyFrameTxWidth <= muxFrameTxWidth after tpd;

         -- Delayed version of acked
         cellTxAcked <= nextAcked;

         -- Link is not ready
         if pibLinkReady = '0' then
            cellTxSOF     <= '0'           after tpd;
            cellTxEOF     <= '0'           after tpd;
            nextAcked     <= '0'           after tpd;
            selValid      <= '0'           after tpd;
            selWidth      <= '0'           after tpd;
            selSOC        <= '0'           after tpd;
            selEOF        <= '0'           after tpd;
            selEOFE       <= '0'           after tpd;
            selCrcMask    <= "0000"        after tpd;
            selData       <= (others=>'0') after tpd;
            frameReadyOut <= '0'           after tpd;
            cellTxInp     <= '0'           after tpd;
            cellSerial    <= "00"          after tpd;
            txState       <= ST_IDLE       after tpd;

         -- Transmit state engine
         else case txState is 

            -- IDLE, waiting for frame, no data on sel
            when ST_IDLE =>

               -- Clear Flags
               cellTxEOF     <= '0' after tpd;
               nextAcked     <= '0' after tpd;
               frameReadyOut <= '0' after tpd;

               -- No Data  
               selValid   <= '0'      after tpd;
               selWidth   <= '0'      after tpd;
               selEOF     <= '0'      after tpd;
               selEOFE    <= '0'      after tpd;
               selCrcMask <= "0000"   after tpd;
               selData    <= randData after tpd;

               -- Wait for transmit control from scheduler
               if cellTxReq = '1' then

                  -- Set in frame mode
                  txState   <= ST_HEAD0 after tpd;
                  cellTxInp <= '1'      after tpd;

                  -- Assert SOF, payload flags as early as possible
                  cellTxSOF   <= not cellTxIdle and muxFrameTxSOF     after tpd;
               else
                  cellTxInp   <= '0' after tpd;
                  cellTxSOF   <= '0' after tpd;
               end if;

            -- Header 0, data is SOC placeholder and header byte 0
            when ST_HEAD0 =>

               -- Assert ready
               selSOC      <= '1' after tpd;
               cellTxSOF   <= '0' after tpd;

               -- Assert flags to external blocks, some fields depend on frame type
               -- IDLE cell
               if cellTxIdle = '1' then
                  frameReadyOut         <= '0'                     after tpd;
                  nextAcked             <= cellTxAck or cellTxNack after tpd;
                  selData(15 downto 14) <= "00"                    after tpd; -- Cell Type
                  selData(13)           <= cellTxAck               after tpd; -- Ack Bit
                  selData(12)           <= cellTxNAck              after tpd; -- Nack Bit
                  selData(11 downto 10) <= "00"                    after tpd; -- VC 

               -- SOF Frame
               elsif muxFrameTxSOF = '1' then
                  frameReadyOut         <= '1'           after tpd;
                  nextAcked             <= '0'           after tpd;
                  selData(15 downto 14) <= "11"          after tpd; -- Cell Type
                  selData(13)           <= '0'           after tpd; -- Ack Bit
                  selData(12)           <= '0'           after tpd; -- Nack Bit
                  selData(11 downto 10) <= cellTxDataVc  after tpd; -- VC

               -- Payload
               else 
                  frameReadyOut         <= '1'                     after tpd;
                  nextAcked             <= cellTxAck or cellTxNack after tpd;
                  selData(15 downto 14) <= "01"                    after tpd; -- Cell Type
                  selData(13)           <= cellTxAck               after tpd; -- Ack Bit
                  selData(12)           <= cellTxNAck              after tpd; -- Nack Bit
                  selData(11 downto 10) <= cellTxDataVc            after tpd; -- VC 
               end if;

               -- Delay pipeline input
               selValid             <= '1'        after tpd;
               selWidth             <= '0'        after tpd;
               selData(9  downto 8) <= cellSerial after tpd; -- Cell serial number

               -- Increment serial number
               cellSerial <= cellSerial + 1 after tpd;

               -- Go to header 1 state
               txState <= ST_HEAD1 after tpd;

            -- Header 1, data is header bytes 1 & 2
            when ST_HEAD1 =>

               -- Clear flags
               selSOC       <= '0' after tpd;
               cellTxSOF    <= '0' after tpd;
               nextAcked    <= '0' after tpd;

               -- Delay pipeline input
               selWidth     <= '1'               after tpd;
               selData(15)  <= vc3LocBuffFull    after tpd;
               selData(14)  <= vc2LocBuffFull    after tpd;
               selData(13)  <= vc1LocBuffFull    after tpd;
               selData(12)  <= vc0LocBuffFull    after tpd;
               selData(11)  <= vc3LocBuffAFull   after tpd;
               selData(10)  <= vc2LocBuffAFull   after tpd;
               selData(9)   <= vc1LocBuffAFull   after tpd;
               selData(8)   <= vc0LocBuffAFull   after tpd;

               -- Lower byte depends on frame type
               if nextAcked = '1' then
                  selData(7 downto 0) <= cellTxAckSeq  after tpd; -- Ack/Nack seq num
               else
                  selData(7 downto 0) <= cellTxDataSeq after tpd; -- Data frame seq num
               end if;

               -- EOF is passed at input
               if muxFrameTxEOF = '1' then
                  frameReadyOut <= '0' after tpd;
               end if;

               -- Process payload data
               txState <= ST_PAYLD after tpd;

            -- Payload data
            when ST_PAYLD =>

               -- Delay pipeline input
               selValid   <= '1'    after tpd;

               -- EOF
               if dlyFrameTxEOF = '1' then 

                  -- Store error flag for later
                  selEOF   <= '1'            after tpd;
                  selEOFE  <= dlyFrameTxEOFE after tpd;

                  -- Width = 0, overwrite upper byte with CRC byte 0
                  if dlyFrameTxWidth = '0' then 
                     selData    <= dlyFrameTxData after tpd;
                     txState    <= ST_CRC12       after tpd;
                     selCrcMask <= "0001"         after tpd;
                     selWidth   <= '0'            after tpd;

                  -- Width = 1
                  else 
                     selData    <= dlyFrameTxData after tpd;
                     txState    <= ST_CRC01       after tpd;
                     selCrcMask <= "0000"         after tpd;
                     selWidth   <= '1'            after tpd;
                  end if;

               -- Ready de-asserted by user or valid de-asserted by local logic 
               elsif frameReadyOut = '0' or muxFrameTxValid = '0' then
                  selData    <= dlyFrameTxData after tpd;
                  txState    <= ST_CRC01       after tpd;
                  selCrcMask <= "0000"         after tpd;
                  selWidth   <= '1'            after tpd;

               -- Normal data. Pass width flag to CRC generator. This will ensure an
               -- error occurs if user de-asserts width flag without EOF.
               else
                  selData    <= dlyFrameTxData  after tpd;
                  selCrcMask <= "0000"          after tpd;
                  selWidth   <= dlyFrameTxWidth after tpd;
               end if;

               -- EOF is passed at input or user has de-asserted valid
               if muxFrameTxValid = '0' or muxFrameTxEOF = '1' then
                  frameReadyOut <= '0' after tpd;

               -- Payload size exceeded or idle size has been reached
               elsif payloadCount = 254 or (payloadCount = 4 and cellTxIdle = '1') then
                  frameReadyOut <= '0' after tpd;
               end if;

            -- CRC bytes 01, even alignment
            when ST_CRC01 => 
               selWidth   <= '1'      after tpd;
               selValid   <= '0'      after tpd;
               selCrcMask <= "0011"   after tpd;
               txState    <= ST_CRC23 after tpd;

            -- CRC bytes 23, even alignment
            when ST_CRC23 => 
               selWidth   <= '1'      after tpd;
               selValid   <= '0'      after tpd;
               selCrcMask <= "1100"   after tpd;
               cellTxEOF  <= selEOF   after tpd;
               txState    <= ST_IDLE  after tpd;

            -- CRC bytes 12, odd alignment
            when ST_CRC12 => 
               selWidth   <= '1'      after tpd;
               selValid   <= '0'      after tpd;
               selCrcMask <= "0110"   after tpd;
               txState    <= ST_CRC3  after tpd;

            -- CRC byte 3, odd alignment
            when ST_CRC3 => 
               selWidth   <= '0'      after tpd;
               selValid   <= '0'      after tpd;
               selCrcMask <= "1000"   after tpd;
               cellTxEOF  <= selEOF   after tpd;
               txState    <= ST_IDLE  after tpd;

            -- Just in case
            when others => txState <= ST_IDLE after tpd;
         end case;
         end if;
      end if;
   end process;


   -- The rest of the delay chain. A delay is required in order to compensate
   -- for the latency of the CRC generator.
   process ( pgpClk, pgpReset ) begin
      if pgpReset = '1' then
         dly1TxSOC   <= '0'           after tpd;
         dly1TxEOF   <= '0'           after tpd;
         dly1TxEOFE  <= '0'           after tpd;
         dly1CrcMask <= "0000"        after tpd;
         dly1TxData  <= (others=>'0') after tpd;
         dly2TxSOC   <= '0'           after tpd;
         dly2TxEOF   <= '0'           after tpd;
         dly2TxEOFE  <= '0'           after tpd;
         dly2CrcMask <= "0000"        after tpd;
         dly2TxData  <= (others=>'0') after tpd;
         dly3TxSOC   <= '0'           after tpd;
         dly3TxEOF   <= '0'           after tpd;
         dly3TxEOFE  <= '0'           after tpd;
         dly3CrcMask <= "0000"        after tpd;
         dly3TxData  <= (others=>'0') after tpd;
         dly4TxSOC   <= '0'           after tpd;
         dly4TxEOF   <= '0'           after tpd;
         dly4TxEOFE  <= '0'           after tpd;
         dly4CrcMask <= "0000"        after tpd;
         dly4TxData  <= (others=>'0') after tpd;
      elsif rising_edge(pgpClk) then

         -- Delay stage 1
         dly1TxSOC   <= selSOC     after tpd;
         dly1TxEOF   <= selEOF     after tpd;
         dly1TxEOFE  <= selEOFE    after tpd;
         dly1CrcMask <= selCrcMask after tpd;
         dly1TxData  <= selData    after tpd;

         -- Delay stage 2
         dly2TxSOC   <= dly1TxSOC   after tpd;
         dly2TxEOF   <= dly1TxEOF   after tpd;
         dly2TxEOFE  <= dly1TxEOFE  after tpd;
         dly2CrcMask <= dly1CrcMask after tpd;
         dly2TxData  <= dly1TxData  after tpd;

         -- Delay stage 3
         dly3TxSOC   <= dly2TxSOC   after tpd;
         dly3TxEOF   <= dly2TxEOF   after tpd;
         dly3TxEOFE  <= dly2TxEOFE  after tpd;
         dly3CrcMask <= dly2CrcMask after tpd;
         dly3TxData  <= dly2TxData  after tpd;

         -- Delay stage 3
         dly4TxSOC   <= dly3TxSOC   after tpd;
         dly4TxEOF   <= dly3TxEOF   after tpd;
         dly4TxEOFE  <= dly3TxEOFE  after tpd;
         dly4CrcMask <= dly3CrcMask after tpd;
         dly4TxData  <= dly3TxData  after tpd;
      end if;
   end process;


   -- Output stage, either real data or insert CRC values
   process ( pgpClk, pgpReset ) begin
      if pgpReset = '1' then
         pibTxSOC   <= '0' after tpd;
         pibTxWidth <= '0' after tpd;
         pibTxEOC   <= '0' after tpd;
         pibTxEOF   <= '0' after tpd;
         pibTxEOFE  <= '0' after tpd;
         pibTxData  <= (others=>'0') after tpd;

      elsif rising_edge(pgpClk) then

         -- Data depends on state of shifted CRC mask
         case dly4CrcMask is 

            -- Normal data
            when "0000" =>
               pibTxSOC   <= dly4TxSOC  after tpd;
               pibTxWidth <= '1'        after tpd;
               pibTxEOC   <= '0'        after tpd;
               pibTxEOF   <= '0'        after tpd;
               pibTxEOFE  <= '0'        after tpd;
               pibTxData  <= dly4TxData after tpd;

            -- Partial CRC in upper byte
            when "0001" =>
               pibTxSOC   <= '0' after tpd;
               pibTxWidth <= '1' after tpd;
               pibTxEOC   <= '0' after tpd;
               pibTxEOF   <= '0' after tpd;
               pibTxEOFE  <= '0' after tpd;
               pibTxData(7  downto 0) <= dly4TxData(7 downto 0) after tpd;
               pibTxData(15 downto 8) <= crcTxOut(31 downto 24) after tpd;

            -- Shifted CRC
            when "0110" =>
               pibTxSOC   <= '0' after tpd;
               pibTxWidth <= '1' after tpd;
               pibTxEOC   <= '0' after tpd;
               pibTxEOF   <= '0' after tpd;
               pibTxEOFE  <= '0' after tpd;
               pibTxData(7  downto 0) <= crcTxOut(23 downto 16) after tpd;
               pibTxData(15 downto 8) <= crcTxOut(15 downto 8)  after tpd;

            -- Partial CRC in lower byte, end of cell
            when "1000" =>
               pibTxSOC   <= '0'        after tpd;
               pibTxWidth <= '0'        after tpd;
               pibTxEOC   <= '1'        after tpd;
               pibTxEOF   <= dly4TxEOF  after tpd;
               pibTxEOFE  <= dly4TxEOFE after tpd;
               pibTxData(7  downto 0) <= crcTxOut(7 downto 0) after tpd;
               pibTxData(15 downto 8) <= (others=>'0')        after tpd;

            -- Full CRC
            when "0011" =>
               pibTxSOC   <= '0' after tpd;
               pibTxWidth <= '1' after tpd;
               pibTxEOC   <= '0' after tpd;
               pibTxEOF   <= '0' after tpd;
               pibTxEOFE  <= '0' after tpd;
               pibTxData(7  downto 0) <= crcTxOut(31 downto 24) after tpd;
               pibTxData(15 downto 8) <= crcTxOut(23 downto 16) after tpd;

            -- Full CRC, end of cell
            when "1100" => 
               pibTxSOC   <= '0'        after tpd;
               pibTxWidth <= '1'        after tpd;
               pibTxEOC   <= '1'        after tpd;
               pibTxEOF   <= dly4TxEOF  after tpd;
               pibTxEOFE  <= dly4TxEOFE after tpd;
               pibTxData(7  downto 0) <= crcTxOut(15 downto 8) after tpd;
               pibTxData(15 downto 8) <= crcTxOut(7  downto 0) after tpd;

            when others =>
               pibTxSOC   <= '0' after tpd;
               pibTxWidth <= '1' after tpd;
               pibTxEOC   <= '0' after tpd;
               pibTxEOF   <= '0' after tpd;
               pibTxEOFE  <= '0' after tpd;
               pibTxData  <= dly4TxData after tpd;
         end case;
      end if;
   end process;


   -- Random data generator
   process ( pgpClk, pgpReset ) begin
      if pgpReset = '1' then
         randData <= (others =>'0') after tpd;
      elsif rising_edge(pgpClk) then
         randData <= randData + 1 after tpd;
      end if;
   end process;

end PgpCellTx;

