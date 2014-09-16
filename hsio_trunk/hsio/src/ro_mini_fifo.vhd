--
-- Readout Mini FIFO
--
-- Small FIFO for sending small fixed len packets,
-- 
-- Actually uses SRL16 pipelines (hopefully)
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library utils;
use utils.pkg_types.all;
use hsio.pkg_hsio_globals.all;

entity ro_mini_fifo is
   generic( 
      PAYLOAD_WORDS : integer := 24
   );
   port( 

 -- input interface
      data_i  : in     slv16;
      wren_i    : in     std_logic;
      busy_o    : out    std_logic;
      -- output interface
      llo : inout t_llbus;
      -- infrastucture
      clk       : in     std_logic;
      rst       : in     std_logic

   );

-- Declarations

end ro_mini_fifo ;


architecture rtl of ro_mini_fifo is

  constant LEN : integer := PAYLOAD_WORDS+3;
  
  signal   pipe_adv : std_logic;
  signal pipeline     : slv16_array(LEN-1 downto 0) := (others => x"0000");

  constant WCOUNT_MAX : integer := (LEN-1);
  signal   wcount : integer range 0 to WCOUNT_MAX;
  signal   wcount_clr : std_logic;

  type states is (FillPipe, SrcRdy, SOF, Middle, EOF,
                  Idle, Reset );

  signal state, nstate : states;


begin


  
  
---------------------------------------------------------------

  prc_sm_sync : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        state <= Reset;
      else
        state <= nstate;

      end if;
    end if;
  end process;


  prc_sm_async : process (llo.dst_rdy, wcount, wren_i, data_i, state)
  begin

    -- defaults
    nstate <= Reset;
    wcount_clr <= '0';
    llo.src_rdy  <= '1';
    llo.sof      <= '0';
    llo.eof      <= '0';
    pipe_adv   <= '0';
    busy_o     <= '1';

    
    case state is


      when Reset =>
        llo.src_rdy  <= '0';
        wcount_clr <= '1';
        busy_o     <= '0';
        nstate <= Idle;
        
      
      when Idle =>
        nstate   <= Idle;
        busy_o     <= '0';
        llo.src_rdy  <= '0';
        wcount_clr <= '1';
        if (wren_i = '1') then
          pipe_adv   <= '1';
          nstate   <= FillPipe;
        end if;

      when FillPipe =>
        nstate   <= FillPipe;
        llo.src_rdy  <= '0';
        pipe_adv   <= wren_i;
        if (wcount = WCOUNT_MAX) then
          nstate   <= SrcRdy;
        end if;
        


      when SrcRdy =>
          nstate   <= SrcRdy;
        wcount_clr <= '1';
        if (llo.dst_rdy = '1') then
          nstate   <= SOF;
        end if;


      when SOF =>
          nstate   <= SOF;
        llo.sof      <= '1';
        if (llo.dst_rdy = '1') then
          pipe_adv <= '1';
          nstate   <= Middle;
        end if;


      when Middle =>
            nstate <= Middle;
        if (llo.dst_rdy = '1') then
          pipe_adv <= '1';
          if (wcount = (WCOUNT_MAX-1)) then
            nstate <= EOF;
          end if;
        end if;


      when EOF =>
          nstate <= EOF;
        llo.eof    <= '1';
        wcount_clr <= '1';
        if (llo.dst_rdy = '1') then
          nstate <= Reset;
        end if;


    end case;
  end process;


-------------------------------------------------------

  prc_wcount : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') or (wcount_clr = '1') then
        wcount <= 0;

      else
        if (wcount < WCOUNT_MAX) and (pipe_adv = '1') then
          wcount <= wcount + 1;

        end if;
      end if;
    end if;
  end process;


-------------------------------------------------------

  prc_pipeline : process (clk)
  begin
    if rising_edge(clk) then
      if (pipe_adv = '1') then
        pipeline <= pipeline(LEN-2 downto 0) & data_i;

      end if;
    end if;
  end process;

  llo.data <= pipeline(LEN-1);
  
-----------------------------------------------------------------------------------
end architecture;
