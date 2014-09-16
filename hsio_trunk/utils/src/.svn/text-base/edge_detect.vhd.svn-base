--
--
--

library ieee;
use ieee.std_logic_1164.all;

entity edge_detect is
     port(
      --rst : in std_logic;
      clk : in std_logic;
      d : in     std_logic;
      rising : out    std_logic;
      rising_long : out    std_logic;
      falling : out    std_logic
      
   );

-- Declarations

end edge_detect ;


architecture rtl of edge_detect is

  signal q : std_logic;
  signal r : std_logic;
  signal r_q : std_logic_vector(3 downto 0);
  
begin

  process (clk)
    begin
      if rising_edge(clk) then
        --if (rst = '1') then
        --  q <= '0';
        --else
          q <= d after 200 ps;

          falling <= '0';
          r <= '0';

          if d='0' and q='1' then 
             falling <= '1';
          end if;

          if d='1' and q='0' then
            r <= '1';
          end if;

          r_q <= r_q(2 downto 0) & r;
          
        --end if;
     end if;   
  end process;

  rising <= r;
  rising_long <= '0' when (r_q = "0000") else '1';
          
end rtl;
