--
-- LocalLink Ack Packet Generator
--
-- Tiny block for simple Ack sending
-- Has advanced extra functions for larger payloads:
--  send_i: leave high to indicate more data available
--  busy_o: if send_i high, used for flow control
--

-- SIMPLE ACK MODE:
--
-- clk ^\__/^^\__/^^\__/^^\__/^^\__/^^\__/^^\__/^^\__/^^\__/
--
-- send_i _/^^^^^\__________________________________________
--
-- busy_o _______/^^^^^^^^^^^^^^^^^^^^^^^\__________________
--
-- data_o _______/ opc | seq | siz | pay \__________________
--
--
-- ADVANCED MODE:
-- Hold send high, busy acts as eoheader signal,
-- then flow control for payload data
--
-- clk \__/^^\__/^^\__/^^\__/^^\__/^^\__/^^\__/^^\__/^^\__/^^\__/ ... _/^^\__
--
-- send_i _/^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ ... ^^^^^\_
--
-- busy_o _______/^^^^^^^^^^^\_____/^^^^^^^^^^^\_____/^^^^^^^^^^^ ... ^^^^^\_
--
-- data_o _______/ opc | seq | siz | pa0 | pa1 |    pa2    | pa3  ...  paZ \_
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

entity ll_ack_gen is
  port(
    -- input interface
    opcode_i  : in    slv16;
    ocseq_i   : in    slv16;
    ocsize_i  : in    slv16;
    payload_i : in    slv16;
    send_i    : in    std_logic;
    busy_o    : out   std_logic;
    -- locallink tx interface
    lls_o              : out t_llsrc;
    lld_i              : in std_logic;
    -- infrastucture
    clk       : in    std_logic;
    rst       : in    std_logic
    );

-- Declarations

end ll_ack_gen;


architecture rtl of ll_ack_gen is


  type states is (SrcRdy, OpcodeSOF, OCSeq, Size,
                  PayloadEOF, AdvPayloadEOF,
                  Idle);

  signal state, nstate : states;

  attribute keep : string;
  attribute keep of state : signal is "true";
  
begin

---------------------------------------------------------------

  prc_sm_sync : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        state <= Idle;
      else
        state <= nstate;

      end if;
    end if;
  end process;


  prc_sm_async : process (lld_i, send_i,
                          opcode_i, ocseq_i, ocsize_i, payload_i,
                          state)
  begin

    -- defaults
    nstate    <= Idle;
    busy_o    <= '1';
    lls_o.src_rdy <= '1';
    lls_o.sof     <= '0';
    lls_o.eof     <= '0';
    lls_o.data    <= opcode_i;


    case state is


      when Idle =>
        nstate    <= Idle;
        busy_o    <= '0';
        lls_o.src_rdy <= '0';
        if (send_i = '1') then
          busy_o <= '1';
          nstate <= SrcRdy;
        end if;


      when SrcRdy =>
        nstate <= SrcRdy;
        if (lld_i = '1') then
          nstate <= OpcodeSOF;
        end if;


      when OpcodeSOF =>
        nstate <= OpcodeSOF;
        lls_o.sof  <= '1';
        lls_o.data <= opcode_i;
        if (lld_i = '1') then
          nstate <= OCSeq;
        end if;


      when OCSeq =>
        nstate <= OCSeq;
        lls_o.data <= ocseq_i;
        if (lld_i = '1') then
          nstate <= Size;
        end if;


      when Size =>
        nstate <= Size;
        lls_o.data <= ocsize_i;
        if (send_i = '1') then  -- send=1 here =  advanced mode, busy=0 signals end-of-header
          if (lld_i = '1') then
            busy_o <= '0';
            nstate <= AdvPayloadEOF;
          end if;
        else
          if (lld_i = '1') then
            nstate <= PayloadEOF;
          end if;
        end if;



      when PayloadEOF =>
        nstate <= PayloadEOF;
        lls_o.data <= payload_i;
        lls_o.eof  <= '1';
        if (lld_i = '1') then
          nstate <= Idle;
        end if;



        ------------------------------------
      when AdvPayloadEOF =>
        nstate <= AdvPayloadEOF;
        lls_o.data <= payload_i;
        busy_o <= not(lld_i);
        if (send_i = '0') then
          lls_o.eof <= '1';
          if (lld_i = '1') then
            nstate <= Idle;
          end if;
        end if;


    end case;
  end process;



-----------------------------------------------------------------------------------
end architecture;
