--
-- Quick and Dirty packet decoder
-- (actually a lot less dirty than it used to be, nor quick)
--
-- Very simple packet parsing and serialising for generating ABC COM streams
-- etc.
--


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use hsio.pkg_hsio_globals.all;

entity hsio_packet_decoder is
  generic(
    NO_DECODE : std_logic := '0'
    );
  port(
    dbg_state_o            : out slv4;
    ocrawcom_start_o       : out std_logic;
    delta_eof63_i          : in  slv8;
    -- net ll fifo interface
    src_rdy_i              : in  std_logic;
    data_i                 : in  slv16;
    sof_i                  : in  std_logic;
    eof_i                  : in  std_logic;
    dst_rdy_o              : out std_logic;
    -- decoded out
    rx_magicn_o            : out slv16;
    rx_seq_o               : out slv16;
    rx_len_o               : out slv16;
    rx_cbcnt_o             : out slv16;
    rx_opcode_o            : out slv16;
    rx_cbseq_o             : out slv16;
    rx_size_o              : out slv16;
    rx_word0_o             : out slv16;
    abc_com_o              : out std_logic;
    reg_ds_enable_o        : out slv16;  --slv48;
    reg_ds_mode_o          : out slv16;  --slv48;
    reg_ds_gendata_en_o    : out slv16;  --slv48;
    reg_ds_gendata_src_o   : out slv16;  --slv48;
    reg_len0_o             : out slv16;
    reg_len1_o             : out slv16;
    --reg_idelay_o           : out slv16;
    reg_trig_burst_rate_o  : out slv16;
    reg_trig_burst_count_o : out slv16;
    reg_com_enable_o       : out slv16;
    reg_cs_reset_o         : out slv16;  --slv48;
    reg_cs_capt_mode_en_o  : out slv16;  --slv48;
    reg_disp_reg_o         : out slv16;
    reg_control_o          : out slv16;
    reg_histo_reset_o      : out slv16;  --slv48;
    reg_histo_ro_o         : out slv16;  --slv48;
    commands_o             : out slv16;
    regwe_o                : out std_logic_vector (31 downto 0);
    regdata_o              : out std_logic_vector (15 downto 0);
    regstrobe_o            : out std_logic;
    l1id_i                 : in  slv16;
    bcid_l1a_i             : in  slv16;
    build_timestamp_i      : in  slv16;
    build_no_i             : in  slv16;
    build_info_i           : in  slv16;
    s_dropped_pkts_i       : in  slv8_array (47 downto 0);
    s_fifo_depth_i         : in  slv4_array (47 downto 0);
    -- tx fifo interface
    tx_wren_o              : out std_logic := '0';
    tx_sof_o               : out std_logic := '0';
    tx_eof_o               : out std_logic := '0';
    tx_data_o              : out slv16     := x"0000";
    tx_len_o               : out slv11     := "00000000000";
    ti2c_req_o             : out std_logic := '0';
    --ti2c_dbg_req_o : out std_logic := '0';
    dst_rdy_i              : in  std_logic;
    --rst_ro_local_o         : OUT    std_logic  := '0';
    --rst_netrof_local_o     : OUT    std_logic  := '0';
    --rst_hsio_o             : OUT    std_logic  := '0';
    --count_por_sw_i         : IN     slv4;
    --count_rst_hsio_i       : IN     slv4;
    --count_rst_netrof_i     : IN     slv4;
    --count_rst_ro_i         : IN     slv4;
    --rst_ro_i               : IN     std_logic;  -- monitor this before starting ...
    --rst_netrof_i           : IN     std_logic;  -- monitor this before starting ...
    --rst_co_i               : IN     std_logic;  -- monitor this before starting ...
    --resets_all_i           : IN     std_logic;  -- monitor this before starting ...
    strobe40_i             : in  std_logic;
    clk                    : in  std_logic;
    rst                    : in  std_logic
    );

-- Declarations

end hsio_packet_decoder;


architecture rtl of hsio_packet_decoder is

  type states is (ComblockHeader,
                  OCRawCom, OCRawComSync,
                  DataSerialise, DataSerialLoad,
                  OCWPAddr, OCWPData, OCTI2C,
                  WaitEOF,
                  TX_Start, TX_CBSeq,
                  TXAck_Size, TXAck_EOF,
                  TXAckError_Size, TXAckError_EOF,
                  TXRegBlock_Size, TXRegBlock_Data,
                  TXStatBlock_Size, TXStatBlock_Data,
                  --OCHSIOReset, OCNetFIFOReset, OCReadoutReset,
                  Idle, Reset
                  );

  signal state, nstate : states;

  signal rx_magicn : slv16;
  signal rx_seq    : slv16;
  signal rx_len    : slv16;
  signal rx_cbcnt  : slv16;

  signal rx_opcode : slv16;
  signal rx_cbseq  : slv16;
  signal rx_size   : slv16;
  signal rx_word0  : slv16;

  signal rx_hdr : slv16_array (0 to 8) := (others => x"0000");

  signal wcount     : integer range 0 to 8;
  signal wcount_en  : std_logic;
  signal wcount_clr : std_logic;

  signal bitcount40     : integer range 0 to 15;
  signal bitcount40_set : std_logic;

  signal data_store    : slv16 := x"0000";
  signal data_store_en : std_logic;

  signal reg_addr_str : std_logic;
  signal reg_addr     : slv16;
  signal reg_addr_int : integer range 0 to 31;
  signal reg_data_str : std_logic;
  signal reg_data     : slv16_array (0 to 31) := (others => x"0000");
  signal status_data  : slv16_array (0 to 31) := (others => x"0000");
  signal acount       : integer range 0 to 31;
  signal acount_clr   : std_logic;

  signal tx_wren : std_logic;
  signal tx_sof  : std_logic;
  signal tx_eof  : std_logic;
  signal tx_data : slv16;
  signal tx_len  : slv12;

  signal ti2c_req     : std_logic;
  signal ti2c_dbg_req : std_logic;

  signal src_dst_rdy : std_logic;
  signal resets      : std_logic := '0';

begin

  src_dst_rdy <= src_rdy_i and dst_rdy_i;

  rx_magicn <= rx_hdr(0);
  rx_seq    <= rx_hdr(1);
  rx_len    <= rx_hdr(2);
  rx_cbcnt  <= rx_hdr(3);

  rx_magicn_o <= rx_magicn;
  rx_seq_o    <= rx_seq;
  rx_len_o    <= rx_len;
  rx_cbcnt_o  <= rx_cbcnt;

  rx_opcode <= rx_hdr(4);
  rx_cbseq  <= rx_hdr(5);
  rx_size   <= rx_hdr(6);
  rx_word0  <= rx_hdr(7);

  rx_opcode_o <= rx_opcode;
  rx_cbseq_o  <= rx_cbseq;
  rx_size_o   <= rx_size;
  rx_word0_o  <= rx_word0;


  --resets <= (rst_ro_i or rst_co_i or rst_netrof_i);


  -- State Machine
  --------------------------------------------------------
  prc_sync_part : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        state <= Reset;
      else
        state <= nstate;                -- after 50 ps;

      end if;
    end if;
  end process;




  prc_async_machine : process (state,
                               --resets_all_i,
                               src_dst_rdy, dst_rdy_i, sof_i, eof_i,
                               wcount, bitcount40, strobe40_i,
                               rx_opcode, rx_cbseq, reg_data, status_data,
                               data_store, data_i,
                               acount
                               )
  begin
    -- defaults
    dbg_state_o    <= x"f";
    dst_rdy_o      <= dst_rdy_i;
    bitcount40_set <= '0';
    abc_com_o      <= '0';
    wcount_clr     <= '0';
    data_store_en  <= '0';
    reg_addr_str   <= '0';
    reg_data_str   <= '0';
    acount_clr     <= '0';

    -- tx fifo interface
    tx_wren <= '0';
    tx_sof  <= '0';
    tx_eof  <= '0';
    tx_data <= x"0000";
    tx_len  <= x"000";

    ti2c_req         <= '0';
    ti2c_dbg_req     <= '0';
    ocrawcom_start_o <= '0';
    --rst_hsio_o         <= '0';
    --rst_netrof_local_o <= '0';
    --rst_ro_local_o     <= '0';


    case state is

      -------------------------------------------------------------------
      when Reset =>
        dst_rdy_o <= '0';
        --if (resets_all_i = '1') then  -- wait for all parts to come out of reset
        --  nstate <= Reset;
        --else
        nstate    <= TX_Start;          -- send ack at reset
        --end if;


        -------------------------------------------------------------
      when Idle =>
        dst_rdy_o  <= '0';
        wcount_clr <= '1';
        if (src_dst_rdy = '1') and (sof_i = '1') then
          nstate <= ComblockHeader;
        else
          nstate <= Idle;
        end if;


      when ComblockHeader =>            -- opcode, ocseq, size
        if (src_dst_rdy = '1') and (wcount = 6) then
          case rx_opcode is  -- process only "write" opcodes needing packet contents
            when x"0010" => nstate <= OCWPAddr;
            when x"0041" => nstate <= OCTI2C;
            when x"0101" => nstate <= OCRawCom; ocrawcom_start_o <= '1';
            when others  => nstate <= WaitEOF;
          end case;
        else
          nstate <= ComblockHeader;
        end if;


        ---------------------------------------------------------------
      when OCTI2C =>
        ti2c_req <= '1';
        nstate   <= WaitEOF;


        -------------------------------------------------------------------
      when OCRawCom =>
        --
        data_store_en  <= '1';
        bitcount40_set <= '1';
        if (src_dst_rdy = '1') then
          if (strobe40_i = '0') then
            nstate <= DataSerialise;
          else
            nstate <= OCRawComSync;
          end if;
        else
          nstate <= OCRawCom;
        end if;

        when OCRawComSync =>
              dst_rdy_o <= '0';
              bitcount40_set <= '1';
               nstate <= DataSerialise;
 

      when DataSerialise =>
        dst_rdy_o <= '0';
        abc_com_o <= data_store(bitcount40);
        if (bitcount40 = 1) then
          nstate <= DataSerialLoad;
        else
          nstate <= DataSerialise;
        end if;


      when DataSerialLoad =>
        dst_rdy_o     <= '1';
        data_store_en <= '1';
        abc_com_o     <= data_store(bitcount40);
        if (eof_i = '1') then           -- bitcount40 will = zero
          nstate <= TX_Start;
        else
          nstate <= DataSerialise;      -- this is a one clock state
        end if;


        -------------------------------------------------------------

      when OCWPAddr =>
        reg_addr_str <= '1';

        if (src_dst_rdy = '1') then
          nstate <= OCWPData;
        else
          nstate <= OCWPAddr;
        end if;


      when OCWPData =>
        --reg_data_str <= '1';

        if (src_dst_rdy = '1') then
          reg_data_str <= '1';
          nstate       <= WaitEOF;
        else
          nstate <= OCWPData;
        end if;



        --------------------------------------------------------------

      when WaitEOF =>
        if (eof_i = '1') then
          -- Special Case opcodes
          --case rx_opcode is
          --  when x"0F10" => nstate <= OCReadoutReset;
          --  when x"0F20" => nstate <= OCNetFIFOReset;
          --  when x"0FEC" => nstate <= OCHSIOReset;
          --  when others  => nstate <= TX_Start;
          --end case;
          nstate <= TX_Start;
        else
          nstate <= WaitEOF;
        end if;


        -----------------------------------------------------------------

      when TX_Start =>                  -- opcode
        dst_rdy_o <= '0';
        tx_data   <= rx_opcode;
        tx_wren   <= '1';
        tx_sof    <= '1';
        nstate    <= TX_CBSeq;


      when TX_CBSeq =>                  -- process TX opcodes here
        dst_rdy_o <= '0';
        tx_data   <= rx_cbseq;
        tx_wren   <= '1';
        case rx_opcode is
          when x"0010" => nstate <= TXAck_Size;
          when x"0015" => nstate <= TXRegBlock_Size;
          when x"0019" => nstate <= TXStatBlock_Size;
          when x"0041" => nstate <= TXAck_Size;
          when x"0101" => nstate <= TXAck_Size;
                          --when x"0f10" => nstate <= TXAck_Size;
                          --when x"0f20" => nstate <= TXAck_Size;
                          --when x"0fec" => nstate <= TXAck_Size;
          when others  => nstate <= TXAckError_Size;
        end case;


        ---------------------------------------------------------------------------
      when TXAck_Size =>
        dst_rdy_o <= '0';
        tx_data   <= x"0000";           -- place holder for len
        tx_wren   <= '1';
        nstate    <= TXAck_EOF;


      when TXAck_EOF =>                 --  adding payload is helpful for the
        -- FIFO control machine (no special circumstances for
        -- early EOF)
        dst_rdy_o <= '0';
        tx_data   <= x"aacc";           -- make this an obvious ack packet
        tx_wren   <= '1';
        tx_len    <= x"002";   -- EOF is used to strobe in the len downstream.
        tx_eof    <= '1';
        nstate    <= Idle;

        ---------------------------------------------------------------------------
      when TXAckError_Size =>
        dst_rdy_o <= '0';
        tx_data   <= x"0000";           -- place holder for len
        tx_wren   <= '1';
        nstate    <= TXAckError_EOF;


      when TXAckError_EOF =>
        dst_rdy_o <= '0';
        tx_data   <= x"e000";           -- error code - e000 = invalid opcode
        tx_wren   <= '1';
        tx_len    <= x"002";   --  EOF is used to strobe in the len downstream.
        tx_eof    <= '1';
        nstate    <= Idle;


        ------------------------------------------------------------------------   
      when TXRegBlock_Size =>
        dst_rdy_o  <= '0';
        tx_data    <= x"0000";          -- place holder
        tx_wren    <= '1';
        acount_clr <= '1';
        nstate     <= TXRegBlock_Data;


      when TXRegBlock_Data =>
        dst_rdy_o <= '0';
        tx_data   <= reg_data(acount);
        tx_len    <= x"040";
        tx_wren   <= '1';
        if (acount = 31) then
          tx_eof <= '1';
          nstate <= Idle;
        else
          nstate <= TXRegBlock_Data;
        end if;

        -----------------------------------------------------------

      when TXStatBlock_Size =>
        dst_rdy_o  <= '0';
        tx_data    <= x"0000";          -- place holder
        tx_wren    <= '1';
        acount_clr <= '1';
        nstate     <= TXStatBlock_Data;


      when TXStatBlock_Data =>
        dst_rdy_o <= '0';
        tx_data   <= status_data(acount);
        tx_len    <= x"040";
        tx_wren   <= '1';
        if (acount = 31) then
          tx_eof <= '1';
          nstate <= Idle;
        else
          nstate <= TXStatBlock_Data;
        end if;


        --------------------------------------------------------------
        --when OCReadoutReset =>
        --  dst_rdy_o  <= '0';
        --  rst_ro_local_o <= '1';
        --  if (resets_all_i = '1') then  -- wait for reset to kick in
        --    nstate <= Reset;           
        --  else
        --    nstate <= OCReadoutReset;
        --  end if;


        --when OCNetFIFOReset =>
        --  dst_rdy_o  <= '0';
        --  rst_netrof_local_o <= '1';
        --  if (resets_all_i = '1') then  -- wait for reset to kick in
        --    nstate <= Reset;           
        --  else
        --    nstate <= OCNetFIFOReset;
        --  end if;


        --when OCHSIOReset =>
        --  dst_rdy_o  <= '0';
        --  rst_hsio_o <= '1';
        --  nstate <= OCHSIOReset;      -- wait for reset to kick in!!!!


    end case;
  end process;

---------------------------------
  prc_clockout_tx_data : process (clk)
  begin
    if rising_edge(clk) then
      tx_data_o  <= tx_data;
      tx_len_o   <= tx_len(10 downto 0);
      tx_wren_o  <= tx_wren;
      tx_sof_o   <= tx_sof;
      tx_eof_o   <= tx_eof;
      ti2c_req_o <= ti2c_req;
      --ti2c_dbg_req_o <= ti2c_dbg_req;
    end if;
  end process;

--------------------------------------------------------------------
  wcount_en <= src_dst_rdy;

  prc_word_counter : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') or (wcount_clr = '1') then
        wcount <= 0;
      else
        if (wcount_en = '1') and (wcount < 8) then
          wcount <= wcount + 1;
        end if;
      end if;
    end if;
  end process;


  prc_bit_counter40 : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') or (bitcount40_set = '1') then
        bitcount40 <= 15;
      else
        if (strobe40_i = '0') then
          if (bitcount40 = 0) then
            bitcount40 <= 15;
          else
            bitcount40 <= bitcount40 - 1;
          end if;
        end if;
      end if;
    end if;
  end process;


  prc_regaddr_counter : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') or (acount_clr = '1') then
        acount <= 0;
      else
        if (acount < 31) then
          acount <= acount + 1;
        end if;
      end if;
    end if;
  end process;


  prc_src_mac_store : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        rx_hdr(4) <= x"0fec";           -- preset opcode
      else
        rx_hdr(wcount) <= data_i;
      end if;
    end if;
  end process;


  prc_data_store : process (clk)
  begin
    if rising_edge(clk) then
      if (data_store_en = '1') then
        data_store <= data_i;
      end if;
    end if;
  end process;



-----------------------------------------------
-- Register Block
-----------------------------------------------

--[16] com enable bits
-- 15 - com shift 180
-- 14 - com shift 90
-- 13 - dclk enable
-- 12 - bco enable
-- 11 - invert reset
-- 10 - swap bco and dclk outputs
-- 9 - com into pp1 reset en
-- 8 - com into pp0 reset en
-- 7 - dclk invert
-- 6 - bco invert
-- 5 - com into pp1 l1 enable
-- 4 - com into pp0 l1 enable
-- 3 - com into st l1r enable
-- 2 - st com enable
-- 1 - pp1 com enable
-- 0 - pp0 com enable

--[23] control bits
-- 15 - 
-- 14 - 
-- 13
-- 12 - 
-- 9 - map st outs for EOS porch
-- 8 - 1 Hz osc enable
-- 7 - debug outputs enable
-- 6 - com into noise enable
-- 5 - pp_inputs_instead
-- 4 - histo test data en (data=addr)
-- 1 - BCID counting enable
-- 0 - L1ID counting enable

  reg_addr_int <= conv_integer(reg_addr(4 downto 0));


-- ***need to get ro registers working!
--reg_data(21) <= l1id_i;
--reg_data(21) <= bcid_i;
--reg_data(13) <= ver_timestamp_i;
--reg_data(14) <= ver_build_i;




  prc_reg_block : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        reg_addr <= (others => '0');

        reg_data(0)  <= x"0000";        -- DSenable0
        --reg_data(1)  <= x"0000";
        --reg_data(2)  <= x"0000";
        --reg_data(3)  <= x"0000";
        reg_data(4)  <= x"0000";        -- DSHistoEn
        reg_data(5)  <= x"0000";        -- DSGendataEn
        reg_data(6)  <= x"0000";        -- DSGendataSrc
        reg_data(7)  <= x"007F";        -- DSLen0
        reg_data(8)  <= x"008F";        -- DSLen1
        --reg_data(9)  <= x"0000";      -- IDelay
        reg_data(10) <= x"0000";        -- TrigBurstRate
        reg_data(11) <= x"0000";        -- TrigBurstCount
        reg_data(12) <= x"0000";        -- COMMAND
        --reg_data(13) <= x"0000";      -- version timestamp (ro)
        --reg_data(14) <= x"0000";      -- version build (ro)
        --reg_data(15) <= x"0000";
        reg_data(16) <= x"9B01";  -- COMenable: see above "1001110000000001"
        reg_data(17) <= x"0000";        -- DSReset
        reg_data(18) <= x"0000";        -- DSCaptModeEn
        --reg_data(19) <= x"0000";
        reg_data(20) <= x"0099";        -- DispReg
        --reg_data(21) <= x"0000";      -- 21 is for L1ID readback on disp (ro)
        --reg_data(22) <= x"0000";      -- 22 is for BCID readback on disp (ro)
        reg_data(23) <= x"00a3";        -- TrigControl (w/ debug o/p enabled) 
        reg_data(24) <= x"ffff";        -- CSHistoReset0
        --reg_data(25) <= x"0000";
        --reg_data(26) <= x"0000";
        --reg_data(27) <= x"0000";
        reg_data(28) <= x"0000";        -- CSHistoRO0
        --reg_data(29) <= x"0000";
        --reg_data(30) <= x"0000";      -- clk bco duty cycle
        --reg_data(31) <= x"0000";  -- reg_data(31) <= x"0000";  -- ClkRoPhase

        regdata_o   <= (others => '0');
        regwe_o     <= (others => '0');
        regstrobe_o <= '0';

      else

        regstrobe_o <= reg_data_str;

        -- store address
        if (reg_addr_str = '1') then
          reg_addr <= data_i;
        end if;

        -- default
        regwe_o <= (others => '0');

        -- store data to register and output
        if (reg_data_str = '1') then
          regdata_o             <= data_i;
          regwe_o(reg_addr_int) <= '1';

          reg_data(reg_addr_int) <= data_i;

        end if;

      end if;
    end if;
  end process;

-- outputs
  reg_ds_enable_o        <= reg_data(0);  --0x00x"11111111" & reg_data(0);  --0x00
-- 0x01
-- 0x02
-- 0x03
  reg_ds_mode_o          <= reg_data(4);  --0x04x"00000000" & reg_data(4);  --0x04
  reg_ds_gendata_en_o    <= reg_data(5);  --0x05x"00000000" & reg_data(5);  --0x05
  reg_ds_gendata_src_o   <= reg_data(6);  --0x06x"00000000" & reg_data(6);  --0x06
  reg_len0_o             <= reg_data(7);   --0x07
  reg_len1_o             <= reg_data(8);   --0x08
--reg_idelay_o           <= reg_data(9);  --0x09
  reg_trig_burst_rate_o  <= reg_data(10);  --0x0a
  reg_trig_burst_count_o <= reg_data(11);  --0x0b
--reg_command           <= reg_data(12);  --0x0c
-- 0x0d
-- 0x0e
-- 0x0f
  reg_com_enable_o       <= reg_data(16);  --0x10
  reg_cs_reset_o         <= reg_data(17);  --0x11x"00000000" & reg_data(17);  --0x11
  reg_cs_capt_mode_en_o  <= reg_data(18);  --0x12x"00000000" & reg_data(18);  --0x12
  reg_disp_reg_o         <= reg_data(20);  --0x14
-- 0x15                                 -- addr used to get L1ID on disp
-- 0x16                                 -- addr used to get BCID on disp
  reg_control_o          <= reg_data(23);  --0x17
  reg_histo_reset_o      <= reg_data(24);  --0x18x"00000000" & reg_data(24);  --0x18
-- 0x19
-- 0x1a
-- 0x1b
  reg_histo_ro_o         <= reg_data(28);  --0x1cx"00000000" & reg_data(28);  --0x1c
--reg_data(29);                         --0x1d
--reg_duty_cycle reg_data(30) <= x"0000";  -- 0x1e  -- BCO duty cycle control
--reg_clkro      reg_data(31) <= x"0000";  -- 0x1f ClkRoPhase

-- below id for Command aka Go signals
  commands_o <= data_i when (reg_addr_int = 12) else (others => '0');



  status_data(0)  <= x"f000";           -- sanity check 
  status_data(1)  <= x"baaa";           --    "
  status_data(2)  <= build_no_i;
  status_data(3)  <= build_info_i;
  status_data(4)  <= x"0000";           -- timestamp lo
  status_data(5)  <= x"0000";           -- timestamp hi
  status_data(6)  <= x"0000";           --
  status_data(7)  <= x"0000";           --
  status_data(8)  <= l1id_i;
  status_data(9)  <= bcid_l1a_i;
  status_data(10) <= x"0000";
  status_data(11) <= x"0000";
  status_data(12) <= x"0000";
  status_data(13) <= x"0000";
  status_data(14) <= x"0000";           -- & delta_eof63_i; 
  status_data(15) <= x"0000";
--count_por_sw_i & count_rst_hsio_i & count_rst_netrof_i & count_rst_ro_i;

--gen_stat : for s in 0 to 15 generate
--  status_data(16+s) <= s_dropped_pkts_i(s) & "0000" & s_fifo_depth_i(s);
--end generate;

end architecture;


