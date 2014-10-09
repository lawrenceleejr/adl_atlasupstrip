-------------------------------------------------------------------------------
-- Title         : Pretty Good Protocol Applications, Register Slave Block
-- Project       : General Purpose Core
-------------------------------------------------------------------------------
-- File          : PgpRegSlave.vhd
-- Author        : Ryan Herbst, rherbst@slac.stanford.edu
-- Created       : 09/22/2007
-------------------------------------------------------------------------------
-- Description:
-- Slave block for Register protocol over the PGP.
-- Packet is 16 bytes. The 16 bit values passed over the PGP will be:
-- Word 0 Data[1:0]   = VC
-- Word 0 Data[7:2]   = Dest_ID
-- Word 0 Data[15:8]  = TID[7:0]
-- Word 1 Data[15:0]  = TID[23:8]
-- Word 2 Data[15:0]  = Address[15:0]
-- Word 3 Data[15:14] = OpCode, 0x0=Read, 0x1=Write, 0x2=Set, 0x3=Clear
-- Word 3 Data[13:8]  = Don't Care
-- Word 3 Data[7:0]   = Address[23:16]
-- Word 4 Data[15:0]  = WriteData[15:0]
-- Word 5 Data[15:0]  = WriteData[31:16]
-- Word 6             = Don't Care
-- Word 7 Data[15:2]  = Don't Care
-- Word 7 Data[1]     = Timeout Flag (response data)
-- Word 7 Data[0]     = Fail Flag (response data)
-------------------------------------------------------------------------------
-- Copyright (c) 2007 by Ryan Herbst. All rights reserved.
-------------------------------------------------------------------------------
-- Modification history:
-- 09/22/2007: created.
-- 10/10/2007: Added 32-bit CID value to frame.
-- 10/29/2007: Changed name of coregen blocks
-- 11/06/2007: Changed flow control reaction to ensure their are no short cells.
-- 11/06/2007: Added wait for ACK and re-transmission on NACK reception.
-- 11/07/2007: Changed reaction to full flag due to change in pic interface.
-- 11/20/2007: Added check to ensure overflow will put EOFE into buffer.
-- 11/27/2007: Modified to allow the option of sync or async FIFOs
--             Removed re-transmission of nack reception.
-- 11/30/2007: Fixed error with back to back frames and mis-connected data lines.
--             Made frame size 20bytes for received data. Testing Only.
-- 11/30/2007: Removed FIFO in TX direction.
-- 12/12/2007: Added wait for ack de-assertion for set and clear commands.
--             Previous version would see ack from pervious command due to
--             pipeline of register data.
-- 12/14/2007: Adjusted frame length back to 16 bytes.
-- 01/25/2008: Adjusted for new frame format.
-- 02/08/2008: More frame format changes. Added in progress flag.
-- 02/05/2008: Changed timeout to 12-bits.
-- 07/22/2008: Changed timeout to 16-bits.
-- 01/14/2009: Changed timeout to 24-bits.
-------------------------------------------------------------------------------

LIBRARY ieee;
USE work.ALL;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity PgpRegSlave is
   generic (
      AsyncFIFO   : string  := "TRUE"   -- Use Async FIFOs, TRUE or FALSE
   );
   port ( 

      -- PGP Clock And Reset
      pgpClk           : in  std_logic;                     -- PGP Clock
      pgpReset         : in  std_logic;                     -- Synchronous PGP Reset

      -- Local clock and reset
      locClk           : in  std_logic;                     -- Local Clock
      locReset         : in  std_logic;                     -- Synchronous Local Reset

      -- PGP Receive Signals
      vcFrameRxValid   : in  std_logic;                     -- Data is valid
      vcFrameRxSOF     : in  std_logic;                     -- Data is SOF
      vcFrameRxWidth   : in  std_logic;                     -- Data is 16-bits
      vcFrameRxEOF     : in  std_logic;                     -- Data is EOF
      vcFrameRxEOFE    : in  std_logic;                     -- Data is EOF with Error
      vcFrameRxData    : in  std_logic_vector(15 downto 0); -- Data
      vcLocBuffAFull   : out std_logic;                     -- Local buffer almost full
      vcLocBuffFull    : out std_logic;                     -- Local buffer full

      -- PGP Transmit Signals
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

      -- Local register control signals
      regInp           : out std_logic;                     -- Register Access In Progress Flag
      regReq           : out std_logic;                     -- Register Access Request
      regOp            : out std_logic;                     -- Register OpCode, 0=Read, 1=Write
      regAck           : in  std_logic;                     -- Register Access Acknowledge
      regFail          : in  std_logic;                     -- Register Access Fail
      regAddr          : out std_logic_vector(23 downto 0); -- Register Address
      regDataOut       : out std_logic_vector(31 downto 0); -- Register Data Out
      regDataIn        : in  std_logic_vector(31 downto 0)  -- Register Data In
   );

end PgpRegSlave;


-- Define architecture
architecture PgpRegSlave of PgpRegSlave is

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
   signal rxFifoDin      : std_logic_vector(19 downto 0);
   signal rxFifoDout     : std_logic_vector(19 downto 0);
   signal rxFifoRd       : std_logic;
   signal rxFifoRdDly    : std_logic;
   signal rxFifoCount    : std_logic_vector(8  downto 0);
   signal rxFifoEmpty    : std_logic;
   signal locRxSOF       : std_logic;
   signal locRxWidth     : std_logic;
   signal locRxEOF       : std_logic;
   signal locRxEOFE      : std_logic;
   signal locRxData      : std_logic_vector(15 downto 0);
   signal intRxCnt       : std_logic_vector(2 downto 0);
   signal intRxCntEn     : std_logic;
   signal intOpCode      : std_logic_vector(1  downto 0);
   signal intVc          : std_logic_vector(1  downto 0);
   signal intDest        : std_logic_vector(5  downto 0);
   signal intAddress     : std_logic_vector(23 downto 0);
   signal intTid         : std_logic_vector(23 downto 0);
   signal intWrData      : std_logic_vector(31 downto 0);
   signal rxFifoRdEn     : std_logic;
   signal intRegStart    : std_logic;
   signal intInp         : std_logic;
   signal intReq         : std_logic;
   signal intOp          : std_logic;
   signal intData        : std_logic_vector(31 downto 0);
   signal intReqCnt      : std_logic_vector(23 downto 0);
   signal intFail        : std_logic;
   signal intTout        : std_logic;
   signal respCnt        : std_logic_vector(2  downto 0);
   signal nxtInp         : std_logic;
   signal nxtReq         : std_logic;
   signal nxtOp          : std_logic;
   signal nxtdata        : std_logic_vector(31 downto 0);
   signal nxtFail        : std_logic;
   signal nxtTout        : std_logic;
   signal fifoErr        : std_logic;
   signal fifoFull       : std_logic;
   signal respReq        : std_logic;
   signal respReqDly     : std_logic_vector(1 downto 0);
   signal respAck        : std_logic;
   signal respAckDly     : std_logic_vector(1 downto 0);
   signal respValid      : std_logic;

   -- Register access states
   signal   curState    : std_logic_vector(2 downto 0);
   signal   nxtState    : std_logic_vector(2 downto 0);
   constant ST_IDLE     : std_logic_vector(2 downto 0) := "001";
   constant ST_WRITE    : std_logic_vector(2 downto 0) := "010";
   constant ST_READ     : std_logic_vector(2 downto 0) := "011";
   constant ST_SET      : std_logic_vector(2 downto 0) := "100";
   constant ST_CLEAR    : std_logic_vector(2 downto 0) := "101";
   constant ST_RESP     : std_logic_vector(2 downto 0) := "110";
   constant ST_DONE     : std_logic_vector(2 downto 0) := "111";

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

   -- Data going into Rx FIFO
   rxFifoDin(19)          <= vcFrameRxSOF;
   rxFifoDin(18)          <= vcFrameRxWidth;
   rxFifoDin(17)          <= vcFrameRxEOF  or fifoErr;
   rxFifoDin(16)          <= vcFrameRxEOFE or fifoErr;
   rxFifoDin(15 downto 0) <= vcFrameRxData; 

   -- Async Receive FIFO
   U_GenRxAFifo: if AsyncFIFO = "TRUE" generate
      U_RegRxAFifo: pgp_afifo_20x511 port map (
         din           => rxFifoDin,
         rd_clk        => locClk,
         rd_en         => rxFifoRd,
         rst           => pgpReset,
         wr_clk        => pgpClk,
         wr_en         => vcFrameRxValid,
         dout          => rxFifoDout,
         empty         => rxFifoEmpty,
         full          => fifoFull,
         wr_data_count => rxFifoCount
      );
   end generate;

   -- Sync Receive FIFO
   U_GenRxFifo: if AsyncFIFO = "FALSE" generate
      U_RegRxFifo: pgp_fifo_20x512 port map (
         din           => rxFifoDin,
         clk           => pgpClk,
         rd_en         => rxFifoRd,
         rst           => pgpReset,
         wr_en         => vcFrameRxValid,
         dout          => rxFifoDout,
         empty         => rxFifoEmpty,
         full          => fifoFull,
         data_count    => rxFifoCount
      );
   end generate;

   -- Data coming out of Rx FIFO
   locRxSOF   <= rxFifoDout(19);
   locRxWidth <= rxFifoDout(18);
   locRxEOF   <= rxFifoDout(17);
   locRxEOFE  <= rxFifoDout(16);
   locRxData  <= rxFifoDout(15 downto 0);

   -- Generate fifo read, Don't read after EOF is just read
   rxFifoRd <= (not rxFifoEmpty) and rxFifoRdEn and ((not rxFifoRdDly) or (not locRxEOF));

   -- Generate flow control
   process ( pgpClk, pgpReset ) begin
      if pgpReset = '1' then
         vcLocBuffAFull <= '0' after tpd;
         vcLocBuffFull  <= '0' after tpd;
         fifoErr        <= '0' after tpd;
      elsif rising_edge(pgpClk) then

         -- Generate full error
         if rxFifoCount >= 508 or fifoFull = '1' then
            fifoErr <= '1' after tpd;
         else
            fifoErr <= '0' after tpd;
         end if;

         -- Almost full at half capacity
         vcLocBuffAFull <= rxFifoCount(8);

         -- Full at 3/4 capacity
         vcLocBuffFull <= rxFifoCount(8) and rxFifoCount(7);
      end if;
   end process;


   -- Receive Data Processor
   process ( locClk, locReset ) begin
      if locReset = '1' then
         intOpCode   <= "00"          after tpd;
         intAddress  <= (others=>'0') after tpd;
         intWrData   <= (others=>'0') after tpd;
         intRegStart <= '0'           after tpd;
         intTid      <= (others=>'0') after tpd;
         rxFifoRdDly <= '0'           after tpd;
         intRxCnt    <= (others=>'0') after tpd;
         intRxCntEn  <= '0'           after tpd;
         intDest     <= (others=>'0') after tpd;
         intVc       <= (others=>'0') after tpd;
      elsif rising_edge(locClk) then

         -- Generate delayed read
         rxFifoRdDly <= rxFifoRd after tpd;

         -- Only process when data has been read
         if rxFifoRdDly = '1' then

            -- Receive Data Counter
            -- Reset on SOF or EOF, Start counter on SOF
            if locRxSOF = '1' or locRxEOF = '1' then
               intRxCnt   <= (others=>'0') after tpd;
               intRxCntEn <= not locRxEOF  after tpd;
            elsif intRxCntEn = '1' and intRxCnt /= "111" then
               intRxCnt <= intRxCnt + 1 after tpd;
            end if;

            -- SOF Received
            if locRxSOF = '1' then
               intTid(7 downto 0) <= locRxData(15 downto 8) after tpd;
               intDest            <= locRxData(7  downto 2) after tpd;
               intVc              <= locRxData(1  downto 0) after tpd;
               intRegStart        <= '0'                    after tpd;

            -- Rest of Frame
            else case intRxCnt is

               -- Word 1 
               when "000" =>
                  intTid(23 downto 8) <= locRxData after tpd;
                  intRegStart         <= '0'       after tpd;

               -- Word 2
               when "001" =>
                  intAddress(15 downto 0) <= locRxData after tpd;
                  intRegStart             <= '0'       after tpd;

               -- Word 3 
               when "010" =>
                  intOpCode                <= locRxData(15 downto 14) after tpd;
                  intAddress(23 downto 16) <= locRxData(7  downto 0)  after tpd;
                  intRegStart              <= '0'                     after tpd;

               -- Word 4 
               when "011" =>
                  intWrData(15 downto 0) <= locRxData after tpd;
                  intRegStart            <= '0'       after tpd;

               -- Word 5 
               when "100" =>
                  intWrData(31 downto 16) <= locRxData after tpd;
                  intRegStart             <= '0'       after tpd;

               -- Word 7, Last word 
               when "110" =>

                  -- No error and internal flags match
                  if locRxEOF = '1' and locRxEOFE = '0' and locRxWidth = '1' then
                     intRegStart <= '1' after tpd;
                  else
                     intRegStart <= '0' after tpd;
                  end if;

               -- Do nothing for others
               when others =>
                  intRegStart <= '0' after tpd;
            end case;
            end if;
         else
            intRegStart <= '0' after tpd;
         end if;
      end if;
   end process;


   -- Drive address bus
   regAddr    <= intAddress;
   regDataOut <= intData;
   regInp     <= intInp;
   regReq     <= intReq;
   regOp      <= intOp;


   -- Register State Machine, Sync Logic
   process ( locClk, locReset ) begin
      if locReset = '1' then
         intInp     <= '0'           after tpd;
         intReq     <= '0'           after tpd;
         intOp      <= '0'           after tpd;
         intData    <= (others=>'0') after tpd;
         intReqCnt  <= (others=>'0') after tpd;
         intFail    <= '0'           after tpd;
         intTout    <= '0'           after tpd;
         respAckDly <= (others=>'0') after tpd;
         curState   <= ST_IDLE       after tpd;
      elsif rising_edge(locClk) then

         -- Sync Response Ack Lines
         respAckDly(0) <= respAck;
         respAckDly(1) <= respAckDly(0);

         -- State transition
         curState <= nxtState after tpd;

         -- Opcode and write data
         intInp <= nxtInp     after tpd;
         intReq <= nxtReq     after tpd;
         intOp  <= nxtOp      after tpd;

         -- Data Storage
         intData <= nxtData after tpd;

         -- Timeout & fail flags
         intFail <= nxtFail after tpd;
         intTout <= nxtTout after tpd;

         -- Timeout counter
         if intReq <= '0' then
            intReqCnt <= (others=>'0') after tpd;
         elsif intReqCnt /= x"FFFFFF" then
            intReqCnt <= intReqCnt + 1 after tpd;
         end if;
      end if;
   end process;


   -- Register state engine
   process ( curState, intWrData, intRegStart, intOpCode, intData, 
             regAck, regFail, regDataIn, intReqCnt, intFail, intTout, respAckDly ) begin

      -- States
      case curState is

         -- IDLE, Wait for enable from read logic
         when ST_IDLE =>

            -- No Response Request
            respReq <= '0';

            -- No timeout or fail
            nxtFail <= '0';
            nxtTout <= '0';

            -- No external commands
            nxtInp <= '0';
            nxtReq <= '0';
            nxtOp  <= '0';

            -- Register data
            nxtdata <= intWrData;

            -- Start
            if intRegStart = '1' then

               -- Write Command
               if intOpCode = "01" then
                  nxtState <= ST_WRITE;

               -- Read, Set Bit, Clear Bit
               else
                  nxtState <= ST_READ;
               end if;
               rxFifoRdEn <= '0';
            else
               nxtState   <= curState;
               rxFifoRdEn <= '1';
            end if;

         -- Write State
         when ST_WRITE =>

            -- No Response Request
            respReq <= '0';

            -- Assert write to external interface
            nxtInp <= '1';
            nxtReq <= '1';
            nxtOp  <= '1';

            -- Disable FIFO Rd
            rxFifoRdEn <= '0';

            -- Keep data
            nxtdata <= intData;

            -- Ack is passed
            if regAck = '1' then

               -- Generate response
               nxtState <= ST_RESP;

               -- Store fail flag, no timeout
               nxtFail <= regFail;
               nxtTout <= '0';

            -- Timeout
            elsif intReqCnt = x"FFFFFF" then

               -- Generate response
               nxtState <= ST_RESP;

               -- No Fail, set timeout
               nxtFail <= '0';
               nxtTout <= '1';

           -- Keep waiting
           else
               nxtState <= curState;
               nxtFail  <= '0';
               nxtTout  <= '0';
           end if;

         -- Read State
         when ST_READ =>

            -- No Response Request
            respReq <= '0';

            -- Assert read to external interface
            nxtInp <= '1';
            nxtReq <= '1';
            nxtOp  <= '0';

            -- Disable FIFO Rd
            rxFifoRdEn <= '0';

            -- Take read data
            nxtdata <= regDataIn;

            -- Ack is passed
            if regAck = '1' then

               -- Fail
               if regFail = '1' then

                  -- Store fail flag, no timeout, send response
                  nxtFail  <= regFail;
                  nxtTout  <= '0';
                  nxtState <= ST_RESP;

               -- Normal termination
               else

                  -- No fail or timeout
                  nxtFail  <= '0';
                  nxtTout  <= '0';

                  -- Set bit command
                  if intOpCode = "10" then
                     nxtState <= ST_SET;

                  -- Clear bit command
                  elsif intOpCode = "11" then
                     nxtState <= ST_CLEAR;

                  -- Read command
                  else
                     nxtState <= ST_RESP;
                  end if;
               end if;
            
           -- Timeout
           elsif intReqCnt = x"FFFFFF" then

               -- Generate response
               nxtState <= ST_RESP;

               -- No Fail, set timeout
               nxtFail <= '0';
               nxtTout <= '1';

           -- Keep waiting
           else
               nxtState <= curState;
               nxtFail  <= '0';
               nxtTout  <= '0';
           end if;

         -- Set Bit Command
         when ST_SET =>

            -- No Response Request
            respReq <= '0';

            -- No external commands
            nxtInp <= '1';
            nxtReq <= '0';
            nxtOp  <= '0';

            -- Disable FIFO Rd
            rxFifoRdEn <= '0';

            -- Set bits
            nxtdata <= intData or intWrData;

            -- No errors
            nxtFail  <= '0';
            nxtTout  <= '0';

            -- Go to write state
            -- Wait for ack from previous command to clear
            if regAck = '0' then
               nxtState <= ST_WRITE;
            else
               nxtState <= curState;
            end if;

         -- Clear Bit Command
         when ST_CLEAR =>

            -- No Response Request
            respReq <= '0';

            -- No external commands
            nxtInp <= '1';
            nxtReq <= '0';
            nxtOp  <= '0';

            -- Disable FIFO Rd
            rxFifoRdEn <= '0';

            -- Clear bits
            nxtdata <= intData and (not intWrData);

            -- No errors
            nxtFail  <= '0';
            nxtTout  <= '0';

            -- Go to write state
            -- Wait for ack from previous command to clear
            if regAck = '0' then
               nxtState <= ST_WRITE;
            else
               nxtState <= curState;
            end if;

         -- Response
         when ST_RESP =>

            -- Response Request
            respReq <= '1';

            -- No external commands
            nxtInp <= '0';
            nxtReq <= '0';
            nxtOp  <= '0';

            -- Disable FIFO Rd
            rxFifoRdEn <= '0';

            -- Keep Data
            nxtdata <= intData;

            -- Keep errors
            nxtFail  <= intFail;
            nxtTout  <= intTout;

            -- Wait For Response Engine To Response
            if respAckDly(1) = '1' then
               nxtState  <= ST_DONE;
            else
               nxtState  <= curState;
            end if;

         -- Done
         when ST_DONE =>

            -- Response Request
            respReq <= '0';

            -- No external commands
            nxtInp <= '0';
            nxtReq <= '0';
            nxtOp  <= '0';

            -- Disable FIFO Rd
            rxFifoRdEn <= '0';

            -- Keep Data
            nxtdata <= intData;

            -- Keep errors
            nxtFail  <= intFail;
            nxtTout  <= intTout;

            -- Wait For Response Engine To Respond
            if respAckDly(1) = '0' then
               nxtState  <= ST_IDLE;
            else
               nxtState  <= curState;
            end if;

         when others =>
            respReq     <= '0';
            nxtReq      <= '0';
            nxtInp      <= '0';
            nxtOp       <= '0';
            rxFifoRdEn  <= '0';
            nxtdata     <= (others=>'0');
            nxtFail     <= '0';
            nxtTout     <= '0';
            nxtState    <= ST_IDLE;
      end case;
   end process;


   -- Response Data Engine. Runs on PGP clock not local clock.
   -- Handshake lines are double synced before being acted upon.
   -- Timing constraints must ensure that data moving between
   -- clocks is less than the period of the faster clock.
   process ( pgpClk, pgpReset ) begin
      if pgpReset = '1' then
         respReqDly     <= (others=>'0') after tpd;
         respAck        <= '0'           after tpd;
         respCnt        <= (others=>'0') after tpd;
         respValid      <= '0'           after tpd;
         vcFrameTxSOF   <= '0'           after tpd;
         vcFrameTxEOF   <= '0'           after tpd;
         vcFrameTxData  <= (others=>'0') after tpd;
      elsif rising_edge(pgpClk) then

         -- Sync Response Req Lines
         respReqDly(0) <= respReq       after tpd;
         respReqDly(1) <= respReqDly(0) after tpd;

         -- Response Counter
         if respReqDly(1) = '0' then
            respCnt   <= (others=>'0') after tpd;
         elsif respValid  = '1' and vcFrameTxReady = '1' then
            respCnt <= respCnt + 1 after tpd;
         end if;

         -- Request is not asserted
         if respReqDly(1) = '0' then
            respValid <= '0' after tpd;
            respAck   <= '0' after tpd;

         -- Request is assert, valid is not assert, ack is not asserted, 
         -- wait for PGP to be ready. Assert grant and valid
         elsif respValid = '0' and respAck = '0' and vcRemBuffAFull = '0' then
            respValid <= '1' after tpd;
            respAck   <= '0' after tpd;

         -- Data movement on last value. Assert ack, de-assert valid
         elsif vcFrameTxReady = '1' and respCnt = "111" then
            respValid <= '0' after tpd;
            respAck   <= '1' after tpd;
         end if;

         -- Initial Data
         if respReqDly(1) = '0' then
            vcFrameTxSOF               <= '1'                after tpd;
            vcFrameTxEOF               <= '0'                after tpd;
            vcFrameTxData(15 downto 8) <= intTid(7 downto 0) after tpd;
            vcFrameTxData(7  downto 2) <= intDest            after tpd;
            vcFrameTxData(1  downto 0) <= intVc              after tpd;

         -- Data Movement
         elsif respValid  = '1' and vcFrameTxReady = '1' then
            case respCnt is
               when "000" =>
                  vcFrameTxSOF  <= '0'                 after tpd;
                  vcFrameTxEOF  <= '0'                 after tpd;
                  vcFrameTxData <= intTid(23 downto 8) after tpd;
               when "001" =>
                  vcFrameTxSOF  <= '0'                     after tpd;
                  vcFrameTxEOF  <= '0'                     after tpd;
                  vcFrameTxData <= intAddress(15 downto 0) after tpd;
               when "010" =>
                  vcFrameTxSOF                <= '0'                      after tpd;
                  vcFrameTxEOF                <= '0'                      after tpd;
                  vcFrameTxData(15 downto 14) <= intOpCode                after tpd;
                  vcFrameTxData(13 downto  8) <= (others=>'0')            after tpd;
                  vcFrameTxData(7  downto  0) <= intAddress(23 downto 16) after tpd;
               when "011" =>
                  vcFrameTxSOF   <= '0'                   after tpd;
                  vcFrameTxEOF   <= '0'                   after tpd;
                  vcFrameTxData  <= intData(15 downto  0) after tpd;
               when "100" =>
                  vcFrameTxSOF   <= '0'                   after tpd;
                  vcFrameTxEOF   <= '0'                   after tpd;
                  vcFrameTxData  <= intData(31 downto 16) after tpd;
               when "101" =>
                  vcFrameTxSOF   <= '0'           after tpd;
                  vcFrameTxEOF   <= '0'           after tpd;
                  vcFrameTxData  <= (others=>'0') after tpd;
               when "110" =>
                  vcFrameTxSOF               <= '0'           after tpd;
                  vcFrameTxEOF               <= '1'           after tpd;
                  vcFrameTxData(15 downto 2) <= (others=>'0') after tpd;
                  vcFrameTxData(1)           <= intTout       after tpd;
                  vcFrameTxData(0)           <= intFail       after tpd;
               when others =>
                  vcFrameTxSOF   <= '0'           after tpd;
                  vcFrameTxEOF   <= '0'           after tpd;
                  vcFrameTxData  <= (others=>'0') after tpd;
            end case;
         end if;
      end if;
   end process;

   -- Output to PGP
   vcFrameTxValid <= respValid;
   vcFrameTxEOFE  <= '0';
   vcFrameTxCid   <= (others=>'0');
   vcFrameTxWidth <= '1';

end PgpRegSlave;

