----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:52:06 11/08/2010 
-- Design Name: 
-- Module Name:    hsio_proc_wrapper - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:  This file mirrors the ports of hsio/xps/hsio_proc_wrapper.vhd but does not
--                     instantiate the actual core.
--                     Because the XPS stuff is handled specially in ISE, it's easier to do it this
--                      way than use a generic flag.
--
-- Dependencies:  None!
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

library hsio;
use hsio.pkg_hsio_globals.all;

entity hsio_proc_wrapper is
	generic( 
		SIM_MODE : integer := 0
	);

	port (
		clk_sys_clk_pin : in std_logic;
		rst_sys_rst_pin : in std_logic;

		gpio_hex_input : in std_logic_vector(3 downto 0);

		DDR_DQ :    inout std_logic_vector(15 downto 0);
		DDR_LDQS :  inout std_logic;
		DDR_UDQS :  inout std_logic;
		DDR_BA :    out std_logic_vector(1 downto 0);
		DDR_ADDR :  out std_logic_vector(12 downto 0);
		DDR_CK :    out std_logic;
		DDR_CLKN :  out std_logic;
		DDR_CS_n :  out std_logic;
		DDR_CE :    out std_logic;
		DDR_RAS_n : out std_logic;
		DDR_CAS_n : out std_logic;
		DDR_WE_n :  out std_logic;
		DDR_LDM :   out std_logic;
		DDR_UDM :   out std_logic;

		mpmc_Idelayctrl_Rdy : out std_logic;
		mpmc_InitDone : out std_logic;

		clock_LOCKED : out std_logic
	);
end hsio_proc_wrapper;

architecture Behavioral of hsio_proc_wrapper is

begin
    -- Assign outputs
	DDR_DQ <= (others => '0');
	DDR_LDQS <= '0';
	DDR_UDQS <= '0';

	DDR_BA <= "00";
	DDR_ADDR <= (others => '0');
	DDR_CK <= '0';
	DDR_CLKN <= '0';
	DDR_CS_n <= '0';
	DDR_CE <= '0';
	DDR_RAS_n <= '0';
	DDR_CAS_n <= '0';
	DDR_WE_n <= '0';
	DDR_LDM <= '0';
	DDR_UDM <= '0';

	mpmc_Idelayctrl_Rdy <= '0';
	mpmc_InitDone <= '0';

	clock_LOCKED <= '0';
end Behavioral;
