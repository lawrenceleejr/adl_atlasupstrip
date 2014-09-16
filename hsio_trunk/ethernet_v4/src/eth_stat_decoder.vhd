--
-- VHDL Architecture EthernetInterface2.eth_stat_decoder.rtl
--
-- Created:
--          by - warren.warren (positron)
--          at - 16:14:42 07/31/07
--
-- using Mentor Graphics HDL Designer(TM) 2006.1 (Build 72)
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity eth_stat_decoder is
   port( 
      rx_clk           : in     std_logic;
      rst              : in     std_logic;
      tx_clk           : in     std_logic;
      tx_stats_i       : in     std_logic;
      tx_stats_valid_i : in     std_logic;
      tx_status_o      : out    std_logic_vector (31 downto 0);
      rx_stats_i       : in     std_logic_vector (6 downto 0);
      rx_stats_valid_i : in     std_logic;
      rx_status_o      : out    std_logic_vector (27 downto 0);
      rxdvld_i         : in     std_logic;
      rxdcount_o       : out    std_logic_vector (31 downto 0)
   );

-- Declarations

end eth_stat_decoder ;


architecture rtl of eth_stat_decoder is

  signal tx_counter : std_logic_vector(4 downto 0);
  signal rx_counter : std_logic_vector(1 downto 0);

  signal tx_status_int : std_logic_vector(31 downto 0);
  signal rx_status_int : std_logic_vector(27 downto 0);

  signal rxdcount : std_logic_vector(31 downto 0);

begin

  process (rst, tx_clk)
  begin

    -- TX
    -----
    if (rst = '1') then
      tx_counter    <= (others => '0');
      tx_status_int <= (others => '0');
      tx_status_o   <= (others => '0');

    elsif rising_edge(tx_clk) then

      if (tx_stats_valid_i = '1') then
        tx_counter    <= tx_counter + '1';
        tx_status_int <= (tx_stats_i & tx_status_int(31 downto 1));

      else
        tx_counter  <= (others => '0');
        tx_status_o <= tx_status_int;

      end if;
    end if;
  end process;


  -- RX
  -----
  process (rst, rx_clk)
  begin

    if (rst = '1') then
      rx_counter    <= (others => '0');
      rx_status_int <= (others => '0');
      rx_status_o   <= (others => '0');

    elsif rising_edge(rx_clk) then

      if (rx_stats_valid_i = '1') then
        rx_counter    <= rx_counter + '1';
        rx_status_int <= (rx_stats_i & rx_status_int(27 downto 7));

      else
        rx_counter  <= (others => '0');
        rx_status_o <= rx_status_int;

      end if;
    end if;
  end process;

  
  -- RX Byte Counter
  ----------------------------
  prc_counter : process (rst, rx_clk)
  begin

    if (rst = '1') then
      rxdcount <= (others => '0');

    elsif rising_edge(rx_clk) then
      if (rxdvld_i = '1') then
        rxdcount <= rxdcount + '1';

      end if;
    end if;

  end process;

  rxdcount_o <= rxdcount;

end architecture rtl;

