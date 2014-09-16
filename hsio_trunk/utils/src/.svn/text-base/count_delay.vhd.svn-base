--
-- Counter for start-up delay
--
-- Matt Warren
-- UCL
--


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity count_delay is
  generic(
    SIM_MODE : integer := 0;
    BITS     : integer := 16
    );
  port(
    done        : out std_logic;
    done_n        : out std_logic;
    rst : in  std_logic;
    clk         : in  std_logic
    );

-- Declarations

end count_delay;

--
architecture rtl of count_delay is

  signal count     : std_logic_vector((BITS-1) downto 0);
  signal count_max : std_logic_vector((BITS-1) downto 0);
  signal done_int  : std_logic;

begin


  count_max <= (others => '1') when (SIM_MODE = 0) else
               conv_std_logic_vector(63, BITS);

  process (clk, rst)
  begin

    if (rst = '1') then
      count    <= (others => '0');
      done_int <= '0';

    elsif rising_edge(clk) then

      done_int <= '0';

      -- make sure this does get stuck!
      if (count = count_max) then
        done_int <= '1';

      else
        count <= count + '1';

      end if;

    end if;
  end process;

  done <= done_int;
  done_n <= not done_int;

end architecture rtl;

