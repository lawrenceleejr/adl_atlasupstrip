--
-- Multi channel IDELAY delay set
--
-- Matt Warren 2011
--
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library utils;
use utils.pkg_types.all;

library hsio;
use hsio.pkg_core_globals.all;
  

entity idelay_prog is
   port( 
      databus_i     : in     std_logic_vector (15 downto 0);
      rwr_idelay_i  : in     std_logic;
      idelay_ctl_o : out    t_idelay_ctl;
      rst           : in     std_logic;
      clk           : in     std_logic
   );

-- Declarations

end idelay_prog ;

--
architecture rtl of idelay_prog is

  signal selected_hs : integer range 0 to 71;
  signal address     : std_logic_vector(6 downto 0);
  signal counter     : std_logic_vector(5 downto 0);
  signal count_en    : std_logic;

  signal ce   : std_logic_vector(71 downto 0);
  signal zero : std_logic_vector(71 downto 0);

  signal strm_swap    : std_logic_vector (71 downto 0);
  signal strm_loop    : std_logic_vector (71 downto 0);

  type states is (Idle, ZeroDelay, ZeroDelayWS,
                  WaitState, IncDelay, CheckCounter);

  signal state, nstate : states;


begin


  idelay_ctl_o.ce   <= ce(71 downto 0);
  idelay_ctl_o.zero <= zero(71 downto 0);
  idelay_ctl_o.inc  <= '1';                 -- we inc only!
  idelay_ctl_o.strm_swap  <= strm_swap(71 downto 0);

  selected_hs <= conv_integer(address);

  prc_store : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        counter    <= (others => '0');
        address    <= (others => '0');
        strm_swap <= (others => '0');
        strm_loop <= (others => '0');

      else
        if (rwr_idelay_i = '1') then
          counter <= databus_i(5 downto 0);
          address <= databus_i(14 downto 8);

          strm_swap (conv_integer(databus_i(14 downto 8))) <= databus_i(6);
          strm_loop (conv_integer(databus_i(14 downto 8))) <= databus_i(7);

        else
          if (count_en = '1') then
            counter <= counter - '1';
          end if;
        end if;
      end if;
    end if;
  end process;


  -- State Machine
  --------------------------------------------------------

  prc_sm_clocked : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        state <= Idle;
      else
        state <= nstate;
      end if;
    end if;
  end process;



  prc_sm_async : process (state, rwr_idelay_i, counter, selected_hs)
  begin

    --defaults
    nstate   <= Idle;
    ce       <= (others => '0');
    zero     <= (others => '0');
    count_en <= '0';

    case state is


      when Idle =>
        if (rwr_idelay_i = '1') then
          nstate <= ZeroDelayWS;
        else
          nstate <= Idle;
        end if;


      when ZeroDelayWS =>
        nstate <= ZeroDelay;


      when ZeroDelay =>
        zero(selected_hs) <= '1';
        nstate            <= WaitState;


      when WaitState =>
        nstate <= CheckCounter;


      when CheckCounter =>
        if (counter = "000000") then
          nstate <= Idle;
        else
          nstate <= IncDelay;
        end if;


      when IncDelay =>
        count_en        <= '1';
        ce(selected_hs) <= '1';
        nstate          <= CheckCounter;


    end case;

  end process;


end architecture rtl;

