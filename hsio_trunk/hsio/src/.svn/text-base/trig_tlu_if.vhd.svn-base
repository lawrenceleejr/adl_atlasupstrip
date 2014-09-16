--
-- TLU Intefrace
--
-- Matt Warren 2014
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity trig_tlu_if is
-- generic(
-- SIM_MODE : integer := 0
-- );
  port(
    trig_tlu_o      : out std_logic;
    tlu_trig_sync_i : in  std_logic;    -- syncronised, but not l2p
    busy_i          : in  std_logic;
    tlu_busy_o      : out std_logic;
    tlu_tclk_o      : out std_logic;
    tick_tclk_i     : in  std_logic;
    tog_tclk_i      : in  std_logic;
    trid_tlu_o      : out std_logic_vector(15 downto 0);
    trid_valid_o    : out std_logic;
    trid_new_o      : out std_logic;
    debug_mode_i    : in  std_logic;
    debug_trig_i    : in  std_logic;
    l0id16_i        : in  std_logic_vector(15 downto 0);
    s40             : in  std_logic;
    en              : in  std_logic;
    clk             : in  std_logic;
    rst             : in  std_logic
    );

-- Declarations

end trig_tlu_if;

--
architecture rtl of trig_tlu_if is

  signal bcount    : integer range 0 to 15;
  signal bcount_en : std_logic;

  signal trid       : std_logic_vector(14 downto 0);
  signal trid_shift : std_logic;
  signal trid_valid : std_logic;
  signal trid_new   : std_logic;

  signal tlu_busy0 : std_logic;
  signal trig_tlu0 : std_logic;

  signal trig_in : std_logic;

  type states is ( TrigOut0, TrigOut1,
                   WaitTrigLo, WaitTick0, WaitTick1,  --WaitTog0,
                   GetTrID, LastTClk,   --ReqTrID, StoreTrID,
                   Start, Idle
                   );

  signal state, nstate : states;

begin

  trig_in <= tlu_trig_sync_i when (debug_mode_i = '0') else
             debug_trig_i;


  tlu_busy_o <= tlu_busy0 or busy_i;

  trid_valid_o <= trid_valid when rising_edge(clk);
  trid_new_o   <= trid_new   when rising_edge(clk);

  trig_tlu_o <= (trig_tlu0 and not(debug_mode_i)) when rising_edge(clk);


  -- State Machine
  --------------------------------------------------------
  prc_sync_part : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') or (en = '0') then
        state <= Start;
      else
        state <= nstate;

      end if;
    end if;
  end process;


  prc_async_machine : process (trig_in, tick_tclk_i, tog_tclk_i, bcount,
                               s40, state
                               )
  begin

    -- defaults
    tlu_busy0  <= '1';
    tlu_tclk_o <= '0';
    bcount_en  <= '0';
    trid_shift <= '0';
    trid_valid <= '0';
    trid_new   <= '0';
    trig_tlu0  <= '0';



    case state is

      -------------------------------------------------------------

      when Start =>
        nstate      <= Start;
        tlu_busy0   <= '0';
        tlu_tclk_o  <= '0';
        if (trig_in = '1') and (s40 = '1') then
          nstate    <= TrigOut0;
        end if;


      when TrigOut0 =>
        trig_tlu0 <= '1';
        nstate    <= TrigOut1;

      when TrigOut1 =>
        trig_tlu0 <= '1' after 1 ns;
        nstate    <= WaitTrigLo;


      when WaitTrigLo =>                -- Assert Busy
        nstate     <= WaitTrigLo;
        tlu_tclk_o <= '0';
        if (trig_in = '0') then
          nstate   <= WaitTick0;
        end if;


      when WaitTick0 =>
        nstate     <= WaitTick0;
        tlu_tclk_o <= '0';
        if (tick_tclk_i = '1') then
          nstate   <= WaitTick1;
        end if;


      when WaitTick1 =>
        nstate     <= WaitTick1;
        tlu_tclk_o <= '0';
        if (tick_tclk_i = '1') then
          nstate   <= GetTrID;
        end if;


      when GetTrID =>
        nstate     <= GetTrID;
        bcount_en  <= '1';
        tlu_tclk_o <= tog_tclk_i;
        if (bcount = 15) then
          nstate   <= LastTClk;
        end if;


      when LastTClk =>
        nstate     <= LastTClk;
        tlu_tclk_o <= tog_tclk_i;
        trid_valid <= '1';
        if (tick_tclk_i = '1') then
          trid_new <= '1';
          nstate   <= Idle;
        end if;


      when Idle =>
        nstate     <= Idle;
        tlu_busy0  <= '0';
        tlu_tclk_o <= '0';
        trid_valid <= '1';
        if (trig_in = '1')  and (s40 = '1') then
          nstate   <= TrigOut0;
        end if;


    end case;
  end process;


  ----------------------------------------------------------------------

  prc_bcount : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        bcount <= 0;

        trid <= "001" & x"234";         -- good for debug mode
        --trid   <= (others => '0');

      else

        if (bcount_en = '0') then
          bcount <= 0;

        elsif (tick_tclk_i = '1') then
          bcount <= bcount + 1;
          trid   <= tlu_trig_sync_i & trid(14 downto 1);

        end if;
      end if;
    end if;
  end process;


  trid_tlu_o <= ('0' & trid) when (debug_mode_i = '0') else
                l0id16_i;


end architecture rtl;

