`timescale 1ns/1ps

module triggerCounter (
  clk,
  rstb,
  trigger,
  count
);


input clk;    
input rstb;
input trigger;
output [7:0] count;

wire [7:0] count;

reg [7:0] countA;
reg [7:0] countB;
reg [7:0] countC;
wire [7:0] hardCount;

assign count[7:0] = hardCount[7:0];

//majority logic
assign hardCount[0] = (countA[0] & countB[0]) | (countA[0] & countC[0]) | (countB[0] & countC[0]);
assign hardCount[1] = (countA[1] & countB[1]) | (countA[1] & countC[1]) | (countB[1] & countC[1]);
assign hardCount[2] = (countA[2] & countB[2]) | (countA[2] & countC[2]) | (countB[2] & countC[2]);
assign hardCount[3] = (countA[3] & countB[3]) | (countA[3] & countC[3]) | (countB[3] & countC[3]);
assign hardCount[4] = (countA[4] & countB[4]) | (countA[4] & countC[4]) | (countB[4] & countC[4]);
assign hardCount[5] = (countA[5] & countB[5]) | (countA[5] & countC[5]) | (countB[5] & countC[5]);
assign hardCount[6] = (countA[6] & countB[6]) | (countA[6] & countC[6]) | (countB[6] & countC[6]);
assign hardCount[7] = (countA[7] & countB[7]) | (countA[7] & countC[7]) | (countB[7] & countC[7]);


//set up so that a SEU in countA or countB or countC will be corrected on each increment.
//the logic will fail only iff there is an SEU on two of the three count{A,B,C} during the same increment.
always @(posedge clk ) begin
   if ( rstb == 1'b0 ) begin
       countA <= 8'h0;
       countB <= 8'h0;
       countC <= 8'h0;
   end
   else if ( trigger == 1'b1 ) begin
     countA <= hardCount + 1'b1;
     countB <= hardCount + 1'b1;
     countC <= hardCount + 1'b1;
   end
end //always clock


endmodule

