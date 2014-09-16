// Created by ihdl
`timescale 1ns/10ps

module MUX21BAL (Z,D0,D1,SD);

  output  Z;
  input   D0;
  input   D1;
  input   SD;

  wire Z_; 
  wire Z,SD,D0,D1;

  //  *** MUX21_UDP u0 (Z_,SD,D0,D1);
  // *** buf b1 (Z,Z_);


  assign Z = (SD) ? D1 : D0; // ***
  

endmodule
