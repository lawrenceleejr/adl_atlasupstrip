--------------------------------------------------------------
-- Serializer for High Speed I/O board (ATLAS Pixel teststand)
-- Martin Kocian 01/2009
--------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

--------------------------------------------------------------

entity tdcreadout is
generic( CHANNEL: std_logic_vector:="1111");
port(	clk: 	    in std_logic;
	rst:	    in std_logic;
	slowclock:  in std_logic;
        go:         in std_logic;
        delay:      in std_logic_vector(4 downto 0);
        counter1:   in std_logic_vector(31 downto 0);
        counter2:   in std_logic_vector(31 downto 0);
        trgtime:    in std_logic_vector(63 downto 0);
        deadtime:   in std_logic_vector(63 downto 0);
        status:     in std_logic_vector(14 downto 0);
        marker:     in std_logic;
        l1count:    in std_logic_vector(3 downto 0);
        bxid   :    in std_logic_vector(7 downto 0);
	d_out:	    out std_logic_vector(15 downto 0);
        ld:         out std_logic;
        busy:       out std_logic;
        sof:        out std_logic;
        eof:        out std_logic;
        runmode:    in std_logic_vector(1 downto 0);
        eudaqdone:  in std_logic;
        eudaqtrgword: in std_logic_vector(14 downto 0);
        hitbus:     in std_logic_vector(1 downto 0);
        triggerword:in std_logic_vector(7 downto 0)
);
end tdcreadout;

--------------------------------------------------------------

architecture TDCREADOUT of tdcreadout is
 
  signal headercounter: unsigned (5 downto 0);
  signal busys: std_logic;
  signal marked: std_logic;
  signal eventmark: std_logic;
  signal waitforeudaq: std_logic;
  signal oldbusys: std_logic;
  signal oldoldbusys: std_logic;

begin

    busy<=oldoldbusys;
    process(rst, slowclock)
    begin
      if(rst='1')then
        oldbusys<='0';
        oldoldbusys<='0';
      elsif (rising_edge(slowclock))then
        oldbusys<=busys;
        oldoldbusys<=oldbusys;
      end if;
    end process;

    process(rst, clk)
    begin
        if(rst='1') then
          d_out<=x"0000";
          eof<='0';
          sof<='0';
          headercounter<=(others => '0');
          ld<='0';
          busys<='0';
          marked<='0';
          eventmark<='0';
          waitforeudaq<='0';
        elsif (clk'event and clk='1') then
          if(marker='1')then
            eventmark<='1';
          elsif(marked='1')then
            eventmark<='0';
          end if;
          if(busys='0' and go='1')then 
            busys<='1';
            eof<='0';
            headercounter<=unsigned('0'&delay)+31;
            if(delay="00000") then
              sof<='1';
              ld<='1';
            end if;
            d_out<=x"0000";
          elsif (headercounter/=0)then 
            if (headercounter=32) then
              sof<='1';
              ld<='1';
            elsif (headercounter=31) then
              sof<='0';
              d_out(7 downto 0)<=(others=>'0'); 
              d_out(15 downto 8)<=x"0"&CHANNEL;
              --d_out<=tid(23 downto 8);
            elsif(headercounter=30) then
              d_out<=x"0000";
            elsif(headercounter=29) then
              d_out<=eventmark&"000"&x"000";
            elsif(headercounter=28) then
              d_out<=x"0000";
            elsif(headercounter=16) then
              d_out<=x"0" & l1count & bxid;
            elsif(headercounter=15) then
              d_out<=eventmark&status;
            elsif(headercounter=14) then
              d_out<=counter1(31 downto 16);
            elsif(headercounter=13) then
              d_out<=counter1(15 downto 0);
            elsif(headercounter=12) then
              d_out<=counter2(31 downto 16);
            elsif(headercounter=11) then
              d_out<=counter2(15 downto 0);
            elsif(headercounter=10) then
              d_out<=trgtime(63 downto 48);
            elsif(headercounter=9) then
              d_out<=trgtime(47 downto 32);
            elsif(headercounter=8) then
              d_out<=trgtime(31  downto 16);
            elsif(headercounter=7) then
              d_out<=trgtime(15  downto 0);
            elsif(headercounter=6) then
              d_out<=deadtime(63 downto 48);
            elsif(headercounter=5) then
              d_out<=deadtime(47 downto 32);
            elsif(headercounter=4) then
              d_out<=deadtime(31 downto 16);
            elsif(headercounter=3) then
              d_out<=deadtime(15 downto 0);
              marked<='1';
            elsif(headercounter=2) then
              d_out<="000000"&hitbus&triggerword;
              marked<='0';
            elsif(headercounter=1) then
              if (runmode(1)='1')then
                ld<='0';
                waitforeudaq<='1';
              else
                d_out<=(others=>'0');
                eof<='1';
              end if;
            else
              d_out<=(others=>'0');
            end if;
            headercounter<=headercounter-1;
          else
            if(waitforeudaq='1')then
              if(eudaqdone='1')then
                ld<='1';
                eof<='1';
                d_out<='0'&eudaqtrgword;
                waitforeudaq<='0';
              else
                ld<='0';
                d_out<=(others=>'0');
              end if;
            else
              eof<='0';
              ld<='0';
              busys<='0';
            end if;
          end if;
 	end if;
    
    end process;		

end TDCREADOUT;

--------------------------------------------------------------
