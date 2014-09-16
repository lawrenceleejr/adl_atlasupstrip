----------------------------------------------------------------------------------
-- Company:   University of Freiburg
-- Engineer:  Tom Barber (tom.barber@cern.ch)
-- 
-- Create Date:    13:12:21 31/03/2011 
-- Design Name: 
-- Module Name:    decoder_histogrammer_top - Behavioral 
-- Project Name:   ATLAS Strips Upgrade HSIO
-- Target Devices: 
-- Tool versions: ISE 12.4
-- Description: Unit which decodes and histograms ABCnext events
--
-- Layout looks something like this
--
--   ====> dataGate (only lets through headers and trailers)
--             |
--             |
--             V
--         decoder (decodes the event, and flags chip/channel numbers, hits & errors
--            /  \
--           /    \ 
--          /      \==> histogrammer (contains a block RAM to store events)
--         |                |
--         V                V
--     counters=======>  readout (streams data in an DAQ friendly format)
-- (headers, hits, errors)
--
-- Dependencies: None
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

use IEEE.NUMERIC_STD.all;

library utils;
use utils.pkg_types.all;

entity parser_tom_top is
   generic( 
     -- STREAM_ID       : integer := 0;
      histogram_width : integer := 16
   );
   port(
      STREAM_ID : in integer;
      rst           : in     std_logic;   -- HSIO switch2, code_reload#
      en            : in     std_logic;
      abcdata_i     : in     std_logic;
      start_hstro_i : in     std_logic;
      debug_mode_i  : in     std_logic;
      lls_o         : out    t_llsrc;
      lld_i         : in     std_logic;
      clk           : in     std_logic
   );

-- Declarations

end parser_tom_top ;

--
architecture Behavioral of parser_tom_top is

-- Constants                            --

  constant LevelOneLength  : natural := 4;
  constant BCIDLength      : natural := 8;
  constant channelLength   : natural := 7;
  constant chipLength      : natural := 7;
  constant fifo_depth      : integer := 5;
  constant addressLength   : natural := 11;
  constant maximum_channel : natural := 1280;

-----------------

  component hawaiiFIFO
    generic (
      depth : natural := 4              -- fifo will be 2**depth bits deep
      );
    port (

      clock, reset : in std_logic;      -- clock and reset
      rd, wr       : in std_logic;      -- read / write enable (are these needed)

      -- Length in bits of read and write 
      read_length : in std_logic_vector(depth-1 downto 0);

      -- Read and Write data: must be maximum length of buffer
      -- as the rw length can be changed during running
      write_data : in  std_logic;
      read_data  : out std_logic_vector(2**depth-1 downto 0);

      -- Buffer occupancy and full/empty flags
      occupancy   : out std_logic_vector(depth downto 0);
      full, empty : out std_logic

      );
  end component;


  component decoderFSM
    generic (
      depth                :     natural := 4;  -- length of the input data (2**depth)
      -- Length of various bits in the data stream
      chipAddressLength    :     natural := chipLength;
      channelAddressLength :     natural := channelLength;
      levelOneLength       :     natural := LevelOneLength;
      bcLength             :     natural := BCIDLength;
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
      found_chipError  : out std_logic;

      -- Last L1ID
      last_levelOne_out : out std_logic_vector(levelOneLength-1 downto 0);
      last_bcID_out     : out std_logic_vector(bcLength-1 downto 0);

      -- Chip and channels flags
      hit_chip_address_out    : out std_logic_vector(chipAddressLength-1 downto 0);
      hit_channel_address_out : out std_logic_vector(channelAddressLength-1 downto 0);
      hit_pattern_out         : out std_logic_vector(hitPatternLength-1 downto 0);

      -- Interaction with the FIFO
      abc_fifo_data    : in  std_logic_vector(2**depth - 1 downto 0);
      fifo_read_length : out std_logic_vector(depth - 1 downto 0);
      fifo_occupancy   : in  std_logic_vector(depth downto 0);
      fifo_empty       : in  std_logic;
      readout_fifo     : out std_logic
      );

  end component;

  component dataGate_tom
    -- Keep default generics

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

  component readoutHist_tom
    generic(
      --STREAM_ID         : integer := 0;
      histogram_depth   : natural := 11;
      histogram_width   : natural := 16;
      max_address_count : natural := 1280

      );
    port(
      STREAM_ID : in integer;
      clk : in std_logic;               --
      rst : in std_logic;               --

      start_ro_i : in  std_logic;
      ready_out  : out std_logic;       --

      hst_rdPtr_out : out std_logic_vector(histogram_depth-1 downto 0);  --
      hst_rdData_i  : in  std_logic_vector(histogram_width-1 downto 0);  --
      hst_rdEn_out  : out std_logic;


      lls_o : out t_llsrc;
      lld_i : in std_logic;
      

      header_count     : in std_logic_vector(histogram_width-1 downto 0);
      hit_count        : in std_logic_vector(histogram_width-1 downto 0);
      error_count      : in std_logic_vector(histogram_width-1 downto 0);
      parseError_count : in std_logic_vector(histogram_width-1 downto 0)

      );
  end component;


  component generic_counter
    generic ( WIDTH               :     integer := 32);
    port (
      CLK, RESET, LOAD, INCREMENT : in  std_logic;
      DATA                        : in  unsigned(WIDTH-1 downto 0);
      Q                           : out unsigned(WIDTH-1 downto 0));
  end component;


  -- FIFO Reset
  signal rst_fifo : std_logic;

  -- Data Input
  signal abcdata        : std_logic;
  -- Data after the data gate
  signal headerDetected : std_logic;

  signal read_enable     : std_logic;
  signal isfull, isempty : std_logic;
  signal write_enable    : std_logic := '0';

  signal hro0_ready    : std_logic;
  signal readout_histo : std_logic := '0';

  signal debug_mode : std_logic := '0';

  signal fifo_data       : std_logic_vector(2**fifo_depth - 1 downto 0);
  signal abcBufferedData : std_logic;

  signal histo_occ       : std_logic_vector(histogram_width-1 downto 0);
  signal readout_address : std_logic_vector(addressLength-1 downto 0);

  signal LOneID_count : std_logic_vector(LevelOneLength-1 downto 0);
  signal BCID_count   : std_logic_vector(BCIDLength-1 downto 0);

  signal found_header    : std_logic;
  signal found_hit_reg   : std_logic;
  signal hit_channel     : std_logic_vector(channelLength-1 downto 0);
  signal hit_chip        : std_logic_vector(chipLength-1 downto 0);
  signal found_error     : std_logic;
  signal found_chipError : std_logic;

  -- counters
  signal header_count, hit_count, error_count, parseerror_count : unsigned(histogram_width-1 downto 0);

  signal fifo_occupancy : std_logic_vector(fifo_depth downto 0);
  signal read_length    : std_logic_vector(fifo_depth-1 downto 0);

  signal state : std_logic_vector(4 downto 0);

begin

  -- FIFO connections
-- Really reset the fifo if we find a trailer
-- Clears out the FIFO if inactive
  fifo : hawaiiFIFO
    generic map ( depth => fifo_depth )
    port map (
      clock             => clk,
      reset             => rst_fifo,
      rd                => read_enable,
      wr                => headerDetected,
      write_data        => abcBufferedData,
      read_length       => read_length,
      full              => isfull,
      empty             => isempty,
      read_data         => fifo_data,
      occupancy         => fifo_occupancy
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
      hit_channel_address_out => hit_channel,
      found_chipError         => found_chipError
      );

  gataDate : dataGate_tom
    port map (
      clock        => clk,
      reset        => rst,
-- Disable writing if error is found
-- ie give up looking for a trailer and start
-- looking for new header, but don't clear the buffer
      writeDisable => found_error,
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
      clock                                              => clk,
      reset                                              => rst,
      inputAddress(addressLength-1 downto channelLength) => hit_chip(addressLength-channelLength-1 downto 0),
      inputAddress(channelLength-1 downto 0)             => hit_channel,
      writeEnable                                        => found_hit_reg,
      readEnable                                         => readout_histo,
      histogram_occupancy                                => histo_occ,
      outputAddress                                      => readout_address
      );

  readout : readoutHist_tom
    generic map (
      --STREAM_ID         => STREAM_ID,
      histogram_depth   => addressLength,
      histogram_width   => histogram_width,
      max_address_count => maximum_channel
      )
    port map(
      STREAM_ID => STREAM_ID,
      clk               => clk,
      rst               => rst,

      start_ro_i => start_hstro_i,
      ready_out  => hro0_ready,

      hst_rdPtr_out => readout_address,

      hst_rdData_i => histo_occ,
      hst_rdEn_out => readout_histo,

      lls_o => lls_o,
      lld_i => lld_i,

      header_count     => std_logic_vector( header_count ),
      hit_count        => std_logic_vector( hit_count ),
      error_count      => std_logic_vector( error_count ),
      parseerror_count => std_logic_vector( parseerror_count )

      );

  header_counter : generic_counter
    generic map (
      width     => histogram_width
      )
    port map (
      clk       => clk,
      reset     => rst,
      increment => found_header,
      load      => '0',
      data      => "0000000000000000",
      q         => header_count
      );

  hit_counter : generic_counter
    generic map (
      width     => histogram_width
      )
    port map (
      clk       => clk,
      reset     => rst,
      increment => found_hit_reg,
      load      => '0',
      data      => "0000000000000000",
      q         => hit_count
      );

  chip_error_counter : generic_counter
    generic map (
      width     => histogram_width
      )
    port map (
      clk       => clk,
      reset     => rst,
      increment => found_chipError,
      load      => '0',
      data      => "0000000000000000",
      q         => error_count
      );

  error_counter : generic_counter
    generic map (
      width     => histogram_width
      )
    port map (
      clk       => clk,
      reset     => rst,
      increment => found_error,
      load      => '0',
      data      => "0000000000000000",
      q         => parseerror_count
      );

-- Connections

  abcdata  <= abcdata_i and en;
  rst_fifo <= (rst or (not headerDetected));

end architecture Behavioral;

