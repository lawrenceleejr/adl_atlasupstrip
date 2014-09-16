-------------------------------------------------------------------------------
-- Title         : Pretty Good Protocol Applications, Command Slave Block
-- Project       : General Purpose Core
-------------------------------------------------------------------------------
-- File          : PgpCmdSlave.vhd
-- Author        : Ryan Herbst, rherbst@slac.stanford.edu
-- Created       : 09/22/2007
-------------------------------------------------------------------------------
-- Description:
-- Slave block for Command protocol over the PGP.
-- Packet is 16 bytes. The 16 bit values passed over the PGP will be:
-- Word 0 Data[1:0]  = VC
-- Word 0 Data[7:2]  = Dest_ID
-- Word 0 Data[15:8] = TID[7:0]
-- Word 1 Data[15:0] = TID[23:8]
-- Word 2 Data[7:0]  = OpCode[7:0]
-- Word 2 Data[15:8] = Don't Care
-- Word 3 Data[15:0] = Don't Care
-- Word 4            = Don't Care
-- Word 5            = Don't Care
-- Word 6            = Don't Care
-- Word 7            = Don't Care
-------------------------------------------------------------------------------
-- Copyright (c) 2007 by Ryan Herbst. All rights reserved.
-------------------------------------------------------------------------------
-- Modification history:
-- 09/22/2007: created.
-- 10/10/2007: Converted context value to 32-bits.
-- 10/29/2007: Changed name of coregen blocks
-- 11/20/2007: Added check to ensure overflow will put EOFE into buffer.
-- 11/27/2007: Modified to allow the option of sync or async FIFO
-- 11/30/2007: Fixed error with back to back frames and mis-connected data lines.
-- 01/25/2008: Adjusted for new frame format.
-------------------------------------------------------------------------------

LIBRARY ieee;
USE work.ALL;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity PgpCmdSlave is
   generic (
      DestId      : natural := 0;     -- Destination ID Value To Match
      DestMask    : natural := 0;     -- Destination ID Mask For Match
      AsyncFIFO   : string  := "TRUE" -- Use Async FIFOs, TRUE or FALSE
   );
   port ( 

      -- PGP Clock And Reset
      pgpClk           : in  std_logic;                      -- PGP Clock
      pgpReset         : in  std_logic;                      -- Synchronous PGP Reset

      -- Local clock and reset
      locClk           : in  std_logic;                      -- Local Clock
      locReset         : in  std_logic;                      -- Synchronous Local Reset

      -- PGP Signals, Virtual Channel Rx Only
      vcFrameRxValid   : in  std_logic;                      -- Data is valid
      vcFrameRxSOF     : in  std_logic;                      -- Data is SOF
      vcFrameRxWidth   : in  std_logic;                      -- Data is 16-bits
      vcFrameRxEOF     : in  std_logic;                      -- Data is EOF
      vcFrameRxEOFE    : in  std_logic;                      -- Data is EOF with Error
      vcFrameRxData    : in  std_logic_vector(15 downto 0);  -- Data
      vcLocBuffAFull   : out std_logic;                      -- Local buffer almost full
      vcLocBuffFull    : out std_logic;                      -- Local buffer full

      -- Local command signals
      cmdEn            : out std_logic;                      -- Command Enable
      cmdOpCode        : out std_logic_vector(7  downto 0);  -- Command OpCode
      cmdCtxOut        : out std_logic_vector(23 downto 0)   -- Command Context
   );

end PgpCmdSlave;


-- Define architecture
architecture PgpCmdSlave of PgpCmdSlave is

   -- Async FIFO
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

   -- Sync FIFO
   component pgp_fifo_20x512 port (
      din:        IN  std_logic_VECTOR(19 downto 0);
      clk:        IN  std_logic;
      rd_en:      IN  std_logic;
      rst:        IN  std_logic;
      wr_en:      IN  std_logic;
      dout:       OUT std_logic_VECTOR(19 downto 0);
      empty:      OUT std_logic;
      full:       OUT std_logic;
      data_count: OUT std_logic_VECTOR(8 downto 0));
   end component;

   -- Local Signals
   signal intDestId    : std_logic_vector(5 downto 0);
   signal selDestId    : std_logic_vector(5 downto 0);
   signal selDestMask  : std_logic_vector(5 downto 0);
   signal intCmdEn     : std_logic;
   signal intCmdOpCode : std_logic_vector(7  downto 0);
   signal intCmdCtxOut : std_logic_vector(23 downto 0);
   signal fifoDin      : std_logic_vector(19 downto 0);
   signal fifoDout     : std_logic_vector(19 downto 0);
   signal fifoRd       : std_logic;
   signal fifoRdDly    : std_logic;
   signal fifoCount    : std_logic_vector(8  downto 0);
   signal fifoEmpty    : std_logic;
   signal locSOF       : std_logic;
   signal locWidth     : std_logic;
   signal locEOF       : std_logic;
   signal locEOFE      : std_logic;
   signal locData      : std_logic_vector(15 downto 0);
   signal intCnt       : std_logic_vector(2  downto 0);
   signal intCntEn     : std_logic;
   signal fifoErr      : std_logic;
   signal fifoFull     : std_logic;

   -- Register delay for simulation
   constant tpd:time := 0.5 ns;

   -- Black Box Attributes
   attribute syn_black_box : boolean;
   attribute syn_noprune   : boolean;
   attribute syn_black_box of pgp_afifo_20x511 : component is TRUE;
   attribute syn_noprune   of pgp_afifo_20x511 : component is TRUE;
   attribute syn_black_box of pgp_fifo_20x512  : component is TRUE;
   attribute syn_noprune   of pgp_fifo_20x512  : component is TRUE;

begin

   -- Output signal
   cmdEn     <= intCmdEn;
   cmdOpCode <= intCmdOpCode;
   cmdCtxOut <= intCmdCtxOut;

   -- Convert destnation ID and Mask
   selDestId   <= conv_std_logic_vector(DestId,6);
   selDestMask <= conv_std_logic_vector(DestMask,6);

   -- Data going into FIFO
   fifoDin(19)          <= vcFrameRxSOF;
   fifoDin(18)          <= vcFrameRxWidth;
   fifoDin(17)          <= vcFrameRxEOF  or fifoErr;
   fifoDin(16)          <= vcFrameRxEOFE or fifoErr;
   fifoDin(15 downto 0) <= vcFrameRxData; 

   -- Async FIFO
   U_GenAFifo: if AsyncFIFO = "TRUE" generate
      U_CmdAFifo: pgp_afifo_20x511 port map (
         din           => fifoDin,
         rd_clk        => locClk,
         rd_en         => fifoRd,
         rst           => pgpReset,
         wr_clk        => pgpClk,
         wr_en         => vcFrameRxValid,
         dout          => fifoDout,
         empty         => fifoEmpty,
         full          => fifoFull,
         wr_data_count => fifoCount
      );
   end generate;

   -- Sync FIFO
   U_GenFifo: if AsyncFIFO = "FALSE" generate
      U_CmdFifo: pgp_fifo_20x512 port map (
         din           => fifoDin,
         clk           => pgpClk,
         rd_en         => fifoRd,
         rst           => pgpReset,
         wr_en         => vcFrameRxValid,
         dout          => fifoDout,
         empty         => fifoEmpty,
         full          => fifoFull,
         data_count    => fifoCount
      );
   end generate;


   -- Data coming out of FIFO
   locSOF   <= fifoDout(19);
   locWidth <= fifoDout(18);
   locEOF   <= fifoDout(17);
   locEOFE  <= fifoDout(16);
   locData  <= fifoDout(15 downto 0);

   -- FIFO Read Control
   fifoRd <= not fifoEmpty;


   -- Generate flow control
   process ( pgpClk, pgpReset ) begin
      if pgpReset = '1' then
         vcLocBuffAFull <= '0' after tpd;
         vcLocBuffFull  <= '0' after tpd;
         fifoErr        <= '0' after tpd;
      elsif rising_edge(pgpClk) then
         
         -- Generate full error
         if fifoCount >= 508 or fifoFull = '1' then
            fifoErr <= '1' after tpd;
         else
            fifoErr <= '0' after tpd;
         end if;

         -- Almost full at half capacity
         vcLocBuffAFull <= fifoCount(8);

         -- Full at 3/4 capacity
         vcLocBuffFull <= fifoCount(8) and fifoCount(7);
      end if;
   end process;


   -- Receive Data Processor
   process ( locClk, locReset ) begin
      if locReset = '1' then
         intCmdEn     <= '0'           after tpd;
         intCmdOpCode <= (others=>'0') after tpd;
         intCmdCtxOut <= (others=>'0') after tpd;
         intDestId    <= (others=>'0') after tpd;
         fifoRdDly    <= '0'           after tpd;
         intCnt       <= (others=>'0') after tpd;
         intCntEn     <= '0'           after tpd;
      elsif rising_edge(locClk) then

         -- Generate delayed read
         fifoRdDly <= fifoRd after tpd;

         -- Only process when data has been read
         if fifoRdDly = '1' then

            -- Receive Data Counter
            -- Reset on SOF or EOF, Start counter on SOF
            if locSOF = '1' or locEOF = '1' then
               intCnt   <= (others=>'0') after tpd;
               intCntEn <= not locEOF  after tpd;
            elsif intCntEn = '1' and intCnt /= "110" then
               intCnt <= intCnt + 1 after tpd;
            end if;

            -- SOF Received
            if locSOF = '1' then
               intCmdCtxOut(7 downto 0) <= locData(15 downto 8) after tpd;
               intDestId                <= locData(7  downto 2) after tpd;
               intCmdEn                 <= '0'                  after tpd;

            -- Rest of Frame
            else case intCnt is

               -- Word 1 
               when "000" =>
                  intCmdCtxOut(23 downto 8) <= locData after tpd;
                  intCmdEn                  <= '0'     after tpd;

               -- Word 2 
               when "001" =>
                  intCmdOpCode <= locData(7 downto 0) after tpd;
                  intCmdEn     <= '0'                 after tpd;

               -- Word 7, Last word 
               when "110" =>

                  -- No error and destination ID matches
                  if locEOF = '1' and locEOFE = '0' and 
                     ( intDestId and selDestMask ) = selDestId then
                     intCmdEn <= '1' after tpd;
                  else
                     intCmdEn <= '0' after tpd;
                  end if;

               -- Do nothing for others
               when others =>
                  intCmdEn <= '0' after tpd;
            end case;
            end if;
         else
            intCmdEn <= '0' after tpd;
         end if;
      end if;
   end process;

end PgpCmdSlave;

