--
-- m_buff
-- Matts BUFFer
-- A little entity to make a small buff for the diags
--
--

library ieee;
use ieee.std_logic_1164.all;

entity m_buffn is
   generic( 
      N : integer := 2
   );
   port( 
      i : in     std_logic_vector (N-1 downto 0);
      o : out    std_logic_vector (N-1 downto 0)
   );

-- Declarations

end m_buffn ;


architecture rtl of m_buffn is
begin

  o <= i after 200 ps;
end rtl;
