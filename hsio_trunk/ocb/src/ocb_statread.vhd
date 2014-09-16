--
-- Opcode Block STATBLOCK
--
-- Opcodes serviced: OC_STATREAD
-- 
-- Read bank of 32x16b status words
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


entity ocb_statread is
   port( 
      -- oc rx interface
      oc_valid_i : in     std_logic;
      oc_data_i  : in     slv16;
      oc_dack_no : out    std_logic;
      -- locallink tx interface
      lls_o      : out    t_llsrc;
      lld_i      : in     std_logic;
      -- status words in
      stat_i     : in     slv16_array (31 downto 0);
      -- infrastructure
      clk        : in     std_logic;
      rst        : in     std_logic
   );

-- Declarations

end ocb_statread ;


architecture rtl of ocb_statread is

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


  signal addr_clr : std_logic;
  signal addr_inc : std_logic;
  signal addr : slv5;
  --signal addr_int : integer range 0 to 31;

  signal stat_blk : slv16_array(31 downto 0);


  signal ack_send    : std_logic;
  signal ack_busy    : std_logic;
  signal ack_payload : slv16;
  signal rx_ocseq    : slv16;
  signal rx_oc_port : slv4;
  signal tx_opcode    : slv16;


  signal ocseq_store_en : std_logic;
signal oc_port_store_en : std_logic;

  type states is (Opcode, OCSeq, Size,
                  BlkRd_WaitEOF, BlkRd_Header, BlkRd_Data,
                  WaitOCReady, Idle, OCDone
                  );

  signal state, nstate : states;

  attribute keep : string;
  attribute keep of addr : signal is "true";
  attribute keep of state : signal is "true";
 

begin

  stat_blk <= stat_i;

  -- State Machine
  --------------------------------------------------------
  prc_sync_part : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        state <= WaitOCReady;
      else
        state <= nstate;                -- after 50 ps;

      end if;
    end if;
  end process;



  prc_async_machine : process (oc_valid_i, ack_busy, oc_data_i,
                               addr,
                               --addr_int,
                               state
                               )
  begin

    -- defaults
    nstate         <= Idle;
    oc_dack_no     <= '1';
    ack_send       <= '0';
    ocseq_store_en <= '0';
    addr_clr       <= '0';
    addr_inc       <= '0';
    oc_port_store_en <= '0';

    case state is

      -------------------------------------------------------------------

      when WaitOCReady =>                      -- Make sure we get rising edge of oc_valid
        nstate     <= WaitOCReady;
        oc_dack_no <= 'Z';
        addr_clr   <= '1';
        if (oc_valid_i = '0') then
          nstate   <= Idle;
        end if;


      when Idle =>
        nstate     <= Idle;
        oc_dack_no <= 'Z';
        if (oc_valid_i = '1') then
          if (oc_get_opcodepl(oc_data_i) = OC_STATREAD) then
            oc_port_store_en <= '1';
            nstate <= Opcode;
          else
            nstate <= WaitOCReady;
          end if;
        end if;


      when Opcode =>
        oc_dack_no <= '0';
        nstate     <= OCSeq;


      when OCSeq =>
        oc_dack_no     <= '0';
        ocseq_store_en <= '1';
        nstate         <= Size;


      when Size =>
        oc_dack_no <= '0';
        nstate     <= BlkRd_WaitEOF;


        -- STATBLOCK_RD
        -------------------------------------------------------------

      when BlkRd_WaitEOF =>
        nstate     <= BlkRd_WaitEOF;
        oc_dack_no <= '0';
        if (oc_valid_i = '0') then
            oc_dack_no <= '1';  -- wait til after ack
          nstate   <= BlkRd_Header;
        end if;


      when BlkRd_Header =>
        nstate     <= BlkRd_Header;
        oc_dack_no <= '1';
        ack_send <= '1';
        addr_clr <= '1';
        if (ack_busy = '0') then  -- if ack_send=1, ack_busy signals start of data transfer (this is advanced mode)
          nstate <= BlkRd_Data;
        end if;


      when BlkRd_Data =>
        nstate     <= BlkRd_Data;
        oc_dack_no <= '1';
        ack_send <= '1';

        --if (addr_int = 31) then
        if (addr = "11111") then
          ack_send <= '0';
        end if;

        if (ack_busy = '0') then
          addr_inc <= '1';
          --if (addr_int = 31) then
          if (addr = "11111") then
            nstate <= OCDone;
          end if;
        end if;


           --=========================================================================
      when OCDone =>
        oc_dack_no   <= '0'; -- final oc_dack to release ocbus
        nstate <= Idle;


    end case;
  end process;


--------------------------------------------------------------------


  prc_addr_count_store : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') or (addr_clr = '1') then
        addr <= (others => '0');
        --addr_int <= 0;

      else
        if (addr_inc = '1') then
          --if (addr_int < 31) then
          if (addr < "11111") then
            --addr <= '0';
            --addr_int <= 0;
            --else
            addr <= addr + '1';
            --addr_int <= addr_int + 1;
          end if;
        end if;
      end if;
    end if;
  end process;

-- addr_int <= conv_integer(addr(4 downto 0));




-----------------------------------------------------------
-- Ack Interface

  prc_ocseq_store : process (clk)
  begin
    if rising_edge(clk) then
      if (oc_port_store_en = '1') then
        rx_oc_port <= oc_get_port(oc_data_i);
      end if;

      if (ocseq_store_en = '1') then
        rx_ocseq <= oc_data_i;
      end if;
    end if;
  end process;

  --ack_payload <= stat_blk(addr_int);
  ack_payload <= stat_blk(conv_integer(addr));

  tx_opcode <= oc_insert_port(OC_STATREAD, rx_oc_port);

  ocbstatrd_ack : ll_ack_gen
    port map (
      opcode_i  => tx_opcode,
      ocseq_i   => rx_ocseq,
      ocsize_i  => x"0040",
      payload_i => ack_payload,
      send_i    => ack_send,
      busy_o    => ack_busy,
      lls_o     => lls_o,
      lld_i     => lld_i,
      clk       => clk,
      rst       => rst
      );


end architecture;


