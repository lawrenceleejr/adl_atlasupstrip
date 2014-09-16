// Created by ihdl
`timescale 1ns/10ps

module DELAY4 (Z,A);

  output  Z;
  input   A;

  wire Z,A ;

  buf  b1 (Z,A);

endmodule
