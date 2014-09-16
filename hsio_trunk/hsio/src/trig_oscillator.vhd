--
-- VHDL Architecture hsio.trig_osc.rtl
--
-- Created:
--          by - warren.warren (fedxtron)
--          at - 09:06:46 06/03/10
--
-- using Mentor Graphics HDL Designer(TM) 2008.1b (Build 7)
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity trig_oscillator is
   generic( 
      PERIOD      : integer                      := 10000000;
      PULSE_SHAPE : std_logic_vector(3 downto 0) := "0001";
      SIM_MODE    : integer                      := 0
   );
   port( 
      trig : out    std_logic;
      en   : in     std_logic;
      clk  : in     std_logic;
      rst  : in     std_logic
   );

-- Declarations

end trig_oscillator ;

--
architecture rtl of trig_oscillator is
  signal counter : std_logic_vector(31 downto 0);
  signal counter_max : std_logic_vector(31 downto 0);
  signal sr      : std_logic_vector(3 downto 0);
  signal tick    : std_logic;
  
begin

  counter_max <= x"00000080" when (SIM_MODE = 1) else
    conv_std_logic_vector(PERIOD, 32);
                 
  prc_counter : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') or (en = '0') then
        counter <= (others => '0');
          tick <= '0';
      else
        --default
        tick <= '0';

        if (counter = counter_max) then
          tick    <= '1';
          counter <= (others => '0');
        else
          counter <= counter + '1';
        end if;

      end if;
    end if;
  end process;

  prc_sr : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') or (en = '0') then
        sr <= (others => '0');

      else
        
        if (tick = '1') then
          sr <= PULSE_SHAPE;

        else
          sr <= ('0' & sr(3 downto 1));
          
          

        end if;
      end if;
    end if;
  end process;


  trig <= sr(0);


end architecture rtl;

