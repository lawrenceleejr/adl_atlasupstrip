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
use ieee.numeric_std.all;
use work.arraytype.all;

entity hitbuspipeline is 
   port (
     rst        : in std_logic;
     clk        : in std_logic;
     ld         : in std_logic;
     depth      : in std_logic_vector(4 downto 0);
     wordin     : in std_logic_vector(2 downto 0);
     wordout    : out std_logic_vector(31 downto 0)
     );
end hitbuspipeline;

architecture HITBUSPIPELINE of hitbuspipeline is

  signal pp: hbpipeline;
  signal index: integer;

begin
   
   process (rst,clk)
   begin
     if(rst='1')then
       for I in 0 to 40 loop
	 pp(I)<="000";
       end loop;
       wordout(31 downto 30)<="00";
     elsif(rising_edge(clk))then
       if(ld='1') then
         pp(0)<=wordin;
         hbset: for I in 1 to 40 loop
           pp(I)<=pp(I-1);
         end loop; 
       end if;
       for I in 0 to 9 loop
         wordout(I*3+2)<=pp(conv_integer(unsigned(depth))+I)(2);         
         wordout(I*3+1)<=pp(conv_integer(unsigned(depth))+I)(1);         
         wordout(I*3)<=pp(conv_integer(unsigned(depth))+I)(0);         
       end loop;
     end if;
  end process;
       
end HITBUSPIPELINE;
