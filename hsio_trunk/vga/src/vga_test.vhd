--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:02:12 06/28/2012
-- Design Name:   
-- Module Name:   C:/Users/tbarber/Documents/hep/detectors/SctUpgrade/fpga/hsio/vga/vga_test.vhd
-- Project Name:  vga_test
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: vga_top
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
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use std.textio.all;
use ieee.std_logic_textio.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
library hsio;
use hsio.pkg_hsio_globals.all;
library vga;
use vga.pkg_vga.all;
library utils;
use utils.pkg_types.all;

entity vga_test is
end vga_test;

architecture behavior of vga_test is

  -- Component Declaration for the Unit Under Test (UUT)

  component vga_top
    port(
      clock, clock40, reset  : in  std_logic;  -- 40 Mhz clock
      post_rst_5s            : in  std_logic;
      Rout, Gout, Bout, H, V : out std_logic;  -- VGA drive signals      
-- Signals to display
      status_i               : in  slv16_array(31 downto 0);
      reg_i                  : in  t_reg_bus;
-- Single bits (LED-like behaviour)
      leds_i                 : in  std_logic_vector(N_LEDS-1 downto 0)
      );
  end component;
  --Inputs
  signal clock               :     std_logic := '0';
  signal clock40             :     std_logic := '0';
  signal reset               :     std_logic := '1';

  --Outputs
  signal Rout : std_logic;
  signal Gout : std_logic;
  signal Bout : std_logic;
  signal H    : std_logic;
  signal V    : std_logic;

  signal wait_five_s : std_logic := '1';

  -- Clock period definitions
  constant clock_period : time := 12.5 ns;

  signal stat : slv16_array(31 downto 0);

  signal led : std_logic := '1';

  function header ( bcid : integer; l1id : integer) return std_logic_vector is
    variable output      : std_logic_vector((6 + 4 + 8 + 1)-1 downto 0);
  begin
    output(18 downto 13) := "111010";
    output(12 downto 9)  := std_logic_vector(to_unsigned(bcid, 4));
    output(8 downto 1)   := std_logic_vector(to_unsigned(l1id, 8));
    output(0)            := '1';
    return output;
  end header;

  function clstr ( chip : integer; channel : integer) return std_logic_vector is
    variable output     : std_logic_vector((2 + 7 + 7)-1 downto 0);
  begin
    output(15 downto 14) := "01";
    output(13 downto 7)  := std_logic_vector(to_unsigned(chip, 7));
    output(6 downto 0)   := std_logic_vector(to_unsigned(channel, 7));
    return output;
  end clstr;



  signal   abcdata        : std_logic                                     := '0';
  constant ABCNTestLength : integer                                       := 784 + 128 + 128 + 80 + 128;
  constant ABCNTEST       : std_logic_vector(ABCNTestLength - 1 downto 0) :=
    -- Two events with minimal trailer between
    -- Two hits from 70/13
    "0000"& header(1, 1) & "0011001100111000000000000000"&header(15, 170)& clstr(70, 13) &"101010101000000000000000000000000000000000"
    --   +----,+--,+------,,+--,+--,+--,+--------------,+----,+--,+------,,+,+-----,+-----,,+-,,+-,+  --------------,
    -- Two events with minimal+1 trailer
    -- Two hits from 7/64
    & "0000"& header(2, 2) & "00110011001110000000000000000"&header(15, 165)& clstr(7, 64) & "10101010100000000000000000000000000000000"
    --   +----,+--,+------,,+--,+--,+--,+--------------, +----,+--,+------,,+,+-----,+-----,,+-,,+-,+  --------------,
    -- Two events with minimal trailer and chip channel = 0 (ie 14 zeros)
    -- 3 hits from 0/0
    & "0000"& header(3, 3) & "0011001100111000000000000000"&header(15, 255) & clstr(0, 0) & "101010101010100000000000000000000000000000"
    --   +----,+--,+------,,+--,+--,+--,+--------------,+----,+--,+------,,+,+-----,+-----,,+-,,+-,,+-,+  --------------, 
    -- Minimal trailer after data
    -- 1+3 hits from 0/0
    & "0000" & header(4, 4) & clstr(0, 0) & "11111000000000000000"& header(4, 228) & clstr(0, 0) & "1010101010101000000000000000000000"
    --   +----,+--,+------,,+,+-----,+-----,,+-,+--------------,+----,+--,+------,,+,+-----,+-----,,+-,,+-,,+-,+  --------------, 
    -- Consecutive hits of different patterns from chip = channel = 0
    -- 8 hits from 0/10 (but 000 not counted)
    & "0000" & header(5, 5) & clstr(0, 10) & "100010011010101111001101111011111000000000000000000000000000000000"
    --   +----,+--,+------,,+,+-----,+-----,,+-,,+-,,+-,,+-,,+-,,+-,,+-,,+-,+  --------------, 
    -- Event with no hit followed by a hit
    -- 1 hit from 5/10
    & "0000" & header(6, 6) &"0011"&clstr(5, 10)&"101010000000000000000"
    --   +----,+--,+------,,+--,+,+-----,+-----,,+-,+  --------------,
    -- Event with a hit followed by no hit
    -- 1 hit from 9/10
    & "0000" & header(7, 7) & clstr(9, 10) &"1010001110000000000000000"
    --   +----,+--,+------,,+,+-----,+-----,,+-,+--,+  --------------,
    -- Error packet (both 001 and 100)
    & "0000"& header(8, 8) & "000101010100110001010101100110000000000000000000"
    --   +----,+--,+------,,+-,------,+-,,+-,+-----,+-,,+  --------------,
    -- Config readback
    & "00"& header(9, 9) & "00010101011110011001111100110011000000000000000000"
    -- +----,+--,+------,,+-,+-----,+-,+------,,+------,,+  --------------,
    -- Register readback
    & "0000"&header(10, 10) & "0001010101010000001111111111111111111000000000000000000000000000000000000000000000"
    --   +----,+--,+------,,+-,------,+-,+---,+------,,+------,,+  --------------, 
    -- Put it into an error state (no trailer bit)
    & "0000"&header(11, 11) &"0011000000000000000000000"
    --   +----,+--,+------,,+--,*       --------------,
    -- Missing separator 1 (BC = L1 = 12)
    & "00001110101100000011000"&clstr(56, 56)&"1000100110000000000000000"
    --   +----,+--,+------,*+,+-----,+-----,,+-,,+-,+  --------------, 
    -- Missing separator 2
    & "0000"&header(13, 13) & clstr(56, 56) &"0000100110000000000000000"
    --   +----,+--,+------,,+,+-----,+-----,*+-,,+-,+  --------------, 
    -- Empty events (check OK after errors)
    & "0000"&header(14, 14) &"100000000000000000000"&header(15, 255)&"10000000000000000"
    --   +----,+--,+------,,+--------------, ----+----,+--,+------,,+  --------------,
;


begin

  stat(S_HW_ID)        <= x"0c02";
  stat(S_SANITY)       <= x"a510";
  stat(S_VERSION)      <= conv_std_logic_vector(C_FW_BUILD_NO, 16);
  stat(S_MODULES_EN)   <= conv_std_logic_vector(C_MODULECOUNT, 16);
  stat(S_BCID_L1A)     <= x"0000";
  stat(S_L1ID_LO)      <= x"0000";
  stat(S_L1ID_HI)      <= x"0000";
  stat(S_15)           <= x"0000";
  stat(S_TMODULES_EN)  <= C_TMODULES_EN;
  stat(S_THISTOS_EN)   <= C_THISTOS_EN;
  stat(S_BMODULES_EN)  <= C_BMODULES_EN;
  stat(S_BHISTOS_EN)   <= C_BHISTOS_EN;
  stat(S_PPHISTMOD_EN) <= C_PPHISTOS_EN(7 downto 0) & C_PPMODULES_EN(7 downto 0);

  -- Instantiate the Unit Under Test (UUT)
  uut : vga_top
    port map (
      clock       => clock,
      clock40     => clock40,
      post_rst_5s => wait_five_s,
      reset       => reset,
      Rout        => Rout,
      Gout        => Gout,
      Bout        => Bout,
      H           => H,
      V           => V,
      status_i    => stat,
      reg_i       => REG_INITVAL,
      leds_i(0)   => led,
      leds_i(1)   => not(led),
      leds_i(2)   => '1',
      leds_i(3)   => '1',
      leds_i(4)   => '1',
      leds_i(5)   => '1',
      leds_i(6)   => abcdata,
      leds_i(7)   => abcdata,
      leds_i(8)   => '1',
      leds_i(9)   => '1',
      leds_i(10)  => clock40,
      leds_i(11)  => abcdata,
      leds_i(12)  => '1',
      leds_i(13)  => '1'
      );


  -- Clock process definitions
  clock_process : process
  begin
    clock <= '1';
    wait for clock_period/2;
    clock <= '0';
    wait for clock_period/2;
  end process;

  -- Clock process definitions
  clock40_process : process
  begin
    clock40 <= '1';
    wait for clock_period;
    clock40 <= '0';
    wait for clock_period;
  end process;

  -- Send ABCN data to engine (has no effect on the data already captured)
  data_pushout : process
  begin
    wait for clock_period*1000000;
    for n in 0 to ABCNTestLength-1 loop
      abcdata <= ABCNTEST((ABCNTestLength-1)-n);
      wait for clock_period;
    end loop;
  end process;

  my_reset : process
  begin
    if (wait_five_s = '1') then
      wait for clock_period*650000;
      wait_five_s <= '0';
    else
      wait for clock_period;
    end if;
  end process;

  led_flash : process
  begin
    led <= '1';
    wait for clock_period*650000;
    led <= '0';
    wait for clock_period*650000;
  end process;

  my_reset_5s : process
  begin
    if (reset = '1') then
      wait for clock_period*10;
      reset <= '0';
    else
      wait for clock_period*10;
    end if;
  end process;

-- printlogo: process
-- variable thismem: char_ram_type;
-- variable toto: LINE;                 -- initialised to empty!
--              file data_out: TEXT open write_mode is "initialram.txt";
--      begin
--              thismem := string_to_char_ram( initial_screen );
--              FOR i IN 0 TO 8191 LOOP
--                      hwrite(toto, thismem(i));
--                      write(toto, ", ");
--              END LOOP;
--              writeline(data_out, toto);
--              wait;
--      end process;

  -- Stimulus process
  printvga           : process(clock40, reset)
    variable toto    : LINE;            -- initialised to empty!
    file data_out    : TEXT open write_mode is "vgadata.txt";
    variable newline : std_logic := '0';
  begin
    if (reset = '1') then
      write(toto, "VGA Tester");
      writeline(data_out, toto);
    else
      if (clock40'event and clock40 = '1') then
        if (V = '0') then
          --write(toto, "V reset");
          --writeline(data_out,toto);
        else
          if (H = '1') then
            newline              := '1';
            if (Gout = '1') then
              write(toto, "*");
            else
              write(toto, " ");
            end if;
          else
            if (newline = '1') then
              newline := '0';
              write(toto, "|");
              writeline(data_out,toto);
            end if;
          end if;
        end if;
      end if;
    end if;
  end process;

END;
