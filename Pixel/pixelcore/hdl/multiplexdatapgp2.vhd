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


entity multiplexdata is

port(	clk: 	    in std_logic;
	rst:	    in std_logic;
        enabled:    in std_logic;
        channelmask: in std_logic_vector(15 downto 0);
        datawaiting: in std_logic_vector(15 downto 0);
        indatavalid: in std_logic_vector(15 downto 0);
        datain: in dataarray;
        dataout: out std_logic_vector(15 downto 0);
        eofout: out std_logic;
        sofout: out std_logic;
        datavalid: out std_logic;
        reqdata: out std_logic_vector(15 downto 0);
        counter4: out std_logic_vector(31 downto 0);
        counter10b: out std_logic_vector(31 downto 0);
        counter10: out std_logic_vector(31 downto 0)
);
end multiplexdata;

--------------------------------------------------------------

architecture MULTIPLEXDATA of multiplexdata is
  signal index: integer;
  signal eof: std_logic;
  signal sof: std_logic;
  signal pdata: dataarray;
  signal pvalid: std_logic_vector(15 downto 0);
  type state_type is (idle, first, sending, paused, switch, kludge1, kludge2, kludge3, mwait);
  signal state: state_type;
  signal wcounter: std_logic_vector(8 downto 0);
  signal cdata: std_logic_vector(31 downto 0);
  signal ctrig: std_logic_vector(7 downto 0); 
  signal ccontrol: std_logic_vector(35 downto 0);
  signal dwcounter: std_logic_vector(3 downto 0);
  signal eofouts: std_logic;
  signal sofouts: std_logic;
  signal datavalids: std_logic;
  signal reqdatas: std_logic_vector(15 downto 0);
component chipscope_ila_new
   PORT (
     CONTROL : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
     CLK : IN STD_LOGIC;
     DATA : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
     TRIG0 : IN STD_LOGIC_VECTOR(7 DOWNTO 0));

end component;
 component chipscope_icon_new
   PORT (
     CONTROL0 : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0));

 end component;
--  attribute syn_noprune : boolean;
--  attribute syn_noprune of chipscope : label is true;
--  attribute syn_noprune of chipscopeicon : label is true;

begin

  eofout<=eofouts;
  sofout<=sofouts;
  datavalid<=datavalids;
  reqdata<=reqdatas; 

  process (rst,clk)
  begin
    if(rst='1')then
      index<=0;
      reqdatas<=x"0000";
      eofouts<='0';
      sofouts<='0';
      dataout<=x"0000";
      pvalid<=x"0000";
      pdata(0)<="00"&x"0000";
      pdata(1)<="00"&x"0000";
      pdata(2)<="00"&x"0000";
      pdata(3)<="00"&x"0000";
      pdata(4)<="00"&x"0000";
      pdata(5)<="00"&x"0000";
      pdata(6)<="00"&x"0000";
      pdata(7)<="00"&x"0000";
      pdata(8)<="00"&x"0000";
      pdata(9)<="00"&x"0000";
      pdata(10)<="00"&x"0000";
      pdata(11)<="00"&x"0000";
      pdata(12)<="00"&x"0000";
      pdata(13)<="00"&x"0000";
      pdata(14)<="00"&x"0000";
      pdata(15)<="00"&x"0000";
      wcounter<='0'&x"00";
      counter4<=x"00000000";
      dwcounter<="0000";
      state<= idle;
    elsif(rising_edge(clk))then
      case state is
        when kludge1 =>
          dataout<=x"0000";
          if(indatavalid(index)='1')then
            pvalid(index)<='1';
            pdata(index)<=datain(index);
          else
            pvalid(index)<='0';
          end if;
          state<=kludge2;
        when kludge2 =>
          eofouts<='1';
          state<=kludge3;
        when kludge3 =>
          eofouts<='0';
          datavalids<='0';
          sofouts<='0';
          if(index=15)then
            index<=0;
          else
            index<=index+1;
          end if;
          dwcounter<="1010";
          state<=mwait;
        when switch =>
          eofouts<='0';
          datavalids<='0';
          sofouts<='0';
          if(indatavalid(index)='1')then
            pvalid(index)<='1';
            pdata(index)<=datain(index);
          else
            pvalid(index)<='0';
          end if;
          if(index=15)then
            index<=0;
          else
            index<=index+1;
          end if;
          dwcounter<="1010";
          state<=mwait;
        when mwait =>
          if(dwcounter/="0000")then
            dwcounter<=unsigned(dwcounter)-1;
            state<=mwait;
          else
            state<=idle; 
          end if;
        when idle =>
          if(enabled='1' and channelmask(index)='1' and datawaiting(index)='1')then
            reqdatas(index)<='1';
            state<=first;
            wcounter<='0'&x"00";
          elsif(enabled='0')then
            state<=idle;
          else
            state<=idle;
             if(index=15)then
               index<=0;
             else
               index<=index+1;
             end if;
          end if;
        when first =>
          if(pvalid(index)='1')then
            sofouts<='1';
            dataout<=pdata(index)(15 downto 0);
            datavalids<='1';
            wcounter<=unsigned(wcounter)+1;
            pvalid(index)<='0';
          end if;
          state<= sending;
        when sending =>
          dataout <= datain(index)(15 downto 0); 
          datavalids<='1';
          wcounter<=unsigned(wcounter)+1;
          sofouts <=datain(index)(16);
          if(datain(index)(17)='1') then --EOF
            reqdatas(index)<='0';
            if(wcounter(8)='1' or wcounter(7)='1')then
              counter4(8 downto 0)<=wcounter;
            end if;
            if(wcounter(7 downto 0)=x"01")then -- pgp kludge, add an extra 2 words
              state<=kludge1;
            else
              state<=kludge1;
              --eofouts<='1';
            end if;
          elsif(enabled='0')then
              reqdatas(index)<='0';
              state<=paused;-- pause transmission
          else
            state<=sending;
          end if;
        when paused =>
          if(indatavalid(index)='1')then
            dataout <= datain(index)(15 downto 0); 
            wcounter<=unsigned(wcounter)+1;
            if(datain(index)(17)='1') then --EOF
              if(wcounter(7 downto 0)=x"01")then -- pgp kludge, add an extra 2 words
                state<=kludge1;
              else
                state<=kludge1;
                --eofouts<='1';
              end if;
            end if;
          else
            datavalids<='0';
            if(enabled='1')then
              reqdatas(index)<='1';
              state<=first;
            else
              state<=paused;
            end if;
          end if;
      end case;
    end if;

   cdata(6)<=datain(index)(17);
   cdata(7)<=eofouts;
   cdata(8)<=datain(index)(16);
   cdata(9)<=sofouts;
   cdata(5)<=datavalids;
   cdata(4)<=indatavalid(index);
   cdata(3 downto 0)<=conv_std_logic_vector(index, 4);
   cdata(17 downto 10)<=reqdatas(7 downto 0);
   cdata(18)<=channelmask(index) and datawaiting(index) and enabled;
   ctrig(0)<=channelmask(index) and datawaiting(index)  and enabled;
   
  end process;

 --chipscope : chipscope_ila_new
  -- port map (
  --   CONTROL => ccontrol,
  --   CLK => clk,
  --   DATA => cdata,
  --   TRIG0 => ctrig);
-- chipscopeicon : chipscope_icon_new
--   port map (
--     CONTROL0 => ccontrol);       
--             

end MULTIPLEXDATA;
