--
-- FIFO Used for sending OCB Acks/Replies
--
-- Filled with data as per normal, but Opcode etc need only be added at send time.
-- This allow truncations, timeouts etc to be flagged, but existing data to be
-- sent.
-- Based on a BRAM, as it's less LUT hungry
--
-- NOTE: The size is provided by the "client" - and not monitored here. This may
-- have to change, but lets see if we can get away from it ...
--
--
-- Changelog:
-- 2012-07-05 -- Added sof - keeps things tidy. 

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library utils;
use utils.pkg_types.all;

library hsio;
use hsio.pkg_core_globals.all;

entity ll_fifo_ack_gen is
  port(

    -- input interface
    data_i : in slv16;
    wren_i : in std_logic;
    eof_i  : in std_logic;
    sof_i  : in std_logic;

    -- send interface
    send_i   : in    std_logic;
    opcode_i : in    slv16;
    ocseq_i  : in    slv16;
    size_i   : in    slv16;
    busy_o   : out   std_logic;
    -- locallink tx interface
    lls_o              : out t_llsrc;
    lld_i              : in std_logic;
    -- infrastucture
    clk      : in    std_logic;
    rst      : in    std_logic

    );

-- Declarations

end ll_fifo_ack_gen;


architecture rtl of ll_fifo_ack_gen is

  component cg_brfifo_1kx18
    port (
      clk        : in  std_logic;
      srst       : in  std_logic;
      din        : in  std_logic_vector(17 downto 0);
      wr_en      : in  std_logic;
      rd_en      : in  std_logic;
      dout       : out std_logic_vector(17 downto 0);
      full       : out std_logic;
      overflow   : out std_logic;
      empty      : out std_logic;
      underflow  : out std_logic;
      data_count : out std_logic_vector(1 downto 0);
      prog_full  : out std_logic
      );
  end component;

  signal fifo_din  : std_logic_vector(17 downto 0);
  signal fifo_dout : std_logic_vector(17 downto 0);
  signal fifo_rd   : std_logic;

  signal fifo_data : slv16;
  signal fifo_eof  : std_logic;
  signal fifo_sof  : std_logic;


  type states is (FIFOSOF, SrcRdy, OpcodeSOF, OCSeq, Size, PayloadEOF, Done,
                  Idle );
  signal state, nstate : states;


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


  prc_sm_async : process (lld_i, wren_i, send_i, data_i,
                          fifo_sof, fifo_eof, fifo_data, opcode_i, ocseq_i, size_i,
                          state)
  begin
    -- defaults
    nstate      <= Idle;
    busy_o      <= '1';
    lls_o.src_rdy <= '1';
    lls_o.sof     <= '0';
    lls_o.eof     <= '0';
    lls_o.data    <= fifo_data;
    fifo_rd     <= '0';


    case state is


      when Idle =>
        nstate      <= Idle;
        busy_o      <= '0';
        lls_o.src_rdy <= '0';
        if (send_i = '1') then
          busy_o    <= '1';
          nstate    <= FIFOSOF;
        end if;


      when FIFOSOF =>
        nstate      <= FIFOSOF;
        lls_o.src_rdy <= '0';
        fifo_rd   <= '1';
        if (fifo_sof = '1') then
          lls_o.src_rdy <= '1';
          fifo_rd   <= '0';
          if (lld_i = '1') then
            nstate  <= SrcRdy;
          end if;
        end if;


      when SrcRdy =>
        nstate    <= OpcodeSOF;


      when OpcodeSOF =>
        nstate   <= OpcodeSOF;
        lls_o.sof  <= '1';
        lls_o.data <= opcode_i;
        if (lld_i = '1') then
          nstate <= OCSeq;
        end if;


      when OCSeq =>
        nstate   <= OCSeq;
        lls_o.data <= ocseq_i;
        if (lld_i = '1') then
          nstate <= Size;
        end if;


      when Size =>
        nstate    <= Size;
        lls_o.data  <= size_i;
        if (lld_i = '1') then
          --fifo_rd <= '1';               -- need to get first word ready
          nstate  <= PayloadEOF;
        end if;


      when PayloadEOF =>
        nstate      <= PayloadEOF;
        lls_o.data    <= fifo_data;
        if (fifo_eof = '1') then
          lls_o.eof   <= '1';
        end if;
        if (lld_i = '1') then
          if (fifo_eof = '1') then
            nstate  <= Done;
          else
            fifo_rd <= '1';
          end if;
        end if;


      when Done =>
        nstate      <= Done;
        busy_o      <= '0';
        lls_o.src_rdy <= '0';
        if (send_i = '0') then
          nstate    <= Idle;
        end if;


    end case;
  end process;


-------------------------------------------------------



  fifo0 : cg_brfifo_1kx18
    port map (
      clk        => clk,
      srst       => rst,
      din        => fifo_din,
      wr_en      => wren_i,
      rd_en      => fifo_rd,
      dout       => fifo_dout,
      full       => open,
      overflow   => open,
      empty      => open,
      underflow  => open,
      data_count => open,
      prog_full  => open
      );


  fifo_din(15 downto 0) <= data_i;
  fifo_din(16)          <= eof_i;
  fifo_din(17)          <= sof_i;

  fifo_sof  <= fifo_dout(17);
  fifo_eof  <= fifo_dout(16);
  fifo_data <= fifo_dout(15 downto 0);



-----------------------------------------------------------------------------------
end architecture;

