--
--

--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity abc130_driver_pcb_top_tester is
  port(
    rst_i : std_logic;
    bco_i : std_logic;
    drc_i : std_logic;
    coml0_i : std_logic;
    l1r3_i : std_logic;
    addr_i : std_logic_vector(4 downto 0);
    
    --bdp_pio : inout std_logic_vector(15 downto 8);
    --bdp_nio : inout std_logic_vector(15 downto 8);
    SHUNT_CTL_SW_I : out     std_logic;  
    REG_ENA_I      : out     std_logic; 
    ABCUP_I       : out std_logic;  
    ADDR0_I       : out std_logic;   
    ADDR1_I       : out std_logic;   
    ADDR2_I       : out std_logic;    
    ADDR3_I       : out std_logic;   
    ADDR4_I       : out std_logic;   
    HSIO_BCO_N    : out std_logic;   
    HSIO_BCO_P    : out std_logic;   
    HSIO_DXOUT0_N : out std_logic;   
    HSIO_DXOUT0_P : out std_logic;   
    HSIO_DXOUT1_N : out std_logic;   
    HSIO_DXOUT1_P : out std_logic;   
    HSIO_DXOUT2_N : out std_logic;   
    HSIO_DXOUT2_P : out std_logic;   
    HSIO_DXOUT3_N : out std_logic;   
    HSIO_DXOUT3_P : out std_logic;   
    HSIO_L0_CMD_N : out std_logic;   
    HSIO_L0_CMD_P : out std_logic;   
    HSIO_R3_N     : out std_logic;   
    HSIO_R3_P     : out std_logic;      --
    HSIO_SP0_N    : out std_logic;      --
    HSIO_SP0_P    : out std_logic;      --
    I2C_CLK       : out std_logic;      --
    I2C_DATA      : out std_logic;      --
    REG_END_I     : out std_logic;      --
    RSTB_I        : out std_logic;      --
    SCAN_EN_I     : out std_logic;      --
    SDI_BC_I      : out std_logic;      --
    SDI_CLK_I     : out std_logic;      --
    SDO_BC_O      : out std_logic;      --
    SDO_CLK_O     : out std_logic;      --
    SW1_O         : out std_logic;      -- 
    SPARE1        : out std_logic;   
    SPARE2        : out std_logic;   
    SPARE3        : out std_logic;   
    SPARE4        : out std_logic;   
    SPARE5        : out std_logic;   
    TERM_I        : out std_logic      
    );

-- Declarations

end abc130_driver_pcb_top_tester;

--
architecture sim of abc130_driver_pcb_top_tester is




  signal rst : std_logic;

  constant POST_BC_DELAY : time := 50 ps;

  signal bc  : std_logic;
  signal bcd : std_logic;


  --signal clk40 : std_logic := '1';

  --signal coml0 : std_logic;
  --signal l1r3s : std_logic;
  signal dxout : std_logic_vector(3 downto 0);
  --signal addr  : std_logic_vector(4 downto 0);
  signal bdp  : std_logic_vector(15 downto 8);




begin

  --bdp_pio <= bdp;
  --bdp_nio <= not bdp;

  --clk40 <= not(clk40) after 12500 ps;

  SW1_O <= rst_i;  -- hardreset
  SDO_CLK_O <= '0'; -- tmu_coml0_swap

  HSIO_BCO_N <= not bco_i;
  HSIO_BCO_P <= bco_i;


  HSIO_DXOUT0_N <= not dxout(0);
  HSIO_DXOUT0_P <= dxout(0);
  HSIO_DXOUT1_N <= not dxout(1);
  HSIO_DXOUT1_P <= dxout(1);
  HSIO_DXOUT2_N <= not dxout(2);
  HSIO_DXOUT2_P <= dxout(2);
  HSIO_DXOUT3_N <= not dxout(3);
  HSIO_DXOUT3_P <= dxout(3);

  HSIO_L0_CMD_N <= not coml0_i after 6250 ps;
  HSIO_L0_CMD_P <= coml0_i  after 6250 ps;
  HSIO_R3_N     <= not l1r3_i after 6250 ps;
  HSIO_R3_P     <= l1r3_i after 6250 ps;
  HSIO_SP0_N    <= '1';
  HSIO_SP0_P    <= '0';



 -- ABCUP_I <= '0';
 
  -----------------------------------
--  I2C_CLK   <= 'Z';
--  I2C_DATA  <= 'Z';

--   SHUNT_CTL_SW_I <= '0';
--   REG_ENA_I  <= '0';
--   REG_END_I <= '0';

--   RSTB_I    <= '0';
--   SCAN_EN_I <= '0';
--   SDI_BC_I  <= '0';
--   SDI_CLK_I <= '0';
--   SDO_BC_O  <= '0';
--   SPARE1    <= '0';
--   SPARE2    <= '0';
--   SPARE3    <= '0';
--   SPARE4    <= '0';
--   SPARE5    <= '0';
--   TERM_I    <= '0';


  dxout <= "0000";
  --coml0 <= '0';
  --l1r3s  <= '0';
  --addr  <= "10101";
  bdp <= (others => 'Z');


  --rst   <= '1', '0' after 1000 ns;
  

  simulation : process
  begin

    wait;

  end process;
    
  

end architecture sim;

