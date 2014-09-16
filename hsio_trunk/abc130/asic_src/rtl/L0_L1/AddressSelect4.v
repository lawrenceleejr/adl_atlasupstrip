//Verilog HDL 
// Selects address to read L1Buffer
//
// F.A. 06 June 2011
//
//

`timescale 1ns/1ps


module AddressSelect4( CLK, AI, BI, StrobA, StrobC, StrobD,
	R3_ReadStrob_A, R3_ReadStrob_C, R3_ReadStrob_D,
	L1_ReadStrob_A, L1_ReadStrob_C, L1_ReadStrob_D,
	AddressIn1, AddressIn2, AddressOut
	);
	
input				CLK,AI,BI;
input	[`L1B_ADDR_WIDTH-1:0]	AddressIn1;
input	[`L1B_ADDR_WIDTH-1:0]	AddressIn2;		
output	[`L1B_ADDR_WIDTH-1:0]	AddressOut;
output				StrobA, StrobC, StrobD;
output 				R3_ReadStrob_A, R3_ReadStrob_C, R3_ReadStrob_D;
output 				L1_ReadStrob_A, L1_ReadStrob_C, L1_ReadStrob_D;

wire	[`L1B_ADDR_WIDTH-1:0]	AddressOut;

wire				StrobA, StrobC, StrobD;
wire 				R3_ReadStrob_A, R3_ReadStrob_C, R3_ReadStrob_D; 
wire 				L1_ReadStrob_A, L1_ReadStrob_C, L1_ReadStrob_D; 
reg				Select;
reg	[3:0]			CIS, DIS;



///////////////////////////////////////////////////////////////////
// Generate ROReadStrob stretched to 3 BC's //
///////////////////////////////////////////////////////////////////
  always @( posedge CLK ) begin
    if ( AI ) begin 
      Select <= 0; // default if A is 1 whatever B is
    end else 
    if ( BI ) begin 
      Select <= 1; // Only if A was 0 and B is one
    end else begin
      Select <= Select;  // default if 0,0
    end
    begin
    CIS[0] <= AI;
    DIS[0] <= BI;
    CIS[1] <= CIS[0];
    DIS[1] <= DIS[0];
    CIS[2] <= CIS[1];
    DIS[2] <= DIS[1];
    CIS[3] <= CIS[2];
    DIS[3] <= DIS[2];
    end
  end
  
assign AddressOut = (Select) ? AddressIn2:AddressIn1;


//always @( posedge CLK ) begin
//	if (~Select) 
//		AddressOut <= AddressIn1;
//	else
//		AddressOut <= AddressIn2;
//end

assign  StrobA = (CIS[0] & ~Select) | (DIS[0] & Select);
assign  StrobC = (CIS[1] & ~Select) | (DIS[1] & Select);
assign  StrobD = (CIS[2] & ~Select) | (DIS[2] & Select);

assign 	R3_ReadStrob_A = (CIS[1] & ~Select);
assign 	R3_ReadStrob_C = (CIS[2] & ~Select);
assign 	R3_ReadStrob_D = (CIS[3] & ~Select);

assign 	L1_ReadStrob_A = (DIS[1] & Select);
assign 	L1_ReadStrob_C = (DIS[2] & Select);
assign 	L1_ReadStrob_D = (DIS[3] & Select);
  
endmodule
