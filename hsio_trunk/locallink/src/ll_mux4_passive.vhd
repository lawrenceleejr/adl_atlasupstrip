--
-- VHDL Architecture hsio.llmux_rx.rtl
--
-- Created:
--          by - warren.man (pc140.hep.ucl.ac.uk)
--          at - 11:37:32 03/04/10
--
-- using Mentor Graphics HDL Designer(TM) 2008.1b (Build 7)
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ll_mux4_passive is
   generic( 
      DATA_WIDTH : integer := 16
   );
   port( 
      -- Common
      sof_o      : out    std_logic;
      eof_o      : out    std_logic;
      src_rdy_o  : out    std_logic;
      dst_rdy_i  : in     std_logic;
      data_o     : out    std_logic_vector (DATA_WIDTH-1 downto 0);
      -- Port 0
      sof0_i     : in     std_logic;
      eof0_i     : in     std_logic;
      src_rdy0_i : in     std_logic;
      dst_rdy0_o : out    std_logic;
      data0_i    : in     std_logic_vector (DATA_WIDTH-1 downto 0);
      -- Port 1
      sof1_i     : in     std_logic;
      eof1_i     : in     std_logic;
      src_rdy1_i : in     std_logic;
      dst_rdy1_o : out    std_logic;
      data1_i    : in     std_logic_vector (DATA_WIDTH-1 downto 0);
      -- Port 2
      sof2_i     : in     std_logic;
      eof2_i     : in     std_logic;
      src_rdy2_i : in     std_logic;
      dst_rdy2_o : out    std_logic;
      data2_i    : in     std_logic_vector (DATA_WIDTH-1 downto 0);
      -- Port 3
      sof3_i     : in     std_logic;
      eof3_i     : in     std_logic;
      src_rdy3_i : in     std_logic;
      dst_rdy3_o : out    std_logic;
      data3_i    : in     std_logic_vector (DATA_WIDTH-1 downto 0);
      sel        : in     std_logic_vector (1 downto 0)
   );

-- Declarations

end ll_mux4_passive ;

--
architecture rtl of ll_mux4_passive is
begin


  dst_rdy0_o <= dst_rdy_i when (sel = "00") else '0';
  dst_rdy1_o <= dst_rdy_i when (sel = "01") else '0';
  dst_rdy2_o <= dst_rdy_i when (sel = "10") else '0';
  dst_rdy3_o <= dst_rdy_i when (sel = "11") else '0';


  sof_o       <= sof0_i when (sel = "00") else 
                 sof1_i when (sel = "01") else 
                 sof2_i when (sel = "10") else 
                 sof3_i;

  eof_o       <= eof0_i when (sel = "00") else 
                 eof1_i when (sel = "01") else 
                 eof2_i when (sel = "10") else 
                 eof3_i;
                 
  
  src_rdy_o   <= src_rdy0_i   when (sel = "00") else
                 src_rdy1_i   when (sel = "01") else
                 src_rdy2_i   when (sel = "10") else
                 src_rdy3_i;
                 
   data_o      <= data0_i      when (sel = "00") else
                 data1_i      when (sel = "01") else
                 data2_i      when (sel = "10") else
                 data3_i; 

end architecture rtl;

