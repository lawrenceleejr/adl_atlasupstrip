--
-- Trigger Selector
--
--
--
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity trig_select is
  generic(
    DELAY_MAX    :     integer := 256
    );
  port(
    delay_i      : in  std_logic_vector (15 downto 0);
    trig_i       : in  std_logic;
    trig_com_o   : out std_logic;
    trig_l1r_o   : out std_logic;
    l1r_sel_i    : in  std_logic;
    pattern_en_i : in  std_logic;
    pattern_go_o : out std_logic;
    strobe40_i   : in  std_logic;
    rst          : in  std_logic;
    clk          : in  std_logic
    );

-- Declarations

end trig_select;

architecture rtl of trig_select is

  signal q         : std_logic_vector(2 downto 0);
  signal d         : std_logic_vector(DELAY_MAX-1 downto 0);
  signal delay_int : integer range 0 to (DELAY_MAX-1);

  signal trig_delayed : std_logic;

  signal trig_com   : std_logic;
  signal trig_l1r   : std_logic;
  signal pattern_go : std_logic;


  type states is (Bit1, Bit2, Idle);
  signal state, nstate : states;

begin


  d(0) <= trig_i;

  process (clk)
  begin
    if rising_edge(clk) then
      if (strobe40_i = '0') then
        d(DELAY_MAX-1 downto 1) <= d(DELAY_MAX-2 downto 0);
      end if;
    end if;
  end process;

  delay_int <= conv_integer(delay_i);

  trig_delayed <= d(delay_int);



  -- State Machine
  ----------------------------------------------------------------
  prc_sm_sync : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        state <= Idle;

      elsif (strobe40_i = '0') then
        state <= nstate;

      end if;
    end if;
  end process;



  prc_sm_async : process (state, trig_delayed)
  begin

    -- defaults
    trig_com   <= '0';
    trig_l1r   <= '0';
    pattern_go <= '0';


    case state is

      when Idle =>
        nstate       <= Idle;
        if (trig_delayed = '1') then
          trig_com   <= '1';
          trig_l1r   <= '1';
          pattern_go <= '1';
          nstate     <= Bit1;
        end if;


      when Bit1 =>
        trig_com <= '1';
        nstate   <= Bit2;


      when Bit2 =>
        nstate <= Idle;


    end case;
  end process;


  prc_clock_out : process (clk)
  begin
    if rising_edge(clk) then
      if (strobe40_i = '0') then

        trig_com_o   <= trig_com and not(l1r_sel_i) and not(pattern_en_i);
        trig_l1r_o   <= trig_l1r and l1r_sel_i and not(pattern_en_i);
        pattern_go_o <= pattern_go and pattern_en_i;
      end if;
    end if;
  end process;

end rtl;
