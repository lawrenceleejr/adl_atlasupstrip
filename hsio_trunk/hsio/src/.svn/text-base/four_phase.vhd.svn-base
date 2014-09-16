--
--
-- Phase a 25ns signal through 0,90,180,270 using a rising and falling 12.5ns clock
--
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity four_phase is
  port(
    sig_i      : in  std_logic;
    sig_o      : out std_logic;
    dbg_sig0_o : out std_logic;
    sel_i      : in  std_logic_vector (1 downto 0);
    invert_i   : in  std_logic;
    com_i      : in  std_logic;
    com_en     : in  std_logic;
    rst        : in  std_logic;
    clk        : in  std_logic
    );

-- Declarations

end four_phase;

--
architecture rtl of four_phase is

  signal sig     : std_logic;
  signal sig_qs  : std_logic;
  signal sig_qc  : std_logic;
  signal sig_0   : std_logic;
  signal sig_90  : std_logic;
  signal sig_180 : std_logic;
  signal sig_270 : std_logic;


begin


  prc_com_180_0 : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        sig_qs <= '0';
        sig_qc <= '0';
        --sig_0   <= '0';
        --sig_180 <= '0';

      else
        sig_qs  <= sig_i;               
        sig_qc  <= (com_i and com_en); 
        sig_0   <= (sig_qs or sig_qc) xor invert_i;
        sig_180 <= sig_0;

      end if;
    end if;
  end process;


  prc_com_270_90 : process (clk)
  begin
    if falling_edge(clk) then
      sig_90  <= sig_i;
      sig_270 <= sig_i;
    end if;
  end process;

  

  with sel_i select
    sig <= sig_270 when "11",
           sig_180 when "10",
           sig_90  when "01",
           sig_0   when others;

  sig_o      <= sig;
  dbg_sig0_o <= ((sig_qs or sig_qc) xor invert_i) when rising_edge(clk);

end architecture rtl;

