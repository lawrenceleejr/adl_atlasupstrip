-------------------------------------------------------------------------------
-- Title         : Pretty Good Protocol Applications, Remote Buffer For PIC
-- Project       : Reconfigurable Cluster Element
-------------------------------------------------------------------------------
-- File          : PgpPicRemBuff.vhd
-- Author        : Ryan Herbst, rherbst@slac.stanford.edu
-- Created       : 11/09/2007
-------------------------------------------------------------------------------
-- Description:
-- VHDL source file for block on the remote end of the PGP link which feeds 
-- the PGP with frame data that will be receoved by the PIC Import block. 
-- The PIC Import block does not support short cells. This logic will ensure
-- that only full cells are transfered over the PGP link. 
-- This block is fed from a fifo which is filled by the user logic.
-- Flow control
-- When the PIC asserts FULL data transfer will stop immediatly. When almost
-- full is asserted the current cell will be complete the the interface will
-- pause at the next boundary.
-------------------------------------------------------------------------------
-- Copyright (c) 2007 by Ryan Herbst. All rights reserved.
-------------------------------------------------------------------------------
-- Modification history:
-- 11/09/2007: created.
-- 11/16/2007: Fixed corner case where flow control asserts just as pre-read
--             data is read from the fifo.
-- 11/27/2007: Moved CID generator into chipscope block for size reasons.
-- 11/29/2007: Changed cell boundary detection to improve timing.
-- 12/11/2007: Removed chipscope;
-- 03/06/2008: Removed 8-bit support.
-------------------------------------------------------------------------------
LIBRARY ieee;
use work.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity PgpPicRemBuff is port ( 

      -- Clock and reset     
      pgpClk            : in  std_logic;                     -- 125Mhz master clock
      pgpReset          : in  std_logic;                     -- Synchronous reset input

      -- Interface To PGP
      vcFrameTxValid    : out std_logic;                     -- User frame data is valid
      vcFrameTxReady    : in  std_logic;                     -- PGP is ready
      vcFrameTxSOF      : out std_logic;                     -- User frame data start of frame
      vcFrameTxWidth    : out std_logic;                     -- User frame data width
      vcFrameTxEOF      : out std_logic;                     -- User frame data end of frame
      vcFrameTxEOFE     : out std_logic;                     -- User frame data error
      vcFrameTxData     : out std_logic_vector(15 downto 0); -- User frame data
      vcFrameTxCid      : out std_logic_vector(31 downto 0); -- User frame data, context ID
      vcFrameTxAckCid   : in  std_logic_vector(31 downto 0); -- PGP ACK/NACK context ID
      vcFrameTxAckEn    : in  std_logic;                     -- PGP ACK/NACK enable
      vcFrameTxAck      : in  std_logic;                     -- PGP ACK/NACK
      vcRemBuffAFull    : in  std_logic;                     -- Remote buffer almost full
      vcRemBuffFull     : in  std_logic;                     -- Remote buffer full

      -- Interface to feeding FIFO
      txFifoRd          : out std_logic;                     -- TX Fifo Read Strobe
      txFifoEmpty       : in  std_logic;                     -- TX Fifo Empty
      txFifoData        : in  std_logic_vector(15 downto 0); -- TX Data
      txFifoSOF         : in  std_logic;                     -- TX Fifo Start Of Frame
      txFifoEOF         : in  std_logic;                     -- TX Fifo End Of Frame
      txFifoEOFE        : in  std_logic                      -- TX Fifo End Of Frame, Error
   );
end PgpPicRemBuff;


-- Define architecture
architecture PgpPicRemBuff of PgpPicRemBuff is

   -- Output Fifo
   component pgp_fifo_21x512 port (
      clk:        IN  std_logic;
      din:        IN  std_logic_VECTOR(20 downto 0);
      rd_en:      IN  std_logic;
      rst:        IN  std_logic;
      wr_en:      IN  std_logic;
      data_count: OUT std_logic_VECTOR(8 downto 0);
      dout:       OUT std_logic_VECTOR(20 downto 0);
      empty:      OUT std_logic;
      full:       OUT std_logic);
   end component;

   -- Local Signals
   signal intFifoRdDly      : std_logic;
   signal syncWr            : std_logic;
   signal syncDin           : std_logic_vector(20 downto 0);
   signal wrCount           : std_logic_vector(7 downto 0);
   signal syncRdDly         : std_logic;
   signal cellCount         : std_logic_vector(2 downto 0);
   signal syncValid         : std_logic;
   signal syncDout          : std_logic_vector(20 downto 0);
   signal syncRd            : std_logic;
   signal syncEmpty         : std_logic;
   signal syncCount         : std_logic_vector(8 downto 0);
   signal intFifoRd         : std_logic;
   signal intCid            : std_logic_vector(31 downto 0);
   signal syncAFull         : std_logic;
   signal syncSOC           : std_logic;

   -- Register delay for simulation
   constant tpd:time := 0.5 ns;

   -- Black Box Attributes
   attribute syn_black_box : boolean;
   attribute syn_noprune   : boolean;
   attribute syn_black_box of pgp_fifo_21x512  : component is TRUE;
   attribute syn_noprune   of pgp_fifo_21x512  : component is TRUE;

begin

   -- Pass read to FIFO
   txFifoRd <= intFifoRd;

   -- Read when FIFO has data and sync FIFO has room
   intFifoRd <= (not txFifoEmpty) and (not syncAFull);

   -- Track data movement
   process ( pgpClk, pgpReset ) begin
      if pgpReset = '1' then
         intFifoRdDly         <= '0'           after tpd;
         syncWr               <= '0'           after tpd;
         syncDin(19 downto 0) <= (others=>'0') after tpd; 
         wrCount              <= (others=>'0') after tpd;
         syncRdDly            <= '0'           after tpd;
         cellCount            <= "000"         after tpd;
         syncValid            <= '0'           after tpd;
         syncSOC              <= '0'           after tpd;
         syncAFull            <= '0'           after tpd;
      elsif rising_edge(pgpClk) then

         -- Generate sync fifo almost full signal
         if syncCount > 500 or cellCount(2) = '1' then
            syncAFull <= '1' after tpd;
         else
            syncAFull <= '0' after tpd;
         end if;

         -- Delayed copy of fifo read
         intFifoRdDly <= intFifoRd after tpd;

         -- Add pipeline stage to write data for timing
         syncWr               <= intFifoRdDly after tpd;
         syncDin(19)          <= txFifoEOFE   after tpd;
         syncDin(18)          <= txFifoEOF    after tpd;
         syncDin(17)          <= '1'          after tpd;
         syncDin(16)          <= txFifoSOF    after tpd;
         syncDin(15 downto 0) <= txFifoData   after tpd;

         -- Cell Write Counter
         if syncDin(18) = '1' then
            wrCount <= (others=>'0') after tpd;
         elsif syncWr = '1' then
            wrCount <= wrCount + 1 after tpd;
         end if;

         -- Delayed copy of sync FIFO reads
         syncRdDly  <= syncRd  after tpd;

         -- Track number of cells in the sync fifo
         -- Read cell marker, no write
         if syncRdDly = '1' and syncDout(20) = '1' and 
               (syncWr = '0' or syncDin(20) = '0') then
            cellCount <= cellCount - 1 after tpd;

         -- Write cell marker, no read
         elsif syncWr = '1' and syncDin(20) = '1' and
               (syncRdDly = '0' or syncDout(20) = '0') then
            cellCount <= cellCount + 1 after tpd;

         -- FIFO is empty
         elsif syncEmpty = '1' then
            cellCount <= "000" after tpd;
         end if;

         -- De-assert valid when PGP accepts and no read occurs
         if vcFrameTxReady = '1' and syncRd = '0' then
            syncValid <= '0' after tpd;
            syncSOC   <= '0' after tpd;

         -- Read is occuring with or without ready
         elsif syncRd = '1' then

            -- Last value was EOC or no cells in FIFO, De-Assert valid for at least one cycle
            -- Mark current output as start of cell
            if syncDout(20) = '1' or cellCount = 0 then
               syncValid <= '0' after tpd;
               syncSOC   <= '1' after tpd;
            else
               syncValid <= '1' after tpd;
               syncSOC   <= '0' after tpd;
            end if;

         -- SOC is on FIFO output, assert valid only when at least one cell is
         -- present in the FIFO and remote buffers are ready
         elsif syncSOC = '1' then
            if cellCount /= 0 and syncEmpty = '0' and vcRemBuffAFull = '0' 
                                                  and vcRemBuffFull  = '0' then
               syncValid <= '1' after tpd;
            end if;
         end if;
      end if;
   end process;


   -- Set end of cell flag
   syncDin(20) <= '1' when syncDin(18) = '1' or wrCount = 255 else '0';


   -- Control reads from FIFO
   process (vcRemBuffFull, vcFrameTxReady, syncValid, syncSOC, syncEmpty ) begin

      -- Data is moving
      if vcFrameTxReady = '1' and syncValid = '1' then
         syncRd <= (not syncEmpty) and (not vcRemBuffFull);

      -- Pre-read required
      elsif syncValid = '0' and syncSOC = '0' then
         syncRd <= (not syncEmpty) and (not vcRemBuffFull);

      -- No Read
      else 
         syncRd <= '0';
      end if;
   end process;


   -- Sync FIFO
   U_SyncFifo: pgp_fifo_21x512 port map (
      clk        => pgpClk,
      din        => syncDin,
      rd_en      => syncRd,
      rst        => pgpReset,
      wr_en      => syncWr,
      data_count => syncCount,
      dout       => syncDout,
      empty      => syncEmpty,
      full       => open
   );

   -- Outgoing data
   vcFrameTxValid    <= syncValid;
   vcFrameTxEOFE     <= syncDout(19);
   vcFrameTxEOF      <= syncDout(18);
   vcFrameTxWidth    <= '1';
   vcFrameTxSOF      <= syncDout(16);
   vcFrameTxData     <= syncDout(15 downto 0);
   vcFrameTxCid      <= (others=>'0');

end PgpPicRemBuff;

