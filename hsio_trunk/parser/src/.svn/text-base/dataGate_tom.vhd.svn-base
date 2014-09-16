-- dataGate.vhd
-- Code: Alex Law
-- Comments: Tom Barber
--
-- The dataGate only lets data through when it detects a header
-- and stops when after trailer is found
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity dataGate_tom is
  generic(
    headerLength  : integer                   := 5;
    header        : std_logic_vector(0 to 4)  := "11101";
    trailerLength : integer                   := 16;
    trailer       : std_logic_vector(0 to 15) := "1000000000000000"
    );

  port(
    clock        : in  std_logic;
    reset        : in  std_logic;
    writeDisable : in  std_logic;       -- override write enable out but don't reset buffer
    dataBit      : in  std_logic;
    outBit       : out std_logic := '0';
    wrEnOut      : out std_logic := '0'
    );
end dataGate_tom;

architecture Behavioral of dataGate_tom is

--constant buffLength : integer := trailerLength+headerLength;
  constant buffLength  : integer := trailerLength+1;
--constant tapPosition : integer := buffLength-(headerLength+1);
  constant tapPosition : integer := 0;

  signal dataGate      : std_logic_vector(0 to buffLength-1) := (others => '0');
  signal dataGate_next : std_logic_vector(0 to buffLength-1) := (others => '0');
  signal wrEn          : std_logic                           := '0';
  signal wrEn_next     : std_logic                           := '0';

begin


  process(clock, reset, writeDisable)
  begin


    if (clock'event and clock = '1') then
      if(reset = '1') then
        dataGate <= (others => '0');
        wrEn     <= '0';

      else

        dataGate <= dataGate_next;

        if(writeDisable = '1') then
          wrEn <= '0';                  -- Reset write enable, but don't clear the buffer
        else
          wrEn <= wrEn_next;
        end if;
      end if;
    end if;
  end process;

  outBit        <= dataGate(tapPosition) and wrEn;
  wrEnOut       <= wrEn;
  dataGate_next <= dataGate(1 to buffLength-1) & dataBit;

  process(dataGate, wrEn)
  begin
    if( dataGate( tapPosition+1 to tapPosition+headerLength) = header ) then
      wrEn_next <= '1';
    elsif ( dataGate(0 to trailerLength-1) = trailer ) then
      wrEn_next <= '0';
    else
      wrEn_next <= wrEn;
    end if;

  end process;


end Behavioral;



