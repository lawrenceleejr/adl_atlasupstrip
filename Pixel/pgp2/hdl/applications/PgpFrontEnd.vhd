-------------------------------------------------------------------------------
-- Title         : Pretty Good Protocol Applications, Front End Wrapper
-- Project       : General Purpose Core
-------------------------------------------------------------------------------
-- File          : PgpFrontEnd.vhd
-- Author        : Ryan Herbst, rherbst@slac.stanford.edu
-- Created       : 09/24/2007
-------------------------------------------------------------------------------
-- Description:
-- Wrapper for front end logic connection to the RCE. 
-------------------------------------------------------------------------------
-- Copyright (c) 2007 by Ryan Herbst. All rights reserved.
-------------------------------------------------------------------------------
-- Modification history:
-- 09/24/2007: created.
-- 03/06/2008: Removed width signal.
-------------------------------------------------------------------------------

LIBRARY ieee;
use work.all;
use work.Version.all;
use work.Pgp2MgtPackage.all;
use work.Pgp2AppPackage.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity PgpFrontEnd is 
   generic (
      MgtMode    : string  := "A";       -- Default Location
      RefClkSel  : string  := "REFCLK1"  -- Reference Clock To Use "REFCLK1" or "REFCLK2"
   );
   port ( 
      
      -- Reference Clock, PGP Clock & Reset Signals
      -- Use one ref clock, tie other to 0, see RefClkSel above
      pgpRefClk1       : in  std_logic;
      pgpRefClk2       : in  std_logic;
      mgtRxRecClk      : out std_logic;
      pgpClk           : in  std_logic;
      pgpReset         : in  std_logic;

      -- Display Digits
      pgpDispA         : out std_logic_vector(7 downto 0);
      pgpDispB         : out std_logic_vector(7 downto 0);

      -- Reset output
      resetOut         : out std_logic;

      -- Local clock and reset
      locClk           : in  std_logic;
      locReset         : in  std_logic;

      -- Local command signal
      cmdEn            : out std_logic;
      cmdOpCode        : out std_logic_vector(7  downto 0);
      cmdCtxOut        : out std_logic_vector(23 downto 0);

      -- Local register control signals
      regReq           : out std_logic;
      regOp            : out std_logic;
      regInp           : out std_logic;
      regAck           : in  std_logic;
      regFail          : in  std_logic;
      regAddr          : out std_logic_vector(23 downto 0);
      regDataOut       : out std_logic_vector(31 downto 0);
      regDataIn        : in  std_logic_vector(31 downto 0);

      -- Local data transfer signals
      frameTxEnable    : in  std_logic;
      frameTxSOF       : in  std_logic;
      frameTxEOF       : in  std_logic;
      frameTxEOFE      : in  std_logic;
      frameTxData      : in  std_logic_vector(15 downto 0);
      frameTxAFull     : out std_logic;
      frameRxValid     : out std_logic;
      frameRxReady     : in  std_logic;
      frameRxSOF       : out std_logic;
      frameRxEOF       : out std_logic;
      frameRxEOFE      : out std_logic;
      frameRxData      : out std_logic_vector(15 downto 0);
      valid            : out std_logic;
      eof              : out std_logic;
      sof              : out std_logic;

      -- MGT Serial Pins
      mgtRxN           : in  std_logic;
      mgtRxP           : in  std_logic;
      mgtTxN           : out std_logic;
      mgtTxP           : out std_logic;

      -- MGT Signals For Simulation, 
      -- Drive mgtCombusIn to 0's, Leave mgtCombusOut open for real use
      mgtCombusIn      : in  std_logic_vector(15 downto 0);
      mgtCombusOut     : out std_logic_vector(15 downto 0)
   );
end PgpFrontEnd;


-- Define architecture
architecture PgpFrontEnd of PgpFrontEnd is

   -- Downstream buffer
   component PgpDsBuff
      port (
         pgpClk           : in  std_logic;
         pgpReset         : in  std_logic;
         locClk           : in  std_logic;
         locReset         : in  std_logic;
         vcFrameRxValid   : in  std_logic;
         vcFrameRxSOF     : in  std_logic;
         vcFrameRxWidth   : in  std_logic;
         vcFrameRxEOF     : in  std_logic;
         vcFrameRxEOFE    : in  std_logic;
         vcFrameRxData    : in  std_logic_vector(15 downto 0);
         vcLocBuffAFull   : out std_logic;
         vcLocBuffFull    : out std_logic;
         frameRxValid     : out std_logic;
         frameRxReady     : in  std_logic;
         frameRxSOF       : out std_logic;
         frameRxEOF       : out std_logic;
         frameRxEOFE      : out std_logic;
         frameRxData      : out std_logic_vector(15 downto 0)
      );
   end component;

   -- Local Signals
   signal pibReLink         : std_logic;
   signal vc0FrameTxValid   : std_logic;
   signal vc0FrameTxReady   : std_logic;
   signal vc0FrameTxSOF     : std_logic;
   signal vc0FrameTxEOF     : std_logic;
   signal vc0FrameTxEOFE    : std_logic;
   signal vc0FrameTxData    : std_logic_vector(15 downto 0);
   signal vc0RemBuffAFull   : std_logic;
   signal vc0RemBuffFull    : std_logic;
   signal vc1FrameTxValid   : std_logic;
   signal vc1FrameTxReady   : std_logic;
   signal vc1FrameTxSOF     : std_logic;
   signal vc1FrameTxEOF     : std_logic;
   signal vc1FrameTxEOFE    : std_logic;
   signal vc1FrameTxData    : std_logic_vector(15 downto 0);
   signal vc1RemBuffAFull   : std_logic;
   signal vc1RemBuffFull    : std_logic;
   signal vc2FrameTxValid   : std_logic;
   signal vc2FrameTxReady   : std_logic;
   signal vc2FrameTxSOF     : std_logic;
   signal vc2FrameTxEOF     : std_logic;
   signal vc2FrameTxEOFE    : std_logic;
   signal vc2FrameTxData    : std_logic_vector(15 downto 0);
   signal vc2RemBuffAFull   : std_logic;
   signal vc2RemBuffFull    : std_logic;
   signal vc3FrameTxValid   : std_logic;
   signal vc3FrameTxReady   : std_logic;
   signal vc3FrameTxSOF     : std_logic;
   signal vc3FrameTxEOF     : std_logic;
   signal vc3FrameTxEOFE    : std_logic;
   signal vc3FrameTxData    : std_logic_vector(15 downto 0);
   signal vc3RemBuffAFull   : std_logic;
   signal vc3RemBuffFull    : std_logic;
   signal vc0FrameRxValid   : std_logic;
   signal vcFrameRxSOF     : std_logic;
   signal vcFrameRxEOF     : std_logic;
   signal vcFrameRxEOFE    : std_logic;
   signal vcFrameRxData    : std_logic_vector(15 downto 0);
   signal vc0LocBuffAFull   : std_logic;
   signal vc0LocBuffFull    : std_logic;
   signal vc1FrameRxValid   : std_logic;
   signal vc1LocBuffAFull   : std_logic;
   signal vc1LocBuffFull    : std_logic;
   signal vc2FrameRxValid   : std_logic;
   signal vc2LocBuffAFull   : std_logic;
   signal vc2LocBuffFull    : std_logic;
   signal vc3FrameRxValid   : std_logic;
   signal vc3LocBuffAFull   : std_logic;
   signal vc3LocBuffFull    : std_logic;
   signal pibLock           : std_logic_vector(1  downto 0);
   signal countLinkDown     : std_logic;
   signal countLinkError    : std_logic;
   signal countCellError    : std_logic;
   signal cntLinkError      : std_logic_vector(3  downto 0);
   signal cntCellError      : std_logic_vector(3  downto 0);
   signal cntLinkDown       : std_logic_vector(3  downto 0);
   signal cntOverFlow       : std_logic_vector(3  downto 0);
   signal pllLock           : std_logic;
   signal pllLockDly        : std_logic;
   signal cntPllLock        : std_logic_vector(3  downto 0);
   signal intRegReq         : std_logic;
   signal intRegOp          : std_logic;
   signal intRegAck         : std_logic;
   signal intRegFail        : std_logic;
   signal intRegAddr        : std_logic_vector(23 downto 0);
   signal intRegDataOut     : std_logic_vector(31 downto 0);
   signal intRegDataIn      : std_logic_vector(31 downto 0);
   signal intCmdEn          : std_logic;
   signal intCmdOpCode      : std_logic_vector(7  downto 0);
   signal intCmdCtxOut      : std_logic_vector(23 downto 0);
   signal scratchPad        : std_logic_vector(31 downto 0);
   signal countReset        : std_logic;
   signal dataOverFlow      : std_logic;
   signal intCmdAFull       : std_logic;
   signal intCmdFull        : std_logic;
   signal extCmdAFull       : std_logic;
   signal extCmdFull        : std_logic;
   signal pibError          : std_logic;
   signal txCount           : std_logic_vector(31 downto 0);
   signal pibLinkReady      : std_logic;
   signal iframeTxAFull     : std_logic;

   -- Register delay for simulation
   constant tpd:time := 0.5 ns;

begin

   -- Display values
   pgpDispB <= x"0" & txCount(3 downto 0);
   pgpDispA <= x"10" when pllLock      = '0' else  -- Display 'P'
               x"11" when pibLinkReady = '0' else  -- Display 'N'
               x"0E" when pibError     = '1' else  -- Display 'E'
               x"12";                              -- Display 'L'
   
   -- Detect error status
   pibError <= '1' when (cntLinkError & cntCellError) /= 0 else '0';

   -- Transaction Counter
   process ( pgpClk, pgpReset ) begin
      if pgpReset = '1' then
         txCount <= (others=>'0') after tpd;
      elsif rising_edge(pgpClk) then
         if pibLinkReady = '0' then
            txCount <= (others=>'0') after tpd;
         else
            if (vc0FrameTxReady = '1' and vc0FrameTxEOF = '1') or
               (vc1FrameTxReady = '1' and vc1FrameTxEOF = '1') or
               (vc2FrameTxReady = '1' and vc2FrameTxEOF = '1') or
               (vc3FrameTxReady = '1' and vc3FrameTxEOF = '1') then
               txCount <= txCount + 1 after tpd;
            end if;
         end if;
      end if;
   end process;


   -- Register read and write
   process ( pgpClk, pgpReset ) begin
      if pgpReset = '1' then
         intRegDataIn <= (others=>'0') after tpd;
         intRegAck    <= '0'           after tpd;
         intRegFail   <= '0'           after tpd;
         scratchPad   <= (others=>'0') after tpd;
      elsif rising_edge(pgpClk) then

         -- Register request is pending
         if intRegReq = '1' then

            -- Drive ack
            intRegAck <= '1' after tpd;

            -- Read
            if intRegOp = '0' then

               -- Which register
               case intRegAddr is

                  when x"000000" =>
                     intRegDataIn <= FpgaVersion after tpd;
                     intRegFail   <= '0'         after tpd;

                  when x"000001" =>
                     intRegDataIn <= scratchPad after tpd;
                     intRegFail   <= '0'        after tpd;

                  when x"000002" =>
                     intRegDataIn(31)           <= '0'             after tpd;
                     intRegDataIn(30)           <= '0'             after tpd;
                     intRegDataIn(29)           <= '0'             after tpd;
                     intRegDataIn(28)           <= '0'             after tpd;
                     intRegDataIn(27 downto 24) <= cntOverFlow     after tpd;
                     intRegDataIn(23 downto 20) <= cntPllLock      after tpd;
                     intRegDataIn(19 downto 16) <= cntLinkDown     after tpd;
                     intRegDataIn(15 downto 12) <= cntLinkError    after tpd;
                     intRegDataIn(11 downto  8) <= (others=>'0')   after tpd;
                     intRegDataIn( 7 downto  4) <= cntCellError    after tpd;
                     intRegDataIn( 3 downto  0) <= "0000"          after tpd;
                     intRegFail                 <= '0'             after tpd;

                  when x"000003" =>
                     intRegDataIn               <= txCount         after tpd;
                     intRegFail                 <= '0'             after tpd;

                  when others =>
                     intRegFail   <= '1'           after tpd;
                     intRegDataIn <= (others=>'0') after tpd;
               end case;
            
            -- Write
            else

               -- Scratchpad write
               if intRegAddr = x"000001" then
                  intRegFail <= '0'           after tpd;
                  scratchPad <= intRegDataOut after tpd;
               else
                  intRegFail <= '1'           after tpd;
               end if;
            end if;
         
         -- No Request
         else
            intRegAck    <= '0'           after tpd;
            intRegFail   <= '0'           after tpd;
            intRegDataIn <= (others=>'0') after tpd;
         end if;
      end if;
   end process;


   -- Internal command receiver
   process ( pgpClk, pgpReset ) begin
      if pgpReset = '1' then
         countReset <= '0' after tpd;
         pibReLink  <= '0' after tpd;
         resetOut   <= '0' after tpd;
      elsif rising_edge(pgpClk) then

         -- Internal command received
         if intCmdEn = '1' then

            -- Reset
            if intCmdOpCode = "00000000" then
               resetOut   <= '1' after tpd;
               countReset <= '0' after tpd;
               pibReLink  <= '0' after tpd;

            -- Count Reset
            elsif intCmdOpCode = "00000001" then
               countReset <= '1' after tpd;
               pibReLink  <= '0' after tpd;

            -- PGP Relink
            elsif intCmdOpCode = "00000010" then
               countReset <= '0' after tpd;
               pibReLink  <= '1' after tpd;

            else
               countReset <= '0' after tpd;
               pibReLink  <= '0' after tpd;
            end if;
         else
            countReset <= '0' after tpd;
            pibReLink  <= '0' after tpd;
         end if;
      end if;
   end process;


   -- Error Counters
   process ( pgpClk, pgpReset ) begin
      if pgpReset = '1' then
         cntLinkError     <= (others=>'0') after tpd;
         cntCellError     <= (others=>'0') after tpd;
         cntLinkDown      <= (others=>'0') after tpd;
         cntPllLock       <= (others=>'0') after tpd;
         cntOverFlow      <= (others=>'0') after tpd;
         pllLock          <= '0'           after tpd;
         pllLockDly       <= '0'           after tpd;
      elsif rising_edge(pgpClk) then

         -- Link Error Counter, 8-bits
         if countReset = '1' or pibLinkReady = '0' then
            cntLinkError <= (others=>'0') after tpd;
         elsif countLinkError = '1' and cntLinkError /= x"F" then
            cntLinkError <= cntLinkError + 1 after tpd;
         end if;
          
         -- Cell Error Counter, 8-bits
         if countReset = '1'  or pibLinkReady = '0' then
            cntCellError <= (others=>'0') after tpd;
         elsif countCellError = '1' and cntCellError /= x"F" then
            cntCellError <= cntCellError + 1 after tpd;
         end if;

         -- Link Down Counter, 8-bits
         if countReset = '1' then
            cntLinkDown <= (others=>'0') after tpd;
         elsif countLinkDown = '1' and cntLinkDown /= x"F" then
            cntLinkDown <= cntLinkDown + 1 after tpd;
         end if;

         -- PLL Unlock Counter
         if countReset = '1'  or pibLinkReady = '0' then
            cntPllLock <= (others=>'0') after tpd;
         elsif pllLock = '0' and pllLockDly = '1' and cntPllLock /= x"F" then
            cntPllLock <= cntPllLock + 1 after tpd;
         end if;

         -- PLL Lock Edge Detection
         pllLock    <= pibLock(1) and pibLock(0) after tpd;
         pllLockDly <= pllLock after tpd;

         -- Data overflow counter
         if countReset = '1' then
            cntOverFlow <= (others=>'0') after tpd;
         elsif dataOverFlow = '1'and cntOverFlow /= x"F" then
            cntOverFlow <= cntOverFlow + 1 after tpd;
         end if;

      end if;
   end process;

   -- PGP Wrap
   U_Pgp2Mgt16: Pgp2Mgt16
      generic map ( 
         EnShortCells => 1, 
         VcInterleave => 0,
         MgtMode      => MgtMode,
         RefClkSel    => RefClkSel
      )
      port map (
         pgpClk            => pgpClk,
         pgpReset          => pgpReset,
         pgpFlush          => '0',
         pllTxRst          => '0',
         pllRxRst          => pibReLink,
         pllRxReady        => pibLock(0),
         pllTxReady        => pibLock(1),
         pgpRemData        => open,
         pgpLocData        => (others=>'0'),
         pgpTxOpCodeEn     => '0',
         pgpTxOpCode       => (others=>'0'),
         pgpRxOpCodeEn     => open,
         pgpRxOpCode       => open,
         pgpLocLinkReady   => pibLinkReady,
         pgpRemLinkReady   => open,
         pgpRxCellError    => countCellError,
         pgpRxLinkDown     => countLinkDown,
         pgpRxLinkError    => countLinkError,
         vc0FrameTxValid   => vc0FrameTxValid,
         vc0FrameTxReady   => vc0FrameTxReady,
         vc0FrameTxSOF     => vc0FrameTxSOF,
         vc0FrameTxEOF     => vc0FrameTxEOF,
         vc0FrameTxEOFE    => vc0FrameTxEOFE,
         vc0FrameTxData    => vc0FrameTxData,
         vc0LocBuffAFull   => vc0LocBuffAFull,
         vc0LocBuffFull    => vc0LocBuffFull,
         vc1FrameTxValid   => vc1FrameTxValid,
         vc1FrameTxReady   => vc1FrameTxReady,
         vc1FrameTxSOF     => vc1FrameTxSOF,
         vc1FrameTxEOF     => vc1FrameTxEOF,
         vc1FrameTxEOFE    => vc1FrameTxEOFE,
         vc1FrameTxData    => vc1FrameTxData,
         vc1LocBuffAFull   => vc1LocBuffAFull,
         vc1LocBuffFull    => vc1LocBuffFull,
         vc2FrameTxValid   => vc2FrameTxValid,
         vc2FrameTxReady   => vc2FrameTxReady,
         vc2FrameTxSOF     => vc2FrameTxSOF,
         vc2FrameTxEOF     => vc2FrameTxEOF,
         vc2FrameTxEOFE    => vc2FrameTxEOFE,
         vc2FrameTxData    => vc2FrameTxData,
         vc2LocBuffAFull   => vc2LocBuffAFull,
         vc2LocBuffFull    => vc2LocBuffFull,
         vc3FrameTxValid   => vc3FrameTxValid,
         vc3FrameTxReady   => vc3FrameTxReady,
         vc3FrameTxSOF     => vc3FrameTxSOF,
         vc3FrameTxEOF     => vc3FrameTxEOF,
         vc3FrameTxEOFE    => vc3FrameTxEOFE,
         vc3FrameTxData    => vc3FrameTxData,
         vc3LocBuffAFull   => vc3LocBuffAFull,
         vc3LocBuffFull    => vc3LocBuffFull,
         vcFrameRxSOF      => vcFrameRxSOF,
         vcFrameRxEOF      => vcFrameRxEOF,
         vcFrameRxEOFE     => vcFrameRxEOFE,
         vcFrameRxData     => vcFrameRxData,
         vc0FrameRxValid   => vc0FrameRxValid,
         vc0RemBuffAFull   => vc0RemBuffAFull,
         vc0RemBuffFull    => vc0RemBuffFull,
         vc1FrameRxValid   => vc1FrameRxValid,
         vc1RemBuffAFull   => vc1RemBuffAFull,
         vc1RemBuffFull    => vc1RemBuffFull,
         vc2FrameRxValid   => vc2FrameRxValid,
         vc2RemBuffAFull   => vc2RemBuffAFull,
         vc2RemBuffFull    => vc2RemBuffFull,
         vc3FrameRxValid   => vc3FrameRxValid,
         vc3RemBuffAFull   => vc3RemBuffAFull,
         vc3RemBuffFull    => vc3RemBuffFull,
			mgtLoopback       => '0',
         mgtRefClk1        => pgpRefClk1,
			mgtRefClk2  	   => pgpRefClk2,
         mgtRxRecClk       => mgtRxRecClk,
         mgtRxN            => mgtRxN,
         mgtRxP            => mgtRxP,
         mgtTxN            => mgtTxN,
         mgtTxP            => mgtTxP,
         mgtCombusIn       => mgtCombusIn,
         mgtCombusOut      => mgtCombusOut,
         debug             => open
      );

   -- Lane 0, VC0, External command processor
   U_ExtCmd: Pgp2CmdSlave 
      generic map ( 
         DestId    => 0,
         DestMask  => 1,
         FifoType  => "V4"
      ) port map ( 
         pgpRxClk       => pgpClk,          pgpRxReset     => pgpReset,
         locClk         => locClk,          locReset       => locReset,
         vcFrameRxValid => vc0FrameRxValid, vcFrameRxSOF   => vcFrameRxSOF,
         vcFrameRxEOF   => vcFrameRxEOF,    vcFrameRxEOFE  => vcFrameRxEOFE,
         vcFrameRxData  => vcFrameRxData,   vcLocBuffAFull => extCmdAFull,
         vcLocBuffFull  => extCmdFull,      cmdEn          => cmdEn,
         cmdOpCode      => cmdOpCode,       cmdCtxOut      => cmdCtxOut
      );

   -- Lane 0, VC0, Internal command processor
   U_IntCmd: Pgp2CmdSlave 
      generic map ( 
         DestId    => 1,
         DestMask  => 1,
         FifoType  => "V4"
      ) port map ( 
         pgpRxClk       => pgpClk,          pgpRxReset     => pgpReset,
         locClk         => pgpClk,          locReset       => pgpReset,
         vcFrameRxValid => vc0FrameRxValid, vcFrameRxSOF   => vcFrameRxSOF,
         vcFrameRxEOF   => vcFrameRxEOF,    vcFrameRxEOFE  => vcFrameRxEOFE,
         vcFrameRxData  => vcFrameRxData,   vcLocBuffAFull => intCmdAFull,
         vcLocBuffFull  => intCmdFull,      cmdEn          => intCmdEn,
         cmdOpCode      => intCmdOpCode,    cmdCtxOut      => intCmdCtxOut
      );

   -- Generate flow control
   vc0LocBuffAFull <= extCmdAFull or intCmdAFull;
   vc0LocBuffFull  <= extCmdFull  or intCmdFull;

   -- Return data, Lane 0, VC0
   U_DataBuff0: Pgp2UsBuff generic map ( FifoType => "V4" ) port map ( 
      pgpClk           => pgpClk,
      pgpReset         => pgpReset,
      locClk           => locClk,
      locReset         => locReset,
      frameTxValid     => frameTxEnable,
      frameTxSOF       => frameTxSOF,
      frameTxEOF       => frameTxEOF,
      frameTxEOFE      => frameTxEOFE,
      frameTxData      => frameTxData,
      frameTxAFull     => iframeTxAFull,
      vcFrameTxValid   => vc0FrameTxValid,
      vcFrameTxReady   => vc0FrameTxReady,
      vcFrameTxSOF     => vc0FrameTxSOF,
      vcFrameTxEOF     => vc0FrameTxEOF,
      vcFrameTxEOFE    => vc0FrameTxEOFE,
      vcFrameTxData    => vc0FrameTxData,
      vcRemBuffAFull   => vc0RemBuffAFull,
      vcRemBuffFull    => vc0RemBuffFull
   );
   dataOverFlow <= frameTxEnable and iframeTxAFull;
   frameTxAFull <= iframeTxAFull;

   valid  <= vc0FrameTxValid;
   eof    <= vc0FrameTxEOF;
   sof    <= vc0FrameTxSOF;

   -- Lane 0, VC1, External register access control
   U_ExtReg: Pgp2RegSlave generic map ( FifoType => "V4" ) port map (
      pgpRxClk        => pgpClk,           pgpRxReset      => pgpReset,
      pgpTxClk        => pgpClk,           pgpTxReset      => pgpReset,
      locClk          => locClk,           locReset        => locReset,
      vcFrameRxValid  => vc1FrameRxValid,  vcFrameRxSOF    => vcFrameRxSOF,
      vcFrameRxEOF    => vcFrameRxEOF,     vcFrameRxEOFE   => vcFrameRxEOFE,
      vcFrameRxData   => vcFrameRxData,    vcLocBuffAFull  => vc1LocBuffAFull,
      vcLocBuffFull   => vc1LocBuffFull,   vcFrameTxValid  => vc1FrameTxValid,
      vcFrameTxReady  => vc1FrameTxReady,  vcFrameTxSOF    => vc1FrameTxSOF,
      vcFrameTxEOF    => vc1FrameTxEOF,    vcFrameTxEOFE   => vc1FrameTxEOFE,
      vcFrameTxData   => vc1FrameTxData,   vcRemBuffAFull  => vc1RemBuffAFull,
      vcRemBuffFull   => vc1RemBuffFull,   regInp          => regInp,
      regReq          => regReq,           regOp           => regOp,
      regAck          => regAck,           regFail         => regFail,
      regAddr         => regAddr,          regDataOut      => regDataOut,
      regDataIn       => regDataIn
   );

   -- Lane 0, VC2, Internal register access control
   U_IntReg: Pgp2RegSlave generic map ( FifoType => "V4" ) port map (
      pgpRxClk        => pgpClk,           pgpRxReset      => pgpReset,
      pgpTxClk        => pgpClk,           pgpTxReset      => pgpReset,
      locClk          => pgpClk,           locReset        => pgpReset,
      vcFrameRxValid  => vc2FrameRxValid,  vcFrameRxSOF    => vcFrameRxSOF,
      vcFrameRxEOF    => vcFrameRxEOF,     vcFrameRxEOFE   => vcFrameRxEOFE,
      vcFrameRxData   => vcFrameRxData,    vcLocBuffAFull  => vc2LocBuffAFull,
      vcLocBuffFull   => vc2LocBuffFull,   vcFrameTxValid  => vc2FrameTxValid,
      vcFrameTxReady  => vc2FrameTxReady,  vcFrameTxSOF    => vc2FrameTxSOF,
      vcFrameTxEOF    => vc2FrameTxEOF,    vcFrameTxEOFE   => vc2FrameTxEOFE,
      vcFrameTxData   => vc2FrameTxData,   vcRemBuffAFull  => vc2RemBuffAFull,
      vcRemBuffFull   => vc2RemBuffFull,   regInp          => open,
      regReq          => intRegReq,        regOp           => intRegOp,
      regAck          => intRegAck,        regFail         => intRegFail,
      regAddr         => intRegAddr,       regDataOut      => intRegDataOut,
      regDataIn       => intRegDataIn
   );

   -- VC3, Downstream data
   U_DsBuff: Pgp2DsBuff generic map ( FifoType => "V4" ) port map (
      pgpClk           => pgpClk,
      pgpReset         => pgpReset,
      locClk           => locClk,
      locReset         => locReset,
      vcFrameRxValid   => vc3FrameRxValid,
      vcFrameRxSOF     => vcFrameRxSOF,
      vcFrameRxEOF     => vcFrameRxEOF,
      vcFrameRxEOFE    => vcFrameRxEOFE,
      vcFrameRxData    => vcFrameRxData,
      vcLocBuffAFull   => vc3LocBuffAFull,
      vcLocBuffFull    => vc3LocBuffFull,
      frameRxValid     => frameRxValid,
      frameRxReady     => frameRxReady,
      frameRxSOF       => frameRxSOF,
      frameRxEOF       => frameRxEOF,
      frameRxEOFE      => frameRxEOFE,
      frameRxData      => frameRxData
   );

   -- VC3 transmit is unused
   vc3FrameTxValid <= '0';
   vc3FrameTxEOFE  <= '0';
   vc3FrameTxEOF   <= '0';
   vc3FrameTxSOF   <= '0';
   vc3FrameTxData  <= (others=>'0');

end PgpFrontEnd;

