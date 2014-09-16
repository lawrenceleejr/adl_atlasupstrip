--
-- VHDL Architecture
--
-- Created:
--          by - warren.warren (positron)
--          at - 
--
-- using Mentor Graphics HDL Designer(TM) 2006.1 (Build 72)
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY PauseQuantaTimer IS
   PORT( 
      clk           : IN     std_logic;
      rst           : IN     std_logic;
      quanta_tick_o : OUT    std_logic
   );

-- Declarations

END PauseQuantaTimer ;



architecture rtl of PauseQuantaTimer is

  signal pqt_counter : std_logic_vector(10 downto 0);

begin
  prc_sigs_count : process (clk)
  begin
    if (rising_edge(clk)) then
      if (rst = '1') then

        pqt_counter   <= (others => '0');
        quanta_tick_o <= '1';

      else
        quanta_tick_o <= '0';

        pqt_counter <= pqt_counter + '1';

        
        if (pqt_counter = "10011111101") then

          pqt_counter   <= (others => '0');
          quanta_tick_o <= '1';

        end if;
      end if;
    end if;
  end process;


end architecture rtl;

