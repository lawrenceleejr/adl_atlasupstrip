---------------------------------------------------------------------
--
-- HSIO Global Declarations
--
---------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library utils;
use utils.pkg_types.all;

library hsio;
use hsio.pkg_core_globals.all;

package pkg_hsio_globals is

  -- Build Details
  ------------------------------------------------

  constant C_FW_BUILD_NO  : integer   := 16#438d#;
  constant C_RAW_MULTI_EN : std_logic := '0';
  constant C_TDC_EN : integer := 0;
  constant C_TLU_EN : integer := 0;

  -- Concise format, each bit corrosponds to 4 streams (1 module) worth of inputs
  -- Thus bit 0 = streams 0-3, bit 1 = streams 4-7 etc.

  --nib typ modules  streams               streams per bit
  --=== === =======  =======  =========================================
  -- 8   I   33-32   135-128                      | 135-132 | 131-128 |
  -- 7   a   31-28   127-112  | 127-124 | 123-120 | 119-116 | 115-112 |
  -- 6   B   27-24   111-96   | 111-108 | 107-104 | 103-100 |  99-96  |
  -- 5   B   23-20    95-80   |  95-92  |  91-88  |  87-84  |  83-80  |
  -- 4   B   19-16    79-64   |  79-76  |  75-72  |  71-68  |  67-64  | 
  -- 3   a   15-12    63-48   
  -- 2   T   11-8     47-32   |  47-44  |  43-40  |  39-36  |  35-32  | 
  -- 1   T    7-4     31-16   |  31-28  |  27-24  |  23-20  |  19-16  | 
  -- 0   T    3-0     15-0    |  15-12  |  11-8   |   7-4   |   3-0   | 

  -- Driver uses streams (top)   2  8 14 20 (+  40 for TMU (4 on Atlys))
  --             streams (bot)  66 72 78 84 (+ 104 for TMU)
  --  Order: IDC, Bottom, Top      IaBBBaTTT
--constant C_MOD_RAW  : slv36 := x"000000001";  -- max 0x30fff0fff
--constant C_MOD_RAW  : slv36 := x"00000043f";  -- max 0x30fff0fff
--constant C_MOD_RAW  : slv36 := x"000000000";  -- max 0x30fff0fff  
--constant C_MOD_RAW  : slv36 := x"000000001";  -- max 0x30fff0fff
  constant C_MOD_RAW  : slv36 := x"0043f043f";  -- max 0x30fff0fff
--constant C_MOD_RAW  : slv36 := x"0000f000f";  -- max 0x30fff0fff
--constant C_MOD_RAW  : slv36 := x"3000f0fff";  -- max 0x30fff0fff
--constant C_MOD_RAW  : slv36 := x"0c0000000";  -- max 0x30fff0fff


  constant C_MOD_HST  : slv36 := x"000000000";  -- max 0x30fff0fff
  constant C_MOD_TYPE : slv36 := x"3ffffffff";  -- 0: ABCN, 1: ABC130
  constant C_MOD_IDBG : slv36 := x"0f000f000";  -- DEBUG - skips IDELAY for internal e.g. ABC-TESTING

    constant C_INCLUDE_HSIOA13 : std_logic :=
    C_MOD_RAW(31) or
    C_MOD_RAW(30) or
    C_MOD_RAW(29) or
    C_MOD_RAW(28) or
    C_MOD_RAW(15) or
    C_MOD_RAW(14) or
    C_MOD_RAW(13) or
    C_MOD_RAW(12);

  constant C_MOD_PRES : slv36 := C_MOD_RAW or C_MOD_HST;

  constant C_MODULECOUNT : integer :=
    conv_integer(C_MOD_PRES(35)) +
    conv_integer(C_MOD_PRES(34)) +
    conv_integer(C_MOD_PRES(33)) +
    conv_integer(C_MOD_PRES(32)) +
    conv_integer(C_MOD_PRES(31)) +
    conv_integer(C_MOD_PRES(30)) +
    conv_integer(C_MOD_PRES(29)) +
    conv_integer(C_MOD_PRES(28)) +
    conv_integer(C_MOD_PRES(27)) +
    conv_integer(C_MOD_PRES(26)) +
    conv_integer(C_MOD_PRES(25)) +
    conv_integer(C_MOD_PRES(24)) +
    conv_integer(C_MOD_PRES(23)) +
    conv_integer(C_MOD_PRES(22)) +
    conv_integer(C_MOD_PRES(21)) +
    conv_integer(C_MOD_PRES(20)) +
    conv_integer(C_MOD_PRES(19)) +
    conv_integer(C_MOD_PRES(18)) +
    conv_integer(C_MOD_PRES(17)) +
    conv_integer(C_MOD_PRES(16)) +
    conv_integer(C_MOD_PRES(15)) +
    conv_integer(C_MOD_PRES(14)) +
    conv_integer(C_MOD_PRES(13)) +
    conv_integer(C_MOD_PRES(12)) +
    conv_integer(C_MOD_PRES(11)) +
    conv_integer(C_MOD_PRES(10)) +
    conv_integer(C_MOD_PRES(9)) +
    conv_integer(C_MOD_PRES(8)) +
    conv_integer(C_MOD_PRES(7)) +
    conv_integer(C_MOD_PRES(6)) +
    conv_integer(C_MOD_PRES(5)) +
    conv_integer(C_MOD_PRES(4)) +
    conv_integer(C_MOD_PRES(3)) +
    conv_integer(C_MOD_PRES(2)) +
    conv_integer(C_MOD_PRES(1)) +
    conv_integer(C_MOD_PRES(0));

  constant C_STRM_RAW : slv136 :=
C_MOD_RAW(33) & C_MOD_RAW(33) & C_MOD_RAW(33) & C_MOD_RAW(33) &
C_MOD_RAW(32) & C_MOD_RAW(32) & C_MOD_RAW(32) & C_MOD_RAW(32) &
C_MOD_RAW(31) & C_MOD_RAW(31) & C_MOD_RAW(31) & C_MOD_RAW(31) &
C_MOD_RAW(30) & C_MOD_RAW(30) & C_MOD_RAW(30) & C_MOD_RAW(30) &
C_MOD_RAW(29) & C_MOD_RAW(29) & C_MOD_RAW(29) & C_MOD_RAW(29) &
C_MOD_RAW(28) & C_MOD_RAW(28) & C_MOD_RAW(28) & C_MOD_RAW(28) &
C_MOD_RAW(27) & C_MOD_RAW(27) & C_MOD_RAW(27) & C_MOD_RAW(27) &
C_MOD_RAW(26) & C_MOD_RAW(26) & C_MOD_RAW(26) & C_MOD_RAW(26) &
C_MOD_RAW(25) & C_MOD_RAW(25) & C_MOD_RAW(25) & C_MOD_RAW(25) &
C_MOD_RAW(24) & C_MOD_RAW(24) & C_MOD_RAW(24) & C_MOD_RAW(24) &
C_MOD_RAW(23) & C_MOD_RAW(23) & C_MOD_RAW(23) & C_MOD_RAW(23) &
C_MOD_RAW(22) & C_MOD_RAW(22) & C_MOD_RAW(22) & C_MOD_RAW(22) &
C_MOD_RAW(21) & C_MOD_RAW(21) & C_MOD_RAW(21) & C_MOD_RAW(21) &
C_MOD_RAW(20) & C_MOD_RAW(20) & C_MOD_RAW(20) & C_MOD_RAW(20) &
C_MOD_RAW(19) & C_MOD_RAW(19) & C_MOD_RAW(19) & C_MOD_RAW(19) &
C_MOD_RAW(18) & C_MOD_RAW(18) & C_MOD_RAW(18) & C_MOD_RAW(18) &
C_MOD_RAW(17) & C_MOD_RAW(17) & C_MOD_RAW(17) & C_MOD_RAW(17) &
C_MOD_RAW(16) & C_MOD_RAW(16) & C_MOD_RAW(16) & C_MOD_RAW(16) &
C_MOD_RAW(15) & C_MOD_RAW(15) & C_MOD_RAW(15) & C_MOD_RAW(15) &
C_MOD_RAW(14) & C_MOD_RAW(14) & C_MOD_RAW(14) & C_MOD_RAW(14) &
C_MOD_RAW(13) & C_MOD_RAW(13) & C_MOD_RAW(13) & C_MOD_RAW(13) &
C_MOD_RAW(12) & C_MOD_RAW(12) & C_MOD_RAW(12) & C_MOD_RAW(12) &
C_MOD_RAW(11) & C_MOD_RAW(11) & C_MOD_RAW(11) & C_MOD_RAW(11) &
C_MOD_RAW(10) & C_MOD_RAW(10) & C_MOD_RAW(10) & C_MOD_RAW(10) &
C_MOD_RAW(9) & C_MOD_RAW(9) & C_MOD_RAW(9) & C_MOD_RAW(9) &
C_MOD_RAW(8) & C_MOD_RAW(8) & C_MOD_RAW(8) & C_MOD_RAW(8) &
C_MOD_RAW(7) & C_MOD_RAW(7) & C_MOD_RAW(7) & C_MOD_RAW(7) &
C_MOD_RAW(6) & C_MOD_RAW(6) & C_MOD_RAW(6) & C_MOD_RAW(6) &
C_MOD_RAW(5) & C_MOD_RAW(5) & C_MOD_RAW(5) & C_MOD_RAW(5) &
C_MOD_RAW(4) & C_MOD_RAW(4) & C_MOD_RAW(4) & C_MOD_RAW(4) &
C_MOD_RAW(3) & C_MOD_RAW(3) & C_MOD_RAW(3) & C_MOD_RAW(3) &
C_MOD_RAW(2) & C_MOD_RAW(2) & C_MOD_RAW(2) & C_MOD_RAW(2) &
C_MOD_RAW(1) & C_MOD_RAW(1) & C_MOD_RAW(1) & C_MOD_RAW(1) &
C_MOD_RAW(0) & C_MOD_RAW(0) & C_MOD_RAW(0) & C_MOD_RAW(0);


  
end pkg_hsio_globals;

