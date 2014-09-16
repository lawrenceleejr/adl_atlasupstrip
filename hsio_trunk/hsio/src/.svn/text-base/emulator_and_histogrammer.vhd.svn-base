--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:51:49 11/24/2010
-- Design Name:   
-- Module Name:   C:/Users/tbarber/Documents/hep/silicon/SCT Upgrade/fpga/Tomulator/source//emulator_and_histogrammer.vhd
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
use ieee.numeric_std.all;

use std.textio.all;

--use ieee.std_logic_textio.write;

library parser;
use parser.all;
  
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

entity sct_sim_histo_tb is
end sct_sim_histo_tb;

architecture behavior of sct_sim_histo_tb is

  constant number_of_tests : integer := 12;
  -- Clock period definitions
  constant clk_in_period   : time    := 25 ns;
  -- Trigger period
  constant levelone_period : time    := 30 us;
-- constant levelone_period : time := 15 ms;
  -- Number of triggers
  constant n_triggers      : integer := 100;
  -- BCR Signal, should be 11kHz
  constant orbit_period    : time    := 91 us;
  -- ECR Signals, typically 1 per second or so
  constant ecr_period      : time    := 1 ms;


  -- Component Declaration for the Unit Under Test (emulator)

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

  component parser_tom_top
    generic(
      STREAM_ID       :     integer := 0;
      histogram_width :     integer := 16
      );
    port(
      rst             : in  std_logic;  -- HSIO switch2, code_reload#
      en              : in  std_logic;
      abcdata_i       : in  std_logic;
      start_hstro_i   : in  std_logic;
      reset_hst_i     : in  std_logic;
      debug_mode_i    : in  std_logic;
      ll_sof_o        : out std_logic;
      ll_eof_o        : out std_logic;
      ll_src_rdy_o    : out std_logic;
      ll_dst_rdy_i    : in  std_logic;
      ll_data_o       : out std_logic_vector (15 downto 0);
      ll_data_len_o   : out std_logic_vector (15 downto 0);
      clk             : in  std_logic
      );
  end component;

  --Inputs
  signal clk_in    : std_logic                     := '0';
  signal reset     : std_logic                     := '0';
  signal inlinks   : std_logic_vector(95 downto 0) := (others => '0');
  signal config_in : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";


  type tom_array is array (1 to number_of_tests) of std_logic_vector(31 downto 0);
  signal config_array : tom_array;      -- array of test signals

  signal level1_trigger : std_logic := '0';
  signal ecr_in         : std_logic := '0';
  signal bcr_in         : std_logic := '0';

  -- Histogram outputs
  signal start_hstro : std_logic := '0';
  signal ll_sof      : std_logic;
  signal ll_eof      : std_logic;
  signal ll_src_rdy  : std_logic;
  signal ll_data     : std_logic_vector (15 downto 0);
  signal ll_data_len : std_logic_vector (15 downto 0);
  signal ll_dst_rdy  : std_logic := '0';
  signal histo_reset : std_logic := '0';


  --Outputs
  signal outlinks : std_logic_vector(95 downto 0);


  signal reset_not : std_logic;
  
begin

  reset_not <= not(reset);

  
  -- Instantiate the Unit Under Test (emulator)
  emulator : sct_sim_control port map (
    clk_in         => clk_in,
    rst_n_in       => reset_not,
    inlinks        => inlinks,
    config_in      => config_in,
    level1_trigger => level1_trigger,
    ecr_in         => ecr_in,
    bcr_in         => bcr_in,
    outlinks       => outlinks
    );

  -- And a hisotgrammer
  parser : parser_tom_top
    generic map (
      STREAM_ID       => 255,
      histogram_width => 16
      )
    port map (
      rst             => reset,  --rst_n_in,  -- HSIO switch2, code_reload#
      en              => '1',
      abcdata_i       => outlinks(0),   -- just connect one of the outputs
      start_hstro_i   => start_hstro,
      reset_hst_i     => histo_reset,
      debug_mode_i    => '0',
      ll_sof_o        => ll_sof,
      ll_eof_o        => ll_eof,
      ll_src_rdy_o    => ll_src_rdy,
      ll_dst_rdy_i    => ll_dst_rdy,
      ll_data_o       => ll_data,
      ll_data_len_o   => ll_data_len,
      clk             => clk_in
      );


  -- Clock process definitions
  clk_in_process : process
  begin
    clk_in <= '0';
    wait for clk_in_period/2;
    clk_in <= '1';
    wait for clk_in_period/2;
  end process;

--  -- A L1 trigger
--      trigger_process : process
--      begin
--         level1_trigger <= '0';
--              wait for levelone_period;
--              level1_trigger <= '1';
--              wait for clk_in_period;
--      end process;
--
--   -- BCR
--      bcr_process : process
--      begin
--         bcr_in <= '0';
--              wait for orbit_period;
--         bcr_in <= '1';
--              wait for clk_in_period;
--      end process;
--
---- ECR
--      ecr_process : process
--      begin
--         ecr_in <= '0';
--              wait for ecr_period;
--         ecr_in <= '1';
--              wait for clk_in_period;
--      end process;


  -- Stimulus process
  stim_proc : process
  begin

-- Set up event types

    config_array(1) <= "00000000000000001001000000000001";  -- 10 chips per data stream (numbered 0-9) :)
    config_array(2) <= "00000000000000001001000100000001";  -- 50 % empty
    config_array(3) <= "00000000000000001001001000000001";  -- 1 in 128 hit
    config_array(4) <= "00000000000000001001001100000001";  -- all empty events :)
    config_array(5) <= "00000000000110001001000000000001";  -- 1 chip, four hits per chip :)             

    config_array(6) <= "00000000000000001001010000000001";  -- some errors (1 in 128) :)
    config_array(7) <= "00000000000000010010100000000001";  -- 50% error/hit :)
    config_array(8) <= "00000000000000010010110000000001";  -- all errors :)

    config_array(9)  <= "00000000000000001001000000000101";  -- config readback mode :)
    config_array(10) <= "10000000000000001001000000000001";  -- 10 chips per data stream + bit flips
    config_array(11) <= "01000000000000001001000000000001";  -- 10 chips per data stream + bit flips
    config_array(12) <= "11000000000000001001000000000001";  -- 10 chips per data stream + bit flips


    -- hold reset state for 100 ns.
    -- things activate on a high reset

    reset <= '0';
    wait for clk_in_period;
    reset <= '1';
    wait for clk_in_period;
    reset <= '0';

    level1_trigger <= '0';

    -- keep this high, whatever it is
    ll_dst_rdy <= '1';


    -- reset the histogram
    wait for clk_in_period * 10;
    histo_reset <= '1';
    wait for clk_in_period;
    histo_reset <= '0';

    -- Does this mean readout the histogram???
    wait for 50 us;
    start_hstro <= '1';
    wait for clk_in_period;
    start_hstro <= '0';
    wait for 50 us;

    wait for clk_in_period * 10;

    -- Loop over number of trigger configurations
    for c in 1 to number_of_tests loop

      wait for 1 us;

      -- set the config of the emulator
      config_in <= config_array(c);

      wait for 1 us;

      -- Set a load of triggers
      for n in 1 to n_triggers loop

        level1_trigger <= '1';
        wait for clk_in_period;
        level1_trigger <= '0';
        wait for levelone_period;

      end loop;

      -- Then the emulator should generate something
      wait for clk_in_period * 100;

      -- Readout histogram
      start_hstro <= '1';
      wait for clk_in_period;
      start_hstro <= '0';

      -- wait to readout
      wait for 50us;

      -- reset counters
      histo_reset <= '1';
      wait for clk_in_period;
      histo_reset <= '0';

    end loop;

    wait;
  end process;


  print_output    : process (start_hstro, ll_data, ll_src_rdy, clk_in)
    variable s    : line;
    --File outputs
    file data_out : text open write_mode is "histodata.txt";

  begin

    if (clk_in = '1' and clk_in'event) then

      if (start_hstro = '1' and start_hstro'last_value = '0') then
        write(s, "************* Readout Histogram **************");
        writeline(data_out, s);         -- write marker
        write(s, ll_data_len);
        writeline(data_out, s);         -- write data length
        write(s, n_triggers);
        writeline(data_out, s);         -- number of triggers

      end if;

      if (ll_src_rdy = '1') then        -- buffer is reading out
        write(s, ll_data);
        writeline(data_out, s);         -- write histogram bin to file
      end if;

    end if;

  end process;



end behavior;

