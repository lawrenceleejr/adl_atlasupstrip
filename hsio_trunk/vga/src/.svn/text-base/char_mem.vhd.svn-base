-- VGA Character Memory
--
-- This memory can store 128x32 characters where each character is
-- 8 bits. The memory is dual ported providing a port
-- to read the characters and a port to write the characters.
--
-- 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vga;
use vga.pkg_vga.all;


entity char_mem is
  port(
    clk, reset       : in  std_logic;
    char_read_addr   : in  std_logic_vector(CHAR_RAM_ADDR_WIDTH-1 downto 0);
    char_write_addr  : in  std_logic_vector(CHAR_RAM_ADDR_WIDTH-1 downto 0);
    char_we          : in  std_logic;
    char_write_value : in  single_char;
    char_read_value  : out single_char
    );
end char_mem;

architecture arch of char_mem is

  signal read_a   : std_logic_vector(CHAR_RAM_ADDR_WIDTH-1 downto 0);
  signal char_ram : char_ram_type := string_to_char_ram( initial_screen );

begin

  -- character memory concurrent statement
  process(clk, reset)
  begin
    if (reset = '1') then
      read_a                                              <= (others => '0');
    else
      if (clk'event and clk = '1') then
        if (char_we = '1') then
          char_ram(to_integer(unsigned(char_write_addr))) <= char_write_value;
        end if;
        read_a                                            <= char_read_addr;
      end if;
    end if;
  end process;
  char_read_value                                         <= char_ram(to_integer(unsigned(read_a)));

end arch;

