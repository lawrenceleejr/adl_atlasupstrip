-------------------------------------------------------------------------------
-- Description:
-- Core logic for BNL ASIC test FPGA.
-------------------------------------------------------------------------------
-- Copyright (c) 2008 by Ryan Herbst. All rights reserved.
-------------------------------------------------------------------------------
-- Modification history:
-- 07/21/2008: created.
-------------------------------------------------------------------------------

LIBRARY ieee;
use work.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity triggerpipeline is 
   port (
     rst        : in std_logic;
     clk        : in std_logic;
     L1Ain      : in std_logic;
     L1Aout     : out std_logic;
     configure  : in std_logic;
     delay      : in std_logic_vector(7 downto 0);
     busy       : out std_logic;
     deadtime   : in std_logic_vector(15 downto 0)
     );
end triggerpipeline;

architecture TRIGGERPIPELINE of triggerpipeline is

  component triggerfifo 
	port (
	clk: IN std_logic;
	din: IN std_logic_VECTOR(0 downto 0);
	rd_en: IN std_logic;
	rst: IN std_logic;
	wr_en: IN std_logic;
	data_count: OUT std_logic_VECTOR(7 downto 0);
	dout: OUT std_logic_VECTOR(0 downto 0);
	empty: OUT std_logic;
	full: OUT std_logic);
  end component;

  signal oldconfigure: std_logic;
  signal configuring : std_logic;
  signal configured  : std_logic;
  signal din         : std_logic_vector(0 downto 0);
  signal dout        : std_logic_vector(0 downto 0);
  signal data_count   : std_logic_vector(7 downto 0);
  --signal busycounter : std_logic_vector(2 downto 0);
  signal busycounter : std_logic_vector(15 downto 0);
  signal rd_en       : std_logic;
  signal wr_en       : std_logic;
  signal fiforst     : std_logic;

begin

   L1Aout<=dout(0);
   process (rst,clk)
   begin
     if(rst='1')then
       oldconfigure<='0';
       configuring<='0';
       configured<='0';
       busy<='1';
       din(0)<='0';
       rd_en<='0';
       wr_en<='0';
       busycounter<=x"0000";
     elsif(rising_edge(clk))then
       if(configure='1'and oldconfigure='0')then
         configuring<='1';
         configured<='0';
         fiforst<='1';
         rd_en<='0';
         wr_en<='0';
         busy<='1';
       elsif(configuring='1')then
         fiforst<='0';
         if(delay=data_count)then
           configuring<='0';
           configured<='1';
           wr_en<='0';
           busy<='0';
         else
           din(0)<='0';
           wr_en<='1';
         end if;
       elsif(configured='1')then
         wr_en<='1';
         rd_en<='1';
         din(0)<=L1Ain;
         if(L1Ain='1')then
           busy<='1';
          -- busycounter<="111";
        -- elsif (busycounter/="000")then
           if(deadtime(15 downto 3)="0000000000000")then
             busycounter<="0000000000000111"; --at least 7 ticks deadtime
           else
             busycounter<=deadtime;
           end if;
         elsif (busycounter/=x"0000")then
           busycounter<=unsigned(busycounter)-1;
         else
           busy<='0';
         end if;
       end if;
     end if;
  end process;
       

   thepiepeline: triggerfifo
     port map(
       clk=>clk,
       din=>din,
       rd_en=>rd_en,
       rst=>fiforst,
       wr_en=>wr_en,
       data_count => data_count,
       dout=>dout,
       empty=>open,
       full=>open );

end TRIGGERPIPELINE;
