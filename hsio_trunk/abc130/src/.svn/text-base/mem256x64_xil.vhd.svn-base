-- Xilinx/Coregen/VHDL wrapper for the ram inside ABC130


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity mem256x64 is

  port(
    CLOCK_in   : in  std_logic;
    writeB     : in  std_logic;
    readB      : in  std_logic;
    addr_in    : in  std_logic_vector(6 downto 0);
    Page_sel_B : in  std_logic;
    data_in    : in  std_logic_vector(63 downto 0);
    data_out   : out std_logic_vector(63 downto 0);
    data_m     : out std_logic
    );

end mem256x64;


architecture rtl of mem256x64 is



  component cg_mem256x64
    port (
      clka  : in  std_logic;
      wea   : in  std_logic_vector(0 downto 0);
      addra : in  std_logic_vector(7 downto 0);
      dina  : in  std_logic_vector(63 downto 0);
      douta : out std_logic_vector(63 downto 0)
      );
  end component;


  signal wr   : std_logic_vector(0 downto 0);
  signal addr : std_logic_vector(7 downto 0);


begin

  data_m <= '0';

  wr <= conv_std_logic_vector(not(writeB), 1);


  addr <= Page_sel_B & addr_in;


  bram256x64 : cg_mem256x64
    port map (
      clka  => CLOCK_in,
      wea   => wr,
      addra => addr,
      dina  => data_in,
      douta => data_out
      );

end architecture rtl;

