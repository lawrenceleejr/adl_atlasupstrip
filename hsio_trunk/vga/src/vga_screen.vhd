-- 
-- Block which writes to the vga char_mem
--
--

library IEEE;
use IEEE.STD_Logic_1164.all;
use ieee.numeric_std.all;

library vga;
use vga.pkg_vga.all;
library hsio;
use hsio.pkg_hsio_globals.all;
library utils;
use utils.pkg_types.all;



entity vga_screen is
  generic (
    scope_width      :     integer := 64
    );
  port(
--
    clock, reset     : in  std_logic;   -- 40 Mhz clock
-- Screen Refresh
    refresh          : in  std_logic;   -- Refresh the screen RAM
-- Input to the Char mem RAM
    char_write_addr  : out std_logic_vector(CHAR_RAM_ADDR_WIDTH-1 downto 0);
    char_we          : out std_logic;
    char_write_value : out single_char;
-- Signals to display
    status_i         : in  slv16_array(31 downto 0);
    reg_i            :     t_reg_bus;
-- Single bits (LED-like behaviour)
    leds_i           : in  std_logic_vector(N_LEDS-1 downto 0);
-- Buffered scope like signals
    scope_i          : in  scope_arr;
-- VGA Control bits
    vga_ctrl_in      : in  slv16
    );
end;

architecture behaviour1 of vga_screen is

  signal current_char : character;
  signal char_pointer : integer;        -- define counters

  type vga_state_type is (idle, writing);  --type of state machine.
  signal current_s, next_s : vga_state_type;  --current and next state declaration.

begin

  char_write_value <= char_to_ascii( current_char );
  char_write_addr  <= std_logic_vector( to_unsigned(char_pointer, CHAR_RAM_ADDR_WIDTH) );

-- Control the character buffer writing
  process(char_pointer)
  begin
    current_char                                                                                                                                                                                                                                                                       <= ' ';
    char_we                                                                                                                                                                                                                                                                            <= '0';
    if (current_s = writing) then
      -- Map the current character
      char_we                                                                                                                                                                                                                                                                          <= '1';
      case char_pointer is
-- Title
--______ ______________________
--___ / / /_ ___/___ _/_ __ \
--__ /_/ /_____ \ __ / _ / / /
--_ __ / ____/ /__/ / / /_/ /
--/_/ /_/ /____/ /___/ \____/
        when coord_to_address(1, 0) to coord_to_address(6, 0) |
          coord_to_address(9, 0) to coord_to_address(30, 0) |
          coord_to_address(1, 1) to coord_to_address(3, 1) |
          coord_to_address(11, 1) | coord_to_address(23, 1) | coord_to_address(25, 1) | coord_to_address(28, 1) | coord_to_address(29, 1) |
          coord_to_address(14, 1) to coord_to_address(16, 1)|
          coord_to_address(18, 1) to coord_to_address(20, 1)|
          coord_to_address(1, 2) | coord_to_address(2, 2) | coord_to_address(6, 2) |
          coord_to_address(10, 2) to coord_to_address(14, 2)|
          coord_to_address(18, 2) | coord_to_address(19, 2) | coord_to_address(24, 2) |
          coord_to_address(1, 3) | coord_to_address(4, 3) | coord_to_address(5, 3) |
          coord_to_address(10, 3) to coord_to_address(13, 3)|
          coord_to_address(17, 3) | coord_to_address(18, 3) | coord_to_address(27, 3) |
          coord_to_address(2, 4) | coord_to_address(6, 4) |
          coord_to_address(11, 4) to coord_to_address(14, 4)|
          coord_to_address(18, 4) to coord_to_address(20, 4)|
          coord_to_address(25, 4) to coord_to_address(28, 4)                                                                                                                                                                                 => current_char                           <= '_';
        when coord_to_address(6, 1) | coord_to_address(8, 1) | coord_to_address(10, 1) | coord_to_address(17, 1) | coord_to_address(24, 1) |
          coord_to_address(5, 2) | coord_to_address(7, 2) | coord_to_address(9, 2) | coord_to_address(22, 2) | coord_to_address(27, 2) | coord_to_address(29, 2) | coord_to_address(31, 2) |
          coord_to_address(8, 3) | coord_to_address(14, 3) | coord_to_address(16, 3) | coord_to_address(19, 3) | coord_to_address(21, 3) | coord_to_address(24, 3) | coord_to_address(26, 3) |coord_to_address(28, 3) | coord_to_address(30, 3) |
          coord_to_address(1, 4) | coord_to_address(3, 4) | coord_to_address(5, 4) | coord_to_address(7, 4) | coord_to_address(10, 4) | coord_to_address(15, 4) | coord_to_address(17, 4) |coord_to_address(21, 4) | coord_to_address(29, 4) => current_char                           <= '/';
        when coord_to_address(31, 1) | coord_to_address(16, 2) | coord_to_address(24, 4)                                                                                                                                                     => current_char                           <= '\';
---- ===========================================================================
---- S T A T U S
---- ===========================================================================
-- Status registers
        when coord_to_address(1, 6)                                                                                                                                                                                                          => current_char                           <= 'S';
        when coord_to_address(2, 6)                                                                                                                                                                                                          => current_char                           <= 't';
        when coord_to_address(3, 6)                                                                                                                                                                                                          => current_char                           <= 'a';
        when coord_to_address(4, 6)                                                                                                                                                                                                          => current_char                           <= 't';
        when coord_to_address(5, 6)                                                                                                                                                                                                          => current_char                           <= 'u';
        when coord_to_address(6, 6)                                                                                                                                                                                                          => current_char                           <= 's';
-- constant S_VERSION : integer := 2;  -- 0x04  -- f/w version
        when coord_to_address(1, 8)                                                                                                                                                                                                          => current_char                           <= 'H';
        when coord_to_address(2, 8)                                                                                                                                                                                                          => current_char                           <= 'a';
        when coord_to_address(3, 8)                                                                                                                                                                                                          => current_char                           <= 'r';
        when coord_to_address(4, 8)                                                                                                                                                                                                          => current_char                           <= 'd';
        when coord_to_address(5, 8)                                                                                                                                                                                                          => current_char                           <= 'w';
        when coord_to_address(6, 8)                                                                                                                                                                                                          => current_char                           <= 'a';
        when coord_to_address(7, 8)                                                                                                                                                                                                          => current_char                           <= 'r';
        when coord_to_address(8, 8)                                                                                                                                                                                                          => current_char                           <= 'e';
        when coord_to_address(10, 8)                                                                                                                                                                                                         => current_char                           <= 'I';
        when coord_to_address(11, 8)                                                                                                                                                                                                         => current_char                           <= 'D';
        when coord_to_address(12, 8)                                                                                                                                                                                                         => current_char                           <= '  : ';
        when coord_to_address(15, 8)                                                                                                                                                                                                         => current_char                           <= '0';
        when coord_to_address(16, 8)                                                                                                                                                                                                         => current_char                           <= 'x';
        when coord_to_address(17, 8)                                                                                                                                                                                                         => current_char                           <= slv_to_char( status_i(S_HW_ID), 3 );
        when coord_to_address(18, 8)                                                                                                                                                                                                         => current_char                           <= slv_to_char( status_i(S_HW_ID), 2 );
        when coord_to_address(19, 8)                                                                                                                                                                                                         => current_char                           <= slv_to_char( status_i(S_HW_ID), 1 );
        when coord_to_address(20, 8)                                                                                                                                                                                                         => current_char                           <= slv_to_char( status_i(S_HW_ID), 0 );
-- constant S_SANITY : integer := 1;  -- 0x02  -- sanity check - always = 0xA510                 
        when coord_to_address(1, 9)                                                                                                                                                                                                          => current_char                           <= 'S';
        when coord_to_address(2, 9)                                                                                                                                                                                                          => current_char                           <= 'a';
        when coord_to_address(3, 9)                                                                                                                                                                                                          => current_char                           <= 'n';
        when coord_to_address(4, 9)                                                                                                                                                                                                          => current_char                           <= 'i';
        when coord_to_address(5, 9)                                                                                                                                                                                                          => current_char                           <= 't';
        when coord_to_address(6, 9)                                                                                                                                                                                                          => current_char                           <= 'y';
        when coord_to_address(8, 9)                                                                                                                                                                                                          => current_char                           <= 'B';
        when coord_to_address(9, 9)                                                                                                                                                                                                          => current_char                           <= 'i';
        when coord_to_address(10, 9)                                                                                                                                                                                                         => current_char                           <= 't';
        when coord_to_address(11, 9)                                                                                                                                                                                                         => current_char                           <= 's';
        when coord_to_address(12, 9)                                                                                                                                                                                                         => current_char                           <= '  : ';
        when coord_to_address(15, 9)                                                                                                                                                                                                         => current_char                           <= '0';
        when coord_to_address(16, 9)                                                                                                                                                                                                         => current_char                           <= 'x';
        when coord_to_address(17, 9)                                                                                                                                                                                                         => current_char                           <= slv_to_char( status_i(S_SANITY), 3 );
        when coord_to_address(18, 9)                                                                                                                                                                                                         => current_char                           <= slv_to_char( status_i(S_SANITY), 2 );
        when coord_to_address(19, 9)                                                                                                                                                                                                         => current_char                           <= slv_to_char( status_i(S_SANITY), 1 );
        when coord_to_address(20, 9)                                                                                                                                                                                                         => current_char                           <= slv_to_char( status_i(S_SANITY), 0 );
-- constant S_VERSION : integer := 2;  -- 0x04  -- f/w version                            
        when coord_to_address(1, 10)                                                                                                                                                                                                         => current_char                           <= 'H';
        when coord_to_address(2, 10)                                                                                                                                                                                                         => current_char                           <= 'S';
        when coord_to_address(3, 10)                                                                                                                                                                                                         => current_char                           <= 'I';
        when coord_to_address(4, 10)                                                                                                                                                                                                         => current_char                           <= 'O';
        when coord_to_address(6, 10)                                                                                                                                                                                                         => current_char                           <= 'V';
        when coord_to_address(7, 10)                                                                                                                                                                                                         => current_char                           <= 'e';
        when coord_to_address(8, 10)                                                                                                                                                                                                         => current_char                           <= 'r';
        when coord_to_address(9, 10)                                                                                                                                                                                                         => current_char                           <= 's';
        when coord_to_address(10, 10)                                                                                                                                                                                                        => current_char                           <= 'i';
        when coord_to_address(11, 10)                                                                                                                                                                                                        => current_char                           <= 'o';
        when coord_to_address(12, 10)                                                                                                                                                                                                        => current_char                           <= 'n';
        when coord_to_address(13, 10)                                                                                                                                                                                                        => current_char                           <= ' : ';
        when coord_to_address(15, 10)                                                                                                                                                                                                        => current_char                           <= '0';
        when coord_to_address(16, 10)                                                                                                                                                                                                        => current_char                           <= 'x';
        when coord_to_address(17, 10)                                                                                                                                                                                                        => current_char                           <= slv_to_char( status_i(S_VERSION), 3 );
        when coord_to_address(18, 10)                                                                                                                                                                                                        => current_char                           <= slv_to_char( status_i(S_VERSION), 2 );
        when coord_to_address(19, 10)                                                                                                                                                                                                        => current_char                           <= slv_to_char( status_i(S_VERSION), 1 );
        when coord_to_address(20, 10)                                                                                                                                                                                                        => current_char                           <= slv_to_char( status_i(S_VERSION), 0 );
---- constant S_TB_TCOUNT : integer := 4;  -- 0x08  -- trig burst ??? count
--                                      when coord_to_address(1,12) => current_char <= 'T';
--                                      when coord_to_address(2,12) => current_char <= 'B';
--                                      when coord_to_address(4,12) => current_char <= 'T';
--                                      when coord_to_address(5,12) => current_char <= 'C';
--                                      when coord_to_address(6,12) => current_char <= 'o';
--                                      when coord_to_address(7,12) => current_char <= 'u';
--                                      when coord_to_address(8,12) => current_char <= 'n';
--                                      when coord_to_address(9,12) => current_char <= 't';
--                                      when coord_to_address(10,12) => current_char <= ':';
--                                      when coord_to_address(15,12) => current_char <= '0';
--                                      when coord_to_address(16,12) => current_char <= 'x';
--                                      when coord_to_address(17,12) => current_char <= slv_to_char( status_i(S_TB_TCOUNT), 3 );
--                                      when coord_to_address(18,12) => current_char <= slv_to_char( status_i(S_TB_TCOUNT), 2 );
--                                      when coord_to_address(19,12) => current_char <= slv_to_char( status_i(S_TB_TCOUNT), 1 );
--                                      when coord_to_address(20,12) => current_char <= slv_to_char( status_i(S_TB_TCOUNT), 0 );
----  constant S_TB_BCOUNT    : integer := 5;  -- 0x0a  -- trig burst ??? count
--                                      when coord_to_address(1,13) => current_char <= 'T';
--                                      when coord_to_address(2,13) => current_char <= 'B';
--                                      when coord_to_address(4,13) => current_char <= 'B';
--                                      when coord_to_address(5,13) => current_char <= 'C';
--                                      when coord_to_address(6,13) => current_char <= 'o';
--                                      when coord_to_address(7,13) => current_char <= 'u';
--                                      when coord_to_address(8,13) => current_char <= 'n';
--                                      when coord_to_address(9,13) => current_char <= 't';
--                                      when coord_to_address(10,13) => current_char <= ':';
--                                      when coord_to_address(15,13) => current_char <= '0';
--                                      when coord_to_address(16,13) => current_char <= 'x';
--                                      when coord_to_address(17,13) => current_char <= slv_to_char( status_i(S_TB_BCOUNT), 3 );
--                                      when coord_to_address(18,13) => current_char <= slv_to_char( status_i(S_TB_BCOUNT), 2 );
--                                      when coord_to_address(19,13) => current_char <= slv_to_char( status_i(S_TB_BCOUNT), 1 );
--                                      when coord_to_address(20,13) => current_char <= slv_to_char( status_i(S_TB_BCOUNT), 0 );
----  constant S_TB_FLAGS     : integer := 6;  -- 0x0c  -- trig burst flags
--                                      when coord_to_address(1,14) => current_char <= 'T';
--                                      when coord_to_address(2,14) => current_char <= 'B';
--                                      when coord_to_address(4,14) => current_char <= 'F';
--                                      when coord_to_address(5,14) => current_char <= 'l';
--                                      when coord_to_address(6,14) => current_char <= 'a';
--                                      when coord_to_address(7,14) => current_char <= 'g';
--                                      when coord_to_address(8,14) => current_char <= 's';
--                                      when coord_to_address(9,14) => current_char <= ':';
--                                      when coord_to_address(15,14) => current_char <= '0';
--                                      when coord_to_address(16,14) => current_char <= 'x';
--                                      when coord_to_address(17,14) => current_char <= slv_to_char( status_i(S_TB_FLAGS), 3 );
--                                      when coord_to_address(18,14) => current_char <= slv_to_char( status_i(S_TB_FLAGS), 2 );
--                                      when coord_to_address(19,14) => current_char <= slv_to_char( status_i(S_TB_FLAGS), 1 );
--                                      when coord_to_address(20,14) => current_char <= slv_to_char( status_i(S_TB_FLAGS), 0 );
--  constant S_MODULES_EN   : integer := 3;  -- 0x06  -- n modules in build
        when coord_to_address(31, 8)                                                                                                                                                                                                         => current_char                           <= 'N';
        when coord_to_address(33, 8)                                                                                                                                                                                                         => current_char                           <= 'M';
        when coord_to_address(34, 8)                                                                                                                                                                                                         => current_char                           <= 'o';
        when coord_to_address(35, 8)                                                                                                                                                                                                         => current_char                           <= 'd';
        when coord_to_address(36, 8)                                                                                                                                                                                                         => current_char                           <= 'u';
        when coord_to_address(37, 8)                                                                                                                                                                                                         => current_char                           <= 'l';
        when coord_to_address(38, 8)                                                                                                                                                                                                         => current_char                           <= 'e';
        when coord_to_address(39, 8)                                                                                                                                                                                                         => current_char                           <= 's';
        when coord_to_address(40, 8)                                                                                                                                                                                                         => current_char                           <= '  : ';
        when coord_to_address(45, 8)                                                                                                                                                                                                         => current_char                           <= '0';
        when coord_to_address(46, 8)                                                                                                                                                                                                         => current_char                           <= 'x';
        when coord_to_address(47, 8)                                                                                                                                                                                                         => current_char                           <= slv_to_char( status_i(S_MODULES_EN), 3 );
        when coord_to_address(48, 8)                                                                                                                                                                                                         => current_char                           <= slv_to_char( status_i(S_MODULES_EN), 2 );
        when coord_to_address(49, 8)                                                                                                                                                                                                         => current_char                           <= slv_to_char( status_i(S_MODULES_EN), 1 );
        when coord_to_address(50, 8)                                                                                                                                                                                                         => current_char                           <= slv_to_char( status_i(S_MODULES_EN), 0 );
-- constant S_TMODULES_EN : integer := 16;  -- 0x20  -- top modules in build
        when coord_to_address(31, 9)                                                                                                                                                                                                         => current_char                           <= 'T';
        when coord_to_address(32, 9)                                                                                                                                                                                                         => current_char                           <= 'o';
        when coord_to_address(33, 9)                                                                                                                                                                                                         => current_char                           <= 'p';
        when coord_to_address(35, 9)                                                                                                                                                                                                         => current_char                           <= 'M';
        when coord_to_address(36, 9)                                                                                                                                                                                                         => current_char                           <= 'o';
        when coord_to_address(37, 9)                                                                                                                                                                                                         => current_char                           <= 'd';
        when coord_to_address(38, 9)                                                                                                                                                                                                         => current_char                           <= 'u';
        when coord_to_address(39, 9)                                                                                                                                                                                                         => current_char                           <= 'l';
        when coord_to_address(40, 9)                                                                                                                                                                                                         => current_char                           <= 'e';
        when coord_to_address(41, 9)                                                                                                                                                                                                         => current_char                           <= 's';
        when coord_to_address(42, 9)                                                                                                                                                                                                         => current_char                           <= '  : ';
        when coord_to_address(45, 9)                                                                                                                                                                                                         => current_char                           <= '0';
        when coord_to_address(46, 9)                                                                                                                                                                                                         => current_char                           <= 'x';
        when coord_to_address(47, 9)                                                                                                                                                                                                         => current_char                           <= slv_to_char( status_i(S_TMODULES_EN), 3 );
        when coord_to_address(48, 9)                                                                                                                                                                                                         => current_char                           <= slv_to_char( status_i(S_TMODULES_EN), 2 );
        when coord_to_address(49, 9)                                                                                                                                                                                                         => current_char                           <= slv_to_char( status_i(S_TMODULES_EN), 1 );
        when coord_to_address(50, 9)                                                                                                                                                                                                         => current_char                           <= slv_to_char( status_i(S_TMODULES_EN), 0 );
-- constant S_THISTOS_EN : integer := 17;  -- 0x22  -- top histos in build
        when coord_to_address(31, 10)                                                                                                                                                                                                        => current_char                           <= 'T';
        when coord_to_address(32, 10)                                                                                                                                                                                                        => current_char                           <= 'o';
        when coord_to_address(33, 10)                                                                                                                                                                                                        => current_char                           <= 'p';
        when coord_to_address(35, 10)                                                                                                                                                                                                        => current_char                           <= 'H';
        when coord_to_address(36, 10)                                                                                                                                                                                                        => current_char                           <= 'i';
        when coord_to_address(37, 10)                                                                                                                                                                                                        => current_char                           <= 's';
        when coord_to_address(38, 10)                                                                                                                                                                                                        => current_char                           <= 't';
        when coord_to_address(39, 10)                                                                                                                                                                                                        => current_char                           <= 'o';
        when coord_to_address(40, 10)                                                                                                                                                                                                        => current_char                           <= 's';
        when coord_to_address(41, 10)                                                                                                                                                                                                        => current_char                           <= ' : ';
        when coord_to_address(45, 10)                                                                                                                                                                                                        => current_char                           <= '0';
        when coord_to_address(46, 10)                                                                                                                                                                                                        => current_char                           <= 'x';
        when coord_to_address(47, 10)                                                                                                                                                                                                        => current_char                           <= slv_to_char( status_i(S_THISTOS_EN), 3 );
        when coord_to_address(48, 10)                                                                                                                                                                                                        => current_char                           <= slv_to_char( status_i(S_THISTOS_EN), 2 );
        when coord_to_address(49, 10)                                                                                                                                                                                                        => current_char                           <= slv_to_char( status_i(S_THISTOS_EN), 1 );
        when coord_to_address(50, 10)                                                                                                                                                                                                        => current_char                           <= slv_to_char( status_i(S_THISTOS_EN), 0 );
-- constant S_BMODULES_EN : integer := 18;  -- 0x24  -- bottom modules in build
        when coord_to_address(31, 11)                                                                                                                                                                                                        => current_char                           <= 'B';
        when coord_to_address(32, 11)                                                                                                                                                                                                        => current_char                           <= 'o';
        when coord_to_address(33, 11)                                                                                                                                                                                                        => current_char                           <= 't';
        when coord_to_address(35, 11)                                                                                                                                                                                                        => current_char                           <= 'M';
        when coord_to_address(36, 11)                                                                                                                                                                                                        => current_char                           <= 'o';
        when coord_to_address(37, 11)                                                                                                                                                                                                        => current_char                           <= 'd';
        when coord_to_address(38, 11)                                                                                                                                                                                                        => current_char                           <= 'u';
        when coord_to_address(39, 11)                                                                                                                                                                                                        => current_char                           <= 'l';
        when coord_to_address(40, 11)                                                                                                                                                                                                        => current_char                           <= 'e';
        when coord_to_address(41, 11)                                                                                                                                                                                                        => current_char                           <= 's';
        when coord_to_address(42, 11)                                                                                                                                                                                                        => current_char                           <= ' : ';
        when coord_to_address(45, 11)                                                                                                                                                                                                        => current_char                           <= '0';
        when coord_to_address(46, 11)                                                                                                                                                                                                        => current_char                           <= 'x';
        when coord_to_address(47, 11)                                                                                                                                                                                                        => current_char                           <= slv_to_char( status_i(S_BMODULES_EN), 3 );
        when coord_to_address(48, 11)                                                                                                                                                                                                        => current_char                           <= slv_to_char( status_i(S_BMODULES_EN), 2 );
        when coord_to_address(49, 11)                                                                                                                                                                                                        => current_char                           <= slv_to_char( status_i(S_BMODULES_EN), 1 );
        when coord_to_address(50, 11)                                                                                                                                                                                                        => current_char                           <= slv_to_char( status_i(S_BMODULES_EN), 0 );
-- constant S_BHISTOS_EN : integer := 19;  -- 0x26  -- bottom histos in build
        when coord_to_address(31, 12)                                                                                                                                                                                                        => current_char                           <= 'B';
        when coord_to_address(32, 12)                                                                                                                                                                                                        => current_char                           <= 'o';
        when coord_to_address(33, 12)                                                                                                                                                                                                        => current_char                           <= 't';
        when coord_to_address(35, 12)                                                                                                                                                                                                        => current_char                           <= 'H';
        when coord_to_address(36, 12)                                                                                                                                                                                                        => current_char                           <= 'i';
        when coord_to_address(37, 12)                                                                                                                                                                                                        => current_char                           <= 's';
        when coord_to_address(38, 12)                                                                                                                                                                                                        => current_char                           <= 't';
        when coord_to_address(39, 12)                                                                                                                                                                                                        => current_char                           <= 'o';
        when coord_to_address(40, 12)                                                                                                                                                                                                        => current_char                           <= 's';
        when coord_to_address(41, 12)                                                                                                                                                                                                        => current_char                           <= ' : ';
        when coord_to_address(45, 12)                                                                                                                                                                                                        => current_char                           <= '0';
        when coord_to_address(46, 12)                                                                                                                                                                                                        => current_char                           <= 'x';
        when coord_to_address(47, 12)                                                                                                                                                                                                        => current_char                           <= slv_to_char( status_i(S_BHISTOS_EN), 3 );
        when coord_to_address(48, 12)                                                                                                                                                                                                        => current_char                           <= slv_to_char( status_i(S_BHISTOS_EN), 2 );
        when coord_to_address(49, 12)                                                                                                                                                                                                        => current_char                           <= slv_to_char( status_i(S_BHISTOS_EN), 1 );
        when coord_to_address(50, 12)                                                                                                                                                                                                        => current_char                           <= slv_to_char( status_i(S_BHISTOS_EN), 0 );
-- constant S_PPHISTMOD_EN : integer := 20;  -- 0x28  -- pp histos/modules in build                                    when others => current_char <= ' ';
        when coord_to_address(31, 13)                                                                                                                                                                                                        => current_char                           <= 'N';
        when coord_to_address(33, 13)                                                                                                                                                                                                        => current_char                           <= 'P';
        when coord_to_address(34, 13)                                                                                                                                                                                                        => current_char                           <= 'P';
        when coord_to_address(35, 13)                                                                                                                                                                                                        => current_char                           <= 'M';
        when coord_to_address(36, 13)                                                                                                                                                                                                        => current_char                           <= 'o';
        when coord_to_address(37, 13)                                                                                                                                                                                                        => current_char                           <= 'd';
        when coord_to_address(38, 13)                                                                                                                                                                                                        => current_char                           <= 'u';
        when coord_to_address(39, 13)                                                                                                                                                                                                        => current_char                           <= 'l';
        when coord_to_address(40, 13)                                                                                                                                                                                                        => current_char                           <= 'e';
        when coord_to_address(41, 13)                                                                                                                                                                                                        => current_char                           <= 's';
        when coord_to_address(42, 13)                                                                                                                                                                                                        => current_char                           <= ' : ';
        when coord_to_address(45, 13)                                                                                                                                                                                                        => current_char                           <= '0';
        when coord_to_address(46, 13)                                                                                                                                                                                                        => current_char                           <= 'x';
        when coord_to_address(47, 13)                                                                                                                                                                                                        => current_char                           <= slv_to_char( status_i(S_PPHISTMOD_EN), 3 );
        when coord_to_address(48, 13)                                                                                                                                                                                                        => current_char                           <= slv_to_char( status_i(S_PPHISTMOD_EN), 2 );
        when coord_to_address(49, 13)                                                                                                                                                                                                        => current_char                           <= slv_to_char( status_i(S_PPHISTMOD_EN), 1 );
        when coord_to_address(50, 13)                                                                                                                                                                                                        => current_char                           <= slv_to_char( status_i(S_PPHISTMOD_EN), 0 );
-- constant S_BCID_L1A : integer := 7;  -- 0x0e  -- 
        when coord_to_address(1, 12)                                                                                                                                                                                                         => current_char                           <= 'B';
        when coord_to_address(2, 12)                                                                                                                                                                                                         => current_char                           <= 'C';
        when coord_to_address(3, 12)                                                                                                                                                                                                         => current_char                           <= 'I';
        when coord_to_address(4, 12)                                                                                                                                                                                                         => current_char                           <= 'D';
        when coord_to_address(5, 12)                                                                                                                                                                                                         => current_char                           <= '  : ';
        when coord_to_address(15, 12)                                                                                                                                                                                                        => current_char                           <= '0';
        when coord_to_address(16, 12)                                                                                                                                                                                                        => current_char                           <= 'x';
        when coord_to_address(17, 12)                                                                                                                                                                                                        => current_char                           <= slv_to_char( status_i(S_BCID_L1A), 3 );
        when coord_to_address(18, 12)                                                                                                                                                                                                        => current_char                           <= slv_to_char( status_i(S_BCID_L1A), 2 );
        when coord_to_address(19, 12)                                                                                                                                                                                                        => current_char                           <= slv_to_char( status_i(S_BCID_L1A), 1 );
        when coord_to_address(20, 12)                                                                                                                                                                                                        => current_char                           <= slv_to_char( status_i(S_BCID_L1A), 0 );
-- constant S_L1ID_LO : integer := 7;  -- 0x0e  -- 
        when coord_to_address(1, 13)                                                                                                                                                                                                         => current_char                           <= 'L';
        when coord_to_address(2, 13)                                                                                                                                                                                                         => current_char                           <= '1';
        when coord_to_address(3, 13)                                                                                                                                                                                                         => current_char                           <= 'I';
        when coord_to_address(4, 13)                                                                                                                                                                                                         => current_char                           <= 'D';
        when coord_to_address(6, 13)                                                                                                                                                                                                         => current_char                           <= 'L';
        when coord_to_address(7, 13)                                                                                                                                                                                                         => current_char                           <= 'O';
        when coord_to_address(8, 13)                                                                                                                                                                                                         => current_char                           <= '  : ';
        when coord_to_address(15, 13)                                                                                                                                                                                                        => current_char                           <= '0';
        when coord_to_address(16, 13)                                                                                                                                                                                                        => current_char                           <= 'x';
        when coord_to_address(17, 13)                                                                                                                                                                                                        => current_char                           <= slv_to_char( status_i(S_L1ID_LO), 3 );
        when coord_to_address(18, 13)                                                                                                                                                                                                        => current_char                           <= slv_to_char( status_i(S_L1ID_LO), 2 );
        when coord_to_address(19, 13)                                                                                                                                                                                                        => current_char                           <= slv_to_char( status_i(S_L1ID_LO), 1 );
        when coord_to_address(20, 13)                                                                                                                                                                                                        => current_char                           <= slv_to_char( status_i(S_L1ID_LO), 0 );
-- constant S_L1ID_HI : integer := 7;  -- 0x0e  -- 
        when coord_to_address(1, 14)                                                                                                                                                                                                         => current_char                           <= 'L';
        when coord_to_address(2, 14)                                                                                                                                                                                                         => current_char                           <= '1';
        when coord_to_address(3, 14)                                                                                                                                                                                                         => current_char                           <= 'I';
        when coord_to_address(4, 14)                                                                                                                                                                                                         => current_char                           <= 'D';
        when coord_to_address(6, 14)                                                                                                                                                                                                         => current_char                           <= 'H';
        when coord_to_address(7, 14)                                                                                                                                                                                                         => current_char                           <= 'I';
        when coord_to_address(8, 14)                                                                                                                                                                                                         => current_char                           <= '  : ';
        when coord_to_address(15, 14)                                                                                                                                                                                                        => current_char                           <= '0';
        when coord_to_address(16, 14)                                                                                                                                                                                                        => current_char                           <= 'x';
        when coord_to_address(17, 14)                                                                                                                                                                                                        => current_char                           <= slv_to_char( status_i(S_L1ID_HI), 3 );
        when coord_to_address(18, 14)                                                                                                                                                                                                        => current_char                           <= slv_to_char( status_i(S_L1ID_HI), 2 );
        when coord_to_address(19, 14)                                                                                                                                                                                                        => current_char                           <= slv_to_char( status_i(S_L1ID_HI), 1 );
        when coord_to_address(20, 14)                                                                                                                                                                                                        => current_char                           <= slv_to_char( status_i(S_L1ID_HI), 0 );
-- Registers
        when coord_to_address(60, 6)                                                                                                                                                                                                         => current_char                           <= 'R';
        when coord_to_address(61, 6)                                                                                                                                                                                                         => current_char                           <= 'e';
        when coord_to_address(62, 6)                                                                                                                                                                                                         => current_char                           <= 'g';
        when coord_to_address(63, 6)                                                                                                                                                                                                         => current_char                           <= 'i';
        when coord_to_address(64, 6)                                                                                                                                                                                                         => current_char                           <= 's';
        when coord_to_address(65, 6)                                                                                                                                                                                                         => current_char                           <= 't';
        when coord_to_address(66, 6)                                                                                                                                                                                                         => current_char                           <= 'e';
        when coord_to_address(67, 6)                                                                                                                                                                                                         => current_char                           <= 'r';
        when coord_to_address(68, 6)                                                                                                                                                                                                         => current_char                           <= 's';
-- constant R_IN_ENA
        when coord_to_address(60, 8)                                                                                                                                                                                                         => current_char                           <= 'I';
        when coord_to_address(61, 8)                                                                                                                                                                                                         => current_char                           <= 'n';
        when coord_to_address(63, 8)                                                                                                                                                                                                         => current_char                           <= 'E';
        when coord_to_address(64, 8)                                                                                                                                                                                                         => current_char                           <= 'n';
        when coord_to_address(65, 8)                                                                                                                                                                                                         => current_char                           <= 'a';
        when coord_to_address(66, 8)                                                                                                                                                                                                         => current_char                           <= 'b';
        when coord_to_address(67, 8)                                                                                                                                                                                                         => current_char                           <= 'l';
        when coord_to_address(68, 8)                                                                                                                                                                                                         => current_char                           <= 'e';
        when coord_to_address(69, 8)                                                                                                                                                                                                         => current_char                           <= 's';
        when coord_to_address(70, 8)                                                                                                                                                                                                         => current_char                           <= '  : ';
        when coord_to_address(74, 8)                                                                                                                                                                                                         => current_char                           <= '0';
        when coord_to_address(75, 8)                                                                                                                                                                                                         => current_char                           <= 'x';
        when coord_to_address(76, 8)                                                                                                                                                                                                         => current_char                           <= slv_to_char( reg_i(R_IN_ENA), 3 );
        when coord_to_address(77, 8)                                                                                                                                                                                                         => current_char                           <= slv_to_char( reg_i(R_IN_ENA), 2 );
        when coord_to_address(78, 8)                                                                                                                                                                                                         => current_char                           <= slv_to_char( reg_i(R_IN_ENA), 1 );
        when coord_to_address(79, 8)                                                                                                                                                                                                         => current_char                           <= slv_to_char( reg_i(R_IN_ENA), 0 );
-- constant R_OUT_ENA
        when coord_to_address(60, 9)                                                                                                                                                                                                         => current_char                           <= 'O';
        when coord_to_address(61, 9)                                                                                                                                                                                                         => current_char                           <= 'u';
        when coord_to_address(62, 9)                                                                                                                                                                                                         => current_char                           <= 't';
        when coord_to_address(64, 9)                                                                                                                                                                                                         => current_char                           <= 'E';
        when coord_to_address(65, 9)                                                                                                                                                                                                         => current_char                           <= 'n';
        when coord_to_address(66, 9)                                                                                                                                                                                                         => current_char                           <= 'a';
        when coord_to_address(67, 9)                                                                                                                                                                                                         => current_char                           <= 'b';
        when coord_to_address(68, 9)                                                                                                                                                                                                         => current_char                           <= 'l';
        when coord_to_address(69, 9)                                                                                                                                                                                                         => current_char                           <= 'e';
        when coord_to_address(70, 9)                                                                                                                                                                                                         => current_char                           <= 's';
        when coord_to_address(71, 9)                                                                                                                                                                                                         => current_char                           <= '  : ';
        when coord_to_address(74, 9)                                                                                                                                                                                                         => current_char                           <= '0';
        when coord_to_address(75, 9)                                                                                                                                                                                                         => current_char                           <= 'x';
        when coord_to_address(76, 9)                                                                                                                                                                                                         => current_char                           <= slv_to_char( reg_i(R_OUT_ENA), 3 );
        when coord_to_address(77, 9)                                                                                                                                                                                                         => current_char                           <= slv_to_char( reg_i(R_OUT_ENA), 2 );
        when coord_to_address(78, 9)                                                                                                                                                                                                         => current_char                           <= slv_to_char( reg_i(R_OUT_ENA), 1 );
        when coord_to_address(79, 9)                                                                                                                                                                                                         => current_char                           <= slv_to_char( reg_i(R_OUT_ENA), 0 );
-- constant R_INT_ENA
        when coord_to_address(60, 10)                                                                                                                                                                                                        => current_char                           <= 'I';
        when coord_to_address(61, 10)                                                                                                                                                                                                        => current_char                           <= 'n';
        when coord_to_address(62, 10)                                                                                                                                                                                                        => current_char                           <= 't';
        when coord_to_address(64, 10)                                                                                                                                                                                                        => current_char                           <= 'E';
        when coord_to_address(65, 10)                                                                                                                                                                                                        => current_char                           <= 'n';
        when coord_to_address(66, 10)                                                                                                                                                                                                        => current_char                           <= 'a';
        when coord_to_address(67, 10)                                                                                                                                                                                                        => current_char                           <= 'b';
        when coord_to_address(68, 10)                                                                                                                                                                                                        => current_char                           <= 'l';
        when coord_to_address(69, 10)                                                                                                                                                                                                        => current_char                           <= 'e';
        when coord_to_address(70, 10)                                                                                                                                                                                                        => current_char                           <= 's';
        when coord_to_address(71, 10)                                                                                                                                                                                                        => current_char                           <= ' : ';
        when coord_to_address(74, 10)                                                                                                                                                                                                        => current_char                           <= '0';
        when coord_to_address(75, 10)                                                                                                                                                                                                        => current_char                           <= 'x';
        when coord_to_address(76, 10)                                                                                                                                                                                                        => current_char                           <= slv_to_char( reg_i(R_INT_ENA), 3 );
        when coord_to_address(77, 10)                                                                                                                                                                                                        => current_char                           <= slv_to_char( reg_i(R_INT_ENA), 2 );
        when coord_to_address(78, 10)                                                                                                                                                                                                        => current_char                           <= slv_to_char( reg_i(R_INT_ENA), 1 );
        when coord_to_address(79, 10)                                                                                                                                                                                                        => current_char                           <= slv_to_char( reg_i(R_INT_ENA), 0 );
-- constant R_COM_ENA
        when coord_to_address(60, 11)                                                                                                                                                                                                        => current_char                           <= 'C';
        when coord_to_address(61, 11)                                                                                                                                                                                                        => current_char                           <= 'o';
        when coord_to_address(62, 11)                                                                                                                                                                                                        => current_char                           <= 'm';
        when coord_to_address(64, 11)                                                                                                                                                                                                        => current_char                           <= 'E';
        when coord_to_address(65, 11)                                                                                                                                                                                                        => current_char                           <= 'n';
        when coord_to_address(66, 11)                                                                                                                                                                                                        => current_char                           <= 'a';
        when coord_to_address(67, 11)                                                                                                                                                                                                        => current_char                           <= 'b';
        when coord_to_address(68, 11)                                                                                                                                                                                                        => current_char                           <= 'l';
        when coord_to_address(69, 11)                                                                                                                                                                                                        => current_char                           <= 'e';
        when coord_to_address(70, 11)                                                                                                                                                                                                        => current_char                           <= 's';
        when coord_to_address(71, 11)                                                                                                                                                                                                        => current_char                           <= ' : ';
        when coord_to_address(74, 11)                                                                                                                                                                                                        => current_char                           <= '0';
        when coord_to_address(75, 11)                                                                                                                                                                                                        => current_char                           <= 'x';
        when coord_to_address(76, 11)                                                                                                                                                                                                        => current_char                           <= slv_to_char( reg_i(R_COM_ENA), 3 );
        when coord_to_address(77, 11)                                                                                                                                                                                                        => current_char                           <= slv_to_char( reg_i(R_COM_ENA), 2 );
        when coord_to_address(78, 11)                                                                                                                                                                                                        => current_char                           <= slv_to_char( reg_i(R_COM_ENA), 1 );
        when coord_to_address(79, 11)                                                                                                                                                                                                        => current_char                           <= slv_to_char( reg_i(R_COM_ENA), 0 );
-- constant R_CONTROL
        when coord_to_address(60, 12)                                                                                                                                                                                                        => current_char                           <= 'C';
        when coord_to_address(61, 12)                                                                                                                                                                                                        => current_char                           <= 'o';
        when coord_to_address(62, 12)                                                                                                                                                                                                        => current_char                           <= 'n';
        when coord_to_address(63, 12)                                                                                                                                                                                                        => current_char                           <= 't';
        when coord_to_address(64, 12)                                                                                                                                                                                                        => current_char                           <= 'r';
        when coord_to_address(65, 12)                                                                                                                                                                                                        => current_char                           <= 'o';
        when coord_to_address(66, 12)                                                                                                                                                                                                        => current_char                           <= 'l';
        when coord_to_address(67, 12)                                                                                                                                                                                                        => current_char                           <= ' : ';
        when coord_to_address(74, 12)                                                                                                                                                                                                        => current_char                           <= '0';
        when coord_to_address(75, 12)                                                                                                                                                                                                        => current_char                           <= 'x';
        when coord_to_address(76, 12)                                                                                                                                                                                                        => current_char                           <= slv_to_char( reg_i(R_CONTROL), 3 );
        when coord_to_address(77, 12)                                                                                                                                                                                                        => current_char                           <= slv_to_char( reg_i(R_CONTROL), 2 );
        when coord_to_address(78, 12)                                                                                                                                                                                                        => current_char                           <= slv_to_char( reg_i(R_CONTROL), 1 );
        when coord_to_address(79, 12)                                                                                                                                                                                                        => current_char                           <= slv_to_char( reg_i(R_CONTROL), 0 );
-- R_LEMO_STRM : Streams on the lemo
        when coord_to_address(60, 13)                                                                                                                                                                                                        => current_char                           <= 'L';
        when coord_to_address(61, 13)                                                                                                                                                                                                        => current_char                           <= 'e';
        when coord_to_address(62, 13)                                                                                                                                                                                                        => current_char                           <= 'm';
        when coord_to_address(63, 13)                                                                                                                                                                                                        => current_char                           <= 'o';
        when coord_to_address(65, 13)                                                                                                                                                                                                        => current_char                           <= 'S';
        when coord_to_address(66, 13)                                                                                                                                                                                                        => current_char                           <= 't';
        when coord_to_address(67, 13)                                                                                                                                                                                                        => current_char                           <= 'r';
        when coord_to_address(68, 13)                                                                                                                                                                                                        => current_char                           <= 'e';
        when coord_to_address(69, 13)                                                                                                                                                                                                        => current_char                           <= 'a';
        when coord_to_address(70, 13)                                                                                                                                                                                                        => current_char                           <= 'm';
        when coord_to_address(71, 13)                                                                                                                                                                                                        => current_char                           <= 's';
        when coord_to_address(72, 13)                                                                                                                                                                                                        => current_char                           <= ' : ';
        when coord_to_address(74, 13)                                                                                                                                                                                                        => current_char                           <= '0';
        when coord_to_address(75, 13)                                                                                                                                                                                                        => current_char                           <= 'x';
        when coord_to_address(76, 13)                                                                                                                                                                                                        => current_char                           <= slv_to_char( reg_i(R_LEMO_STRM), 3 );
        when coord_to_address(77, 13)                                                                                                                                                                                                        => current_char                           <= slv_to_char( reg_i(R_LEMO_STRM), 2 );
        when coord_to_address(78, 13)                                                                                                                                                                                                        => current_char                           <= slv_to_char( reg_i(R_LEMO_STRM), 1 );
        when coord_to_address(79, 13)                                                                                                                                                                                                        => current_char                           <= slv_to_char( reg_i(R_LEMO_STRM), 0 );
-- LED Flashing
        when coord_to_address(40, 1)                                                                                                                                                                                                         => current_char                           <= 'P';
        when coord_to_address(41, 1)                                                                                                                                                                                                         => current_char                           <= 'u';
        when coord_to_address(42, 1)                                                                                                                                                                                                         => current_char                           <= 'l';
        when coord_to_address(43, 1)                                                                                                                                                                                                         => current_char                           <= 's';
        when coord_to_address(44, 1)                                                                                                                                                                                                         => current_char                           <= 'e';
        when coord_to_address(45, 1)                                                                                                                                                                                                         => current_char                           <= '  : ';
        when coord_to_address(53, 1)                                                                                                                                                                                                         => if (leds_i(0) = '1') then current_char <= '*'; else current_char <= ' '; end if;
-- LED Flashing Rx
        when coord_to_address(40, 2)                                                                                                                                                                                                         => current_char                           <= 'N';
        when coord_to_address(41, 2)                                                                                                                                                                                                         => current_char                           <= 'e';
        when coord_to_address(42, 2)                                                                                                                                                                                                         => current_char                           <= 't';
        when coord_to_address(44, 2)                                                                                                                                                                                                         => current_char                           <= 'T';
        when coord_to_address(45, 2)                                                                                                                                                                                                         => current_char                           <= 'x';
        when coord_to_address(46, 2)                                                                                                                                                                                                         => current_char                           <= '/';
        when coord_to_address(47, 2)                                                                                                                                                                                                         => current_char                           <= 'R';
        when coord_to_address(48, 2)                                                                                                                                                                                                         => current_char                           <= 'x';
        when coord_to_address(49, 2)                                                                                                                                                                                                         => current_char                           <= '  : ';
        when coord_to_address(53, 2)                                                                                                                                                                                                         => if (leds_i(1) = '1') then current_char <= '*'; else current_char <= ' '; end if;
        when coord_to_address(55, 2)                                                                                                                                                                                                         => if (leds_i(2) = '1') then current_char <= '*'; else current_char <= ' '; end if;
-- LED Flashing Sync
        when coord_to_address(40, 3)                                                                                                                                                                                                         => current_char                           <= 'N';
        when coord_to_address(41, 3)                                                                                                                                                                                                         => current_char                           <= 'e';
        when coord_to_address(42, 3)                                                                                                                                                                                                         => current_char                           <= 't';
        when coord_to_address(44, 3)                                                                                                                                                                                                         => current_char                           <= 'S';
        when coord_to_address(45, 3)                                                                                                                                                                                                         => current_char                           <= 'y';
        when coord_to_address(46, 3)                                                                                                                                                                                                         => current_char                           <= 'n';
        when coord_to_address(47, 3)                                                                                                                                                                                                         => current_char                           <= 'c';
        when coord_to_address(48, 3)                                                                                                                                                                                                         => current_char                           <= '0';
        when coord_to_address(49, 3)                                                                                                                                                                                                         => current_char                           <= '/';
        when coord_to_address(50, 3)                                                                                                                                                                                                         => current_char                           <= '1';
        when coord_to_address(51, 3)                                                                                                                                                                                                         => current_char                           <= '  : ';
        when coord_to_address(53, 3)                                                                                                                                                                                                         => if (leds_i(3) = '1') then current_char <= '*'; else current_char <= ' '; end if;
        when coord_to_address(55, 3)                                                                                                                                                                                                         => if (leds_i(4) = '1') then current_char <= '*'; else current_char <= ' '; end if;
-- Debugs
        when coord_to_address(1, 16)                                                                                                                                                                                                         => current_char                           <= 'D';
        when coord_to_address(2, 16)                                                                                                                                                                                                         => current_char                           <= 'e';
        when coord_to_address(3, 16)                                                                                                                                                                                                         => current_char                           <= 'b';
        when coord_to_address(4, 16)                                                                                                                                                                                                         => current_char                           <= 'u';
        when coord_to_address(5, 16)                                                                                                                                                                                                         => current_char                           <= 'g';
        when coord_to_address(6, 16)                                                                                                                                                                                                         => current_char                           <= 's';
---- Debug Enable
-- when coord_to_address(60,8) => current_char <= 'E';
-- when coord_to_address(61,8) => current_char <= 'n';
-- when coord_to_address(62,8) => current_char <= 'a';
-- when coord_to_address(63,8) => current_char <= 'b';
-- when coord_to_address(64,8) => current_char <= 'l';
-- when coord_to_address(65,8) => current_char <= 'e';
-- when coord_to_address(66,8) => current_char <= 'd';
-- when coord_to_address(67,8) => current_char <= '?';
-- when coord_to_address(70,8) => if (leds_i(5) = '1') then current_char <= '*'; else current_char <= ' '; end if;
-- Stream 0
        when coord_to_address(1, 18)                                                                                                                                                                                                         => current_char                           <= 'S';
        when coord_to_address(2, 18)                                                                                                                                                                                                         => current_char                           <= 't';
        when coord_to_address(3, 18)                                                                                                                                                                                                         => current_char                           <= 'r';
        when coord_to_address(4, 18)                                                                                                                                                                                                         => current_char                           <= 'e';
        when coord_to_address(5, 18)                                                                                                                                                                                                         => current_char                           <= 'a';
        when coord_to_address(6, 18)                                                                                                                                                                                                         => current_char                           <= 'm';
        when coord_to_address(8, 18)                                                                                                                                                                                                         => current_char                           <= '0';
        when coord_to_address(9, 18)                                                                                                                                                                                                         => current_char                           <= '  : ';
        when coord_to_address(11, 18)                                                                                                                                                                                                        => if (leds_i(6) = '1') then current_char <= '*'; else current_char <= ' '; end if;

        when coord_to_address(13, 18) to coord_to_address(13+SCOPE_WIDTH-1, 18) =>
          if (scope_i(6)((char_pointer mod COL_NUM)-13-LEFT_BLANK_SIZE) = '1') then current_char                          <= '1'; else current_char <= ' '; end if;
-- Stream 1
        when coord_to_address(1, 19)                                            => current_char                           <= 'S';
        when coord_to_address(2, 19)                                            => current_char                           <= 't';
        when coord_to_address(3, 19)                                            => current_char                           <= 'r';
        when coord_to_address(4, 19)                                            => current_char                           <= 'e';
        when coord_to_address(5, 19)                                            => current_char                           <= 'a';
        when coord_to_address(6, 19)                                            => current_char                           <= 'm';
        when coord_to_address(8, 19)                                            => current_char                           <= '1';
        when coord_to_address(9, 19)                                            => current_char                           <= ' : ';
        when coord_to_address(11, 19)                                           => if (leds_i(7) = '1') then current_char <= '*'; else current_char <= ' '; end if;

        when coord_to_address(13, 19) to coord_to_address(13+SCOPE_WIDTH-1, 19) =>
          if (scope_i(7)((char_pointer mod COL_NUM)-13-LEFT_BLANK_SIZE) = '1') then current_char <= '1'; else current_char <= ' '; end if;

-- Link
        when coord_to_address(1, 20)  => current_char                           <= 'L';
        when coord_to_address(2, 20)  => current_char                           <= 'i';
        when coord_to_address(3, 20)  => current_char                           <= 'n';
        when coord_to_address(4, 20)  => current_char                           <= 'k';
        when coord_to_address(5, 20)  => current_char                           <= ' : ';
        when coord_to_address(11, 20) => if (leds_i(8) = '1') then current_char <= '*'; else current_char <= ' '; end if;

        when coord_to_address(13, 20) to coord_to_address(13+SCOPE_WIDTH-1, 20) =>
          if (scope_i(8)((char_pointer mod COL_NUM)-13-LEFT_BLANK_SIZE) = '1') then current_char <= '1'; else current_char <= ' '; end if;

---- Lemo Trigger
-- when coord_to_address(60,12) => current_char <= 'L';
-- when coord_to_address(61,12) => current_char <= 'e';
-- when coord_to_address(62,12) => current_char <= 'm';
-- when coord_to_address(63,12) => current_char <= 'o';
-- when coord_to_address(65,12) => current_char <= 'T';
-- when coord_to_address(66,12) => current_char <= 'r';
-- when coord_to_address(67,12) => current_char <= 'g';
-- when coord_to_address(68,12) => current_char <= ':';
-- when coord_to_address(70,12) => if (leds_i(9) = '1') then current_char <= '*'; else current_char <= ' '; end if;
-- Lemo BCO
        when coord_to_address(1, 21)  => current_char                            <= 'B';
        when coord_to_address(2, 21)  => current_char                            <= 'C';
        when coord_to_address(3, 21)  => current_char                            <= 'O';
        when coord_to_address(4, 21)  => current_char                            <= ' : ';
        when coord_to_address(11, 21) => if (leds_i(10) = '1') then current_char <= '*'; else current_char <= ' '; end if;

        when coord_to_address(13, 21) to coord_to_address(13+SCOPE_WIDTH-1, 21) =>
          if (scope_i(10)((char_pointer mod COL_NUM)-13-LEFT_BLANK_SIZE) = '1') then current_char <= '1'; else current_char <= ' '; end if;

-- Lemo COM
        when coord_to_address(1, 22)  => current_char                            <= 'C';
        when coord_to_address(2, 22)  => current_char                            <= 'O';
        when coord_to_address(3, 22)  => current_char                            <= 'M';
        when coord_to_address(4, 22)  => current_char                            <= ' : ';
        when coord_to_address(11, 22) => if (leds_i(11) = '1') then current_char <= '*'; else current_char <= ' '; end if;

        when coord_to_address(13, 22) to coord_to_address(13+SCOPE_WIDTH-1, 22) =>
          if (scope_i(11)((char_pointer mod COL_NUM)-13-LEFT_BLANK_SIZE) = '1') then current_char <= '1'; else current_char <= ' '; end if;

-- Busy RO
        when coord_to_address(1, 23)  => current_char                            <= 'B';
        when coord_to_address(2, 23)  => current_char                            <= 'u';
        when coord_to_address(3, 23)  => current_char                            <= 's';
        when coord_to_address(4, 23)  => current_char                            <= 'y';
        when coord_to_address(6, 23)  => current_char                            <= 'R';
        when coord_to_address(7, 23)  => current_char                            <= 'O';
        when coord_to_address(8, 23)  => current_char                            <= ' : ';
        when coord_to_address(11, 23) => if (leds_i(12) = '1') then current_char <= '*'; else current_char <= ' '; end if;

        when coord_to_address(13, 23) to coord_to_address(13+SCOPE_WIDTH-1, 23) =>
          if (scope_i(12)((char_pointer mod COL_NUM)-13-LEFT_BLANK_SIZE) = '1') then current_char <= '1'; else current_char <= ' '; end if;

-- Raw COM Start
        when coord_to_address(1, 24)  => current_char                            <= 'R';
        when coord_to_address(2, 24)  => current_char                            <= 'a';
        when coord_to_address(3, 24)  => current_char                            <= 'w';
        when coord_to_address(5, 24)  => current_char                            <= 'C';
        when coord_to_address(6, 24)  => current_char                            <= 'o';
        when coord_to_address(7, 24)  => current_char                            <= 'm';
        when coord_to_address(8, 24)  => current_char                            <= ' : ';
        when coord_to_address(11, 24) => if (leds_i(13) = '1') then current_char <= '*'; else current_char <= ' '; end if;

        when coord_to_address(13, 24) to coord_to_address(13+SCOPE_WIDTH-1, 24) =>
          if (scope_i(13)((char_pointer mod COL_NUM)-13-LEFT_BLANK_SIZE) = '1') then current_char <= '1'; else current_char <= ' '; end if;
-- VGA Info
        when coord_to_address(1, 30)                                            => current_char   <= 'V';
        when coord_to_address(2, 30)                                            => current_char   <= 'G';
        when coord_to_address(3, 30)                                            => current_char   <= 'A';
        when coord_to_address(5, 30)                                            => current_char   <= 'O';
        when coord_to_address(6, 30)                                            => current_char   <= 'p';
        when coord_to_address(7, 30)                                            => current_char   <= 'c';
        when coord_to_address(8, 30)                                            => current_char   <= 'o';
        when coord_to_address(9, 30)                                            => current_char   <= 'd';
        when coord_to_address(10, 30)                                           => current_char   <= 'e';
        when coord_to_address(11, 30)                                           => current_char   <= ' : ';
        when coord_to_address(13, 30)                                           => current_char   <= '0';
        when coord_to_address(14, 30)                                           => current_char   <= 'x';
        when coord_to_address(15, 30)                                           => current_char   <= slv_to_char( OC_VGA, 3 );
        when coord_to_address(16, 30)                                           => current_char   <= slv_to_char( OC_VGA, 2 );
        when coord_to_address(17, 30)                                           => current_char   <= slv_to_char( OC_VGA, 1 );
        when coord_to_address(18, 30)                                           => current_char   <= slv_to_char( OC_VGA, 0 );
        when coord_to_address(20, 30)                                           => current_char   <= ' = ';
        when coord_to_address(22,30)                                            => current_char   <= '0';					
        when coord_to_address(23,30) => current_char <= 'x';						
        when coord_to_address(24,30) => current_char <= slv_to_char( vga_ctrl_in, 3 );
        when coord_to_address(25,30) => current_char <= slv_to_char( vga_ctrl_in, 2 );
        when coord_to_address(26,30) => current_char <= slv_to_char( vga_ctrl_in, 1 );
        when coord_to_address(27,30) => current_char <= slv_to_char( vga_ctrl_in, 0 );					
-- Complete the MUX5
        when others => current_char <= ' ';
      end case;				
    end if; -- state writing
  end process;

-- Finite State Machine (very simple)
  process (current_s,refresh, char_pointer)
  begin
    case current_s is
      when idle => 
        if(refresh ='0') then
          next_s <= idle;
        else
          next_s <= writing;
        end if;  

      when writing =>
        if (char_pointer >= 2**CHAR_RAM_ADDR_WIDTH) then
          next_s <= idle;
        else
          next_s <= writing;
        end if;
    end case;
  end process;

-- Moving the state machine along
  process (clock,reset)
  begin
    if (reset='1') then
      current_s <= idle;  --default state on reset.
      char_pointer <= 0;
    elsif (clock='1' and clock'event) then
      current_s <= next_s;   --state change.
      
      if (current_s = writing) then			
        char_pointer <= char_pointer + 1;
      else
        char_pointer <= 0;
      end if;
      
    end if;
  end process;


end architecture;
