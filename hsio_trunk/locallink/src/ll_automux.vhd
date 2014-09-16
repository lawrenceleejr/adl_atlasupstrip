--
-- Async Auto MUX
-- 
-- Round robin port selection, no sync 
--
--
-- change log:
-- 2012-07-31 - moved to t_llbus type, at last

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library utils;
use utils.pkg_types.all;

entity ll_automux is
   generic( 
      LEVELS : integer := 2
   );
   port( 
      -- locallink interfaces
      --in
      lls_i : in     t_llsrc_array ((2**LEVELS)-1 downto 0);
      lld_o : out    std_logic_vector ((2**LEVELS)-1 downto 0);
      --out
      lls_o : out    t_llsrc;
      lld_i : in     std_logic;
      -- infrastructure
      rst   : in     std_logic;
      clk   : in     std_logic
   );

-- Declarations

end ll_automux ;

--
architecture rtl of ll_automux is

  constant PORTS : integer := 2**LEVELS;

  type states is(
    WaitEOF,
    Idle);
  signal state, nstate : states;

  signal sel     : std_logic_vector(LEVELS-1 downto 0);
  signal sel_int : integer range 0 to (PORTS-1);
  signal sel_inc : std_logic;

  signal src_rdy_in : std_logic_vector(PORTS-1 downto 0);
  --signal sof_in : std_logic_vector(PORTS-1 downto 0);
  signal eof_in : std_logic_vector(PORTS-1 downto 0);
  signal dst_rdy_out : std_logic_vector(PORTS-1 downto 0);
  
begin

  deconstructed_sigs_gen : for n in 0 to (PORTS-1) generate
    src_rdy_in(n) <= lls_i(n).src_rdy;
    --sof_in(n) <= lls_i(n).sof;
    eof_in(n) <= lls_i(n).eof;
    lld_o(n) <= dst_rdy_out(n); 
  end generate;


  

  lls_o.src_rdy <= lls_i(sel_int).src_rdy;
  lls_o.sof     <= lls_i(sel_int).sof;
  lls_o.eof     <= lls_i(sel_int).eof;
  lls_o.data    <= lls_i(sel_int).data;



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
  prc_sm_async : process(state,
                         src_rdy_in,
                         eof_in,
                         lld_i,
                         sel_int)
  begin

    -- defaults
    nstate    <= Idle;
    dst_rdy_out <= (others => '0');

    case state is

      when Idle =>
        nstate    <= Idle;
        sel_inc   <= '1';
        if (src_rdy_in(sel_int) = '1') then
          sel_inc <= '0';
          nstate  <= WaitEOF;
        end if;


      when WaitEOF =>
        nstate               <= WaitEOF;
        sel_inc              <= '0';
        if (lld_i = '1') then
          dst_rdy_out(sel_int) <= '1';
          if (eof_in(sel_int) = '1') then
            nstate           <= Idle;
          end if;
        end if;

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

