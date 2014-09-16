// Created by ihdl
`timescale 1ns/10ps

`celldefine

module DFFR_E (Q,QBAR,CLK,D,RN,VDD,GND,NW,SX);
  // Modified on 20-04-2010 by Sandro Bonacini
  // Added power supply and ground ports
  // Imported into Virtuoso library cmos8rf
  inout VDD,GND,NW,SX;

  output  Q;
  output  QBAR;
  input  CLK;
  input  D;
  input  RN;

  reg    notifier;
  DFFR  i0 (Q,QBAR,CLK,D,RN,notifier);

specify

  (posedge CLK => (Q +: CLK)) = (0.1:0.1:0.1, 0.1:0.1:0.1);
  (negedge RN => (Q +: RN)) = (0.1:0.1:0.1, 0.1:0.1:0.1);
  (posedge CLK => (QBAR +: CLK)) = (0.1:0.1:0.1, 0.1:0.1:0.1);
  (negedge RN => (QBAR -: RN)) = (0.1:0.1:0.1, 0.1:0.1:0.1);
  $setuphold (posedge CLK &&& RN,posedge D,0.09,0.09,notifier);
  $setuphold (posedge CLK &&& RN,negedge D,0.09,0.09,notifier);
  $setup (posedge RN,posedge CLK,0.09,notifier);
  $width (negedge CLK &&& RN,0.4,0,notifier);
  $width (posedge CLK &&& RN,0.4,0,notifier);
  $width (negedge RN,0.4,0,notifier);
endspecify

endmodule

`endcelldefine
