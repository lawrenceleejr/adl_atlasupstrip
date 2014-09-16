--
-- m_buff
-- Matts BUFFer
-- A little entity to make a small buff for the diags
--
--

library ieee;
use ieee.std_logic_1164.all;

ENTITY ll_enbuff IS
   PORT( 
      srci : IN     std_logic;
      sofi : IN     std_logic;
      eofi : IN     std_logic;
      dsto : OUT    std_logic;
      srco : OUT    std_logic;
      sofo : OUT    std_logic;
      eofo : OUT    std_logic;
      dsti : IN     std_logic;
      en   : IN     std_logic
   );

-- Declarations

END ll_enbuff ;


architecture rtl of ll_enbuff is
begin
  srco <= srci and en;
  sofo <= sofi and en;
  eofo <= eofi and en;
  dsto <= dsti and en;
end rtl;
