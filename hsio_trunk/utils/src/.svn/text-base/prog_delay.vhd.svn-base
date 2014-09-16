--
--
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity prog_delay is
  generic (
    LEN : integer := 256
	 );
  port(
    strobe40_i : in  std_logic;
    delay_i    :     std_logic_vector(15 downto 0);
    sig_i      : in  std_logic;
    dsig_o     : out std_logic;

    rst : in std_logic;
    clk : in std_logic

    );

-- Declarations

end prog_delay;


architecture rtl of prog_delay is

  signal q         : std_logic_vector(LEN-1 downto 0);
  signal delay_int : integer range 0 to (LEN-1);

begin

  q(0) <= sig_i;

  process (clk)
  begin
    if rising_edge(clk) then
      --  if (rst = '1') then
      --    q(LEN-1 downto 1) <= (others = > '0');
      --  else
      if (strobe40_i = '0') then
        q(LEN-1 downto 1) <= q(LEN-2 downto 0);
      end if;
      --  end if;
    end if;
  end process;

  delay_int <= conv_integer(delay_i);
  dsig_o <= q(delay_int);

end rtl;
