
---------------------------------------------------------------------
-- Atlys ITSDAQ Specific Declarations
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


package pkg_atlys_itsdaq is



  -- ================================================================================
  -- Build Details
  -- ================================================================================
  
  constant C_FW_BUILD_NO  : integer   := 16#a008#;
  
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
  constant C_MOD_RAW  : slv36 := x"000000001";  -- max 0x30fff0fff
--constant C_MOD_RAW  : slv36 := x"00000043f";  -- max 0x30fff0fff
--constant C_MOD_RAW  : slv36 := x"000000000";  -- max 0x30fff0fff  
--constant C_MOD_RAW  : slv36 := x"000000001";  -- max 0x30fff0fff
--constant C_MOD_RAW  : slv36 := x"0043f043f";  -- max 0x30fff0fff
--constant C_MOD_RAW  : slv36 := x"0000f000f";  -- max 0x30fff0fff
--constant C_MOD_RAW  : slv36 := x"3000f0fff";  -- max 0x30fff0fff
--constant C_MOD_RAW  : slv36 := x"0c0000000";  -- max 0x30fff0fff
--constant C_MOD_HST  : slv36 := x"000000000";  -- max 0x30fff0fff


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



--==============================================================================
-- VMOD Mapping
--==============================================================================

  constant vmCMD     : integer := 1;  
  constant vmL1R     : integer := 2;  
  constant vmD0     : integer := 3;  
  constant vmD1     : integer := 4;  
  constant vmD2     : integer := 5;  
  constant vmD3     : integer := 6;  
  constant vmD4     : integer := 7;  
  constant vmD5     : integer := 8;  
  constant vmD6     : integer := 9;  
  constant vmBCO     : integer := 10;  
  constant vmDRC     : integer := 11;  
  constant vmD7     : integer := 12;  
  constant vmD8     : integer := 13;  
  constant vmD9     : integer := 14;  
  constant vmD10     : integer := 15;  
  constant vmD11     : integer := 16;  
  constant vmD12     : integer := 17;  
  constant vmD13     : integer := 18;  
  constant vmD14     : integer := 19;  
  constant vmD15     : integer := 20;  

end pkg_atlys_itsdaq;
  

