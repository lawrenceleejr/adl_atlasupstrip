--
-- Network RX Packet Formatter
--
-- removes mac headers and sorts out data width problems
-- 
-- presumes to have a ll_fifo downstream with no dst_rdy flow control coming in
--


-- Originally by Matt, then updated to 16 by Erdem, then Matt messed more


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
--use ieee.std_logic_unsigned.all;
library utils;
use utils.pkg_types.all;

library hsio;
use hsio.pkg_core_globals.all;

entity net_rx_pktfmt16 is
   generic( 
      BYTESWAP : integer := 1
   );
   port( 
      -- net side input interface
      net_data_i     : in     slv16;              -- Erdem slv8;
      net_sof_i      : in     std_logic;
      net_eof_i      : in     std_logic;
      net_dst_rdy_o  : out    std_logic;
      net_src_rdy_i  : in     std_logic;
      -- hsio side side (output) interface
      hsio_data_o    : out    slv16  := x"0000";
      hsio_sof_o     : out    std_logic;
      hsio_eof_o     : out    std_logic;
      hsio_dst_rdy_i : in     std_logic;
      hsio_src_rdy_o : out    std_logic;
      rx_src_mac_o   : out    slv48;
      clk            : in     std_logic;
      rst            : in     std_logic
   );

-- Declarations

end net_rx_pktfmt16 ;


architecture rtl of net_rx_pktfmt16 is


  signal bcount     : integer range 0 to 15;
  signal bcount_clr : std_logic;
  signal bcount_inc : std_logic;


  signal rx_net_hdr : slv16_array (0 to 7) := (others => x"0000");

  signal srcdst_rdy : std_logic;
  signal in_header  : std_logic;


  signal type_check : std_logic;
  signal net_data   : slv16;


  type states is (
    NetHeader, HSIO_SrcRdy, HSIO_SOF, Wait_EOF,
    Idle, Reset
    );

  signal state, nstate : states;

begin


  gen_byteswap1 : if (BYTESWAP = 1) generate
    net_data <= net_data_i (7 downto 0) & net_data_i (15 downto 8);
  end generate;


  gen_byteswap0 : if (BYTESWAP = 0) generate
      net_data <= net_data_i;
  end generate;

  hsio_data_o <= net_data;



  -- State Machine
  --------------------------------------------------------

  prc_rxformat_sm_clocked : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        state <= Reset;
      else
        state <= nstate;
      end if;
    end if;
  end process;


  prc_rx_format_sm_async : process (net_src_rdy_i,
                                    net_sof_i,
                                    net_eof_i,
                                    hsio_dst_rdy_i,
                                    bcount,
                                    state )
  begin

    --defaults
    nstate         <= Idle;
    in_header      <= '0';
    hsio_src_rdy_o <= '0';
    hsio_sof_o     <= '0';
    hsio_eof_o     <= '0';
    bcount_clr     <= '0';
    bcount_inc     <= '0';
    net_dst_rdy_o  <= '0';
    type_check     <= '0';

    case state is


      when Reset =>
        net_dst_rdy_o <= '0';
        bcount_clr    <= '1';
        nstate        <= Idle;


      when Idle =>
        nstate        <= Idle;
        net_dst_rdy_o <= '1';
        in_header     <= '1';
        if (net_src_rdy_i = '1') and (net_sof_i = '1') then
          bcount_inc  <= '1';
          nstate      <= NetHeader;
        end if;


      when NetHeader =>                 -- dst mac, src mac
        nstate        <= NetHeader;
        net_dst_rdy_o <= '1';
        in_header     <= '1';
        bcount_inc    <= '1';           -- we presume no src flow control
        if (bcount = 4) then            -- one less because it inc's (and net_dst_rdy's) 1 more time
          nstate      <= HSIO_SrcRdy;
        end if;


      when HSIO_SrcRdy =>
        nstate          <= HSIO_SrcRdy;
        in_header       <= '1';         -- otherwise we miss the last word
        hsio_src_rdy_o  <= '1';
        if (hsio_dst_rdy_i = '1') then
          net_dst_rdy_o <= '1';
          nstate        <= HSIO_SOF;
        end if;


      when HSIO_SOF =>
        nstate          <= HSIO_SOF;
        hsio_src_rdy_o  <= '1';
        hsio_sof_o      <= '1';
        type_check      <= '1';         -- SOF = convenient place marker
        if (hsio_dst_rdy_i = '1') then
          net_dst_rdy_o <= '1';
          nstate        <= Wait_EOF;
        end if;


      when Wait_EOF =>
        nstate          <= Wait_EOF;
        hsio_src_rdy_o  <= '1';
        if (net_eof_i = '1') then
          hsio_eof_o    <= '1';
        end if;
        if (hsio_dst_rdy_i = '1') then
          net_dst_rdy_o <= '1';
          if (net_eof_i = '1') then
            nstate      <= Reset;
          end if;
        end if;


    end case;
  end process;



  prc_byte_counter : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') or (bcount_clr = '1') then
        bcount <= 0;

      else
        if (bcount_inc = '1') and (bcount < 7) then
          bcount <= bcount + 1;

        end if;
      end if;
    end if;
  end process;


  prc_src_mac_store : process (clk)
  begin
    if rising_edge(clk) then
      if (in_header = '1') then
        rx_net_hdr(bcount) <= net_data;
      end if;

      -- check if packet is of right type
      if (type_check = '1') then--and (net_data(15 downto 4) = x"876") then
        rx_src_mac_o <= rx_net_hdr(3) & rx_net_hdr(4) & rx_net_hdr(5);
      end if;

    end if;
  end process;



end architecture;

