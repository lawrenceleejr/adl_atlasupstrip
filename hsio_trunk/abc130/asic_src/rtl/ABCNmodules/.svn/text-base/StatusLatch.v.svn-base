// high-priority register-read interface
//  captures overflows
`timescale 1ns/1ps
module StatusLatch (
   input clk, rstb, SigIn,
   output reg SigOut
); 
//the input,output shift register
always @(posedge clk) 
   if ( rstb == 1'b0 )
     SigOut <= 1'b0;
   else  if ( SigIn == 1'b1)
    SigOut <= 1'b1;
endmodule //StatusLatch
