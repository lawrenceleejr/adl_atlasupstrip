-- VHDL Entity locallink.ll_syncmux16.symbol
--
-- Created by Matt Warren 2014
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2013.1 (Build 6)
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library hsio;
use hsio.pkg_hsio_globals.all;
library utils;
use utils.pkg_types.all;

entity ll_syncmux16 is
   port( 
      clk            : in     std_logic;
      dst_rdy_i      : in     std_logic;
      rst            : in     std_logic;
      s_data_i       : in     slv16_array (15 downto 0);
      s_data_len_i   : in     slv16_array (15 downto 0);
      s_eof_i        : in     std_logic_vector (15 downto 0);
      s_sof_i        : in     std_logic_vector (15 downto 0);
      s_src_rdy_i    : in     std_logic_vector (15 downto 0);
      data_len_o     : out    slv16;
      data_o         : out    slv16;
      eof_o          : out    std_logic;
      s_dst_rdy_o    : out    std_logic_vector (15 downto 0);
      selected_str_o : out    std_logic_vector (3 downto 0);
      sof_o          : out    std_logic;
      src_rdy_o      : out    std_logic
   );

-- Declarations

end ll_syncmux16 ;

-- VHDL from Block Diagram 
-- Generated by Mentor Graphics HDL Designer(TM) 2013.1 (Build 6) 
--
-- locallink.ll_syncmux16.struct
--
-- Created by Matt Warren 2014
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library hsio;
use hsio.pkg_hsio_globals.all;

library utils;
use utils.pkg_types.all;


architecture struct of ll_syncmux16 is

   -- Architecture declarations

   -- Internal signal declarations
   signal freeze : std_logic;
   signal sel    : std_logic_vector(3 downto 0);


   -- Component Declarations
   component ll_smx16
   port (
      -- destination port
      data_o       : out    slv16 ;
      data_len_o   : out    slv16 ;
      sof_o        : out    std_logic ;
      eof_o        : out    std_logic ;
      src_rdy_o    : out    std_logic ;
      freeze_i     : in     std_logic ;
      -- source ports
      s_data_i     : in     slv16_array (15 downto 0);
      s_data_len_i : in     slv16_array (15 downto 0);
      s_sof_i      : in     std_logic_vector (15 downto 0);
      s_eof_i      : in     std_logic_vector (15 downto 0);
      s_src_rdy_i  : in     std_logic_vector (15 downto 0);
      --s_dst_rdy_o  : out std_logic_vector (15 downto 0);
      sel_i        : in     std_logic_vector (3 downto 0);
      clk          : in     std_logic ;
      rst          : in     std_logic 
   );
   end component;


begin

   -- ModuleWare code(v1.12) for instance 'U_0' of 'buff'
   selected_str_o <= sel;

   -- Instance port mappings.
   Usmx16 : ll_smx16
      port map (
         data_o       => data_o,
         data_len_o   => data_len_o,
         sof_o        => sof_o,
         eof_o        => eof_o,
         src_rdy_o    => src_rdy_o,
         freeze_i     => freeze,
         s_data_i     => s_data_i,
         s_data_len_i => s_data_len_i,
         s_sof_i      => s_sof_i,
         s_eof_i      => s_eof_i,
         s_src_rdy_i  => s_src_rdy_i,
         sel_i        => sel,
         clk          => clk,
         rst          => rst
      );

end struct;
