--
-- Readout Unit FIFO
--
-- Meant to provide a cut down version of a locallink stylee fifo
-- essentially a normal fifo with start-of-frame and end-of-frame
-- BUT only makes data available to client (asserts src_rdy) when
-- an eof has been received
--
--
--
-- 17/02/2012 - changed to block-ram fifo - for depth reporting
-- 09/05/2012 - removed fall-through from len_fifo and use SM to control read (was sof)
--            - added some more rst processes to FREE up LUTs(!!)
--            - changed len_fifo writes to be directly controlled from deser
-- 22/05/2012 - removed all to do with truncation
-- 31/07/2012 - changed to use llo type, at last.
-- 1/08/2012 - changed to use lls+lld type, inouts make tristate hell



library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library utils;
use utils.pkg_types.all;

entity ro_unit_fifo is
   port( 
      -- input interface
      wren_i                : in     std_logic;
      data_i                : in     std_logic_vector (15 downto 0);
      sof_i                 : in     std_logic;
      eof_i                 : in     std_logic;
      data_truncd_i         : in     std_logic;
      data_len_i            : in     std_logic_vector (10 downto 0);
      data_len_wr_i         : in     std_logic;
      -- locallink tx interface
      lls_o                 : out    t_llsrc;
      lld_i                 : in     std_logic;
      -- fifo status
      full_o                : out    std_logic;
      near_full_o           : out    std_logic;
      overflow_o            : out    std_logic;
      underflow_o           : out    std_logic;
      data_count_o          : out    std_logic_vector (1 downto 0);
      len_fifo_full_o       : out    std_logic;
      len_fifo_near_full_o  : out    std_logic;
      len_fifo_data_count_o : out    std_logic_vector (1 downto 0);
      -- infrastructure
      en                    : in     std_logic;
      clk                   : in     std_logic;
      rst                   : in     std_logic
   );

-- Declarations

end ro_unit_fifo ;


architecture rtl of ro_unit_fifo is


  component cg_ipfifo_1kx18
    port (
      clk       : in  std_logic;
      rst       : in  std_logic;
      din       : in  std_logic_vector(17 downto 0);
      wr_en     : in  std_logic;
      rd_en     : in  std_logic;
      dout      : out std_logic_vector(17 downto 0);
      full      : out std_logic;
      overflow  : out std_logic;
      empty     : out std_logic;
      underflow : out std_logic;
      prog_full : out std_logic
      );
  end component;

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

  component cg_dfifo_32x12
    port (
      clk         : in  std_logic;
      srst        : in  std_logic;
      din         : in  std_logic_vector(11 downto 0);
      wr_en       : in  std_logic;
      rd_en       : in  std_logic;
      dout        : out std_logic_vector(11 downto 0);
      full        : out std_logic;
      almost_full : out std_logic;
      empty       : out std_logic;
      data_count  : out std_logic_vector(1 downto 0)
      );
  end component;

  component cg_dfifo_16x12
    port (
      clk         : in  std_logic;
      srst        : in  std_logic;
      din         : in  std_logic_vector (11 downto 0);
      wr_en       : in  std_logic;
      rd_en       : in  std_logic;
      dout        : out std_logic_vector (11 downto 0);
      full        : out std_logic;
      almost_full : out std_logic;
      empty       : out std_logic;
      data_count  : out std_logic_vector(1 downto 0)
      );
  end component;


  signal fifo_empty  : std_logic;
  signal fifo_din    : std_logic_vector(17 downto 0);
  signal fifo_dout   : std_logic_vector(17 downto 0);
  signal fifo_rd     : std_logic;
  signal fifo_pre_rd : std_logic;
  signal fifo_wr     : std_logic;

  signal fifo_sof   : std_logic;
  signal fifo_sof_q : std_logic := '0';
  signal fifo_eof   : std_logic;


  constant EOFIN_DELAY : integer := 2;  -- *** was 7 (just a big number for now
                                        -- now smaller for better utilisation

  signal eofin   : std_logic;
  signal eofin_q : std_logic_vector(EOFIN_DELAY downto 0) := (others => '0');

  signal eof_coded     : std_logic_vector(1 downto 0);
  signal delta_eof     : integer range 0 to 31;
  signal dec_delta_eof : std_logic;



  type states is (
    FlufferSOF,
                  WaitStateSOF,
                  OpcodeSOF,
                  SeqID,
                  Len,
                  WaitEOF,
                  DecDeltaEOF,
                  Delay,
                  Idle
                  );

  signal state, nstate : states;

  signal len_fifo_din         : std_logic_vector(11 downto 0);
  signal len_fifo_rd          : std_logic;
  signal len_fifo_wr          : std_logic;
  signal len_fifo_dout        : std_logic_vector(11 downto 0);
  signal len_fifo_data        : std_logic_vector(10 downto 0);
--  signal len_fifo_data_truncd : std_logic;

  signal insert_length       : std_logic;
--  signal insert_error_opcode : std_logic;


begin


--------------------------------------------------
-- EOF manager - sync to 40/80 and count in vs. out
--------------------------------------------------


-- by pipelining the write section we ensure there
-- is enough time for the len fifo to propagate data

  eofin <= (eof_i and wren_i);

  prc_eofin_q : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        eofin_q <= (others => '0');
      else
        eofin_q <= eofin_q(EOFIN_DELAY-1 downto 0) & eofin;
      end if;
    end if;
  end process;


  eof_coded <= (eofin_q(EOFIN_DELAY) & dec_delta_eof);

  prc_count_delta_eof : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        delta_eof <= 0;

      else
        case eof_coded is
          when "00"   => null;
          when "01"   => delta_eof <= delta_eof - 1;
          when "10"   => delta_eof <= delta_eof + 1;
          when "11"   => null;
          when others => null;

        end case;
      end if;
    end if;
  end process;

  --delta_eof_o   <= conv_std_logic_vector(delta_eof, 8);

------------------------------------------------------------------
-- fifo in, locallink out
------------------------------------------------------------------

  -- datasheet says don't toggle wr during rst
  fifo_wr <= wren_i;                    -- and not(rst); *** this simply shouldn't happen ;-)



  fifo0 : cg_brfifo_1kx18
    port map (
      clk        => clk,
      srst       => rst,
      din        => fifo_din,
      wr_en      => fifo_wr,
      rd_en      => fifo_rd,
      dout       => fifo_dout,
      full       => full_o,
      overflow   => overflow_o,
      empty      => fifo_empty,
      underflow  => underflow_o,
      data_count => data_count_o,
      prog_full  => near_full_o
      );


  fifo_din(15 downto 0) <= data_i;
  fifo_din(16)          <= eof_i;
  fifo_din(17)          <= sof_i;

  lls_o.data <= --x"E" & fifo_dout(11 downto 0) when (insert_error_opcode = '1') else
            ("00000" & len_fifo_data)     when (insert_length = '1')       else
            fifo_dout(15 downto 0);

  fifo_eof <= fifo_dout(16);
  fifo_sof <= fifo_dout(17);


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


  prc_sm_async : process (state, delta_eof, fifo_sof, lld_i, fifo_eof, en)--, len_fifo_data_truncd)
  begin

    -- defaults
    nstate              <= Idle;
    lls_o.src_rdy           <= '0';
    lls_o.sof               <= '0';
    lls_o.eof               <= '0';
    fifo_rd             <= '0';
    insert_length       <= '0';
    dec_delta_eof       <= '0';
--    insert_error_opcode <= '0';
    len_fifo_rd         <= '0';

    case state is

      when Idle =>
        nstate   <= Idle;
        if (delta_eof > 0) and (en = '1') then
          nstate <= FlufferSOF;
        end if;


      when FlufferSOF =>
        nstate      <= FlufferSOF;
        fifo_rd     <= '1';
        if (fifo_sof = '1') then
          fifo_rd   <= '0';
          lls_o.src_rdy <= '1';
          if (lld_i = '1') then
            nstate  <= WaitStateSOF;
          end if;
        end if;


      when WaitStateSOF =>
        lls_o.src_rdy   <= '1';
        len_fifo_rd <= '1';
        nstate      <= OpcodeSOF;


      when OpcodeSOF =>
        nstate                  <= OpcodeSOF;
        lls_o.src_rdy               <= '1';
        lls_o.sof                   <= '1';
        if (lld_i = '1') then
          fifo_rd               <= '1';
--          if (len_fifo_data_truncd = '1') then
--            insert_error_opcode <= '1';
--          end if;
          nstate                <= SeqID;
        end if;


      when SeqID =>
        nstate    <= SeqID;
        lls_o.src_rdy <= '1';
        if (lld_i = '1') then
          fifo_rd <= '1';
          nstate  <= Len;
        end if;


      when Len =>
        nstate        <= Len;
        lls_o.src_rdy     <= '1';
        insert_length <= '1';
        if (lld_i = '1') then
          fifo_rd     <= '1';
          nstate      <= WaitEOF;
        end if;


      when WaitEOF =>
        nstate      <= WaitEOF;
        lls_o.src_rdy   <= '1';
        lls_o.eof       <= fifo_eof;
        if (lld_i = '1') then
          fifo_rd   <= '1';
          if (fifo_eof = '1') then
            fifo_rd <= '0';
            nstate  <= DecDeltaEOF;     -- no more reads needed now
          end if;
        end if;


      when DecDeltaEOF =>
        dec_delta_eof <= '1';
        nstate        <= Delay;


      when Delay =>                     -- need to wait for the delta_eof to update
        nstate <= Idle;


    end case;
  end process;



------------------------------------------------------------
-- store lengths in parallel with data
-------------------------------------------------------------

  len_fifo_wr  <= data_len_wr_i;
  --len_fifo_din <= data_truncd_i & data_len_i;
  len_fifo_din <= '0' & data_len_i;


  inst_len_fifo : cg_dfifo_16x12
    port map (
      clk         => clk,
      srst        => rst,
      din         => len_fifo_din,
      wr_en       => len_fifo_wr,
      rd_en       => len_fifo_rd,
      dout        => len_fifo_dout,
      full        => len_fifo_full_o,
      empty       => open,
      data_count  => len_fifo_data_count_o,
      almost_full => len_fifo_near_full_o
      );


  --len_fifo_data_truncd <= len_fifo_dout(11);
  len_fifo_data        <= len_fifo_dout(10 downto 0);

end architecture;
