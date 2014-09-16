library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library UNISIM;
use UNISIM.Vcomponents.all;


entity hsio_ibc09_test is
  port(
    -- CLOCKS
    clk_xtal_125_mi : in std_logic;     --CRYSTAL_CLK_M
    clk_xtal_125_pi : in std_logic;     --CRYSTAL_CLK_P

    ibs09_convst_n_o  : out   std_logic_vector(2 downto 0);  -- fpga net/pin:GPIO_14/J25; hsio z3 conn/pin:J25/G4
    ibs09_scl_o       : out   std_logic_vector(2 downto 0);  -- fpga net/pin:GPIO_15/J25; hsio z3 conn/pin:J25/H4
    ibs09_sda_io      : inout std_logic_vector(2 downto 0);  -- fpga net/pin:GPIO_16/J25; hsio z3 conn/pin:J25/A5
    ibs09_convstt_n_o : out   std_logic_vector(2 downto 0);  -- fpga net/pin:GPIO_24/J25; hsio z3 conn/pin:J25/A6
    ibs09_sclt_o      : out   std_logic_vector(2 downto 0);  -- fpga net/pin:GPIO_25/J25; hsio z3 conn/pin:J25/B6
    ibs09_sdat_io     : inout std_logic_vector(2 downto 0);  -- fpga net/pin:GPIO_26/J25; hsio z3 conn/pin:J25/C6

    ibs09_slc_wire_o   : out   std_logic;  -- fpga net/pin:GPIO_28/J25; hsio z3 conn/pin:J25/E6
    ibs09_sda_wire_io  : inout std_logic;  -- fpga net/pin:GPIO_29/J25; hsio z3 conn/pin:J25/F6
    ibs09_slc_wiret_o  : out   std_logic;  -- fpga net/pin:GPIO_30/J25; hsio z3 conn/pin:J25/G6
    ibs09_sda_wiret_io : inout std_logic;  -- fpga net/pin:GPIO_31/J25; hsio z3 conn/pin:J25/H6

    ibs09_bcot_po : out std_logic;      -- fpga net/pin:J26_LVDS_0_P/J26; hsio z3 conn/pin:J26/A1
    ibs09_bcot_mo : out std_logic;      -- fpga net/pin:J26_LVDS_0_M/J26; hsio z3 conn/pin:J26/B1
    ibs09_cmdt_po : out std_logic;      -- fpga net/pin:J26_LVDS_1_P/J26; hsio z3 conn/pin:J26/C1
    ibs09_cmdt_mo : out std_logic;      -- fpga net/pin:J26_LVDS_1_M/J26; hsio z3 conn/pin:J26/D1
    ibs09_l1rt_po : out std_logic;      -- fpga net/pin:J26_LVDS_2_P/J26; hsio z3 conn/pin:J26/E1
    ibs09_l1rt_mo : out std_logic;      -- fpga net/pin:J26_LVDS_2_M/J26; hsio z3 conn/pin:J26/F1

    ibs09_dot_pi : in std_logic_vector(23 downto 0);  -- fpga net/pin:J26_LVDS_26_P/J26; hsio z3 conn/pin:J26/E7
    ibs09_dot_mi : in std_logic_vector(23 downto 0);  -- fpga net/pin:J26_LVDS_26_M/J26; hsio z3 conn/pin:J26/F7

    ibs09_spia_do_pi   : in  std_logic;  -- fpga net/pin:J26_LVDS_27_P/J26; hsio z3 conn/pin:J26/G7
    ibs09_spia_do_mi   : in  std_logic;  -- fpga net/pin:J26_LVDS_27_M/J26; hsio z3 conn/pin:J26/H7
    ibs09_spia_clk_po  : out std_logic;  -- fpga net/pin:J26_LVDS_28_P/J26; hsio z3 conn/pin:J26/A8
    ibs09_spia_clk_mo  : out std_logic;  -- fpga net/pin:J26_LVDS_28_M/J26; hsio z3 conn/pin:J26/B8
    ibs09_spia_com_po  : out std_logic;  -- fpga net/pin:J26_LVDS_29_P/J26; hsio z3 conn/pin:J26/C8
    ibs09_spia_com_mo  : out std_logic;  -- fpga net/pin:J26_LVDS_29_M/J26; hsio z3 conn/pin:J26/D8
    ibs09_spita_do_pi  : in  std_logic;  -- fpga net/pin:J26_LVDS_30_P/J26; hsio z3 conn/pin:J26/E8
    ibs09_spita_do_mi  : in  std_logic;  -- fpga net/pin:J26_LVDS_30_M/J26; hsio z3 conn/pin:J26/F8
    ibs09_spita_clk_po : out std_logic;  -- fpga net/pin:J26_LVDS_31_P/J26; hsio z3 conn/pin:J26/G8
    ibs09_spita_clk_mo : out std_logic;  -- fpga net/pin:J26_LVDS_31_M/J26; hsio z3 conn/pin:J26/H8
    ibs09_spita_com_po : out std_logic;  -- fpga net/pin:J26_LVDS_32_P/J26; hsio z3 conn/pin:J26/A9
    ibs09_spita_com_mo : out std_logic;  -- fpga net/pin:J26_LVDS_32_M/J26; hsio z3 conn/pin:J26/B9

    ibs09_bco_po : out std_logic;       -- fpga net/pin:J27_LVDS_0_P/J27; hsio z3 conn/pin:J27/A1
    ibs09_bco_mo : out std_logic;       -- fpga net/pin:J27_LVDS_0_M/J27; hsio z3 conn/pin:J27/B1
    ibs09_cmd_po : out std_logic;       -- fpga net/pin:J27_LVDS_1_P/J27; hsio z3 conn/pin:J27/C1
    ibs09_cmd_mo : out std_logic;       -- fpga net/pin:J27_LVDS_1_M/J27; hsio z3 conn/pin:J27/D1
    ibs09_l1r_po : out std_logic;       -- fpga net/pin:J27_LVDS_2_P/J27; hsio z3 conn/pin:J27/E1
    ibs09_l1r_mo : out std_logic;       -- fpga net/pin:J27_LVDS_2_M/J27; hsio z3 conn/pin:J27/F1

    ibs09_do_pi : in std_logic_vector(23 downto 0);  -- fpga net/pin:J27_LVDS_26_P/J27; hsio z3 conn/pin:J27/E7
    ibs09_do_mi : in std_logic_vector(23 downto 0);  -- fpga net/pin:J27_LVDS_26_M/J27; hsio z3 conn/pin:J27/F7



	ibpp0_testi_pi : in std_logic_vector(3 downto 0); -- fpga net/pin:J27_LVDS_38_P/J27; hsio z3 conn/pin:J27/E10
	ibpp0_testi_mi : in std_logic_vector(3 downto 0); -- fpga net/pin:J27_LVDS_38_M/J27; hsio z3 conn/pin:J27/F10
	ibpp0_testo_po : out std_logic_vector(9 downto 0); -- fpga net/pin:J27_LVDS_39_P/J27; hsio z3 conn/pin:J27/G10
	ibpp0_testo_mo : out std_logic_vector(9 downto 0); -- fpga net/pin:J27_LVDS_39_M/J27; hsio z3 conn/pin:J27/H10


	ibclk_osc0_pi : in std_logic; -- fpga net/pin:GC_IO_0_P/J25; hsio z3 conn/pin:J25/A10
	ibclk_osc0_mi : in std_logic; -- fpga net/pin:GC_IO_0_M/J25; hsio z3 conn/pin:J25/B10
	ibclk_osc1_pi : in std_logic; -- fpga net/pin:GC_IO_1_P/J25; hsio z3 conn/pin:J25/C10
	ibclk_osc1_mi : in std_logic; -- fpga net/pin:GC_IO_1_M/J25; hsio z3 conn/pin:J25/D10


   rst_poweron_ni : in std_logic       --PORESET_N


    );

-- Declarations

end hsio_ibc09_test;


architecture rtl of hsio_ibc09_test is
  signal clk125 : std_logic;

  component IBUFDS
    generic (
      CAPACITANCE      :     string  := "DONT_CARE";
      DIFF_TERM        :     boolean := false;
      IBUF_DELAY_VALUE :     string  := "0";
      IFD_DELAY_VALUE  :     string  := "AUTO";
      IOSTANDARD       :     string  := "DEFAULT"
      );
    port (
      I                : in  std_ulogic;
      IB               : in  std_ulogic;
      O                : out std_ulogic
      );
  end component;

  component IBUFGDS
    generic (
      CAPACITANCE      :     string  := "DONT_CARE";
      DIFF_TERM        :     boolean := false;
      IBUF_DELAY_VALUE :     string  := "0";
      IOSTANDARD       :     string  := "DEFAULT"
      );
    port (
      I                : in  std_ulogic;
      IB               : in  std_ulogic;
      O                : out std_ulogic
      );
  end component;

  component OBUFDS
    generic (
      CAPACITANCE      :     string  := "DONT_CARE";
      IOSTANDARD       :     string  := "DEFAULT"
      );
    port (
      I                : in  std_ulogic;
      O                : out std_ulogic;
      OB               : out std_ulogic
      );
  end component;

  signal ibs09_bco : std_logic;
  signal ibs09_cmd : std_logic;
  signal ibs09_l1r : std_logic;

  signal ibs09_bcot : std_logic;
  signal ibs09_cmdt : std_logic;
  signal ibs09_l1rt : std_logic;

  signal ibs09_dot : std_logic_vector(23 downto 0);
  signal ibs09_do  : std_logic_vector(23 downto 0);

  signal ibs09_spia_do  : std_logic;
  signal ibs09_spia_clk : std_logic;
  signal ibs09_spia_com : std_logic;

  signal ibs09_spita_do  : std_logic;
  signal ibs09_spita_clk : std_logic;
  signal ibs09_spita_com : std_logic;

  signal testi : std_logic_vector(3 downto 0);
  signal testo : std_logic_vector(9 downto 0);

  signal ib_clk0 : std_logic;
  signal ib_clk1 : std_logic;


  signal reset : std_logic;

begin

  reset <= not(rst_poweron_ni);

  Uibufgds : IBUFGDS
    port map (
      O                => clk125,
      I                => clk_xtal_125_pi,
      IB               => clk_xtal_125_mi
      );

  Ubco : OBUFDS
    port map (
      O  => ibs09_bco_po,
      OB => ibs09_bco_mo,
      I  => ibs09_bco
      );
  Ucmd : OBUFDS
    port map (
      O  => ibs09_cmd_po,
      OB => ibs09_cmd_mo,
      I  => ibs09_cmd
      );
  Ul1r : OBUFDS
    port map (
      O  => ibs09_l1r_po,
      OB => ibs09_l1r_mo,
      I  => ibs09_l1r
      );

  do_gen : for n in 0 to 23 generate
    Udo  : IBUFDS
      port map (
        O  => ibs09_do(n),
        I  => ibs09_do_pi(n),
        IB => ibs09_do_mi(n)
        );
  end generate;

  ibs09_bco <= clk125;
  ibs09_cmd <= '1' when ibs09_do = x"000000" else '0';
  ibs09_l1r <= '1' when ibs09_do = x"000000" else '0';

  Ubcot : OBUFDS
    port map (
      O  => ibs09_bcot_po,
      OB => ibs09_bcot_mo,
      I  => ibs09_bcot
      );

  Ucmdt : OBUFDS
    port map (
      O  => ibs09_cmdt_po,
      OB => ibs09_cmdt_mo,
      I  => ibs09_cmdt
      );

  Ul1rt : OBUFDS
    port map (
      O  => ibs09_l1rt_po,
      OB => ibs09_l1rt_mo,
      I  => ibs09_l1rt
      );

  dot_gen : for nt in 0 to 23 generate
    Udot  : IBUFDS
      port map (
        O  => ibs09_dot(nt),
        I  => ibs09_dot_pi(nt),
        IB => ibs09_dot_mi(nt)
        );
  end generate;

  ibs09_bcot <= clk125;
  ibs09_cmdt <= '1' when ibs09_dot = x"000000" else '0';
  ibs09_l1rt <= '1' when ibs09_dot = x"000000" else '0';


  ibs09_convst_n_o <= ibs09_sda_io;
  ibs09_scl_o      <= ibs09_sda_io;
  ibs09_sda_io     <= "111" when reset = '1' else "ZZZ";

  ibs09_convstt_n_o <= ibs09_sdat_io;
  ibs09_sclt_o      <= ibs09_sdat_io;
  ibs09_sdat_io     <= "111" when reset = '1' else "ZZZ";


  ibs09_slc_wire_o  <= ibs09_sda_wire_io;
  ibs09_sda_wire_io <= '1' when reset = '1' else 'Z';

  ibs09_slc_wiret_o  <= ibs09_sda_wiret_io;
  ibs09_sda_wiret_io <= '1' when reset = '1' else 'Z';


  Uspia_clk : OBUFDS
    port map (
      O  => ibs09_spia_clk_po,
      OB => ibs09_spia_clk_mo,
      I  => ibs09_spia_clk
      );

  Uspia_com : OBUFDS
    port map (
      O  => ibs09_spia_com_po,
      OB => ibs09_spia_com_mo,
      I  => ibs09_spia_com
      );

  Uspia_do : IBUFDS
    port map (
      O  => ibs09_spia_do,
      I  => ibs09_spia_do_pi,
      IB => ibs09_spia_do_mi
      );


  ibs09_spia_clk <= ib_clk0;
  ibs09_spia_com <= ibs09_spia_do;



  Uspita_clk : OBUFDS
    port map (
      O  => ibs09_spita_clk_po,
      OB => ibs09_spita_clk_mo,
      I  => ibs09_spita_clk
      );

  Uspita_com : OBUFDS
    port map (
      O  => ibs09_spita_com_po,
      OB => ibs09_spita_com_mo,
      I  => ibs09_spita_com
      );

  Uspita_do : IBUFDS
    PORT MAP (
      O  => ibs09_spita_do,
      I  => ibs09_spita_do_pi,
      IB => ibs09_spita_do_mi
      );

  ibs09_spita_clk <= ib_clk1;
  ibs09_spita_com <= ibs09_spita_do;




  -- IDC16 test connects

  testi_gen : for n in 0 to 3 generate
    Utesti  : IBUFDS
      port map (
        O  => testi(n),
        I  => ibpp0_testi_pi(n),
        IB => ibpp0_testi_mi(n)
        );
  end generate;

  testo_gen : for n in 0 to 9 generate
    Utesto  : OBUFDS
    port map (
			O  => ibpp0_testo_po(n),
         OB => ibpp0_testo_mo(n),
         I  => testo(n)
			);
  end generate;

  testo <= "1111111111" when testi = "1111" else "0000000000";

  Uibosc0 : IBUFGDS
    port map (
      O                => ib_clk0,
      I                => ibclk_osc0_pi,
      IB               => ibclk_osc0_mi
      );

Uibosc1: IBUFGDS
    port map (
      O                => ib_clk1,
      I                => ibclk_osc1_pi,
      IB               => ibclk_osc1_mi
      );
 

END rtl;
