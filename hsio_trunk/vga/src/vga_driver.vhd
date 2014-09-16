-- VGA driver for Altera UP1 board  Rob Chapman  Feb 22, 1998

library IEEE;
use IEEE.STD_Logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library vga;
use vga.pkg_vga.all;

entity vga_driver is
  port( clock, reset           : in  std_logic;  -- 40 Mhz clock
        red, green, blue       : in  std_logic;  -- input values for RGB signals
        row, column            : out std_logic_vector(10 downto 0);  -- for current pixel
        Rout, Gout, Bout, H, V : out std_logic);  -- VGA drive signals
  -- The signals Rout, Gout, Bout, H and V are output to the monitor.
  -- The row and column outputs are used to know when to assert red,
  -- green and blue to color the current pixel.  For VGA, the column
  -- values that are valid are from 0 to 639, all other values should
  -- be ignored.  The row values that are valid are from 0 to 479 and
  -- again, all other values are ignored.  To turn on a pixel on the
  -- VGA monitor, some combination of red, green and blue should be
  -- asserted before the rising edge of the clock.  Objects which are
  -- displayed on the monitor, assert their combination of red, green and
  -- blue when they detect the row and column values are within their
  -- range.  For multiple objects sharing a screen, they must be combined
  -- using logic to create single red, green, and blue signals.
end;

architecture behaviour1 of vga_driver is

begin

  Rout <= red;
  Gout <= green;
  Bout <= blue;

  process(clock, reset)
    variable vertical, horizontal : counter;  -- define counters
  begin
    if (reset = '1') then
      horizontal     := (others => '0');
      vertical       := (others => '0');
      H <= '0';
      V <= '0';
    else
      if (clock'event and clock = '1') then
        -- increment counters
        if horizontal < A - 1 then
          horizontal := horizontal + 1;
        else
          horizontal := (others => '0');

          if vertical < O - 1 then        -- less than oh
            vertical := vertical + 1;
          else
            vertical := (others => '0');  -- is set to zero
          end if;
        end if;

        -- define H pulse
        if horizontal >= (D + E) and horizontal < (D + E + B) then
          H <= '0';
        else
          H <= '1';
        end if;

        -- define V pulse
        if vertical >= (R + S) and vertical < (R + S + P) then
          V <= '0';
        else
          V <= '1';
        end if;

        -- mapping of the variable to the signals
        -- negative signs are because the conversion bits are reversed
        row <= vertical;
        column <= horizontal;
      end if; -- clock
    end if; -- reset
    
  end process;

end architecture;
