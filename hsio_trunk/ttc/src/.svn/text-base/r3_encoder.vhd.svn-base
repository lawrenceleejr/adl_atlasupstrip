--
-- VHDL Architecture ttc.r3_encoder.rtl
--
-- Created:
--          by - warren.man (pc140.hep.ucl.ac.uk)
--          at - 13:05:24 04/09/13
--
-- using Mentor Graphics HDL Designer(TM) 2012.1 (Build 6)
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity r3_encoder is
   port( 
      -- Input
      r3_map_i   : in     std_logic_vector (13 downto 0);
      r3_valid_i : in     std_logic;
      r3_l0id_i  : in     std_logic_vector (7 downto 0);
      -- Output
      fe_r3_o    : out    std_logic;
      fe_r3s_o   : out    std_logic;
      -- Infrastructure
      strobe40_i : in     std_logic;
      clk        : in     std_logic;
      rst        : in     std_logic
   );

-- Declarations

end r3_encoder ;

--
architecture rtl of r3_encoder is

  component cg_dfifo_16x22_ft
    port (
      clk   : in  std_logic;
      srst  : in  std_logic;
      din   : in  std_logic_vector(21 downto 0);
      wr_en : in  std_logic;
      rd_en : in  std_logic;
      dout  : out std_logic_vector(21 downto 0);
      full  : out std_logic;
      empty : out std_logic
      );
  end component;


  signal bcount     : integer range 0 to 31;
  signal bcount_clr : std_logic;
 -- signal bcount_inc : std_logic;

  signal fifo_din   : std_logic_vector(21 downto 0);
  signal fifo_we    : std_logic;
  signal fifo_rd    : std_logic;
  signal fifo_dout  : std_logic_vector(21 downto 0);
  signal fifo_full  : std_logic;
  signal fifo_empty : std_logic;
  
  --                                                   0123 456789 01234567 89012345 6
  signal r3_word   : std_logic_vector(26 downto 0); -- 0HHH MMMMMM MMMMMMMM LLLLLLLL 0
  signal r3s_word  : std_logic_vector(26 downto 0);
  constant BCOUNT_MAX : integer := 26;                                                     


  
  type states is (SendR3, Idle);
  signal state, nstate : states;

begin

  fifo_din <= r3_map_i & r3_l0id_i;
  fifo_we  <= r3_valid_i;

  r3_word <= "0101" & fifo_dout & '0'; 
  r3s_word <= "0101" & fifo_dout(7 downto 0) & "000000000000000"; 

  
  r3_fifo : cg_dfifo_16x22_ft
    port map (
      clk   => clk,
      srst  => rst,
      din   => fifo_din,
      wr_en => fifo_we,
      rd_en => fifo_rd,
      dout  => fifo_dout,
      full  => fifo_full,
      empty => fifo_empty
      );



  -- State Machine
  ----------------------------------------------------------------
  prc_sm_sync : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        state <= Idle;

      else
        state <= nstate;

      end if;
    end if;
  end process;



  prc_sm_async : process (state, bcount, fifo_empty, strobe40_i)
  begin

    -- defaults
    bcount_clr <= '0';
    fifo_rd    <= '1';


    case state is

      when Idle =>
        nstate       <= Idle;
        bcount_clr   <= '1';
        if ( fifo_empty = '0') and (strobe40_i = '1') then
          nstate     <= SendR3;
        end if;


      when SendR3 =>
        nstate   <= SendR3;
        if (bcount = BCOUNT_MAX) then
          nstate <= Idle;
        end if;
        
    end case;
  end process;

  
  fe_r3_o <= r3_word(bcount) when rising_edge(clk);
  fe_r3s_o <= r3s_word(bcount) when rising_edge(clk);


  prc_byte_counter : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') or (bcount_clr = '1') then
        bcount <= 0;

      else
        if (strobe40_i = '1') and (bcount < 31) then
          bcount <= bcount + 1;

        end if;
      end if;
    end if;
  end process;

end architecture rtl;

