----------------------------------------------------------------------------------
-- 
-- Create Date:    14:34:29 03/02/2012 
-- Design Name: 
-- Module Name:    ll_test_sink - Behavioral 
-- Project Name: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;

use hsio.pkg_hsio_globals.t_llstore;
use hsio.pkg_hsio_globals.t_llbus;

entity ll_test_sink is
  port (
    clk : in  std_logic;
    ll : in t_llbus;

    data_store : out t_llstore);
end ll_test_sink;

architecture Behavioral of ll_test_sink is
  signal store : t_llstore;
  signal pointer : natural := 0;

begin

  store_output : process (clk, ll.src_rdy, ll.dst_rdy, ll.data)
  begin
    if (clk = '1' and clk'event) then
      if (ll.sof = '1') then
        if (ll.src_rdy = '1' and ll.dst_rdy = '1') then        -- buffer is reading out
          pointer <= 1;
          store(0) <= ll.data;
        else
          pointer <= 0;
        end if;
      elsif (ll.src_rdy = '1' and ll.dst_rdy = '1') then        -- buffer is reading out
        store(pointer) <= ll.data;
        pointer <= pointer + 1;
      else
        pointer <= pointer;
      end if;

    end if;
  end process;

  data_store <= store;

end Behavioral;

