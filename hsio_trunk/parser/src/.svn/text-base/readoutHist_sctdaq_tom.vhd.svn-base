-- readoutHist.vhd - writes histogram data to the transmit buffer.
-- August 2009
-- Alexander Law (atlaw@lbl.gov)
-- Lawrence Berkeley National Laboratory
--
-- converted for use with SCT daq.
-- Now this is almost a generic BRAM to LocalLink readout tool
--
-- Hacked by tom


library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
library utils;
use utils.pkg_types.all;


entity readoutHist_tom is
  generic(
    --STREAM_ID         : integer := 0;
    histogram_depth   : natural := 11;
    histogram_width   : natural := 16;
    max_address_count : natural := 1280

    );
  port(
    STREAM_ID : in integer;
    clk        : in  std_logic;         --
    rst        : in  std_logic;         --
    start_ro_i : in  std_logic;
    ready_out  : out std_logic;         --

    hst_rdPtr_out : out std_logic_vector(histogram_depth-1 downto 0);  --
    hst_rdData_i  : in  std_logic_vector(histogram_width-1 downto 0);  --
    hst_rdEn_out  : out std_logic;

    lls_o             : out t_llsrc;
    lld_i             : in std_logic;

    header_count     : in std_logic_vector(histogram_width-1 downto 0);
    hit_count        : in std_logic_vector(histogram_width-1 downto 0);
    error_count      : in std_logic_vector(histogram_width-1 downto 0);
    parseError_count : in std_logic_vector(histogram_width-1 downto 0)

    );
end readoutHist_tom;

architecture rtl of readoutHist_tom is

  -- histo is split across 2 packets.
  -- a packet contains 1280/2 strips @ 2bytes/strip = 1280 bytes/packet
  -- The additional 10 is the number of header bytes (anything not histo data)
  constant payload_size      : natural := max_address_count + 10;
  constant DoolData          : natural := 16#d011#;
  -- Can we calculate this? How big can a packet be?
  -- Network packets can be up to 65535 bytes long
  -- minimum required is 576 bytes
  constant number_of_packets : natural := 2;


  signal hst_rdPtr : integer range 0 to 2**histogram_depth - 1;

  signal hst_wrEn : std_logic;

  type states is (
    SrcRdy,
    Opcode,
    Size,
    Seqnum,
    StreamID,
    EventCount,
    HitCount,
    ErrorCount,
    ParseErrorCount,
    ReadoutData,
    NextPacketEOF,
    LastPacketEOF,
    Idle
    );

  signal state     : states := Idle;
  signal nextState : states := Idle;

  signal ready : std_logic;

  signal ll_sof     : std_logic;
  signal ll_eof     : std_logic;
  signal ll_src_rdy : std_logic;
  signal ll_data    : std_logic_vector(histogram_width-1 downto 0);

  --signal sctdaq_header : std_logic;
  --signal header_data   : std_logic_vector(histogram_width-1 downto 0);

  signal seqnum_count : integer range 0 to 2**histogram_width-1;
  signal seqnum_inc   : std_logic;

  signal addr_inc : std_logic;
  signal addr_clr : std_logic;

  signal fifo_rd   : std_logic;
  signal fifo_rd_q : std_logic;

  signal hst_rdData   : std_logic_vector(histogram_width-1 downto 0);
  signal hst_rdData_q : std_logic_vector(histogram_width-1 downto 0);

  signal fragment2 : std_logic;


begin

-- ll_data_len_o <= std_logic_vector(to_unsigned(payload_size, ll_data_len_o'length));

  ready_out <= ready;

  hst_rdEn_out <= fifo_rd;

  hst_rdPtr_out <= std_logic_vector(to_unsigned(hst_rdPtr, histogram_depth));


  -- This is the data output to the local link
  lls_o.data    <= ll_data;              --header_data when (sctdaq_header = '1') else hst_rdData;
  lls_o.sof     <= ll_sof;
  lls_o.eof     <= ll_eof;
  lls_o.src_rdy <= ll_src_rdy;


-- readout peak absorber

  prc_peak_absorb : process (clk, rst)
  begin
    if rising_edge(clk) then
      if (rst = '1') then

        hst_rdData_q <= (others => '0');
        fifo_rd_q    <= '0';

      else

        fifo_rd_q <= fifo_rd;

        if (fifo_rd_q = '1') then
          hst_rdData_q <= hst_rdData_i;
        end if;

      end if;
    end if;
  end process;


  hst_rdData <= hst_rdData_q when (fifo_rd_q = '0') else
                hst_rdData_i;

  addr_inc <= fifo_rd;


-------------------------------------------------
-- synchronous assignments

  process(clk, rst)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        state     <= Idle;
        hst_rdPtr <= 0;
        fragment2 <= '0';

      else
        state <= nextState;

        if (addr_clr = '1') then
          hst_rdPtr <= 0;
        elsif (addr_inc = '1') then
          hst_rdPtr <= hst_rdPtr + 1;
        end if;


        -- fragment marker
        if (state = Idle) then
          fragment2 <= '0';
        elsif (state = NextPacketEOF) then
          fragment2 <= '1';
        end if;
      end if;
    end if;
  end process;


-------------------------------------------------
-- async state machine process

  prc_sm_async : process( state, start_ro_i, hst_rdPtr, lld_i,
                          seqnum_count, fragment2, hst_rdData,
                          header_count, hit_count, error_count, parseError_count)
  begin

    -- defaults
    ready      <= '0';
    ll_sof     <= '0';
    ll_eof     <= '0';
    addr_clr   <= '0';
    fifo_rd    <= '0';
    seqnum_inc <= '0';
    ll_src_rdy <= '1';
    ll_data    <= hst_rdData;


    case state is


      when Idle =>
        nextState   <= Idle;
        ready       <= '1';
        addr_clr    <= '1';
        ll_src_rdy  <= '0';
        if (start_ro_i = '1') then
          nextState <= SrcRdy;
        end if;


      when SrcRdy =>
        nextState   <= SrcRdy;
        if (lld_i = '1') then
          nextState <= Opcode;
        end if;


      when Opcode =>
        nextState   <= Opcode;
        ll_data     <= std_logic_vector(to_unsigned(DoolData, ll_data'length));
        ll_sof      <= '1';
        if (lld_i = '1') then
          nextState <= Seqnum;
        end if;


      when Seqnum =>
        nextState    <= Seqnum;
        ll_data      <= std_logic_vector(to_unsigned(seqnum_count, ll_data'length));
        if (lld_i = '1') then
          seqnum_inc <= '1';
          nextState  <= Size;
        end if;


      when Size =>
        nextState   <= Size;
        ll_data     <= std_logic_vector(to_unsigned(payload_size, ll_data'length));
        if (lld_i = '1') then
          nextState <= StreamID;
        end if;


      when StreamID =>
        nextState <= StreamID;

        -- Bit of a mouthful
        ll_data(histogram_width-1 downto histogram_width-8) <=          std_logic_vector(to_unsigned(STREAM_ID, 8));
        ll_data(histogram_width-9 downto 0)                 <=          (0 => fragment2, others => '0');
        if (lld_i = '1') then
          nextState <= EventCount;
        end if;


      when EventCount =>
        nextState   <= EventCount;
        ll_data     <= header_count;
        if (lld_i = '1') then
          nextState <= HitCount;
        end if;


      when HitCount =>
        nextState   <= HitCount;
        ll_data     <= hit_count;
        if (lld_i = '1') then
          nextState <= ErrorCount;
        end if;


      when ErrorCount =>
        nextState   <= ErrorCount;
        ll_data     <= error_count;
        if (lld_i = '1') then
          nextState <= ParseErrorCount;
        end if;


      when ParseErrorCount =>
        nextState   <= ParseErrorCount;
        ll_data     <= parseerror_count;
        if (lld_i = '1') then
          nextState <= ReadoutData;
          fifo_rd   <= '1';
        end if;


      when ReadoutData =>
        nextState     <= ReadoutData;
        if (lld_i = '1') then
          fifo_rd     <= '1';
          if (hst_rdPtr = (max_address_count/number_of_packets - 1)) then  -- split data across n packets
            nextState <= NextPacketEOF;
          elsif (hst_rdPtr = (max_address_count-1)) then
            nextState <= LastPacketEOF;
          end if;
        end if;


      when NextPacketEOF =>
        nextState   <= NextPacketEOF;
        ll_eof      <= '1';
        if (lld_i = '1') then
          nextState <= SrcRdy;
        end if;


      when LastPacketEOF =>
        nextState   <= LastPacketEOF;
        ll_eof      <= '1';
        if (lld_i = '1') then
          nextState <= Idle;
        end if;


    end case;
  end process;






  prc_sequence_number : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        seqnum_count <= 0;

      else
        if (seqnum_inc = '1') then
          seqnum_count <= seqnum_count + 1;
        end if;
      end if;
    end if;
  end process;


end rtl;

