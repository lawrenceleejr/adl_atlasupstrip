library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity dataGate is
generic(
      headerLength  : integer :=5;
      header        : std_logic_vector(0 to 4) := "11101";
      trailerLength : integer :=16;
      trailer       : std_logic_vector(0 to 15) := "1000000000000000"
      );

port(
      clock : in std_logic;
      reset : in std_logic;
      dataBit : in std_logic;
      outBit : out std_logic :='0';
      wrEnOut : out std_logic := '0'
      );
end dataGate;

architecture Behavioral of dataGate is

constant buffLength : integer := trailerLength+1;
constant tapPosition : integer := 0;

signal dataGate : std_logic_vector(0 to buffLength-1) := (others =>'0');
signal dataGate_next : std_logic_vector(0 to buffLength-1) := (others =>'0');
signal wrEn : std_logic :='0';
signal wrEn_next : std_logic :='0';

begin

process(clock, reset)
begin
if(reset='1') then
   dataGate <= (others => '0');
   wrEn <= '0';
elsif(clock'event AND clock = '1') then
   dataGate <= dataGate_next;
   wrEn <= wrEn_next;
end if;
end process;
outBit <= dataGate(tapPosition) AND wrEn;
wrEnOut <= wrEn;
dataGate_next <= dataGate(1 to buffLength-1) & dataBit;

process(clock, dataGate, wrEn)
begin
   if( dataGate(tapPosition to tapPosition+headerLength) = header ) then
      wrEn_next <= '1';
   elsif ( dataGate(tapPosition+1 to tapPosition+trailerLength) = trailer ) then
      wrEn_next <= '0';
   else
      wrEn_next <= wrEn;
   end if;
end process;


end Behavioral;

