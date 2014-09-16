--
-- Opcode Block ECHO
--
-- Echoes packet received
-- Now with added functions to watch for timeouts on an opcode and send back 
--

-- changelog
-- 2012-01-01 around when this was born
-- 2012-07-16 started to add opcode watchdog


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library utils;
use utils.pkg_types.all;

library hsio;
use hsio.pkg_core_globals.all;

library locallink;


entity ocb_echo_watchdog is
   port( 
      -- oc rx interface
      oc_valid_i  : in     std_logic;
      oc_data_i   : in     slv16;
      oc_dack_nio : inout  std_logic;
      -- locallink tx interface
      lls_o       : out    t_llsrc;
      lld_i       : in     std_logic;
      -- infrastructure
      tick_4hz_i  : in     std_logic;
      clk         : in     std_logic;
      rst         : in     std_logic
   );

-- Declarations

end ocb_echo_watchdog ;


architecture rtl of ocb_echo_watchdog is

  signal   watchdog_timer : slv2;
  constant WDTIMER_MAX    : slv2 := "11";
  signal   watchdog_clr   : std_logic;

  type states is (SrcRdy, SOF, WaitEOF,
                  BarkSrcRdy, BarkSOF,
                  WaitOCReady, Idle
                  );

  signal state, nstate : states;


begin


  -- State Machine
  --------------------------------------------------------
  prc_sync_part : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        state   <= WaitOCReady;
      else
        if (watchdog_timer = WDTIMER_MAX) then
          state <= BarkSrcRdy;
        else
          state <= nstate;
        end if;
      end if;
    end if;
  end process;



  prc_async_machine : process ( oc_valid_i, oc_dack_nio,
                                lld_i, oc_data_i,
                                state
                                )
  begin

    -- defaults
    nstate        <= Idle;
    oc_dack_nio    <= '1';
    lls_o.src_rdy <= '0';
    lls_o.sof     <= '0';
    lls_o.eof     <= '0';
    watchdog_clr  <= '1';
    lls_o.data    <= oc_data_i;



    case state is

      -------------------------------------------------------------------


      when WaitOCReady =>                      -- Make sure we get rising edge of oc_valid
        nstate       <= WaitOCReady;           -- If we wait too long for oc_valid to
        oc_dack_nio   <= 'Z';
        watchdog_clr <= not oc_dack_nio; -- drop, watchdog will handle OC
        if (oc_valid_i = '0') then
          nstate     <= Idle;
        end if;


      when Idle =>
        nstate     <= Idle;
        oc_dack_nio <= 'Z';
        if (oc_valid_i = '1') then
          if (oc_get_opcodepl(oc_data_i) = OC_ECHO) then
            nstate <= SrcRdy;
          else
            nstate <= WaitOCReady;
          end if;
        end if;


      when SrcRdy =>
        nstate        <= SrcRdy;
        lls_o.src_rdy <= '1';
        if (lld_i = '1') then
          nstate      <= SOF;
        end if;


      when SOF =>
        nstate        <= SOF;
        lls_o.src_rdy <= '1';
        lls_o.sof     <= '1';
        if (lld_i = '1') then
          oc_dack_nio  <= '0';
          nstate      <= WaitEOF;
        end if;


      when WaitEOF =>
        nstate        <= WaitEOF;
        lls_o.src_rdy <= '1';
        if (oc_valid_i = '0') then
          lls_o.eof   <= '1';
        end if;
        if (lld_i = '1') then
          oc_dack_nio  <= '0';
          if (oc_valid_i = '0') then
            nstate    <= Idle;
          end if;
        end if;

        ----------------------------------------------------------------
      when BarkSrcRdy =>
        nstate                   <= BarkSrcRdy;
        lls_o.src_rdy            <= '1';
        lls_o.data(15 downto 12) <= x"b";  -- just for neatness 
        if (lld_i = '1') then
          nstate                 <= BarkSOF;
        end if;


      when BarkSOF =>
        nstate                   <= BarkSOF;
        lls_o.src_rdy            <= '1';
        lls_o.sof                <= '1';
        lls_o.data(15 downto 12) <= x"b";
        if (lld_i = '1') then
          oc_dack_nio             <= '0';
          nstate                 <= WaitEOF;
        end if;


    end case;


  end process;



  -------------------------------------------------------------------------
  -- Watchdog Timer
  -------------------------------------------------------------------------

  prc_timeout_counter : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') or (watchdog_clr = '1') then
        watchdog_timer <= (others => '0');

      else
        if (tick_4Hz_i = '1') then
          watchdog_timer <= watchdog_timer + '1';

        end if;
      end if;
    end if;
  end process;


end architecture;


