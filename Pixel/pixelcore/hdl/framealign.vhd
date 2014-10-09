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

entity framealign is 
   port (
     clk       : in std_logic;
     rst       : in std_logic;
     d_in      : in std_logic;
     d_out     : out std_logic;
     aligned   : out std_logic
     );
end framealign;

architecture FRAMEALIGN of framealign is

  signal pipeline: std_logic_vector(19 downto 0);

begin

   process (rst,clk)
   begin
     if(rst='1')then
       pipeline<=(others=>'0');
       d_out<='0';
     elsif(rising_edge(clk))then
       pipeline(19 downto 1)<= pipeline (18 downto 0);
       pipeline(0)<=d_in;
       d_out<=pipeline(19);
       if(pipeline="00111110101100000111" or  -- EOF SOF
          pipeline="11000001010011111000" or  -- EOF SOF
          pipeline="00111110011100000111" or  -- Idle SOF
          pipeline="11000001100011111000" or  -- Idle SOF
          pipeline="00111110011100000110" or  -- Idle Idle
          pipeline="11000001100011111001"   -- Idle Idle
          )then
         aligned<='1';
       else
         aligned<='0';
       end if;
     end if;
  end process;
       
end FRAMEALIGN;
