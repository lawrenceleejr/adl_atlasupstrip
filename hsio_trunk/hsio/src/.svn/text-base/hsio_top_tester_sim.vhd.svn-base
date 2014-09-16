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

ENTITY hsio_top_tester IS
   PORT( 
      rst_poweron_n  : OUT    std_logic;
      rst            : OUT    std_logic;
      clk40          : OUT    std_logic;
      clk25          : OUT    std_logic;
      clk_mgt0_125_p : OUT    std_logic;
      clk_mgt0_125_m : OUT    std_logic;
      clk_xtal_125_p : OUT    std_logic;
      clk_xtal_125_m : OUT    std_logic;
      clk_mgt0_250_p : OUT    std_logic;
      clk_mgt0_250_m : OUT    std_logic;
      clk_diff_156_p : OUT    std_logic;
      clk_diff_156_m : OUT    std_logic;
      ibfi_moddef1   : IN     std_logic_vector ( 1 DOWNTO 0);
      ibfi_moddef2   : INOUT  std_logic_vector ( 1 DOWNTO 0);
      hex_sw_n       : OUT    std_logic_vector (3 DOWNTO 0);
      eth_md_io      : OUT    std_logic;
      sim_conf_busy  : OUT    boolean
   );

-- Declarations

END hsio_top_tester ;


architecture sim of hsio_top_tester is



  signal c250 : std_logic := '0';
  signal c125 : std_logic := '0';
  signal c156 : std_logic := '0';
  signal c25  : std_logic := '0';
  signal c40  : std_logic := '0';

  signal clk   : std_logic := '0';


  signal rd0, rd1, wr0, wr1 : std_logic;
  signal data               : std_logic_vector(31 downto 0);
  signal addr               : std_logic_vector(11 downto 0);  -- note bigger


------------------------------------------------------------------------------
begin

  c40  <= not(c40)  after 12500 ps;
  c25  <= not(c25)  after 20000 ps;
  c125 <= not(c125) after 4000 ps;
  c250 <= not(c250) after 2000 ps;
  c156 <= not(c156) after 3000 ps;

  clk_mgt0_125_p <= c125;
  clk_mgt0_125_m <= not c125;

  clk_mgt0_250_p <= c250;
  clk_mgt0_250_m <= not c250;

  clk_diff_156_p <= c156;
  clk_diff_156_m <= not c156;

  clk_xtal_125_p <= c125;
  clk_xtal_125_m <= not c125;

  clk   <= c125;
  clk25 <= c25;
  clk40 <= c40;

  ibfi_moddef2 <= "HH";
  eth_md_io    <= 'H';



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

    ----------------------------------------------------

    ----------------------------------------------------
  begin

    hex_sw_n <= "1111";
    rst_poweron_n <= '0', '1' after 1234 ns;
    
    sim_conf_busy <= true;
    wait for 450 us;
    sim_conf_busy <= false;

    wait for 1000 ns;
    -------------------------------------------------
    

    --TestHostBus;
    --TestTXFifo;

    wait;

  end process;



end architecture sim;

