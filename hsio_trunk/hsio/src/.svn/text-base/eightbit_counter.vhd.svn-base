----------------------------------------------------------------------------------
-- Company: 		 CERN	
-- Engineer: 		 Jens Dopke, Daniel Dobos
-- 
-- Create Date:    19:02:48 09/16/2007 
-- Design Name: 
-- Module Name:    8-bit_counter - Behavioral 
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

entity counter_8_bit is
  Port ( clock           : in  STD_LOGIC;                     -- clock input
         reset           : in  STD_LOGIC;                     -- clock asynchronous reset 
         sync_reset      : in  STD_LOGIC;                     -- clock synchronous reset
         enable          : in  STD_LOGIC;                     -- count only if enabled
         rising_only     : in  STD_LOGIC;                     -- count only rising edges
			buffer_write    : in  STD_LOGIC;                     -- write counter to buffer
         output          : out STD_LOGIC_VECTOR (7 downto 0); -- 8-bit counter output
         buffered_output : out STD_LOGIC_VECTOR (7 downto 0)  -- buffered 8-bit counter output			
		  );
end counter_8_bit;

architecture Behavioral of counter_8_bit is

	signal counter             : STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal reset_value         : STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal counter_buffer      : STD_LOGIC_VECTOR (7 DOWNTO 0);
   signal enable_buffer       : STD_LOGIC := '0';
   signal buffer_write_buffer : STD_LOGIC := '0';
	
begin

  output <= counter;

  -- the starting value of the BCID counter may have to be
  -- set to strange value to get correct BCID offset
  -- Is also dependant on the BCID delay specified in the
  -- ROD configuration file $SCTDAQ_ROD_CONFIGURATION_PATH
  -- look for <BCIDoffset> tags inthe <rod> section
  -- This value should work for BCID offset of 13, which was
  -- the value used in the SctRodDaq 07/04/09
  reset_value <= "11111110";
  
counter_process : process (
  clock,
  reset
)
begin
  if (reset = '1') then                   -- asynchronous reset
	 counter <= reset_value;
	 buffered_output <= reset_value;
  elsif (rising_edge(clock)) then
    enable_buffer <= enable;
	 buffer_write_buffer <= buffer_write;
	 if (sync_reset = '1') then            -- synchronous reset
		counter <= reset_value;
		buffered_output <= reset_value;
	 elsif (enable = '1' and (enable_buffer = '0' or rising_only = '0')) then
	   counter <= (counter + "01");
	 end if;			
    if (buffer_write = '1') then
      buffered_output <= (counter + "01");
    end if;
  end if;
end process counter_process;

end Behavioral;



