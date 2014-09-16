--
-- A little entity to make anding easy and small
-- Matt Warren
--

library ieee;
use ieee.std_logic_1164.all;

entity m_and3 is
   port( 
      i1 : in     std_logic;
      i2 : in     std_logic;
      i3 : in     std_logic;
      o  : out    std_logic
   );

-- Declarations

end m_and3 ;


architecture rtl of m_and3 is
begin

  o <= (i1 and i2 and i3) after 200 ps;

end rtl;
