--
-- ABC130 Deserialiser
--
-- Deserialises 160Mb HCC streams. HSIO still operates at 80MHz so
-- data arrives in on 2 streams and is then combined. Packet detection
-- operates on both "sides" of the stream.
-- 
--
-- Log:
-- 30/11/2012 - File born!


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library utils;
use utils.pkg_types.all;

library hsio;
use hsio.pkg_core_globals.all;

entity ro13_deser is
  generic(
    LINK_ID         :     integer := 0
    );
  port(
    -- In
    ser_i           : in  slv2;
    -- Pkt Out
    packet_o        : out std_logic_vector(63 downto 0);        --t_packet;
    pkt_valid_o     : out std_logic;
    pkt_rdack_i     : in  std_logic;
    --
    dropped_pkts_o  : out std_logic_vector(7 downto 0);
    capture_mode_i  : in  std_logic;
    capture_start_i : in  std_logic;
    capture_len_i   : in  std_logic_vector(9 downto 0);
    -- infra
    mode80_i        : in  std_logic;
    mode_abc_i        : in  std_logic;
    en              : in  std_logic;
    clk             : in  std_logic;
    rst             : in  std_logic
    );

-- Declarations

end ro13_deser;

--
architecture rtl of ro13_deser is

  signal ser_in : slv68;
  signal sdet : slv64_array(1 downto 0);

  signal hpktdet_true  : slv2;
  signal hpktdet_false : slv2;
  signal hpktdet       : slv2;
  signal apktdet_true  : slv2;
  signal apktdet_false : slv2;
  signal apktdet       : slv2;
  signal pktdet_true  : slv2;
  signal pktdet_false : slv2;
  signal pktdet       : slv2;

  signal pkt_valid : std_logic;
  signal pkt_we    : slv2;

  signal hpacket : slv64_array(1 downto 0);  --t_packet_array(1 downto 0);
  signal apacket : slv64_array(1 downto 0);  --t_packet_array(1 downto 0);
  signal packet : slv64_array(1 downto 0);  --t_packet_array(1 downto 0);

  signal bcount            : integer range 0 to 63;
  signal bcount_clr        : std_logic;
  signal bcount_max        : integer;
  signal bcount_max_minus1 : integer;
  signal bc_max_hcc        : integer;
  signal bc_max_m1_hcc : integer;
  signal bc_max_abc        : integer;
  signal bc_max_m1_abc : integer;

  signal dropped_pkts_count : slv8;
  signal dropped_pkts_inc   : sl;

  signal cap_count     : slv10;
  signal cap_count_max : slv10;
  signal cap_count_inc : sl;
  signal cap_count_clr : sl;


  -- G : gap (need to check this on final chip)
  -- S : start bit
  -- C : chipid
  -- T : type
  -- L : l1id
  -- B : bcid
  -- P : payload
  -- s : stop bit
  

  -- HCC Mode
  -------------------------------------------------------------------------------------------------
  --
  --                             "7777777766666666555555554444444433333333222222221111111100000000"
  --                             "SSHHHCCCCCTTTTLLLLLLLLBBBBBBBBPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPs"
  constant HDETMASK_T : slv64 := "1100000000000000000000000000000000000000000000000000000000000000";
  constant HDETBITS_T : slv64 := "1000000000000000000000000000000000000000000000000000000000000000";
  -- *** skipping non-zero chip id and type checking for now
--constant HDETMASK_F : slv64 := "0000001111111100000000000000000000000000000000000000000000000000";
--constant HDETBITS_F : slv64 := "0000000000000000000000000000000000000000000000000000000000000000";
  constant HDETMASK_F : slv64 := "0000000000000000000000000000000000000000000000000000000000000000";
  constant HDETBITS_F : slv64 := "1111111111111111111111111111111111111111111111111111111111111111";


  -- ABC130 Mode
  -------------------------------------------------------------------------------------------------
  --
  --                             "7777777766666666555555554444444433333333222222221111111100000000"
  --                             "00GSCCCCCTTTTLLLLLLLLBBBBBBBBPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPsG"
  constant ADETMASK_T : slv64 := "1111000000000000000000000000000000000000000000000000000000000001";
  constant ADETBITS_T : slv64 := "0001000000000000000000000000000000000000000000000000000000000000";
  -- *** skipping non-zero chip id and type checking for now
--constant ADETMASK_F : slv64 := "0000111111111000000000000000000000000000000000000000000000000000";
--constant ADETBITS_F : slv64 := "0000000000000000000000000000000000000000000000000000000000000000";
  constant ADETMASK_F : slv64 := "0000000000000000000000000000000000000000000000000000000000000000";
  constant ADETBITS_F : slv64 := "1111111111111111111111111111111111111111111111111111111111111111";

  constant OS : integer := 4;
  
  signal hpkt_dbg : slv64_array(1 downto 0);
  signal apkt_dbg : slv64_array(1 downto 0);
  signal pkt_dbg : slv64_array(1 downto 0);

  type states is ( Packet0, Packet1, Wait_Packet0, Wait_Packet1, Idle_Cap, Wait_End_Cap, Idle );

  signal state, nstate : states;


begin

  bc_max_hcc    <= 63 when (mode80_i = '1') else 31;
  bc_max_m1_hcc <= 62 when (mode80_i = '1') else 30;

  bc_max_abc    <= 59 when (mode80_i = '1') else 29;
  bc_max_m1_abc <= 58 when (mode80_i = '1') else 28;

  bcount_max        <= bc_max_hcc    when (mode_abc_i = '0') else bc_max_abc;
  bcount_max_minus1 <= bc_max_m1_hcc when (mode_abc_i = '0') else bc_max_m1_abc;


  prc_ser_in : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        ser_in     <= (others => '0');
      else
        if (en = '1') then
          if (mode80_i = '1') then
            ser_in <= ser_in(66 downto 0) & ser_i(0);

          else                          -- mode160
            ser_in <= ser_in(65 downto 0) & ser_i(0) & ser_i(1);
          end if;
        end if;
      end if;
    end if;
  end process;


  -- Packet detect and deserialise
  -------------------------------------------------------------------------

  -- Need to check odd and even 80Mb streams for 160Mb operation

  
  gen_pkt_ser_in : for n in 0 to 1 generate
  begin

    sdet(n) <= ser_in(64-n downto 1-n);

    -- Detect packet
    ----------------------------------------------------------
    hpktdet_true(n)  <= '1' when ((sdet(n) and HDETMASK_T) = HDETBITS_T)  else '0';
    hpktdet_false(n) <= '1' when ((sdet(n) and HDETMASK_F) /= HDETBITS_F) else '0';
    hpktdet(n)       <= (hpktdet_true(n) and hpktdet_false(n)) or capture_mode_i;

    apktdet_true(n)  <= '1' when ((sdet(n) and ADETMASK_T) = ADETBITS_T)  else '0';
    apktdet_false(n) <= '1' when ((sdet(n) and ADETMASK_F) /= ADETBITS_F) else '0';
    apktdet(n)       <= (apktdet_true(n) and apktdet_false(n)) or capture_mode_i;

    
  --  pktdet(n) <= hpktdet(n) when (mode_abc_i = '0') else apktdet(n);


    -- Build packet
    ----------------------------------------------------------

    hpkt_dbg(n)              <= ser_in(63+OS-n downto 0+OS-n);
    hpacket(n)(63 downto 62) <= conv_std_logic_vector(LINK_ID, 2);
    hpacket(n)(61 downto 0)  <= ser_in(61+OS-n downto 0+OS-n);

    apkt_dbg(n)              <= "0000" & ser_in(59+OS-n downto 0+OS-n);
    apacket(n)(63 downto 62) <= conv_std_logic_vector(LINK_ID, 2);
    apacket(n)(61 downto 0)  <= "00" & ser_in(59+OS-n downto 0+OS-n);

    
--    packet(n)  <= hpacket(n)  when (mode_abc_i = '0') else apacket(n);
--    dbg_pkt(n) <= hpkt_dbg(n) when (mode_abc_i = '0') else apkt_dbg(n);



-- packet(n)(63 downto 62) <= conv_std_logic_vector(LINK_ID, 2);  --  2 link-id
--     packet(n)(61 downto 59) <= ser_in(61+OS-n downto 59+OS-n);  --  3 hcchead
--     packet(n)(58 downto 54) <= ser_in(58+OS-n downto 56+OS-n);  --  5 chipid
--     packet(n)(53 downto 50) <= ser_in(53+OS-n downto 52+OS-n);  --  4 typ
--     packet(n)(49 downto 42) <= ser_in(49+OS-n downto 44+OS-n);  --  8 l0id
--     packet(n)(41 downto 34) <= ser_in(41+OS-n downto 35+OS-n);  --  8 bcid
--     packet(n)(33 downto 1)  <= ser_in(33+OS-n downto  1+OS-n);  -- 33 payload
--     packet(n)(0)            <= ser_in(                0+OS-n);  --  1 stop


  end generate;

  pktdet <= hpktdet when (mode_abc_i = '0') else apktdet;
  packet  <= hpacket  when (mode_abc_i = '0') else apacket;
  pkt_dbg <= hpkt_dbg when (mode_abc_i = '0') else apkt_dbg;

  
  ---------------------------------------------------------------
  -- Deser Machine
  ---------------------------------------------------------------

  prc_sm_deser_sync : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        state <= Idle;
      else
        state <= nstate;

      end if;
    end if;
  end process;


  prc_sm_deser_async : process (en, pktdet, bcount, bcount_max, bcount_max_minus1, mode80_i,
                                capture_mode_i, capture_start_i, cap_count, cap_count_max,
                                state)
  begin

    -- defaults
    bcount_clr    <= '0';
    pkt_we        <= "00";
    cap_count_clr <= '0';
    cap_count_inc <= '0';


    case state is

      when Idle =>
        nstate         <= Idle;
        bcount_clr     <= '1';
        if (capture_mode_i = '1') then
          nstate       <= Idle_Cap;
        else
          if (en = '1') then
            if (mode80_i = '0') then
              if (pktdet(0) = '1') then
                nstate <= Packet0;

              elsif (pktdet(1) = '1') then
                nstate <= Packet1;
              end if;
            else                        -- mode80_i = '0'
              if (pktdet(0) = '1') then
                nstate <= Packet1;      -- this 0=1 thing is to compensate for SR step=2
              end if;
            end if;
          end if;
        end if;


      when Packet0 =>
        pkt_we(0) <= '1';
        nstate    <= Wait_Packet0;


      when Packet1 =>
        pkt_we(1) <= '1';
        nstate    <= Wait_Packet1;


      when Wait_Packet0 =>
        nstate   <= Wait_Packet0;
        if (bcount = bcount_max_minus1) then
          nstate <= Idle;
        end if;

      when Wait_Packet1 =>
        nstate   <= Wait_Packet1;
        if (bcount = bcount_max) then
          nstate <= Idle;
        end if;

        


        -- Capture Mode
        ----------------------------------------------
      when Idle_Cap =>
        nstate        <= Idle_Cap;
        cap_count_clr <= '1';
        bcount_clr    <= '1';
        if (capture_mode_i = '0') then
          nstate      <= Idle;
        elsif (capture_start_i = '1') and (en = '1') then
          nstate      <= Wait_End_Cap;
        end if;


      when Wait_End_Cap =>
        nstate <= Wait_End_Cap;

        --if (bcount = bcount_max_minus1) then
        if (bcount = bcount_max) then
          pkt_we(0)     <= '1';
          cap_count_inc <= '1';

          if (cap_count = cap_count_max) then
            nstate <= Idle_Cap;
          end if;
        end if;


    end case;
  end process;





  -- Packet output interface
  -------------------------------------------------------------------------

  prc_packet_out : process(clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        packet_o  <= (others => '0');
        pkt_valid <= '0';

      else
        -- default
        dropped_pkts_inc <= '0';

        if (pkt_we(0) = '1') then
          packet_o <= packet(0);

        elsif (pkt_we(1) = '1') then
          packet_o <= packet(1);

        end if;

        if (pkt_we(0) = '1') or (pkt_we(1) = '1') then
          pkt_valid <= '1';

          --check if last one was read
          if (pkt_valid = '1') then
            dropped_pkts_inc <= '0';
          end if;


        elsif (pkt_rdack_i = '1') then
          pkt_valid <= '0';

        end if;


      end if;
    end if;

  end process;



  pkt_valid_o <= pkt_valid;


  -- Bit counter (2 bits per tick)
  -------------------------------------------------

  prc_bcount : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        bcount <= 0;

      elsif (bcount_clr = '1') or (bcount = bcount_max) then
        bcount <= 0;

      else
        bcount <= bcount + 1;

      end if;
    end if;
  end process;


  -- Dropped packet counter
  -----------------------------------------------------

  prc_dropped_pks_count : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        dropped_pkts_count <= (others => '0');

      elsif (dropped_pkts_count < x"ff") and (dropped_pkts_inc = '1') then
        dropped_pkts_count <= dropped_pkts_count + '1';

      end if;
    end if;
  end process;


  dropped_pkts_o <= dropped_pkts_count;


  -- Capture mode len counter
  -----------------------------------------------------

  cap_count_max <= capture_len_i;       -- byte val converted to 64b words

  prc_capture_count : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        cap_count <= (others => '0');

      else
        if (cap_count_clr = '1') then
          cap_count <= (others => '0');

        elsif (cap_count_inc = '1') then
          cap_count <= cap_count + '1';

        end if;

      end if;
    end if;
  end process;

end architecture rtl;

