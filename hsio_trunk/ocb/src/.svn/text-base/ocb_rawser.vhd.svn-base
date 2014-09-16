--
-- Opcode Block RAWSER
-- 
-- Send payload as serial data
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


entity ocb_rawser is
  generic(
    OPCODE : slv16 := x"9999"
    );
  port(
    -- oc rx interface
    oc_valid_i  : in    std_logic;
    oc_data_i   : in    slv16;
    oc_dtack_o  : out   std_logic;
    -- locallink tx interface
    llo         : inout t_llbus;
    -- serialiser
    ser_data_o  : out   std_logic;
    ser_clk_o   : out   std_logic;
    ser_start_o : out   std_logic;
    ser_2tick_i : in    std_logic;
    -- infrastructure
    clk         : in    std_logic;
    rst         : in    std_logic
    );

-- Declarations

end ocb_rawser;


architecture rtl of ocb_rawser is


  component ll_ack_gen
    port (
      -- input interface
      opcode_i  : in    slv16;
      ocseq_i   : in    slv16;
      ocsize_i  : in    slv16;
      payload_i : in    slv16;
      send_i    : in    std_logic;
      busy_o    : out   std_logic;
      -- output interface
      llo       : inout t_llbus;
      -- infrastucture
      clk       : in    std_logic;
      rst       : in    std_logic
      );
  end component;

  signal control_word : slv16;
  signal cw_store_en  : std_logic;


  constant SER_CLK_DELAY : integer := 1;

  signal ser_clk_q : std_logic;

  signal ser_tick       : std_logic;
  signal ser_data       : std_logic;
  signal ser_enable     : std_logic;
  signal ser_clk_enable : std_logic;
  signal ser_clk_invert : std_logic;
  signal ser_clk        : std_logic;

  signal bitcount     : integer range 0 to 15;
  signal bitcount_set : std_logic;

  signal ocseq_store_en : std_logic;
  signal rx_ocseq       : slv16;
  signal oc_port       : slv4;

  signal ack_busy : std_logic;
  signal ack_send : std_logic;



  type states is (OpcodeStart, OCSeq, Size, ControlWord,
                  ClkSync, RawCom_Start,
                  Serialise, SerialLoad, SendAck,
                  Idle, Init
                  );

  signal state, nstate : states;

begin


  ser_clk_invert <= control_word(0);



  -- State Machine
  --------------------------------------------------------
  prc_sync_part : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        state <= Init;
      else
        state <= nstate;

      end if;
    end if;
  end process;


  prc_async_machine : process (oc_valid_i, oc_data_i,
                               bitcount, ser_tick, ack_busy,
                               state
                               )
  begin

    -- defaults
    nstate         <= Init;
    oc_dtack_o     <= '0';
    bitcount_set   <= '0';
    ser_enable     <= '0';
    ser_data       <= '0';
    ack_send       <= '0';
    ocseq_store_en <= '0';
    oc_port_store_en <= '0';
    cw_store_en    <= '0';
    ser_start_o    <= '0';
    ser_clk_enable <= '0';

    case state is

      -------------------------------------------------------------

      when Init =>
        nstate <= Init;
        if (oc_valid_i = '0') then  -- wait for OC to be done
          nstate <= Idle;
        end if;


      when Idle =>
        nstate <= Idle;
        if (oc_valid_i = '1') then
          if (oc_get_opcodepl(oc_data_i) = OPCODE) then
            oc_port_store_en <= '1';
            nstate <= OpcodeStart;
          else
            nstate <= Init;
          end if;
        end if;


      when OpcodeStart =>
        oc_dtack_o <= '1';
        nstate     <= OCSeq;


      when OCSeq =>
        oc_dtack_o     <= '1';
        ocseq_store_en <= '1';
        nstate         <= Size;


      when Size =>
        oc_dtack_o <= '1';
        nstate     <= ControlWord;


      when ControlWord =>
        oc_dtack_o  <= '1';
        cw_store_en <= '1';
        nstate      <= ClkSync;


        --------------------------------------------------------------
      when ClkSync =>
        nstate     <= ClkSync;
        ser_enable <= '1';
        if (ser_tick = '1') then
          ser_clk_enable <= '1';
          nstate         <= RawCom_Start;
        end if;


      when RawCom_Start =>
        nstate         <= RawCom_Start;
        ser_enable     <= '1';
        ser_clk_enable <= '1';
        ser_start_o    <= '1';
        bitcount_set   <= '1';
        if (ser_tick = '1') then
          nstate <= Serialise;
        end if;


      when Serialise =>
        nstate         <= Serialise;
        ser_enable     <= '1';
        ser_clk_enable <= '1';
        ser_data       <= oc_data_i(bitcount);
        if (bitcount = 1) and (ser_tick = '1') then
          nstate <= SerialLoad;
        end if;


      when SerialLoad =>
        nstate         <= SerialLoad;
        ser_enable     <= '1';
        ser_clk_enable <= '1';
        ser_data       <= oc_data_i(bitcount);

        if (ser_tick = '1') then        -- bitcount = min
          if (oc_valid_i = '0') then
            nstate <= SendAck;
          else
            oc_dtack_o <= '1';
            nstate     <= Serialise;
          end if;
        end if;


      when SendAck =>
        oc_dtack_o <= '1';              -- acknowlege final word
        ack_send   <= '1';
        nstate     <= WaitAckBusy;

        
      when WaitAckBusy =>
        nstate <= WaitAckBusy;
        if (ack_busy = '0') then 
          nstate     <= Idle;
        end if;



    end case;
  end process;


  --------------------------------------------------------------------


  prc_set_tick_clk_gen : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') or (ser_enable = '0') then
        ser_tick <= '0';
        ser_clk  <= '0';

      else

        -- defaults
        ser_tick <= '0';

        if (ser_2tick_i = '1') then
          ser_clk <= not(ser_clk);

          if (ser_clk = '0') then
            ser_tick <= '1';
          end if;

        end if;

      end if;
    end if;
  end process;


  ----------------------------------------------------------------------

  prc_bit_counter40 : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') or (bitcount_set = '1') then
        bitcount <= 15;
      else
        if (ser_tick = '1') then
          if (bitcount = 0) then
            bitcount <= 15;
          else
            bitcount <= bitcount - 1;
          end if;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------
  -- Control Word Store

  prc_cw_store : process (clk)
  begin
    if rising_edge(clk) then
      if (cw_store_en = '1') then
        control_word <= oc_data_i;
      end if;
    end if;
  end process;


  ---------------------------------

  prc_clockout : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        ser_data_o <= '0';
        ser_clk_q  <= '0';
        ser_clk_o  <= '0';

      else

        ser_data_o <= ser_data;

        -- use rising edge to squash short pulse
        ser_clk_q <= (ser_clk xor ser_clk_invert) and ser_clk_enable;
        ser_clk_o <= ser_clk_q;

      end if;
    end if;
  end process;



  --ser_clk_o <= not ser_clk_q(SER_CLK_DELAY);


  -----------------------------------------------------------
  -- Ack Interface

  prc_stores : process (clk)
  begin
    if rising_edge(clk) then
      if (ocseq_store_en = '1') then
        rx_ocseq <= oc_data_i;
      end if;
      if (oc_opcode_store_en = '1') then
        rx_oc_port <= oc_get_port(oc_data_i);
      end if;
    end if;
  end process;


  rx_opcode <= oc_insert_port(OPCODE, rx_oc_port);

  
  ocbrawser_ack : ll_ack_gen
    port map (
      opcode_i  => rx_opcode,
      ocseq_i   => rx_ocseq,
      ocsize_i  => x"0002",
      payload_i => x"acac",
      send_i    => ack_send,
      busy_o    => ack_busy,
      llo       => llo,
      clk       => clk,
      rst       => rst
      );


end architecture;


