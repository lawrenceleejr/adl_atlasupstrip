-------------------------------------------------------------------------------
-- Description:
-- Core logic for BNL ASIC test FPGA.
-------------------------------------------------------------------------------
-- Copyright (c) 2008 by Ryan Herbst. All rights reserved.
-------------------------------------------------------------------------------
-- Modification history:
-- 07/21/2008: created.
-------------------------------------------------------------------------------

LIBRARY ieee;
use work.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity dataflag is 
   port (
     eofin      : in std_logic;
     eofout     : in std_logic;
     datawaiting: out std_logic;
     clk        : in std_logic;
     rst        : in std_logic;
     counter    : out std_logic_vector(15 downto 0)
     );
end dataflag;

architecture DATAFLAG of dataflag is

  component eofcounter 
	port (
	clk: IN std_logic;
	up: IN std_logic;
	ce: IN std_logic;
	aclr: IN std_logic;
	q_thresh0: OUT std_logic;
	q: OUT std_logic_VECTOR(15 downto 0));
  end component;
  signal iszero: std_logic;
  signal oldeofin: std_logic;
  signal oldeofout: std_logic;
  signal cond: std_logic;
  signal eofincond: std_logic;
  signal eofoutcond: std_logic;
  signal updown: std_logic;
  signal init: std_logic;

begin

--   datawaiting<=not iszero;
   -- reset resets the threshold flag, too :-(
   datawaiting<=not iszero when init='1' else '0';   
   process (rst,clk)
   begin
     if(rst='1')then
       oldeofin<='1';
       oldeofout<='1';
       cond<='0';
       init<='0';
     elsif(rising_edge(clk))then
       oldeofin<=eofin;
       oldeofout<=eofout;
       if(eofin='1' and oldeofin='0')then
         eofincond<='1';
         init<='1';
       else
         eofincond<='0';
       end if;
       if(eofout='1' and oldeofout='0')then
         eofoutcond<='1';
       else
         eofoutcond<='0';
       end if;
       cond<=eofincond xor eofoutcond;
       updown<=eofincond;
       
     end if;
  end process;
       

   theeofcounter: eofcounter
     port map(
       clk=>clk,
       up=>updown,
       ce=>cond,
       aclr=>rst,
       q_thresh0=>iszero,
       q=>counter);

end DATAFLAG;
