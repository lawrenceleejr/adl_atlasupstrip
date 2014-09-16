-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

LIBRARY ieee;
Library Unisim;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity disp_binmap is
--   generic ( 
--        BIT_MODE : integer := 1
--); 
   port (
	--binary_i : in std_logic_vector(3 downto 0);
	bit0 : in std_logic;
	bit1 : in std_logic;
	bit2 : in std_logic;
	bit3 : in std_logic;
       dispchar_o : out std_logic_vector(7 downto 0)
);
 

end disp_binmap;


-- Define architecture for first level module
architecture rtl of disp_binmap is 
   signal dci : integer range 0 to 63;
   signal bin : std_logic_vector(3 downto 0);

begin

  bin <= bit3 & bit2 & bit1 & bit0;

--  bin <= binary_i when (BIT_MODE = '0') else
--         (bit3 & bit2 & bit1 & bit0);

  with bin select dci <= 
    40 when x"1",
    41 when x"2",
    42 when x"3",
    43 when x"4",
    44 when x"5",
    45 when x"6",
    46 when x"7",
    47 when x"8",
    48 when x"9",
    49 when x"a",
    50 when x"b",
    51 when x"c",
    52 when x"d",
    53 when x"e",
    54 when x"f",
    39 when others;


   dispchar_o <= conv_std_logic_vector(dci, 8);


end rtl;
