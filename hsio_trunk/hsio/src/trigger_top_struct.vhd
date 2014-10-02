-- VHDL Entity hsio.trigger_top.symbol
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

entity trigger_top is
   generic( 
      TLU_EN : integer := 1;
      TDC_EN : integer := 1
   );
   port( 
      busy_i            : in     std_logic;
      clk               : in     std_logic;
      clk160ps          : in     std_logic;
      clk40             : in     std_logic;
      command           : in     std_logic_vector (15 downto 0);
      lemo_bcr_i        : in     std_logic;
      lemo_ecr_i        : in     std_logic;
      lemo_trig_i       : in     std_logic;
      lld_i             : in     std_logic;
      ocraw_start_i     : in     std_logic;
      rawsigs_i         : in     std_logic_vector (15 downto 0);
      -- registers
      reg               : in     t_reg_bus;
      rst               : in     std_logic;
      s40               : in     std_logic;
      tick              : in     std_logic_vector (34 downto 0);
      tlu_trig_i        : in     std_logic;
      tog               : in     std_logic_vector (34 downto 0);
      twin_open_i       : in     std_logic;
      bcid_l1a_o        : out    std_logic_vector (11 downto 0);
      bcid_o            : out    std_logic_vector (11 downto 0);
      bcr_all_o         : out    std_logic;
      busy_all_o        : out    std_logic;
      busy_ext_o        : out    std_logic;
      dbg_trig_ext_o    : out    std_logic;
      ecr_all_o         : out    std_logic;
      l0id_l1_o         : out    std_logic_vector (7 downto 0);
      l0id_o            : out    std_logic_vector (31 downto 0);
      -- locallink tx interface
      lls_o             : out    t_llsrc;
      outsigs_o         : out    std_logic_vector (15 downto 0);
      pretrig_o         : out    std_logic;
      tb_bcount_o       : out    std_logic_vector (15 downto 0);
      tb_flags_o        : out    std_logic_vector (7 downto 0);
      tb_tcount_o       : out    std_logic_vector (15 downto 0);
      tdc_calib_edge0_o : out    std_logic;
      tdc_code_o        : out    std_logic_vector (19 downto 0);
      tdc_counter1_o    : out    std_logic_vector (31 downto 0);
      tdc_counter2_o    : out    std_logic_vector (31 downto 0);
      tlu_busy_o        : out    std_logic;
      tlu_tclk_o        : out    std_logic;
      trg_all_mask_o    : out    std_logic_vector (15 downto 0);
      trig40_o          : out    std_logic;
      trig80_o          : out    std_logic;
      trig_out_o        : out    std_logic
   );

-- Declarations

end trigger_top ;

-- VHDL from Block Diagram 
-- Generated by Mentor Graphics HDL Designer(TM) 2013.1 (Build 6) 
--
-- hsio.trigger_top.struct
--
-- Created by Matt Warren 2014
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library utils;
use utils.pkg_types.all;

library hsio;
use hsio.pkg_core_globals.all;


architecture struct of trigger_top is

   -- Architecture declarations

   -- Internal signal declarations
   signal HI               : std_logic;
   signal LO               : std_logic;
   signal ZERO13           : std_logic_vector(12 downto 0);
   signal ZERO16           : std_logic_vector(15 downto 0);
   signal ZERO2            : std_logic_vector(1 downto 0);
   signal ZERO3            : std_logic_vector(2 downto 0);
   signal ZERO4            : std_logic_vector(3 downto 0);
   signal ZERO8            : std_logic_vector(7 downto 0);
   signal atrig            : std_logic;
   signal bcid             : std_logic_vector(11 downto 0);
   signal bcr_all          : std_logic;
   signal bcr_cmd          : std_logic;
   signal bcr_dec          : std_logic;
   signal bcr_ecb          : std_logic;
   signal bcr_ext          : std_logic;
   signal bcr_genc         : std_logic;
   signal busy             : std_logic;
   signal com_all          : std_logic;
   signal com_genc         : std_logic;
   signal din1             : std_logic;
   signal ecr_all          : std_logic;
   signal ecr_cmd          : std_logic;
   signal ecr_dec          : std_logic;
   signal ecr_ecb          : std_logic;
   signal ecr_ext          : std_logic;
   signal ecr_genc         : std_logic;
   signal l0id             : std_logic_vector(31 downto 0);
   signal l1_auto          : std_logic;
   signal lemo_atrig       : std_logic;
   signal lemo_trig0       : std_logic;
   signal ocraw_start40    : std_logic;
   signal pretrig          : std_logic;
   signal pretrig_ecb      : std_logic;
   signal reg_control      : std_logic_vector(15 downto 0);
   signal reg_control1     : std_logic_vector(15 downto 0);
   signal reg_int_ena      : std_logic_vector(15 downto 0);
   signal reg_out_ena      : std_logic_vector(15 downto 0);
   signal reg_outsigs      : std_logic_vector(15 downto 0);
   signal s40_n            : std_logic;
   signal tb_testflag      : std_logic;
   signal tcd_counter2     : std_logic_vector(31 downto 0);
   signal td_packet        : std_logic_vector(63 downto 0);
   signal td_pkt_rdack     : std_logic;
   signal td_pkt_valid     : std_logic;
   signal tdc_calib_edge0  : std_logic;
   signal tdc_code         : std_logic_vector(19 downto 0);
   signal tdc_counter1     : std_logic_vector(31 downto 0);
   signal tdc_edge0        : std_logic;
   signal tdc_new          : std_logic;
   signal tdc_start        : std_logic;
   signal tdc_tlu_start    : std_logic;
   signal tdc_valid        : std_logic;
   signal tlu_atrig        : std_logic;
   signal tlu_debug_trig_i : std_logic;
   signal tlu_trig_sync    : std_logic;
   signal trid_new         : std_logic;
   signal trid_tlu         : std_logic_vector(15 downto 0);
   signal trid_valid       : std_logic;
   signal trig40           : std_logic;
   signal trig80           : std_logic;
   signal trig_burster     : std_logic;
   signal trig_bus         : std_logic_vector(15 downto 0);
   signal trig_cmd         : std_logic;
   signal trig_cmd0        : std_logic;
   signal trig_ecb         : std_logic;
   signal trig_ext         : std_logic;
   signal trig_ext0        : std_logic;
   signal trig_src         : std_logic_vector(3 downto 0);
   signal trig_tlu         : std_logic;
   signal trigdat_en       : std_logic;
   signal ts_count         : std_logic_vector(39 downto 0);


   -- ModuleWare signal declarations(v1.12) for instance 'Ubcid_l1a' of 'adff'
   signal mw_Ubcid_l1areg_cval : std_logic_vector(11 downto 0);

   -- Component Declarations
   component com_decoder
   port (
      com_i       : in     std_logic ;
      -- ABC130
      a13_fcfr_o  : out    std_logic ;
      a13_sysr_o  : out    std_logic ;
      a13_bcr_o   : out    std_logic ;
      a13_ecr_o   : out    std_logic ;
      a13_softr_o : out    std_logic ;
      -- Infra
      strobe40_i  : in     std_logic ;
      rst         : in     std_logic ;
      clk         : in     std_logic 
   );
   end component;
   component l1_autogen
   port (
      clk         : in     std_logic;
      ecr_i       : in     std_logic;
      en_i        : in     std_logic;
      l0_i        : in     std_logic;
      l0id_i      : in     std_logic_vector (31 downto 0);
      rst         : in     std_logic;
      strobe40_i  : in     std_logic;
      l0id_send_o : out    std_logic_vector (7 downto 0);
      l1_o        : out    std_logic
   );
   end component;
   component outsigs_enc_map
   port (
      invert_mux_i   : in     std_logic ;
      reg_outsigs_i  : in     std_logic_vector (15 downto 0);
      rawsigs_i      : in     std_logic_vector (15 downto 0);
      --l1r_i          : in  std_logic;
      l1_auto_i      : in     std_logic ;
      l0_ecb_i       : in     std_logic ;
      com_genc_i     : in     std_logic ;
      trg80_all_o    : out    std_logic ;
      trg_all_o      : out    std_logic ;
      trg_all_mask_o : out    std_logic_vector (15 downto 0);
      outsigs_o      : out    std_logic_vector (15 downto 0);
      strobe40       : in     std_logic ;
      rst            : in     std_logic ;
      clk            : in     std_logic 
   );
   end component;
   component slac_tdc
   port (
      edge0     : in     std_logic;
      edge1     : in     std_logic;
      start     : in     std_logic;
      sysclk    : in     std_logic;
      sysrst    : in     std_logic;
      counter1  : out    std_logic_vector (31 downto 0);
      counter2  : out    std_logic_vector (31 downto 0);
      newdata_o : out    std_logic;
      valid_o   : out    std_logic
   );
   end component;
   component slac_tdc_calib
   port (
      delayq_i : in     std_logic_vector (1 downto 0);
      edge0_o  : out    std_logic ;
      clk160ps : in     std_logic ;
      s40      : in     std_logic ;
      rst      : in     std_logic 
   );
   end component;
   component slac_tdc_encode
   port (
      clk        : in     std_logic;
      counter1_i : in     std_logic_vector (31 downto 0);
      counter2_i : in     std_logic_vector (31 downto 0);
      rst        : in     std_logic;
      code_o     : out    std_logic_vector (19 downto 0)
   );
   end component;
   component trig_burst
   generic (
      rptLen   : integer := 16;      -- bit length of trigger reitition counter
      rpt2Len  : integer := 16;      -- bit length of supercycle repitition counter
      waitLen  : integer := 20;      -- bit length of repeat cycle countdown timer
      wait2Len : integer := 20;      -- bit length of supercycle countdown timer (VHDL integers have max. value 2**31-1)
      sqLenExp : integer := 3        -- exponent for bit length (2**sqLenExp) of trigger bit-sequence register
   );
   port (
      --clock         : in  std_logic;    -- global 40 MHz clock
      clock          : in     std_logic ;                            -- global 80 MHz clock
      strobe40_i     : in     std_logic ;                            -- 40MHz clock strobe - for 80MHz sync
      reset          : in     std_logic ;                            -- global reset
      trigs_count_o  : out    std_logic_vector (15 downto 0);
      bursts_count_o : out    std_logic_vector (15 downto 0);
      ready_o        : out    std_logic ;
      running_o      : out    std_logic ;
      finished_o     : out    std_logic ;
      -- trigger_in : in std_logic;           -- readout trigger
      giddyup_in     : in     std_logic ;                            -- "go," since trigger might just mean "read config ports"
      seq_reset_i    : in     std_logic ;
      -- config_in : in std_logic;            -- if received concurrently with trigger, module reads and registers config inputs.
      rpt_in         : in     std_logic_vector (rptLen-1 downto 0);  -- number of triggers within a burst
      -- *** all of our registers are 16b, so we need to make these values
      waitMin16_in   : in     std_logic_vector (15 downto 0);        -- minimum number of clock ticks between triggers w/in a burst
      waitMax16_in   : in     std_logic_vector (15 downto 0);        -- maximum number of clock ticks between triggers w/in a burst
      rpt2_in        : in     std_logic_vector (rpt2Len-1 downto 0); -- number of trigger bursts
      wait2_16_in    : in     std_logic_vector (15 downto 0);        -- fixed number of clock ticks between bursts
      --sq_in         : in  std_logic_vector(2**sqLenExp-1 downto 0);
      --sqLen_in  : in  std_logic_vector(sqLenExp-1 downto 0);
      busy_i         : in     std_logic ;                            -- input for back-pressure or flow control
      outBit_out     : out    std_logic ;                            -- trigger signal output
      testFlag_out   : out    std_logic                              -- long-lived flag for oscilloscope inspection
   );
   end component;
   component trig_dataenc
   port (
      trig_i        : in     std_logic ;
      l0id16_i      : in     std_logic_vector (15 downto 0);
      trig_bus_i    : in     std_logic_vector (15 downto 0);
      trig_src_o    : out    std_logic_vector (3 downto 0);
      trid_i        : in     std_logic_vector (15 downto 0);
      trid_new_i    : in     std_logic ;
      tdc_code_i    : in     std_logic_vector (19 downto 0);
      tdc_new_i     : in     std_logic ;
      tdc_calmode_i : in     std_logic ;
      tdc_caldel_i  : in     std_logic_vector (15 downto 0);
      -- Pkt Out
      packet_o      : out    std_logic_vector (63 downto 0); --t_packet;
      pkt_valid_o   : out    std_logic ;
      pkt_rdack_i   : in     std_logic ;
      -- infra
      en            : in     std_logic ;
      clk           : in     std_logic ;
      rst           : in     std_logic 
   );
   end component;
   component trig_tlu_if
   port (
      trig_tlu_o      : out    std_logic ;
      tlu_trig_sync_i : in     std_logic ;                   -- syncronised, but not l2p
      busy_i          : in     std_logic ;
      tlu_busy_o      : out    std_logic ;
      tlu_tclk_o      : out    std_logic ;
      tick_tclk_i     : in     std_logic ;
      tog_tclk_i      : in     std_logic ;
      trid_tlu_o      : out    std_logic_vector (15 downto 0);
      trid_valid_o    : out    std_logic ;
      trid_new_o      : out    std_logic ;
      debug_mode_i    : in     std_logic ;
      debug_trig_i    : in     std_logic ;
      l0id16_i        : in     std_logic_vector (15 downto 0);
      s40             : in     std_logic ;
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
   component edgedet_sync
   generic (
      EN_ID : integer := 0
   );
   port (
      s40        : in     std_logic ;
      async_i    : in     std_logic ;
      async_o    : out    std_logic ;
      edgesync_o : out    std_logic ;
      sync_o     : out    std_logic ;
      ena_i      : in     std_logic_vector (15 downto 0);
      inv_i      : in     std_logic_vector (15 downto 0);
      rst        : in     std_logic ;
      clk        : in     std_logic 
   );
   end component;
   component prog_delay
   generic (
      LEN : integer := 256
   );
   port (
      strobe40_i : in     std_logic ;
      delay_i    : in     std_logic_vector (15 downto 0);
      sig_i      : in     std_logic ;
      dsig_o     : out    std_logic ;
      rst        : in     std_logic ;
      clk        : in     std_logic 
   );
   end component;
   component sercom_gen
   generic (
      LEN  : integer := 7;
      DATA : integer := 0
   );
   port (
      clk        : in     std_logic;
      ena_i      : in     std_logic;
      go_i       : in     std_logic;
      rst        : in     std_logic;
      strobe40_i : in     std_logic;
      com_o      : out    std_logic
   );
   end component;
   component stretch1
   port (
      clk : in     std_logic;
      i   : in     std_logic;
      o   : out    std_logic
   );
   end component;
   component stretch_sr
   port (
      clk : in     std_logic;
      en  : in     std_logic;
      i   : in     std_logic;
      o16 : out    std_logic;
      o8  : out    std_logic
   );
   end component;


begin
   -- Architecture concurrent statements
   -- HDL Embedded Text Block 1 eb1
   -- eb1 1
   reg_int_ena <= reg(R_INT_ENA);
   reg_out_ena <= reg(R_OUT_ENA);
   reg_control <= reg(R_CONTROL);
   reg_outsigs <= reg(R_OUTSIGS);
   reg_control1 <= reg(R_CONTROL1);

   -- HDL Embedded Text Block 2 eb2
   -- eb2 2
   trig_bus <= x"000" &
     trig_cmd &
     trig_burster &
     trig_tlu &
     trig_ext;
   
   
      

   -- HDL Embedded Text Block 3 eb3
   -- eb3 3
   trigdat_en <= '0' when 
     ((TLU_EN = 0) and (TDC_EN = 0)) 
        else '1';

   -- HDL Embedded Text Block 4 eb4
   -- eb4 4
   HI <= '1';
   LO <= '0';
   ZERO2 <=  "00";
   ZERO3 <=  "000";
   ZERO4 <=  "0000";
   ZERO8 <=  "00000000";
   ZERO13 <= "0000000000000";
   ZERO16 <= "0000000000000000";


   -- ModuleWare code(v1.12) for instance 'Ubcid_l1a' of 'adff'
   bcid_l1a_o <= mw_Ubcid_l1areg_cval;
   prcubcid_l1aseq: process (clk)begin
      if (clk'event and clk='1') then
         if (rst = '1' or rst = 'H') then
            mw_Ubcid_l1areg_cval <= "000000000000";
         elsif (trig80 = '1' or trig80 = 'H') then
            mw_Ubcid_l1areg_cval <= bcid;
         end if;
      end if;
   end process prcubcid_l1aseq;

   -- ModuleWare code(v1.12) for instance 'U_9' of 'and'
   trig_ext <= not(busy) and trig_ext0;

   -- ModuleWare code(v1.12) for instance 'U_10' of 'and'
   lemo_trig0 <= lemo_trig_i and din1;

   -- ModuleWare code(v1.12) for instance 'U_11' of 'and'
   trig_cmd <= not(busy) and trig_cmd0;

   -- ModuleWare code(v1.12) for instance 'U_29' of 'and'
   busy_ext_o <= busy and reg_out_ena(ENA_BUSY);

   -- ModuleWare code(v1.12) for instance 'U_0' of 'buff'
   s40_n <= s40;

   -- ModuleWare code(v1.12) for instance 'U_1' of 'buff'
   ecr_all_o <= ecr_all;

   -- ModuleWare code(v1.12) for instance 'U_5' of 'buff'
   trig80_o <= trig80;

   -- ModuleWare code(v1.12) for instance 'U_6' of 'buff'
   bcid_o <= bcid;

   -- ModuleWare code(v1.12) for instance 'U_13' of 'buff'
   dbg_trig_ext_o <= trig_ext;

   -- ModuleWare code(v1.12) for instance 'U_15' of 'buff'
   trig40_o <= trig40;

   -- ModuleWare code(v1.12) for instance 'U_16' of 'buff'
   l0id_o <= l0id;

   -- ModuleWare code(v1.12) for instance 'U_23' of 'buff'
   bcr_all_o <= bcr_all;

   -- ModuleWare code(v1.12) for instance 'U_26' of 'buff'
   busy_all_o <= busy;

   -- ModuleWare code(v1.12) for instance 'U_3' of 'or'
   ecr_ecb <= ecr_cmd or ecr_ext;

   -- ModuleWare code(v1.12) for instance 'U_7' of 'or'
   pretrig_ecb <= trig_burster or trig_cmd or trig_ext or trig_tlu;

   -- ModuleWare code(v1.12) for instance 'U_12' of 'or'
   din1 <= not(reg_control(CTL_TWIN_EN)) or twin_open_i;

   -- ModuleWare code(v1.12) for instance 'U_14' of 'or'
   com_all <= rawsigs_i(RS_STT_COM) or rawsigs_i(RS_STB_COM)
              or rawsigs_i(RS_ID0_COM) or rawsigs_i(RS_ID1_COM);

   -- ModuleWare code(v1.12) for instance 'U_17' of 'or'
   pretrig <= pretrig_ecb or ocraw_start40;

   -- ModuleWare code(v1.12) for instance 'U_19' of 'or'
   ecr_all <= ecr_dec or ecr_ecb;

   -- ModuleWare code(v1.12) for instance 'U_20' of 'or'
   bcr_ecb <= bcr_cmd or bcr_ext;

   -- ModuleWare code(v1.12) for instance 'U_21' of 'or'
   bcr_all <= bcr_dec or bcr_ecb;

   -- ModuleWare code(v1.12) for instance 'U_22' of 'or'
   com_genc <= ecr_genc or bcr_genc;

   -- ModuleWare code(v1.12) for instance 'U_27' of 'or'
   busy <= busy_i or reg_control(CTL_SBUSY);

   -- Instance port mappings.
   Ucmddecoder : com_decoder
      port map (
         com_i       => com_all,
         a13_fcfr_o  => open,
         a13_sysr_o  => open,
         a13_bcr_o   => bcr_dec,
         a13_ecr_o   => ecr_dec,
         a13_softr_o => open,
         strobe40_i  => s40,
         rst         => rst,
         clk         => clk
      );
   Ul1autogen : l1_autogen
      port map (
         strobe40_i  => s40,
         l0id_i      => l0id,
         l0id_send_o => l0id_l1_o,
         en_i        => reg(R_CONTROL1)(CTL_L0_AUTOGEN),
         ecr_i       => ecr_all,
         l0_i        => trig_ecb,
         l1_o        => l1_auto,
         rst         => rst,
         clk         => clk
      );
   Uosencmap : outsigs_enc_map
      port map (
         invert_mux_i   => reg(R_CONTROL)(CTL_A13MUX_INV),
         reg_outsigs_i  => reg(R_OUTSIGS),
         rawsigs_i      => rawsigs_i,
         l1_auto_i      => l1_auto,
         l0_ecb_i       => trig_ecb,
         com_genc_i     => com_genc,
         trg80_all_o    => trig80,
         trg_all_o      => trig40,
         trg_all_mask_o => trg_all_mask_o,
         outsigs_o      => outsigs_o,
         strobe40       => s40,
         rst            => rst,
         clk            => clk
      );
   Utrgburst : trig_burst
      generic map (
         rptLen   => 16,         -- bit length of trigger rpeitition counter
         rpt2Len  => 16,         -- bit length of supercycle repitition counter
         waitLen  => 20,         -- bit length of repeat cycle countdown timer
         wait2Len => 20,         -- bit length of supercycle countdown timer (VHDL integers have max. value 2**31-1)
         sqLenExp => 3           -- exponent for bit length (2**sqLenExp) of trigger bit-sequence register
      )
      port map (
         clock          => clk,
         strobe40_i     => s40,
         reset          => rst,
         trigs_count_o  => tb_tcount_o,
         bursts_count_o => tb_bcount_o,
         ready_o        => tb_flags_o(TB_READY),
         running_o      => tb_flags_o(TB_RUNNING),
         finished_o     => tb_flags_o(TB_FINISHED),
         giddyup_in     => command(CMD_TB_START),
         seq_reset_i    => command(CMD_TB_RST),
         rpt_in         => reg(R_TB_TRIGS),
         waitMin16_in   => reg(R_TB_PMIN),
         waitMax16_in   => reg(R_TB_PMAX),
         rpt2_in        => reg(R_TB_BURSTS),
         wait2_16_in    => reg(R_TB_PDEAD),
         busy_i         => busy,
         outBit_out     => trig_burster,
         testFlag_out   => tb_testflag
      );
   Utrgdatenc : trig_dataenc
      port map (
         trig_i        => trig40,
         l0id16_i      => l0id(15 downto 0),
         trig_bus_i    => trig_bus,
         trig_src_o    => trig_src,
         trid_i        => trid_tlu,
         trid_new_i    => trid_new,
         tdc_code_i    => tdc_code,
         tdc_new_i     => tdc_new,
         tdc_calmode_i => reg_control1(CTL_TDC_CALIB),
         tdc_caldel_i  => reg(R_TWIN_DELAY),
         packet_o      => td_packet,
         pkt_valid_o   => td_pkt_valid,
         pkt_rdack_i   => td_pkt_rdack,
         en            => trigdat_en,
         clk           => clk,
         rst           => rst
      );
   Utdatfifo : ro13_mod_fifo
      generic map (
         STREAM_ID => 144,
         TS_HIRES  => 1
      )
      port map (
         l0id16_i       => l0id(15 downto 0),
         ts_count_i     => ts_count,
         ts_source_i    => trig_src,
         ts_always_i    => HI,
         ts_disable_i   => reg(R_CONTROL1)(CTL_TDC_CALIB),
         timeout_tick_i => tick(T_800Hz),
         strm_src_i     => ZERO3,
         capture_mode_i => LO,
         packet_i       => td_packet,
         pkt_valid_i    => td_pkt_valid,
         pkt_rdack_o    => td_pkt_rdack,
         lls_o          => lls_o,
         lld_i          => lld_i,
         full_o         => open,
         overflow_o     => open,
         underflow_o    => open,
         data_count_o   => open,
         en             => trigdat_en,
         s40            => s40,
         clk            => clk,
         rst            => rst
      );
   Ubcid : counter
      generic map (
         BITS          => 12,
         ROLLOVER_EN   => 1,
         RST_IS_PRESET => 0         -- reset is preset
      )
      port map (
         inc_i          => s40,
         clr_i          => bcr_all,
         pre_i          => LO,
         count_o        => bcid,
         count_at_max_o => open,
         en_i           => HI,
         rst            => rst,
         clk            => clk
      );
   Ul0id : counter
      generic map (
         BITS          => 32,
         ROLLOVER_EN   => 1,
         RST_IS_PRESET => 1         -- reset is preset
      )
      port map (
         inc_i          => trig40,
         clr_i          => LO,
         pre_i          => ecr_all,
         count_o        => l0id,
         count_at_max_o => open,
         en_i           => s40,
         rst            => rst,
         clk            => clk
      );
   Utimestamp : counter
      generic map (
         BITS          => 40,
         ROLLOVER_EN   => 1,
         RST_IS_PRESET => 0         -- reset is preset
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
   Uedgedet : edgedet_sync
      generic map (
         EN_ID => ENA_TRIG0
      )
      port map (
         s40        => s40,
         async_i    => lemo_trig_i,
         async_o    => lemo_atrig,
         edgesync_o => trig_ext0,
         sync_o     => open,
         ena_i      => reg(R_IN_ENA),
         inv_i      => reg(R_IN_INV),
         rst        => rst,
         clk        => clk
      );
   Uedgedet1 : edgedet_sync
      generic map (
         EN_ID => ENA_ECR
      )
      port map (
         s40        => s40,
         async_i    => lemo_ecr_i,
         async_o    => open,
         edgesync_o => ecr_ext,
         sync_o     => open,
         ena_i      => reg(R_IN_ENA),
         inv_i      => reg(R_IN_INV),
         rst        => rst,
         clk        => clk
      );
   Uedgedet2 : edgedet_sync
      generic map (
         EN_ID => ENA_BCR
      )
      port map (
         s40        => s40,
         async_i    => lemo_bcr_i,
         async_o    => open,
         edgesync_o => bcr_ext,
         sync_o     => open,
         ena_i      => reg(R_IN_ENA),
         inv_i      => reg(R_IN_INV),
         rst        => rst,
         clk        => clk
      );
   Utrigdelay : prog_delay
      generic map (
         LEN => 256
      )
      port map (
         strobe40_i => s40,
         delay_i    => reg(R_TDELAY),
         sig_i      => pretrig_ecb,
         dsig_o     => trig_ecb,
         rst        => rst,
         clk        => clk
      );
   Uscgen_bcr : sercom_gen
      generic map (
         LEN  => 8,
         DATA => 2#10100101#
      )
      port map (
         strobe40_i => s40,
         ena_i      => HI,
         go_i       => bcr_ecb,
         com_o      => bcr_genc,
         rst        => rst,
         clk        => clk
      );
   Uscgen_ecr : sercom_gen
      generic map (
         LEN  => 8,
         DATA => 2#10100110#
      )
      port map (
         strobe40_i => s40,
         ena_i      => HI,
         go_i       => ecr_ecb,
         com_o      => ecr_genc,
         rst        => rst,
         clk        => clk
      );
   Ucbcrstrch : stretch1
      port map (
         clk => clk,
         i   => command(CMD_BCR),
         o   => bcr_cmd
      );
   Ucecrstrch : stretch1
      port map (
         clk => clk,
         i   => command(CMD_ECR),
         o   => ecr_cmd
      );
   Urwstrtstrch : stretch1
      port map (
         clk => clk,
         i   => ocraw_start_i,
         o   => ocraw_start40
      );
   Ustrch1 : stretch1
      port map (
         clk => clk,
         i   => command(CMD_TRIG),
         o   => trig_cmd0
      );
   Utrigoutstretch : stretch_sr
      port map (
         i   => trig40,
         en  => reg(R_CONTROL1)(CTL_TRIGOUT_100),
         o8  => trig_out_o,
         o16 => open,
         clk => clk
      );
   Utrigoutstretch1 : stretch_sr
      port map (
         i   => pretrig,
         en  => reg(R_CONTROL1)(CTL_PRETRIG_100),
         o8  => pretrig_o,
         o16 => open,
         clk => clk
      );

   g0: IF (TLU_EN = 1) GENERATE
      Uedgedet3 : edgedet_sync
         generic map (
            EN_ID => ENA_TRIG1
         )
         port map (
            s40        => s40,
            async_i    => tlu_trig_i,
            async_o    => tlu_atrig,
            edgesync_o => open,
            sync_o     => tlu_trig_sync,
            ena_i      => reg(R_IN_ENA),
            inv_i      => reg(R_IN_INV),
            rst        => rst,
            clk        => clk
         );
      Utluif : trig_tlu_if
         port map (
            trig_tlu_o      => trig_tlu,
            tlu_trig_sync_i => tlu_trig_sync,
            busy_i          => busy,
            tlu_busy_o      => tlu_busy_o,
            tlu_tclk_o      => tlu_tclk_o,
            tick_tclk_i     => tick(T_1MHz),
            tog_tclk_i      => tog(T_1MHz),
            trid_tlu_o      => trid_tlu,
            trid_valid_o    => trid_valid,
            trid_new_o      => trid_new,
            debug_mode_i    => reg(R_CONTROL1)(CTL_TLU_DEBUG),
            debug_trig_i    => tlu_debug_trig_i,
            l0id16_i        => l0id(15 downto 0),
            s40             => s40,
            en              => reg(R_CONTROL1)(CTL_TLU_MODE),
            clk             => clk,
            rst             => rst
         );

      -- ModuleWare code(v1.12) for instance 'U_18' of 'or'
      tlu_debug_trig_i <= trig_cmd or trig_burster;
   end generate g0;

   g1: IF (TDC_EN = 1) GENERATE
      Utdc : slac_tdc
         port map (
            sysclk    => clk,
            sysrst    => rst,
            edge0     => tdc_edge0,
            edge1     => clk40,
            start     => tdc_start,
            valid_o   => tdc_valid,
            newdata_o => tdc_new,
            counter1  => tdc_counter1,
            counter2  => tcd_counter2
         );

      -- ModuleWare code(v1.12) for instance 'U_24' of 'buff'
      tdc_counter1_o <= tdc_counter1;

      -- ModuleWare code(v1.12) for instance 'U_25' of 'buff'
      tdc_counter2_o <= tcd_counter2;
      Utdccode : slac_tdc_encode
         port map (
            clk        => clk,
            rst        => rst,
            counter1_i => tdc_counter1,
            counter2_i => tcd_counter2,
            code_o     => tdc_code
         );

      -- ModuleWare code(v1.12) for instance 'U_28' of 'buff'
      tdc_code_o <= tdc_code;

      -- ModuleWare code(v1.12) for instance 'U_30' of 'or'
      atrig <= lemo_atrig or tlu_atrig or trig_cmd;

      -- ModuleWare code(v1.12) for instance 'U_2' of 'mux'
      prcu_2combo: process(atrig, tdc_calib_edge0, 
                           reg_control1(CTL_TDC_CALIB))
      begin
         case reg_control1(CTL_TDC_CALIB) is
         when '0'|'L' => tdc_edge0 <= atrig;
         when '1'|'H' => tdc_edge0 <= tdc_calib_edge0;
         when others => tdc_edge0 <= 'X';
         end case;
      end process prcu_2combo;

      -- ModuleWare code(v1.12) for instance 'U_31' of 'or'
      tdc_start <= command(CMD_TDC_START) or tdc_tlu_start;

      -- ModuleWare code(v1.12) for instance 'U_32' of 'and'
      tdc_tlu_start <= reg_control1(CTL_TDC_TLU_EN) and trid_new;
      Utdccalib : slac_tdc_calib
         port map (
            delayq_i => reg(R_TWIN_DELAY)(11 downto 10),
            edge0_o  => tdc_calib_edge0,
            clk160ps => clk160ps,
            s40      => s40,
            rst      => rst
         );

      -- ModuleWare code(v1.12) for instance 'U_33' of 'buff'
      tdc_calib_edge0_o <= tdc_calib_edge0;
   end generate g1;

end struct;