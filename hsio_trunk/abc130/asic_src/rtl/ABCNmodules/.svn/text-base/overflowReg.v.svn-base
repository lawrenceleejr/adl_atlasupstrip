// high-priority register-read interface
//  captures overflows
`timescale 1ns/1ps
module overflowReg (
  bclk,
  rstb,
  of,
  dataOut,
  push
); 
input  bclk;   
input  rstb;  
input  [31:0] of;
output [31:0] dataOut;  
output push;

reg [31:0] dataOut, dataOutL;  
//wire push = dataOut[0] || dataOut[1] || dataOut[2] || dataOut[3] || dataOut[4];
wire [31:0] pushi;
//integer i;
//the input,output shift register
always @(posedge bclk ) 
//   if ( rstb == 1'b0  || push == 1'b1)  begin
   if ( rstb == 1'b0 )  begin
     dataOut <= 32'h0;
     dataOutL <= 32'h0;
   end
   else  begin
//    for ( i = 0; i < 32; i = i+1) begin
//    dataOut <= of | dataOut;
    dataOut <= of | dataOut;
    dataOutL <= dataOut;
//    end
   end  //not reset
assign pushi = dataOut & ~dataOutL;
wire push = |pushi;

endmodule //overflowReg
