--
--
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity edgedet_sync is
   generic( 
      EN_ID : integer := 0
   );
   port( 
      s40 : in     std_logic;
      async_i        : in     std_logic;
      async_o        : out     std_logic;
      edgesync_o        : out    std_logic;
      sync_o        : out    std_logic;
      ena_i      : in     std_logic_vector (15 downto 0);
      inv_i      : in     std_logic_vector (15 downto 0);
      rst        : in     std_logic;
      clk        : in     std_logic
   );

-- Declarations

end edgedet_sync ;


architecture rtl of edgedet_sync is

  signal qi : std_logic_vector(2 downto 0);
  signal ts : std_logic_vector(1 downto 0);
  signal qo : std_logic_vector(1 downto 0);
  signal a0 : std_logic;
  
begin

  a0 <= (async_i xor inv_i(EN_ID)) and ena_i(EN_ID);

  async_o <= a0;

  qi <= qi(1 downto 0) & a0 when rising_edge(clk);

  -- syncro version of input
  sync_o <= qi(1);
 

  ts(0) <= '1' when (qi(2 downto 1) = "01") else '0';
  ts(1) <= ts(0) when rising_edge(clk);


  qo(0) <= '1' when (s40 = '0') and  (ts /= "00") else '0';
  qo(1) <= qo(0) when rising_edge(clk);


  -- full edge detected, synchro, l2p
  edgesync_o <= qo(0) or qo(1) when rising_edge(clk);


--   process (clk)
--   begin
--     if rising_edge(clk) then
--       if (rst = '1') then
--         qi <= (others => '0');
--         qo <= (others => '0');

--       else
--         qi <= qi(2 downto 0) & a0;

--         -- default
--         qo(0) <= '0';

--         if (qi(2 downto 1) = "01") or (qi(3 downto 2) = "01") then
--           if (s40 = '0') then
--             qo(0) <= '1';
--           end if;
--         end if;

--         qo(1) <= qo(0);

--       end if;
--     end if;
--   end process;

--   s_o <= qo(0) or qo(1);

end rtl;
