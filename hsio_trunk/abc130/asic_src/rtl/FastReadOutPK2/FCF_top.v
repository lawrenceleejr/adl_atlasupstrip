`timescale 1ns / 1ps

/*
 * Fast Cluster Finder
 * 
 * Nandor Dressnand,Sananda Ghosh, Amogh Halgeri, 
 * Paul T. Keener, Mitch Newcomer, Vinata Koppal
 * 
 * University of Pennsylvania
 * 
 * April 2013
 */

module FCF_top( inputFrntEnd, BCclk, fs_clk, control, reset_n,
                data_out1, data_out2 );
   
   
   input [255:0] inputFrntEnd;
   input         BCclk;
   input         fs_clk;
   input [1:0]   control;
   input         reset_n;

   output        data_out1;
   output        data_out2;

   wire 	 enable;
   wire [31:0] 	 to_serial;
   wire 	 dataV;
   

   fastClusterFinderMode fCFM1( .inputFrntEnd( inputFrntEnd ), .BCclk( BCclk ),
			       .control( control ), .reset_n( reset_n),
			       .module_en( enable ), .to_serial( to_serial ),
			       .dataV( dataV ) );

   BigSerialize bs1 ( .dataIn( to_serial ), .dataV( dataV ), .enable( enable ),
		      .out_clk( fs_clk ), .reset_n( reset_n ), 
		      .dataOut1( data_out1 ), .dataOut2( data_out2 ) );

endmodule // top_level

