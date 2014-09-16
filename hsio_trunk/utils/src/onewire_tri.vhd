--
-- 
-- A wee buffer to abstract tri-state signaling
-- A little entity to make a small buff 
--
--

library ieee;
use ieee.std_logic_1164.all;

entity onewire_tri is
   port( 
      
      data_i : in    std_logic;
      data_o : out    std_logic;
      tren_i : in    std_logic;
      pin_io : inout    std_logic
   );

-- Declarations

end onewire_tri ;


architecture rtl of onewire_tri is
begin


  data_o <= pin_io;
  pin_io <= 'Z' when (tren_i = '1') else data_i;

end rtl;
