// Created by ihdl
`timescale 1ns/10ps

`celldefine

module BUFFER_E (Z,A,VDD,GND,NW,SX);
  // Modified on 20-04-2010 by Sandro Bonacini
  // Added power supply and ground ports
  // Imported into Virtuoso library cmos8rf
  inout VDD,GND,NW,SX;

  output  Z;
  input  A;

  BUFFER  i0 (Z,A);

specify

  (A +=> Z) = (0.0:0.0:0.0, 0.0:0.0:0.0);
endspecify

endmodule

`endcelldefine
