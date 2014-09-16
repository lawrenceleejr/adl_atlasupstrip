--
-- VHDL Architecture parser.parser_top_tester.sim
--
-- Created:
--          by - warren.man (pc140.hep.ucl.ac.uk)
--          at - 12:10:07 06/15/10
--
-- using Mentor Graphics HDL Designer(TM) 2008.1b (Build 7)
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pkg_hsio_globals.t_llbus;
use work.pkg_hsio_globals.t_llstore;

entity parser_top_tester is
  port (
    start_hstro  : out std_logic;
    clk_o        : out std_logic;
    abcdata      : out std_logic;
    dst_rdy      : out std_logic;
    debug_mode_o : out std_logic;
    rst_o        : out std_logic;
    ll_in        : in t_llbus
    );
end parser_top_tester;

--
architecture sim of parser_top_tester is

  component ll_test_sink is
    port (
      clk : in  std_logic;
      ll :  in  t_llbus;

      data_store : out t_llstore);
  end component;

  signal clk_enabled : std_logic := '1';
  signal clk              : std_logic                    := '1';
  signal rst              : std_logic                    := '1';
  signal dst_rdy_osc      : std_logic                    := '1';
  signal dst_rdy_slow_osc : std_logic                    := '1';


  -- How to drive the destination ready
  type DSTMODE is (
    LO, HI,
    TOG, TOGN,
    SLOWTOG, SLOWTOGN);

  signal dst_mode         : DSTMODE;

  signal data_store       : t_llstore;

  signal expected_data    : std_logic_vector(15 downto 0);

  function header ( bcid : integer; l1id : integer) return std_logic_vector is
    variable output : std_logic_vector((6 + 4 + 8 + 1)-1 downto 0);
  begin
    output(18 downto 13) := "111010";
    output(12 downto 9) := std_logic_vector(to_unsigned(bcid, 4));
    output(8 downto 1) := std_logic_vector(to_unsigned(l1id, 8));
    output(0) := '1';
    return output;
  end header;

  function clstr ( chip : integer; channel : integer) return std_logic_vector is
    variable output : std_logic_vector((2 + 7 + 7)-1 downto 0);
  begin
    output(15 downto 14) := "01";
    output(13 downto 7) := std_logic_vector(to_unsigned(chip, 7));
    output(6 downto 0) := std_logic_vector(to_unsigned(channel, 7));
    return output;
  end clstr;

  signal header_check : std_logic_vector(18 downto 0);
  signal header_value : std_logic_vector(18 downto 0);
  signal cluster_check : std_logic_vector(15 downto 0);
  signal cluster_value : std_logic_vector(15 downto 0);

  constant ABCNTestLength : integer := 784 + 128 + 128 + 80 + 128;

  constant ABCNTEST : std_logic_vector(ABCNTestLength - 1 downto 0) :=
   -- Two events with minimal trailer between
   -- Two hits from 70/13
   "0000"& header(1, 1) & "0011001100111000000000000000"&header(15, 170)& clstr(70, 13) &"101010101000000000000000000000000000000000"
   --   +----,+--,+------,,+--,+--,+--,+--------------,+----,+--,+------,,+,+-----,+-----,,+-,,+-,+--------------,
   -- Two events with minimal+1 trailer
   -- Two hits from 7/64
&  "0000"& header(2, 2) & "00110011001110000000000000000"&header(15, 165)& clstr(7, 64) & "10101010100000000000000000000000000000000"
   --   +----,+--,+------,,+--,+--,+--,+--------------, +----,+--,+------,,+,+-----,+-----,,+-,,+-,+--------------,
   -- Two events with minimal trailer and chip channel = 0 (ie 14 zeros)
   -- 3 hits from 0/0
&  "0000"& header(3, 3) & "0011001100111000000000000000"&header(15, 255) & clstr(0, 0) & "101010101010100000000000000000000000000000"
   --   +----,+--,+------,,+--,+--,+--,+--------------,+----,+--,+------,,+,+-----,+-----,,+-,,+-,,+-,+--------------, 
   -- Minimal trailer after data
   -- 1+3 hits from 0/0
&  "0000" & header(4, 4) & clstr(0, 0) &  "11111000000000000000"& header(4, 228) & clstr(0, 0) & "1010101010101000000000000000000000"
   --   +----,+--,+------,,+,+-----,+-----,,+-,+--------------,+----,+--,+------,,+,+-----,+-----,,+-,,+-,,+-,+--------------, 
   -- Consecutive hits of different patterns from chip = channel = 0
   -- 8 hits from 0/10 (but 000 not counted)
&  "0000" & header(5, 5) & clstr(0, 10) & "100010011010101111001101111011111000000000000000000000000000000000"
   --   +----,+--,+------,,+,+-----,+-----,,+-,,+-,,+-,,+-,,+-,,+-,,+-,,+-,+--------------, 
   -- Event with no hit followed by a hit
   -- 1 hit from 5/10
&  "0000" & header(6, 6) &"0011"&clstr(5, 10)&"101010000000000000000"
   --   +----,+--,+------,,+--,+,+-----,+-----,,+-,+--------------,
   -- Event with a hit followed by no hit
   -- 1 hit from 9/10
&  "0000" & header(7, 7) & clstr(9, 10) &"1010001110000000000000000"
   --   +----,+--,+------,,+,+-----,+-----,,+-,+--,+--------------,
   -- Error packet (both 001 and 100)
&  "0000"& header(8, 8) & "000101010100110001010101100110000000000000000000"
   --   +----,+--,+------,,+-,------,+-,,+-,+-----,+-,,+--------------,
   -- Config readback
&  "00"& header(9, 9) & "00010101011110011001111100110011000000000000000000"
   -- +----,+--,+------,,+-,+-----,+-,+------,,+------,,+--------------,
   -- Register readback
&  "0000"&header(10,10) & "0001010101010000001111111111111111111000000000000000000000000000000000000000000000"
   --   +----,+--,+------,,+-,------,+-,+---,+------,,+------,,+--------------, 
   -- Put it into an error state (no trailer bit)
&  "0000"&header(11, 11) &"0011000000000000000000000"
   --   +----,+--,+------,,+--,*--------------,
   -- Missing separator 1 (BC = L1 = 12)
&  "00001110101100000011000"&clstr(56,56)&"1000100110000000000000000"
   --   +----,+--,+------,*+,+-----,+-----,,+-,,+-,+--------------, 
   -- Missing separator 2
&  "0000"&header(13, 13) & clstr(56, 56) &"0000100110000000000000000"
   --   +----,+--,+------,,+,+-----,+-----,*+-,,+-,+--------------, 
   -- Empty events (check OK after errors)
&  "0000"&header(14, 14) &"100000000000000000000"&header(15, 255)&"10000000000000000"
   --   +----,+--,+------,,+--------------, ----+----,+--,+------,,+--------------,
    ;

begin

  -- Check the helper functions do what they're supposed to
  header_check <= header(2, 15);
  header_value <= "1110100010000011111";
  cluster_check <= clstr(14, 112);
  cluster_value <= "0100011101110000";

  assert header_check = header_value report "Header function check";
  assert cluster_check = cluster_value report "Chip chan function check";

  -- Use clk_enabled to terminate simulation
  clk <= clk_enabled and not(clk) after 12500 ps;

  dst_rdy_osc      <= clk_enabled and not(dst_rdy_osc)      after 25000 ps;
  dst_rdy_slow_osc <= clk_enabled and not(dst_rdy_slow_osc) after 200 ns;

  clk_o <= clk;
  rst_o <= rst;

  dst_rdy <= '0'                   when dst_mode = LO       else
             '1'                   when dst_mode = HI       else
             dst_rdy_osc           when dst_mode = TOG      else
             not(dst_rdy_osc)      when dst_mode = TOGN     else
             dst_rdy_slow_osc      when dst_mode = SLOWTOG  else
             not(dst_rdy_slow_osc) when dst_mode = SLOWTOGN else
             '1';




  ----------------------------------------------------------------------------
  simulation                  :    process
    --------------------------------------------------
    -- Procedures 
    --------------------------------------------------
    procedure WaitClk is
    begin
      wait until rising_edge(clk);
      wait for 100 ps;
    end procedure;
    ----------------------------------------------------
    procedure WaitClks (nclks : in integer) is
    begin
      for waitclkloops in 1 to nclks loop
        wait until rising_edge(clk);
        wait for 100 ps;
      end loop;
    end procedure;
    ----------------------------------------------------


    -- =======================================================================
  begin

    -- Initialise
    --------------------------------------------------------------------

    start_hstro <= '0';
    abcdata     <= '0';
    debug_mode_o <= '1'; 
    rst         <= '1';
    WaitClks(100);
    rst <= '0';
    WaitClks(100);


    -------------------------------------------

    dst_mode <= HI;
    WaitClks(100);

    start_hstro <= '1';
    WaitClks(1);
    start_hstro <= '0';

    -- Wait for histo readout to complete
    WaitClks(40*40);

    -- Send ABCN data to engine (has no effect on the data already captured)
    for n in 0 to ABCNTestLength-1 loop
      abcdata <= ABCNTEST((ABCNTestLength-1)-n);
      WaitClk;
    end loop;

    WaitClks(100);

    -- Check the second packet of the data (the first one is overwritten)
    --  Still contains counter, before sending any data
    --  because we haven't overwritten the buffer by requesting readout again
    assert data_store(0) = "1101000000010001" report "Op code";
    assert data_store(1) = "0000000000000001" report "Sequence number";
    assert data_store(2) = std_logic_vector(to_unsigned(1290, 16)) report "Payload size";
    assert data_store(3) = "1111000100000001" report "Stream id and packet num";

    assert data_store(4) = std_logic_vector(to_unsigned(0, 16)) report "Event count";
    assert data_store(5) = std_logic_vector(to_unsigned(0, 16)) report "Hit count";
    assert data_store(6) = std_logic_vector(to_unsigned(0, 16)) report "Error count";  -- Counts config and regreadback
    assert data_store(7) = std_logic_vector(to_unsigned(0, 16)) report "Parse error count";

    for i in 0 to 639 loop
      assert data_store(i+8) = std_logic_vector(to_unsigned(i+640, 16))
          report "Histo data packet 1 " & integer'image(to_integer(unsigned(data_store(i+8)))) & " NOT " & integer'image(i+640);
      wait for 1 ps; -- So we know which one
    end loop;

    dst_mode <= SLOWTOGN;
    WaitClks(1300);

    dst_mode <= LO;


    WaitClks(100);

    ----------------------------------

    WaitClks(300);

    start_hstro <= '1';
    WaitClks(1);
    start_hstro <= '0';

    WaitClks(100);

    dst_mode <= TOG;
    WaitClks(1300);

    dst_mode <= LO;

    WaitClks(200);

    -- Check first packet of the readout data
    --   (mostly empty, but after sending data)
    assert data_store(0) = "1101000000010001" report "Op code";
    assert data_store(1) = "0000000000000010" report "Sequence number";
    assert data_store(2) = std_logic_vector(to_unsigned(1290, 16)) report "Payload size";
    assert data_store(3) = "1111000100000000" report "Stream id and packet num";

    assert data_store(4) = std_logic_vector(to_unsigned(19, 16)) report "Event count";
    assert data_store(5) = std_logic_vector(to_unsigned(20, 16)) report "Hit count";
    assert data_store(6) = std_logic_vector(to_unsigned(4, 16)) report "Error count";  -- Counts config and regreadback
    assert data_store(7) = std_logic_vector(to_unsigned(4, 16)) report "Parse error count";

    for i in 0 to 639 loop
      -- Check for hits in chips 0-4
      if (i=0) then expected_data <= std_logic_vector(to_unsigned(3, 16));
      elsif (i<3) then expected_data <= std_logic_vector(to_unsigned(2, 16));
      elsif (i>10 and i<18) then expected_data <= std_logic_vector(to_unsigned(1, 16));
      else expected_data <= "0000000000000000";
      end if;

      -- Allow the new value to take effect
      -- Also identifies position in loop
      wait for 1 ps;

      assert data_store(i+8) = expected_data
          report "Histo data packet 2 channel " & integer'image(i)
               & " " & integer'image(to_integer(unsigned(data_store(i+8))))
               & " hits NOT " & integer'image(to_integer(unsigned(expected_data)));
    end loop;

    ----------------------------------

    WaitClks(300);
    dst_mode <= TOG;

    start_hstro <= '1';
    WaitClks(1);
    start_hstro <= '0';


    WaitClks(1200);

    -- Check second packet of the readout
    --   (mostly empty, but after sending data)
    assert data_store(0) = "1101000000010001" report "Op code error";
    assert data_store(1) = "0000000000000011" report "Sequence number";
    assert data_store(2) = std_logic_vector(to_unsigned(1290, 16)) report "Payload size";
    assert data_store(3) = "1111000100000001" report "Stream id and packet num";

    assert data_store(4) = std_logic_vector(to_unsigned(19, 16)) report "Event count";
    assert data_store(5) = std_logic_vector(to_unsigned(20, 16)) report "Hit count";
    assert data_store(6) = std_logic_vector(to_unsigned(4, 16)) report "Error count";  -- Counts config and regreadback
    assert data_store(7) = std_logic_vector(to_unsigned(4, 16)) report "Parse error count";

    for i in 0 to 639 loop
      -- Check for hits in chips 5-9
      if (i=10) then expected_data <= std_logic_vector(to_unsigned(1, 16));
      elsif (i=141 or i=142) then expected_data <= std_logic_vector(to_unsigned(1, 16));
      elsif (i=256+64 or i=256+65) then expected_data <= std_logic_vector(to_unsigned(1, 16));
      elsif (i=512+10) then expected_data <= std_logic_vector(to_unsigned(1, 16));
      else expected_data <= std_logic_vector(to_unsigned(0, 16));
      end if;

      -- Allow the new value to take effect
      -- Also identifies position in loop
      wait for 1 ps;

      assert data_store(i+8) = expected_data
          report "Histo data packet 3 channel " & integer'image(i)
               & " " & integer'image(to_integer(unsigned(data_store(i+8))))
               & " hits NOT " & integer'image(to_integer(unsigned(expected_data)));
    end loop;

    ------------------------------------
    -- Reset to zero counters (including sequence number) on next readout
	 rst <= '1';
    WaitClks(100);
    rst <= '0';

    WaitClks(300);
    dst_mode <= TOGN;

    start_hstro <= '1';
    WaitClks(1);
    start_hstro <= '0';

    -- Wait for histo readout to complete
    WaitClks(100*40);

    -- Brief check of final packet (after reset)
    assert data_store(0) = "1101000000010001" report "Op code error";
    assert data_store(1) = "0000000000000001" report "Sequence number"; -- Second since reset
    assert data_store(2) = std_logic_vector(to_unsigned(1290, 16)) report "Payload size";
    assert data_store(3) = "1111000100000001" report "Stream id and packet num";

    assert data_store(4) = std_logic_vector(to_unsigned(0, 16)) report "Event count";
    assert data_store(5) = std_logic_vector(to_unsigned(0, 16)) report "Hit count";
    assert data_store(6) = std_logic_vector(to_unsigned(0, 16)) report "Error count";  -- Counts config and regreadback
    assert data_store(7) = std_logic_vector(to_unsigned(0, 16)) report "Parse error count";

    for i in 0 to 640 loop
      assert data_store(i+8) = "0000000000000000";
    end loop;

    -- Turn off clock so simulation finishes
    clk_enabled <= '0';

    wait;

  end process;

  Ustore : ll_test_sink
    port map (
      clk => clk,
      ll => ll_in,
      --ll_eof => ll_eof_in,
      --ll_src_rdy => ll_src_rdy_in,
      --ll_dst_rdy => ll_dst_rdy_in,
      --ll_data => ll_data_in,

      data_store => data_store);

end architecture sim;

