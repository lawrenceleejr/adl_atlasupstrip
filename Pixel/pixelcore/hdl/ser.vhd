--------------------------------------------------------------
-- Serializer for High Speed I/O board (ATLAS Pixel teststand)
-- Martin Kocian 01/2009
--------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use work.all;

--------------------------------------------------------------

entity ser is

port(	clk: 	    in std_logic;
        ld:         out std_logic;
        l1a:        in std_logic;
        go:         in std_logic;
        busy:       out std_logic;
        stop:       in std_logic;
	rst:	    in std_logic;
	d_in:	    in std_logic_vector(15 downto 0);
	d_out:	    out std_logic
);
end ser;

--------------------------------------------------------------

architecture SER of ser is

signal reg : std_logic_vector(15 downto 0);
signal busys: std_logic;
signal counter: std_logic_vector(3 downto 0);
signal l1acounter: std_logic_vector(2 downto 0);
signal going: std_logic;
signal oldl1a: std_logic;

begin

  busy<=busys;

    process(rst, clk)

    begin
        if(rst='1') then
          reg<=x"0000";
          d_out<='0';
          going<='0';
          ld<='0';
          l1acounter<="000";
          oldl1a<='0';
          busys<='0';
        elsif (clk'event and clk='1') then
            if (go='1' and stop='0' and busys='0')then
              going<='1';
              counter<="0010";
              busys<='1';
            else
              if (stop='1' and counter="0011") then
               going<='0';  
              end if;      
              if(counter="0010" and going='1') then  -- it takes 2 cycles to
                ld<='1';                               -- get data from the FIFO;
              elsif(counter="0001" and going='1') then
                ld<='0';                -- Request is only 1 cycle long.
              end if;
              if  (counter="0000" and going='1') then
               reg<=d_in; 
              elsif (l1acounter="101")then
                reg<=x"e800";
              else 
               reg(15 downto 1)<=reg(14 downto 0);
               reg(0)<='0';
              end if;
              if(l1acounter="010")then
                busys<='0';
              elsif(going='0' and counter="0000" and l1acounter="000") then
                busys<='0';
              end if;
              if(l1a='1' and oldl1a='0' and busys='0')then
                l1acounter<="101";
                busys<='1';
              elsif(l1acounter/="000")then
                l1acounter<=unsigned(l1acounter)-1;
              end if;
              counter<=unsigned(counter)-1;
              d_out<=reg(15);
            end if;
            oldl1a<=l1a;
 	end if;
    
    end process;		

end SER;

--------------------------------------------------------------
