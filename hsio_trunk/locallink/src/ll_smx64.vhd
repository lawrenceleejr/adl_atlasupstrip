-------------------------------------------------------------------------------
-- Sync MUX 64 LL streams
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library utils;
use utils.pkg_types.all;

library hsio;
use hsio.pkg_hsio_globals.all;

entity ll_smx64 is
  port(
    -- destination port
    data_o      : out slv16;
    sof_o       : out std_logic;
    eof_o       : out std_logic;
    src_rdy_o   : out std_logic;
    freeze_i    : in  std_logic;
    -- source ports
    s_data_i    : in  slv16_array (63 downto 0);
    s_sof_i     : in  std_logic_vector (63 downto 0);
    s_eof_i     : in  std_logic_vector (63 downto 0);
    s_src_rdy_i : in  std_logic_vector (63 downto 0);
    sel_i       : in  std_logic_vector (5 downto 0);
    clk         : in  std_logic;
    rst         : in  std_logic
    );

-- Declarations

end ll_smx64;

architecture rtl of ll_smx64 is

  component ll_smx_unit
    port(
      sel_i       : in  std_logic;
      data_o      : out slv16;
      sof_o       : out std_logic;
      eof_o       : out std_logic;
      src_rdy_o   : out std_logic;
      freeze_i    : in  std_logic;
      s_data_i    : in  slv16_array(1 downto 0);
      s_sof_i     : in  slv2;
      s_eof_i     : in  slv2;
      s_src_rdy_i : in  slv2;
      rst         : in  std_logic;
      clk         : in  std_logic
      );
  end component;

  component ll_asmx_unit
    port(
      sel_i       : in  std_logic;
      data_o      : out slv16;
      sof_o       : out std_logic;
      eof_o       : out std_logic;
      src_rdy_o   : out std_logic;
      freeze_i    : in  std_logic;
      s_data_i    : in  slv16_array(1 downto 0);
      s_sof_i     : in  slv2;
      s_eof_i     : in  slv2;
      s_src_rdy_i : in  slv2;
      rst         : in  std_logic;
      clk         : in  std_logic
      );
  end component;


  signal a_sel     : slv8;
  signal a_data    : slv16;
  signal a_sof     : std_logic;
  signal a_eof     : std_logic;
  signal a_src_rdy : std_logic;

  signal b_sel     : slv8;
  signal b_data    : slv16_array(1 downto 0);
  signal b_sof     : std_logic_vector(1 downto 0);
  signal b_eof     : std_logic_vector(1 downto 0);
  signal b_src_rdy : std_logic_vector(1 downto 0);

  signal c_sel     : slv8;
  signal c_data    : slv16_array(3 downto 0);
  signal c_sof     : std_logic_vector(3 downto 0);
  signal c_eof     : std_logic_vector(3 downto 0);
  signal c_src_rdy : std_logic_vector(3 downto 0);

  signal d_sel     : slv8;
  signal d_data    : slv16_array(7 downto 0);
  signal d_sof     : std_logic_vector(7 downto 0);
  signal d_eof     : std_logic_vector(7 downto 0);
  signal d_src_rdy : std_logic_vector(7 downto 0);

  signal e_sel     : slv8;
  signal e_data    : slv16_array(15 downto 0);
  signal e_sof     : std_logic_vector(15 downto 0);
  signal e_eof     : std_logic_vector(15 downto 0);
  signal e_src_rdy : std_logic_vector(15 downto 0);

  signal fe_sel     : slv8;

  signal f_sel     : slv8;
  signal f_data    : slv16_array(31 downto 0);
  signal f_sof     : std_logic_vector(31 downto 0);
  signal f_eof     : std_logic_vector(31 downto 0);
  signal f_src_rdy : std_logic_vector(31 downto 0);

  signal g_sel     : slv8;
  signal g_data    : slv16_array(63 downto 0);
  signal g_sof     : std_logic_vector(63 downto 0);
  signal g_eof     : std_logic_vector(63 downto 0);
  signal g_src_rdy : std_logic_vector(63 downto 0);

   

begin


  -- "IN"/Source IO Mapping
  g_data    <= s_data_i;
  g_sof     <= s_sof_i;
  g_eof     <= s_eof_i;
  g_src_rdy <= s_src_rdy_i;
  
  f_sel     <= "00" & sel_i;
  

  -------------------------------------------------------------------------
  f_gen  : for m5 in 0 to 31 generate
    muxd : ll_smx_unit
    port map (
      sel_i    => f_sel(0),
      freeze_i => freeze_i,

      s_data_i    => g_data(m5*2+1 downto m5*2),
      s_sof_i     => g_sof(m5*2+1 downto m5*2),
      s_eof_i     => g_eof(m5*2+1 downto m5*2),
      s_src_rdy_i => g_src_rdy(m5*2+1 downto m5*2),

      data_o    => f_data(m5),
      sof_o     => f_sof(m5),
      eof_o     => f_eof(m5),
      src_rdy_o => f_src_rdy(m5),

      rst => rst,
      clk => clk
      );
  end generate;

  e_sel <= f_sel when rising_edge(clk) and (freeze_i = '0');


  ------------------------------------------------------------------------
  e_gen  : for m4 in 0 to 15 generate
    muxd : ll_asmx_unit
    port map (
      sel_i    => e_sel(1),
      freeze_i => freeze_i,

      s_data_i    => f_data(m4*2+1 downto m4*2),
      s_sof_i     => f_sof(m4*2+1 downto m4*2),
      s_eof_i     => f_eof(m4*2+1 downto m4*2),
      s_src_rdy_i => f_src_rdy(m4*2+1 downto m4*2),

      data_o    => e_data(m4),
      sof_o     => e_sof(m4),
      eof_o     => e_eof(m4),
      src_rdy_o => e_src_rdy(m4),

      rst => rst,
      clk => clk
      );
  end generate;

  d_sel <= e_sel;--  when rising_edge(clk) and (freeze_i = '0');
  
  -------------------------------------------------------------------------
  d_gen  : for m3 in 0 to 7 generate
    muxd : ll_smx_unit
    port map (
      sel_i    => d_sel(2),
      freeze_i => freeze_i,

      s_data_i    => e_data(m3*2+1 downto m3*2),
      s_sof_i     => e_sof(m3*2+1 downto m3*2),
      s_eof_i     => e_eof(m3*2+1 downto m3*2),
      s_src_rdy_i => e_src_rdy(m3*2+1 downto m3*2),

      data_o    => d_data(m3),
      sof_o     => d_sof(m3),
      eof_o     => d_eof(m3),
      src_rdy_o => d_src_rdy(m3),

      rst => rst,
      clk => clk
      );
  end generate;

  c_sel <= d_sel when rising_edge(clk) and (freeze_i = '0');


  -------------------------------------------------------------------------
  c_gen  : for m2 in 0 to 3 generate
    muxc : ll_asmx_unit
    port map (
      sel_i    => c_sel(3),
      freeze_i => freeze_i,

      s_data_i    => d_data(m2*2+1 downto m2*2),
      s_sof_i     => d_sof(m2*2+1 downto m2*2),
      s_eof_i     => d_eof(m2*2+1 downto m2*2),
      s_src_rdy_i => d_src_rdy(m2*2+1 downto m2*2),

      data_o    => c_data(m2),
      sof_o     => c_sof(m2),
      eof_o     => c_eof(m2),
      src_rdy_o => c_src_rdy(m2),

      rst => rst,
      clk => clk
      );
  end generate;

  b_sel <= c_sel; -- when rising_edge(clk) and (freeze_i = '0');


  -------------------------------------------------------------------------
  b_gen  : for m1 in 0 to 1 generate
    muxb : ll_smx_unit
      port map (
      sel_i    => b_sel(4),
      freeze_i => freeze_i,

      s_data_i    => c_data(m1*2+1 downto m1*2),
      s_sof_i     => c_sof(m1*2+1 downto m1*2),
      s_eof_i     => c_eof(m1*2+1 downto m1*2),
      s_src_rdy_i => c_src_rdy(m1*2+1 downto m1*2),

      data_o    => b_data(m1),
      sof_o     => b_sof(m1),
      eof_o     => b_eof(m1),
      src_rdy_o => b_src_rdy(m1),

      rst => rst,
      clk => clk
      );
  end generate;

  a_sel <= b_sel  when rising_edge(clk) and (freeze_i = '0');


  -------------------------------------------------------------------------
  muxa : ll_smx_unit
  port map (
    sel_i    => a_sel(5),
    freeze_i => freeze_i,

    s_data_i    => b_data(1 downto 0),
    s_sof_i     => b_sof(1 downto 0),
    s_eof_i     => b_eof(1 downto 0),
    s_src_rdy_i => b_src_rdy(1 downto 0),

    data_o    => a_data,
    sof_o     => a_sof,
    eof_o     => a_eof,
    src_rdy_o => a_src_rdy,

    rst => rst,
    clk => clk
    );


    data_o <= a_data;
    sof_o  <= a_sof;
    eof_o  <= a_eof;
    src_rdy_o  <= a_src_rdy;

  
end rtl;
