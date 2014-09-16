----------------------------------------------------------------------------
-- Freiburg
-- Author: Tom Barber
-- Description:
-- The sct_sim_control module generates data packets emulating
-- the output of the ABC-next chip
--
-- At the moment I am going on:
-- 96 input/output links
-- each link contains 10 chips
-- each chip has 128 strips
-- Data format as per "Project Specification ABC-N ASIC, Version: V1.3.1"
----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;


----------------------------------------------------------------------------
--PORT DECLARATION
----------------------------------------------------------------------------

entity sct_sim_control is
  port(
    clk_in         : in  std_logic; -- 40 MHz clock
    rst_n_in       : in  std_logic; -- Powerup global reset
    inlinks        : in  std_logic_vector(95 DOWNTO 0); -- Real Input links
    config_in      : in  std_logic_vector(31 DOWNTO 0); -- configuration word for the sim_module
    level1_trigger : in  std_logic; -- Level 1 Trigger Input
    ecr_in         : in  std_logic; -- ECR Input
    bcr_in         : in  std_logic; -- BCR Input
    outlinks       : out std_logic_vector(95 DOWNTO 0) -- output for real or encoded data
    );
end sct_sim_control; 

architecture rtl of sct_sim_control is

----------------------------------------------------------------------------
--SIGNAL DECLARATION
----------------------------------------------------------------------------
constant n_modules : integer := 1;  -- the number of unique simulation engines (different data streams)
constant n_links   : integer := 96;  -- this gives the number of output links (also change outlinks above...)

type   rnd_seed_array is array (0 to 15) of std_logic_vector(7 downto 0); --
signal rnd_seed : rnd_seed_array;

signal l1_trigger_count     : std_logic_vector (3 downto 0); -- count the number of L1  
signal bc_count             : std_logic_vector (7 downto 0); -- count the number of BC
signal link_data            : std_logic_vector ((n_modules-1) downto 0) := (others => '0'); -- the data links
--signal write_event_id       : STD_LOGIC := '0';

----------------------------------------------------------------------------
--COMPONENT DECLARATION
----------------------------------------------------------------------------

component sct_sim_module is
  port(
    clk_in                 : in  std_logic; -- 40 MHz clock
    rst_n_in               : in  std_logic; -- Powerup global reset
	 rnd_seed               : in  std_logic_vector( 7 DOWNTO 0);
    config_in              : in  std_logic_vector( 31 DOWNTO 0); -- configuration word for the sim_module
	 level1_trigger         : in  std_logic; -- Level 1 Trigger Input
	 l1_trigger_count       : in std_logic_vector (3 downto 0); -- count the number of L1
	 bc_count   	         : in std_logic_vector (7 downto 0); -- count the number of BC
	 outlink                : out std_logic -- just one output link for the upgrade
    );
end component ; 



component level1_stretcher is
  port( 
    clk_in         : in  STD_LOGIC;                       -- 40 MHz clock
	 rst_n_in       : in  STD_LOGIC;
    level1_trigger : in  STD_LOGIC;
    level1_accept  : in  STD_LOGIC_VECTOR (3 downto 0);
	 BCR            : in  STD_LOGIC;
	 ECR            : in  STD_LOGIC;
    write_event_id : out STD_LOGIC;
    BCID           : out STD_LOGIC_VECTOR (7 downto 0);
    LVL1ID         : out STD_LOGIC_VECTOR (3 downto 0)
  );
end component level1_stretcher;



BEGIN  --  Main Body of VHDL code

----------------------------------------------------------------------------
--COMPONENT INSTANTIATION
----------------------------------------------------------------------------

-- Random seeds for strip number generation (add more if needed)
rnd_seed(0)  <= X"00";
rnd_seed(1)  <= X"01";
rnd_seed(2)  <= X"02";
rnd_seed(3)  <= X"03";
rnd_seed(4)  <= X"04";
rnd_seed(5)  <= X"05";
rnd_seed(6)  <= X"06";
rnd_seed(7)  <= X"07";
rnd_seed(8)  <= X"08";
rnd_seed(9)  <= X"09";
rnd_seed(10) <= X"0A";
rnd_seed(11) <= X"0B";
rnd_seed(12) <= X"0C";
rnd_seed(13) <= X"0D";
rnd_seed(14) <= X"0E";
rnd_seed(15) <= X"0F";
--------------------------------

-- Generate the specified number of engines
sim : for j in 0 to (n_modules - 1) generate
  U1 : sct_sim_module
   port map(
      clk_in         => clk_in,
      rst_n_in       => rst_n_in,
      rnd_seed       => rnd_seed(j),
      config_in      => config_in,
      level1_trigger => level1_trigger,
      l1_trigger_count => l1_trigger_count,
      bc_count         => bc_count,
      outlink    => link_data(j)
      );
end generate;


level1_handler : level1_stretcher
  port map(
    clk_in         => clk_in,
	 rst_n_in       => rst_n_in,
    level1_trigger => level1_trigger,
	 level1_accept => (others => '0'),  -- set to zero for now...
	 BCR            => bcr_in,
	 ECR            => ecr_in,
    write_event_id => open,
    BCID           => bc_count,
    LVL1ID         => l1_trigger_count
  );


--------------------------------------------------------------------------
-- SIGNALS
--------------------------------------------------------------------------

--------------------------------------------------------------------------
-- PROCESS DECLARATION
--------------------------------------------------------------------------

-- put the mux in here??

--some_process : process (
--  rst_n_in,
--  clk_in
--  )
--begin
--  if (rst_n_in = '0' or reset_cnt = '1') then 
--  elsif (clk_in'event AND clk_in = '1') then
--  end if;
--end process;

output_mux : process (
  config_in,
  link_data
)
begin
--Check whether to activate the simulator based on the config register
  if (config_in(0) = '0') then
    outlinks  <= inlinks;
  else
-- Link the engines to the output links
-- data stream will repeat every n_modules
    for i in (n_links-1) downto 0 loop
	     outlinks(i) <= link_data( (i mod n_modules) );
    end loop;
  end if;
end process;



end rtl;
