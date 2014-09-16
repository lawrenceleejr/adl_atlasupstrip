----------------------------------------------------------------------------------
-- Company: University of Freiburg
-- Engineer: Tom Barber (thomas.barber@physik.uni-freiburg)
-- 
-- Create Date:    10:29:58 03/21/2011 
-- Design Name: Strips upgrade histogramming
-- Module Name:    histogrammer - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
-- This should serve as a general histogrammer, implemented as a four-state FSM. 
-- (Perhaps this is overkill?) I couldn't get it to work with a simpler model...
-- Histogram waits to recieve a write signal, after which it reads the current
-- value n of the current address in RAM. On the next clock, it moves to write
-- to write a value of n+1, before returning to idle.
--
-- I think at the moment it requires a 2 clock latency to do this (ie, can't have
-- two writes in successive ticks (they will be ignored).
--
-- If read mode is enabled, the histogrammer strobes the output address to the
-- requested output, vetoing any write operations that may occur.
-- This has a latency of 1 clock tick, so the output will appear 1 tick after
-- requested.
--
-- On the clock tick following readout, the previous bin is also zeroed
-- (maybe have a switch for this eventually?)
--
-- Dependencies:
-- Needs the Xilinx core generator to create a Dual Block RAM Core
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity histogrammer is

  generic (
-- These cannot be changed once the core has
-- been generated!
-- If the core is regenerated with different
-- values, these need to be changed too...
-- Would be nice to specify generics for this, but
-- I think it is fixed in the core
    histogram_depth   : natural := 11;
    histogram_width   : natural := 16;
    max_address_count : natural := 1280
    );
  port (

    clock, reset : in std_logic;        -- clock and reset
    inputAddress : in std_logic_vector(histogram_depth-1 downto 0);  -- read address
    writeEnable  : in std_logic;        -- when to increment the buffer

    readEnable          : in  std_logic;  -- readout
    outputAddress       : in  std_logic_vector(histogram_depth-1 downto 0);  -- readout address
    histogram_occupancy : out std_logic_vector(histogram_width-1 downto 0)  -- histogrammed value

    );

end histogrammer;

architecture Behavioral of histogrammer is

  -- define the states of histogram FSM
  type state_type is (
    idle,                               -- wait 
    read_bin,                           -- read n
    write_bin,                          -- write n+1
    read_out                            -- readout address (veto writing)
    );

  signal next_state, current_state : state_type;

  component histogram
    port (
      clka  : in  std_logic;
      wea   : in  std_logic_vector(0 downto 0);
      addra : in  std_logic_vector(histogram_depth-1 downto 0);
      dina  : in  std_logic_vector(histogram_width-1 downto 0);
      douta : out std_logic_vector(histogram_width-1 downto 0);
      clkb  : in  std_logic;
      web   : in  std_logic_vector(0 downto 0);
      addrb : in  std_logic_vector(histogram_depth-1 downto 0);
      dinb  : in  std_logic_vector(histogram_width-1 downto 0);
      doutb : out std_logic_vector(histogram_width-1 downto 0));
  end component;

  signal bin_occupancy, bin_occupancy_next, bin_occupancy_incr :
    integer range 0 to 2**histogram_width-1 := 0;

  signal bin_occupancy_bits, bin_occupancy_bits_next :
    std_logic_vector(histogram_width-1 downto 0) := (others => '0');

  signal input_address_integer, output_address_integer :
    integer range 0 to 2**histogram_width-1;

  signal internal_input_address, internal_output_address,
    internal_input_address_cut, internal_output_address_cut,
    internal_output_address_last :
    std_logic_vector(histogram_depth-1 downto 0);

  signal internal_write_enable : std_logic := '0';



begin

  histoMem : histogram
    port map(
      addra  => internal_input_address,   -- use a to write
      addrb  => internal_output_address,  -- use b to read
      clka   => clock,
      clkb   => clock,
      dina   => bin_occupancy_bits_next,  -- write occupancy
      dinb   => "0000000000000000",
      douta  => open,
      doutb  => bin_occupancy_bits,       -- read occupancy
      wea(0) => internal_write_enable,    -- write enable
      web    => "0"                       -- never write using b
      );


  bin_occupancy <= to_integer( unsigned(bin_occupancy_bits));

  input_address_integer  <= to_integer( unsigned(inputAddress) );
  output_address_integer <= to_integer( unsigned(outputAddress) );

  histogram_occupancy <= bin_occupancy_bits;

  internal_output_address <= internal_input_address_cut(histogram_depth-1 downto 0) when (current_state = read_bin)
                             else internal_output_address_cut(histogram_depth-1 downto 0);

  internal_output_address_cut <= std_logic_vector( to_unsigned(output_address_integer, internal_output_address_cut'length)) when
                                 (output_address_integer < max_address_count) else (others => '0');
  internal_input_address_cut  <= std_logic_vector( to_unsigned(input_address_integer, internal_input_address_cut'length))   when
                                 (input_address_integer < max_address_count)  else (others  => '0');


  process(reset, clock) is
  begin
    if rising_edge(clock) then
      if (reset = '1') then
        current_state                <= idle;
        internal_output_address_last <= (others => '0');
      else
        -- move the state on every clock tick
        current_state                <= next_state;
        -- need to buffer the output address so it can be cleared
        -- on the next clock
        internal_output_address_last <= internal_output_address_cut;

        case current_state is

          when idle                            =>
            internal_input_address  <= (others => '0');
            internal_write_enable   <= '0';
            bin_occupancy_bits_next <= (others => '0');
          when read_bin                        =>
            internal_input_address  <= internal_input_address_cut(histogram_depth-1 downto 0);
            internal_write_enable   <= '0';
            bin_occupancy_bits_next <= (others => '0');
          when write_bin                       =>
            internal_write_enable   <= '1';
            bin_occupancy_bits_next
                                    <= std_logic_vector( to_unsigned(bin_occupancy + 1, histogram_width));
          when read_out                        =>
                                        -- Also start to zero bins that have already been read out
            internal_write_enable   <= '1';
            bin_occupancy_bits_next <= (others => '0');
            internal_input_address  <= internal_output_address_last;
          when others                          =>

        end case;
      end if;

    end if;
  end process;


  state_logic : process(current_state, readEnable, writeEnable, input_address_integer,
                        output_address_integer, internal_output_address_last)
  begin

    case current_state is
      when idle      =>
        if ((readEnable = '1') and (output_address_integer < max_address_count)) then
          next_state <= read_out;
        elsif ((writeEnable = '1') and (input_address_integer < max_address_count)) then
                                        -- Read the bin first
          next_state <= read_bin;
        else
          next_state <= idle;
        end if;
      when read_bin  =>
                                        -- Now write it
        next_state   <= write_bin;
      when write_bin =>
        next_state   <= idle;
      when read_out  =>
                                        -- Continue readout until the input pin goes low
        if ((readEnable = '1') and (output_address_integer < max_address_count)) then
          next_state <= read_out;
        else
          next_state <= idle;
        end if;

      when others =>
        next_state <= idle;
    end case;

  end process;

-- read_write: process(current_state, output_address_integer)
-- begin
--
--  --      if (rising_edge(clock)) then
--              
--                      case current_state is
--                      
--                              when idle =>
--                                              internal_input_address <= (others => '0');
--                                              internal_output_address <= (others => '0');
--                                              internal_write_enable <= '0';   
--                                              bin_occupancy_bits_next <= (others => '0');
--                                              histogram_occupancy <= (others => '0');                         
--                              when read_bin =>
--                                              internal_output_address <= inputAddress(histogram_depth-1 downto 0);
--                                              internal_input_address <= inputAddress(histogram_depth-1 downto 0);
--                                              internal_write_enable <= '0';
--                                              bin_occupancy_bits_next <= (others => '0');
--                              when write_bin =>
--                                      internal_write_enable <= '1';
--                                      bin_occupancy_bits_next
--                                              <= std_logic_vector( to_unsigned(bin_occupancy + 1, histogram_width));                          
--                              when read_out =>
--                                      -- Start reading out
--                                      internal_output_address <=
--                                              std_logic_vector( to_unsigned(output_address_integer, internal_output_address'length));
--                                              
--                              when continue_read_out =>
--                                      internal_output_address <=
--                                              std_logic_vector( to_unsigned(output_address_integer, internal_output_address'length));
--
--                                      -- Also start to zero bins that have already been read out
--                                      internal_write_enable <= '1';
--                                      bin_occupancy_bits_next <= (others => '0');
--                                      internal_input_address <= internal_output_address_last;
--                                      histogram_occupancy <= bin_occupancy_bits;                                                      
--                      
-- when stop_read_out =>
--                                      -- Stop reading, but continue to erase last bin read out
--                                      internal_write_enable <= '1';
--                                      bin_occupancy_bits_next <= (others => '0');
--                                      internal_input_address <= internal_output_address_last;
--                                      histogram_occupancy <= (others => '0');         
--                      
--                              when others =>
--                      
--                      end case;
--              
--  --end if;
--		
--	end process;

end Behavioral;

