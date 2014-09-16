--
-- mux_dff
-- a ddr like mux using a clk2x
-- 
--
--

library ieee;
use ieee.std_logic_1164.all;

entity mux_ddr is
   port( 
      q0_i       : in     std_logic;
      q1_i       : in     std_logic;
      swap_i     : in     std_logic;
      d_o        : out    std_logic;
      strobe1x_i : in     std_logic;
      clk2x      : in     std_logic;
      rst        : in     std_logic
   );

-- Declarations

end mux_ddr ;


architecture rtl of mux_ddr is

begin

  prc : process (clk2x)
  begin

    if rising_edge(clk2x) then
      if (rst = '1') then
        d_o <= '0';

      else
        if (strobe1x_i = '1') then
          if (swap_i = '0') then
            d_o <= q0_i;

          else
            d_o <= q1_i;

          end if;

        else                            -- (strobe = '0')
          if (swap_i = '0') then
            d_o <= q1_i;

          else
            d_o <= q0_i;

          end if;

        end if;
      end if;
    end if;


  end process;

end rtl;
