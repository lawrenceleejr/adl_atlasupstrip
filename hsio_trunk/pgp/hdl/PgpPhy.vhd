-------------------------------------------------------------------------------
-- Title         : Pretty Good Protocol, Physical Interface Module
-- Project       : General Purpose Core
-------------------------------------------------------------------------------
-- File          : PgpPhy.vhd
-- Author        : Ryan Herbst, rherbst@slac.stanford.edu
-- Created       : 10/24/2006
-------------------------------------------------------------------------------
-- Description:
-- Physical interface module for the Pretty Good Protocol core. 
-------------------------------------------------------------------------------
-- Copyright (c) 2006 by Ryan Herbst. All rights reserved.
-------------------------------------------------------------------------------
-- Modification history:
-- 10/24/2006: created.
-- 01/17/2006: First simulation complete.
-- 04/16/2006: Modified to support cell transmission with a blank spot for the
--             SOC charactor already included in the cell.
-- 05/30/2007: Modified link init sequence so that rx and tx are reset
--             seperately. Changed state counters for pattern detection.
--             Fixed version and link train error, extended init timeout.
-- 06/08/2007: Added counter on rx and tx lock to ensure that we only proceed
--             with init after rx and tx lock are stable.
-- 06/11/2007: Changed init sequence so that txPmaReset and rxPmaReset are not
--             longer asserted during the init sequence. These resets mess with
--             the PLL and should only be asserted at startup. It appears as if
--             the RX PLL can re-lock when the signal returns without a PMA
--             reset. Also the state machine will allow the init sequence to 
--             continue to loop until a link is found. The link will only go to
--             fail if the versions mismatch. TX or RX unlock will cause the 
--             link to re-start.
-- 06/13/2007: Cleanup of PMA reset control. Wait for RX lock is now much 
--             longer than before per the Xilinx datasheet.
-- 06/15/2007: Removed shifting on receive data. MGT will always align comma
--             to an even byte.
-- 06/19/2007: One skip is now transmitted after a cell. The rest is junk data.
-- 06/19/2007: Removed reset of lock counters in ST_RESET state.
-- 08/24/2007: Changed clock init state machine.
-- 08/25/2007: Combined decode and disparity error
-- 04/30/2008: Added Chipscope For Debugging
-- 11/05/2008: Removed chipscope. Removed rx/tx pll and reset logic.
-------------------------------------------------------------------------------

LIBRARY ieee;
USE work.ALL;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity PgpPhy is port ( 

   -- System clock, reset & control
   pgpClk            : in  std_logic;                     -- Master clock
   pgpReset          : in  std_logic;                     -- Synchronous reset input
   pibReLink         : in  std_logic;                     -- Re-Link control signal

   -- Status signals
   localVersion      : in  std_logic_vector(7  downto 0); -- Local version ID
   remoteVersion     : out std_logic_vector(7  downto 0); -- Remote version ID
   pibFail           : out std_logic;                     -- PIB fail indication
   pibLinkReady      : out std_logic;                     -- PIB link is ready
   pibState          : out std_logic_vector(2  downto 0); -- PIB State

   -- Cell Transmit Interface
   pibTxSOC          : in  std_logic;                     -- Cell data start of cell
   pibTxWidth        : in  std_logic;                     -- Cell data width
   pibTxEOC          : in  std_logic;                     -- Cell data end of cell
   pibTxEOF          : in  std_logic;                     -- Cell data end of frame
   pibTxEOFE         : in  std_logic;                     -- Cell data end of frame error
   pibTxData         : in  std_logic_vector(15 downto 0); -- Cell data data

   -- Cell Receive Interface
   pibRxSOC          : out std_logic;                     -- Cell data start of cell
   pibRxWidth        : out std_logic;                     -- Cell data width
   pibRxEOC          : out std_logic;                     -- Cell data end of cell
   pibRxEOF          : out std_logic;                     -- Cell data end of frame
   pibRxEOFE         : out std_logic;                     -- Cell data end of frame error
   pibRxData         : out std_logic_vector(15 downto 0); -- Cell data data

   -- Physical Interface Signals
   phyRxPolarity     : out std_logic;                     -- PHY receive signal polarity
   phyRxData         : in  std_logic_vector(15 downto 0); -- PHY receive data
   phyRxDataK        : in  std_logic_vector(1  downto 0); -- PHY receive data is K character
   phyTxData         : out std_logic_vector(15 downto 0); -- PHY transmit data
   phyTxDataK        : out std_logic_vector(1  downto 0); -- PHY transmit data is K character
   phyInitDone       : in  std_logic                      -- PHY init is done
); 

end PgpPhy;


-- Define architecture
architecture PgpPhy of PgpPhy is

   -- Local Signals
   signal nxtPibFail        : std_logic;
   signal nxtPibLinkReady   : std_logic;
   signal stateCnt          : std_logic_vector(15 downto 0);
   signal stateCntRst       : std_logic;
   signal stateCntEn        : std_logic;
   signal pattCnt           : std_logic_vector(7  downto 0);
   signal pattCntRst        : std_logic;
   signal pattCntEn         : std_logic;
   signal txIdleEn          : std_logic;
   signal txTrainEn         : std_logic;
   signal txVerEn           : std_logic;
   signal txSkipEn          : std_logic;
   signal txDataEn          : std_logic;
   signal rxDataEn          : std_logic;
   signal rxDetectIdle      : std_logic;
   signal rxDetectTrain     : std_logic;
   signal rxDetectInvert    : std_logic;
   signal rxDetectVer       : std_logic;
   signal rxDetectVerErr    : std_logic;
   signal nxtRxPolarity     : std_logic;
   signal dly0RxData        : std_logic_vector(15 downto 0);
   signal dly0RxDataK       : std_logic_vector(1  downto 0);
   signal dly1RxData        : std_logic_vector(15 downto 0);
   signal dly1RxDataK       : std_logic_vector(1  downto 0);
   signal sofDetect         : std_logic;
   signal intPhyRxPolarity  : std_logic;
   signal txDlyEOC          : std_logic;
   signal txDlyEOF          : std_logic;
   signal txDlyEOFE         : std_logic;

   -- Physical Link State
   constant ST_LOCK  : std_logic_vector(2 downto 0) := "001";
   constant ST_IDLE  : std_logic_vector(2 downto 0) := "010";
   constant ST_TRAIN : std_logic_vector(2 downto 0) := "011";
   constant ST_VER   : std_logic_vector(2 downto 0) := "100";
   constant ST_EN    : std_logic_vector(2 downto 0) := "101";
   constant ST_SKP   : std_logic_vector(2 downto 0) := "110";
   constant ST_FAIL  : std_logic_vector(2 downto 0) := "111";
   signal   curState : std_logic_vector(2 downto 0);
   signal   nxtState : std_logic_vector(2 downto 0);

   -- Debug states
   signal   nxtDebug : std_logic_vector(2 downto 0);
   signal   curDebug : std_logic_vector(2 downto 0);

   -- Constant 8-bit values for RX & Tx
   constant K_COM  : std_logic_vector(7 downto 0) := "10111100"; -- K28.5
   constant K_IDL  : std_logic_vector(7 downto 0) := "01111100"; -- K28.3
   constant K_LTS  : std_logic_vector(7 downto 0) := "00111100"; -- K28.1
   constant D_102  : std_logic_vector(7 downto 0) := "01001010"; -- D10.2
   constant D_215  : std_logic_vector(7 downto 0) := "10110101"; -- D21.5
   constant K_SKP  : std_logic_vector(7 downto 0) := "00011100"; -- K28.0
   constant K_VTS  : std_logic_vector(7 downto 0) := "11110111"; -- K23.7
   constant K_SOC  : std_logic_vector(7 downto 0) := "11111011"; -- K27.7
   constant K_EOF  : std_logic_vector(7 downto 0) := "11111101"; -- K29.7
   constant K_EOFE : std_logic_vector(7 downto 0) := "11111110"; -- K30.7
   constant K_EOC  : std_logic_vector(7 downto 0) := "01011100"; -- K28.2

   -- Register delay for simulation
   constant tpd:time := 0.5 ns;

begin

   -- Outputs
   phyRxPolarity <= intPhyRxPolarity;


   -- State transition sync logic. 
   -- In state counter for timeouts
   -- Rx pattern counter
   process ( pgpClk, pgpReset ) begin
      if pgpReset = '1' then
         curState         <= ST_LOCK       after tpd;
         curDebug         <= ST_LOCK       after tpd;
         stateCnt         <= (others=>'0') after tpd;
         pattCnt          <= (others=>'0') after tpd;
         intPhyRxPolarity <= '0'           after tpd;
         pibFail          <= '0'           after tpd;
         pibLinkReady     <= '0'           after tpd;
      elsif rising_edge(pgpClk) then

         -- Status signals
         pibFail      <= nxtPibFail      after tpd;
         pibLinkReady <= nxtPibLinkReady after tpd;

         -- Re-Link detected or either of the clocks have lost lock
         if pibReLink = '1' or phyInitDone = '0' then
            curState <= ST_LOCK after tpd;
         else
            curState <= nxtState after tpd;
         end if;

         -- Link inversion
         intPhyRxPolarity <= nxtRxPolarity after tpd;

         -- In state counter
         if stateCntRst = '1' then
            stateCnt <= (others=>'0') after tpd;
         elsif stateCntEn = '1' then
            stateCnt <= stateCnt + 1 after tpd;
         end if;

         -- Pattern receive counter
         if pattCntRst = '1' then
            pattCnt <= (others=>'0') after tpd;
         elsif pattCntEn = '1' then
            pattCnt <= pattCnt + 1 after tpd;
         end if;

         -- Drive state debug output
         curDebug <= nxtDebug;
      end if;
   end process;

   -- Output debug state
   pibState  <= curDebug;

   -- Link control state machine
   process ( curState, stateCnt, rxDetectIdle, pattCnt, intPhyRxPolarity, rxDetectTrain, 
             rxDetectVer, rxDetectVerErr, rxDetectInvert, pibTxEOC, pibTxWidth, txDlyEOC, 
             curDebug ) begin
      case curState is 

         -- Wait for lock state
         when ST_LOCK =>
            nxtPibLinkReady <= '0';
            nxtPibFail      <= '0';
            pattCntRst      <= '1';
            pattCntEn       <= '0';
            stateCntRst     <= '1';
            stateCntEn      <= '0';
            txIdleEn        <= '0';
            txTrainEn       <= '0';
            txVerEn         <= '0';
            txSkipEn        <= '0';
            txDataEn        <= '0';
            rxDataEn        <= '0';
            nxtRxPolarity   <= '0';
            nxtDebug        <= ST_LOCK;
            nxtState        <= ST_IDLE;

         -- Transmit IDLE
         when ST_IDLE =>

            -- Idle is transmitting
            nxtPibLinkReady <= '0';
            nxtPibFail      <= '0';
            txTrainEn       <= '0';
            txVerEn         <= '0';
            txDataEn        <= '0';
            rxDataEn        <= '0';
            nxtRxPolarity   <= '0';
            nxtDebug        <= ST_IDLE;

            -- Transmit IDLE normally,
            -- add two skip patterns every 512 clocks
            if stateCnt(8 downto 2) = 0 then 
               txIdleEn <= '0';
               txSkipEn <= '1';
            else
               txIdleEn <= '1';
               txSkipEn <= '0';
            end if;

            -- Free run state counter
            stateCntEn  <= '1';

            -- Pattern counter counts IDLE sequence reception
            -- Stop counting once we receive enough patterns
            pattCntEn <= rxDetectIdle and not pattCnt(7);
           
            -- Move to next state when 128 IDLE sequences detected and we have 
            -- been in the state long enough to transmit 256 IDLE sequences (512 clocks)
            if pattCnt(7) = '1' and stateCnt > 511 then
               stateCntRst <= '1';
               pattCntRst  <= '1';
               nxtState    <= ST_TRAIN;

            -- Check for timeout while waiting for IDLE
            elsif stateCnt = x"FFFF" then
               stateCntRst <= '1';
               pattCntRst  <= '1';
               nxtState    <= ST_LOCK;

            -- Keep counting
            else
               stateCntRst <= '0';
               pattCntRst  <= '0';
               nxtState    <= curState;
            end if;

         -- Transmit training sequence
         when ST_TRAIN =>

            -- Training sequence is transmitting
            nxtPibLinkReady <= '0';
            nxtPibFail      <= '0';
            txIdleEn        <= '0';
            txVerEn         <= '0';
            txDataEn        <= '0';
            rxDataEn        <= '0';
            nxtDebug        <= ST_TRAIN;

            -- Transmit training normally,
            -- add two skip patterns every 512 clocks
            if stateCnt(8 downto 2) = 0 then 
               txTrainEn <= '0';
               txSkipEn  <= '1';
            else
               txTrainEn <= '1';
               txSkipEn  <= '0';
            end if;

            -- Free run state counter
            stateCntEn  <= '1';

            -- Detect link inversion, allow single polarity flip due to latency
            -- in the rocket IO data path.
            if rxDetectTrain = '1' and rxDetectInvert = '1' and intPhyRxPolarity = '0' then
               nxtRxPolarity <= '1';
            else
               nxtRxPolarity <= intPhyRxPolarity;
            end if;

            -- Pattern counter counts training sequence reception
            -- Stop counting once we receive enough patterns
            pattCntEn <= rxDetectTrain and (not rxDetectInvert) and (not pattCnt(7));
           
            -- Move to next state when 128 training sequences detected and we have 
            -- been in the state long enough to transmit 256 training sequences (512 clocks)
            if pattCnt(7) = '1' and stateCnt > 511 then
               stateCntRst <= '1';
               pattCntRst  <= '1';
               nxtState    <= ST_VER;

            -- Check for timeout while waiting for training sequences
            elsif stateCnt = x"FFFF" then
               stateCntRst <= '1';
               pattCntRst  <= '1';
               nxtState    <= ST_LOCK;

            -- Keep counting
            else
               stateCntRst <= '0';
               pattCntRst  <= '0';
               nxtState    <= curState;
            end if;

         -- Transmit Version sequence
         when ST_VER =>

            -- Version is transmitting
            nxtPibLinkReady <= '0';
            nxtPibFail      <= '0';
            txIdleEn        <= '0';
            txTrainEn       <= '0';
            txDataEn        <= '0';
            rxDataEn        <= '0';
            nxtDebug        <= ST_VER;

            -- Transmit version normally,
            -- add two skip patterns every 512 clocks
            if stateCnt(8 downto 2) = 0 then 
               txVerEn  <= '0';
               txSkipEn <= '1';
            else
               txVerEn  <= '1';
               txSkipEn <= '0';
            end if;

            -- Free run state counter
            stateCntEn    <= '1';
            nxtRxPolarity <= intPhyRxPolarity;

            -- Pattern counter counts version sequence reception
            -- Stop counting once we receive enough patterns
            pattCntEn <= rxDetectVer and not pattCnt(2);
           
            -- Move to next state when 4 version sequences detected and we have 
            -- been in the state long enough to transmit 8 version sequences (16 clocks)
            if pattCnt(2) = '1' and stateCnt > 15 then

               -- Reset counters for next state
               stateCntRst <= '1';
               pattCntRst  <= '1';

               -- Detect version mismatch
               if rxDetectVerErr = '1' and rxDetectVer = '1' then
                  nxtState <= ST_FAIL;
               else
                  nxtState <= ST_EN;
               end if;

            -- Check for timeout while waiting for version sequences
            elsif stateCnt = x"FFFF" then
               stateCntRst <= '1';
               pattCntRst  <= '1';
               nxtState    <= ST_LOCK;

            -- Keep counting
            else
               stateCntRst <= '0';
               pattCntRst  <= '0';
               nxtState    <= curState;
            end if;

         -- Normal operation
         when ST_EN =>

            -- Normal data is transmitting
            nxtPibLinkReady <= '1';
            nxtPibFail      <= '0';
            txIdleEn        <= '0';
            txTrainEn       <= '0';
            txVerEn         <= '0';
            txSkipEn        <= '0';
            txDataEn        <= '1';
            rxDataEn        <= '1';
            nxtRxPolarity   <= intPhyRxPolarity;
            nxtDebug        <= ST_EN;

            -- Pattern count is not used
            pattCntEn  <= '0';
            pattCntRst <= '1';

            -- State Counter Is In Reset
            stateCntEn  <= '0';
            stateCntRst <= '1';

            -- IDLE is detected
            if rxDetectIdle = '1' then
               nxtState <= ST_LOCK;

            -- We just transmitted a CELL, transmit Skip immediatly following
            elsif (pibTxEOC = '1' and pibTxWidth = '0') or txDlyEOC = '1' then
               nxtState <= ST_SKP;

            -- Stay in enable mode
            else
               nxtState <= curState;
            end if;

         -- Transmit SKP sequence
         when ST_SKP =>

            -- SKP data is transmitting
            nxtPibLinkReady <= '1';
            nxtPibFail      <= '0';
            txIdleEn        <= '0';
            txTrainEn       <= '0';
            txVerEn         <= '0';
            txSkipEn        <= '1';
            txDataEn        <= '0';
            rxDataEn        <= '1';
            nxtRxPolarity   <= intPhyRxPolarity;
            nxtDebug        <= ST_SKP;

            -- Reset pattern count
            pattCntEn  <= '0';
            pattCntRst <= '1';

            -- We are done when we have transmitted 1 SKIP sequence (2 clocks).
            if stateCnt(0) = '1' then
               nxtstate     <= ST_EN;
               stateCntEn   <= '0';
               stateCntRst  <= '1';
            else
               nxtstate     <= curState;
               stateCntEn   <= '1';
               stateCntRst  <= '0';
            end if;

         -- Link init failed
         when ST_FAIL =>

            -- IDLE is transmitting
            nxtPibLinkReady <= '0';
            nxtPibFail      <= '1';
            txIdleEn        <= '1';
            txTrainEn       <= '0';
            txVerEn         <= '0';
            txSkipEn        <= '0';
            txDataEn        <= '0';
            rxDataEn        <= '0';
            nxtRxPolarity   <= '0';
            pattCntEn       <= '0';
            stateCntEn      <= '1';
            stateCntRst     <= '0';
            pattCntRst      <= '1';
            nxtState        <= curState;
            nxtDebug        <= curDebug;

         -- Default state
         when others =>
            nxtPibLinkReady <= '0';
            nxtPibFail      <= '0';
            txIdleEn        <= '0';
            txTrainEn       <= '0';
            txVerEn         <= '0';
            txSkipEn        <= '0';
            txDataEn        <= '0';
            rxDataEn        <= '0';
            nxtRxPolarity   <= '0';
            pattCntEn       <= '0';
            stateCntEn      <= '0';
            stateCntRst     <= '0';
            pattCntRst      <= '0';
            nxtState        <= ST_LOCK;
            nxtDebug        <= ST_LOCK;
      end case;
   end process;


   -- Receive data from external Serdes
   -- Re-Align and detect ordered set
   process ( pgpClk, pgpReset ) begin
      if pgpReset = '1' then
         dly0RxData     <= (others=>'0') after tpd;
         dly0RxDataK    <= (others=>'0') after tpd;
         dly1RxData     <= (others=>'0') after tpd;
         dly1RxDataK    <= (others=>'0') after tpd;
         rxDetectIdle   <= '0'           after tpd;
         rxDetectTrain  <= '0'           after tpd;
         rxDetectInvert <= '0'           after tpd;
         rxDetectVer    <= '0'           after tpd;
         rxDetectVerErr <= '0'           after tpd;
         remoteVersion  <= (others=>'0') after tpd;
      elsif rising_edge(pgpClk) then

         -- First and second stages take data right from IO pads
         dly0RxData  <= phyRxData   after tpd;
         dly0RxDataK <= phyRxDataK  after tpd;
         dly1RxData  <= dly0RxData  after tpd;
         dly1RxDataK <= dly0RxDataK after tpd;

         -- Detect IDLE sequence
         if dly0RxDataK(0) = '1' and dly0RxData(7  downto 0) = K_COM and
            dly0RxDataK(1) = '1' and dly0RxData(15 downto 8) = K_IDL and
            dly1RxDataK(0) = '1' and dly1RxData(7  downto 0) = K_IDL and
            dly1RxDataK(1) = '1' and dly1RxData(15 downto 8) = K_IDL then
            rxDetectIdle <= '1' after tpd;
         else
            rxDetectIdle <= '0' after tpd;
         end if;

         -- Detect training sequence
         if dly0RxDataK(0) = '1' and dly0RxData(7  downto 0) = K_COM and
            dly0RxDataK(1) = '1' and dly0RxData(15 downto 8) = K_LTS and
            dly1RxDataK(0) = '0' and 
            dly1RxDataK(1) = '1' and dly1RxData(15 downto 8) = K_LTS then

            -- Non-Inverted training data
            if dly1RxData(7 downto 0) = D_102 then
               rxDetectTrain  <= '1' after tpd;
               rxDetectInvert <= '0' after tpd;

            -- Inverted training data
            elsif dly1RxData(7 downto 0) = D_215 then
               rxDetectTrain  <= '1' after tpd;
               rxDetectInvert <= '1' after tpd;

            -- Bad data
            else
               rxDetectTrain  <= '0' after tpd;
               rxDetectInvert <= '0' after tpd;
            end if;
         else
            rxDetectTrain  <= '0' after tpd;
            rxDetectInvert <= '0' after tpd;
         end if;

         -- Detect Version Sequence
         if dly0RxDataK(0) = '1' and dly0RxData(7  downto 0) = K_COM and
            dly0RxDataK(1) = '1' and dly0RxData(15 downto 8) = K_VTS and
            dly1RxDataK(0) = '0' and 
            dly1RxDataK(1) = '1' and dly1RxData(15 downto 8) = K_VTS then

            -- Version sequence detected
            rxDetectVer    <= '1'                    after tpd;

            -- Only store remote version when we are transmitting version
            if txVerEn = '0' then
            remoteVersion  <= dly1RxData(7 downto 0) after tpd;
            end if;

            -- Version matches
            if dly1RxData(7 downto 0) = localVersion then
               rxDetectVerErr <= '0' after tpd;

            -- Version mismatch
            else 
               rxDetectVerErr <= '1' after tpd;
            end if;
         else
            rxDetectVer <= '0' after tpd;
         end if;
      end if;
   end process;


   -- Receive data from external Serdes
   -- Re-Align and detect SOC,EOF,EOC,EOFE
   process ( pgpClk, pgpReset ) begin
      if pgpReset = '1' then
         pibRxSOC     <= '0'           after tpd;
         pibRxWidth   <= '0'           after tpd;
         pibRxEOC     <= '0'           after tpd;
         pibRxEOF     <= '0'           after tpd;
         pibRxEOFE    <= '0'           after tpd;
         pibRxData    <= (others=>'0') after tpd;
         sofDetect    <= '0'           after tpd;
      elsif rising_edge(pgpClk) then

         -- Receiver is enabled
         if rxDataEn = '1' then

            -- Detect SOC
            if dly0RxDataK(0) = '1' and dly0RxData(7 downto 0) = K_SOC then
               sofDetect    <= '1' after tpd;
            else
               sofDetect    <= '0' after tpd;
            end if;

            -- Store data to outgoing pads
               pibRxData(15 downto 8) <= dly1RxData(15 downto 8) after tpd;
               pibRxData(7  downto 0) <= dly1RxData(7  downto 0) after tpd;

            -- SOC Flags
            pibRxSOC <= sofDetect after tpd;

            -- Detect EOF flag, low byte
            if (dly0RxDataK(0)  = '1' and dly0RxData(7 downto 0) = K_EOF ) then 
               pibRxEOF   <= '1' after tpd;
               pibRxEOFE  <= '0' after tpd;
               pibRxEOC   <= '1' after tpd;
               pibRxWidth <= '1' after tpd;

            -- Detect EOF flag, high byte
            elsif (dly1RxDataK(1) = '1' and dly1RxData(15 downto 8) = K_EOF ) then
               pibRxEOF   <= '1' after tpd;
               pibRxEOFE  <= '0' after tpd;
               pibRxEOC   <= '1' after tpd;
               pibRxWidth <= '0' after tpd;

            -- Detect EOFE flag, low byte
            elsif (dly0RxDataK(0)  = '1' and dly0RxData(7 downto 0) = K_EOFE ) then
               pibRxEOF   <= '1' after tpd;
               pibRxEOFE  <= '1' after tpd;
               pibRxEOC   <= '1' after tpd;
               pibRxWidth <= '1' after tpd;

            -- Detect EOFE flag, high byte
            elsif (dly1RxDataK(1) = '1' and dly1RxData(15 downto 8) = K_EOFE ) then
               pibRxEOF   <= '1' after tpd;
               pibRxEOFE  <= '1' after tpd;
               pibRxEOC   <= '1' after tpd;
               pibRxWidth <= '0' after tpd;

            -- Detect EOC flag, low byte
            elsif (dly0RxDataK(0)  = '1' and dly0RxData(7 downto 0) = K_EOC ) then
               pibRxEOF   <= '0' after tpd;
               pibRxEOFE  <= '0' after tpd;
               pibRxEOC   <= '1' after tpd;
               pibRxWidth <= '1' after tpd;

            -- Detect EOC flag, high byte
            elsif (dly1RxDataK(1) = '1' and dly1RxData(15 downto 8) = K_EOC ) then
               pibRxEOF   <= '0' after tpd;
               pibRxEOFE  <= '0' after tpd;
               pibRxEOC   <= '1' after tpd;
               pibRxWidth <= '0' after tpd;

            -- Normal data
            else
               pibRxEOF   <= '0' after tpd;
               pibRxEOFE  <= '0' after tpd;
               pibRxEOC   <= '0' after tpd;
               pibRxWidth <= '1' after tpd;
            end if;
         end if;
      end if;
   end process;


   -- Transmit data to external serdes. Data frame cell tx logic will 
   -- contain data with the first byte in bits 7-0. An SOC charactor
   -- must be added to the front of the frame. An EOF charactor will be
   -- added to the end.
   process ( pgpClk, pgpReset ) begin
      if pgpReset = '1' then
         phyTxData  <= (others=>'0') after tpd;
         phyTxDataK <= (others=>'0') after tpd;
         txDlyEOC   <= '0' after tpd;
         txDlyEOF   <= '0' after tpd;
         txDlyEOFE  <= '0' after tpd;

      elsif rising_edge(pgpClk) then

         -- Transmit IDLE
         if txIdleEn = '1' then
            if stateCnt(0) = '0' then
               phyTxDataK             <= "11"  after tpd;
               phyTxData(7 downto 0)  <= K_COM after tpd;
               phyTxData(15 downto 8) <= K_IDL after tpd;
            else
               phyTxDataK             <= "11"  after tpd;
               phyTxData(7 downto 0)  <= K_IDL after tpd;
               phyTxData(15 downto 8) <= K_IDL after tpd;
            end if;

            -- Unused signals
            txDlyEOC   <= '0' after tpd;
            txDlyEOF   <= '0' after tpd;
            txDlyEOFE  <= '0' after tpd;

         -- Transmit training sequence
         elsif txTrainEn = '1' then
            if stateCnt(0) = '0' then
               phyTxDataK             <= "11"  after tpd;
               phyTxData(7 downto 0)  <= K_COM after tpd;
               phyTxData(15 downto 8) <= K_LTS after tpd;
            else
               phyTxDataK             <= "10"  after tpd;
               phyTxData(7 downto 0)  <= D_102 after tpd;
               phyTxData(15 downto 8) <= K_LTS after tpd;
            end if;

            -- Unused signals
            txDlyEOC   <= '0' after tpd;
            txDlyEOF   <= '0' after tpd;
            txDlyEOFE  <= '0' after tpd;

         -- Transmit local version
         elsif txVerEn = '1' then
            if stateCnt(0) = '0' then
               phyTxDataK             <= "11"  after tpd;
               phyTxData(7 downto 0)  <= K_COM after tpd;
               phyTxData(15 downto 8) <= K_VTS after tpd;
            else
               phyTxDataK             <= "10"         after tpd;
               phyTxData(7 downto 0)  <= localVersion after tpd;
               phyTxData(15 downto 8) <= K_VTS        after tpd;
            end if;

            -- Unused signals
            txDlyEOC   <= '0' after tpd;
            txDlyEOF   <= '0' after tpd;
            txDlyEOFE  <= '0' after tpd;

         -- Transmit skip sequence
         elsif txSkipEn = '1' then
            if stateCnt(0) = '0' then
               phyTxDataK             <= "11"  after tpd;
               phyTxData(7 downto 0)  <= K_COM after tpd;
               phyTxData(15 downto 8) <= K_SKP after tpd;
            else
               phyTxDataK             <= "11"  after tpd;
               phyTxData(7 downto 0)  <= K_SKP after tpd;
               phyTxData(15 downto 8) <= K_SKP after tpd;
            end if;

            -- Unused signals
            txDlyEOC   <= '0' after tpd;
            txDlyEOF   <= '0' after tpd;
            txDlyEOFE  <= '0' after tpd;

         -- Transmitter is enabled
         elsif txDataEn = '1' then

            -- SOC Generation
            if pibTxSOC = '1' then
               phyTxData(15 downto 8) <= pibTxData(15 downto 8) after tpd;
               phyTxData(7 downto 0)  <= K_SOC                  after tpd;
               phyTxDataK             <= "01"                   after tpd;
               txDlyEOC               <= '0'                    after tpd;
               txDlyEOF               <= '0'                    after tpd;
               txDlyEOFE              <= '0'                    after tpd;

            -- End of cell requested
            elsif pibTxEOC = '1' then

               -- Width = '0', overwrite upper byte with EOF, we are done
               if pibTxWidth = '0' then
                  phyTxData(7 downto 0)  <= pibTxData(7  downto 0) after tpd;
                  phyTxDataK             <= "10"                   after tpd;
                  txDlyEOC               <= '0'                    after tpd;
                  txDlyEOF               <= '0'                    after tpd;
                  txDlyEOFE              <= '0'                    after tpd;

                  -- Which EOC charactor to send
                  if pibTxEOFE = '1' then
                     phyTxData(15 downto 8) <= K_EOFE after tpd;
                  elsif pibTxEOF  = '1' then
                     phyTxData(15 downto 8) <= K_EOF  after tpd;
                  else
                     phyTxData(15 downto 8) <= K_EOC  after tpd;
                  end if;

               -- Width = '1', need to add an extra byte
               else
                  phyTxData  <= pibTxData after tpd;
                  phyTxDataK <= "00"      after tpd;
                  txDlyEOC   <= '1'       after tpd;
                  txDlyEOF   <= pibTxEOF  after tpd;
                  txDlyEOFE  <= pibTxEOFE after tpd;
               end if;

            -- Delayed EOC
            elsif txDlyEOC = '1' then

               -- Pass unused through
               phyTxData(15 downto 8) <= pibTxData(15 downto 8) after tpd;
               phyTxDataK             <= "01"                   after tpd;
               txDlyEOC               <= '0'                    after tpd;
               txDlyEOF               <= '0'                    after tpd;
               txDlyEOFE              <= '0'                    after tpd;

               -- Which EOC charactor to send
               if txDlyEOFE = '1' then
                  phyTxData(7 downto 0) <= K_EOFE after tpd;
               elsif txDlyEOF  = '1' then
                  phyTxData(7 downto 0) <= K_EOF  after tpd;
               else
                  phyTxData(7 downto 0) <= K_EOC  after tpd;
               end if;

            -- Normal data
            else
               phyTxData  <= pibTxData after tpd;
               phyTxDataK <= "00"      after tpd;
               txDlyEOC   <= '0'       after tpd;
               txDlyEOF   <= '0'       after tpd;
               txDlyEOFE  <= '0'       after tpd;
            end if;
         end if;
      end if;
   end process;

end PgpPhy;

