--
-- Opcode Block STREAMS
--
-- Opcodes serviced: OC_STRM_CONF_WR, OC_STRM_REQ_STAT [, OC_STRM_CONF2_WR]
-- 
-- Write to bank(s) of 16b registers, send stat reqs
--
-- 
-- 
-- 
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library utils;
use utils.pkg_types.all;

library hsio;
use hsio.pkg_core_globals.all;

library locallink;

entity ocb_streams is
   generic( 
      NSTREAMS : integer := 16
   );
   port( 
      -- locallink tx interface
      lls_o           : out    t_llsrc;
      lld_i           : in     std_logic;
      -- oc rx interface
      oc_valid_i      : in     std_logic;
      oc_data_i       : in     slv16;
      oc_dack_no      : out    std_logic;
      -- streams interface
      strm_req_stat_o : out    std_logic_vector ((NSTREAMS-1) downto 0);
      strm_reg_o      : out    slv16_array ((NSTREAMS-1) downto 0);
      strm_cmd_o      : out    slv16_array ((NSTREAMS-1) downto 0);
      -- infrastructure
      clk             : in     std_logic;
      rst             : in     std_logic
   );

-- Declarations

end ocb_streams ;


architecture rtl of ocb_streams is


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
      clk       : in  std_logic;
      rst       : in  std_logic
      );
  end component;



  signal a_ok : std_logic;

  signal ack_send    : std_logic;
  signal ack_busy    : std_logic;
  signal ack_opcode  : slv16;
  signal ack_opcode0 : slv16;
  signal ack_size    : slv16;
  signal ack_payload : slv16;

  signal ocseq_store      : std_logic;
  signal ocsize_store     : std_logic;
  signal rx_ocseq         : slv16;
  signal rx_port          : slv4;
  signal oc_data_opcodepl : slv16;

  signal rx_ocsize     : slv16;
  signal rx_ocsize_int : integer range 0 to 2047;


  constant BCOUNT_MAX : integer := 2047;
  signal   bcount     : integer range 0 to BCOUNT_MAX;
  signal   bcount_clr : std_logic;

  signal strm_mask       : slv16_array(8 downto 0);
  signal strm_mask_store : std_logic;
  signal strm_mask_all   : std_logic_vector(NSTREAMS-1 downto 0);



  signal send_req_stat : std_logic;


  signal stream       : slv8;
  signal stream_int   : integer range 0 to (NSTREAMS-1);
  signal stream_store : std_logic;

  signal reg_mask : slv16;
  signal reg_data : slv16_array(NSTREAMS-1 downto 0);

  signal mask_store  : std_logic;
  signal reg_store   : std_logic;
  signal cmd_strobe  : std_logic;
  signal breg_store  : std_logic;
  signal bcmd_strobe : std_logic;

-- signal stream_id_overflow : std_logic;

  type oc_decoded_type is (CONF_WR, B_CONF_WR,
                           COMMAND, B_COMMAND,
                           REQ_STAT
                           );

  signal oc_decoded       : oc_decoded_type;
  signal oc_decoded_d     : oc_decoded_type;
  signal oc_decoded_store : std_logic;
  signal oc_decode_en     : std_logic;


  type states is (Opcode, OCSeq, Size,
                  CW_DataMask, CW_StreamAddr, CW_Data,
                  BCW_DataMask, BCW_Data,
                  CMD_StreamAddr, CMD_Data,
                  BCMD_Data,
                  RX_Strm_Mask, GS_Send_Req_Stat,
                  WaitEOF,
                  SendAck, WaitAckBusy,
                  WaitOCReady, Idle, OCDone
                  );

  signal state, nstate : states;


begin


  --stream_id_overflow <= '0' when (conv_integer(oc_data_i(6 downto 0)) < NSTREAMS) else '1';

  oc_data_opcodepl <= oc_get_opcodepl(oc_data_i);

  -- State Machine
  --------------------------------------------------------
  prc_sync_part : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        state <= WaitOCReady;
      else
        state <= nstate;

      end if;
    end if;
  end process;



  prc_async_machine : process (oc_valid_i, oc_data_i, oc_decoded, oc_data_opcodepl,
                               bcount, ack_busy,  --stream_id_overflow,
                               rx_ocsize_int, strm_mask_all,
                               state
                               )
  begin

    -- defaults
    nstate           <= Idle;
    oc_dack_no       <= '1';
    ack_send         <= '0';
    ocseq_store      <= '0';
    ocsize_store     <= '0';
    oc_decoded_d     <= CONF_WR;
    oc_decoded_store <= '0';
    stream_store     <= '0';
    mask_store       <= '0';
    cmd_strobe       <= '0';
    reg_store        <= '0';
    bcmd_strobe      <= '0';
    breg_store       <= '0';
    bcount_clr       <= '0';
    strm_mask_store  <= '0';
    send_req_stat    <= '0';


    case state is

      -------------------------------------------------------------------

      when WaitOCReady =>                      -- Make sure we get rising edge of oc_valid
        oc_dack_no <= 'Z';
        nstate     <= WaitOCReady;
        if (oc_valid_i = '0') then
          nstate   <= Idle;
        end if;


      when Idle =>
        nstate             <= Idle;
        oc_dack_no         <= 'Z';
        if (oc_valid_i = '1') then
          oc_decoded_store <= '1';

          case oc_data_opcodepl is
            when OC_STRM_CONF_WR  => oc_decoded_d <= CONF_WR; nstate <= Opcode;
            when OC_BSTRM_CONF_WR => oc_decoded_d <= B_CONF_WR; nstate <= Opcode;
            when OC_STRM_REQ_STAT => oc_decoded_d <= REQ_STAT; nstate <= Opcode;
            when OC_STRM_COMMAND  => oc_decoded_d <= COMMAND; nstate <= Opcode;
            when OC_BSTRM_COMMAND => oc_decoded_d <= B_COMMAND; nstate <= Opcode;
            when others           => nstate       <= WaitOCReady;
          end case;
        end if;


      when Opcode =>
        oc_dack_no <= '0';
        nstate     <= OCseq;


      when OCSeq =>
        oc_dack_no  <= '0';
        ocseq_store <= '1';
        nstate      <= Size;


      when Size          =>
        oc_dack_no                 <= '0';
        ocsize_store               <= '1';
        bcount_clr                 <= '1';
        case oc_decoded is
          when CONF_WR   => nstate <= CW_DataMask;
          when B_CONF_WR => nstate <= RX_Strm_Mask;
          when COMMAND   => nstate <= CMD_StreamAddr;
          when B_COMMAND => nstate <= RX_Strm_Mask;
          when REQ_STAT  => nstate <= RX_Strm_Mask;
        end case;


        --== Conf Write ================================================

      when CW_DataMask =>

        oc_dack_no <= '0';
        mask_store <= '1';
        nstate     <= CW_StreamAddr;


      when CW_StreamAddr =>
        if (bcount < (rx_ocsize_int/2)) then  -- do this here to get bcount+1, and catch bad packets
          oc_dack_no   <= '0';
          --if (stream_id_overflow = '0') then
          stream_store <= '1';
          --end if;
          nstate       <= CW_Data;
        else
          nstate       <= WaitEOF;
        end if;


      when CW_Data =>

        --if (stream_id_overflow = '0') then
        reg_store  <= '1';
        --end if;
        oc_dack_no <= '0';
        if (oc_valid_i = '1') then
          nstate   <= CW_StreamAddr;
        else
          nstate   <= SendAck;
        end if;


        --== Send Command =================================================

      when CMD_StreamAddr =>
        if (bcount < (rx_ocsize_int/2)) then  -- need bcount+1
          oc_dack_no   <= '0';
          --if (stream_id_overflow = '0') then
          stream_store <= '1';
          --end if;
          nstate       <= CMD_Data;
        else
          nstate       <= WaitEOF;
        end if;


      when CMD_Data =>
        --if (stream_id_overflow = '0') then
        cmd_strobe <= '1';
        --end if;
        oc_dack_no <= '0';
        if (oc_valid_i = '1') then      -- *** there must be a better way
          nstate   <= CMD_StreamAddr;
        else
          nstate   <= SendAck;
        end if;



        --== Generic RX Mask Store =========================================

      when RX_Strm_Mask    =>
        nstate                       <= RX_Strm_Mask;
        oc_dack_no                   <= '0';
        strm_mask_store              <= '1';
        if (bcount = 8) then
          bcount_clr                 <= '1';
          case oc_decoded is
            when B_CONF_WR => nstate <= BCW_DataMask;
            when B_COMMAND => nstate <= BCMD_Data;
            when REQ_STAT  => nstate <= GS_Send_Req_Stat;
            when others    => null;     -- should NEVER get here.
          end case;
        end if;


        --== Get Stats ======================================================

      when GS_Send_Req_Stat =>
        send_req_stat <= '1';
        nstate        <= WaitEOF;


        --== Broadcast Config Write  ========================================

      when BCW_DataMask =>
        oc_dack_no <= '0';
        mask_store <= '1';
        bcount_clr <= '1';
        nstate     <= BCW_Data;


      when BCW_Data =>
        nstate     <= BCW_Data;
        breg_store <= strm_mask_all(bcount);
        if (bcount = (NSTREAMS-1)) then
          nstate   <= WaitEOF;
        end if;


        --== Broadcast Send Command  ========================================


      when BCMD_Data =>
        nstate      <= BCMD_Data;
        bcmd_strobe <= strm_mask_all(bcount);
        if (bcount = (NSTREAMS-1)) then
          nstate    <= WaitEOF;
        end if;


        --===================================================================

      when WaitEOF =>
        nstate     <= WaitEOF;
        oc_dack_no <= '0';
        if (oc_valid_i = '0') then
          oc_dack_no <= '1';  -- wait til after ack
          nstate   <= SendAck;
        end if;


      when SendAck =>
        oc_dack_no <= '1';
        ack_send   <= '1';
        nstate     <= WaitAckBusy;


      when WaitAckBusy =>
        oc_dack_no <= '1';
        nstate     <= WaitAckBusy;
        if (ack_busy = '0') then        -- wait for Ack to be done
          nstate   <= OCDone;
        end if;


        
      --=========================================================================
      when OCDone =>
        oc_dack_no   <= '0'; -- final oc_dack to release ocbus
        nstate <= Idle;




    end case;
  end process;


--------------------------------------------------------------------

  prc_byte_counter : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') or (bcount_clr = '1') then
        bcount <= 0;

      else
        if (bcount /= BCOUNT_MAX) then
          bcount <= bcount + 1;
        end if;
      end if;
    end if;
  end process;

--------------------------------------------------------------------

  prc_gen_stores : process (clk)
  begin
    if rising_edge(clk) then
      if (stream_store = '1') then
        stream <= oc_data_i(7 downto 0);
      end if;

      if (oc_decoded_store = '1') then
        rx_port    <= oc_get_port(oc_data_i);
        oc_decoded <= oc_decoded_d;
      end if;

      if (ocseq_store = '1') then
        rx_ocseq <= oc_data_i;
      end if;

      if (ocsize_store = '1') then
        rx_ocsize <= oc_data_i;
      end if;


    end if;
  end process;

  stream_int    <= conv_integer(stream);
  rx_ocsize_int <= conv_integer(rx_ocsize);



--------------------------------------------------------------------
  prc_reg_stores : process (clk)
  begin
    if rising_edge(clk) then

      if (rst = '1') then
        --reg_mask <= x"0000";
        reg_data  <= (others => x"0000");  -- *** default set to enabled,
                                           -- capture for testing
        strm_mask <= (others => x"0000");
        --cmd_data <= (others => x"0000")

      else

        -- Mask                         ----------------------
        if (mask_store = '1') then
          reg_mask <= oc_data_i;
        end if;

        -- Register                     ----------------------
        if (reg_store = '1') then
          reg_data(stream_int) <= (reg_data(stream_int) and not(reg_mask)) or (oc_data_i and reg_mask);
        elsif (breg_store = '1') then
          reg_data(bcount)     <= (reg_data(bcount) and not(reg_mask)) or (oc_data_i and reg_mask);
        end if;


        -- Command                      ----------------------
        -- default
        strm_cmd_o               <= (others => x"0000");
        if (cmd_strobe = '1') then
          strm_cmd_o(stream_int) <= oc_data_i;
        elsif (bcmd_strobe = '1') then
          strm_cmd_o(bcount)     <= oc_data_i;
        end if;


        -- Stream Mask (multi use)      ----------------------
        if (strm_mask_store = '1') then
          strm_mask(bcount) <= oc_data_i;
        end if;

      end if;
    end if;
  end process;


  strm_mask_all <= strm_mask(8) &
                   strm_mask(7) &
                   strm_mask(6) &
                   strm_mask(5) &
                   strm_mask(4) &
                   strm_mask(3) &
                   strm_mask(2) &
                   strm_mask(1) &
                   strm_mask(0);


  strm_reg_o(NSTREAMS-1 downto 0) <= reg_data;
  strm_req_stat_o                 <= (others => '0') when (send_req_stat = '0') else
                                     strm_mask_all;


--------------------------------------------------------------------
-- Ack Interface

  ack_opcode0 <= OC_STRM_CONF_WR  when (oc_decoded = CONF_WR)   else
                 OC_BSTRM_CONF_WR when (oc_decoded = B_CONF_WR) else
                 OC_STRM_COMMAND  when (oc_decoded = COMMAND)   else
                 OC_BSTRM_COMMAND when (oc_decoded = B_COMMAND) else
                 OC_STRM_REQ_STAT;

  ack_opcode <= oc_insert_port(ack_opcode0, rx_port);

  ack_size    <= x"0002";
  ack_payload <= x"ACAC";


  ocbstrcw_ack : ll_ack_gen
    port map (
      opcode_i  => ack_opcode,
      ocseq_i   => rx_ocseq,
      ocsize_i  => ack_size,
      payload_i => ack_payload,
      send_i    => ack_send,
      busy_o    => ack_busy,
      lls_o     => lls_o,
      lld_i     => lld_i,
      clk       => clk,
      rst       => rst
      );



end architecture;


