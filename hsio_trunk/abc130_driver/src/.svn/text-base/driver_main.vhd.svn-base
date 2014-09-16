library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library unisim;
use unisim.vcomponents.all;

library utils;
use utils.pkg_types.all;

library abc130_driver;
use abc130_driver.pkg_drv_globals.all;


entity driver_main is
  port(
    clk40   : in std_logic;
    clk80   : in std_logic;
    clk160  : in std_logic;
    clkn40  : in std_logic;
    clkn80  : in std_logic;
    clkn160 : in std_logic;
    rst     : in std_logic;

    -- HSIO IB P1
    -----------------------------------
    hs_bco_i      : in  std_logic;
    hs_coml0_i    : in  std_logic;
    hs_l1r3_i     : in  std_logic;
    hs_sp0_i      : in  std_logic;
    hs_dxout_i    : in  std_logic_vector (3 downto 0);
    hs_dxin_o     : out std_logic_vector (3 downto 0);
    hs_p1_spare_i : in  std_logic_vector (13 downto 0);


    -- HSIO IB P2
    -----------------------------------
    hs_p2_spare_i : in    std_logic_vector (3 downto 0);
    hs_i2c_sdc_io : inout std_logic;
    hs_i2c_sda_io : inout std_logic;


    ------------------------------------------------------------------
    -- DUT
    -------------------------------------------------------------------

    singlechip_sel_o : out std_logic;   -- 0=hybrid, 1=single chip

    dir_data_o   : out std_logic_vector (3 downto 0);
    dir_xoff_o   : out std_logic_vector (3 downto 0);
    highz_data_o : out std_logic_vector(3 downto 0);
    highz_xoff_o : out std_logic_vector(3 downto 0);


    -- COMMON (all to P3)
    -------------------------------------------------------------
    shuntctl_o   : out std_logic;       -- SHUNT_CTL_SW, becomes SHUNTCTL
    reg_en_ana_o : out std_logic;       -- REG_EN_A
    reg_en_dig_o : out std_logic;       -- REG_EN_D
    bco_o        : out std_logic;       -- BCO
    drc_o        : out std_logic;       -- DRC
    coml0_o      : out std_logic;       -- LO_CMD
    l1r3_o       : out std_logic;       -- R3
    data_i       : in  std_logic_vector (3 downto 0);
    xoff_i       : in  std_logic_vector (3 downto 0);
    data_o       : out std_logic_vector (3 downto 0);
    xoff_o       : out std_logic_vector (3 downto 0);

    -- BDP8                             -- XOFF_R0_P
    -- BDP9                             -- DATA_R0_P___FCCLK_N  *INVERT
    -- BDP14                            -- DATA3_P___FC1_P
    -- BDP15                            -- XOFF_R3_P___FC2_P
    -- BDP10                            -- DATA_1_P___DATA_L_N  *INVERT
    -- BDP10                            -- DATA_1_P___DATA_L_N  *INVERT
    -- BDP11                            -- XOFF_1_P___XOFF_L_P
    -- BDP11                            -- XOFF_1_P___XOFF_L_P
    -- BDP13                            -- DATA_R2_P___DATA_R_N  *INVERT
    -- BDP13                            -- DATA_R2_P___DATA_R_N  *INVERT
    -- BDP12                            -- XOFF_R2_P___XOFF_R_P
    -- BDP12                            -- XOFF_R2_P___XOFF_R_P

    -- ASIC Only Signals (P4)
    ---------------------------------------------------------------

    sc_term_o        : out std_logic;                      -- TERM
    sc_addr_o        : out std_logic_vector (4 downto 0);  -- ADDR0-4
    sc_rstb_o        : out std_logic;                      -- RSTB
    sc_abcup_o       : out std_logic;                      -- ABCUP
    sc_sdo_bc_i      : in  std_logic;  -- SDO_BC           --SCN_O_BC
    sc_sdi_bc_o      : out std_logic;  -- SDI_BC           --SCN_I_BC
    sc_sdo_clk_i     : in  std_logic;  -- SDO_CLK          --SCN_O_CK
    sc_sdi_clk_o     : out std_logic;  -- SDI_CLK          --SCN_I_CK
    sc_scan_enable_o : out std_logic;                      -- SCAN_ENABLE
    sc_switch1_i     : in  std_logic;                      -- SWITCH1

    -- Infra
    ---------------------------------------------------------------
    reg : in slv32_array (127 downto 0)
    );

-- Declarations

end driver_main;

architecture rtl of driver_main is


  signal bco_bufg : std_logic;
  signal drc_bufg : std_logic;

-- signal clkn40 : std_logic;
-- signal clkn80 : std_logic;
-- signal clkn160 : std_logic;


  signal counter : integer range 0 to 63;
  signal cmod60  : std_logic_vector(3 downto 0);

  signal drc   : std_logic;
  signal bco   : std_logic;
  signal coml0 : std_logic;
  signal l1r3  : std_logic;
  signal data  : std_logic_vector(3 downto 0);
  signal xoff  : std_logic_vector(3 downto 0);


  signal mode_bco     : std_logic_vector(3 downto 0);
  signal mode_drc     : std_logic_vector(3 downto 0);
  signal mode_coml0   : std_logic_vector(3 downto 0);
  signal mode_l1r3    : std_logic_vector(3 downto 0);
  signal mode_fclk    : std_logic_vector(3 downto 0);
  signal mode_scan_en : std_logic_vector(3 downto 0);
  signal mode_sdi_bc  : std_logic_vector(3 downto 0);
  signal mode_sdi_clk : std_logic_vector(3 downto 0);


  signal mode_data : slv4_array(3 downto 0);
  signal mode_xoff : slv4_array(3 downto 0);
  signal mode_hdx  : slv4_array(3 downto 0);

begin

  hs_i2c_sdc_io <= 'Z';
  hs_i2c_sda_io <= 'Z';

  --stat(zzz) <=   sc_switch1_i;        -- SWITCH1


  -- Reg DIRECTION
  -------------------------------------------------------------
  dir_xoff_o <= reg(rDIRECTION)(bDIR_XOFF3 downto bDIR_XOFF0);
  dir_data_o <= reg(rDIRECTION)(bDIR_DATA3 downto bDIR_DATA0);


  -- Reg CONFIG 
  -------------------------------------------------------------
  sc_term_o        <= reg(rCONFIG)(bSC_TERM);
  sc_addr_o        <= reg(rCONFIG)(bSC_ADDR4 downto bSC_ADDR0);
  sc_rstb_o        <= not reg(rCONFIG)(bSC_RST);
  sc_abcup_o       <= reg(rCONFIG)(bSC_ABCUP);
  singlechip_sel_o <= reg(rCONFIG)(bSINGCHIP);
  shuntctl_o       <= reg(rCONFIG)(bSHUNTCTL);
  reg_en_ana_o     <= reg(rCONFIG)(bREG_ENA);
  reg_en_dig_o     <= reg(rCONFIG)(bREG_END);


  mode_sdi_clk <= reg(rMODE_SIGS)(31 downto 28);
  mode_sdi_bc  <= reg(rMODE_SIGS)(27 downto 24);
  mode_scan_en <= reg(rMODE_SIGS)(23 downto 20);
  mode_fclk    <= reg(rMODE_SIGS)(19 downto 16);
  mode_l1r3    <= reg(rMODE_SIGS)(15 downto 12);
  mode_coml0   <= reg(rMODE_SIGS)(11 downto 8);
  mode_drc     <= reg(rMODE_SIGS)(7 downto 4);
  mode_bco     <= reg(rMODE_SIGS)(3 downto 0);

  mode_xoff(3) <= reg(rMODE_DX)(31 downto 28);
  mode_xoff(2) <= reg(rMODE_DX)(27 downto 24);
  mode_xoff(1) <= reg(rMODE_DX)(23 downto 20);
  mode_xoff(0) <= reg(rMODE_DX)(19 downto 16);
  mode_data(3) <= reg(rMODE_DX)(15 downto 12);
  mode_data(2) <= reg(rMODE_DX)(11 downto 8);
  mode_data(1) <= reg(rMODE_DX)(7 downto 4);
  mode_data(0) <= reg(rMODE_DX)(3 downto 0);

  mode_hdx(3) <= reg(rMODE_HDXIN)(15 downto 12);
  mode_hdx(2) <= reg(rMODE_HDXIN)(11 downto 8);
  mode_hdx(1) <= reg(rMODE_HDXIN)(7 downto 4);
  mode_hdx(0) <= reg(rMODE_HDXIN)(3 downto 0);

  --clkn40  <= not(clk40);
  --clkn80  <= not(clk80);
  --clkn160 <= not(clk160);


-- BCO
------------------------------------------
  with mode_bco select bco <=
    --'Z' when x"e",
    '1'    when x"d",
    '0'    when x"c",
    clkn40 when x"1",
    clk40  when x"0",
    '0'    when others;

  bufg_bco : BUFG port map (I => bco, O => bco_bufg);
  bco_o <= bco_bufg;
  --bco_o <= bco;


-- DRC
------------------------------------------
  with mode_drc select drc <=
    --'Z' when x"f",
    '1'     when x"d",
    '0'     when x"c",
    clkn40  when x"5",
    clk40   when x"4",
    clkn80  when x"3",
    clk80   when x"2",
    clkn160 when x"1",
    clk160  when x"0",
    '0'     when others;

  bufg_drc : BUFG port map (I => drc, O => drc_bufg);
  drc_o <= drc_bufg;
  --drc_o <= drc;


-- COML0
------------------------------------------
  with mode_coml0 select coml0 <=
    --'Z' when x"f",
    '1'        when x"d",
    '0'        when x"c",
    hs_coml0_i when others;

  coml0_o <= coml0;


-- L1R3
------------------------------------------

  with mode_l1r3 select l1r3 <=
    --'Z' when x"f",
    '1'       when x"d",
    '0'       when x"c",
    hs_l1r3_i when others;


  l1r3_o <= l1r3;

-------------------------------------------

  -- === ABC DATA and XOFF ===
  -- =========================


  --dir:
  -- 0=L->R (data left in, right out), 
  -- 1=R->L (data right in left)

  -- DATA 0-3 (MODE_DX 15:0)
  ------------------------------------------
  gen_data : for n in 0 to 3 generate
  begin
    with mode_data(n) select data(n) <=
      --'Z' when x"f",
      '1'           when x"d",
      '0'           when x"c",
      hs_dxout_i(3) when x"3",
      hs_dxout_i(2) when x"2",
      hs_dxout_i(1) when x"1",
      hs_dxout_i(0) when x"0",
      '0'           when others;

    highz_data_o(n) <= '1' when (mode_data(n) = x"f") else '0';
  end generate;

  data_o <= data;


  -- XOFF 0-3 (MODE_DX 31:16)
  ------------------------------------------

  gen_xoff : for n in 0 to 3 generate
  begin
    with mode_xoff(n) select xoff(n) <=
      --'Z' when x"f",
      '1'           when x"d",
      '0'           when x"c",
      hs_dxout_i(3) when x"3",
      hs_dxout_i(2) when x"2",
      hs_dxout_i(1) when x"1",
      hs_dxout_i(0) when x"0",
      '0'           when others;

    highz_xoff_o(n) <= '1' when (mode_data(n) = x"f") else '0';
  end generate;

  xoff_o <= xoff;


-- HSIO Signals (Output to HSIO)
-- ===========================================================

  -- DXIN 0-3  (MODE_DXIN)
  ------------------------------------------

  gen_hdxin : for n in 0 to 3 generate
  begin
    with mode_hdx(n) select hs_dxin_o(n) <=
      --'Z'           when x"f",
      hs_dxout_i(n) when x"e",          -- loopback
      '1'           when x"d",
      '0'           when x"c",
      sc_sdo_clk_i  when x"9",
      sc_sdo_bc_i   when x"8",
      xoff_i(3)     when x"7",          --fcdat2
      xoff_i(2)     when x"6",          -- xoffr
      xoff_i(1)     when x"5",          -- xoffl
      xoff_i(0)     when x"4",          -- n/c
      data_i(3)     when x"3",          -- fcdat1
      data_i(2)     when x"2",          -- datar
      data_i(1)     when x"1",          -- datal
      data_i(0)     when x"0",          -- n/c (fclk)
      '0'           when others;
  end generate;



-- SC MODE ONLY signals
--===========================================================


-- SDI_BC
---------------------------------------------------
  sc_sdi_bc_o <= '0';  -- SDI_BC        --SCN_I_BC

-- SDI_CLK
---------------------------------------------------
  sc_sdi_clk_o <= '0';  -- SDI_CLK      --SCN_I_CK

-- SCAN_EN
---------------------------------------------------
  sc_scan_enable_o <= '0';              -- SCAN_ENABLE

-- FCLK
---------------------------------------------------
  --This actual goes into DATA0, need to org special case
  --fcclk <= '0';

--
--==============================================================


  --------------------------------------------------------------------------------

  prc_counter : process(clk40)
  begin
    if rising_edge(clk40) then
      if (rst = '1') then
        counter <= 0;
        cmod60  <= (others => '0');

      else
        cmod60(3 downto 1) <= cmod60(2 downto 0);

        if (counter = 29) then
          cmod60(0) <= not(cmod60(0));
          counter   <= 0;

        else
          counter <= counter + 1;

        end if;
      end if;
    end if;
  end process;


-------------------------------------------------------------------------------------
end rtl;

