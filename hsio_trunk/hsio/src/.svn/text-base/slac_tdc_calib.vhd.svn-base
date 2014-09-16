--------------------------------------------------------------
--
-- Calibration gen for Martin Kocians TDC (for the HSIO)
--
-- Matt Warren 05/2014
--
--------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library utils;
use utils.pkg_types.all;

--------------------------------------------------------------

entity slac_tdc_calib is

  port (
    delayq_i : in  std_logic_vector(1 downto 0);
    edge0_o  : out std_logic;
    clk160ps : in  std_logic;
    s40      : in  std_logic;
    rst      : in  std_logic

    );
end slac_tdc_calib;

---------------------------------------------------------------

architecture rtl of slac_tdc_calib is

  signal rr  : std_logic_vector(3 downto 0);
  signal sr  : std_logic_vector(7 downto 0);
  signal dq0 : std_logic_vector(1 downto 0);
  signal dq1 : std_logic_vector(1 downto 0);
  signal edge0 : std_logic;

begin


  -- try sync reset to ps domain


  -- sync

  prc_start : process (clk160ps)
  begin
    if rising_edge(clk160ps) then

      rr <= (rr(2 downto 0) & s40);

      if (rr(3 downto 2) = "01") and (rst = '1') then
        sr <= x"80";

      else
        sr <= sr(0) & sr(7 downto 1);

      end if;
      

      dq0 <= delayq_i;
      dq1 <= dq0;
      
      case dq1 is
        when "00"   => edge0 <= sr(5);
        when "01"   => edge0 <= sr(4);
        when "10"   => edge0 <= sr(3);
        when "11"   => edge0 <= sr(2);
        when others => null;
      end case;

      edge0_o <= edge0;
      
    end if;
  end process;


end rtl;




