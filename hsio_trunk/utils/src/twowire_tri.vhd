--
-- m_tristate
-- Matts Tristate buffer
-- A little entity to make a small buff for the diags
--
--

library ieee;
use ieee.std_logic_1164.all;

library UNISIM;
use UNISIM.vcomponents.all;

entity twowire_tri is
  port(
    sck_i   : in  std_logic;
    sck_ti  : in  std_logic;
    sck_pin : out std_logic;

    sda_i   : in    std_logic;
    sda_o   : out   std_logic;
    sda_ti  : in    std_logic;
    sda_pin : inout std_logic
    );

-- Declarations

end twowire_tri;


architecture rtl of twowire_tri is

  component PULLUP
    port (
      O : out std_logic
      );
  end component;

begin

--  sck_pullup : PULLUP
--    port map (
--      O => sck_pin
--      );


  sck_pin <= 'Z' when (sck_ti = '1') else sck_i;




--  sda_pullup : PULLUP
--    port map (
--      O => sda_pin
--      );

  sda_o   <= sda_pin;
  sda_pin <= 'Z' when (sda_ti = '1') else sda_i;


end rtl;
