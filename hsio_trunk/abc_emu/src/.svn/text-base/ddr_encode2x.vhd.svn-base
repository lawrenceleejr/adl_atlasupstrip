--
--
-- 
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ddr_encode2x is
  port(
    lo_i     : in  std_logic;
    hi_i     : in  std_logic;
    ddr_o    : out std_logic;
    strobe_i : in  std_logic;
    clk2x    : in  std_logic
    --rst       : in     std_logic
    );

-- Declarations

end ddr_encode2x;

--
architecture rtl of ddr_encode2x is

begin

  prc_ddr : process (clk2x)
  begin
    if falling_edge(clk2x) then
      if (strobe_i = '1') then -- inverted from usual because clk40=bcon
        ddr_o <= hi_i;-- after 100 ps;
      else
        ddr_o <= lo_i;-- after 100 ps;
      end if;
    end if;
  end process;

end architecture rtl;

