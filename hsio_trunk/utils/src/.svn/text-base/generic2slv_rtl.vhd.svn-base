--
-- VHDL Architecture emulator.generic2slv.rtl
--
-- Created:
--          by - warren.warren (ubutron)
--          at - 09:25:16 12/05/08
--
-- using Mentor Graphics HDL Designer(TM) 2007.1 (Build 19)
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity generic2slv is
   generic( 
      INT_VAL    : integer := 0;
      WIDTH_BITS : integer := 7
   );
   port( 
      constval : out    std_logic_vector ((WIDTH_BITS-1) downto 0)
   );

-- Declarations

end generic2slv ;

--
architecture rtl of generic2slv is
begin

  constval <= conv_std_logic_vector(INT_VAL, WIDTH_BITS);
  
end architecture rtl;

