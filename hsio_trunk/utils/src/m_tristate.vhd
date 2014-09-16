--
-- m_tristate
-- Matts Tristate buffer
-- A little entity to make a small buff for the diags
--
--

library ieee;
use ieee.std_logic_1164.all;

entity m_tristate is
   port( 
      i : in     std_logic;
      t : in     std_logic;
      o : out    std_logic
   );

-- Declarations

end m_tristate ;


architecture rtl of m_tristate is
begin

  o <= 'Z' when (t = '1') else i;

end rtl;
