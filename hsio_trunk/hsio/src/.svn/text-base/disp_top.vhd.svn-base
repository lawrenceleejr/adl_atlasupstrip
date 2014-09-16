-- The following contains exerpts pertaining to the LED display taken from "BnlAsicCore.vhd" by Ryan Herbst (SLAC)
-- This code requires two submodules: 
-- DisplayControl.vhd
-- DisplayCharacters.vhd
--
-- **************************************Instantiation template**********************************
-- *** following goes before "begin" of the architecture of the top module
-- component LEDdisplay is
--      port(
--              clk125mhz : in std_logic;
--              reset   : in std_logic;
--              dispClk      : out std_logic;
--              dispDat      : out std_logic;
--              dispLoadL    : out std_logic_vector(0 to 1);
--              dispRstL     : out std_logic;
--              dispDigitA,dispDigitB,dispDigitC,dispDigitD,dispDigitE,dispDigitF,dispDigitG,dispDigitH   : in  std_logic_vector(7 downto 0)
--      );
--      end component;
--      signal dispDigitA      : std_logic_vector(7 downto 0);
--   signal dispDigitB      : std_logic_vector(7 downto 0);
--   signal dispDigitC      : std_logic_vector(7 downto 0);
--   signal dispDigitD      : std_logic_vector(7 downto 0);
--   signal dispDigitE      : std_logic_vector(7 downto 0);
--   signal dispDigitF      : std_logic_vector(7 downto 0);
--   signal dispDigitG      : std_logic_vector(7 downto 0);
--   signal dispDigitH      : std_logic_vector(7 downto 0);
--
-- ***following goes after begin of architecture of top module
--      inst_display: LEDdisplay port map(
--              clk125mhz =>clk125mhz,
--              reset => reset,
--              dispClk => dispClk, 
--              dispDat => dispDat
--              dispLoadL => dispLoadL,
--              dispRstL => dispRstL,
--              dispDigitA => dispDigitA,
--              dispDigitB => dispDigitB,
--              dispDigitC => dispDigitC,
--              dispDigitD => dispDigitD,
--              dispDigitE => dispDigitE,
--              dispDigitF => dispDigitF,
--              dispDigitG => dispDigitG,
--              dispDigitH => dispDigitH
--      );
--              --assign the values to be displayed here, if a new symbol is desired add it to the DisplayCharacter
--              dispDigitA <= x"0A";  
--        dispDigitB <= x"0B";
--        dispDigitC <= x"0C";
--        dispDigitD <= x"0D";
--        dispDigitE <= x"0E";
--        dispDigitF <= x"0F";
--        dispDigitG <= x"10";
--        dispDigitH <= x"11";
-- *** following goes in the port declaration in the top module
--              --display
--              dispClk      : out std_logic;
--              dispDat      : out std_logic;
--              dispLoadL    : out std_logic_vector(0 to 1);
--              dispRstL     : out std_logic;
-- *** following goes in the .ucf file
--NET "DispClk"       LOC = "AG22";
--NET "DispDat"       LOC = "AJ22";
--NET "DispLoadL<0>"  LOC = "AK17";
--NET "DispLoadL<1>"  LOC = "AK18";
--NET "DispRstL"      LOC = "AH22";
-- --if NOT using "HIGH SPEED I/O VIRTEX4 BOARD SA 24B-100-11-C00 by SLAC" modify accordingly

-- *************************************End of Instantiation template***************************************
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;


entity disp_top is
  port(
    clk        : in  std_logic;
    reset      : in  std_logic;
    tick_2khz_i      : in  std_logic;
    toggle_2mhz_i      : in  std_logic;
    dispClk    : out std_logic;
    dispDat    : out std_logic;
    dispLoadL  : out std_logic_vector(1 downto 0);
    dispRstL   : out std_logic;
    dispDigitA : in  std_logic_vector(7 downto 0);
    dispDigitB : in  std_logic_vector(7 downto 0);
    dispDigitC : in  std_logic_vector(7 downto 0);
    dispDigitD : in  std_logic_vector(7 downto 0);
    dispDigitE : in  std_logic_vector(7 downto 0);
    dispDigitF : in  std_logic_vector(7 downto 0);
    dispDigitG : in  std_logic_vector(7 downto 0);
    dispDigitH : in  std_logic_vector(7 downto 0)
    );
end disp_top;

architecture rtl of disp_top is
  component disp_control
    port (
      sysClk     : in  std_logic;
      sysRst     : in  std_logic;
      dispStrobe : in  std_logic;
      dispUpdate : in  std_logic;
      dispRotate : in  std_logic_vector(1 downto 0);
      dispDigitA : in  std_logic_vector(7 downto 0);
      dispDigitB : in  std_logic_vector(7 downto 0);
      dispDigitC : in  std_logic_vector(7 downto 0);
      dispDigitD : in  std_logic_vector(7 downto 0);
      dispClk    : out std_logic;
      dispDat    : out std_logic;
      dispLoadL  : out std_logic;
      dispRstL   : out std_logic
      );
  end component;
  signal dispUpdateA : std_logic;
  signal dispUpdateB : std_logic;
  signal dispDatA    : std_logic;
  signal dispDatB    : std_logic;
  signal dispStrobe  : std_logic;
  signal sysClkCnt   : std_logic;

begin
  -- Display Controller A
  Udispctrl0 : disp_control port map (
    sysClk     => clk,
    sysRst     => reset,
    dispStrobe => dispStrobe,
    dispUpdate => dispUpdateA,
    dispRotate => "01",
    dispDigitA => dispDigitA,
    dispDigitB => dispDigitB,
    dispDigitC => dispDigitC,
    dispDigitD => dispDigitD,
    dispClk    => dispClk,
    dispDat    => dispDatA,
    dispLoadL  => dispLoadL(1),
    dispRstL   => dispRstL
    );
  -- Display Controller B
  Udispcntrl1 : disp_control port map (
    sysClk     => clk,
    sysRst     => reset,
    dispStrobe => dispStrobe,
    dispUpdate => dispUpdateB,
    dispRotate => "01",
    dispDigitA => dispDigitE,
    dispDigitB => dispDigitF,
    dispDigitC => dispDigitG,
    dispDigitD => dispDigitH,
    dispClk    => open,
    dispDat    => dispDatB,
    dispLoadL  => dispLoadL(0),
    dispRstL   => open
    );

  process (clk, reset)
  begin
    if rising_edge(clk) then
      if (reset = '1') then
        sysClkCnt   <= '0';
        dispStrobe  <= '0';
        dispUpdateA <= '0';
        dispUpdateB <= '0';
        sysClkCnt   <= '0';

      else

        -- Display strobe, ns
        dispStrobe <= toggle_2mhz_i;

        -- defaults
        dispUpdateA <= '0';
        dispUpdateB <= '0';

        if (tick_2khz_i = '1') then
            dispUpdateA <= sysClkCnt;
            dispUpdateB <= not sysClkCnt;
 
          -- Update counter
          sysClkCnt <= not (sysClkCnt);
          
        end if;
      end if;
      

    end if;
  end process;
  dispDat <= dispDatA or dispDatB;
end rtl;

