--
-- Synchro LocalLink MUX Controller
--
-- Original author Barry Green
-- re-worked (not nessesarily for the better) by Matt Warren.
--
-- At some point we should start thinking about timeouts when waiting for EOFs
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library utils;
use utils.pkg_types.all;

entity ll_mux_ctrl is
  generic(
    NLEVELS   :     integer := 4        -- number of levels of data, not muxs
    );
  port(
    src_rdy_i : in  std_logic_vector (2**NLEVELS-1 downto 0);
    --src_rdy_o : out std_logic;        -- *** tst
    eof_i     : in  std_logic_vector (2**NLEVELS-1 downto 0);
    dst_rdy_o : out std_logic_vector (2**NLEVELS-1 downto 0);
    dst_rdy_i : in  std_logic;
    freeze_o  : out std_logic;
    sel_o     : out std_logic_vector (NLEVELS-1 downto 0);
    rst       : in  std_logic;
    clk       : in  std_logic
    );

-- Declarations

end ll_mux_ctrl;

--
architecture rtl of ll_mux_ctrl is
  constant NPORTS : integer := (2**NLEVELS);

  type states is(
    WaitEOF,
    WaitState,
    Idle);
  signal state, nstate : states;

  signal scount          : std_logic_vector(NLEVELS downto 0);
  signal SCOUNT_MAX      : std_logic_vector(NLEVELS downto 0);
  signal selected_stream : integer range (NPORTS-1) downto 0;

  signal stream_inc      : std_logic;
  signal sel_update :    std_logic;


begin

  freeze_o <= not(dst_rdy_i);

  -- SM Clocked
  -------------------------------------------------------
  prc_sm_clocked : process(clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        state <= Idle;
      else
        state <= nstate;
      end if;
    end if;
  end process;


  -- SM Async
  -------------------------------------------------------
  prc_sm_async : process(state, src_rdy_i, eof_i, dst_rdy_i, selected_stream)
  begin

    -- defaults
    nstate     <= Idle;
    stream_inc <= '0';
    sel_update <= '0';

    dst_rdy_o <= (others => '0');

    case state is
      
      when Idle =>
        nstate       <= Idle;
        stream_inc   <= '1';
        if (src_rdy_i(selected_stream) = '1') then
          stream_inc <= '0';
          sel_update <= '1';
          nstate     <= WaitEOF;
        end if;

        
      when WaitEOF =>
        nstate <= WaitEOF;

        if (dst_rdy_i = '1') then
          dst_rdy_o(selected_stream) <= '1';

          if (eof_i(selected_stream) = '1') then
            --nstate <= Idle;
            nstate <= WaitState;
          end if;
        end if;

       when WaitState =>
         nstate <= Idle;

    end case;

  end process;


  -- Port select counter
  -- The ordering could be more complicated with priority ports etc


  SCOUNT_MAX <= (others => '1');

  prc_port_sel_counter : process(clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        scount <= (others => '0');

      else
        if (stream_inc = '1') then
          if (scount = (SCOUNT_MAX-1)) then  -- don't need to double count Ack
            scount <= (others => '0');
          else
            scount <= scount + '1';
          end if;

        end if;
      end if;
    end if;
  end process;

  selected_stream <= conv_integer(scount(NLEVELS downto 1)) when (scount(0) = '0') else (NPORTS-1);

  prc_sel_out : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        sel_o <= (others => '0');

      else
        if (sel_update = '1') then
          sel_o <= conv_std_logic_vector(selected_stream, NLEVELS);

        end if;
      end if;
    end if;
  end process;

end architecture rtl;



