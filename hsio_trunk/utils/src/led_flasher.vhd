--
-- VHDL Architecture UtilityLib.LedFlash.rtl
--
-- Created:
--          by - warren.warren (positron)
--          at - 11:09:07 03/05/07
--
-- using Mentor Graphics HDL Designer(TM) 2006.1 (Build 72)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

entity led_flasher is
   generic( 
      FLASH_PERIOD_BITS : integer := 2;
      SIM_MODE          : integer := 0
   );
   port( 
      clk         : in     std_logic;
      rst         : in     std_logic;
      tick_10hz_i : in     std_logic;
      flash_out   : out    std_logic
   );

-- Declarations

end led_flasher ;

--
architecture rtl of led_flasher is
  signal count : std_logic_vector(FLASH_PERIOD_BITS-1 downto 0);

begin
  flash_counter : process (clk)
  begin
    if rising_edge(clk) then

      if (rst = '1') then
        count <= (others => '1');

      else
        if (tick_10hz_i = '1') then
        count <= count + '1';
        end if;
      end if;
    end if;
  end process;

  
  flash_out <= count(FLASH_PERIOD_BITS-1) when SIM_MODE=0 else count(1);

end architecture rtl;
