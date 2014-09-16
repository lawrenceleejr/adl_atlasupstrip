----------------------------------------------------------------------------------
-- Company: University of Freiburg
-- Engineer: Tom Barber
-- 
-- Create Date:    16:11:35 03/11/2011 
-- Design Name: 
-- Module Name:    decoderFSM - Behavioral 
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
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;


entity decoderFSM is
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

end decoderFSM;

architecture Behavioral of decoderFSM is

-- All sorts of data constants
  constant header_data : std_logic_vector(4 downto 0) := "11101";

  -- define the states of FSM model
  type state_type is (
    idle,
    header,
    dataType,
    LOneID_BCID,
    SyncOne,
    DataHOne,
    DataHTwo,
    parseError,
    ChipChanAdd,
    SyncTwo,
    HitPatt,
    SyncThree,
    noHit,
    emptyEvent,
    errChipAdd,
    errorSep,
    regPatternOne,
    errSyncOne,
    regPatternTwo,
    errSyncTwo,
    regAdd,
    trailer
    );

-- States encoded into an output (mainly for debuggery)
  type state_encoded_array is array(state_type) of std_logic_vector(4 downto 0);
  constant state_encoded : state_encoded_array := (
    idle          => "00000",
    header        => "10111",
    dataType      => "00001",
    LOneID_BCID   => "00010",
    SyncOne       => "00100",
    DataHOne      => "00101",
    DataHTwo      => "00110",
    parseError    => "11111",
    ChipChanAdd   => "00111",
    SyncTwo       => "01001",
    HitPatt       => "01010",
    SyncThree     => "01011",
    noHit         => "01100",
    emptyEvent    => "01101",
    errChipAdd    => "01110",
    errorSep      => "01111",
    regPatternOne => "10010",
    errSyncOne    => "10101",
    regPatternTwo => "10111",
    errSyncTwo    => "11000",
    regAdd        => "11001",
    trailer       => "10000"
    );

-- Try an array with state_type as the index
  type state_integer_array is array(state_type) of integer range 0 to 2**depth;
-- Mapping of the state type with number of bits to read
  constant state_length : state_integer_array := (
    idle          => 0,                 -- Don't empty the buffer in idle
    header        => header_data'length,
    LOneID_BCID   => levelOneLength+bcLength,
    ChipChanAdd   => chipAddressLength+channelAddressLength,
    HitPatt       => hitPatternLength,  -- Hit pattern
    errChipAdd    => chipAddressLength,
    errorSep      => 3,                 -- Error/config/register seperator
    regAdd        => 5,                 -- Register readback address
    regPatternOne => 8,                 -- Register/config pattern 1
    regPatternTwo => 8,                 -- Register/config pattern 2
    others        => 1
    );

-- Map the state to an output

  signal next_state, current_state : state_type;

  signal fifo_read_length_next, fifo_read_length_internal, occupancy :
    integer range 0 to 2**depth;

  signal readout_fifo_internal : std_logic := '0';
  signal fifo_can_be_read      : std_logic;

  signal last_levelOne, last_levelOne_next :
    integer range 0 to 2**levelOneLength-1;
  signal last_bcID, last_bcID_next :
    integer range 0 to 2**bcLength-1;

  signal hit_chip_address, hit_chip_address_next :
    integer range 0 to 2**chipAddressLength-1;
  signal hit_channel_address, hit_channel_address_next :
    integer range 0 to 2**channelAddressLength-1;

begin


-- Convert internal signal to output
  fifo_read_length <= std_logic_vector( to_unsigned(fifo_read_length_internal, fifo_read_length'length ));
  occupancy        <= to_integer( unsigned(fifo_occupancy) );
  readout_fifo     <= readout_fifo_internal;
  fifo_can_be_read <= not(fifo_empty);

  -- Debug output of the current state
  fsm_status <= state_encoded(current_state);

  -- Readout length taken from the next state
  fifo_read_length_next <= state_length(next_state);

  -- Decoded output signals
  hit_chip_address_out    <= std_logic_vector( to_unsigned(hit_chip_address, hit_chip_address_out'length));
  hit_channel_address_out <= std_logic_vector( to_unsigned(hit_channel_address, hit_channel_address_out'length));
  last_levelOne_out       <= std_logic_vector( to_unsigned(last_levelOne, last_levelOne_out'length));
  last_bcID_out           <= std_logic_vector( to_unsigned(last_bcID, last_bcID_out'length));

  -- Clock process, move on state and latched signals
  state_reg : process(clock, reset)
  begin
    if (clock'event and clock = '1') then
      if (reset = '1') then
        current_state             <= idle;
        fifo_read_length_internal <= 0;
        last_levelOne             <= 0;
        last_bcID                 <= 0;

        hit_chip_address    <= 0;
        hit_channel_address <= 0;

      else
        -- Only move on the state when the fifo is read out
        -- This allows fifo to pipe enough data through
        -- before we move to next state
        last_levelOne <= last_levelOne_next;
        last_bcID     <= last_bcID_next;

        hit_chip_address    <= hit_chip_address_next;
        hit_channel_address <= hit_channel_address_next;

        if ((readout_fifo_internal = '1') or (decode_active = '0')) then
          current_state             <= next_state;
          fifo_read_length_internal <= fifo_read_length_next;
        else
          current_state             <= current_state;
          fifo_read_length_internal <= fifo_read_length_internal;
        end if;

      end if;
    end if;
  end process;

  -- Can we read out the FIFO?
  readout_fifo_internal <= fifo_can_be_read and not(reset);

  -- State logic
  -- This described the state transitions only
  -- State dependant behaviour is described below
  comb_logic : process(current_state, abc_fifo_data, decode_active)
  begin

    next_state <= current_state;

    if (decode_active = '0') then
      -- Always revert to idle if the decoder is inactive
      -- sort of like a reset
      next_state <= idle;
    else

      -- use case statement to show the 
      -- state transistion
      case current_state is
        when idle          =>
          -- This is special case, need to be told
          -- to expect a header by the data gate
          if (decode_active = '1') then
            next_state <= header;
          else
            next_state <= idle;
          end if;
        when header        =>
          -- Check header corresponds to expected
          if (abc_fifo_data(header_data'length-1 downto 0) = header_data) then
            next_state <= dataType;
          else
            next_state <= parseError;
          end if;
        when dataType      =>
          next_state   <= LOneID_BCID;
        when LOneID_BCID        =>
          next_state   <= SyncOne;
        when SyncOne       =>
          if (abc_fifo_data(0) = '1') then
            next_state <= DataHOne;
          else
            next_state <= parseError;
          end if;
        when DataHOne      =>
          -- If this bit is a "1", then it implies
          -- the start of a trailer, should
          -- go back to idle
          if (abc_fifo_data(0) = '0') then
            next_state <= DataHTwo;
          else
            next_state <= trailer;
          end if;
        when DataHTwo      =>
          -- DataHOne & DataHTwo = "01"  --> a hit
          --                     = "00"  --> could be no hit, error or config
          if (abc_fifo_data(0) = '1') then
            next_state <= ChipChanAdd;
          else
            next_state <= noHit;
          end if;
        when parseError    =>
          -- Keep error state until deactived
          if (decode_active = '0') then
            next_state <= idle;
          else
            next_state <= parseError;
          end if;
        when ChipChanAdd   =>
          next_state   <= SyncTwo;
        when SyncTwo       =>
          if (abc_fifo_data(0) = '1') then
            next_state <= HitPatt;
          else
            next_state <= parseError;
          end if;
        when HitPatt       =>
          next_state   <= SyncThree;
        when SyncThree     =>
          -- There is a complication with sync bit 3
          -- * No probs if it is a zero, then go back to DataHTwo
          -- * But if it is a one, could have could be:
          ------------------------------------------
          -- 01,aaaaaaaa,ccccccc,1,hhh,1,hhh,
          --                           ^
          --                          SyncThree
          -- Or:
          ------------------------------------------
          -- 01,aaaaaaaa,ccccccc,1,hhh,1,0000000000000000
          --                           ^
          --                          SyncThree
          --
          -- ie, start of another hit, or a trailer
          -- complicated by hit patters of '000'
          -- Easiest solution is to check the decode active
          -- but to see if data gate has found a trailer already
          if (decode_active = '0') then
            next_state <= idle;
          elsif (abc_fifo_data(0) = '0') then
            next_state <= DataHTwo;
          else
            next_state <= HitPatt;
          end if;
        when noHit         =>
          -- Could either be "0011" (no hit)
          --                    ^
          -- or              "000" (error or config)
          --                    ^
          if (abc_fifo_data(0) = '1') then
            next_state <= emptyEvent;
          else
            next_state <= errChipAdd;
          end if;
        when emptyEvent    =>
          -- Has to be "0011" to be an empty event
          --               ^
          if (abc_fifo_data(0) = '1') then
            next_state <= DataHOne;
          else
            next_state <= parseError;
          end if;
        when errChipAdd    =>
          -- Wait for the chip address 
          next_state   <= errorSep;
        when errorSep      =>
          -- Could now be either an error or config/register readout
          if (abc_fifo_data(2 downto 0) = "111") then
            next_state <= regPatternOne;
          elsif (abc_fifo_data(2 downto 0) = "010") then
            next_state <= regAdd;
          elsif ((abc_fifo_data(2 downto 0) = "001") or (abc_fifo_data(2 downto 0) = "100")) then
                                         -- In the case of error, go straight to second error bit
            next_state <= errSyncTwo;
          else
            next_state <= parseError;
          end if;
        when regAdd        =>
          -- Four bit register address
          next_state   <= regPatternOne;
        when regPatternOne =>
          -- Eight bit address data
          next_state   <= errSyncOne;
        when errSyncOne    =>
          if (abc_fifo_data(0) = '1') then
            next_state <= regPatternTwo;
          else
            next_state <= parseError;
          end if;
        when regPatternTwo =>
          next_state   <= errSyncTwo;
        when errSyncTwo    =>
          if (abc_fifo_data(0) = '1') then
            next_state <= DataHOne;
          else
            next_state <= parseError;
          end if;
        when trailer       =>
          -- Trailer should always be zero
          if (abc_fifo_data(0) = '0') then
            next_state <= trailer;
          else
            next_state <= parseError;
          end if;
        when others        =>
          next_state   <= idle;
      end case;

    end if;

  end process;


-- Syncronous decoded signals
  hit_out : process(current_state, readout_fifo_internal,

                    hit_chip_address, hit_channel_address, last_levelOne, last_bcID, abc_fifo_data

                    )
  begin

    found_hit                <= '0';
    hit_chip_address_next    <= hit_chip_address;
    hit_channel_address_next <= hit_channel_address;
    last_levelOne_next       <= last_levelOne;
    last_bcID_next           <= last_bcID;

    hit_pattern_out  <= (others => '0');
    found_header     <= '0';
    found_parseError <= '0';
    found_chipError  <= '0';

    if (readout_fifo_internal = '1') then

      found_hit        <= '0';
      found_header     <= '0';
      found_parseError <= '0';

      hit_chip_address_next    <= hit_chip_address;
      hit_channel_address_next <= hit_channel_address;
      hit_pattern_out          <= (others => '0');


      case current_state is
        when idle       =>              -- reset all the latched signals
          hit_chip_address_next      <= 0;
          hit_channel_address_next   <= 0;
                                        -- Do we want the L1ID and BCID
                                        -- to reset between events?
                                        -- Uncomment the lines below if so!
                                        --last_levelOne_next <= 0;
                                        --last_bcID_next <= 0;
        when header     =>
                                        -- Make sure we have a valid header before declaring it
          if (abc_fifo_data(header_data'length-1 downto 0) = header_data) then
            found_header             <= '1';
          end if;
        when LOneID_BCID=>
          last_bcID_next             <= to_integer( unsigned(abc_fifo_data(bcLength-1 downto 0)));
          last_levelOne_next         <= to_integer( unsigned(abc_fifo_data(bcLength+levelOneLength-1 downto bcLength)));
        when ChipChanAdd=>
          hit_channel_address_next   <= to_integer( unsigned(abc_fifo_data(channelAddressLength-1 downto 0)));
          hit_chip_address_next      <= to_integer( unsigned(abc_fifo_data(channelAddressLength+chipAddressLength-1 downto channelAddressLength)));
        when errChipAdd =>
          hit_chip_address_next      <= to_integer( unsigned(abc_fifo_data(chipAddressLength-1 downto 0)));
        when HitPatt    =>
                                        -- Veto any 000 hit patterns
          if (abc_fifo_data(hitPatternLength-1 downto 0) /= "000") then
            found_hit                <= '1';
          else
            found_hit                <= '0';
          end if;
          hit_pattern_out            <= abc_fifo_data(hitPatternLength-1 downto 0);
        when SyncThree  =>
                                        -- After sync bit three (after the hit pattern)
                                        -- increment the hit channel in anticipation of an
                                        -- adjancent hit.
                                        -- Don't want to go out of range of the integer
          if (hit_channel_address < (2**channelAddressLength-1)) then
            hit_channel_address_next <= hit_channel_address + 1;
          end if;
        when errSyncTwo =>
          found_chipError            <= '1';
        when parseError =>
          found_parseError           <= '1';
        when others     =>

      end case;

    end if;

  end process;




end Behavioral;


-- q(0) <= sig;
-- process (clk)
-- If rising_edge(clk) then
-- q(1) <= q(0);
-- enf if;
-- end process;
--
-- sig_rising <= '1' when (q = "01") else '0';



