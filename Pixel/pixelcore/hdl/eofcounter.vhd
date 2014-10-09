--------------------------------------------------------------------------------
--     This file is owned and controlled by Xilinx and must be used           --
--     solely for design, simulation, implementation and creation of          --
--     design files limited to Xilinx devices or technologies. Use            --
--     with non-Xilinx devices or technologies is expressly prohibited        --
--     and immediately terminates your license.                               --
--                                                                            --
--     XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"          --
--     SOLELY FOR USE IN DEVELOPING PROGRAMS AND SOLUTIONS FOR                --
--     XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION        --
--     AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE, APPLICATION            --
--     OR STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS              --
--     IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,                --
--     AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE       --
--     FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY               --
--     WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE                --
--     IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR         --
--     REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF        --
--     INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS        --
--     FOR A PARTICULAR PURPOSE.                                              --
--                                                                            --
--     Xilinx products are not intended for use in life support               --
--     appliances, devices, or systems. Use in such applications are          --
--     expressly prohibited.                                                  --
--                                                                            --
--     (c) Copyright 1995-2007 Xilinx, Inc.                                   --
--     All rights reserved.                                                   --
--------------------------------------------------------------------------------
-- You must compile the wrapper file eofcounter.vhd when simulating
-- the core, eofcounter. When compiling the wrapper file, be sure to
-- reference the XilinxCoreLib VHDL simulation library. For detailed
-- instructions, please refer to the "CORE Generator Help".

-- The synthesis directives "translate_off/translate_on" specified
-- below are supported by Xilinx, Mentor Graphics and Synplicity
-- synthesis tools. Ensure they are correct for your synthesis tool(s).

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
-- synthesis translate_off
Library XilinxCoreLib;
-- synthesis translate_on
ENTITY eofcounter IS
	port (
	clk: IN std_logic;
	up: IN std_logic;
	ce: IN std_logic;
	aclr: IN std_logic;
	q_thresh0: OUT std_logic;
	q: OUT std_logic_VECTOR(15 downto 0));
END eofcounter;

ARCHITECTURE eofcounter_a OF eofcounter IS
-- synthesis translate_off
component wrapped_eofcounter
	port (
	clk: IN std_logic;
	up: IN std_logic;
	ce: IN std_logic;
	aclr: IN std_logic;
	q_thresh0: OUT std_logic;
	q: OUT std_logic_VECTOR(15 downto 0));
end component;

-- Configuration specification 
	for all : wrapped_eofcounter use entity XilinxCoreLib.c_counter_binary_v8_0(behavioral)
		generic map(
			c_count_mode => 2,
			c_has_aset => 0,
			c_load_enable => 0,
			c_load_low => 0,
			c_count_to => "1",
			c_sync_priority => 1,
			c_has_iv => 0,
			c_has_sclr => 0,
			c_restrict_count => 0,
			c_width => 16,
			c_has_q_thresh1 => 0,
			c_enable_rlocs => 0,
			c_has_q_thresh0 => 1,
			c_thresh1_value => "0",
			c_has_load => 0,
			c_has_up => 1,
			c_thresh_early => 1,
			c_has_thresh1 => 0,
			c_has_thresh0 => 0,
			c_ainit_val => "0",
			c_has_ce => 1,
			c_pipe_stages => 0,
			c_has_aclr => 1,
			c_sync_enable => 1,
			c_has_ainit => 0,
			c_sinit_val => "0",
			c_has_sset => 0,
			c_has_sinit => 0,
			c_count_by => "1",
			c_has_l => 0,
			c_thresh0_value => "0");
-- synthesis translate_on
BEGIN
-- synthesis translate_off
U0 : wrapped_eofcounter
		port map (
			clk => clk,
			up => up,
			ce => ce,
			aclr => aclr,
			q_thresh0 => q_thresh0,
			q => q);
-- synthesis translate_on

END eofcounter_a;

