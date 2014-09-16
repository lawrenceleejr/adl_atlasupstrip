// Created by ihdl
`timescale 1ns/10ps

`celldefine

module DELAY4_C (Z,A,VDD,GND,NW,SX);
  // Modified on 20-04-2010 by Sandro Bonacini
  // Added power supply and ground ports
  // Imported into Virtuoso library cmos8rf
  inout VDD,GND,NW,SX;

  output  Z;
  input  A;

  DELAY4  i0 (Z,A);

specify


  `ifdef DELAY_CELL_NOM_DLY
    specparam tech_dly = 0.315;
  `else
  `ifdef DELAY_CELL_ZERO_DLY
    specparam tech_dly = 0.0;
  `else
    specparam tech_dly = 0.2;
  `endif
  `endif

  (A +=> Z) = (tech_dly:tech_dly:tech_dly , tech_dly:tech_dly:tech_dly);
endspecify

endmodule

`endcelldefine
