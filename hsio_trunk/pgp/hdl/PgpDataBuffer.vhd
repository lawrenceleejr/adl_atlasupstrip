-------------------------------------------------------------------------------
-- Title         : Pretty Good Protocol Applications, Data Buffer
-- Project       : General Purpose Core
-------------------------------------------------------------------------------
-- File          : PgpDataBuffer.vhd
-- Author        : Ryan Herbst, rherbst@slac.stanford.edu
-- Created       : 10/04/2007
-------------------------------------------------------------------------------
-- Description:
-- Data buffer for front end data sent up to RCE
-------------------------------------------------------------------------------
-- Copyright (c) 2007 by Ryan Herbst. All rights reserved.
-------------------------------------------------------------------------------
-- Modification history:
-- 09/24/2007: created.
-- 11/06/2007: Changed flow control reaction to ensure their are no short cells.
-- 11/07/2007: Changed reaction to full flag due to change in pic interface.
-- 11/09/2007: Moved PGP Fifo to common block.
-- 03/06/2008: Removed width signal.
-------------------------------------------------------------------------------

LIBRARY ieee;
use work.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity PgpDataBuffer is port ( 
      
      -- PGP Clock & Reset Signals
      pgpClk           : in  std_logic;
      pgpReset         : in  std_logic;

      -- Local clock and reset
      locClk           : in  std_logic;
      locReset         : in  std_logic;

      -- Local data transfer signals
      frameTxEnable    : in  std_logic;
      frameTxSOF       : in  std_logic;
      frameTxEOF       : in  std_logic;
      frameTxEOFE      : in  std_logic;
      frameTxData      : in  std_logic_vector(15 downto 0);
      frameTxAFull     : out std_logic;

      -- PGP Virtual Channels Signals
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

      -- Overflow occured flag
      dataOverFlow     : out std_logic
   );
end PgpDataBuffer;


-- Define architecture
architecture PgpDataBuffer of PgpDataBuffer is

   -- Async Fifo
   component pgp_afifo_20x511 port (
      din:           IN  std_logic_VECTOR(19 downto 0);
      rd_clk:        IN  std_logic;
      rd_en:         IN  std_logic;
      rst:           IN  std_logic;
      wr_clk:        IN  std_logic;
      wr_en:         IN  std_logic;
      dout:          OUT std_logic_VECTOR(19 downto 0);
      empty:         OUT std_logic;
      full:          OUT std_logic;
      wr_data_count: OUT std_logic_VECTOR(8 downto 0));
   end component;

   -- PGP Pic Buffer Block
   component PgpPicRemBuff is 
      port ( 
         pgpClk            : in  std_logic;
         pgpReset          : in  std_logic;
         vcFrameTxValid    : out std_logic;
         vcFrameTxReady    : in  std_logic;
         vcFrameTxSOF      : out std_logic;
         vcFrameTxWidth    : out std_logic;
         vcFrameTxEOF      : out std_logic;
         vcFrameTxEOFE     : out std_logic;
         vcFrameTxData     : out std_logic_vector(15 downto 0);
         vcFrameTxCid      : out std_logic_vector(31 downto 0);
         vcFrameTxAckCid   : in  std_logic_vector(31 downto 0);
         vcFrameTxAckEn    : in  std_logic;
         vcFrameTxAck      : in  std_logic;
         vcRemBuffAFull    : in  std_logic;
         vcRemBuffFull     : in  std_logic;
         txFifoRd          : out std_logic;
         txFifoEmpty       : in  std_logic;
         txFifoData        : in  std_logic_vector(15 downto 0);
         txFifoSOF         : in  std_logic;
         txFifoEOF         : in  std_logic;
         txFifoEOFE        : in  std_logic
      );
   end component;

   -- Local Signals
   signal asyncDin          : std_logic_vector(19 downto 0);
   signal asyncDout         : std_logic_vector(19 downto 0);
   signal asyncRd           : std_logic;
   signal asyncCount        : std_logic_vector(8 downto 0);
   signal asyncEmpty        : std_logic;
   signal asyncFull         : std_logic;
   signal asyncOflowRstDly0 : std_logic;
   signal asyncOflowRstDly1 : std_logic;
   signal asyncOflow        : std_logic;
   signal asyncOflowDly0    : std_logic;
   signal asyncOflowDly1    : std_logic;
   signal asyncOflowRst     : std_logic;
   signal intOverFlow       : std_logic;
   signal fifoerr           : std_logic;

   -- Register delay for simulation
   constant tpd:time := 0.5 ns;

   -- Black Box Attributes
   attribute syn_black_box : boolean;
   attribute syn_noprune   : boolean;
   attribute syn_black_box of pgp_afifo_20x511 : component is TRUE;
   attribute syn_noprune   of pgp_afifo_20x511 : component is TRUE;

begin

   -- Drive overflow flag
   dataOverFlow <= intOverFlow;

   -- Detect overflows on write
   process ( locClk, locReset ) begin
      if locReset = '1' then
         asyncOflowRstDly0 <= '0' after tpd;
         asyncOflowRstDly1 <= '0' after tpd;
         asyncOflow        <= '0' after tpd;
      elsif rising_edge(locClk) then

         -- Double sync overflow clear
         asyncOflowRstDly0 <= asyncOflowRst     after tpd;
         asyncOflowRstDly1 <= asyncOflowRstDly0 after tpd;

         -- Overflow write clear
         if asyncOflowRstDly1 = '1' then
            asyncOflow <= '0' after tpd;

         -- Overflow write
         elsif asyncFull = '1' and frameTxEnable = '1' then
            asyncOflow <= '1' after tpd;
         end if;
      end if;
   end process;


   -- PGP Clock Version Of Overflow
   process ( pgpClk, pgpReset ) begin
      if pgpReset = '1' then
         asyncOflowDly0 <= '0' after tpd;
         asyncOflowDly1 <= '0' after tpd;
         asyncOflowRst  <= '0' after tpd;
         intOverFlow    <= '0' after tpd;
      elsif rising_edge(pgpClk) then

         -- Sync overflow signal
         asyncOflowDly0 <= asyncOflow     after tpd;
         asyncOflowDly1 <= asyncOflowDly0 after tpd;

         -- Generate overflow reset
         asyncOflowRst <= asyncOflowDly1 after tpd;

         -- Generate overflow signal
         intOverFlow <= asyncOflowDly1 and not intOverFlow after tpd;

      end if;
   end process;


   -- Write data into FIFO
   asyncDin(19)          <= frameTxEOFE or fifoErr;
   asyncDin(18)          <= frameTxEOF or fifoErr;
   asyncDin(17)          <= '1'; -- Width
   asyncDin(16)          <= frameTxSOF;
   asyncDin(15 downto 0) <= frameTxData;

   -- Generate fifo error signal
   process ( locClk, locReset ) begin
      if locReset = '1' then
         fifoErr      <= '0' after tpd;
         frameTxAFull <= '0' after tpd;
      elsif rising_edge(locClk) then

         -- Generate full error
         if asyncCount >= 508 or asyncFull = '1' then
            fifoErr <= '1' after tpd;
         else
            fifoErr <= '0' after tpd;
         end if;

         -- Almost full at 3/4 capacity
         frameTxAFull <= asyncFull or (asyncCount(8) and asyncCount(7));

      end if;
   end process;

   -- Async FIFO
   U_AsyncFifo: pgp_afifo_20x511 port map (
      din           => asyncDin,
      rd_clk        => pgpClk,
      rd_en         => asyncRd,
      rst           => pgpReset,
      wr_clk        => locClk,
      wr_en         => frameTxEnable,
      dout          => asyncDout,
      empty         => asyncEmpty,
      full          => asyncFull,
      wr_data_count => asyncCount
   );


   -- PGP Pic Buffer Block
   U_PgpBuffer: PgpPicRemBuff port map (
      pgpClk          => pgpClk,
      pgpReset        => pgpReset,
      vcFrameTxValid  => vcFrameTxValid,
      vcFrameTxReady  => vcFrameTxReady,
      vcFrameTxSOF    => vcFrameTxSOF,
      vcFrameTxWidth  => vcFrameTxWidth,
      vcFrameTxEOF    => vcFrameTxEOF,
      vcFrameTxEOFE   => vcFrameTxEOFE,
      vcFrameTxData   => vcFrameTxData,
      vcFrameTxCid    => vcFrameTxCid,
      vcFrameTxAckCid => vcFrameTxAckCid,
      vcFrameTxAckEn  => vcFrameTxAckEn,
      vcFrameTxAck    => vcFrameTxAck,
      vcRemBuffAFull  => vcRemBuffAFull,
      vcRemBuffFull   => vcRemBuffFull,
      txFifoRd        => asyncRd,
      txFifoEmpty     => asyncEmpty,
      txFifoData      => asyncDout(15 downto 0),
      txFifoSOF       => asyncDout(16),
      txFifoEOF       => asyncDout(18),
      txFifoEOFE      => asyncDout(19)
   ); 

end PgpDataBuffer;

