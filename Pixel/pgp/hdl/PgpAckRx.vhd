-------------------------------------------------------------------------------
-- Title         : Pretty Good Protocol, ACK/NACK Receive & Timer Logic
-- Project       : General Purpose Core
-------------------------------------------------------------------------------
-- File          : PgpAckRx.vhd
-- Author        : Ryan Herbst, rherbst@slac.stanford.edu
-- Created       : 10/24/2006
-------------------------------------------------------------------------------
-- Description:
-- ACK/NACK receive module for the Pretty Good Protocol core. 
-------------------------------------------------------------------------------
-- Copyright (c) 2006 by Ryan Herbst. All rights reserved.
-------------------------------------------------------------------------------
-- Modification history:
-- 10/24/2006: created.
-- 06/15/2007: Added register state before ACK FIFO. Needed for timing.
-- 07/25/2007: Changed cell CRC error to cell receive error.
-- 09/21/2007: Ack timeout converted to generic.
-- 09/29/2007: Changed name of coregen blocks
-------------------------------------------------------------------------------

LIBRARY ieee;
USE work.ALL;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity PgpAckRx is 
   generic (
      AckTimeout : natural := 8  -- Ack/Nack Not Received Timeout, 8.192uS Steps
   );
   port ( 

      -- System clock, reset & control
      pgpClk            : in  std_logic;                     -- Master clock
      pgpReset          : in  std_logic;                     -- Synchronous reset input

      -- PIB Interface
      pibLinkReady      : in  std_logic;                     -- PIB Link Ready

      -- Error Indication
      seqFifoEmpty      : out std_logic;                     -- Sequence number fifo is empty
      nackCountInc      : out std_logic;                     -- Nack received count increment

      -- Cell Receiver Interface
      cellRxDone        : in  std_logic;                     -- Cell reception done
      cellRxCellError   : in  std_logic;                     -- Cell receieve error
      cellRxSeq         : in  std_logic_vector(7  downto 0); -- Cell receieve sequence
      cellRxAck         : in  std_logic;                     -- Cell receieve ACK
      cellRxNAck        : in  std_logic;                     -- Cell receieve NACK

      -- Transmit Schedular Interface
      cidReady          : out std_logic;                     -- CID Engine is ready
      cidTimerStart     : in  std_logic;                     -- CID timer start
      cellTxDataVc      : in  std_logic_vector(1  downto 0); -- Cell transmit virtual channel
      cidSave           : in  std_logic;                     -- CID value store signal

      -- Cell Transmit logic
      cellTxSOF         : in  std_logic;                     -- Cell contained SOF
      cellTxDataSeq     : out std_logic_vector(7  downto 0); -- Transmit sequence number

      -- User logic interface
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

end PgpAckRx;


-- Define architecture
architecture PgpAckRx of PgpAckRx is

   -- Active context ID memory
   component pgp_dpram_51x256 port (
      addra: IN  std_logic_VECTOR(7 downto 0);
      addrb: IN  std_logic_VECTOR(7 downto 0);
      clka:  IN  std_logic;
      clkb:  IN  std_logic;
      dina:  IN  std_logic_VECTOR(50 downto 0);
      dinb:  IN  std_logic_VECTOR(50 downto 0);
      doutb: OUT std_logic_VECTOR(50 downto 0);
      wea:   IN  std_logic;
      web:   IN  std_logic
   ); end component;

   -- Seq number FIFO
   component pgp_fifo_8x256 port (
      clk:        IN  std_logic;
      rst:        IN  std_logic;
      din:        IN  std_logic_VECTOR(7 downto 0);
      wr_en:      IN  std_logic;
      rd_en:      IN  std_logic;
      dout:       OUT std_logic_VECTOR(7 downto 0);
      full:       OUT std_logic;
      empty:      OUT std_logic
   ); end component;

   -- Adder 16+16=16
   component pgp_adder_16_16
      port (
         A   : IN  std_logic_VECTOR(15 downto 0);
         B   : IN  std_logic_VECTOR(15 downto 0);
         S   : OUT std_logic_VECTOR(15 downto 0)
      );
   end component;


   -- Local Signals
   signal seqNumber        : std_logic_vector(7  downto 0);
   signal seqNumberInc     : std_logic;
   signal seqAddrSel       : std_logic;
   signal seqFifoDin       : std_logic_vector(7  downto 0);
   signal seqFifoWr        : std_logic;
   signal seqFifoRd        : std_logic;
   signal seqFifoRst       : std_logic;
   signal seqFifoDout      : std_logic_vector(7  downto 0);
   signal seqFifoDoutVal   : std_logic;
   signal seqFifoFull      : std_logic;
   signal intSeqFifoEmpty  : std_logic;
   signal intCidReady      : std_logic;
   signal startSeqNum      : std_logic_vector(7  downto 0);
   signal cidMemAddrA      : std_logic_vector(7  downto 0);
   signal cidMemAddrB      : std_logic_vector(7  downto 0);
   signal cidMemDinA       : std_logic_vector(50 downto 0);
   signal cidMemWrA        : std_logic;
   signal cidMemWrAReq     : std_logic;
   signal cidMemWrANext    : std_logic;
   signal cidMemWrB        : std_logic;
   signal cidMemRdB        : std_logic;
   signal cidMemDoutB      : std_logic_vector(50 downto 0);
   signal intFrameTxAckCid : std_logic_vector(31 downto 0);
   signal intFrameTxAckEn  : std_logic_vector(3  downto 0);
   signal intFrameTxAck    : std_logic;
   signal nxtFrameTxAckEn  : std_logic_vector(3  downto 0);
   signal nxtFrameTxAck    : std_logic;
   signal seqRxFlag        : std_logic;
   signal dlyRxFlag        : std_logic;
   signal seqRxFlagClr     : std_logic;
   signal locCellRxSeq     : std_logic_vector(7  downto 0);
   signal locCellRxAck     : std_logic;
   signal ackTimer         : std_logic_vector(15 downto 0);
   signal ackTimerSum      : std_logic_vector(15 downto 0);
   signal ackTimerInc      : std_logic;
   signal muxVcSeq         : std_logic_vector(7  downto 0);
   signal intVc0Seq        : std_logic_vector(7  downto 0);
   signal intVc1Seq        : std_logic_vector(7  downto 0);
   signal intVc2Seq        : std_logic_vector(7  downto 0);
   signal intVc3Seq        : std_logic_vector(7  downto 0);
   signal muxFrameTxCid    : std_logic_vector(31 downto 0);
   signal cidSaveData      : std_logic_vector(31 downto 0);
   signal regFifoDin       : std_logic_vector(7  downto 0);
   signal regFifoWr        : std_logic;
   signal intTimeout       : std_logic_vector(15 downto 0);

   -- Context state machine
   signal   seqState     : std_logic_vector(7 downto 0);
   signal   nxtState     : std_logic_vector(7 downto 0);
   constant ST_INIT      : std_logic_vector(7 downto 0) := "00000001";
   constant ST_WAIT      : std_logic_vector(7 downto 0) := "00000010";
   constant ST_FILL      : std_logic_vector(7 downto 0) := "00000100";
   constant ST_TIME_RD   : std_logic_vector(7 downto 0) := "00001000";
   constant ST_TIME_CHK  : std_logic_vector(7 downto 0) := "00010000";
   constant ST_ACK_RD    : std_logic_vector(7 downto 0) := "00100000";
   constant ST_ACK_RET   : std_logic_vector(7 downto 0) := "01000000";
   constant ST_CID_START : std_logic_vector(7 downto 0) := "10000000";

   -- Register delay for simulation
   constant tpd:time := 0.5 ns;

   -- Black Box Attributes
   attribute syn_black_box : boolean;
   attribute syn_noprune   : boolean;
   attribute syn_black_box of pgp_dpram_51x256 : component is TRUE;
   attribute syn_noprune   of pgp_dpram_51x256 : component is TRUE;
   attribute syn_black_box of pgp_fifo_8x256   : component is TRUE;
   attribute syn_noprune   of pgp_fifo_8x256   : component is TRUE;
   attribute syn_black_box of pgp_adder_16_16  : component is TRUE;
   attribute syn_noprune   of pgp_adder_16_16  : component is TRUE;

begin

   -- Convert Ack Timeout Value
   intTimeout <= conv_std_logic_vector(AckTimeout,16);

   -- Sequence number FIFO is empty
   seqFifoEmpty  <= intSeqFifoEmpty;
   cellTxDataSeq <= seqFifoDout;

   -- Nack counter increment
   nackCountInc <= '0' when intFrameTxAckEn = "0000" else (not intFrameTxAck);

   -- CID FIFO is ready
   cidReady <= seqFifoDoutVal;

   -- Context ID, VC 0
   vc0FrameTxAckCid  <= intFrameTxAckCid;
   vc0FrameTxAckEn   <= intFrameTxAckEn(0);
   vc0FrameTxAck     <= intFrameTxAck;

   -- Context ID, VC 1
   vc1FrameTxAckCid  <= intFrameTxAckCid;
   vc1FrameTxAckEn   <= intFrameTxAckEn(1);
   vc1FrameTxAck     <= intFrameTxAck;

   -- Context ID, VC 2
   vc2FrameTxAckCid  <= intFrameTxAckCid;
   vc2FrameTxAckEn   <= intFrameTxAckEn(2);
   vc2FrameTxAck     <= intFrameTxAck;

   -- Context ID, VC 3
   vc3FrameTxAckCid  <= intFrameTxAckCid;
   vc3FrameTxAckEn   <= intFrameTxAckEn(3);
   vc3FrameTxAck     <= intFrameTxAck;


   -- Interface for sechedular to read available seq number values
   -- from the seq number FIFO. Also provide interface for the
   -- schedular to start the timer for a previously allocated sequence number.
   process ( pgpClk, pgpReset ) begin
      if pgpReset = '1' then
         seqFifoDoutVal <= '0'           after tpd;
         seqFifoRd      <= '0'           after tpd;
         startSeqNum    <= (others=>'0') after tpd;
         cidMemDinA     <= (others=>'0') after tpd;
         cidMemWrA      <= '0'           after tpd;
         cidMemWrAReq   <= '0'           after tpd;
         intVc0Seq      <= (others=>'0') after tpd;
         intVc1Seq      <= (others=>'0') after tpd;
         intVc2Seq      <= (others=>'0') after tpd;
         intVc3Seq      <= (others=>'0') after tpd;
         cidSaveData    <= (others=>'0') after tpd;

      elsif rising_edge(pgpClk) then

         -- Reset data out on link down
         if intCidReady = '0' then
            seqFifoDoutVal <= '0' after tpd;
            seqFifoRd      <= '0' after tpd;

         -- We just read from FIFO
         elsif seqFifoRd = '1' then
            seqFifoRd      <= '0' after tpd;
            seqFifoDoutVal <= '1' after tpd;

         -- Scheduler just read seq number
         elsif cellTxSOF = '1' then

            -- Clear valid flag, read next sequence number
            seqFifoDoutVal <= '0'                 after tpd;
            seqFifoRd      <= not intSeqFifoEmpty after tpd;

            -- Store sequence number associted with VC
            case cellTxDataVc is 
               when "00"   => intVc0Seq <= seqFifoDout after tpd;
               when "01"   => intVc1Seq <= seqFifoDout after tpd;
               when "10"   => intVc2Seq <= seqFifoDout after tpd;
               when "11"   => intVc3Seq <= seqFifoDout after tpd;
               when others => 
            end case;

         -- Load next value if none is waiting
         elsif seqFifoDoutVal = '0' then
            seqFifoRd <= not intSeqFifoEmpty after tpd;
         end if;

         -- Schedular is passing CID value at the start of a cell. Store the
         -- data for now just in case this cell contains an EOF.
         if cidSave = '1' then
            cidSaveData <= muxFrameTxCid after tpd;
         end if;

         -- Memory write occured, clear request
         if cidMemWrA = '1' then
            cidMemWrAReq <= '0' after tpd;

         -- Schedular has indicated that the timer should start for the
         -- current VC.
         elsif cidTimerStart = '1' then
            startSeqNum              <= muxVcSeq     after tpd;
            cidMemDinA(50)           <= '1'          after tpd;
            cidMemDinA(49 downto 48) <= cellTxDataVc after tpd;
            cidMemDinA(47 downto 32) <= ackTimerSum  after tpd;
            cidMemDinA(31 downto 0)  <= cidSaveData  after tpd;
            cidMemWrAReq             <= '1'          after tpd;
         end if;

         -- Drive write to memory when it is safe, one clock after timer read
         cidMemWrA <= cidMemWrAReq and cidMemWrANext after tpd;

      end if;
   end process;

   
   -- Mux for vc related data
   process (cellTxDataVc, intVc0Seq, intVc1Seq, intVc2Seq, intVc3Seq,
            vc0FrameTxCid, vc1FrameTxCid, vc2FrameTxCid, vc3FrameTxCid ) begin
      case cellTxDataVc is 
         when "00"   => muxVcSeq <= intVc0Seq; muxFrameTxCid <= vc0FrameTxCid;
         when "01"   => muxVcSeq <= intVc1Seq; muxFrameTxCid <= vc1FrameTxCid;
         when "10"   => muxVcSeq <= intVc2Seq; muxFrameTxCid <= vc2FrameTxCid;
         when "11"   => muxVcSeq <= intVc3Seq; muxFrameTxCid <= vc3FrameTxCid;
         when others => muxVcSeq <= (others=>'0'); muxFrameTxCid <= (others=>'0');
      end case;
   end process;


   -- Sequence number input state machine. This engine pre-fills the
   -- sequence number FIFO when the link goes active, adds received
   -- sequence numbers back into the FIFO, removes recieved sequence numbers
   -- from the active context memory. This engine will also handle
   -- timeouts for the currently active contexts. The timeout values for each
   -- of the 256 memory locations are serviced once every 4 clocks. This results
   -- in every timer processed every 1024 clocks or 8.192uS.
   process ( pgpClk, pgpReset ) begin
      if pgpReset = '1' then
         seqState         <= ST_INIT       after tpd;
         seqRxFlag        <= '0'           after tpd;
         dlyRxFlag        <= '0'           after tpd;
         locCellRxSeq     <= (others=>'0') after tpd;
         locCellRxAck     <= '0'           after tpd;
         seqNumber        <= (others=>'0') after tpd;
         ackTimer         <= (others=>'0') after tpd;
         intFrameTxAckCid <= (others=>'0') after tpd;
         intFrameTxAck    <= '0'           after tpd;
         intFrameTxAckEn  <= "0000"        after tpd;

      elsif rising_edge(pgpClk) then

         -- Force back to INIT state when link goes down
         if pibLinkReady = '0' then
            seqState <= ST_INIT after tpd;

         -- State transition 
         else
            seqState <= nxtState after tpd;
         end if;

         -- Clear sequence address value
         if pibLinkReady = '0' then
            seqNumber <= (others=>'0') after tpd;

         -- Increment address value
         elsif seqNumberInc = '1' then
            seqNumber <= seqNumber + 1 after tpd;
         end if;

         -- Register ack/nack data passed from frame receiver. Mark
         -- a flag to indicate pending request. Clear when state machine
         -- processes. 
         if cellRxDone = '1' and cellRxCellError = '0' then
            locCellRxSeq <= cellRxSeq               after tpd;
            locCellRxAck <= cellRxAck               after tpd;
            seqRxFlag    <= cellRxAck or cellRxNack after tpd;
         elsif seqRxFlagClr = '1' then
            seqRxFlag    <= '0' after tpd;
         end if;

         -- Delayed copy of receive flag. This is needed to ensure we look at 
         -- the non delayed flag only once in the state machine. 
         dlyRxFlag <= seqRxFlag after tpd;

         -- Reset Ack timer 
         if pibLinkReady = '0' then
            ackTimer <= (others=>'0') after tpd;

         -- Increment Ack timer value
         elsif ackTimerInc = '1' then
            ackTimer <= ackTimer + 1 after tpd;
         end if;

         -- Drive outgoing CID ack/nack signals
         intFrameTxAckCid <= cidMemDoutB(31 downto 0) after tpd;
         intFrameTxAck    <= nxtFrameTxAck            after tpd;
         intFrameTxAckEn  <= nxtFrameTxAckEn          after tpd;

      end if;
   end process;


   -- State transition control. The following signals are driven in each state:
   -- intCidReady     : Indicates to schedular that memory init is complete
   -- seqFifoWr       : Controls writes into the available seq number FIFO
   -- cidMemWrB       : Controls writes to context memory
   -- cidMemRdB       : Controls reads from context memory
   -- seqAddrSel      : Chooses between seq num counter (value=0) and returned seq number
   -- seqNumberInc    : Increment the seq number counter
   -- seqRxFlagClr    : Clear the flag indicating a seq number has been passed
   -- nxtFrameTxAck   : Next outgoing frame ack signal
   -- nxtFrameTxAckEn : Next outgoing frame ack signal enable
   -- ackTimerInc     : Ack timer increment
   -- nxtState        : Defines which state to proceed to
   process ( seqState, seqNumber, cidMemDoutB, ackTimer, 
             seqFifoFull, seqRxFlag, dlyRxFlag, locCellRxAck ) begin
      case seqState is 

         -- INIT conect memory and sequence FIFO
         when ST_INIT =>

            -- Not ready
            intCidReady <= '0';
         
            -- Fifo is being reset, no mem reads or writes
            seqFifoWr   <= '0';
            cidMemWrB   <= '0';
            cidMemRdB   <= '0';

            -- Seq nubmer is being cleared. Clear any pending receive flags
            seqAddrSel   <= '0';
            seqNumberInc <= '0';
            ackTimerInc  <= '0';
            seqRxFlagClr <= '1';

            -- No ACK/NACK output
            nxtFrameTxAck   <= '0';
            nxtFrameTxAckEn <= "0000";

            -- CID Memory write enable 
            cidMemWrANext <= '0';

            -- Start fill of data
            nxtState <= ST_WAIT;

         -- Wait for FIFO to be ready following reset
         when ST_WAIT =>

            -- Not ready
            intCidReady <= '0';
         
            -- No mem reads or writes
            seqFifoWr   <= '0';
            cidMemWrB   <= '0';
            cidMemRdB   <= '0';

            -- Seq nubmer is being cleared. Clear any pending receive flags
            seqAddrSel   <= '0';
            seqNumberInc <= '0';
            ackTimerInc  <= '0';
            seqRxFlagClr <= '0';

            -- No ACK/NACK output
            nxtFrameTxAck   <= '0';
            nxtFrameTxAckEn <= "0000";

            -- CID Memory write enable 
            cidMemWrANext <= '0';

            -- Start fill of data when FIFO full flag de-asserts
            if seqFifoFull = '0' then
               nxtState <= ST_FILL;
            else
               nxtState <= seqState;
            end if;

         -- Fill sequence FIFO and clear each context memory location
         when ST_FILL =>

            -- Not ready
            intCidReady <= '0';
         
            -- Store current count value into sequence number FIFO, clear context mem location
            seqFifoWr    <= '1';
            cidMemWrB    <= '1';
            cidMemRdB    <= '0';
            seqAddrSel   <= '0';
            seqRxFlagClr <= '0';
            seqNumberInc <= '1';
            ackTimerInc  <= '0';

            -- No ACK/NACK output
            nxtFrameTxAck   <= '0';
            nxtFrameTxAckEn <= "0000";

            -- CID Memory write enable 
            cidMemWrANext <= '0';

            -- Stop after writing 256 bytes
            if seqNumber = 255 then
               nxtState <= ST_TIME_RD;
            else
               nxtState <= seqState;
            end if;

         -- Read currnt timer value from current location
         when ST_TIME_RD =>

            -- Block is ready
            intCidReady <= '1';
         
            -- Read from current context memory location
            seqAddrSel <= '0';
            seqFifoWr  <= '0';
            cidMemWrB  <= '0';
            cidMemRdB  <= '1';

            -- Don't Increment sequence number
            seqNumberInc <= '0';
            ackTimerInc  <= '0';
            seqRxFlagClr <= '0';

            -- No ACK/NACK output
            nxtFrameTxAck   <= '0';
            nxtFrameTxAckEn <= "0000";

            -- CID Memory write enable 
            cidMemWrANext <= '0';

            -- Go to check state
            nxtState <= ST_TIME_CHK;

         -- Check for expired timer in current location
         when ST_TIME_CHK =>

            -- Block is ready
            intCidReady <= '1';
         
            -- No memory read
            seqAddrSel  <= '0';
            cidMemRdB   <= '0';

            -- Increment sequence number
            seqNumberInc <= '1';
            seqRxFlagClr <= '0';

            -- Increment timer if we just read from seq address 255
            if seqNumber = 255 then
               ackTimerInc  <= '1';
            else
               ackTimerInc  <= '0';
            end if;

            -- Entry is active and timer expire value matches
            if cidMemDoutB(50) = '1' and cidMemDoutB(47 downto 32) = ackTimer(15 downto 0) then

               -- Drive nack output
               nxtFrameTxAck <= '0';

               -- Select dest for ack enable
               case cidMemDoutB(49 downto 48) is
                  when "00"   => nxtFrameTxAckEn <= "0001";
                  when "01"   => nxtFrameTxAckEn <= "0010";
                  when "10"   => nxtFrameTxAckEn <= "0100";
                  when "11"   => nxtFrameTxAckEn <= "1000";
                  when others => nxtFrameTxAckEn <= "0000";
               end case;

               -- Return seq number to FIFO, Clear context memory
               seqFifoWr <= '1';
               cidMemWrB <= '1';

            -- No Timeout
            else

               -- No NACK/ACK
               nxtFrameTxAck   <= '0';
               nxtFrameTxAckEn <= "0000";
               seqFifoWr       <= '0';
               cidMemWrB       <= '0';
            end if;

            -- CID Memory write enable 
            cidMemWrANext <= '0';

            -- Go to Ack received state
            nxtState <= ST_ACK_RD;

         -- Read from context memory if pending ack is ready
         when ST_ACK_RD =>

            -- Block is ready
            intCidReady <= '1';
         
            -- Read from current context memory location if ack is pending
            seqAddrSel  <= '1';
            seqFifoWr   <= '0';
            cidMemWrB   <= '0';
            cidMemRdB   <= seqRxFlag;

            -- Don't Increment sequence number
            seqNumberInc <= '0';
            ackTimerInc  <= '0';
            seqRxFlagClr <= '0';

            -- No ACK/NACK output
            nxtFrameTxAck   <= '0';
            nxtFrameTxAckEn <= "0000";

            -- CID Memory write enable 
            cidMemWrANext <= '0';

            -- Go to check return state
            nxtState <= ST_ACK_RET;

         -- Return ack/nack to user if context memory location is active, clear
         -- context memory location
         when ST_ACK_RET =>

            -- Block is ready
            intCidReady <= '1';
         
            -- No memory read, select return ack value as address
            seqAddrSel  <= '1';
            cidMemRdB   <= '0';

            -- No timer increments
            seqNumberInc <= '0';
            ackTimerInc  <= '0';

            -- Clear rx flag if valid on previous clock
            seqRxFlagClr <= dlyRxFlag;

            -- Entry is active and rx flag was valid on previous clock
            if dlyRxFlag = '1' and cidMemDoutB(50) = '1' then

               -- Drive ack output
               nxtFrameTxAck <= locCellRxAck;

               -- Select dest
               case cidMemDoutB(49 downto 48) is
                  when "00"   => nxtFrameTxAckEn <= "0001";
                  when "01"   => nxtFrameTxAckEn <= "0010";
                  when "10"   => nxtFrameTxAckEn <= "0100";
                  when "11"   => nxtFrameTxAckEn <= "1000";
                  when others => nxtFrameTxAckEn <= "0000";
               end case;

               -- Return seq number to FIFO, Clear context memory
               seqFifoWr <= '1';
               cidMemWrB <= '1';

            -- Not Active
            else

               -- No NACK/ACK
               nxtFrameTxAck   <= '0';
               nxtFrameTxAckEn <= "0000";
               seqFifoWr       <= '0';
               cidMemWrB       <= '0';
            end if;

            -- CID Memory write enable 
            cidMemWrANext <= '0';

            -- Go to Ack received state
            nxtState <= ST_CID_START;


         -- Timeslot for CID entry creation in memory through port A
         when ST_CID_START =>

            -- Block is ready
            intCidReady <= '1';
         
            -- No memory read or timer increments
            seqAddrSel   <= '0';
            cidMemRdB    <= '0';
            seqNumberInc <= '0';
            ackTimerInc  <= '0';
            seqRxFlagClr <= '0';

            -- No NACK/ACK
            nxtFrameTxAck   <= '0';
            nxtFrameTxAckEn <= "0000";
            seqFifoWr       <= '0';
            cidMemWrB       <= '0';

            -- CID Memory write enable 
            cidMemWrANext <= '1';

            -- Go to Ack received state
            nxtState <= ST_TIME_RD;


         -- Just in case
         when others =>
            intCidReady     <= '0';
            seqAddrSel      <= '0';
            cidMemRdB       <= '0';
            cidMemWrANext   <= '0';
            seqNumberInc    <= '0';
            ackTimerInc     <= '0';
            seqRxFlagClr    <= '0';
            nxtFrameTxAck   <= '0';
            nxtFrameTxAckEn <= "0000";
            seqFifoWr       <= '0';
            cidMemWrB       <= '0';
            nxtState        <= ST_INIT;
      end case;
   end process;



   -- Determine which address to use for FIFO input and context memory 
   -- port B. Chooses between running counter and returned sequence value. 
   -- Reset the FIFO when the link is not ready
   seqFifoDin <= seqNumber when seqAddrSel = '0' else locCellRxSeq;
   seqFifoRst <= not pibLinkReady;


   -- Pipeline writes to FIFO, needed for timing purposes
   process ( pgpClk, pgpReset ) begin
      if pgpReset = '1' then
         regFifoDin <= (others=>'0') after tpd;
         regFifoWr  <= '0'           after tpd;
      elsif rising_edge(pgpClk) then
         regFifoDin <= seqFifoDin after tpd;
         regFifoWr  <= seqFifoWr  after tpd;
      end if;
   end process;


   -- Sequence number FIFO
   U_SeqNumFifo : pgp_fifo_8x256 port map (
      clk   => pgpClk,       rst   => seqFifoRst,
      din   => regFifoDin,   wr_en => regFifoWr,
      rd_en => seqFifoRd,    dout  => seqFifoDout,
      full  => seqFifoFull,  empty => intSeqFifoEmpty
   );


   -- Keep addresses from lining up, addresses can never match in Xilinx DPRAM
   cidMemAddrA <= startSeqNum when cidMemWrA = '1' else not seqFifoDin;
   cidMemAddrB <= seqFifoDin  when cidMemWrA = '0' else not startSeqNum;


   -- Active context ID memory
   -- Bits 31-0 = cidValue, bits 47-32 = cidTimer, bits 49-48 = VC num, bit 50 is en
   -- Writes to port B will always be zero
   U_CidMemory : pgp_dpram_51x256 port map (
      clka  => pgpClk,       clkb  => pgpClk, 
      addra => cidMemAddrA,  addrb => cidMemAddrB,
      dina  => cidMemDinA,   dinb  => (others=>'0'),
      wea   => cidMemWrA,    web   => cidMemWrB,
      doutb => cidMemDoutB
   );


   -- Adder to calculate timeout value for newly created context timers
   U_TimerSum : pgp_adder_16_16 port map (
      A   => ackTimer,
      B   => intTimeout,
      S   => ackTimerSum
   );

end PgpAckRx;

