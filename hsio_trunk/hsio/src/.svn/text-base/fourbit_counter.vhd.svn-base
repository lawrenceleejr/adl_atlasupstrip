----------------------------------------------------------------------------------
-- Company: 		 CERN	
-- Engineer: 		 Jens Dopke, Daniel Dobos
-- 
-- Create Date:    19:02:48 09/16/2007 
-- Design Name: 
-- Module Name:    4-bit_counter - Behavioral 
-- Project Name:   ATLAS Pixel Simulator
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
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity counter_4_bit is
  Port ( clock       : in  STD_LOGIC;                     -- clock input
         reset       : in  STD_LOGIC;                     -- clock asynchronous reset 
         sync_reset  : in  STD_LOGIC;                     -- clock synchronous reset
         enable      : in  STD_LOGIC;                     -- count only if enabled
         rising_only : in  STD_LOGIC;                     -- count only rising edges
         output      : out STD_LOGIC_VECTOR (3 downto 0)  -- 4-bit counter output
		  );
end counter_4_bit;

architecture Behavioral of counter_4_bit is

	signal counter        : STD_LOGIC_VECTOR (3 DOWNTO 0);
	signal counter_buffer : STD_LOGIC_VECTOR (3 DOWNTO 0);
   signal enable_buffer  : STD_LOGIC := '0';
begin

  output <= counter;
  
counter_process : process (
  clock,
  reset
)
begin
  if (reset = '1') then           -- asynchronous reset
--	 counter <= "1111";
    counter <= "0000"; -- set funny initial value to get correct l1
  elsif (rising_edge(clock)) then
    enable_buffer <= enable;
	 if (sync_reset = '1') then    -- synchronous reset
--		counter <= "1111";
      counter <= "0000"; -- set funny initial value to get correct l1
	 elsif (enable = '1' and (enable_buffer = '0' or rising_only = '0')) then
	   counter <= (counter + "01");
	 end if;			
  end if;
end process counter_process;

end Behavioral;



