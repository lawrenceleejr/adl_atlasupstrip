--
-- Sync Auto MUX
-- 
-- Round robin port selection
-- 

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library utils;
use utils.pkg_types.all;

entity ll_autosmx is
  generic(
    LEVELS    :     integer := 2
    );
  port(
    -- Common Out
    sof_o     : out std_logic;
    eof_o     : out std_logic;
    src_rdy_o : out std_logic;
    dst_rdy_i : in  std_logic;
    data_o    : out slv16;
    -- Ports In
    sof_i     : in  std_logic_vector ((2**LEVELS)-1 downto 0);
    eof_i     : in  std_logic_vector ((2**LEVELS)-1 downto 0);
    src_rdy_i : in  std_logic_vector ((2**LEVELS)-1 downto 0);
    dst_rdy_o : out std_logic_vector ((2**LEVELS)-1 downto 0);
    data_i    : in  slv16_array ((2**LEVELS)-1 downto 0);
    -- infrastructure
    rst       : in  std_logic;
    clk       : in  std_logic
    );

-- Declarations

end ll_autosmx;

--
architecture rtl of ll_autosmx is

  -- This doens't hsio check dst_rdy timing ...
  
  constant PORTS : integer := 2**LEVELS;

  type states is(
    WaitEOF,
    WaitState,
    Idle);
  signal state, nstate : states;

  signal sel     : std_logic_vector(LEVELS-1 downto 0);
  signal sel_int : integer range 0 to (PORTS-1);
  signal sel_inc : std_logic;


begin


  prc_sync : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        src_rdy_o <= '0';
        sof_o     <= '0';
        eof_o     <= '0';
        data_o <= x"0000";

      else

        src_rdy_o <= src_rdy_i(sel_int);
        sof_o     <= sof_i(sel_int);
        eof_o     <= eof_i(sel_int);
        data_o    <= data_i(sel_int);
      end if;
    end if;
  end process;


  -- SM Clocked
  -------------------------------------------------------
  prc_sm_clocked : process(clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        state <= Idle;
      else
        state <= nstate;
      end if;
    end if;
  end process;


  -- SM Async
  -------------------------------------------------------
  prc_sm_async : process(state, src_rdy_i, eof_i, dst_rdy_i, sel_int)
  begin

    -- defaults
    nstate    <= Idle;
    dst_rdy_o <= (others => '0');

    case state is

      when Idle =>
        nstate    <= Idle;
        sel_inc   <= '1';
        if (src_rdy_i(sel_int) = '1') then
          sel_inc <= '0';
          nstate  <= WaitEOF;
        end if;


      when WaitEOF =>
        nstate               <= WaitEOF;
        sel_inc              <= '0';
        if (dst_rdy_i = '1') then
          dst_rdy_o(sel_int) <= '1';
          if (eof_i(sel_int) = '1') then
            nstate           <= WaitState;
          end if;
        end if;


      when WaitState =>
        nstate <= Idle;

    end case;
  end process;


  -- Port select counter                --  this is simple round-robin


  prc_port_sel_counter : process(clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        sel <= (others => '0');

      elsif (sel_inc = '1') then
        sel <= sel + '1';

      end if;
    end if;
  end process;

  sel_int <= conv_integer(sel);



end architecture rtl;

