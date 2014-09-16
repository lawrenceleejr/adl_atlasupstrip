--
--
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library utils;
use utils.pkg_types.all;

entity lls_break is
   port( 
      data_o    : out    std_logic_vector (15 downto 0);
      eof_o     : out    std_logic;
      sof_o     : out    std_logic;
      src_rdy_o : out    std_logic;
      lls_i     : in  t_llsrc
   );

-- Declarations

end lls_break ;

--
architecture rtl of lls_break is
begin

  src_rdy_o <= lls_i.src_rdy;
  sof_o <= lls_i.sof;
  eof_o <= lls_i.eof;
  data_o <= lls_i.data;
  
end architecture rtl;

