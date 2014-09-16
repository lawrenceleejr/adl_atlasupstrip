-------------------------------------------------------------------------------
-- Sync MUX 128 LL streams
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library utils;
use utils.pkg_types.all;

library hsio;
use hsio.pkg_hsio_globals.all;

entity ll_smx128 is
  port(
    lls_o    : out t_llsrc;
    s_lls_i  : in  t_llsrc_array (127 downto 0);
    freeze_i : in  std_logic;
    sel_i    : in  std_logic_vector (6 downto 0);
    clk      : in  std_logic;
    rst      : in  std_logic
    );

-- Declarations

end ll_smx128;

architecture rtl of ll_smx128 is

  component ll_smx_unit
    port(
      sel_i    : in  std_logic;
      lls_o    : out t_llsrc;
      freeze_i : in  std_logic;
      s_lls_i  : in  t_llsrc_array(1 downto 0);
      rst      : in  std_logic;
      clk      : in  std_logic
      );
  end component;

  component ll_asmx_unit
    port(
      sel_i    : in    std_logic;
      lls_o    : inout t_llsrc;
      freeze_i : in    std_logic;
      s_lls_i  : inout t_llsrc_array(1 downto 0);
      rst      : in    std_logic;
      clk      : in    std_logic
      );
  end component;


  signal a_sel : slv8;
  signal a_ll  : t_llsrc;

  signal b_sel : slv8;
  signal b_ll  : t_llsrc_array(1 downto 0);

  signal c_sel : slv8;
  signal c_ll  : t_llsrc_array(3 downto 0);

  signal d_sel : slv8;
  signal d_ll  : t_llsrc_array(7 downto 0);

  signal e_sel : slv8;
  signal e_ll  : t_llsrc_array(15 downto 0);

  signal f_sel : slv8;
  signal f_ll  : t_llsrc_array(31 downto 0);

  signal g_sel : slv8;
  signal g_ll  : t_llsrc_array(63 downto 0);

  --signal h_sel : slv8;
  signal h_ll : t_llsrc_array(127 downto 0);




begin


  -- "IN"/Source IO Mapping
  h_ll <= s_lls_i;

  g_sel <= "0" & sel_i;


  -------------------------------------------------------------------------
  g_gen : for m6 in 0 to 63 generate
    muxg : ll_smx_unit
      port map (
        sel_i    => g_sel(0),
        freeze_i => freeze_i,
        s_lls_i  => h_ll((m6*2)+1 downto m6*2),
        lls_o    => g_ll(m6),
        rst      => rst,
        clk      => clk
        );
  end generate;

  f_sel <= g_sel when rising_edge(clk) and (freeze_i = '0');



  -------------------------------------------------------------------------
  f_gen : for m5 in 0 to 31 generate
    muxf : ll_smx_unit
      port map (
        sel_i    => f_sel(1),
        freeze_i => freeze_i,
        s_lls_i  => g_ll((m5*2)+1 downto m5*2),
        lls_o    => f_ll(m5),
        rst      => rst,
        clk      => clk
        );
  end generate;

  e_sel <= f_sel when rising_edge(clk) and (freeze_i = '0');


  
  ------------------------------------------------------------------------
  e_gen : for m4 in 0 to 15 generate
    muxe : ll_smx_unit
      port map (
        sel_i    => e_sel(2),
        freeze_i => freeze_i,
        s_lls_i  => f_ll((m4*2)+1 downto m4*2),
        lls_o    => e_ll(m4),
        rst      => rst,
        clk      => clk
        );
  end generate;

  d_sel <= e_sel  when rising_edge(clk) and (freeze_i = '0');

  
  
  -------------------------------------------------------------------------
  d_gen : for m3 in 0 to 7 generate
    muxd : ll_smx_unit
      port map (
        sel_i    => d_sel(3),
        freeze_i => freeze_i,
        s_lls_i  => e_ll((m3*2)+1 downto m3*2),
        lls_o    => d_ll(m3),
        rst      => rst,
        clk      => clk
        );
  end generate;

  c_sel <= d_sel when rising_edge(clk) and (freeze_i = '0');


  
  -------------------------------------------------------------------------
  c_gen : for m2 in 0 to 3 generate
    muxc : ll_smx_unit
      port map (
        sel_i    => c_sel(4),
        freeze_i => freeze_i,
        s_lls_i  => d_ll((m2*2)+1 downto m2*2),
        lls_o    => c_ll(m2),
        rst      => rst,
        clk      => clk
        );
  end generate;

  b_sel <= c_sel when rising_edge(clk) and (freeze_i = '0');

  

  -------------------------------------------------------------------------
  b_gen : for m1 in 0 to 1 generate
    muxb : ll_smx_unit
      port map (
        sel_i    => b_sel(5),
        freeze_i => freeze_i,
        s_lls_i  => c_ll((m1*2)+1 downto m1*2),
        lls_o    => b_ll(m1),
        rst      => rst,
        clk      => clk
        );
  end generate;

  a_sel <= b_sel when rising_edge(clk) and (freeze_i = '0');


  -------------------------------------------------------------------------
  muxa : ll_smx_unit
    port map (
      sel_i    => a_sel(6),
      freeze_i => freeze_i,
      s_lls_i  => b_ll(1 downto 0),
      lls_o    => a_ll,
      rst      => rst,
      clk      => clk
      );


  lls_o <= a_ll;


end rtl;
