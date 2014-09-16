--
-- abc_emu.abc130_top_tester.sim
--
-- Tester to drive ABC130 digital part simulation
--
-- Matt Warren, UCL
--
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity abc130_top_tester is
  port(
    clk80_o          : out std_logic;
    com_o            : out std_logic;
    l0_o             : out std_logic;
    l1_o             : out std_logic;
    r3s_o            : out std_logic;
    abc_powerUpRstb  : out std_logic;
    abc_RST          : out std_logic;
    abc_RSTB         : out std_logic;
    abc_BC           : out std_logic;
    abc_CLK          : out std_logic;
    abc_DIN          : out std_logic_vector (255 downto 0);
    abc_FastCLK      : out std_logic;
    abc_FastCLK_div2 : out std_logic;
    abc_DATL         : out std_logic;
    abc_padID1       : out std_logic_vector (4 downto 0);
    abc_padID2       : out std_logic_vector (4 downto 0);
    abc_padID3       : out std_logic_vector (4 downto 0);
    abc_padID4       : out std_logic_vector (4 downto 0);
    abc_padID5       : out std_logic_vector (4 downto 0);
    abc_padTerm      : out std_logic
    );

-- Declarations

end abc130_top_tester;

--
architecture sim of abc130_top_tester is

  signal rst : std_logic;

  constant POST_BC_DELAY : time      := 50 ps;
  signal   clk40         : std_logic := '1';
  signal   clk80         : std_logic := '1';
  signal   clk160        : std_logic := '1';
  signal   clk320        : std_logic := '1';
  signal   clk640        : std_logic := '1';
  signal   bc            : std_logic;

  signal strips_data : std_logic_vector(255 downto 0) :=
    x"0000000000000000000000000000000000000000000000000000000000001111";

  signal strips0_d16 : std_logic_vector(15 downto 0);
  signal strips1_d16 : std_logic_vector(15 downto 0);

  type t_dest is (Dflt, Idle, BCR, ECP, SRST, SEUR, HCC, ABC);
  type t_sigport is (p_L0, p_L1, p_R3s, p_COM);

  constant RD : integer := 0;
  constant WR : integer := 1;

  constant BCAST : integer := 16#1F#;

  signal com : std_logic;

  signal l0  : std_logic;
  signal l1  : std_logic;
  signal r3s : std_logic;

  signal l0_delay : std_logic_vector(4 downto 0);


  -- SCReg bits
  --------------------------------------------------------
  constant SCCalPulse     : integer := 16#01#;
--constant SCDigitalPulse : integer := 16#02#;  -- not impl.
  constant SCHPRClear     : integer := 16#04#;
--constant reserved : integer := 16#08#;
  constant SCWriteDisable : integer := 16#10#;


  -- Register Map
  --------------------------------------------------------
  constant SCReg      : integer := 16#00#;
  constant ADCS1      : integer := 16#01#;
  constant ADCS2      : integer := 16#02#;
  constant ADCS3      : integer := 16#03#;
  constant ADCS4      : integer := 16#04#;
  constant ADCS5      : integer := 16#05#;
  constant ADCS6      : integer := 16#06#;
  constant ADCS7      : integer := 16#07#;
  constant ADCS8      : integer := 16#08#;
  constant MaskInput0 : integer := 16#10#;
  constant MaskInput1 : integer := 16#11#;
  constant MaskInput2 : integer := 16#12#;
  constant MaskInput3 : integer := 16#13#;
  constant MaskInput4 : integer := 16#14#;
  constant MaskInput5 : integer := 16#15#;
  constant MaskInput6 : integer := 16#16#;
  constant MaskInput7 : integer := 16#17#;
  constant RegInput0  : integer := 16#18#;
  constant RegInput1  : integer := 16#19#;
  constant RegInput2  : integer := 16#1a#;
  constant RegInput3  : integer := 16#1b#;
  constant RegInput4  : integer := 16#1c#;
  constant RegInput5  : integer := 16#1d#;
  constant RegInput6  : integer := 16#1e#;
  constant RegInput7  : integer := 16#1f#;
  constant CREG0      : integer := 16#20#;
  constant CREG1      : integer := 16#21#;
  constant CREG2      : integer := 16#22#;
  constant CREG3      : integer := 16#23#;
  constant STAT0      : integer := 16#30#;
  constant STAT1      : integer := 16#31#;
  constant STAT2      : integer := 16#32#;
  constant STAT3      : integer := 16#33#;
  constant STATF      : integer := 16#3F#;
  constant aCSR       : integer := 16#3F#;
  constant CalEn0     : integer := 16#68#;
  constant CalEn1     : integer := 16#69#;
  constant CalEn2     : integer := 16#6a#;
  constant CalEn3     : integer := 16#6b#;
  constant CalEn4     : integer := 16#6c#;
  constant CalEn5     : integer := 16#6d#;
  constant CalEn6     : integer := 16#6e#;
  constant CalEn7     : integer := 16#6f#;


begin

  com_o <= com;
  l0_o  <= l0;
  l1_o  <= l1;
  r3s_o <= r3s;


  clk40  <= not(clk40)  after 12512 ps;  -- used integer number of clk640's
  clk80  <= not(clk80)  after 6256 ps;   -- to keep all syncro at 1ps timing
  clk160 <= not(clk160) after 3128 ps;   -- 3125
  clk320 <= not(clk320) after 1564 ps;   -- 1562.5
  clk640 <= not(clk640) after 782 ps;    -- 781.25

  bc <= clk40;
  clk80_o <= clk80;

  abc_BC           <= bc;
  abc_CLK          <= clk80; --clk160;
  abc_FastCLK      <= clk80;
  abc_FastCLK_div2 <= clk40;

  abc_RST  <= rst;
  abc_RSTB <= not(rst);


  -- Generate simple strips stimulus
  prc_strips_data_gen : process (bc)
  begin
    if rising_edge(bc) then

      l0_delay <= l0_delay(3 downto 0) & l0;

      if (l0_delay(4) = '1') then
        --if (l0 = '1') then
        strips_data <= strips_data(254 downto 0) & strips_data(255);
      end if;
    end if;
  end process;

  abc_DIN <= strips_data;

  sd16_gen : for n in 0 to 15 generate
  begin

    strips0_d16(n) <= strips_data(n*2);
    strips1_d16(n) <= strips_data(n*2+1);
  end generate;

  ----------------------------------------------------------------------------
  simulation : process
    --------------------------------------------------
    -- Procedures 
    --------------------------------------------------
    procedure WaitBC(nbcs       : in integer := 1) is
      begin
        for waitclkloops in 1 to nbcs loop
          wait until rising_edge(bc);
        end loop;
      wait for POST_BC_DELAY;
    end procedure;
    ----------------------------------------------------
    procedure SendHardReset is
    begin
      rst                   <= '1';
      WaitBC(20);
      rst                   <= '0';
      WaitBC;
    end procedure;
    ----------------------------------------------------------------
    procedure SendSer(sigport     :    t_sigport; serdat, len : integer) is
      variable serdat_slv         :    std_logic_vector(31 downto 0);
    begin
      serdat_slv                               := conv_std_logic_vector(serdat, 32);
      for b in 0 to (len-1) loop
        case sigport is
          when p_L0  => l0  <= serdat_slv(len-b-1);
          when p_L1  => l1  <= serdat_slv(len-b-1);
          when p_R3s => r3s <= serdat_slv(len-b-1);
          when p_COM => com <= serdat_slv(len-b-1);
        end case;
        WaitBC;
      end loop;
    end procedure;
    ----------------------------------------------------
    procedure SendHeaderCom (dest :    t_dest) is
    begin
      case dest is
        when Dflt    => SendSer(p_COM, 2#10100000#, 8);
        when Idle    => SendSer(p_COM, 2#10100011#, 8);
        when BCR     => SendSer(p_COM, 2#10100101#, 8);
        when ECP     => SendSer(p_COM, 2#10100110#, 8);
        when SRST    => SendSer(p_COM, 2#10101001#, 8);
        when SEUR    => SendSer(p_COM, 2#10101010#, 8);
        when HCC     => SendSer(p_COM, 2#10111101#, 8);
        when ABC     => SendSer(p_COM, 2#10111110#, 8);
      end case;
    end procedure;
    ----------------------------------------------------
    procedure SendShortCom (dest  :    t_dest) is
    begin
      SendHeaderCom(dest);
      SendSer(p_COM, 0, 1);
    end procedure;
    ----------------------------------------------------    
    procedure SendLongCom(dest    :    t_dest; hccid, abcid, addr, rdwr, dat : integer) is
    begin
      WaitBC;
      SendSer(p_COM, 0, 1);             -- not sure this should be needed
      SendHeaderCom(dest); -- 8 bits
      SendSer(p_COM, hccid, 5);
      SendSer(p_COM, abcid, 5);
      SendSer(p_COM, addr, 7);
      SendSer(p_COM, rdwr, 1);
      SendSer(p_COM, dat, 32);
      SendSer(p_COM, 0, 1);
    end procedure;
    -----------------------------------------------------------
    procedure SendL0(n            :    integer := 1) is
    begin
      for i in 1 to n loop
        l0                  <= '1';
        WaitBC;
        l0                  <= '0';
        WaitBC(31);
      end loop;
    end procedure;
    --------------------------------------------------------------
    procedure SendL1(l0id         :    integer) is
    begin
      SendSer(p_L1, 2#0110#, 4);
      SendSer(p_L1, l0id, 8);
      SendSer(p_L1, 0, 1);
    end procedure;
    --------------------------------------------------------------
    procedure SendR3s(l0id        :    integer) is
    begin
      SendSer(p_R3s, 2#0101#, 4);
      SendSer(p_R3s, l0id, 8);
      SendSer(p_R3s, 0, 1);
    end procedure;
    --------------------------------------------------------------
    --------------------------------------------------------------
    procedure Initialise is
    begin
      rst                   <= '1';
      abc_padID1            <= "00001";
      abc_padID2            <= "00010";
      abc_padID3            <= "00011";
      abc_padID4            <= "00100";
      abc_padID5            <= "00101";
      abc_padTerm           <= '0';
      abc_DATL              <= '0';
      l0                    <= '0';
      com                   <= '0';
      l1                    <= '0';
      r3s                   <= '0';
      abc_powerUpRstb       <= '0';
      WaitBC(100);
      abc_powerUpRstb       <= '1';
      WaitBC(10);      
      rst                   <= '0';
      WaitBC(10);

   end procedure;
    --------------------------------------------------------------
    procedure ABC130Init is
    begin
      
      SendHardReset;
      WaitBC(100);

      SendShortCom(BCR);                -- Bunch Counter Reset
      WaitBC(100);

      SendShortCom(ECP);                -- L0ID Preset
      WaitBC(100);

      SendShortCom(SRST);               -- Soft Reset
      WaitBC(100);


      -- Default Chip setup
      for n in 0 to 2 loop
        SendLongCom(ABC, BCAST, n, CREG0, WR, 16#00001F10#+n);  -- en fcf, ena fifos, dir, set priority
        WaitBC(100);
      end loop;

      SendLongCom(ABC, BCAST, BCAST, CREG2, WR, 16#02#);  -- write L0 pipe latency 2
      WaitBC(100);

      SendLongCom(ABC, BCAST, BCAST, CREG3, WR, 16#04#);  -- L1-1BC mode
      WaitBC(100);

    end procedure;

    --------------------------------------------------------------

    procedure ReadbackRegs is
    begin

      SendLongCom(ABC, BCAST, BCAST, CREG0, RD, 0);
      WaitBC(100);

      SendLongCom(ABC, BCAST, BCAST, CREG1, RD, 0);
      WaitBC(100);

      SendLongCom(ABC, BCAST, BCAST, CREG2, RD, 0);
      WaitBC(100);

      SendLongCom(ABC, BCAST, BCAST, CREG3, RD, 0);
      WaitBC(100);

    end procedure;

    --------------------------------------------------------------

    procedure TMUTest is
    begin

        SendLongCom(ABC, BCAST, BCAST, 112, RD, 0);  -- DRV VERSION
        SendLongCom(ABC, BCAST, BCAST, 113, RD, 0);  -- DRV STATUS0
        SendLongCom(ABC, BCAST, BCAST, 116, RD, 0);  -- DRV CONFIG
        SendLongCom(ABC, BCAST, BCAST, 117, RD, 0);  -- DRV DIRECTION
        SendLongCom(ABC, BCAST, BCAST, 118, RD, 0);  -- DRV MODE_SIGS
        SendLongCom(ABC, BCAST, BCAST, 119, RD, 0);  -- DRV MODE_DX
        SendLongCom(ABC, BCAST, BCAST, 120, RD, 0);  -- DRV MODE_HDXIN


        SendLongCom(ABC, BCAST, BCAST, 118, WR, 16#4000000#);  -- DRV MODE_HDXIN
        SendLongCom(ABC, BCAST, BCAST, 118, RD, 0);  -- DRV MODE_HDXIN
        SendLongCom(ABC, BCAST, BCAST, 118, RD, 0);  -- DRV MODE_HDXIN
        SendLongCom(ABC, BCAST, BCAST, 118, RD, 0);  -- DRV MODE_HDXIN
                


      WaitBC(1000);

      for n in 0 to 7 loop
        SendLongCom(ABC, BCAST, BCAST, n+120, WR, (n+8)*16#10000#+n);
        WaitBC(100);
      end loop;

      WaitBC(500);
      
      for n in 0 to 7 loop
        SendLongCom(ABC, BCAST, BCAST, n+120, RD, 0);
        WaitBC(100);
      end loop;

      WaitBC(500);
      
      for n in 0 to 31 loop
        SendLongCom(ABC, BCAST, n, 1, WR, 0);
        WaitBC(100);
      end loop;

      WaitBC(100);

    end procedure;

    --------------------------------------------------------------
    procedure CalEn_Test is
    begin

      SendShortCom(ECP);                -- L0ID Preset
      WaitBC(100);

      SendLongCom(ABC, BCAST, BCAST, CalEn0, WR, 16#ffffffff#);

      for p in 0 to 99 loop

        SendLongCom(ABC, BCAST, BCAST, CREG2, WR, p);  -- write L0 pipe latency
        WaitBC(256);

        SendLongCom(ABC, BCAST, BCAST, SCReg, WR, SCCalPulse);  -- Special Command reg
        WaitBC(20);                    -- delay wrt CAL = 8 + delay
        SendL0(1);
        WaitBC(10);

      end loop;


      for n in 0 to 99 loop
        SendL1(n);
      end loop;

    end procedure;

    --------------------------------------------------------------
    procedure TrigLong ( nloops : integer := 99) is
    begin
      -- L1 @ 200kHz = 200 BC period
      -- R3 @  50lHz = 800 BC period

      for m in 0 to nloops loop
        for n in 0 to 63 loop
          SendL0(4);
          SendL1(n*4);
          WaitBC(100-13-32);
          SendL1((n*4)+1);
          WaitBC(300-13-32);
          SendL1((n*4)+2);
          WaitBC(350-13-64);
          SendL1((n*4)+3);
          SendR3s(n*4+3);
          WaitBC(50-13-13);
        end loop;
      end loop;

      WaitBC(10000);

      for n in 0 to nloops loop
        SendR3s(n);
        WaitBC(500);
      end loop;

      WaitBC(2000);

    end procedure;

    --------------------------------------------------------------
    procedure Triggers ( nloops : integer := 10) is
    begin

      SendL0(10);

      for n in 0 to nloops loop
        SendL1(n);
        WaitBC(200);
      end loop;

      WaitBC(1000);

      for n in 0 to nloops loop
        SendR3s(n);
        WaitBC(200);
      end loop;

      WaitBC(1000);

      SendL0(100);

      SendShortCom(ECP);                -- L0ID Preset

      SendL0(100);

      WaitBC(1000);

      for n in 0 to nloops loop
        SendL1(n);
        WaitBC(20);
      end loop;

      WaitBC(1000);

      for n in 0 to nloops loop
        SendR3s(n);
        WaitBC(20);
      end loop;

      WaitBC(1000);

    end procedure;

--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==  --==
  begin
--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==  --==

    
    Initialise;

    --ABC130Init;

    TMUTest;


    WaitBC(300);

    --ReadbackRegs;

    --CalEn_Test;

    --Triggers(10);

    --TrigLong(99);


    wait;
  end process;
  -------------------------------------------------

end architecture sim;

