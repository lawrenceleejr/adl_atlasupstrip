
---------------------------------------------------------------------
-- ITSDAQ Core Global Declarations
--
---------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library utils;
use utils.pkg_types.all;


package pkg_core_globals is

   -- Build specific, but very rare , so leaving here
	constant C_RAW_MULTI_EN : std_logic := '0';


  -- Reg Bus
  -------------------------------------------

  subtype t_reg_bus is slv16_array(0 to 31);


  -- IDELAY Control bus
  -------------------------------------------
  type t_idelay_ctl is
    record
      inc       : std_logic;
      ce        : std_logic_vector(71 downto 0);
      zero      : std_logic_vector(71 downto 0);
      strm_swap : std_logic_vector(71 downto 0);
      strm_loop : std_logic_vector(71 downto 0);
    end record;


  -- ABC130 Packet Stuff (version 0.1)
  --------------------------------------------------------------

  type t_pkt_a13 is
    record
      startb : std_logic;                      --  1
      chipid : std_logic_vector(4 downto 0);   --  5
      typ    : std_logic_vector(3 downto 0);   --  4
      l0id   : std_logic_vector(7 downto 0);   --  8
      bcid   : std_logic_vector(7 downto 0);   --  8
      datawd : std_logic_vector(32 downto 0);  -- 33
      stopb  : std_logic;                      --  1
    end record;  ----------------------------- ==
  -- 60

  type t_pkt_hcc is
    record
      -- start bits                             --  2   0:1
      hcchead : std_logic_vector(2 downto 0);   --  3   2:4
      chipid  : std_logic_vector(4 downto 0);   --  5   5:9
      typ     : std_logic_vector(3 downto 0);   --  4  10:13
      l0id    : std_logic_vector(7 downto 0);   --  8  14:21
      bcid    : std_logic_vector(7 downto 0);   --  8  22:29
      datawd  : std_logic_vector(32 downto 0);  -- 33  30:62
      stopb   : std_logic;                      --  1   63
    end record;  ------------------------------ ==
  -- 64

  type t_packet is
    record
      linkid  : std_logic_vector(1 downto 0);   --  2   0:1
      hcchead : std_logic_vector(2 downto 0);   --  3   2:4
      chipid  : std_logic_vector(4 downto 0);   --  5   6:10
      typ     : std_logic_vector(3 downto 0);   --  4  11:14 
      l0id    : std_logic_vector(7 downto 0);   --  8  15:22
      bcid    : std_logic_vector(7 downto 0);   --  8  23:30
      dat     : std_logic_vector(32 downto 0);  -- 33  31:63
      stopb   : std_logic;                      --  1  
    end record;  ------------------------------ ==
  -- 64


  type t_packet_array is array (natural range <>) of t_packet;


  type t_datawd_l11bc is
    record
      strip0 : std_logic_vector(7 downto 0);
      hits0  : std_logic_vector(2 downto 0);
      strip1 : std_logic_vector(7 downto 0);
      hits1  : std_logic_vector(2 downto 0);
      strip2 : std_logic_vector(7 downto 0);
      hits2  : std_logic_vector(2 downto 0);
    end record;

  type t_datawd_l13bc is
    record
      strip : std_logic_vector(7 downto 0);
      hits0 : std_logic_vector(2 downto 0);
      hits1 : std_logic_vector(2 downto 0);
      hits2 : std_logic_vector(2 downto 0);
      hits3 : std_logic_vector(2 downto 0);
    end record;

  type t_datawd_r3 is
    record
      strip0 : std_logic_vector(7 downto 0);
      strip1 : std_logic_vector(7 downto 0);
      strip2 : std_logic_vector(7 downto 0);
      strip3 : std_logic_vector(7 downto 0);
      ovf    : std_logic;
    end record;


--==============================================================================
-- Registers and Bits
--==============================================================================


  constant OC_ECHO          : slv16 := x"0003";
  constant OC_REGWRITE      : slv16 := x"0010";
  constant OC_REGBLOCK_WR   : slv16 := x"0014";
  constant OC_REGBLOCK_RD   : slv16 := x"0015";
  constant OC_STATREAD      : slv16 := x"0019";
  constant OC_COMMAND       : slv16 := x"0030";
--constant OC_MONREAD_TOP : slv16 := x"0041";  -- replaced by TWOWIRE
--constant OC_MONREAD_BOT   : slv16 := x"0042";  -- replaced by TWOWIRE
  constant OC_STRM_CONF_WR  : slv16 := x"0050";
  constant OC_STRM_REQ_STAT : slv16 := x"0051";
  constant OC_BSTRM_CONF_WR : slv16 := x"0052";
  constant OC_STRM_COMMAND  : slv16 := x"005c";
  constant OC_BSTRM_COMMAND : slv16 := x"005e";
--constant OC_RAWCOM : slv16 := x"0070";  -- one day it will move here
  constant OC_COM_PATTERN   : slv16 := x"0072";
  constant OC_RAWSIGS       : slv16 := x"0074";
  constant OC_SIGS_PATTERN  : slv16 := x"0076";
  constant OC_RAWSEQ        : slv16 := x"0078";
  constant OC_SEQ_PATTERN   : slv16 := x"007a";
  constant OC_TWOWIRE       : slv16 := x"0080";  -- 0x008X will be for all DCS stuff
  constant OC_TWMEM_LOAD    : slv16 := x"0082";
  constant OC_RESET_OCB     : slv16 := x"00F0";
  constant OC_RAWCOM        : slv16 := x"0101";
--constant OC_SPISER : slv16 := x"0105";

  constant OC_INVALID           : slv16 := x"F0EC";  -- was 0FEC
  constant OC_ACK               : slv16 := x"A0CC";  -- was AACC
  constant OC_BOOT_ACK          : slv16 := x"A0BB";  -- was AABB
--constant OC_RXPKTDEC_BARK : slv16 := x"AAEE";  -- rx pkt decoder watchdog timeout
--now signalled using 0xBopc from ocb_echo_watchdog
  constant OC_RXPKTDEC_FIFOFULL : slv16 := x"A0FF";  -- rx pkt opcode fifo full

-- HSIO TO PC (usually unsolicited)
  constant OC_STRM_RAW_DATA     : slv16 := x"D000";
  constant OC_STRM_HISTO_DATA   : slv16 := x"D001";
  constant OC_STRM_HISTOM_DATA  : slv16 := x"D011";  -- Tom's histo
  constant OC_STRM_CAPTURE_DATA : slv16 := x"D004";
  constant OC_SINK_DATA         : slv16 := x"D020";  -- Sink Data
  constant OC_STRM_STAT_DATA    : slv16 := x"D051";

  -- ABC130 unsolicited
  constant OC_STRM_A13_RAW_DATA  : slv16 := x"D008";
  constant OC_STRM_A13_HIST_DATA : slv16 := x"D009";
  --constant OC_STRM_A13_CAPT_DATA   : slv16 := x"D00c";  -- using D004

-- Connector pin assignments
-- ===========================================================================

-- The Peter Phillips(tm) connector pinout:
  constant PP_COM   : integer := 0;     -- IDC pins 1,2
  constant PP_BCO   : integer := 1;  -- IDC pins 3,4  --NOTE BCO, DCLK labels swapped in some schematics
  constant PP_L1    : integer := 2;     -- IDC pins 5,6
  constant PP_DCLK  : integer := 3;     -- IDC pins 7,8
  constant PP_DATA0 : integer := 4;     -- IDC pins 9,10
  constant PP_DATA1 : integer := 5;     -- IDC pins 11,12
  constant PP_RESET : integer := 6;     -- IDC pins 13,14
  constant PP_GND   : integer := 7;     -- IDC pins 15,16


----------------------------------------
-- constant SIG_ST_BCO : integer := 0;       -- IDC  1
--  constant SIG_UNUSED_01 : integer := 1;   -- IDC  3
--  constant SIG_STT_COM   : integer := 2;   -- IDC  5
--  constant SIG_STT_L1R   : integer := 3;   -- IDC  7
--                                       -- IDC  9 GND
--  constant SIG_STT_NOISE : integer := 4;   -- IDC 11
--  constant SIG_STB_COM   : integer := 5;   -- IDC 13
--  constant SIG_STB_L1R   : integer := 6;   -- IDC 15
--  constant SIG_STB_NOISE : integer := 7;   -- IDC 17
--                                       -- IDC 19 GND
--  constant SIG_PP_BCO    : integer := 8;   -- IDC 21
--  constant SIG_PP_DCLK   : integer := 9;   -- IDC 23
--  constant SIG_PP0_COM   : integer := 10;  -- IDC 25
--  constant SIG_PP0_L1    : integer := 11;  -- IDC 27
--                                       -- IDC 29 GND
--  constant SIG_PP0_RESET : integer := 12;  -- IDC 31
--  constant SIG_PP1_COM   : integer := 13;  -- IDC 33
--  constant SIG_PP1_L1    : integer := 14;  -- IDC 35
--  constant SIG_PP1_RESET : integer := 15;  -- IDC 37
--                                       -- IDC 39 N/C



-- REGBLOCK assignments
-- ==========================================================

-----------------------------------------------
-- Register Block
-----------------------------------------------

--[REG 16] com enable bits
-- 15 - com shift 180
-- 14 - com shift 90
-- 13 - dclk enable
-- 12 - bco enable
-- 11 - invert reset
-- 10 - swap bco and dclk outputs
-- 9 - com into pp1 reset en
-- 8 - com into pp0 reset en
-- 7 - dclk invert
-- 6 - bco invert
-- 5 - com into pp1 l1 enable
-- 4 - com into pp0 l1 enable
-- 3 - com into st l1r enable
-- 2 - st com enable
-- 1 - pp1 com enable
-- 0 - pp0 com enable


  constant R_IN_ENA      : integer := 0;  -- 0x00  -- inputs enables
  constant R_OUT_ENA     : integer := 1;  -- 0x02  -- outputs enables
  constant R_INT_ENA     : integer := 2;  -- 0x04  -- internal signals ena
  constant R_IN_INV      : integer := 3;  -- 0x06  -- input inverts
  constant R_SIGS_IDLE   : integer := 4;  -- 0x08  -- signs value when not being driven by RAWSIGS/SEQ
  constant R_SQ_CTL      : integer := 5;  -- 0x0a  -- sequence control - 
  constant R_SPYSIG_CTL  : integer := 6;  -- 0x0c
  constant R_LEN0        : integer := 7;  -- 0x0e
  constant R_LEN1        : integer := 8;  -- 0x10
  constant R_IDELAY      : integer := 9;  -- 0x12
  constant R_SG0_CONF_LO : integer := 10;  -- 0x14
  constant R_SG0_CONF_HI : integer := 11;  -- 0x16
  constant R_SG1_CONF_LO : integer := 12;  -- 0x18
  constant R_SG1_CONF_HI : integer := 13;  -- 0x1a
  constant R_SG_RNDSEEDS : integer := 14;  -- 0x1c
  constant R_TWIN_DELAY  : integer := 15;  -- 0x1e  -- trigger window open delay (when enabled)
  constant R_COM_ENA     : integer := 16;  -- 0x20
  constant R_BUSY_DELTA  : integer := 17;  -- 0x22  -- levels for delta busy (global)
  constant R_DRV_CONF    : integer := 18;  -- 0x24  -- Driver config (temporary Nov13)
  constant R_CONTROL1    : integer := 19;  -- 0x26  -- Control Register 1
  constant R_DISP_SEL    : integer := 20;  -- 0x28
  constant R_LEMO_STRM   : integer := 21;  -- 0x2a  -- stream to present on dbg lemo 1,2
  constant R_OUTSIGS     : integer := 22;  -- 0x2c  -- configure output signal formats
  constant R_CONTROL     : integer := 23;  -- 0x2e
  constant R_TB_TRIGS    : integer := 24;  -- 0x30  -- number of trigger in a burst
  constant R_TB_BURSTS   : integer := 25;  -- 0x32  -- number of bursts
  constant R_TB_PMIN     : integer := 26;  -- 0x34  -- trigger period min (400ns steps)
  constant R_TB_PMAX     : integer := 27;  -- 0x36  -- trigger perid max (400ns steps)
  constant R_TB_PDEAD    : integer := 28;  -- 0x38  -- intra-burst deadtime (6.4us steps)
  constant R_TDELAY      : integer := 29;  -- 0x3a  -- trigger delay
  constant R_BCO_DC      : integer := 30;  -- 0x3c  -- BCO duty cycle (when enabled)
  constant R_TLU_CTL     : integer := 31;  -- 0x3e  -- Bits for controling interact with TLU

  --was: constant R_DL0_DELAY   : integer := 31;  -- 0x32  -- Delayed L0 delay (when enabled)



  constant REG_INITVAL : t_reg_bus := (
    x"0000",                            -- 0  IN_ENA
    x"0000",                            -- 1  OUT_ENA
    x"0000",                            -- 2  INT_ENA 
    x"0000",                            -- 3  IN_INV
    x"0000",                            -- 4  
    x"1FFF",                            -- 5  SQ_CTL  max seq len
    x"0000",                            -- 6  SPYSIG_CTL
    x"007F",                            -- 7  LEN0
    x"008F",                            -- 8  LEN1
    x"0000",                            -- 9  IDELAY
    x"0000",                            -- 10 SG0_CONF_LO
    x"0000",                            -- 11 SG0_CONF_HI
    x"0000",                            -- 12 SG1_CONF_LO
    x"0000",                            -- 13 SG1_CONF_HI
    x"0112",                            -- 14 SG_RNDSEEDS
    x"0000",                            -- 15 TWIN_DELAY
    x"9C01",                            -- 16 COM_ENA
    x"2010",                            -- 17 BUSY_DELTA
    x"0150",                            -- 18 DRV_CONF chip addr 21
    x"0000",                            -- 19
    x"0015",                            -- 20 DISP_SEL
    x"0008",                            -- 21 LEMO_STRM
    x"2222",                            -- 22 OUTSIGS
    x"0080",                            -- 23 CONTROL
    x"000A",                            -- 24 TB_TRIGS
    x"0001",                            -- 25 TB_BURSTS
    x"0010",                            -- 26 TB_PMIN
    x"0010",                            -- 27 TB_PMAX
    x"1000",                            -- 28 TB_PDEAD
    x"0000",                            -- 29 TDELAY
    x"0000",                            -- 30 BCO_DC
    x"0000"                             -- 31 DL0_DELAY
    );

-- ===========================================================================
-- S T A T U S
-- ===========================================================================
  constant S_HW_ID        : integer := 0;  -- 0x00  -- hsio hardware id
  constant S_SANITY       : integer := 1;  -- 0x02  -- sanity check - always = 0xA510
  constant S_VERSION      : integer := 2;  -- 0x04  -- f/w version
  constant S_MODULECOUNT  : integer := 3;  -- 0x06  -- n modules in build
  constant S_TB_TCOUNT    : integer := 4;  -- 0x08  -- trig burst ??? count
  constant S_TB_BCOUNT    : integer := 5;  -- 0x0a  -- trig burst ??? count
  constant S_TBSQ_FLAGS   : integer := 6;  -- 0x0c  -- trig burst and sequencer flags
  constant S_BCID_L1A     : integer := 7;  -- 0x0e  -- 
  constant S_L0ID_LO      : integer := 8;  -- 0x10
  constant S_L0ID_HI      : integer := 9;  -- 0x12
  constant S_SF0_STAT_LO  : integer := 10;  -- 0x14  -- eth fibre 0 stats lo
  constant S_SF0_STAT_HI  : integer := 11;  -- 0x16  -- eth fibre 0 stats hi
  constant S_SF1_STAT_LO  : integer := 12;  -- 0x18  -- eth fibre 1 stats lo
  constant S_SF1_STAT_HI  : integer := 13;  -- 0x1a  -- eth fibre 1 stats hi
  constant S_CU_STAT      : integer := 14;  -- 0x1c  -- eth copper stats 
  constant S_GENSTAT      : integer := 15;  -- 0x1e
  constant S_TOP_RAW      : integer := 16;  -- 0x20  -- top rawfifos in build
  constant S_TOP_HST      : integer := 17;  -- 0x22  -- top histos in build
  constant S_BOT_RAW      : integer := 18;  -- 0x24  -- bottom rawfifos in build
  constant S_BOT_HST      : integer := 19;  -- 0x26  -- bottom histos in build
  constant S_IDC_HSTRAW   : integer := 20;  -- 0x28  -- idc histos/rawfifo in build
  constant S_SPY_HOLD_REG : integer := 21;  -- 0x2a  -- spy signals held if seen 
  constant S_TIMESTAMP_LO : integer := 22;  -- 0x2c
  constant S_TIMESTAMP_HI : integer := 23;  -- 0x2e
  constant S_SQ_ADDR      : integer := 24;  -- 0x30  -- Sequence current RAM address
  constant S_SK_ADDR      : integer := 25;  -- 0x32  -- Sink current RAM address
  constant S_L0ID_L1      : integer := 26;  -- 0x34  -- Last L0ID sent by L1-auto
  constant S_27           : integer := 27;  -- 0x36
  constant S_28           : integer := 28;  -- 0x38
  constant S_29           : integer := 29;  -- 0x3a
  constant S_30           : integer := 30;  -- 0x3c
  constant S_31           : integer := 31;  -- 0x3e


-- ===========================================================================
-- reg in/out/int enables sigs

  constant ENA_15    : integer := 15;
  constant ENA_14    : integer := 14;
  constant ENA_13    : integer := 13;
  constant ENA_12    : integer := 12;
  constant ENA_11    : integer := 11;
  constant ENA_10    : integer := 10;
  constant ENA_CLK1  : integer := 9;
  constant ENA_CLK0  : integer := 8;
  constant ENA_BUSY  : integer := 7;
  constant ENA_06    : integer := 6;
  constant ENA_ECR   : integer := 5;
  constant ENA_BCR   : integer := 4;
  constant ENA_TRIG3 : integer := 3;
  constant ENA_TRIG2 : integer := 2;
  constant ENA_TRIG1 : integer := 1;
  constant ENA_TRIG0 : integer := 0;


--==========================================================
-- reg spysig_ctl bits

  constant SPYSIG_15   : integer := 15;
  constant SPYSIG_14   : integer := 14;
  constant SPYSIG_13   : integer := 13;
  constant SPYSIG_12   : integer := 12;
  constant SPYSIG_11   : integer := 11;
  constant SPYSIG_10   : integer := 10;
  constant SPY_RAWSIGS : integer := 9;  -- spy on rawsigs (not outsigs)
  constant SPY_PAR_EN  : integer := 8;  -- enable parallel capture of ALL channels
  -- 7:4                                -- spy channel select
  constant SPYSIG_03   : integer := 3;
  constant SPYSIG_02   : integer := 2;
  constant SPYSIG_01   : integer := 1;
  constant SPYSIG_EN   : integer := 0;


--==========================================================
-- reg com enable dbits - R_COM_ENA

  constant B_COM_PS_180  : integer := 15;
  constant B_COM_PS_90   : integer := 14;
  constant B_DCLK_EN     : integer := 13;
  constant B_BCO_EN      : integer := 12;
  constant B_RST_INV     : integer := 11;
--constant B_SWAP_BCO_DCLK : integer := 10;
  constant B_COM_J38_RST : integer := 9;
  constant B_COM_J37_RST : integer := 8;
  constant B_DCLK_INV    : integer := 7;
  constant B_BCO_INV     : integer := 6;
  constant B_COM_J38_L1  : integer := 5;
  constant B_COM_J37_L1  : integer := 4;
  constant B_COM_ST_L1R  : integer := 3;
  constant B_ST_COM_EN   : integer := 2;
  constant B_J38_COM_EN  : integer := 1;
  constant B_J37_COM_EN  : integer := 0;


--==========================================================
-- reg sq_ctl bits - R_SQ_CTL [5]

  constant B_SQ_CYCLIC_EN : integer := 15;



--==========================================================
-- reg control bits - R_CONTROL (0) [23]

  constant CTL_SBUSY         : integer := 0;  -- SBUSY - software busy
  constant CTL_A13MUX_INV    : integer := 1;  -- shifts the ABC130 sigs by 180 degrees
  constant CTL_A13_DCLK_160  : integer := 2;  -- enable to 160MHz DCLK for internal ABC130 emu - else 80MHz
  constant CTL_AD_TYPE_EN    : integer := 3;  -- alternate eth type for DCS packets en
  constant CTL_HTEST_EN      : integer := 4;  -- histo test data en (data=addr)
  constant CTL_GEN13DATA_EN  : integer := 5;  -- enable abc130 data gen (0=reset)
  constant CTL_GEN13ABC_EN   : integer := 6;  -- enable ABC packet deser (else HCC)
  constant CTL_DBG_EN        : integer := 7;  -- debug outputs enable
  constant CTL_COM_PATT_EN   : integer := 8;
  constant CTL_TWIN_EN       : integer := 9;
  constant CTL_BCO_DC_EN     : integer := 10;  -- enable BCO duty cycle control
  constant CTL_CAP_START_SRC : integer := 11;
  constant CTL_L1R_SEL       : integer := 12;
  constant CTL_COM_NOISE_EN  : integer := 13;  -- com into noise enable
  constant CTL_DCLK40_MODE   : integer := 14;
  --constant CTL_DL0_EN        : integer := 15;  -- enable delayed L0 trigger

--==========================================================
-- reg control bits - R_CONTROL1 [19]

  constant CTL_RAWOUT_EN   : integer := 0;  -- enable raw/sequencer direct output mapping
--constant CTL_101         : integer := 1;
--constant CTL_102         : integer := 2;
  constant CTL_DRV_SP0     : integer := 3;  -- SCAN_EN
  constant CTL_DRV_DXOUT0  : integer := 4;
  constant CTL_DRV_DXOUT1  : integer := 5;
  constant CTL_DRV_DXOUT2  : integer := 6;  -- SDO_BC
  constant CTL_DRV_DXOUT3  : integer := 7;  -- SDO_CLK
  constant CTL_TRIGOUT_100 : integer := 8;  -- TRIG_OUT width = 100ns
  constant CTL_PRETRIG_100 : integer := 9;  -- PRETRIG_OUT width = 100ns
  constant CTL_L0_AUTOGEN  : integer := 10;  -- 
  constant CTL_TLU_MODE    : integer := 11;  -- HSIO is talking to a TLU via Clucky
  constant CTL_TLU_DEBUG   : integer := 12;  -- TLU debug mode
  constant CTL_TDC_CALIB   : integer := 13;  -- enable TDC calibration mode
  constant CTL_TDC_TLU_EN  : integer := 14;  -- enable TDC/TLC auto start logic
--constant CTL_ : integer := 15;


--==========================================================
-- COMMAND bits (opcode oc_command - 0x30)


  constant CMD_TWMEM_GO  : integer := 15;
  constant CMD_RCPATT_GO : integer := 14;
  constant CMD_SINK_GO   : integer := 13;
  constant CMD_SQPATT_GO : integer := 12;
  constant CMD_RSPATT_GO : integer := 11;  -- this may move to RCPATT
  constant CMD_LATCH_RST : integer := 10;  -- Reset "latch" registers
  constant CMD_TB_RST    : integer := 9;
  constant CMD_TB_START  : integer := 8;
  constant CMD_TDC_START : integer := 7;
  constant CMD_L1ID_RST  : integer := 6;
  constant CMD_BCID_RST  : integer := 5;
  constant CMD_04        : integer := 4;
  constant CMD_03        : integer := 3;
  constant CMD_ECR       : integer := 2;
  constant CMD_BCR       : integer := 1;
  constant CMD_TRIG      : integer := 0;


--constant RST_ : integer := 15;
--constant RST_ : integer := 14;
--constant RST_ : integer := 13;
--constant RST_ : integer := 12;
--constant RST_ : integer := 11;
--constant RST_ : integer := 10;
--constant RST_ : integer := 9;
--constant RST_ : integer := 8;
  constant CMD_RST_DRV   : integer := 7;
  constant CMD_RST_NETRX : integer := 6;
  constant CMD_RST_NETTX : integer := 5;
  constant CMD_RST_DISP  : integer := 4;
--constant CMD_RST_FEO : integer := 3;
--constant CMD_RST : integer := 2;
  constant CMD_RST_TRIG  : integer := 1;
  constant CMD_RST_RO    : integer := 0;


--===========================================================
-- STATUS bits

-- TBSQ_FLAGS reg (Stat 6)

  constant TB_READY    : integer := 0;
  constant TB_RUNNING  : integer := 1;
  constant TB_FINISHED : integer := 2;

  constant SQ_READY   : integer := 8;
  constant SQ_RUNNING : integer := 9;


--==========================================================
-- RAWSIGS bits (opcode oc_rawsigs - 0x74)


-- constant RS_STT_COM : integer := 0;
-- constant RS_STB_COM : integer := 1;
-- constant RS_ID0_COM : integer := 2;
-- constant RS_ID1_COM : integer := 3;
-- constant RS_STT_R3 : integer := 4;
-- constant RS_STB_R3 : integer := 5;
-- constant RS_ST_L0 : integer := 6;
-- constant RS_ST_L1 : integer := 7;
-- constant RS_IDC_L1R : integer := 8;
-- constant RS_IDC_RES : integer := 9;
-- constant RS_SPARE10 : integer := 10;
-- constant RS_SPARE11 : integer := 11;
-- constant RS_STT_NOS : integer := 12;
-- constant RS_STB_NOS : integer := 13;
-- constant RS_SPARE14 : integer := 14;
-- constant RS_ABC_DL0 : integer := 15;

  -- ------------------------------------ ABC130   ABCN
  -------------------------------------- -------- ------
  constant RS_ID1_R3  : integer := 15;  -- R3     RESET
  constant RS_ID1_COM : integer := 14;  -- COM     COM
  constant RS_ID0_R3  : integer := 13;  -- R3     RESET
  constant RS_ID0_COM : integer := 12;  -- COM     COM

  constant RS_IDC_L1  : integer := 11;  -- L1      L1R 
  constant RS_IDC_L0  : integer := 10;  -- L0      n/a
  constant RS_STB_NOS : integer := 9;   -- NOISE  NOISE
  constant RS_STT_NOS : integer := 8;   -- NOISE  NOISE

  constant RS_STB_R3  : integer := 7;   -- R3      n/a
  constant RS_STB_L1  : integer := 6;   -- L1      L1R
  constant RS_STB_L0  : integer := 5;   -- L0      n/a
  constant RS_STB_COM : integer := 4;   -- COM     COM

  constant RS_STT_R3  : integer := 3;   -- R3      n/a
  constant RS_STT_L1  : integer := 2;   -- L1      L1R
  constant RS_STT_L0  : integer := 1;   -- L0      n/a
  constant RS_STT_COM : integer := 0;   -- COM     COM


-- constant RS_ABC_DL0 : integer := 11;
-- constant RS_ABC_COM : integer := 12;
-- constant RS_ABC_L0 : integer := 13;
-- constant RS_ABC_L1 : integer := 14;
-- constant RS_ABC_R3S : integer := 15;



  -- Output signals (mapped via R_OUTSIGS)
  ------------------------------------  --------  m o d e  ------
  ------------HSIO                      -- HCC     ABC130  ABCN
  ------------------------------------  -- ------  ------  ------
  constant OS_ID1_RST : integer := 15;  -- n/a     n/a     RESET
  constant OS_ID1_COM : integer := 14;  -- COML0E  COML0   COM
  constant OS_ID0_RST : integer := 13;  -- n/a     n/a     RESET
  constant OS_ID0_COM : integer := 12;  -- COML0E  COML0   COM

  constant OS_ID1_L1R : integer := 11;  -- L1R3E   L1R3S   L1R     
  constant OS_ID0_L1R : integer := 10;  -- L1R3E   L1R3S   L1R     
  constant OS_STB_NOS : integer := 9;   -- NOISE   NOISE   NOISE
  constant OS_STT_NOS : integer := 8;   -- NOISE   NOISE   NOISE

  constant OS_7       : integer := 7;   -- n/a     n/a     n/a
  constant OS_STB_L1R : integer := 6;   -- L1R3E   L1R3S   L1R
  constant OS_5       : integer := 5;   -- n/a     n/a     n/a
  constant OS_STB_COM : integer := 4;   -- COML0E  COML0   COM

  constant OS_3       : integer := 3;   -- n/a     n/a     n/a
  constant OS_STT_L1R : integer := 2;   -- L1R3E   L1R3S   L1R
  constant OS_1       : integer := 1;   -- n/a     n/a     n/a
  constant OS_STT_COM : integer := 0;   -- COML0E  COML0   COM


  -- values mapped onto the mode values in reg_outsigs
  constant C_OS_HCC    : std_logic_vector(2 downto 0) := "011";
  constant C_OS_ABC130 : std_logic_vector(2 downto 0) := "010";
--constant C_OS_reserv : std_logic_vector(2 downto 0) := "001";
  constant C_OS_ABCN   : std_logic_vector(2 downto 0) := "000";
  constant C_OS_OFF    : std_logic_vector(2 downto 0) := "111";



  -- Output signals map for the Driver     SC MODE
  ------------------------------------  ----------
  constant OD_DX3   : integer := 7;     -- SDO_CLK
  constant OD_DX2   : integer := 6;     -- SDO_BC
  constant OD_DX1   : integer := 5;     -- DXR
  constant OD_DX0   : integer := 4;     -- DXL
  constant OD_3     : integer := 3;     -- n/c
  constant OD_SPARE : integer := 2;     -- SCAN_EN
  constant OD_L1R3  : integer := 1;
  constant OD_COML0 : integer := 0;

  -- Input signals map for the Driver          SC MODE
  ------------------------------------  ----------------
  constant ID_DX3 : integer := 7;       -- Strms  20, 84
  constant ID_DX2 : integer := 6;       -- Strms  14, 78
  constant ID_DX1 : integer := 5;       -- Strms   8, 52
  constant ID_DX0 : integer := 4;       -- Strms   2, 66
  constant ID_3   : integer := 3;       -- n/c
  constant ID_2   : integer := 2;       -- n/c
  constant ID_1   : integer := 1;       -- n/c
  constant ID_0   : integer := 0;       -- n/c



  ---------------------------------------------------------------------------
  constant BIT_MASK : slv16_array := (
    x"0001",
    x"0002",
    x"0004",
    x"0008",
    x"0010",
    x"0020",
    x"0040",
    x"0080",
    x"0100",
    x"0200",
    x"0400",
    x"0800",
    x"1000",
    x"2000",
    x"4000",
    x"8000"
    );


--===============================================================
  constant PD_SIM_FF : time := 50 ps;


--====================================================================
-- FUNCTIONS
--====================================================================

  -- functions that extract the opcode "port" or clear it
  -- the idea is that if this definition changes all the ocb_
  -- files will not need to be changed AGAIN
  --

  constant OC_PORT_MASK : std_logic_vector(15 downto 0) := "1111000111111111";

  function oc_get_port (
    opcode_raw : std_logic_vector(15 downto 0)
    )
    return std_logic_vector;


  function oc_insert_port (
    opcode      : std_logic_vector(15 downto 0);
    opcode_port : std_logic_vector(3 downto 0)
    )
    return std_logic_vector;


  function oc_get_opcodepl (
    opcode_raw : std_logic_vector(15 downto 0)
    )
    return std_logic_vector;


end pkg_core_globals;



--=========================================================================================
--
-- B O D Y
--
--=========================================================================================

package body pkg_core_globals is

  function oc_get_port (
    opcode_raw : std_logic_vector(15 downto 0)
    )
    return std_logic_vector is
  begin

    return '0' & opcode_raw(11 downto 9);

  end function;

  function oc_insert_port
    (opcode      : std_logic_vector(15 downto 0);
     opcode_port : std_logic_vector(3 downto 0)
     )
    return std_logic_vector is
  begin
    return (opcode and OC_PORT_MASK) or
      (x"0" & opcode_port(2 downto 0) & "0" & x"00");
  end function;


  function oc_get_opcodepl
    (opcode_raw : std_logic_vector(15 downto 0) )
    return std_logic_vector is
  begin
    return (opcode_raw and OC_PORT_MASK);
  end function;


end pkg_core_globals;

