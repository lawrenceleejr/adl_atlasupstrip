--
-- VHDL Architecture UtilityLib.LedFlash.rtl
--
-- Created:
--          by - warren.warren (positron)
--          at - 11:09:07 03/05/07
--
-- using Mentor Graphics HDL Designer(TM) 2006.1 (Build 72)
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity led_pulse is
   port( 
      clk    : in     std_logic;
      i      : in     std_logic;
      tick_i : in     std_logic;
      rst    : in     std_logic;
      o      : out    std_logic
   );

-- Declarations

end led_pulse ;


architecture rtl of led_pulse is

  signal count    : std_logic_vector(1 downto 0);
  signal count_en : std_logic;

begin

  stretch_counter : process (clk)
  begin
    if rising_edge(clk) then

      if (rst = '1') then
        count_en <= '0';
        count    <= (others => '0');

      else
        -- counter control
        if (i = '1') then
          count_en <= '1';

        elsif (count = "11") then
          count_en <= '0';

        end if;

        -- counter
        if (count_en = '1') then
          if (tick_i = '1') then
            count <= count + '1';
          end if;
        else
          count   <= (others => '0');
        end if;

      end if;
    end if;
  end process;

  o <= count_en;

end rtl;
