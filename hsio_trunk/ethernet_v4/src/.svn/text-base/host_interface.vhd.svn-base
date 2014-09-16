--
-- Xilinx EMAC Host Interface for ODR Access
--
-- Created: Matt Warren
--          2008-03-19
--


-- Notes:
-- Address as in docs, but
-- addr(10) selects MDIO registers (vs Configuration registers)

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity host_interface is
   port( 
      odr_addr_i     : in     std_logic_vector (10 downto 0);
      odr_data_i     : in     std_logic_vector (31 downto 0);
      odr_rd0_i      : in     std_logic;
      odr_wr0_i      : in     std_logic;
      odr_data0_o    : out    std_logic_vector (63 downto 0);
      odr_rd1_i      : in     std_logic;
      odr_wr1_i      : in     std_logic;
      odr_data1_o    : out    std_logic_vector (63 downto 0);
      HOSTMIIMRDY_i  : in     std_logic;
      HOSTRDDATA_i   : in     std_logic_vector (31 downto 0);
      HOSTADDR_o     : out    std_logic_vector (9 downto 0);
      HOSTEMAC1SEL_o : out    std_logic;
      HOSTMIIMSEL_o  : out    std_logic;
      HOSTOPCODE_o   : out    std_logic_vector (1 downto 0);
      HOSTREQ_o      : out    std_logic;
      HOSTWRDATA_o   : out    std_logic_vector (31 downto 0);
      reset_i        : in     std_logic;
      hostclk_125_i  : in     std_logic
   );

-- Declarations

end host_interface ;


architecture rtl of host_interface is

  signal clk : std_logic;
  signal rst : std_logic;

  signal eth_opcode     : std_logic_vector(1 downto 0);
  signal eth_req        : std_logic;
  signal eth_miimsel    : std_logic;
  signal eth_emac1sel   : std_logic;
  signal odr_access     : std_logic;
  signal odr_addr_ok    : std_logic;
  signal odr_write      : std_logic;
  signal odr_read       : std_logic;
  signal odr_read_data  : std_logic_vector(63 downto 0);
  signal odr_write_data : std_logic_vector(31 downto 0);
  signal seq            : std_logic_vector(9 downto 0);
  signal reg38c_access  : std_logic;

begin

  clk <= hostclk_125_i;
  rst <= reset_i;


  -- assemble signals
  -----------------------------------------------------------------------------

  odr_write <= odr_wr0_i or odr_wr1_i;
  odr_read  <= odr_rd0_i or odr_rd1_i;

  odr_access <= odr_read or odr_write;

  reg38c_access <= '1' when (odr_addr_i(9 downto 0) = "1110001100") else '0';

  eth_emac1sel <= '1' when ( (odr_wr1_i or odr_rd1_i) = '1' ) else '0';

  eth_opcode <= "01" when (odr_write = '1') else  --write
                "11";                             --read - default

  -- long winded, I know - but it was useful once ...
  odr_write_data <= odr_data_i;


  -- setup sequence controller (aka a wee state machine ;-) )

  seq(0) <= odr_access;

  sequencer : process (rst, clk)
    --  note extra clock period
  begin
    if (rst = '1') then
      seq(9 downto 1) <= (others => '0');
      odr_read_data   <= (others => '0');


    elsif rising_edge(clk) then

-- if ( (seq(0) = '0') and (odr_access = '1') ) then  -- rising access
      --       seq(0) <= '1';
      --    end if;

      seq(9 downto 1) <= seq(8 downto 0);

      -- output data de-mux
      -- *** debug start
      -- *** test register
      if (odr_addr_i(10) = '1') then
        if (seq(0) = '1') then
          odr_read_data <= x"DEAD" & "00000" & odr_addr_i & x"A110A110";

        elsif (seq(1) = '1') then
          odr_read_data <= x"DEAD" & "00000" & odr_addr_i & x"A110A111";

        elsif (seq(2) = '1') then
          odr_read_data <= x"DEAD" & "00000" & odr_addr_i & x"A110A112";

        elsif (seq(3) = '1') then
          odr_read_data <= x"DEAD" & "00000" & odr_addr_i & x"A110A113";

        elsif (seq(4) = '1') then
          odr_read_data <= x"DEAD" & "00000" & odr_addr_i & x"A110A114";

        elsif (seq(5) = '1') then
          odr_read_data <= x"DEAD" & "00000" & odr_addr_i & x"A110A115";

        elsif (seq(6) = '1') then
          odr_read_data <= x"DEAD" & "00000" & odr_addr_i & x"A110A116";

        elsif (seq(7) = '1') then
          odr_read_data <= x"DEAD" & "00000" & odr_addr_i & x"A110A117";

        elsif (seq(8) = '1') then
          odr_read_data <= x"DEAD" & "00000" & odr_addr_i & x"A110A118";

        elsif (seq(9) = '1') then
          odr_read_data <= x"DEAD" & "00000" & odr_addr_i & x"A110A119";

        else
          odr_read_data <= x"DEAD" & "00000" & odr_addr_i & x"A110E15E";

        end if;
      else
        -- *** debug end

        if seq(1) = '1' then
          odr_read_data(31 downto 0) <= HOSTRDDATA_i;
        end if;

        if seq(2) = '1' then
          if (reg38c_access = '1') then
            odr_read_data(63 downto 32) <= HOSTRDDATA_i;

          else
            odr_read_data(63 downto 32) <= x"F0000000";

          end if;
        end if;

        --odr_read_data(31 downto  0) <= HOSTRDDATA_i;
        --odr_read_data(63 downto 32) <= HOSTRDDATA_i;

      end if;
    end if;
  end process;



  -- miimsel and req construct/gen
  -----------------------------------------------------------------------------
  p_sigsgen : process (odr_addr_i , seq)
  begin

    if (odr_addr_i(10) = '0') then      -- register access
      eth_miimsel <= not( seq(0) or seq(1) );
      eth_req     <= '0';

    else                                -- mdio access
      eth_miimsel <= '1';
      eth_req     <= seq(0);

    end if;
  end process;

  

  -- mdio handler tba
  -----------------------------------------------------------------------------
  --eth_miimrdy <= HOSTMIIMRDY_i;



  -- output signals assemble
  -----------------------------------------------------------------------------

-- odr_data0_o <= odr_read_data when odr_rd0_i = '1';  -- no else - I hope it defaults
-- odr_data1_o <= odr_read_data when odr_rd1_i = '1';  -- no else - I hope it defaults

  -- no need to latch this as timed properly (HOPEFULLY)
  odr_data0_o <= odr_read_data;
  odr_data1_o <= odr_read_data;

  HOSTOPCODE_o   <= eth_opcode;
  HOSTREQ_o      <= eth_req;
  HOSTMIIMSEL_o  <= eth_miimsel;
  HOSTEMAC1SEL_o <= eth_emac1sel;
  HOSTADDR_o     <= odr_addr_i(9 downto 0);
  HOSTWRDATA_o   <= odr_write_data;

end architecture rtl;

