--
-- VHDL Architecture EthernetInterface2.EthernetInterface2X_tester.sim
--
-- Created:
--          by - warren.man (pc140.hep.ucl.ac.uk)
--          at - 10:47:12 04/25/08
--
-- using Mentor Graphics HDL Designer(TM) 2007.1 (Build 19)
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity EthernetInterface2X_tester is
  port(

	 
    REFCLK1_i          : out   std_logic;
    REFCLK2_i          : out   std_logic;
    dclk_50_i          : out   std_ulogic;
    hostclk_125_i      : out   std_logic;
    machost_addr_i     : out   std_logic_vector (10 downto 0);
    machost_data_i     : out   std_logic_vector (63 downto 0);
    machost_rd0_i      : out   std_logic;
    machost_rd1_i      : out   std_logic;
    machost_wr0_i      : out   std_logic;
    machost_wr1_i      : out   std_logic;
    pause_request_i0       : out   std_logic;
    pause_request_i1       : out   std_logic;
    pause_clear_i0       : out   std_logic;
    pause_clear_i1       : out   std_logic;
    
    reset_i            : out   std_logic;
    rx0_dst_rdy_i      : out   std_logic;
    rx0_fifo_clk_i     : out   std_logic;
    --rx0n_i             : out   std_logic;
    --rx0p_i             : out   std_logic;
    rx1_dst_rdy_i      : out   std_logic;
    rx1_fifo_clk_i     : out   std_logic;
    --rx1n_i             : out   std_logic;
    --rx1p_i             : out   std_logic;
    sfp0_los_i         : out   std_logic;
    sfp0_moddef0_i     : out   std_logic;
    sfp0_txfault_i     : out   std_logic;
    sfp1_los_i         : out   std_logic;
    sfp1_moddef0_i     : out   std_logic;
    sfp1_txfault_i     : out   std_logic;
    tx0_data_i         : out   std_logic_vector (7 downto 0);
    tx0_eof_i          : out   std_logic;
    tx0_fifo_clk_i     : out   std_logic;
    tx0_ifg_delay_i    : out   std_logic_vector (7 downto 0);
    tx0_sof_i          : out   std_logic;
    tx0_src_rdy_i      : out   std_logic;
    tx1_data_i         : out   std_logic_vector (7 downto 0);
    tx1_eof_i          : out   std_logic;
    tx1_fifo_clk_i     : out   std_logic;
    tx1_ifg_delay_i    : out   std_logic_vector (7 downto 0);
    tx1_sof_i          : out   std_logic;
    tx1_src_rdy_i      : out   std_logic;
    sfp0_moddef2_io    : inout std_logic;
    sfp1_moddef2_io    : inout std_logic;

    sim_conf_busy : out boolean

    );

-- Declarations

end EthernetInterface2X_tester;


architecture sim of EthernetInterface2X_tester is

  signal clk   : std_logic := '0';
  signal clk50 : std_logic := '0';

  signal rd0, rd1, wr0, wr1 : std_logic;
  signal data               : std_logic_vector(31 downto 0);
  signal addr               : std_logic_vector(11 downto 0);  -- note bigger


------------------------------------------------------------------------------
begin

  clk   <= not(clk)   after 4000 ps;
  clk50 <= not(clk50) after 10 ns;

  REFCLK1_i     <= clk;
  hostclk_125_i <= clk;
  dclk_50_i     <= clk50;

  rx0_fifo_clk_i <= clk;
  tx0_fifo_clk_i <= clk;
  tx1_fifo_clk_i <= clk;
  rx1_fifo_clk_i <= clk;


  sfp0_moddef2_io <= 'Z';
  sfp1_moddef2_io <= 'Z';


  -- to make life easier:
  machost_addr_i <= addr(10 downto 0);  -- allows use of x"nnn"
  machost_data_i <= x"00000000" & data;
  machost_rd0_i  <= rd0;
  machost_rd1_i  <= rd1;
  machost_wr0_i  <= wr0;
  machost_wr1_i  <= wr1;

  ----------------------------------------------------------------------------
  simulation : process


    --------------------------------------------------
    -- Procedures 
    --------------------------------------------------
    procedure HostWrite( iaddr : in std_logic_vector(11 downto 0);
                         idata : in std_logic_vector(31 downto 0)
                         ) is
      --variable addr : std_logic_vector(15 downto 0);
      --variable data : std_logic_vector(31 downto 0);
    begin
      addr <= iaddr;
      data <= idata;
      wr0  <= '1';
      wait until rising_edge(clk);
      wr0  <= '0';
      wait until rising_edge(clk);
      wait until rising_edge(clk);
      wait until rising_edge(clk);
      wait until rising_edge(clk);
    end procedure;
    ----------------------------------------------------
    procedure HostRead( iaddr  : in std_logic_vector(11 downto 0)
                        ) is
    begin
      addr <= iaddr;
      rd0  <= '1';
      wait until rising_edge(clk);
      rd0  <= '0';
      wait until rising_edge(clk);
      wait until rising_edge(clk);
      wait until rising_edge(clk);
      wait until rising_edge(clk);
    end procedure;
    ----------------------------------------------------
    procedure WaitClk is
    begin
      wait until rising_edge(clk);
      wait for 1 ns;
    end procedure;
    ----------------------------------------------------
    procedure WaitClks (nclks  : in integer) is
    begin
      for waitclkloops in 1 to nclks loop
        wait until rising_edge(clk);
        wait for 1 ns;
      end loop;
    end procedure;
    ----------------------------------------------------


    ----------------------------------------------------
    ----------------------------------------------------
    ----------------------------------------------------
    ----------------------------------------------------
    ----------------------------------------------------
    ----------------------------------------------------
    ----------------------------------------------------



    ----------------------------------------------------
    --                 T E S T S        --
    ----------------------------------------------------

    procedure TestHostBus is
    begin
      addr <= x"000";
      data <= x"00000000";
      rd0  <= '0';
      rd1  <= '0';
      wr0  <= '0';
      wr1  <= '0';

      wait for 1000 ns;

      HostRead(x"200");
      HostRead(x"240");
      HostWrite(x"200", x"12345678");
      HostWrite(x"240", x"00009abc");
      HostRead(x"200");
      HostRead(x"240");

      wait for 5000 ns;

      HostRead(x"200");
      HostRead(x"240");
      HostRead(x"280");
      HostRead(x"2C0");
      HostRead(x"300");
      HostRead(x"320");
      HostRead(x"340");
      HostRead(x"380");
      HostRead(x"384");
      HostRead(x"388");
      HostRead(x"38C");
      HostRead(x"390");

      wait for 10000 ns;
      --------------------------------------------------
      wait until rising_edge(clk);

      addr <= x"300";
      data <= x"12345678";
      wr0  <= '1';
      wait until rising_edge(clk);
      wr0  <= '0';
      wait for 100 ns;
      wait until rising_edge(clk);

      addr <= x"300";
      rd0  <= '1';
      wait until rising_edge(clk);
      rd0  <= '0';
      wait for 100 ns;
      wait until rising_edge(clk);

      addr <= x"400";
      rd0  <= '1';
      wait until rising_edge(clk);
      rd0  <= '0';
      wait for 100 ns;
      wait until rising_edge(clk);

      addr <= x"200";
      rd0  <= '1';
      wait until rising_edge(clk);
      rd0  <= '0';
      wait for 100 ns;
      wait until rising_edge(clk);

      addr <= x"38C";
      rd0  <= '1';
      wait until rising_edge(clk);
      rd0  <= '0';

    end procedure;

    --======================================================  --

    procedure TestTXFifo is
    begin

      WaitClk;

      tx0_src_rdy_i <= '1';
      tx0_data_i    <= x"11";

      WaitClks(1000);


      for packets in 1 to 20 loop

        tx0_sof_i <= '1';
        WaitClk;
        --tx0_sof_i <= '0';

        for loopy2 in 1 to 236 loop

          tx0_data_i <= conv_std_logic_vector(packets, 8);
          WaitClk;

        end loop;

        tx0_sof_i <= '0';
        tx0_eof_i  <= '1';    
        
        for loopy2 in 1 to 236 loop

          tx0_data_i <= conv_std_logic_vector(packets, 8);
          WaitClk;

        end loop;

        tx0_data_i <= x"EE";
        tx0_eof_i  <= '1';
        WaitClk;
        tx0_eof_i  <= '0';

      end loop;

      WaitClks(1000);

      tx0_src_rdy_i <= '0';



    end procedure;

    ----------------------------------------------------

    ----------------------------------------------------
  begin

    -- defaults                         ---------
    REFCLK2_i <= '0';


    pause_request_i0  <= '0';
    pause_request_i1 <= '0';
    pause_clear_i0   <= '0';
    pause_clear_i1   <= '0';
    


    tx0_src_rdy_i <= '0';
    rx0_dst_rdy_i <= '1';
    tx1_src_rdy_i <= '0';
    rx1_dst_rdy_i <= '1';

    sfp0_los_i     <= '1';
    sfp0_moddef0_i <= 'H';              -- xilinx do this to sim float high
    sfp0_txfault_i <= '0';
    sfp1_los_i     <= '1';
    sfp1_moddef0_i <= 'H';
    sfp1_txfault_i <= '0';

    tx0_data_i <= "00000000";
    tx1_data_i <= "00000000";

    tx0_eof_i <= '0';
    tx1_eof_i <= '0';
    tx0_sof_i <= '0';
    tx1_sof_i <= '0';

    tx0_ifg_delay_i <= "00000000";
    tx1_ifg_delay_i <= "00000000";

    --rx0n_i          <= '0';
    --rx0p_i          <= '0';
    --rx1n_i          <= '0';
    --rx1p_i          <= '0';

    sim_conf_busy <= true;

    reset_i <= '1';
    wait until rising_edge(clk);
    reset_i <= '0';

    wait for 12000 ns;
    sim_conf_busy <= false;

    wait for 1000 ns;
    -------------------------------------------------



    --TestHostBus;
    TestTXFifo;

    wait;

  end process;



end architecture sim;

