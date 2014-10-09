library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use work.all;
package arraytype is
    type    dataarray is array(15 downto 0) of std_logic_vector(17 downto 0);
    type    array10b is array(15 downto 0) of std_logic_vector(9 downto 0);
    type    dal is array(15 downto 0) of std_logic_vector(1 downto 0);
    type    hb is array(1 downto 0) of std_logic_vector(4 downto 0);
    type    hbpipeline is array(40 downto 0) of std_logic_vector(2 downto 0);
    type    hitbusoutput is array(1 downto 0) of std_logic_vector(31 downto 0);
end package arraytype; 
