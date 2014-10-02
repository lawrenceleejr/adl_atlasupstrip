-- VHDL Entity ethernet_v4.PauseController_tb.symbol
--
-- Created by Matt Warren 2014
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2013.1 (Build 6)
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.eth_types.all;

entity PauseController_tb is
-- Declarations

end PauseController_tb ;

-- VHDL from Block Diagram 
-- Generated by Mentor Graphics HDL Designer(TM) 2013.1 (Build 6) 
--
-- ethernet_v4.PauseController_tb.sim
--
-- Created by Matt Warren 2014
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.eth_types.all;


architecture sim of PauseController_tb is

   -- Architecture declarations

   -- Internal signal declarations
   -- Architecture declarations

   -- Internal signal declarations
   signal clk             : std_logic;
   signal rst             : std_logic;
   signal pause_req_o     : std_logic;
   signal pause_val_o     : std_logic_vector(15 downto 0);
   signal rx_fifo_stat_i  : std_logic_vector(3 downto 0);
   signal quanta_tick_o   : std_logic;
   signal ext_pause_clr_i : std_logic;
   signal ext_pause_req_i : std_logic;
   signal hi              : std_logic;
   signal lo              : std_logic;


   -- Component Declarations
   component PauseController_tester
   port (
      pause_req_o     : in     std_logic;
      pause_val_o     : in     std_logic_vector (15 downto 0);
      clk             : out    std_logic;
      ext_pause_clr_i : out    std_logic;
      ext_pause_req_i : out    std_logic;
      rst             : out    std_logic;
      rx_fifo_stat_i  : out    std_logic_vector (3 downto 0)
   );
   end component;
   component PauseQuantaTimer
   port (
      bitclk        : in     std_logic;
      rst           : in     std_logic;
      quanta_tick_o : out    std_logic
   );
   end component;
   component pause_controller
   generic (
      PAUSE_QUANTA_VALUE : integer
   );
   port (
      clk                 : in     std_logic;
      ext_pause_clr_i     : in     std_logic;
      ext_pause_req_i     : in     std_logic;
      quanta_timer_tick_i : in     std_logic;
      rst                 : in     std_logic;
      rx_fifo_stat_i      : in     std_logic_vector (3 downto 0);
      test_i              : in     std_logic;
      pause_req_o         : out    std_logic;
      pause_val_o         : out    std_logic_vector (15 downto 0)
   );
   end component;
   component m_power
   port (
      hi : out    std_logic;
      lo : out    std_logic
   );
   end component;


begin

   -- Instance port mappings.
   UPauseController_tester : PauseController_tester
      port map (
         pause_req_o     => pause_req_o,
         pause_val_o     => pause_val_o,
         clk             => clk,
         rst             => rst,
         ext_pause_clr_i => ext_pause_clr_i,
         ext_pause_req_i => ext_pause_req_i,
         rx_fifo_stat_i  => rx_fifo_stat_i
      );
   UPauseQuantaTimer : PauseQuantaTimer
      port map (
         bitclk        => clk,
         rst           => rst,
         quanta_tick_o => quanta_tick_o
      );
   Upause_controller : pause_controller
      generic map (
         PAUSE_QUANTA_VALUE => 32
      )
      port map (
         clk                 => clk,
         rst                 => rst,
         test_i              => lo,
         ext_pause_req_i     => ext_pause_req_i,
         ext_pause_clr_i     => ext_pause_clr_i,
         quanta_timer_tick_i => quanta_tick_o,
         rx_fifo_stat_i      => rx_fifo_stat_i,
         pause_req_o         => pause_req_o,
         pause_val_o         => pause_val_o
      );
   U_0 : m_power
      port map (
         hi => hi,
         lo => lo
      );

end sim;