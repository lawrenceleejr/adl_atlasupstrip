LIBRARY ieee;
use work.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity dataflagnew is 
   port (
     eofin      : in std_logic;
     eofout     : in std_logic;
     datawaiting: out std_logic;
     clkin      : in std_logic;
     clkout     : in std_logic;
     rst        : in std_logic
     );
end dataflagnew;

architecture DATAFLAGNEW of dataflagnew is
  COMPONENT dataflagfifo
    PORT (
    rst : IN STD_LOGIC;
    wr_clk : IN STD_LOGIC;
    rd_clk : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC
    );
  END COMPONENT;

  signal oldeofin: std_logic;
  signal oldeofout: std_logic;
  signal datain: std_logic;
  signal dataout: std_logic;
  signal empty: std_logic;

  begin

    process(rst, clkin)
    begin
      if(rst='1')then
        oldeofin<='0';
      elsif (rising_edge(clkin))then
        oldeofin<=eofin;
        datain<=eofin and not oldeofin;
      end if;
    end process; 
  
    process(rst, clkout)
    begin
      if(rst='1')then
        oldeofout<='0';
      elsif (rising_edge(clkout))then
        oldeofout<=eofout;
        dataout<=eofout and not oldeofout;
      end if;
    end process; 
  
  thedataflagfifo : dataflagfifo
    PORT MAP (
    rst => rst,
    wr_clk => clkin,
    rd_clk => clkout,
    din => "1",
    wr_en => datain,
    rd_en => dataout,
    dout => open,
    full => open,
    empty => empty
    );
    datawaiting <= not empty;

end DATAFLAGNEW;
