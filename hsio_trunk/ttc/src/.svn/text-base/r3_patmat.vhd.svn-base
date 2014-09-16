--
-- VHDL Architecture ttc.r3_patmat.rtl
--
-- Created by Matt Warren 2012
--
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity r3_patmat is
   port( 
      -- Input
      ttc_r3_i           : in     std_logic;
      ttc_r3_l0id_i      : in     std_logic_vector (7 downto 0);
      ttc_r3_roi_i       : in     std_logic_vector (11 downto 0);
      ttc_r3_roi_valid_i : in     std_logic;
      -- Output
      r3_valid_o         : out    std_logic;
      r3_l0id_o          : out    std_logic_vector (7 downto 0);
      r3_map_o           : out    std_logic_vector (13 downto 0);
      -- Ext RAM interface
      ram_rdy_o          : out    std_logic;
      ram_we_i           : in     std_logic;
      ram_addr_i         : in     std_logic_vector (11 downto 0);
      ram_din_i          : in     std_logic_vector (15 downto 0);
      ram_dout_o         : out    std_logic_vector (15 downto 0);
      -- Infrastructure
      strobe40_i         : in     std_logic;
      clk                : in     std_logic;
      rst                : in     std_logic
   );

-- Declarations

end r3_patmat ;

--
architecture rtl of r3_patmat is
  component cg_bram_4kx16
    port (
      clka  : in  std_logic;
      wea   : in  std_logic_vector(0 downto 0);
      addra : in  std_logic_vector(11 downto 0);
      dina  : in  std_logic_vector(15 downto 0);
      douta : out std_logic_vector(15 downto 0)
      );
  end component;

  signal r3_map : std_logic_vector(13 downto 0);
  signal r3_map_clr  : std_logic;
  signal r3_map_add : std_logic;
  signal r3_valid : std_logic;

  
  signal ram_rdy  :   std_logic;
  signal ram_we   :   std_logic;
  signal ram_we00 :   std_logic_vector(0 downto 0);
  signal ram_addr :   std_logic_vector(11 downto 0);
  signal ram_din  :   std_logic_vector(15 downto 0);
  signal ram_dout :  std_logic_vector(15 downto 0);


    type states is (AddMap, DoneMap, Idle);
  signal state, nstate : states;


begin


  ram_we  <= ram_we_i;
  ram_din <= ram_din_i;

  ram_addr <= ttc_r3_roi_i;


  ram_we00 <= "0" when (ram_we = '0') else "1"; --%^&* coregen
  
  Upatram : cg_bram_4kx16
    port map (
      clka  => clk,
      wea   => ram_we00,
      addra => ram_addr,
      dina  => ram_din,
      douta => ram_dout
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



  prc_sm_async : process (state, ttc_r3_roi_valid_i)
  begin

    -- defaults
    r3_map_clr <= '0';
    r3_map_add <= '0';
    r3_valid <= '0';             


    case state is

      when Idle =>
        nstate     <= Idle;
        if (ttc_r3_roi_valid_i = '1') then
          r3_map_clr <= '1';
          nstate   <= AddMap;
        end if;


      when AddMap =>
        nstate <= AddMap;
        r3_map_add <= '1';
        if (ttc_r3_roi_valid_i = '0') then
          nstate   <= DoneMap;
        end if;
        

      when DoneMap =>
        r3_map_add <= '1';
        r3_valid <= '1';             
        nstate   <= Idle;

       
    end case;
  end process;

  r3_valid_o <= r3_valid when rising_edge(clk);
  r3_l0id_o  <= ttc_r3_l0id_i;

  prc_build_map : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') or (r3_map_clr = '1') then
        r3_map <= (others => '0');

      else
        if (r3_map_add = '1') then
          r3_map <= r3_map or ram_dout(13 downto 0);
        end if;
      end if;
    end if;
  end process;

  r3_map_o <= r3_map;


end architecture rtl;

