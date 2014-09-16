//Verilog HDL 
// Selects address to read L1Buffer
//
// F.A. 06 June 2011
//
//

`timescale 1ns/1ps


module AddressSelect( CLK, AI, BI, CI, DI, Strob,
	AddressIn1, AddressIn2, AddressOut
	);
	
input				CLK,AI,BI,CI,DI;
input	[`L1B_ADDR_WIDTH-1:0]	AddressIn1;
input	[`L1B_ADDR_WIDTH-1:0]	AddressIn2;		
output	[`L1B_ADDR_WIDTH-1:0]	AddressOut;
output				Strob;

wire	[`L1B_ADDR_WIDTH-1:0]	AddressOut;

wire				Strob;
reg				Select, CIS, DIS;



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
    CIS <= CI;
    DIS <= DI;
    end
  end
  
assign AddressOut = (Select) ? AddressIn2:AddressIn1;


//always @( posedge CLK ) begin
//	if (~Select) 
//		AddressOut <= AddressIn1;
//	else
//		AddressOut <= AddressIn2;
//end

assign  Strob = (CIS & ~Select) | (DIS & Select);
  
endmodule
