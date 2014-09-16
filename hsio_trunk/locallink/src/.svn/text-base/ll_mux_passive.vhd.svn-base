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

ENTITY ll_mux_passive IS
   GENERIC( 
      DATA_WIDTH : integer := 16
   );
   PORT( 
      -- Common
      sof_o      : OUT    std_logic;
      eof_o      : OUT    std_logic;
      src_rdy_o  : OUT    std_logic;
      dst_rdy_i  : IN     std_logic;
      data_o     : OUT    std_logic_vector (DATA_WIDTH-1 DOWNTO 0);
      -- Port 0
      sof0_i     : IN     std_logic;
      eof0_i     : IN     std_logic;
      src_rdy0_i : IN     std_logic;
      dst_rdy0_o : OUT    std_logic;
      data0_i    : IN     std_logic_vector (DATA_WIDTH-1 DOWNTO 0);
      -- Port 1
      sof1_i     : IN     std_logic;
      eof1_i     : IN     std_logic;
      src_rdy1_i : IN     std_logic;
      dst_rdy1_o : OUT    std_logic;
      data1_i    : IN     std_logic_vector (DATA_WIDTH-1 DOWNTO 0);
      sel        : IN     std_logic
   );

-- Declarations

END ll_mux_passive ;

--
architecture rtl of ll_mux_passive is
begin


  dst_rdy0_o <= dst_rdy_i and not sel;
  dst_rdy1_o <= dst_rdy_i and sel;


  sof_o       <= sof1_i       when (sel = '1') else sof0_i;
  eof_o       <= eof1_i       when (sel = '1') else eof0_i;
  src_rdy_o   <= src_rdy1_i   when (sel = '1') else src_rdy0_i;
  data_o      <= data1_i      when (sel = '1') else data0_i;

end architecture rtl;

