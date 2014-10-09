--------------------------------------------------------------
-- Serializer for High Speed I/O board (ATLAS Pixel teststand)
-- Martin Kocian 01/2009
--------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use work.all;

--------------------------------------------------------------

entity encodepgp is
generic( CHANNEL: std_logic_vector:="1111");
port(	clk: 	    in std_logic;
	rst:	    in std_logic;
        enabled:    in std_logic;
        isrunning:    out std_logic;
	d_in:	    in std_logic_vector(7 downto 0);
	k_in:	    in std_logic;
        err_in:     in std_logic;
        marker:     in std_logic;
	d_out:	    out std_logic_vector(17 downto 0);
        ldin:       in std_logic;
        ldout:      out std_logic;
        overflow:   out std_logic
--        acounter:    out std_logic_vector(15 downto 0)
);
end encodepgp;

--------------------------------------------------------------

architecture ENCODEPGP of encodepgp is

signal running: std_logic;
signal headercounter: std_logic_vector(3 downto 0);
signal parity: std_logic_vector(1 downto 0);
signal trailer: std_logic;
signal msb: std_logic_vector(7 downto 0);
signal oldmarker: std_logic;
signal oldoldmarker: std_logic;
signal marked: std_logic;
signal eventmark: std_logic;
signal wordcount: std_logic_vector(11 downto 0);

begin
  isrunning<=running;
    process(rst, clk)
    begin
        if(rst='1') then
          d_out<=x"0000"&"00";
          --acounter<=x"0000";
          running<='0';
          headercounter<=x"0";
          parity<="00";
          trailer<='0';
          msb<=x"00";
          ldout<='0';
          oldmarker<='0';
          oldoldmarker<='0';
          marked<='0';
          eventmark<='0';
          overflow<='0';
          wordcount<=(others =>'0');
        elsif (clk'event and clk='1') then
          oldmarker<=marker;
          oldoldmarker<=oldmarker;
          if(marker='1' and oldoldmarker='0')then
            eventmark<='1';
          elsif(marked='1')then
            eventmark<='0';
          end if;
          if(ldin='1')then 
            if(running='0')then
              if(enabled='1' and d_in=x"fc" and k_in='1')then  -- SOF
                headercounter<="1111";
                d_out<="01"&x"0000"; --  SOF
                running<='1';
                parity<="01";
                ldout<='1';
                trailer<='0';
                wordcount<=(others =>'0');
              end if;
            else -- running
              if(k_in='1' or err_in='1' or wordcount=x"800")then --EOF or idle or error
              --if((d_in=x"bc")and k_in='1')then --EOF or idle in case of failure
                running<='0';
                if(wordcount=x"800")then
                  overflow<='1';
                end if;
                if(headercounter/="0000")then -- sequence was SOF EOF
                  trailer<='1';
                  ldout<='0';
                else
                  ldout<='1';
                  if(parity(0)='0')then
                    d_out(15 downto 0)<=x"0000";
                  else
                    d_out(15 downto 0)<= msb & x"00";
                  end if;
                  if(parity(1)='0')then
                    trailer<='1';
                    d_out(17 downto 16)<="00";
                  else
                    trailer<='0';
                    d_out(17 downto 16)<="10";
                  end if;
                end if;
              --elsif(err_in='1' or k_in='1')then
              --  acounter<=unsigned(acounter)+1;
              else-- data 
                parity<=unsigned(parity)+1;
                if(parity(0)='0')then --MSB
                  ldout<='0';
                  msb<=d_in;
                else -- LSB
                  wordcount<=unsigned(wordcount)+1;
                  ldout<='1';
                  d_out(15 downto 0)<=msb & d_in;
                  d_out(17 downto 16)<="00";
                end if;
              end if;
            end if;      
          else
            if(headercounter/="0000")then
              ldout<='1';
              parity<=unsigned(parity)+1;
              headercounter<=unsigned(headercounter)-1;
              if(headercounter="1111")then
                d_out(7 downto 0)<=(others=>'0'); 
                d_out(15 downto 8)<=x"0"&CHANNEL;
                d_out(17 downto 16)<="00";
              elsif(headercounter="1101")then
                d_out<="00"&eventmark&"000"&x"000";
                marked<='1';
              elsif(headercounter="0001" and trailer='1')then
                d_out<="10"&x"0000"; --EOF
                trailer<='0';
              else
                d_out<=(others=>'0');
                marked<='0';
              end if;
            elsif(trailer='1')then
              ldout<='1';
              d_out<="10"&x"0000";
              trailer<='0';
            else
              ldout<='0';
            end if;
          end if;
 	end if;
    
    end process;		

end ENCODEPGP;

--------------------------------------------------------------
