--
-- VHDL Architecture parser.parser_top_tester.sim
--
-- Created:
--          by - warren.man (pc140.hep.ucl.ac.uk)
--          at - 12:10:07 06/15/10
--
-- using Mentor Graphics HDL Designer(TM) 2008.1b (Build 7)
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity hawaiiFIFO_tester is
  port (
    clk_o        : out std_logic;
    rst_o        : out std_logic
    );
end hawaiiFIFO_tester;

--
architecture sim of hawaiiFIFO_tester is


component hawaiiFIFO is
	generic (
		depth: natural := 4  -- fifo will be max_occupancy) registers deep
	);
	port (

		clock, reset : in std_logic; -- clock and reset
		rd, wr : in std_logic; -- read / write enable
		read_length: in std_logic_vector(depth-1 downto 0);
		write_length: in std_logic_vector(depth-1 downto 0);
		full, empty: out std_logic;

		read_data: out std_logic_vector(2**depth - 1 downto 0);
		write_data: in std_logic_vector(2**depth-1 downto 0); -- single bit input
		
		-- Some debug outputs
		w_ptr_reg_o, w_ptr_next_o, w_ptr_succ_o: out
		std_logic_vector(depth-1 downto 0) := (others => '0');

		-- Read pointers
		r_ptr_reg_o, r_ptr_next_o, r_ptr_succ_o: out
		std_logic_vector(depth-1 downto 0) := (others => '0');
		
		-- Buffer occupancy
		occupancy: out std_logic_vector(depth downto 0)
		
	);
end component;

  signal clk              : std_logic                    := '1';
  signal rst              : std_logic                    := '1';

  signal abcdata      : std_logic;

  signal read_enable : std_logic := '0';
  signal isfull, isempty : std_logic;
  signal write_enable : std_logic := '0';
  
  constant fifo_depth : integer := 8;
  signal fifo_data : std_logic_vector(2**fifo_depth - 1 downto 0);

-- Write pointers
   signal w_ptr_reg, w_ptr_next, w_ptr_succ:
      std_logic_vector(fifo_depth-1 downto 0) := (others => '0');

-- Read pointers
   signal r_ptr_reg, r_ptr_next, r_ptr_succ:
      std_logic_vector(fifo_depth-1 downto 0) := (others => '0');

   signal fifo_occupancy : std_logic_vector(fifo_depth downto 0);

  constant ABCNTestLength : integer := 784 + 128 + 128 + 40 + 40;
  constant ABCNTEST : std_logic_vector(ABCNTestLength - 1 downto 0) :=
   -- Two events with minimal trailer between
   "00001110101111111111111001100110011100000000000000011101011111111111110101010100101010101010101000000000000000000000000000000000"
    ---------,---,-------,,---,---,---,---------------,-----,---,-------,,-,------,------,,--,,--,---------------,
   -- Two events with minimal+1 trailer
&  "00001110101111111111111001100110011100000000000000001110101111111111111010101010010101010101010100000000000000000000000000000000"
    ---------,---,-------,,---,---,---,---------------, -----,---,-------,,-,------,------,,--,,--,---------------,
   -- Two events with minimal trailer and chip channel = 0 (ie 14 zeros)
&  "00001110101111111111111001100110011100000000000000011101011111111111110100000000000000101010101010100000000000000000000000000000"
   --   +----,+--,+------,,+--,+--,+--,+--------------,+----,+--,+------,,+,+-----,+-----,,+-,,+-,,+-,+--------------, 
   -- Consecutive hits of different patterns from chip = channel = 0
&  "000011101011111111111110100000000000000100010011010101111001101111011111000000000000000000000000000000000"
   --   +----,+--,+------,,+,+-----,+-----,,+-,,+-,,+-,,+-,,+-,,+-,,+-,,+-,+--------------, 
   -- Event with no hit followed by a hit
&  "0000111010111111111111100110100001010001010101010000000000000000"
    ----+----,+--,+------,,+--,+,+-----,+-----,,+-,+--------------,
   -- Event with a hit followed by no hit
&  "0000111010111111111111101000010100010101010001110000000000000000"
    ----+----,+--,+------,,+,+-----,+-----,,+-,+--,+--------------,
   -- Error packet (both 001 and 100)
&  "00001110101111111111111000101010100110001010101100110000000000000000000"
   --   +----,+--,+------,,+-,------,+-,,+-,+-----,+-,,+--------------,
   -- Config readback
&  "00111010111111111111100010101011110011001111100110011000000000000000000"
   -- +----,+--,+------,,+-,+-----,+-,+------,,+------,,+--------------, 
   -- Register readback
&  "000011101011111111111110001010101010000001111111111111111111000000000000000000000000000000000000000000000"
   --   +----,+--,+------,,+-,------,+-,+---,+------,,+------,,+--------------, 
   -- Put it into an error state (no trailer bit)
&  "000011101011111111111110011000000000000000000000"
    ----+----,+--,+------,,+--,*--------------,
   -- Missing separator 1
&  "0000111010111111111111001011100001110001000100110000000000000000"
   --   +----,+--,+------,*+,+-----,+-----,,+-,,+-,+--------------, 
   -- Missing separator 2
&  "0000111010111111111111101011100001110000000100110000000000000000"
   --   +----,+--,+------,,+,+-----,+-----,*+-,,+-,+--------------, 
   -- Empty event (check OK after errors)
&  "0000111010111111111111110000000000000000"
    ----+----,+--,+------,,+--------------,
&  "0000111010111111111111110000000000000000"
    ----+----,+--,+------,,+--------------,
	;
begin

   -- And a hisotgrammer
	fifo: hawaiiFIFO
	generic map ( depth => fifo_depth )
	PORT MAP (
		clock => clk,
		reset => rst,
		rd => read_enable,
		wr => write_enable,
		write_data(0) => abcdata,
		write_data(2**fifo_depth-1 downto 1) => (others => '0'),
		read_length => "00000101",
		write_length => "00000001",
		full => isfull,
		empty => isempty,
		read_data => fifo_data,
		w_ptr_reg_o => w_ptr_reg,
		w_ptr_next_o => w_ptr_next,
		w_ptr_succ_o => w_ptr_succ,
		r_ptr_reg_o => r_ptr_reg,
		r_ptr_next_o => r_ptr_next,
		r_ptr_succ_o => r_ptr_succ,
		occupancy => fifo_occupancy
	);

  clk <= not(clk) after 12500 ps;

  clk_o <= clk;
  rst_o <= rst;

  ----------------------------------------------------------------------------
  fillbuffer       :    process
    --------------------------------------------------
    -- Procedures 
    --------------------------------------------------
    procedure WaitClk is
    begin
      wait until rising_edge(clk);
      wait for 100 ps;
    end procedure;
    ----------------------------------------------------
    procedure WaitClks (nclks : in integer) is
    begin
      for waitclkloops in 1 to nclks loop
        wait until rising_edge(clk);
        wait for 100 ps;
      end loop;
    end procedure;
    ----------------------------------------------------


    -- =======================================================================
  begin

    -- Initialise
    --------------------------------------------------------------------

    abcdata     <= '0';
    rst         <= '1';
    WaitClks(100);
    rst <= '0';
    WaitClks(100);

    -------------------------------------------

    write_enable <= '1';
    read_enable <= '0';

--    for n in 0 to ABCNTestLength-1 loop
    for n in 0 to 128 loop
      abcdata <= ABCNTEST((ABCNTestLength-1)-n);
      WaitClk;
    end loop;

    write_enable <= '0';
    read_enable <= '1';

    WaitClks(100);

  end process;


end architecture sim;

