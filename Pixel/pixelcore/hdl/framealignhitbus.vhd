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

entity framealignhitbus is 
   port (
     clk       : in std_logic;
     rst       : in std_logic;
     d_in      : in std_logic;
     d_out     : out std_logic;
     aligned   : out std_logic
     );
end framealignhitbus;

architecture FRAMEALIGNHITBUS of framealignhitbus is

  signal pipeline: std_logic_vector(7 downto 0);

begin

   process (rst,clk)
   begin
     if(rst='1')then
       pipeline<=(others=>'0');
       d_out<='0';
     elsif(rising_edge(clk))then
       pipeline(7 downto 1)<= pipeline (6 downto 0);
       pipeline(0)<=d_in;
       d_out<=pipeline(7);
       if(pipeline="10001000"  -- No triggers 1 marker bit for two cycles
          )then
         aligned<='1';
       else
         aligned<='0';
       end if;
     end if;
  end process;
       
end FRAMEALIGNHITBUS;
