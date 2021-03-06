-- VHDL Entity readout130.ro13_link.symbol
--
-- Created by Matt Warren 2014
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2013.1 (Build 6)
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library utils;
use utils.pkg_types.all;

library hsio;
use hsio.pkg_core_globals.all;

entity ro13_link is
   generic( 
      STREAM_ID : integer   := 0;
      HST_EN    : std_logic := '0';
      RAW_EN    : std_logic := '0'
   );
   port( 
      bcid_i          : in     std_logic_vector (11 downto 0) bus;
      capture_start_i : in     std_logic;
      clk             : in     std_logic;
      gen13data80_i   : in     slv2_array (1 downto 0);
      gen13data_i     : in     slv2_array (1 downto 0);
      l1id_i          : in     std_logic_vector (23 downto 0) bus;
      lld_i           : in     std_logic;
      -- registers
      reg             : in     t_reg_bus;
      -- stats
      req_stat_i      : in     std_logic;
      rst             : in     std_logic;
      s40             : in     std_logic;
      ser13data_i     : in     slv2;
      sim13data_i     : in     slv2_array (1 downto 0);
      strm_cmd_i      : in     std_logic_vector (15 downto 0);
      strm_reg_i      : in     std_logic_vector (15 downto 0);
      tick            : in     std_logic_vector (MAX_TICTOG downto 0);
      trig80_i        : in     std_logic;
      --ht_delta_max_i   : in  slv6;
      busy_o          : out    std_logic;
      --out
      lls_o           : out    t_llsrc
   );

-- Declarations

end ro13_link ;

-- VHDL from Block Diagram 
-- Generated by Mentor Graphics HDL Designer(TM) 2013.1 (Build 6) 
--
-- readout130.ro13_link.struct
--
-- Created by Matt Warren 2014
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
LIBRARY UNISIM;
USE UNISIM.VComponents.all;
library utils;
use utils.pkg_types.all;
library hsio;
use hsio.pkg_core_globals.all;


architecture struct of ro13_link is

   -- Architecture declarations

   -- Internal signal declarations
   signal HI               : std_logic;
   signal HIHI             : std_logic_vector(1 downto 0);
   signal HILO             : std_logic_vector(1 downto 0);
   signal LO               : std_logic;
   signal LOHI             : std_logic_vector(1 downto 0);
   signal LOLO             : std_logic_vector(1 downto 0);
   signal ZERO16           : std_logic_vector(15 downto 0);
   signal ZERO4            : std_logic_vector(3 downto 0);
   signal busy_en_delta    : std_logic;
   signal busy_en_fifo     : std_logic;
   signal capture_mode     : std_logic;
   signal data_count       : std_logic_vector(1 downto 0);
   signal deser_en         : std_logic;
   -- deser monitoring
   signal dropped_pkts     : std_logic_vector(7 downto 0);
   signal fifo_full        : std_logic;
   signal fifo_overflow    : std_logic;
   signal fifo_underflow   : std_logic;
   signal gendata_sel      : std_logic;
   signal histo_debug_mode : std_logic;
   signal histo_en         : std_logic;
   signal mode80           : std_logic;
   signal mode_abc         : std_logic;
   -- Pkt Out
   signal packet           : slv64;                            --t_packet;
   signal pkt_rdack        : std_logic;
   signal pkt_valid        : std_logic;
   signal r_lld            : std_logic_vector(3 downto 0);
   -- locallink tx interface
   signal r_lls            : t_llsrc_array(3 downto 0);
   signal reg_busy_delta   : std_logic_vector(15 downto 0);
   signal reg_len0         : std_logic_vector(15 downto 0);
   signal s40_n            : std_logic;
   -- In
   signal ser0             : slv2;
   signal strm_en          : std_logic;
   signal strm_histo_ro    : std_logic;
   signal strm_mode        : std_logic_vector(1 downto 0);
   signal strm_reset       : std_logic;
   signal strm_src         : std_logic_vector(2 downto 0);
   signal ts_count         : std_logic_vector(39 downto 0);


   -- Component Declarations
   component ll_automux
   generic (
      LEVELS : integer := 2
   );
   port (
      -- locallink interfaces
      --in
      lls_i : in     t_llsrc_array ((2**LEVELS)-1 downto 0);
      lld_o : out    std_logic_vector ((2**LEVELS)-1 downto 0);
      --out
      lls_o : out    t_llsrc ;
      lld_i : in     std_logic ;
      -- infrastructure
      rst   : in     std_logic ;
      clk   : in     std_logic 
   );
   end component;
   component lls_zero
   port (
      lls_o : out    t_llsrc 
   );
   end component;
   component ro13_deser
   generic (
      LINK_ID : integer := 0
   );
   port (
      -- In
      ser_i           : in     slv2 ;
      -- Pkt Out
      packet_o        : out    std_logic_vector (63 downto 0); --t_packet;
      pkt_valid_o     : out    std_logic ;
      pkt_rdack_i     : in     std_logic ;
      --
      dropped_pkts_o  : out    std_logic_vector (7 downto 0);
      capture_mode_i  : in     std_logic ;
      capture_start_i : in     std_logic ;
      capture_len_i   : in     std_logic_vector (9 downto 0);
      -- infra
      mode80_i        : in     std_logic ;
      mode_abc_i      : in     std_logic ;
      en              : in     std_logic ;
      clk             : in     std_logic ;
      rst             : in     std_logic 
   );
   end component;
   component ro13_mod_fifo
   generic (
      STREAM_ID : integer := 0;
      TS_HIRES  : integer := 0
   );
   port (
      l0id16_i       : in     std_logic_vector (15 downto 0);
      ts_count_i     : in     std_logic_vector (39 downto 0);
      ts_source_i    : in     std_logic_vector (3 downto 0);
      ts_always_i    : in     std_logic ;
      ts_disable_i   : in     std_logic ;
      timeout_tick_i : in     std_logic ;
      strm_src_i     : in     std_logic_vector (2 downto 0);
      capture_mode_i : in     std_logic ;
      -- input interface
      packet_i       : in     slv64 ;                       --t_packet;
      pkt_valid_i    : in     sl ;
      pkt_rdack_o    : out    sl ;
      -- locallink tx interface
      lls_o          : out    t_llsrc ;
      lld_i          : in     std_logic ;
      -- fifo status
      full_o         : out    std_logic ;
      --near_full_o    : out std_logic;
      overflow_o     : out    std_logic ;
      underflow_o    : out    std_logic ;
      data_count_o   : out    std_logic_vector (1 downto 0);
      -- infrastructure
      en             : in     std_logic ;
      s40            : in     std_logic ;
      clk            : in     std_logic ;
      rst            : in     std_logic 
   );
   end component;
   component ro13_mod_stat
   generic (
      STREAM_ID : integer := 0
   );
   port (
      -- locallink tx interface
      lls_o          : out    t_llsrc ;
      lld_i          : in     std_logic ;
      -- stats
      req_stat_i     : in     std_logic ;
      strm_reg_i     : in     slv16 ;
      trig80_i       : in     std_logic ;
      dropped_pkts_i : in     slv8 ;
      fifo_count_i   : in     slv2 ;
      busy_en_fifo_i : in     std_logic ;
      deser_en_i     : in     std_logic ;
      histo_en_i     : in     std_logic ;
      busy_o         : out    std_logic ;
      -- infrastructure
      clk            : in     std_logic ;
      rst            : in     std_logic 
   );
   end component;
   component src_mux
   port (
      sel_i  : in     slv3 ;
      ser0_i : in     slv2 ;
      ser1_i : in     slv2 ;
      ser2_i : in     slv2 ;
      ser3_i : in     slv2 ;
      ser4_i : in     slv2 ;
      ser5_i : in     slv2 ;
      ser6_i : in     slv2 ;
      ser7_i : in     slv2 ;
      ser_o  : out    slv2 
      -- infrastructure
      --rst         : in  std_logic;
      --clk         : in  std_logic
   );
   end component;
   component counter
   generic (
      BITS          : integer := 16;
      ROLLOVER_EN   : integer := 1;
      RST_IS_PRESET : integer := 0      -- reset is preset
   );
   port (
      inc_i          : in     std_logic ;
      clr_i          : in     std_logic ;
      pre_i          : in     std_logic ;
      count_o        : out    std_logic_vector ((BITS-1) downto 0);
      count_at_max_o : out    std_logic ;
      en_i           : in     std_logic ;
      rst            : in     std_logic ;
      clk            : in     std_logic 
   );
   end component;
   component m_power
   port (
      hi : out    std_logic ;
      lo : out    std_logic 
   );
   end component;


begin
   -- Architecture concurrent statements
   -- HDL Embedded Text Block 2 eb2
   -- eb2 2
   --tba histo_en <= strm_reg_i(0)
   mode_abc  <= strm_reg_i(9);
   mode80  <= strm_reg_i(8);
   busy_en_fifo  <= strm_reg_i(7);
   busy_en_delta <= strm_reg_i(6);
   strm_mode  <= strm_reg_i(5 downto 4);
   strm_src   <= strm_reg_i(3 downto 1);
   strm_en    <= strm_reg_i(0);
   
   deser_en <= '1' when ((strm_en = '1') and
                         (RAW_EN  = '1') and 
                         (strm_mode /= "11")) 
          else '0';
   
   histo_en <= '1' when ((strm_en = '1') and
                         (HST_EN = '1') and
                         (strm_mode = "11"))
          else '0';
   
   capture_mode <= '1' when (strm_mode = "01")
              else '0';
   
   gendata_sel <= '1' when (strm_src(2) = '1')
             else '0';
   
   -- Commands
   --------------------------------------
   strm_reset <= strm_cmd_i(15) or rst;
   strm_histo_ro <= strm_cmd_i(0);

   -- HDL Embedded Text Block 4 eb4
   -- eb3 3
   reg_len0 <= reg(R_LEN0);
   reg_busy_delta <= reg(R_BUSY_DELTA);
   histo_debug_mode <= reg(R_CONTROL)(CTL_HTEST_EN);

   -- HDL Embedded Text Block 5 eb5
   -- eb5 5
   HIHI <= "11";
   LOLO <= "00";
   HILO <= "10";
   LOHI <= "01";
   ZERO4 <= x"0";
   ZERO16 <= x"0000";


   -- Instance port mappings.
   Ullautomux : ll_automux
      generic map (
         LEVELS => 2
      )
      port map (
         lls_i => r_lls,
         lld_o => r_lld,
         lls_o => lls_o,
         lld_i => lld_i,
         rst   => strm_reset,
         clk   => clk
      );
   Ullsz3 : lls_zero
      port map (
         lls_o => r_lls(3)
      );
   Urustat : ro13_mod_stat
      generic map (
         STREAM_ID => STREAM_ID
      )
      port map (
         lls_o          => r_lls(1),
         lld_i          => r_lld(1),
         req_stat_i     => req_stat_i,
         strm_reg_i     => strm_reg_i,
         trig80_i       => trig80_i,
         dropped_pkts_i => dropped_pkts,
         fifo_count_i   => data_count,
         busy_en_fifo_i => busy_en_fifo,
         deser_en_i     => deser_en,
         histo_en_i     => histo_en,
         busy_o         => busy_o,
         clk            => clk,
         rst            => strm_reset
      );
   Umpower : m_power
      port map (
         hi => HI,
         lo => LO
      );

   g_histo: IF (HST_EN='1') GENERATE
      Ullsz0 : lls_zero
         port map (
            lls_o => r_lls(2)
         );
   end generate g_histo;

   g_nraw: IF (RAW_EN='0') GENERATE
      Ullsz1 : lls_zero
         port map (
            lls_o => r_lls(0)
         );
      -- HDL Embedded Text Block 1 eb1
      -- eb1 1
      dropped_pkts <= x"00";

   end generate g_nraw;

   g_nhisto: IF (HST_EN='0') GENERATE
      Ullsz2 : lls_zero
         port map (
            lls_o => r_lls(2)
         );
   end generate g_nhisto;

   g_raw: IF (RAW_EN='1') GENERATE
      Udeser0 : ro13_deser
         generic map (
            LINK_ID => 0
         )
         port map (
            ser_i           => ser0,
            packet_o        => packet,
            pkt_valid_o     => pkt_valid,
            pkt_rdack_i     => pkt_rdack,
            dropped_pkts_o  => dropped_pkts,
            capture_mode_i  => capture_mode,
            capture_start_i => capture_start_i,
            capture_len_i   => reg_len0(9 downto 0),
            mode80_i        => mode80,
            mode_abc_i      => mode_abc,
            en              => deser_en,
            clk             => clk,
            rst             => strm_reset
         );
      Usrcmux0 : src_mux
         port map (
            sel_i  => strm_src,
            ser0_i => ser13data_i,
            ser1_i => LOLO,
            ser2_i => gen13data80_i(0),
            ser3_i => gen13data80_i(1),
            ser4_i => gen13data_i(0),
            ser5_i => gen13data_i(1),
            ser6_i => sim13data_i(0),
            ser7_i => sim13data_i(1),
            ser_o  => ser0
         );
      Utimestamp : counter
         generic map (
            BITS          => 40,
            ROLLOVER_EN   => 1,
            RST_IS_PRESET => 0            -- reset is preset
         )
         port map (
            inc_i          => HI,
            clr_i          => LO,
            pre_i          => LO,
            count_o        => ts_count,
            count_at_max_o => open,
            en_i           => s40_n,
            rst            => LO,
            clk            => clk
         );

      -- ModuleWare code(v1.12) for instance 'U_0' of 'buff'
      s40_n <= s40;
      Ufifo : ro13_mod_fifo
         generic map (
            STREAM_ID => STREAM_ID,
            TS_HIRES  => 0
         )
         port map (
            l0id16_i       => ZERO16,
            ts_count_i     => ts_count,
            ts_source_i    => ZERO4,
            ts_always_i    => LO,
            ts_disable_i   => LO,
            timeout_tick_i => tick(T_800kHz),
            strm_src_i     => strm_src,
            capture_mode_i => capture_mode,
            packet_i       => packet,
            pkt_valid_i    => pkt_valid,
            pkt_rdack_o    => pkt_rdack,
            lls_o          => r_lls(0),
            lld_i          => r_lld(0),
            full_o         => fifo_full,
            overflow_o     => fifo_overflow,
            underflow_o    => fifo_underflow,
            data_count_o   => data_count,
            en             => deser_en,
            s40            => s40,
            clk            => clk,
            rst            => strm_reset
         );
   end generate g_raw;

end struct;
