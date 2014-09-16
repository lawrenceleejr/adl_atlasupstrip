--
-- LocalLink LLO record maker
--


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library utils;
use utils.pkg_types.all;

entity llo_make is
   port( 
      llo       : inout  t_llbus;
      sof_i     : in     std_logic;
      eof_i     : in     std_logic;
      dst_rdy_o : out    std_logic;
      src_rdy_i : in     std_logic;
      data_i    : in     std_logic_vector (15 downto 0)
   );

-- Declarations

end llo_make ;


architecture rtl of llo_make is
begin

---------------------------------------------------------------

  llo.src_rdy <= src_rdy_i;
  llo.sof     <= sof_i;
  llo.eof     <= eof_i;
  llo.data    <= data_i;
  dst_rdy_o   <= llo.dst_rdy;

-----------------------------------------------------------------------------------
end architecture;
