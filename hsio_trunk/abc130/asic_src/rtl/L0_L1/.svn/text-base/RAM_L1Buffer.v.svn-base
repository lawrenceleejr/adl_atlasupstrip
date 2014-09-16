// RAM Interface registers
// Not for synthesis
// Based on mem element of Verilog
// May need to be truly synthtiyed later on with registers ?

`timescale	1ns/1ps
module 	RAM_L1Buffer( BC,  
	WriteStrob, WriteAddress, DataIn,
	ReadStrob, ReadAddress, Dout
	);
	
	
input 	BC, WriteStrob, ReadStrob;
input	[`L1B_ADDR_WIDTH-1:0]	WriteAddress, ReadAddress;
input 	[`L1B_DATA_WIDTH-1:0]	DataIn;
output 	[`L1B_DATA_WIDTH-1:0]	Dout;

//synopsys translate_off

reg 	[`L1B_DATA_WIDTH-1:0]	Dout;
//reg 	[`L1B_ADDR_WIDTH-1:0]	WriteAddrReg;
//reg 	Write;
  
`ifdef Tacc
    `undef Tacc
`endif

`define	Tacc 5.5	// Read access time in ns (typical case simulations of a 2K X 9 bit SRAM)
			// to be redefined  for this block
			
// reg	[`RO_ADDR_WIDTH-1:0]	mem[(1<<(`FIFO_ADDR_WIDTH))-1:0]; // Ca c'est la memoire, enfin   : reg wordsize mem[addresssize]!!
// reg	[`L1B_ADDR_WIDTH-1:0]	mem[`L1B_RAM_max_depth-1:0]; // Ca c'est la memoire, enfin   : reg wordsize mem[addresssize]!!
// Modif MKC
   reg	[`L1B_DATA_WIDTH-1:0]	mem[`L1B_RAM_max_depth-1:0]; // Ca c'est la memoire, enfin   : reg wordsize mem[addresssize]!!
// Modif MKC
// Initialise the memory contents to zero.
 initial   
 $readmemb("../test/Matlab/v3/L0L1_Buffer.txt",mem);			

//always @(posedge BC)
//    begin
//	Write	     <= #1 WriteStrob;
//	WriteAddrReg <= #1 WriteAddress;
//	DataInReg    <= #1 DataIn;
//    end


// WRITE Operation -- Check later on true model, if negedge is used really

always @(posedge BC)
    begin
	if (WriteStrob)
	  begin
	  
            mem[WriteAddress] <= #1 DataIn; // This is the mem block finally
//	    Write <= 1'b0;  // Internal to block, not synthetized !!
	    
	  end
    end


// READ Operation

always @(posedge BC)
    begin 
        if (ReadStrob)
	  begin
	  
	    Dout <= #1.5 'hx;
	    Dout <= #`Tacc mem[ReadAddress];
	    
	  end
    end
    			
//synopsys translate_on

endmodule		
