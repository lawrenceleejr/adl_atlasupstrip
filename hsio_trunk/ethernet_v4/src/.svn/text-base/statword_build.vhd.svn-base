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

entity statword_build is
   port( 
      clk               : in     std_logic;
      rst               : in     std_logic;
      rx_fifo_stat_i    : in     std_logic_vector (3 downto 0);
      syncaqu_i         : in     std_logic;
      sfp_not_present_i : in     std_logic;
      sfp_txfault_i     : in     std_logic;
      rx_status_i       : in     std_logic_vector (27 downto 0);
      tx_status_i       : in     std_logic_vector (31 downto 0);
      tx_fifo_stat_i    : in     std_logic_vector (3 downto 0);
      rxdcount_i        : in     std_logic_vector (31 downto 0);
      sfp_los_i         : in     std_logic;
      tx_overflow_i     : in     std_logic;
      rx_overflow_i     : in     std_logic;
      rx_framedrop_i    : in     std_logic;
      macstat_o         : out    std_logic_vector (63 downto 0);
      statword_o        : out    std_logic_vector (63 downto 0)
   );

-- Declarations

end statword_build ;


architecture rtl of statword_build is

  signal rx_overflow_count  : std_logic_vector(3 downto 0);
  signal rx_framedrop_count : std_logic_vector(3 downto 0);
  signal tx_overflow_count  : std_logic_vector(3 downto 0);
  signal sfp_los_count      : std_logic_vector(3 downto 0);

  signal sfp_los_q      : std_logic;
  signal tx_overflow_q  : std_logic;
  signal rx_overflow_q  : std_logic;
  signal rx_framedrop_q : std_logic;


begin

  macstat_o(63 downto 32) <= tx_status_i;
  macstat_o(27 downto 0)  <= rx_status_i;

  statword_o(63 downto 32) <= rxdcount_i;
  statword_o(31 downto 28) <= tx_overflow_count;
  statword_o(27 downto 24) <= tx_fifo_stat_i;
  statword_o(23 downto 20) <= sfp_los_count;
  statword_o(19)           <= tx_overflow_i;
--statword_o(18)
  statword_o(17)           <= not(sfp_not_present_i);
  statword_o(16)           <= sfp_txfault_i;
  statword_o(15 downto 12) <= rx_overflow_count;
  statword_o(11 downto 8)  <= rx_fifo_stat_i;
  statword_o( 7 downto 4)  <= rx_framedrop_count;
  statword_o( 3)           <= rx_overflow_i;
  statword_o( 2)           <= rx_framedrop_i;
  statword_o( 1)           <= sfp_los_i;
  statword_o( 0)           <= syncaqu_i;


  prc_sigs_count : process (clk)
  begin
    if (rising_edge(clk)) then
      if (rst = '1') then
        rx_overflow_count  <= (others => '0');
        rx_framedrop_count <= (others => '0');
        tx_overflow_count  <= (others => '0');
        sfp_los_count      <= (others => '0');


      else
        sfp_los_q      <= sfp_los_i;
        tx_overflow_q  <= tx_overflow_i;
        rx_overflow_q  <= rx_overflow_i;
        rx_framedrop_q <= rx_framedrop_i;


        if (sfp_los_q = '0') and (sfp_los_i = '1') then
          sfp_los_count <= sfp_los_count + '1';
        end if;


        if (tx_overflow_q = '0') and (tx_overflow_i = '1') then
          tx_overflow_count <= tx_overflow_count + '1';
        end if;


        if (rx_overflow_q = '0') and (rx_overflow_i = '1') then
          rx_overflow_count <= rx_overflow_count + '1';
        end if;

        if (rx_framedrop_q = '0') and (rx_framedrop_i = '1') then
          rx_framedrop_count <= rx_framedrop_count + '1';
        end if;

      end if;
    end if;
  end process;


end architecture rtl;

