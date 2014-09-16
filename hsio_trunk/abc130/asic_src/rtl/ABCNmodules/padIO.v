// prototype differential IO pad, probably SLVS or LVDS
`timescale 1ns/1ps
module padIO(
  oen,
  padP,
  padN,
  dataIn,
  dataOut
); 
input  oen;  //output enable active low
input dataOut;  //data to be asserted
output dataIn; //data being received
inout padP, padN;  //pad-side

////synopsys translate_off
//wire  dataIn;
//wire padP, padN;
//assign dataIn = padP;
//assign padP = oen ? 1'bz : dataOut;
//assign padN = oen ? 1'bz : !dataOut;
////synopsys translate_on

//In Verilog library below cells contains also VDD, DVDD and DVSS ports but these ports are not
//present in timing library and cause synthesis error
SIOB12_B padP_mod (.PAD(padP),.Z(),.ZH(dataIn),.A( dataOut),.RG(1'b1),.TS(~oen));
SIOB12_B padN_mod (.PAD(padN),.Z(),.ZH(),      .A(~dataOut),.RG(1'b1),.TS(~oen));

endmodule //padIO
