--
-- VHDL Architecture ttc.ttc_decode.rtl
--
-- Created by Matt Warren 2012
--
--



library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity ttc_decode is
  port(
    sim_mode_i : in std_logic;

    -- TTC Inputs
    ttc_controls_i : in std_logic_vector (15 downto 0);
    ttc_data_i     : in std_logic_vector (15 downto 0);

    -- TTC Outputs
    ttc_l0a_o          : out std_logic;
    ttc_l1a_o          : out std_logic;
    ttc_l1a_l0id_o     : out std_logic_vector (7 downto 0);
    ttc_r3_o           : out std_logic;
    ttc_r3_l0id_o      : out std_logic_vector (7 downto 0);
    ttc_r3_roi_o       : out std_logic_vector (11 downto 0);
    ttc_r3_roi_valid_o : out std_logic;

    -- Infrastructure
    strobe40_i : in std_logic;
    clk        : in std_logic;
    rst        : in std_logic
    );

-- Declarations

end ttc_decode;

--
architecture rtl of ttc_decode is

  signal roi_id : std_logic_vector(11 downto 0);
  signal l0a    : std_logic;
  signal l0id   : std_logic_vector(7 downto 0);

  signal ttc_r3_roi       : std_logic_vector (11 downto 0);
  signal ttc_r3_roi_valid : std_logic;

  signal   l0a_prescale     : std_logic_vector(11 downto 0);
  constant L0A_PRESCALE_MAX : std_logic_vector(11 downto 0) := x"999";

  signal   bcount     : integer range 0 to 15;
  signal   bcount_clr : std_logic;
--signal bcount_inc : std_logic;
  constant BCOUNT_MAX : integer := 5;

  type states is (SendRoIs, Idle);
  signal state, nstate : states;


begin

  ttc_l1a_o      <= '0';
  ttc_l1a_l0id_o <= x"00";

  ttc_r3_o      <= l0a;
  ttc_r3_l0id_o <= l0id;


  -- State Machine
  ----------------------------------------------------------------
  prc_sm_sync : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        state <= Idle;

      else
        state <= nstate;

      end if;
    end if;
  end process;



  prc_sm_async : process (state, bcount, l0a)
  begin

    -- defaults
    bcount_clr       <= '0';
    ttc_l0a_o        <= '0';
    ttc_r3_roi       <= x"000";
    ttc_r3_roi_valid <= '0';

    case state is

      when Idle =>
        nstate     <= Idle;
        bcount_clr <= '1';
        if (l0a = '1') then
          nstate   <= SendRoIs;
        end if;


      when SendRoIs =>
        nstate <= SendRoIs;

        ttc_r3_roi       <= roi_id;
        ttc_r3_roi_valid <= '1';

        if (bcount = BCOUNT_MAX) then
          ttc_r3_roi_valid <= '0';
          nstate           <= Idle;
        end if;

    end case;
  end process;



  ttc_r3_roi_o       <= ttc_r3_roi       when rising_edge(clk);
  ttc_r3_roi_valid_o <= ttc_r3_roi_valid when rising_edge(clk);




  prc_byte_counter : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') or (bcount_clr = '1') then
        bcount <= 0;

      else
        if (bcount < 15) then
          bcount <= bcount + 1;

        end if;
      end if;
    end if;
  end process;





  prc_roi_id : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        roi_id <= x"001";
      else

        --if (roi_id = x"fff") then
        --  roi_id <= x"000";

        --else
          --roi_id <= roi_id + '1';
          roi_id <= roi_id(10 downto 0) & roi_id(11);

        --end if;
      end if;
    end if;
  end process;







  -- Sim Mode
  -- LFSR for fake RoI gen
  -- pipeline to hold 10 of them
  --
  -- option to vary number of RoIs per L0 ??



  prc_l0a_counters : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        l0a          <= '0';
        l0a_prescale <= (others => '0');
        l0id         <= x"ff";
      else
        -- default
        l0a          <= '0';

        if (l0a_prescale = L0A_PRESCALE_MAX) then
          l0a_prescale <= x"000";
          l0a          <= '1';
          if l0id = x"ff" then
            l0id       <= x"00";
          else
            l0id       <= l0id + '1';
          end if;

        else
          l0a_prescale <= l0a_prescale + '1';

        end if;
      end if;
    end if;
  end process;




end architecture rtl;

