-- parser.vhd
-- parses and histograms ABCD/ABCN electrical test data
-- December 2009
-- Alexander Law (atlaw@lbl.gov)
-- Lawrence Berkeley National Laboratory


-- This is a finite state machine for parsing ABCD3TA electrical test
-- data. The parsing logic is general and could be used for other
-- applications, but the "hit" data is recorded in a manner specific
-- to test scans such as threshold, double trigger, etc.


library IEEE;
use IEEE.STD_LOGIC_1164.all;
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;
use ieee.numeric_std.all;

entity parser is
  port(
    -- global synchronization signals
    clock         : in std_logic;                     --
    reset         : in std_logic;                     --
    parseEn       : in std_logic;                     --
    -- testFlag   : out std_logic;
    -- scanParam  : in std_logic_vector();            -- 
    -- ready_out  : out std_logic;
    chipType      : in std_logic;
    addrOffset_in : in std_logic_vector(6 downto 0);  --
    dg_wrEn       : in std_logic;

    -- parse buffer (pb_) signals
    pb_rdPtr_out    : out std_logic_vector(4 downto 0);  -- points to the first unread bit of the parse buffer (0 to 31)
    pb_fieldLen_out : out std_logic_vector(3 downto 0);  -- tells parse buffer how many bits to read (0 to 8)
    dataByte        : in  std_logic_vector(7 downto 0);  -- contains fieldLen bits, beginning at rdPtr, within a masked byte from the parseBuffer
    pb_occ_in       : in  std_logic_vector(5 downto 0);  -- number of unread bits in the parse buffer (0 to 32)

    -- histogram block ram (hst_) signals
    hst_rdPtr_out  : out std_logic_vector(10 downto 0);  -- sets the blockRAM read head to a selected memory address 
    hst_wrPtr_out  : out std_logic_vector(10 downto 0);  -- sets the blockRAM write head to a selected memory address
    hst_rdData_in  : in  std_logic_vector(15 downto 0);  -- contents of the memory address indicated by hst_rdPtr
    hst_wrData_out : out std_logic_vector(15 downto 0);  -- data to be written to memory address indicated by wrPtr
    hst_wrEn_out   : out std_logic;     -- strobe high writes hst_wrData => hst_wrPtr
    read_from_pb   : out std_logic
    );
end parser;

architecture behavioral of parser is

  type states is
    (
      init,                             -- Wait for header from data gate
      header,                           -- Check header
      dataType,                         -- 
      L1,                               -- 
      beamCrossing,                     -- 
      seperator1,                       -- 
      dataBlockType,                    -- 
      hitDataAddress,                   -- 
      NChitChannel,                     -- 
      seperator2,                       -- 
      hitPattern0,                      -- 
      hitPattern1,                      -- 
      hitPattern2,                      -- 
      A,                                -- 
      B,                                -- 
      C,                                -- 
      D,                                --  Look for 0011 (ABCN no hit) after data hit (BJG)
      whyNoData1,                       -- 
      whyNoData2,                       -- ABCN no hit data packet is one bit longer than for ABCD PWP
      errorAddress,                     -- 
      errorType,                        -- 
      seperator3,                       -- 
      cfgReg1,                          -- 
      seperator4,                       -- 
      cfgReg2,                          -- 
      registerAddress,                  -- Changed to 5 bits, makes seperator5 redundant PWP
      trailer,                          --
      waiting,                          -- 
      parseError                        -- 
      );

  signal state          : states := init;  -- FSM state on current clock tick
  signal potentialState : states := init;  -- next state, once the parse buffer has enough data to fill the corresponding data field
  signal nextState      : states := init;  -- either "potentialState" or "waiting," depending on parse buffer occupancy.
-- signal stateReg       : states := init;  -- remembers potentialState if the parser has to wait on more data
-- signal stateReg_next  : states := init;  -- next-state signal for stateReg

  signal fieldLen      : integer range 0 to 8 := 0;  -- length of current data field
  signal fieldLen_next : integer range 0 to 8 := 0;  -- max field length 8 for BC number
  signal nextFieldLen  : integer range 0 to 8 := 0;  -- length of next data field
-- signal fieldLenReg          : integer range 0 to 8 := 0;  -- remembers fieldLen while waiting on parse buffer occupancy
-- signal fieldLenReg_next     : integer range 0 to 8 := 0;  -- fieldLenReg next-state signal
-- signal nextFieldLenReg      : integer range 0 to 8 := 0;  -- remembers fieldLen while waiting on parse buffer occupancy
-- signal nextFieldLenReg_next : integer range 0 to 8 := 0;  -- fieldLenReg next-state signal

-- signal ready :
-- signal ready_next :
-- signal scanParamReg : unsigned integer range 0 to 2048 := 0;
-- signal scanParamReg_next : unsigned integer range 0 to 2048 := 0;

  signal pb_rdPtr        : integer range 0 to 31    := 0;
  signal pb_rdPtr_next   : integer range 0 to 31    := 0;
  signal pb_occ          : integer range 0 to 32;
-- no pb_occ_next, since it is an input from the parse buffer
  signal hst_rdPtr       : integer range 0 to 2047  := 0;  -- 0 to 767 used
  signal hst_rdPtr_next  : integer range 0 to 2047  := 0;  -- 0 to 767 used
  signal hst_rdData      : integer range 0 to 65535;
-- no hst_rdData_next, since hst_rdData is an input from the histogram blockRAM
  signal hst_wrPtr       : integer range 0 to 2047  := 0;  -- 0 to 767 used
  signal hst_wrPtr_next  : integer range 0 to 2047  := 0;  -- 0 to 767 used
  signal hst_wrData      : integer range 0 to 65535 := 0;  -- 
  signal hst_wrData_next : integer range 0 to 65535 := 0;  -- hst_wrData next-state signal
  signal hst_wrEn        : std_logic                := '0';  -- 
  signal hst_wrEn_next   : std_logic                := '0';  -- hst_wrEn next-state signal

-- signal parseErrorCount : integer range 0 to 255 := 0;  -- parse error count
-- signal parseErrorCount_next : integer range 0 to 255 := 0;  -- parse error count

-- signal L1count : integer range 0 to 127 := 0;       -- L1 Trigger count
-- signal L1count_next : integer range 0 to 127 := 0;  -- L1 Trigger count
-- signal BCcount      : integer range 0 to 255 := 0;  -- Beam crossing count
-- signal BCcount_next : integer range 0 to 255 := 0;  -- Beam Crossing count

  signal   addrOffset        : integer range 0 to 127 := 0;
  constant hitDataAddressLen : integer                := 7;  --***ABCN only

  signal address      : integer range 0 to 127 := 0;  -- NC hit or error address
  signal address_next : integer range 0 to 127 := 0;  -- address next-state signal
  signal channel      : integer range 0 to 127 := 0;  -- hit channel number (0-127)
  signal channel_next : integer range 0 to 127 := 0;  -- channel next-state signal

  signal nonEmptyHitPattern      : std_logic := '0';  -- used to filter "000" hit patterns 
  signal nonEmptyHitPattern_next : std_logic := '0';  -- nonEmptyHitPattern next-state signal
  signal consecutiveHit          : std_logic := '0';  -- used by states "hitPattern(x)" and "A" to increment the occ data address
  signal consecutiveHit_next     : std_logic := '0';  -- consecutiveHit next-state signal

-- signal noDataErrorCount : integer range 0 to 255 := 0;  -- number of "no data" errors reported by hybrid
-- signal noDataErrorCount_next   : integer range 0 to 255 := 0;  -- noDataErrorCount next-state signal
-- signal bufferErrorCount        : integer range 0 to 255 := 0;  -- number of "buffer" errors reported by hybrid
-- signal bufferErrorCount_next   : integer range 0 to 255 := 0;  -- bufferErrorCount next-state signal
-- signal overflowErrorCount      : integer range 0 to 255 := 0;  -- number of "overflow" errors reported by hybrid
-- signal overflowErrorCount_next : integer range 0 to 255 := 0;  -- overflowErrorCount next-state signal

  constant trailerLen        : integer               := 15;  --***ABCN specs say 16, but it's really only 15 for immediately adjacent events PWP
  signal   trailerFlag       : std_logic             := '0';
  signal   trailerFlag_next  : std_logic             := '0';
  signal   trailerCount      : integer range 0 to 31 := 0;  -- we only need 16
  signal   trailerCount_next : integer range 0 to 31 := 0;  -- we only need 16

-- signal testFlag_next : std_logic := '0';

  signal read_from_pb_next : std_logic := '0';

begin

--------- persistent assignments        ----------------
-- ready_out <= ready;
  pb_rdPtr_out    <= std_logic_vector(to_unsigned(pb_rdPtr, 5));
  pb_fieldLen_out <= std_logic_vector(to_unsigned(fieldLen, 4));
  pb_occ          <= to_integer( unsigned(pb_occ_in) );
  hst_rdPtr_out   <= std_logic_vector(to_unsigned(hst_rdPtr, 11));
  hst_wrPtr_out   <= std_logic_vector(to_unsigned(hst_wrPtr, 11));
  hst_wrData_out  <= std_logic_vector(to_unsigned(hst_wrData, 16));
  hst_rdData      <= to_integer( unsigned(hst_rdData_in) );
  hst_wrData_out  <= std_logic_vector( to_unsigned(hst_wrData, 16) );
  hst_wrEn_out    <= hst_wrEn;
--with chipType select hitDataAddressLen <=
-- 4 when '0',                          -- ABCD
--      7 when others;                  -- ABCN
--with chipType select trailerLen <=
--      15 when '0',                    -- ABCD
--      16 when others;                 -- ABCN
--addrOffset <= to_integer( unsigned(addrOffset_in) );
-------------------------------------------------

--------- reset/synchronous assignments  ---------
  process(
    clock, reset,
    nextState, nextFieldLen,             --fieldLenReg_next,
    pb_rdPtr_next, hst_rdPtr_next, hst_wrPtr_next, hst_wrData_next, hst_wrEn_next,
    --L1count_next,BCcount_next,
    address_next, channel_next,
    nonEmptyHitPattern_next, consecutiveHit_next,
    -- noDataErrorCount_next,bufferErrorCount_next,overflowErrorCount_next,parseErrorCount_next,
    trailerCount_next, trailerFlag_next
    )
  begin
    if(clock'event and clock = '1') then
      if(reset = '1') then
        state              <= init;
        -- stateReg <= init;
        fieldLen           <= 0;
        -- fieldLenReg <= 0;
        -- nextFieldLenReg <= 0;
        pb_rdPtr           <= 0;
        hst_rdPtr          <= 0;
        hst_wrPtr          <= 0;
        hst_wrData         <= 0;
        hst_wrEn           <= '0';
        -- L1count <= 0;
        -- BCcount <= 0;
        address            <= 0;
        channel            <= 0;
        nonEmptyHitPattern <= '0';
        consecutiveHit     <= '0';
        -- errorAddress <= 0;
        -- parseErrorCount <= 0;
        -- noDataErrorCount <= 0;
        -- bufferErrorCount <= 0;
        -- overflowErrorCount <= 0;
        trailerFlag        <= '0';
        trailerCount       <= 0;
        -- ready <= '0';
        -- testFlag <= '0';
        read_from_pb       <= '0';
      else
        state              <= nextState;
        -- stateReg <= stateReg_next;
        fieldLen           <= fieldLen_next;
        -- fieldLenReg <= fieldLenReg_next;
        -- nextFieldLenReg <= nextFieldLenReg_next;
        pb_rdPtr           <= pb_rdPtr_next;
        hst_rdPtr          <= hst_rdPtr_next;
        hst_wrPtr          <= hst_wrPtr_next;
        hst_wrData         <= hst_wrData_next;
        hst_wrEn           <= hst_wrEn_next;
        -- L1count <= L1count_next;
        -- BCcount <= BCcount_next;
        address            <= address_next;
        channel            <= channel_next;
        nonEmptyHitPattern <= nonEmptyHitPattern_next;
        consecutiveHit     <= consecutiveHit_next;
        -- errorAddress <= errorAddress_next; 
        -- noDataErrorCount <= noDataErrorCount_next;
        -- bufferErrorCount <= bufferErrorCount_next;
        -- overflowErrorCount <= overflowErrorCount_next;
        -- parseErrorCount <= parseErrorCount_next;
        trailerFlag        <= trailerFlag_next;
        trailerCount       <= trailerCount_next;
        --ready <= ready_next;
        -- testFlag <= testFlag_next;
        read_from_pb       <= read_from_pb_next;
      end if;
    end if;
  end process;
-------------------------------------------------


  process(
    chipType,                           --hitDataAddressLen,trailerLen,
    state, parseEn, dataByte, dg_wrEn,
    pb_rdPtr, pb_occ, hst_rdPtr, hst_rdData, hst_wrPtr, hst_wrData, hst_wrEn,
    address, channel,
    nonEmptyHitPattern, consecutiveHit,
    trailerFlag, trailerCount
    -- noDataErrorcount,bufferErrorCount,overflowErrorCount,parseErrorCount
    )
  begin

-- set some signal default values up here, so that they only have to
-- be reset explicitly in the states that change them.
-- study the code to see what needs to be set here

-- potentialState, nextFieldLen should be set in all states
-- L1Count_next <= L1Count;
-- BCcount_next <= BCcount;
    address_next            <= address;
    channel_next            <= channel;
    hst_rdPtr_next          <= hst_rdPtr;
    hst_wrPtr_next          <= hst_wrPtr;
    hst_wrEn_next           <= '0';
    nonEmptyHitPattern_next <= nonEmptyHitPattern;
    consecutiveHit_next     <= consecutiveHit;
    hst_wrData_next         <= hst_wrData;
    trailerFlag_next        <= trailerFlag;
    trailerCount_next       <= 0;
-- parseErrorCount_next <= parseErrorCount;
-- testFlag_next <= '0';

    case state is

      when init =>
        if (parseEn = '1') then
          potentialState <= header;
          nextFieldLen   <= 5;
        else
          potentialState <= init;
          nextFieldLen   <= 0;
        end if;

-- reading the data header
      when header =>
        if (dataByte(4 downto 0) = "11101") then
          potentialState <= dataType;
          nextFieldLen   <= 1;
        else
          potentialState <= parseError;
          nextFieldLen   <= 1;
        end if;

-- reading the data type
      when dataType =>
        if (dataByte(0) = '0') then
          potentialState <= L1;
          nextFieldLen   <= 4;
        else
          potentialState <= parseError;  -- 1 can be a valid data Type for the ABC-N, but not -D.
          nextFieldLen   <= 1;
        end if;

-- reading the L1 trigger Count
      when L1 =>
-- is L1count always consecutive for consecutive readouts (accounting for resets, of course)?
-- Can this be used as a parseError trigger?
-- the parser will be disabled for odd readouts in the double-trigger test.
-- xxxx
        potentialState <= beamCrossing;
        nextFieldLen   <= 8;

-- read the beam crossing count
      when beamCrossing =>
-- xxxx xxxx
        potentialState <= seperator1;
        nextFieldLen   <= 1;


-- read the seperator between beam crossing count and data block type
      when seperator1 =>
-- 1 =>
        if (dataByte(0) = '1') then
          potentialState <= dataBlockType;
          nextFieldLen   <= 2;
-- 0 =>
        else
          potentialState <= parseError;
          nextFieldLen   <= 1;
        end if;


      when dataBlockType =>
-- 01 =>
        if(dataByte(1 downto 0) = "01") then
          potentialState <= hitDataaddress;
          nextFieldLen   <= hitDataAddressLen;  -- 4/7 switched in persistent assignments
-- 00 => 
        elsif(dataByte(1 downto 0) = "00") then
          potentialState <= whyNoData1;
          nextFieldLen   <= 1;
        else
          potentialState <= parseError;
          nextFieldLen   <= 1;
        end if;


      when hitDataAddress =>
-- with hybrid and module metadata, addresses of hybrids that aren't there could be used to trigger parseError.
-- the following if block is replaced by the first line following, since hitDataAddressLen is switched in the
-- persistent assignements.
-- if (chipType = '0') then             -- ABCD
        -- xxxx, address 15 ("1111") not allowed, trigger parseError? 
        -- address_next <= to_integer( unsigned(dataByte(3 downto 0)) );
-- else                                 -- ABCN
        -- xxxx xxx, address 127 ("1111 111") not allowed, trigger parseError? 
        -- address_next <= to_integer( unsigned(dataByte(6 downto 0)) );
-- end case;
        address_next   <= to_integer( unsigned(dataByte(hitDataAddressLen-1 downto 0)) );
        potentialState <= NChitChannel;
        nextFieldLen   <= hitDataAddressLen;

      when NChitChannel =>
-- xxxx xxx =>
        channel_next   <= to_integer( unsigned(dataByte(6 downto 0)) );
        potentialState <= seperator2;
        nextFieldLen   <= 1;
-- begin occupancy read-back, do not increment until you can check hit pattern not "000"
        hst_rdPtr_next <= ((address-addrOffset)*128) + to_integer( unsigned(dataByte(6 downto 0)) );
        hst_wrPtr_next <= ((address-addrOffset)*128) + to_integer( unsigned(dataByte(6 downto 0)) );
        hst_wrEn_next  <= '0';


-- adding a seperate state for each data bit within the hit data will be
-- faster when the parsing is keeping pace with the data rate, or
-- spending a lot of time waiting on data. There will be a speed penalty
-- to this choice if the parser is trying to play catch-up.
-- It's simpler, more concise code either way. (spares a separate
-- trigger-read-increment-write module)

      when seperator2 =>                -- between hit channel and hit pattern
-- 1 => 
        if (dataByte(0) = '1') then
          potentialState          <= hitPattern0;
          nextFieldLen            <= 1;
          hst_rdPtr_next          <= hst_rdPtr;  -- sustained from state "channel"
          hst_wrPtr_next          <= hst_wrPtr;  -- sustained from state "channel"
          hst_wrEn_next           <= '0';
          nonEmptyHitPattern_next <= '0';
          consecutiveHit_next     <= '0';  -- reset this before every nonconsecutive hit
-- 0 =>
        else
          potentialState          <= parseError;
          nextFieldLen            <= 1;
          -- testFlag_next <= '1';
        end if;


      when hitPattern0 =>
-- second tick w/rdPtr on current address
        hst_rdPtr_next          <= hst_rdPtr;
        hst_wrPtr_next          <= hst_wrPtr;  -- ensuring last write cycle ends fully before wrPtr changes
        hst_wrData_next         <= hst_wrData;  -- making sure that the last write cycle ends fully before wrData changes. 
        hst_wrEn_next           <= '0';
        consecutiveHit_next     <= consecutiveHit;
        potentialState          <= hitPattern1;
        nextFieldLen            <= 1;
        nonEmptyHitPattern_next <= dataByte(0);


      when hitPattern1 =>
        consecutiveHit_next     <= consecutiveHit;
        hst_rdPtr_next          <= hst_rdPtr;
        if (consecutiveHit = '1') then
          hst_wrPtr_next        <= hst_wrPtr+1;
        else
          hst_wrPtr_next        <= hst_wrPtr;
        end if;
        hst_wrData_next         <= hst_rdData +1;
        hst_wrEn_next           <= '0';  -- don't have full hit pattern yet
        potentialState          <= hitPattern2;
        nextFieldLen            <= 1;
        nonEmptyHitPattern_next <= nonEmptyHitPattern or dataByte(0);


      when hitPattern2 =>
        if (dg_wrEn = '0') then         -- Data gate found trailer
          potentialState    <= init;
          nextFieldLen      <= 0;
        else
          potentialState    <= A;
          nextFieldLen      <= 1;
        end if;
        consecutiveHit_next <= consecutiveHit;
        hst_rdPtr_next      <= hst_rdPtr;
        hst_wrPtr_next      <= hst_wrPtr;
        hst_wrData_next     <= hst_wrData;
        hst_wrEn_next       <= nonEmptyHitPattern or dataByte(0);
        if (nonEmptyHitPattern = '0' and dataByte(0) = '0') then
          trailerFlag_next  <= '1';
        else
          trailerFlag_next  <= '0';
        end if;


-- next three bits determine how the data branches after the hit pattern.
      when A =>
        hst_wrPtr_next        <= hst_wrPtr;
        hst_wrData_next       <= hst_wrData;
        hst_wrEn_next         <= hst_wrEn;
        if(dataByte(0) = '1')then
          -- 1 =>                       --hit on next channel
          consecutiveHit_next <= '1';
          hst_rdPtr_next      <= hst_rdPtr+1;
          potentialState      <= hitPattern0;  -- next channel
          nextFieldLen        <= 1;
          channel_next        <= channel+1;
          trailerFlag_next    <= '0';
        else
          -- 0 =>                       --unknown: could be nonconsecutive hit, no data next address, or error
          hst_rdPtr_next      <= hst_rdPtr;
          consecutiveHit_next <= '0';
          potentialState      <= B;
          nextFieldLen        <= 1;
          trailerFlag_next    <= trailerFlag;
        end if;


      when B =>                         -- Seen 0 after hit
-- 1 =>                                 --nonconsecutive hit
        if (dataByte(0) = '1') then
          potentialState   <= hitDataAddress;
          if (chipType = '0') then      -- ABCD
            nextFieldLen   <= 4;
          else                          -- ABCN
            nextFieldLen   <= hitDataAddressLen;
          end if;
          trailerFlag_next <= '0';
-- 0 =>                                 --unknown: could be no data next address, or error
        else
          potentialState   <= C;
          nextfieldLen     <= 1;
          trailerFlag_next <= trailerFlag;
        end if;


      when C =>                         -- Seen 00 after hit
-- 1 =>                                 -- no data next address 
        if (dataByte(0) = '1') then
          if (chipType = '0') then      -- ABCD
            potentialState <= dataBlockType;
            nextFieldLen   <= 2;
          else                          -- Look for 0011 (no hit in chip)
            potentialState <= D;
            nextfieldLen   <= 1;
          end if;
          trailerFlag_next <= '0';
          -- 0 =>                       --error
        else
          potentialState   <= errorAddress;
          if (chipType = '0') then      -- ABCD
            nextFieldLen   <= 4;
          else                          -- ABCN
            nextFieldLen   <= hitDataAddressLen;
          end if;
          trailerFlag_next <= trailerFlag;
        end if;


      when D =>                         -- Seen 001 after hit
-- 1 =>                                 -- no data next address 
        if (dataByte(0) = '1') then
          if (dg_wrEn = '0') then       -- Data gate found trailer
            potentialState <= init;
            nextFieldLen   <= 0;
          else
            potentialState <= dataBlockType;
            nextFieldLen   <= 2;
          end if;
-- 0 =>                                 --error
        else
          potentialState   <= parseError;
          nextFieldLen     <= 1;
        end if;



      when whyNoData1 =>
        if (dataByte(0) = '0') then     --error or config ("000")
          potentialState   <= errorAddress;
          nextFieldLen     <= hitDataAddressLen;
          trailerFlag_next <= '1';      --PWP
        else                            -- no hit data packet, perhaps
          if (chipType = '0') then      -- ABCD no hit packet
            potentialState <= parseError;
            nextFieldLen   <= 1;
          else                          -- ABCN
            potentialState <= whyNoData2;
            nextFieldLen   <= 1;
          end if;
        end if;

      when whyNoData2 =>
        if (dataByte(0) = '1') then     --ABCN no hit packet ("0011")
          if (dg_wrEn = '0') then       -- Data gate found trailer
            potentialState <= init;
            nextFieldLen   <= 0;
          else
            potentialState <= dataBlockType;
            nextFieldLen   <= 2;
          end if;
        else                            -- error
          potentialState   <= parseError;
          nextFieldLen     <= 1;
        end if;


      when errorAddress =>
        potentialState     <= errorType;
        nextFieldLen       <= 3;
        address_next       <= to_integer( unsigned(dataByte(hitDataAddressLen-1 downto 0)) );
-- This comparison is dependent on data byte masking. Not great, but much more concise
-- than if statements on the chip type.
-- alterantive(?): if (dataByte(hitDataAddressLen-1 downto 0) = (others => '0') AND trailerFlag = '1') then
        if (dataByte = "00000000" and trailerFlag = '1') then
          trailerFlag_next <= trailerFlag;
        else
          trailerFlag_next <= '0';
        end if;

-- this state can be reduced a lot with a few choice switches on chipType in the persistent assignments.
      when errorType   =>
        case dataByte(2 downto 0) is
          when ("001") =>
            -- "no data available" error
            potentialState   <= seperator3;
            nextFieldLen     <= 1;
          when ("100") =>
            -- "buffer error"
            potentialState   <= seperator3;
            nextFieldLen     <= 1;
          when "111"   =>
            -- config register read-back
            potentialState   <= cfgReg1;
            nextFieldLen     <= 8;
          when "000"   =>
            if (address = 0) then
              potentialState <= trailer;
              if (chipType = '0' and trailerFlag = '1') then
                nextFieldLen <= 2;
              elsif (chipType = '0' and trailerFlag = '0') then
                nextFieldLen <= 5;
              elsif (chipType = '1' and trailerFlag = '1') then
                nextFieldLen <= 0;
              else                      -- (chipType = '1' AND trailerFlag = '0')
                nextFieldLen <= 3;
              end if;
            else
              potentialState <= parseError;
              nextFieldLen   <= 1;
            end if;
          when ("010") =>
            -- ABCD "buffer overflow" error
            -- ABCN register readback
            if (chipType = '0') then    -- ABCD
              potentialState <= seperator3;
              nextFieldLen   <= 1;
            else                        -- ABCN
              potentialState <= registerAddress;
              nextFieldLen   <= 5;
            end if;
          when others  =>               -- "011" or "110" 
            potentialState   <= parseError;
            nextFieldLen     <= 1;
        end case;

      when seperator3 =>                --ends error block
-- 1 =>
        if (dataByte(0) = '1') then
          if (dg_wrEn = '0') then       -- Data gate found trailer
            potentialState <= init;
            nextFieldLen   <= 0;
          else
            potentialState <= dataBlockType;
            nextFieldLen   <= 2;
          end if;
-- 0 =>
        else
          potentialState   <= parseError;
          nextFieldLen     <= 1;
        end if;

      when registerAddress =>
-- register address is 5 bits long.
-- LSB is usually but not always 0 - so cannot be treated as a seperator bit :-(
        potentialState <= cfgReg1;
        nextFieldLen   <= 8;

      when cfgReg1 =>
-- xxxx xxxx =>
        potentialState <= seperator4;
        nextFieldLen   <= 1;

      when seperator4 =>                -- between two bytes of cfg reg. data
-- 1 => 
        if (dataByte(0) = '1') then
          if (dg_wrEn = '0') then       -- Data gate found trailer
            potentialState <= init;
            nextFieldLen   <= 0;
          else
            potentialState <= cfgReg2;
            nextfieldLen   <= 8;
          end if;
-- 0 =>
        else
          potentialState   <= parseError;
          nextFieldLen     <= 1;
        end if;


      when cfgReg2 =>
-- xxxx xxxx =>
        potentialState <= seperator3;
        nextFieldLen   <= 1;

-- depending on the flag, there could be zero, two, or five bits delivered from the parseBuffer,
-- but the numerical value is (shoiuld be) zero either way.
-- this is currently dependent on data byte masking.
      when trailer =>
        if (dataByte = "00000000") then
          potentialState <= header;
          nextFieldLen   <= 5;
        else
          potentialState <= parseError;
          nextFieldLen   <= 1;
        end if;


-- when waiting =>
-- potentialState <= stateReg;
-- nextFieldLen <= nextFieldLenReg;

      when parseError =>
-- testFlag_next <= '1';
-- trailerLen switched on chipType in persistent assignments
        if ( (trailerCount < trailerLen) and ( (pb_occ > 0) or (dg_wrEn = '1') ) ) then
          potentialState      <= parseError;
          nextFieldLen        <= 1;
          if (dataByte(0) = '0') then
            trailerCount_next <= trailerCount +1;
          else
            trailerCount_next <= 0;
          end if;
        else
          potentialState      <= init;
          nextFieldLen        <= 0;
          trailerCount_next   <= 0;
          -- parseErrorCount_next <= parseErrorCount +1;
        end if;

      when others =>
        potentialState <= parseError;
        nextFieldLen   <= 1;

    end case;
------------------------------------------------------
------------------------------------------------------

  end process;

---------- checking parseBuffer occupancy  ------------
------------------------------------------------------
  process(
    pb_occ, pb_rdPtr,
    nextFieldLen, fieldLen,
    dg_wrEn,
    state, potentialState
    )
  begin
    if ( (pb_occ >= nextFieldLen) or ( (pb_occ = nextFieldLen -1) and (dg_wrEn = '1') ) ) then  -- parseBuffer has enough data
      nextState         <= potentialState;
      fieldLen_next     <= nextFieldLen;
      pb_rdPtr_next     <= (pb_rdPtr+fieldLen) mod 32;
      read_from_pb_next <= '1';
    else
      -- FIXME: Data gate found trailer while parser waiting for more data
      --if (dg_wrEn = '0') then 
      -- nextState <= parseError;
      --else
      nextState         <= state;
      fieldLen_next     <= fieldLen;
      pb_rdPtr_next     <= pb_rdPtr;
      read_from_pb_next <= '0';
      --end if;
    end if;
  end process;
------------------------------------------------------
------------------------------------------------------

end behavioral;

