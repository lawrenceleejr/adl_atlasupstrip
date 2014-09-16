--
-- mux_dff
-- a ddr like demux using a clk2x
-- 
--
--

library ieee;
use ieee.std_logic_1164.all;

entity demux_ddr is
  port(
    q0_o       : out std_logic;
    q1_o       : out std_logic;
    swap_i     : in  std_logic;
    d_i        : in  std_logic;
    strobe1x_i : in  std_logic;
    clk2x      : in  std_logic;
    rst        : in  std_logic
    );

-- Declarations

end demux_ddr;


architecture rtl of demux_ddr is

  signal qq0 : std_logic;
  signal qq1 : std_logic;

begin

  prc : process (clk2x)
  begin

    if rising_edge(clk2x) then
      if (rst = '1') then
        qq0 <= '0';
        qq1 <= '0';

      else
        if (strobe1x_i = '0') then
          if (swap_i = '0') then
            qq0 <= d_i;
          else
            qq1 <= d_i;
          end if;

        else                            -- (strobe = '0')
          if (swap_i = '0') then
            qq1 <= d_i;
          else
            qq0 <= d_i;
          end if;
        end if;

        -- deskew/lengthen/align for output 
        if (strobe1x_i = '1') then
          q0_o <= qq0;
          q1_o <= qq1;
        end if;

      end if;
    end if;


  end process;

end rtl;
