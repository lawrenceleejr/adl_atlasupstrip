
LIBRARY ieee;
use work.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity bpmencoder is 
   port (
     clock      : in std_logic;
     rst        : in std_logic;
     clockx2    : in std_logic;
     datain     : in std_logic;
     encode     : in std_logic;
     dataout    : out std_logic
     );
end bpmencoder;

architecture BPMENCODER of bpmencoder is

  signal bmp: std_logic;

begin

  process(clockx2, rst) 
  begin
    if(rst='1') then
      bmp<='0';
    elsif(clockx2'event and clockx2='1') then
      if(clock='1' or datain='1')then
        bmp<=not bmp;
      end if;
    end if;
  end process;

  with encode select
      dataout<= datain when '0',
                bmp when '1',
                datain when others;

end BPMENCODER;
