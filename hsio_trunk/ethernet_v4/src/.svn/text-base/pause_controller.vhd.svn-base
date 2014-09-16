--
-- Pause controller
--
-- Matt Warren
-- 2008-08-01


-- log
--
--01/08/08 - this file created
--12/08/08 - modified to deal with external pause thresholds

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.eth_types.all;

entity pause_controller is
   generic( 
      PAUSE_QUANTA_VALUE : integer := 32;
      USE_LLFIFO_STAT    : boolean := false
   );
   port( 
      clk                 : in     std_logic;
      rst                 : in     std_logic;
      test_i              : in     std_logic;
      ext_pause_req_i     : in     std_logic;
      ext_pause_clr_i     : in     std_logic;
      quanta_timer_tick_i : in     std_logic;
      rx_fifo_stat_i      : in     std_logic_vector (3 downto 0);
      pause_req_o         : out    std_logic;
      pause_val_o         : out    std_logic_vector (15 downto 0)
   );

-- Declarations

end pause_controller ;

architecture rtl of pause_controller is

  type states is (
    s_reset,
    s_check_level,
    s_send_pause,
    s_send_pause_zero,
    s_wait_pause_timeout
    );

  signal state     : states;
  signal nextstate : states;

  signal pause_quanta_count : std_logic_vector(15 downto 0);
  signal resend_timeout : std_logic_vector(15 downto 0);
  signal pause_value        : std_logic_vector(15 downto 0);
  signal pause_req          : std_logic;
  signal pause_val          : std_logic_vector(15 downto 0);

  signal near_full         : std_logic;
  signal near_empty        : std_logic;
  signal llfifo_gt_half    : std_logic;
  signal llfifo_lt_quarter : std_logic;

begin

  pause_value    <= conv_std_logic_vector(PAUSE_QUANTA_VALUE, 16);
  resend_timeout <= conv_std_logic_vector(32, 16);
  
  
  pause_req_o <= '1'             when (test_i = '1') else pause_req;
  pause_val_o <= (others => '1') when (test_i = '1') else pause_val;

  llfifo_gt_half    <= '1' when (rx_fifo_stat_i(3) = '1')           else '0';
  llfifo_lt_quarter <= '1' when (rx_fifo_stat_i(3 downto 2) = "00") else '0';

  near_full  <= ext_pause_req_i when (USE_LLFIFO_STAT = false) else llfifo_gt_half;
  near_empty <= ext_pause_clr_i when (USE_LLFIFO_STAT = false) else llfifo_lt_quarter;


  prc_comb_machine : process (state, pause_quanta_count, pause_value, near_full, near_empty )
  begin

    -- defaults
    nextstate <= s_reset;
    pause_req <= '0';
    pause_val <= pause_value;

    case state is

      ---------------------------------------------------------  
      when s_reset           =>
        pause_req <= '0';
        --pause_val <= (others => '0');
        nextstate <= s_check_level;

      ---------------------------------------------------------  
      when s_check_level =>
        if (near_full = '1') then
          nextstate <= s_send_pause;

          --elsif (near_empty = '1') then
          --  nextstate <= s_send_pause_zero;
        else
          nextstate <= s_check_level;

        end if;

      ---------------------------------------------------------  
      when s_send_pause =>
        pause_req <= '1';
        pause_val <= pause_value;
        nextstate <= s_wait_pause_timeout;

      ---------------------------------------------------------  
      when s_wait_pause_timeout =>
        if (pause_quanta_count = resend_timeout) then
          nextstate <= s_check_level;

        elsif (near_empty = '1') then
          nextstate <= s_send_pause_zero;
        else
          nextstate <= s_wait_pause_timeout;
        end if;

      ---------------------------------------------------------  
      when s_send_pause_zero =>
        pause_val <= (others => '0');
        pause_req <= '1';
        nextstate <= s_check_level;


      ---------------------------------------------------------  
      when others =>
        null;
      ---------------------------------------------------------  

    end case;
  end process;


  -- State transitioner
  prc_state : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        state <= s_reset;

      else
        state <= nextstate;

      end if;
    end if;
  end process;


  -- Quanta Counter
  prc_quanta_count : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') or (pause_req = '1') then
        pause_quanta_count <= (others => '0');

      else
        if (quanta_timer_tick_i = '1') then
          pause_quanta_count <= pause_quanta_count + '1';
        end if;
      end if;
    end if;

  end process;


end architecture rtl;

