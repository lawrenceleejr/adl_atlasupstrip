--------------------------------------------------------------
-- Serializer for High Speed I/O board (ATLAS Pixel teststand)
-- Martin Kocian 01/2009
--------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use work.all;

--------------------------------------------------------------

entity deser10b is
port(	clk: 	    in std_logic;
	rst:	    in std_logic;
	d_in:	    in std_logic;
	align:	    in std_logic;
	d_out:	    out std_logic_vector(9 downto 0);
        ld:         out std_logic
);
end deser10b;

--------------------------------------------------------------

architecture DESER10B of deser10b is

signal reg : std_logic_vector(9 downto 0);
signal index : std_logic_vector(3 downto 0);
signal aligned: std_logic;

begin
    process(rst, clk)
    begin
        if(rst='1') then
          reg<=x"00"&"00";
          index<=x"0";
          ld<='0';
          aligned<='0';
        elsif (clk'event and clk='1') then
          if(align='1' and (aligned='0' or index/=x"0"))then 
            index<=x"9";
            ld<='0';
            aligned<='1';
          elsif(index=x"0")then
            index<=x"9";
            if(aligned='1')then
              ld<='1';
              d_out<=reg;
            else
              ld<='0';
            end if;
          else
            index<=unsigned(index)-1;
            ld<='0';
          end if;
          reg(8 downto 0)<=reg(9 downto 1);
          reg(9)<=d_in;
 	end if;
    
    end process;		

end DESER10B;

--------------------------------------------------------------
