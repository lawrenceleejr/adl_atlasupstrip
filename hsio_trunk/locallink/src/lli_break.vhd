--
--
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library utils;
use utils.pkg_types.all;

entity lli_break is
   port( 
      dst_rdy_i : in     std_logic;
      data_o    : out    std_logic_vector (15 downto 0);
      eof_o     : out    std_logic;
      sof_o     : out    std_logic;
      src_rdy_o : out    std_logic;
      lli     : inout  t_llbus
   );

-- Declarations

end lli_break ;

--
architecture rtl of lli_break is
begin

  src_rdy_o <= lli.src_rdy;
  sof_o <= lli.sof;
  eof_o <= lli.eof;
  data_o <= lli.data;
  lli.dst_rdy <= dst_rdy_i;
  
end architecture rtl;

