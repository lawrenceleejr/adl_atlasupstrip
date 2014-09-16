--
-- Counter 
--
-- Matt Warren
-- UCL
--


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity counter is
  generic(
    BITS           :     integer := 16;
    ROLLOVER_EN    :     integer := 1;
    RST_IS_PRESET  :     integer := 0 -- reset is preset
    );
  port(
    inc_i          : in  std_logic;
    clr_i          : in  std_logic;
    pre_i          : in  std_logic;
    count_o        : out std_logic_vector ((BITS-1) downto 0);
    count_at_max_o : out std_logic;
    en_i             : in  std_logic;
    rst            : in  std_logic;
    clk            : in  std_logic
    ); 

-- Declarations

end counter;

--
architecture rtl of counter is

  signal count     : std_logic_vector((BITS-1) downto 0) := (others => '0');
  signal count_max : std_logic_vector((BITS-1) downto 0) := (others => '1');
  signal count_rst : std_logic_vector((BITS-1) downto 0) := (others => '0');
  signal count_pre : std_logic_vector((BITS-1) downto 0) := (others => '0');

begin

  count_max <= (others => '1');

  gen_rst1 : if (RST_IS_PRESET = 1) generate
    count_rst <= (others => '1');
  end generate;
  
  gen_rst0 : if (RST_IS_PRESET = 0) generate
    count_rst <= (others => '0');
  end generate;

  count_pre <= (others => '1');


  process (clk)
  begin

    if rising_edge(clk) then

      if (rst = '1') then
        count <= count_rst;

      else
        if (en_i = '1') then

          if (clr_i = '1') then
             count <= (others => '0');

          elsif (pre_i = '1') then
            count <= count_pre;

          elsif (inc_i = '1') then
            if (count = count_max) then
              if (ROLLOVER_EN = 1) then
                count <= (others => '0');
              end if;
            else
              count   <= count + '1';

            end if;
          end if;
        end if;
      end if;
    end if;
  end process;

  count_o <= count;

  count_at_max_o <= '1' when (count = count_max) else '0';

end architecture rtl;

