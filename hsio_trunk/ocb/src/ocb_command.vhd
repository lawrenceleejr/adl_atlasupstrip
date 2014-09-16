--
-- Opcode COMMAND
--  
-- For pulsed signals
--
-- 
--


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library utils;
use utils.pkg_types.all;

library locallink;

library hsio;
use hsio.pkg_core_globals.all;

entity ocb_command is
   port( 
      -- oc rx interface
      oc_valid_i        : in     std_logic;
      oc_data_i         : in     slv16;
      oc_dack_no        : out    std_logic;
      -- locallink tx interface
      lls_o             : out    t_llsrc;
      lld_i             : in     std_logic;
      -- payload output
      command_o         : out    slv16;
      rst_ro_o          : out    std_logic;
      rst_trig_o        : out    std_logic;
      --rst_ocb_o   : out std_logic;
      rst_feo_o         : out    std_logic;
      rst_disp_o        : out    std_logic;
      rst_nettx_o       : out    std_logic;
      rst_netrx_o       : out    std_logic;
      rst_drv_o         : out    std_logic;
      slow_reset_tick_i : in     std_logic;
      -- infrastructure
      clk               : in     std_logic;
      rst               : in     std_logic
   );

-- Declarations

end ocb_command ;


architecture rtl of ocb_command is


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

  signal cmd        : slv16;
  signal cmd_store_en : std_logic;
  signal cmd_out_en : std_logic;

  signal reset_cmd     : slv16;
  signal reset_cmd_clr : std_logic;
  signal reset_out     : slv16;

  signal ocseq_store_en     : std_logic;
  signal reset_cmd_store_en : std_logic;
  signal rx_ocseq           : slv16;
  signal oc_port_store_en   : std_logic;
  signal rx_oc_port         : slv4;
  signal tx_opcode          : slv16;

  signal ack_busy : std_logic;
  signal ack_send : std_logic;



  type states is (Reset,
                  Opcode, OCSeq, Size,
                  SendCommand,
                  LongCommand0, LongCommand1,
                  SendAck, WaitAckBusy,
                  Idle, WaitOCReady, OCDone
                  );

  signal state, nstate : states;

begin

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


  prc_async_machine : process (oc_valid_i, oc_data_i, ack_busy,
                               slow_reset_tick_i,
                               state
                               )
  begin

    -- defaults
    nstate             <= Reset;
    oc_dack_no         <= '1';
    ack_send           <= '0';
    ocseq_store_en     <= '0';
    reset_cmd_clr     <= '0';
    reset_cmd_store_en <= '0';
    cmd_store_en       <= '0';
    cmd_out_en         <= '0';
    oc_port_store_en   <= '0';


    case state is

      -------------------------------------------------------------
      when Reset =>
        oc_dack_no   <= 'Z';
        cmd_out_en <= '1'; -- sends all resets
        nstate       <= WaitOCReady;


      when WaitOCReady =>
        nstate     <= WaitOCReady;
        oc_dack_no <= 'Z';
        if (oc_valid_i = '0') then      -- wait for OC to be done
          nstate   <= Idle;
        end if;


      when Idle =>
        nstate               <= Idle;
        oc_dack_no           <= 'Z';
        reset_cmd_clr       <= '1';
        if (oc_valid_i = '1') then
          if (oc_get_opcodepl(oc_data_i) = OC_COMMAND) then  -- check for opcode here
            oc_port_store_en <= '1';
            nstate           <= Opcode;
          else
            nstate           <= WaitOCReady;
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
        if (oc_data_i = 16#4#) then
          nstate   <= LongCommand0;
        else
          nstate   <= SendCommand;
        end if;


        --------------------------------------------------------------
      when SendCommand =>
        --oc_dack_no <= '0';            -- skip dtack in case this is the last word
        cmd_store_en <= '1';
        nstate       <= SendAck;


        --------------------------------------------------------------
      when LongCommand0 =>
        oc_dack_no   <= '0';
        cmd_store_en <= '1';
        nstate       <= LongCommand1;


      when LongCommand1 =>
        --oc_dack_no <= '0';            -- skip dtack in case this is the last word
        reset_cmd_store_en <= '1';
        nstate             <= SendAck;

        --------------------------------------------------------------



      when SendAck =>
        nstate       <= SendAck;
        oc_dack_no   <= '0';
        if (oc_valid_i = '0') then
          oc_dack_no <= '1';            -- wait until after ack
          cmd_out_en <= '1';
          ack_send   <= '1';
          nstate     <= WaitAckBusy;
        end if;


      when WaitAckBusy =>
        nstate     <= WaitAckBusy;
        oc_dack_no <= '1';
        if (ack_busy = '0') then
          nstate   <= OCDone;
        end if;


        --=========================================================================
      when OCDone =>
        oc_dack_no <= '0';              -- final oc_dack to release ocbus
        nstate     <= Idle;


    end case;
  end process;


  ---------------------------------

  prc_clockout : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        cmd       <= (others => '0');
        command_o <= (others => '0');

        reset_cmd <= (others => '0');
        reset_out <= (others => '1');

      else

        if (cmd_store_en = '1') then
          cmd <= oc_data_i;
        end if;

        if (reset_cmd_clr = '1') then
          reset_cmd <= x"0000";

        elsif (reset_cmd_store_en = '1') then
          reset_cmd <= oc_data_i;

        end if;


        -- defaults
        command_o <= (others => '0');
        reset_out <= (others => '0');

        if (cmd_out_en = '1') then
          command_o <= cmd;
          reset_out <= reset_cmd;
        end if;

      end if;

    end if;
  end process;

  rst_ro_o    <= reset_out(CMD_RST_RO);
  rst_trig_o  <= reset_out(CMD_RST_TRIG);
  --rst_ocb_o   <= reset_out(CMD_RST_OCB);
  --rst_feo_o   <= reset_out(CMD_RST_FEO);
  rst_disp_o  <= reset_out(CMD_RST_DISP);
  rst_nettx_o <= reset_out(CMD_RST_NETTX);
  rst_netrx_o <= reset_out(CMD_RST_NETRX);
  rst_drv_o   <= reset_out(CMD_RST_DRV);



-----------------------------------------------------------
-- Ack Interface

  prc_ocseq_store : process (clk)
  begin
    if rising_edge(clk) then
      if (oc_port_store_en = '1') then
        rx_oc_port <= oc_get_port(oc_data_i);
      end if;
      if (ocseq_store_en = '1') then
        rx_ocseq   <= oc_data_i;
      end if;
    end if;
  end process;


  tx_opcode <= oc_insert_port(OC_COMMAND, rx_oc_port);

  ocbcommand_ack : ll_ack_gen
    port map (
      opcode_i  => tx_opcode,
      ocseq_i   => rx_ocseq,
      ocsize_i  => x"0002",
      payload_i => x"acac",
      send_i    => ack_send,
      busy_o    => ack_busy,
      lls_o     => lls_o,
      lld_i     => lld_i,
      clk       => clk,
      rst       => rst
      );



end architecture;


