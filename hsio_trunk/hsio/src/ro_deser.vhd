--
-- Readout Deserialiser
--

-- Log:
-- 09/05/2012 - changed actions of almost full fifo to abort always in WaitBits
-- - stopped reverting to header detect after trailer timeout, rather wait for trailer indefinitely
-- - send truncated packet if fragments try for higher than 1
-- 02/10/2012 - added ff to header_seen_o, added "if en='0'" to WaitStart's


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library utils;
use utils.pkg_types.all;

library hsio;
use hsio.pkg_core_globals.all;

entity ro_deser is
   port( 
      STREAM_ID            : in     integer;
      RAW_MULTI_EN         : in     std_logic;
      sr_data_word_i       : in     std_logic_vector (15 downto 0);
      header_seen_i        : in     std_logic;
      trailer_seen_i       : in     std_logic;
      tseen_lch_i          : in     std_logic;
      tseen_lch_clr_o      : out    std_logic;
      gendata_sel_i        : in     std_logic;
      capture_mode_i       : in     std_logic;
      wide_cap_mode_i      : in     std_logic;
      capture_len_i        : in     std_logic_vector (8 downto 0);
      strm_src_i           : in     std_logic_vector (2 downto 0);
      capture_start_i      : in     std_logic;
      --ocrawcom_start_i     : in     std_logic;
      mode40_strobe_i      : in     std_logic;
      -- output fifo interface
      fifo_we_o            : out    std_logic;
      fifo_eof_o           : out    std_logic;
      fifo_sof_o           : out    std_logic;
      fifo_data_o          : out    slv16;
      data_len_o           : out    std_logic_vector (10 downto 0);
      data_len_wr_o        : out    std_logic;
      data_truncd_o        : out    std_logic;
      -- fifo monitoring
      fifo_near_full_i     : in     std_logic;
      fifo_full_i          : in     std_logic;
      len_fifo_near_full_i : in     std_logic;
      len_fifo_full_i      : in     std_logic;
      -- header details
      l1id_i               : in     std_logic_vector (23 downto 0);
      bcid_i               : in     std_logic_vector (11 downto 0);
      -- deser monitoring
      dropped_pkts_o       : out    slv8;
      -- infra
      en                   : in     std_logic;
      clk                  : in     std_logic;
      rst                  : in     std_logic
   );

-- Declarations

end ro_deser ;

--
architecture rtl of ro_deser is


  -- need to keep tabs on data size to ensure we don't exceed ethernet frame size.
  -- also now want it a multiple of 16
  constant OC_WORDS_MAX  : integer := 736;  -- 1488-16=1472/2 = 743/16 = 46
  constant OC_BLOCKS_MAX : integer := OC_WORDS_MAX/16;

  -- signal dcom_seqid_inc : std_logic;
  signal data_len_store : std_logic;

  signal fifo_data       : std_logic_vector(15 downto 0);
  signal fifo_we         : std_logic;
  signal fifo_sof        : std_logic;
  signal fifo_eof        : std_logic;
  signal fifo_data_we    : std_logic;
  signal fifo_dcomhdr_we : std_logic;
  signal fifo_zero_we    : std_logic;


  signal dcom_fragid     : std_logic;
  signal dcom_fragid_inc : std_logic;

  signal dcom_seqid  : slv16;
  signal chan_fragid : slv16;

  signal bit_counter     : integer range 0 to 16#3FFF#;
  signal bit_counter_clr : std_logic;
  signal bit_counter_slv : std_logic_vector(13 downto 0);

  signal block_count  : std_logic_vector(5 downto 0);
  signal word_count   : std_logic_vector(9 downto 0);
  signal word16_count : std_logic_vector(3 downto 0);
  signal word_bit     : std_logic_vector(3 downto 0);

  signal word_bit_f : std_logic;

  signal mode_coded : std_logic_vector(7 downto 0);


  type states is (
    WaitStart, WaitBitsMain, WaitBitsHeader,
    CaptureWaitStart, CaptureWaitBitsMain, CaptureWaitBitsHeader,
    InTrailer, PadTrailerEOP,
    FragmentEOP, PadFragmentEOP, NextFragment,
    CaptureEOP, CaptureFIFONearFullEOP,  --CaptureEmptyEv,
    TruncWaitTrailer, EmptyEvWaitTrailer,
    FIFONearFullEOP,
    SendEmptyEvErrPkt, EmptyEvErrPktSOF, EmptyEvErrPktEOF, EEWaitTrailer,
    SendErrorPkt, ErrorPktSOF, ErrorPktEOF,
    Reset
    );
  signal state : states := Reset;

  constant OC_HEADER_LEN       : integer := 3;
  constant DATA_HEADER_LEN     : integer := 1;
  constant TRAILER_PAD_LEN     : integer := 1;
  constant HEADER_ALIGN_OFFSET : integer := -7;

  constant OC_START_BCNT : integer := 16 +  -- added to increase len reported
                                      (TRAILER_PAD_LEN*16)+
                                      (DATA_HEADER_LEN*16)+
                                      HEADER_ALIGN_OFFSET;

  constant DATA_START_BCNT        : integer := OC_START_BCNT + OC_HEADER_LEN + DATA_HEADER_LEN;
  constant DATA_START_BCNT_MINUS1 : integer := DATA_START_BCNT - 1;


-- signal dcomhdr_data : slv16;
--*** fixme:+1???
  signal dcomhdr : slv16_array(DATA_START_BCNT+1 downto OC_START_BCNT);  --


  signal errhdr         : slv16_array(OC_START_BCNT+4 downto OC_START_BCNT);
  signal fifo_errhdr_we : std_logic;

  signal dropped_pkts_inc   : std_logic;
  signal dropped_pkts_count : slv8;

  signal   error_code            : slv16;
  constant EC_EMPTY_EVENT        : slv16 := x"0001";
  constant EC_TRUNCEV_TRAILER_TO : slv16 := x"0002";
  constant EC_FRAGEV_TRAILER_TO  : slv16 := x"0003";
  constant EC_EMPTYEV_TRAILER_TO : slv16 := x"0004";
  constant EC_LEN_FIFO_FULL      : slv16 := x"0005";

  signal strm_id_final : integer;

begin

  mode_coded <= "00000" &
                capture_mode_i &
                gendata_sel_i &
                '0';


-- gstmid0 : if (C_RAW_MULTI_EN = 1) and (STREAM_ID < 16) generate
-- strm_id_final <= (STREAM_ID+16) when strm_src_i = "001" else
-- (STREAM_ID+32) when strm_src_i = "010" else
-- STREAM_ID;
-- end generate;

-- gstmid16 : if (C_RAW_MULTI_EN = 1) and (STREAM_ID >= 16) generate
-- strm_id_final <= STREAM_ID;
-- end generate;

-- grawmulti0 : if (C_RAW_MULTI_EN = 0) generate
-- strm_id_final <= STREAM_ID;
-- end generate;

  -- *** Hopefully the optimiser will see this for what it is - generics for pre-
  -- synthed blocks
  
  prc_strm_id : process (RAW_MULTI_EN, STREAM_ID, strm_src_i)
  begin

    if (RAW_MULTI_EN = '1') then
      if (STREAM_ID < 16) then
        if (strm_src_i = "001") then
          strm_id_final <= (STREAM_ID+16);

        elsif(strm_src_i = "010") then
          strm_id_final <= (STREAM_ID+32);

        else
          strm_id_final <= STREAM_ID;
          
        end if;
      else                              -- (STREAM_ID >= 16) then
        strm_id_final   <= STREAM_ID;
        
      end if;
    else                                --(RAW_MULTI_EN = 0) then
      strm_id_final <= STREAM_ID;

    end if;
  end process;




    chan_fragid <= conv_std_logic_vector(strm_id_final, 8) & "0000000" & dcom_fragid;


    -- Note: headers also include first word/s of payload as needed

-- *** fixme : should need the +1 below
    dcomhdr(OC_START_BCNT+1) <= x"D0" & mode_coded;
    dcomhdr(OC_START_BCNT+2) <= dcom_seqid;   -- Sequence ID
    dcomhdr(OC_START_BCNT+3) <= x"0000";      -- Payload Size place holder
    dcomhdr(OC_START_BCNT+4) <= chan_fragid;  -- Channel/Fragment ID


    errhdr(OC_START_BCNT+0) <= x"F0" & mode_coded;
    errhdr(OC_START_BCNT+1) <= dcom_seqid;   -- Sequence ID
    errhdr(OC_START_BCNT+2) <= x"0000";      -- Payload Size place holder
    errhdr(OC_START_BCNT+3) <= chan_fragid;  -- Channel/Fragment ID
    errhdr(OC_START_BCNT+4) <= error_code;

    ---------------------------------------------------
    -- FIFO Data Output
    ---------------------------------------------------

    fifo_data <= sr_data_word_i       when (fifo_data_we = '1')    else
                 dcomhdr(bit_counter) when (fifo_dcomhdr_we = '1') else
                 errhdr(bit_counter)  when (fifo_errhdr_we = '1')  else
                 (others => '0');       -- fifo_zero_we

    fifo_we     <= fifo_data_we or fifo_dcomhdr_we or fifo_zero_we or fifo_errhdr_we;
    fifo_data_o <= fifo_data;
    fifo_we_o   <= fifo_we;
    fifo_eof_o  <= fifo_eof;
    fifo_sof_o  <= fifo_sof;



    ---------------------------------------------------
    -- Deserialiser Machine
    ---------------------------------------------------


    prc_bit_counter : process (clk)
    begin
      if rising_edge(clk) then

        if (rst = '1') then
          bit_counter <= OC_START_BCNT;

        else
          if (mode40_strobe_i = '1') then

            if (bit_counter_clr = '1') then
              bit_counter <= OC_START_BCNT;

            else
              bit_counter <= bit_counter + 1;
            end if;
          end if;
        end if;
      end if;

    end process;

    bit_counter_slv <= conv_std_logic_vector(bit_counter, 14);
    block_count     <= bit_counter_slv(13 downto 8) when (wide_cap_mode_i = '0') else  bit_counter_slv(9 downto 4);
    word_count      <= bit_counter_slv(13 downto 4);
    word16_count    <= bit_counter_slv(7 downto 4);
    word_bit        <= bit_counter_slv(3 downto 0);

    word_bit_f <= '1' when (word_bit = x"f") else '0';




-- prc_pseudo_sync_state_part : process (clk, mode40_strobe_i)
-- begin
-- if (mode40_i = '0') then
-- state <= nstate;
-- else
--  -- This is the cludge needed to make things go at 40MHz
--       if rising_edge(clk) then
--         if (rst = '1') then
--           state <= Reset;
--         else
--           state <= nstate;
--         end if;
--       end if;
--     end if;
--   end process;


    prc_sm_inproc : process (clk)
    begin
      if rising_edge(clk) then
        if (rst = '1') then
          fifo_data_we     <= '0';
          fifo_dcomhdr_we  <= '0';
          fifo_zero_we     <= '0';
          fifo_sof         <= '0';
          fifo_eof         <= '0';
          bit_counter_clr  <= '1';
          -- dcom_seqid_inc <= '0';
          data_len_store   <= '0';
          state            <= Reset;
          fifo_errhdr_we   <= '0';
          dropped_pkts_inc <= '0';
          dcom_fragid      <= '0';
          tseen_lch_clr_o  <= '0';
          error_code       <= (others => '0');

        else



          -- defaults
          fifo_data_we     <= '0';
          fifo_dcomhdr_we  <= '0';
          fifo_zero_we     <= '0';
          fifo_sof         <= '0';
          fifo_eof         <= '0';
          dropped_pkts_inc <= '0';
          tseen_lch_clr_o  <= '0';
          fifo_errhdr_we   <= '0';
          data_len_store   <= '0';



          if (mode40_strobe_i = '1') then

            -- defaults                 -- need to hold value at 40
            bit_counter_clr <= '0';
            tseen_lch_clr_o <= '0';


            case state is


              when Reset                   =>
                state           <= Reset;
                bit_counter_clr <= '1';
                tseen_lch_clr_o <= '1';
                dcom_fragid     <= '0';
                error_code      <= (others => '0');
                if (en = '1') then
                  if (capture_mode_i = '1') then
                    state       <= CaptureWaitStart;
                  else
                    state       <= WaitStart;
                  end if;
                end if;


              when WaitStart =>
                state <= WaitStart;

                bit_counter_clr <= '1';
                tseen_lch_clr_o <= '1';

                if (en = '0') then
                  state <= Reset;

                elsif (capture_mode_i = '1') then  -- splitting Norm/Cap mode states
                  state <= CaptureWaitStart;

                elsif (header_seen_i = '1') then
                  bit_counter_clr <= '0';
                  --dcom_seqid_inc  <= '1';
                  if (len_fifo_near_full_i = '1') then
                    error_code    <= EC_LEN_FIFO_FULL;
                    state         <= SendErrorPkt;

                  elsif (fifo_full_i = '1') or (fifo_near_full_i = '1') or (len_fifo_full_i = '1') then  --drop
                    dropped_pkts_inc <= '1';
                    state            <= Reset;

                  else
                    state <= WaitBitsHeader;
                  end if;
                end if;


              when CaptureWaitStart =>
                state <= CaptureWaitStart;

                bit_counter_clr <= '1';
                tseen_lch_clr_o <= '1';

                if (en = '0') then
                  state <= Reset;

                elsif (capture_mode_i = '0') then  -- splitting Cap/Norm mode states
                  state <= WaitStart;

                elsif (capture_start_i = '1') then
                  bit_counter_clr <= '0';
                  --dcom_seqid_inc  <= '1';

                  if (len_fifo_near_full_i = '1') then
                    error_code <= EC_LEN_FIFO_FULL;
                    state      <= SendErrorPkt;

                  elsif (fifo_full_i = '1') or (fifo_near_full_i = '1') or (len_fifo_full_i = '1') then  --drop
                    dropped_pkts_inc <= '1';
                    state            <= Reset;
                  else
                    state            <= CaptureWaitBitsHeader;
                  end if;
                end if;


              when WaitBitsHeader =>
                state <= WaitBitsHeader;

                if (word_bit_f = '1') then
                  fifo_data_we <= '1';
                end if;


                if (bit_counter = OC_START_BCNT) then
                  fifo_sof <= '1';
                end if;

                if (bit_counter < DATA_START_BCNT) then  -- write header words  
                  fifo_dcomhdr_we <= '1';
                end if;

                if (bit_counter = DATA_START_BCNT_MINUS1) then
                  state <= WaitBitsMain;
                end if;


              when WaitBitsMain =>
                state <= WaitBitsMain;

                if (word_bit_f = '1') then
                  fifo_data_we <= '1';
                end if;

                if (fifo_near_full_i = '1') then
                  data_len_store <= '1';
                  -- data_truncd_o  <= '1';
                  state          <= FIFONearFullEOP;
                else
                  if (tseen_lch_i = '1') then
                    -- data_len_store <= '1';  -- Done later
                    state        <= InTrailer;
                  elsif (block_count = OC_BLOCKS_MAX) then
                    --data_len_store <= '1';
                    state        <= FragmentEOP;
                  end if;
                end if;

              ------------------------------------------------------------
              when CaptureWaitBitsHeader =>
                state <= CaptureWaitBitsHeader;

                if (word_bit_f = '1') then
                  fifo_data_we <= '1';
                end if;

                if (bit_counter = OC_START_BCNT) then
                  fifo_sof <= '1';
                end if;

                if (bit_counter < DATA_START_BCNT) then  -- write header words  
                  fifo_dcomhdr_we <= '1';
                end if;

                if (bit_counter = DATA_START_BCNT_MINUS1) then
                  state <= CaptureWaitBitsMain;
                end if;


              when CaptureWaitBitsMain =>
                state <= CaptureWaitBitsMain;

                if (word_bit_f = '1') or (wide_cap_mode_i = '1') then
                  fifo_data_we <= '1';
                end if;

                if (fifo_near_full_i = '1') then
                  data_len_store <= '1';
                  -- data_truncd_o  <= '1';
                  state          <= CaptureFIFONearFullEOP;
                elsif (block_count(4 downto 0) >= (capture_len_i(8 downto 4))) then
                  data_len_store <= '1';
                  state          <= CaptureEOP;
                end if;


                -- Normal Packet handling incl. Capture
                ---------------------------------------
              when InTrailer =>
                state            <= InTrailer;
                if (word_bit_f = '1') then
                  fifo_data_we   <= '1';
                  data_len_store <= '1';
                  state          <= PadTrailerEOP;
                end if;


              when PadTrailerEOP =>     -- add the zeros artificually so sm is ready for a directly following header
                fifo_zero_we <= '1';
                fifo_eof     <= '1';
                state        <= Reset;


              when CaptureEOP =>
                state          <= CaptureEOP;
                if (word_bit_f = '1') then
                  fifo_data_we <= '1';
                  fifo_eof     <= '1';
                  state        <= Reset;
                end if;



                -- Fragment handling
                ----------------------------------------------

              when FragmentEOP =>
                state            <= FragmentEOP;
                if (word_bit_f = '1') then
                  data_len_store <= '1';
                  --if (dcom_fragid = '1') then
                  --  data_truncd_o <= '1';
                  --end if;
                  fifo_data_we   <= '1';
                  state          <= PadFragmentEOP;
                end if;


              when PadFragmentEOP =>
                fifo_zero_we <= '1';
                fifo_eof     <= '1';
                state        <= NextFragment;


              when NextFragment =>
                state             <= NextFragment;
                if (dcom_fragid = '1') then   --already on second fragment
                  state           <= TruncWaitTrailer;
                elsif (word_bit = x"7") then  -- re-align
                  dcom_fragid     <= '1';
                  bit_counter_clr <= '1';
                  state           <= WaitBitsHeader;
                end if;


                -- FIFO near full/truncated packet handling
                ----------------------------------------------
              when FIFONearFullEOP =>
                state <= FIFONearFullEOP;

                if (word_bit_f = '1') then
                  fifo_data_we    <= '1';
                  fifo_eof        <= '1';
                  bit_counter_clr <= '1';
                  --data_truncd_o   <= '1';  -- now must be done before data_len_store
                  if (tseen_lch_i = '1') then
                    state         <= Reset;
                  else
                    state         <= TruncWaitTrailer;
                  end if;
                end if;


              when TruncWaitTrailer =>
                state <= TruncWaitTrailer;

                if (tseen_lch_i = '1') then
                  state      <= Reset;
                elsif (block_count = "111111") then  -- timeout waiting for trailer
                  error_code <= EC_TRUNCEV_TRAILER_TO;
                  state      <= SendEmptyEvErrPkt;
                end if;


              when CaptureFIFONearFullEOP =>
                state             <= CaptureFIFONearFullEOP;
                if (word_bit_f = '1') then
                  fifo_data_we    <= '1';
                  fifo_eof        <= '1';
                  bit_counter_clr <= '1';
                  --data_truncd_o   <= '1';
                  state           <= Reset;
                end if;


                -- Empty Event Handling
                --------------------------------------------------
              when EmptyEvWaitTrailer =>
                state <= EmptyEvWaitTrailer;

                if (tseen_lch_i = '1') then
                  error_code <= EC_EMPTY_EVENT;
                  state      <= SendEmptyEvErrPkt;
                elsif (block_count = "111111") then  -- timeout waiting for trailer
                  error_code <= EC_EMPTYEV_TRAILER_TO;
                  state      <= SendEmptyEvErrPkt;
                end if;


                --when CaptureEmptyEv =>
                --  error_code <= EC_EMPTY_EVENT;
                --  state      <= SendEmptyEvErrPkt;



                -- Empty Event Error Packet Sending
                -------------------------------------------------------
              when SendEmptyEvErrPkt =>
                data_truncd_o   <= '0';
                bit_counter_clr <= '1';
                state           <= EmptyEvErrPktSOF;


              when EmptyEvErrPktSOF =>
                fifo_errhdr_we <= '1';
                fifo_sof       <= '1';
                state          <= EmptyEvErrPktEOF;


              when EmptyEvErrPktEOF =>
                state          <= EmptyEvErrPktEOF;
                fifo_errhdr_we <= '1';

                if (bit_counter = OC_START_BCNT+2) then
                  data_len_store <= '1';
                end if;

                if (bit_counter = OC_START_BCNT+3) then
                  fifo_eof <= '1';
                  state    <= EEWaitTrailer;
                end if;

              when EEWaitTrailer =>
                if (tseen_lch_i = '1') then
                  state <= Reset;
                else
                  state <= EEWaitTrailer;
                end if;


                -- Error Packet Sending
                -------------------------------------------------------
              when SendErrorPkt =>
                --data_truncd_o   <= '0';
                bit_counter_clr <= '1';
                state           <= ErrorPktSOF;


              when ErrorPktSOF =>
                fifo_errhdr_we <= '1';
                fifo_sof       <= '1';
                state          <= ErrorPktEOF;


              when ErrorPktEOF =>
                state          <= ErrorPktEOF;
                fifo_errhdr_we <= '1';

                if (bit_counter = OC_START_BCNT+2) then
                  data_len_store <= '1';
                end if;

                if (bit_counter = OC_START_BCNT+3) then
                  fifo_eof <= '1';
                  state    <= Reset;
                end if;


            end case;
          end if;
        end if;
      end if;
    end process;




    -- Sequence ID
    -----------------------------------------------------------------------


    prc_dcom_seqid_count : process (clk)
    begin
      if rising_edge(clk) then
        if (rst = '1') then
          dcom_seqid <= (others => '0');

          --elsif (dcom_seqid_inc = '1') then
        elsif (fifo_sof = '1') and (fifo_we = '1') then
          dcom_seqid <= dcom_seqid + '1';

        end if;
      end if;
    end process;


-- Len FIFO Write
--------------------------------------------------------------------------

    data_len_wr_o <= data_len_store;
--data_len_o <= block_count & x"0" & '0';  -- double for bytes
    data_len_o    <= word_count & '0';       -- double for bytes


-- Dropped Packets Counter
--------------------------------------------------------------------------

    prc_dropped_pks_count : process (clk)
    begin
      if rising_edge(clk) then
        if (rst = '1') then
          dropped_pkts_count <= (others => '0');

        elsif (dropped_pkts_count < x"ff") and (dropped_pkts_inc = '1') then
          dropped_pkts_count <= dropped_pkts_count + '1';

        end if;
      end if;
    end process;


    dropped_pkts_o <= dropped_pkts_count;



  end architecture rtl;

