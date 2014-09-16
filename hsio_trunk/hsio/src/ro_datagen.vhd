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

entity ro_datagen is
  port(
    mode40_strobe_i : in  std_logic;
    start_i         : in  std_logic;
    abc_gendata_o   : out std_logic;
    len_i           : in  std_logic_vector (11 downto 0);
    clk             : in  std_logic;
    rst             : in  std_logic
    );

-- Declarations

end ro_datagen;

--
architecture rtl of ro_datagen is

  constant BYTE_COUNTER_MAX : integer := 4095;
  signal   byte_counter     : integer range 0 to BYTE_COUNTER_MAX;

  --signal test_data : slv8_array(15 downto 0);

  type states is (s_Reset, s_WaitStart,
                  s_Bit0, s_Bit1, s_Bit2, s_Bit3, s_Bit4, s_Bit5, s_Bit6, s_Bit7,
                  s_GenDone
                  );

  signal state  : states;
  signal evbyte : slv8;

  signal len_int : integer;
  signal halflen : integer;

  signal b2b : std_logic;

  signal bc_slv     : slv16;
  signal evbytedata : slv8;
  signal oddneven   : std_logic;

  signal   start_done       : slv3;
  signal   gen_done         : std_logic;
  constant DELTA_STARTS_MAX : integer := 15;

  signal delta_starts      : integer range 0 to DELTA_STARTS_MAX;
  signal delta_starts_full : std_logic;

begin

  len_int <= conv_integer(len_i);

  bc_slv <= conv_std_logic_vector(byte_counter, 16);

  evbytedata <= bc_slv(8 downto 1) when (oddneven = '1') else
                x"f" & bc_slv(12 downto 9);

  evbyte <= "00011101" when byte_counter = 0         else
            --"00000000" when byte_counter = 1         else
            -- note offset 1 is for multi-trigs
            "00001000" when byte_counter = len_int-1 else
            "00000000" when byte_counter = len_int   else
            evbytedata;



  prc_sm_inproc : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        state         <= s_Reset;
        abc_gendata_o <= '0';
        byte_counter  <= 0;
        oddneven      <= '0';

      else


        if (mode40_strobe_i = '1') then
          case state is
            when s_Reset =>
              byte_counter  <= 0;
              oddneven      <= '0';
              abc_gendata_o <= '0';
              state         <= s_WaitStart;


            when s_WaitStart =>
              oddneven      <= '0';
              if (delta_starts > 0) then
                byte_counter <= 0;
                if (len_int = 0) then   -- avoids sending data when len = 0;
                  state      <= s_GenDone;
                else
                  state      <= s_Bit0;
                end if;
              end if;


            when s_Bit0 =>
              abc_gendata_o <= evbyte(7);
              state         <= s_Bit1;

            when s_Bit1 =>
              abc_gendata_o <= evbyte(6);
              state         <= s_Bit2;

            when s_Bit2 =>
              abc_gendata_o <= evbyte(5);
              state         <= s_Bit3;

            when s_Bit3 =>
              abc_gendata_o <= evbyte(4);
              state         <= s_Bit4;

            when s_Bit4 =>
              abc_gendata_o <= evbyte(3);
              state         <= s_Bit5;

            when s_Bit5 =>
              abc_gendata_o <= evbyte(2);
              state         <= s_Bit6;

            when s_Bit6 =>
              abc_gendata_o <= evbyte(1);
              state         <= s_Bit7;

            when s_Bit7 =>
              abc_gendata_o  <= evbyte(0);
              if (byte_counter = len_int) then
                state        <= s_GenDone;
              else
                byte_counter <= byte_counter + 1;
                oddneven     <= not(oddneven);
                state        <= s_Bit0;
              end if;


            when s_GenDone =>           -- state used to trigger action elsewhere
              state <= s_WaitStart;

          end case;
        end if;
      end if;
    end if;
  end process;


  gen_done <= '1' when (state = s_GenDone) and (mode40_strobe_i = '1') else '0';

  delta_starts_full <= '1' when (delta_starts = DELTA_STARTS_MAX) else '0';

  start_done <= start_i & gen_done & delta_starts_full;

  prc_start_counter : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        delta_starts <= 0;

      else

        case start_done is
          when "010"  => delta_starts <= delta_starts - 1;
          when "011"  => delta_starts <= delta_starts - 1;
          when "100"  => delta_starts <= delta_starts + 1;
          when others => null;
        end case;
      end if;
    end if;
  end process;



end architecture rtl;
