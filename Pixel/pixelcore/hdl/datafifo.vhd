LIBRARY ieee;
use work.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity datafifo is
        generic (
          buffersize : integer :=8192 -- FIFO size
        );
	port (
	din: IN std_logic_VECTOR(17 downto 0);
	rd_clk: IN std_logic;
	rd_en: IN std_logic;
	rst: IN std_logic;
	wr_clk: IN std_logic;
	wr_en: IN std_logic;
	dout: OUT std_logic_VECTOR(17 downto 0);
	empty: OUT std_logic;
	full: OUT std_logic;
	overflow: OUT std_logic;
	prog_full: OUT std_logic;
	valid: OUT std_logic;
        underflow: out std_logic);
   end datafifo;

architecture datafifo of datafifo is

     component datafifo8192
	port (
	din: IN std_logic_VECTOR(17 downto 0);
	rd_clk: IN std_logic;
	rd_en: IN std_logic;
	rst: IN std_logic;
	wr_clk: IN std_logic;
	wr_en: IN std_logic;
	dout: OUT std_logic_VECTOR(17 downto 0);
	empty: OUT std_logic;
	full: OUT std_logic;
	overflow: OUT std_logic;
	prog_full: OUT std_logic;
	valid: OUT std_logic;
        underflow: out std_logic);
   end component;

   COMPONENT datafifo16384
     PORT (
       rst : IN STD_LOGIC;
       wr_clk : IN STD_LOGIC;
       rd_clk : IN STD_LOGIC;
       din : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
       wr_en : IN STD_LOGIC;
       rd_en : IN STD_LOGIC;
       dout : OUT STD_LOGIC_VECTOR(17 DOWNTO 0);
       full : OUT STD_LOGIC;
       overflow : OUT STD_LOGIC;
       empty : OUT STD_LOGIC;
       valid : OUT STD_LOGIC;
       underflow : OUT STD_LOGIC;
       prog_full : OUT STD_LOGIC
       );
   END COMPONENT;
   component datafifo32768
        port (
        din: IN std_logic_VECTOR(17 downto 0);
        rd_clk: IN std_logic;
        rd_en: IN std_logic;
        rst: IN std_logic;
        wr_clk: IN std_logic;
        wr_en: IN std_logic;
        dout: OUT std_logic_VECTOR(17 downto 0);
        empty: OUT std_logic;
        full: OUT std_logic;
        overflow: OUT std_logic;
        prog_full: OUT std_logic;
        valid: OUT std_logic;
        underflow: out std_logic);
   end component;
   component datafifo65536
        port (
        din: IN std_logic_VECTOR(17 downto 0);
        rd_clk: IN std_logic;
        rd_en: IN std_logic;
        rst: IN std_logic;
        wr_clk: IN std_logic;
        wr_en: IN std_logic;
        dout: OUT std_logic_VECTOR(17 downto 0);
        empty: OUT std_logic;
        full: OUT std_logic;
        overflow: OUT std_logic;
        prog_full: OUT std_logic;
        valid: OUT std_logic;
        underflow: out std_logic);
   end component;
   COMPONENT datafifo131072
     PORT (
       rst : IN STD_LOGIC;
       wr_clk : IN STD_LOGIC;
       rd_clk : IN STD_LOGIC;
       din : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
       wr_en : IN STD_LOGIC;
       rd_en : IN STD_LOGIC;
       dout : OUT STD_LOGIC_VECTOR(17 DOWNTO 0);
       full : OUT STD_LOGIC;
       overflow : OUT STD_LOGIC;
       empty : OUT STD_LOGIC;
       valid : OUT STD_LOGIC;
       underflow : OUT STD_LOGIC;
       prog_full : OUT STD_LOGIC
       );
   END COMPONENT;

begin

  buf_8192: if (buffersize=8192) generate
      fifo8192 : datafifo8192
         port map (
           din => din,
           rd_clk => rd_clk,
           rd_en => rd_en,
           rst => rst,
           wr_clk => wr_clk,
           wr_en => wr_en,
           dout => dout,
           empty => empty,
           full => full,
           overflow => overflow,
           prog_full => prog_full,
           valid => valid,
           underflow => underflow);
  end generate;

  buf_16384: if (buffersize=16384) generate
      fifo16384 : datafifo16384
         port map (
           din => din,
           rd_clk => rd_clk,
           rd_en => rd_en,
           rst => rst,
           wr_clk => wr_clk,
           wr_en => wr_en,
           dout => dout,
           empty => empty,
           full => full,
           overflow => overflow,
           prog_full => prog_full,
           valid => valid,
           underflow => underflow);
  end generate;

  buf_32768: if (buffersize=32768) generate
      fifo32768 : datafifo32768
         port map (
           din => din,
           rd_clk => rd_clk,
           rd_en => rd_en,
           rst => rst,
           wr_clk => wr_clk,
           wr_en => wr_en,
           dout => dout,
           empty => empty,
           full => full,
           overflow => overflow,
           prog_full => prog_full,
           valid => valid,
           underflow => underflow);
  end generate;

  buf_65536: if (buffersize=65536) generate
      fifo65536 : datafifo65536
         port map (
           din => din,
           rd_clk => rd_clk,
           rd_en => rd_en,
           rst => rst,
           wr_clk => wr_clk,
           wr_en => wr_en,
           dout => dout,
           empty => empty,
           full => full,
           overflow => overflow,
           prog_full => prog_full,
           valid => valid,
           underflow => underflow);
  end generate;

  buf_131072: if (buffersize=131072) generate
      fifo131072 : datafifo131072
         port map (
           din => din,
           rd_clk => rd_clk,
           rd_en => rd_en,
           rst => rst,
           wr_clk => wr_clk,
           wr_en => wr_en,
           dout => dout,
           empty => empty,
           full => full,
           overflow => overflow,
           prog_full => prog_full,
           valid => valid,
           underflow => underflow);
  end generate;


end datafifo;

