----------------------------------------------------------------------------------
-- Company:        CERN
-- Engineer:       Jens Dopke, Daniel Dobos
-- 
-- Create Date:    07:27:59 09/20/2007 
-- Design Name: 
-- Module Name:    level1_stretcher - Behavioral 
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

----------------------------------------------------------------------------
--PORT DECLARATION
----------------------------------------------------------------------------
entity level1_stretcher is
    Port ( clk_in         : in  STD_LOGIC;                       -- 40 MHz clock
	        rst_n_in       : in  STD_LOGIC;
           level1_trigger : in  STD_LOGIC;
           level1_accept  : in  STD_LOGIC_VECTOR (3 downto 0);
			  BCR            : in  STD_LOGIC;
			  ECR            : in  STD_LOGIC;
           write_event_id : out STD_LOGIC;
           BCID           : out STD_LOGIC_VECTOR (7 downto 0);
           LVL1ID         : out STD_LOGIC_VECTOR (3 downto 0));
end level1_stretcher;

architecture Behavioral of level1_stretcher is

----------------------------------------------------------------------------
--SIGNAL DECLARATION
----------------------------------------------------------------------------

  signal level1_intern        : STD_LOGIC := '0';
  signal counter_enabled      : STD_LOGIC := '0';
  signal BCR_intern           : STD_LOGIC := '0';
  signal ECR_intern           : STD_LOGIC := '0';
  signal level1_accept_count  : UNSIGNED (3 DOWNTO 0) := "0000";


----------------------------------------------------------------------------
--COMPONENT DECLARATION
----------------------------------------------------------------------------

component counter_4_bit is
  port(
	 clock           : in   STD_LOGIC;                    -- clock input
    reset           : in   STD_LOGIC;                    -- clock asynchronous reset 
    sync_reset      : in   STD_LOGIC;                    -- clock synchronous reset
    enable          : in   STD_LOGIC;                    -- count only if enabled
    rising_only     : in   STD_LOGIC;                    -- count only enable rising edges
    output          : out  STD_LOGIC_VECTOR (3 downto 0) -- 4-bit counter output	 
  );
end component counter_4_bit; 

component counter_8_bit is
  port(
	 clock           : in   STD_LOGIC;                     -- clock input
    reset           : in   STD_LOGIC;                     -- clock asynchronous reset 
    sync_reset      : in   STD_LOGIC;                     -- clock synchronous reset
    enable          : in   STD_LOGIC;                     -- count only if enabled
    rising_only     : in   STD_LOGIC;                     -- count only enable rising edges
    buffer_write    : in   STD_LOGIC;                     -- write counter to buffer
    output          : out  STD_LOGIC_VECTOR (7 downto 0); -- 8-bit counter output
    buffered_output : out  STD_LOGIC_VECTOR (7 downto 0)  -- buffered 8-bit counter output			
	 
  );
end component counter_8_bit; 

begin

--------------------------------------------------------------------------
--COMPONENT INSTANTIATION
--------------------------------------------------------------------------
BCID_counter : counter_8_bit
  port map(
    clock              => clk_in,
	 reset				  => '0',
    sync_reset         => BCR_intern,
	 enable		        => '1',
	 rising_only        => '0',
	 buffer_write		  => counter_enabled,
    output             => open,
	 buffered_output    => BCID
  );

LVLID_counter : counter_4_bit
  port map(
    clock              => clk_in,
	 reset				  => '0',
    sync_reset         => ECR_intern,
	 enable		        => counter_enabled,
	 rising_only        => '1',
    output             => LVL1ID
  );

--------------------------------------------------------------------------
-- SIGNALS
--------------------------------------------------------------------------
  BCR_intern <= (not rst_n_in) or BCR;
  ECR_intern <= (not rst_n_in) or ECR;

--------------------------------------------------------------------------
-- PROCESS DECLARATION
--------------------------------------------------------------------------
lvl1id_progress : process (
  rst_n_in,
  level1_trigger,
  level1_accept,
  clk_in
  )
begin
  if (rst_n_in = '0') then
    write_event_id <= '0';
	 level1_intern <= '0';
  elsif (clk_in'event AND clk_in = '1') then
    level1_intern <= level1_trigger;
	 if (level1_intern = '1') then
	   level1_accept_count <= UNSIGNED(level1_accept);
      counter_enabled <= level1_intern;
	 else
	   if (level1_accept_count = 0) then
	     counter_enabled <= '0';
		else
		  level1_accept_count <= level1_accept_count - "0001";
		  counter_enabled <= '1';
		end if;
	 end if;
	 write_event_id <= counter_enabled;
  end if;
end process;

end Behavioral;


