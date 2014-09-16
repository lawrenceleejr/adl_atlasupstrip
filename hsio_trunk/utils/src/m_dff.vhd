--
-- m_dff
-- Matts DFF
-- A little entity to make a simple D flip-flop (sync reset)
--
--

library ieee;
use ieee.std_logic_1164.all;

entity m_dff is
   port(
      r : in std_logic;
      c : in std_logic;
      d : in     std_logic;
      q : out    std_logic
   );

-- Declarations

end m_dff ;


architecture rtl of m_dff is
begin

  process (c)
    begin
      if rising_edge(c) then
        if (r = '1') then
          q <= '0';
        else
          q <= d after 200 ps;
        end if;
     end if;   
  end process;
end rtl;
