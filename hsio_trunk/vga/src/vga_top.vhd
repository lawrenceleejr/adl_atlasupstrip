--------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:58:53 06/28/2012 
-- Design Name: 
-- Module Name:    vga_top - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

library utils;
use utils.pkg_types.all;
use work.pkg_hsio_globals.all;
use work.pkg_vga.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga_top is
  port(
    clock, clock40, reset  : in  std_logic;  -- Data clock and 40MHz vga clock
    post_rst_5s            : in  std_logic;
    Rout, Gout, Bout, H, V : out std_logic;  -- VGA drive signals
    vga_ctrl_in            : in  slv16;
-- Signals to display
-- Status Registers
    status_i               : in  slv16_array(31 downto 0);
-- Control Registers
    reg_i                  : in  t_reg_bus;
-- Single bits (LED-like behaviour)
    leds_i                 : in  std_logic_vector(N_LEDS-1 downto 0)
    );


end vga_top;

architecture Behavioral of vga_top is

  signal leds : std_logic_vector(N_LEDS-1 downto 0);

  signal led_rx                  : std_logic;
  signal led_tx                  : std_logic;
  signal vert, vsync_edge        : std_logic;
  signal row, column             : std_logic_vector(10 downto 0);
  signal pixel, red, green, blue : std_logic;

  signal rst_ctrl    : std_logic;
  signal trig_source : integer;
  signal trig_sig    : std_logic;
  signal trig_all    : std_logic;
  signal triggers    : std_logic_vector(N_LEDS-1 downto 0);

  signal scope_output : scope_arr;

  -- Signals to/from the char buffer
  signal char_write_addr  : std_logic_vector(12 downto 0);
  signal char_we          : std_logic;
  signal char_write_value : single_char;
  signal char_read_value  : single_char;
  signal char_read_addr   : std_logic_vector(12 downto 0);

  component vga_driver is
                         port( clock, reset           : in  std_logic;  -- 40 Mhz clock
                               red, green, blue       : in  std_logic;  -- input values for RGB signals
                               row, column            : out std_logic_vector(10 downto 0);  -- for current pixel
                               Rout, Gout, Bout, H, V : out std_logic);  -- VGA drive signals
  end component;

-- component char_mem is
-- port(
-- clk, reset: in std_logic;
--  -- Read
--                      char_read_addr : in std_logic_vector(12 downto 0);
--                      char_read_value : out single_char;
--                      -- Write
--                      char_write_addr: in std_logic_vector(12 downto 0);
--                      char_we : in std_logic;
--                      char_write_value : in single_char                       
--              );
--      end component;

  component cg_char_mem
    port (
      clka  : in  std_logic;
      wea   : in  std_logic_vector(0 downto 0);
      addra : in  std_logic_vector(12 downto 0);
      dina  : in  std_logic_vector(7 downto 0);
      clkb  : in  std_logic;
      rstb  : in  std_logic;
      addrb : in  std_logic_vector(12 downto 0);
      doutb : out std_logic_vector(7 downto 0)
      );
  end component;

  component char_gen is
                       port ( clock, reset    : in  std_logic;
                              row, column     : in  std_logic_vector(10 downto 0);  -- for current pixel
                              pixel           : out std_logic;
                              -- Read Char values from the buffer
                              char_read_addr  : out std_logic_vector(12 downto 0);
                              char_read_value : in  single_char
                              );
  end component;

  component vga_screen is
                         port(
                           clock, reset     : in  std_logic;  -- 40 Mhz clock
                           -- Screen Refresh
                           refresh          : in  std_logic;  -- Refresh the screen RAM
                           -- Input to the Char mem RAM
                           char_write_addr  : out std_logic_vector(CHAR_RAM_ADDR_WIDTH-1 downto 0);
                           char_we          : out std_logic;
                           char_write_value : out single_char;
                           -- Signals to display
                           status_i         : in  slv16_array(31 downto 0);
                           reg_i            :     t_reg_bus;
                           -- Single bits (LED-like behaviour)          
                           leds_i           : in  std_logic_vector(N_LEDS-1 downto 0);
                           -- Buffered scope like signals
                           scope_i          : in  scope_arr;
                           -- VGA Control bits
                           vga_ctrl_in      : in  slv16
                           );
  end component;


  component led_pulse
    port (
      clk    : in  std_logic;
      i      : in  std_logic;
      tick_i : in  std_logic;
      rst    : in  std_logic;
      o      : out std_logic
      );
  end component;

  component edge_detect
    port (
      clock  : in  std_logic;
      my_sig : in  std_logic;
      output : out std_logic
      );
  end component;

  component scopecapture is
                           port (
                             clock          : in  std_logic;
                             reset          : in  std_logic;
                             trigger        : in  std_logic;
                             prime          : in  std_logic;
                             data           : in  std_logic;
                             capture_data_o : out std_logic_vector(scope_width-1 downto 0)
                             );
  end component;

begin

  V           <= vert;
  -- Control with the first bit (on/off)
  rst_ctrl    <= reset or not(vga_ctrl_in(0));
  -- Funny Colours!
  red         <= pixel and vga_ctrl_in(1);
  green       <= pixel and vga_ctrl_in(2);
  blue        <= pixel and vga_ctrl_in(3);
  -- Second byte use to control whether signals trigger themselves
  -- or use the channel specified by byte 3
  trig_all    <= not(vga_ctrl_in(4));
  -- Third byte controls the trigger source
  trig_source <= to_integer(unsigned(vga_ctrl_in(11 downto 8)));

  Uvga_driver : vga_driver
    port map (
      clock  => clock40,
      reset  => rst_ctrl,
      red    => red,
      blue   => blue,
      green  => green,
      row    => row,
      column => column,
      Rout   => Rout,
      Gout   => Gout,
      Bout   => Bout,
      H      => H,
      V      => vert
      );

  Uchar_gen : char_gen
    port map (
      clock           => clock40,
      reset           => rst_ctrl,
      row             => row,
      column          => column,
      pixel           => pixel,
      char_read_addr  => char_read_addr,
      char_read_value => char_read_value
      );

-- Uchar_mem : char_mem
-- port map (
-- clk => clock,
-- reset => reset,
-- char_read_addr => char_read_addr,
-- char_read_value => char_read_value,
-- char_we => char_we,
-- char_write_addr => char_write_addr,
-- char_write_value => char_write_value
-- );

  Uchar_mem : cg_char_mem
    port map (
      clka   => clock,
      wea(0) => char_we,
      addra  => char_write_addr,
      dina   => char_write_value,
      clkb   => clock40,
      rstb   => rst_ctrl,
      addrb  => char_read_addr,
      doutb  => char_read_value
      );

  Uvga_screen : vga_screen
    port map (
      clock            => clock,
      reset            => rst_ctrl,
      refresh          => vsync_edge,
      char_write_addr  => char_write_addr,
      char_we          => char_we,
      char_write_value => char_write_value,
      status_i         => status_i,
      reg_i            => reg_i,
      leds_i           => leds,
      scope_i          => scope_output,
      vga_ctrl_in => vga_ctrl_in
      );

  -- Detect when we have a vertical sync
  -- Produces a 'tick' for each screen refresh
  Uvsync_edge : edge_detect
    port map (
      clock => clock,
      my_sig => not(vert),
      output => vsync_edge
      );

  ULEDS : for i in 0 to N_LEDS-1 generate
  begin
    ULED : led_pulse
      port map (
        clk    => clock,
        i      => leds_i(i),
        tick_i => vsync_edge,
        rst    => rst_ctrl,
        o      => leds(i)
        );
  end generate;
  
  UCaptures : for i in 0 to N_LEDS-1 generate
  begin
    UCapture : scopecapture
      port map (
        clock => clock,
        reset => rst_ctrl,
        trigger => triggers(i),
        data => leds_i(i),
        prime => vsync_edge,
        capture_data_o => scope_output(i)
        );
  end generate;

  trigger_driver : process (clock)
  begin
    if rising_edge(clock) then
      if (rst_ctrl = '1') then
        trig_sig <= '0';
      else
        for i in 0 to N_LEDS-1 loop
          if (trig_all = '1') then
            triggers(i) <= leds_i(i);
          else
            triggers(i) <= leds_i(trig_source);
          end if;
        end loop;
      end if;
    end if;
  end process;	
  
end Behavioral;

