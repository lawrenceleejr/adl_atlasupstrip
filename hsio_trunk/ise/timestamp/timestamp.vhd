-- timestamp.vhd generated by mkfiles/timestamp.tcl:
-- Fri Oct 17 03:03:35 PM CST 2014 = 1413520415 = 0x54409C1F
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity timestamp is
   port( ts_o : out std_logic_vector (31 downto 0));
end timestamp ;

architecture rtl of timestamp is
begin
  ts_o <= conv_std_logic_vector(1413520415, 32);
end architecture rtl;

