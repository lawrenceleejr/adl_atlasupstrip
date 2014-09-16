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
use ieee.std_logic_arith.all;
use IEEE.NUMERIC_STD.all;

entity decoderFSM_tester is
  port (
    clk_o : out std_logic;
    rst_o : out std_logic;
    hit_o : out std_logic
    );
end decoderFSM_tester;

--
architecture sim of decoderFSM_tester is


  component hawaiiFIFO
    generic (
      depth : natural := 4              -- fifo will be max_occupancy) registers deep
      );
    port (

      clock, reset : in  std_logic;     -- clock and reset
      rd, wr       : in  std_logic;     -- read / write enable                  
      read_length  : in  std_logic_vector(depth-1 downto 0);
      write_length : in  std_logic_vector(depth-1 downto 0);
      full, empty  : out std_logic;

      read_data  : out std_logic_vector(0 to 2**depth-1);
      write_data : in  std_logic_vector(0 to 2**depth-1);  -- single bit input

      -- Some debug outputs
      w_ptr_reg_o, w_ptr_next_o, w_ptr_succ_o : out
      std_logic_vector(depth-1 downto 0) := (others => '0');

      -- Read pointers
      r_ptr_reg_o, r_ptr_next_o, r_ptr_succ_o : out
      std_logic_vector(depth-1 downto 0) := (others => '0');

      -- Buffer occupancy
      occupancy : out std_logic_vector(depth downto 0)

      );
  end component;

  component decoderFSM
    generic (
      depth                :     natural := 4;  -- length of the input data (2**depth)
      -- Length of various bits in the data stream
      chipAddressLength    :     natural := 7;
      channelAddressLength :     natural := 7;
      levelOneLength       :     natural := 4;
      bcLength             :     natural := 8;
      hitPatternLength     :     natural := 3
      );
    port(
      clock                : in  std_logic;
      reset                : in  std_logic;
      -- Debug status word
      fsm_status           : out std_logic_vector(4 downto 0);

      -- Should we try to decode?
      -- This is signal from data gate
      decode_active : in std_logic;

      -- Decoded Signals
      found_header     : out std_logic;
      found_hit        : out std_logic;
      found_parseError : out std_logic;

      -- Last L1ID
      last_levelOne_out : out std_logic_vector(levelOneLength-1 downto 0);
      last_bcID_out     : out std_logic_vector(bcLength-1 downto 0);

      -- Chip and channels flags
      hit_chip_address_out    : out std_logic_vector(chipAddressLength-1 downto 0);
      hit_channel_address_out : out std_logic_vector(channelAddressLength-1 downto 0);
      hit_pattern_out         : out std_logic_vector(0 to hitPatternLength-1);

      -- Interaction with the FIFO
      abc_fifo_data    : in  std_logic_vector(0 to 2**depth - 1);
      fifo_read_length : out std_logic_vector(depth - 1 downto 0);
      fifo_occupancy   : in  std_logic_vector(depth downto 0);
      fifo_empty       : in  std_logic;
      readout_fifo     : out std_logic
      );

  end component;

  component dataGate
    generic(
      headerLength  : integer                   := 5;
      header        : std_logic_vector(0 to 4)  := "11101";
      trailerLength : integer                   := 17;
      trailer       : std_logic_vector(0 to 16) := "10000000000000000"
      );

    port(
      clock        : in  std_logic;
      reset        : in  std_logic;
      dataBit      : in  std_logic;
      writeDisable : in  std_logic;
      outBit       : out std_logic := '0';
      wrEnOut      : out std_logic := '0'
-- dataGateDebug : out std_logic_vector(0 to trailerLength)
      );
  end component;


  component histogrammer

    generic (
      histogram_depth   : natural := 11;
      histogram_width   : natural := 16;
      max_address_count : natural := 1280
      );
    port (

      clock, reset : in std_logic;      -- clock and reset
      inputAddress : in std_logic_vector(histogram_depth-1 downto 0);
      writeEnable  : in std_logic;

      readEnable          : in  std_logic;
      outputAddress       : in  std_logic_vector(histogram_depth-1 downto 0);
      histogram_occupancy : out std_logic_vector(histogram_width-1 downto 0)

      );

  end component;

  component readoutHist_sctdaq
    generic(
      STREAM_ID         : integer := 0;
      histogram_depth   : natural := 11;
      histogram_width   : natural := 16;
      max_address_count : natural := 1280

      );
    port(
      clk        : in  std_logic;       --
      rst        : in  std_logic;       --
      en         : in  std_logic;       --
      start_ro_i : in  std_logic;
      ready_out  : out std_logic;       --

      hst_rdPtr_out : out std_logic_vector(histogram_depth-1 downto 0);  --
      hst_rdData_i  : in  std_logic_vector(histogram_width-1 downto 0);  --
      hst_rdEn_out  : out std_logic;

      ll_sof_o      : out std_logic;
      ll_eof_o      : out std_logic;
      ll_src_rdy_o  : out std_logic;
      ll_dst_rdy_i  : in  std_logic;
      ll_data_o     : out std_logic_vector(histogram_width-1 downto 0);
      ll_data_len_o : out std_logic_vector(histogram_width-1 downto 0);

      header_count     : in std_logic_vector(histogram_width-1 downto 0);
      hit_count        : in std_logic_vector(histogram_width-1 downto 0);
      error_count      : in std_logic_vector(histogram_width-1 downto 0);
      parseError_count : in std_logic_vector(histogram_width-1 downto 0)

      );
  end component;

  constant LevelOneLength : natural := 4;
  constant BCIDLength     : natural := 8;
  constant channelLength  : natural := 7;
  constant chipLength     : natural := 7;
  constant fifo_depth     : integer := 5;

  constant histogram_width : integer := 16;
  constant addressLength   : natural := 11;

  constant maximum_channel : natural := 1280;

  signal clk : std_logic := '1';
  signal rst : std_logic := '1';

  signal abcdata         : std_logic;
  signal abcBufferedData : std_logic;
  signal headerDetected  : std_logic;

  signal read_enable     : std_logic;
  signal isfull, isempty : std_logic;
  signal write_enable    : std_logic := '0';

  signal readout_histo : std_logic := '0';
  signal readout_link  : std_logic := '0';
  signal hro0_ready    : std_logic := '0';
  signal debug_mode    : std_logic := '0';

  signal fifo_data : std_logic_vector(2**fifo_depth - 1 downto 0);

  signal ll_sof_o      : std_logic;
  signal ll_eof_o      : std_logic;
  signal ll_src_rdy_o  : std_logic;
  signal ll_dst_rdy_i  : std_logic := '1';
  signal ll_data_o     : std_logic_vector (histogram_width-1 downto 0);
  signal ll_data_len_o : std_logic_vector (histogram_width-1 downto 0);

  signal histo_occ       : std_logic_vector(histogram_width-1 downto 0);
  signal readout_address : std_logic_vector(addressLength-1 downto 0);

  signal LOneID_count : std_logic_vector(LevelOneLength-1 downto 0);
  signal BCID_count   : std_logic_vector(BCIDLength-1 downto 0);

  signal found_header  : std_logic;
  signal found_hit_reg : std_logic;
  signal hit_channel   : std_logic_vector(channelLength-1 downto 0);
  signal hit_chip      : std_logic_vector(chipLength-1 downto 0);
  signal found_error   : std_logic;

-- Write pointers
  signal w_ptr_reg, w_ptr_next, w_ptr_succ :
    std_logic_vector(fifo_depth-1 downto 0) := (others => '0');

-- Read pointers
  signal r_ptr_reg, r_ptr_next, r_ptr_succ :
    std_logic_vector(fifo_depth-1 downto 0) := (others => '0');

  signal fifo_occupancy : std_logic_vector(fifo_depth downto 0);
  signal read_length    : std_logic_vector(fifo_depth-1 downto 0);

  signal state : std_logic_vector(4 downto 0);

  constant ABCNTestLength : integer                                       := 784 + 128 + 128 + 40 + 40 + 128 + 128 + 128 + 128;
  constant ABCNTEST       : std_logic_vector(ABCNTestLength - 1 downto 0) :=
    -- Two events with minimal trailer between
    -------     Empty event                                                   aaaaaaaccccccc
    "00011101010011111111110011001100111000000000000000011101011111111111110100000000000000101010101000000000000000000000000000000000"
    ---------,---,-------,,---,---,---,---------------,-----,---,-------,,-,------,------,,--,,--,  ----------------
    -- Two events with a dodgy trailer           
    & "00011101010011111111110011001100111000010000000000011101011111111111110100010011111110101010101000000000000000000000000000000000"
    ---------,---,-------,,---,---,---,---------------,-----,---,-------,,-,------,------,,--,,--,  ---------------,
    -- Two events with minimal-1 trailer between             
    & "00001110101001111111111001100110011100000000000000011101011111111111110100000000000010101010101000000000000000000000000000000000"
    ---------,---,-------,,---,---,---,---------------,-----,---,-------,,-,------,------,,--,,--,  ---------------,
    -- Two events with minimal+1 trailer
    & "00011101010111111111110011001100111000000000000000001110101111111111111010000010000000010101010100000000000000000000000000000000"
    ---------,---,-------,,---,---,---,---------------, -----,---,-------,,-,------,------,,--,,--,  ---------------,
    -- Event with 000 hit pattern, followed by an error, then chip with address 0, and error code 001 - ie 15 zeros
    & "000111010111111111111101111111111111111010100000000000000011100000000000000000000000000000000000000000000000000000000000000000"
    ----hhhhh,llllbbbbbbbbs             --aaaaaaaccccccc-ddd-dddcccaaaaaaaeee-ttttttttttttttttttttttttttttttttttttttttttttttttttt
    -- Two events with minimal trailer and chip channel = 0 (ie 14 zeros)
    & "0000011101011011111111110011001100111000000000000000011101011111111111110100000000000000101010101010100000000000000000000000000000"
    --   +----,+--,+------,,+--,+--,+--,+--------------,+----,+--,+------,,+,+-----,+-----,,+-,,+-,,+-,+  --------------, 
    -- Consecutive hits of different patterns from chip = channel = 0
    & "000011101011111111111110100000000000000100010011010101111001101111011111000000000000000000000000000000000"
    --   +----,+--,+------,,+,+-----,+-----,,+-,,+-,,+-,,+-,,+-,,+-,,+-,,+-,+  --------------, 
    -- Event with no hit followed by a hit
    & "0000111010111111111111100110100001010001010101010000000000000000"
    ----+----,+--,+------,,+--,+,+-----,+-----,,+-,+  --------------,
    -- Event with a hit followed by no hit
    & "0000111010111111111111101000010100010101010001110000000000000000"
    -- Hit,no-hit,hit
    & "00001110101111111111111010000101000101010100011010000111000101010101000000000000000000000000000000000000000000000000000000000000"
    ----+----,+--,+------,,+,+-----,+-----,,+-,+--,+  --------------,
    -- Error packet (both 001 and 100)
    & "00001110101111111111111000101010100110001010101100110000000000000000000"
    --   +----,+--,+------,,+-,------,+-,,+-,+-----,+-,,+  --------------,
    -- Config readback
    & "00111010111111111111100010101011110011001111100110011000000000000000000"
    -- +----,+--,+------,,+-,+-----,+-,+------,,+------,,+  --------------, 
    -- Register readback
    & "000011101011111111111110001010101010000001111111111111111111000000000000000000000000000000000000000000000"
    --   +----,+--,+------,,+-,------,+-,+---,+------,,+------,,+  --------------, 
    -- Put it into an error state (no trailer bit)
    & "000011101011111111111110011000000000000000000000"
    ----+----,+--,+------,,+--,*        --------------,
    -- Missing separator 1
    & "0000111010111111111111001011100001110001000100110000000000000000"
    --   +----,+--,+------,*+,+-----,+-----,,+-,,+-,+  --------------, 
    -- Missing separator 2
    & "0000111010111111111111101011100001110000000100110000000000000000"
    --   +----,+--,+------,,+,+-----,+-----,*+-,,+-,+  --------------, 
    -- Empty event (check OK after errors)
    & "0000111010111111111111110000000000000000"
    ----+----,+--,+------,,+            --------------,
    & "0000111010111111111111110000000000000000"
    ----+----,+--,+------,,+            --------------,
;
begin

  -- And a hisotgrammer
  fifo : hawaiiFIFO
    generic map ( depth                => fifo_depth )
    port map (
      clock                            => clk,
-- Really reset the fifo if we find a trailer
      --reset => rst,
      reset                            => (rst or (not headerDetected)),
-- reset => rst,
      rd                               => read_enable,
      wr                               => headerDetected,
      write_data(0)                    => abcBufferedData,
      write_data(1 to 2**fifo_depth-1) => (others => '0'),
      read_length                      => read_length,
      write_length                     => "00001",
      full                             => isfull,
      empty                            => isempty,
      read_data                        => fifo_data,
      w_ptr_reg_o                      => w_ptr_reg,
      w_ptr_next_o                     => w_ptr_next,
      w_ptr_succ_o                     => w_ptr_succ,
      r_ptr_reg_o                      => r_ptr_reg,
      r_ptr_next_o                     => r_ptr_next,
      r_ptr_succ_o                     => r_ptr_succ,
      occupancy                        => fifo_occupancy
      );

  decoder : decoderFSM
    generic map (
      depth                   => fifo_depth,
      levelOneLength          => LevelOneLength,
      bcLength                => BCIDLength,
      chipAddressLength       => chipLength,
      channelAddressLength    => channelLength
      )
    port map (
      clock                   => clk,
      reset                   => rst,
      decode_active           => headerDetected,
      fsm_status              => state,
      last_levelOne_out       => LOneID_count,
      last_bcID_out           => BCID_count,
      abc_fifo_data           => fifo_data,
      fifo_occupancy          => fifo_occupancy,
      fifo_read_length        => read_length,
      fifo_empty              => isempty,
      readout_fifo            => read_enable,
      found_header            => found_header,
      found_hit               => found_hit_reg,
      found_parseError        => found_error,
      hit_chip_address_out    => hit_chip,
      hit_channel_address_out => hit_channel
      );

  gataDate : dataGate
    port map (
      clock        => clk,
      reset        => rst,
-- Disable writing if error is found
-- ie give up looking for a trailer and start
-- looking for new header, but don't clear the buffer
      writeDisable => found_error,
-- writeDisable => '0',
      dataBit      => abcdata,
      outBit       => abcBufferedData,
      wrEnOut      => headerDetected
      );

  histo : histogrammer
    generic map (
      histogram_depth                                    => addressLength,
      histogram_width                                    => histogram_width,
      max_address_count                                  => maximum_channel
      )
    port map (
      clock                                              => clk, reset => rst,
      inputAddress(addressLength-1 downto channelLength) => hit_chip(addressLength-channelLength-1 downto 0),
      inputAddress(channelLength-1 downto 0)             => hit_channel,
      writeEnable                                        => found_hit_reg,
      readEnable                                         => readout_histo,
      histogram_occupancy                                => histo_occ,
      outputAddress                                      => readout_address
-- outputAddress => (others => '0')
      );

  readout : readoutHist_sctdaq
    generic map (
      STREAM_ID         => 255,
      histogram_depth   => addressLength,
      histogram_width   => histogram_width,
      max_address_count => maximum_channel
      )
    port map(
      clk               => clk,
      rst               => rst,
      en                => '1',

      start_ro_i => readout_link,       --***hro0_trigger,
      ready_out  => hro0_ready,

      hst_rdPtr_out => readout_address,

      hst_rdData_i => histo_occ,
      hst_rdEn_out => readout_histo,

      ll_sof_o      => ll_sof_o,
      ll_eof_o      => ll_eof_o,
      ll_src_rdy_o  => ll_src_rdy_o,
      ll_dst_rdy_i  => ll_dst_rdy_i,
      ll_data_o     => ll_data_o,
      ll_data_len_o => ll_data_len_o

      );




  clk <= not(clk) after 12500 ps;

  clk_o <= clk;
  rst_o <= rst;
  hit_o <= found_hit_reg;

  ----------------------------------------------------------------------------
  fillbuffer                  :    process
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

    abcdata      <= '0';
    rst          <= '1';
    readout_link <= '0';
    WaitClks(100);
    rst          <= '0';
    WaitClks(100);

    -------------------------------------------

-- write_enable <= '1';

-- for n in 0 to ABCNTestLength-1 loop
    for n in 1 to ABCNTestLength loop
-- for n in 1 to 256+128 loop
      abcdata <= ABCNTEST((ABCNTestLength)-n);
      WaitClk;
    end loop;

    WaitClks(10);

    readout_link <= '1';
    WaitClks(1);
    readout_link <= '0';

    --for n in 0 to 1279 loop
    --  readout_address <= std_logic_vector( to_unsigned(n, readout_address'length));
    --  WaitClks(1);
    --end loop;
    --readout_histo <= '0';

    WaitClks(1000);
    ll_dst_rdy_i <= '0';
    WaitClks(10);
    ll_dst_rdy_i <= '1';

    wait until hro0_ready = '1';
    WaitClks(100);

  end process;


end architecture sim;

