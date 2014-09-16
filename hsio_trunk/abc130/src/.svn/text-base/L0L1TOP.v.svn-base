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
// New (test) version for single port memory access F.A. 14/12/2011
// Stop_Pipe removed F.A. 14/12/2011
// 
// 16-04-2012 : extended RAM field to 320 bits
//*****************************************************************************


`timescale 1ns/1ps

`include "../../abc130/src/veri_globals_P5.v" // ***

module 	L0L1TOP ( CLK, SoftResetB, L0A, L0IDReset, L0IDPreset, 
	R3DataIn, L1DataIn, R3_ReadEnable, L1_ReadEnable, L1BReadVetoIn,
	L1B_Read_R3_A, L1B_Read_R3_C, L1B_Read_R3_D, L1B_Read_L1_A, L1B_Read_L1_C, L1B_Read_L1_D, L1BReadVetoOut,
	R3_Empty, R3_Full, L1_Empty, L1_Full,
	PipeHoldAddress, PreL0ID, L0ID_Local,
	Data, 
	L1B_DataOutA, L1B_DataOutC, L1B_DataOutD
);


input 				CLK, SoftResetB, L0A, L0IDReset, L0IDPreset, R3DataIn, L1DataIn, R3_ReadEnable, L1_ReadEnable, L1BReadVetoIn;
input  [`RO_ADDR_WIDTH-1:0]  	PreL0ID;
output 				L1B_Read_R3_A, L1B_Read_R3_C, L1B_Read_R3_D, L1B_Read_L1_A, L1B_Read_L1_C, L1B_Read_L1_D, L1BReadVetoOut; 
output 				R3_Empty, R3_Full, L1_Empty, L1_Full;
output[`RO_ADDR_WIDTH-1:0]	L0ID_Local;
input [`PIPE_ADDR_WIDTH-1:0]	PipeHoldAddress;
input [`PIPE_DATA_WIDTH-1:0]	Data;
output[`L1B_DATA_WIDTH-1:0]	L1B_DataOutC;
output[`L1B_DATA_WIDTH-65:0]	L1B_DataOutA, L1B_DataOutD;



wire L1B_Read_R3_A, L1B_Read_R3_C, L1B_Read_R3_D;
wire L1B_Read_L1_A, L1B_Read_L1_C, L1B_Read_L1_D;
wire [`RO_ADDR_WIDTH-1:0] 	R3L0ID, L0ID_Local, R3Address, L1L0ID, L1Address;
wire [`PIPE_ADDR_WIDTH-1:0]	PipeWA, PipeRAPre;
wire [`PIPE_DATA_WIDTH-1:0]	DataPIn, PipeData1, PipeData2;
wire [`FIFO_ADDR_WIDTH-1:0]	R3WA, R3RA;
wire [`FIFO_ADDR_WIDTH-1:0]	L1WA, L1RA;
wire [`L1B_ADDR_WIDTH-1:0]	L0IDtoL1B_Address, L1B_Address;
//wire [`L1B_DATA_WIDTH-1:0]	L1BDataIn;
//wire 				R3_L0Stretch, L1_L0Stretch;

//assign L1BDataIn[`L1B_DATA_WIDTH-1:0] = {L0ID_Local[`RO_ADDR_WIDTH-1:0], PipeData[263:0]}; // 272 bits wide
assign DataPIn[`PIPE_DATA_WIDTH-1:0] = Data[`PIPE_DATA_WIDTH-1:0]; 
//assign L1BDataIn[`L1B_DATA_WIDTH-1:0] = {L0ID_Local[`RO_ADDR_WIDTH-1:0], PipeData1[263:0]}; // 272 bits wide
//assign DataPIn[`PIPE_DATA_WIDTH-1:0] = {8'b0, Data[255:0]};  // BC counter not implemented !! 264 bits wide

wire 				R3_ReadStrob, R3_ReadStrob_A, R3_ReadStrob_C, R3_ReadStrob_D, L1_ReadStrob, L1_ReadStrob_A, L1_ReadStrob_C, L1_ReadStrob_D;

assign L1B_Read_R3_A = R3_ReadStrob_A;
assign L1B_Read_L1_A = L1_ReadStrob_A;
assign L1B_Read_R3_C = R3_ReadStrob_C;
assign L1B_Read_L1_C = L1_ReadStrob_C;
assign L1B_Read_R3_D = R3_ReadStrob_D;
assign L1B_Read_L1_D = L1_ReadStrob_D;


reg [2:0]			PipeR1, PipeR2, PipeR1D, PipeR2D; 
reg 				PipeR1F, PipeR2F, PipeR1G, PipeR2G;
reg [`PIPE_ADDR_WIDTH-1:0] 	PipeRA, PipeRAD, PipeRAF, PipeRAG;
wire [2:0]			L1B_W, PipeR1Pre, PipeR2Pre;
wire 				PipeR1E, PipeR2E;
wire [`PIPE_ADDR_WIDTH-1:0] 	PipeRAE;

assign L1BReadVetoOut = L1B_W[0];

PIPELINE_CONTROLLER PIPELINE_CONTROL( 
	.BC(CLK), .SoftResetB(SoftResetB), .L0A(L0A),
	.PipeHoldAddress(PipeHoldAddress),
	.PipeWriteStrob(PipeW), .PipeWriteAddress(PipeWA),
	.PipeReadStrob(PipeR), .PipeReadAddress(PipeRAPre),
	.L1B_W(L1B_W)
	);
	
assign PipeW1 = PipeW & PipeWA[0];  // even address RAM bank  ~was here
assign PipeW2 = PipeW & ~PipeWA[0];  // odd address RAM bank

assign PipeR1Pre = L1B_W & {3{~PipeRAPre[0]}};  // even address RAM bank
assign PipeR2Pre = L1B_W & {3{PipeRAPre[0]}};  // odd address RAM bank // was PipeR

always @ (posedge CLK)
	if (~SoftResetB) begin
	PipeR1 <= 1'b0;
	PipeR2 <= 1'b0;
	PipeRA <= 1'b0;
	PipeR1D <= 1'b0;
	PipeR2D <= 1'b0;
	PipeRAD <= 1'b0; 
	end else begin
  	PipeR1 <= PipeR1Pre;
	PipeR2 <= PipeR2Pre;
	PipeRA <= PipeRAPre;
	PipeR1D <= PipeR1;
	PipeR2D <= PipeR2;
	PipeRAD <= PipeRA;
	end
	
assign PipeR1E = ( ~PipeHoldAddress[0] ? PipeR1[0]|PipeR1[1]|PipeR1[2]:PipeR1D[0]|PipeR1D[1]|PipeR1D[2]);
assign PipeR2E = ( ~PipeHoldAddress[0] ? PipeR2[0]|PipeR2[1]|PipeR2[2]:PipeR2D[0]|PipeR2D[1]|PipeR2D[2]);	
assign PipeRAE = ( ~PipeHoldAddress[0] ? PipeRA:PipeRAD);

always @ (posedge CLK) // will be unused if we confirm no use of L1BReadVeto
	if (~SoftResetB) begin
	PipeR1F <= 1'b0;
	PipeR2F <= 1'b0;
	PipeRAF <= 1'b0;
	end else begin
  	PipeR1F <= PipeR1E;
	PipeR2F <= PipeR2E;
	PipeRAF <= PipeRAE;
	end     //
	
always @ (posedge CLK) begin // shift by +1BC if L1B in Read
	if (~SoftResetB) begin
	PipeR1G <= 1'b0;
	PipeR2G <= 1'b0;
	PipeRAG <= 1'b0;
	end else if (L1BReadVetoIn) begin
  	PipeR1G <= PipeR1F;
	PipeR2G <= PipeR2F;
	PipeRAG <= PipeRAF;
	end else begin    // only this reg shift will be kept if no use of L1BReadVeto
	PipeR1G <= PipeR1E;
	PipeR2G <= PipeR2E;
	PipeRAG <= PipeRAE;
	end
      end
	
/*SRAM_320X128 Pipe1(
	.CLK(CLK),
	.W(PipeW1),
	.R(PipeR1G),
	.WA(PipeWA[`PIPE_ADDR_WIDTH-1:1]),
	.RA(PipeRAG[`PIPE_ADDR_WIDTH-1:1]),
	.Din(DataPIn),
	.Dout(PipeData1)
);  // even [0] address memory bank

SRAM_320X128 Pipe2(
	.CLK(CLK),
	.W(PipeW2),
	.R(PipeR2G),
	.WA(PipeWA[`PIPE_ADDR_WIDTH-1:1]),
	.RA(PipeRAG[`PIPE_ADDR_WIDTH-1:1]),
	.Din(DataPIn),
	.Dout(PipeData2)
); // odd [0] address memory bank
*/

//CERN RAM modular

wire [`PIPE_ADDR_WIDTH-1:1] PipeADR1, PipeADR2;
assign PipeADR1 = (PipeWA[`PIPE_ADDR_WIDTH-1:1] & {7{~PipeW1}}) | (PipeRAG[`PIPE_ADDR_WIDTH-1:1] & {7{PipeR1G}});
assign PipeADR2 = (PipeWA[`PIPE_ADDR_WIDTH-1:1] & {7{~PipeW2}}) | (PipeRAG[`PIPE_ADDR_WIDTH-1:1] & {7{PipeR2G}});

// even [0] address memory bank Pipeline RAM

mem128x64  SRAM_128x64_P1_G0(
	.CLOCK_in(CLK),
	.writeB(PipeW1),
	.readB(~PipeR1G),
	.addr_in(PipeADR1),
	.Page_sel_B(1'b0),
	.data_in(DataPIn[63:0]),
	.data_out(PipeData1[63:0])
);
mem128x64  SRAM_128x64_P1_G1(
	.CLOCK_in(CLK),
	.writeB(PipeW1),
	.readB(~PipeR1G),
	.addr_in(PipeADR1),
	.Page_sel_B(1'b0),
	.data_in(DataPIn[127:64]),
	.data_out(PipeData1[127:64])
);
mem128x64  SRAM_128x64_P1_G2(
	.CLOCK_in(CLK),
	.writeB(PipeW1),
	.readB(~PipeR1G),
	.addr_in(PipeADR1),
	.Page_sel_B(1'b0),
	.data_in(DataPIn[191:128]),
	.data_out(PipeData1[191:128])
);
mem128x64  SRAM_128x64_P1_G3(
	.CLOCK_in(CLK),
	.writeB(PipeW1),
	.readB(~PipeR1G),
	.addr_in(PipeADR1),
	.Page_sel_B(1'b0),
	.data_in(DataPIn[255:192]),
	.data_out(PipeData1[255:192])
);
mem128x64  SRAM_128x64_P1_G4(
	.CLOCK_in(CLK),
	.writeB(PipeW1),
	.readB(~PipeR1G),
	.addr_in(PipeADR1),
	.Page_sel_B(1'b0),
	.data_in(DataPIn[319:256]),
	.data_out(PipeData1[319:256])
);

// odd [0] address memory bank Pipeline RAM

mem128x64  SRAM_128x64_P2_G0(
	.CLOCK_in(CLK),
	.writeB(PipeW2),
	.readB(~PipeR2G),
	.addr_in(PipeADR2),
	.Page_sel_B(1'b0),
	.data_in(DataPIn[63:0]),
	.data_out(PipeData2[63:0])
);
mem128x64  SRAM_128x64_P2_G1(
	.CLOCK_in(CLK),
	.writeB(PipeW2),
	.readB(~PipeR2G),
	.addr_in(PipeADR2),
	.Page_sel_B(1'b0),
	.data_in(DataPIn[127:64]),
	.data_out(PipeData2[127:64])
);
mem128x64  SRAM_128x64_P2_G2(
	.CLOCK_in(CLK),
	.writeB(PipeW2),
	.readB(~PipeR2G),
	.addr_in(PipeADR2),
	.Page_sel_B(1'b0),
	.data_in(DataPIn[191:128]),
	.data_out(PipeData2[191:128])
);
mem128x64  SRAM_128x64_P2_G3(
	.CLOCK_in(CLK),
	.writeB(PipeW2),
	.readB(~PipeR2G),
	.addr_in(PipeADR2),
	.Page_sel_B(1'b0),
	.data_in(DataPIn[255:192]),
	.data_out(PipeData2[255:192])
);
mem128x64  SRAM_128x64_P2_G4(
	.CLOCK_in(CLK),
	.writeB(PipeW2),
	.readB(~PipeR2G),
	.addr_in(PipeADR2),
	.Page_sel_B(1'b0),
	.data_in(DataPIn[319:256]),
	.data_out(PipeData2[319:256])
);

R3detect_tri R3_detect ( .clk(CLK), .Resetb(SoftResetB), .R3DataIn(R3DataIn),
	.R3detAck(R3detAck), .R3L0ID(R3L0ID)
	);

L1detect_tri L1_detect ( .clk(CLK), .Resetb(SoftResetB), .L1DataIn(L1DataIn),
	.L1detAck(L1detAck), .L1L0ID(L1L0ID)
	);

// Modif MKC: Parameter added
RO_FIFO2_CONTROL_tri #(`RO_FIFO_max_depth) R3_FIFO_CONTROL( 
	.BC(CLK), .ResetB(SoftResetB), .SyncWrite(R3detAck), .ReadEnable(R3_ReadEnable),
	.WriteFIFO(R3W), .FWriteAddress(R3WA),
	.ReadFIFO(R3R), .ROReadStrob(R3_ReadStrob), .FReadAddress(R3RA),
	.Empty(R3_Empty), .Full(R3_Full)
	);

// Modif MKC: Parameter added	
RO_FIFO2_CONTROL_tri #(`RO_FIFO_max_depth) L1_FIFO_CONTROL( 
	.BC(CLK), .ResetB(SoftResetB), .SyncWrite(L1detAck), .ReadEnable(L1_ReadEnable),
	.WriteFIFO(L1W), .FWriteAddress(L1WA),
	.ReadFIFO(L1R), .ROReadStrob(L1_ReadStrob), .FReadAddress(L1RA),
	.Empty(L1_Empty), .Full(L1_Full)
	);
	
//AddressExtender3 L1AddressExtender(
//	.CLK(CLK), .Resetb(SoftResetB), .ROReadStrob(L1_ReadStrob), .ROStretchP(L1_L0StretchP), .ROStretch(L1_L0Stretch),
//	.AddressIn(L1Address), .AddressOut(L1toL1B_Address)
//	);

//AddressExtender3 R3AddressExtender(
//	.CLK(CLK), .Resetb(SoftResetB), .ROReadStrob(R3_ReadStrob), .ROStretchP(R3_L0StretchP), .ROStretch(R3_L0Stretch),
//	.AddressIn(R3Address), .AddressOut(R3toL1B_Address)
//	);

wire L1BWA, L1BWC, L1BWD;
reg L1BWAF, L1BWAG, L1BWCF, L1BWCG, L1BWDF, L1BWDG;
	
//AddressExtender4 L0AddressExtender(
//	.CLK(CLK), .SoftResetB(SoftResetB), .L0IDReset(L0IDReset), .L0IDPreset(L0IDPreset), .ROReadStrob(L1BWA), .PreL0ID(PreL0ID),
//	.L0ID_Local(L0IDtoL1B_Address)
//	);
	
LocalL0ID_tri LocalL0ID_tri(
	.CLK1(CLK), .CLK2(CLK), .CLK3(CLK), .SoftResetB(SoftResetB), .L0IDReset(L0IDReset), .L0IDPreset(L0IDPreset), .ROReadStrob(L1BWA), .PreL0ID(PreL0ID),
	.L0ID_Local(L0IDtoL1B_Address)
	);
	
	
RAM_80x8 R3_ADDR_FIFO( .BC(CLK),  
	.FWriteStrob(R3W), .FWriteAddress(R3WA), .DataIn(R3L0ID),
	.FReadStrob(R3R), .FReadAddress(R3RA), .Dout(R3Address)
	);
	
RAM_80x8 L1_ADDR_FIFO( .BC(CLK),  
	.FWriteStrob(L1W), .FWriteAddress(L1WA), .DataIn(L1L0ID),
	.FReadStrob(L1R), .FReadAddress(L1RA), .Dout(L1Address)
	);
	
reg BitRA0, BitRA0D;

always @(posedge CLK) begin
	if (~SoftResetB) begin
	BitRA0 <= 1'b0;
	BitRA0D <= 1'b0;
	end
	else if (L1B_W[0]) begin
	BitRA0 <= PipeRAPre[0];
	end 
	begin 
	BitRA0D <= BitRA0;
 	end
      end	
      		
      
assign L1BWA = ( ~PipeHoldAddress[0] ? (PipeR1[0] & ~BitRA0) | (PipeR2[0] & BitRA0) : (PipeR1D[0] & ~BitRA0D) | (PipeR2D[0] & BitRA0D));
assign L1BWC = ( ~PipeHoldAddress[0] ? (PipeR2[1] & ~BitRA0) | (PipeR1[1] & BitRA0) : (PipeR2D[1] & ~BitRA0D) | (PipeR1D[1] & BitRA0D));
assign L1BWD = ( ~PipeHoldAddress[0] ? (PipeR1[2] & ~BitRA0) | (PipeR2[2] & BitRA0) : (PipeR1D[2] & ~BitRA0D) | (PipeR2D[2] & BitRA0D));

always @(posedge CLK)
	if (~SoftResetB) begin 
	L1BWAF <= 1'b0;
	L1BWCF <= 1'b0;
	L1BWDF <= 1'b0;
	end else begin
  	L1BWAF <= L1BWA;
	L1BWCF <= L1BWC;
	L1BWDF <= L1BWD;
	end
	
always @(posedge CLK) begin // shift by +1BC if L1B in Read
	if (~SoftResetB) begin 
	L1BWAG <= 1'b0;
	L1BWCG <= 1'b0;
	L1BWDG <= 1'b0;
	end else if (L1BReadVetoIn) begin
  	L1BWAG <= L1BWAF;
	L1BWCG <= L1BWCF;
	L1BWDG <= L1BWDF;
	end else begin // only that shit reg left if no use of L1BReadVeto
	L1BWAG <= L1BWAF;
	L1BWCG <= L1BWCF;
	L1BWDG <= L1BWDF;
	end
      end
      
wire   [`L1B_DATA_WIDTH-1:0]  L1BDataInA, L1BDataInC, L1BDataInD;
wire 	DataOrder; 
assign   L0ID_Local =  L0IDtoL1B_Address; 
assign DataOrder = ( ~PipeHoldAddress[0] ? BitRA0 : BitRA0D);   
assign L1BDataInA[`L1B_DATA_WIDTH-1:0] = {48'b1, L0ID_Local[`RO_ADDR_WIDTH-1:0], ( (PipeData1[263:0] & {264{~DataOrder}}) | (PipeData2[263:0] & {264{DataOrder}}))};
assign L1BDataInC[`L1B_DATA_WIDTH-1:0] = {48'b1, L0ID_Local[`RO_ADDR_WIDTH-1:0], ( (PipeData2[263:0] & {264{~DataOrder}}) | (PipeData1[263:0] & {264{DataOrder}}))};
assign L1BDataInD[`L1B_DATA_WIDTH-1:0] = {48'b1, L0ID_Local[`RO_ADDR_WIDTH-1:0], ( (PipeData1[263:0] & {264{~DataOrder}}) | (PipeData2[263:0] & {264{DataOrder}}))};

//L1Buffer A C D address assignments	


AddressSelect4  AddressSel( .CLK(CLK), .AI(R3_ReadStrob), .BI(L1_ReadStrob),
	.StrobA(L1ReadA), .StrobC(L1ReadC), .StrobD(L1ReadD),
	.R3_ReadStrob_A(R3_ReadStrob_A), .R3_ReadStrob_C(R3_ReadStrob_C), .R3_ReadStrob_D(R3_ReadStrob_D),
	.L1_ReadStrob_A(L1_ReadStrob_A), .L1_ReadStrob_C(L1_ReadStrob_C), .L1_ReadStrob_D(L1_ReadStrob_D),
	.AddressIn1(R3Address), .AddressIn2(L1Address), .AddressOut(L1B_Address)
	);
	

wire [`L1B_ADDR_WIDTH-1:0] WR_L1B_AddressA, WR_L1B_AddressC, WR_L1B_AddressD;
assign WR_L1B_AddressA = (L0IDtoL1B_Address[`L1B_ADDR_WIDTH-1:0] & {8{L1BWAG}}) | (L1B_Address[`L1B_ADDR_WIDTH-1:0] & {8{L1ReadA}});
assign WR_L1B_AddressC = (L0IDtoL1B_Address[`L1B_ADDR_WIDTH-1:0] & {8{L1BWCG}}) | (L1B_Address[`L1B_ADDR_WIDTH-1:0] & {8{L1ReadC}});
assign WR_L1B_AddressD = (L0IDtoL1B_Address[`L1B_ADDR_WIDTH-1:0] & {8{L1BWDG}}) | (L1B_Address[`L1B_ADDR_WIDTH-1:0] & {8{L1ReadD}});

wire L1B_DataOutA_m0, L1B_DataOutA_m1, L1B_DataOutA_m2, L1B_DataOutA_m3, L1B_DataOutA_m4; 
wire L1B_DataOutC_m0, L1B_DataOutC_m1, L1B_DataOutC_m2, L1B_DataOutC_m3, L1B_DataOutC_m4; 
wire L1B_DataOutD_m0, L1B_DataOutD_m1, L1B_DataOutD_m2, L1B_DataOutD_m3, L1B_DataOutD_m4; 

//L1Buffer A
mem256x64 SRAM_256x64_L1BA_G0(
	.CLOCK_in(CLK),
	.writeB(~L1BWAG),
	.readB(~L1ReadA),
	.addr_in(WR_L1B_AddressA[`L1B_ADDR_WIDTH-2:0]),
	.Page_sel_B(WR_L1B_AddressA[`L1B_ADDR_WIDTH-1]),
	.data_in(L1BDataInA[63:0]),
	.data_out(L1B_DataOutA[63:0]),
	.data_m(L1B_DataOutA_m0)
);

mem256x64 SRAM_256x64_L1BA_G1(
	.CLOCK_in(CLK),
	.writeB(~L1BWAG),
	.readB(~L1ReadA),
	.addr_in(WR_L1B_AddressA[`L1B_ADDR_WIDTH-2:0]),
	.Page_sel_B(WR_L1B_AddressA[`L1B_ADDR_WIDTH-1]),
	.data_in(L1BDataInA[127:64]),
	.data_out(L1B_DataOutA[127:64]),
	.data_m(L1B_DataOutA_m1)
);
mem256x64 SRAM_256x64_L1BA_G2(
	.CLOCK_in(CLK),
	.writeB(~L1BWAG),
	.readB(~L1ReadA),
	.addr_in(WR_L1B_AddressA[`L1B_ADDR_WIDTH-2:0]),
	.Page_sel_B(WR_L1B_AddressA[`L1B_ADDR_WIDTH-1]),
	.data_in(L1BDataInA[191:128]),
	.data_out(L1B_DataOutA[191:128]),
	.data_m(L1B_DataOutA_m2)
);
mem256x64 SRAM_256x64_L1BA_G3(
	.CLOCK_in(CLK),
	.writeB(~L1BWAG),
	.readB(~L1ReadA),
	.addr_in(WR_L1B_AddressA[`L1B_ADDR_WIDTH-2:0]),
	.Page_sel_B(WR_L1B_AddressA[`L1B_ADDR_WIDTH-1]),
	.data_in(L1BDataInA[255:192]),
	.data_out(L1B_DataOutA[255:192]),
	.data_m(L1B_DataOutA_m3)
);
/*mem256x64 SRAM_256x64_L1BA_G4(
	.CLOCK_in(CLK),
	.writeB(~L1BWAG),
	.readB(~L1ReadA),
	.addr_in(WR_L1B_AddressA[`L1B_ADDR_WIDTH-2:0]),
	.Page_sel_B(WR_L1B_AddressA[`L1B_ADDR_WIDTH-1]),
	.data_in(L1BDataInA[319:256]),
	.data_out(L1B_DataOutA[319:256]),
	.data_m(L1B_DataOutA_m4)
);*/

//L1Buffer C
mem256x64 SRAM_256x64_L1BC_G0(
	.CLOCK_in(CLK),
	.writeB(~L1BWCG),
	.readB(~L1ReadC),
	.addr_in(WR_L1B_AddressC[`L1B_ADDR_WIDTH-2:0]),
	.Page_sel_B(WR_L1B_AddressC[`L1B_ADDR_WIDTH-1]),
	.data_in(L1BDataInC[63:0]),
	.data_out(L1B_DataOutC[63:0]),
	.data_m(L1B_DataOutC_m0)
);

mem256x64 SRAM_256x64_L1BC_G1(
	.CLOCK_in(CLK),
	.writeB(~L1BWCG),
	.readB(~L1ReadC),
	.addr_in(WR_L1B_AddressC[`L1B_ADDR_WIDTH-2:0]),
	.Page_sel_B(WR_L1B_AddressC[`L1B_ADDR_WIDTH-1]),
	.data_in(L1BDataInC[127:64]),
	.data_out(L1B_DataOutC[127:64]),
	.data_m(L1B_DataOutC_m1)
);
mem256x64 SRAM_256x64_L1BC_G2(
	.CLOCK_in(CLK),
	.writeB(~L1BWCG),
	.readB(~L1ReadC),
	.addr_in(WR_L1B_AddressC[`L1B_ADDR_WIDTH-2:0]),
	.Page_sel_B(WR_L1B_AddressC[`L1B_ADDR_WIDTH-1]),
	.data_in(L1BDataInC[191:128]),
	.data_out(L1B_DataOutC[191:128]),
	.data_m(L1B_DataOutC_m2)
);
mem256x64 SRAM_256x64_L1BC_G3(
	.CLOCK_in(CLK),
	.writeB(~L1BWCG),
	.readB(~L1ReadC),
	.addr_in(WR_L1B_AddressC[`L1B_ADDR_WIDTH-2:0]),
	.Page_sel_B(WR_L1B_AddressC[`L1B_ADDR_WIDTH-1]),
	.data_in(L1BDataInC[255:192]),
	.data_out(L1B_DataOutC[255:192]),
	.data_m(L1B_DataOutC_m3)
);
mem256x64 SRAM_256x64_L1BC_G4(
	.CLOCK_in(CLK),
	.writeB(~L1BWCG),
	.readB(~L1ReadC),
	.addr_in(WR_L1B_AddressC[`L1B_ADDR_WIDTH-2:0]),
	.Page_sel_B(WR_L1B_AddressC[`L1B_ADDR_WIDTH-1]),
	.data_in(L1BDataInC[319:256]),
	.data_out(L1B_DataOutC[319:256]),
	.data_m(L1B_DataOutC_m4)
);

//L1Buffer D
mem256x64 SRAM_256x64_L1BD_G0(
	.CLOCK_in(CLK),
	.writeB(~L1BWDG),
	.readB(~L1ReadD),
	.addr_in(WR_L1B_AddressD[`L1B_ADDR_WIDTH-2:0]),
	.Page_sel_B(WR_L1B_AddressD[`L1B_ADDR_WIDTH-1]),
	.data_in(L1BDataInD[63:0]),
	.data_out(L1B_DataOutD[63:0]),
	.data_m(L1B_DataOutD_m0)
);

mem256x64 SRAM_256x64_L1BD_G1(
	.CLOCK_in(CLK),
	.writeB(~L1BWDG),
	.readB(~L1ReadD),
	.addr_in(WR_L1B_AddressD[`L1B_ADDR_WIDTH-2:0]),
	.Page_sel_B(WR_L1B_AddressD[`L1B_ADDR_WIDTH-1]),
	.data_in(L1BDataInD[127:64]),
	.data_out(L1B_DataOutD[127:64]),
	.data_m(L1B_DataOutD_m1)
);
mem256x64 SRAM_256x64_L1BD_G2(
	.CLOCK_in(CLK),
	.writeB(~L1BWDG),
	.readB(~L1ReadD),
	.addr_in(WR_L1B_AddressD[`L1B_ADDR_WIDTH-2:0]),
	.Page_sel_B(WR_L1B_AddressD[`L1B_ADDR_WIDTH-1]),
	.data_in(L1BDataInD[191:128]),
	.data_out(L1B_DataOutD[191:128]),
	.data_m(L1B_DataOutD_m2)
);
mem256x64 SRAM_256x64_L1BD_G3(
	.CLOCK_in(CLK),
	.writeB(~L1BWDG),
	.readB(~L1ReadD),
	.addr_in(WR_L1B_AddressD[`L1B_ADDR_WIDTH-2:0]),
	.Page_sel_B(WR_L1B_AddressD[`L1B_ADDR_WIDTH-1]),
	.data_in(L1BDataInD[255:192]),
	.data_out(L1B_DataOutD[255:192]),
	.data_m(L1B_DataOutD_m3)
);
/*mem256x64 SRAM_256x64_L1BD_G4(
	.CLOCK_in(CLK),
	.writeB(~L1BWDG),
	.readB(~L1ReadD),
	.addr_in(WR_L1B_AddressD[`L1B_ADDR_WIDTH-2:0]),
	.Page_sel_B(WR_L1B_AddressD[`L1B_ADDR_WIDTH-1]),
	.data_in(L1BDataInD[319:256]),
	.data_out(L1B_DataOutD[319:256]),
	.data_m(L1B_DataOutD_m4)
);*/

/*RAM_L1Buffer	L1BufferA( .BC(CLK),  
	.WriteStrob(L1BWAG), .WriteAddress(L0IDtoL1B_Address), .DataIn(L1BDataInA),
	.ReadStrob(L1ReadA), .ReadAddress(L1B_Address), .Dout(L1B_DataOutA)
	);
	
RAM_L1Buffer	L1BufferC( .BC(CLK),  
	.WriteStrob(L1BWCG), .WriteAddress(L0IDtoL1B_Address), .DataIn(L1BDataInC),
	.ReadStrob(L1ReadC), .ReadAddress(L1B_Address), .Dout(L1B_DataOutC)
	);
	
RAM_L1Buffer	L1BufferD( .BC(CLK),  
	.WriteStrob(L1BWDG), .WriteAddress(L0IDtoL1B_Address), .DataIn(L1BDataInD),
	.ReadStrob(L1ReadD), .ReadAddress(L1B_Address), .Dout(L1B_DataOutD)
	);
*/


	
//always @(posedge CLK) begin
	
//R3_ReadStrob1 <= R3_ReadStrob;
//L1_ReadStrob1 <= L1_ReadStrob;
//R3_ReadStrobS <= R3_ReadStrob1;
//L1_ReadStrobS <= L1_ReadStrob1;

//end
	
endmodule

