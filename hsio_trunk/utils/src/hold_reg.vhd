--
-- hold_reg
-- Records if something is ever one 
-- 
--
--

library ieee;
use ieee.std_logic_1164.all;

entity hold_reg is
  port(
    d_i  : in  std_logic_vector(15 downto 0);
    clk  : in  std_logic;
    rst0 : in  std_logic;
    rst1 : in  std_logic;
    q_o  : out std_logic_vector(15 downto 0)

    );

-- Declarations

end hold_reg;


architecture rtl of hold_reg is

  signal q : std_logic_vector(15 downto 0);


begin

  process (clk)
  begin
    if rising_edge(clk) then
      if (rst0 = '1') then
        q <= (others => '0');

      else
        if (rst1 = '1') then
          q <= d_i;

        else
          q <= q or d_i;

        end if;
      end if;
    end if;
  end process;

  q_o <= q;

end rtl;
