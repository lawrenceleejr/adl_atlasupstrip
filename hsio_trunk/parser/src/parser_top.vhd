-- top.vhd
-- 
-- July 2009
-- Alexander Law (atlaw@law.gov)
-- Lawrence Berkeley National Laboratory

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

library UNISIM;
use UNISIM.VComponents.all;

entity parser_top is
   generic( 
      STREAM_ID : integer := 0
   );
   port( 
      rst           : in     std_logic;                       -- HSIO switch2, code_reload#
      en            : in     std_logic;
      abcdata_i     : in     std_logic;
      start_hstro_i : in     std_logic;
      reset_hst_i   : in     std_logic;
      debug_mode_i  : in     std_logic;
      ll_sof_o      : out    std_logic;
      ll_eof_o      : out    std_logic;
      ll_src_rdy_o  : out    std_logic;
      ll_dst_rdy_i  : in     std_logic;
      ll_data_o     : out    std_logic_vector (15 downto 0);
      clk           : in     std_logic
   );

-- Declarations

end parser_top ;

architecture rtl of parser_top is

  component dataGate
    port(
      clock   : in  std_logic;
      reset   : in  std_logic;
      dataBit : in  std_logic;
      outBit  : out std_logic;
      wrEnOut : out std_logic
      );
  end component;

  component parseBuffer
    port(
      clock         : in  std_logic;
      reset         : in  std_logic;
      wrEn          : in  std_logic;
      dataBitIn     : in  std_logic;
      rdPtr_in      : in  std_logic_vector(4 downto 0);
      fieldLen_in   : in  std_logic_vector(3 downto 0);
      data_out      : out std_logic_vector(7 downto 0);
      occ_out       : out std_logic_vector(5 downto 0);
      overflow_out  : out std_logic;
      underflow_out : out std_logic;
      readFlag      : in  std_logic
      );
  end component;

  component parser
    port(
      clock           : in  std_logic;
      reset           : in  std_logic;
      parseEn         : in  std_logic;
      chipType        : in  std_logic;
      addrOffset_in   : in  std_logic_vector(6 downto 0);
      dg_wrEn         : in  std_logic;
      -- testFlag        : out std_logic;
      pb_rdPtr_out    : out std_logic_vector(4 downto 0);
      pb_fieldLen_out : out std_logic_vector(3 downto 0);
      dataByte        : in  std_logic_vector(7 downto 0);
      pb_occ_in       : in  std_logic_vector (5 downto 0);
      hst_rdPtr_out   : out std_logic_vector(10 downto 0);
      hst_wrPtr_out   : out std_logic_vector(10 downto 0);
      hst_rdData_in   : in  std_logic_vector(15 downto 0);
      hst_wrData_out  : out std_logic_vector(15 downto 0);
      hst_wrEn_out    : out std_logic;
      read_from_pb    : out std_logic
      );
  end component;

  component histogram
    port (
      clka  : in  std_logic;
      wea   : in  std_logic_vector(0 downto 0);
      addra : in  std_logic_vector(10 downto 0);
      dina  : in  std_logic_vector(15 downto 0);
      douta : out std_logic_vector(15 downto 0);
      clkb  : in  std_logic;
      web   : in  std_logic_vector(0 downto 0);
      addrb : in  std_logic_vector(10 downto 0);
      dinb  : in  std_logic_vector(15 downto 0);
      doutb : out std_logic_vector(15 downto 0));
  end component;

  component readoutHist_sctdaq
    generic (
      STREAM_ID : integer
      );

    port(
      clk            : in  std_logic;
      rst            : in  std_logic;
      en             : in  std_logic;
      start_ro_i     : in  std_logic;
      ready_out      : out std_logic;
      debug_mode_i    : in  std_logic;
      hst_rdPtr_out  : out std_logic_vector(10 downto 0);
      hst_rdData_i     : in  std_logic_vector(15 downto 0);
      hst_wrPtr_out  : out std_logic_vector(10 downto 0);
      hst_wrData_out : out std_logic_vector(15 downto 0);
      hst_wrEn_out   : out std_logic;
      ll_sof_o       : out std_logic;
      ll_eof_o       : out std_logic;
      ll_src_rdy_o   : out std_logic;
      ll_dst_rdy_i   : in  std_logic;
      ll_data_o      : out std_logic_vector(15 downto 0)

      );
  end component;


  signal dg0_wrEn    : std_logic;
  signal dg0_dataBit : std_logic;

  signal pb0_rdPtr     : std_logic_vector(4 downto 0);  -- value range 0 to 31
  signal pb0_fieldLen  : std_logic_vector(3 downto 0);  -- value range 0 to 8
  signal pb0_dataByte  : std_logic_vector(7 downto 0);  -- byte-wide data bus
  signal pb0_occ       : std_logic_vector(5 downto 0);  -- value range 0 to 32
  signal pb0_overflow  : std_logic;
  signal pb0_underflow : std_logic;

  signal p0_testFlag     : std_logic;
  signal p0_read_from_pb : std_logic;

  signal hst0_rdPtr_p    : std_logic_vector(10 downto 0);
  signal hst0_rdPtr_hro  : std_logic_vector(10 downto 0);
  signal hst0_wrPtr_p    : std_logic_vector(10 downto 0);
  signal hst0_wrPtr_hro  : std_logic_vector(10 downto 0);
  signal hst0_wrData_p   : std_logic_vector(15 downto 0);
  signal hst0_wrData_hro : std_logic_vector(15 downto 0);
  signal hst0_wrEn_p     : std_logic;
  signal hst0_wrEn_hro   : std_logic;

  signal hst0_rdPtr  : std_logic_vector(10 downto 0);
  signal hst0_rdData : std_logic_vector(15 downto 0);
  signal hst0_wrPtr  : std_logic_vector(10 downto 0);
  signal hst0_wrdata : std_logic_vector(15 downto 0);
  signal hst0_wrEn   : std_logic_vector(0 downto 0);

  signal hro0_trigger : std_logic;
  signal hro0_ready   : std_logic;

  signal command0     : std_logic;
  signal command0_inv : std_logic;
  signal data9        : std_logic;

  signal sg0_state : std_logic_vector(3 downto 0);
  signal sg0_test  : std_logic;

  signal rst_local : std_logic;

-- signal reset_in_inv : std_logic;
-- signal clock_locked : std_logic;



  signal CHIP_TYPE : std_logic;  -- := '1';  -- ABCN , 0=ABCD
  --


  signal ZERO16 : std_logic_vector(15 downto 0);  -- := x"0000";
  signal ZERO8  : std_logic_vector(7 downto 0);   -- := x"00";
  signal ZERO00 : std_logic_vector(0 downto 0);   -- := "0";

  signal ADDR_OFFSET : std_logic_vector(6 downto 0);  -- := "0000110";  -- 6, works for test ABCD hybrid  

  signal hi : std_logic;                -- := '1';
  signal lo : std_logic;                -- := '0';



begin

  CHIP_TYPE <= '1';                     -- ABCN , 0=ABCD

  ZERO16      <= x"0000";
  ZERO8       <= x"00";
  ZERO00      <= "0";
  ADDR_OFFSET <= "0000110";             -- 6, works for test ABCD hybrid  

  hi <= '1';
  lo <= '0';


  rst_local <= rst or reset_hst_i;



  dg0 : dataGate
    port map(
      clock   => clk,
      reset   => rst_local,
      dataBit => data9,
      outBit  => dg0_dataBit,
      wrEnOut => dg0_wrEn
      );


  pb0 : parseBuffer
    port map(
      clock         => clk,
      reset         => rst_local,
      wrEn          => dg0_wrEn,
      dataBitIn     => dg0_dataBit,
      rdPtr_in      => pb0_rdPtr,
      fieldLen_in   => pb0_fieldLen,
      data_out      => pb0_dataByte,
      occ_out       => pb0_occ,
      overflow_out  => pb0_overflow,
      underflow_out => pb0_underflow,
      readFlag      => p0_read_from_pb
      );


  p0 : parser
    port map(
      clock           => clk,
      reset           => rst_local,
      parseEn         => en,            --'1',
      chipType        => CHIP_TYPE,     -- ***
      addrOffset_in   => ADDR_OFFSET,  --"0000110",  -- 6, works for test ABCD hybrid
      dg_wrEn         => dg0_wrEn,
      -- testFlag => p0_testFlag,
      pb_rdPtr_out    => pb0_rdPtr,
      pb_fieldLen_out => pb0_fieldLen,
      dataByte        => pb0_dataByte,
      pb_occ_in       => pb0_occ,
      hst_rdPtr_out   => hst0_rdPtr_p,
      hst_rdData_in   => hst0_rdData,
      hst_wrPtr_out   => hst0_wrPtr_p,
      hst_wrData_out  => hst0_wrData_p,
      hst_wrEn_out    => hst0_wrEn_p,
      read_from_pb    => p0_read_from_pb
      );


  hst0 : histogram
    port map(
      addra => hst0_wrPtr,
      addrb => hst0_rdPtr,
      clka  => clk,
      clkb  => clk,
      dina  => hst0_wrData,
      dinb  => ZERO16,                  --"0000000000000000",
      douta => open,
      doutb => hst0_rdData,
      wea   => hst0_wrEn,
      web   => ZERO00                   --"0"
      );
  with hro0_ready select hst0_rdPtr   <=
    hst0_rdPtr_hro  when '0',
    hst0_rdPtr_p    when others;
  with hro0_ready select hst0_wrPtr   <=
    hst0_wrPtr_hro  when '0',
    hst0_wrPtr_p    when others;
  with hro0_ready select hst0_wrData  <=
    hst0_wrData_hro when '0',
    hst0_wrData_p   when others;
  with hro0_ready select hst0_wrEn(0) <=
    hst0_wrEn_hro   when '0',
    hst0_wrEn_p     when others;


  hro0 : readoutHist_sctdaq
    generic map (
      STREAM_ID      => STREAM_ID
      )
    port map(
      clk            => clk,
      rst            => rst_local,
      en             => en,
      start_ro_i     => start_hstro_i,  --***hro0_trigger,
      ready_out      => hro0_ready,
      debug_mode_i   => debug_mode_i,      -- ***
      hst_rdPtr_out  => hst0_rdPtr_hro,
      hst_rdData_i   => hst0_rdData,
      hst_wrPtr_out  => hst0_wrPtr_hro,
      hst_wrData_out => hst0_wrData_hro,
      hst_wrEn_out   => hst0_wrEn_hro,

      ll_sof_o      => ll_sof_o,
      ll_eof_o      => ll_eof_o,
      ll_src_rdy_o  => ll_src_rdy_o,
      ll_dst_rdy_i  => ll_dst_rdy_i,
      ll_data_o     => ll_data_o
      );


  data9 <= abcdata_i;



-------------------------------------------------
-------------------------------------------------

end rtl;



