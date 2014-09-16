--
-- TMU Too Command Decoder
--
-- Matt Warren, UCL
--
-- Deserialises ABC130 (and later HCC) command streams
-- 
--
-- Log:
-- 26/11/2013 - Birthday
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library utils;
use utils.pkg_types.all;

entity tmu_too is
  generic(
    ABC_ID        :     integer := 0;
    HCC_ID        :     integer := 0;
    ABC_nHCC_MODE :     integer := 0
    );
  port(
    ser_i         : in  std_logic;
    ddrtx_o       : out std_logic_vector (1 downto 0);
    reg_o         : out slv32_array (127 downto 0);
    stat_i        : in  slv32_array (127 downto 0);
    clk           : in  std_logic;
    rst           : in  std_logic
    );

-- Declarations

end tmu_too;


architecture rtl of tmu_too is


  type t_reg_attr is (Ro, Wo, RW, na);
  type t_reg_attr_array is array (natural range <>) of t_reg_attr;

  -- Regblock attributes:
  -----------------------
  --  Ro  Read Only - aka status
  --  Wo  Write Only - aka command or pulse
  --  RW  Read/Write - normal register
  --  na  Not Available - not implemented


  constant REG_ATTR : t_reg_attr_array(127 downto 0) := (
    --f   e   d   c   b   a   9   8   7   6   5   4   3   2   1   0
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    na, na, na, na, na, na, na, RW, RW, RW, RW, RW, Ro, Ro, Ro, Ro,  -- 7 127-112
    na, na, na, na, na, na, na, na, na, na, na, na, na, na, na, na,  -- 6 111-96
    na, na, na, na, na, na, na, na, na, na, na, na, na, na, na, na,  -- 5  95-80
    na, na, na, na, na, na, na, na, na, na, na, na, na, na, na, na,  -- 4  64-79
    na, na, na, na, na, na, na, na, na, na, na, na, na, na, na, na,  -- 3  48-63
    na, na, na, na, na, na, na, na, na, na, na, na, na, na, na, na,  -- 2  32-47
    na, na, na, na, na, na, na, na, na, na, na, na, na, na, na, na,  -- 1  16-31
    na, na, na, na, na, na, na, na, na, na, na, na, na, na, na, na  -- 0   0-15
    );

  constant Z : slv32 := x"00000000";
  constant REG_INIT_VAL : slv32_array(127 downto 0) := (
     Z,  Z,  Z,  Z,  Z,  Z,  Z,

    x"00003210",                       --120 -- MODE_HDXIN
    x"cccc3210",                       --119 -- MODE_DX
    x"00000020",                       --118 -- MODE_SIGS
    x"0000000f",                       --117 -- DIRECTION
    x"00000400",                       --116 -- CONFIG
     Z,                                 --115 -- STATUS2 (Ro)
     Z,                                 --114 -- STATUS1 (Ro)
     Z,                                 --113 -- STATUS0 (Ro)
     Z,                                 --112 -- VERSION (Ro)
    -- 7 127-112
    --f   e   d   c   b   a   9   8   7   6   5   4   3   2   1   0
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
     Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  -- 6 111-96
     Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  -- 5  95-80
     Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  -- 4  64-79
     Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  -- 3  48-63
     Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  -- 2  32-47
     Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  -- 1  16-31
     Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z,  Z   -- 0   0-15
    );


  signal sr         : slv64;
  signal ser_q      : sl;
  signal ser_rising : sl;

  signal reg_addr     : slv7;
  signal reg_addr_int : integer range 0 to 127;
  signal reg_addr_map : std_logic_vector(127 downto 0);
  signal reg_addr_we  : sl;

  signal reg_data    : slv32_array(127 downto 0);
  signal REG_INIT    : slv32_array(127 downto 0);
  signal reg_data_we : sl;
  signal reg_data_oe : sl;


  constant ABC_MODE   : slv1 := conv_std_logic_vector(ABC_nHCC_MODE, 1);
  constant HCC_ID_SLV : slv5 := conv_std_logic_vector(HCC_ID, 5);
  constant ABC_ID_SLV : slv5 := conv_std_logic_vector(ABC_ID, 5);


  signal   bcount     : integer range 0 to 63;
  constant BCOUNT_MAX : integer := 63;
  signal   bcount_clr : std_logic;

  constant BC_START   : integer := -1;
  constant BC_HEADER  : integer := 4 + BC_START;
  constant BC_TYPEP   : integer := 4 + BC_HEADER;
  constant BC_HCCID   : integer := 5 + BC_TYPEP;
  constant BC_ABCID   : integer := 5 + BC_HCCID;
  constant BC_REGADDR : integer := 7 + BC_ABCID;
  constant BC_RW      : integer := 1 + BC_REGADDR;
  constant BC_DATA    : integer := 32 + BC_RW;
  constant BC_END     : integer := 1 + BC_DATA;

  signal dbg_header  : slv4;
  signal dbg_typep   : slv4;
  signal dbg_hccid   : slv5;
  signal dbg_abcid   : slv5;
  signal dbg_regaddr : slv7;
  signal dbg_rw      : slv1;
  signal dbg_data    : slv32;

  signal dbg_header_we  : sl;
  signal dbg_typep_we   : sl;
  signal dbg_hccid_we   : sl;
  signal dbg_abcid_we   : sl;
  signal dbg_regaddr_we : sl;
  signal dbg_rw_we      : sl;
  signal dbg_data_we    : sl;

  constant DOFFS : integer := -1;       -- dbg signal sr offset

  constant TX_BCOUNT_MAX : integer := 30;

  signal pkt     : slv64;
  signal dbg_pkt : slv64;
  signal pkt_rev : slv64;
  signal pkt0    : slv32;
  signal pkt1    : slv32;

  signal ddrtx  : slv2;
  signal txtyp  : slv4;
  signal txdata : slv32;

  type states is (
    Header,
    FastCommand, LongCommand,
    HCCIDField, ABCIDField,
    RegAddress, RegReadWrite,
    RegData, IgnoreRest,
    SendReadPacket, SendSerialise,
    Idle
    );

  signal state, nstate : states;

begin

  gen_reg_init : for n in 0 to 127 generate
    REG_INIT(n) <= (others => '0') when (REG_ATTR(n) = Wo) else REG_INIT_VAL(n);
    --REG_INIT(n) <= (others => '0') when (REG_ATTR(n) = Wo) else conv_std_logic_vector(n, 32);
  end generate;


  prc_sr : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        sr    <= (others => '0');
        ser_q <= '0';
      else
        ser_q <= ser_i;                 -- add one more for nicer sr bit numbering
        sr    <= sr(62 downto 0) & ser_q;
      end if;
    end if;
  end process;

  ser_rising <= '1' when ((sr(0) = '0') and (ser_q = '1')) else '0';


  ---------------------------------------------------------------
  -- Deser Machine
  ---------------------------------------------------------------

  prc_sm_deser_sync : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        state <= Idle;
      else
        state <= nstate;

      end if;
    end if;
  end process;

  prc_sm_deser_async : process (ser_rising, bcount, sr, state, reg_addr_int)
  begin

    -- defaults
    bcount_clr  <= '0';
    reg_addr_we <= '0';
    reg_data_we <= '0';
    reg_data_oe <= '0';

    dbg_header_we  <= '0';
    dbg_typep_we   <= '0';
    dbg_hccid_we   <= '0';
    dbg_abcid_we   <= '0';
    dbg_regaddr_we <= '0';
    dbg_rw_we      <= '0';
    dbg_data_we    <= '0';

    ddrtx <= "00";


    case state is

      when Idle =>
        nstate     <= Idle;
        bcount_clr <= '1';
        if (ser_rising = '1') then
          nstate   <= Header;
        end if;


      when Header       =>
        nstate                    <= Header;
        if (bcount = BC_HEADER) then
          dbg_header_we           <= '1';
          case sr(3 downto 0) is
            when "1010" => nstate <= FastCommand;
            when "1011" => nstate <= LongCommand;
            when others => nstate <= Idle;
          end case;
        end if;


      when FastCommand =>
        -- placeholder for future
        nstate <= IgnoreRest;


      when LongCommand =>
        nstate         <= LongCommand;
        if (bcount = BC_TYPEP) then
          dbg_typep_we <= '1';
          if (ABC_MODE = "1") and sr(3 downto 0) = "1110" then
            nstate     <= HCCIDField;
          elsif (ABC_MODE = "0") and sr(3 downto 0) = "1101" then
            nstate     <= HCCIDField;
          else
            nstate     <= IgnoreRest;
          end if;
        end if;


      when HCCIDField =>
        nstate         <= HCCIDField;
        if (bcount = BC_HCCID) then
          dbg_hccid_we <= '1';
          if (sr(4 downto 0) = "11111") then
            nstate     <= ABCIDField;
          elsif (sr(4 downto 0) = HCC_ID_SLV) then
            nstate     <= ABCIDField;
          else
            nstate     <= IgnoreRest;
          end if;
        end if;


      when ABCIDField =>
        nstate         <= ABCIDField;
        if (bcount = BC_ABCID) then
          dbg_abcid_we <= '1';
          if (ABC_MODE = "0") then
            nstate     <= RegAddress;
          else
            if (sr(4 downto 0) = "11111") then
              nstate   <= RegAddress;
            elsif (sr(4 downto 0) = ABC_ID_SLV) then
              nstate   <= RegAddress;
            else
              nstate   <= IgnoreRest;
            end if;
          end if;
        end if;


      when RegAddress =>
        nstate           <= RegAddress;
        if (bcount = BC_REGADDR) then
          dbg_regaddr_we <= '1';
          reg_addr_we    <= '1';
          nstate         <= RegReadWrite;
        end if;


      when RegReadWrite =>
        nstate                    <= RegData;
        dbg_rw_we                 <= '1';
        if (sr(0) = '0') then
          case REG_ATTR(reg_addr_int) is
            when Ro     => nstate <= SendReadPacket;
            when RW     => nstate <= SendReadPacket;
            when others => null;
          end case;
        end if;



      when RegData      =>
        nstate                         <= RegData;
        if (bcount = BC_DATA) then
          dbg_data_we                  <= '1';
          case REG_ATTR(reg_addr_int) is
            when Wo     => reg_data_oe <= '1';
            when RW     => reg_data_we <= '1';
            when others => null;
          end case;
          nstate                       <= IgnoreRest;
        end if;


      when IgnoreRest =>
        nstate   <= IgnoreRest;
        if (bcount >= BC_END) then
          nstate <= Idle;
        end if;


        ------------------------------------------------------
        -- TX - Register Read

      when SendReadPacket =>
        bcount_clr <= '1';
        nstate     <= SendSerialise;


      when SendSerialise =>
        nstate <= SendSerialise;

        ddrtx(0) <= pkt0(bcount);
        ddrtx(1) <= pkt1(bcount);

        if (bcount >= TX_BCOUNT_MAX) then
          nstate <= Idle;
        end if;


    end case;
  end process;

  --txtyp  <= "1001"               when (REG_ATTR(reg_addr_int) = Ro) else "1000";
  txtyp  <= "1000";
  txdata <= stat_i(reg_addr_int) when (REG_ATTR(reg_addr_int) = Ro) else reg_data(reg_addr_int);


  pkt_rev(63 downto 60) <= "0000";      --  padding
  pkt_rev(59)           <= '1';         -- start bit  --  1 start bit = 1
  pkt_rev(58 downto 54) <= ABC_ID_SLV;  --  5 chipid
  pkt_rev(53 downto 50) <= txtyp;       --  4 typ  1000=read reg, 1001=read stat
  pkt_rev(49 downto 42) <= '0' & reg_addr;  --  8 l0id/regaddr
  pkt_rev(41 downto 34) <= "00000000";  --  8 bcid/unused=0
  pkt_rev(33 downto 2)  <= txdata;      -- 32 datawd
  pkt_rev(1)            <= '0';         --  1 overflow
  pkt_rev(0)            <= '0';         --  1 stop bit

  dbg_pkt <= pkt_rev(62 downto 0) & '0';  -- aligns with trailing zero packet det
                                        -- in decoder


  gen_pkt01 : for n in 0 to 29 generate
    pkt(59-(n*2))   <= pkt_rev(n*2);
    pkt(59-(n*2+1)) <= pkt_rev(n*2+1);

    pkt0(n) <= pkt(n*2);
    pkt1(n) <= pkt(n*2+1);
  end generate;


  pkt(63 downto 60)  <= "0000";
  pkt0(31 downto 30) <= "00";
  pkt1(31 downto 30) <= "00";



  ddrtx_o <= ddrtx when rising_edge(clk);



  -- Stores
  -------------------------------------------------

  prc_stores : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        reg_addr_int <= 0;

      else

        if (reg_addr_we = '1') then
          reg_addr_int <= conv_integer(sr(6 downto 0));
        end if;

        reg_addr_map               <= (others => '0');
        reg_addr_map(reg_addr_int) <= '1';

      end if;
    end if;
  end process;

  reg_addr <= conv_std_logic_vector(reg_addr_int, 7);


  ------------------------------------------------------------------------
  -- Using generates to ensure we don't make registers we don't use

  gen_reg_procs   : for n in 0 to 127 generate
    gen_rw        : if (REG_ATTR(n) = RW) generate
      prc_regdata : process (clk)
      begin
        if rising_edge(clk) then
          if (rst = '1') then
            reg_data(n) <= REG_INIT(n);

          else
            if (reg_addr_map(n) = '1') and (reg_data_we = '1') then
              reg_data(n) <= sr(31 downto 0);

            end if;
          end if;
        end if;
      end process;
    end generate;

    gen_wo        : if (REG_ATTR(n) = Wo) generate
      prc_regdata : process (clk)
      begin
        if rising_edge(clk) then

          -- default
          reg_data(n) <= (others => '0');

          if (reg_addr_map(n) = '1') and (reg_data_we = '1') then
            reg_data(n) <= sr(31 downto 0);

          end if;
        end if;
      end process;
    end generate;

  end generate;


  reg_o <= reg_data;


  -- RX Bit counter
  -------------------------------------------------

  prc_bcount : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        bcount <= 0;

      elsif (bcount_clr = '1') or (bcount = BCOUNT_MAX) then
        bcount <= 0;

      else
        bcount <= bcount + 1;

      end if;
    end if;
  end process;

  reg_o <= reg_data;


  -- Debug 4 4 5 5 7 1 32

  dbg_header  <= sr(DOFFS+4 downto DOFFS+1) when rising_edge(clk) and (dbg_header_we = '1');
  dbg_typep   <= sr(DOFFS+4 downto DOFFS+1) when rising_edge(clk) and (dbg_typep_we = '1');
  dbg_hccid   <= sr(DOFFS+5 downto DOFFS+1) when rising_edge(clk) and (dbg_hccid_we = '1');
  dbg_abcid   <= sr(DOFFS+5 downto DOFFS+1) when rising_edge(clk) and (dbg_abcid_we = '1');
  dbg_regaddr <= reg_addr;
  --             sr(DOFFS+7  downto DOFFS+1) when rising_edge(clk) and (dbg_regaddr_we = '1');
  dbg_rw      <= sr(DOFFS+1 downto DOFFS+1) when rising_edge(clk) and (dbg_rw_we = '1');
  dbg_data    <= reg_data(conv_integer(reg_addr));
  --             sr(DOFFS+32 downto DOFFS+1) when rising_edge(clk) and (dbg_data_we   = '1');


end architecture rtl;

