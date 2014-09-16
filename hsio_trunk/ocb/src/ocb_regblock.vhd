--
-- Opcode Block REGBLOCK
--
-- Opcodes serviced: OC_REGWRITE, OC_REGBLOCK_RD, OC_REGBLOCK_WR
-- 
-- Read/Write to bank of 16b registers
--
-- An example of a multi-opcode OCB
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


entity ocb_regblock is
   port( 
      -- locallink tx interface
      lls_o      : out    t_llsrc;
      lld_i      : in     std_logic;
      -- oc rx interface
      oc_valid_i : in     std_logic;
      oc_data_i  : in     slv16;
      oc_dack_no : out    std_logic;
      -- registers
      reg_o      : out    t_reg_bus;
      db_wr_o    : out    slv32;
      db_data_o  : out    slv16;
      -- infrastructure
      clk        : in     std_logic;
      rst        : in     std_logic
   );

-- Declarations

end ocb_regblock ;


architecture rtl of ocb_regblock is


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


  signal addr_str : std_logic;
  signal addr_clr : std_logic;
  signal addr_inc : std_logic;
  --signal addr     : slv16;
  signal addr_int : integer range 0 to 31;
  signal data_str : std_logic;
-- signal reg_data : slv16_array (0 to 31) := (others => x"0000");
  signal reg_data : t_reg_bus := (others => x"0000");

  signal opcode_ok : std_logic;

  signal ack_send    : std_logic;
  signal ack_busy    : std_logic;
  signal ack_opcode  : slv16;
  signal ack_size    : slv16;
  signal ack_payload : slv16;
  signal rx_oc_port    : slv4;
  signal rx_ocseq    : slv16;

  signal ocseq_store_en : std_logic;
  signal oc_decode_en   : std_logic;
  signal oc_data_opcodepl : slv16;


  type oc_decoded_type is (REGWRITE, REGBLOCK_RD, REGBLOCK_WR, UNRECOG_OPCODE);
  signal oc_decoded : oc_decoded_type;


  type states is (Opcode, OCSeq, Size,
                  RegWr_Start, RegWr_Data,
                  BlkWr_Start, BlkWr_Data,
                  BlkRd_WaitEOF, BlkRd_Header, BlkRd_Data,
                  WaitEOF,
                  SendAck, WaitAckBusy,
                  WaitOCReady, Idle, OCDone
                  );

  signal state, nstate : states;


begin

  oc_data_opcodepl <= oc_get_opcodepl(oc_data_i);

  opcode_ok <= '1' when (oc_data_opcodepl = OC_REGWRITE)     else
               '1' when (oc_data_opcodepl = OC_REGBLOCK_RD ) else
               '1' when (oc_data_opcodepl = OC_REGBLOCK_WR ) else
               '0';


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



  prc_async_machine : process ( oc_valid_i, ack_busy, oc_data_i,
                                opcode_ok, oc_decoded,
                                --addr,
                                addr_int,
                                state
                                )
  begin

    -- defaults
    nstate         <= Idle;
    oc_dack_no     <= '1';
    ack_send       <= '0';
    ocseq_store_en <= '0';
    oc_decode_en   <= '0';
    addr_str       <= '0';
    data_str       <= '0';
    addr_clr       <= '0';
    addr_inc       <= '0';

    case state is

      -------------------------------------------------------------------

      when WaitOCReady =>                      -- Make sure we get rising edge of oc_valid
        nstate     <= WaitOCReady;
        addr_clr   <= '1';
        oc_dack_no <= 'Z';
        if (oc_valid_i = '0') then
          nstate   <= Idle;
        end if;


      when Idle =>
        nstate           <= Idle;
        oc_dack_no       <= 'Z';
        if (oc_valid_i = '1') then
          if (opcode_ok = '1') then
            oc_decode_en <= '1';
            nstate       <= Opcode;
          else
            nstate       <= WaitOCReady;
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

        case oc_decoded is
          when REGWRITE    => nstate <= RegWr_Start;
          when REGBLOCK_WR => nstate <= BlkWr_Start;
          when REGBLOCK_RD => nstate <= BlkRd_WaitEOF;
          when others      => nstate <= BlkRd_WaitEOF;
        end case;



        -- REGWRITE
        -------------------------------------------------------------

      when RegWr_Start =>               -- Address
        oc_dack_no <= '0';
        addr_str   <= '1';
        nstate     <= RegWr_Data;


      when RegWr_Data =>
        --oc_dack_no <= '0';
        data_str <= '1';
        nstate   <= WaitEOF;


        -- REGBLOCK_WR
        -------------------------------------------------------------
      when BlkWr_Start =>
        addr_clr <= '1';
        nstate   <= BlkWr_Data;


      when BlkWr_Data =>
        nstate     <= BlkWr_Data;
        addr_inc   <= '1';
        oc_dack_no <= '0';
        if (addr_int = 31) then
          if (oc_valid_i = '0') then
            oc_dack_no <= '1'; -- wait til after ack
            nstate <= SendAck;
          else
            nstate <= WaitEOF;
          end if;
        end if;



        -- REGBLOCK_RD
        -------------------------------------------------------------
      when BlkRd_WaitEOF =>
        nstate     <= BlkRd_WaitEOF;
        oc_dack_no <= '0';
        if (oc_valid_i = '0') then
          oc_dack_no <= '1'; -- wait til after ack
          nstate   <= BlkRd_Header;
        end if;


      when BlkRd_Header =>
        nstate     <= BlkRd_Header;
        oc_dack_no <= '1';

        ack_send <= '1';
        addr_clr <= '1';
        if (ack_busy = '0') then        -- if ack_send=1, ack_busy signals start of data transfer (this is advanced mode)
          nstate <= BlkRd_Data;
        end if;


      when BlkRd_Data =>
        nstate     <= BlkRd_Data;
        oc_dack_no <= '1';
        ack_send <= '1';
        
        if (addr_int = 31) then
          ack_send <= '0';
        end if;

        if (ack_busy = '0') then
          addr_inc <= '1';
          if (addr_int = 31) then
            nstate <= OCDone;
          end if;
        end if;


        --------------------------------------------------------------

      when WaitEOF =>
        nstate     <= WaitEOF;
        oc_dack_no <= '0';
        if (oc_valid_i = '0') then
          oc_dack_no <= '1';  -- wait til after ack
          nstate   <= SendAck;
        end if;


      when SendAck =>
        oc_dack_no <= '1';

        ack_send <= '1';
        nstate   <= WaitAckBusy;


      when WaitAckBusy =>
        oc_dack_no <= '1';

        nstate   <= WaitAckBusy;
        if (ack_busy = '0') then      -- wait for Ack to be done
          nstate <= OCDone;
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
        --addr <= (others => '0');
        addr_int <= 0;

      else
        if (addr_str = '1') then
          --addr <= oc_data_i;
          addr_int <= conv_integer(oc_data_i(4 downto 0));

        elsif (addr_inc = '1') then
          if (addr_int < 31) then
            --addr_int <= 0;
            --else
            -- addr <= addr + '1';
            addr_int <= addr_int + 1;
          end if;

        end if;
      end if;
    end if;
  end process;

-- addr_int <= conv_integer(addr(4 downto 0));




  prc_reg_block : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then

        reg_data <= REG_INITVAL;

        db_data_o <= (others => '0');
        db_wr_o   <= (others => '0');

      else

        -- default
        db_wr_o <= (others => '0');

        -- store data to register and output
        if (data_str = '1') then
          reg_data(addr_int) <= oc_data_i;
          db_data_o          <= oc_data_i;
          db_wr_o(addr_int)  <= '1';

        end if;
      end if;
    end if;
  end process;


  reg_o <= reg_data;



-----------------------------------------------------------

  prc_oc_decode_store : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        oc_decoded <= UNRECOG_OPCODE;

      elsif (oc_decode_en = '1') then
        rx_oc_port <= oc_get_port(oc_data_i);
        -- default
        oc_decoded                          <= UNRECOG_OPCODE;
        case oc_data_opcodepl is
          when OC_REGWRITE    => oc_decoded <= REGWRITE;
          when OC_REGBLOCK_RD => oc_decoded <= REGBLOCK_RD;
          when OC_REGBLOCK_WR => oc_decoded <= REGBLOCK_WR;
          when others         => oc_decoded <= UNRECOG_OPCODE;
        end case;
      end if;
    end if;
  end process;



-----------------------------------------------------------
-- Ack Interface

  prc_ocseq_store : process (clk)
  begin
    if rising_edge(clk) then
      if (ocseq_store_en = '1') then
        rx_ocseq <= oc_data_i;
      end if;
    end if;
  end process;



  prc_ack_sigs : process (oc_decoded, reg_data, addr_int)
  begin
    case oc_decoded is
      when REGWRITE =>
        ack_opcode  <= oc_insert_port(OC_REGWRITE, rx_oc_port);
        ack_size    <= x"0002";
        ack_payload <= x"ACAC";

      when REGBLOCK_RD =>
        ack_opcode  <= oc_insert_port(OC_REGBLOCK_RD, rx_oc_port);
        ack_size    <= x"0040";
        ack_payload <= reg_data(addr_int);

      when REGBLOCK_WR =>
        ack_opcode  <= oc_insert_port(OC_REGBLOCK_WR, rx_oc_port);
        ack_size    <= x"0002";
        ack_payload <= x"ACAC";

      when others =>
        ack_opcode  <= oc_insert_port(OC_INVALID, rx_oc_port);
        ack_size    <= x"0002";
        ack_payload <= x"ACAC";

    end case;
  end process;



  ocbregblk_ack : ll_ack_gen
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



