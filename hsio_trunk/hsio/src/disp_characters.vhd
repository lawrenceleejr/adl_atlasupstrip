-------------------------------------------------------------------------------
-- Title         : OSRAM SCDV5540 Display Controller Characters
-- Project       : General Purpose Core
-------------------------------------------------------------------------------
-- File          : DisplayCharacters.vhd
-- Author        : Ryan Herbst, rherbst@slac.stanford.edu
-- Created       : 12/06/2007
-------------------------------------------------------------------------------
-- Description:
-- Package for display chracter lookup table.
-------------------------------------------------------------------------------
-- Copyright (c) 2007 by Ryan Herbst. All rights reserved.
-------------------------------------------------------------------------------
-- Modification history:
-- 12/06/2007: created.
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

package disp_characters is

  -- Types For Character Lookup
  subtype DISPCHAR is std_logic_vector(24 downto 0);
  type DISPTABLE is array (natural range <>) of DISPCHAR;

  -- Constants For Charactors
  constant DISPMAX    : natural   := 54;
  constant DISPLOOKUP : DISPTABLE :=
    (
      0  =>
      "01110" &                         -- Hex 0
      "10011" &
      "10101" &
      "11001" &
      "01110",
      1  =>
      "00100" &                         -- Hex 1
      "01100" &
      "00100" &
      "00100" &
      "11111",
      2  =>
      "11110" &                         -- Hex 2
      "00001" &
      "00110" &
      "01000" &
      "11111",
      3  =>
      "11110" &                         -- Hex 3
      "00001" &
      "01110" &
      "00001" &
      "11110",
      4  =>
      "00110" &                         -- Hex 4
      "01010" &
      "11111" &
      "00010" &
      "00010",
      5  =>
      "11111" &                         -- Hex 5
      "10000" &
      "11110" &
      "00001" &
      "11110",
      6  =>
      "00110" &                         -- Hex 6
      "01000" &
      "11110" &
      "10001" &
      "01110",
      7  =>
      "11111" &                         -- Hex 7
      "00010" &
      "00100" &
      "01000" &
      "01000",
      8  =>
      "01110" &                         -- Hex 8
      "10001" &
      "01110" &
      "10001" &
      "01110",
      9  =>
      "01110" &                         -- Hex 9
      "10001" &
      "01111" &
      "00010" &
      "01100",
      10 =>
      "00100" &                         -- Hex A
      "01010" &
      "11111" &
      "10001" &
      "10001",
      11 =>
      "11110" &                         -- Hex B
      "01001" &
      "01110" &
      "01001" &
      "11110",
      12 =>
      "01111" &                         -- Hex C
      "10000" &
      "10000" &
      "10000" &
      "11111",
      13 =>
      "11110" &                         -- Hex D
      "01001" &
      "01001" &
      "01001" &
      "11110",
      14 =>
      "11111" &                         -- Hex E
      "10000" &
      "11100" &
      "10000" &
      "11111",
      15 =>
      "11111" &                         -- Hex F
      "10000" &
      "11100" &
      "10000" &
      "10000",
      16 =>                             -- 0x10
      "01110" &                         -- G
      "10001" &
      "10000" &
      "10011" &
      "10001",
      17 =>                             -- 0x11
      "01110" &                         -- H
      "10001" &
      "11111" &
      "10001" &
      "10001",
      18 =>                             -- 0x12
      "11111" &                         -- I
      "00100" &
      "00100" &
      "00100" &
      "11111",
      19 =>                             -- 0x13
      "11111" &                         -- J
      "00001" &
      "00001" &
      "10001" &
      "01110",
      20 =>                             -- 0x14
      "10011" &                         -- K
      "10100" &
      "11000" &
      "10100" &
      "10011",
      21 =>                             -- 0x15
      "10000" &                         -- L
      "10000" &
      "10000" &
      "10000" &
      "11111",
      22 =>                             -- 0x16
      "10001" &                         -- M
      "11011" &
      "10101" &
      "10001" &
      "10001",
      23 =>                             -- 0x17
      "10001" &                         -- N
      "11001" &
      "10101" &
      "10011" &
      "10001",
      24 =>                             -- 0x18
      "01110" &                         -- O
      "10001" &
      "10001" &
      "10001" &
      "01110",
      25 =>                             -- 0x19
      "11110" &                         -- P
      "10001" &
      "11110" &
      "10000" &
      "10000",
      26 =>                             -- 0x1a
      "01100" &                         -- Q
      "10010" &
      "10110" &
      "10010" &
      "01101",
      27 =>                             -- 0x1b
      "11110" &                         -- R
      "10001" &
      "11110" &
      "10100" &
      "10011",
      28 =>                             -- 0x1c
      "01111" &                         -- S
      "10000" &
      "01110" &
      "00001" &
      "11110",
      29 =>                             -- 0x1d
      "11111" &                         -- T
      "00100" &
      "00100" &
      "00100" &
      "00100",
      30 =>                             -- 0x1e
      "10001" &                         -- U
      "10001" &
      "10001" &
      "10001" &
      "01110",
      31 =>                             -- 0x1f
      "10001" &                         -- V
      "10001" &
      "10001" &
      "01010" &
      "00100",
      32 =>                             -- 0x20
      "10001" &                         -- W
      "10001" &
      "10101" &
      "11011" &
      "10001",
      33 =>                             -- 0x21
      "10001" &                         -- X
      "01010" &
      "00100" &
      "01010" &
      "10001",
      34 =>                             -- 0x22
      "10001" &                         -- Y
      "01010" &
      "00100" &
      "00100" &
      "00100",
      35 =>                             -- 0x23
      "11111" &                         -- Z
      "00010" &
      "00100" &
      "01000" &
      "11111",
      36 =>                             -- 0x24
      "00101" &                         -- #
      "11111" &
      "01010" &
      "11111" &
      "10100",
      37 =>                             -- 0x25
      "01010" &                         -- :-)
      "01010" &
      "00000" &
      "10001" &
      "01110",
      38 =>                             --  0x26
      "01010" &                         -- :-(
      "01010" &
      "00000" &
      "01110" &
      "10001",

      -- Patterns for 4-bit status "dots"
      39 =>                             -- 0x27
      "00000" &                         -- 0000
      "00000" &
      "00000" &
      "00000" &
      "00000",
      40 =>                             --  0x28
      "00000" &                         -- 0001
      "00000" &
      "00000" &
      "00011" &
      "00011",
      41 =>                             --  0x29
      "00000" &                         -- 0010
      "00000" &
      "00000" &
      "11000" &
      "11000",
      42 =>                             --  0x2a
      "00000" &                         -- 0011
      "00000" &
      "00000" &
      "11011" &
      "11011",
      43 =>                             --  0x2b
      "00011" &                         -- 0100
      "00011" &
      "00000" &
      "00000" &
      "00000",
      44 =>                             --  0x2c
      "00011" &                         -- 0101
      "00011" &
      "00000" &
      "00011" &
      "00011",
      45 =>                             --  0x2d
      "00011" &                         -- 0110
      "00011" &
      "00000" &
      "11000" &
      "11000",
      46 =>                             --  0x2e
      "00011" &                         -- 0111
      "00011" &
      "00000" &
      "11011" &
      "11011",
      47 =>                             --  0x2f
      "11000" &                         --  1000
      "11000" &
      "00000" &
      "00000" &
      "00000",
      48 =>                             --  0x3a
      "11000" &                         -- 1001
      "11000" &
      "00000" &
      "00011" &
      "00011",
      49 =>                             --  0x3b
      "11000" &                         -- 1010
      "11000" &
      "00000" &
      "11000" &
      "11000",
      50 =>                             --  0x3c
      "11000" &                         -- 1011
      "11000" &
      "00000" &
      "11011" &
      "11011",
      51 =>                             --  0x3d
      "11011" &                         -- 1100
      "11011" &
      "00000" &
      "00000" &
      "00000",
      52 =>                             --  0x3e
      "11011" &                         -- 1101
      "11011" &
      "00000" &
      "00011" &
      "00011",
      53 =>                             --  0x3f
      "11011" &                         -- 1110
      "11011" &
      "00000" &
      "11000" &
      "11000",
      54 =>                             --  0x40
      "11011" &                         -- 1111
      "11011" &
      "00000" &
      "11011" &
      "11011"



      );

end disp_characters;
