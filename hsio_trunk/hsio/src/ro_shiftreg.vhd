--
-- Serdata Shift register
-- Hopefully shared by histo and raw 
--

-- Log:
--


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library utils;
use utils.pkg_types.all;

library hsio;
use hsio.pkg_core_globals.all;

entity ro_shiftreg is
  generic (
    SR_MAX : integer := 34
    );

  port(
    serdata_i : in  std_logic;
    sr_data_o : out std_logic_vector (SR_MAX downto 0);

    header_seen_o   : out std_logic;
    hseen_lch_o     : out std_logic;
    hseen_lch_clr_i : in  std_logic;

    trailer_seen_o  : out std_logic;
    tseen_lch_o     : out std_logic;
    tseen_lch_clr_i : in  std_logic;

    mode40_strobe_i : in std_logic;
    clk             : in std_logic;
    rst             : in std_logic
    );

-- Declarations

end ro_shiftreg;

--
architecture rtl of ro_shiftreg is

  signal sr_data : std_logic_vector(SR_MAX downto 0);


begin

  prc_pipeline_in : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        sr_data <= (others => '0');

      else
        if (mode40_strobe_i = '1') then
          sr_data <= sr_data(SR_MAX-1 downto 0) & serdata_i;
        end if;

      end if;
    end if;
  end process;

  sr_data_o <= sr_data;


  prc_header_seen : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        header_seen_o <= '0';
      else

        -- default
        header_seen_o <= '0';

        if (sr_data(SR_MAX downto SR_MAX-17) = "000000000000000111010") then
          --if (sr_data(SR_MAX-11 downto SR_MAX-16) = "011101") then
          header_seen_o <= '1';
          hseen_lch_o   <= '1';

        elsif (hseen_lch_clr_i = '1') then
          hseen_lch_o <= '0';

        end if;
      end if;
    end if;
  end process;




  prc_trailer_seen : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        trailer_seen_o <= '0';

      else
        -- default
        trailer_seen_o <= '0';

        if (sr_data(14 downto 0) = "100000000000000") and (serdata_i = '0') then
          trailer_seen_o <= '1';
          tseen_lch_o    <= '1';

        elsif (tseen_lch_clr_i = '1') then
          tseen_lch_o <= '0';

        end if;
      end if;
    end if;
  end process;


-- prc_in_event : process (clk)
-- begin
-- if rising_edge(clk) then
-- if (rst = '1') then
-- in_event <= '0';
-- header_det_o <= '0';

-- else
--  --default
--         header_det_o <= '0';

-- if (in_event = '0') and (header_seen = '1') then
-- in_event <= '1';
-- header_det_o <= '1';

-- elsif (trailer_seen = '1') then
-- in_event <= '0';

-- end if;
-- end if;
-- end if;
-- end process;




end architecture rtl;
