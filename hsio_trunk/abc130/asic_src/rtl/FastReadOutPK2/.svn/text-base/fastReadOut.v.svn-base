`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
//  
//  
// Code by : Sananda Ghosh, Amogh Halgeri, Vinata Koppal from Upenn
//
// Date:   1/25/2012 
// Module Name:    fastReadout.v
//  
// Description: The 256 bit interleaved data from the two 128 bits is analyzed and the
// 		location of hit cluster is given out in 32 bit output.
//
//  
//
//////////////////////////////////////////////////////////////////////////////////

//module fastReadOut(BCdataLowerbits,BCdataHigherbits,interestingCountReset, hitLocation, count3CL, count3CH, interestingCountL, interestingCountH);
module fastReadOut(BCclk, BCdataLowerbits,BCdataHigherbits, hitLocation);//, count3CL, count3CH);
   input BCclk;
   
   input [127:0] BCdataLowerbits, BCdataHigherbits;
//   input 	 interestingCountReset;
  
   output [31:0] hitLocation;

   //output  count3CL, count3CH;
//   output [15:0] interestingCountL, interestingCountH;

// instantiating twice , once for bits 0-127 and second time for bits 128-255 
   
   remove3hitcluster_128bit lowerStrip (.BCclk(BCclk),
					.BCdata(BCdataLowerbits),
					//.interestingCountReset(interestingCountReset),
					.totaladdr(hitLocation[15:0]));//,
//					.count3cluster(count3CL));
   
   //	.interestingCount(interestingCountL));
					

   remove3hitcluster_128bit upperStrip (.BCclk(BCclk),
					.BCdata(BCdataHigherbits),
					//	.interestingCountReset(interestingCountReset),
					.totaladdr(hitLocation[31:16]));//,
					//.count3cluster(count3CH));
   
						//				.interestingCount(interestingCountH));

 
endmodule // fastReadOut


 
