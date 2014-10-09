--------------------------------------------------------------
-- Serializer for High Speed I/O board (ATLAS Pixel teststand)
-- Martin Kocian 01/2009
--------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use work.all;

--------------------------------------------------------------

entity deser is
generic( CHANNEL: std_logic_vector:="1111");
port(	clk: 	    in std_logic;
      rst:	    in std_logic;
      d_in:	    in std_logic;
      enabled:    in std_logic;
      replynow:   in std_logic;
      marker:     in std_logic;
      d_out:	    out std_logic_vector(15 downto 0);
      ld:         out std_logic;
      sof:        out std_logic;
      eof:        out std_logic
);
end deser;

--------------------------------------------------------------

architecture DESER of deser is

signal reg : std_logic_vector(15 downto 0);
signal parcounter: std_logic_vector(1 downto 0);
signal nodata: std_logic;
signal oldmarker: std_logic;
signal marked: std_logic;
signal eventmark: std_logic;

begin


    process(rst, clk)

    variable counter: std_logic_vector(3 downto 0);
    variable zerocounter: std_logic_vector(6 downto 0);
    variable headercounter: std_logic_vector(3 downto 0);
    variable going: std_logic;
    begin
        if(rst='1') then
          reg<=x"0000";
          d_out<=x"0000";
          going:='0';
          eof<='0';
          sof<='0';
          headercounter:="0000";
          ld<='0';
          parcounter<="00";
          oldmarker<='0';
          marked<='0';
          eventmark<='0';
        elsif (clk'event and clk='1') then
          if (d_in='1')then
            zerocounter:="0000000";
          else
            zerocounter:=unsigned(zerocounter)+1;
          end if;
          oldmarker<=marker;
          if(marker='1' and oldmarker='0')then
            eventmark<='1';
          elsif(marked='1')then
            eventmark<='0';
          end if;
          if(going='0' and ((enabled='1' and d_in='1') or replynow='1'))then 
            going:='1';
            counter:="1111";
            eof<='0';
            zerocounter:="0000000";
            headercounter:="1111";
            parcounter<="00";
            nodata<=replynow;
          elsif (going='1' and counter="1111") then
            parcounter<=unsigned(parcounter)+1;
            d_out<=reg;
            if(nodata='1')then
              going:='0';
              ld<='0';
            else
              ld<='1';
              if(zerocounter>="0100000" and parcounter="11")then
                eof<='1';
                going:='0';
              else
                eof<='0';
              end if;
            end if;
          elsif(counter="1110" and headercounter="0000")then
            ld<='0';
          end if;
          if (unsigned(headercounter)>0)then  -- we have to squeeze in the header
            ld<='1';                          -- before the first event
            if(headercounter="1111")then
              sof<='1';
              d_out<=(others=>'0'); 
            elsif(headercounter="1110")then
              sof<='0';
              d_out(7 downto 0)<=(others=>'0'); 
              d_out(15 downto 8)<=x"0"&CHANNEL;
            elsif(headercounter="1100")then
              d_out<=eventmark&"000"&x"000";
              sof<='0';
              marked<='1';
            else
               sof<='0';
               d_out<=(others=>'0');
               marked<='0';
            end if;
            headercounter:=unsigned(headercounter)-1;
          elsif(nodata='1' and headercounter="0000")then
            eof<='1';
            d_out<=(others=>'0');
          end if;
          reg(15 downto 1)<=reg(14 downto 0);
      	  reg(0)<=d_in;
          counter:=unsigned(counter)-1;
 	end if;
    
    end process;		

end DESER;

--------------------------------------------------------------
