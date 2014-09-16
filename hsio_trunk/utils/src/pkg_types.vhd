-- Useful Types
--
--
--

library ieee;
use ieee.std_logic_1164.all;

package pkg_types is

  subtype sl is std_logic;
  
  subtype slv1 is std_logic_vector(0 downto 0);
  subtype slv2 is std_logic_vector(1 downto 0);
  subtype slv3 is std_logic_vector(2 downto 0);
  subtype slv4 is std_logic_vector(3 downto 0);
  subtype slv5 is std_logic_vector(4 downto 0);
  subtype slv6 is std_logic_vector(5 downto 0);
  subtype slv7 is std_logic_vector(6 downto 0);
  subtype slv8 is std_logic_vector(7 downto 0);
  subtype slv9 is std_logic_vector(8 downto 0);
  subtype slv10 is std_logic_vector(9 downto 0);
  subtype slv11 is std_logic_vector(10 downto 0);
  subtype slv12 is std_logic_vector(11 downto 0);
  subtype slv13 is std_logic_vector(12 downto 0);
  subtype slv14 is std_logic_vector(13 downto 0);
  subtype slv15 is std_logic_vector(14 downto 0);
  subtype slv16 is std_logic_vector(15 downto 0);
  subtype slv17 is std_logic_vector(16 downto 0);
  subtype slv18 is std_logic_vector(17 downto 0);
  subtype slv19 is std_logic_vector(18 downto 0);
  subtype slv20 is std_logic_vector(19 downto 0);
  subtype slv21 is std_logic_vector(20 downto 0);
  subtype slv22 is std_logic_vector(21 downto 0);
  subtype slv23 is std_logic_vector(22 downto 0);
  subtype slv24 is std_logic_vector(23 downto 0);
  subtype slv25 is std_logic_vector(24 downto 0);
  subtype slv26 is std_logic_vector(25 downto 0);
  subtype slv27 is std_logic_vector(26 downto 0);
  subtype slv28 is std_logic_vector(27 downto 0);
  subtype slv29 is std_logic_vector(28 downto 0);
  subtype slv30 is std_logic_vector(29 downto 0);
  subtype slv31 is std_logic_vector(30 downto 0);
  subtype slv32 is std_logic_vector(31 downto 0);
  subtype slv33 is std_logic_vector(32 downto 0);
  subtype slv36 is std_logic_vector(35 downto 0);
  subtype slv48 is std_logic_vector(47 downto 0);
  subtype slv64 is std_logic_vector(63 downto 0);
  subtype slv65 is std_logic_vector(64 downto 0);
  subtype slv66 is std_logic_vector(65 downto 0);
  subtype slv68 is std_logic_vector(67 downto 0);
  subtype slv96 is std_logic_vector(95 downto 0);
  subtype slv100 is std_logic_vector(99 downto 0);
  subtype slv104 is std_logic_vector(103 downto 0);
  subtype slv108 is std_logic_vector(107 downto 0);
  subtype slv112 is std_logic_vector(111 downto 0);
  subtype slv128 is std_logic_vector(127 downto 0);
  subtype slv136 is std_logic_vector(135 downto 0);
  subtype slv144 is std_logic_vector(143 downto 0);
  subtype slv256 is std_logic_vector(255 downto 0);

  type slv1_array is array (natural range <>) of slv1;
  type slv2_array is array (natural range <>) of slv2;
  type slv3_array is array (natural range <>) of slv3;
  type slv4_array is array (natural range <>) of slv4;
  type slv5_array is array (natural range <>) of slv5;
  type slv6_array is array (natural range <>) of slv6;
  type slv7_array is array (natural range <>) of slv7;
  type slv8_array is array (natural range <>) of slv8;
  type slv15_array is array (natural range <>) of slv15;
  type slv16_array is array (natural range <>) of slv16;
  type slv28_array is array (natural range <>) of slv28;
  type slv32_array is array (natural range <>) of slv32;
  type slv48_array is array (natural range <>) of slv48;
  type slv64_array is array (natural range <>) of slv64;
  type slv128_array is array (natural range <>) of slv128;
  type slv256_array is array (natural range <>) of slv256;


  type integer_array is array (natural range <>) of integer;


  -- LocalLink Stuff
  --------------------------------------------------------------
  -- All driven by source except for dst_rdy
  type t_llbus is
  record
    src_rdy : std_logic;
    sof     : std_logic;
    eof     : std_logic;
    dst_rdy : std_logic;
    data    : std_logic_vector(15 downto 0);
  end record;

  type t_llbus_array is array (natural range <>) of t_llbus;

  -- (Simulation) store the information in an ll packet
  --  2000 should be plenty (Eth is only 1500 bytes)
  type t_llstore is array(0 to 2000) of std_logic_vector(15 downto 0);

  -- All driven by source
  type t_llsrc is
  record
    src_rdy : std_logic;
    sof     : std_logic;
    eof     : std_logic;
    data    : std_logic_vector(15 downto 0);
  end record;

  type t_llsrc_array is array (natural range <>) of t_llsrc;



  -- FREQUENCY CONSTANTS
  ---------------------------------------------------------------  
  constant T_8MHz   : integer := 0;
  constant T_4MHz   : integer := 1;
  constant T_2MHz   : integer := 2;
  constant T_1MHz   : integer := 3;
  constant T_500kHz : integer := 4;
  
  constant T_800kHz : integer := 5;
  constant T_400kHz : integer := 6;
  constant T_200kHz : integer := 7;
  constant T_100kHz : integer := 8;
  constant T_50kHz  : integer := 9;

  constant T_80kHz  : integer := 10;
  constant T_40kHz  : integer := 11;
  constant T_20kHz  : integer := 12;
  constant T_10kHz  : integer := 13;
  constant T_5kHz   : integer := 14;

  constant T_8kHz   : integer := 15;
  constant T_4kHz   : integer := 16;
  constant T_2kHz   : integer := 17;
  constant T_1kHz   : integer := 18;
  constant T_500Hz  : integer := 19;

  constant T_800Hz  : integer := 20;
  constant T_400Hz  : integer := 21;
  constant T_200Hz  : integer := 22;
  constant T_100Hz  : integer := 23;
  constant T_50Hz   : integer := 24;

  constant T_80Hz   : integer := 25;
  constant T_40Hz   : integer := 26;
  constant T_20Hz   : integer := 27;
  constant T_10Hz   : integer := 28;
  constant T_5Hz    : integer := 29;

  constant T_8Hz    : integer := 30;
  constant T_4Hz    : integer := 31;
  constant T_2Hz    : integer := 32;
  constant T_1Hz    : integer := 33;
  constant T_0Hz5   : integer := 34;

  constant MAX_TICTOG : integer := 34;
  
  

  
end pkg_types;
