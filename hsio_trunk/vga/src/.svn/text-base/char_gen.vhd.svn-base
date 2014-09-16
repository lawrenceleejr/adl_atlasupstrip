----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:26:58 06/28/2012 
-- Design Name: 
-- Module Name:    char_gen - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

library vga;
use vga.pkg_vga.all;
library utils;
use utils.pkg_types.all;
use hsio.pkg_hsio_globals.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity char_gen is

  port(
    clock, reset    : in  std_logic;                      -- 40 Mhz clock
    row, column     : in  std_logic_vector(10 downto 0);  -- for current pixel
    pixel           : out std_logic;
    -- Read Char values from the buffer
    char_read_addr  : out std_logic_vector(12 downto 0);
    char_read_value : in  single_char
    );

end char_gen;

architecture Behavioral of char_gen is


  component font_rom
    port(
      clk, reset : in  std_logic;
      addr       : in  std_logic_vector(10 downto 0);
      data       : out std_logic_vector(7 downto 0)
      );
  end component;


  signal font_add : std_logic_vector(10 downto 0);
  signal pix_col  : std_logic_vector(7 downto 0);

  signal col_prev, col_prev_prev : std_logic_vector(10 downto 0);
  signal row_prev, row_prev_prev : std_logic_vector(10 downto 0);

begin

  Ufont_rom : font_rom
    port map (
      clk   => clock,
      reset => reset,
      addr  => font_add,
      data  => pix_col
      );

  char_read_addr <= row(9 downto 4) & column(9 downto 3);
  -- The char read value is one tick behind
  font_add       <= char_read_value(6 downto 0) & row_prev(3 downto 0);

  column_buffer : process (clock, reset)
  begin
    if (reset = '1') then
      col_prev_prev      <= (others => '0');
      col_prev           <= (others => '0');
      row_prev_prev      <= (others => '0');
      row_prev           <= (others => '0');
    else if (clock'event and clock = '1') then
           col_prev_prev <= col_prev;
           col_prev      <= column;
           row_prev_prev <= row_prev;
           row_prev      <= row;
         end if;
    end if;
  end process;

  pixmux : process (col_prev_prev, pix_col)
  begin
    case col_prev_prev(2 downto 0) is
      when "000"  => pixel <= pix_col(7);
      when "001"  => pixel <= pix_col(6);
      when "010"  => pixel <= pix_col(5);
      when "011"  => pixel <= pix_col(4);
      when "100"  => pixel <= pix_col(3);
      when "101"  => pixel <= pix_col(2);
      when "110"  => pixel <= pix_col(1);
      when "111"  => pixel <= pix_col(0);
      when others => pixel <= '0';
    end case;
  end process;

end Behavioral;

