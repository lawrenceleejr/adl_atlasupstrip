--
-- HSIO RX packet decoder
-- Chops of pre-opcode header and passes opcode out
-- Sends Ack
-- Will manage multiple opcode packets one day ...
--


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library utils;
use utils.pkg_types.all;
library hsio;
use hsio.pkg_hsio_globals.all;

entity sim_packet_decode is
  generic(
    UDP            :     integer := 0;
    OC_HEADER_ONLY :     integer := 1;
    OPCODE_CATCH   :     integer := 1
    );
  port(
    opcode_catch_o : out std_logic;
    -- rx ll fifo interface
    src_rdy_i      : in  std_logic;
    data_i         : in  slv16;
    sof_i          : in  std_logic;
    eof_i          : in  std_logic;
    dst_rdy_i      : in  std_logic;     -- we monitor a link only
    -- decoded out
    magicn         : out slv16;
    seq            : out slv16;
    len            : out slv16;
    cbcnt          : out slv16;
    opcode         : out slv16;
    ocseq          : out slv16;
    size           : out slv16;
    words          : out slv16;
    -- infrastructure
    clk            : in  std_logic;
    rst            : in  std_logic
    );

-- Declarations

end sim_packet_decode;


architecture rtl of sim_packet_decode is



  signal srcdst_rdy : std_logic;


  signal hdr     : slv16_array (0 to 13) := (others => x"0000");
  signal hdr_clr : std_logic;


  signal wcount      : integer := 0;         --*** range 0 to 13;
  signal last_wcount : integer;
  signal wcount_en   : std_logic;
  signal wcount_clr  : std_logic;

  signal reg_out_en : std_logic;

  signal dst_mac : slv48;
  signal src_mac : slv48;



  type states is (WaitEOF, Idle );

  signal state, nstate : states;


begin



  prc_clk_out : process (clk)
  begin
    if rising_edge(clk) then
      if (reg_out_en = '1') then
        dst_mac <= hdr(0) & hdr(1) & hdr(2);
        src_mac <= hdr(3) & hdr(4) & hdr(5);

        magicn <= hdr(6);
        seq    <= hdr(7);
        len    <= hdr(8);
        cbcnt  <= hdr(9);

        opcode <= hdr(10);
        ocseq  <= hdr(11);
        size   <= hdr(12);
        words  <= hdr(13);
      end if;
    end if;
  end process;

  srcdst_rdy <= src_rdy_i and dst_rdy_i;


  opcode_catch_o <= '1' when (hdr(10) = conv_std_logic_vector(OPCODE_CATCH, 16)) else '0';

  -- State Machine
  --------------------------------------------------------
  prc_sync_part : process (clk)
  begin
    if rising_edge(clk) then

      if (rst = '1') then
        state <= Idle;

      else
        state <= nstate;

      end if;
    end if;
  end process;


------------------------------------------------------------------

  prc_async_machine : process (src_rdy_i, sof_i, eof_i, wcount, srcdst_rdy, state )
  begin

    -- defaults
    nstate     <= Idle;
    wcount_en  <= '0';
    wcount_clr <= '0';
    hdr_clr    <= '0';
    reg_out_en <= '0';

    case state is


      -------------------------------------------------------------
      when Idle =>
        nstate       <= Idle;
        wcount_clr   <= '1';
        if (srcdst_rdy = '1') and (sof_i = '1') then  -- *** xil ll ignores sof!????
          wcount_clr <= '0';
          wcount_en  <= '1';
          nstate     <= WaitEOF;
        end if;


      when WaitEOF =>
        nstate         <= WaitEOF;
        if (srcdst_rdy = '1') then
          wcount_en    <= '1';
          if (wcount = 13) then
            reg_out_en <= '1';
          end if;
          if (eof_i = '1') then
            nstate     <= Idle;
          end if;
        end if;


    end case;
  end process;



--------------------------------------------------------------------

  prc_word_counter : process (clk)
  begin
    if rising_edge(clk) then

      if (rst = '1') then
        wcount      <= 0;
        last_wcount <= 9999;

      elsif (wcount_clr = '1') then

        if (OC_HEADER_ONLY = 1) then
          wcount <= 10;
        elsif (UDP = 1) then
          wcount <= 6;
        else
          wcount <= 0;
        end if;

      else

        if (wcount_en = '1') then       --and (wcount < 13) then
          wcount <= wcount + 1;
        end if;

        if (eof_i = '1') then
          last_wcount <= wcount;
        end if;

      end if;
    end if;
  end process;





  prc_hdr_store : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') or (hdr_clr = '1') then
        hdr <= (others => x"0000");

      else
        --  if (OC_HEADER_ONLY = 1) then
        if (wcount < 14) then
          hdr(wcount) <= data_i;
        end if;
        --  else
        --    hdr(wcount) <= data_i(7 downto 0) & data_i(15 downto 8);  -- net16 swaps bytes
        --  end if;
      end if;
    end if;
  end process;



end architecture;


