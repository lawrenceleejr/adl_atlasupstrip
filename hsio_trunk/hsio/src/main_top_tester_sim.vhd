--
-- VHDL Architecture hsio.main_top_tester.sim
--
-- Created:
--          by - warren.warren (fedxtron)
--          at - 21:14:58 08/13/10
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.ALL;

entity main_top_tester is
   port( 
      -- DISPLAY
      disp_clk_o    : in     std_logic;                         --DISP_CLK
      disp_dat_o    : in     std_logic;                         --DISP_DAT
      disp_load_no  : in     std_logic_vector (1 downto 0);     --DISP_LOAD1_N
      disp_rst_no   : in     std_logic;                         --DISP_RST_N
      ibag_bco_o    : in     std_logic;
      ibag_com_o    : in     std_logic;
      ibag_dclk_o   : in     std_logic;
      ibag_l1_o     : in     std_logic;
      ibag_reset_o  : in     std_logic;
      ibpp_bco_o    : in     std_logic;
      ibpp_com_o    : in     std_logic;
      ibpp_dclk_o   : in     std_logic;
      ibpp_l1_o     : in     std_logic;
      ibpp_reset_o  : in     std_logic;
      ibst_bco_o    : in     std_logic;
      ibst_com_o    : in     std_logic;
      ibst_l1r_o    : in     std_logic;
      led_status_o  : in     std_logic;                         --LED_FPGA_STATUS
      rx_dst_rdy_o  : in     std_logic;
      rx_fifo_clk_o : in     std_ulogic;
      rx_fifo_rst_o : in     std_logic;
      ti2c_cvstt_no : in     std_logic_vector (2 downto 0);
      ti2c_sclt_o   : in     std_logic_vector (2 downto 0);
      tx_data_len_o : in     std_logic_vector (15 downto 0);
      tx_data_o     : in     std_logic_vector (15 downto 0);
      tx_eof_o      : in     std_logic;
      tx_fifo_clk_o : in     std_logic;
      tx_fifo_rst_o : in     std_logic;
      tx_sof_o      : in     std_logic;
      tx_src_rdy_o  : in     std_logic;
      abc_data_i    : out    std_logic_vector (23 downto 0);
      clk125        : out    std_logic;
      clk40         : out    std_ulogic;
      dcms_locked_i : out    std_logic;
      led_linkupa   : out    std_logic;
      led_linkupb   : out    std_logic;
      rst40         : out    std_logic;
      rx_data_i     : out    std_logic_vector (15 downto 0);
      rx_eof_i      : out    std_logic;
      rx_sof_i      : out    std_logic;
      rx_src_rdy_i  : out    std_logic;
      stat_word_cu  : out    std_logic_vector (63 downto 0);
      stat_word_sfa : out    std_logic_vector (63 downto 0);
      stat_word_sfb : out    std_logic_vector ( 63 downto 0 );
      stat_word_usb : out    std_logic_vector (63 downto 0);
      sw_hex_ni     : out    std_logic_vector (3 downto 0);
      tx_dst_rdy_i  : out    std_logic;
      -- IDC CONNECTORS (P2-5)
      idc_p2_io     : inout  std_logic_vector (31 downto 0);    --IDC_P2
      idc_p3_io     : inout  std_logic_vector (31 downto 0);    --IDC_P3
      idc_p4_io     : inout  std_logic_vector (31 downto 0);    --IDC_P4
      idc_p5_io     : inout  std_logic_vector (31 downto 0);    --IDC_P5
      sma_io        : inout  std_logic_vector (8 downto 1);     --IDC_P5
      ti2c_sdat_io  : inout  std_logic_vector (2 downto 0)
   );

-- Declarations

end main_top_tester ;

--
architecture sim of main_top_tester is
begin
end architecture sim;

