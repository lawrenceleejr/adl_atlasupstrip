-- VHDL Architecture hsio.dcm_conf.rtl
--
-- Created:
--          by - warren.man (pc140.hep.ucl.ac.uk)
--          at - 15:35:32 04/28/10
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

entity dcm_conf is
  port (
    delay_i       : in  std_logic_vector(9 downto 0);
    go_i        : in  std_logic;
    psdone_i    : in  std_logic;
    psbusy_o    : out std_logic;

    -- dcm conf port
    daddr_o : out std_logic_vector(6 downto 0);
    den_o   : out std_logic;
    di_o    : out slv16;
    dwe_o   : out std_logic;
    drdy_i  : in  std_logic;

    clk : in std_logic;
    rst : in std_logic
    );
end entity dcm_conf;

--
architecture rtl of dcm_conf is

  type states is (WaitDrdy0,
                  SendGo,
                  WaitDrdy1,
                  WaitPSDone,
                  ReadBack,
                  Idle,
                  Reset
                  );

  signal state, nstate : states;

  signal daddr : slv8;

begin

  daddr_o <= daddr(6 downto 0);
  di_o    <= "000000" & delay_i;


  -- State Machine
  --------------------------------------------------------

  prc_sm_clocked : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        state <= Reset;
      else
        state <= nstate;
      end if;
    end if;
  end process;



  prc_sm_async : process (state, go_i, drdy_i, psdone_i)
  begin

    --defaults
    nstate   <= Reset;
    den_o    <= '0';
    dwe_o    <= '0';
    psbusy_o <= '0';
    daddr    <= x"00";


    case state is

      when Reset =>
        nstate <= Idle;

      when Idle =>
        nstate   <= Idle;
        daddr    <= x"55";
        den_o    <= go_i;
        dwe_o    <= go_i;
        if (go_i = '1') then
          nstate <= WaitDrdy0;
        end if;


      when WaitDrdy0 =>
        nstate   <= WaitDrdy0;
        if (drdy_i = '1') then
          nstate <= SendGo;
        end if;


      when SendGo =>
        daddr  <= x"11";
        den_o  <= '1';
        dwe_o  <= '1';
        nstate <= WaitDrdy1;


      when WaitDrdy1 =>
        nstate   <= WaitDrdy1;
        if (drdy_i = '1') then
          nstate <= WaitPSDone;
        end if;


      when WaitPSDone =>
        nstate   <= WaitPSDone;
        psbusy_o <= '1';
        if (psdone_i = '1') then
          nstate <= ReadBack;
        end if;


      when ReadBack =>
        den_o  <= '1';
        nstate <= Idle;


      when others =>
        nstate <= Idle;


    end case;

  end process;


end architecture rtl;

