--
--
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library utils;
use utils.pkg_types.all;

entity ro13_datagen is
  generic(
    DOFFSET       :     std_logic_vector(15 downto 0) := x"0100"
    );
  port(
    mode_abc_i       : in  std_logic;
    start_i       : in  std_logic;
    abc130_data_o : out slv2;
    len_i         : in  std_logic_vector (11 downto 0);
    en            : in  std_logic;
    clk           : in  std_logic;
    rst           : in  std_logic
    );

-- Declarations

end ro13_datagen;

--
architecture rtl of ro13_datagen is


  signal data_count : slv8;
  signal bcount     : slv5;
  signal bcount_set : std_logic;
  signal bit_count  : slv3;


  constant BCOUNT_MAX : slv5 := "11111";

  signal up_down  : slv2;
  signal gen_done : std_logic;

  constant DELTA_STARTS_MAX : integer := 15;
  signal   delta_starts     : integer range 0 to DELTA_STARTS_MAX;

  signal hpkt   : slv64;
  signal apkt   : slv64;
  signal pkt   : slv64;
  signal pkt65 : slv65;

  signal dp      : slv64;
  signal dbg_pkt : slv64;

  signal dcount     : slv16;
  signal dcount_inc : std_logic;
  signal dcount_clr : std_logic;

  signal pcount     : integer range 0 to 255;
  signal pcount_max : integer range 0 to 255;
  signal pcount_inc : std_logic;
  signal pcount_clr : std_logic;

  signal in_packet      : sl;
  signal pkt_debug_mode : sl;



  type states is (SendData, Reset, Gap, Idle);

  signal state, nstate : states;

  signal ddr_step     : std_logic;
  signal tog_ddr_step : std_logic;
  signal abcdata0     : std_logic;
  signal abcdata1     : std_logic;


begin

  pcount_max <= conv_integer(len_i(7 downto 0));


  pkt_debug_mode <= '0';

  hpkt <= x"9160f161c162c163" when pkt_debug_mode = '1' else
          "10" &                        -- SS
--        dcount(13 downto 5) & '1'     -- *** Could check for non-zero type, but not yet
--        & dcount(3 downto 0) &        --   HHHCCCCCTTTTLL  KKHHHCCCCCTTTTLL   Typ must be non zero
          dcount(13 downto 0) &         --   HHHCCCCCTTTTLL  KKHHHCCCCCTTTTLL
          dcount(15 downto 0) &         -- LLLLLLBBBBBBBBPP  LLLLLLBBBBBBBBPP
          dcount(15 downto 0) &         -- PPPPPPPPPPPPPPPP  PPPPPPPPPPPPPPPP
          dcount(15 downto 0);          -- PPPPPPPPPPPPPPPs  PPPPPPPPPPPPPPPs


  apkt <= x"0963a162b161c160" when pkt_debug_mode = '1' else
          "00001" &                     -- 0000S
--        dcount(13 downto 5) & '1'     -- *** Could check for non-zero type, but not yet
--        & dcount(3 downto 0) &        --      CCCCCTTTTLL  KK000CCCCCTTTTLL   Typ must be non zero
          dcount(10 downto 0) &         --      CCCCCTTTTLL  KK000CCCCCTTTTLL
          dcount(15 downto 0) &         -- LLLLLLBBBBBBBBPP  LLLLLLBBBBBBBBPP
          dcount(15 downto 0) &         -- PPPPPPPPPPPPPPPP  PPPPPPPPPPPPPPPP
          dcount(15 downto 0);          -- PPPPPPPPPPPPPPPs  PPPPPPPPPPPPPPPs



  pkt   <= hpkt when (mode_abc_i = '0') else apkt;
  pkt65 <= '0' & pkt;

  abcdata0 <= pkt65(conv_integer(bcount)*2+1) when (ddr_step = '0') else
              pkt65(conv_integer(bcount)*2+2);

  abcdata1 <= pkt65(conv_integer(bcount)*2+0) when (ddr_step = '0') else
              pkt65(conv_integer(bcount)*2+1);


  abc130_data_o(0) <= abcdata0 and in_packet;
  abc130_data_o(1) <= abcdata1 and in_packet;


  prc_dbg_pkt : process(clk)
  begin
    if rising_edge(clk) then
      if (in_packet = '1') then

        case bcount(4 downto 3) is
          when "11" => dp(63 downto 48) <= pkt(63 downto 48);
          when "10" => dp(47 downto 32) <= pkt(47 downto 32);
          when "01" => dp(31 downto 16) <= pkt(31 downto 16);
          when "00" => dbg_pkt          <= dp(63 downto 16) & pkt(15 downto 0);

          when others => null;
        end case;
      end if;
    end if;
  end process;

  ------------------------------------------------------------------------

  prc_ddr_toggle : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') or (en = '0') then
        ddr_step <= '0';

      else
        if (tog_ddr_step = '1') then
          ddr_step <= not(ddr_step);
        end if;
      end if;
    end if;
  end process;



  ---------------------------------------------------------------------------
  -- Machine
  ---------------------------------------------------------------------------
  prc_sm_sync : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') or (en = '0') then
        state <= Reset;

      else
        state <= nstate;

      end if;
    end if;
  end process;


  prc_sm_async : process (state, delta_starts, bcount, bit_count, pcount, pcount_max )
  begin

-- defaults
    gen_done     <= '0';
    bcount_set   <= '0';
    dcount_clr   <= '0';
    dcount_inc   <= '0';
    pcount_clr   <= '0';
    pcount_inc   <= '0';
    in_packet    <= '0';
    tog_ddr_step <= '0';


    case state is

      when Reset =>
        dcount_clr <= '1';
        pcount_clr <= '1';
        nstate     <= Idle;

      when Idle =>
        nstate       <= Idle;
        bcount_set   <= '1';
        pcount_clr   <= '1';
        if (delta_starts > 0) then
          in_packet  <= '1';
          bcount_set <= '0';
          nstate     <= SendData;
        end if;


      when SendData =>
        nstate         <= SendData;
        in_packet      <= '1';
        if (bcount = 0) then
          dcount_inc   <= '1';
          if (pcount < pcount_max) then
            pcount_inc <= '1';
          else
            gen_done   <= '1';
            nstate     <= Gap;
          end if;
        elsif (bit_count = "000") then
          dcount_inc   <= '1';
        end if;

      when Gap =>
        nstate         <= Gap;
        if (bcount = 0) then
          tog_ddr_step <= '1';
          nstate       <= Idle;
        end if;

    end case;
  end process;


  -- bit/byte counter
  -------------------

  prc_bcount : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        bcount <= (others => '1');

      else
        if (bcount_set = '1') or (bcount = "00000") then
          bcount <= (others => '1');

        else
          bcount <= bcount - '1';

        end if;
      end if;
    end if;
  end process;

  bit_count <= bcount(2 downto 0);


  -- pkt counter
  -------------------

  prc_pcount : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        pcount <= 0;

      else
        if (pcount_clr = '1') then
          pcount <= 0;

        elsif (pcount_inc = '1') then
          pcount <= pcount + 1;

        end if;
      end if;
    end if;
  end process;


  -- data counter
  -------------------

  prc_dcount : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') or (en = '0') then
        dcount <= DOFFSET;

      else
        if (dcount_inc = '1') then
          dcount <= dcount + '1';

        end if;
      end if;
    end if;
  end process;




  -- pkts to send counter
  ---------------------------------------------------------------

  up_down <= start_i & gen_done;

  prc_start_counter : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') or (en = '0') then
        delta_starts <= 0;

      else

        if (up_down = "01") and (delta_starts > 0) then
          delta_starts <= delta_starts - 1;

        elsif (up_down = "10") and (delta_starts < DELTA_STARTS_MAX) then
          delta_starts <= delta_starts + 1;

        end if;
      end if;
    end if;
  end process;



end architecture rtl;
