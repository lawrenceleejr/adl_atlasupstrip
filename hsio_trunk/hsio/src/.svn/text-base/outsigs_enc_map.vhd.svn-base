--
-- 
-- Encode (in needed) and map output signals
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
use hsio.pkg_core_globals.all;

entity outsigs_enc_map is
  port(
    invert_mux_i   : in  std_logic;
    reg_outsigs_i  : in  std_logic_vector(15 downto 0);
    rawsigs_i      : in  std_logic_vector(15 downto 0);
    --l1r_i          : in  std_logic;
    l1_auto_i      : in  std_logic;
    l0_ecb_i      : in  std_logic;
    com_genc_i      : in  std_logic;
        
    trg80_all_o      : out std_logic;
    trg_all_o      : out std_logic;
    trg_all_mask_o : out std_logic_vector(15 downto 0);
    outsigs_o      : out std_logic_vector(15 downto 0);
    strobe40       : in  std_logic;
    rst            : in  std_logic;
    clk            : in  std_logic
    );

-- Declarations

end outsigs_enc_map;

architecture rtl of outsigs_enc_map is


  signal stt_mode : std_logic_vector(2 downto 0);
  signal stb_mode : std_logic_vector(2 downto 0);
  signal id0_mode : std_logic_vector(2 downto 0);
  signal id1_mode : std_logic_vector(2 downto 0);

  signal stt_trg : std_logic;
  signal stb_trg : std_logic;
  signal id0_trg : std_logic;
  signal id1_trg : std_logic;

  signal stt_trg_mask : std_logic_vector(15 downto 0);
  signal stb_trg_mask : std_logic_vector(15 downto 0);
  signal id0_trg_mask : std_logic_vector(15 downto 0);
  signal id1_trg_mask : std_logic_vector(15 downto 0);

  signal a13sigs : std_logic_vector(15 downto 0);
  signal hccsigs : std_logic_vector(15 downto 0);

begin

  id1_mode <= reg_outsigs_i(14 downto 12);
  id0_mode <= reg_outsigs_i(10 downto 8);
  stb_mode <= reg_outsigs_i(6 downto 4);
  stt_mode <= reg_outsigs_i(2 downto 0);


  -- ABC 130 signals mux
  ------------------------------------------------------------------------------
  prc_encoder : process (clk)
  begin

    if rising_edge(clk) then

      if (strobe40 = invert_mux_i) then  -- BCO falling

        a13sigs(OS_ID1_L1R) <= rawsigs_i(RS_ID1_R3);  --L1R3S
        a13sigs(OS_ID1_COM) <= rawsigs_i(RS_IDC_L0) or l0_ecb_i;  --COML0

        a13sigs(OS_ID0_L1R) <= rawsigs_i(RS_ID0_R3);  --L1R3S
        a13sigs(OS_ID0_COM) <= rawsigs_i(RS_IDC_L0) or l0_ecb_i;  --COML0

        a13sigs(OS_STB_L1R) <= rawsigs_i(RS_STB_R3);  --L1R3S
        a13sigs(OS_STB_COM) <= rawsigs_i(RS_STB_L0) or l0_ecb_i;  --COML0

        a13sigs(OS_STT_L1R) <= rawsigs_i(RS_STT_R3);  --L1R3S
        a13sigs(OS_STT_COM) <= rawsigs_i(RS_STT_L0) or l0_ecb_i;  --COML0

      else  -- BCO rising               -----------------------------

        a13sigs(OS_ID1_L1R) <= rawsigs_i(RS_IDC_L1) or l1_auto_i;  --L1R3S
        a13sigs(OS_ID1_COM) <= rawsigs_i(RS_ID1_COM) or com_genc_i;  --COML0

        a13sigs(OS_ID0_L1R) <= rawsigs_i(RS_IDC_L1) or l1_auto_i; --L1R3S
        a13sigs(OS_ID0_COM) <= rawsigs_i(RS_ID0_COM) or com_genc_i;  --COML0

        a13sigs(OS_STB_L1R) <= rawsigs_i(RS_STB_L1) or l1_auto_i; --L1R3S
        a13sigs(OS_STB_COM) <= rawsigs_i(RS_STB_COM) or com_genc_i;  --COML0

        a13sigs(OS_STT_L1R) <= rawsigs_i(RS_STT_L1) or l1_auto_i; --L1R3S
        a13sigs(OS_STT_COM) <= rawsigs_i(RS_STT_COM) or com_genc_i;  --COML0

      end if;
    end if;
  end process;


  -- HCC signals mux, encode
  ------------------------------------------------------------------------------
  -- This needs to be expanded to include the encoders and mux
  hccsigs <= rawsigs_i;


  prc_mapper : process(hccsigs, a13sigs, rawsigs_i,
                       id1_mode, id0_mode, stb_mode, stt_mode,
                       l0_ecb_i
                       )
  begin

    -- IDC1
    ---------------------------

    case id1_mode is
      when C_OS_HCC =>
        id1_trg               <= rawsigs_i(RS_IDC_L0) or l0_ecb_i;
        id1_trg_mask          <= BIT_MASK(RS_IDC_L0);
        outsigs_o(OS_ID1_RST) <= '0';
        outsigs_o(OS_ID1_COM) <= hccsigs(RS_ID1_COM);
        outsigs_o(OS_ID1_L1R) <= hccsigs(RS_IDC_L1);

      when C_OS_ABC130 =>
        id1_trg               <= rawsigs_i(RS_IDC_L0) or l0_ecb_i;
        id1_trg_mask          <= BIT_MASK(RS_IDC_L0);
        outsigs_o(OS_ID1_RST) <= '0';
        outsigs_o(OS_ID1_COM) <= a13sigs(OS_ID1_COM);
        outsigs_o(OS_ID1_L1R) <= a13sigs(OS_ID1_L1R);

   -- when C_OS_ABCN =>
   --   id1_trg               <= rawsigs_i(RS_IDC_L1);
   --   id1_trg_mask          <= BIT_MASK(RS_IDC_L1);
   --   outsigs_o(OS_ID1_RST) <= rawsigs_i(RS_ID1_R3);
   --   outsigs_o(OS_ID1_L1R) <= rawsigs_i(RS_IDC_L1);  -- or l1r_i;
   --   outsigs_o(OS_ID1_COM) <= rawsigs_i(RS_ID1_COM);

      when others => -- C_OS_OFF
        stt_trg               <= '0';
        stt_trg_mask          <= (others => '0');
        outsigs_o(OS_STT_L1R) <= '0';
        outsigs_o(OS_STT_COM) <= '0';

    end case;


    -- IDC0
    ---------------------------
    case id0_mode is
      when C_OS_HCC =>
        id0_trg               <= rawsigs_i(RS_IDC_L0) or l0_ecb_i;
        id0_trg_mask          <= BIT_MASK(RS_IDC_L0);
        outsigs_o(OS_ID0_RST) <= '0';
        outsigs_o(OS_ID0_COM) <= hccsigs(RS_ID0_COM);
        outsigs_o(OS_ID0_L1R) <= hccsigs(RS_IDC_L1);  -- or l1r_i;

      when C_OS_ABC130 =>
        id0_trg               <= rawsigs_i(RS_IDC_L0) or l0_ecb_i;
        id0_trg_mask          <= BIT_MASK(RS_IDC_L0);
        outsigs_o(OS_ID0_RST) <= '0';
        outsigs_o(OS_ID0_COM) <= a13sigs(OS_ID0_COM);
        outsigs_o(OS_ID0_L1R) <= a13sigs(OS_ID0_L1R);  -- or l1r_i;

   -- when C_OS_ABCN =>
   --   id0_trg               <= rawsigs_i(RS_IDC_L1);
   --   id0_trg_mask          <= BIT_MASK(RS_IDC_L1);
   --   outsigs_o(OS_ID0_RST) <= rawsigs_i(RS_ID0_R3);
   --   outsigs_o(OS_ID0_L1R) <= rawsigs_i(RS_IDC_L1);  -- or l1r_i;
   --   outsigs_o(OS_ID0_COM) <= rawsigs_i(RS_ID0_COM);

      when others =>  -- C_OS_OFF
        stt_trg               <= '0';
        stt_trg_mask          <= (others => '0');
        outsigs_o(OS_STT_L1R) <= '0';
        outsigs_o(OS_STT_COM) <= '0';

    end case;

    -- Stave Bottom
    ---------------------------
    case stb_mode is
      when C_OS_HCC =>
        stb_trg               <= rawsigs_i(RS_STB_L0) or l0_ecb_i;
        stb_trg_mask          <= BIT_MASK(RS_STB_L0);
        outsigs_o(OS_STB_L1R) <= hccsigs(RS_STB_L1);   --L1R3E
        outsigs_o(OS_STB_COM) <= hccsigs(RS_STB_COM);  --COML0E

      when C_OS_ABC130 =>
        stb_trg               <= rawsigs_i(RS_STB_L0) or l0_ecb_i;
        stb_trg_mask          <= BIT_MASK(RS_STB_L0);
        outsigs_o(OS_STB_L1R) <= a13sigs(OS_STB_L1R);  --L1R3S
        outsigs_o(OS_STB_COM) <= a13sigs(OS_STB_COM);  --COML0

   -- when C_OS_ABCN =>
   --   stb_trg               <= rawsigs_i(RS_STB_L1);
   --   stb_trg_mask          <= BIT_MASK(RS_STB_L1);
   --   outsigs_o(OS_STB_L1R) <= rawsigs_i(RS_STB_L1); -- or l1r_i;
   --   outsigs_o(OS_STB_COM) <= rawsigs_i(RS_STB_COM);

      when others => -- C_OS_OFF
        stt_trg               <= '0';
        stt_trg_mask          <= (others => '0');
        outsigs_o(OS_STT_L1R) <= '0';
        outsigs_o(OS_STT_COM) <= '0';

    end case;


    -- Stave Top
    ---------------------------
    case stt_mode is
      when C_OS_HCC =>
        stt_trg               <= rawsigs_i(RS_STT_L0) or l0_ecb_i;
        stt_trg_mask          <= BIT_MASK(RS_STT_L0);
        outsigs_o(OS_STT_L1R) <= hccsigs(RS_STT_L1);   --L1R3E
        outsigs_o(OS_STT_COM) <= hccsigs(RS_STT_COM);  --COML0E

      when C_OS_ABC130 =>
        stt_trg               <= rawsigs_i(RS_STT_L0) or l0_ecb_i;
        stt_trg_mask          <= BIT_MASK(RS_STT_L0);
        outsigs_o(OS_STT_L1R) <= a13sigs(OS_STT_L1R);  --L1R3S
        outsigs_o(OS_STT_COM) <= a13sigs(OS_STT_COM);  --COML0

   -- when C_OS_ABCN =>
   --   stt_trg               <= rawsigs_i(RS_STT_L1);
   --   stt_trg_mask          <= BIT_MASK(RS_STT_L1);
   --   outsigs_o(OS_STT_L1R) <= rawsigs_i(OS_STT_L1R); -- or l1r_i;
   --   outsigs_o(OS_STT_COM) <= rawsigs_i(OS_STT_COM);

      when others => -- C_OS_OFF
        stt_trg               <= '0';
        stt_trg_mask          <= (others => '0');
        outsigs_o(OS_STT_L1R) <= '0';
        outsigs_o(OS_STT_COM) <= '0';

    end case;

    -- NOISE outputs 
    outsigs_o(OS_STT_NOS) <= rawsigs_i(RS_STT_NOS);
    outsigs_o(OS_STB_NOS) <= rawsigs_i(RS_STB_NOS);



    -----------------------------------------------------------------------
  end process;


  trg_all_o      <= stt_trg or stb_trg or id1_trg or id0_trg; -- or l1r_i;
  trg_all_mask_o <= stt_trg_mask or stb_trg_mask or id1_trg_mask or id0_trg_mask;


  trg80_all_o    <= ((stt_trg or stb_trg or id1_trg or id0_trg) and not(strobe40)) when rising_edge(clk);

  
end rtl;

