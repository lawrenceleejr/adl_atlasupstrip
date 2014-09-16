--
-- deser_msg
-- Deserialise short messages into hex bases on length
--
-- Matt Warren
-- UCL
--


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity deser_msg is
   generic( 
      LEN       : integer := 6;
      HEXDIGITS : integer := 2
   );
   port( 
      ser_i : in     std_logic;
      hex_o : out    std_logic_vector (HEXDIGITS*4-1 downto 0);
      rst   : in     std_logic;
      clk   : in     std_logic
   );

-- Declarations

end deser_msg ;

--
architecture rtl of deser_msg is

  signal sr      : std_logic_vector(HEXDIGITS*4-1 downto 0);
  signal cnt     : integer range 0 to HEXDIGITS*4;
  signal cnt_clr : std_logic;

  signal in_msg : std_logic;

begin

  prc_controller : process (clk)
  begin

    if rising_edge(clk) then
      if (rst = '1') then
        hex_o  <= (others => '0');
        sr     <= (others => '0');
        in_msg <= '0';

      else
        sr         <= sr(HEXDIGITS*4-2 downto 0) & ser_i;
        
        if (in_msg = '0') then
          cnt_clr  <= '1';
          if (sr(0) = '1') then
            in_msg <= '1';

          end if;
        else
          cnt_clr  <= '0';
          if (cnt = LEN-3) then
            hex_o  <= sr;
            in_msg <= '0';

          end if;
        end if;
      end if;
    end if;
  end process;



  prc_counter : process (clk)
  begin

    if rising_edge(clk) then
      if (rst = '1') then
        cnt <= 0;

      else
        if (cnt_clr = '1') then
          cnt <= 0;
        else 
          cnt <= cnt + 1;

        end if;
      end if;
    end if;
  end process;


end architecture rtl;

