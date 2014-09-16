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

use work.pkg_hsio_globals.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

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

component hsioProc
	port(
		fpga_0_clk_1_sys_clk_pin : in std_logic;
		fpga_0_rst_1_sys_rst_pin : in std_logic;

		xps_gpio_0_GPIO2_IO_I_pin : in std_logic_vector(0 to 3);

		mpmc_0_DDR_DQ :           inout std_logic_vector(15 downto 0);
		mpmc_0_DDR_DQS :          inout std_logic_vector(1 downto 0);      
		mpmc_0_DDR_BankAddr_pin : out std_logic_vector(1 downto 0);
		mpmc_0_DDR_Addr_pin :     out std_logic_vector(12 downto 0);
		mpmc_0_DDR_Clk_pin :      out std_logic_vector(0 to 0);
		mpmc_0_DDR_Clk_n_pin :    out std_logic_vector(0 to 0);
		mpmc_0_DDR_CS_n_pin :     out std_logic_vector(0 to 0);
		mpmc_0_DDR_CE_pin :       out std_logic_vector(0 to 0);
		mpmc_0_DDR_RAS_n_pin :    out std_logic;
		mpmc_0_DDR_CAS_n_pin :    out std_logic;
		mpmc_0_DDR_WE_n_pin :     out std_logic;
		mpmc_0_DDR_DM_pin :       out std_logic_vector(1 downto 0);

		mpmc_0_MPMC_Idelayctrl_Rdy_O_pin :    out std_logic;
		mpmc_0_MPMC_InitDone_pin :            out std_logic;

		clock_generator_0_LOCKED_pin :        out std_logic
		);
	end component;

component cg_brfifo_1kx18
	port (
		rst: IN std_logic;
		wr_clk: IN std_logic;
		rd_clk: IN std_logic;
		din: IN std_logic_VECTOR(17 downto 0);
		wr_en: IN std_logic;
		rd_en: IN std_logic;
		dout: OUT std_logic_VECTOR(17 downto 0);
		full: OUT std_logic;
		almost_full: OUT std_logic;
		overflow: OUT std_logic;
		empty: OUT std_logic;
		underflow: OUT std_logic;
		wr_data_count: OUT std_logic_VECTOR(3 downto 0);
		prog_full: OUT std_logic);
end component;

attribute box_type : string;
attribute box_type of hsioProc : component is "user_black_box";

-- Convert to arrays for port map
signal ddr_clk_sig : std_logic_vector(0 to 0);
signal ddr_clk_n_sig : std_logic_vector(0 to 0);

signal ddr_cs_n_sig : std_logic_vector(0 to 0);
signal ddr_ce_sig : std_logic_vector(0 to 0);

signal ddr_dm_sig : std_logic_vector(0 to 1);
signal ddr_dqs_sig : std_logic_vector(0 to 1);

begin

	Inst_hsioProc: hsioProc PORT MAP(
		fpga_0_clk_1_sys_clk_pin => clk_sys_clk_pin,
		fpga_0_rst_1_sys_rst_pin => rst_sys_rst_pin,

		xps_gpio_0_GPIO2_IO_I_pin => gpio_hex_input,

		mpmc_0_DDR_DQ => DDR_DQ,
		mpmc_0_DDR_BankAddr_pin => DDR_BA,
		mpmc_0_DDR_Addr_pin => DDR_ADDR,
		mpmc_0_DDR_Clk_pin => ddr_clk_sig,
		mpmc_0_DDR_Clk_n_pin => ddr_clk_n_sig,
		mpmc_0_DDR_CS_n_pin => ddr_cs_n_sig,
		mpmc_0_DDR_CE_pin => ddr_ce_sig,
		mpmc_0_DDR_RAS_n_pin => DDR_RAS_n,
		mpmc_0_DDR_CAS_n_pin => DDR_CAS_n,
		mpmc_0_DDR_WE_n_pin => DDR_WE_n,
		mpmc_0_DDR_DM_pin => ddr_dm_sig,
		mpmc_0_DDR_DQS => ddr_dqs_sig,

		mpmc_0_MPMC_Idelayctrl_Rdy_O_pin => mpmc_Idelayctrl_Rdy,
		mpmc_0_MPMC_InitDone_pin => mpmc_InitDone,

		clock_generator_0_LOCKED_pin => clock_LOCKED
	);

	DDR_CK <= ddr_clk_sig(0);
	DDR_CLKN <= ddr_clk_n_sig(0);
	DDR_CS_N <= ddr_cs_n_sig(0);
	DDR_CE <= ddr_ce_sig(0);

	DDR_LDM <= ddr_dm_sig(1);   -- LDM Input mask for write data 0-7
	DDR_UDM <= ddr_dm_sig(0);   -- UDM Input mask for write data 8-15

	DDR_LDQS <= ddr_dqs_sig(1); -- LDQS Data strobe for data 0-7
	DDR_UDQS <= ddr_dqs_sig(0); -- UDQS Data strobe for data 8-15

end Behavioral;
