// Created by ihdl
`timescale 1ns/10ps

module DFFR (Q,QBAR,CLK,D,RN,notifier);

  output  Q;
  output  QBAR;
  input   CLK;
  input   D;
  input   RN;
  input   notifier;
  
  reg Q; // ***
  
  always @ ( posedge CLK or negedge RN)  // ***
  if (~RN) begin // ***
    Q <= 1'b0; // ***
  end // ***
  else begin // ***
    Q <= D; // ***
  end // ***
 
  assign QBAR = ~Q;  // ***
  
  

  // ***DFF_ASYNR  r1 (qout,CLK,D,RN,notifier);
  // ***buf        b0 (Q, qout);
  // ***not        i1 (QBAR, qout);

endmodule
