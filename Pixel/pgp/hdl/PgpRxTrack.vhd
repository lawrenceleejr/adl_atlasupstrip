-------------------------------------------------------------------------------
-- Title         : Pretty Good Protocol, Receive Tracking Block
-- Project       : General Purpose Core
-------------------------------------------------------------------------------
-- File          : PgpRxTrack.vhd
-- Author        : Ryan Herbst, rherbst@slac.stanford.edu
-- Created       : 10/24/2006
-------------------------------------------------------------------------------
-- Description:
-- Receive Tracking logic module for the Pretty Good Protocol core. 
-------------------------------------------------------------------------------
-- Copyright (c) 2006 by Ryan Herbst. All rights reserved.
-------------------------------------------------------------------------------
-- Modification history:
-- 10/24/2006: created.
-- 04/18/2007: Added support to track the number of cells in a frame to detect
--             dropped cells.
-- 06/19/2007: Included PgpAckTx block to reduce file count.
-- 07/25/2007: In frame status of all VCs is now output. Cell CRC error changed
--             to cell rx error.
-- 09/18/2007: Changed code go generate abort flag if SOF is received while 
--             the VC is in the in-frame state. This will cause the current VC
--             to receive EOF/EOFE combination.
-- 09/29/2007: Changed name of coregen blocks
-- 11/06/2007: Added cellRxShort flag to indicate to tracking logic that EOFE
--             was generated due to short cell.
-------------------------------------------------------------------------------

LIBRARY ieee;
USE work.ALL;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity PgpRxTrack is port ( 

      -- System clock, reset & control
      pgpClk            : in  std_logic;                    -- Master clock
      pgpReset          : in  std_logic;                    -- Synchronous reset input

      -- PIB Interface
      pibLinkReady      : in  std_logic;                    -- PIB Link Ready

      -- Error Indication
      ackFifoFull       : out std_logic;                    -- ACK FIFO is full

      -- Cell Receiver Block
      cellRxSOF         : in  std_logic;                    -- Cell contained SOF
      cellRxDataVc      : in  std_logic_vector(1 downto 0); -- Cell virtual channel
      cellRxEOF         : in  std_logic;                    -- Cell contained EOF
      cellRxEOFE        : in  std_logic;                    -- Cell contained EOFE
      cellRxEmpty       : in  std_logic;                    -- Cell was empty
      cellRxStart       : in  std_logic;                    -- Cell reception start
      cellRxDone        : in  std_logic;                    -- Cell reception done
      cellRxShort       : in  std_logic;                     -- Cell receieve is short (PIC Mode)
      cellRxCellError   : in  std_logic;                    -- Cell receieve error
      cellRxSeq         : in  std_logic_vector(7 downto 0); -- Cell receieve sequence
      cellVcInFrame     : out std_logic_vector(3 downto 0); -- Cell VC in frame status
      cellVcAbort       : out std_logic;                    -- Cell abort flag for current VC

      -- Cell Transmit Logic & schedular
      cellTxNAck        : out std_logic;                    -- Cell transmit NACK request
      cellTxAck         : out std_logic;                    -- Cell transmit ACK request
      cellTxAckSeq      : out std_logic_vector(7 downto 0); -- Cell transmit ACK sequence
      cellTxAcked       : in  std_logic;                    -- Cell transmit ACK was sent
      cellTxAckReq      : out std_logic                     -- Cell transmit ACK request
   );

end PgpRxTrack;


-- Define architecture
architecture PgpRxTrack of PgpRxTrack is

   -- ACK/NACK FIFO, 9 * 256
   component pgp_fifo_9x256 port (
      clk:        IN  std_logic;
      rst:        IN  std_logic;
      din:        IN  std_logic_VECTOR(8 downto 0);
      wr_en:      IN  std_logic;
      rd_en:      IN  std_logic;
      dout:       OUT std_logic_VECTOR(8 downto 0);
      full:       OUT std_logic;
      empty:      OUT std_logic
   ); end component;

   -- Local Signals
   signal vc0InFrame        : std_logic;
   signal vc0SeqNum         : std_logic_vector(7 downto 0);
   signal vc1InFrame        : std_logic;
   signal vc1SeqNum         : std_logic_vector(7 downto 0);
   signal vc2InFrame        : std_logic;
   signal vc2SeqNum         : std_logic_vector(7 downto 0);
   signal vc3InFrame        : std_logic;
   signal vc3SeqNum         : std_logic_vector(7 downto 0);
   signal muxInFrame        : std_logic;
   signal muxSeqNum         : std_logic_vector(7 downto 0);
   signal ackTxFifoDin      : std_logic_vector(8 downto 0);
   signal ackTxFifoDout     : std_logic_vector(8 downto 0);
   signal ackTxFifoWr       : std_logic;
   signal ackTxFifoRd       : std_logic;
   signal ackTxFifoRdDly    : std_logic;
   signal ackTxFifoFull     : std_logic;
   signal ackTxFifoEmpty    : std_logic;
   signal ackTxFifoRst      : std_logic;
   signal intCellTxAckReq   : std_logic;
   signal frameRxSeq        : std_logic_vector(7 downto 0);
   signal frameRxAck        : std_logic;
   signal frameRxNAck       : std_logic;
   signal intAbort          : std_logic;

   -- Register delay for simulation
   constant tpd:time := 0.5 ns;

   -- Black Box Attributes
   attribute syn_black_box : boolean;
   attribute syn_noprune   : boolean;
   attribute syn_black_box of pgp_fifo_9x256 : component is TRUE;
   attribute syn_noprune   of pgp_fifo_9x256 : component is TRUE;

begin

   -- VC In frame status output
   cellVcInFrame(0) <= vc0InFrame;
   cellVcInFrame(1) <= vc1InFrame;
   cellVcInFrame(2) <= vc2InFrame;
   cellVcInFrame(3) <= vc3InFrame;
   cellVcAbort      <= intAbort;


   -- Mux current VC values
   process ( cellRxDataVc, vc0InFrame, vc0SeqNum, vc1InFrame, vc1SeqNum, 
             vc2InFrame, vc2SeqNum, vc3InFrame, vc3SeqNum ) begin
      case cellRxDataVc is
         when "00" =>
            muxInFrame   <= vc0InFrame;
            muxSeqNum    <= vc0SeqNum;
         when "01" =>
            muxInFrame   <= vc1InFrame;
            muxSeqNum    <= vc1SeqNum;
         when "10" =>
            muxInFrame   <= vc2InFrame;
            muxSeqNum    <= vc2SeqNum;
         when "11" =>
            muxInFrame   <= vc3InFrame;
            muxSeqNum    <= vc3SeqNum;
         when others =>
            muxInFrame   <= '0';
            muxSeqNum    <= (others=>'0');
      end case;
   end process;


   -- Drive current status back to cell receive engine
   process ( pgpClk, pgpReset ) begin
      if pgpReset = '1' then
         frameRxSeq     <= (others=>'0') after tpd;
         frameRxAck     <= '0'           after tpd;
         frameRxNAck    <= '0'           after tpd;
         vc0InFrame     <= '0'           after tpd;
         vc0SeqNum      <= (others=>'0') after tpd;
         vc1InFrame     <= '0'           after tpd;
         vc1SeqNum      <= (others=>'0') after tpd;
         vc2InFrame     <= '0'           after tpd;
         vc2SeqNum      <= (others=>'0') after tpd;
         vc3InFrame     <= '0'           after tpd;
         vc3SeqNum      <= (others=>'0') after tpd;
         intAbort       <= '0'           after tpd;
      elsif rising_edge(pgpClk) then

         -- Link is down, reset status of all VCs
         if pibLinkReady = '0' then
            vc0InFrame  <= '0'           after tpd;
            vc0SeqNum   <= (others=>'0') after tpd;
            vc1InFrame  <= '0'           after tpd; 
            vc1SeqNum   <= (others=>'0') after tpd;
            vc2InFrame  <= '0'           after tpd; 
            vc2SeqNum   <= (others=>'0') after tpd;
            vc3InFrame  <= '0'           after tpd; 
            vc3SeqNum   <= (others=>'0') after tpd;
            intAbort    <= '0'           after tpd;
            frameRxAck  <= '0'           after tpd;
            frameRxNAck <= '0'           after tpd;

         -- Start of cell, 
         elsif cellRxStart = '1' then

            -- Detect missing EOF this occurs when
            -- we get SOF when we are already in frame
            -- Generate NACK for previous sequence number
            -- Generate abort signal
            if muxInFrame = '1' and cellRxSOF = '1' then
               frameRxSeq  <= muxSeqNum after tpd;
               frameRxAck  <= '0'       after tpd;
               frameRxNAck <= '1'       after tpd;
               intAbort    <= '1'       after tpd;
            else
               frameRxSeq  <= (others=>'0') after tpd;
               frameRxAck  <= '0'           after tpd;
               frameRxNAck <= '0'           after tpd;
               intAbort    <= '0'           after tpd;
            end if;

            -- Cell contains start of frame and is not empty
            if cellRxSOF = '1' and cellRxEmpty = '0' then

               -- Mark current VC as in frame if in frame flag is not already set.
               -- If flag is already set then an error occured and we should to to
               -- out of frame state
               case cellRxDataVc is 
                  when "00" => 
                     vc0InFrame   <= '1'       after tpd;
                     vc0SeqNum    <= cellRxSeq after tpd;
                  when "01" => 
                     vc1InFrame   <= '1'       after tpd; 
                     vc1SeqNum    <= cellRxSeq after tpd;
                  when "10" => 
                     vc2InFrame   <= '1'       after tpd; 
                     vc2SeqNum    <= cellRxSeq after tpd;
                  when "11" => 
                     vc3InFrame   <= '1'       after tpd; 
                     vc3SeqNum    <= cellRxSeq after tpd;
                  when others =>
               end case;
            end if;

         -- End of cell
         elsif cellRxDone = '1' then

            -- Clear abort
            intAbort <= '0' after tpd;

            -- Cell is in error, mark all VCs as not in frame
            if cellRxCellError = '1' then
               vc0InFrame <= '0' after tpd; 
               vc1InFrame <= '0' after tpd; 
               vc2InFrame <= '0' after tpd; 
               vc3InFrame <= '0' after tpd; 

            -- EOF is received
            elsif cellRxEOF = '1' and cellRxEmpty = '0' then

               -- Drive ack/nack only if cell was not short.
               -- This is to avoid sending back a nack to the 
               -- remote end before it is expected.
               if cellRxShort = '0' then

               -- Drive ACK/NACK update for one clock. This will handle
               -- A NACK for current cell. If others cells are errored
               -- out their nack will be handled by the timeout.
               frameRxSeq  <= muxSeqNum      after tpd;
               frameRxAck  <= not cellRxEOFE after tpd;
               frameRxNAck <= cellRxEOFE     after tpd;
               else
                  frameRxAck  <= '0' after tpd;
                  frameRxNAck <= '0' after tpd;
               end if;

               -- Clear in frame status for current vc
               case cellRxDataVc is 
                  when "00"   => vc0InFrame   <= '0' after tpd; 
                  when "01"   => vc1InFrame   <= '0' after tpd; 
                  when "10"   => vc2InFrame   <= '0' after tpd; 
                  when "11"   => vc3InFrame   <= '0' after tpd; 
                  when others => 
               end case;

            -- Non EOF frame 
            else 

               -- Clear ACK/NACK drive
               frameRxAck  <= '0' after tpd;
               frameRxNAck <= '0' after tpd;
            end if;
         
         -- Clear Ack/NACK drive
         else
            frameRxAck  <= '0' after tpd;
            frameRxNAck <= '0' after tpd;
         end if;
      end if;
   end process;


   -- Connect external signals
   ackFifoFull  <= ackTxFifoFull;
   cellTxAckReq <= intCellTxAckReq;

   -- Control reads from FIFO
   process ( pgpClk, pgpReset ) begin
      if pgpReset = '1' then
         cellTxNAck      <= '0'           after tpd;
         cellTxAck       <= '0'           after tpd;
         cellTxAckSeq    <= (others=>'0') after tpd;
         intCellTxAckReq <= '0'           after tpd;
         ackTxFifoRdDly  <= '0'           after tpd;
      elsif rising_edge(pgpClk) then

         -- Delayed copy of FIFO read
         ackTxFifoRdDly <= ackTxFifoRd after tpd;

         -- Link has gone down or cell transmitter has acked
         if pibLinkReady = '0' or cellTxAcked = '1' then
            cellTxNAck      <= '0'           after tpd;
            cellTxAck       <= '0'           after tpd;
            cellTxAckSeq    <= (others=>'0') after tpd;
            intCellTxAckReq <= '0'           after tpd;

         -- New value has been read 
         elsif ackTxFifoRdDly = '1' then
            cellTxNAck      <= not ackTxFifoDout(8)      after tpd;
            cellTxAck       <= ackTxFifoDout(8)          after tpd;
            cellTxAckSeq    <= ackTxFifoDout(7 downto 0) after tpd;
            intCellTxAckReq <= '1'                       after tpd;
         end if;
      end if;
   end process;

   -- Generate read signal
   ackTxFifoRd <= not intCellTxAckReq and not ackTxFifoEmpty and not ackTxFifoRdDly;

   -- Generate FIFO reset
   ackTxFifoRst <= pgpReset or not pibLinkReady;

   -- Control write signals
   ackTxFifoWr              <= frameRxAck or frameRxNAck;
   ackTxFifoDin(8)          <= frameRxAck;
   ackTxFifoDin(7 downto 0) <= frameRxSeq;

   -- Sequence number FIFO
   U_AckTxFifo : pgp_fifo_9x256 port map (
      clk   => pgpClk,        rst   => ackTxFifoRst,
      din   => ackTxFifoDin,  wr_en => ackTxFifoWr,
      rd_en => ackTxFifoRd,   dout  => ackTxFifoDout,
      full  => ackTxFifoFull, empty => ackTxFifoEmpty 
   );

end PgpRxTrack;

