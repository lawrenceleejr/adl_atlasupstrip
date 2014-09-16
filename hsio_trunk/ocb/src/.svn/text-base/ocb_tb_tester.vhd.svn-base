--
-- OCB Tester
--


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library utils;
use utils.pkg_types.all;

library hsio;
use hsio.pkg_core_globals.all;


entity ocb_tb_tester is
  generic(
    N_OPCODES  :     integer := 1
    );
  port(
    oc_data_o  : out slv16;
    oc_valid_o : out std_logic;
    oc_dtack_i : in  slv32;
    clk_o      : out std_logic;
    rst_o      : out std_logic
    );

-- Declarations

end ocb_tb_tester;

--

architecture sim of ocb_tb_tester is


  constant POST_CLK_DELAY : time      := 50 ps;
  signal   rst            : std_logic := '1';
  signal   clk            : std_logic := '1';

  signal oc_dtack_all    : std_logic;
  signal oc_dtack_masked : slv32;

  signal oc_seqid : slv16                    := x"0000";
  signal payload  : slv16_array(99 downto 0) := (others => x"0000");

  -- for debug
  signal p : integer;


begin

  clk <= not(clk) after 6250 ps;

  clk_o <= clk;
  rst_o <= rst;

  oc_dtack_masked(N_OPCODES-1 downto 0) <= oc_dtack_i(N_OPCODES-1 downto 0);
  oc_dtack_masked(31 downto N_OPCODES)  <= (others => '0');

  oc_dtack_all <= '0' when (oc_dtack_masked = x"00000000") else '1';



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
    procedure WaitDtackClk is
    begin
      if (oc_dtack_all = '0') then      -- this is needed for some reason
        wait until rising_edge(oc_dtack_all);
      end if;
      wait until rising_edge(clk);
      wait for POST_CLK_DELAY;
    end procedure;
    -----------------------------------------------------

    ----------------------------------------------------------
    procedure SendOpcode (opcode : slv16 := x"AACC"; words : integer := 4) is
      variable size_slv          : slv16;
    begin

      oc_seqid   <= oc_seqid + '1';
      oc_valid_o <= '1';

      size_slv := conv_std_logic_vector((words*2), 16);

      -- opcode
      --oc_data_o  <= conv_std_logic_vector(opcode, 16); WaitDtackClk;
      oc_data_o <= opcode;
      WaitDtackClk;
      -- oc_seqid
      oc_data_o <= oc_seqid;
      WaitDtackClk;
      -- size
      oc_data_o <= size_slv;
      WaitDtackClk;

      -- payload
      for zz in 0 to (words-2) loop
        oc_data_o <= payload(zz);
        WaitDtackClk;
      end loop;

      oc_valid_o <= '0';

      oc_data_o <= payload(words-1); WaitDtackClk;
      WaitClks(1);

    end procedure;


    -- =======================================================================
  begin

    -- Initialise
    --------------------------------------------------------------------

    rst <= '1';

    oc_data_o  <= x"0000";
    oc_valid_o <= '0';

    Waitclks(1);
    rst <= '0';

    Waitclks(100);

    payload(0)  <= x"0000";
    payload(1)  <= x"ffff";
    payload(2)  <= x"1234";
    payload(3)  <= x"0003";
    payload(4)  <= x"0004";
    payload(5)  <= x"0005";
    payload(6)  <= x"0006";
    payload(7)  <= x"0007";
    payload(8)  <= x"0008";
    payload(9)  <= x"0009";
    payload(10) <= x"1010";
    payload(11) <= x"1011";
    payload(12) <= x"1012";
    payload(13) <= x"1013";
    payload(14) <= x"1014";
    payload(15) <= x"1015";
    payload(16) <= x"1016";
    payload(17) <= x"1017";
    payload(18) <= x"1018";
    payload(19) <= x"1019";
    payload(20) <= x"2020";
    payload(21) <= x"2120";
    payload(22) <= x"2220";
    payload(23) <= x"2320";
    payload(24) <= x"2420";
    payload(25) <= x"2520";
    payload(26) <= x"2620";
    payload(27) <= x"2720";
    payload(28) <= x"2820";
    payload(29) <= x"2920";
    payload(30) <= x"3030";


    payload(0) <= x"0005";
    payload(1) <= x"1001";
    payload(2) <= x"0006";
    payload(3) <= x"2002";
    payload(4) <= x"0007";
    payload(5) <= x"3003";

    payload(6) <= x"0005";
    payload(7) <= x"1ff1";
    payload(8) <= x"0006";
    payload(9) <= x"2ff2";
    payload(10) <= x"0007";
    payload(11) <= x"3ff3";



     
    for n in 0 to 15 loop
      payload(0)     <= conv_std_logic_vector(2**n, 16);
      SendOpcode(OC_COMMAND, 1);
    WaitClks(10);
    end loop;

    WaitClks(1000);
    
--     for n in 1 to 10 loop

--       payload(0) <= x"0000";
--       payload(1) <= x"0000";
--       SendOpcode(OC_MONREAD_TOP, 3);
--       WaitClks(200000);

--     end loop;

    WaitClks(1000);



    -- load mask
    for n in 0 to 6 loop
      payload(n)     <= conv_std_logic_vector(16#f000# + n, 16);
    end loop;
    payload(7) <= x"f00f";
    SendOpcode(OC_BSTRM_COMMAND, 8);
    WaitClks(100);

    payload(7) <= x"abcd";
    SendOpcode(OC_BSTRM_CONF_WR, 9);

    WaitClks(1000);

    

    payload(0) <= x"000a";
    payload(1) <= x"a00a";
    payload(2) <= x"000b";
    payload(3) <= x"b00b";
    payload(4) <= x"000c";
    payload(5) <= x"c00c";
    
    SendOpcode(OC_STRM_COMMAND, 6);
    WaitClks(100);

    payload(0) <= x"0001";
    payload(1) <= x"0010";
    SendOpcode(OC_STRM_COMMAND, 2);
    WaitClks(100);

    payload(0) <= x"0002";
    payload(1) <= x"0100";
    SendOpcode(OC_STRM_COMMAND, 2);
    WaitClks(100);


    WaitClks(1000);

    
    


    payload(0) <= x"ffff";
    payload(1) <= x"0000";
    payload(2) <= x"1234";
    SendOpcode(OC_STRM_CONF_WR, 3);
    WaitClks(100);

    payload(0) <= x"00ff";
    payload(1) <= x"0000";
    payload(2) <= x"abcd";
    SendOpcode(OC_STRM_CONF_WR, 3);
    WaitClks(100);

    payload(0) <= x"ff00";
    payload(1) <= x"0000";
    payload(2) <= x"abcd";
    SendOpcode(OC_STRM_CONF_WR, 3);
    WaitClks(100);

    payload(0) <= x"ffff";
    payload(1) <= x"0001";
    payload(2) <= x"1111";
    SendOpcode(OC_STRM_CONF_WR, 3);
    WaitClks(100);

    payload(0) <= x"ffff";
    payload(1) <= x"0002";
    payload(2) <= x"2222";
    SendOpcode(OC_STRM_CONF_WR, 3);
    WaitClks(100);

    payload(0) <= x"ffff";
    payload(1) <= x"0003";
    payload(2) <= x"3333";
    SendOpcode(OC_STRM_CONF_WR, 3);
    WaitClks(100);

    payload(0) <= x"ffff";
    payload(1) <= x"0000";
    payload(2) <= x"0000";
    SendOpcode(OC_STRM_CONF_WR, 3);


    WaitClks(1000);


    payload(0) <= x"ffff";

    for n in 0 to 15 loop

      payload(1+(n*2))     <= conv_std_logic_vector(n, 16);
      payload(1+(n*2)+1) <= conv_std_logic_vector((255-n)*16#100#+n, 16);

    end loop;


    SendOpcode(OC_STRM_CONF_WR, 33);
    WaitClks(100);


    wait;

  end process;

end architecture sim;

