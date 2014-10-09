--------------------------------------------------------------
-- Serializer for High Speed I/O board (ATLAS Pixel teststand)
-- Martin Kocian 01/2009
--------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use work.all;
use work.arraytype.all;

--------------------------------------------------------------


entity coincidence is

port(	clk: 	    in std_logic;
	rst:	    in std_logic;
        enabled:    in std_logic;
        channelmask: in std_logic_vector(15 downto 0);
        dfifothresh: in std_logic_vector(15 downto 0);
        trgin: in std_logic;
        serbusy: in std_logic;
        tdcreadoutbusy: in std_logic;
        tdcready: in std_logic;
        starttdc: out std_logic;
        l1a: out std_logic;
        trgdelay: in std_logic_vector(7 downto 0);
        busy: out std_logic;
        coinc: out std_logic;
        coincd: out std_logic
);
end coincidence;

--------------------------------------------------------------

architecture COINCIDENCE of coincidence is

signal andr: std_logic_vector(15 downto 0);
signal delaycounter: std_logic_vector(7 downto 0);
signal orr: std_logic;
signal busys: std_logic;
signal coinct: std_logic;
signal rescoin: std_logic;
signal oldcoinct: std_logic;
signal oldoldcoinct: std_logic;
signal oldbusys: std_logic;
signal oldenabled: std_logic;
signal l1asig: std_logic;
signal go: std_logic;
   signal cdata: std_logic_vector(31 downto 0);
   signal ctrig: std_logic_vector(0 downto 0); 
   signal ccontrol: std_logic_vector(35 downto 0);
component ila
   PORT (
     CONTROL : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
     CLK : IN STD_LOGIC;
     DATA : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
     TRIG0 : IN STD_LOGIC_VECTOR(0 DOWNTO 0));

end component;
 component icon
   PORT (
     CONTROL0 : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0));

 end component;
  --attribute syn_noprune : boolean;
  --attribute syn_noprune of chipscope : label is true;
  --attribute syn_noprune of chipscopeicon : label is true;

begin
  l1a<=l1asig;
  andr<= channelmask and dfifothresh;
  orr<=andr(0) or andr(1) or andr(2) or andr(3) or andr(4)
               or andr(5) or andr(6) or andr(7) or andr(8)
               or andr(9) or andr(10) or andr(11) or andr(12)
               or andr(13) or andr(14) or andr(15);
  busys<=orr or serbusy or tdcreadoutbusy;
  go <= tdcready and enabled and not busys;
  busy<= enabled and (busys or not tdcready);
  coinc<=coinct;
  coincd<=trgin;
  
  process (rst,rescoin, go,trgin)
  begin
    if( rst='1' or rescoin='1')then
      coinct<='0';
    elsif(rising_edge(trgin))then
      if(go='1')then
        coinct<='1';
      end if;
    end if;
  end process;
  
  process (rst,clk)
  begin
    if(rst='1')then
      starttdc<= '0';
      oldcoinct<='0';
      oldoldcoinct<='0';
      oldbusys<='0';
      oldenabled<='0';
      l1asig<='0';
      delaycounter<=x"00";
    elsif(rising_edge(clk))then
      if(delaycounter/=x"00")then
        delaycounter<=unsigned(delaycounter)-1;
      elsif(coinct='1' and oldoldcoinct='0')then  -- keep one bin as a buffer
        delaycounter<=trgdelay;
      end if;
      if(delaycounter=x"01")then
        l1asig<='1';
      else
        l1asig<='0';
      end if;
      if(l1asig='1')then
        rescoin<='1';
      elsif(go='0')then
        rescoin<='0';
      end if;
      if(tdcready='0' and busys='0' and oldbusys='1')then
        starttdc<='1';
      elsif(enabled='1' and oldenabled='0') then
        starttdc<='1';
      else
        starttdc<='0';
      end if;
      oldcoinct<=coinct;
      oldoldcoinct<=oldcoinct;
      oldbusys<=busys;
      oldenabled<=enabled;
    end if;
  end process;
   cdata(0)<= l1asig;
   cdata(1)<= rescoin;
   cdata(2)<= tdcready;
   cdata(3)<= busys;
   cdata(4)<= oldcoinct;
   cdata(5)<= enabled;
   cdata(6)<= oldoldcoinct;
   cdata(7)<= coinct;
   cdata(8)<= rst;
   cdata(9)<= go;
   cdata(12 downto 10)<= delaycounter(2 downto 0) ;
   ctrig(0)<=trgin;
 --chipscope : ila
   --port map (
     --CONTROL => ccontrol,
     --CLK => clk,
     --DATA => cdata,
     --TRIG0 => ctrig);
 --chipscopeicon : icon
   --port map (
     --CONTROL0 => ccontrol);       
             

end COINCIDENCE;
