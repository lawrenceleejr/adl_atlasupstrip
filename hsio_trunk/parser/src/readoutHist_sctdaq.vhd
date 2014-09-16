-- readoutHist.vhd - writes histogram data to the transmit buffer.
-- August 2009
-- Alexander Law (atlaw@lbl.gov)
-- Lawrence Berkeley National Laboratory
--
-- converted for use with SCT daq.
-- Now this is almost a generic BRAM to LocalLink readout tool
--


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library UNISIM;
use UNISIM.VComponents.all;

entity readoutHist_sctdaq is
  generic( STREAM_ID :     integer := 0
           );
  port(
    clk              : in  std_logic;   --
    rst              : in  std_logic;   --
    en               : in  std_logic;   --
    start_ro_i       : in  std_logic;
    ready_out        : out std_logic;   --
    debug_mode_i     : in  std_logic;

    hst_rdPtr_out  : out std_logic_vector(10 downto 0);  --
    hst_rdData_i   : in  std_logic_vector(15 downto 0);  --
    hst_wrPtr_out  : out std_logic_vector(10 downto 0);
    hst_wrData_out : out std_logic_vector(15 downto 0);
    hst_wrEn_out   : out std_logic;

    ll_sof_o     : out std_logic;
    ll_eof_o     : out std_logic;
    ll_src_rdy_o : out std_logic;
    ll_dst_rdy_i : in  std_logic;
    ll_data_o    : out std_logic_vector(15 downto 0)

    );
end readoutHist_sctdaq;

architecture rtl of readoutHist_sctdaq is



  signal histogramLen : integer range 0 to 2047;  -- clean this up later

  signal hst_rdPtr : integer range 0 to 2047;
  signal hst_wrPtr : integer range 0 to 2047;  -- only want 0 to 767/1280, but range will relfect read bit field range.
  signal hst_wrEn  : std_logic;


  type states is (SrcRdy, Opcode, Size, Seqnum, StreamID,
                  ReadoutData, NextPacketEOF, LastPacketEOF,
                  Idle );
  signal state     : states;
  signal nextState : states;


  signal ready : std_logic;

  signal ll_sof     : std_logic;
  signal ll_eof     : std_logic;
  signal ll_src_rdy : std_logic;
  signal ll_data    : std_logic_vector(15 downto 0);

  signal addr_inc : std_logic;
  signal addr_clr : std_logic;

  signal seqnum_count : std_logic_vector(15 downto 0);
  signal seqnum_inc   : std_logic;

  signal fifo_rd   : std_logic;
  signal fifo_rd_q : std_logic;

  signal hst_rdData   : std_logic_vector(15 downto 0);
  signal hst_rdData_q : std_logic_vector(15 downto 0);

  signal payload_size : std_logic_vector(15 downto 0);
  signal fragment2    : std_logic;



begin

  -- histo is split across 2 packets.
  -- a packet contains 1280/2 strips @ 2bytes/strip = 1280 bytes/packet

  histogramLen <= 1280;                 --note 1280x16b is too long for a packet
  payload_size <= conv_std_logic_vector(histogramLen+2, 16);


  hst_wrPtr_out  <= conv_std_logic_vector(hst_wrPtr, 11);
  hst_wrData_out <= "0000000000000000" when (debug_mode_i = '0') else
                    conv_std_logic_vector(hst_wrPtr, 16);

  hst_wrEn_out <= hst_wrEn;
  ready_out    <= ready;

  hst_rdPtr_out <= conv_std_logic_vector(hst_rdPtr, 11);

  ll_data_o    <= ll_data;              --header_data when (sctdaq_header = '1') else hst_rdData;
  ll_sof_o     <= ll_sof;
  ll_eof_o     <= ll_eof;
  ll_src_rdy_o <= ll_src_rdy;



-- readout peak absorber
------------------------------------------------


  prc_peak_absorb : process (clk)
  begin
    if rising_edge(clk) then

      fifo_rd_q <= fifo_rd;

      if (fifo_rd_q = '1') then
        hst_rdData_q <= hst_rdData_i;
      end if;

    end if;
  end process;

  hst_rdData <= hst_rdData_q when (fifo_rd_q = '0') else
                hst_rdData_i;

  addr_inc <= fifo_rd;
  hst_wrEn <= fifo_rd_q;

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
          hst_wrPtr <= hst_rdPtr;       -- eeeurgh - pipelined wrPtr

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

  prc_sm_async : process( state, histogramLen, start_ro_i, hst_rdPtr, ll_dst_rdy_i,
                          en, seqnum_count, fragment2, hst_rdData)
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
        if (start_ro_i = '1') and (en = '1') then
          nextState <= SrcRdy;
        end if;


      when SrcRdy =>
        nextState   <= SrcRdy;
        if (ll_dst_rdy_i = '1') then
          nextState <= Opcode;
        end if;


      when Opcode =>
        nextState   <= Opcode;
        ll_data     <= x"D001";
        ll_sof      <= '1';
        if (ll_dst_rdy_i = '1') then
          nextState <= Seqnum;
        end if;


      when Seqnum =>
        nextState    <= Seqnum;
        ll_data      <= seqnum_count;
        if (ll_dst_rdy_i = '1') then
          seqnum_inc <= '1';
          nextState  <= Size;
        end if;


      when Size =>
        nextState   <= Size;
        ll_data     <= payload_size;
        if (ll_dst_rdy_i = '1') then
          nextState <= StreamID;
        end if;


      when StreamID =>
        nextState   <= StreamID;
        ll_data     <= conv_std_logic_vector(STREAM_ID, 8) & "0000000" & fragment2;
        if (ll_dst_rdy_i = '1') then
          nextState <= ReadoutData;
          fifo_rd   <= '1';
        end if;


      when ReadoutData =>
        nextState     <= ReadoutData;
        if (ll_dst_rdy_i = '1') then
          fifo_rd     <= '1';
          if (hst_rdPtr = (histogramLen/2 - 1)) then  -- split data across 2 packets
            nextState <= NextPacketEOF;
          elsif (hst_rdPtr = (histogramLen-1)) then
            nextState <= LastPacketEOF;
          end if;
        end if;


      when NextPacketEOF =>
        nextState   <= NextPacketEOF;
        ll_eof      <= '1';
        if (ll_dst_rdy_i = '1') then
          nextState <= SrcRdy;
        end if;


      when LastPacketEOF =>
        nextState   <= LastPacketEOF;
        ll_eof      <= '1';
        if (ll_dst_rdy_i = '1') then
          nextState <= Idle;
        end if;


    end case;
  end process;






  prc_sequence_number : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        seqnum_count <= x"0000";

      else
        if (seqnum_inc = '1') then
          seqnum_count <= seqnum_count + '1';
        end if;
      end if;
    end if;
  end process;


end rtl;

