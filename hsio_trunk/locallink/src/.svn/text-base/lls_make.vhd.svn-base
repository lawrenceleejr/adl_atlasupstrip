--
-- LocalLink LLS record maker
--


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library utils;
use utils.pkg_types.all;

entity lls_make is
   port( 
      lls       : out  t_llsrc;
      src_rdy_i : in     std_logic;
      sof_i     : in     std_logic;
      eof_i     : in     std_logic;
      data_i    : in     std_logic_vector (15 downto 0)
   );

-- Declarations

end lls_make ;


architecture rtl of lls_make is
begin

---------------------------------------------------------------

  lls.src_rdy <= src_rdy_i;
  lls.sof     <= sof_i;
  lls.eof     <= eof_i;
  lls.data    <= data_i;

-----------------------------------------------------------------------------------
end architecture;
