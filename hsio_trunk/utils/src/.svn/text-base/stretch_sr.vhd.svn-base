--
-- Simple syncro pulse stretch using a shift reg and big or.
--
--
--


library ieee;
use ieee.std_logic_1164.all;

entity stretch_sr is
  port(
    i   : in  std_logic;
    en  : in  std_logic;
    o8  : out std_logic;
    o16 : out std_logic;
    clk : in  std_logic
    );

-- Declarations

end stretch_sr;


architecture rtl of stretch_sr is

  signal sr  : std_logic_vector(14 downto 0);
  signal sr0 : std_logic_vector(14 downto 0);
  signal q7  : std_logic;
  signal q15 : std_logic;

begin

  sr0 <= sr(13 downto 0) & i;

  process (clk)
  begin
    if rising_edge(clk) then
      sr <= sr0;

      -- defaults
      q7 <= '0';
      q15 <= '0';
      
      -- Sync for easier timing downstream
      -- Note only 7/15 states of 8/16 - the other is the input

      if (sr0(6 downto 0) /= "0000000") then
        q7 <= '1';
      end if;

      if (sr0(14 downto 0) /= "000000000000000") then
        q15 <= '1';
      end if;

    end if;
  end process;

  o8  <= i when (en = '0') else (i or q7);
  o16 <= i when (en = '0') else (i or q15);


end rtl;
