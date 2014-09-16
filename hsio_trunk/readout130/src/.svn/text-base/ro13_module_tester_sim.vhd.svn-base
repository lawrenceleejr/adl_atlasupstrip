--
--
--
--
--
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library utils;
use utils.pkg_types.all;
library hsio;
use hsio.pkg_hsio_globals.all;

entity ro13_module_tester is
  port(
    busy_i          : in  std_logic;
    lls_i           : in  t_llsrc;
    bcid_o          : out std_logic_vector (11 downto 0);
    capture_start_o : out std_logic;
    s40_o           : out std_logic;
    clk_o           : out std_logic;
    l1id_o          : out std_logic_vector (23 downto 0);
    lld_o           : out std_logic;
    reg             : out t_reg_bus;
    req_stat_o      : out std_logic;
    rst_o           : out std_logic;
    strm_cmd_o      : out std_logic_vector (15 downto 0);
    strm_reg_o      : out std_logic_vector (15 downto 0);
    ser13data_o     : out std_logic_vector (1 downto 0);
    datagen_rstn_o  : out std_logic;
    mode_abc_o      : out std_logic;
    trig80_o        : out std_logic
    );

-- Declarations

end ro13_module_tester;

--
architecture sim of ro13_module_tester is

  constant POST_CLK_DELAY : time      := 50 ps;
  signal   clk            : std_logic := '0';
  signal   clk160         : std_logic := '0';
  signal   clk40         : std_logic := '0';
  signal   rst            : std_logic := '0';

  signal count16i : integer := 0; 
  signal count16 : std_logic_vector(15 downto 0); 

  signal count3i : integer := 0; 


  signal counter : integer range 0 to 63;
  signal cmod60 : std_logic_vector(3 downto 0);
  
begin

  rst   <= '1', '0' after 1000 ns;
  rst_o <= rst;

  clk   <= not(clk) after 6250 ps;
  clk_o <= clk;

  clk160   <= not(clk160) after 3125 ps;
  clk40   <= not(clk40) after 12500 ps;

  s40_o <= clk40;
  

  prc_counter : process(clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        counter <= 0;
        cmod60  <= (others => '0');

      else
        cmod60(3 downto 1) <= cmod60(2 downto 0);
        
        if (counter = 7) then
          cmod60(0)  <= not(cmod60(0));
          counter <= 0;

        else
          counter <= counter + 1;

        end if;
      end if;
    end if;
  end process;

  
  count3i <= count3i + 1 when (count3i<7) and rising_edge(clk160) else
             0 when rising_edge(clk160);

  count16i <= count16i + 1 when (count3i=7) and rising_edge(clk);
  count16 <= conv_std_logic_vector(count16i,16);  

  --ser13data_o(0) <= count16(count3i*2);
  --ser13data_o(1) <= count16(count3i*2+1);
  ser13data_o(0) <= cmod60(0);
  ser13data_o(1) <= cmod60(0);


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



    --===============================================================
    procedure Test_Datagen160 is
    begin

      datagen_rstn_o <= '0'; WaitClk;
      datagen_rstn_o <= '1'; WaitClk;

      strm_reg_o <= x"0009";            -- data gen 1
      WaitClks(100);

      for n in 0 to 1 loop
        trig80_o <= '1';
        WaitClk;
        trig80_o <= '0';
        WaitClks(2000);
      end loop;

      mode_abc_o <= '1';

      WaitClks(1000);

      for n in 0 to 1 loop
        trig80_o <= '1';
        WaitClk;
        trig80_o <= '0';
        WaitClks(2000);
      end loop;

      mode_abc_o <= '0';

      WaitClks(1000);

    end procedure;

    --===============================================================
    procedure Test_ABC_Datagen80 is
    begin
      strm_reg_o <= x"0105";
      WaitClks(100);

      for n in 0 to 1 loop
        WaitClks(20);

        trig80_o <= '1';
        WaitClk;
        trig80_o <= '0';

        WaitClks(1000);
      end loop;

    end procedure;


    --===============================================================
    procedure Test_Capture is
    begin

      reg(R_LEN0)    <= x"0010";
      reg(R_LEN1)    <= x"0012";
  
      strm_reg_o <= x"0211"; --160Mb ABC Capt
      --strm_reg_o <= x"0311"; --80Mb
      --strm_reg_o <= x"0301"; -- no capt
      WaitClks(100);

      for n in 0 to 1 loop
        capture_start_o <= '1';
        WaitClk;
        capture_start_o <= '0';

        WaitClks(20);

        trig80_o <= '1';
        WaitClk;
        trig80_o <= '0';

        WaitClks(1000);
      end loop;

      WaitClks(1000);

    end procedure;

    --===============================================================



  begin
    ----------------------------------------------
    -- Init

    datagen_rstn_o  <= '0';
    mode_abc_o      <= '0';
    bcid_o          <= (others => '0');
    capture_start_o <= '0';
    l1id_o          <= (others => '0');
    lld_o           <= '1';
    reg             <= (others => (others => '0'));
    req_stat_o      <= '0';

    strm_cmd_o <= (others => '0');
    strm_reg_o <= x"0000";
    trig80_o   <= '0';

    WaitClks(100);

    datagen_rstn_o <= '1';
    reg(R_LEN0)    <= x"0010";
    reg(R_LEN1)    <= x"0010";

    WaitClks(100);

    -----------------------------------------------

    Test_Datagen160;
    --Test_ABC_Datagen80;
    --Test_Capture;


    ---------------------------------------- 
    wait;
  end process;
end architecture sim;

