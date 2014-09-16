--
-- Set lls to zero when disabled, otherwise passthrough.
-- 


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library utils;
use utils.pkg_types.all;

entity lls_en_zero is
  port(
    lls_i : in  t_llsrc;
    lls_o : out t_llsrc;
    en_i  : in  std_logic
    );

-- Declarations

end lls_en_zero;

--
architecture rtl of lls_en_zero is

begin



  lls_o.src_rdy <= '0'             when (en_i = '0') else lls_i.src_rdy;
  lls_o.sof     <= '0'             when (en_i = '0') else lls_i.sof;
  lls_o.eof     <= '0'             when (en_i = '0') else lls_i.eof;
  lls_o.data    <= (others => '0') when (en_i = '0') else lls_i.data;


end architecture rtl;

