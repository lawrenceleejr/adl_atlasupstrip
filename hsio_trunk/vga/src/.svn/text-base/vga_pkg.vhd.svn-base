--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

package vga_pkg is

	constant COL_POW: integer := 7;
	constant ROW_POW: integer := 6;

   constant CHAR_RAM_WIDTH: integer := 8;  -- 8 bits per character
	constant LEFT_BLANK_SIZE: integer := 8; 
	constant TOP_BLANK_SIZE: integer  := 2; 

	constant COL_NUM: integer := 2**COL_POW;
	constant ROW_NUM: integer := 2**ROW_POW;
   constant CHAR_RAM_ADDR_WIDTH: integer := COL_POW + ROW_POW; -- 2^7 X 2^6 = 8192

	subtype single_char is std_logic_vector(CHAR_RAM_WIDTH-1 downto 0);
   type char_ram_type is array (0 to 2**CHAR_RAM_ADDR_WIDTH-1)
     of single_char;

	subtype char_screen is string(1 to 2**CHAR_RAM_ADDR_WIDTH);
	
	constant blank_front_porch: string(1 to LEFT_BLANK_SIZE) :=  (others => ' ');
	constant blank_back_porch:  string(1 to 20) := (others => ' ');
	constant blank_middle:      string(1 to 100) :=(others => ' ');
	constant blank_line:        string(1 to COL_NUM) := blank_front_porch & blank_middle & blank_back_porch;
	constant blank_top:         string(1 to COL_NUM*TOP_BLANK_SIZE) := blank_line & blank_line;
	constant blank_bot:         string(1 to 3200) := (others => ' ');


	constant initial_screen: char_screen := ( blank_top &-- 2 lines
	blank_front_porch & "       ::.                      ....     .... .       .  . . .              ...            .:cc:..  " & blank_back_porch &          
	blank_front_porch & "     .:coc:..::coc:            :OOOO.    COOOOOOOOOOOOC :OOOO:             cOOOC.       .oOOOCOOOOc " & blank_back_porch &          
	blank_front_porch & " :CocoCo          cCc          COCOOo   .COOOOOCCOCOOOC.:OCOO:            .COOCO:      cCOCOOOOOOOo " & blank_back_porch & 
	blank_front_porch & " 8o .  cc           :c.       .CCCCOC.       cOOOOc     cOCCO:            cOCOCOo      CCCOCc    :: " & blank_back_porch &           
	blank_front_porch & ":coC     cc   .::... .::      cCOCCCOc       :OCCOc     cOCCO:           .oOCCCOC.    .CCCOo        " & blank_back_porch &        
	blank_front_porch & "c .o:      cc         ::     .CCCCCCCC       :CCCO:     :OCCC:           :CCCCCCOc     oCCCo.       " & blank_back_porch &           
	blank_front_porch & ":  .O   .   .c     .:   :    cCCCoCCCC:      :CCCC:     :CCCC:           oCoCoCCCo.    :CCCCC:      " & blank_back_porch &           
	blank_front_porch & ":   c8:      .c  ..     :    oCCC:cCoCc      :CCCC:     :CCCC:          .CCoo.oCCC:     :oCoCCo:    " & blank_back_porch &           
	blank_front_porch & "c. . :O       .c:       :   .ocoo .oooo.     :ooco:     :ooco:          :oooc :ococ       :oocooc.  " & blank_back_porch &           
	blank_front_porch & ".c.   cO.       .      .:   coccc  ccco:     .occo.     :occo.          cccc. .occo.        :ocooc: " & blank_back_porch &           
	blank_front_porch & ":.c:   .o:       :     :   .ocoo.  :oooc     .oooo:     :oooo:         :oooc   cCooc          cocoo:" & blank_back_porch &           
	blank_front_porch & " ..ccc:  ::      ::  .::   :oooooooooooo:    :oooo:     :oooo:         coooocooooooo           cooCc" & blank_back_porch &           
	blank_front_porch & "   :ccoo:cc. ooc :o::ccc. .oooooooooCoooc.   :CooC:     :oooC:        :oooooCoCoCooCc          oCcCo" & blank_back_porch &           
	blank_front_porch & "     :c:occccc:occoco:c   :CCCo:. . cCoCC:   :CCCC:     :CCCC:        cCoCo.   .cCoCC. .oc.  .cCCCCc" & blank_back_porch &           
	blank_front_porch & "       ..:::ccccoCoooo:   oCCCo.     CCCCo   :OCCOc     cCCCCCCCCCOC .CCCC:     :OCCO: :CCCOCCooCOo " & blank_back_porch &           
	blank_front_porch & "           .::.:cc.      :OOCO:      oOOCO:  cOCCOc     :COOCOOCOCOC.oOOOC.     .COOOC .COCOOOOOo:  " & blank_back_porch &           
	blank_front_porch & "           .oc..::..                                                                       ...      " & blank_back_porch &           
	blank_front_porch & "            oc:cooooc     ::..:..:   .: .:...   ::..:  ::.:    ::   .:    :.  .:..:: ...  .. ...:..." & blank_back_porch &           
	blank_front_porch & "            c::c::cooo   .COoCo::OC cOC oOCCOO. OOoCC:.OOCCOo  OO: .OOc  oOo  oOCoCc oOO. CO:cCOOCCo" & blank_back_porch &           
	blank_front_porch & "            c:.:c::c::   .OC.    oOcCC  COc oOc.CO.   .OC. CO. CC: :OOo .COC  COc    oCOc CO:  cOo  " & blank_back_porch &           
	blank_front_porch & "            c:.:  :Oo:.  .CCc.   .CCC.  oCc:CC:.CC:.  .CC::Oo  CC: :CCC.cCCC. cCc .  cCCC:oO:  cCc  " & blank_back_porch &           
	blank_front_porch & "            cc:   .c.:    coccc.  :oc   coocc.  cocco  coccc   co. :ococccco. :ooco: cocoooo:  :oc  " & blank_back_porch &           
	blank_front_porch & "           cc::    ::     oo.    :Coo:  co:    .oo.   .cocoo  .cc. co.coocco. :o:    co:.ooc:  coc  " & blank_back_porch &           
	blank_front_porch & "       .:::::.:cc::cocc::.oo.   .Co:oo: cOc    .oo.   .CC.cCc  oC: oC.cCC.:Oc cC:    cCc cCC:  cCc  " & blank_back_porch &           
	blank_front_porch & "       .::::::c:ccccooc::.COCOCooOc :OC:oOc    :COOOO:.CO. CO:.CO:.CC..CC.:OC oOOOOo oOc .CCc  cOo  " & blank_back_porch &           
	blank_front_porch & "                                                                                                    " & blank_back_porch &           
	blank_front_porch & "    c8O88O8OO8O8O8O8O8O8O8OO8O8O8O8O88OO8O8O88O88OO88O8O8OO8OO888OO88O8O8O8O8O8OOO8OO8OO8O8O8O8OOOOo" & blank_back_porch &           
	blank_front_porch & "                                                                                                    " & blank_back_porch &           
	blank_front_porch & "     c:                                  c.      :c              .c                            :.   " & blank_back_porch &           
	blank_front_porch & "     OC                                 OC      :8c              o8:                          :8c   " & blank_back_porch &           
	blank_front_porch & "     8o      8O   8C                   oO.      8o          c8c  o8:                          :8:   " & blank_back_porch &           
	blank_front_porch & "     O8O8o  C8@c.o88o .O8O8c  c8o     o8.      OC    OO88o .88C: o8.  oOO8C.  O8O:       o8Oc :8OC8c" & blank_back_porch &           
	blank_front_porch & "     8C C8.  OO  .OC   Oo CO.        cO:      CC    c8::8o  :8c  c8: .8o CO  o8:        c8o   :8c 8C" & blank_back_porch &           
	blank_front_porch & "    .8C C8   OO   OO  .8o C8.       :8c      CO.    o8..8o  c8:  o8: .8o C8   :C8:      c8c   :8c 8C" & blank_back_porch &          
	blank_front_porch & "     8C C8   8O   OO   88o8O  :Oc   8o      c8:     :8oC8c  c@:  o8:  COo8O. :co8o  Co  :O8o. :8c 8C" & blank_back_porch &           
	blank_front_porch & "     .. .:   ..   ..  .Co::    :.  OC      :8:       ....    :   ..    ::..   ::.   ..    ::   :  :." & blank_back_porch &            
	blank_front_porch & "                       OC         CC      :Oc                                                       " & blank_back_porch &                  
	blank_bot -- 25 lines 
	);

	constant N_LEDS : integer := 14;
	constant SCOPE_WIDTH : integer := 64;
	type scope_arr is array(0 to N_LEDS) of std_logic_vector(SCOPE_WIDTH-1 downto 0);

--	constant initial_screen: char_screen := (others => 'T');
-- The screen I have starts at col 6, row 2
-- Try +128 to get the first row, +8 to get the first column
-- 128 is not quite there - it gets cut off
-- 256 is a safer bet, + 8 for 1st col
--	constant initial_screen: char_screen := (
--															264 => 'T',
--															265 => 'o',
--															266 => 'm',
---- 2304 should be somewhere around the middle row															
----  +50 should be the middle column
----=2354
--															2354 => 'i',
--															2355 => 's',
---- 4480 should be the bottom
----   80 towards the right
----=4560 
--															4560 => 'A',
--															4561 => 'w',
--															4562 => 'e',
--															4563 => 's',
--															4564 => 'o',
--															4565 => 'm',
--															4566 => 'e',
--															4567 => '!',															
--															others => '.');
		

  -- names are referenced from Altera University Program Design
  -- Laboratory Package  November 1997, ver. 1.1  User Guide Supplement
  -- clock period = 39.72 ns; the constants are integer multiples of the
  -- clock frequency and are close but not exact
--  -- row counter will go from 0 to 524; column counter from 0 to 799
--  subtype counter is std_logic_vector(9 downto 0);
--  constant B : natural := 93;  -- horizontal blank: 3.77 us
--  constant C : natural := 45;  -- front guard: 1.89 us
--  constant D : natural := 640; -- horizontal columns: 25.17 us
--  constant E : natural := 22;  -- rear guard: 0.94 us
--  constant A : natural := B + C + D + E;  -- one horizontal sync cycle: 31.77 us
--  constant P : natural := 2;   -- vertical blank: 64 us
--  constant Q : natural := 32;  -- front guard: 1.02 ms
--  constant R : natural := 480; -- vertical rows: 15.25 ms
--  constant S : natural := 11;  -- rear guard: 0.35 ms
--  constant O : natural := P + Q + R + S;  -- one vertical sync cycle: 16.6 ms
  -- Now using a 40MHz clock for SVGA (800 x 600)
--   row counter will go from 0 to 524; column counter from 0 to 799
-- See http://tinyvga.com/vga-timing/800x600@60Hz
  subtype counter is std_logic_vector(10 downto 0);
  constant B : natural := 128;  -- horizontal blank: 
  constant C : natural := 40;  -- front guard: 
  constant D : natural := 800; -- horizontal columns:
  constant E : natural := 88;  -- rear guard: 
  -- Whole line 1056
  constant A : natural := B + C + D + E;  -- one horizontal sync cycle: 31.77 us
  constant P : natural := 4;   -- vertical blank:
  constant Q : natural := 1;  -- front guard: 
  constant R : natural := 600; -- vertical rows: 
  constant S : natural := 23;  -- rear guard:
  constant O : natural := P + Q + R + S;  -- one vertical sync cycle: 16.6 ms 
  -- Whole line 628

-- type <new_type> is
--  record
--    <type_name>        : std_logic_vector( 7 downto 0);
--    <type_name>        : std_logic;
-- end record;



-- Declare constants
--
-- constant <constant_name>		: time := <time_unit> ns;
-- constant <constant_name>		: integer := <value;
--
-- Declare functions and procedure
--
-- function <function_name>  (signal <signal_name> : in <type_declaration>) return <type_declaration>;
-- procedure <procedure_name> (<type_declaration> <constant_name>	: in <type_declaration>);
--

	function char_to_ascii ( char : in character ) return single_char;
	function string_to_char_ram ( instring : in char_screen ) return char_ram_type;
	function coord_to_address( x : in integer; y: in integer ) return integer;
	function slv_to_char ( reg : in std_logic_vector(15 downto 0); nibble : in integer ) return character;

end vga_pkg;

package body vga_pkg is

---- Example 1
--  function <function_name>  (signal <signal_name> : in <type_declaration>  ) return <type_declaration> is
--    variable <variable_name>     : <type_declaration>;
--  begin
--    <variable_name> := <signal_name> xor <signal_name>;
--    return <variable_name>; 
--  end <function_name>;

	function char_to_ascii (char : in character ) return single_char is
		variable ascii : single_char;
	begin
		case char is
			when ' ' => ascii := X"20";
			when '!' => ascii := X"21";
--	when '"' => ascii := X"22";
			when '#' => ascii := X"23";
			when '$' => ascii := X"24";
			when '%' => ascii := X"25";
			when '&' => ascii := X"26";
--	when ''' => ascii := X"27";
			when '(' => ascii := X"28";
			when ')' => ascii := X"29";
			when '*' => ascii := X"2a";
			when '+' => ascii := X"2b";			
			when ',' => ascii := X"2c";			
			when '-' => ascii := X"2d";			
			when '.' => ascii := X"2e";			
			when '/' => ascii := X"2f";			
---
			when '0' => ascii := X"30";			
			when '1' => ascii := X"31";			
			when '2' => ascii := X"32";			
			when '3' => ascii := X"33";			
			when '4' => ascii := X"34";			
			when '5' => ascii := X"35";			
			when '6' => ascii := X"36";			
			when '7' => ascii := X"37";			
			when '8' => ascii := X"38";			
			when '9' => ascii := X"39";			
			when ':' => ascii := X"3a";			
			when ';' => ascii := X"3b";			
			when '<' => ascii := X"3c";			
			when '=' => ascii := X"3d";			
			when '>' => ascii := X"3e";			
			when '?' => ascii := X"3f";			
---
			when '@' => ascii := X"40";			
			when 'A' => ascii := X"41";			
			when 'B' => ascii := X"42";			
			when 'C' => ascii := X"43";			
			when 'D' => ascii := X"44";			
			when 'E' => ascii := X"45";			
			when 'F' => ascii := X"46";			
			when 'G' => ascii := X"47";			
			when 'H' => ascii := X"48";			
			when 'I' => ascii := X"49";			
			when 'J' => ascii := X"4a";			
			when 'K' => ascii := X"4b";			
			when 'L' => ascii := X"4c";			
			when 'M' => ascii := X"4d";			
			when 'N' => ascii := X"4e";			
			when 'O' => ascii := X"4f";			
			when 'P' => ascii := X"50";			
			when 'Q' => ascii := X"51";			
			when 'R' => ascii := X"52";			
			when 'S' => ascii := X"53";			
			when 'T' => ascii := X"54";			
			when 'U' => ascii := X"55";			
			when 'V' => ascii := X"56";			
			when 'W' => ascii := X"57";			
			when 'X' => ascii := X"58";			
			when 'Y' => ascii := X"59";			
			when 'Z' => ascii := X"5a";			
			when '[' => ascii := X"5b";			
			when '\' => ascii := X"5c";			
			when ']' => ascii := X"5d";			
			when '^' => ascii := X"5e";			
			when '_' => ascii := X"5f";		
---
			when '`' => ascii := X"60";			
			when 'a' => ascii := X"61";			
			when 'b' => ascii := X"62";			
			when 'c' => ascii := X"63";			
			when 'd' => ascii := X"64";			
			when 'e' => ascii := X"65";			
			when 'f' => ascii := X"66";			
			when 'g' => ascii := X"67";			
			when 'h' => ascii := X"68";			
			when 'i' => ascii := X"69";			
			when 'j' => ascii := X"6a";			
			when 'k' => ascii := X"6b";			
			when 'l' => ascii := X"6c";			
			when 'm' => ascii := X"6d";			
			when 'n' => ascii := X"6e";			
			when 'o' => ascii := X"6f";			
			when 'p' => ascii := X"70";			
			when 'q' => ascii := X"71";			
			when 'r' => ascii := X"72";			
			when 's' => ascii := X"73";			
			when 't' => ascii := X"74";			
			when 'u' => ascii := X"75";			
			when 'v' => ascii := X"76";			
			when 'w' => ascii := X"77";			
			when 'x' => ascii := X"78";			
			when 'y' => ascii := X"79";			
			when 'z' => ascii := X"7a";			
			when '{' => ascii := X"7b";			
			when '|' => ascii := X"7c";			
			when '}' => ascii := X"7d";			
			when '~' => ascii := X"7e";			
--	when '_' => ascii := X"7f";					
---
			when others => ascii := X"20";  -- blank
		end case;
		return ascii;
	end char_to_ascii;


	function string_to_char_ram ( instring : in char_screen ) return char_ram_type is
		variable outram : char_ram_type;
	begin		
		for i in 0 to (2**CHAR_RAM_ADDR_WIDTH-1) loop
			outram(i) := char_to_ascii( instring(i+1) );
		end loop;
		return outram;
	end string_to_char_ram;

	function coord_to_address( x : in integer; y: in integer ) return integer is
	begin		
		return ( (y + TOP_BLANK_SIZE) * COL_NUM ) + x + LEFT_BLANK_SIZE;
	end coord_to_address;

	function slv_to_char ( reg : in std_logic_vector(15 downto 0); nibble : in integer ) return character is
		variable ascii : character;
		variable sub_slv : std_logic_vector(3 downto 0);
	begin
		sub_slv := reg( ((nibble+1)*4)-1 downto (nibble*4) );
		case sub_slv is
			when X"0" => ascii := '0';			
			when X"1" => ascii := '1';			
			when X"2" => ascii := '2';			
			when X"3" => ascii := '3';			
			when X"4" => ascii := '4';			
			when X"5" => ascii := '5';			
			when X"6" => ascii := '6';			
			when X"7" => ascii := '7';			
			when X"8" => ascii := '8';			
			when X"9" => ascii := '9';			
			when X"a" => ascii := 'A';			
			when X"b" => ascii := 'B';			
			when X"c" => ascii := 'C';			
			when X"d" => ascii := 'D';			
			when X"e" => ascii := 'E';			
			when X"f" => ascii := 'F';			
			when others => ascii := ' ';  -- blank
		end case;
		return ascii;
	end slv_to_char;

---- Example 2
--  function <function_name>  (signal <signal_name> : in <type_declaration>;
--                         signal <signal_name>   : in <type_declaration>  ) return <type_declaration> is
--  begin
--    if (<signal_name> = '1') then
--      return <signal_name>;
--    else
--      return 'Z';
--    end if;
--  end <function_name>;

---- Procedure Example
--  procedure <procedure_name>  (<type_declaration> <constant_name>  : in <type_declaration>) is
--    
--  begin
--    
--  end <procedure_name>;
 
end vga_pkg;
