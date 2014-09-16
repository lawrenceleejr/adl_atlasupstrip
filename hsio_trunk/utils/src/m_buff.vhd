--
-- m_buff
-- Matts BUFFer
-- A little entity to make a small buff for the diags
--
--

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY m_buff IS
   PORT( 
      i : IN     std_logic;
      o : OUT    std_logic
   );

-- Declarations

END m_buff ;


architecture rtl of m_buff is
begin

  o <= i after 200 ps;
end rtl;
