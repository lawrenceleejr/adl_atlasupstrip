// prototype differential IO pad, probably SLVS or LVDS
`timescale 1ns/1ps
module padIn(
  padP,
  padN,
  dataIn,
); 
output dataIn; //data being received
input padP, padN;  //pad-side

wire  dataIn;
wire padP, padN;
//assign dataIn = padP ^ padN ? padP : 1'bx;
assign dataIn = padP;

endmodule //padIn
