--
-- Set lls to zero
-- 


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library utils;
use utils.pkg_types.all;

entity lls_zero is
   port( 
      lls_o : out     t_llsrc
   );

-- Declarations

end lls_zero ;

--
architecture rtl of lls_zero is

begin


  lls_o.src_rdy <= '0';
  lls_o.sof     <= '0';
  lls_o.eof     <= '0';
  lls_o.data    <= (others => '0');


end architecture rtl;

