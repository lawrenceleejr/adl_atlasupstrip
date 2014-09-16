-------------------------------------------------------------------------------
-- MUX 2 LL streams, with arrays, async dst_rdy
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library utils;
use utils.pkg_types.all;

library hsio;
use hsio.pkg_hsio_globals.all;

entity ll_smx16 is
   port( 
      -- destination port
      data_o       : out    slv16;
      data_len_o   : out    slv16;
      sof_o        : out    std_logic;
      eof_o        : out    std_logic;
      src_rdy_o    : out    std_logic;
      freeze_i     : in     std_logic;
      -- source ports
      s_data_i     : in     slv16_array (15 downto 0);
      s_data_len_i : in     slv16_array (15 downto 0);
      s_sof_i      : in     std_logic_vector (15 downto 0);
      s_eof_i      : in     std_logic_vector (15 downto 0);
      s_src_rdy_i  : in     std_logic_vector (15 downto 0);
      --s_dst_rdy_o  : out std_logic_vector (15 downto 0);
      sel_i        : in     std_logic_vector (3 downto 0);
      clk          : in     std_logic;
      rst          : in     std_logic
   );

-- Declarations

end ll_smx16 ;

architecture rtl of ll_smx16 is

  component ll_smx_unit
    port(
      data_o       : out slv16;
      data_len_o   : out slv16;
      sof_o        : out std_logic;
      eof_o        : out std_logic;
      src_rdy_o    : out std_logic;
      freeze_i     : in  std_logic;
      s_data_i     : in  slv16_array(1 downto 0);
      s_data_len_i : in  slv16_array(1 downto 0);
      s_sof_i      : in  slv2;
      s_eof_i      : in  slv2;
      s_src_rdy_i  : in  slv2;
      --s_dst_rdy_o  : out slv2;
      sel_i        : in  std_logic;
      rst          : in  std_logic;
      clk          : in  std_logic
      );
  end component;


  signal a_sel      : std_logic_vector(3 downto 0);
  signal a_data     : slv16_array(0 downto 0);
  signal a_data_len : slv16_array(0 downto 0);
  signal a_sof      : std_logic_vector(0 downto 0);
  signal a_eof      : std_logic_vector(0 downto 0);
  signal a_src_rdy  : std_logic_vector(0 downto 0);
  --signal a_dst_rdy  : std_logic_vector(0 downto 0);

  signal b_sel      : std_logic_vector(3 downto 0);
  signal b_data     : slv16_array(1 downto 0);
  signal b_data_len : slv16_array(1 downto 0);
  signal b_sof      : std_logic_vector(1 downto 0);
  signal b_eof      : std_logic_vector(1 downto 0);
  signal b_src_rdy  : std_logic_vector(1 downto 0);
  --signal b_dst_rdy  : std_logic_vector(1 downto 0);

  signal c_sel      : std_logic_vector(3 downto 0);
  signal c_data     : slv16_array(3 downto 0);
  signal c_data_len : slv16_array(3 downto 0);
  signal c_sof      : std_logic_vector(3 downto 0);
  signal c_eof      : std_logic_vector(3 downto 0);
  signal c_src_rdy  : std_logic_vector(3 downto 0);
  --signal c_dst_rdy  : std_logic_vector(3 downto 0);


  signal d_sel      : std_logic_vector(3 downto 0);
  signal d_data     : slv16_array(7 downto 0);
  signal d_data_len : slv16_array(7 downto 0);
  signal d_sof      : std_logic_vector(7 downto 0);
  signal d_eof      : std_logic_vector(7 downto 0);
  signal d_src_rdy  : std_logic_vector(7 downto 0);
  --signal d_dst_rdy  : std_logic_vector(7 downto 0);

  --signal e_sel      : std_logic_vector(31 downto 0);
  signal e_data     : slv16_array(15 downto 0);
  signal e_data_len : slv16_array(15 downto 0);
  signal e_sof      : std_logic_vector(15 downto 0);
  signal e_eof      : std_logic_vector(15 downto 0);
  signal e_src_rdy  : std_logic_vector(15 downto 0);
  --signal e_dst_rdy  : std_logic_vector(15 downto 0);

begin

  d_sel <= sel_i;

  prc_sel_pipe : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        --d_sel   <= (others => '0');
        c_sel   <= (others => '0');
        b_sel   <= (others => '0');
        a_sel   <= (others => '0');
        
      else
        if (freeze_i = '0') then
          --d_sel <= sel_i;
          c_sel <= d_sel;
          b_sel <= c_sel;
          a_sel <= b_sel;
        end if;
      end if;
    end if;
  end process;



  -- "IN"/Source IO Mapping
  e_data     <= s_data_i;
  e_data_len <= s_data_len_i;
  e_sof      <= s_sof_i;
  e_eof      <= s_eof_i;
  e_src_rdy  <= s_src_rdy_i;
  --s_dst_rdy_o <= e_dst_rdy;



  d_gen  : for m3 in 0 to 7 generate
    muxd : ll_smx_unit
      port map (
        sel_i        => d_sel(0),
        data_o       => d_data(m3),
        data_len_o   => d_data_len(m3),
        sof_o        => d_sof(m3),
        eof_o        => d_eof(m3),
        src_rdy_o    => d_src_rdy(m3),
        freeze_i     => freeze_i,
        s_data_i     => e_data(m3*2+1 downto m3*2),
        s_data_len_i => e_data_len(m3*2+1 downto m3*2),
        s_sof_i      => e_sof(m3*2+1 downto m3*2),
        s_eof_i      => e_eof(m3*2+1 downto m3*2),
        s_src_rdy_i  => e_src_rdy(m3*2+1 downto m3*2),
        --s_dst_rdy_o  => e_dst_rdy(m3*2+1 downto m3*2),
        rst          => rst,
        clk          => clk
        );
  end generate;

  c_gen  : for m2 in 0 to 3 generate
    muxc : ll_smx_unit
      port map (
        sel_i        => c_sel(1),
        data_o       => c_data(m2),
        data_len_o   => c_data_len(m2),
        sof_o        => c_sof(m2),
        eof_o        => c_eof(m2),
        src_rdy_o    => c_src_rdy(m2),
        freeze_i     => freeze_i,
        s_data_i     => d_data(m2*2+1 downto m2*2),
        s_data_len_i => d_data_len(m2*2+1 downto m2*2),
        s_sof_i      => d_sof(m2*2+1 downto m2*2),
        s_eof_i      => d_eof(m2*2+1 downto m2*2),
        s_src_rdy_i  => d_src_rdy(m2*2+1 downto m2*2),
        --s_dst_rdy_o  => d_dst_rdy(m2*2+1 downto m2*2),
        rst          => rst,
        clk          => clk
        );
  end generate;

  b_gen  : for m1 in 0 to 1 generate
    muxb : ll_smx_unit
      port map (
        sel_i        => b_sel(2),
        data_o       => b_data(m1),
        data_len_o   => b_data_len(m1),
        sof_o        => b_sof(m1),
        eof_o        => b_eof(m1),
        src_rdy_o    => b_src_rdy(m1),
        freeze_i     => freeze_i,
        s_data_i     => c_data(m1*2+1 downto m1*2),
        s_data_len_i => c_data_len(m1*2+1 downto m1*2),
        s_sof_i      => c_sof(m1*2+1 downto m1*2),
        s_eof_i      => c_eof(m1*2+1 downto m1*2),
        s_src_rdy_i  => c_src_rdy(m1*2+1 downto m1*2),
        --s_dst_rdy_o  => c_dst_rdy(m1*2+1 downto m1*2),
        rst          => rst,
        clk          => clk
        );
  end generate;


  muxa : ll_smx_unit
    port map (
      sel_i        => a_sel(3),
      data_o       => data_o,
      data_len_o   => data_len_o,
      sof_o        => sof_o,
      eof_o        => eof_o,
      src_rdy_o    => src_rdy_o,
      freeze_i     => freeze_i,
      s_data_i     => b_data(1 downto 0),
      s_data_len_i => b_data_len(1 downto 0),
      s_sof_i      => b_sof(1 downto 0),
      s_eof_i      => b_eof(1 downto 0),
      s_src_rdy_i  => b_src_rdy(1 downto 0),
      --s_dst_rdy_o  => b_dst_rdy(1 downto 0),
      rst          => rst,
      clk          => clk
      );


end rtl;
