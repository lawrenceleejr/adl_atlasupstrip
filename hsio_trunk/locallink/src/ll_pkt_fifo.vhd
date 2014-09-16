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

entity ll_pkt_fifo is
  port(
    -- input interface
    src_rdy_i       : in  std_logic;
    dst_rdy_o       : out std_logic;
    data_i          : in  std_logic_vector (15 downto 0);
    sof_i           : in  std_logic;
    eof_i           : in  std_logic;
    -- output interface
    data_o          : out std_logic_vector (15 downto 0);
    sof_o           : out std_logic;
    eof_o           : out std_logic;
    dst_rdy_i       : in  std_logic;
    src_rdy_o       : out std_logic;
    -- fifo status
    full_o          : out std_logic;
    near_full_o     : out std_logic;
    overflow_o      : out std_logic;
    underflow_o     : out std_logic;
    wr_data_count_o : out std_logic_vector (3 downto 0) := "0000";
    clk             : in  std_logic;
    rst             : in  std_logic
    );

-- Declarations

end ll_pkt_fifo;


architecture rtl of ll_pkt_fifo is


  component cg_brfifo_1kx18
    port (
      rst           : in  std_logic;
      wr_clk        : in  std_logic;
      rd_clk        : in  std_logic;
      din           : in  std_logic_vector(17 downto 0);
      wr_en         : in  std_logic;
      rd_en         : in  std_logic;
      dout          : out std_logic_vector(17 downto 0);
      full          : out std_logic;
      almost_full   : out std_logic;
      overflow      : out std_logic;
      empty         : out std_logic;
      underflow     : out std_logic;
      wr_data_count : out std_logic_vector(3 downto 0);
      prog_full     : out std_logic);
  end component;

  component cg_ipfifo_1kx18
    port (
      rst       : in  std_logic;
      clk       : in  std_logic;
      din       : in  std_logic_vector(17 downto 0);
      wr_en     : in  std_logic;
      rd_en     : in  std_logic;
      dout      : out std_logic_vector(17 downto 0);
      full      : out std_logic;
      --almost_full   : out std_logic;
      overflow  : out std_logic;
      empty     : out std_logic;
      underflow : out std_logic;
      --wr_data_count : out std_logic_vector(3 downto 0);
      prog_full : out std_logic
      );
  end component;



  signal fifo_empty     : std_logic;
  signal fifo_near_full : std_logic;
  signal fifo_din       : std_logic_vector(17 downto 0);
  signal fifo_dout      : std_logic_vector(17 downto 0);
  signal fifo_rd        : std_logic;
  signal fifo_pre_rd    : std_logic;
  signal fifo_wr        : std_logic;

  signal fifo_sof   : std_logic;
  signal fifo_sof_q : std_logic := '0';
  signal fifo_eof   : std_logic;


  signal dst_rdy_out : std_logic;


  signal eofin : std_logic;

  signal eof_coded     : std_logic_vector(1 downto 0);
  signal delta_eof     : integer range 0 to 255;
  signal dec_delta_eof : std_logic;



  type states is (FIFOSOF,
                  SrcRdy, SOF, WaitEOF,
                  DecDeltaEOF, Delay,
                  Idle
                  );

  signal state, nstate : states;


begin


  -- eof manager - only allow whole packets
  -------------------------------------------------------------------

  eofin <= (eof_i and src_rdy_i);

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


  fifo_wr <= src_rdy_i and dst_rdy_out;


  fifo0 : cg_ipfifo_1kx18
-- fifo0 : cg_brfifo_1kx18
    port map (
      rst       => rst,
      clk       => clk,
      din       => fifo_din,
      wr_en     => fifo_wr,
      rd_en     => fifo_rd,
      dout      => fifo_dout,
      full      => full_o,
      --almost_full   => open,
      overflow  => overflow_o,
      empty     => fifo_empty,
      underflow => underflow_o,
      --wr_data_count => wr_data_count_o,
      prog_full => fifo_near_full

      );

  fifo_din(15 downto 0) <= data_i;
  fifo_din(16)          <= eof_i;
  fifo_din(17)          <= sof_i;

  data_o   <= fifo_dout(15 downto 0);
  fifo_eof <= fifo_dout(16);
  fifo_sof <= fifo_dout(17);


  dst_rdy_out <= not (fifo_near_full or rst);  -- need rst to make sure fifo wren is
                                        -- deasserted at rst
  dst_rdy_o   <= dst_rdy_out;

  near_full_o <= fifo_near_full;


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

        if (delta_eof > 0) then
          nstate <= FIFOSOF;
        end if;


        
      when FIFOSOF =>
        nstate      <= FIFOSOF;
        if (fifo_sof = '1') then
          src_rdy_o <= '1';
          if (dst_rdy_i = '1') then
            nstate  <= SrcRdy;
          end if;
        else
          fifo_rd   <= '1';
        end if;


      when SrcRdy =>
        src_rdy_o <= '1';
        nstate    <= SOF;


      when SOF =>
        nstate    <= SOF;
        src_rdy_o <= '1';
        sof_o     <= '1';
        if (dst_rdy_i = '1') then
          fifo_rd <= '1';
          nstate  <= WaitEOF;
        end if;

      when WaitEOF =>
        nstate      <= WaitEOF;
        src_rdy_o   <= '1';
        eof_o       <= fifo_eof;
        if (dst_rdy_i = '1') then
          if (fifo_eof = '1') then
            nstate  <= DecDeltaEOF;     -- no more reads needed now
          else
            fifo_rd <= '1';
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
