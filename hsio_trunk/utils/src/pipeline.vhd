--
-- Pipeline 
--
-- Matt Warren
-- UCL
--


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity pipeline is
  generic(
    LEN : integer := 16
    );
  port(
    clk_en : in  std_logic;
    pipe_i   : in  std_logic;
    pipe_o   : out std_logic;
    pipe_no   : out std_logic;
    rst      : in  std_logic;
    clk      : in  std_logic
    );

-- Declarations

end pipeline;

--
architecture rtl of pipeline is

  signal pipe : std_logic_vector(LEN-1 downto 0) := (others => '0');

begin

  process (clk)
  begin

    if rising_edge(clk) then

      if (rst = '1') then
        pipe <= (others => '0');

      else
        if (clk_en = '1') then
          pipe <= pipe(LEN-2 downto 0) & pipe_i;
        end if;
      end if;
    end if;
  end process;

  pipe_o <= pipe(LEN-1);
  pipe_no <= not(pipe(LEN-1));

end architecture rtl;

