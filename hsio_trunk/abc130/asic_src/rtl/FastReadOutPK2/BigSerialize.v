`timescale 1ns / 1ps

/*
 * BigSerialize
 * 
 * Serialize the 32-bit dataIn input into two 1-bit output streams on
 * dataOut1 and dataOut2. Input data are latched on high dataV and
 * serialized with the input FSclk.
 * 
 * If enable is low, FSclk is gated off and the outputs are held low.
 * 
 * Nandor Dressnandt, Amogh Halgeri, Paul T. Keener, Mitch Newcomer
 * 
 * University of Pennsylvania
 * 
 * April 2013
 */
module BigSerialize( dataIn, dataV, enable, out_clk, reset_n, 
		     dataOut1, dataOut2 );
   
   input [31:0] dataIn;      // parallel data in
   input        dataV;       // Data Valid from latch
   input 	enable;      // enable clock
   input        out_clk;   // Fast (80 - 640 MHz) clock for output
   input 	reset_n;

   output       dataOut1;
   output       dataOut2;

   wire         FSclk;       // Fast (40 - 320 MHz) clock

   wire         d_out1;
   wire 	d_out2;

   wire         out1;
   wire 	out2;

   wire 	fs_gclk;
   
   


//   clock_gate cg2( .enable( 1'b1 ), .clk_in( FSclk ), .clk_out( fs_gclk ) );
   clock_gate_bs cg2( .enable( enable ), .clk_in( out_clk ),
		      .clk_out( out_gclk ) );

   fc_clock_gen fcg1( .clk_in( out_gclk ), .reset_n( reset_n ),
		      .clk_out1( fs_gclk  ) );
   
   
   
 	
   FCserializerHalf s1 ( .dataIn( dataIn[31:16]), .dataV( dataV ),
			 .FSclk( fs_gclk ), .out_clk( out_gclk ),
			 .reset_n( reset_n ), .dataOut( out1 ) );
   
   FCserializerHalf s2 ( .dataIn( dataIn[15:0]), .dataV( dataV ),
			 .FSclk( fs_gclk ), .out_clk( out_gclk ),
			 .reset_n( reset_n ), .dataOut( out2 ) );

   assign d_out1 = enable ? out1 : 0;
   assign d_out2 = enable ? out2 : 0;

   /*
    * Comment these lines out for synthesis
    *
    *
   assign dataOut1 = d_out1;
   assign dataOut2 = d_out2;
   */
	  
   /*
    * Uncomment these lines for synthesis
    */ 
   bufferDriver buf1 ( .in( d_out1 ), .out( dataOut1 ) );
   bufferDriver buf2 ( .in( d_out2 ), .out( dataOut2 ) );
/*    */
   
endmodule
   
