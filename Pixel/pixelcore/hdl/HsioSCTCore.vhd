-------------------------------------------------------------------------------
-- Title         : BNL ASIC Test FGPA Core 
-- Project       : LCLS Detector, BNL ASIC
-------------------------------------------------------------------------------
-- File          : BnlAsicCore.vhd
-- Author        : Ryan Herbst, rherbst@slac.stanford.edu
-- Created       : 07/21/2008
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
use work.arraytype.all;
use work.Version.all;

entity HsioPixelCore is 
	generic (
	framedFirstChannel   : integer := 0; --First framed channel
	framedLastChannel    : integer := 7; --Last framed channel
	rawFirstChannel      : integer := 11; --First raw channel
	rawLastChannel       : integer := 14; -- Last raw channel
	buffersize           : integer := 8192; --FIFO size
	bpmDefault           : std_logic := '0'; --BPM on startup
	hitbusreadout        : std_logic := '0' -- hitbus configuration
	);
	port ( 

	-- Master system clock, 250Mhz, 125Mhz
	sysClk250    : in  std_logic;
	sysClk125    : in  std_logic;
	sysRst125    : in  std_logic;
	sysRst250    : in  std_logic;

	-- PGP Clocks
	refClock     : in  std_logic;
	pgpClk       : in  std_logic;
	pgpClk90     : in  std_logic;
	pgpReset     : in  std_logic;

	pgpClkUnbuf  : in std_logic;
	pgpClk90Unbuf: in std_logic;
	sysClkUnbuf  : in std_logic;

	clk320       : in std_logic;
	-- reload firmware
	reload       : out std_logic;

	-- MGT Serial Pins
	mgtRxN       : in  std_logic;
	mgtRxP       : in  std_logic;
	mgtTxN       : out std_logic;
	mgtTxP       : out std_logic;

	-- ATLAS Pixel module pins
	serialin0    : in std_logic_vector(7 downto 0);
	serialout0   : out std_logic_vector(7 downto 0);
	serialin1    : in std_logic_vector(7 downto 0);
	serialout1   : out std_logic_vector(7 downto 0);
	discin       : in std_logic_vector(1 downto 0);
	clock160     : in std_logic;
	clock80      : in std_logic;
	clock40      : in std_logic;

	-- Reset out to PGP Clock generation
	resetOut     : out std_logic;

	-- Debug
	debug         : out std_logic_vector(7 downto 0);
	exttrigger    : in std_logic;
	extrst        : in std_logic;
	extbusy       : out std_logic;
	exttrgclk     : out std_logic;
	exttriggero   : out std_logic;
	extrsto       : out std_logic;

	doricreset    : out std_logic;

	dispDigitA    : out std_logic_vector(7 downto 0);
	dispDigitB    : out std_logic_vector(7 downto 0);
	dispDigitC    : out std_logic_vector(7 downto 0);
	dispDigitD    : out std_logic_vector(7 downto 0);
	dispDigitE    : out std_logic_vector(7 downto 0);
	dispDigitF    : out std_logic_vector(7 downto 0);
	dispDigitG    : out std_logic_vector(7 downto 0);
	dispDigitH    : out std_logic_vector(7 downto 0);

	-- HSIO trigger
	HSIObusy      : out std_logic;
	HSIOtrigger   : in std_logic
	);
end HsioPixelCore;


-- Define architecture
architecture HsioPixelCore of HsioPixelCore is

	component phaseshift
		port ( CLKIN_IN    : in    std_logic; 
		DADDR_IN    : in    std_logic_vector (6 downto 0); 
		DCLK_IN     : in    std_logic; 
		DEN_IN      : in    std_logic; 
		DI_IN       : in    std_logic_vector (15 downto 0); 
		DWE_IN      : in    std_logic; 
		RST_IN      : in    std_logic; 
		CLK0_OUT    : out   std_logic; 
		CLK90_OUT    : out   std_logic; 
		CLK180_OUT    : out   std_logic; 
		CLK270_OUT    : out   std_logic; 
		CLKFX_OUT   : out   std_logic; 
		CLK2X_OUT   : out   std_logic; 
		DRDY_OUT    : out   std_logic; 
		LOCKED_OUT  : out   std_logic; 
		pclkUnbuf   : out   std_logic;
		pclk90Unbuf : out   std_logic;
		pclk180Unbuf: out   std_logic;
		pclk270Unbuf: out   std_logic
		); 
	end component;  
	component tdc
		port ( sysclk: in std_logic;
		sysrst: in std_logic;
		edge1: in std_logic;
		edge2: in std_logic;
		start: in std_logic;
		ready: out std_logic;
		counter1: out std_logic_vector(31 downto 0);
		counter2: out std_logic_vector(31 downto 0)
		);
	end component;
	component ser
		port(clk: 	    in std_logic;
		ld:         out std_logic;
		l1a:        in std_logic;
		go:         in std_logic;
		busy:       out std_logic;
		stop:       in std_logic;
		rst:	    in std_logic;
		d_in:	    in std_logic_vector(15 downto 0);
		d_out:	    out std_logic
		);
	end component;
	component deser
		generic( CHANNEL: std_logic_vector:="1111");
		port(clk: 	    in std_logic;
		rst:	    in std_logic;
		d_in:	    in std_logic;
		enabled:    in std_logic;
		replynow:   in std_logic;
		marker  :   in std_logic;
		d_out:	    out std_logic_vector(15 downto 0);
		ld:         out std_logic;
		sof:        out std_logic;
		eof:        out std_logic
		);
	end component;
	component tdcreadout
		generic ( CHANNEL: std_logic_vector:="1111");
		port(clk: 	    in std_logic;
		slowclock:  in std_logic;
		rst:        in std_logic;
		go:         in std_logic;
		delay:      in std_logic_vector(4 downto 0);
		counter1:   in std_logic_vector(31 downto 0);
		counter2:   in std_logic_vector(31 downto 0);
		trgtime:    in std_logic_vector(63 downto 0);
		deadtime:   in std_logic_vector(63 downto 0);
		status:     in std_logic_vector(14 downto 0);
		marker:     in std_logic;
		l1count:    in std_logic_vector(3 downto 0);
		bxid:       in std_logic_vector(7 downto 0);
		d_out:	    out std_logic_vector(15 downto 0);
		ld:         out std_logic;
		busy:       out std_logic;
		sof:        out std_logic;
		eof:        out std_logic;
		runmode:    in std_logic_vector(1 downto 0);
		eudaqdone:  in std_logic;
		eudaqtrgword: in std_logic_vector(14 downto 0);
		hitbus:     in std_logic_vector(1 downto 0);
		triggerword:in std_logic_vector(7 downto 0)
		);
	end component;          

	component eofcounter 
		port (
		clk: IN std_logic;
		up: IN std_logic;
		ce: IN std_logic;
		aclr: IN std_logic;
		q_thresh0: OUT std_logic;
		q: OUT std_logic_VECTOR(15 downto 0));
	end component;

	component multiplexdata
		port( 
		clk: 	    in std_logic;
		rst:	    in std_logic;
		enabled:    in std_logic;
		channelmask: in std_logic_vector(15 downto 0);
		datawaiting: in std_logic_vector(15 downto 0);
		indatavalid: in std_logic_vector(15 downto 0);
		datain: in dataarray;
		dataout: out std_logic_vector(15 downto 0);
		eofout: out std_logic;
		sofout: out std_logic;
		datavalid: out std_logic;
		reqdata: out std_logic_vector(15 downto 0);
		counter4: out std_logic_vector(31 downto 0);
		counter10b: out std_logic_vector(31 downto 0);
		counter10: out std_logic_vector(31 downto 0)
		);
	end component; 

	-----------------------------------------------------------
	-- DATAFIFO -----------------------------------------------

	component datafifo
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
	end component;
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
	component datafifo16384
		port (
		rst : in std_logic;
		wr_clk : in std_logic;
		rd_clk : in std_logic;
		din : in std_logic_vector(17 downto 0);
		wr_en : in std_logic;
		rd_en : in std_logic;
		dout : out std_logic_vector(17 downto 0);
		full : out std_logic;
		overflow : out std_logic;
		empty : out std_logic;
		valid : out std_logic;
		underflow : out std_logic;
		prog_full : out std_logic
		);
	end component;
	component datafifo1024
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

	-----------------------------------------------------------
	-----------------------------------------------------------

	component dataflag
		port (
		eofin      : in std_logic;
		eofout     : in std_logic;
		datawaiting: out std_logic;
		clk        : in std_logic;
		rst        : in std_logic;
		counter    : out std_logic_vector(15 downto 0)
		);
	end component;
	component dataflag160
		port (
		eofin      : in std_logic;
		eofout     : in std_logic;
		datawaiting: out std_logic;
		clk        : in std_logic;
		rst        : in std_logic;
		counter    : out std_logic_vector(15 downto 0)
		);
	end component;
	component dataflagnew is 
		port (
		eofin      : in std_logic;
		eofout     : in std_logic;
		datawaiting: out std_logic;
		clkin      : in std_logic;
		clkout     : in std_logic;
		rst        : in std_logic
		);
	end component;


	-----------------------------------------------------------
	-----------------------------------------------------------

	component coincidence
		port(
		clk: 	    in std_logic;
		rst:	    in std_logic;
		enabled:    in std_logic;
		channelmask: in std_logic_vector(15 downto 0);
		dfifothresh: in std_logic_vector(15 downto 0);
		trgin: in std_logic;
		serbusy: in std_logic;
		tdcreadoutbusy: in std_logic;
		tdcready: in std_logic;
		starttdc: out std_logic;
		l1a: out std_logic;
		trgdelay: in std_logic_vector(7 downto 0);
		busy: out std_logic;
		coinc: out std_logic;
		coincd: out std_logic
		);
	end component;
	component triggerpipeline 
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
	end component;
	component hitbuspipeline
		port (
		rst        : in std_logic;
		clk        : in std_logic;
		ld         : in std_logic;
		depth      : in std_logic_vector(4 downto 0);
		wordin     : in std_logic_vector(2 downto 0);
		wordout    : out std_logic_vector(31 downto 0)
		);
	end component;
	component wordswapper 
		port (
		rst        : in std_logic;
		clk        : in std_logic;
		wordin     : in std_logic_vector(15 downto 0);
		eofin      : in std_logic;
		eeofin     : in std_logic;
		sofin      : in std_logic;
		validin    : in std_logic;
		wordout    : out std_logic_vector(15 downto 0);
		eofout     : out std_logic;
		eeofout    : out std_logic;
		sofout     : out std_logic;
		validout   : out std_logic
		);
	end component;

	component eudaqTrigger
		port (
		clk        : in std_logic;
		rst        : in std_logic;
		busyin     : in std_logic;
		tdcready   : in std_logic;
		enabled    : in std_logic;
		l1a        : in std_logic;
		trg        : in std_logic;
		done       : out std_logic;
		extbusy    : out std_logic;
		trgword    : out std_logic_vector(14 downto 0);
		trgclk     : out std_logic
		);
	end component;


	-----------------------------------------------------------
	-----------------------------------------------------------

	component deser10b
		port(
		clk: 	    in std_logic;
		rst:	    in std_logic;
		d_in:	    in std_logic;
		align:	    in std_logic;
		d_out:	    out std_logic_vector(9 downto 0);
		ld:         out std_logic
		);
	end component;
	component deser4b
		port(
		clk: 	    in std_logic;
		rst:	    in std_logic;
		d_in:	    in std_logic;
		align:	    in std_logic;
		d_out:	    out std_logic_vector(3 downto 0);
		ld:         out std_logic
		);
	end component;


	-----------------------------------------------------------
	-----------------------------------------------------------

	component framealign
		port (
		clk       : in std_logic;
		rst       : in std_logic;
		d_in      : in std_logic;
		d_out     : out std_logic;
		aligned   : out std_logic
		);
	end component;
	component framealignhitbus
		port (
		clk       : in std_logic;
		rst       : in std_logic;
		d_in      : in std_logic;
		d_out     : out std_logic;
		aligned   : out std_logic
		);
	end component;
	component syncdatac 
		port (
		clk 		: in std_logic ;			-- clock input
		clk90 		: in std_logic ;			-- clock 90 input
		rdatain		: in std_logic;                         -- data input
		rst 		: in std_logic ;			-- reset input
		useaout		: out std_logic ;			-- useA output for cascade
		usebout		: out std_logic ;			-- useB output for cascade
		usecout		: out std_logic ;			-- useC output for cascade
		usedout		: out std_logic ;			-- useD output for cascade
		sdataout	: out std_logic;                      	-- data out
		phaseConfig     : in std_logic
		);                        -- FS: Setting phase configuration flag
	end component;

	component decode_8b10b_wrapper
		PORT (
		CLK        : IN  STD_LOGIC;
		DIN        : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
		DOUT       : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		KOUT       : OUT STD_LOGIC;

		CE         : IN  STD_LOGIC;
		SINIT      : IN  STD_LOGIC;
		CODE_ERR   : OUT STD_LOGIC;
		ND         : OUT STD_LOGIC
		);
	end component;

	component fifo8b10b
		port (
		din: IN std_logic_VECTOR(9 downto 0);
		rd_clk: IN std_logic;
		rd_en: IN std_logic;
		rst: IN std_logic;
		wr_clk: IN std_logic;
		wr_en: IN std_logic;
		almost_empty: OUT std_logic;
		dout: OUT std_logic_VECTOR(9 downto 0);
		empty: OUT std_logic;
		full: OUT std_logic;
		underflow: OUT std_logic
		);
	end component;
	component fifo8b10bnew
		port (
		rst: IN std_logic;
		wr_clk: IN std_logic;
		rd_clk: IN std_logic;
		din: IN std_logic_VECTOR(9 downto 0);
		wr_en: IN std_logic;
		rd_en: IN std_logic;
		dout: OUT std_logic_VECTOR(9 downto 0);
		full: OUT std_logic;
		empty: OUT std_logic;
		almost_empty: OUT std_logic;
		valid: OUT std_logic);
	end component;

	component noframefifo
		port (
		rst: IN std_logic;
		wr_clk: IN std_logic;
		rd_clk: IN std_logic;
		din: IN std_logic_VECTOR(17 downto 0);
		wr_en: IN std_logic;
		rd_en: IN std_logic;
		dout: OUT std_logic_VECTOR(17 downto 0);
		full: OUT std_logic;
		empty: OUT std_logic;
		almost_empty: OUT std_logic;
		valid: OUT std_logic);
	end component;

	component encodepgp
		generic ( CHANNEL: std_logic_vector:="1111");
		port(clk: 	    in std_logic;
		rst:        in std_logic;
		enabled:    in std_logic;
		isrunning:    out std_logic;
		d_in:       in std_logic_vector(7 downto 0);
		k_in:       in std_logic;
		err_in:     in std_logic;
		marker:     in std_logic;
		d_out:	    out std_logic_vector(17 downto 0);
		ldin:       in std_logic;
		ldout:      out std_logic;
		overflow:   out std_logic
		);
	end component;          

	component encodepgpfast 
		generic( CHANNEL: std_logic_vector:="1111");
		port(clk: 	    in std_logic;
		rst:	    in std_logic;
		enabled:    in std_logic;
		fifoempty:  in std_logic;
		fifovalid:  in std_logic;
		d_in:	    in std_logic_vector(9 downto 0);
		d_out:	    out std_logic_vector(17 downto 0);
		ldin:       out std_logic;
		ldout:      out std_logic
		);
	end component;

	component IDELAY
		generic (IOBDELAY_TYPE : string := "DEFAULT"; --(DEFAULT, FIXED, VARIABLE)
		IOBDELAY_VALUE : integer := 0 --(0 to 63)
		);
		port (
		O : out STD_LOGIC;
		I : in STD_LOGIC;
		C : in STD_LOGIC;
		CE : in STD_LOGIC;
		INC : in STD_LOGIC;
		RST : in STD_LOGIC
		);
	end component;
	component OBUF    port ( O : out std_logic; I  : in  std_logic ); end component;
	-- PGP Front End Wrapper

	component BUFGMUX port (O: out std_logic; I0: in std_logic; I1: in std_logic; S: in std_logic); end component;
	component PgpFrontEnd
		generic (
		MgtMode    : string  := "A";
		RefClkSel  : string  := "REFCLK1"
		);
		port (
		pgpRefClk1       : in  std_logic;
		pgpRefClk2       : in  std_logic;
		mgtRxRecClk      : out std_logic;
		pgpClk           : in  std_logic;
		pgpReset         : in  std_logic;
		pgpDispA         : out std_logic_vector(7 downto 0);
		pgpDispB         : out std_logic_vector(7 downto 0);
		resetOut         : out std_logic;
		locClk           : in  std_logic;
		locReset         : in  std_logic;
		cmdEn            : out std_logic;
		cmdOpCode        : out std_logic_vector(7  downto 0);
		cmdCtxOut        : out std_logic_vector(23 downto 0);
		regReq           : out std_logic;
		regOp            : out std_logic;
		regInp           : out std_logic;
		regAck           : in  std_logic;
		regFail          : in  std_logic;
		regAddr          : out std_logic_vector(23 downto 0);
		regDataOut       : out std_logic_vector(31 downto 0);
		regDataIn        : in  std_logic_vector(31 downto 0);
		frameTxEnable    : in  std_logic;
		frameTxSOF       : in  std_logic;
		frameTxEOF       : in  std_logic;
		frameTxEOFE      : in  std_logic;
		frameTxData      : in  std_logic_vector(15 downto 0);
		frameTxAFull     : out std_logic;
		frameRxValid     : out std_logic;
		frameRxReady     : in  std_logic;
		frameRxSOF       : out std_logic;
		frameRxEOF       : out std_logic;
		frameRxEOFE      : out std_logic;
		frameRxData      : out std_logic_vector(15 downto 0);
		valid            : out std_logic;
		eof              :out std_logic;
		sof              :out std_logic;
		mgtRxN           : in  std_logic;
		mgtRxP           : in  std_logic;
		mgtTxN           : out std_logic;
		mgtTxP           : out std_logic;
		mgtCombusIn      : in  std_logic_vector(15 downto 0);
		mgtCombusOut     : out std_logic_vector(15 downto 0)
		);
	end component;

	component bpmencoder
		port (
		clock      : in std_logic;
		rst        : in std_logic;
		clockx2    : in std_logic;
		datain     : in std_logic;
		encode     : in std_logic;
		dataout    : out std_logic
		);
	end component;
	component ila
		PORT (
		CONTROL : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
		CLK : IN STD_LOGIC;
		DATA : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		TRIG0 : IN STD_LOGIC_VECTOR(0 DOWNTO 0));
	end component;

	component icon
		PORT (
		CONTROL0 : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0));
	end component;

	component ODDR port ( 
		Q  : out std_logic;
		CE : in std_logic;
		C  : in std_logic;
		D1 : in std_logic;
		D2 : in std_logic;
		R  : in std_logic;
		S  : in std_logic
		);
	end component;

	component pattern_blk_mem
		port (
		clka: IN std_logic;
		dina: IN std_logic_VECTOR(31 downto 0);
		addra: IN std_logic_VECTOR(9 downto 0);
		ena: IN std_logic;
		wea: IN std_logic_VECTOR(0 downto 0);
		douta: OUT std_logic_VECTOR(31 downto 0);
		clkb: IN std_logic;
		dinb: IN std_logic_VECTOR(31 downto 0);
		addrb: IN std_logic_VECTOR(9 downto 0);
		enb: IN std_logic;
		web: IN std_logic_VECTOR(0 downto 0);
		doutb: OUT std_logic_VECTOR(31 downto 0));
	end component;
	
	component ser32 
		port(	clk: 	    in std_logic;
		ld:         out std_logic;
		go:         in std_logic;
		busy:       out std_logic;
		stop:       in std_logic;
		rst:	    in std_logic;
		d_in:	    in std_logic_vector(31 downto 0);
		d_out:	    out std_logic
		);
	end component;

	-- Local Signals
	signal cmdEn           : std_logic;
	signal cmdOpCode       : std_logic_vector(7  downto 0);
	signal cmdCtxOut       : std_logic_vector(23 downto 0);
	signal readDataValid   : std_logic;
	signal readDataSOF     : std_logic;
	signal readDataEOF     : std_logic;
	signal readDataEOFE    : std_logic;
	signal readData        : std_logic_vector(15 downto 0);
	signal pgpDispA        : std_logic_vector(7 downto 0);
	signal pgpDispB        : std_logic_vector(7 downto 0);
	signal regReq          : std_logic;
	signal regOp           : std_logic;
	signal regAck          : std_logic;
	signal regFail         : std_logic;
	signal regAddr         : std_logic_vector(23 downto 0);
	signal regDataOut      : std_logic_vector(31 downto 0);
	signal regDataIn       : std_logic_vector(31 downto 0);
	signal ack             : std_logic;
	signal err             : std_logic;
	signal eof             : std_logic;
	signal sof             : std_logic;
	signal vvalid          : std_logic;
	signal req             : std_logic;
	signal frameRxValid    : std_logic;
	signal frameRxReady    : std_logic;
	signal frameRxSOF      : std_logic;
	signal frameRxEOF      : std_logic;
	signal frameRxEOFE     : std_logic;
	signal frameRxData     : std_logic_vector(15 downto 0);
	signal regInp          : std_logic;
	signal blockdata       : std_logic_vector(17 downto 0);
	signal configdataout   : std_logic_vector(17 downto 0);
	signal blockcounter    : std_logic_vector(2 downto 0);
	signal handshake       : std_logic;
	signal replynow        : std_logic;
	signal readword        : std_logic;
	signal swapsof         : std_logic;
	signal swappedeof      : std_logic;
	signal oldswappedeof   : std_logic;
	signal gocounter       : std_logic_vector(3 downto 0);
	signal swapvalid       : std_logic;
	signal readvalid       : std_logic;
	signal counter1        : std_logic_vector(3 downto 0);
	signal counter2        : std_logic_vector(3 downto 0);
	signal idcounter       : std_logic_vector(2 downto 0);
	signal daddr           : std_logic_vector (6 downto 0);
	signal denphase        : std_logic;
	signal phaseclk        : std_logic;
	signal phaseclk90      : std_logic;
	signal phaseclk180     : std_logic;
	signal phaseclk270     : std_logic;
	signal o01             : std_logic;
	signal o23             : std_logic;
	signal clockselect     : std_logic_vector(1 downto 0);
	signal phaseclksel     : std_logic;
	signal fxclock         : std_logic;
	signal serclk          : std_logic;
	signal drdy            : std_logic;
	signal drdy2           : std_logic;
	signal lockedfx        : std_logic;
	signal lockedid        : std_logic;
	signal oldlockedid     : std_logic;
	signal lockedphase     : std_logic;
	signal lockednophase   : std_logic;
	signal reqclkphase     : std_logic;
	signal oldreqclkphase  : std_logic;
	signal clkenaphase     : std_logic;
	signal holdrst         : std_logic;
	signal phaserst        : std_logic;
	signal clockrst        : std_logic;
	signal clockrst2       : std_logic;
	signal idctrlrst       : std_logic;
	signal clkdata         : std_logic_vector(15 downto 0);
	signal holdctr         : std_logic_vector(24 downto 0);
	signal clockidctrl     : std_logic;
	signal dreset          : std_logic_vector(23 downto 16);
	signal ena             : std_logic;
	signal cout            : std_logic;
	signal enaold          : std_logic;
	signal pgpEnaOld       : std_logic;
	signal startmeas       : std_logic;
	signal countclk        : std_logic;
	signal clockcountv     : std_logic_vector(16 downto 0);
	signal tdcready        : std_logic;
	signal starttdcreadout : std_logic;
	signal starttdc        : std_logic;
	signal resettdc        : std_logic;
	signal tcounter1       : std_logic_vector(31 downto 0);
	signal tcounter2       : std_logic_vector(31 downto 0);
	signal counterout1     : std_logic_vector(31 downto 0);
	signal counterout2     : std_logic_vector(31 downto 0);
	signal l1a             : std_logic;
	signal oldl1a          : std_logic;
	signal l1amod          : std_logic;
	signal stop            : std_logic;
	signal oldstop         : std_logic;
	signal go              : std_logic;
	signal qout            : std_logic_vector(15 downto 0);
	signal tdcdata         : std_logic_vector(17 downto 0);
	signal tdcld           : std_logic;
	signal datawaiting     : std_logic_vector(15 downto 0);
	signal indatavalid     : std_logic_vector(15 downto 0);
	signal chanld          : std_logic_vector(15 downto 0);
	signal datain          : dataarray;
	signal channeldata     : dataarray;
	signal rxdataout       : dal;
	signal rxdatavalid     : dal;
	signal dataout         : std_logic_vector(15 downto 0);
	signal eofout          : std_logic;
	signal sofout          : std_logic;
	signal datavalid       : std_logic;
	signal reqdata         : std_logic_vector(15 downto 0);
	signal dfifothresh     : std_logic_vector(15 downto 0);
	signal empty           : std_logic;
	signal full            : std_logic;
	signal configfull      : std_logic;
	signal bufoverflow     : std_logic_vector(15 downto 0);
	signal overflow        : std_logic_vector(15 downto 0);
	signal underflow       : std_logic_vector(15 downto 0);
	signal prog_full       : std_logic;
	signal emptyv          : std_logic_vector(15 downto 0);
	signal fullv           : std_logic_vector(15 downto 0);
	signal overflowv       : std_logic_vector(15 downto 0);
	signal underflowv      : std_logic_vector(15 downto 0);
	signal prog_fullv      : std_logic_vector(15 downto 0);
	signal isrunning       : std_logic_vector(15 downto 0);
	signal tdcbusy         : std_logic;
	signal startdc         : std_logic;
	signal coinc           : std_logic;
	signal rst             : std_logic;
	signal softrst         : std_logic;
	signal trigenabled     : std_logic;
	signal exttrgclkeu     : std_logic;
	signal waitfordata     : std_logic;
	signal busy            : std_logic;
	signal marker          : std_logic;
	signal mxdata          : std_logic_vector(15 downto 0);
	signal mxvalid         : std_logic;
	signal mxeof           : std_logic;
	signal mxsof           : std_logic;
	signal coincd          : std_logic;
	signal ldser           : std_logic;
	signal configoverflow  : std_logic;
	signal configunderflow : std_logic;
	signal d_out           : std_logic;
	signal serbusy         : std_logic;
	signal trgbusy         : std_logic;
	signal stdc            : std_logic;
	signal calibmode       : std_logic_vector(1 downto 0);
	signal edge1           : std_logic;
	signal edge2           : std_logic;
	signal delena0         : std_logic;
	signal delena1         : std_logic;
	signal delrst          : std_logic;
	signal delrst1         : std_logic;
	signal delrst2         : std_logic;
	signal delrstf         : std_logic;
	signal delayrst        : std_logic;
	signal startrun        : std_logic;
	signal paused          : std_logic;
	signal nobackpressure  : std_logic;
	signal nobackpress     : std_logic;
	signal reg             : std_logic_vector(31 downto 0);
	signal backprescounter : std_logic_vector(3 downto 0);
	signal cycliccounter   : std_logic_vector(31 downto 0);
	signal period          : std_logic_vector(31 downto 0);
	signal counter4        : std_logic_vector(31 downto 0);
	signal counter10       : std_logic_vector(31 downto 0);
	signal counter10e      : std_logic_vector(31 downto 0);
	signal tdccounter      : std_logic_vector(15 downto 0);
	signal counter4m       : std_logic_vector(31 downto 0);
	signal counter10m      : std_logic_vector(31 downto 0);
	signal cyclic          : std_logic;
	signal frameTxAFull    : std_logic;
	signal channelmask     : std_logic_vector(15 downto 0);
	signal channeloutmask  : std_logic_vector(15 downto 0);
	signal enablereadout   : std_logic_vector(15 downto 0);
	signal phases          : std_logic_vector(31 downto 0);
	signal reply           : std_logic_vector(15 downto 0);
	signal status          : std_logic_vector(31 downto 0);
	signal statusd         : std_logic_vector(31 downto 0);
	signal trgtime         : std_logic_vector(63 downto 0);
	signal trgtimel        : std_logic_vector(63 downto 0);
	signal deadtime        : std_logic_vector(63 downto 0);
	signal deadtimel       : std_logic_vector(63 downto 0);
	signal l1count         : std_logic_vector(3 downto 0);
	signal l1countlong     : std_logic_vector(31 downto 0);
	signal l1countl        : std_logic_vector(3 downto 0);
	signal rstl1count      : std_logic;
	signal disc            : std_logic_vector(3 downto 0);
	signal discs           : std_logic_vector(3 downto 0);
	signal starttdccount   : std_logic_vector(3 downto 0);
	signal trgdelay        : std_logic_vector(7 downto 0);
	signal markercounter   : std_logic_vector(9 downto 0);
	signal conftrg         : std_logic;
	signal ld8b10b         : std_logic_vector(15 downto 0);
	signal ldout8b10b      : std_logic_vector(15 downto 0);
	signal data8b10b       : array10b;
	signal dout8b10b       : array10b;
	signal ldfei4          : std_logic_vector(15 downto 0);
	signal fei4data        : dataarray;
	signal aligned         : std_logic_vector(15 downto 0);
	signal alignout        : std_logic_vector(15 downto 0);
	signal receiveclock    : std_logic;
	signal receiveclock90  : std_logic;
	signal serdesclock     : std_logic;
	signal recdata         : std_logic_vector(15 downto 0);
	signal read8b10bfifo   : std_logic_vector(15 downto 0);
	signal fifo8b10bempty  : std_logic_vector(15 downto 0);
	signal valid8b10b      : std_logic_vector(15 downto 0);
	signal pgpencdatain    : array10b;
	signal selfei4clk      : std_logic_vector(1 downto 0);
	signal trgcount        : std_logic_vector(15 downto 0);
	signal trgcountdown    : std_logic_vector(15 downto 0);

	signal bpm             : std_logic;
	signal oldbpm          : std_logic;
	signal doriccounter    : std_logic_vector(15 downto 0);
	signal doricresetb     : std_logic;
	signal trgin           : std_logic;
	signal triggermask     : std_logic_vector(15 downto 0);
	signal eudaqdone       : std_logic;
	signal eudaqbusy       : std_logic;
	signal eudaqtrgword    : std_logic_vector(14 downto 0);
	signal extrstcounter   : std_logic_vector(3 downto 0);
	signal setdeadtime     : std_logic_vector(15 downto 0);
	signal serialoutb      : std_logic_vector(15 downto 0);
	signal ccontrol        : std_logic_vector(35 downto 0);
	signal cdata           : std_logic_vector(31 downto 0);
	signal ctrig           : std_logic_vector(0 downto 0);
	signal setfifothresh   : std_logic_vector(15 downto 0);

	signal phaseConfig     : std_logic;

	signal hitbus            : std_logic;
	signal hitbusa           : std_logic;
	signal hitbusb           : std_logic;
	signal hitbusop          : std_logic_vector(7 downto 0);
	signal hitbusin          : std_logic_vector(5 downto 0);
	signal latchhitbus       : std_logic_vector(1 downto 0);
	signal latchhitbuscounter : hb;
	signal l1c               : std_logic_vector(4 downto 0);
	signal hbc               : std_logic_vector(4 downto 0);
	signal hbm               : std_logic_vector(1 downto 0);
	signal latchhitbusl1counter : std_logic_vector(4 downto 0);
	signal l1high             : std_logic;
	signal hitbushigh        : std_logic_vector(1 downto 0);
	signal starthitbus        : std_logic_vector(1 downto 0);
	signal starthitbusold     : std_logic_vector(1 downto 0);
	signal starthitbusoldold  : std_logic_vector(1 downto 0);
	signal hitbusword         : hitbusoutput;
	signal hitbusdepth : std_logic_vector(4 downto 0);
	signal tdcreadoutdelay:   std_logic_vector(4 downto 0);

	signal latchtriggerword: std_logic_vector(7 downto 0);
	signal flatch:            std_logic_vector(7 downto 0);
	signal ofprotection      : std_logic;

	signal phaseClkUnbuf : std_logic;
	signal phaseClk90Unbuf : std_logic;
	signal phaseClk180Unbuf : std_logic;
	signal phaseClk270Unbuf : std_logic;

	signal writemem: std_logic;
	signal maxmem: std_logic_vector(9 downto 0);
	signal ld32: std_logic;
	signal oldld32: std_logic;
	signal serdata32: std_logic_vector(31 downto 0);
	signal readpointer: std_logic_vector(9 downto 0);
	signal memout : std_logic;
	signal stop32: std_logic;
	signal go32 : std_logic;
	signal going32: std_logic;
	signal l1route: std_logic;
	signal l1modin: std_logic;
	signal l1memin: std_logic;
	signal outbusy: std_logic;
	signal readmem: std_logic;
	signal bpl: std_logic;

	-- Register delay for simulation
	constant tpd:time := 0.5 ns;
	type DELAR is array (0 to 15) of integer;
	constant setting: DELAR := (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
	attribute syn_noprune : boolean;

	function vectorize(s: std_logic) return std_logic_vector is
		variable v: std_logic_vector(0 downto 0);
		begin
			v(0) := s;
			return v;
		end;

	function vectorize(v: std_logic_vector) return std_logic_vector is
		begin
			return v;
		end;

	begin


	-- PGP Front End
	U_PgpFrontEnd: PgpFrontEnd port map (
	pgpRefClk1    => refClock,       pgpRefClk2    => '0',
	mgtRxRecClk   => open,           pgpClk        => pgpClk,
	pgpReset      => pgpReset,       pgpDispA      => pgpDispA,
	pgpDispB      => pgpDispB,       resetOut      => resetOut,
	locClk        => sysClk125,      locReset      => sysRst125,
	cmdEn         => cmdEn,          cmdOpCode     => cmdOpCode,
	cmdCtxOut     => cmdCtxOut,      regReq        => regReq,
	regInp        => regInp,
	regOp         => regOp,          regAck        => regAck,
	regFail       => regFail,        regAddr       => regAddr,
	regDataOut    => regDataOut,     regDataIn     => regDataIn,
	frameTxEnable => readDataValid,  frameTxSOF    => readDataSOF,
	frameTxEOF    => readDataEOF,    frameTxEOFE   => readDataEOFE,
	frameTxData   => readData,       frameTxAFull  => frameTxAFull,
	frameRxValid  => frameRxValid,
	frameRxReady  => frameRxReady,   frameRxSOF    => frameRxSOF,
	frameRxEOF    => frameRxEOF,     frameRxEOFE   => frameRxEOFE,
	frameRxData   => frameRxData,    valid => vvalid,
	eof => eof, sof => sof,
	mgtRxN        => mgtRxN,
	mgtRxP        => mgtRxP,         mgtTxN        => mgtTxN,
	mgtTxP        => mgtTxP,         mgtCombusIn   => (others=>'0'),
	mgtCombusOut  => open
	);

	dispDigitA<=pgpDispA;
	dispDigitB<=pgpDispB;
	dispDigitC(7 downto 1)<="000000"&bpl;
	dispDigitC(0)<=flatch(7) or flatch(6) or flatch(5) or flatch(4) or flatch(3) or flatch(2) or flatch(1) or flatch(0);
	dispDigitD<=x"0"&FpgaVersion(3 downto 0);
	dispDigitE<=x"00";
	dispDigitF<=x"00";
	dispDigitG<=x"00";
	dispDigitH<=x"00";

	HSIObusy <= busy or paused;
	nobackpressure<= not frameTxAFull;
	--blockdata(15 downto 0) <= frameRxData;
	blockdata(17 downto 16) <= "00";
	frameRxReady <= not configfull;
	vvalid<='0';
	readDataEOFE<='0';
	--readData<=(others=>'0');
	regAck<= drdy2 or ack; 
	regFail<= '0';
	req<='1' when regReq='1' and regAddr(8 downto 7) = "00" else '0';   
	reqclkphase <='1' when regReq='1' and (regAddr(8 downto 4) = "11000" or regAddr(8 downto 4) = "11001" or regAddr(8 downto 4) = "11010") else '0';

	U_phaseshift: phaseshift port map(
	CLKIN_IN  => sysClk125,
	DADDR_IN  => daddr,
	DCLK_IN   => sysClk125,
	DEN_IN    => denphase,
	DI_IN     => regDataOut(15 downto 0),
	DWE_IN    => regOp,
	RST_IN    => clockrst2,
	CLK0_OUT  => phaseclk,
	CLK90_OUT  => phaseclk90,
	CLK180_OUT  => phaseclk180,
	CLK270_OUT  => phaseclk270,
	CLKFX_OUT  => open,
	CLK2X_OUT  => open,
	DRDY_OUT  => drdy2,
	LOCKED_OUT=> lockedphase,
	pclkUnbuf    => phaseClkUnbuf,
	pclk90Unbuf  => phaseClk90Unbuf,
	pclk180Unbuf => phaseClk180Unbuf,
	pclk270Unbuf => phaseClk270Unbuf
	);

	clockrst2<=phaserst;


	with regAddr(8 downto 4) select
		daddr<="1010101" when "11000",
		"0010001" when "11001",
		"0000000" when others;
	process(sysRst125, sysClk125) -- clock interface
		begin
		if (sysRst125='1') then
		holdctr<=(others=>'1');
		elsif(sysClk125'event and sysClk125='1') then
		if (holdctr=x"000000"&'0') then
		phaserst<='0';
		else
		if (holdctr(24)='0') then
		phaserst<='1';
		end if;
		holdctr<=unsigned(holdctr)-1;
		end if;
		if (reqclkphase='1' and oldreqclkphase='0') then
		clkenaphase<='1';
		else
		clkenaphase<='0';
		end if;
		denphase<=clkenaphase;
		oldreqclkphase<=reqclkphase;
		end if;
	end process;

	process(sysClk125,sysRst125) -- test for tdc
	begin
	if(sysRst125='1')then
	ena<='0';
	enaold<='0';
	pgpEnaOld<='0';
	clockselect<="00";
	trgcount<=x"0000";
	calibmode<="00";
	delena0<='0';
	delena1<='0';
	delrst<='0';
	conftrg<='0';
	trgdelay<=x"02";
	triggermask<=x"0000";
	period<=x"00000000";
	reg<=x"00000000";
	setdeadtime<=x"0007";
	channelmask<=x"0000";
	channeloutmask<=x"0000";
	phases <= (others =>'0');
	bpm<=bpmDefault;
	hitbusop<=x"00";
	l1c<="01111";
	hbc<="01111";
	hbm<="11";
	setfifothresh<=x"efff";
	ofprotection<='0';
	writemem<='0';
	maxmem<="0000000000";
	l1route<='0';
	hitbusdepth<="00000";
	tdcreadoutdelay<="00000";
	elsif(rising_edge(sysClk125))then
	if(req='1' and pgpEnaOld='0')then
	ena<='1';
	case regOp is
	when '1' => -- Write
	case regAddr(4 downto 0) is
	when "00001" => -- Start TDC measurement when in calib mode
	startmeas<='1';
	when "00010" => -- Clock select for calib
	clockselect<=regDataOut(1 downto 0);
	when "00011" => -- Select calib mode
	calibmode<= regDataOut(1 downto 0);
	-- 0 is normal
	-- 1 is tdc calib
	-- 2 is eudaq
	when "00000" => -- Set channelmask
	channelmask<=regDataOut(15 downto 0);
	when "00100" => -- Switch TDC/Trigger data on and off
	channeloutmask(10)<=regDataOut(0);
	when "00101" => -- Increment disc 0 delay
	delena0<='1';
	when "00110" => -- Increment disc 1 delay
	delena1<='1';
	when "00111" => -- reset input delays
	delrst<='1';
	when "01000" => -- Set trigger delay
	conftrg<='1';
	if(unsigned(regDataOut(7 downto 0))<2)then
	trgdelay<=x"02";
	else
	trgdelay<=regDataOut(7 downto 0);
	end if;
	when "01001" => -- Set cyclic trigger period
	period<=regDataOut;
	when "01010" => -- Clock select for receive clock
	selfei4clk<=regDataOut(1 downto 0);
	when "01101" => -- enable data output
	channeloutmask(8 downto 0)<=regDataOut(8 downto 0);
	channeloutmask(9)<='1';
	channeloutmask(15 downto 10)<=regDataOut(15 downto 10);
	when "01011" => -- Set trigger mask -1 is scintillator
						 -- 2 is cyclic
						 -- 4 is external
						 -- 8 is external (HSIO)
						 -- 16 is hitbus
	triggermask<=regDataOut(15 downto 0);
	when "01110" => 
	trgcount<=regDataOut(15 downto 0);
	when "01111" =>
	setdeadtime<=regDataOut(15 downto 0);
	when "10001" =>
	phases<=regDataOut;
	when "10010" =>  -- write a word into the command stream buffer
	writemem<='1';
	when "10011" => -- clear the command stream buffer
	maxmem<="0000000000";
	when "10100" =>
	bpm<=regDataOut(0);
	when "10101" =>
	hitbusop<=regDataOut(7 downto 0);
	when "10110" =>
	l1c<=regDataOut(4 downto 0);
	when "10111" =>
	hbc<=regDataOut(4 downto 0);
	when "11000" =>
	hbm<=regDataOut(1 downto 0);
	when "11001" =>
	setfifothresh<=regDataOut(15 downto 0);
	when "11010" =>
	ofprotection<=regDataOut(0);
	when "11011" =>
	l1route<=regDataOut(0);
	when "11100" =>
	hitbusdepth <= regDataOut(4 downto 0);
	when "11101" =>
	tdcreadoutdelay <= regDataOut(4 downto 0);
	when others =>

	end case;
	when '0' => -- Read
	startmeas<='0';
	case regAddr(3 downto 0) is
	when "0000" =>
	regDataIn<=tcounter1;
	when "0001" =>
	regDataIn<=tcounter2;
	when "0010" =>
	regDataIn<=x"0000000"&"000"&tdcready;
	when "0011" =>
	regDataIn<=status;
	when "0100" =>
	regDataIn<=statusd;
	when "0101" =>
	regDataIn<=trgtimel(63 downto 32);
	when "0110" =>
	regDataIn<=trgtimel(31 downto 0);
	when "0111" =>
	regDataIn<=deadtimel(63 downto 32);
	when "1000" =>
	regDataIn<=deadtimel(31 downto 0);
	when "1001" =>
	regDataIn<=counter4;
	when "1010" =>
	regDataIn<=counter10;
	when "1011" =>
	regDataIn<=l1countlong;
	when "1100" =>
	regDataIn<=counter4m;
	when "1101" =>
	regDataIn<=FpgaVersion;
	when "1110" =>
	regDataIn<=reg;
	when "1111" =>
	regDataIn<=channeloutmask&channelmask;
	when others =>
	end case;
	when others =>
	end case;
	else
	if(writemem='1')then
	maxmem<=unsigned(maxmem)+1;
	writemem<='0';
	end if;
	startmeas<='0';
	resettdc<='0';
	ena<='0';
	delena0<='0';
	delena1<='0';
	delrst<='0';
	conftrg<='0';
	extrsto<='0';
	end if;
	pgpEnaOld<=req;
	enaold<=ena;
	ack<=enaold;
	err<='0';
	end if;
	end process;
	process (sysRst125, sysClk125) begin
	if(sysRst125='1')then
	startrun<='0';
	softrst<='0';
	trigenabled<='0';
	rstl1count<='0';
	marker<='0';
	reload <='1';
	markercounter<="0000000000";
	phaseConfig <='0';
	elsif rising_edge(sysClk125) then
	if(cmdEn='1')then
	if(cmdOpCode=x"03")then -- start run
	softrst<='1';
	startrun<='1';
	trgcountdown<=trgcount; -- for runs with a finite number of events.
	elsif(cmdOpCode=x"04")then -- pause run
	trigenabled<='0';
	paused<='1';
	elsif(cmdOpCode=x"05")then -- stop run
	trigenabled<='0';
	paused<='0';
	elsif(cmdOpCode=x"06")then -- resume run
	trigenabled<='1';
	paused<='0';
	elsif(cmdOpCode=x"07")then -- resume run and set marker after delay
	markercounter<="1111111111";
	elsif(cmdOpCode=x"08")then -- Reboot
	reload<='0';          
	elsif(cmdOpCode=x"09")then -- soft reset
	softrst<='1';
	elsif(cmdOpCode=x"10")then -- FS: Write new phase configuration from phase recognition
	phaseConfig <= '1';
	end if;
	elsif(startrun='1')then
	softrst<='0';
	startrun<='0';
	trigenabled<='1';
	paused<='0';
	elsif(softrst='1')then
	softrst<='0';
	elsif(trgcountdown=x"0001")then -- stop run
	trigenabled<='0';
	paused<='0';
	elsif(markercounter="0000000001")then
	marker<='1';
	trigenabled<='1';
	paused<='0';
	rstl1count<='1';
	else
	marker<='0';
	rstl1count<='0';
	phaseConfig<='0';
	end if;
	if(markercounter/="0000000000")then
	markercounter<=unsigned(markercounter)-1;
	end if;
	if(l1a='1' and trgcountdown/=x"0000")then
	trgcountdown<=unsigned(trgcountdown)-1;
	end if;
	end if;
	end process;
	rst<= sysRst125 or softrst; 

	--process(sysClk125) begin
	--if(rising_edge(sysClk125))then
	--backprescounter<=unsigned(backprescounter)+1;
	--if(backprescounter="0000")then
	--nobackpress<='1';
	--else
	--nobackpress<='0';
	--end if;
	--end if;
	--end process;
	process(rst, sysClk125) begin
	if(rst='1')then
	extrstcounter<=x"0";
	elsif(rising_edge(sysClk125))then
	if(extrst='1')then
	extrstcounter<=unsigned(extrstcounter)+1;
	end if;
	end if;
	end process;
	process(sysClk125,rst) begin
	if(rst='1')then
	cycliccounter<=(others=>'0');
	cyclic<='0';
	elsif(rising_edge(sysClk125))then
	if(period/=x"00000000" and cycliccounter=period)then
	cycliccounter<=(others=>'0');
	cyclic<='1';
	--     elsif(period/=x"00000000" and (cycliccounter<x"00000020"))then
	--       cycliccounter<=unsigned(cycliccounter)+1;
	--       cyclic<='1';
	else
	cycliccounter<=unsigned(cycliccounter)+1;
	cyclic<='0';
	end if;
	end if;
	end process;
	doricreset<=doricresetb;
	process(sysClk125, sysRst125) -- reset logic for DORIC
	begin
	if(sysRst125='1') then
	doricresetb<='1';
	doriccounter<=x"0000";
	oldbpm<='0';
	elsif(sysClk125'event and sysClk125='1') then
	oldbpm<=bpm;
	if(bpm='1' and oldbpm='0')then
	doricresetb<='0';
	doriccounter<=x"ffff";
	elsif(doriccounter/=x"0000")then
	doriccounter<=unsigned(doriccounter)-1;
	end if;
	if(doriccounter=x"0001")then
	doricresetb<='1';
	end if;
	end if;
	end process;

	process(sysClk125,rst) begin
	if(rst='1')then
	counter4<=(others=>'0');
	counter10<=(others=>'0');
	counter4m<=(others=>'0');
	counter10m<=(others=>'0');
	elsif(rising_edge(sysClk125))then
	if(mxsof='1' and mxvalid='1')then
	counter4<=unsigned(counter4)+1;
	end if;
	if(mxeof='1' and mxvalid='1')then
	counter10<=unsigned(counter10)+1;
	end if;
	if(mxsof='1')then
	counter4m<=unsigned(counter4m)+1;
	end if;
	if(mxvalid='1' and mxeof='1')then
	counter10m<=unsigned(counter10m)+1;
	end if;
	end if;
	end process;
	process (rst, sysClk125) begin
	if(rst='1')then
	status<=x"00000000";
	statusd<=x"00000000";
	l1count<=x"1";
	l1countlong<=x"00000000";
	starttdccount<=x"1";
	l1countl<=x"1";
	trgtime<=x"0000000000000000";
	trgtimel<=x"0000000000000000";
	deadtime<=x"0000000000000000";
	deadtimel<=x"0000000000000000";
	elsif (rising_edge(sysClk125)) then
	oldl1a<=l1a;
	if(trigenabled='1' or paused='1')then
	trgtime<=unsigned(trgtime)+1;
	end if;
	if(busy='1' or paused='1')then
	deadtime<=unsigned(deadtime)+1;
	end if;
	if(rstl1count='1')then
	l1count<=x"1";
	elsif(l1a='1')then
	l1countl<=l1count;
	l1count<=unsigned(l1count)+1;
	if(oldl1a='0')then
	l1countlong<=unsigned(l1countlong)+1;
	end if;
	trgtimel<=trgtime;
	deadtimel<=deadtime;
	end if;
	if(starttdc='1')then
	starttdccount<=unsigned(starttdccount)+1;
	end if;
	status(10 downto 0)<= dfifothresh(10 downto 0);
	status(11)<= paused;
	status(12)<= frameTxAFull;

	--statusd(10 downto 0)<= statusd(10 downto 0) or underflow;
	statusd(3 downto 0) <= l1count;
	statusd(7 downto 4) <= starttdccount;
	statusd(8)<=coinc;
	statusd(10 downto 9) <=(others=>'0');
	statusd(21 downto 11)<= statusd(21 downto 11) or overflow(10 downto 0);
	statusd(22)<=statusd(22) or configunderflow;
	statusd(23)<=statusd(23) or configoverflow;
	statusd(24)<=busy;
	statusd(25)<=tdcbusy;
	--statusd(26)<=extbusy;
	statusd(26)<='0';
	statusd(27)<=not tdcready;
	end if;
	end process;

	B01: BUFGMUX
	port map(
	O=> o01,
	I0 => phaseclkUnbuf,
	I1 => phaseclk90Unbuf,
	S => clockselect(0)
	);
	B02: BUFGMUX
	port map(
	O=> o23,
	I0 => phaseclk180Unbuf,
	I1 => phaseclk270Unbuf,
	S => clockselect(0)
	);
	B04: BUFGMUX
	port map(
	O=> phaseclksel,
	I0 => o01,
	I1 => o23,
	S => clockselect(1)
	);

	coin: coincidence
	port map(
	clk=>sysClk125,
	rst=>rst,
	enabled=>trigenabled,
	channelmask=>channeloutmask,
	dfifothresh=>dfifothresh,
	trgin=>trgin,
	serbusy=>outbusy,
	tdcreadoutbusy=>tdcbusy,
	tdcready=> tdcready,
	starttdc=>starttdc,
	l1a=> l1a,
	--trgdelay=> trgdelay,
	trgdelay=>x"02",
	busy=> busy,
	coinc=> coinc,
	coincd=> coincd
	);

	outbusy<=trgbusy or going32;
	l1modin<=l1a and not l1route;
	l1memin<=l1a and l1route;
	trgpipeline: triggerpipeline
	port map(
	rst=> sysRst125,
	clk=> sysClk125,
	L1Ain=> l1modin, -- was l1a
	L1Aout=> l1amod,
	configure=> conftrg,
	delay => trgdelay,
	busy => trgbusy,
	deadtime => setdeadtime
	);
	process(sysClk125, sysRst125) begin
	if(sysRst125='1')then
	delrst1<='0';
	delrst2<='0';
	delrstf<='0';
	elsif(rising_edge(sysClk125))then
	if(delrst='1')then
	delrst1<='1';
	delrst2<='1';
	delrstf<='1';
	else
	delrstf<=delrst1;
	delrst1<=delrst2;
	delrst2<='0';
	end if;
	end if; 
	end process;

	delayrst<= delrstf or sysRst125;
	delay0 : IDELAY
	generic map (
			 IOBDELAY_TYPE => "VARIABLE", -- Set to DEFAULT for -- Zero Hold Time Mode
			 IOBDELAY_VALUE => 0 -- (0 to 63)
			 )
	port map (
		O => disc(0),
		I => discin(0),
		C => sysClk125,
		CE => delena0,
		INC => '1',
		RST => delayrst 
		);
	delay1: IDELAY
	generic map (
			 IOBDELAY_TYPE => "VARIABLE", -- Set to DEFAULT for -- Zero Hold Time Mode
			 IOBDELAY_VALUE => 0 -- (0 to 63)
			 )
	port map (
		O => disc(1),
		I => discin(1),
		C => sysClk125,
		CE => delena1,
		INC => '1',
		RST => delayrst 
		);
	trgin<= (triggermask(2) and exttrigger)
	or (triggermask(3) and HSIOtrigger)
	or (triggermask(1) and cyclic)
	or (triggermask(4) and hitbus)
	or (triggermask(0) and disc(0) and disc(1));
	exttriggero<=disc(0);
	process(rst, l1a) begin
	if(rst='1')then
	latchtriggerword<=x"00";
	elsif(rising_edge(l1a))then
	latchtriggerword(7 downto 5)<="000";
	latchtriggerword(4)<=triggermask(4) and hitbus;
	latchtriggerword(3)<=triggermask(3) and HSIOtrigger;
	latchtriggerword(2)<=triggermask(2) and exttrigger;
	latchtriggerword(1)<=triggermask(1) and cyclic;
	latchtriggerword(0)<=triggermask(0) and disc(0) and disc(1);
	end if;
	end process;

	with hitbusop(3) select 
	hitbusa<= (hitbusin(0) and hitbusop(0)) or (hitbusin(1) and hitbusop(1)) or (hitbusin(2) and hitbusop(2)) when '0',
	(hitbusin(0) or not hitbusop(0)) and (hitbusin(1) or not hitbusop(1)) and (hitbusin(2) or not hitbusop(2)) 
	and (hitbusop(0) or hitbusop(1) or hitbusop(2)) when '1',
	'0' when others;
	with hitbusop(7) select 
	hitbusb<= (hitbusin(3) and hitbusop(4)) or (hitbusin(4) and hitbusop(5)) or (hitbusin(5) and hitbusop(6)) when '0',
	(hitbusin(3) or not hitbusop(4)) and (hitbusin(4) or not hitbusop(5)) and (hitbusin(5) or not hitbusop(6)) 
	and  (hitbusop(4) or hitbusop(5) or hitbusop(6)) when '1',
	'0' when others;
	hitbus <= hitbusa or hitbusb;

	hblogic: for I in 0 to 1 generate
	process(rst, sysClk125) begin
	if(rst='1')then
	latchhitbuscounter(I)<=(others=>'0');
	hitbushigh(I)<='0';
	starthitbusold(I)<='0';
	starthitbusoldold(I)<='0';
	elsif(rising_edge(sysClk125))then
	starthitbusold(I)<=starthitbus(I);
	starthitbusoldold(I)<=starthitbusold(I);
	if(latchhitbuscounter(I)/="00000")then
	latchhitbuscounter(I)<=unsigned(latchhitbuscounter(I))-1;
	elsif(starthitbusoldold(I)='1')then
	latchhitbuscounter(I)<=hbc;
	hitbushigh(I)<='1';
	else
	hitbushigh(I)<='0';
	end if;
	if(eudaqdone='1')then
	latchhitbus(I)<='0';
	elsif ((hbm(0)='0' or l1high='1') and (hbm(1)='0' or hitbushigh(I)='1'))then
	latchhitbus(I)<='1';
	end if;
	end if;

	end process;

	process(rst, starthitbusoldold(I), hitbusin(I)) begin
	if(rst='1' or starthitbusoldold(I)='1') then
	starthitbus(I)<='0';
	elsif(rising_edge(hitbusin(I)))then
	starthitbus(I)<='1';
	end if;
	end process;


	end generate hblogic;

	process(rst, sysClk125) begin
	if(rst='1')then
	latchhitbusl1counter<=(others=>'0');
	l1high<='0';
	elsif(rising_edge(sysClk125))then
	if(latchhitbusl1counter/="00000")then
	latchhitbusl1counter<=unsigned(latchhitbusl1counter)-1;
	elsif(l1a='1')then
	latchhitbusl1counter<=l1c;
	l1high<='1';  
	else
	l1high<='0';
	end if;
	end if;
	end process;

	-- TDC config
	with calibmode select
	edge1<= sysClk125 when "01", -- tdc calib  is special
	coinc when others;
	with calibmode select
	edge2<= phaseclksel when "01", -- tdc calib
	sysClk125 when others;

	stdc<= startmeas when calibmode="01" else starttdc;
	thetdc: tdc
	port map(
	sysclk=>sysClk125,
	sysrst=>rst,
	edge1=> edge1,
	edge2=> edge2,
	start=>stdc,
	ready=>tdcready,
	counter1=>tcounter1,
	counter2=>tcounter2
	);           
	hr1: if(hitbusreadout='1') generate
	counterout1<=hitbusword(0);
	counterout2<=hitbusword(1);
	end generate hr1;
	hr2: if(hitbusreadout='0') generate
	counterout1<=tcounter1;
	counterout2<=tcounter2;
	end generate hr2;
	-- Filter out the message header. The only interesting thing is the handshake
	process (rst,sysClk125) begin
	if(rst='1')then
	blockcounter<="000";
	readword<='0';
	handshake<='0';
	swapsof<='0';
	gocounter<=x"0";
	oldswappedeof<='0';
	elsif rising_edge(sysClk125) then
	if(frameRxValid='1' and frameRxSOF='1')then
	blockcounter<="111";
	elsif(blockcounter /= "000")then
	blockcounter<=unsigned(blockcounter)-1;
	if(blockcounter="110")then
	handshake<=frameRxData(0);
	elsif(blockcounter="001")then
	readword<='1';
	swapsof<='1';
	end if;
	elsif(frameRxEOF='1')then
	swapsof<='0';
	readword<='0';
	else
	swapsof<='0';
	end if;
	oldswappedeof<=swappedeof;
	if(swappedeof='1' and oldswappedeof='0') then
	if(stop='0')then
	go<='1';
	else
	gocounter<=x"4";
	end if;
	elsif(gocounter/=x"0")then
	gocounter<=unsigned(gocounter)-1;
	if(gocounter=x"1")then
	go<='1';
	end if;
	else
	go<='0';
	end if;
	end if;
	end process;
	readvalid<=readword and frameRxValid;
	process (sysClk125,sysRst125) begin
	if(sysRst125='1')then
	oldstop<='0';
	elsif rising_edge(sysClk125) then
	oldstop<=stop;
	if (stop='1' and oldstop='0')then
	replynow<=handshake;
	else
	replynow<='0';
	end if;
	end if;
	end process;
	swapconfig: wordswapper 
	port map(
	rst=>rst,
	clk=>sysClk125,
	wordin=>frameRxData,
	eofin=>frameRxEOF,
	eeofin=>'0',
	sofin=>swapsof,
	validin=>readvalid,
	wordout=>blockdata(15 downto 0),
	eofout=>swappedeof,
	eeofout=>open,
	sofout=>open,
	validout=>swapvalid
	);
	theconfigfifo: datafifo16384
	port map (
	din => blockdata,
	rd_clk => sysClk125,
	rd_en => ldser,
	rst => sysRst125,
	wr_clk => sysClk125,
	wr_en => swapvalid,
	dout => configdataout,
	empty => stop,
	full => configfull,
	overflow => open,
	prog_full => open,
	underflow => open);
	theser: ser
	port map(
	clk=>sysClk125,
	ld=>ldser,
	--       l1a=>l1a,
	l1a=>l1amod,
	go=>go,
	busy=>serbusy,
	stop=>stop,
	rst=>rst,
	d_in=>configdataout(15 downto 0),
	d_out=>d_out
	);

	process (sysClk125, sysRst125) begin
	if(sysRst125='1')then
	oldld32<='0';
	stop32<='1';
	readpointer<="0000000000";
	elsif rising_edge(sysClk125)then
	oldld32<=ld32 or l1memin;
	if(l1memin='1' and going32 ='0' and maxmem/="0000000000")then -- serialize trigger sequence
	stop32<='0';
	end if;
	if(going32='1')then
	if(oldld32='1' and ld32='0' )then
	if(readpointer=unsigned(maxmem)-1)then
	stop32<='1';
	readpointer<="0000000000";      
	else
	readpointer<=unsigned(readpointer)+1;
	end if;
	end if;
	end if;
	end if;
	end process;

	readmem<=ld32 or l1memin;
	configmem : pattern_blk_mem
	port map (
	clka => sysClk125,
	dina => regDataOut,
	addra => maxmem,
	ena => writemem,
	wea => vectorize('1'),
	douta => open,
	clkb => sysClk125,
	dinb => (others=>'0'),
	addrb => readpointer,
	enb => readmem,
	web => vectorize('0'),
	doutb => serdata32);

	theser32: ser32
	port map(
	clk => sysClk125,
	ld => ld32,
	go => l1memin,
	busy => going32,
	stop => stop32,
	rst => sysRst125,
	d_in => serdata32,
	d_out => memout);


	fanout: for I in 0 to 15 generate
	bpmenc: bpmencoder
	port map(
	clock=>sysClk125,
	rst=>sysRst125,
	clockx2=>sysClk250,
	datain=>serialoutb(I),
	encode=>bpm,
	dataout=>serialout(I));
	serialoutb(I)<= (d_out or memout) when channelmask(I)='1' and doricresetb='1' else '0';   
	end generate fanout;

	pgpack: deser
	generic map( CHANNEL=>x"9" )
	port map (
	clk       => sysClk125,
	rst       => sysRst125,
	d_in      => '0',
	enabled   => channeloutmask(9),
	replynow  => replynow,
	marker =>'0',
	d_out     => channeldata(9)(15 downto 0),
	ld        => chanld(9),
	sof       => channeldata(9)(16),
	eof       => channeldata(9)(17)
	);
	pgpackfifo : datafifo1024
	port map (
	din => channeldata(9),
	rd_clk => sysClk125,
	rd_en => reqdata(9),
	rst => rst,
	wr_clk => sysClk125,
	wr_en => chanld(9),
	dout => datain(9),
	empty => open,
	full => open,
	overflow => overflow(9),
	prog_full => dfifothresh(9),
	valid => indatavalid(9),
	underflow => underflow(9));
	pgpackdataflag: dataflag
	port map(
	eofin=>channeldata(9)(17),
	eofout=>datain(9)(17),
	datawaiting=> datawaiting(9),
	clk=>sysClk125,
	rst=>rst,
	counter=>open
	);


	CHANNELREADOUT:
	for I in rawFirstChannel to rawLastChannel generate
	enablereadout0(I)<=channeloutmask0(I) and ((trigenabled and not ofprotection) or not dfifothresh0(I)); 
	enablereadout1(I)<=channeloutmask1(I) and ((trigenabled and not ofprotection) or not dfifothresh1(I)); 
	channelreadout0: deser
	generic map( CHANNEL=> std_logic_vector(conv_unsigned(I,4)))
	port map (
	clk       => sysClk125,
	rst       => sysRst125,
	d_in      => serialin0(I),
	enabled   => enablereadout0(I),
	replynow => '0',
	marker    => marker,
	d_out     => channeldata0(I)(15 downto 0),
	ld        => chanld0(I),
	sof       => channeldata0(I)(16),
	eof       => channeldata0(I)(17)
	);
	channelreadout1: deser
	generic map( CHANNEL=> std_logic_vector(conv_unsigned(I,4)))
	port map (
	clk       => sysClk125,
	rst       => sysRst125,
	d_in      => serialin1(I),
	enabled   => enablereadout1(I),
	replynow => '0',
	marker    => marker,
	d_out     => channeldata1(I)(15 downto 0),
	ld        => chanld1(I),
	sof       => channeldata1(I)(16),
	eof       => channeldata1(I)(17)
	);
	channelfifo0 : datafifo8192
	port map (
	din => channeldata0(I),
	rd_clk => sysClk125,
	rd_en => reqdata0(I),
	rst => rst,
	wr_clk => sysClk125,
	wr_en => chanld0(I),
	dout => datain0(I),
	empty => open,
	full => open,
	overflow => overflow0(I),
	prog_full => dfifothresh0(I),
	valid => indatavalid0(I),
	underflow => underflow0(I));
	channeldataflag: dataflag
	port map(
	eofin=>channeldata0(I)(17),
	eofout=>datain0(I)(17),
	datawaiting=> datawaiting0(I),
	clk=>sysClk125,
	rst=>rst,
	counter=>open
	);
	channelfifo1 : datafifo8192
	port map (
	din => channeldata1(I),
	rd_clk => sysClk125,
	rd_en => reqdata1(I),
	rst => rst,
	wr_clk => sysClk125,
	wr_en => chanld1(I),
	dout => datain1(I),
	empty => open,
	full => open,
	overflow => overflow1(I),
	prog_full => dfifothresh1(I),
	valid => indatavalid1(I),
	underflow => underflow1(I));
	channeldataflag: dataflag
	port map(
	eofin=>channeldata1(I)(17),
	eofout=>datain1(I)(17),
	datawaiting=> datawaiting1(I),
	clk=>sysClk125,
	rst=>rst,
	counter=>open
	);
	end generate CHANNELREADOUT;

	starttdcreadout<=l1a and channeloutmask(10);

	thereeadout: tdcreadout
	generic map(CHANNEL=>"1010")
	port map(
	clk=>pgpClk,
	slowclock=>sysClk125,
	rst=>rst,
	go=>starttdcreadout,
	delay=>tdcreadoutdelay,
	counter1=>counterout1,
	counter2=>counterout2,
	trgtime=>trgtimel,
	deadtime=>deadtimel,
	status=>status(14 downto 0),
	marker=>marker,
	l1count=>l1countl,
	bxid=>trgtimel(7 downto 0),
	d_out=>tdcdata(15 downto 0),
	ld=>tdcld,
	busy=>tdcbusy,
	sof=>tdcdata(16),
	eof=>tdcdata(17),
	runmode => calibmode,
	eudaqdone => eudaqdone,
	eudaqtrgword => eudaqtrgword,
	hitbus => latchhitbus,
	triggerword => latchtriggerword
	);
	tdcfifo : datafifo
	generic map( buffersize => buffersize)
	port map (
	din => tdcdata,
	rd_clk => sysClk125,
	rd_en => reqdata(10),
	rst => rst,
	wr_clk => pgpClk,
	wr_en => tdcld,
	dout => datain(10),
	empty => empty,
	full => full,
	overflow => overflow(10),
	prog_full => dfifothresh(10),
	valid => indatavalid(10),
	underflow => underflow(10));
	--tdcdataflag: dataflag
	--port map(
	--eofin=>tdcdata(17),
	--eofout=>datain(10)(17),
	--datawaiting=> datawaiting(10),
	--clk=>sysClk125,
	--rst=>rst,
	--counter=>tdccounter
	--);
	tdcdataflag: dataflagnew
	port map(
	eofin=>tdcdata(17),
	eofout=>datain(10)(17),
	datawaiting=>datawaiting(10),
	clkin=>pgpClk,
	clkout=>sysClk125,
	rst=>rst);

	multiplexer: multiplexdata
	port map(
	clk=>sysClk125,
	rst=>rst,
	enabled=>nobackpressure,
	channelmask=>channeloutmask,
	datawaiting=>datawaiting,
	indatavalid => indatavalid,
	datain=>datain,
	dataout=>mxdata,
	eofout=>mxeof,
	sofout=>mxsof,
	datavalid=>mxvalid,
	reqdata=>reqdata,
	counter4=>open,
	counter10b=>counter10e,
	counter10=>open
	);
	swapdata: wordswapper 
	port map(
	rst=>rst,
	clk=>sysClk125,
	wordin=>mxdata,
	eofin=>mxeof,
	eeofin=>'0',
	sofin=>mxsof,
	validin=>mxvalid,
	wordout=>readData,
	eofout=>readDataEOF,
	eeofout=>open,
	sofout=>readDataSOF,
	validout=>readDataValid
	);
	eudettrg: eudaqTrigger
	port map(
	clk => sysClk125,
	rst => rst,
	busyin => busy,
	tdcready => tdcready,
	enabled =>calibmode(1),
	l1a  => l1a,
	trg  => exttrigger,
	done => eudaqdone,
	extbusy => extbusy,
	trgword => eudaqtrgword,
	trgclk => exttrgclkeu );

	exttrgclk<=exttrgclkeu or paused or not trigenabled;

	FULLDISPLAY:
	for I in 0 to 7 generate
	process (rst, dfifothresh(I)) begin
	if(rst='1')then
	flatch(I)<='0';
	elsif(rising_edge(dfifothresh(I)))then
	flatch(I)<='1';
	end if;
	end process;  
	end generate FULLDISPLAY; 
	process (rst, frameTxAFull) begin
	if(rst='1')then
	bpl<='0';
	elsif(rising_edge(frameTxAFull))then
	bpl<='1';
	end if;
	end process;

	CLKFEI4: BUFGMUX
	port map(
	O=> receiveclock,
	I0 => phaseclkUnbuf,
	I1 => pgpClkUnbuf,
	S => selfei4clk(1)
	);
	CLKFEI490: BUFGMUX
	port map(
	O=> receiveclock90,
	I0 => phaseclk90Unbuf,
	I1 => pgpClk90Unbuf,
	S => selfei4clk(1)
	);

	--   receiveclock<=pgpClk;
	--   serdesclock<=clk320;
	--receiveclock90<=pgpClk90;
	--debug(7)<=rxdataout(0)(0);
	--    debug(6)<=rxdataout(0)(1);
	FRAMEDCHANNELREADOUT:
	for I in framedFirstChannel to framedLastChannel generate
	receivedata: syncdatac
	port map(
	phaseConfig => phaseConfig,
	clk => receiveclock,
	clk90 => receiveclock90,
	rdatain => serialin(I),
	--rdatain => IOMXOUT(1),
	rst => sysRst125,
	useaout => open,
	usebout => open,
	usecout => open,
	usedout => open,
	--        useain => phases(I*4),
	--        usebin => phases(I*4+1),
	--        usecin => phases(I*4+2),
	--        usedin => phases(I*4+3),
	sdataout => recdata(I));
	FE_CHANNEL: if ((I/=3 and I/=7) or hitbusreadout='0') generate
	alignframe: framealign
	port map(
	clk => receiveclock,
	rst => rst,
	d_in => recdata(I),
	d_out => alignout(I),
	aligned => aligned(I)
	);
	--    rxsynch: rx_sync
	--      port map( rst => rst,
	--            clk_data => receiveclock,
	--            clk_serdes => serdesclock,
	--            data_in => serialin(I),
	--            data_out => rxdataout(I),
	--            data_valid => rxdatavalid(I)
	--            );
	--    desernew: data_alignment
	--      port map( clk => receiveclock,
	--            reset => rst,
	--            din => rxdataout(I),
	--            din_valid => rxdatavalid(I),
	--            dout => data8b10b(I),
	--            dout_valid => ld8b10b(I),
	--            dout_sync => open
	--            );
	deser8b10b: deser10b
	port map(
	clk => receiveclock,
	rst => rst,
	d_in => alignout(I),
	align => aligned(I),
	d_out => data8b10b(I),
	ld => ld8b10b(I)
	);
	decoder8b10b: decode_8b10b_wrapper
	port map(
	CLK => receiveclock,
	DIN => data8b10b(I),
	DOUT => dout8b10b(I)(7 downto 0),
	KOUT => dout8b10b(I)(8),
	CE => ld8b10b(I),
	SINIT => rst,
	CODE_ERR =>dout8b10b(I)(9),
	ND =>ldout8b10b(I)
	);
	--   decoder8b10b: decode_8b10b_wrapper
	--     port map(
	--       CLK => ld8b10b(I),
	--       DIN => data8b10b(I),
	--       DOUT => dout8b10b(I)(7 downto 0),
	--       KOUT => dout8b10b(I)(8),
	--       CE => '1',
	--       SINIT => sysRst125,
	--       CODE_ERR =>dout8b10b(I)(9),
	--       ND =>open
	--       );
	--   the8b10bfifo : fifo8b10bnew
	--	port map (
	--		rst => rst,
	--		--wr_clk => ld8b10b(I),
	--		wr_clk => phaseclk,
	--		rd_clk => sysClk125,
	--		din => dout8b10b(I),
	--		wr_en => ldout8b10b(I),
	--		rd_en => read8b10bfifo(I),
	--		dout => pgpencdatain(I),
	--		full => open,
	--		empty => open,
	--		almost_empty => fifo8b10bempty(I),
	--		valid => valid8b10b(I));
	--the8b10bfifo: fifo8b10b
	--port map (
	--din => data8b10bcat,
	--rd_clk => sysClk125,
	--rd_en => read8b10bfifo,
	--rst => rst,
	--wr_clk => ld8b10b,
	--wr_en => '1',
	--almost_empty =>fifo8b10bempty ,
	--dout => pgpencdatain,
	--empty => open,
	--full => open,
	--underflow => open);

	--   pgpencoder: encodepgpfast
	--     generic map(CHANNEL=>std_logic_vector(conv_unsigned(I,4)))
	--     port map(
	--       clk => sysClk125,
	--       rst => sysRst125,
	--       enabled => channelmask(I),
	--       fifoempty => fifo8b10bempty(I),
	--       fifovalid => valid8b10b(I),
	--       d_in => pgpencdatain(I),
	--       d_out => fei4data(I),
	--       ldin => read8b10bfifo(I),
	--       ldout => ldfei4(I)
	--       );
	enablereadout(I)<=channeloutmask(I) and ((trigenabled and not ofprotection) or not dfifothresh(I));
	pgpencoder: encodepgp
	generic map(CHANNEL=>std_logic_vector(conv_unsigned(I,4)))
	port map(
	clk => receiveclock,
	rst => rst,
	enabled => enablereadout(I),
	isrunning => isrunning(I),
	d_in => dout8b10b(I)(7 downto 0),
	k_in => dout8b10b(I)(8),
	err_in => dout8b10b(I)(9),
	marker => marker,
	d_out => fei4data(I),
	ldin => ldout8b10b(I),
	ldout => ldfei4(I),
	overflow => bufoverflow(I)
	);
	fei4fifo : datafifo
	generic map( buffersize => buffersize)
	port map (
	--prog_full_thresh => setfifothresh,
	din => fei4data(I),
	rd_clk => sysClk125,
	rd_en => reqdata(I),
	rst => rst,
	wr_clk => receiveclock,
	wr_en => ldfei4(I),
	dout => datain(I),
	empty => emptyv(I),
	full => fullv(I),
	overflow => overflowv(I),
	prog_full => dfifothresh(I),
	valid => indatavalid(I),
	underflow => underflowv(I));
	--   fei4dataflag: dataflag160
	--   fei4dataflag: dataflag
	--     port map(
	--       eofin=>fei4data(I)(17),
	--       eofout=>datain(I)(17),
	--       datawaiting=> datawaiting(I),
	--       clk=>receiveclock,
	--       rst=>rst,
	--       counter=>open
	--       );
	fei4dataflag: dataflagnew
	port map(
	eofin=>fei4data(I)(17),
	eofout=>datain(I)(17),
	datawaiting=>datawaiting(I),
	clkin=>receiveclock,
	clkout=>sysClk125,
	rst=>rst);
	end generate FE_CHANNEL;
	HITBUS_CHANNEL: if (hitbusreadout='1' and (I=3 or I=7)) generate
	alignframe: framealignhitbus
	port map(
	clk => receiveclock,
	rst => rst,
	d_in => recdata(I),
	d_out => alignout(I),
	aligned => aligned(I)
	);
	deserhitbus: deser4b
	port map(
	clk => receiveclock,
	rst => rst,
	d_in => alignout(I),
	align => aligned(I),
	d_out => data8b10b(I)(3 downto 0),
	ld => ld8b10b(I)
	);
	hitbusin(I/4*3)<=data8b10b(I)(2);
	hitbusin(I/4*3+1)<=data8b10b(I)(1);
	hitbusin(I/4*3+2)<=data8b10b(I)(0);
	thehitbuspipeline: hitbuspipeline
	port map(
	rst  => rst,
	clk => receiveclock,
	ld => ld8b10b(I),
	depth => hitbusdepth,
	wordin => data8b10b(I)(2 downto 0),
	wordout => hitbusword(I/4)
	);
	end generate HITBUS_CHANNEL;
	end generate FRAMEDCHANNELREADOUT;
	hbin: if framedfirstchannel>7 or framedlastchannel<7 or hitbusreadout='0' generate
	hitbusin(3)<='0';  
	hitbusin(4)<='0';  
	hitbusin(5)<='0';  
	end generate hbin;
	hbin2: if framedfirstchannel>3 or framedlastchannel<3 or hitbusreadout='0' generate
	hitbusin(0)<='0';  
	hitbusin(1)<='0';  
	hitbusin(2)<='0';  
	end generate hbin2;

	debug(0)<=recdata(7);
	debug(1)<=alignout(7);
	debug(2)<=aligned(7);
	debug(3)<=data8b10b(7)(3);
	debug(4)<=ld8b10b(7);
	debug(5)<=hitbusin(3);
	debug(6)<=hitbusin(5);
	debug(7)<=hitbus;


	--   cdata(17 downto 0) <= tdcdata;
	--   cdata(18)<=eudaqdone;
	--   cdata(19)<=tdcld;
	--   cdata(20)<=tdcbusy;
	--   cdata(22)<=busy;
	--   cdata(23)<=exttrgclk;
	--   datain(0)<="00"&x"0000";
	--   datain(1)<="00"&x"0000";
	--   datain(2)<="00"&x"0000";
	--   datain(3)<="00"&x"0000";
	--   datain(4)<="00"&x"0000";
	--   datain(5)<="00"&x"0000";
	--   datain(6)<="00"&x"0000";
	--   datain(7)<="00"&x"0000";
	--   datain(8)<="00"&x"0000";
	--   datain(9)<="00"&x"0000";
	--   datain(11)<="00"&x"0000";
	--   datain(12)<="00"&x"0000";
	--   datain(13)<="00"&x"0000";
	--   datain(14)<="00"&x"0000";
	--   datain(15)<="00"&x"0000";

	--   cdata(5)<=busy;
	--   cdata(6)<=trigenabled;
	process (rst, phaseclk) begin
	if(rst='1')then
	ctrig(0)<='0';
	elsif rising_edge(phaseclk) then
	--if(ldout8b10b(4)='1' and dout8b10b(4)(9)='0' and dout8b10b(4)(7 downto 0)/=x"3c")then
	if(ldout8b10b(4)='1' and dout8b10b(4)(8 downto 0)="1"&x"fc" and channeloutmask(4)='1')then
	--if(isrunning(4)='1')then
	ctrig(0)<='1' ;
	else
	ctrig(0)<='0';
	end if;
	end if;
	end process;
	-- cdata(9 downto 0)<=dout8b10b(0);

	cdata(0)<=emptyv(0);
	cdata(1)<=fullv(0);
	cdata(2)<=underflowv(0);
	cdata(3)<=overflowv(0);
	cdata(4)<=prog_fullv(0);
	cdata(5)<=isrunning(0);
	cdata(6)<=channeloutmask(0);
	cdata(7)<=channelmask(0);
	--cdata(8)<=alignout(2);
	--cdata(9)<=aligned(2);
	--cdata(11 downto 10)<=dout8b10b(2)(9 downto 8);

	--cdata(12)<=alignout(3);
	--cdata(13)<=aligned(3);
	--cdata(15 downto 14)<=dout8b10b(3)(9 downto 8);

	cdata(16)<=alignout(0);
	cdata(17)<=aligned(0);
	cdata(18)<=datawaiting(0);
	cdata(28 downto 19)<=dout8b10b(0);

	--cdata(29)<=alignout(5);
	--cdata(30)<=aligned(5);
	--cdata(31)<=dout8b10b(5)(9);


	-- chipscope : ila
	--   port map (
	--     CONTROL => ccontrol,
	--     CLK => receiveclock,
	--     DATA => cdata,
	--     TRIG0 => ctrig);
	-- chipscopeicon : icon
	--   port map (
	--     CONTROL0 => ccontrol);       

end HsioPixelCore;

