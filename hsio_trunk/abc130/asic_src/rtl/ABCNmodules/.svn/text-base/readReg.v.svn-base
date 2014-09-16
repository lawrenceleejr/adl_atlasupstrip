`timescale 1ns/1ps
// This module provides the register read value in parallel form to the readOut module
// special version of 32-bit serial loading register
// designed to receive the serial read signals from primary reg32 instances.
//`include "timescale.inc"
module readReg (
  clk,
  rstb,
  shiftEn,
  latchIn,
  shiftIn,
  dataOut,
  push
); 
input  clk;  
input  rstb;  
output [31:0] dataOut;  
output push;  //push data into readOut
input shiftEn; 
input shiftIn; 
input latchIn;	//load a write value from the shifter into the register

reg push;
reg [31:0] dataOut;  
reg [31:0] shifter;  
reg pushx; //used for delaying the actual push signal by one clock




reg lastLatchIn;  //latchIn delayed one clock
always @(posedge clk )
   if ( rstb == 1'b0 )  begin
     lastLatchIn <= 1'b0;
     push <= 1'b0;
     pushx <= 1'b0;
   end
   else begin
     lastLatchIn <= latchIn;
     pushx <= lastLatchIn;
     push <= pushx;
   end


always @(posedge clk ) 
   if ( rstb == 1'b0 )  begin
     dataOut <= 32'h0;
     shifter <= 32'h0;
   end
   else 
     if (shiftEn == 1'b1  & lastLatchIn == 1'b0 )  begin
       shifter[31:1] <= shifter[30:0];   //bits arrive as msb->lsb
       shifter[0] <= shiftIn;
     end
   else 
     if ( lastLatchIn == 1'b1)  begin
        dataOut <= shifter;
     end

endmodule //reg32
