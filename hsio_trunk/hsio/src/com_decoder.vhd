--
-- ABC130 COM decoder
-- Decodes the com stream to find BCRs ECRs etc
-- These are used to control internal trigger dependent systems
--
-- Matt Warren 2014
--

-- 2014-04-28 - Born from the ashes of trig_decoder


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity com_decoder is
  port(
    com_i : in std_logic;

    -- ABC130
    a13_fcfr_o  : out std_logic;
    a13_sysr_o  : out std_logic;
    a13_bcr_o   : out std_logic;
    a13_ecr_o   : out std_logic;
    a13_softr_o : out std_logic;

    -- Infra
    strobe40_i : in std_logic;
    rst        : in std_logic;
    clk        : in std_logic
    );

-- Declarations

end com_decoder;

architecture rtl of com_decoder is


  signal sr_com : std_logic_vector(15 downto 0);

  signal bcnt     : integer range 0 to 63;
  signal bcnt_clr : std_logic;


  signal a13_fcfr  : std_logic;
  signal a13_sysr  : std_logic;
  signal a13_bcr   : std_logic;
  signal a13_ecr   : std_logic;
  signal a13_softr : std_logic;


  type states is (WaitShort, WaitLong, Idle);
  signal state, nstate : states;

begin


  prc_sr : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        sr_com <= (others => '0');

      else
        if (strobe40_i = '0') then
          sr_com <= sr_com(14 downto 0) & com_i;

        end if;
      end if;
    end if;
  end process;



  -- State Machine
  ----------------------------------------------------------------
  prc_sm_sync : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        state <= Idle;

      else                              --if (strobe40_i = '0') then
        state <= nstate;

      end if;
    end if;
  end process;




  -- ABC130 decodes
  ------------------------------------------
-- COM Short
-- 1010 0000  FCF Reset
-- 1010 0011  SYS Reset
-- 1010 0101  BC Reset
-- 1010 0110  L0ID Preset
-- 1010 1001  Soft Reset
-- 1010 1010  SEU registers Reset

-- COM Long
-- 1011 1101 + 50b HCC payload
-- 1011 1110 + 50b ABC payload


  prc_sm_async : process (state, sr_com, bcnt)
  begin

    -- defaults 
    bcnt_clr <= '0';

    case state is

      when Idle =>
        nstate   <= Idle;
        bcnt_clr <= '1';

        -- short/fast commands
        a13_fcfr  <= '0';
        a13_sysr  <= '0';
        a13_bcr   <= '0';
        a13_ecr   <= '0';
        a13_softr <= '0';

        case (sr_com(7 downto 0)) is

          -- short 
          when "10100000" => a13_fcfr  <= '1'; nstate <= WaitShort;
          when "10100011" => a13_sysr  <= '1'; nstate <= WaitShort;
          when "10100101" => a13_bcr   <= '1'; nstate <= WaitShort;
          when "10100110" => a13_ecr   <= '1'; nstate <= WaitShort;
          when "10101001" => a13_softr <= '1'; nstate <= WaitShort;

                              -- long
          when "10111101" => nstate <= WaitLong;
          when "10111110" => nstate <= WaitLong;
          when others      => null;

        end case;


      when WaitShort =>
        nstate   <= WaitShort;
        if (bcnt = 6) then
          nstate <= Idle;
        end if;

        
      when WaitLong =>
        nstate   <= WaitLong;
        if (bcnt = 56) then
          nstate <= Idle;
        end if;

    end case;
  end process;



  prc_bit_counter : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        bcnt <= 0;

      elsif (strobe40_i = '0') then
        if (bcnt_clr = '1') or (bcnt = 63) then
          bcnt <= 0;

        else
          bcnt <= bcnt + 1;

        end if;
      end if;
    end if;
  end process;


  prc_clk_out : process(clk)
  begin
    if rising_edge(clk) then
      if (strobe40_i = '0') then

        -- ABC130
        a13_fcfr_o  <= a13_fcfr;
        a13_sysr_o  <= a13_sysr;
        a13_bcr_o   <= a13_bcr;
        a13_ecr_o   <= a13_ecr;
        a13_softr_o <= a13_softr;
      end if;
    end if;
  end process;


end rtl;

