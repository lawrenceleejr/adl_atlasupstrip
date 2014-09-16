--
-- LL Packet FIFO
--
-- Simple 2kB FIFO that can buffer a whole packet LL stylee
-- * Does not push use dst_rdy to stop incoming data * 
-- 
-- 

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ll_pkt_fifo_16_axi8 is
  port(
    -- output interface (LL 16b)
    data_i    : in  std_logic_vector (15 downto 0);
    sof_i     : in  std_logic;
    eof_i     : in  std_logic;
    dst_rdy_o : out std_logic;
    src_rdy_i : in  std_logic;

    -- output interface (AXI-S 8b)
    axis_tdata_o  : out std_logic_vector(7 downto 0);
    axis_tvalid_o : out std_logic;
    axis_tlast_o  : out std_logic;
    axis_tready_i : in  std_logic;

    -- fifo status
    --full_o          : out std_logic;
    --near_full_o     : out std_logic;
    --overflow_o      : out std_logic;
    --underflow_o     : out std_logic;
    --wr_data_count_o : out std_logic_vector (3 downto 0) := "0000";
    clk : in std_logic;
    rst : in std_logic
    );

-- Declarations

end ll_pkt_fifo_16_axi8;


architecture rtl of ll_pkt_fifo_16_axi8 is

  component cg_brfifo_1kx18_ft
    port (
      clk         : in  std_logic;
      srst        : in  std_logic;
      din         : in  std_logic_vector(17 downto 0);
      wr_en       : in  std_logic;
      rd_en       : in  std_logic;
      dout        : out std_logic_vector(17 downto 0);
      full        : out std_logic;
      almost_full : out std_logic;
      empty       : out std_logic;
      data_count  : out std_logic_vector(3 downto 0)
      );
  end component;

  signal fifo_we          : std_logic;
  signal fifo_din         : std_logic_vector(17 downto 0);
  signal fifo_dout        : std_logic_vector(17 downto 0);
  signal fifo_rd          : std_logic;
  signal fifo_empty       : std_logic;
  signal fifo_full        : std_logic;
  signal fifo_almost_full : std_logic;
  signal fifo_data_count  : std_logic_vector(3 downto 0);

  signal fifo_dout_eof    : std_logic;
  
  signal src_fifo_rdy : std_logic;


  signal eofin : std_logic;

  signal eof_coded     : std_logic_vector(1 downto 0);
  signal delta_eof     : integer range 0 to 255;
  signal dec_delta_eof : std_logic;



  type wstates is (wWaitEOF,
                   wIdle
                   );

  signal wstate, nwstate : wstates;

  type states is (LowByte, HighByte,
                  DecDeltaEOF, Delay,
                  Idle
                  );

  signal state, nstate : states;


begin


  -- eof manager - only allow whole packets
  -------------------------------------------------------------------

  eofin     <= (src_rdy_i and eof_i);
  eof_coded <= (eofin & dec_delta_eof);

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


------------------------------------------------------------------


  prc_sm_wr_sync : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        wstate <= wIdle;
      else
        wstate <= nwstate;

      end if;
    end if;
  end process;

  src_fifo_rdy <= src_rdy_i and not(fifo_almost_full);
  dst_rdy_o <= not(fifo_almost_full) and not(rst);
  

  prc_sm_wr_async : process (wstate, src_fifo_rdy, sof_i, eof_i)
  begin

    -- defaults
    fifo_we <= '0';

    case wstate is

      when wIdle =>
        nwstate     <= wIdle;
        if (src_fifo_rdy = '1') then
          if (sof_i = '1') then
            fifo_we <= '1';
            nwstate <= wWaitEOF;
          end if;
        end if;


      when wWaitEOF =>
        nwstate     <= wWaitEOF;
        if (src_fifo_rdy = '1') then
          fifo_we   <= '1';
          if (eof_i = '1') then
            nwstate <= wIdle;
          end if;
        end if;


    end case;
  end process;


  fifo_din(15 downto 0) <= data_i;
  fifo_din(16)          <= eof_i;
  fifo_din(17)          <= sof_i;


  fifo0 : cg_brfifo_1kx18_ft
    port map (
      clk         => clk,
      srst        => rst,
      din         => fifo_din,
      wr_en       => fifo_we,
      rd_en       => fifo_rd,
      dout        => fifo_dout,
      full        => fifo_full,
      almost_full => fifo_almost_full,
      empty       => fifo_empty,
      data_count  => fifo_data_count
      );


  fifo_dout_eof   <= fifo_dout(16);
  -- <= fifo_dout(17);                  --unused, was sof


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


  prc_sm_async : process (state, delta_eof, axis_tready_i, fifo_dout_eof, fifo_dout )
  begin

-- defaults
    nstate        <= Idle;
    axis_tdata_o  <= fifo_dout(7 downto 0);
    axis_tlast_o  <= '0';
    axis_tvalid_o <= '0';
    fifo_rd       <= '0';
    dec_delta_eof <= '0';

    case state is

      when Idle =>
        nstate        <= Idle;
        if (delta_eof > 0) then
          nstate      <= HighByte;
        end if;


      when HighByte =>
        nstate       <= HighByte;
        axis_tvalid_o <= '1';
        axis_tdata_o <= fifo_dout(15 downto 8);
        if (axis_tready_i = '1') then
          nstate   <= LowByte;
        end if;

      when LowByte =>
        nstate   <= LowByte;
        axis_tvalid_o <= '1';
        axis_tdata_o <= fifo_dout(7 downto 0);
        axis_tlast_o <= fifo_dout_eof;
        
        if (axis_tready_i = '1') then
          nstate <= HighByte;
          fifo_rd    <= '1';
          if (fifo_dout_eof = '1') then
            nstate   <= DecDeltaEOF;
          end if;
        end if;


      when DecDeltaEOF =>
        dec_delta_eof <= '1';
        nstate        <= Delay;


      when Delay =>                     -- need to wait for the delta_eof to update
        nstate <= Idle;


    end case;

  end process;

end architecture;
