--
-- Trigger Data aggregate and send to FIFO
--
--
-- Log:
-- 19/06/2014 - File born!


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library utils;
use utils.pkg_types.all;
library hsio;
use hsio.pkg_core_globals.all;

entity trig_dataenc is
  --generic(
  --  LINK_ID    :    integer := 0
  --  );
  port(
    trig_i     : in  std_logic;
    l0id16_i   : in  std_logic_vector(15 downto 0);
    trig_bus_i : in  std_logic_vector(15 downto 0);
    trig_src_o : out std_logic_vector(3 downto 0);

    trid_i     : in std_logic_vector(15 downto 0);
    trid_new_i : in std_logic;

    tdc_code_i : in std_logic_vector(19 downto 0);
    tdc_new_i  : in std_logic;
    tdc_calmode_i : in std_logic;
    tdc_caldel_i : in std_logic_vector(15 downto 0);

    -- Pkt Out
    packet_o    : out std_logic_vector(63 downto 0);  --t_packet;
    pkt_valid_o : out std_logic;
    pkt_rdack_i : in  std_logic;
    -- infra
    en          : in  std_logic;
    clk         : in  std_logic;
    rst         : in  std_logic
    );

-- Declarations

end trig_dataenc;

--
architecture rtl of trig_dataenc is

  signal tdc_block : std_logic_vector(63 downto 0);
  signal tlu_block : std_logic_vector(63 downto 0);
  signal packet    : std_logic_vector(63 downto 0);
  signal pkt_valid : std_logic;

  signal trig_src : std_logic_vector(3 downto 0);
  signal trig_bus_lch : std_logic_vector(15 downto 0);
  signal trig_bus_lch_clr : std_logic;

  --signal trig_seen  : std_logic;
  --signal trig_seen_clr  : std_logic;

  signal trid_seen     : std_logic;
  signal trid_seen_clr : std_logic;

  signal tdc_seen     : std_logic;
  signal tdc_seen_clr : std_logic;
  signal tdc_caldel : std_logic_vector(15 downto 0);



  type states is (
    SendTLU, SendTDC, Done,
    Idle
    );

  signal state, nstate : states;

begin

  with trig_bus_lch select trig_src <=
    x"8" when x"0080",
    x"7" when x"0040",
    x"6" when x"0020",
    x"5" when x"0010",
    x"4" when x"0008",
    x"3" when x"0004",
    x"2" when x"0002",
    x"1" when x"0001",
    x"0" when others;

  trig_src_o <= trig_src;

  tdc_caldel <= tdc_caldel_i when (tdc_calmode_i = '1') else x"0000";


  tlu_block <= x"d" &                   --  4
               trig_src &               --  4
               l0id16_i &               -- 16
               x"000000" &              -- 24
               trid_i;                  -- 16

  tdc_block <= x"e" &                   --  4
               trig_src &               --  4
               l0id16_i &               -- 16
               tdc_caldel &             -- 16
               x"0" &                   -- 4
               tdc_code_i;              -- 20

-- ts_block <= x"f" &                   --  4
--             trig_src &               --  4
--             l0id16_i &               -- 16
--             ts_count;                -- 40



  prc_stores : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        trig_bus_lch  <= (others => '0');
        --trig_seen   <= '0';
        tdc_seen  <= '0';
        trid_seen <= '0';


      else
        -- "latch" the trigger source
        if (trig_bus_lch_clr = '1') then 
          trig_bus_lch <= (others => '0');
        else
          trig_bus_lch <= trig_bus_lch or trig_bus_i;
        end if;

        -- Trigger
        --if (trig_seen_clr = '1') then
        --  trig_seen <= '0';
        --elsif (trig_i = '1') then
        --  trig_seen <= '1';
        --end if;

        -- TDC
        if (tdc_seen_clr = '1') then
          tdc_seen <= '0';
        elsif (tdc_new_i = '1') then
          tdc_seen <= '1';
        end if;

        -- TRID
        if (trid_seen_clr = '1') then
          trid_seen <= '0';
        elsif (trid_new_i = '1') then
          trid_seen <= '1';
        end if;

      end if;
    end if;
  end process;



  ---------------------------------------------------------------------
  ---------------------------------------------------------------------

  prc_sm_sync : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') or (en = '0') then
        state <= Idle;
      else
        state <= nstate;

      end if;
    end if;
  end process;


  prc_sm_async : process (state, tdc_seen, trid_seen, pkt_rdack_i )
  begin

    -- defaults
    packet        <= (others => '0');
    pkt_valid     <= '0';
    tdc_seen_clr  <= '0';
    trid_seen_clr <= '0';


    case state is

      when Idle =>
        nstate   <= Idle;
        --if (trig_seen_i = '1') then
        --   nstate <=
        --els
        if (tdc_seen = '1') then
          nstate <= SendTDC;
        elsif (trid_seen = '1') then
          nstate <= SendTLU;
        end if;


      when SendTDC =>
        nstate         <= SendTDC;
        packet         <= tdc_block;
        pkt_valid      <= '1';
        if (pkt_rdack_i = '1') then
          pkt_valid       <= '0';
          tdc_seen_clr <= '1';
          nstate       <= Done;
        end if;


      when SendTLU =>
        nstate          <= SendTLU;
        packet          <= tlu_block;
        pkt_valid       <= '1';
        if (pkt_rdack_i = '1') then
          pkt_valid       <= '0';
          trid_seen_clr <= '1';
          nstate        <= Done;
        end if;

        ------------------------------------------------------


      when Done =>
        if (tdc_seen = '1') then
          nstate <= SendTDC;
        elsif (trid_seen = '1') then
          nstate <= SendTLU;
        else
          trig_bus_lch_clr <= '1';
          nstate <= Idle;
        end if;
        


        

    end case;
  end process;


  packet_o    <= packet    when rising_edge(clk);
  pkt_valid_o <= pkt_valid when rising_edge(clk);


end architecture rtl;

