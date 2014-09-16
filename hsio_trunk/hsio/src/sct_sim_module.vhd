----------------------------------------------------------------------------
-- CERN
-- Author: Jens Dopke, Tom Barber
-- Credits: All the credits go to B. Demirkoz - It's her fault !
----------------------------------------------------------------------------
-- Filename:
--    sct_sim_module.vhd
-- Description:
--    Formatter embedded simulation giving module-like data for the rest of
--       readout chain. The number of hits is defineable and the strobe_out
--       of data is given by a level 1 trigger input.          
----------------------------------------------------------------------------
--
--    What is to be done for simulation of S
--
--  A total of five processe should be needed (could maybe be four):
--                         --- simulator_state  ---
--   - Processes running the State machine
--       Should be done, counting might be wrong though (by one bit each)
--       Needs a controlling instance to check whether I fucked it up...
--                         --- state_progress   ---
--   - Process progressing the present to the next state with each clock
--       Hands on new settings for chipnumber and hits
--                         --- config_transfer  ---
--   - A process depending on the state machine to transfer configuration
--     data into the internal config, which has got to be hold while
--     transferring a full simulated event into the rest of the formatter
--                         --- state_output     ---
--   - A process using the states to determine the data, which is to be
--     routed out of the simu. This sets parallel data at the beginning of
--     each state and routes it out through serial shifting
--                         --- output_mux       ---
--   - By looking at the simulation enable flag, this process selects
--     either simulated or real data to be forwarded to the rest of the
--     formatter for processing
--
--    Question one's gotta think about:
--
--   - Give capabilities of compressed events ?
--   - Switchable randomization ?
--   - Hit location should be increasing during an event, shouldn't it ?
--       (This is gonna be a tough one, when thinkin of randomization...)
--   - At the moment there is no buffering. If one event is being readout
--     when a trigger arrives, the event is skipped. This could lead to all
--     sorts of mis-synchronisation. Need some L1ID and BCID buffering perhaps?
--
--  Configuration bits
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

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.std_logic_unsigned.all;

library utils;
use utils.pkg_types.all;

library hsio;
use hsio.pkg_core_globals.all;

----------------------------------------------------------------------------
--PORT DECLARATION
----------------------------------------------------------------------------

entity sct_sim_module is
  generic(
  -- The top two bits of the chip number (to allow streams starting from 32 and 64)
  -- eg: "01" = column starting with chip number of 32
  --     "10" = column starting with chip number of 64
    CHIPOFFSET : slv2 := "00" 
  );
  port(
    --clk_in           : in  std_logic;   -- 40 MHz clock
    clk              : in  std_logic;   -- 80 MHz clock
    mode40_strobe_i       : in  std_logic;   -- 40 MHz clock strobe
    --rst_n_in         : in  std_logic;   -- Powerup global reset
    rst         : in  std_logic;
    rnd_seed         : in  std_logic_vector(7 downto 0);
    config_in        : in  std_logic_vector(31 downto 0);  -- configuration word for the sim_module
    level1_trigger   : in  std_logic;   -- Level 1 Trigger Input
    l1_trigger_count : in  std_logic_vector (3 downto 0);  -- count the number of L1
    bc_count         : in  std_logic_vector (7 downto 0);  -- count the number of BC
-- Single Link output
    outlink          : out std_logic
    );
end sct_sim_module;

architecture rtl of sct_sim_module is

----------------------------------------------------------------------------
--SIGNAL DECLARATION
----------------------------------------------------------------------------

  type sct_simu_state_typedef is (
    idle,
    send_header,
    send_event_id,
    send_empty_event,
    send_error,
    send_new_cluster,
    send_hit,
    send_trailer,
    send_config_readback,
    send_clock_by_two
    );

  signal nhitsincluster      : unsigned (1 downto 0)          := (others => '0');  -- number of hits in cluster (strobed from the config word)
  signal next_nhitsincluster : unsigned (1 downto 0)          := (others => '0');
  signal nhits               : unsigned (6 downto 0)          := (others => '0');  -- number of hits (strobed from the config word)
  signal next_nhits          : unsigned (6 downto 0)          := (others => '0');
  signal chipnum             : unsigned (6 downto 0)          := (others => '0');  -- chip number
  signal next_chipnum        : unsigned (6 downto 0)          := (others => '0');  -- now 7 bits wide (ABCD: 4 bits)
  signal config_i            : std_logic_vector(31 downto 0)  := (others => '0');  -- internal configuration word for the simulator
  signal bit_count           : unsigned (5 downto 0)          := (others => '0');  -- counter for where we are in the output
  signal next_bit_count      : unsigned (5 downto 0)          := (others => '0');
  signal serial_data_out     : std_logic_vector (31 downto 0) := (others => '0');  -- link output
  signal next_state          : sct_simu_state_typedef         := idle;  -- SCT Decoder FSM states
  signal pres_state          : sct_simu_state_typedef         := idle;  -- SCT Decoder FSM states 
  signal serial_data_in      : std_logic_vector (18 downto 0) := (others => '0');  -- from the random generator

----------------------------------------------------------------------------
--COMPONENT DECLARATION
----------------------------------------------------------------------------

  component sct_sim_lfsr is
    port(
      --clk_in           : in  std_logic;   -- 40 MHz clock
      clk         : in  std_logic;                     -- 80 MHz clock
      mode40_strobe_i  : in  std_logic;                     -- 40 MHz clock strobe
      --rst_n_in    : in  std_logic;                     -- Powerup global reset
      rst    : in  std_logic;                    
      rnd_seed_in : in  std_logic_vector(7 downto 0);  -- Random seed
      rnd_num     : out std_logic_vector(18 downto 0)  -- random number output
      );
  end component;


begin  --  Main Body of VHDL code

----------------------------------------------------------------------------
--COMPONENT INSTANTIATION
----------------------------------------------------------------------------

  random_generator : sct_sim_lfsr
    port map(
      --clk_in      => clk_in,
      clk         => clk,
      mode40_strobe_i  => mode40_strobe_i,
      --rst_n_in    => rst_n_in,
      rst    => rst,
      rnd_seed_in => rnd_seed,
      rnd_num     => serial_data_in
      );


--------------------------------------------------------------------------
-- SIGNALS
--------------------------------------------------------------------------

--------------------------------------------------------------------------
-- PROCESS DECLARATION
--------------------------------------------------------------------------

--some_process : process (
-- rst_n_in,
-- clk_in
-- )
--begin
-- if (rst_n_in = '0' or reset_cnt = '1') then
-- elsif rising_edge(clk_in) then
-- end if;
--end process;

--  output_mux : process (
--    config_i,
--    serial_data_out
--   )
--  begin
    outlink <= serial_data_out(0);
-- outlink <= '1';
--  end process;


  simulator_state : process (
    pres_state,
    next_state,
    bit_count,
    next_bit_count,
    level1_trigger,
    config_i,
    chipnum,
    next_chipnum,
    nhits,
    next_nhits,
    nhitsincluster,
    next_nhitsincluster,
    l1_trigger_count,
    bc_count,
    serial_data_in
    )
  begin
    -- default FSM values
    next_state          <= pres_state;
    next_bit_count      <= bit_count + "000001";
    next_chipnum        <= chipnum;
    next_nhitsincluster <= nhitsincluster;
    next_nhits          <= nhits;
    -- check for state transition conditions
    case pres_state is
--------------------------------------------------------------------------------
-- idle should move to send_header, in case a level 1 trigger is received
--------------------------------------------------------------------------------
      when idle =>
        if (config_i(1) = '0') then
          if (level1_trigger = '1') then
            next_state <= send_header;
          end if;
        else
          next_state <= send_clock_by_two;
        end if;
        next_bit_count <= "000000";
        next_chipnum   <= "0000000";
--------------------------------------------------------------------------------
-- send_header moves to send_event_id for now - no fancy error introduction...
--------------------------------------------------------------------------------
      when send_header =>
        next_chipnum <= "0000000";
        if (std_logic_vector(bit_count) = "000100") then
          next_state     <= send_event_id;
          next_bit_count <= "000000";
        end if;
--------------------------------------------------------------------------------
-- send_event_id should move to new_cluster for standard events, to raw data
-- sending in case of activated flags, and to trailers in case a trailer error
-- flag is to be raised for events.
--------------------------------------------------------------------------------
      when send_event_id =>
-- Initialise value of nhits
        next_nhits <= unsigned(config_i(25 downto 19));
        if (std_logic_vector(bit_count) = "001101") then
-- Decide here what to do: hits, errors, empty
-- frequency of error events, empty events depends on random numbers
-- Config register 2 determines config readback mode
          if (config_i(2) = '0') then   -- send an event
-- Should we send a full event or empty one?
            case (config_i(9 downto 8)) is
              when "00" =>              -- always send a hit
                next_state <= send_new_cluster;
              when "01" =>              -- half hit / half empty
                if (serial_data_in(0) = '0') then
                  next_state <= send_new_cluster;
                else
                  next_state <= send_empty_event;
                end if;
              when "10" =>  -- mostly empty, some hits (per strip every 128 events)
                if (serial_data_in(7 downto 0) = "00000000") then
                  next_state <= send_new_cluster;
                else
                  next_state <= send_empty_event;
                end if;
              when "11" =>              -- always an empty event
                next_state <= send_empty_event;
              when others =>
                next_state <= send_new_cluster;
            end case;

-- Also add probability that we send an error instead of hits
            case (config_i(11 downto 10)) is
              when "00" =>  -- always send hit/empty, so do nothing                                                                      
              when "01" =>              -- mostly OK, but some errors
                if (serial_data_in(15 downto 8) = "00000000") then
                  next_state <= send_error;
                else
                  next_state <= send_new_cluster;
                end if;
              when "10" =>              -- half OK / half error
                if (serial_data_in(8) = '0') then
                  next_state <= send_error;
                end if;
              when "11" =>              -- always an error
                next_state <= send_error;
              when others =>  -- stay OK                                 
            end case;

          else                          -- In this case send the config
            next_state <= send_config_readback;
          end if;
          next_bit_count <= "000000";
        end if;

--------------------------------------------------------------------------------
-- send_event_id moves to send_empty event if not hits are required, then
-- sends a trailer.
--------------------------------------------------------------------------------
      when send_empty_event =>
        if (std_logic_vector(bit_count) = "000011") then
          next_state     <= send_trailer;
          next_bit_count <= "000000";
        end if;

      when send_error =>
        if (std_logic_vector(bit_count) = "001101") then
          -- Check to see if we have reached the last chip
          if (std_logic_vector(chipnum) =
              std_logic_vector(config_i(18 downto 12))) then
            next_state <= send_trailer;
          else
            next_state   <= send_error;
            next_chipnum <= chipnum + "0000001";
          end if;
          next_bit_count <= "000000";
        end if;

      when send_config_readback =>
        if (std_logic_vector(bit_count) = "011110") then
          if (std_logic_vector(chipnum) =
              std_logic_vector(config_i(18 downto 12))) then
            next_state <= send_trailer;
          else
            next_state   <= send_config_readback;
            next_chipnum <= chipnum + "0000001";
          end if;
          next_bit_count <= "000000";
        end if;

      when send_clock_by_two =>
        if (std_logic_vector(bit_count) = "000011") then
          if (config_i(1) = '0') then
            next_state <= idle;               -- switched off clock by two
          else
            next_state <= send_clock_by_two;  -- continue
          end if;
          next_bit_count <= "000000";
        end if;
--------------------------------------------------------------------------------
-- send_event_id should move to new_cluster for standard events, to raw data
-- sending in case of activated flags, and to trailers in case a trailer error
-- flag is to be raised for events.
--------------------------------------------------------------------------------
      when send_new_cluster =>
        next_nhitsincluster <= unsigned(config_i(29 downto 28));
        if (std_logic_vector(bit_count) = "001111") then
          next_state     <= send_hit;
          next_bit_count <= "000000";
        end if;

--------------------------------------------------------------------------------
-- send_hit cycles through the number of wanted hits and sends them out
-- moves on to send_trailer after all chips were cycled through
-- otherwise goes back to send_new_cluster
--------------------------------------------------------------------------------
      when send_hit =>
        if (std_logic_vector(bit_count) = "000011") then
          if (nhitsincluster = 0) then
            if (nhits = 0) then
              if (std_logic_vector(chipnum) = std_logic_vector(config_i(18 downto 12))) then
                next_state <= send_trailer;
              else
                next_state   <= send_new_cluster;
                next_chipnum <= chipnum + "0000001";
                next_nhits   <= unsigned(config_i(25 downto 19));
              end if;
            else
              next_state <= send_new_cluster;
              next_nhits <= nhits - "0000001";   
            end if;
          else
            next_state          <= send_hit;
            next_nhitsincluster <= nhitsincluster - "01";   
          end if;
          next_bit_count <= "000000";
        end if;
--------------------------------------------------------------------------------
-- send_trailer sends out a trailer to finalize the event transfer
--------------------------------------------------------------------------------
      when send_trailer =>
        if (std_logic_vector(bit_count) = "001111") then
          next_state <= idle;
        end if;

      when others =>
        next_state     <= idle;
        next_chipnum   <= "0000000";
        next_bit_count <= "000000";
    end case;
  end process;

  state_progress : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        pres_state <= idle;
        bit_count  <= "000000";
        chipnum    <= "0000000";
      else
        if (mode40_strobe_i = '0') then
          pres_state     <= next_state;
          bit_count      <= next_bit_count;
          chipnum        <= next_chipnum;
          nhitsincluster <= next_nhitsincluster;
          nhits          <= next_nhits;
        end if;
      end if;
    end if;
  end process;

  state_output : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        serial_data_out <= (others => '0');
      else
        if (mode40_strobe_i = '0') then

          -- move the data stream on by one bit
          serial_data_out <= "0" & serial_data_out(31 downto 1);

--------------------------------------------------------------------------------
-- FOLLOWING should be the defining data_out state machinery
--------------------------------------------------------------------------------
          case pres_state is
--------------------------------------------------------------------------------
-- idle should move to send_header, in case a level 1 trigger is received
--------------------------------------------------------------------------------
            when idle =>
              serial_data_out <= (others => '0');
--------------------------------------------------------------------------------
-- send_header should move to different stages, after the header is sent,
-- depending on configuration data:
-- If failures shall be generated without data, then rise an error-flag
--
-- NB - all of the serial_data_out are read from right to left!
--------------------------------------------------------------------------
            when send_header =>
              if (std_logic_vector(bit_count) = "000000") then
-- Check if we want a custom header
                if (std_logic_vector(config_i(7 downto 3)) = "00000") then
-- preamble
                  serial_data_out(31 downto 0) <= "0000000000000" & "0000000000000010111";
                else
                  serial_data_out(31 downto 0) <= "0000000000000" & "00000000000000" &
                                                  std_logic(config_i(3)) & std_logic(config_i(4)) &
                                                  std_logic(config_i(5)) & std_logic(config_i(6)) &
                                                  std_logic(config_i(7));
                end if;
              end if;
--------------------------------------------------------------------------------
-- send_event_id should move to new_cluster for standard events, to raw data
-- sending in case of activated flags, and to trailers in case a trailer error
-- flag is to be raised for events.
--------------------------------------------------------------------------------
            when send_event_id =>
              if (std_logic_vector(bit_count) = "000000") then
-- Check config register to use internal or pre-defined lvl1id
-- General format for event headers:
-- bcid lvl1id data type (always 0)
-- serial_data_out(31 downto 0) <= "0000000000000" &"000001" & "00001101" & "1101" & "0";
                serial_data_out(31 downto 0) <= "0000000000000" &"000001" &
                                                std_logic(bc_count(0)) & std_logic(bc_count(1)) &
                                                std_logic(bc_count(2)) & std_logic(bc_count(3)) &
                                                std_logic(bc_count(4)) & std_logic(bc_count(5)) &
                                                std_logic(bc_count(6)) & std_logic(bc_count(7)) &
                                                std_logic(l1_trigger_count(0)) & std_logic(l1_trigger_count(1)) &
                                                std_logic(l1_trigger_count(2)) & std_logic(l1_trigger_count(3)) & "0";
              end if;

            when send_empty_event =>
              if (std_logic_vector(bit_count) = "000000") then
-- send the data block for an empty event
-- 0011: modified from the ACBD which was 001
                serial_data_out(31 downto 0) <= "0000000000000" &"0000000000000001100";
              end if;

            when send_error =>
              if (std_logic_vector(bit_count) = "000000") then
-- The error code can be 001: no data
-- 100: buffer error
-- nb, if the code is 111 or 010, then it is config readback and register readback respectively
                serial_data_out(31 downto 0) <= "0000000000" & "00000000"
                                                & "1"  -- separator
                                                & serial_data_in(3) & "0" & not serial_data_in(3)  -- error code
                                                & std_logic(chipnum(0)) & std_logic(chipnum(1))
                                                & std_logic(chipnum(2)) & std_logic(chipnum(3))
                                                & std_logic(chipnum(4))
--																& std_logic(chipnum(5)) & std_logic(chipnum(6))
																& CHIPOFFSET(0) & CHIPOFFSET(1) -- To allow constant offset of 32 or 64
                                                & "000";
              end if;

            when send_new_cluster =>
              if (std_logic_vector(bit_count) = "000000") then
-- Generate a new cluster for the current chip
-- Now the chip address is 7 bits wide for te upgrade
                serial_data_out(31 downto 0) <= "0000000000" &"000000" & serial_data_in(7 downto 1)
                                                & std_logic(chipnum(0)) & std_logic(chipnum(1))
                                                & std_logic(chipnum(2)) & std_logic(chipnum(3))
                                                & std_logic(chipnum(4))
--																& std_logic(chipnum(5)) & std_logic(chipnum(6))
																& CHIPOFFSET(0) & CHIPOFFSET(1) -- To allow constant offset of 32 or 64
																& "10";
																
-- serial_data_out(31 downto 0) <= "0000000000" &"000000" &
-- std_logic(l1_trigger_count(0)) & std_logic(l1_trigger_count(1)) &
-- std_logic(l1_trigger_count(2)) & std_logic(l1_trigger_count(3)) & "000" &
-- "0000000" & "10";
              end if;

            when send_hit =>
              if (std_logic_vector(bit_count) = "000000") then
                case (config_i(27 downto 26)) is
                  when "00" =>          -- fixed at 011
                    serial_data_out(31 downto 0) <=
                      x"0000000" & "110" & "1";
                  when "01" =>          -- fixed at 01X
                    serial_data_out(31 downto 0) <=
                      x"0000000" & "01" & serial_data_in(0) & "1";
                  when "10" =>          -- detector alignment x1x
                    serial_data_out(31 downto 0) <=
                      x"0000000" & serial_data_in(0) & "1" & serial_data_in(1) & "1";
                  when "11" =>          -- test mode xxx
                    serial_data_out(31 downto 0) <=
                      x"0000000" & serial_data_in(0) & serial_data_in(1) & serial_data_in(2) & "1";
                  when others =>  -- no hitmap, this shouldn't be possible!
                    serial_data_out(31 downto 0) <=
                      x"0000000" & "000" & "1";
                end case;

              end if;

-- Also add the possiblity for returning config readback mode
-- <000> <aaaaaaa> < 111> <cccc,cccc><1><cccc,cccc><1>
            when send_config_readback =>
              if (std_logic_vector(bit_count) = "000000") then
                serial_data_out(31 downto 0) <=
                  "0" & "1" &
                  serial_data_in(18 downto 11) & "1" &
                  serial_data_in(10 downto 3) & "111"
                  & std_logic(chipnum(0)) & std_logic(chipnum(1))
                  & std_logic(chipnum(2)) & std_logic(chipnum(3))
                  & std_logic(chipnum(4)) & std_logic(chipnum(5))
                  & std_logic(chipnum(6)) & "000";
              end if;

            when send_clock_by_two =>
              if (std_logic_vector(bit_count) = "000000") then
                serial_data_out(31 downto 0) <= "0000000000000" & "0000000000000010101";
              end if;
              
            when send_trailer =>
              if (std_logic_vector(bit_count) = "000000") then
                serial_data_out(31 downto 0) <= "0000000000000" & "0000000000000000001";
              end if;
            when others =>
          end case;  -- present state

-- perhaps try to introduce noise/bit flips into here??
-- The user defined noise level for link 0
          if (pres_state /= idle) then
            case (config_i(31 downto 30)) is
              when "11" =>              -- 1 in 2^19
                if (std_logic_vector(serial_data_in(18 downto 0)) = "0000000000000000000") then
                  serial_data_out <= serial_data_out(31 downto 1) & not(serial_data_out(0));
                end if;
              when "01" =>              -- 1 in 2^9
                if (std_logic_vector(serial_data_in(8 downto 0)) = "000000000") then
                  serial_data_out <= serial_data_out(31 downto 1) & not(serial_data_out(0));
                end if;
              when "10" =>              -- 1 in 4
                if (std_logic_vector(serial_data_in(1 downto 0)) = "00") then
                  serial_data_out <= serial_data_out(31 downto 1) & not(serial_data_out(0));
                end if;
              when others =>            -- default "00" no noise
            end case;
          end if;
          
        end if;  -- if we're not resetting
      end if;
    end if;
  end process;

  config_transfer : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        config_i <= "00000000000000000000000000000000";
      else
        if (mode40_strobe_i = '0') then
          case pres_state is
            when idle =>
              config_i <= config_in;
            when send_clock_by_two =>
              config_i <= config_in;
            when others =>
              config_i <= config_i;
          end case;
        end if;
      end if;
    end if;
  end process;

end rtl;

