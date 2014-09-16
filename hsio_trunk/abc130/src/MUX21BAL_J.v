// Created by ihdl
`timescale 1ns/10ps

`celldefine

module MUX21BAL_J (Z,D0,D1,SD,VDD,GND,NW,SX);
  // Modified on 20-04-2010 by Sandro Bonacini
  // Added power supply and ground ports
  // Imported into Virtuoso library cmos8rf
  inout VDD,GND,NW,SX;

  output  Z;
  input  D0;
  input  D1;
  input  SD;

  MUX21BAL  i0 (Z,D0,D1,SD);

specify

  (D0 +=> Z) = (0.0:0.0:0.0, 0.0:0.0:0.0);
  (D1 +=> Z) = (0.0:0.0:0.0, 0.0:0.0:0.0);
if(SD)
  (posedge SD => (Z:SD) ) = (0.0:0.0:0.0, 0.0:0.0:0.0);
if(!SD)
  (negedge SD => (Z:SD) ) = (0.0:0.0:0.0, 0.0:0.0:0.0);
endspecify

endmodule

`endcelldefine
