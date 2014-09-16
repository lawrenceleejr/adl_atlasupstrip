--
--
-- 
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ddr_encode is
  port(
    lo_i  : in  std_logic;
    hi_i  : in  std_logic;
    ddr_o : out std_logic;
    clk2x : in  std_logic;
    clk   : in  std_logic
    );

-- Declarations

end ddr_encode;

architecture rtl of ddr_encode is

  signal lo_q : std_logic_vector(1 downto 0);
  signal hi_q : std_logic_vector(1 downto 0);
  signal ddr  : std_logic;

begin



  -- try to sync things up for meta and clk domain cross
  prc_ddr : process (clk)
  begin
    if rising_edge(clk) then
      lo_q <= lo_q(0) & lo_i;
      hi_q <= hi_q(0) & hi_i;
    end if;
  end process;


  ddr <= hi_q(1) when (clk = '0') else lo_q(1);


  ddr_o <= ddr when falling_edge(clk2x);


end architecture rtl;

