--
-- mux2_ininv
-- Mux2 with optional input invert
-- 
--
--

library ieee;
use ieee.std_logic_1164.all;

entity mux2_ininv is
  generic (
    I0_INV : integer := 0;
    I1_INV :integer := 0
    );
    
  port(
    i0  : in  std_logic;
    i1  : in  std_logic;
    m  : out  std_logic;
    sel  : in  std_logic
    );

-- Declarations

end mux2_ininv;


architecture rtl of mux2_ininv is

  signal i00 : std_logic;
  signal i11 : std_logic;

begin

  i00 <= i0 when (I0_INV = 0) else not(i0);
  i11 <= i1 when (I1_INV = 0) else not(i1);

  m <= i11 when (sel = '1') else i00;

end rtl;
