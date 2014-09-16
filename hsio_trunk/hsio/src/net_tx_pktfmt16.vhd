--
-- Network Packet Formatter
--
-- adds headers and sorts out data width problems
-- to get data into locallink fifo
--
-- Mods
-- 2011-06-30 Added defaults data_o=0x2468 - this should become the CRC for now


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library utils;
use utils.pkg_types.all;

library hsio;
use hsio.pkg_core_globals.all;

entity net_tx_pktfmt16 is
   port( 
      --alt_dest_type_en_i : in std_logic;
      --***    alt_dest_mac_en_i : in std_logic;
      --***    mac_alt_dest_i   : in  std_logic_vector (47 downto 0);
      
      -- input interface
      data_i       : in     std_logic_vector (15 downto 0);
      sof_i        : in     std_logic;
      eof_i        : in     std_logic;
      dst_rdy_o    : out    std_logic;
      src_rdy_i    : in     std_logic;
      --data_length_i : in  std_logic_vector (15 downto 0);  -- HSIO length field
      mac_dest_i   : in     std_logic_vector (47 downto 0);
      mac_source_i : in     std_logic_vector (47 downto 0);
      -- net client side (output) interface
      ll_data_o    : out    std_logic_vector (15 downto 0);  --(7 downto 0);  -- Erdem
      ll_sof_o     : out    std_logic;
      ll_eof_o     : out    std_logic;
      ll_dst_rdy_i : in     std_logic;
      ll_src_rdy_o : out    std_logic;
      clk          : in     std_logic;
      rst          : in     std_logic
   );

-- Declarations

end net_tx_pktfmt16 ;


architecture rtl of net_tx_pktfmt16 is

  signal pkt_header : slv16_array(9 downto 0);  -- should be 19, but sim eeerg.

  signal bcount     : integer range 0 to 31;  -- 63  -- Erdem 
  signal bcount_en  : std_logic;
  signal bcount_clr : std_logic;
  signal bcount_inc : std_logic;

  signal data_len : std_logic_vector(15 downto 0);


  type states is (HeaderSOF, HeaderOC, Header2,
                  OCData0, OCData1, OCData2,
                  Payload, AddCRC, PadEnd,
                  Idle
                  );

  signal state, nstate : states;

  signal ll_src_rdy : std_logic;
  signal ll_sof     : std_logic;
  signal ll_eof     : std_logic;
  signal ll_data    : slv16;

  signal net_seq_id       : slv16;
  signal dbg_state_change : std_logic;

  signal oc_store        : slv16_array(3 downto 0);  -- should be 2, but sim eeerg.
  signal oc_store_offs10 : slv16_array(13 downto 10);
  signal oc_store_en     : std_logic;
  signal opcodepl        : slv16;

  
  signal net_seq_id_inc : std_logic;

  signal crc : slv16;

  --*** signal ad_mac_en : std_logic; 
  --signal ad_type_en : std_logic; 
  --signal ad_opcode_valid : std_logic;
  signal rx_oc_port : slv4;


  -- polynomial: (0 5 12 16)
  -- data width: 16

  function CRC16_D16
    (Data : std_logic_vector(15 downto 0);
     CRC  : std_logic_vector(15 downto 0))
    return std_logic_vector is

    variable D      : std_logic_vector(15 downto 0);
    variable C      : std_logic_vector(15 downto 0);
    variable NewCRC : std_logic_vector(15 downto 0);


  begin

    D := Data;
    C := CRC;

    NewCRC(0)  := D(12) xor D(11) xor D(8) xor D(4) xor D(0) xor C(0) xor
                 C(4) xor C(8) xor C(11) xor C(12);
    NewCRC(1)  := D(13) xor D(12) xor D(9) xor D(5) xor D(1) xor C(1) xor
                 C(5) xor C(9) xor C(12) xor C(13);
    NewCRC(2)  := D(14) xor D(13) xor D(10) xor D(6) xor D(2) xor C(2) xor
                 C(6) xor C(10) xor C(13) xor C(14);
    NewCRC(3)  := D(15) xor D(14) xor D(11) xor D(7) xor D(3) xor C(3) xor
                 C(7) xor C(11) xor C(14) xor C(15);
    NewCRC(4)  := D(15) xor D(12) xor D(8) xor D(4) xor C(4) xor C(8) xor
                 C(12) xor C(15);
    NewCRC(5)  := D(13) xor D(12) xor D(11) xor D(9) xor D(8) xor D(5) xor
                 D(4) xor D(0) xor C(0) xor C(4) xor C(5) xor C(8) xor
                 C(9) xor C(11) xor C(12) xor C(13);
    NewCRC(6)  := D(14) xor D(13) xor D(12) xor D(10) xor D(9) xor D(6) xor
                 D(5) xor D(1) xor C(1) xor C(5) xor C(6) xor C(9) xor
                 C(10) xor C(12) xor C(13) xor C(14);
    NewCRC(7)  := D(15) xor D(14) xor D(13) xor D(11) xor D(10) xor D(7) xor
                 D(6) xor D(2) xor C(2) xor C(6) xor C(7) xor C(10) xor
                 C(11) xor C(13) xor C(14) xor C(15);
    NewCRC(8)  := D(15) xor D(14) xor D(12) xor D(11) xor D(8) xor D(7) xor
                 D(3) xor C(3) xor C(7) xor C(8) xor C(11) xor C(12) xor
                 C(14) xor C(15);
    NewCRC(9)  := D(15) xor D(13) xor D(12) xor D(9) xor D(8) xor D(4) xor
                 C(4) xor C(8) xor C(9) xor C(12) xor C(13) xor C(15);
    NewCRC(10) := D(14) xor D(13) xor D(10) xor D(9) xor D(5) xor C(5) xor
                  C(9) xor C(10) xor C(13) xor C(14);
    NewCRC(11) := D(15) xor D(14) xor D(11) xor D(10) xor D(6) xor C(6) xor
                  C(10) xor C(11) xor C(14) xor C(15);
    NewCRC(12) := D(15) xor D(8) xor D(7) xor D(4) xor D(0) xor C(0) xor
                  C(4) xor C(7) xor C(8) xor C(15);
    NewCRC(13) := D(9) xor D(8) xor D(5) xor D(1) xor C(1) xor C(5) xor
                  C(8) xor C(9);
    NewCRC(14) := D(10) xor D(9) xor D(6) xor D(2) xor C(2) xor C(6) xor
                  C(9) xor C(10);
    NewCRC(15) := D(11) xor D(10) xor D(7) xor D(3) xor C(3) xor C(7) xor
                  C(10) xor C(11);

    return NewCRC;

  end CRC16_D16;


begin

  prc_clk_ll_out : process (clk)
  begin
    if rising_edge(clk) then
      if (ll_dst_rdy_i = '1') then
        ll_src_rdy_o <= ll_src_rdy;
        ll_sof_o     <= ll_sof;
        ll_eof_o     <= ll_eof;
        ll_data_o    <= ll_data; -- ll_data(7 downto 0) & ll_data (15 downto 8);  -- Erdem  --Byte swap
      end if;
    end if;
  end process;


-- dst_rdy_o <= dst_rdy_out;

  -- Destination MAC
  pkt_header(0) <= mac_dest_i(3*16-1 downto 2*16);
  pkt_header(1) <= mac_dest_i(2*16-1 downto 1*16);
  pkt_header(2) <= mac_dest_i(1*16-1 downto 0*16);

  --***pkt_header(0) <= mac_dest_i(3*16-1 downto 2*16) when (ad_mac_en = '0') else mac_alt_dest_i(3*16-1 downto 2*16);
  --***pkt_header(1) <= mac_dest_i(2*16-1 downto 1*16) when (ad_mac_en = '0') else mac_alt_dest_i(2*16-1 downto 1*16);
  --***pkt_header(2) <= mac_dest_i(1*16-1 downto 0*16) when (ad_mac_en = '0') else mac_alt_dest_i(1*16-1 downto 0*16);

  -- Source MAC
  pkt_header(3) <= mac_source_i(3*16-1 downto 2*16);
  pkt_header(4) <= mac_source_i(2*16-1 downto 1*16);
  pkt_header(5) <= mac_source_i(1*16-1 downto 0*16);

  -- Type (hijacked by HSIO Magic Number) 0x8765)
  --pkt_header(6) <= x"8765";           -- Erdem
  --pkt_header(6) <= x"8765" when (ad_type_en = '0') else x"8766";
  
  -- routing only works if using type lsn >7
  pkt_header(6) <= x"8765" when (rx_oc_port = x"0") else (x"876" & '1' & rx_oc_port(2 downto 0));

  -- HSIO sequence num
  pkt_header(7) <= net_seq_id(15 downto 0);  --data_seqnum_i(15 downto 8);

  -- HSIO length field
  data_len      <= (oc_store(2) + 16);
  pkt_header(8) <= data_len(15 downto 0);

  -- HSIO opcode count field            -- always 1 for readout
  pkt_header(9) <= x"0001";


  -- Alternative destination for packets stuff
  -------------------------------------------------
  -- When enabled packets from the I2C opcode will be sent to a different MAC and/or Type

  --ad_type_en <= alt_dest_type_en_i and ad_opcode_valid;
  --***ad_mac_en <= alt_dest_mac_en_i and alt_dest_opcode;

  --ad_opcode_valid  <= '1' when (oc_store(0)(15 downto 4) = x"008") else '0';

  --==--==--==--==--==--==--==--==--==--==--==--==--==--==--==  --==
  -- SM Clocked
  --==--==--==--==--==--==--==--==--==--==--==--==--==--==--==  --==

  prc_sm_clocked : process(clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        state <= Idle;
      else
        state <= nstate;
      end if;
    end if;
  end process;


  -- SM Async
  -------------------------------------------------------
  prc_sm_async : process (state, src_rdy_i, sof_i, eof_i, ll_dst_rdy_i, bcount, pkt_header, data_i,
                          crc,
                          oc_store)
  begin

    --defaults
    nstate           <= Idle;
    ll_sof           <= '0';
    ll_eof           <= '0';
    ll_src_rdy       <= '1';
    dst_rdy_o        <= '0';            -- ll_dst_rdy_i;
    bcount_clr       <= '0';
    bcount_en        <= '1';
    ll_data          <= x"0000";
    dbg_state_change <= '0';
    oc_store_en      <= '0';
    net_seq_id_inc   <= '0';
    bcount_inc       <= '0';


    case state is

      when Idle =>
        nstate      <= Idle;
        dst_rdy_o   <= '1';
        bcount_clr  <= '1';
        ll_src_rdy  <= '0';
        if (sof_i = '1') then
          --ll_src_rdy <= '1';          -- xil ll ignores sof, srcrdy must be THE START
          dst_rdy_o <= '0';
          nstate    <= HeaderSOF;
        end if;


        -- Send Header and store incoming opcode header
        ---------------------------------------------------------------
      when HeaderSOF =>
        nstate       <= HeaderSOF;
        ll_sof       <= '1';
        ll_data      <= pkt_header(bcount);
        oc_store_en  <= '1';
        if (ll_dst_rdy_i = '1') then
          dst_rdy_o  <= '1';
          bcount_inc <= '1';
          nstate     <= HeaderOC;
        end if;


      when HeaderOC =>                       -- preload opcode, seq, size
        nstate       <= HeaderOC;
        ll_data      <= pkt_header(bcount);  -- Erdem
        oc_store_en  <= '1';
        if (ll_dst_rdy_i = '1') then
          dst_rdy_o  <= '1';
          bcount_inc <= '1';
          if (bcount = 2) then               -- Erdem 
            --if (bcount = 1) then
            nstate   <= Header2;
          end if;
        end if;


      when Header2 =>
        nstate  <= Header2;
        ll_data <= pkt_header(bcount);

        if (ll_dst_rdy_i = '1') then
          bcount_inc         <= '1';
          --if (bcount = 19) then       -- Erdem 
          if (bcount = 9) then
            dbg_state_change <= '1';
            nstate           <= OCData0;
          end if;
        end if;


        --Send Stored Opcode Header
        ------------------------------------------------------------

      when OCData0 =>
        nstate <= OCData0;

        ll_data      <= oc_store(0);
        if (ll_dst_rdy_i = '1') then
          bcount_inc <= '1';

          nstate <= OCData1;
        end if;


      when OCData1 =>
        nstate <= OCData1;

        ll_data      <= oc_store(1);
        if (ll_dst_rdy_i = '1') then
          bcount_inc <= '1';

          nstate <= OCData2;
        end if;



      when OCData2 =>
        nstate <= OCData2;

        ll_data      <= oc_store(2);
        if (ll_dst_rdy_i = '1') then
          bcount_inc <= '1';

          nstate <= Payload;
        end if;




        --Forward data
        -----------------------------------------------

      when Payload =>
        nstate       <= Payload;
        ll_data      <= data_i;
        if (ll_dst_rdy_i = '1') then
          dst_rdy_o  <= '1';            -- Erdem 
          bcount_inc <= '1';

          if (eof_i = '1') then         -- Erdem 
            nstate <= AddCRC;
          end if;
        end if;


      when AddCRC =>
        nstate             <= AddCRC;
        ll_data            <= crc;
        if (ll_dst_rdy_i = '1') then
          bcount_inc       <= '1';
          if (bcount > 30) then
            net_seq_id_inc <= '1';
            nstate         <= Idle;
            ll_eof         <= '1';
          else
            nstate         <= PadEnd;
          end if;
        end if;


      when PadEnd =>
        nstate             <= PadEnd;
        if (ll_dst_rdy_i = '1') then
          bcount_inc       <= '1';
          if (bcount > 30) then         -- min-packet size is 60
            net_seq_id_inc <= '1';
            nstate         <= Idle;
            ll_eof         <= '1';
          end if;
        end if;

    end case;
  end process;

  crc_gen : process (clk)
  begin
    if rising_edge(clk) then
      if state = IDLE then
        crc <= (others => '0');

      else
        if (ll_dst_rdy_i = '1') then
          if bcount > 5 and bcount    <= 9 then
            crc                       <= CRC16_D16 (pkt_header (bcount), crc);
          elsif bcount > 9 and bcount <= 12 then
            --crc <= CRC16_D16 (oc_store(bcount - 10), crc);  -- matt don't like
            crc                       <= CRC16_D16 (oc_store_offs10(bcount), crc);  -- inline maths ...
          elsif bcount > 12 then
            crc                       <= CRC16_D16 (data_i, crc);
          else
            crc                       <= crc;
          end if;

        end if;
      end if;
    end if;
  end process;


  prc_byte_counter : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') or (bcount_clr = '1') then
        bcount   <= 0;
      else
        if (bcount_en = '1') and (bcount < 31) and (bcount_inc = '1') then
          bcount <= bcount + 1;
        end if;
      end if;
    end if;

  end process;


  prc_net_seq_id_counter : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        net_seq_id   <= X"0000";
      else
        if (net_seq_id_inc = '1') then
          net_seq_id <= net_seq_id + '1';
        end if;
      end if;
    end if;

  end process;



  -- *** kludged to re-insert missing part of the opcode stolen by matt for the
  -- port stuff
  
  opcodepl <= oc_get_opcodepl(data_i);

  prc_incoming_oc_store : process (clk)
  begin
    if rising_edge(clk) then
      if (oc_store_en = '1') then
        if (bcount = 0) then
          if (opcodepl(15 downto 12) = x"A") then
             oc_store(0)      <= x"AA" & opcodepl(7 downto 0);
          else
             oc_store(0)      <= opcodepl;
          end if;
          rx_oc_port       <= oc_get_port(data_i);
        else
          oc_store(bcount) <= data_i;
        end if;
      end if;
    end if;
  end process;

  oc_store_offs10 <= oc_store;



end architecture;


