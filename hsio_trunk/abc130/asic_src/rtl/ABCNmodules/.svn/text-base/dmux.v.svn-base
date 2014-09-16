`timescale 1ns/1ps
// double-data-rate demux
// single input, two outputs, on rising and falling edges of the clock
module dmux(
  clk,
  rstb,
  in,
  outR,
  outF
); 
input clk;
input rstb;
input in;
output outR; //data captured on clock-rise
output outF; //data captured on clock-fall

reg outR, outF;
reg tmpR, tmpF;

always @(posedge clk, negedge rstb)
  if ( rstb == 1'b0 ) 
    tmpR <= 1'b0;
  else
    tmpR <= in;

always @(negedge clk, negedge rstb)
  if ( rstb == 1'b0 )
    tmpF <= 1'b0;
  else
    tmpF <= in;

always @(posedge clk, negedge rstb) 
   if ( rstb == 1'b0 ) begin
     outR <= 1'b0;
     outF <= 1'b0;
   end // rstb 
   else begin
     outR <= tmpR;
     outF <= tmpF;
   end

endmodule //dmux
