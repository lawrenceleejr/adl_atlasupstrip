----------------------------------------------------------------------------------
-- Company:   University of Freiburg
-- Engineer:  Tom Barber (tom.barber@cern.ch)
-- 
-- Create Date:    13:12:21 03/09/2011 
-- Design Name: 
-- Module Name:    hawaiiFIFO - Behavioral 
-- Project Name:   ATLAS Strips Upgrade HSIO
-- Target Devices: 
-- Tool versions: ISE 13.4
-- Description: Was a generic FIFO, now shift register with occupancy
--
--    * The FIFO can hold 2**depth std_logic values.
--    * It can be read out with variable length.
--    * An occupancy counter takes care of the full/empty flags
--    ** if full: write is ignored
--    ** if empty: read is ignored
--    * Last item written is found at address 0
--
-- Dependencies: None
--
-- Revision: 
-- Revision 0.01 - File Created
-- Revision 0.02 - Bruce Gallop changed from FIFO to shift register (to remove address lookup logic)
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;


entity hawaiiFIFO is
  generic (
    depth : natural := 4                -- fifo will be 2**depth bits deep
    );
  port (

    clock, reset : in std_logic;        -- clock and reset
    rd, wr       : in std_logic;        -- read / write enable (are these needed)

    -- Length in bits of read
    read_length : in std_logic_vector(depth-1 downto 0);

    -- Read and Write data: must be maximum length of buffer
    -- as the rw length can be changed during running
    write_data : in  std_logic;
    read_data  : out std_logic_vector(2**depth-1 downto 0);

    -- Buffer occupancy and full/empty flags
    occupancy   : out std_logic_vector(depth downto 0);
    full, empty : out std_logic

    );
end hawaiiFIFO;

architecture Behavioral of hawaiiFIFO is

-- What is the maximum occupancy
  constant max_occupancy : integer := 2**depth;

-- The shift register itself
-- Could be expanded as an array of vectors if required?
  signal array_reg : std_logic_vector(max_occupancy-1 downto 0);

-- Status signals
  signal full_reg, empty_reg :
    std_logic := '0';
  signal wr_op, full_and_empty : std_logic_vector(1 downto 0);
  signal wr_en                 : std_logic;

  -- Internal occupancy and length signals
  -- as integers (arithmatic is easier)
  signal occupancy_internal, occupancy_next,
    read_length_internal : integer range 0 to max_occupancy;

begin

--------------------------------------------------------
-- Write data to register from input
--------------------------------------------------------
  process(clock, reset)
  begin
    if (clock'event and clock = '1') then  -- rising clock
      if (reset = '1') then
        -- Reset all of the FIFO values
        array_reg <= (others => '0');
      else
-- Only output if writing is enabled
        if (wr_en = '1') then
-- Write input at index 0 and shift remainder
          array_reg <= array_reg(max_occupancy-2 downto 0) & write_data;
        end if;
      end if;
    end if;
  end process;

-- Output
-- Always output something
  process (array_reg, reset)
  begin
    if (reset = '1') then
      read_data      <= (others => '0');
    else
      read_data      <= array_reg;
    end if;
  end process;

--------------------------------------------------------
-- Write enable if FIFO is not full
--------------------------------------------------------
  wr_en <= wr and (not full_reg);

--------------------------------------------------------
-- FIFO control Logic
--------------------------------------------------------
-- Register for read and write pointers
  process(clock, reset)
  begin
    if (clock'event and clock = '1') then
      if (reset = '1') then             -- reset all signals
        occupancy_internal <= 0;
      else
        occupancy_internal <= occupancy_next;
      end if;
    end if;
  end process;

------------------------------------------------------------
-- Successive pointer values
------------------------------------------------------------
-- Convert external signals to internal integers
  read_length_internal  <= to_integer( unsigned(read_length) );

-- This checks the occupancy and the length of
-- read/write to see if the buffer is full or empty
  process(occupancy_internal, read_length_internal)
  begin

    -- Make sure the occupancy is large enough to read out
    -- a chunk of data read_length bits long
    if (occupancy_internal < read_length_internal) then
      empty_reg <= '1';
    else
      empty_reg <= '0';
    end if;

    -- Also, make sure the buffer is empty enough to write
    -- a chunk of data write_length (constant 1) bits long
    if ( (max_occupancy - occupancy_internal) < 1 ) then
      full_reg <= '1';
    else
      full_reg <= '0';
    end if;

  end process;


-- Next-state logic
  wr_op          <= wr & rd;            -- Read and write strobed together
  full_and_empty <= full_reg & empty_reg;



  process(wr_op, full_and_empty,
          empty_reg, rd, wr, occupancy_internal,
          read_length_internal, full_reg)

  begin
    occupancy_next <= occupancy_internal;

    -- If we are reading AND writing, and are neither full nor
    -- empty, then increment both pointers, and update BOTH occupancies
    if (( wr_op = "11" ) and ( full_and_empty = "00" ) ) then
      -- Need some additional checks in case we get a negative number
      if ((occupancy_internal + 1) >= read_length_internal) then
        occupancy_next <= occupancy_internal - read_length_internal + 1;
      end if;
      -- Just read
    elsif (( rd = '1' ) and ( empty_reg /= '1')) then
      if (occupancy_internal >= read_length_internal) then
        occupancy_next <= occupancy_internal - read_length_internal;
      end if;
      -- Just Write
    elsif (( wr = '1' ) and ( full_reg /= '1' )) then
      occupancy_next <= occupancy_internal + 1;
    end if;

  end process;

-- Output
  full  <= full_reg;
  empty <= empty_reg;

  occupancy <= std_logic_vector( to_unsigned(occupancy_internal, occupancy'length) );


end Behavioral;

