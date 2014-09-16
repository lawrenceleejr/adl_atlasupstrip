`timescale 1ns/1ns
module pipeLineEntry(
stripData,maskBits,BCID, BCclk, hrdrstb,mode,pipeLine,diagnostic);
//inputs and outputs
        input [255:0] stripData;
	input [255:0] maskBits;
	input [7:0]BCID;
	input BCclk;
	input hrdrstb;
	input [1:0]mode;
	output [255:0]pipeLine;
	output [255:0]diagnostic;
	
// the four modes are assigned four 2bit numbers
parameter DATATAKINGMODE = 2'b00;
parameter LOADMASKBITSMODE = 2'b01;
parameter DGNSTCREGLDMODE = 2'b10;
parameter TSTPTRNBCIDMODE = 2'b11;


//256 bit wire to hold the masked data; mask is present in maskOrTestReg
reg [255:0] maskedStripData;
// 256 bit reg to hold the data to be sent to pipeline
reg [255:0] pipeLineReg; 
// acceps data from pipeLineReg
reg [255:0] diagnosticReg;
// accepts data from maskBits
reg [255:0] maskOrTestReg;

// wire pipeline and diagnostic take value from registers
assign pipeLine = pipeLineReg;
assign diagnostic = diagnosticReg;

// we have assumed that we can use a asynchronous hard reset to reset the two registers
// Is this correct? Do we use only synchronous resets?
always@(posedge BCclk or negedge hrdrstb)
	begin
	if (~hrdrstb)
	begin
	maskOrTestReg <= 0;
	maskedStripData <= 0;
	end
	else
	begin
	maskOrTestReg <= maskBits; 
	if (mode == DATATAKINGMODE)
	begin
		maskedStripData <= stripData & (~maskOrTestReg);
		pipeLineReg <= maskedStripData;
	end	
	else if (mode ==LOADMASKBITSMODE)
	   pipeLineReg <= maskOrTestReg;
	   
	else if (mode ==DGNSTCREGLDMODE)
	begin
		diagnosticReg <= pipeLineReg;
		
	end
	else if (mode == TSTPTRNBCIDMODE)
	// The 8 bit BCID is pumped into pipeLineReg 32 times. This BCID is updated everytime this mode is there
	
	pipeLineReg<={BCID[7:0],BCID[7:0],BCID[7:0],BCID[7:0],BCID[7:0],BCID[7:0],BCID[7:0],BCID[7:0],BCID[7:0],BCID[7:0],BCID[7:0],BCID[7:0],BCID[7:0],BCID[7:0],BCID[7:0],BCID[7:0],BCID[7:0],BCID[7:0],BCID[7:0],BCID[7:0],BCID[7:0],BCID[7:0],BCID[7:0],BCID[7:0],BCID[7:0],BCID[7:0],BCID[7:0],BCID[7:0],BCID[7:0],BCID[7:0],BCID[7:0],BCID[7:0]};
	
	else
	pipeLineReg <= pipeLineReg;
	end
	end
	


endmodule					
		

