--
-- Readout Unit FIFO for ABC130 packets
--
-- Cut down version of a locallink stylee fifo that, adds headers etc needed
-- for the ABC130 schema.
--
--
-- 5/12/2012 - Files birthday!
--


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library utils;
use utils.pkg_types.all;

library hsio;
use hsio.pkg_core_globals.all;

entity ro13_mod_fifo is
  generic(
    STREAM_ID      :     integer := 0;
    TS_HIRES       :     integer := 0
    );
  port(
    l0id16_i       : in  std_logic_vector(15 downto 0);
    ts_count_i     : in  std_logic_vector(39 downto 0);
    ts_source_i    : in  std_logic_vector(3 downto 0);
    ts_always_i    : in  std_logic;
    ts_disable_i   : in  std_logic;
    timeout_tick_i : in  std_logic;
    strm_src_i     : in  std_logic_vector(2 downto 0);
    capture_mode_i : in  std_logic;
    -- input interface
    packet_i       : in  slv64;         --t_packet;
    pkt_valid_i    : in  sl;
    pkt_rdack_o    : out sl;
    -- locallink tx interface
    lls_o          : out t_llsrc;
    lld_i          : in  std_logic;
    -- fifo status
    full_o         : out std_logic;
    --near_full_o    : out std_logic;
    overflow_o     : out std_logic;
    underflow_o    : out std_logic;
    data_count_o   : out std_logic_vector (1 downto 0);
    -- infrastructure
    en             : in  std_logic;
    s40            : in  std_logic;
    clk            : in  std_logic;
    rst            : in  std_logic
    );

-- Declarations

end ro13_mod_fifo;


architecture rtl of ro13_mod_fifo is

  component cg_brfifo_1kx18
    port (
      clk        : in  std_logic;
      srst       : in  std_logic;
      din        : in  std_logic_vector(17 downto 0);
      wr_en      : in  std_logic;
      rd_en      : in  std_logic;
      dout       : out std_logic_vector(17 downto 0);
      full       : out std_logic;
      overflow   : out std_logic;
      empty      : out std_logic;
      underflow  : out std_logic;
      data_count : out std_logic_vector(1 downto 0);
      prog_full  : out std_logic
      );
  end component;

  component cg_brfifo_2kx18
    port (
      clk        : in  std_logic;
      srst       : in  std_logic;
      din        : in  std_logic_vector(17 downto 0);
      wr_en      : in  std_logic;
      rd_en      : in  std_logic;
      dout       : out std_logic_vector(17 downto 0);
      full       : out std_logic;
      overflow   : out std_logic;
      empty      : out std_logic;
      underflow  : out std_logic;
      data_count : out std_logic_vector(1 downto 0)
      --prog_full  : out std_logic
      );
  end component;



  signal fifo_data_ready : std_logic;

  signal fifo_empty : std_logic;
  signal fifo_din   : slv18;
  signal fifo_wr    : std_logic;

  signal fin_we   : std_logic;
  signal fin_sof  : std_logic;
  signal fin_eof  : std_logic;
  signal fin_data : slv16;

  signal fifo_rd   : std_logic;
  signal fifo_dout : slv18;
  signal fifo_sof  : std_logic;
  signal fifo_eof  : std_logic;
  signal fifo_data : slv16;

  signal tx_opcode  : slv16;
  signal seq_id     : slv16;
  signal seq_id_inc : std_logic;

  signal   len_count     : integer range 0 to 255;
  signal   len_inc       : std_logic;
  signal   len_clr       : std_logic;
  constant LEN_COUNT_MAX : integer := 1472/8;  -- max payload is 1500. -16 for
                                        -- oc headers, -6 for align-pre-pad zero
                                        -- -3 for our CRC = 1500-6-2 = 1492 
                                        -- /8 for 64bit = 186.5 . so 186*8=
                                               -- 1488  -- 1472 is rounded down

  signal ts_block : slv64;
  signal ts_ready : std_logic;
  signal ts_store : std_logic;
  signal ts_count : std_logic_vector(39 downto 0);



  type states is (
    StartNetPkt,
    OpcodeSOF, SeqID, Len,
    Word0, Word1, Word2,
    TSPayload0, TSPayload1, TSPayload2, TSPayload3,
    Payload0, Payload1, Payload2, Payload3,
    WaitNext, WaitNextTO, WaitNextTO2,
    StartIdle
    );

  signal state, nstate : states;

  type llstates is (LLIdle, LLFluffSOF, LLSrcRdy, LLSOF, LLWaitEOF);
  signal llstate, nllstate : llstates;


begin


  -- ensure that timestamps don't change while filling the FIFO (!)
  gen_ts_hires : if (TS_HIRES = 1) generate
    ts_ready       <= '1';
    prc_tsq    : process (clk)
    begin
      if rising_edge(clk) then
        if (ts_store = '1') then
          ts_count <= ts_count_i;
        end if;
      end if;
    end process;
  end generate;

  gen_ts_lores : if (TS_HIRES = 0) generate
    ts_ready <= '1' when (s40 = '1') and (ts_count_i(0) = '1') else '0';
    ts_count <= ts_count_i;
  end generate;



  ts_block <= x"f" &                    --  4
              x"0" &  --trig_src &      --  4
              l0id16_i &                -- 16
              ts_count;                 -- 40



  tx_opcode <= OC_STRM_CAPTURE_DATA when (capture_mode_i = '1') else
               OC_STRM_A13_RAW_DATA;
  --OC_STRM_A13_HIST_DATA
  --OC_STRM_A13_CAPT_DATA               -- using common OC with abcn


  fifo0 : cg_brfifo_2kx18
    port map (
      clk        => clk,
      srst       => rst,
      din        => fifo_din,
      wr_en      => fifo_wr,
      rd_en      => fifo_rd,
      dout       => fifo_dout,
      full       => full_o,
      overflow   => overflow_o,
      empty      => fifo_empty,
      underflow  => underflow_o,
      data_count => data_count_o
      --prog_full  => near_full_o
      );


  fifo_din(15 downto 0) <= fin_data;
  fifo_din(16)          <= fin_eof;
  fifo_din(17)          <= fin_sof;
  fifo_wr               <= fin_we;



  ---------------------------------------------------------------
  -- FIFO Fill Machine
  ---------------------------------------------------------------

  prc_sm_fifowr_sync : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        state <= StartNetPkt;
      else
        state <= nstate;

      end if;
    end if;
  end process;


  prc_sm_fifowr_async : process (pkt_valid_i, len_count, timeout_tick_i, en, seq_id, packet_i,
                                 ts_ready, ts_always_i, ts_disable_i,
                                 state)
  begin

    -- defaults
    pkt_rdack_o <= '0';
    fin_we      <= '1';
    fin_sof     <= '0';
    fin_eof     <= '0';
    --fin_data    <= x"0000";
    seq_id_inc  <= '0';
    len_inc     <= '0';
    len_clr     <= '0';
    ts_store <= '0';

    case state is

      when StartNetPkt =>
        nstate   <= StartNetPkt;
        fin_we   <= '0';
        len_clr  <= '1';
        if (en = '1') then
          nstate <= OpcodeSOF;
        end if;

        ---------------------------------------------------------------
      when OpcodeSOF =>
        fin_sof  <= '1';
        fin_data <= tx_opcode;
        nstate   <= SeqID;

      when SeqID =>
        fin_data   <= seq_id;
        seq_id_inc <= '1';
        nstate     <= Len;

      when Len =>
        fin_data <= conv_std_logic_vector(LEN_COUNT_MAX*8+6, 16);  -- convert pkts to bytes + ...
        nstate   <= Word0;

      when Word0 =>
        fin_data <= conv_std_logic_vector(STREAM_ID, 8) & x"00";
        nstate   <= Word1;

      when Word1 =>                     -- data format version
        fin_data <= x"0001";
        nstate   <= Word2;

      when Word2 =>                     -- stream source (and maybe more later)
        fin_data <= x"000" & '0' & strm_src_i;
        nstate   <= StartIdle;

        ----------------------------------------------------------        
      when StartIdle =>
        nstate     <= StartIdle;
        fin_we     <= '0';
        if (pkt_valid_i = '1') then
          ts_store <= '1';
          if (ts_always_i = '1') or (ts_disable_i = '1') then
            nstate <= Payload0;         -- ts will be added after data anyway
          else
            nstate <= TSPayload0;
          end if;
        end if;


        ---------------------------------------------  
      when TSPayload0 =>
        nstate   <= TSPayload0;
        fin_we   <= '0';
        fin_data <= ts_block(63 downto 48);
        if (ts_ready = '1') then        -- make sure timing is right
          fin_we <= '1';
          nstate <= TSPayload1;
        end if;

      when TSPayload1 =>
        fin_data <= ts_block(47 downto 32);
        len_inc  <= '1';                -- done here as prev state iffy
        nstate   <= TSPayload2;

      when TSPayload2 =>
        fin_data <= ts_block(31 downto 16);
        nstate   <= TSPayload3;

      when TSPayload3 =>
        fin_data  <= ts_block(15 downto 0);
        if (len_count = LEN_COUNT_MAX) then
          fin_eof <= '1';
          nstate  <= StartNetPkt;
        else
          nstate  <= WaitNext;
        end if;

        ----------------------------------------------------------
      when Payload0 =>
        len_inc  <= '1';
        fin_data <= packet_i(63 downto 48);
        nstate   <= Payload1;

      when Payload1 =>
        fin_data <= packet_i(47 downto 32);
        nstate   <= Payload2;

      when Payload2 =>
        fin_data <= packet_i(31 downto 16);
        nstate   <= Payload3;

      when Payload3 =>
        fin_data     <= packet_i(15 downto 0);
        pkt_rdack_o  <= '1';
        if (len_count = LEN_COUNT_MAX) then
          fin_eof    <= '1';
          nstate     <= StartNetPkt;
        else
          if (ts_always_i = '1') then
            if (ts_disable_i = '0') then
              nstate <= TSPayload0;
            else
              nstate <= WaitNext;
            end if;
          else
            nstate   <= WaitNext;
          end if;
        end if;

        -----------------------------------------------
      when WaitNext =>
        nstate   <= WaitNext;
        fin_we   <= '0';
        if (pkt_valid_i = '1') then
          ts_store <= '1';
          nstate <= Payload0;
        elsif (timeout_tick_i = '1') then
          nstate <= WaitNextTO;
        end if;


      when WaitNextTO =>                -- Filter lucky ticks
        nstate   <= WaitNextTO;
        fin_we   <= '0';
        if (pkt_valid_i = '1') then
          ts_store <= '1';
          nstate <= Payload0;
        elsif (timeout_tick_i = '1') then
          nstate <= WaitNextTO2;
        end if;


      when WaitNextTO2 =>               -- It's been a long wait, add TS before data
        nstate     <= WaitNextTO2;
        fin_we     <= '0';
        if (pkt_valid_i = '1') then
          ts_store <= '1';
          if (ts_always_i = '0') or (ts_disable_i = '1') then
            nstate <= Payload0;
          else
            nstate <= TSPayload0;       -- start-TS
          end if;
        elsif (timeout_tick_i = '1') then
          ts_store <= '1';
          if (ts_disable_i = '0') then
            nstate <= TSPayload0;
          end if;
        end if;

        ------------------------------------------------------

    end case;
  end process;




  prc_len_count : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        len_count <= 0;

      else
        if (len_clr = '1') then
          len_count <= 0;

        elsif (len_inc = '1') then
          if (len_count /= LEN_COUNT_MAX) then
            len_count <= len_count + 1;

          end if;
        end if;
      end if;
    end if;
  end process;



  prc_fifo_data_ready : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        fifo_data_ready <= '0';

      else
        if (fin_eof = '1') then
          fifo_data_ready <= '1';
        elsif (fifo_eof = '1') then
          fifo_data_ready <= '0';
        end if;
      end if;
    end if;
  end process;




  ---------------------------------------------------------------
  -- FIFO LL Read Machine
  ---------------------------------------------------------------


  fifo_eof  <= fifo_dout(16);
  fifo_sof  <= fifo_dout(17);
  fifo_data <= fifo_dout(15 downto 0);


  lls_o.data <= fifo_data;


  prc_sm_fiford_sync : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        llstate <= LLIdle;
      else
        llstate <= nllstate;

      end if;
    end if;
  end process;


  prc_sm_fiford_async : process (llstate, fifo_data_ready, fifo_sof, lld_i, fifo_eof)
  begin

    -- defaults
    nllstate      <= LLIdle;
    lls_o.src_rdy <= '1';
    lls_o.sof     <= '0';
    lls_o.eof     <= '0';
    fifo_rd       <= '0';

    case llstate is

      when LLIdle =>
        nllstate      <= LLIdle;
        lls_o.src_rdy <= '0';
        if (fifo_data_ready = '1') then
          nllstate    <= LLFluffSOF;
        end if;


      when LLFluffSOF =>
        nllstate      <= LLFluffSOF;
        lls_o.src_rdy <= '0';
        fifo_rd       <= '1';
        if (fifo_sof = '1') then
          fifo_rd     <= '0';
          nllstate    <= LLSrcRdy;
        end if;


      when LLSrcRdy =>
        nllstate   <= LLSrcRdy;
        if (lld_i = '1') then
          nllstate <= LLSOF;
        end if;

      when LLSOF =>
        nllstate   <= LLSOF;
        lls_o.sof  <= '1';
        if (lld_i = '1') then
          fifo_rd  <= '1';
          nllstate <= LLWaitEOF;
        end if;


      when LLWaitEOF =>
        nllstate      <= LLWaitEOF;
        if (lld_i = '1') then
          fifo_rd     <= '1';
          if (fifo_eof = '1') then
            lls_o.eof <= '1';
            fifo_rd   <= '0';
            nllstate  <= LLIdle;
          end if;
        end if;

    end case;
  end process;



  prc_seqid_count : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        seq_id <= (others => '0');

      else
        if (seq_id_inc = '1') then
          seq_id <= seq_id + '1';
        end if;

      end if;
    end if;

  end process;



end architecture;
