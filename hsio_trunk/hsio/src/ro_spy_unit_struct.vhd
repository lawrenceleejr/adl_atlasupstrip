-- VHDL Entity hsio.ro_spy_unit.symbol
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
use work.pkg_core_globals.all;

entity ro_spy_unit is
   port( 
      STREAM_ID        : in     integer;
      capture_len_i    : in     std_logic_vector (15 downto 0);
      clk              : in     std_logic;
      hold_reg_rst_i   : in     std_logic;
      lld_i            : in     std_logic;
      ocraw_start_i    : in     std_logic;
      rawsigs_i        : in     std_logic_vector (15 downto 0);
      reg_spysig_ctl_i : in     std_logic_vector (15 downto 0);
      rst              : in     std_logic;
      sink_go_i        : in     std_logic;
      spy_sig_i        : in     std_logic_vector (15 downto 0);
      -- locallink tx interface
      lls_o            : out    t_llsrc;
      spy_hold_reg_o   : out    std_logic_vector (15 downto 0)
   );

-- Declarations

end ro_spy_unit ;

-- VHDL from Block Diagram 
-- Generated by Mentor Graphics HDL Designer(TM) 2013.1 (Build 6) 
--
-- hsio.ro_spy_unit.struct
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


architecture struct of ro_spy_unit is

   -- Architecture declarations

   -- Internal signal declarations
   signal HI                 : std_logic;
   signal LO                 : std_logic;
   signal ZERO12             : std_logic_vector(11 downto 0);
   signal ZERO24             : std_logic_vector(23 downto 0);
   signal ZERO3              : std_logic_vector(2 downto 0);
   signal capture_start      : std_logic;
   signal deser_data         : std_logic_vector(15 downto 0);
   signal deser_data_len     : std_logic_vector(10 downto 0);
   signal deser_data_len_wr  : std_logic;
   signal deser_data_truncd  : std_logic;
   signal deser_eof          : std_logic;
   signal deser_sof          : std_logic;
   signal deser_we           : std_logic;
   -- deser monitoring
   signal dropped_pkts       : slv8;
   signal fifo_full          : std_logic;
   signal fifo_near_full     : std_logic;
   signal header_seen        : std_logic;
   signal hseen_lch          : std_logic;
   signal len_fifo_full      : std_logic;
   signal len_fifo_near_full : std_logic;
   signal serdata            : std_logic;
   signal spy_data           : std_logic_vector(15 downto 0);
   signal sr_data_o          : std_logic_vector(34 downto 0);
   signal sr_data_word       : std_logic_vector(15 downto 0);
   signal trailer_seen       : std_logic;
   signal tseen_lch          : std_logic;
   signal tseen_lch_clr      : std_logic;


   -- Component Declarations
   component ro_deser
   port (
      STREAM_ID            : in     integer ;
      RAW_MULTI_EN         : in     std_logic ;
      sr_data_word_i       : in     std_logic_vector (15 downto 0);
      header_seen_i        : in     std_logic ;
      trailer_seen_i       : in     std_logic ;
      tseen_lch_i          : in     std_logic ;
      tseen_lch_clr_o      : out    std_logic ;
      gendata_sel_i        : in     std_logic ;
      capture_mode_i       : in     std_logic ;
      wide_cap_mode_i      : in     std_logic ;
      capture_len_i        : in     std_logic_vector (8 downto 0);
      strm_src_i           : in     std_logic_vector (2 downto 0);
      capture_start_i      : in     std_logic ;
      --ocrawcom_start_i     : in     std_logic;
      mode40_strobe_i      : in     std_logic ;
      -- output fifo interface
      fifo_we_o            : out    std_logic ;
      fifo_eof_o           : out    std_logic ;
      fifo_sof_o           : out    std_logic ;
      fifo_data_o          : out    slv16 ;
      data_len_o           : out    std_logic_vector (10 downto 0);
      data_len_wr_o        : out    std_logic ;
      data_truncd_o        : out    std_logic ;
      -- fifo monitoring
      fifo_near_full_i     : in     std_logic ;
      fifo_full_i          : in     std_logic ;
      len_fifo_near_full_i : in     std_logic ;
      len_fifo_full_i      : in     std_logic ;
      -- header details
      l1id_i               : in     std_logic_vector (23 downto 0);
      bcid_i               : in     std_logic_vector (11 downto 0);
      -- deser monitoring
      dropped_pkts_o       : out    slv8 ;
      -- infra
      en                   : in     std_logic ;
      clk                  : in     std_logic ;
      rst                  : in     std_logic 
   );
   end component;
   component ro_shiftreg
   generic (
      SR_MAX : integer := 34
   );
   port (
      serdata_i       : in     std_logic ;
      sr_data_o       : out    std_logic_vector (SR_MAX downto 0);
      header_seen_o   : out    std_logic ;
      hseen_lch_o     : out    std_logic ;
      hseen_lch_clr_i : in     std_logic ;
      trailer_seen_o  : out    std_logic ;
      tseen_lch_o     : out    std_logic ;
      tseen_lch_clr_i : in     std_logic ;
      mode40_strobe_i : in     std_logic ;
      clk             : in     std_logic ;
      rst             : in     std_logic 
   );
   end component;
   component ro_unit_fifo
   port (
      -- input interface
      wren_i                : in     std_logic ;
      data_i                : in     std_logic_vector (15 downto 0);
      sof_i                 : in     std_logic ;
      eof_i                 : in     std_logic ;
      data_truncd_i         : in     std_logic ;
      data_len_i            : in     std_logic_vector (10 downto 0);
      data_len_wr_i         : in     std_logic ;
      -- locallink tx interface
      lls_o                 : out    t_llsrc ;
      lld_i                 : in     std_logic ;
      -- fifo status
      full_o                : out    std_logic ;
      near_full_o           : out    std_logic ;
      overflow_o            : out    std_logic ;
      underflow_o           : out    std_logic ;
      data_count_o          : out    std_logic_vector (1 downto 0);
      len_fifo_full_o       : out    std_logic ;
      len_fifo_near_full_o  : out    std_logic ;
      len_fifo_data_count_o : out    std_logic_vector (1 downto 0);
      -- infrastructure
      en                    : in     std_logic ;
      clk                   : in     std_logic ;
      rst                   : in     std_logic 
   );
   end component;
   component hold_reg
   port (
      clk  : in     std_logic;
      d_i  : in     std_logic_vector (15 downto 0);
      rst0 : in     std_logic;
      rst1 : in     std_logic;
      q_o  : out    std_logic_vector (15 downto 0)
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
   -- HDL Embedded Text Block 1 eb1
   -- eb1 1
   serdata <= spy_sig_i(conv_integer(reg_spysig_ctl_i(7 downto 4)));
   

   -- HDL Embedded Text Block 3 eb3
   -- eb2 2
   ZERO12 <= x"000";
   ZERO24 <= x"000000";
   ZERO3 <= "000";
                                   


   -- ModuleWare code(v1.12) for instance 'U_0' of 'mux'
   prcu_0combo: process(sr_data_o(34 downto 19), spy_data, 
                        reg_spysig_ctl_i(SPY_PAR_EN))
   begin
      case reg_spysig_ctl_i(SPY_PAR_EN) is
      when '0'|'L' => sr_data_word <= sr_data_o(34 downto 19);
      when '1'|'H' => sr_data_word <= spy_data;
      when others => sr_data_word <= (others => 'X');
      end case;
   end process prcu_0combo;

   -- ModuleWare code(v1.12) for instance 'U_2' of 'mux'
   prcu_2combo: process(spy_sig_i, rawsigs_i, 
                        reg_spysig_ctl_i(SPY_RAWSIGS))
   begin
      case reg_spysig_ctl_i(SPY_RAWSIGS) is
      when '0'|'L' => spy_data <= spy_sig_i;
      when '1'|'H' => spy_data <= rawsigs_i;
      when others => spy_data <= (others => 'X');
      end case;
   end process prcu_2combo;

   -- ModuleWare code(v1.12) for instance 'U_3' of 'or'
   capture_start <= sink_go_i or ocraw_start_i;

   -- Instance port mappings.
   Udeser : ro_deser
      port map (
         STREAM_ID            => STREAM_ID,
         RAW_MULTI_EN         => LO,
         sr_data_word_i       => sr_data_word,
         header_seen_i        => header_seen,
         trailer_seen_i       => trailer_seen,
         tseen_lch_i          => tseen_lch,
         tseen_lch_clr_o      => tseen_lch_clr,
         gendata_sel_i        => LO,
         capture_mode_i       => HI,
         wide_cap_mode_i      => reg_spysig_ctl_i(SPY_PAR_EN),
         capture_len_i        => capture_len_i(8 downto 0),
         strm_src_i           => ZERO3,
         capture_start_i      => capture_start,
         mode40_strobe_i      => HI,
         fifo_we_o            => deser_we,
         fifo_eof_o           => deser_eof,
         fifo_sof_o           => deser_sof,
         fifo_data_o          => deser_data,
         data_len_o           => deser_data_len,
         data_len_wr_o        => deser_data_len_wr,
         data_truncd_o        => deser_data_truncd,
         fifo_near_full_i     => fifo_near_full,
         fifo_full_i          => fifo_full,
         len_fifo_near_full_i => len_fifo_near_full,
         len_fifo_full_i      => len_fifo_full,
         l1id_i               => ZERO24,
         bcid_i               => ZERO12,
         dropped_pkts_o       => dropped_pkts,
         en                   => reg_spysig_ctl_i(SPYSIG_EN),
         clk                  => clk,
         rst                  => rst
      );
   Usr : ro_shiftreg
      generic map (
         SR_MAX => 34
      )
      port map (
         serdata_i       => serdata,
         sr_data_o       => sr_data_o,
         header_seen_o   => header_seen,
         hseen_lch_o     => hseen_lch,
         hseen_lch_clr_i => LO,
         trailer_seen_o  => trailer_seen,
         tseen_lch_o     => tseen_lch,
         tseen_lch_clr_i => tseen_lch_clr,
         mode40_strobe_i => HI,
         clk             => clk,
         rst             => rst
      );
   Ufifo : ro_unit_fifo
      port map (
         wren_i                => deser_we,
         data_i                => deser_data,
         sof_i                 => deser_sof,
         eof_i                 => deser_eof,
         data_truncd_i         => deser_data_truncd,
         data_len_i            => deser_data_len,
         data_len_wr_i         => deser_data_len_wr,
         lls_o                 => lls_o,
         lld_i                 => lld_i,
         full_o                => fifo_full,
         near_full_o           => fifo_near_full,
         overflow_o            => open,
         underflow_o           => open,
         data_count_o          => open,
         len_fifo_full_o       => len_fifo_full,
         len_fifo_near_full_o  => len_fifo_near_full,
         len_fifo_data_count_o => open,
         en                    => reg_spysig_ctl_i(SPYSIG_EN),
         clk                   => clk,
         rst                   => rst
      );
   U_1 : hold_reg
      port map (
         d_i  => spy_data,
         clk  => clk,
         rst0 => rst,
         rst1 => hold_reg_rst_i,
         q_o  => spy_hold_reg_o
      );
   Umpower : m_power
      port map (
         hi => HI,
         lo => LO
      );

end struct;
