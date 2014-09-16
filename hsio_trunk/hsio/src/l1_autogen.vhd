--
-- l1_autogen
-- Generate l1 string for auto matically after l0
--
-- Matt Warren
-- UCL
--


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity l1_autogen is
-- generic(
-- LEN : integer := 7;
-- DATA : integer := 0
-- );
  port(
    strobe40_i : in  std_logic;
    l0id_i      : in  std_logic_vector(31 downto 0);
    l0id_send_o   : out  std_logic_vector(7 downto 0);
    en_i      : in  std_logic;
    ecr_i      : in  std_logic;
    l0_i       : in  std_logic;
    l1_o       : out std_logic;
    rst        : in  std_logic;
    clk        : in  std_logic
    );

-- Declarations

end l1_autogen;

--
architecture rtl of l1_autogen is

  constant BIT_COUNT_MAX : integer := 12;

  signal bit_count : integer range 0 to BIT_COUNT_MAX;
  signal bit_count_en : std_logic;
  
  --signal l0id        : std_logic_vector(31 downto 0);
  signal l0id_send   : std_logic_vector(7 downto 0);
  signal l0id_send_inc   : std_logic;

  signal l1word      : std_logic_vector(BIT_COUNT_MAX downto 0);
  
  type states is ( Idle, SendL0 );
  signal state, nstate : states;

begin

  l1word <= "0110" & l0id_send & '0';


  -- State Machine
  --------------------------------------------------------
  prc_sync_part : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        state <= Idle;
      else
        state <= nstate;

      end if;
    end if;
  end process;

  ------------------------------------------------------------------

  prc_async_machine : process ( en_i, l0id_i, l0id_send, bit_count, state )
  begin

    -- defaults
    nstate         <= Idle;
    l0id_send_inc  <= '0';
    bit_count_en <= '0';

    case state is
      
      when Idle =>
        nstate   <= Idle;
        if (l0id_i(7 downto 0) /= l0id_send) and (en_i = '1') then
          l0id_send_inc <= '1';
          nstate <= SendL0;
        end if;

     when SendL0 =>
        nstate            <= SendL0;
        bit_count_en    <= '1';
        if (bit_count = 0) then
          bit_count_en  <= '0';
          nstate          <= Idle;
        end if;

    end case;
  end process;

  -------------------------------------------------------------------

  prc_l1_out : process (clk)
  begin
    if rising_edge(clk) then
      if (strobe40_i = '0') then
          l1_o <= l1word(bit_count);

      end if;
    end if;
  end process;

  
  
--   prc_l0id : process (clk)
--   begin

--     if rising_edge(clk) then
--       if (rst = '1') or (en_i = '0') then
--         l0id <= x"ffffffff";

--       else
--         if (l0_i = '1') and (strobe40_i = '1') then
--           if (l0id = x"ffffffff") then
--             l0id <= x"00000000";
            
--           else
--             l0id <= l0id + '1';
            
--           end if;
          
--         elsif (ecr_i = '1') then
--           l0id <= x"ffffffff";
          
--         end if;
--       end if;
--     end if;
--   end process;


  
  prc_l0id_send : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
         l0id_send <= x"ff";

      else
        if (l0id_send_inc = '1') then
          if (l0id_send = x"ff") then
            l0id_send <= x"00";
            
          else
            l0id_send <= l0id_send + '1';
            
          end if;
          
        elsif (ecr_i = '1') then
          l0id_send <= x"ff";
          
        end if;
      end if;
    end if;
  end process;

  l0id_send_o <= l0id_send;
  

  prc_bit_counter : process (clk)
  begin

    if rising_edge(clk) then
      if (rst = '1') or (bit_count_en = '0') then
        bit_count <= BIT_COUNT_MAX;

      else
        if (strobe40_i = '0') then
          bit_count <= bit_count - 1;
          
        end if;
      end if;
    end if;
  end process;






end architecture rtl;

