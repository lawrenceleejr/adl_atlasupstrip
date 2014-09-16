--
-- VHDL Architecture atlys.atlys_top_tester.sim
--
-- Created:
--          by - warren.man (pc140.hep.ucl.ac.uk)
--          at - 21:08:47 11/21/13
--
-- using Mentor Graphics HDL Designer(TM) 2012.1 (Build 6)
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library utils;
use utils.pkg_types.all;

entity atlys_top_tester is
  port(
    bc_i          : in   std_logic;

    com_i          : in   std_logic;
    l0_i          : in   std_logic;
    l1_i          : in   std_logic;
    r3s_i         : in   std_logic;
    
    rstn_i        : in   std_logic;
    btn_o          : out   std_logic_vector (5 downto 0);
    clk_o          : out   std_logic;
    
    sw_o           : out   std_logic_vector (7 downto 0);
    usbuart_rx_0   : out   std_logic;
    vmod_exp_pio   : inout std_logic_vector (20 downto 1);
    vmod_exp_nio   : inout std_logic_vector (20 downto 1);

    datl_o   : out   std_logic;
    datr_o   : out   std_logic
    
    );

-- Declarations

end atlys_top_tester;

--
architecture sim of atlys_top_tester is

  signal dxout : std_logic_vector(3 downto 0);
  signal dxin : std_logic_vector(3 downto 0);

  signal rst : std_logic;

  constant POST_BC_DELAY : time      := 50 ps;

  signal   bc            : std_logic;
  signal   bcd            : std_logic;

  signal   clk100        : std_logic := '1';

  signal   coml0        : std_logic;
  signal   l1r3s        : std_logic;
  
  signal   coml0nd        : std_logic;
  signal   l1r3snd        : std_logic;

  



begin

  dxout <= "0000";

  datl_o <= dxin(0);
  datr_o <= dxin(1);
  

  rst <= not rstn_i;
  btn_o <= "00000" & not(rst);
  sw_o <= "00000000";


  bc     <= bc_i;
  bcd <= bc_i after 6250 ps;
  clk100 <= not(clk100) after 5000 ps;

  clk_o  <= clk100;
  

  coml0nd <= com_i after 50 ps when bc_i = '0' else l0_i after 50 ps;
  l1r3snd  <= l1_i after 50 ps when bc_i = '0' else r3s_i after 50 ps;
  

  coml0 <= coml0nd after 6 ns;
  l1r3s  <= l1r3snd after 6 ns;
  


  vmod_exp_pio(20)  <= '0'; -- hard RST
  vmod_exp_nio(20)  <= '0'; -- tmu_comlo_swap
  vmod_exp_pio(19)  <=  rst; -- RST 
  vmod_exp_nio(19)  <= '0'; -- loop
  vmod_exp_pio(18)  <= '0'; -- high-z
  vmod_exp_nio(18)  <= '0'; -- dir 
  vmod_exp_pio(17)  <= '0'; -- DRC inv
  vmod_exp_nio(17)  <= '1'; -- DRCMode1
  vmod_exp_pio(16)  <= '0'; -- DRCMode0

  vmod_exp_nio(16)  <= 'Z';
  
  
  dxin(3) <= vmod_exp_pio(15);
  
  vmod_exp_pio(14)  <= dxout(3);
  vmod_exp_nio(14)  <= not dxout(3);

  vmod_exp_pio(13)  <= 'Z';
  vmod_exp_nio(13)  <= 'Z';

  
  dxin(2) <= vmod_exp_pio(12);

  vmod_exp_pio(11)  <= '0';
  vmod_exp_nio(11)  <= '1';
  
  vmod_exp_pio(10)  <= bc;
  vmod_exp_nio(10)  <= not bc;

  vmod_exp_pio(9)  <= dxout(2);
  vmod_exp_nio(9)  <= not dxout(2);

  vmod_exp_pio(8)  <= 'Z';
  vmod_exp_nio(8)  <= 'Z';

  dxin(1) <= vmod_exp_pio(7);
  
  vmod_exp_pio(6)  <= dxout(1);
  vmod_exp_nio(6)  <= not dxout(1);

  vmod_exp_pio(5)  <= 'Z';
  vmod_exp_nio(5)  <= 'Z';

  dxin(0) <= vmod_exp_pio(4);

  vmod_exp_pio(3)  <= dxout(0);
  vmod_exp_nio(3)  <= not dxout(0);
  
  vmod_exp_pio(2)  <= l1r3s;
  vmod_exp_nio(2)  <= not l1r3s;
  
  vmod_exp_pio(1)  <= coml0;
  vmod_exp_nio(1)  <= not coml0;


  

end architecture sim;

