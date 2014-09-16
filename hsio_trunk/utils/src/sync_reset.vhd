--
-- VHDL Architecture UtilityLib.LedFlash.rtl
--
-- Created:
--          by - warren.warren (positron)
--          at - 11:09:07 03/05/07
--
-- using Mentor Graphics HDL Designer(TM) 2006.1 (Build 72)
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY sync_reset IS
   GENERIC( 
      LENGTH : integer := 6
   );
   PORT( 
      aresetdone_i : IN     std_logic;
      areset_i     : IN     std_logic;
      sreset_o     : OUT    std_logic;
      clk          : IN     std_logic
   );

-- Declarations

END sync_reset ;


architecture rtl of sync_reset is

  signal q : std_logic_vector(LENGTH-1 downto 0);

begin



  -- Create synchronous signal local clock domain.
  prc_gen_pulse : process (clk, areset_i)
  begin
    if (areset_i = '1') then
      q        <= (others => '1');
      sreset_o <= '1';

    elsif rising_edge(clk) then
      if (aresetdone_i = '1') then
        q(0)                 <= '0';
        q(LENGTH-1 downto 1) <= q(LENGTH-2 downto 0);
        sreset_o             <= q(LENGTH-1);
      end if;
    end if;
  end process prc_gen_pulse;


end rtl;
