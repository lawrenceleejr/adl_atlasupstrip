-- sqr_alt.vhd
-- state-machine variant of the sequencer
-- Alexander Law (atlaw@ucsc.edu)
-- July 2011
-- University of California, Santa Cruz

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use ieee.numeric_std.all;

entity sequencer is
  generic(
    data_rdAddrLen : integer := 12;     -- 2^12 = 4096 depth
    rptCntLen      : integer := 11;  -- 2^11 = 2048 repeats (big for trigger sequences)
    dest_vacLen    : integer := 13;  -- destination vacancy length, should = destination address length
    dataWidth      : integer := 8
    );
  port(
    clock      : in std_logic;          -- global 40 MHz clock
    reset      : in std_logic;          -- global reset
    trigger_in : in std_logic;          -- readout trigger
    rptCnt_in  : in std_logic_vector(rptCntLen-1 downto 0);  -- registered upon receipt of valid trigger (trigger received in "waiting" state)
    dataLen_in : in std_logic_vector(data_rdAddrLen-1 downto 0);  -- also registered upon valid trigger
    clr_in     : in std_logic;  -- if '1' upon valid trigger, last readout clears data buffer.

    data_rdPtr_out : out std_logic_vector(data_rdAddrLen-1 downto 0) := (others => '0');
    data_rDclr_out : out std_logic                                   := '0';  -- data buffer read port "WR" signal
    data_rdData_in : in  std_logic_vector(dataWidth-1 downto 0);

    xmt_request_out : out std_logic;  -- destination token request, tie xmt_token_in to '1' at top-level instantiation to ignore this.
    xmt_token_in    : in  std_logic;  -- destination token: tie to '1' at top-level instattiation to ignore.
    data_out        : out std_logic_vector(dataWidth-1 downto 0) := (others => '0');  -- output data bus
    dest_vacancy_in : in  std_logic_vector(dest_vacLen-1 downto 0);  -- destination vacancy for flow control between readouts: tie this to sequence buffer maximum address to ignore.
    readout_out     : out std_logic  -- output flag indicates valid data on data_out
    );
end sequencer;

architecture behavioral of sequencer is
-- signal dataMask : std_logic_vector(0 to dataWidth-1) := (others <= '0'); -- just duplicates readout
  signal data_rdPtr, data_rdPtr_next   : integer range 0 to 2**data_rdAddrLen -1 := 0;
  signal rptCnt, rptCnt_next           : integer range 0 to 2**rptCntLen-1       := 0;
  signal dataLen, dataLen_next         : integer range 0 to 2**data_rdAddrLen-1  := 0;
  signal clr, clr_next                 : std_logic                               := '0';
  signal data_rdClr, data_rdClr_next   : std_logic                               := '0';
  signal readout, readout_next         : std_logic                               := '0';
  type   states is (waiting, hold, reading);
  signal state, nextState              : states                                  := waiting;
  signal xmt_request, xmt_request_next : std_logic                               := '0';

begin

-------- synchronous assignments ----------------
  process(clock, reset)
  begin
    if(reset = '1') then
      state       <= waiting;
      data_rdPtr  <= 0;
      dataLen     <= 0;
      rptCnt      <= 0;
      clr         <= '0';
      data_rdClr  <= '0';
      xmt_request <= '0';
      readout     <= '0';
    elsif(clock'event and clock = '1')then
      state       <= nextState;
      data_rdPtr  <= data_rdPtr_next;
      dataLen     <= dataLen_next;
      rptCnt      <= rptCnt_next;
      clr         <= clr_next;
      data_rdClr  <= data_rdClr_next;
      xmt_request <= xmt_request_next;
      readout     <= readout_next;
    end if;
  end process;
-------------------------------------------------

---------------  persistent assignments -------------------
  data_rdPtr_out  <= std_logic_vector(to_unsigned(data_rdPtr, data_rdAddrLen));
  data_rdClr_next <= '0';  -- disabled pending more exahaustive testing: warrany void if enabled by user!
  data_rdClr_out  <= data_rdClr;
  data_out        <= data_rdData_in when readout = '1' else (others => '0');  -- masking data
-- readout <= '1' when state = reading else '0';
  readout_out     <= readout;
  xmt_request_out <= xmt_request;
--------------------------------------------------------------



  process(clr, dataLen, rptCnt, rptCnt_in, datalen_in, clr_in, data_rdPtr, state, trigger_in, xmt_request, xmt_token_in)
  begin
----- defaults -------
    clr_next         <= clr;
    datalen_next     <= datalen;
    rptCnt_next      <= rptCnt;
    data_rdptr_next  <= 0;
    xmt_request_next <= xmt_request;
    readout_next     <= readout;
-----------------------
    case state is
      when waiting =>
        readout_next <= '0';
        if(trigger_in = '1')then
          rptCnt_next      <= to_integer(unsigned(rptCnt_in));
          dataLen_next     <= to_integer(unsigned(dataLen_in));
          clr_next         <= clr_in;
          nextState        <= hold;  -- if you are really, truly not concerned about flow-control or back-pressure, you can set this to "readout" and save a clock tick.
          xmt_request_next <= '1';
        else
          clr_next         <= '0';
          rptCnt_next      <= 0;
          dataLen_next     <= 0;
          nextState        <= waiting;
          xmt_request_next <= '0';
        end if;


      when hold =>
        readout_next <= '0';
-- should inherit xmt_request = '1';
        if(xmt_token_in = '1' and to_integer(unsigned(dest_vacancy_in)) > datalen)then
          nextState <= reading;
          -- if clent modules need a 1-clock warning for valid data, set readout_next <= '1' here.
        else
          nextState <= hold;
        end if;

      when reading =>
-- should inherit xmt_request = '1'
        if(data_rdPtr+1 < dataLen)then
          readout_next    <= '1';
          data_rdPtr_next <= data_rdPtr+1;
          rptCnt_next     <= rptCnt;
          nextState       <= reading;
        elsif(rptCnt > 0)then
          data_rdptr_next <= 0;
          rptCnt_next     <= rptCnt -1;
          if(xmt_token_in = '1' and to_integer(unsigned(dest_vacancy_in)) > datalen)then
            nextState    <= reading;
            readout_next <= '1';
          else
            nextState    <= hold;
            readout_next <= '0';
          end if;
        else
          readout_next    <= '0';
          rptCnt_next     <= 0;
          data_rdPtr_next <= 0;
          nextState       <= waiting;
        end if;
    end case;
  end process;

end behavioral;
