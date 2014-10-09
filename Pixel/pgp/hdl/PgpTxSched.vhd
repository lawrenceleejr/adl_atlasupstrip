-------------------------------------------------------------------------------
-- Title         : Pretty Good Protocol, Transmit Schedular
-- Project       : General Purpose Core
-------------------------------------------------------------------------------
-- File          : PgpTxSched.vhd
-- Author        : Ryan Herbst, rherbst@slac.stanford.edu
-- Created       : 10/24/2006
-------------------------------------------------------------------------------
-- Description:
-- Transmit schedular module for the Pretty Good Protocol core. 
-------------------------------------------------------------------------------
-- Copyright (c) 2006 by Ryan Herbst. All rights reserved.
-------------------------------------------------------------------------------
-- Modification history:
-- 10/24/2006: created.
-- 04/18/2007: Added support to track the number of cells in a frame to detect
--             dropped cells.
-- 06/19/2007: Added two clocks of delay after a cell. This ensures the
--             received cell is always fully processed even if a skip is 
--             dropped.
-- 07/19/2007: Removed support to track the number of cells in a frame to detect
--             dropped cells.
-- 09/21/2007: Removed payload imput
-------------------------------------------------------------------------------

LIBRARY ieee;
USE work.ALL;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity PgpTxSched is port ( 

      -- System clock, reset & control
      pgpClk            : in  std_logic;                     -- Master clock
      pgpReset          : in  std_logic;                     -- Synchronous reset input

      -- PIB Interface
      pibLinkReady      : in  std_logic;                     -- PIB Link Ready

      -- ACK/NACK Receiver Logic
      cidReady          : in  std_logic;                     -- CID Engine is ready
      cidTimerStart     : out std_logic;                     -- CID timer start
      cidSave           : out std_logic;                     -- CID value store signal

      -- ACK/NACK Transmit Logic
      cellTxAckReq      : in  std_logic;                     -- Cell ACK/NACK transmit request

      -- Cell Transmit Logic
      cellTxSOF         : in  std_logic;                     -- Cell contained SOF
      cellTxEOF         : in  std_logic;                     -- Cell contained EOF
      cellTxIdle        : out std_logic;                     -- Force IDLE transmit
      cellTxReq         : out std_logic;                     -- Cell transmit request
      cellTxInp         : in  std_logic;                     -- Cell transmit in progress
      cellTxDataVc      : out std_logic_vector(1  downto 0); -- Cell transmit virtual channel

      -- User logic interface
      vc0FrameTxValid   : in  std_logic;                     -- User frame data is valid
      vc1FrameTxValid   : in  std_logic;                     -- User frame data is valid
      vc2FrameTxValid   : in  std_logic;                     -- User frame data is valid
      vc3FrameTxValid   : in  std_logic                      -- User frame data is valid
   );

end PgpTxSched;


-- Define architecture
architecture PgpTxSched of PgpTxSched is

   -- Local Signals
   signal arbTxVc      : std_logic_vector(1 downto 0);
   signal nxtTxVc      : std_logic_vector(1 downto 0);
   signal arbTxIdle    : std_logic;
   signal nxtTxValid   : std_logic;
   signal nxtInFrame   : std_logic;
   signal arbEn        : std_logic;
   signal arbEnDly     : std_logic;
   signal vcInFrame    : std_logic_vector(3 downto 0);

   -- Schedular state
   constant ST_ARB   : std_logic_vector(1 downto 0) := "01";
   constant ST_REQ   : std_logic_vector(1 downto 0) := "10";
   constant ST_INP   : std_logic_vector(1 downto 0) := "11";
   constant ST_DLY   : std_logic_vector(1 downto 0) := "00";
   signal   curState : std_logic_vector(1 downto 0);
   signal   nxtState : std_logic_vector(1 downto 0);

   -- Register delay for simulation
   constant tpd:time := 0.5 ns;

begin

   -- Outgoing signals
   cellTxReq     <= arbEnDly;
   cellTxDataVc  <= arbTxVc;
   cellTxIdle    <= arbTxIdle;
   cidSave       <= arbEnDly;

   -- Drive timer start if we think frame is being transmitted and
   -- EOF or SOF is transmitted.
   cidTimerStart <= vcInFrame(conv_integer(arbTxVc)) and (cellTxSOF or cellTxEOF);


   -- State transition logic
   process ( pgpClk, pgpReset ) begin
      if pgpReset = '1' then
         curState  <= ST_ARB  after tpd;
         arbTxVc   <= "00"    after tpd;
         arbTxIdle <= '0'     after tpd;
         arbEnDly  <= '0'     after tpd;
      elsif rising_edge(pgpClk) then

         -- Force state to select state when link goes down
         if pibLinkReady = '0' then
            curState <= ST_ARB   after tpd;
         else
            curState <= nxtState after tpd;
         end if;

         -- Delayed version of arb enable
         arbEnDly <= arbEn after tpd;

         -- Only select new source if arbitration is enabled
         if arbEn = '1' then

            -- No one is requesting or ack/nack tx is required and
            -- selected source is not already in frame
            -- Transmit idle frame, keep same last VC for next arb
            if nxtTxValid = '0' or ( cellTxAckReq = '1' and nxtInFrame = '0' ) then
               arbTxIdle <= '1' after tpd;

            -- Choose next vc source
            else 
               arbTxVc   <= nxtTxVc after tpd;
               arbTxIdle <= '0'     after tpd;
            end if;
         end if;
      end if;
   end process;


   -- Scheduler state machine
   process ( curState, cidReady, cellTxInp, pibLinkReady ) begin
      case curState is

         -- IDLE, wait for ack receiver to be ready 
         when ST_ARB =>

            -- Continue when ack transmitter is ready
            if cidReady = '1' and pibLinkReady = '1' then
               nxtState <= ST_REQ;
               arbEn    <= '1';
            else
               nxtState <= curState;
               arbEn    <= '0';
            end if;

         -- REQ, assert request
         when ST_REQ =>

            -- No arb, transmit already requested
            arbEn <= '0';

            -- Move to in progress state
            nxtState <= ST_INP;

         -- Cell transmission in progress, wait for it to be done
         when ST_INP =>

            -- No arb, no tx
            arbEn    <= '0';

            -- Wait for in progress to be done
            if cellTxInp = '0' then
               nxtState <= ST_DLY;
                  arbEn    <= '0';
            else
               nxtState <= curState;
               arbEn    <= '0';
            end if;

         -- Delay one clock
         when ST_DLY =>

            -- No arb, transmit already requested
            arbEn <= '0';

            -- Move to arb state
            nxtState <= ST_ARB;

         -- Just in case
         when others =>
            arbEn    <= '0';
            nxtState <= ST_ARB;
      end case;
   end process;


   -- Select in frame status of arb winner
   nxtInFrame <= vcInFrame(conv_integer(nxtTxVc));

   -- Arbitrate for the next VC value based upon current VC value
   -- and status of valid inputs
   process ( arbTxVc, vc0FrameTxValid, vc1FrameTxValid, 
             vc2FrameTxValid, vc3FrameTxValid ) begin
      case arbTxVc is
         when "00" =>
            if    vc1FrameTxValid = '1' then nxtTxVc <= "01"; nxtTxValid <= '1';
            elsif vc2FrameTxValid = '1' then nxtTxVc <= "10"; nxtTxValid <= '1';
            elsif vc3FrameTxValid = '1' then nxtTxVc <= "11"; nxtTxValid <= '1';
            elsif vc0FrameTxValid = '1' then nxtTxVc <= "00"; nxtTxValid <= '1';
            else  nxtTxVc <= arbTxVc; nxtTxValid <= '0'; end if;
         when "01" =>
            if    vc2FrameTxValid = '1' then nxtTxVc <= "10"; nxtTxValid <= '1';
            elsif vc3FrameTxValid = '1' then nxtTxVc <= "11"; nxtTxValid <= '1';
            elsif vc0FrameTxValid = '1' then nxtTxVc <= "00"; nxtTxValid <= '1';
            elsif vc1FrameTxValid = '1' then nxtTxVc <= "01"; nxtTxValid <= '1';
            else  nxtTxVc <= arbTxVc; nxtTxValid <= '0'; end if;
         when "10" =>
            if    vc3FrameTxValid = '1' then nxtTxVc <= "11"; nxtTxValid <= '1';
            elsif vc0FrameTxValid = '1' then nxtTxVc <= "00"; nxtTxValid <= '1';
            elsif vc1FrameTxValid = '1' then nxtTxVc <= "01"; nxtTxValid <= '1';
            elsif vc2FrameTxValid = '1' then nxtTxVc <= "10"; nxtTxValid <= '1';
            else  nxtTxVc <= arbTxVc; nxtTxValid <= '0'; end if;
         when "11" =>
            if    vc0FrameTxValid = '1' then nxtTxVc <= "00"; nxtTxValid <= '1';
            elsif vc1FrameTxValid = '1' then nxtTxVc <= "01"; nxtTxValid <= '1';
            elsif vc2FrameTxValid = '1' then nxtTxVc <= "10"; nxtTxValid <= '1';
            elsif vc3FrameTxValid = '1' then nxtTxVc <= "11"; nxtTxValid <= '1';
            else  nxtTxVc <= arbTxVc; nxtTxValid <= '0'; end if;
         when others =>
            nxtTxVc <= "00"; nxtTxValid <= '0';
      end case;
   end process;


   -- Lock in the status of the last cell transmitted
   -- Also track the current frame status of each VC
   process ( pgpClk, pgpReset ) begin
      if pgpReset = '1' then
         vcInFrame    <= "0000"        after tpd;
      elsif rising_edge(pgpClk) then

         -- Link is down, reset status
         if pibLinkReady = '0' then
            vcInFrame <= "0000" after tpd;
         else

            -- Cell transmission is in progress
            if cellTxInp = '1' then

               -- Update state of VC, track if VC is currently in frame or not
               -- SOF transmitted
               if cellTxSOF = '1' then
                  vcInFrame(conv_integer(arbTxVc)) <= '1' after tpd;
                  
               -- EOF transmitted
               elsif cellTxEOF = '1' then
                  vcInFrame(conv_integer(arbTxVc)) <= '0' after tpd;
               end if;
            end if;
         end if;
      end if;
   end process;

end PgpTxSched;

