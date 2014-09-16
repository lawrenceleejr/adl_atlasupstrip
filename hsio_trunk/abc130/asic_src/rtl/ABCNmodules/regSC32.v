//'Special Command' register
//this is a 32-bit serial loading register
//with some extra logic to do pulsing, etc
`timescale 1ns/1ps
module regSC32 (
  clkEn,
  bclk,
  rstb,
  shiftEn,
  latchIn,
  latchOut,
  shiftIn,
  shiftOut,
  calPulse,
  digitalTestPulse
); 
input clkEn;
input  bclk;   
input  rstb;  
output calPulse;
output digitalTestPulse;
input shiftEn; 
input shiftIn; 
output shiftOut; 
input latchIn;	//load a write value from the shifter into the register
input latchOut; //load a read value from the register into the shifter

wire [31:0] dataOut;  
reg last_cal, last_dtp;
wire calPulse = dataOut[0] & ~last_cal;
wire digitalTestPulse = dataOut[1] & ~last_dtp;


reg32 SCreg(
  .clkEn (clkEn),
  .bclk (bclk),
  .rstb ( rstb),
  .shiftIn ( shiftIn ),
  .shiftOut ( shiftOut ),
  .shiftEn (shiftEn),
  .latchIn ( latchIn ),
  .latchOut ( latchOut ),
  .dataOut ( dataOut )
);

//bit 0 is calibration-pulse trigger
always @(posedge bclk)
  if ( rstb == 1'b0 | latchIn == 1'b1) last_cal <= 1'b0;
  else last_cal <= dataOut[0];

//bit 1 is calibration-pulse trigger
always @(posedge bclk)
  if ( rstb == 1'b0 | latchIn == 1'b1) last_dtp <= 1'b0;
  else last_dtp <= dataOut[1];




endmodule //reg32
