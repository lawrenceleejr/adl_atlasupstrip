-- parseBuffer.vhd
-- raw data buffer for on-the-fly ABC data parsing
-- Alexander Law (atlaw@lbl.gov)
-- August 2009
-- Lawrence Berkeley National Laboratory


-- The buffer needs to be longer than the longest data field in the
-- relevant format. Ths ensures that the read pointer won't "lap" the
-- occupancy counter.
--
-- The data output std_logic_vector (dataByte) should be as long or
-- longer than the longest field in the chosen data format.


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use ieee.numeric_std.all;

entity parseBuffer is
  generic(
    -- if parseBufferLen is a power of 2, you can use mod(parseBufferLen)
    -- to calculate the read address.
    parseBufferLen :     integer := 32
    );
  port(
    clock          : in  std_logic;     -- global 40 MHz clock
    reset          : in  std_logic;     -- global reset
    wrEn           : in  std_logic;     -- wrEn signal from the data gate
    dataBitIn      : in  std_logic;     -- coming from the data Gate
    rdPtr_in       : in  std_logic_vector(4 downto 0);  -- 0 to 31, points to first bit of the next data byte
    fieldLen_in    : in  std_logic_vector(3 downto 0);  -- 0 to 8, number of bits to display on the output byte
    data_out       : out std_logic_vector(7 downto 0);  -- output byte
    occ_out        : out std_logic_vector(5 downto 0);  -- 0 to 32, parse buffer occupancy 
    overflow_out   : out std_logic;  -- '1'  --> parse buffer too full
    underflow_out  : out std_logic;  -- '1'  --> parse buffer too empty
    readFlag       : in  std_logic
    );
end parseBuffer;

architecture behavioral of parseBuffer is

  signal parseBuffer      : std_logic_vector(0 to parseBufferLen-1) := x"FFFFFFFF";
  signal parseBuffer_next : std_logic_vector(0 to parseBufferLen-1) := x"FFFFFFFF";
  signal wrPtr            : integer range 0 to parseBufferLen-1     := 0;
  signal wrPtr_next       : integer range 0 to parseBufferLen-1     := 0;
  signal wrPtrReg         : integer range 0 to parseBufferLen-1     := 0;
  signal wrPtrReg_next    : integer range 0 to parseBufferLen-1     := 0;
  signal rdPtr            : integer range 0 to parseBufferLen-1     := 0;
  signal fieldLen         : integer range 0 to 8                    := 0;
-- signal rdPtrReg : integer range 0 to parseBufferLen-1 :=0;
-- signal rdPtrReg_next : integer range 0 to parseBufferLen-1 :=0;
-- signal fieldLenReg : integer range 0 to 8 := 0;
-- signal fieldLenReg_next : integer range 0 to 8 := 0;
  signal dataByte         : std_logic_vector(0 to 7)                := "00000000";

  signal a           : integer range 0 to 1  := 0;
  signal b           : integer range 0 to 8  := 0;
  signal overflow    : std_logic             := '0';
  signal underflow   : std_logic             := '0';
  signal occ         : integer range 0 to 32 := 0;
  signal occReg      : integer range 0 to 32 := 0;
  signal occReg_next : integer range 0 to 32 := 0;
--signal occ_next : integer range 0 to 32 := 0;

begin

------------ persistent assignemnts     -------------
  rdPtr         <= to_integer( unsigned(rdPtr_in) );
  fieldLen      <= to_integer ( unsigned(fieldLen_in) );
  occ_out       <= std_logic_vector( to_unsigned(occ, 6) );
  overflow_out  <= overflow;
  underflow_out <= underflow;
-------------------------------------------------

-- this right-aligns the first (fieldLen) bits of the data byte.
-- will this synthesize?? Note this won't have the same output as below method.
-- this way, numerical fields can be read without interpretation (right?).

  data_out <= std_logic_vector( unsigned(dataByte) srl (8-fieldLen) );

-- This definition allows the data byte to wrap around the end of the buffer, back to the beginning.
-- is there a more concise way to do this?
-- according to some research the mod operator only synthesizes for [x mod (2^N)]. I don't know firshand, but it would make sense.
-- rdPtr itself has a range of 0 to 31 in this module, so it should have that range wherever it gets passed from.
  dataByte(0) <= parseBuffer( (rdPtr+0) mod 32 );
  dataByte(1) <= parseBuffer( (rdPtr+1) mod 32 );
  dataByte(2) <= parseBuffer( (rdPtr+2) mod 32 );
  dataByte(3) <= parseBuffer( (rdPtr+3) mod 32 );
  dataByte(4) <= parseBuffer( (rdPtr+4) mod 32 );
  dataByte(5) <= parseBuffer( (rdPtr+5) mod 32 );
  dataByte(6) <= parseBuffer( (rdPtr+6) mod 32 );
  dataByte(7) <= parseBuffer( (rdPtr+7) mod 32 );

-------- synchronous assignments        ----------------
  process(clock, reset)
  begin
    if(clock'event and clock = '1')then
      if(reset = '1') then
        parseBuffer <= x"00000000";
        occReg      <= 0;
        wrPtr       <= 0;
        wrPtrReg    <= 0;
        -- rdPtrReg <= 0;
        -- fieldLenReg <= 0;
      else
        parseBuffer <= parseBuffer_next;
        occReg      <= occReg_next;
        wrPtr       <= wrPtr_next;
        wrPtrReg    <= wrPtrReg_next;
        -- rdPtrReg <= rdPtrReg_next;
        -- fieldLenReg <= fieldLenReg_next;
      end if;
    end if;
  end process;
-------------------------------------------------

--------------- incoming data           -------------------
  process(wrEn, occ, wrPtr, dataBitIn, overflow, parseBuffer)
  begin
    parseBuffer_next          <= parseBuffer;
    if( (wrEn = '1') and (occ < 32) ) then
      parseBuffer_next(wrPtr) <= dataBitIn;
      wrPtr_next              <= (wrPtr+1) mod 32;
    else
      wrPtr_next              <= wrPtr;
    end if;
  end process;
-------------------------------------------------

--------- occupancy incrementation      --------------
  wrPtrReg_next <= wrPtr;
  process(wrPtr, wrPtrReg)
  begin
    if (wrPtr = wrPtrReg) then
      a         <= 0;
    elsif (wrPtr < wrPtrReg) then
      a         <= 32 -wrPtrReg +wrPtr;
    else                                -- wrPtr > wrPtrReg
      a         <= wrPtr - wrPtrReg;
    end if;
  end process;
-------------------------------------------------

------- occupancy decrementation logic  ----------
-- this always works because the buffer is too long for the data field 
-- to wrap back around to the same bit within the buffer. 
-- rdPtrReg_next <= rdPtr;
-- fieldLenReg_next <= fieldLen;
  process(readFlag, fieldLen)
  begin
    if(readFlag = '1') then
      b <= fieldLen;
    else
      b <= 0;
    end if;

-- old (wrong) way to calculate b, kept in case reversion is needed
-- if(rdPtr = rdPtrReg) then
-- b <= 0;
-- elsif (rdPtr > rdPtrReg) then
-- b <= rdPtr - rdPtrReg;
-- else                                 -- rdptr < rdPtrReg
-- b <= 32 - rdPtrReg + rdPtr;
-- end if;

  end process;
-------------------------------------------------

------- occ, overflow, underflow        ----------------
  occReg_next  <= occ;
  process(occReg, b, a)
  begin
    if ( (occReg +a -b) > 32 ) then
      occ      <= 32;
      overflow <= '1';
      underflow <= '0';
    elsif ( (occReg +a -b) < 0 ) then
      occ <= 0;
      overflow <= '0';
      underflow <= '1';
    else 
      occ <= occReg +a -b;
      overflow <= '0';
      underflow <= '0';
    end if;	
  end process;
-------------------------------------------------

end behavioral;
