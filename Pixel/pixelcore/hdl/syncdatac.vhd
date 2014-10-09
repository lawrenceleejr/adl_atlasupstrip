------------------------------------------------------------------------------
--
--  Xilinx, Inc. 2002                 www.xilinx.com
--
--  XAPP 225
--
------------------------------------------------------------------------------
--
--  File name :       sync_master_v2.vhd
--
--  Description :     Master phase aligner module for Virtex2 (2 bits)
--
--  Date - revision : January 6th 2009 - v 1.2
--
--  Author :          NJS
--
--  Disclaimer: LIMITED WARRANTY AND DISCLAMER. These designs are
--              provided to you "as is". Xilinx and its licensors make and you
--              receive no warranties or conditions, express, implied,
--              statutory or otherwise, and Xilinx specifically disclaims any
--              implied warranties of merchantability, non-infringement,or
--              fitness for a particular purpose. Xilinx does not warrant that
--              the functions contained in these designs will meet your
--              requirements, or that the operation of these designs will be
--              uninterrupted or error free, or that defects in the Designs
--              will be corrected. Furthermore, Xilinx does not warrantor
--              make any representations regarding use or the results of the
--              use of the designs in terms of correctness, accuracy,
--              reliability, or otherwise.
--
--              LIMITATION OF LIABILITY. In no event will Xilinx or its
--              licensors be liable for any loss of data, lost profits,cost
--              or procurement of substitute goods or services, or for any
--              special, incidental, consequential, or indirect d[DX] Dependencies for CalibGui.cc
--              arising from the use or operation of the designs or
--              accompanying documentation, however caused and on any theory
--              of liability. This limitation will apply even if Xilinx
--              has been advised of the possibility of such damage. This
--              limitation shall apply not-withstanding the failure of the
--              essential purpose of any limited remedies herein.
--
--  Copyright © 2002 Xilinx, Inc.
--  All rights reserved
--
------------------------------------------------------------------------------
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library unisim ;
use unisim.vcomponents.all ;

entity syncdatac is port (
	clk 		: in std_logic ;			-- clock input
	clk90 		: in std_logic ;			-- clock 90 input
	rdatain 	: in std_logic;                         -- data input
	rst 		: in std_logic ;			-- reset input
	useaout		: out std_logic ;			-- useA output for cascade
	usebout		: out std_logic ;			-- useB output for cascade
	usecout		: out std_logic ;			-- useC output for cascade
	usedout		: out std_logic ;			-- useD output for cascade
--	useain		: in std_logic ;			-- useA output for cascade
--	usebin		: in std_logic ;			-- useB output for cascade
--	usecin		: in std_logic ;			-- useC output for cascade
--	usedin		: in std_logic ;			-- useD output for cascade
	sdataout	: out std_logic;               	        -- data out
        phaseConfig     : in std_logic);                        -- Flag for calibration
end syncdatac;

architecture arch_syncdata of syncdatac is

-- component chipscope_ila
--   PORT (
--    CONTROL : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
--    CLK : IN STD_LOGIC;
--    DATA : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
--   TRIG0 : IN STD_LOGIC_VECTOR(7 DOWNTO 0));

-- end component;

-- component chipscope_icon
--   PORT (
--   CONTROL0 : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0));
-- end component;

-- attribute syn_noprune : boolean;
-- attribute syn_noprune of ila : label is true;
-- attribute syn_noprune of icon : label is true;


signal aa0       	: std_logic;
signal bb0       	: std_logic;
signal cc0              : std_logic;
signal dd0              : std_logic;
signal usea 		: std_logic;
signal useb 		: std_logic;
signal usec 		: std_logic;
signal used 		: std_logic;
signal useaint 		: std_logic;
signal usebint 		: std_logic;
signal usecint 		: std_logic;
signal usedint 		: std_logic;
signal ctrlint 		: std_logic_vector(1 downto 0);
signal sdataa 		: std_logic;
signal sdatab 		: std_logic;
signal sdatac 		: std_logic;
signal sdatad 		: std_logic;
signal az     		: std_logic_vector(2 downto 0) ;
signal bz     		: std_logic_vector(2 downto 0) ;
signal cz     		: std_logic_vector(2 downto 0) ;
signal dz     		: std_logic_vector(2 downto 0) ;
signal aap, bbp	 	: std_logic;
signal aan, bbn	 	: std_logic;
signal ccp, ddp 	: std_logic;
signal ccn, ddn 	: std_logic;
signal pipe_ce0 	: std_logic;
signal notclk 		: std_logic;
signal notclk90 	: std_logic;

-- signal control          : std_logic_vector(35 downto 0) ;


-- FS: Counters to determine most likely phase
signal countera         : std_logic_vector(7 downto 0);
signal counterb         : std_logic_vector(7 downto 0);
signal counterc         : std_logic_vector(7 downto 0);
signal counterd         : std_logic_vector(7 downto 0);

signal useatemp         : std_logic;
signal usebtemp         : std_logic;
signal usectemp         : std_logic;
signal usedtemp         : std_logic;

-- signal data             : std_logic_vector(15 downto 0);
-- signal trigger          : std_logic_vector(7 downto 0);
signal count : std_logic;
signal changed : std_logic;




attribute RLOC : string ;
attribute RLOC of ff_az0 : label is "X0Y2";
attribute RLOC of ff_az1 : label is "X0Y2";

attribute RLOC of ff_bz0 : label is "X0Y1";
attribute RLOC of ff_bz1 : label is "X1Y1";

attribute RLOC of ff_cz0 : label is "X1Y0";
attribute RLOC of ff_cz1 : label is "X1Y1";

attribute RLOC of ff_dz0 : label is "X0Y0";
attribute RLOC of ff_dz1 : label is "X0Y1";



begin

notclk <= not clk ;
notclk90 <= not clk90 ;
useaout <= useaint ;
usebout <= usebint ;
usecout <= usecint ;
usedout <= usedint ;
sdataa <= (aa0 and useaint) ;
sdatab <= (bb0 and usebint) ;
sdatac <= (cc0 and usecint) ;
sdatad <= (dd0 and usedint) ;

saa0 : srl16 port map(d => az(2), clk => clk, a0 => ctrlint(0), a1 => ctrlint(1), a2 => '0', a3 => '0', q => aa0);
sbb0 : srl16 port map(d => bz(2), clk => clk, a0 => ctrlint(0), a1 => ctrlint(1), a2 => '0', a3 => '0', q => bb0);
scc0 : srl16 port map(d => cz(2), clk => clk, a0 => ctrlint(0), a1 => ctrlint(1), a2 => '0', a3 => '0', q => cc0);
sdd0 : srl16 port map(d => dz(2), clk => clk, a0 => ctrlint(0), a1 => ctrlint(1), a2 => '0', a3 => '0', q => dd0);


process (clk, rst)
begin
if rst = '1' then
	ctrlint <= "10" ;
	useaint <= '0' ; usebint <= '0' ; usecint <= '0' ; usedint <= '0' ;
	usea <= '0' ; useb <= '0' ; usec <= '0' ; used <= '0' ;
        useatemp <= '0';usebtemp <= '0';usectemp <= '0';usedtemp <= '0';
	pipe_ce0 <= '0' ; sdataout <= '0' ;
	aap <= '0' ; bbp <= '0' ; ccp <= '0' ; ddp <= '0' ;
	aan <= '0' ; bbn <= '0' ; ccn <= '0' ; ddn <= '0' ;
	az(2) <= '0' ; bz(2) <= '0' ; cz(2) <= '0' ; dz(2) <= '0' ;
        countera <= "00000000"; counterb <= "00000000"; counterc <= "00000000"; counterd <= "00000000";
        count <= '0';
        changed <= '0';
elsif clk'event and clk = '1' then
	az(2) <= az(1) ; bz(2) <= bz(1) ; cz(2) <= cz(1) ; dz(2) <= dz(1) ;
	aap <= (az(2) xor az(1)) and not az(1) ;	-- find positive edges
	bbp <= (bz(2) xor bz(1)) and not bz(1) ;
	ccp <= (cz(2) xor cz(1)) and not cz(1) ;
	ddp <= (dz(2) xor dz(1)) and not dz(1) ;
	aan <= (az(2) xor az(1)) and az(1) ;		-- find negative edges
	bbn <= (bz(2) xor bz(1)) and bz(1) ;
	ccn <= (cz(2) xor cz(1)) and cz(1) ;
	ddn <= (dz(2) xor dz(1)) and dz(1) ;
	useatemp <= (bbp and not ccp and not ddp and aap) or (bbn and not ccn and not ddn and aan) ;
	usebtemp <= (ccp and not ddp and aap and bbp) or (ccn and not ddn and aan and bbn) ;
	usectemp <= (ddp and aap and bbp and ccp) or (ddn and aan and bbn and ccn) ;
	usedtemp <= (aap and not bbp and not ccp and not ddp) or (aan and not bbn and not ccn and not ddn) ;
--      usea<=useain;
--      useb<=usebin;
--      usec<=usecin;
--      used<=usedin;

        if phaseConfig = '1' then
          count <= '1';
        end if;


        if count = '1' then
          if useatemp='1' then                -- FS: Only one of the usex equal 1
            countera <= countera+1;
          elsif usebtemp='1' then
            counterb <= counterb+1;
          elsif usectemp='1' then
            counterc <= counterc+1;
          elsif usedtemp='1' then
            counterd <= counterd+1;
          end if;
        end if;
--                data(7) <= useatemp;
--                data(6) <= usebtemp;
--                data(5) <= usectemp;
--                data(4) <= usedtemp;

        if countera = "11111111" then    -- FS: . . . and set the one reaching the end of the counter
                 usea <= '1';
                 useb <= '0';
                 usec <= '0';
                 used <= '0';
                 changed <= '1';
                 
        elsif counterb = "11111111" then
                 usea <= '0';
                 useb <= '1';
                 usec <= '0';
                 used <= '0';
                 changed <= '1';
                 
        elsif counterc = "11111111" then
                 usea <= '0';
                 useb <= '0';
                 usec <= '1';
                 used <= '0';
                 changed <= '1';

        elsif counterd = "11111111" then
                 usea <= '0';
                 useb <= '0';
                 usec <= '0';
                 used <= '1';
                 changed <= '1';
                 
        elsif changed  = '1' then
                changed <= '0';
		pipe_ce0 <= '1' ;
	    	useaint <= usea ;
	    	usebint <= useb ;
	    	usecint <= usec ;
	    	usedint <= used ;

 --               data(3) <= usea;
 --               data(2) <= useb;
 --               data(1) <= usec;
 --               data(0) <= used;
                
                countera <= "00000000";        -- FS: Reset all counters if one of them has reached the end
                counterb <= "00000000";
                counterc <= "00000000";
                counterd <= "00000000";
                count <= '0';
	end if ;
	if pipe_ce0 = '1' then
		sdataout <= sdataa or sdatab or sdatac or sdatad ;
	end if ;
	if usedint = '1' and usea = '1' then 		-- 'd' going to 'a'
		ctrlint <= ctrlint - 1 ;
	elsif useaint = '1' and used = '1' then 	-- 'a' going to 'd'
		ctrlint <= ctrlint + 1 ;
	end if ;
end if ;
end process ;

-- get all the samples into the same time domain

ff_az0 : fdc port map(d => rdatain,  c => clk, clr => rst, q => az(0));
ff_az1 : fdc port map(d => az(0), c => clk, clr => rst, q => az(1));

ff_bz0 : fdc port map(d => rdatain,  c => clk90, clr => rst, q => bz(0));
ff_bz1 : fdc port map(d => bz(0), c => clk,   clr => rst, q => bz(1));

ff_cz0 : fdc port map(d => rdatain,  c => notclk, clr => rst, q => cz(0));
ff_cz1 : fdc port map(d => cz(0), c => clk,    clr => rst, q => cz(1));

ff_dz0 : fdc port map(d => rdatain,  c => notclk90, clr => rst, q => dz(0));
ff_dz1 : fdc port map(d => dz(0), c => clk90,   clr => rst, q => dz(1));

-- trigger <= "0000000" & phaseConfig;


-- icon : chipscope_icon
--   port map (
--     CONTROL0 => control);

-- ila : chipscope_ila
--   port map (
--     CONTROL => control,
--     CLK => clk,
--     DATA => data,
--     TRIG0 => trigger);

end arch_syncdata;
