--
-- ff_dff
-- A quick and dirty ddr flip flop
-- 
--
--

library ieee;
use ieee.std_logic_1164.all;

entity ff_ddr_rx is
   port( 
      q0_o : out    std_logic;
      q1_o : out    std_logic;
      swap_i  : in     std_logic;
      d_i  : in     std_logic;
      clk  : in     std_logic;
      rst  : in     std_logic
   );

-- Declarations

end ff_ddr_rx ;


architecture rtl of ff_ddr_rx is
  signal qq0 : std_logic;
  signal qq1 : std_logic;


begin

  prc : process (clk)
  begin

    if rising_edge(clk) then
      if (rst = '1') then
        qq0  <= '0';
        q0_o <= '0';
        q1_o <= '0';

      else
        qq0  <= d_i;

        if (swap_i = '0') then
          q0_o <= qq0;
          q1_o <= qq1;

        else
          q0_o <= qq1;
          q1_o <= qq0;

        end if;
      end if;
    end if;


    if falling_edge(clk) then
      if (rst = '1') then
        qq1 <= '0';

      else
        qq1 <= d_i;

      end if;
    end if;


  end process;

  --qq0 <= d_i when rising_edge(clk);
  --qq1 <= d_i when falling_edge(clk);
  --q0_o <= qq0 when rising_edge(clk);
  --q1_o <= qq1 when rising_edge(clk);


end rtl;
