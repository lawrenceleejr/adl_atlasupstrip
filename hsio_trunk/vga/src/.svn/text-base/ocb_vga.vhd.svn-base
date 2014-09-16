--
-- Opcode Block vga
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
use hsio.pkg_hsio_globals.all;
library vga;
use vga.pkg_vga.all;

entity ocb_vga is
  port(
    -- oc rx interface
    oc_valid_i : in  std_logic;
    oc_data_i  : in  slv16;
    oc_dack_no : out std_logic;
    -- locallink tx interface
    lls_o      : out t_llsrc;
    lld_i      : in  std_logic;
    -- VGA controller signals
    vga_ctrl_o : out slv16;
    -- infrastructure
    clk        : in  std_logic;
    rst        : in  std_logic
    );

-- Declarations

end ocb_vga;


architecture rtl of ocb_vga is

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

  signal data_str : std_logic;

  signal ack_send    : std_logic;
  signal ack_busy    : std_logic;
  signal ack_opcode  : slv16;
  signal ack_size    : slv16;
  signal ack_payload : slv16;
  signal rx_ocseq    : slv16;

  signal ocseq_store_en : std_logic;
  signal oc_decode_en   : std_logic;

-- VGA Controls
  signal vga_ctrl : slv16;

  type states is (Opcode, OCSeq, Size,
                  RegWr_Data,
                  WaitEOF,
                  SendAck, WaitAckBusy,
                  Init, Idle
                  );

  signal state, nstate : states;


begin



  -- State Machine
  --------------------------------------------------------
  prc_sync_part : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        state <= Init;
      else
        state <= nstate;                -- after 50 ps;
      end if;
    end if;
  end process;



  prc_async_machine : process ( oc_valid_i, ack_busy, oc_data_i, state )
  begin

    -- defaults
    nstate         <= Idle;
    oc_dack_no     <= '1';
    ack_send       <= '0';
    ocseq_store_en <= '0';
    oc_decode_en   <= '0';
    data_str       <= '0';

    case state is

      -------------------------------------------------------------------

      when Init =>                      -- Make sure we get rising edge of oc_valid
        nstate     <= Init;
        oc_dack_no <= 'Z';
        if (oc_valid_i = '0') then
          nstate   <= Idle;
        end if;


      when Idle =>
        nstate           <= Idle;
        oc_dack_no       <= 'Z';
        if (oc_valid_i = '1') then
          if (oc_data_i = OC_VGA) then  -- check for opcode here
            oc_decode_en <= '1';
            nstate       <= Opcode;
          else
            nstate       <= Init;
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
        nstate     <= RegWr_Data;

      when RegWr_Data =>
        data_str <= '1';
        nstate   <= WaitEOF;

      when WaitEOF =>
        nstate     <= WaitEOF;
        oc_dack_no <= '0';
        if (oc_valid_i = '0') then
          nstate   <= SendAck;
        end if;

      when SendAck =>
        oc_dack_no <= 'Z';
        ack_send   <= '1';
        nstate     <= WaitAckBusy;

      when WaitAckBusy =>
        oc_dack_no <= 'Z';
        nstate     <= WaitAckBusy;
        if (ack_busy = '0') then        -- wait for Ack to be done
          nstate   <= Idle;
        end if;


    end case;
  end process;


--------------------------------------------------------------------


  prc_reg_block : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        vga_ctrl   <= (others => '0');
      else
        -- store data to register and output
        if (data_str = '1') then
          -- First bit activates
          vga_ctrl <= oc_data_i;
        end if;
      end if;
    end if;
  end process;


  vga_ctrl_o <= vga_ctrl;



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

  ack_opcode  <= OC_VGA;
  ack_size    <= x"0002";
  ack_payload <= x"ACAC";

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

