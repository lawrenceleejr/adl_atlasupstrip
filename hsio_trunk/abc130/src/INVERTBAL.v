// Created by ihdl
`timescale 1ns/10ps

module INVERTBAL (Z,A);

  output  Z;
  input   A;

  wire Z,A;

  not i0 (Z,A);

endmodule
