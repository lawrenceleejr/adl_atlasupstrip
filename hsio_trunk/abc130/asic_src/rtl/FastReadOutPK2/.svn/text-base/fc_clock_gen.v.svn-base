`timescale 1ns / 1ps

module fc_clock_gen( clk_in, reset_n, clk_out1 );

   input  clk_in;
   input  reset_n;
   
   output clk_out1;

   wire   ci1;
   wire   ci2;

   wire   cloop1;


   BUFFER_E cb1( .A( clk_in ), .Z( ci1 ),.VDD(),.GND(),.NW(),.SX() );
   DFFR_E dff1( .D( cloop1 ), .CLK( ci1 ), .RN( reset_n ),
		.Q( clk_out1 ), .QBAR( cloop1 ),.VDD(),.GND(),.NW(),.SX() );

endmodule // fc_clock_gen

   
   
  
