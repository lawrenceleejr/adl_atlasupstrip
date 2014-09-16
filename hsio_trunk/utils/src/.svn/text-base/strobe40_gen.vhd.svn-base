--
--
-- The idea is to syncronise strobe40 with the incoming clk40
--
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity strobe40_gen is
   port( 
      strobe40_o : out    std_logic;
      clk40      : in     std_logic;
      rst        : in  std_logic;
      clk        : in     std_logic
   );

-- Declarations

end strobe40_gen ;

--
architecture rtl of strobe40_gen is

  signal toggle20 : std_logic := '0';
  signal rise_q  : std_logic_vector(1 downto 0) := "00";

  signal strobe40 : std_logic;


begin


  prc_clk40 : process (clk40) --, rst)
  begin

    --if (rst = '1') then
      --toggle20 <= '0';

    --else
      if rising_edge(clk40) then
        toggle20 <= not(toggle20);

      end if;
    --end if;
  end process;




  prc_strobe40 : process (clk)
  begin
    if rising_edge(clk) then

      --if (rst = '1') then
        --rise_q <= "00";

      --else
        rise_q <= rise_q(0) & toggle20;

        if (rise_q = "01") then
          strobe40 <= '1';

        else
          strobe40 <= not(strobe40);

        end if;
      --end if;
    end if;
  end process;

  strobe40_o <= strobe40;



end architecture rtl;

