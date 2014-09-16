--
-- 
--
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity strip_data_gen is
generic(
 START_PATT : std_logic_vector(15 downto 0) := X"0001"
 );
  port(
    inc_i    : in  std_logic;
    strips1_o : out std_logic_vector (255 downto 0);
    strips2_o : out std_logic_vector (255 downto 0);
    strips3_o : out std_logic_vector (255 downto 0);
    strips4_o : out std_logic_vector (255 downto 0);
    strips5_o : out std_logic_vector (255 downto 0);
    clk40    : in  std_logic;
    rst      : in  std_logic
    );

-- Declarations

end strip_data_gen;

--
architecture rtl of strip_data_gen is

  signal strips128 : std_logic_vector(127 downto 0) := (others => '0');
  signal strips    : std_logic_vector(255 downto 0) := (others => '0');
  signal strips_q    : std_logic_vector(255 downto 0);

  signal strip_id : integer;

begin


  prc_strips_data_gen : process (clk40)
  begin
     if rising_edge(clk40) then

      if (rst = '1') then
        strips128 <= X"0000000000000000000000000000" & START_PATT;
        strip_id  <= 0;
      else

        if (inc_i = '1') then
          strip_id <= strip_id + 1;

          --strips128 <= strips128(126 downto 0) & '1';
          strips128 <= strips128(126 downto 0) & strips128(127); -- after 100 ps;

        --end if;
        end if;
        
      end if;
    end if;
  end process;


  gen_interleaver : for n in 0 to 127 generate
  begin

    strips(n*2)   <= strips128(n);
    strips(n*2+1) <= strips128(n);

  end generate;

  ------------------------ x"ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff";
  --strips_o <= strips and x"ffffff0000000ffffffff000000ffffff00000fffff0000fffff000fff00ffff";

  ---------------------- x"ffff0000ffff0000ffff0000ffff0000ffff0000ffff0000ffff0000ffff0000"
  --strips_q <= strips and x"f001f003f007f00ff01ff03ff07ff0ff01ff03ff07ff0fff1fff3fff7fffffff" when rising_edge(clk80);
  --strips_q <= strips when rising_edge(clk80);
  
  strips_q <= strips when rising_edge(clk40);

  strips1_o <= strips_q;
  strips2_o <= strips_q(255-32 downto 0) & strips_q( 255 downto 256-32);
  strips3_o <= strips_q(255-64 downto 0) & strips_q( 255 downto 256-64);
  strips4_o <= strips_q(255-96 downto 0) & strips_q( 255 downto 256-96);
  strips5_o <= strips_q(255-128 downto 0) & strips_q( 255 downto 256-128);


end architecture rtl;

