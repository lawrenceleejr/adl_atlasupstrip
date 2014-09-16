//`include "timescale.inc"
`timescale 1ns/1ps

//create a slow-clock version of RE from the fast-clock version.
//create a one bclk-long output pulse from a one clk-long input pulse
//will handle 1:1, 2:1, 4:1 f(clk)/f(bclk) ratios
module stretchRE(
  clk,
  bclk,
  rstb,
  reI,
  reO
);
input clk, bclk, rstb;
input reI;  //emtpy signal gets moved from fast to slow clk
output reO; //re oh
wire clk, bclk, rstb;
reg reO;

//reO gets set in clk domain
reg stretchRE;//gets set by reI in clk domain, cleared on reO
always @(posedge clk )
  if ( rstb == 1'b0 ) 
    stretchRE <= 1'b0;
  else
    if ( reI == 1'b1)
      stretchRE <= 1'b1;
    else
      if ( reO == 1'b1)
        stretchRE <= 1'b0;


//reO is in bclk domain
always @(posedge bclk )
  if ( rstb == 1'b0 ) 
    reO <= 1'b0;
  else 
    if ( reO == 1'b1)  //reO should only be high for one bclk
      reO <= 1'b0; 
    else
      if ( stretchRE == 1'b1 )
        reO <= 1'b1;


endmodule
