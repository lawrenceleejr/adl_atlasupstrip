--
-- VHDL Architecture hsio.ll_tx_pktgen_tester.rtl
--
-- Created:
--          by - warren.man (pc140.hep.ucl.ac.uk)
--          at - 11:36:40 06/01/10
--
-- using Mentor Graphics HDL Designer(TM) 2008.1b (Build 7)
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library utils;
use utils.pkg_types.all;
library hsio;
use hsio.pkg_hsio_globals.all;

entity ll_tx_pktgen_tester is
  generic(
    CHAN_ID        :     integer := 0;
    CHAN_ID_OFFSET :     integer := 0
    );
  port(
    mac_src_o      : out slv48;
    mac_dst_o      : out slv48;
    dst_rdy        : in  std_logic;
    data_o         : out slv16;
    -- data_len : out slv16;
    eof            : out std_logic;
    sof            : out std_logic;
    src_rdy        : out std_logic;
    clk_o          : out std_logic;
    rst_o          : out std_logic
    );

-- Declarations

end ll_tx_pktgen_tester;

--
architecture sim of ll_tx_pktgen_tester is

  constant POST_CLK_DELAY : time      := 50 ps;
  signal   clk            : std_logic := '0';
  signal   rst            : std_logic := '0';

  signal data     : std_logic_vector(15 downto 0);
  signal crc_sim  : std_logic_vector(15 downto 0);
  signal crc_base : std_logic_vector(15 downto 0);

  signal mac_src : slv48;
  signal mac_dst : slv48;


begin

  clk <= not(clk) after 12500 ps;

  clk_o <= clk;
  rst_o <= rst;

  data_o <= data;

  mac_src_o <= mac_src;
  mac_dst_o <= mac_dst;



  ----------------------------------------------------------------------------
  simulation                  :    process
    --------------------------------------------------
    -- Procedures 
    --------------------------------------------------
    procedure WaitClk is
    begin
      wait until rising_edge(clk);
      wait for POST_CLK_DELAY;
    end procedure;
    ----------------------------------------------------
    procedure WaitClks (nclks : in integer) is
    begin
      for waitclkloops in 1 to nclks loop
        wait until rising_edge(clk);
        wait for POST_CLK_DELAY;
      end loop;
    end procedure;
    ----------------------------------------------------
    procedure WaitDstRdyClk is
    begin
      wait for POST_CLK_DELAY;
      if (dst_rdy = '0') then
        wait until rising_edge(dst_rdy);
      end if;
      wait until rising_edge(clk);
      wait for POST_CLK_DELAY;
    end procedure;
    ----------------------------------------------------


    -- =======================================================================
  begin

    -- Initialise
    --------------------------------------------------------------------


    mac_dst <= x"000100020003";
    mac_src <= x"000500060007";



    rst <= '1', '0' after 100 ns;

    src_rdy <= '0';
    sof     <= '0';
    eof     <= '0';
    data    <= x"0000";

    --locked <= '0';

    WaitClks(300);
    --locked <= '1';

    WaitClks(10*(CHAN_ID+CHAN_ID_OFFSET));
    WaitClks(100);

    for zz in 0 to 0 loop

      -- packet 0 - normal
      -------------------------------------------------


    WaitClk;


    crc_sim <= x"8765"; WaitClk;
    src_rdy <= '1'; sof <= '1';

-- data <= x"d001"; crc_sim<= data; WaitDstRdyClk; sof <= '0';  -- opcode
--       data <= x"5152"; crc_sim<= crc_sim + data; WaitDstRdyClk;  -- seq no
--       data <= x"0123"; crc_sim <= crc_sim + data; WaitDstRdyClk;  -- size
      data <= x"0001"; WaitDstRdyClk; crc_sim <= crc_sim + data;  sof <= '0';  -- opcode
      data <= x"0002"; WaitDstRdyClk; crc_sim <= crc_sim + data;  -- seq no
      data <= x"0003"; WaitDstRdyClk; crc_sim <= crc_sim + data;  -- size

-- for nn in 0 to 16#123# loop
-- data <= conv_std_logic_vector(CHAN_ID+CHAN_ID_OFFSET, 8) & conv_std_logic_vector(nn, 8);
-- crc_sim <= crc_sim + data;
-- WaitDstRdyClk;
-- end loop;
      for nn in 4 to 100 loop
        data    <= conv_std_logic_vector(nn, 16);
        WaitDstRdyClk;
        crc_sim <= crc_sim + data;
      end loop;


    eof <= '1';
    data <= x"ffff"; WaitDstRdyClk; crc_sim <= crc_sim + data;

    src_rdy <= '0'; eof <= '0';
    WaitClks(1000);


      -- packet 1 - short
      -------------------------------------------------

      WaitClk;

      crc_sim <= x"8765"; WaitClk;

      src_rdy <= '1'; sof <= '1';
    
--    data <= x"d001"; crc_sim <= crc_base + data; WaitDstRdyClk; sof <= '0';  -- opcode
--    data <= x"5152"; crc_sim <= crc_sim + data; WaitDstRdyClk;  -- seq no
--    data <= x"0012"; crc_sim <= crc_sim + data; WaitDstRdyClk;  -- size

      data <= x"0001"; WaitDstRdyClk; crc_sim <= crc_sim + data; sof <= '0';  -- opcode
      data <= x"0002"; WaitDstRdyClk; crc_sim <= crc_sim + data; -- seq no
      data <= x"0003"; WaitDstRdyClk; crc_sim <= crc_sim + data; -- size

-- for nn in 0 to 16#12# loop
-- data <= conv_std_logic_vector(CHAN_ID+CHAN_ID_OFFSET, 8) & conv_std_logic_vector(nn, 8);
-- crc_sim <= crc_sim + data;
-- WaitDstRdyClk;
-- end loop;

      for nn in 4 to 10 loop
        data    <= conv_std_logic_vector(nn, 16);
        WaitDstRdyClk;
        crc_sim <= crc_sim + data;
      end loop;

      eof <= '1';
      data <= x"ffff"; WaitDstRdyClk; crc_sim <= crc_sim + data;

      src_rdy <= '0'; eof <= '0';

      WaitClks(1000);



    end loop;

    wait;

  end process;




end architecture sim;

