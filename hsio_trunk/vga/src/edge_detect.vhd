----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:12:50 09/03/2012 
-- Design Name: 
-- Module Name:    edge_detect - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity edge_detect is

  port (
    clock  : in  std_logic;
    my_sig : in  std_logic;
    output : out std_logic
    );


end edge_detect;

architecture Behavioral of edge_detect is

  signal my_sig_1d : std_logic;

begin


  process
  begin
    wait until clock = '1';
    my_sig_1d <= my_sig;
  end process;

  output <= my_sig and not my_sig_1d;

end Behavioral;


