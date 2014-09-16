-- Xilinx/Coregen/VHDL wrapper for the ram inside ABC130


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity RAM_80x8 is

  port(
    BC            : in  std_logic;
    FWriteStrob   : in  std_logic_vector(0 downto 0);
    FWriteAddress : in  std_logic_vector(6 downto 0);
    DataIn        : in  std_logic_vector(7 downto 0);
    FReadStrob    : in  std_logic;
    FReadAddress  : in  std_logic_vector(6 downto 0);
    Dout          : out std_logic_vector(7 downto 0)
    );

end RAM_80x8;


architecture rtl of RAM_80x8 is
 
  component cg_dpram_80x8
    port (
      clka  : in  std_logic;
      wea   : in  std_logic_vector(0 downto 0);
      addra : in  std_logic_vector(6 downto 0);
      dina  : in  std_logic_vector(7 downto 0);
      clkb  : in  std_logic;
      addrb : in  std_logic_vector(6 downto 0);
      doutb : out std_logic_vector(7 downto 0)
      );
  end component;

  --signal wea : std_logic_vector(0 downto 0);

begin
  


  dpram85x8 : cg_dpram_80x8
    port map (
      clka  => BC,
      wea   => FWriteStrob,
      addra => FWriteAddress,
      dina  => DataIn,
      clkb  => BC,
      addrb => FReadAddress,
      doutb => Dout
      );


end architecture rtl;

