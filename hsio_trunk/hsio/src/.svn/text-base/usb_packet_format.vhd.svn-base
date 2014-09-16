--
-- Network Packet Formatter
--
-- adds headers and sorts out data width problems
-- to get data into locallink fifo
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--library hsio
use hsio.pkg_hsio_globals.all;

ENTITY usb_packet_format IS
   PORT( 
      -- input interface
      data_i        : IN     std_logic_vector (15 DOWNTO 0);
      sof_i         : IN     std_logic;
      eof_i         : IN     std_logic;
      dst_rdy_o     : OUT    std_logic;
      src_rdy_i     : IN     std_logic;
      data_length_i : IN     std_logic_vector (15 DOWNTO 0);  -- HSIO length field
      -- net client side (output) interface
      ll_data_o     : OUT    std_logic_vector (15 DOWNTO 0);
      ll_sof_o      : OUT    std_logic;
      ll_eof_o      : OUT    std_logic;
      ll_dst_rdy_i  : IN     std_logic;
      ll_src_rdy_o  : OUT    std_logic;
      clk           : IN     std_logic;
      rst           : IN     std_logic
   );

-- Declarations

END usb_packet_format ;


architecture rtl of usb_packet_format is

  signal pkt_header : slv16_array(3 downto 0);

  signal bcount     : std_logic_vector(15 downto 0);
  signal bcount_en  : std_logic;
  signal bcount_clr : std_logic;

  signal data_len : std_logic_vector(15 downto 0);


  type states is ( Idle,
                   Header0,
                   Header,
                   DataWord,
-- Pad0Hi,
-- Pad0Lo,
-- Pad1Hi,
-- Pad1Lo,
--                   EndOfDataLo,
                   EndOfPacketWord
--                    EndOfPacketHi,
--                    EndOfPacketLo

                   );

  signal state : states;

  signal ll_eof      : std_logic;
  signal dst_rdy_out : std_logic;
  signal net_seq_id  : std_logic_vector(15 downto 0);

begin

  ll_eof_o <= ll_eof;

  -- Type (hijacked by HSIO Magic Number) 0x8765)
  pkt_header(0) <= x"8765";

  -- HSIO sequence num
  pkt_header(1) <= net_seq_id(15 downto 0);

  -- HSIO length field

  data_len       <= data_length_i + (9*2);  -- payload size (bytes - convert from words below)
                                            -- +4 packet header
                                            -- +3 comblock header
                                            -- +1 crc
                                            -- +1 errrrrrrrrr
  pkt_header(2) <= data_len(15 downto 0);

  -- HSIO comblock count field          -- always 1 for readout
  pkt_header(3) <= x"0001";

  prc_packet_format_machine : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then               --or (machine_rst = '1') then
        state        <= Idle;
        ll_sof_o     <= '0';
        ll_eof       <= '0';
        ll_src_rdy_o <= '0';
        dst_rdy_out  <= '0';
        bcount_clr   <= '1';
        bcount_en    <= '0';
        ll_data_o    <= (others => '0');

      else

        -- uber defaults
        dst_rdy_out  <= '0';
        ll_src_rdy_o <= '0';
        bcount_en    <= '0';


        -- use dst_rdy to freeze the whole machine. Is this a good idea??
        if (ll_dst_rdy_i = '1') then

          --defaults
          ll_sof_o     <= '0';
          ll_eof       <= '0';
          ll_src_rdy_o <= '1';
          dst_rdy_out  <= '0';
          bcount_clr   <= '0';
          bcount_en    <= '1';
          ll_data_o    <= (others => '0');

          case state is

            when Idle =>
              dst_rdy_out  <= '0';
              bcount_en    <= '0';
              ll_src_rdy_o <= '0';
              if (src_rdy_i = '1') and (sof_i = '1') then
                bcount_en  <= '1';
                state      <= Header0;
              end if;


            when Header0 =>
              dst_rdy_out <= '0';
              ll_sof_o    <= '1';
              ll_data_o   <= pkt_header(conv_integer(bcount));
              state       <= Header;

            when Header =>
              dst_rdy_out <= '0';
              ll_data_o   <= pkt_header(conv_integer(bcount));
              if (bcount = x"0003") then  --3
                state     <= DataWord;
              end if;


            when DataWord =>
              dst_rdy_out <= '1';
              ll_data_o <= data_i;
              if eof_i = '1' then
                dst_rdy_out <= '0';
                state <= EndOfPacketWord;
              end if;

            when EndOfPacketWord =>
              --if (bcount > x"003f" ) then
                ll_eof <= '1';
                bcount_clr <= '1';
                state <= Idle;
              --else
                --state <= EndOfPacketWord;
              --end if;
              
            when others => null;


          end case;
        end if;
      end if;
    end if;
  end process;


  dst_rdy_o <= dst_rdy_out and ll_dst_rdy_i;

  prc_byte_counter : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') or (bcount_clr = '1') then
        bcount   <= X"0000";
      else
        if (bcount_en = '1') then
          bcount <= bcount + '1';
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
        if (ll_eof = '1') then
          net_seq_id <= net_seq_id + '1';
        end if;
      end if;
    end if;

  end process;


end architecture;
