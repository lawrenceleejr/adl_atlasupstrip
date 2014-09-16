--
-- gate delay
-- DOES NOT WORK!
--
--

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY gate_delay4 IS
   PORT( 
      d : IN     std_logic_vector (1 DOWNTO 0);
      i : IN     std_logic;
      o : OUT    std_logic
   );

-- Declarations

END gate_delay4 ;


architecture rtl of gate_delay4 is

    signal a : std_logic_vector(3 downto 0);
    
 
begin

  -- use multiples of 5 to use 5 input luts!

  gdgen : for n in 1 to 3 generate
  begin
    a(n) <= a(n-1);
  end generate;
  
  a(0) <= i;

  o <= a(conv_integer(d)*5);

  
end rtl;
