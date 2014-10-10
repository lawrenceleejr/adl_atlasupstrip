--
-- HSIO RX packet decoder
--
-- Chops off pre-opcode header and passes opcode out via FIFO
-- Sends Ack
-- 
--


-- changelog:
-- 2011-01ish - birthday
-- 2012-03ish - added ocfifo to fix long combintoral loop issue
-- 2012-06-12 - added ocfifofull monitoring
-- 2012-06-12 - removed watchdog - now handled by ocb_echo_watchdog
-- 2012-07-30 - attempt to convert tdack to "tristate" bus
-- 2013-07-09 - changed magic number to 0x876X to allow more than one process to send packets

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library utils;
use utils.pkg_types.all;
library locallink;
library hsio;
use hsio.pkg_core_globals.all;

entity rx_packet_decoder is
  port(
    rst_ocb_o   : out std_logic;
    -- rx ll fifo interface
    rx_lls_i    : in  t_llsrc;
    rx_lld_o    : out std_logic;
    -- decoded out (for debug)
    rx_magicn_o : out slv16;
    rx_seq_o    : out slv16;
    rx_len_o    : out slv16;
    rx_cbcnt_o  : out slv16;
    rx_opcode_o : out slv16;
    rx_ocseq_o  : out slv16;
    rx_size_o   : out slv16;
    -- locallink tx interface
    lls_o       : out t_llsrc;
    lld_i       : in  std_logic;
    -- hsio oc bus
    oc_data_o   : out slv16;
    oc_valid_o  : out std_logic;
    oc_dack_ni  : in  std_logic;
    -- infrastructure
    clk         : in  std_logic;
    rst         : in  std_logic
    );

-- Declarations

end rx_packet_decoder;


architecture rtl of rx_packet_decoder is

  component ll_ack_gen
    port (
      -- input interface
      opcode_i  : in  slv16;
      ocseq_i   : in  slv16;
      ocsize_i  : in  slv16;
      payload_i : in  slv16;
      send_i    : in  std_logic;
      busy_o    : out std_logic;
      -- locallink tx interface
      lls_o     : out t_llsrc;
      lld_i     : in  std_logic;

      -- infrastucture
      clk : in std_logic;
      rst : in std_logic
      );
  end component;

  component cg_brfifo_1kx18_ft
    port (
      clk         : in  std_logic;
      srst        : in  std_logic;
      din         : in  std_logic_vector(17 downto 0);
      wr_en       : in  std_logic;
      rd_en       : in  std_logic;
      dout        : out std_logic_vector(17 downto 0);
      full        : out std_logic;
      almost_full : out std_logic;
      empty       : out std_logic;
      data_count  : out std_logic_vector(3 downto 0)
      );
  end component;

  signal rst_ocb  : std_logic;


  
  signal rx_magicn : slv16;
  signal rx_seq    : slv16;
  signal rx_len    : slv16;
  signal rx_cbcnt  : slv16;

  signal rx_opcode : slv16;
  signal rx_ocseq  : slv16;
  signal rx_size   : slv16;
  --signal rx_word0  : slv16;

  signal rx_hdr1 : slv16_array (1 to 4) := (others => x"0000");
  signal rx_hdr2 : slv16_array (1 to 3) := (others => x"0000");

  signal header1_we : std_logic;
  signal header2_we : std_logic;


  signal wcount      : integer range 1 to 1023;
  signal wcount_inc  : std_logic;
  signal wcount_set1 : std_logic;

  signal occount      : slv8;
  signal occount_inc  : std_logic;
  signal occount_set1 : std_logic;

--  signal data_store    : slv16 := x"0000";
  signal data_store_en : std_logic;


  signal ack_send : std_logic;
  signal ack_busy : std_logic;

  signal oc_dtack_all    : std_logic;
  signal oc_port : slv4;

  signal ocfifo_ocdata      : std_logic_vector(15 downto 0);
  signal ocfifo_din         : std_logic_vector(17 downto 0);
  signal ocfifo_wr          : std_logic;
  signal ocfifo_valid       : std_logic;
  signal ocfifo_dout        : std_logic_vector(17 downto 0);
  signal ocfifo_almost_full : std_logic;
  signal ocfifo_data_count  : std_logic_vector(3 downto 0);
  signal ocfifo_rst         : std_logic;

  signal opcode_valid       : std_logic;

  
  signal tx_opcode : slv16;
  signal tx_ocseq  : slv16;

  type states is (
    --***WaitHeader, WaitSOF, WaitCountSize, WaitEOF, WaitEOFNoAck,
    WaitHeader, WaitCountSize, WaitEOF, WaitEOFNoAck,
    OC_Check, OC_Start0, OC_Start1, OC_Next,
    SendAck, SendAck_Busy,
    FIFOFull_SendAck, FIFOFull_SendAck_Busy, WaitOCFIFO_NotFull,
    Idle, Reset
    );

  signal state, nstate : states;


begin


  rx_magicn <= rx_hdr1(1);
  rx_seq    <= rx_hdr1(2);
  rx_len    <= rx_hdr1(3);
  rx_cbcnt  <= rx_hdr1(4);

  rx_magicn_o <= rx_magicn;
  rx_seq_o    <= rx_seq;
  rx_len_o    <= rx_len;
  rx_cbcnt_o  <= rx_cbcnt;

  rx_opcode <= rx_hdr2(1);
  rx_ocseq  <= rx_hdr2(2);
  rx_size   <= rx_hdr2(3);
-- rx_word0 <= rx_hdr(8);

  rx_opcode_o <= rx_opcode;
  rx_ocseq_o  <= rx_ocseq;
  rx_size_o   <= rx_size;
-- rx_word0_o <= rx_word0;


  rst_ocb_o <= rst_ocb when rising_edge(clk);

  -- State Machine
  --------------------------------------------------------
  prc_sync_part : process (clk)
  begin
    if rising_edge(clk) then

      if (rst = '1') then
        state <= Reset;

      else
        state <= nstate;

      end if;
    end if;
  end process;


------------------------------------------------------------------

  prc_async_machine : process (rx_lls_i.src_rdy, rx_lls_i.sof, rx_lls_i.eof, rx_lls_i.data, oc_dtack_all,
                               wcount, rx_magicn, occount, rx_cbcnt,
                               ack_busy, rx_ocseq, rx_size, ocfifo_almost_full,
                               state
                               )
  begin

    -- defaults
    nstate       <= Idle;
    rx_lld_o     <= '0';
    wcount_inc   <= '0';
    wcount_set1  <= '0';
    ocfifo_valid <= '0';
    ack_send     <= '0';
    tx_opcode    <= oc_insert_port(OC_ACK, oc_port);
    tx_ocseq     <= rx_ocseq;
    ocfifo_wr    <= '0';
    header1_we   <= '0';
    header2_we   <= '0';
    ocfifo_rst   <= '0';
    occount_set1 <= '0';
    occount_inc  <= '0';
    rst_ocb      <= '0';
    opcode_valid  <= '0';


    case state is

      -------------------------------------------------------------------
      when Reset =>
        nstate     <= Reset;
        ocfifo_rst <= '1';
        rst_ocb    <= '1';
        if (ack_busy = '0') then
          nstate   <= Idle;
        end if;


      when Idle =>
        nstate       <= Idle;
        wcount_set1  <= '1';
        occount_set1 <= '1';
        rx_lld_o     <= '1'; -- ***
        if (ocfifo_almost_full = '1') then
          nstate     <= FIFOFull_SendAck;
        elsif (rx_lls_i.src_rdy = '1') and (rx_lls_i.sof = '1') then
        --***elsif (rx_lls_i.src_rdy = '1') then
          wcount_set1  <= '0'; --***
          wcount_inc <= '1'; --***
          header1_we <= '1'; --***
          nstate     <= WaitHeader; --***
          --***nstate     <= WaitSOF;
        end if;


--       when WaitSOF =>
--         nstate       <= WaitSOF;
--         rx_lld_o     <= '1';
--         if (rx_lls_i.sof = '1') then
--           wcount_inc <= '1';
--           header1_we <= '1';
--           nstate     <= WaitHeader;
--         end if;


      when WaitHeader =>                -- magicn, seq, len, cbcnt
        nstate        <= WaitHeader;
        rx_lld_o      <= '1';
        wcount_inc    <= '1';
        header1_we    <= '1';
        if (wcount = 4) then
          wcount_set1 <= '1';
          if (rx_magicn(15 downto 4) = x"876") then -- leaving room for more sources
            nstate    <= OC_Check;
          else
            nstate    <= WaitEOFNoAck;
            --nstate <= OC_Check;
            --nstate <= SendAck;
          end if;
        end if;


      when OC_Check =>
        if (rx_lls_i.data = OC_RESET_OCB) then
          rst_ocb <= '1';
          nstate  <= WaitEOF;
        else
          nstate  <= OC_Start0;
        end if;



        --------------------------------------------------------------
      when OC_Start0 =>
        ocfifo_valid  <= '1';           -- rising oc_valid = sof 
        ocfifo_wr     <= '1';
        rx_lld_o      <= '1';
        wcount_inc    <= '1';
        header2_we    <= '1';
        opcode_valid  <= '1';
        nstate        <= OC_Start1;

        
      when OC_Start1 =>
        nstate        <= OC_Start1;
        ocfifo_valid  <= '1';
        ocfifo_wr     <= '1';
        rx_lld_o      <= '1';
        wcount_inc    <= '1';
        header2_we    <= '1';
        if (wcount = 3) then
          wcount_set1 <= '1';
          nstate      <= WaitCountSize;
        end if;


      when WaitCountSize =>
        nstate           <= WaitCountSize;
        if (ocfifo_almost_full = '0') then
          ocfifo_valid   <= '1';
          rx_lld_o       <= '1';
          ocfifo_wr      <= '1';
          wcount_inc     <= '1';
          if (rx_size = x"0000") then   -- *** this is cludgy - have another look one day
            rx_lld_o     <= '0';
            ocfifo_valid <= '0';
            nstate       <= OC_Next;
          elsif (wcount = conv_integer(rx_size(10 downto 1))) then
            ocfifo_valid <= '0';
            nstate       <= OC_Next;
          end if;
        end if;


      when OC_Next =>
        wcount_set1   <= '1';
        if (occount = rx_cbcnt) then
          nstate      <= WaitEOF;
        else
          occount_inc <= '1';
          nstate      <= OC_Start0;
        end if;


      when WaitEOF =>
        nstate     <= WaitEOF;
        rx_lld_o   <= '1';
        wcount_inc <= '1';
        if (rx_lls_i.eof = '1') then
          nstate   <= SendAck;
        end if;


      when WaitEOFNoAck =>
        nstate   <= WaitEOFNoAck;
        rx_lld_o <= '1';
        if (rx_lls_i.eof = '1') then
          nstate <= Idle;
        end if;

        -----------------------------------------------------------------
      when SendAck =>
        ack_send <= '1';
        nstate   <= SendAck_Busy;


      when SendAck_Busy =>
        nstate   <= SendAck_Busy;
        if (ack_busy = '0') then
          nstate <= Idle;
        end if;

        -------------------
      when FIFOFull_SendAck =>
        ack_send <= '1';
        nstate   <= FIFOFull_SendAck_Busy;


      when FIFOFull_SendAck_Busy =>
        nstate    <= FIFOFull_SendAck_Busy;
        tx_opcode <= oc_insert_port( OC_RXPKTDEC_FIFOFULL, oc_port);
        tx_ocseq  <= x"0000";
        if (ack_busy = '0') then
          nstate  <= WaitOCFIFO_NotFull;
        end if;

      when WaitOCFIFO_NotFull =>
        nstate   <= WaitOCFIFO_NotFull;
        if (ocfifo_almost_full = '0') then
          nstate <= Idle;
        end if;


    end case;
  end process;



  -- OCB Interface and FIFO
  -------------------------------------------------------------------------------------
  -- FIFO used to remove the combinatorial connection between rx_net_fifo and tx_net_
  -- fifo flow controls

  oc_dtack_all <= not oc_dack_ni;


  -- Only do routing if eth.type lsn > 7)
  oc_port <= x"0" when (rx_magicn(3) = '0') else ('0' & rx_magicn(2 downto 0));

  ocfifo_ocdata <= oc_insert_port(rx_lls_i.data, oc_port) when (opcode_valid = '1') else
                 rx_lls_i.data;

  --ocfifo_din <= '0' & ocfifo_valid & rx_lls_i.data;
  ocfifo_din <= '0' & ocfifo_valid & ocfifo_ocdata;

  inst_oc_fifo : cg_brfifo_1kx18_ft
    port map (
      clk         => clk,
      srst        => ocfifo_rst,
      din         => ocfifo_din,
      wr_en       => ocfifo_wr,
      rd_en       => oc_dtack_all,
      dout        => ocfifo_dout,
      full        => open,
      almost_full => ocfifo_almost_full,
      empty       => open,
      data_count  => ocfifo_data_count
      );

  oc_valid_o <= ocfifo_dout(16);
  oc_data_o  <= ocfifo_dout(15 downto 0);

--------------------------------------------------------------------

  prc_word_counter : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') or (wcount_set1 = '1') then
        wcount <= 1;

      elsif (wcount_inc = '1') then
        wcount <= wcount + 1;

      end if;
    end if;
  end process;


  prc_opcode_counter : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') or (occount_set1 = '1') then
        occount <= x"01";

      else
        if (occount_inc = '1') then
          occount <= occount + '1';
        end if;

      end if;
    end if;
  end process;


  prc_hdr_store : process (clk)
  begin
    if rising_edge(clk) then
      --if (rst = '1') then
      --  rx_hdr(5) <= x"ffec";         -- preset ocseq

      --else
      if (header1_we = '1') then
        rx_hdr1(wcount) <= rx_lls_i.data;
      end if;

      if (header2_we = '1') then
        rx_hdr2(wcount) <= rx_lls_i.data;
      end if;


      --end if;
    end if;
  end process;


  -------------------------------------------------------------------------
  -- Ack
  -------------------------------------------------------------------------


  pktdec_ack : ll_ack_gen
    port map (
      opcode_i  => tx_opcode,
      ocseq_i   => tx_ocseq,
      ocsize_i  => x"0002",
      payload_i => rx_seq,
      send_i    => ack_send,
      busy_o    => ack_busy,
      lls_o     => lls_o,
      lld_i     => lld_i,
      clk       => clk,
      rst       => rst
      );



end architecture;




