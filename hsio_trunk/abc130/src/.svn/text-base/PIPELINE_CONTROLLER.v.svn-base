//*****************************************************************************
// PipeLine Address Controller
// 
// 12.03.2001. V.R.
//
// removed integer i 13/11/07
// Modify reset for DeraLastAddress S.P. 12/06/2008
// Copy code and adapt for L0/L1 readout F.A. 10/02/2011, use L0 instead of L1
// L0A sync'ed at exactly 3BC
// New (test) version for single port memory access F.A. 14/12/2011 (actually no change)
//*****************************************************************************
`timescale  1ps /  1ps

//***
`include "../../abc130/src/veri_globals_P5.v"


module PIPELINE_CONTROLLER( 
	BC, SoftResetB, L0A, 
	PipeHoldAddress, 
	PipeWriteStrob, PipeWriteAddress,
	PipeReadStrob, PipeReadAddress,
	L1B_W
	);

parameter pipe_max_address =	(1<<(`PIPE_ADDR_WIDTH));

input				BC, SoftResetB, L0A;
input	[`PIPE_ADDR_WIDTH-1:0]	PipeHoldAddress;
output				PipeWriteStrob, PipeReadStrob;
output	[`PIPE_ADDR_WIDTH-1:0]	PipeWriteAddress, PipeReadAddress;
output 	[2:0]			L1B_W;

reg	[2:0]			stretch_L0A_reg;  // FA : stretch extended by one bit (#ABCN25)
reg				PipeWriteStrob, PipeReadStrob;
reg	[`PIPE_ADDR_WIDTH-1:0]	PipeWriteAddress, PipeReadAddress;

reg 	[2:0]			L1B_W;

/////////////////////////////////////////////////
// Generate Pipeline WriteAddress & WriteStrob //
/////////////////////////////////////////////////
  always @( posedge BC ) begin

    if ( ~SoftResetB ) begin 
      PipeWriteStrob <= 0;
      PipeWriteAddress <= pipe_max_address - 1;
    end else begin
      PipeWriteStrob <= 1;
      PipeWriteAddress <= PipeWriteAddress + 1;
    end
  end
///////////////////////////////////////////////////////////////////
// Generate Pipeline ReadAddress & ReadStrob stretched to 3 BC's //
///////////////////////////////////////////////////////////////////
  always @( posedge BC ) begin
    if ( ~SoftResetB ) begin 
      stretch_L0A_reg <= 0;
      PipeReadStrob <= 0;
      PipeReadAddress <= 0;
    end else begin
      stretch_L0A_reg[0] <= L0A;
      stretch_L0A_reg[1] <= stretch_L0A_reg[0];
      stretch_L0A_reg[2] <= stretch_L0A_reg[1];
      PipeReadStrob <=  ( |stretch_L0A_reg ); // FA : here Pipereadstrobe is fully resync on clock (# ABCN25)
      L1B_W[0] <= stretch_L0A_reg[0];
      L1B_W[1] <= stretch_L0A_reg[1];
      L1B_W[2] <= stretch_L0A_reg[2];
      if ( |stretch_L0A_reg ) begin
      	PipeReadAddress <= PipeWriteAddress - PipeHoldAddress;
      end
    end
  end
  
//  always @( posedge BC ) begin
//    if ( ~SoftResetB | L0IDReset ) begin
//    L0ID_Local <= ((8'hFF) & {8{~L0IDPreset}} | (PreL0ID & {8{L0IDPreset}}));
//    end
//    else if ( stretch_L0A_reg[0] ) begin
//	L0ID_Local <= L0ID_Local + 1;
//   end	
//   end
	
    
endmodule

