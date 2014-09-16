--
-- VHDL Architecture hsio.idelay_block_tester.sim
--
-- Created:
--          by - warren.man (pc140.hep.ucl.ac.uk)
--          at - 17:00:43 07/02/10
--
-- using Mentor Graphics HDL Designer(TM) 2008.1b (Build 7)
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity idelay_block_tester is
  port(

    clk_out     : out std_logic;
    clk200      : out std_logic;
    ddrdata     : out std_logic;
    reg_idelay   : out std_logic_vector(15 downto 0);
    rwr_idelay  : out std_logic;
    rst_out     : out std_logic;
    stream0   : in  std_logic;
    stream1   : in  std_logic
    );

-- Declarations

end idelay_block_tester;

--
architecture sim of idelay_block_tester is

  signal clk : std_logic := '1';
  signal c200 : std_logic := '0';
  signal rst : std_logic := '1';

  signal ddrdata_int : std_logic := '1';


  signal testdata0 : std_logic_vector(19 downto 0) := "00000000000000000001";
  signal testdata1 : std_logic_vector(19 downto 0) := "00000000000000000001";

  signal indata0 : std_logic_vector(15 downto 0):= x"ffff";
  signal indata1 : std_logic_vector(15 downto 0):= x"ffff";

  signal outdatac0 : std_logic_vector(15 downto 0);
  signal outdatac1 : std_logic_vector(15 downto 0);

  signal error0 : std_logic;
  signal error1 : std_logic;

  signal idelay_val_int : integer;
  signal idelay_addr_int : integer;
  
begin

  clk <= not(clk) after 6250 ps;
  c200 <= not(c200) after 2500 ps;

  clk_out <= clk;
  clk200 <= c200;
  rst_out <= rst;

  reg_idelay <= "0000" &
                conv_std_logic_vector(idelay_addr_int, 4) &
                "00" &
                conv_std_logic_vector(idelay_val_int, 6);


  
  testdata0 <= testdata0(18 downto 0) & testdata0(19) after 12500 ps;
  testdata1 <= testdata1(18 downto 0) & testdata1(19) after 12500 ps;

  ddrdata_int <= testdata0(14) when clk = '0' else testdata1(14);
  ddrdata <= ddrdata_int; -- after 50 ps;

  indata0 <= (indata0(14 downto 0) & stream0) after 12500 ps;
  indata1 <= (indata1(14 downto 0) & stream1) after 12500 ps;

--  outdatac0 <= testdata0(31 downto 16);
--  outdatac1 <= testdata1(31 downto 16);
  

  prc_error_clk : process (clk)
    begin
      if falling_edge(clk) then
        error0 <= '1';
        if ( indata0 = outdatac0) then
          error0 <= '0';
        end if;

        error1 <= '1';
        if ( indata1 = outdatac1) then
          error1 <= '0';
        end if;


     end if;
  end process;
  
        
  ----------------------------------------------------------------------------
  simulation                  :    process
    --------------------------------------------------
    -- Procedures 
    --------------------------------------------------
    procedure WaitClk is
    begin
      wait until rising_edge(clk);
      wait for 100 ps;
    end procedure;
    ----------------------------------------------------
    procedure WaitClks (nclks : in integer) is
    begin
      for waitclkloops in 1 to nclks loop
        wait until rising_edge(clk);
        wait for 100 ps;
      end loop;
    end procedure;
    ----------------------------------------------------


    -- =======================================================================
  begin

    -- Initialise
    --------------------------------------------------------------------

    --idelay_ce   <= '0';
    --idelay_inc  <= '0';
    --idelay_zero <= '0';
    rst             <= '1';

    WaitClks(10);

    rst <= '0';

    WaitClks(300);

   -- Go!
    ----------------------------------------

  idelay_addr_int <= 0;
  
  for d in 0 to 8 loop
    
    idelay_val_int <= d;
    rwr_idelay <= '1';
    WaitClks(1);
    rwr_idelay <= '0';

    WaitClks(200);

 end loop;
    
    
    idelay_val_int <= 16;
    rwr_idelay <= '1';
    WaitClks(1);
    rwr_idelay <= '0';

    WaitClks(200);

    
    idelay_val_int <= 32;
    rwr_idelay <= '1';
    WaitClks(1);
    rwr_idelay <= '0';


    
    
    

    

   -- for n in 1 to 5 loop

   --   idelay_zero <= '1';
   --   WaitClks(100);
   --   idelay_zero <= '0';
   --   WaitClks(1);

   --   for nn in 1 to n*10 loop
        
   --     idelay_ce   <= '1';
   --     idelay_inc  <= '1';
   --     WaitClks(1);

   --   end loop;
   --   idelay_ce   <= '0';
   --   WaitClks(1000);
   --   end loop;
     

   --WaitClks(1000);
      
   -- for n in 1 to 5 loop

   --   idelay_zero <= '1';
   --   WaitClks(100);
   --   idelay_zero <= '0';
   --   WaitClks(1);

   --   for nn in 1 to n*10 loop
        
   --     idelay_ce   <= '1';
   --     idelay_inc  <= '0';
   --     WaitClks(1);

   --   end loop;
   --   idelay_ce   <= '0';
      
   --   end loop;
      
      



    wait;

  end process;


end architecture sim;

