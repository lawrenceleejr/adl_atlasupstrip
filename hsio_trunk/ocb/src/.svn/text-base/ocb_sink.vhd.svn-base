--
-- Opcode Block SINK
-- 
-- used to capture data to a RAM.
--
-- 
-- Matt Warren 2013
--
-- change log
-- 2013-10-24 birthday!
-- 2014-07-10 Starts walking ...
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


entity ocb_sink is
  port(
    -- oc rx interface
    oc_valid_i : in  std_logic;
    oc_data_i  : in  slv16;
    oc_dack_no : out std_logic;
    -- locallink tx interface
    lls_o      : out t_llsrc;
    lld_i      : in  std_logic;
    -- payload functions
    sigs_i     : in  std_logic_vector (15 downto 0);
    sink_go_i  : in  std_logic;
    --reg_sk_ctl_i : in  std_logic_vector (15 downto 0);
    --sk_stat_o    : out std_logic_vector (7 downto 0);
    --sk_addr_o    : out std_logic_vector (15 downto 0);

    -- infrastructure
    s40            : in  std_logic;
    clk            : in  std_logic;
    rst            : in  std_logic
    );

-- Declarations

end ocb_sink;

architecture rtl of ocb_sink is

  component cg_bram_8kx16
    port (
      clka  : in  std_logic;
      wea   : in  std_logic_vector(0 downto 0);
      addra : in  std_logic_vector(12 downto 0);
      dina  : in  std_logic_vector(15 downto 0);
      douta : out std_logic_vector(15 downto 0)
      );
  end component;


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


  signal ack_busy : std_logic;
  signal ack_send : std_logic;

  constant RAM_AD_WIDTH : integer := 13;

  signal sram_dout : slv16;
  signal sram_din  : slv16;
  signal sram_we   : std_logic;
  signal sram_we00 : std_logic_vector(0 downto 0);
  signal sram_ad   : std_logic_vector(RAM_AD_WIDTH-1 downto 0);

  constant I_WCOUNT_MAX        : integer := (2**RAM_AD_WIDTH-1);
  constant I_WCOUNT_MAX_MINUS1 : integer := (I_WCOUNT_MAX-1);

  constant WCOUNT_MAX        : std_logic_vector(RAM_AD_WIDTH-1 downto 0) :=
    conv_std_logic_vector(I_WCOUNT_MAX, RAM_AD_WIDTH);
  
  constant WCOUNT_MAX_MINUS1 : std_logic_vector(RAM_AD_WIDTH-1 downto 0) :=
    conv_std_logic_vector(I_WCOUNT_MAX_MINUS1, RAM_AD_WIDTH);
  

  signal wcount      : std_logic_vector(RAM_AD_WIDTH-1 downto 0);
  signal wcount_en   : std_logic;
  signal wcount_clr  : std_logic;
  signal wcount_load : std_logic;

  signal tx_opcode  : slv16;
  signal tx_payload : slv16;

  signal sk_running : std_logic;
  signal sk_ready   : std_logic;

  signal ocseq    : std_logic_vector(15 downto 0);
  signal seq_inc    : std_logic;


  --signal end_addr  : std_logic_vector(12 downto 0);
  --signal cyclic_en : std_logic;

  type states is (
    SinkStart, SinkRun, SinkDone,
    SendHeader, SendPayload, SendDone,
    Done, Idle
    );

  signal state, nstate : states;

begin

  --sk_stat_o <= "000000" & sk_running & sk_ready;
  --sk_addr_o <= conv_std_logic_vector(wcount, 16);

  --end_addr  <= reg_sk_ctl_i(12 downto 0);
  --cyclic_en <= reg_sk_ctl_i(B_SK_CYCLIC_EN);



  -- State Machine
  --------------------------------------------------------
  prc_sync_part : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        state <= Idle;

      else
        state <= nstate;

      end if;
    end if;
  end process;


  prc_async_machine : process (sink_go_i, wcount, s40, ack_busy,
                               state )
  begin

    -- defaults
    nstate     <= Idle;
    sram_we    <= '0';
    wcount_clr <= '0';
    wcount_en  <= '0';
    sk_running <= '1';
    sk_ready   <= '0';
    seq_inc    <= '0';

    case state is

      -------------------------------------------------------------


      when Idle =>
        nstate     <= Idle;
        sk_running <= '0';
        oc_dack_no <= 'Z';
        if (sink_go_i = '1') then
          nstate   <= SinkStart;
        end if;



        ------------------------------------------------------------------
        -- Fill RAM 
        ------------------------------------------------------------------

      when SinkStart =>                 -- align with BCO          
        nstate       <= SinkStart;
        wcount_clr   <= '1';
        if (s40 = '0') then
          nstate     <= SinkRun;
        end if;


      when SinkRun =>
        nstate    <= SinkRun;
        sram_we    <= '1';
        wcount_en <= '1';
        if (wcount = WCOUNT_MAX_MINUS1) then
          nstate  <= SinkDone;
        end if;

      when SinkDone =>
        wcount_clr <= '1';
        nstate     <= SendHeader;


      ----------------------------------------------------------------
      ----------------------------------------------------------------

      when SendHeader =>
        nstate   <= SendHeader;
        ack_send <= '1';
        if (ack_busy = '0') then        -- if ack_send=1, ack_busy signals start of data transfer (this is advanced mode)
          nstate <= SendPayload;
        end if;


      when SendPayload =>
        nstate    <= SendPayload;
        ack_send  <= '1';
        wcount_en <= '1';

        if (wcount(10 downto 0) = ("11" & x"ffe")) then
          nstate <= SendDone;
        end if;


      when SendDone =>
        nstate     <= SendDone;
        if (ack_busy = '0') then
          seq_inc  <= '1';
          if (wcount(13 downto 11) = "111") then
            nstate <= Done;
          else
            nstate <= SendHeader;
          end if;
        end if;


      --=========================================================================
      when Done =>
        nstate <= Idle;


    end case;
  end process;





-----------------------------------------------------------
-- Ack Interface

  prc_seq_gen : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        ocseq <= x"0000";

      else
        if (seq_inc = '1') then
          ocseq <= ocseq + '1';
        end if;

      end if;
    end if;
  end process;



  ocbstatrd_ack : ll_ack_gen
    port map (
      opcode_i  => OC_SINK_DATA,
      ocseq_i   => ocseq,
      ocsize_i  => x"0400",
      payload_i => sram_dout,
      send_i    => ack_send,
      busy_o    => ack_busy,
      lls_o     => lls_o,
      lld_i     => lld_i,
      clk       => clk,
      rst       => rst
      );



--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==  --==
--------------------------------------------------------------------
  prc_counts : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        wcount <= (others => '0');

      else
        if (wcount_clr = '1') then
          wcount <= (others => '0');

        elsif (wcount_en = '1') and (wcount < WCOUNT_MAX) then
          wcount <= wcount + '1';

        end if;

      end if;
    end if;

  end process;


  sram_ad   <= wcount;
  sram_we00 <= "1" when sram_we = '1' else "0";
  sram_din  <= sigs_i;

  inst_sram : cg_bram_8kx16
    port map (
      clka  => clk,
      wea   => sram_we00,
      addra => sram_ad,
      dina  => sram_din,
      douta => sram_dout
      );


-------------------------------------------------------------------------------------------------
end architecture;


