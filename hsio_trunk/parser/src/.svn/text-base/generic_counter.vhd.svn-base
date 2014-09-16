library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;               -- for the unsigned type

entity generic_counter is
  generic ( WIDTH               :     integer := 32);
  port (
    CLK, RESET, LOAD, INCREMENT : in  std_logic;
    DATA                        : in  unsigned(WIDTH-1 downto 0);
    Q                           : out unsigned(WIDTH-1 downto 0));
end entity generic_counter;

architecture generic_counter_a of generic_counter is
  signal cnt : unsigned(WIDTH-1 downto 0);
begin
  process(RESET, CLK) is
  begin
    if rising_edge(CLK) then
      if RESET = '1' then
        cnt   <= (others => '0');
      else
        if LOAD = '1' then
          cnt <= DATA;
        elsif INCREMENT = '1' then
      -- else
          cnt <= cnt + 1;
        end if;
      end if;
    end if;
  end process;

  Q <= cnt;

end architecture generic_counter_a;
