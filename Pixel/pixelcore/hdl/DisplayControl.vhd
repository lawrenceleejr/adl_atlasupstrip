-------------------------------------------------------------------------------
-- Title         : OSRAM SCDV5540 Display Controller
-- Project       : General Purpose Core
-------------------------------------------------------------------------------
-- File          : DisplayControl.vhd
-- Author        : Ryan Herbst, rherbst@slac.stanford.edu
-- Created       : 12/06/2007
-------------------------------------------------------------------------------
-- Description:
-- Source code for display controller for OSRAM SCDV5540 4-digit LED
-- display. An 8-bit input value is input for each of the 4 digits on the 
-- LED display. This 8-bit value is used to lookup a charactor from a defined
-- table of charactors. 
-- See DisplayCharacters file for character definitions.
-------------------------------------------------------------------------------
-- Copyright (c) 2007 by Ryan Herbst. All rights reserved.
-------------------------------------------------------------------------------
-- Modification history:
-- 12/06/2007: created.
-- 03/06/2008: Fixed reset of shiftValue
-------------------------------------------------------------------------------
LIBRARY ieee;
Library Unisim;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.ALL;
use work.DisplayCharacters.all;

entity DisplayControl is 
   port ( 

      -- Master Clock & reset
      sysClk       : in  std_logic;
      sysRst       : in  std_logic;

      -- Display timing strobe. 200ns min period.
      dispStrobe   : in  std_logic;

      -- Update display 
      dispUpdate   : in  std_logic;

      -- Display rotation, 0=0, 1=90, 2=180, 3=270
      dispRotate   : in  std_logic_vector(1 downto 0);

      -- Index value for charactor digits
      dispDigitA   : in  std_logic_vector(7 downto 0);
      dispDigitB   : in  std_logic_vector(7 downto 0);
      dispDigitC   : in  std_logic_vector(7 downto 0);
      dispDigitD   : in  std_logic_vector(7 downto 0);

      -- Outputs to display device
      dispClk      : out std_logic;
      dispDat      : out std_logic;
      dispLoadL    : out std_logic;
      dispRstL     : out std_logic
   );

   -- Keep from combinging output clocks
   attribute syn_preserve : boolean;
   attribute syn_preserve of dispClk:     signal is true;

end DisplayControl;


-- Define architecture for first level module
architecture DisplayControl of DisplayControl is 

   -- Local signals
   signal intLoad     : std_logic;
   signal intData     : std_logic;
   signal charCount   : std_logic_vector(1  downto 0);
   signal wordCount   : std_logic_vector(2  downto 0);
   signal bitCount    : std_logic_vector(3  downto 0);
   signal shiftCount  : std_logic_vector(6  downto 0);
   signal shiftValue  : std_logic_vector(39 downto 0);
   signal newShift    : std_logic_vector(39 downto 0);
   signal lookupValue : std_logic_vector(24 downto 0);
   signal newDigit    : std_logic_vector(7  downto 0);
   signal strobeDelay : std_logic;
   signal strobeEdge  : std_logic;
   signal shiftEn     : std_logic;

   -- Keep from combinging output clocks
   attribute syn_preserve of strobeDelay: signal is true;

   -- Register delay for simulation
   constant tpd:time := 0.5 ns;

begin

   -- Output Control Lines
   process ( sysClk, sysRst ) begin
      if sysRst = '1' then
         dispLoadL <= '1' after tpd;
         dispRstL  <= '0' after tpd;
         dispClk   <= '0' after tpd;
         dispDat   <= '0' after tpd;
      elsif rising_edge(sysClk) then
         dispLoadL <= not intLoad     after tpd;
         dispRstL  <= '1'             after tpd;
         dispClk   <= not dispStrobe  after tpd;
         dispDat   <= intData         after tpd;
      end if;
   end process;


   -- Strobe edge detection
   strobeEdge <= dispStrobe and not strobeDelay;

   -- Shift sequence control and counters
   process ( sysClk, sysRst ) begin
      if sysRst = '1' then
         charCount   <= (others=>'0') after tpd;
         wordCount   <= (others=>'0') after tpd;
         shiftCount  <= (others=>'0') after tpd;
         bitCount    <= (others=>'0') after tpd;
         shiftEn     <= '0'           after tpd;
         intLoad     <= '0'           after tpd;
         intData     <= '0'           after tpd;
         strobeDelay <= '0'           after tpd;
         shiftValue  <= (others=>'0') after tpd;
      elsif rising_edge(sysClk) then

         -- Delayed copy of shift
         strobeDelay <= dispStrobe after tpd;

         -- Sequnce is not running
         if shiftEn = '0' then
            charCount  <= (others=>'0') after tpd;
            wordCount  <= (others=>'0') after tpd;
            shiftCount <= (others=>'0') after tpd;
            bitCount   <= (others=>'0') after tpd;
            shiftEn    <= dispUpdate    after tpd;
            intLoad    <= '0'           after tpd;
            intData    <= '0'           after tpd;

         -- Sequence Is Running
         elsif strobeEdge = '1' then

            -- Bit Counter For 8-bit word plus 3-bit space
            if bitCount = 12 then
               bitCount <= (others=>'0') after tpd;
            else
               bitCount <= bitCount + 1 after tpd;
            end if;

            -- Word Counter, Digit address, followed by 4 Rows
            if bitCount = 12 then
               if wordCount = 5 then
                  wordCount <= (others=>'0') after tpd;
               else
                  wordCount <= wordCount + 1 after tpd;
               end if;
            end if;

            -- Char Counter, 4 Characters
            if bitCount = 12 and wordCount = 5 then
               if charCount = 3 then
                  charCount <= (others=>'0') after tpd;
                  shiftEn   <= '0'           after tpd;
               else
                  charCount <= charCount + 1 after tpd;
               end if;
            end if;

            -- Shift Bit Counter, Shift Output for words 1-5
            if wordCount = 0 then 
               shiftCount <= (others=>'0') after tpd;
               shiftValue <= newShift      after tpd;
            elsif bitCount < 8 then
               shiftCount <= shiftCount + 1 after tpd;
            end if;

            -- Character address is first word
            if wordCount = 0 then
               case bitCount is
                  when "0000" => intData <= charCount(0) after tpd;
                  when "0001" => intData <= charCount(1) after tpd;
                  when "0010" => intData <= '0'          after tpd;
                  when "0011" => intData <= '0'          after tpd;
                  when "0100" => intData <= '0'          after tpd;
                  when "0101" => intData <= '1'          after tpd;
                  when "0110" => intData <= '0'          after tpd;
                  when "0111" => intData <= '1'          after tpd;
                  when others => intData <= '0'          after tpd;
               end case;

            -- Shift out digit values for words 1-5
            else
               intData <= shiftValue(conv_integer(shiftCount)) after tpd;
            end if;
               
            -- Load Strobe asserted for bits 0-7
            if bitCount < 8 then
               intLoad <= '1' after tpd;
            else
               intLoad <= '0' after tpd;
            end if;
         end if;
      end if;
   end process;


   -- Select Digit For Display
   newDigit <= dispDigitA when charCount = 0 else
               dispDigitB when charCount = 1 else
               dispDigitC when charCount = 2 else
               dispDigitD;

   -- Get Raw Lookup Value
   lookupValue <= (others=>'0') when newDigit > DISPMAX else DISPLOOKUP(conv_integer(newDigit));

   -- Determine rotation of display digit and add row addresses
   newShift <= 

      -- No Rotation
      "000" & lookupValue(24 downto 20) &
      "001" & lookupValue(19 downto 15) &
      "010" & lookupValue(14 downto 10) &
      "011" & lookupValue(9  downto  5) &
      "100" & lookupValue(4  downto  0) when dispRotate = 0 else

      -- 90 Deg Rotation
      "000" & lookupValue(4)  & lookupValue(9)  & 
              lookupValue(14) & lookupValue(19) & lookupValue(24) &
      "001" & lookupValue(3)  & lookupValue(8)  & 
              lookupValue(13) & lookupValue(18) & lookupValue(23) &
      "010" & lookupValue(2)  & lookupValue(7)  & 
              lookupValue(12) & lookupValue(17) & lookupValue(22) &
      "011" & lookupValue(1)  & lookupValue(6)  & 
              lookupValue(11) & lookupValue(16) & lookupValue(21) &
      "100" & lookupValue(0)  & lookupValue(5)  & 
              lookupValue(10) & lookupValue(15) & lookupValue(20) when dispRotate = 1 else

      -- 180 Deg Rotation
      "000" & lookupValue(0)  & lookupValue(1)  & 
              lookupValue(2)  & lookupValue(3)  & lookupValue(4)  &
      "001" & lookupValue(5)  & lookupValue(6)  & 
              lookupValue(7)  & lookupValue(8)  & lookupValue(9)  &
      "010" & lookupValue(10) & lookupValue(11) & 
              lookupValue(12) & lookupValue(13) & lookupValue(14) &
      "011" & lookupValue(15) & lookupValue(16) & 
              lookupValue(17) & lookupValue(18) & lookupValue(19) &
      "100" & lookupValue(20) & lookupValue(21) & 
              lookupValue(22) & lookupValue(23) & lookupValue(24) when dispRotate = 2 else

      -- 270 Deg Rotation
      "000" & lookupValue(20) & lookupValue(15) & 
              lookupValue(10) & lookupValue(5)  & lookupValue(0) &
      "001" & lookupValue(21) & lookupValue(16) & 
              lookupValue(11) & lookupValue(6)  & lookupValue(1) &
      "010" & lookupValue(22) & lookupValue(17) & 
              lookupValue(12) & lookupValue(7)  & lookupValue(2) &
      "011" & lookupValue(23) & lookupValue(18) & 
              lookupValue(13) & lookupValue(8)  & lookupValue(3) &
      "100" & lookupValue(24) & lookupValue(19) & 
              lookupValue(14) & lookupValue(9)  & lookupValue(4);

end DisplayControl;
