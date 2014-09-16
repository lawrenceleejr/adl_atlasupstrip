--
-- m_inv
-- Matts INVer
-- A little entity to make a small inverter for the diags
--
--

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY m_inv IS
   PORT( 
      i : IN     std_logic;
      o : OUT    std_logic
   );

-- Declarations

END m_inv ;


architecture rtl of m_inv is
begin

  o <= not(i) after 200 ps;
end rtl;
