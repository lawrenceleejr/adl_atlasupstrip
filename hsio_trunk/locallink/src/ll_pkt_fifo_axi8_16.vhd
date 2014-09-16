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

entity ll_pkt_fifo_axi8_16 is
  port(
    -- input interface (AXI-S 8b)
    axis_tdata_i  : in  std_logic_vector(7 downto 0);
    axis_tvalid_i : in  std_logic;
    axis_tlast_i  : in  std_logic;
    axis_tready_o : out std_logic;

    -- output interface (LL 16b)
    data_o    : out std_logic_vector (15 downto 0);
    sof_o     : out std_logic;
    eof_o     : out std_logic;
    dst_rdy_i : in  std_logic;
    src_rdy_o : out std_logic;

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

end ll_pkt_fifo_axi8_16;


architecture rtl of ll_pkt_fifo_axi8_16 is




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

  signal tdata16      : std_logic_vector(15 downto 0);
  signal tdata16hi_we : std_logic;
  signal tlast        : std_logic;


  signal fifo_we          : std_logic;
  signal fifo_din         : std_logic_vector(17 downto 0);
  signal fifo_dout        : std_logic_vector(17 downto 0);
  signal fifo_rd          : std_logic;
  signal fifo_empty       : std_logic;
  signal fifo_full        : std_logic;
  signal fifo_almost_full : std_logic;
  signal fifo_data_count  : std_logic_vector(3 downto 0);


  -- signal fifo_pre_rd : std_logic;

  signal fifo_sof   : std_logic;
  signal fifo_sof_q : std_logic := '0';
  signal fifo_eof   : std_logic;


  signal dst_rdy_out : std_logic;


  signal eofin : std_logic;

  signal eof_coded     : std_logic_vector(1 downto 0);
  signal delta_eof     : integer range 0 to 255;
  signal dec_delta_eof : std_logic;



  type wstates is (wLowByte, wHighByte, wLastLowByte,
                   wIdle
                   );

  signal wstate, nwstate : wstates;

  type states is (SrcRdySOF, WaitEOF,
                  DecDeltaEOF, Delay,
                  Idle
                  );

  signal state, nstate : states;


begin


  -- eof manager - only allow whole packets
  -------------------------------------------------------------------

  eofin     <= (axis_tvalid_i and axis_tlast_i);
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


  prc_sm_wr_async : process (wstate, axis_tvalid_i, axis_tlast_i)
  begin

    -- defaults
    axis_tready_o        <= '1';
    tdata16hi_we         <= '0';
    tdata16(7 downto 0) <= axis_tdata_i;
    tlast                <= '0';
    fifo_we              <= '0';

    case wstate is

      when wIdle =>
        nwstate       <= wIdle;
        axis_tready_o <= '0';
        if (axis_tvalid_i = '1') then
          nwstate     <= wHighByte;
        end if;


      when wHighByte =>
        tdata16hi_we <= '1';
        if (axis_tvalid_i = '1') then
          if (axis_tlast_i = '1') then
            nwstate  <= wLastLowByte;
          else
            nwstate  <= wLowByte;
          end if;
        end if;


      when wLowByte =>
        nwstate   <= wLowByte;
        if (axis_tvalid_i = '1') then
          nwstate <= wHighByte;
          fifo_we <= '1';
          if (axis_tlast_i = '1') then
            tlast <= '1';
            nwstate <= wIdle;            
          end if;

        end if;


      when wLastLowByte =>
        tdata16(7 downto 0) <= x"00";
        tlast                <= '1';
        fifo_we              <= '1';
        nwstate              <= wIdle;


    end case;
  end process;


  prc_tdatalo : process (clk)
  begin
    if rising_edge(clk) then
      if (tdata16hi_we = '1') then
        tdata16(15 downto 8) <= axis_tdata_i;
      end if;
    end if;
  end process;



  fifo_din(15 downto 0) <= tdata16;
  fifo_din(16)          <= tlast;       --eof
  fifo_din(17)          <= '0';         --sof


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


  data_o   <= fifo_dout(15 downto 0);
  fifo_eof <= fifo_dout(16);
  --fifo_sof <= fifo_dout(17);


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


  prc_sm_async : process (state, delta_eof, fifo_sof, dst_rdy_i, fifo_eof )
  begin

-- defaults
    nstate        <= Idle;
    src_rdy_o     <= '0';
    sof_o         <= '0';
    eof_o         <= '0';
    fifo_rd       <= '0';
    dec_delta_eof <= '0';

    case state is

      when Idle =>
        nstate <= Idle;

        if (delta_eof /= 0) and (dst_rdy_i = '1') then
          nstate <= SrcRdySOF;
        end if;


      when SrcRdySOF =>
        nstate    <= SrcRdySOF;
        src_rdy_o <= '1';
        sof_o     <= '1';
        if (dst_rdy_i = '1') then
          fifo_rd <= '1';
          nstate  <= WaitEOF;
        end if;

      when WaitEOF =>
        nstate     <= WaitEOF;
        src_rdy_o  <= '1';
        eof_o      <= fifo_eof;
        if (dst_rdy_i = '1') then
          fifo_rd  <= '1';
          if (fifo_eof = '1') then
            nstate <= DecDeltaEOF;      -- no more reads needed now
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
