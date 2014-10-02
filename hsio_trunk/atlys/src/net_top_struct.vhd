-- VHDL Entity atlys.net_top.symbol
--
-- Created by Matt Warren 2014
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2013.1 (Build 6)
--

library unisim;
use unisim.vcomponents.all;

library ieee;
use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;
library utils;
use utils.pkg_types.all;

--------------------------------------------------------------------------------
-- The entity declaration for the example_design level wrapper.
--------------------------------------------------------------------------------
entity net_top is
   port( 
      -- asynchronous reset
      glbl_rst          : in     std_logic;
      -- 200MHz clock input from board
      --***clk_in_p                      : in  std_logic;
      --***clk_in_n                      : in  std_logic;
      clk125_i          : in     std_logic;                       --***
      dcm_locked_i      : in     std_logic;                       --***
      phy_resetn        : out    std_logic;
      -- GMII Interface
      -----------------
      gmii_txd          : out    std_logic_vector (7 downto 0);
      gmii_tx_en        : out    std_logic;
      gmii_tx_er        : out    std_logic;
      gmii_tx_clk       : out    std_logic;
      gmii_rxd          : in     std_logic_vector (7 downto 0);
      gmii_rx_dv        : in     std_logic;
      gmii_rx_er        : in     std_logic;
      gmii_rx_clk       : in     std_logic;
      gmii_col          : in     std_logic;
      gmii_crs          : in     std_logic;
      -- Serialised statistics vectors
      --------------------------------
      tx_statistics_s   : out    std_logic;
      rx_statistics_s   : out    std_logic;
      -- Serialised Pause interface controls
      --------------------------------------
      pause_req_s       : in     std_logic;
      fifo_clk_locked_i : in     std_logic;
      fifo_clk_i        : in     std_logic;                       -- clock to be sync'ed to
      monitor_o         : out    std_logic_vector (3 downto 0);
      rx_lld_i          : in     std_logic;
      tx_lls_i          : in     t_llsrc;
      tx_lld_o          : out    std_logic;
      rx_lls_o          : out    t_llsrc;
      macaddress_i      : in     std_logic_vector (47 downto 0)
   );

-- Declarations

end net_top ;

-- VHDL from Block Diagram 
-- Generated by Mentor Graphics HDL Designer(TM) 2013.1 (Build 6) 
--
-- atlys.net_top.struct
--
-- Created by Matt Warren 2014
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library utils;
use utils.pkg_types.all;


architecture struct of net_top is

   -- Architecture declarations

   -- Internal signal declarations
   ------------------------------------------------------------------------------
-- Constants used in this top level wrapper.
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- internal signals used in this top level wrapper.
------------------------------------------------------------------------------

-- example design clocks
   signal s_axi_aclk               : std_logic;
   ------------------------------------------------------------------------------
-- Constants used in this top level wrapper.
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- internal signals used in this top level wrapper.
------------------------------------------------------------------------------

-- example design clocks
   signal gtx_clk_bufg             : std_logic;
   signal rx_mac_aclk              : std_logic;
   signal tx_mac_aclk              : std_logic;
   -- resets (and reset generation)
   signal vector_reset_int         : std_logic;
   signal vector_pre_resetn        : std_logic                    := '0';
   signal vector_resetn            : std_logic                    := '0';
   signal local_fifo_reset         : std_logic;
   signal fifo_clk_reset_int       : std_logic;
   signal rx_reset                 : std_logic;
   signal tx_reset                 : std_logic;
   signal dcm_locked               : std_logic;
   signal glbl_rst_int             : std_logic;
   signal glbl_rst_intn            : std_logic;
   signal rx_axis_fifo_tdata       : std_logic_vector(7 downto 0);
   signal rx_axis_fifo_tvalid      : std_logic;
   signal rx_axis_fifo_tlast       : std_logic;
   signal rx_axis_fifo_tready      : std_logic;
   signal tx_axis_fifo_tdata       : std_logic_vector(7 downto 0);
   signal tx_axis_fifo_tvalid      : std_logic;
   signal tx_axis_fifo_tlast       : std_logic;
   signal tx_axis_fifo_tready      : std_logic;
   -- RX Statistics serialisation signals
   signal rx_stats                 : std_logic_vector(27 downto 0);
   -- RX Statistics serialisation signals
   signal rx_statistics_valid      : std_logic;
   -- RX Statistics serialisation signals
   signal rx_statistics_valid_reg  : std_logic;
   signal rx_statistics_vector     : std_logic_vector(27 downto 0);
   signal rx_stats_toggle          : std_logic                    := '0';
   signal rx_stats_toggle_sync_reg : std_logic;
   signal rx_stats_toggle_sync     : std_logic;
   -- TX Statistics serialisation signals
   signal tx_statistics_valid_reg  : std_logic;
   -- TX Statistics serialisation signals
   signal tx_statistics_valid      : std_logic;
   signal tx_statistics_vector     : std_logic_vector(31 downto 0);
   signal pause_req                : std_logic;
   signal pause_val                : std_logic_vector(15 downto 0);
   signal rx_configuration_vector  : std_logic_vector(79 downto 0);
   signal tx_configuration_vector  : std_logic_vector(79 downto 0);
   -- signal tie offs
   signal tx_ifg_delay             : std_logic_vector(7 downto 0) := (others => '0');    -- not used in this example
   signal HI                       : std_logic;
   signal ZERO2                    : std_logic_vector(1 downto 0);
   signal HILO                     : std_logic_vector(1 downto 0);
   signal ZERO4                    : std_logic_vector(3 downto 0);
   signal ZERO8                    : std_logic_vector(7 downto 0);
   signal ZERO13                   : std_logic_vector(12 downto 0);
   signal ZERO16                   : std_logic_vector(15 downto 0);
   signal ZERO64                   : std_logic_vector(63 downto 0);
   signal LO                       : std_logic;
   signal fifo_reset               : std_logic;
   signal fifo_resetn              : std_logic;
   signal fifo_pre_resetn          : std_logic;
   signal pause_shift              : std_logic_vector(17 downto 0);
   signal phy_reset_count          : integer range 0 to 63;
   signal phy_resetn_int           : std_logic;
   signal tx_stats_shift           : std_logic_vector(33 downto 0);
   signal rx_stats_shift           : std_logic_vector(29 downto 0);
   signal net_data                 : std_logic_vector(15 downto 0);
   signal net_eof                  : std_logic;
   signal net_sof                  : std_logic;
   signal net_src_rdy              : std_logic;
   signal net_dst_rdy              : std_logic;
   signal rx_src_mac               : std_logic_vector(47 downto 0);
   signal tx_sof                   : std_logic;
   signal tx_eof                   : std_logic;
   signal tx_src_rdy               : std_logic;
   signal tx_data                  : std_logic_vector(15 downto 0);
   signal rx_data                  : std_logic_vector(15 downto 0);
   signal rx_dst_rdy               : std_logic;
   signal tx_dst_rdy               : std_logic;
   signal rx_src_rdy               : std_logic;
   signal rx_eof                   : std_logic;
   signal rx_sof                   : std_logic;
   signal txll_src_rdy_net         : std_logic;
   signal txll_eof_net             : std_logic;
   signal txll_sof_net             : std_logic;
   signal txll_dst_rdy_net         : std_logic;
   -- net client side (output) interface
   signal txll_data_net            : std_logic_vector(15 downto 0);


   -- Component Declarations
   component cg_eth_1gmac_gmii_axi_config_vector_sm
   port (
      gtx_clk                 : in     std_logic;
      gtx_resetn              : in     std_logic;
      mac_speed               : in     std_logic_vector (1 downto 0);
      update_speed            : in     std_logic;
      rx_configuration_vector : out    std_logic_vector (79 downto 0);
      tx_configuration_vector : out    std_logic_vector (79 downto 0)
   );
   end component;
   component cg_eth_1gmac_gmii_axi_fifo_block
   port (
      glbl_rstn               : in     std_logic;
      gmii_col                : in     std_logic;
      gmii_crs                : in     std_logic;
      gmii_rx_clk             : in     std_logic;
      gmii_rx_dv              : in     std_logic;
      gmii_rx_er              : in     std_logic;
      gmii_rxd                : in     std_logic_vector (7 downto 0);
      gtx_clk                 : in     std_logic;
      pause_req               : in     std_logic;
      pause_val               : in     std_logic_vector (15 downto 0);
      rx_axi_rstn             : in     std_logic;
      rx_axis_fifo_tready     : in     std_logic;
      rx_configuration_vector : in     std_logic_vector (79 downto 0);
      rx_fifo_clock           : in     std_logic;
      rx_fifo_resetn          : in     std_logic;
      tx_axi_rstn             : in     std_logic;
      tx_axis_fifo_tdata      : in     std_logic_vector (7 downto 0);
      tx_axis_fifo_tlast      : in     std_logic;
      tx_axis_fifo_tvalid     : in     std_logic;
      tx_configuration_vector : in     std_logic_vector (79 downto 0);
      tx_fifo_clock           : in     std_logic;
      tx_fifo_resetn          : in     std_logic;
      tx_ifg_delay            : in     std_logic_vector (7 downto 0);
      gmii_tx_clk             : out    std_logic;
      gmii_tx_en              : out    std_logic;
      gmii_tx_er              : out    std_logic;
      gmii_txd                : out    std_logic_vector (7 downto 0);
      rx_axis_fifo_tdata      : out    std_logic_vector (7 downto 0);
      rx_axis_fifo_tlast      : out    std_logic;
      rx_axis_fifo_tvalid     : out    std_logic;
      rx_mac_aclk             : out    std_logic;
      rx_reset                : out    std_logic;
      rx_statistics_valid     : out    std_logic;
      rx_statistics_vector    : out    std_logic_vector (27 downto 0);
      tx_axis_fifo_tready     : out    std_logic;
      tx_mac_aclk             : out    std_logic;
      tx_reset                : out    std_logic;
      tx_statistics_valid     : out    std_logic;
      tx_statistics_vector    : out    std_logic_vector (31 downto 0)
   );
   end component;
   component cg_eth_1gmac_gmii_axi_reset_sync
   generic (
      INITIALISE : bit_vector(1 downto 0) := "11"
   );
   port (
      clk       : in     std_logic;
      enable    : in     std_logic;
      reset_in  : in     std_logic;
      reset_out : out    std_logic
   );
   end component;
   component cg_eth_1gmac_gmii_axi_sync_block
   generic (
      INITIALISE : bit_vector(1 downto 0) := "00"
   );
   port (
      clk      : in     std_logic;
      data_in  : in     std_logic;
      data_out : out    std_logic
   );
   end component;
   component net_rx_pktfmt16
   generic (
      BYTESWAP : integer := 1
   );
   port (
      -- net side input interface
      net_data_i     : in     slv16 ;          -- Erdem slv8;
      net_sof_i      : in     std_logic ;
      net_eof_i      : in     std_logic ;
      net_dst_rdy_o  : out    std_logic ;
      net_src_rdy_i  : in     std_logic ;
      -- hsio side side (output) interface
      hsio_data_o    : out    slv16  := x"0000";
      hsio_sof_o     : out    std_logic ;
      hsio_eof_o     : out    std_logic ;
      hsio_dst_rdy_i : in     std_logic ;
      hsio_src_rdy_o : out    std_logic ;
      rx_src_mac_o   : out    slv48 ;
      clk            : in     std_logic ;
      rst            : in     std_logic 
   );
   end component;
   component net_tx_pktfmt16
   port (
      --alt_dest_type_en_i : in std_logic;
      --***    alt_dest_mac_en_i : in std_logic;
      --***    mac_alt_dest_i   : in  std_logic_vector (47 downto 0);
      
      -- input interface
      data_i       : in     std_logic_vector (15 downto 0);
      sof_i        : in     std_logic ;
      eof_i        : in     std_logic ;
      dst_rdy_o    : out    std_logic ;
      src_rdy_i    : in     std_logic ;
      --data_length_i : in  std_logic_vector (15 downto 0);  -- HSIO length field
      mac_dest_i   : in     std_logic_vector (47 downto 0);
      mac_source_i : in     std_logic_vector (47 downto 0);
      -- net client side (output) interface
      ll_data_o    : out    std_logic_vector (15 downto 0); --(7 downto 0);  -- Erdem
      ll_sof_o     : out    std_logic ;
      ll_eof_o     : out    std_logic ;
      ll_dst_rdy_i : in     std_logic ;
      ll_src_rdy_o : out    std_logic ;
      clk          : in     std_logic ;
      rst          : in     std_logic 
   );
   end component;
   component ll_pkt_fifo_16_axi8
   port (
      axis_tready_i : in     std_logic;
      clk           : in     std_logic;
      data_i        : in     std_logic_vector (15 downto 0);
      eof_i         : in     std_logic;
      rst           : in     std_logic;
      sof_i         : in     std_logic;
      src_rdy_i     : in     std_logic;
      axis_tdata_o  : out    std_logic_vector (7 downto 0);
      axis_tlast_o  : out    std_logic;
      axis_tvalid_o : out    std_logic;
      dst_rdy_o     : out    std_logic
   );
   end component;
   component ll_pkt_fifo_axi8_16
   port (
      axis_tdata_i  : in     std_logic_vector (7 downto 0);
      axis_tlast_i  : in     std_logic;
      axis_tvalid_i : in     std_logic;
      clk           : in     std_logic;
      dst_rdy_i     : in     std_logic;
      rst           : in     std_logic;
      axis_tready_o : out    std_logic;
      data_o        : out    std_logic_vector (15 downto 0);
      eof_o         : out    std_logic;
      sof_o         : out    std_logic;
      src_rdy_o     : out    std_logic
   );
   end component;
   component lls_break
   port (
      lls_i     : in     t_llsrc;
      data_o    : out    std_logic_vector (15 downto 0);
      eof_o     : out    std_logic;
      sof_o     : out    std_logic;
      src_rdy_o : out    std_logic
   );
   end component;
   component lls_make
   port (
      data_i    : in     std_logic_vector (15 downto 0);
      eof_i     : in     std_logic;
      sof_i     : in     std_logic;
      src_rdy_i : in     std_logic;
      lls       : out    t_llsrc
   );
   end component;


begin
   -- Architecture concurrent statements
   -- HDL Embedded Text Block 5 gen_vector_reset
   -- Create fully synchronous reset in the vector clock domain.
      gen_vector_reset : process (gtx_clk_bufg)
      begin
        if gtx_clk_bufg'event and gtx_clk_bufg = '1' then
          if vector_reset_int = '1' then
            vector_pre_resetn  <= '0';
            vector_resetn      <= '0';
          else
            vector_pre_resetn  <= '1';
            vector_resetn      <= vector_pre_resetn;
          end if;
        end if;
      end process gen_vector_reset;

   -- HDL Embedded Text Block 9 gen_fifo_reset
   -- Create fully synchronous reset in the fifo clock domain.
      gen_fifo_reset : process (fifo_clk_i)
      begin
        if fifo_clk_i'event and fifo_clk_i = '1' then
          if fifo_clk_reset_int = '1' then
            fifo_pre_resetn   <= '0';
            fifo_resetn       <= '0';
          else
            fifo_pre_resetn   <= '1';
            fifo_resetn       <= fifo_pre_resetn;
          end if;
        end if;
      end process gen_fifo_reset;
   
   fifo_reset <= not(fifo_resetn);

   -- HDL Embedded Text Block 10 gen_phy_reset
   -----------------
      -- PHY reset
      -- the phy reset output (active low) needs to be held for at least 10x25MHZ cycles
      -- this is derived using the 125MHz available and a 6 bit counter
      gen_phy_reset : process (gtx_clk_bufg)
      begin
        if gtx_clk_bufg'event and gtx_clk_bufg = '1' then
          if glbl_rst_intn = '0' then
            phy_resetn_int       <= '0';
            --phy_reset_count      <= (others => '0');
            phy_reset_count      <= 0;
          else
             --if phy_reset_count /= "111111" then
             if phy_reset_count /= 63 then
                --phy_reset_count <= phy_reset_count + "000001";
                phy_reset_count <= phy_reset_count + 1;
             else
                phy_resetn_int   <= '1';
             end if;
          end if;
        end if;
      end process gen_phy_reset;

   -- HDL Embedded Text Block 12 capture_rx_stats
   ------------------------------------------------------------------------------
     -- Serialize the stats vectors
     -- This is a single bit approach, retimed onto gtx_clk
     -- this code is only present to prevent code being stripped..
     ------------------------------------------------------------------------------
     -- RX STATS
     -- first capture the stats on the appropriate clock
      capture_rx_stats : process (fifo_clk_i)
      begin
         if fifo_clk_i'event and fifo_clk_i = '1' then
            rx_statistics_valid_reg <= rx_statistics_valid;
            if rx_statistics_valid_reg = '0' and rx_statistics_valid = '1' then
               rx_stats        <= rx_statistics_vector;
               rx_stats_toggle <= not rx_stats_toggle;
            end if;
         end if;
      end process capture_rx_stats;

   -- HDL Embedded Text Block 14 gen_shift_rx
   reg_rx_toggle : process (fifo_clk_i)
      begin
         if fifo_clk_i'event and fifo_clk_i = '1' then
            rx_stats_toggle_sync_reg <= rx_stats_toggle_sync;
         end if;
      end process reg_rx_toggle;
   
   -- when an update is rxd load shifter (plus start/stop bit)
    -- shifter always runs (no power concerns as this is an example design)
   gen_shift_rx : process (gtx_clk_bufg)
   begin
     if fifo_clk_i'event and fifo_clk_i = '1' then
       if (rx_stats_toggle_sync_reg xor rx_stats_toggle_sync) = '1' then
         rx_stats_shift <= '1' & rx_stats &  '1';
       else
         rx_stats_shift <= rx_stats_shift(28 downto 0) & '0';
       end if;
     end if;
   end process gen_shift_rx;
   
   rx_statistics_s <= rx_stats_shift(29);

   -- HDL Embedded Text Block 16 gen_shift_tx
   -- TX STATS
   -- when an update is txd load shifter (plus start/stop bit)
   -- shifter always runs (no power concerns as this is an example design)
   gen_shift_tx : process (fifo_clk_i)
   begin
     if fifo_clk_i'event and fifo_clk_i = '1' then
       tx_statistics_valid_reg <= tx_statistics_valid;
       if tx_statistics_valid_reg = '0' and tx_statistics_valid = '1' then
         tx_stats_shift <= '1' & tx_statistics_vector & '1';
       else
         tx_stats_shift <= tx_stats_shift(32 downto 0) & '0';
       end if;
     end if;
   end process gen_shift_tx;
   
   tx_statistics_s <= tx_stats_shift(33);

   -- HDL Embedded Text Block 18 gen_shift_pause
   ------------------------------------------------------------------------------
     -- DESerialize the Pause interface
     -- This is a single bit approachtimed on gtx_clk
     -- this code is only present to prevent code being stripped..
     ------------------------------------------------------------------------------
     -- the serialised pause info has a start bit followed by the quanta and a stop bit
     -- capture the quanta when the start bit hits the msb and the stop bit is in the lsb
      gen_shift_pause : process (gtx_clk_bufg)
      begin
         if gtx_clk_bufg'event and gtx_clk_bufg = '1' then
            pause_shift <= pause_shift(16 downto 0) & pause_req_s;
         end if;
      end process gen_shift_pause;

   -- HDL Embedded Text Block 19 grab_pause
   grab_pause : process (gtx_clk_bufg)
      begin
         if gtx_clk_bufg'event and gtx_clk_bufg = '1' then
            if (pause_shift(17) = '1' and pause_shift(0) = '1') then
               pause_req <= '1';
               pause_val <= pause_shift(16 downto 1);
            else
               pause_req <= '0';
               pause_val <= (others => '0');
            end if;
         end if;
      end process grab_pause;

   -- HDL Embedded Text Block 20 eb8
   -- eb3 3
   HI <= '1';
   LO <= '0';
   HILO <= "10";
   ZERO2 <=  "00";
   ZERO4 <=  "0000";
   ZERO8 <=  "00000000";
   ZERO13 <= "0000000000000";
   ZERO16 <= "0000000000000000";
   ZERO64 <= x"0000000000000000";


   -- ModuleWare code(v1.12) for instance 'U_2' of 'buff'
   phy_resetn <= phy_resetn_int;

   -- ModuleWare code(v1.12) for instance 'U_4' of 'buff'
   gtx_clk_bufg <= clk125_i;

   -- ModuleWare code(v1.12) for instance 'U_7' of 'buff'
   dcm_locked <= dcm_locked_i;

   -- ModuleWare code(v1.12) for instance 'U_9' of 'buff'
   s_axi_aclk <= clk125_i;

   -- ModuleWare code(v1.12) for instance 'U_10' of 'buff'
   tx_lld_o <= tx_dst_rdy;

   -- ModuleWare code(v1.12) for instance 'U_12' of 'buff'
   monitor_o(0) <= rx_axis_fifo_tvalid;

   -- ModuleWare code(v1.12) for instance 'U_13' of 'buff'
   monitor_o(1) <= rx_axis_fifo_tready;

   -- ModuleWare code(v1.12) for instance 'U_14' of 'buff'
   monitor_o(2) <= tx_axis_fifo_tvalid;

   -- ModuleWare code(v1.12) for instance 'U_15' of 'buff'
   monitor_o(3) <= tx_axis_fifo_tready;

   -- ModuleWare code(v1.12) for instance 'Ubuffrxclk1' of 'buff'
   rx_dst_rdy <= rx_lld_i;

   -- ModuleWare code(v1.12) for instance 'U_8' of 'inv'
   glbl_rst_intn <= not(glbl_rst_int);

   -- ModuleWare code(v1.12) for instance 'U_11' of 'or'
   local_fifo_reset <= glbl_rst or rx_reset or tx_reset;

   -- Instance port mappings.
   -- ----------------------------------------------------------------------------
   --  Instantiate the Config vector controller Controller
   -- 
   config_vector_controller : cg_eth_1gmac_gmii_axi_config_vector_sm
      port map (
         gtx_clk                 => gtx_clk_bufg,
         gtx_resetn              => vector_resetn,
         mac_speed               => HILO,
         update_speed            => LO,
         rx_configuration_vector => rx_configuration_vector,
         tx_configuration_vector => tx_configuration_vector
      );
   -- ----------------------------------------------------------------------------
   --  Instantiate the TRIMAC core FIFO Block wrapper
   -- ----------------------------------------------------------------------------
   -- 
   trimac_fifo_block : cg_eth_1gmac_gmii_axi_fifo_block
      port map (
         glbl_rstn               => glbl_rst_intn,
         gmii_col                => gmii_col,
         gmii_crs                => gmii_crs,
         gmii_rx_clk             => gmii_rx_clk,
         gmii_rx_dv              => gmii_rx_dv,
         gmii_rx_er              => gmii_rx_er,
         gmii_rxd                => gmii_rxd,
         gtx_clk                 => gtx_clk_bufg,
         pause_req               => pause_req,
         pause_val               => pause_val,
         rx_axi_rstn             => HI,
         rx_axis_fifo_tready     => rx_axis_fifo_tready,
         rx_configuration_vector => rx_configuration_vector,
         rx_fifo_clock           => fifo_clk_i,
         rx_fifo_resetn          => fifo_resetn,
         tx_axi_rstn             => HI,
         tx_axis_fifo_tdata      => tx_axis_fifo_tdata,
         tx_axis_fifo_tlast      => tx_axis_fifo_tlast,
         tx_axis_fifo_tvalid     => tx_axis_fifo_tvalid,
         tx_configuration_vector => tx_configuration_vector,
         tx_fifo_clock           => fifo_clk_i,
         tx_fifo_resetn          => fifo_resetn,
         tx_ifg_delay            => tx_ifg_delay,
         gmii_tx_clk             => gmii_tx_clk,
         gmii_tx_en              => gmii_tx_en,
         gmii_tx_er              => gmii_tx_er,
         gmii_txd                => gmii_txd,
         rx_axis_fifo_tdata      => rx_axis_fifo_tdata,
         rx_axis_fifo_tlast      => rx_axis_fifo_tlast,
         rx_axis_fifo_tvalid     => rx_axis_fifo_tvalid,
         rx_mac_aclk             => rx_mac_aclk,
         rx_reset                => rx_reset,
         rx_statistics_valid     => rx_statistics_valid,
         rx_statistics_vector    => rx_statistics_vector,
         tx_axis_fifo_tready     => tx_axis_fifo_tready,
         tx_mac_aclk             => tx_mac_aclk,
         tx_reset                => tx_reset,
         tx_statistics_valid     => tx_statistics_valid,
         tx_statistics_vector    => tx_statistics_vector
      );
   -- ----------------------------------------------------------------------------
   --  Generate resets required for the fifo side signals plus axi_lite logic
   -- ----------------------------------------------------------------------------
   --  in each case the async reset is first captured and then synchronised
   -- 
   -- ---------------
   --  Control vector reset
   -- 
   axi_lite_reset_gen : cg_eth_1gmac_gmii_axi_reset_sync
      port map (
         clk       => gtx_clk_bufg,
         enable    => dcm_locked,
         reset_in  => glbl_rst,
         reset_out => vector_reset_int
      );
   -- ---------------
   --  global reset
   -- 
   glbl_reset_gen : cg_eth_1gmac_gmii_axi_reset_sync
      port map (
         clk       => gtx_clk_bufg,
         enable    => dcm_locked,
         reset_in  => glbl_rst,
         reset_out => glbl_rst_int
      );
   -- ---------------
   --  gtx_clk reset
   -- 
   gtx_reset_gen : cg_eth_1gmac_gmii_axi_reset_sync
      port map (
         clk       => fifo_clk_i,
         enable    => fifo_clk_locked_i,
         reset_in  => local_fifo_reset,
         reset_out => fifo_clk_reset_int
      );
   rx_stats_sync : cg_eth_1gmac_gmii_axi_sync_block
      port map (
         clk      => fifo_clk_i,
         data_in  => rx_stats_toggle,
         data_out => rx_stats_toggle_sync
      );
   --use ieee.std_logic_unsigned.all;
   Unetrxpktfmt : net_rx_pktfmt16
      generic map (
         BYTESWAP => 0
      )
      port map (
         net_data_i     => net_data,
         net_sof_i      => net_sof,
         net_eof_i      => net_eof,
         net_dst_rdy_o  => net_dst_rdy,
         net_src_rdy_i  => net_src_rdy,
         hsio_data_o    => rx_data,
         hsio_sof_o     => rx_sof,
         hsio_eof_o     => rx_eof,
         hsio_dst_rdy_i => rx_dst_rdy,
         hsio_src_rdy_o => rx_src_rdy,
         rx_src_mac_o   => rx_src_mac,
         clk            => fifo_clk_i,
         rst            => fifo_reset
      );
   Utx_pkt_fmt : net_tx_pktfmt16
      port map (
         data_i       => tx_data,
         sof_i        => tx_sof,
         eof_i        => tx_eof,
         dst_rdy_o    => tx_dst_rdy,
         src_rdy_i    => tx_src_rdy,
         mac_dest_i   => rx_src_mac,
         mac_source_i => macaddress_i,
         ll_data_o    => txll_data_net,
         ll_sof_o     => txll_sof_net,
         ll_eof_o     => txll_eof_net,
         ll_dst_rdy_i => txll_dst_rdy_net,
         ll_src_rdy_o => txll_src_rdy_net,
         clk          => fifo_clk_i,
         rst          => fifo_reset
      );
   Utxpktfifo : ll_pkt_fifo_16_axi8
      port map (
         data_i        => txll_data_net,
         sof_i         => txll_sof_net,
         eof_i         => txll_eof_net,
         dst_rdy_o     => txll_dst_rdy_net,
         src_rdy_i     => txll_src_rdy_net,
         axis_tdata_o  => tx_axis_fifo_tdata,
         axis_tvalid_o => tx_axis_fifo_tvalid,
         axis_tlast_o  => tx_axis_fifo_tlast,
         axis_tready_i => tx_axis_fifo_tready,
         clk           => fifo_clk_i,
         rst           => fifo_reset
      );
   Urxpktfifo : ll_pkt_fifo_axi8_16
      port map (
         axis_tdata_i  => rx_axis_fifo_tdata,
         axis_tvalid_i => rx_axis_fifo_tvalid,
         axis_tlast_i  => rx_axis_fifo_tlast,
         axis_tready_o => rx_axis_fifo_tready,
         data_o        => net_data,
         sof_o         => net_sof,
         eof_o         => net_eof,
         dst_rdy_i     => net_dst_rdy,
         src_rdy_o     => net_src_rdy,
         clk           => fifo_clk_i,
         rst           => fifo_reset
      );
   Ullsbreak : lls_break
      port map (
         data_o    => tx_data,
         eof_o     => tx_eof,
         sof_o     => tx_sof,
         src_rdy_o => tx_src_rdy,
         lls_i     => tx_lls_i
      );
   Ullsmake : lls_make
      port map (
         lls       => rx_lls_o,
         src_rdy_i => rx_src_rdy,
         sof_i     => rx_sof,
         eof_i     => rx_eof,
         data_i    => rx_data
      );

end struct;