--
-- VHDL Architecture hsio.top_outputs_tester.sim
--
-- Created:
--          by - warren.man (pc140.hep.ucl.ac.uk)
--          at - 16:50:15 02/20/13
--
-- using Mentor Graphics HDL Designer(TM) 2012.1 (Build 6)
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity top_outputs_tester is
  port(
    outsigs        : out std_logic_vector (15 downto 0);
    clk_o          : out std_logic;
    clk_bco        : out std_logic;
    com            : out std_logic;
    l1r            : out std_logic;
    reg_com_enable : out std_logic_vector (15 downto 0);
    reg_control    : out std_logic_vector (15 downto 0);
    rst_o          : out std_logic;
    strobe40       : out std_logic
    );

-- Declarations

end top_outputs_tester;

--
architecture sim of top_outputs_tester is


  constant POST_CLK_DELAY : time := 50 ps;

  signal rst   : std_logic := '1';
  signal clk   : std_logic := '1';
  signal clk40 : std_logic := '1';

  signal coml0 : std_logic := '0';
  signal l1r3  : std_logic := '0';


begin

  clk   <= not(clk)   after 6250 ps;
  clk40 <= not(clk40) after 12500 ps;

  clk_o <= clk;

  strobe40 <= clk40;
  clk_bco  <= clk40;

  rst_o <= rst;

  outsigs <= '0' & coml0 & '0' & coml0 & l1r3 & l1r3 & "00" &
             '0' & l1r3 & '0' & coml0 & '0' & l1r3 & '0' & coml0;

  ----------------------------------------------------------------------------
  simulation                  :    process
    --------------------------------------------------
    -- Procedures 
    --------------------------------------------------
    procedure WaitClk is
    begin
      wait until rising_edge(clk);
      wait for POST_CLK_DELAY;
    end procedure;
    ----------------------------------------------------
    procedure WaitClks (nclks : in integer) is
    begin
      for waitclkloops in 1 to nclks loop
        wait until rising_edge(clk);
        wait for POST_CLK_DELAY;
      end loop;
    end procedure;
    ----------------------------------------------------
    procedure SendComTrig is
    begin
      com   <= '1';
      WaitClks(4);
      com   <= '0';
    end procedure;
    ----------------------------------------------------
    procedure SendL1R is
    begin
      l1r   <= '1';
      WaitClks(2);
      l1r   <= '0';
    end procedure;
    ----------------------------------------------------
    ----------------------------------------------------
    procedure SendCOML0 is
    begin
      -- COM 11011
      -- L0  01000
      -- =   1011001010
      coml0 <= '1'; WaitClks(1);
      coml0 <= '0'; WaitClks(1);
      coml0 <= '1'; WaitClks(1);
      coml0 <= '1'; WaitClks(1);
      coml0 <= '0'; WaitClks(1);
      coml0 <= '0'; WaitClks(1);
      coml0 <= '1'; WaitClks(1);
      coml0 <= '0'; WaitClks(1);
      coml0 <= '1'; WaitClks(1);
      coml0 <= '0'; WaitClks(1);

    end procedure;
    ----------------------------------------------------
    procedure SendL1R3 is
    begin

      -- L1  10101
      -- R3  11010
      -- =   1101100100
      l1r3 <= '1'; WaitClks(1);
      l1r3 <= '1'; WaitClks(1);
      l1r3 <= '0'; WaitClks(1);
      l1r3 <= '1'; WaitClks(1);
      l1r3 <= '1'; WaitClks(1);
      l1r3 <= '0'; WaitClks(1);
      l1r3 <= '0'; WaitClks(1);
      l1r3 <= '1'; WaitClks(1);
      l1r3 <= '1'; WaitClks(1);
      l1r3 <= '0'; WaitClks(1);


    end procedure;
    ----------------------------------------------------



    -- =======================================================================
  begin

    -- Initialise
    --------------------------------------------------------------------

    com            <= '0';
    l1r            <= '0';
    rst            <= '1';
    Waitclks(10);
    rst            <= '0';
    waitClks(10);
    reg_com_enable <= x"333f";          --all sigs
    reg_control    <= x"0040";          --noise


    for n in 0 to 3 loop

      reg_com_enable <= conv_std_logic_vector(n, 2) & "11" & x"33f";
      waitClks(10);
      SendCOML0;
      waitClks(5);
      SendL1R3;
      waitClks(20);

    end loop;

    waitClks(2000);


    -------------------------------------------
    -- BCO_EN
    reg_com_enable <= x"1000";
    Waitclks(100);


    -------------------------------------------
    -- BCO_INV
    reg_com_enable <= x"1040";
    Waitclks(100);


    -------------------------------------------
    -- DCK_EN
    reg_com_enable <= x"3000";
    Waitclks(100);


    -------------------------------------------
    -- DCLK INV
    reg_com_enable <= x"3080";
    Waitclks(100);


    -------------------------------------------
    -- DCLK MODE40
    reg_control <= x"4000";
    Waitclks(100);


    -------------------------------------------
    --DCLK NON-INV
    reg_com_enable <= x"3000";
    Waitclks(100);


    -------------------------------------------
    --DCLK ONLY 
    reg_com_enable <= x"2000";
    Waitclks(100);


    -------------------------------------------
    --NONE
    reg_com_enable <= x"0000";
    Waitclks(100);



    Waitclks(1000);



    -------------------------------------------
    reg_com_enable <= x"2000";
    SendComTrig;
    Waitclks(100);


    ------------------------------------------
    reg_com_enable <= x"2080";
    SendComTrig;
    Waitclks(500);


    ------------------------------------------

    reg_com_enable <= x"0100";
    SendComTrig;
    Waitclks(100);

    ------------------------------------------

    reg_com_enable <= x"0200";
    SendComTrig;
    Waitclks(500);

    ------------------------------------------

    reg_com_enable <= x"1000";
    SendComTrig;
    Waitclks(100);

    ------------------------------------------

    reg_com_enable <= x"0004";
    SendComTrig;
    Waitclks(100);

    ------------------------------------------

    reg_com_enable <= x"0008";
    SendComTrig;
    Waitclks(300);



    --14
    reg_control <= x"0280";
    SendComTrig;
    Waitclks(300);



    --15a
    reg_com_enable <= x"1000";
    SendComTrig;
    Waitclks(100);

    --15b
    reg_com_enable <= x"0004";
    SendComTrig;
    Waitclks(100);

    -- 16
    reg_com_enable <= x"0008";
    SendComTrig;
    Waitclks(100);


    -- 17
    reg_control <= x"00c0";
    SendComTrig;
    Waitclks(100);



    WaitClks(1000);



    for n in 0 to 99 loop
      SendL1R;
      WaitClks(10);
    end loop;


    wait;

  end process;
end architecture sim;

