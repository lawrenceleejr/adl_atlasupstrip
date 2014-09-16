--
-- sercom_gen
-- Generate short strings of serial commands from COM
--
-- Matt Warren
-- UCL
--


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity sercom_gen is
  generic(
    LEN        :     integer := 7;
    DATA       :     integer := 0
    );
  port(
    strobe40_i : in  std_logic;
    ena_i      : in  std_logic;
    go_i       : in  std_logic;
    com_o      : out std_logic;
    rst        : in  std_logic;
    clk        : in  std_logic
    );

-- Declarations

end sercom_gen;

--
architecture rtl of sercom_gen is

  signal nbit     : integer range 0 to LEN+1;
  signal data_slv : std_logic_vector(LEN+1 downto 0);

begin

  data_slv <= '0' & conv_std_logic_vector(DATA, LEN) & '0';

  process (clk)
  begin

    if rising_edge(clk) then

      if (rst = '1') or (ena_i = '0') then
        nbit <= 0;

      else
        if (strobe40_i = '0') then
          if (go_i = '1') then
            nbit     <= LEN+1;

          elsif (nbit > 0) then
              nbit <= nbit - 1;

          end if;
        end if;
      end if;
    end if;
  end process;

  com_o <= data_slv(nbit);

end architecture rtl;

