-- Xilinx/Coregen/VHDL wrapper for the ram inside ABC130


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity mem128x64 is

  port(
    CLOCK_in   : in  std_logic;
    writeB     : in  std_logic;
    readB      : in  std_logic;
    addr_in    : in  std_logic_vector(6 downto 0);
    Page_sel_B : in  std_logic;
    data_in    : in  std_logic_vector(63 downto 0);
    data_out   : out std_logic_vector(63 downto 0)
    );

end mem128x64;


architecture rtl of mem128x64 is

  component cg_mem128x64
    port (
      clka  : in  std_logic;
      wea   : in  std_logic_vector(0 downto 0);
      addra : in  std_logic_vector(6 downto 0);
      dina  : in  std_logic_vector(63 downto 0);
      douta : out std_logic_vector(63 downto 0)
      );
  end component;

  signal wr : std_logic_vector(0 downto 0);

begin

  wr <= conv_std_logic_vector(not(writeB),1);

  bram128x64 : cg_mem128x64
    port map (
      clka  => CLOCK_in,
      wea   => wr,
      addra => addr_in,
      dina  => data_in,
      douta => data_out
      );

end architecture rtl;

