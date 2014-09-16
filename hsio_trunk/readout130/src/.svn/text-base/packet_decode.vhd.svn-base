--
-- Packet Decoder 
--
-- Matt Warren, UCL
--
-- Simply braeak a packet into pieces 
--
-- Log:
-- 13/12/2013 - File born (initially copied from ro13_deser.vhd)
--
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library utils;
use utils.pkg_types.all;
library hsio;
use hsio.pkg_hsio_globals.all;

entity packet_decode is
  generic(
    PKT_TYPE       :     integer := 0   -- unused
    );
  port(
    packet_i       : in  slv64;
    pkt_valid_i    : in  std_logic;
    pkt_rdack_o    : out std_logic;
    pkt_a13_o      : out t_pkt_a13;
    datawd_l11bc_o : out t_datawd_l11bc;
    datawd_l13bc_o : out t_datawd_l13bc;
    datawd_r3_o    : out t_datawd_r3;
    datawd_reg32_o : out slv32;
    clk            : in  std_logic;
    rst            : in  std_logic
    );

-- Declarations

end packet_decode;

--
architecture rtl of packet_decode is

  signal pkt_a13 : t_pkt_a13;
  signal datawd  : slv33;

  constant OS : integer := 0;

begin



  prc_latch : process (clk)
  begin
    if rising_edge(clk) then
      pkt_rdack_o <= '0';
      
      if (pkt_valid_i = '1') then
        pkt_rdack_o <= '1';

        pkt_a13.startb <= packet_i(59+OS);               --  1
        pkt_a13.chipid <= packet_i(58+OS downto 54+OS);  --  5
        pkt_a13.typ    <= packet_i(53+OS downto 50+OS);  --  4
        pkt_a13.l0id   <= packet_i(49+OS downto 42+OS);  --  8
        pkt_a13.bcid   <= packet_i(41+OS downto 34+OS);  --  8
        pkt_a13.datawd <= packet_i(33+OS downto 1+OS);   -- 33
        pkt_a13.stopb  <= packet_i(0+OS);                --  1
      end if;
    end if;

  end process;

  pkt_a13_o <= pkt_a13;



  datawd_l11bc_o.strip0 <= pkt_a13.datawd(32 downto 25);
  datawd_l11bc_o.hits0  <= pkt_a13.datawd(24 downto 22);
  datawd_l11bc_o.strip1 <= pkt_a13.datawd(21 downto 14);
  datawd_l11bc_o.hits1  <= pkt_a13.datawd(13 downto 11);
  datawd_l11bc_o.strip2 <= pkt_a13.datawd(10 downto 3);
  datawd_l11bc_o.hits2  <= pkt_a13.datawd( 2 downto 0);

  datawd_l13bc_o.strip <= pkt_a13.datawd(32 downto 25);
  datawd_l13bc_o.hits0 <= pkt_a13.datawd(24 downto 22);
  datawd_l13bc_o.hits1 <= pkt_a13.datawd(21 downto 19);
  datawd_l13bc_o.hits2 <= pkt_a13.datawd(18 downto 16);
  datawd_l13bc_o.hits3 <= pkt_a13.datawd(15 downto 13);

  datawd_r3_o.strip0 <= pkt_a13.datawd(32 downto 25);
  datawd_r3_o.strip1 <= pkt_a13.datawd(24 downto 17);
  datawd_r3_o.strip2 <= pkt_a13.datawd(16 downto 9);
  datawd_r3_o.strip3 <= pkt_a13.datawd(8 downto 1);
  datawd_r3_o.ovf    <= pkt_a13.datawd(0);


  datawd_reg32_o <= pkt_a13.datawd(32 downto 1);


end architecture rtl;

