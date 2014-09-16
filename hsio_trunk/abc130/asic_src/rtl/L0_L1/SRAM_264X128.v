
//********************************************************************
// MODULE:	Radiation Tolerant SRAM 
//		in CMOS 0.25um 
// FILE NAME:	SRAM_264X128.v
// VERSION:	2.0
// DATE:	Oct. 25, 2000
// Updated	Jul.  3, 2002
//
// AUTHOR:	KLOUKINAS Kostas
//
// DESCRIPTION:	This module defines a Synchronous Dual Port Static RAM  
//		with registered inputs and latched outputs.
//		The module is parameterized so that the SRAM  can be sized 
//		according to the application needs.
//
// NOTE:	The access time of the memory is not fixed and scales 
// 		with the size of the memory. This SRAM module is designed  
//		to be used in 40MHz synchronous system. 
//
// MODIFIED : Name of pins - Herve M. 21-03-2006 
// Preliminary version for ABCN130 F.A. 29-04-2011, extended to 264 bits
// Single port simulated operation 15.12.2011
//*******************************************************************

`timescale	1ns/1ps

// Width of the RAM in bits (should be modulo 9) is:	 256 bits
// Depth of the RAM in words (should be modulo 128) is:	 256 words

`define	Tacc 5.5	// Read access time in ns (typical case simulations
  
module SRAM_264X128 (
	CLK,
	W,
	R,
	WA,
	RA,
	Din,
	Dout
);

input	CLK,			// SRAM clock (all interface signals 
				// should be synchronous to this clock) 
	W,			// WRITE enable signal (active high)
	R;			// READ enable signal (active high)

input 	[6:0]	WA;		// Write Address port
input	[6:0]	RA;		// Read Address port
input	[263:0]	Din;		// Write Data input port

output	[263:0]	Dout;	// Read Data output port

// synopsys translate_off

//reg	[6:0] 	WriteAddrReg;
		
reg	[263:0]	Dout;

reg	Write;

reg	[263:0]	mem[127:0];


// RAM Interface registers

always @(posedge CLK)
    begin
	Write	     <= #1 W;
//	WriteAddrReg <= #1 WA;
//	DataInReg    <= #1 Din;
    end


// WRITE Operation

always @(posedge CLK)
    begin
	if (Write)
	  begin
	  
            mem[WA] <= #1 Din;
	    Write <= 1'b0;
	    
	  end
    end


// READ Operation

always @(posedge CLK)
    begin 
        if (R)
	  begin
	  
	    // Dout <= #1.5 'hx;
	    Dout <= #`Tacc mem[RA];
	    
	  end
    end

// synopsys translate_on

endmodule

