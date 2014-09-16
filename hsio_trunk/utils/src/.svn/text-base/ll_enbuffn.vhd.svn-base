--
-- m_buff
-- Matts BUFFer
-- A little entity to make a small buff for the diags
--
--

library ieee;
use ieee.std_logic_1164.all;

ENTITY ll_enbuffn IS
   PORT( 
      srci  : IN     std_logic;
      sofi  : IN     std_logic;
      eofi  : IN     std_logic;
      dsto  : OUT    std_logic;
      srcno : OUT    std_logic;
      sofno : OUT    std_logic;
      eofno : OUT    std_logic;
      dstni : IN     std_logic;
      en    : IN     std_logic
   );

-- Declarations

END ll_enbuffn ;


architecture rtl of ll_enbuffn is
begin


  srcno <= not(srci and en);
  sofno <= not(sofi and en);
  eofno <= not(eofi and en);
  dsto  <= not(dstni) and en;


end rtl;
