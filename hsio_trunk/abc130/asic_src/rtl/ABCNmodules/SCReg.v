//Special Command register (address 0 in register space)
// 32-bit serial loading register with triplication
// plus a bit of logic
`timescale 1ns/1ps
module SCReg (
  clkEn,
  bclka,
  bclkb,
  bclkc,
  rstb,
  calPulse,
  digitalTestPulse,
  regWriteDisable,
  HPRClear,
  serIn,
  serOut,
  shiftEn,
  latchIn,
  latchOut,
  shiftIn,
  shiftOut
); 
input clkEn;  //requires set_attribute lp_insert_clock_gating true
input  bclka;   
input  bclkb;   
input  bclkc;   
input  rstb;  
input  serIn;  	//indicates some previous register has had a soft-error
output serOut;  //indicates this or some previous register has had a soft-error
input shiftEn; 
input shiftIn; 
output shiftOut; 
input latchIn;	//load a write value from the shifter into the register
input latchOut; //load a read value from the register into the shifter

output digitalTestPulse;
output calPulse;
output regWriteDisable;
output HPRClear;

wire calPulse;

//[0]  trigger calibration pulse
//[1]  trigger digital test pulse
//[2]  disable writes to registers
//[3]  invert analog calibration pulse polarity.  0: low-going  1: high-going

wire [31:0] dataOut;  
//create an 8-clock long calibration pulse
//in response to dataOut[0] being set
reg [2:0] counter;
reg calPulseInt;  //internal calPulse
always @(posedge bclka )
  if ( rstb == 1'b0 ) begin
     calPulseInt <= 1'b0;
     counter[2:0] <= 3'b0;
  end
  else begin
    if ( dataOut[0] == 1'b1 ) 
      calPulseInt <= 1'b1;
    if ( calPulseInt == 1'b1 ) 
      counter[2:0] <= counter[2:0] + 1'b1;
    if ( counter[2:0] == 3'b111 )  begin
       counter[2:0] <= 3'b0;
       calPulseInt <= 1'b0;
    end //counter
  end

//wire calPulsePolarity = dataOut[3];
//assign calPulse = calPulsePolarity ? calPulseInt : !calPulseInt; //dataOut[3] sets calPulse polarity.  1: high pulse    0: low pulse
assign calPulse = calPulseInt;


wire pulseClear = calPulseInt || dataOut[1] || dataOut[2] || dataOut[3];  //clear the register after a test or calibration pulse or HPRClear

reg32tz regA(
  .clkEn (clkEn),
  .bclka (bclka),
  .bclkb (bclkb),
  .bclkc (bclkc),
  .rstb ( rstb ),
  .pulseRst ( pulseClear),
  .serIn (  serIn ),
  .serOut ( serOut ),
  .shiftIn ( shiftIn ),
  .shiftOut ( shiftOut ),
  .shiftEn (shiftEn),
  .latchIn ( latchIn ),
  .latchOut ( latchOut ),
  .dataOut ( dataOut )
);


//digitalTestPulse 1 clock long
//regWriteDisable set and stuck
assign digitalTestPulse = dataOut[1];
assign regWriteDisable = dataOut[4];
assign HPRClear = dataOut[2];
endmodule //SCReg
