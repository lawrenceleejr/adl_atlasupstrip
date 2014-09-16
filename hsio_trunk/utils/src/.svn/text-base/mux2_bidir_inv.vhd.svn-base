--
-- mux2_ininv
-- Mux2 with optional input invert
-- 
--
--

library ieee;
use ieee.std_logic_1164.all;

entity mux2_bidir_inv is
   generic( 
      P1_INV : integer := 0
   );
   port( 
      highz_i  : in     std_logic;
      i0  : in     std_logic;
      o0  : out    std_logic;
      t0  : in     std_logic;
      i1  : in     std_logic;
      o1  : out    std_logic;
      t1  : in     std_logic;
      mo  : in     std_logic;
      mi  : out    std_logic;
      mt  : out    std_logic;
      sel : in     std_logic
   );

-- Declarations

end mux2_bidir_inv ;


architecture rtl of mux2_bidir_inv is

  signal i00 : std_logic;
  signal o00 : std_logic;
  signal i11 : std_logic;
  signal o11 : std_logic;

begin

  i00 <= i0; -- when (P0_INV = 0) else not(i0);
  o00 <= mo; -- when (P0_INV = 0) else not(mo);
  o0 <= o00 when (sel = '0') else '0';

  i11 <= i1 when (P1_INV = 0) else not(i1);
  o11 <= mo when (P1_INV = 0) else not(mo);
  o1 <= o11 when (sel = '1') else '0';
  
  mi <= i11 when (sel = '1') else i00;

  mt <= '1' when (highz_i ='1') else
        t1  when (sel = '1') else t0;
  


end rtl;
