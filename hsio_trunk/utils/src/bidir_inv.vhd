--
-- bidir_inv
-- bidir buf with optional invert
-- 
--
--

library ieee;
use ieee.std_logic_1164.all;

entity bidir_inv is
   generic( 
      P1_INV : integer := 0
   );
   port( 
      highz_i  : in     std_logic;
      di  : in     std_logic;
      do  : out    std_logic;
      ti  : in     std_logic;
      mo  : in     std_logic;
      mi  : out    std_logic;
      mt  : out    std_logic;
      inv_i : in     std_logic
   );

-- Declarations

end bidir_inv ;


architecture rtl of bidir_inv is

  signal i00 : std_logic;
  signal o00 : std_logic;
  signal i11 : std_logic;
  signal o11 : std_logic;

begin

  i00 <= di;
  o00 <= mo;

  i11 <= di when (P1_INV = 0) else not(di);
  o11 <= mo when (P1_INV = 0) else not(mo);

  
  do <= o00 when (inv_i = '0') else o11;
  mi <= i00 when (inv_i = '0') else i11;
  
  mt <= '1' when (highz_i ='1') else ti;


end rtl;
