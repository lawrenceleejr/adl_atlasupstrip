-------------------------------------------------------------------------------
-- Title         : Pretty Good Protocol, V2, Clock Generation Block
-- Project       : General Purpose Core
-------------------------------------------------------------------------------
-- File          : Pgp2MgtClk.vhd
-- Author        : Ryan Herbst, rherbst@slac.stanford.edu
-- Created       : 05/28/2009
-------------------------------------------------------------------------------
-- Description:
-- PGP Clock Module. Contains DCM to support PGP.
-- Used to generate global buffer clock for PGP core at the same frequency
-- as the input reference clock. Will also generate an optional 125Mhz
-- global clock and reset for external logic use.
-- RefClk should be generated from external GT11CLK Module.
-------------------------------------------------------------------------------
-- Copyright (c) 2006 by Ryan Herbst. All rights reserved.
-------------------------------------------------------------------------------
-- Modification history:
-- 05/28/2009: created.
-------------------------------------------------------------------------------

LIBRARY ieee;
use work.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.Pgp2MgtPackage.all;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity PgpClkGen is 
   generic (
      RefClkEn1  : string  := "ENABLE";  -- ENABLE or DISABLE
      RefClkEn2  : string  := "DISABLE"; -- ENABLE or DISABLE
      DcmClkSrc  : string  := "RefClk1"; -- RefClk1 or RefClk2
      UserFxDiv  : integer := 5; -- DCM FX Output Divide
      UserFxMult : integer := 4  -- DCM FX Output Divide, 4/5 * 156.25 = 125Mhz
   );
   port (

      -- Reference Clock Pad Inputs
      pgpRefClkInP  : in  std_logic;
      pgpRefClkInN  : in  std_logic;

      -- Power On Reset Input
      ponResetL     : in  std_logic;

      -- Locally Generated Reset
      locReset      : in  std_logic;

      -- Reference Clock To PGP MGT
      -- Use one, See RefClkEn1 & RefClkEn2 Generics
      pgpRefClk1    : out std_logic;
      pgpRefClk2    : out std_logic;

      -- Global Clock & Reset For PGP Logic, 156.25Mhz
      pgpClk        : out std_logic;
      pgpClk90      : out std_logic;
      pgpReset      : out std_logic;

      clk320        : out std_logic;
      -- Global Clock & Reset For User Logic, 125Mhz
      userClk       : out std_logic;
      userReset     : out std_logic;

      -- Inputs clocks for reset generation connect
      -- to pgpClk and userClk
      pgpClkIn      : in  std_logic;
      userClkIn     : in  std_logic;

       -- Output unbuffered clocks
      pgpClkUnbuf   : out std_logic;
      pgpClk90Unbuf : out std_logic;
      locClkUnbuf   : out std_logic
   );

end PgpClkGen;


-- Define architecture
architecture PgpClkGen of PgpClkGen is

   -- Xilinx GTLL Clock Module
   component GT11CLK 
      generic (
         REFCLKSEL    : string := "MGTCLK";
         SYNCLK1OUTEN : string := "ENABLE";
         SYNCLK2OUTEN : string := "DISABLE"
      );
      port (
         SYNCLK1OUT   : out std_ulogic;
         SYNCLK2OUT   : out std_ulogic;
         MGTCLKN      : in  std_ulogic;
         MGTCLKP      : in  std_ulogic;
         REFCLK       : in  std_ulogic;
         RXBCLK       : in  std_ulogic;
         SYNCLK1IN    : in  std_ulogic;
         SYNCLK2IN    : in  std_ulogic
      );
   end component;

   -- Local Signals
   signal ponReset     : std_logic;
   signal intRefClk1   : std_logic;
   signal intRefClk2   : std_logic;
   signal tmpPgpClk    : std_logic;
   signal tmpPgpClk90  : std_logic;
   signal intPgpClk    : std_logic;
   signal intPgpClk90  : std_logic;
   signal intPgpRst    : std_logic;
   signal tmpLocClk    : std_logic;
   signal tmp320Clk    : std_logic;
   signal int320Clk    : std_logic;
   signal intUsrClk    : std_logic;
   signal intUsrRst    : std_logic;
   signal syncPgpRstIn : std_logic_vector(2 downto 0);
   signal pgpRstCnt    : std_logic_vector(3 downto 0);
   signal syncLocRstIn : std_logic_vector(2 downto 0);
   signal locRstCnt    : std_logic_vector(3 downto 0);
   signal dcmRefClk    : std_logic;
   signal dcmLock      : std_logic;
   signal resetIn      : std_logic;

   -- Register delay for simulation
   constant tpd:time := 0.5 ns;

begin

   -- Output Generated Clock And Reset Signals
   pgpRefClk1 <= intRefClk1;
   pgpRefClk2 <= intRefClk2;
   pgpClk     <= intPgpClk;
   pgpClk90   <= intPgpClk90;
   clk320     <= int320Clk;
   pgpReset   <= intPgpRst;
   userClk    <= intUsrClk;
   userReset  <= intUsrRst;

    -- Output unbuffered clocks
   pgpClkUnbuf <= tmpPgpClk;
   pgpClk90Unbuf <= tmpPgpClk90;
   locClkUnbuf <= tmpLocClk;  

   -- Invert power on reset
   ponReset <= not ponResetL;

   -- MGT Clock Module
   U_PgpClkGT11: GT11CLK  generic map (
      SYNCLK1OUTEN => RefClkEn1,
      SYNCLK2OUTEN => RefClkEn2,
      REFCLKSEL    => "MGTCLK"
   ) port map (
      MGTCLKN      => pgpRefClkInN,
      MGTCLKP      => pgpRefClkInP,
      REFCLK       => '0',
      RXBCLK       => '0',
      SYNCLK1IN    => '0',
      SYNCLK2IN    => '0',
      SYNCLK1OUT   => intRefClk1,
      SYNCLK2OUT   => intRefClk2
   );


   -- REF Clock 1 Is Selected As DCM Source
   U_DCM_REF1: if DcmClkSrc = "RefClk1" generate
      dcmRefClk <= intRefClk1;
   end generate;

   -- REF Clock 2 Is Selected As DCM Source
   U_DCM_REF2: if DcmClkSrc = "RefClk2" generate
      dcmRefClk <= intRefClk2;
   end generate;



   -- DCM For PGP Clock & User Clock
   U_PgpDcm: DCM
      generic map (
         DFS_FREQUENCY_MODE    => "LOW",      DLL_FREQUENCY_MODE    => "HIGH",
         DUTY_CYCLE_CORRECTION => FALSE,      CLKIN_DIVIDE_BY_2     => FALSE,
         CLK_FEEDBACK          => "1X",       CLKOUT_PHASE_SHIFT    => "NONE",
         STARTUP_WAIT          => false,      PHASE_SHIFT           => 0,
         CLKFX_MULTIPLY        => UserFxMult, CLKFX_DIVIDE          => UserFxDiv,
         CLKDV_DIVIDE          => 4.0,        CLKIN_PERIOD          => 6.4,
         DSS_MODE              => "NONE",     FACTORY_JF            => X"C080",
         DESKEW_ADJUST         => "SYSTEM_SYNCHRONOUS"
      )
      port map (
         CLKIN    => dcmRefClk,   CLKFB    => intPgpClk,
         CLK0     => tmpPgpClk,   CLK90    => tmpPgpClk90,
         CLK180   => open,        CLK270   => open, 
         CLK2X    => tmp320Clk,   CLK2X180 => open,
         CLKDV    => tmpLocClk,   CLKFX    => open,
         CLKFX180 => open,        LOCKED   => dcmLock,
         PSDONE   => open,        STATUS   => open,
         DSSEN    => '0',         PSCLK    => '0',
         PSEN     => '0',         PSINCDEC => '0',
         RST      => ponReset
      );


   -- Global Buffer For PGP Clock
   U_PgpClkBuff: BUFGMUX port map (
      O  => intPgpClk,
      I0 => tmpPgpClk,
      I1 => '0',
      S  => '0'
   );
   U_PgpClkBuff90: BUFGMUX port map (
      O  => intPgpClk90,
      I0 => tmpPgpClk90,
      I1 => '0',
      S  => '0'
   );


   -- Global Buffer For 125Mhz Clock
   U_LocClkBuff: BUFGMUX port map (
      O  => intUsrClk,
      I0 => tmpLocClk,
      I1 => '0',
      S  => '0'
   );
   U_320ClkBuff: BUFGMUX port map (
      O  => int320Clk,
      I0 => tmp320Clk,
      I1 => '0',
      S  => '0'
   );

 
   -- Generate reset input
   resetIn <= (not dcmLock) or ponReset or locReset;

   -- PGP Clock Synced Reset
   process ( pgpClkIn, resetIn ) begin
      if resetIn = '1' then
         syncPgpRstIn <= (others=>'0') after tpd;
         pgpRstCnt    <= (others=>'0') after tpd;
         intPgpRst    <= '1'           after tpd;
      elsif rising_edge(pgpClkIn) then

         -- Sync local reset, lock and power on reset to local clock
         -- Negative asserted signal
         syncPgpRstIn(0) <= '1'             after tpd;
         syncPgpRstIn(1) <= syncPgpRstIn(0) after tpd;
         syncPgpRstIn(2) <= syncPgpRstIn(1) after tpd;

         -- Reset counter on reset
         if syncPgpRstIn(2) = '0' then
            pgpRstCnt <= (others=>'0') after tpd;
            intPgpRst <= '1' after tpd;

         -- Count Up To Max Value
         elsif pgpRstCnt = "1111" then
            intPgpRst <= '0' after tpd;

         -- Increment counter
         else
            intPgpRst <= '1' after tpd;
            pgpRstCnt <= pgpRstCnt + 1 after tpd;
         end if;
      end if;
   end process;
   
   -- Local User Clock Synced Reset
   process ( userClkIn, resetIn ) begin
      if resetIn = '1' then
         syncLocRstIn <= (others=>'0') after tpd;
         locRstCnt    <= (others=>'0') after tpd;
         intUsrRst    <= '1'           after tpd;
      elsif rising_edge(userClkIn) then

         -- Sync local reset, lock and power on reset to local clock
         -- Negative asserted signal
         syncLocRstIn(0) <= '1'             after tpd;
         syncLocRstIn(1) <= syncLocRstIn(0) after tpd;
         syncLocRstIn(2) <= syncLocRstIn(1) after tpd;

         -- Reset counter on reset
         if syncLocRstIn(2) = '0' then
            locRstCnt <= (others=>'0') after tpd;
            intUsrRst <= '1' after tpd;

         -- Count Up To Max Value
         elsif locRstCnt = "1111" then
            intUsrRst <= '0' after tpd;

         -- Increment counter
         else
            intUsrRst <= '1' after tpd;
            locRstCnt <= locRstCnt + 1 after tpd;
         end if;
      end if;
   end process;

end PgpClkGen;

