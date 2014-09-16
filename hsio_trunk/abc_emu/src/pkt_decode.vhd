--
-- Packet Decoder (was similar to readout130/ro13_deser)
--
-- Matt Warren, UCL
--
-- Deserialises ABC130/HCC data streams for sim (so far)
-- Hopefully generic enough to do both
-- 
--
-- Log:
-- 11/1/2013 - File born (initially copied from ro13_deser.vhd)
--
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library utils;
use utils.pkg_types.all;
library hsio;
use hsio.pkg_hsio_globals.all;

entity pkt_decode is
  generic(
    PKT_TYPE       :     integer := 0   -- unused
    );
  port(
    ser_i          : in  sl;
    packet_o       : out slv64;
    pkt_valid_o    : out std_logic;
    pkt_a13_o      : out t_pkt_a13;
    datawd_l11bc_o : out t_datawd_l11bc;
    datawd_l13bc_o : out t_datawd_l13bc;
    datawd_r3_o    : out t_datawd_r3;
    datawd_reg32_o : out slv32;
    clk            : in  std_logic;
    rst            : in  std_logic
    );

-- Declarations

end pkt_decode;

--
architecture rtl of pkt_decode is

  signal delta_l1_l0id : integer;
  signal new_l1_l0id   : slv8;
  signal old_l1_l0id   : slv8;

  signal delta_r3_l0id : integer;
  signal new_r3_l0id   : slv8;
  signal old_r3_l0id   : slv8;

  signal ser_in : slv64;

  signal pktdet_true  : sl;
  signal pktdet_false : sl;
  signal pktdet       : sl;

  signal pkt_valid : std_logic;
  signal pkt_we    : sl;

  signal packet  : slv64;
  signal pkt_in  : t_pkt_a13;
  signal pkt_a13 : t_pkt_a13;
  signal datawd  : slv33;


  signal   bcount     : integer range 0 to 63;
  constant BCOUNT_MAX : integer := 59;
  signal   bcount_clr : std_logic;


  --                            "7777777766666666555555554444444433333333222222221111111100000000"
  --                            "00GSCCCCCTTTTLLLLLLLLBBBBBBBBPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPsG"
  constant DETMASK_T : slv64 := "0011000000000000000000000000000000000000000000000000000000000011";
  constant DETBITS_T : slv64 := "0001000000000000000000000000000000000000000000000000000000000010";
  -- *** skiping non-zero chip id and type checking for now
--constant DETMASK_F : slv64 := "0000111111111000000000000000000000000000000000000000000000000000";
--constant DETBITS_F : slv64 := "0000000000000000000000000000000000000000000000000000000000000000";
  constant DETMASK_F : slv64 := "0000000000000000000000000000000000000000000000000000000000000000";
  constant DETBITS_F : slv64 := "1111111111111111111111111111111111111111111111111111111111111111";

  constant OS : integer := 1;

  type states is (Wait_Packet, Idle);

  signal state, nstate : states;


begin

  prc_ser_in : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        ser_in <= (others => '0');
      else
        ser_in <= ser_in(62 downto 0) & ser_i;
      end if;
    end if;
  end process;


  pkt_in.startb <= ser_in(59+OS);            --  1
  pkt_in.chipid <= ser_in(58+OS downto 54+OS);  --  5
  pkt_in.typ    <= ser_in(53+OS downto 50+OS);  --  4
  pkt_in.l0id   <= ser_in(49+OS downto 42+OS);  --  8
  pkt_in.bcid   <= ser_in(41+OS downto 34+OS);  --  8
  pkt_in.datawd <= ser_in(33+OS downto 1+OS);   -- 33
  pkt_in.stopb  <= ser_in(0+OS);             --  1


  
  ---------------------------------------------------------------
  -- Packet Detect
  ---------------------------------------------------------------

  pktdet_true  <= '1' when ((ser_in(63 downto 0) and DETMASK_T) = DETBITS_T)  else '0';
  pktdet_false <= '1' when ((ser_in(63 downto 0) and DETMASK_F) /= DETBITS_F) else '0';
  pktdet       <= (pktdet_true and pktdet_false);


  ---------------------------------------------------------------
  -- Deser Machine
  ---------------------------------------------------------------

  prc_sm_deser_sync : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        state <= Idle;
      else
        state <= nstate;

      end if;
    end if;
  end process;


  prc_sm_deser_async : process (pktdet, bcount, state)
  begin

    -- defaults
    bcount_clr <= '0';
    pkt_we     <= '0';

    case state is

      when Idle =>
        nstate     <= Idle;
        bcount_clr <= '1';
        if (pktdet = '1') then
          pkt_we   <= '1';
          nstate   <= Wait_Packet;
        end if;

      when Wait_Packet =>
        nstate   <= Wait_Packet;
        if (bcount = (BCOUNT_MAX-1)) then
          nstate <= Idle;
        end if;

    end case;
  end process;




-- Packet output interface
-------------------------------------------------------------------------

  prc_packet_out : process(clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        packet_o    <= (others => '0');
        pkt_valid_o <= '0';
        old_l1_l0id    <= (others => '0');
        new_l1_l0id    <= (others => '0');
        old_r3_l0id    <= (others => '0');
        new_r3_l0id    <= (others => '0');


      else
        -- default
        pkt_valid_o <= '0';

        if (pkt_we = '1') then
          packet_o    <= ser_in;
          pkt_valid_o <= '1';

          pkt_a13 <= pkt_in;

          if (pkt_in.typ = "0010") or (pkt_in.typ = "0011") then
            new_r3_l0id <= pkt_in.l0id;
            old_r3_l0id <= new_r3_l0id;
          end if;
          
          if (pkt_in.typ = "0100") or (pkt_in.typ = "0110") or (pkt_in.typ = "0111") then
            new_l1_l0id <= pkt_in.l0id;
            old_l1_l0id <= new_l1_l0id;
          end if;

        end if;
      end if;
    end if;

  end process;

  delta_l1_l0id <= conv_integer(new_l1_l0id) - conv_integer(old_l1_l0id);
  delta_r3_l0id <= conv_integer(new_r3_l0id) - conv_integer(old_r3_l0id);

  pkt_a13_o <= pkt_a13;

  datawd_l11bc_o.strip0 <= pkt_a13.datawd(32 downto 25);
  datawd_l11bc_o.hits0  <= pkt_a13.datawd(24 downto 22);
  datawd_l11bc_o.strip1 <= pkt_a13.datawd(21 downto 14);
  datawd_l11bc_o.hits1  <= pkt_a13.datawd(13 downto 11);
  datawd_l11bc_o.strip2 <= pkt_a13.datawd(10 downto 3);
  datawd_l11bc_o.hits2  <= pkt_a13.datawd( 2 downto 0);

  datawd_l13bc_o.strip <= pkt_a13.datawd(32 downto 25);
  datawd_l13bc_o.hits0 <= pkt_a13.datawd(24 downto 22);
  datawd_l13bc_o.hits1 <= pkt_a13.datawd(21 downto 19);
  datawd_l13bc_o.hits2 <= pkt_a13.datawd(18 downto 16);
  datawd_l13bc_o.hits3 <= pkt_a13.datawd(15 downto 13);

  datawd_r3_o.strip0 <= pkt_a13.datawd(32 downto 25);
  datawd_r3_o.strip1 <= pkt_a13.datawd(24 downto 17);
  datawd_r3_o.strip2 <= pkt_a13.datawd(16 downto 9);
  datawd_r3_o.strip3 <= pkt_a13.datawd(8 downto 1);
  datawd_r3_o.ovf    <= pkt_a13.datawd(0);


  datawd_reg32_o <= pkt_a13.datawd(32 downto 1);

  -- Bit counter
  -------------------------------------------------

  prc_bcount : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        bcount <= 0;

      elsif (bcount_clr = '1') or (bcount = BCOUNT_MAX) then
        bcount <= 0;

      else
        bcount <= bcount + 1;

      end if;
    end if;
  end process;

end architecture rtl;

