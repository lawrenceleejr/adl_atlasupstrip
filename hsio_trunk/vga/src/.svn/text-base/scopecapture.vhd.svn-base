----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:59:52 09/14/2012 
-- Design Name: 
-- Module Name:    scopecapture - Behavioral 
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
library vga;
use vga.pkg_vga.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity scopecapture is
  port (
    clock          : in  std_logic;
    reset          : in  std_logic;
    trigger        : in  std_logic;
    prime          : in  std_logic;
    data           : in  std_logic;
    capture_data_o : out std_logic_vector(scope_width-1 downto 0)
    );
end scopecapture;

architecture Behavioral of scopecapture is

  signal buf_pointer : integer;         -- define counters
  signal data_buffer : std_logic_vector(1 downto 0);

  type scope_state_type is (idle, writing, full);  --type of state machine.
  signal current_s, next_s : scope_state_type;  --current and next state declaration.

begin

-- Finite State Machine (very simple)
  process (current_s, trigger, buf_pointer, prime)
  begin
    case current_s is
      when idle =>
        if(trigger = '0') then
          next_s <= idle;
        else
          next_s <= writing;
        end if;

      when writing =>
        if (buf_pointer >= scope_width-1) then
          next_s <= full;
        else
          next_s <= writing;
        end if;

      when full =>
        if (prime = '1') then
          next_s <= idle;
        else
          next_s <= full;
        end if;

    end case;
  end process;


  cycle : process(clock, reset)

  begin
    if (reset = '1') then
      capture_data_o                  <= (others => '0');
      current_s                       <= idle;
      buf_pointer                     <= 0;
    else
      if (clock'event and clock = '1') then
        if (current_s = writing) then
          capture_data_o(buf_pointer) <= data_buffer(0);
          buf_pointer                 <= buf_pointer + 1;
        else
          buf_pointer                 <= 0;
        end if;
        current_s                     <= next_s;  --state change.

        data_buffer(0) <= data_buffer(1);
        data_buffer(1) <= data;
        
      end if;			
    end if;
  end process;

end Behavioral;

