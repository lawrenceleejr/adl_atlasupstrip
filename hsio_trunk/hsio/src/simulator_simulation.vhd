--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:51:49 11/24/2010
-- Design Name:   
-- Module Name:   C:/Users/tbarber/Documents/hep/silicon/SCT Upgrade/fpga/Tomulator/source//simulator_simulation.vhd
-- Project Name:  Tomulator
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: sct_sim_control
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

entity simulator_simulation is
end simulator_simulation;

architecture behavior of simulator_simulation is

  -- Component Declaration for the Unit Under Test (UUT)

  component sct_sim_control
    port(
      clk_in         : in  std_logic;
      rst_n_in       : in  std_logic;
      inlinks        : in  std_logic_vector(95 downto 0);
      config_in      : in  std_logic_vector(31 downto 0);
      level1_trigger : in  std_logic;
      ecr_in         : in  std_logic;
      bcr_in         : in  std_logic;
      outlinks       : out std_logic_vector(95 downto 0)
      );
  end component;


  --Inputs
  signal clk_in         : std_logic                     := '0';
  signal rst_n_in       : std_logic                     := '0';
  signal inlinks        : std_logic_vector(95 downto 0) := (others => '0');
  signal config_in      : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
  signal level1_trigger : std_logic                     := '0';
  signal ecr_in         : std_logic                     := '0';
  signal bcr_in         : std_logic                     := '0';

  --Outputs
  signal outlinks : std_logic_vector(95 downto 0);

  -- Clock period definitions
  constant clk_in_period   : time := 25 ns;
  -- Trigger period
  constant levelone_period : time := 10 us;
  -- BCR Signal, should be 11kHz
  constant orbit_period    : time := 91 us;
  -- ECR Signals, typically 1 per second or so
  constant ecr_period      : time := 1 ms;

begin

  -- Instantiate the Unit Under Test (UUT)
  uut : sct_sim_control port map (
    clk_in         => clk_in,
    rst_n_in       => rst_n_in,
    inlinks        => inlinks,
    config_in      => config_in,
    level1_trigger => level1_trigger,
    ecr_in         => ecr_in,
    bcr_in         => bcr_in,
    outlinks       => outlinks
    );

  -- Clock process definitions
  clk_in_process : process
  begin
    clk_in <= '0';
    wait for clk_in_period/2;
    clk_in <= '1';
    wait for clk_in_period/2;
  end process;

  -- A L1 trigger
  trigger_process : process
  begin
    level1_trigger <= '0';
    wait for levelone_period;
    level1_trigger <= '1';
    wait for clk_in_period;
  end process;

  -- BCR
  bcr_process : process
  begin
    bcr_in <= '0';
    wait for orbit_period;
    bcr_in <= '1';
    wait for clk_in_period;
  end process;

-- BCR
  ecr_process : process
  begin
    ecr_in <= '0';
    wait for ecr_period;
    ecr_in <= '1';
    wait for clk_in_period;
  end process;


  -- Stimulus process
  stim_proc : process
  begin
    -- hold reset state for 100 ns.
    -- things activate on a high reset
    rst_n_in <= '0';
    wait for 100 ns;
    rst_n_in <= '1';


    wait for levelone_period * 0.5;

-- Configuration bits
--  ------------------
--  
--  0: Activation (0 - route input to output, 1 - ignore input, generate random events)
--  1: Send only clock/2
--  2: Send config readback
--  3-7: custom header
--  8-9: hit prob
-- 10-11:err prob
-- 12-18:chipnum
-- 19-25: hitnum
-- 26-27: hitmap
-- 28-29: cluster size
-- 30-31: Link 0 error probability
-- an example:
--              config_in <=
--                   "00"               -- Probability of bit flips: ( 00 = none, 01 = 1 in 4, 10 = 1 in 1^9, 11 = 1^19 )
--                 & "00"               -- number of hits in each cluster
--                 & "00"               -- hitmap ( 00 = 011, 01 = 01X, 10 = X1X, 11 = XXX )
--                 & "0000000"          -- number of hits per chip
--                 & "1000000"          -- number of chips
--                 & "00"               -- error probability
--                 & "01"               -- hit probability
--                 & "00000"            -- custom header
--                 & "0"                -- config readback
--                      & "1"           -- clock/2 mode
--                      & "1";          -- activation

-- configurations to test
-- Ones with a smiley face have been tested and verified! :)
-- config_in <= "00000000000000000000000000000001";  -- basic operation, one hit per chip :)
--              wait for levelone_period;
--              config_in <= "00000000000000000000000000000011";  -- clock by two mode :)
--              wait for levelone_period;
--              config_in <= "00000000000000000000000000000101";  -- config readback mode :)
--              wait for levelone_period;
--              config_in <= "00000000000000000000000010101001";  -- custom header mode :)
--              wait for levelone_period;               
--              config_in <= "00000000000000000000000100000001";  -- hit probability 50% :)
--              wait for levelone_period;
--              config_in <= "00000000000000000000001000000001";  -- hit probability 1 in 128 :)
--              wait for levelone_period;
--              config_in <= "00000000000000000000001100000001";  -- all empty events :)
--              wait for levelone_period;               
--              config_in <= "00000000000000000000010000000001";  -- some errors (1 in 128) :)
--              wait for levelone_period * 2;  -- needs 2 triggers to see errors
--              config_in <= "00000000000000000000100000000001";  -- 50% error/hit :)
--              wait for levelone_period;
--              config_in <= "00000000000000000000110000000001";  -- all errors :)
--              wait for levelone_period;
--              config_in <= "00000000000000001001000000000001";  -- 10 chips per data stream (numbered 0-9) :)
--              wait for levelone_period;
--              config_in <= "00000000000110000000000000000001";  -- 1 chip, four hits per chip :)
--              wait for levelone_period;
--              config_in <= "00001100000000000000000000000001";  -- XXX any hit mode (also 000) :)
--              wait for levelone_period;
--              config_in <= "00110000000000000000000000000001";  -- 1 chip, 1 cluster, size 4 :)
--              wait for levelone_period;               
--              config_in <= "01000000000000000000000000000001";  -- bit flips at rate of 1 in 2^9 :)
--              wait for levelone_period * 2;           
    -------------------------------------------------------------------------------------------------
    config_in <= "11010100000010001100100100000001";  -- combination of different settings
    wait for levelone_period;           -- 1 hit every 2 triggers
                                        -- 1 error every 2 hits
                                        -- 5 chips have hits
                                        -- 2 strips with hits for every chip
                                        -- cluster size of 2
                                        -- 01X time bins
                                        -- 1 bit flip per 2^19 clock ticks
--      --------------------------------------------------------------------------------------------------
--              config_in <= "00110011111111111111000000000001";  -- the largest possible event (13 ms to of data!)
-- wait for levelone_period * 1;        -- not possible with actual hardware

    
    wait;
  end process;

END;
