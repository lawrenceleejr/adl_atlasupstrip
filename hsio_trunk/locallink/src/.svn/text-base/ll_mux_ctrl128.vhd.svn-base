--
-- Synchro LocalLink MUX Controller
--
-- Original author Barry Green
-- re-hsiod (not nessesarily for the better) by Matt Warren.
--
-- At some point we should start thinking about timeouts when waiting for EOFs
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library utils;
use utils.pkg_types.all;

library hsio;
use hsio.pkg_hsio_globals.all;

entity ll_mux_ctrl128 is
   port( 
      s_lls_i  : in  t_llsrc_array (127 downto 0);
      s_lldr_o  : out    std_logic_vector (127 downto 0);
      dst_rdy_i : in     std_logic;
      freeze_o  : out    std_logic;
      sel_o     : out    std_logic_vector (6 downto 0);
      rst       : in     std_logic;
      clk       : in     std_logic
   );

-- Declarations

end ll_mux_ctrl128 ;

--
architecture rtl of ll_mux_ctrl128 is

  type states is(
    WaitEOF,
    WaitState,
    Idle);
  signal state, nstate : states;

  signal scount          : std_logic_vector(7 downto 0);
  signal SCOUNT_MAX      : std_logic_vector(7 downto 0);
  signal selected_stream : integer range 127 downto 0;

  signal stream_inc : std_logic;
  signal sel_update : std_logic;

 
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
  prc_sm_async : process (state, s_lls_i, dst_rdy_i, selected_stream)
  begin

    -- defaults
    nstate     <= Idle;
    stream_inc <= '0';
    sel_update <= '0';
    s_lldr_o <= (others => '0');

    case state is
      
      when Idle =>
        nstate     <= Idle;
        stream_inc <= '1';
        if (s_lls_i(selected_stream).src_rdy = '1') then
          stream_inc <= '0';
          sel_update <= '1';
          nstate     <= WaitEOF;
        end if;

        
      when WaitEOF =>
        nstate <= WaitEOF;

        if (dst_rdy_i = '1') then
          s_lldr_o(selected_stream) <= '1';

          if (s_lls_i(selected_stream).eof = '1') then
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

  selected_stream <= conv_integer(scount(7 downto 1)) when (scount(0) = '0') else 127;

  prc_sel_out : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        sel_o <= (others => '0');

      else
        if (sel_update = '1') then
          sel_o <= conv_std_logic_vector(selected_stream, 7);

        end if;
      end if;
    end if;
  end process;

end architecture rtl;



