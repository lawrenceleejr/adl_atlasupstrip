--
-- Simple Packet Mux
-- 
-- Async and VERY simple.
-- Uses round robin port selection
-- 

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library utils;
use utils.pkg_types.all;

entity src_mux is
--  generic(
--    CHANNELS :     integer := 2
--    );
  port(
    sel_i  : in slv3;
    
    ser0_i : in slv2;
    ser1_i : in slv2;
    ser2_i : in slv2;
    ser3_i : in slv2;
    ser4_i : in slv2;
    ser5_i : in slv2;
    ser6_i : in slv2;
    ser7_i : in slv2;

    ser_o : out slv2

    -- infrastructure
    --rst         : in  std_logic;
    --clk         : in  std_logic
    );

-- Declarations

end src_mux;


architecture rtl of src_mux is

begin

  with sel_i select ser_o <=
    ser0_i when "000",
    ser1_i when "001",
    ser2_i when "010",
    ser3_i when "011",
    ser4_i when "100",
    ser5_i when "101",
    ser6_i when "110",
    ser7_i when others;
    
end architecture rtl;

