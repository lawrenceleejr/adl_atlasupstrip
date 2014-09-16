----------------------------------------------------------------------------
-- CERN
-- Author: Jens Dopke
-- Thanks to: My Parents and Xilinx (the latter ones for giving the right
--            taps for LFSRs)
----------------------------------------------------------------------------
-- Filename:
--    sct_simulator.vhd
-- Description:
--    LFSR based random number generator (19 Bit random number output), to
--      serve the maximum number of Shift_reg_Bits used in link_formatter
----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

----------------------------------------------------------------------------
--PORT DECLARATION
----------------------------------------------------------------------------

entity sct_sim_lfsr is
  port(
    --clk_in           : in  std_logic;   -- 40 MHz clock
    clk         : in  std_logic;                     -- 80 MHz clock
    mode40_strobe_i  : in  std_logic;                     -- 40 MHz clock strobe
    --rst_n_in    : in  std_logic;                     -- Powerup global reset
    rst    : in  std_logic;
    rnd_seed_in : in  std_logic_vector(7 downto 0);  -- random number seed
    rnd_num     : out std_logic_vector(18 downto 0)  -- random number output
    );
end sct_sim_lfsr;

architecture rtl of sct_sim_lfsr is

----------------------------------------------------------------------------
--SIGNAL DECLARATION
----------------------------------------------------------------------------

  signal rsr : std_logic_vector (18 downto 0);
--  signal rnd_seed : std_logic_vector (18 DOWNTO 0);

begin  --  Main Body of VHDL code

--------------------------------------------------------------------------
-- SIGNALS
--------------------------------------------------------------------------

  rnd_num <= rsr(18 downto 0);

--------------------------------------------------------------------------
-- PROCESS DECLARATION
--------------------------------------------------------------------------

  randomize : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        -- rsr <= (others => '0');
        rsr <= rnd_seed_in & "00000000000";
      else
        if (mode40_strobe_i = '0') then
          rsr <= rsr(17 downto 0) & (rsr(18) xnor rsr(5) xnor rsr(1) xnor rsr(0));
        end if;
      end if;
    end if;
  end process;

end rtl;

