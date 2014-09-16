
`timescale 1ns/1ps
module syncFifo (
  dIn,
  dOut,
  we,
  re,
  full,
  overflow,
  almostFull,
  empty,
  clk,
  rstb
);
  parameter WORDWIDTH=8;
  parameter logDEPTH=3;
  input [ WORDWIDTH - 1:0] dIn;
  output [ WORDWIDTH - 1:0] dOut;
  input we, re;
  output almostFull, full, empty;
  input clk;
  input rstb;
  output overflow;
  wire [ WORDWIDTH - 1:0] dIn;
  wire [ WORDWIDTH - 1:0] dOut;
  wire we, re;
  wire rstb;
  wire full, empty;
  reg overflow;

  parameter MAX = 2 ** logDEPTH;
  reg [ logDEPTH - 1: 0] rPtr;
  reg [ logDEPTH - 1  : 0] wPtr;
  reg [ logDEPTH : 0] occupancy;  //room to detect overflow
  reg [ WORDWIDTH - 1:0] mem[ MAX-1 : 0];

  assign empty = ( occupancy == 'h0);
  assign full = ( occupancy == MAX );
  assign almostFull = ( occupancy == (MAX - 1) );

  //overflow logic
  //if the FIFO is full and a we is received,
  //assert overflow for one clock to indicate data loss
  always @(posedge clk ) 
    if ( rstb == 1'b0 ) 
      overflow <= 1'b0;
    else
      overflow <= we && full;

  always @(posedge clk ) 
    if ( rstb == 1'b0 ) begin
      wPtr <=  'h0;
      rPtr <=  'h0;
    end //rstb
    else begin
      if ( we == 1'b1 ) 
	wPtr <= wPtr + 1'b1; 
      if ( re == 1'b1 ) 
	rPtr <= rPtr + 1'b1; 
    end //not reset

  assign dOut = mem[rPtr] ;  //output always valid, at current read pointer.

  //memory contents is not initialized
  //this is behavioral!!!
  //integer index;
  //always @(posedge clk or rstb) 
    //if ( rstb == 1'b0 ) begin
      //for ( index = 0; index < MAX; index = index + 1 ) mem[ index] = 'h0;
    //end

  always @(posedge clk ) 
      if ( we ) mem[ wPtr ] <= dIn;

  //calculate the occupancy of the fifo
  always @(posedge clk ) 
    if ( rstb == 1'b0 ) occupancy <= 'h0; 
    else begin
      case ( {re, we } )
        2'b10 :  begin
           occupancy <= occupancy - 1'b1;
        end
        2'b01 :  begin
           occupancy <= occupancy + 1'b1;
        end
      endcase
    end //not reset

`ifdef FIFO_DEBUG
   initial $display("[%t] Hi from FIFO %m", $time);
   always @(posedge overflow ) $display("[%t] Overflow of FIFO %m", $time);
`endif

endmodule

