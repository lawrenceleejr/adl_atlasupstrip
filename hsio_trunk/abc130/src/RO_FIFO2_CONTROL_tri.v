// made on 2011-08-17 10:41:05
// TRM version
`timescale  1ns /  1ps


//***
`include "../../abc130/src/veri_globals_P5.v"


module RO_FIFO2_CONTROL_tri( 
			BC,
			ResetB,
			SyncWrite,
			ReadEnable,
			WriteFIFO,
			FWriteAddress,
			ReadFIFO,
			ROReadStrob,
			FReadAddress,
			Empty,
			Full
			);



///////////////////////////////////////////////////////////////////// 
/////parameters
parameter RO_FIFO_max_depth =	(1<<(`FIFO_ADDR_WIDTH));

///////////////////////////////////////////////////////////////////// 
/////OLD inputs tri
input BC, ResetB, SyncWrite, ReadEnable;

///////////////////////////////////////////////////////////////////// 
/////NEW triple wires from the old inputs tri
wire BC_1, ResetB_1, SyncWrite_1, ReadEnable_1;
wire BC_2, ResetB_2, SyncWrite_2, ReadEnable_2;
wire BC_3, ResetB_3, SyncWrite_3, ReadEnable_3;

///////////////////////////////////////////////////////////////////// 
/////assign for the triplicated wires
assign BC_1=BC;
assign BC_2=BC;
assign BC_3=BC;
assign ResetB_1=ResetB;
assign ResetB_2=ResetB;
assign ResetB_3=ResetB;
assign SyncWrite_1=SyncWrite;
assign SyncWrite_2=SyncWrite;
assign SyncWrite_3=SyncWrite;
assign ReadEnable_1=ReadEnable;
assign ReadEnable_2=ReadEnable;
assign ReadEnable_3=ReadEnable;

///////////////////////////////////////////////////////////////////// 
/////NEW OUTPUTS now wires tri
wire Empty_o_1, Full_o_1, FWriteStrob_o_1, FReadStrob_o_1;
wire Empty_o_2, Full_o_2, FWriteStrob_o_2, FReadStrob_o_2;
wire Empty_o_3, Full_o_3, FWriteStrob_o_3, FReadStrob_o_3;

///////////////////////////////////////////////////////////////////// 
/////NEW OUTPUTS BUSES now wires tri
wire  [`FIFO_ADDR_WIDTH-1:0] FWriteAddress_o_1;
wire  [`FIFO_ADDR_WIDTH-1:0] FReadAddress_o_1, FLastAddress_o_1;
wire  [`FIFO_ADDR_WIDTH-1:0] FWriteAddress_o_2;
wire  [`FIFO_ADDR_WIDTH-1:0] FReadAddress_o_2, FLastAddress_o_2;
wire  [`FIFO_ADDR_WIDTH-1:0] FWriteAddress_o_3;
wire  [`FIFO_ADDR_WIDTH-1:0] FReadAddress_o_3, FLastAddress_o_3;

///////////////////////////////////////////////////////////////////// 
/////wire from internal registers tri
wire FWriteStrob, FReadStrob;

///////////////////////////////////////////////////////////////////// 
/////wire buses from internal registers tri
wire [`FIFO_ADDR_WIDTH-1:0]  FLastAddress;

///////////////////////////////////////////////////////////////////// 
/////OLD OUTPUTS now wires
wire WriteFIFO_1, ReadFIFO_1, ROReadStrob_1;
wire WriteFIFO_2, ReadFIFO_2, ROReadStrob_2;
wire WriteFIFO_3, ReadFIFO_3, ROReadStrob_3;

///////////////////////////////////////////////////////////////////// 
/////NEW OUTPUTS BUSES to the outside
output  [`FIFO_ADDR_WIDTH-1:0] FWriteAddress;

output  [`FIFO_ADDR_WIDTH-1:0] FReadAddress;


///////////////////////////////////////////////////////////////////// 
/////OUTPUTS singles to the outside
output WriteFIFO, ReadFIFO, ROReadStrob, Empty, Full;

///////////////////////////////////////////////////////////////////// 
/////triplicated instances
RO_FIFO2_CONTROL_internal  RO_FIFO2_CONTROL_internal_1( .BC(BC_1), .ResetB(ResetB_1), .SyncWrite(SyncWrite_1), .ReadEnable(ReadEnable_1), .Empty_i(Empty), .Full_i(Full), .FWriteAddress_i(FWriteAddress), .FReadAddress_i(FReadAddress), .FLastAddress_i(FLastAddress), .WriteFIFO(WriteFIFO_1), .ReadFIFO(ReadFIFO_1), .ROReadStrob(ROReadStrob_1), .Empty_o(Empty_o_1), .Full_o(Full_o_1), .FWriteStrob_o(FWriteStrob_o_1), .FReadStrob_o(FReadStrob_o_1), .FWriteAddress_o(FWriteAddress_o_1), .FReadAddress_o(FReadAddress_o_1), .FLastAddress_o(FLastAddress_o_1));

RO_FIFO2_CONTROL_internal  RO_FIFO2_CONTROL_internal_2( .BC(BC_2), .ResetB(ResetB_2), .SyncWrite(SyncWrite_2), .ReadEnable(ReadEnable_2), .Empty_i(Empty), .Full_i(Full), .FWriteAddress_i(FWriteAddress), .FReadAddress_i(FReadAddress), .FLastAddress_i(FLastAddress), .WriteFIFO(WriteFIFO_2), .ReadFIFO(ReadFIFO_2), .ROReadStrob(ROReadStrob_2), .Empty_o(Empty_o_2), .Full_o(Full_o_2), .FWriteStrob_o(FWriteStrob_o_2), .FReadStrob_o(FReadStrob_o_2), .FWriteAddress_o(FWriteAddress_o_2), .FReadAddress_o(FReadAddress_o_2), .FLastAddress_o(FLastAddress_o_2));

RO_FIFO2_CONTROL_internal  RO_FIFO2_CONTROL_internal_3( .BC(BC_3), .ResetB(ResetB_3), .SyncWrite(SyncWrite_3), .ReadEnable(ReadEnable_3), .Empty_i(Empty), .Full_i(Full), .FWriteAddress_i(FWriteAddress), .FReadAddress_i(FReadAddress), .FLastAddress_i(FLastAddress), .WriteFIFO(WriteFIFO_3), .ReadFIFO(ReadFIFO_3), .ROReadStrob(ROReadStrob_3), .Empty_o(Empty_o_3), .Full_o(Full_o_3), .FWriteStrob_o(FWriteStrob_o_3), .FReadStrob_o(FReadStrob_o_3), .FWriteAddress_o(FWriteAddress_o_3), .FReadAddress_o(FReadAddress_o_3), .FLastAddress_o(FLastAddress_o_3));

majority_voter #(.WIDTH( 7 + `FIFO_ADDR_WIDTH + `FIFO_ADDR_WIDTH + `FIFO_ADDR_WIDTH)) mv (
		.in1({WriteFIFO_1, ReadFIFO_1, ROReadStrob_1, Empty_o_1, Full_o_1, FWriteStrob_o_1, FReadStrob_o_1, FWriteAddress_o_1, FReadAddress_o_1, FLastAddress_o_1}),
		.in2({WriteFIFO_2, ReadFIFO_2, ROReadStrob_2, Empty_o_2, Full_o_2, FWriteStrob_o_2, FReadStrob_o_2, FWriteAddress_o_2, FReadAddress_o_2, FLastAddress_o_2}),
		.in3({WriteFIFO_3, ReadFIFO_3, ROReadStrob_3, Empty_o_3, Full_o_3, FWriteStrob_o_3, FReadStrob_o_3, FWriteAddress_o_3, FReadAddress_o_3, FLastAddress_o_3}),
		.out({WriteFIFO, ReadFIFO, ROReadStrob, Empty, Full, FWriteStrob, FReadStrob, FWriteAddress, FReadAddress, FLastAddress}),
		.err()
	);
endmodule
