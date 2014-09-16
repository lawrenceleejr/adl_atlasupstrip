
//********************************************************************
// MODULE:	Radiation Tolerant SRAM 
//		in CMOS 0.13um 
// FILE NAME:	sram_wb_model.v
// VERSION:	1.0
// DATE:	Apr.  4, 2012
// Updated	----  -- ----
//
// AUTHOR:	BIALAS Wojciech, based on work of KLOUKINAS Kostas
//
// DESCRIPTION:	This module defines a Synchronous Pseudo Dual Port Static RAM  
//		with registered inputs and latched outputs.
//
// NOTE:	The access time of the memory is not fixed and scales 
// 		with the size of the memory. This SRAM module is designed  
//		to be used in 40MHz synchronous system. 
//
//*******************************************************************

`timescale	1ns/10ps

// Width of the RAM in bits (should be modulo 8) is:	  64 bits
// Depth of the RAM in words (should be modulo 128) is:	 128 words

`define	T_avail_end	0.3 // data out avail. margin after  positive CLK edge in [ns] 
			// typical simulation of a 128  X 64 bit SRAM)
`define	T_avail_begin	2.3 // data out avail. margin after negative CLK edge in [ns] 
			//  of a 128  X 64 bit SRAM)
			
			
module SRAM_128X64_CERN (
	clk,
	WEB,
	REB,
	ADR,
	DataIn,
	DataOut
);

// Define Parameter
parameter numWord = 128;
parameter numBit = 64;

input	clk,			// SRAM clock (all interface signals 
				// should be synchronous to this clock) 
	WEB,			// WRITE enable signal (active low)
	REB;			// READ enable signal (active low)

input 	[6:0]	ADR;		// Write Address port
input	[63:0]	DataIn;		// Write Data input port

output	[63:0]	DataOut;	// Read Data output port

`ifdef DC
`else

reg	[6:0] 	AddrReg;
		
reg	[63:0]	DataInReg, DataOut;

reg	WriteReg,ReadReg;

reg	[63:0]	mem[127:0];

reg notify_clk;

//specify
//
//   specparam tCYC = 20.0;
//   specparam tCKH = 8.0;    
//   specparam tCKL = 8.0;
//
//   $period(posedge CLK, tCYC, notify_clk);
//   $width(posedge CLK, tCKH, 0, notify_clk);
//   $width(negedge CLK, tCKL, 0, notify_clk);
//
//endspecify

// RAM Interface registers

always @(posedge clk)
    begin
	WriteReg     <=  #0.1 (~WEB);
	ReadReg <= #0.1 (~REB);
	AddrReg <= #0.1 ADR;
	DataInReg    <= #0.1 DataIn;
    end


// WRITE and READ operations

always @(negedge clk)
    begin

	// WRITE operation
	if (WriteReg)
	  begin
	  
            mem[AddrReg] <= #0.1 DataInReg;
	    WriteReg <= 1'b0;
	    
	  end

    end
    
always @ ( clk ) begin
    if (~clk && ReadReg) begin
//    if (ReadReg) begin
    	DataOut <= #`T_avail_begin mem[AddrReg];
    end else 
    	DataOut <= #`T_avail_end 'hx ;
  end
	

`endif

    
endmodule

