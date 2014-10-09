--------------------------------------------------------------
-- Serializer for High Speed I/O board (ATLAS Pixel teststand)
-- Martin Kocian 01/2009
--------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use work.all;

--------------------------------------------------------------

entity ser32 is

port(	clk: 	    in std_logic;
        ld:         out std_logic;
        go:         in std_logic;
        busy:       out std_logic;
        stop:       in std_logic;
	rst:	    in std_logic;
	d_in:	    in std_logic_vector(31 downto 0);
	d_out:	    out std_logic
);
end ser32;

--------------------------------------------------------------

architecture SER of ser32 is

signal reg : std_logic_vector(31 downto 0);
signal counter: std_logic_vector(4 downto 0);
signal going: std_logic;

begin

    busy<=going;
    d_out<=reg(31);
    process(rst, clk)

    begin
        if(rst='1') then
          reg<=x"00000000";
          going<='0';
          ld<='0';
        elsif (clk'event and clk='1') then
            if (go='1')then
              going<='1';
              counter<="00000";
            else
              if (stop='1' and counter="00011") then
               going<='0';  
              end if;      
              if(counter="00010" and going='1') then  -- it takes 2 cycles to
                ld<='1';                               -- get data from the FIFO;
              elsif(counter="00001" and going='1') then
                ld<='0';                -- Request is only 1 cycle long.
              end if;
              if  (counter="00000" and going='1') then
               reg<=d_in; 
              else 
               reg(31 downto 1)<=reg(30 downto 0);
               reg(0)<='0';
              end if;
              counter<=unsigned(counter)-1;
            end if;
 	end if;
    
    end process;		

end SER;

--------------------------------------------------------------
