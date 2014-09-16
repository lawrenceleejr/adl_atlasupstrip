--
--
--

library ieee;
use ieee.std_logic_1164.all;

entity stretch1 is
     port(
      clk : in std_logic;
      i : in     std_logic;
      o : out    std_logic
    
   );

-- Declarations

end stretch1 ;


architecture rtl of stretch1 is

  signal q : std_logic;
begin

  process (clk)
    begin
      if rising_edge(clk) then
          q <= i;
     end if;   
  end process;



  o <= i or q;

end rtl;
