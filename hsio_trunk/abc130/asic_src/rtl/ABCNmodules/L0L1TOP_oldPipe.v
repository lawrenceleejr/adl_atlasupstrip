//*****************************************************************************
// L0 and L1 buffer system for ABCN 130
// 
// 14.06.2011. F.A.
//
// 
// StopPipe : Zero, no use now
// L0A : 1 CLK pulse, L0 signal
// R3DataIn : R3s signal from HCC, 101 followed by 8 bits (R3L0ID)
// L1DataIn : L1 signal from HCC, 110 followed by 8 bits (L1L0ID)
// R3_ReadEnable, L1_ReadEnable : 1 CLK pulse, signal triggering R3 or L1 readout (extracts data from L1buffer)
// L1B_Read_R3, L1B_Read_L1 : 3 CLK pulse (output) : signal sync'd with 3 consecutive (R3 or L1) data (BC-1, BC, BC+1) from L1 buffer
// L1Read : OR of the 2 above (no use ?)
// Data : 256 bits from analogue channels
// L1B_DataOut : 272 bits L1 buffer output
// 
//*****************************************************************************


`timescale 1ns/1ps
module 	L0L1TOP ( CLK, SoftResetB, L0A, StopPipe,
	R3DataIn, L1DataIn, R3_ReadEnable, L1_ReadEnable,
	L1B_Read_R3, L1B_Read_L1, L1Read,
	R3_Empty, R3_Full, L1_Empty, L1_Full,
	PipeHoldAddress, Data, 
	L1B_DataOut
);


input 				CLK, SoftResetB, L0A, StopPipe, R3DataIn, L1DataIn, R3_ReadEnable, L1_ReadEnable;
output 				L1B_Read_R3, L1B_Read_L1, L1Read; 
output 				R3_Empty, R3_Full, L1_Empty, L1_Full;
input [`PIPE_ADDR_WIDTH-1:0]	PipeHoldAddress;
input [263:0]			Data;
output[`L1B_DATA_WIDTH-1:0]	L1B_DataOut;



wire L1B_Read_R3;
wire L1B_Read_L1;
wire [`RO_ADDR_WIDTH-1:0] 	R3L0ID, L0ID_Local, R3Address, L1L0ID, L1Address;
wire [`PIPE_ADDR_WIDTH-1:0]	PipeWA, PipeRA;
wire [`PIPE_DATA_WIDTH-1:0]	DataPIn, PipeData;
wire [`FIFO_ADDR_WIDTH-1:0]	R3WA, R3RA;
wire [`FIFO_ADDR_WIDTH-1:0]	L1WA, L1RA;
wire [`L1B_ADDR_WIDTH-1:0]	L0IDtoL1B_Address, R3toL1B_Address, L1toL1B_Address, L1B_Address;
wire [`L1B_DATA_WIDTH-1:0]	L1BDataIn;
wire 				R3_L0Stretch, L1_L0Stretch;

assign L1BDataIn[`L1B_DATA_WIDTH-1:0] = {L0ID_Local[`RO_ADDR_WIDTH-1:0], PipeData[263:0]}; // 272 bits wide
assign DataPIn[`PIPE_DATA_WIDTH-1:0] = Data[263:0]; 

assign L1B_Read_R3 = R3_L0Stretch;
assign L1B_Read_L1 = L1_L0Stretch;

PIPELINE_CONTROLLER PIPELINE_CONTROL( 
	.BC(CLK), .SoftResetB(SoftResetB), .L0A(L0A),
	.PipeHoldAddress(PipeHoldAddress),
	.PipeWriteStrob(PipeW), .PipeWriteAddress(PipeWA),
	.PipeReadStrob(PipeR), .PipeReadAddress(PipeRA),
	.DelayL0A(DelayL0A), .StretchL0A(Unused), .L0ID_Local(L0ID_Local), .StopPipe(StopPipe)
	);
	
SRAM_264X256 Pipe(
	.CLK(CLK),
	.W(PipeW),
	.R(PipeR),
	.WA(PipeWA),
	.RA(PipeRA),
	.Din(DataPIn),
	.Dout(PipeData)
);

R3detect R3_detect ( .clk(CLK), .Resetb(SoftResetB), .R3DataIn(R3DataIn),
	.R3detAck(R3detAck), .R3L0ID(R3L0ID)
	);

L1detect L1_detect ( .clk(CLK), .Resetb(SoftResetB), .L1DataIn(L1DataIn),
	.L1detAck(L1detAck), .L1L0ID(L1L0ID)
	);

// Modif MKC: Parameter added
RO_FIFO2_CONTROL #(`RO_FIFO_max_depth) R3_FIFO_CONTROL( 
	.BC(CLK), .ResetB(SoftResetB), .SyncWrite(R3detAck), .ReadEnable(R3_ReadEnable),
	.WriteFIFO(R3W), .FWriteAddress(R3WA),
	.ReadFIFO(R3R), .ROReadStrob(R3_ReadStrob), .FReadAddress(R3RA),
	.Empty(R3_Empty), .Full(R3_Full)
	);

// Modif MKC: Parameter added	
RO_FIFO2_CONTROL #(`RO_FIFO_max_depth) L1_FIFO_CONTROL( 
	.BC(CLK), .ResetB(SoftResetB), .SyncWrite(L1detAck), .ReadEnable(L1_ReadEnable),
	.WriteFIFO(L1W), .FWriteAddress(L1WA),
	.ReadFIFO(L1R), .ROReadStrob(L1_ReadStrob), .FReadAddress(L1RA),
	.Empty(L1_Empty), .Full(L1_Full)
	);
	
AddressExtender3 L1AddressExtender(
	.CLK(CLK), .Resetb(SoftResetB), .ROReadStrob(L1_ReadStrob), .ROStretchP(L1_L0StretchP), .ROStretch(L1_L0Stretch),
	.AddressIn(L1Address), .AddressOut(L1toL1B_Address)
	);

AddressExtender3 R3AddressExtender(
	.CLK(CLK), .Resetb(SoftResetB), .ROReadStrob(R3_ReadStrob), .ROStretchP(R3_L0StretchP), .ROStretch(R3_L0Stretch),
	.AddressIn(R3Address), .AddressOut(R3toL1B_Address)
	);
	
AddressExtender4 L0AddressExtender(
	.CLK(CLK), .Resetb(SoftResetB), .ROReadStrob(L0A), .ROStretch(Stretch_L0A),
	.AddressIn(L0ID_Local), .AddressOut(L0IDtoL1B_Address)
	);
	
	
RAM_80x8 R3_ADDR_FIFO( .BC(CLK),  
	.FWriteStrob(R3W), .FWriteAddress(R3WA), .DataIn(R3L0ID),
	.FReadStrob(R3R), .FReadAddress(R3RA), .Dout(R3Address)
	);
	
RAM_80x8 L1_ADDR_FIFO( .BC(CLK),  
	.FWriteStrob(L1W), .FWriteAddress(L1WA), .DataIn(L1L0ID),
	.FReadStrob(L1R), .FReadAddress(L1RA), .Dout(L1Address)
	);
	
RAM_L1Buffer	L1Buffer( .BC(CLK),  
	.WriteStrob(Stretch_L0A), .WriteAddress(L0IDtoL1B_Address), .DataIn(L1BDataIn),
	.ReadStrob(L1Read), .ReadAddress(L1B_Address), .Dout(L1B_DataOut)
	);

AddressSelect  AddressSel( .CLK(CLK), .AI(R3_ReadStrob), .BI(L1_ReadStrob), .CI(R3_L0StretchP), .DI(L1_L0StretchP),
	.Strob(L1Read),
	.AddressIn1(R3toL1B_Address), .AddressIn2(L1toL1B_Address), .AddressOut(L1B_Address)
	);
	
endmodule

