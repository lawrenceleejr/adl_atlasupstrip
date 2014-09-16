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

--library hsio;
--use hsio.pkg_hsio_globals.all;

entity ticks_gen is
  generic(
    SIM_MODE :     integer := 0;
    CLK_MHZ  :     integer := 80
    );
  port(
    tick_o   : out std_logic_vector(MAX_TICTOG downto 0);
    toggle_o : out std_logic_vector(MAX_TICTOG downto 0);
    clk : in std_logic;
    rst : in std_logic
    );

-- Declarations

end ticks_gen;

--
architecture rtl of ticks_gen is


  signal count     : slv4_array(6 downto 0)       := (others => x"0");
  signal count_max : integer_array(6 downto 0);
  signal divcount  : slv4_array(6 downto 0)       := (others => x"0");
  signal divtick   : slv4_array(6 downto 0)       := (others => x"0");
  signal gentog    : std_logic_vector(6 downto 0) := (others => '0');
  signal gentick   : std_logic_vector(6 downto 0);



  constant F_8MHz   : integer := 0;
  constant F_800kHz : integer := 1;
  constant F_80kHz  : integer := 2;
  constant F_8kHz   : integer := 3;
  constant F_800Hz  : integer := 4;
  constant F_80Hz   : integer := 5;
  constant F_8Hz    : integer := 6;


begin


  gen_sim_mode : if (SIM_MODE = 1) generate
    count_max(F_8MHz)   <= 4;
    count_max(F_800kHz) <= 4;
    count_max(F_80kHz)  <= 4;
    count_max(F_8kHz)   <= 4;
    count_max(F_800Hz)  <= 4;
    count_max(F_80Hz)   <= 4;
    count_max(F_8Hz)    <= 4;
  end generate;

  
  gen_not_sim_mode : if (SIM_MODE = 0) generate
    count_max(F_8MHz)   <= (CLK_MHZ/8-1);
    count_max(F_800kHz) <= 10;
    count_max(F_80kHz)  <= 10;
    count_max(F_8kHz)   <= 10;
    count_max(F_800Hz)  <= 10;
    count_max(F_80Hz)   <= 10;
    count_max(F_8Hz)    <= 10;
  end generate;




  prc_8mhz_counter : process (clk)
  begin
    if rising_edge(clk) then

      if (rst = '1') then
        count(F_8MHz)    <= (others => '0');
        divcount(F_8MHz) <= (others => '0');

      else

        -- defaults
        gentick(F_8MHz) <= '0';
        divtick(F_8MHz) <= (others => '0');

        if (count(F_8MHz) = 0) then
          gentick(F_8MHz)  <= '1';
          divcount(F_8MHz) <= divcount(F_8MHz) + '1';

          case divcount(F_8MHz) is
            when x"1"   => divtick(F_8MHz) <= "0001";
            when x"3"   => divtick(F_8MHz) <= "0011";
            when x"5"   => divtick(F_8MHz) <= "0001";
            when x"7"   => divtick(F_8MHz) <= "0111";
            when x"9"   => divtick(F_8MHz) <= "0001";
            when x"b"   => divtick(F_8MHz) <= "0011";
            when x"d"   => divtick(F_8MHz) <= "0001";
            when x"f"   => divtick(F_8MHz) <= "1111";
            when others => divtick(F_8MHz) <= "0000";
          end case;

        end if;

        if count(F_8MHz) < conv_std_logic_vector(count_max(F_8MHz)/2, 4) then
          gentog(F_8MHz) <= '1';
        else
          gentog(F_8MHz) <= '0';
        end if;

        if count(F_8MHz) = (count_max(F_8MHz)-1) then
          count(F_8MHz) <= (others => '0');
        else
          count(F_8MHz) <= count(F_8MHz) + '1';
        end if;

      end if;
    end if;
  end process;



  gen_div10_counters : for f in F_800kHz to F_8Hz generate
  begin
    prc_counter      : process (clk)
    begin
      if rising_edge(clk) then
        if (rst = '1') then
          count(f)    <= (others => '0');
          divcount(f) <= (others => '0');

        else
                                        --default
          gentick(f) <= '0';
          divtick(f) <= x"0";

          if (gentick(f-1) = '1') then

            if (count(f) = x"0") then
              gentick(f)  <= '1';
              divcount(f) <= divcount(f) + '1';

              case divcount(f) is
                when x"1"   => divtick(f) <= "0001";
                when x"3"   => divtick(f) <= "0011";
                when x"5"   => divtick(f) <= "0001";
                when x"7"   => divtick(f) <= "0111";
                when x"9"   => divtick(f) <= "0001";
                when x"b"   => divtick(f) <= "0011";
                when x"d"   => divtick(f) <= "0001";
                when x"f"   => divtick(f) <= "1111";
                when others => divtick(f) <= "0000";
              end case;

            end if;

            if (count(f) < conv_std_logic_vector(count_max(f)/2, 4)) then
              gentog(f) <= '1';
            else
              gentog(f) <= '0';
            end if;

            if count(f) = (count_max(f)-1) then
              count(f) <= x"0";
            else
              count(f) <= count(f) + '1';
            end if;

          end if;
        end if;
      end if;
    end process;

  end generate;
  

  tick_o(T_8MHz)   <= gentick(F_8MHz);
  tick_o(T_4MHz)   <= divtick(F_8MHz)(0);
  tick_o(T_2MHz)   <= divtick(F_8MHz)(1);
  tick_o(T_1MHz)   <= divtick(F_8MHz)(2);
  tick_o(T_500kHz) <= divtick(F_8MHz)(3);

  tick_o(T_800kHz) <= gentick(F_800kHz);
  tick_o(T_400kHz) <= divtick(F_800kHz)(0);
  tick_o(T_200kHz) <= divtick(F_800kHz)(1);
  tick_o(T_100kHz) <= divtick(F_800kHz)(2);
  tick_o(T_50kHz)  <= divtick(F_800kHz)(3);

  tick_o(T_80kHz) <= gentick(F_80kHz);
  tick_o(T_40kHz) <= divtick(F_80kHz)(0);
  tick_o(T_20kHz) <= divtick(F_80kHz)(1);
  tick_o(T_10kHz) <= divtick(F_80kHz)(2);
  tick_o(T_5kHz)  <= divtick(F_80kHz)(3);

  tick_o(T_8kHz)  <= gentick(F_8kHz);
  tick_o(T_4kHz)  <= divtick(F_8kHz)(0);
  tick_o(T_2kHz)  <= divtick(F_8kHz)(1);
  tick_o(T_1kHz)  <= divtick(F_8kHz)(2);
  tick_o(T_500Hz) <= divtick(F_8kHz)(3);

  tick_o(T_800Hz) <= gentick(F_800Hz);
  tick_o(T_400Hz) <= divtick(F_800Hz)(0);
  tick_o(T_200Hz) <= divtick(F_800Hz)(1);
  tick_o(T_100Hz) <= divtick(F_800Hz)(2);
  tick_o(T_50Hz)  <= divtick(F_800Hz)(3);

  tick_o(T_80Hz) <= gentick(F_80Hz);
  tick_o(T_40Hz) <= divtick(F_80Hz)(0);
  tick_o(T_20Hz) <= divtick(F_80Hz)(1);
  tick_o(T_10Hz) <= divtick(F_80Hz)(2);
  tick_o(T_5Hz)  <= divtick(F_80Hz)(3);

  tick_o(T_8Hz)  <= gentick(F_8Hz);
  tick_o(T_4Hz)  <= divtick(F_8Hz)(0);
  tick_o(T_2Hz)  <= divtick(F_8Hz)(1);
  tick_o(T_1Hz)  <= divtick(F_8Hz)(2);
  tick_o(T_0Hz5) <= divtick(F_8Hz)(3);


  toggle_o(T_8MHz)   <= gentog(F_8MHz);
  toggle_o(T_4MHz)   <= divcount(F_8MHz)(0);
  toggle_o(T_2MHz)   <= divcount(F_8MHz)(1);
  toggle_o(T_1MHz)   <= divcount(F_8MHz)(2);
  toggle_o(T_500kHz) <= divcount(F_8MHz)(3);

  toggle_o(T_800kHz) <= gentog(F_800kHz);
  toggle_o(T_400kHz) <= divcount(F_800kHz)(0);
  toggle_o(T_200kHz) <= divcount(F_800kHz)(1);
  toggle_o(T_100kHz) <= divcount(F_800kHz)(2);
  toggle_o(T_50kHz)  <= divcount(F_800kHz)(3);

  toggle_o(T_80kHz) <= gentog(F_80kHz);
  toggle_o(T_40kHz) <= divcount(F_80kHz)(0);
  toggle_o(T_20kHz) <= divcount(F_80kHz)(1);
  toggle_o(T_10kHz) <= divcount(F_80kHz)(2);
  toggle_o(T_5kHz)  <= divcount(F_80kHz)(3);

  toggle_o(T_8kHz)  <= gentog(F_8kHz);
  toggle_o(T_4kHz)  <= divcount(F_8kHz)(0);
  toggle_o(T_2kHz)  <= divcount(F_8kHz)(1);
  toggle_o(T_1kHz)  <= divcount(F_8kHz)(2);
  toggle_o(T_500Hz) <= divcount(F_8kHz)(3);

  toggle_o(T_800Hz) <= gentog(F_800Hz);
  toggle_o(T_400Hz) <= divcount(F_800Hz)(0);
  toggle_o(T_200Hz) <= divcount(F_800Hz)(1);
  toggle_o(T_100Hz) <= divcount(F_800Hz)(2);
  toggle_o(T_50Hz)  <= divcount(F_800Hz)(3);

  toggle_o(T_80Hz) <= gentog(F_80Hz);
  toggle_o(T_40Hz) <= divcount(F_80Hz)(0);
  toggle_o(T_20Hz) <= divcount(F_80Hz)(1);
  toggle_o(T_10Hz) <= divcount(F_80Hz)(2);
  toggle_o(T_5Hz)  <= divcount(F_80Hz)(3);

  toggle_o(T_8Hz)  <= gentog(F_8Hz);
  toggle_o(T_4Hz)  <= divcount(F_8Hz)(0);
  toggle_o(T_2Hz)  <= divcount(F_8Hz)(1);
  toggle_o(T_1Hz)  <= divcount(F_8Hz)(2);
  toggle_o(T_0Hz5) <= divcount(F_8Hz)(3);




end architecture rtl;

