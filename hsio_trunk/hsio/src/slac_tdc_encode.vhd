
--------------------------------------------------------------
-- Simple (as in easy to synth) data reduction for for Martin
-- Kocians TDC (for the High Speed I/O board)
-- Matt Warren 05/2014
--------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

library utils;
use utils.pkg_types.all;

--------------------------------------------------------------

entity slac_tdc_encode is

  port( clk        : in  std_logic;
        rst        : in  std_logic;
        counter1_i : in  std_logic_vector(31 downto 0);
        counter2_i : in  std_logic_vector(31 downto 0);
        code_o     : out std_logic_vector(19 downto 0)
        );
end slac_tdc_encode;

---------------------------------------------------------------

architecture rtl of slac_tdc_encode is
  signal raw  : std_logic_vector(74 downto 0);

  signal raw_subset : slv15_array(4 downto 0);
  
  signal code : std_logic_vector(19 downto 0);

begin

  raw <= x"00" & "000" & counter2_i & counter1_i;

  encoder : for n in 0 to 4 generate

    raw_subset(n) <= raw(n*15+14 downto n*15);
    
    with raw_subset(n) select
      code(n*4+3 downto n*4) <=
      x"f" when "111111111111111",
      x"e" when "011111111111111",
      x"d" when "001111111111111",
      x"c" when "000111111111111",
      x"b" when "000011111111111",
      x"a" when "000001111111111",
      x"9" when "000000111111111",
      x"8" when "000000011111111",
      x"7" when "000000001111111",
      x"6" when "000000000111111",
      x"5" when "000000000011111",
      x"4" when "000000000001111",
      x"3" when "000000000000111",
      x"2" when "000000000000011",
      x"1" when "000000000000001",
      x"0" when others;

  end generate;


  code_o <= code when rising_edge(clk);
  
end rtl;




