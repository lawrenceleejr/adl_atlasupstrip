--
-- Simple Packet Mux
-- 
-- Async and VERY simple. Hopefully can skip sync version
-- Uses round robin port selection
-- 

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library utils;
use utils.pkg_types.all;

entity pkt_mux is
  generic(
    CHANNELS    :     integer := 2
    );
  port(
    -- Out Port
    packet_o    : out slv64;            --t_packet;
    pkt_valid_o : out std_logic;
    pkt_rdack_i : in  std_logic;

    -- In Ports
    packet_i    : in  slv64_array(CHANNELS-1 downto 0);  --t_packet_array(CHANNELS-1 downto 0);
    pkt_valid_i : in  std_logic_vector (CHANNELS-1 downto 0);
    pkt_rdack_o : out std_logic_vector (CHANNELS-1 downto 0);
    -- infrastructure
    rst         : in  std_logic;
    clk         : in  std_logic
    );

-- Declarations

end pkt_mux;

--
architecture rtl of pkt_mux is


  signal sel : integer range 0 to (CHANNELS-1);


begin


  packet_o    <= packet_i(sel);
  pkt_valid_o <= pkt_valid_i(sel);
--    pkt_rdack_o(sel) <= pkt_rdack_i (others => '0');
--    pkt_rdack_o <= (sel => pkt_rdack_i, others => '0');
  
  prc_rdack : process (sel, pkt_rdack_i)
  begin
    -- default
    pkt_rdack_o <= (others => '0');
	 
	 pkt_rdack_o(sel) <= pkt_rdack_i;
  end process;


  prc_sel : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        sel <= 0;

      else
        if (pkt_valid_i(sel) = '0') then
          if (sel = (CHANNELS-1)) then
            sel <= 0;

          else
            sel <= sel + 1;

          end if;
        end if;
      end if;
    end if;
  end process;


end architecture rtl;

