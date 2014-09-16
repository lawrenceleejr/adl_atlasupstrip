`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
//  
//  
// Code by : Sananda Ghosh, Amogh Halgeri, Vinata Koppal from Upenn
//
// Date:   01/25/2012 
// Module Name:    remove3hitcluster_128bit.v
//  
// Description: The 128 bit strip data is analyzed and more than two consecutive high
//		bits are replaced by zeros and trial128bit.v is called to get the address
//		of the location.
//
//////////////////////////////////////////////////////////////////////////////////

//module remove3hitcluster_128bit(BCdata,interestingCountReset,totaladdr,count3cluster,interestingCount);
module remove3hitcluster_128bit(BCclk, BCdata,totaladdr,count3cluster);
   input BCclk; 
   //input enable;
   input wire [127:0] BCdata;
   //   input 	      interestingCountReset;
   output wire [15:0] totaladdr;
   output 	      count3cluster;
   reg 		      count;
   
   //   output [15:0]      interestingCount;
   
   //wire [127:0] data;
   
   wire [7:0] 	      first, second, third;
   
   integer 	      i;
   reg [127:0] 	      single, double;
   //Implentation of the double hit and single hit masks on the BC data for the 
   //data at the edges of the bank before starting with a for loop 
   //to take care of the remaining data in the middle. These masks would require inverters 
   //and three or four input AND gates in hardware.
   
   
   
   assign count3cluster = count;
   
   always @(BCdata)
     begin
	// generates single and double registers which hold all the single and double hits
	
	single[0] <= (BCdata[0] & !BCdata[1])? 1'b1 : 1'b0;
	single[1]<=(!BCdata[0] & BCdata[1] & !BCdata[2])? 1'b1 : 1'b0;
	single[127]<=(!BCdata[126] & BCdata[127])? 1'b1 : 1'b0;
	single[126]<=(!BCdata[125] & BCdata[126] & !BCdata[127])? 1'b1 : 1'b0;
	double[0] <= (BCdata[0] & BCdata[1] & !BCdata[2])? 1'b1 : 1'b0;
	double[1] <= (BCdata[0] & BCdata[1] & !BCdata[2])? 1'b1 : 1'b0;
	double[1]<=(!BCdata[0] & BCdata[1] & BCdata[2] & !BCdata[3])? 1'b1 : 1'b0;
	
	double[126] <= (!BCdata[125] & BCdata[126] & BCdata[127])? 1'b1 : 1'b0;
	double[126] <= (!BCdata[124] & BCdata[125] & BCdata[126] & !BCdata[127])?1'b1:1'b0;
	double[127] <= (!BCdata[125] & BCdata[126] & BCdata[127])? 1'b1 : 1'b0;
	
	
	for (i=2; i<126; i=i+1)
	  begin 
	     single[i]<=(!BCdata[i-1] & BCdata[i] & !BCdata[i+1]) ? 1'b1 : 1'b0;
	     double[i] <= 	((!BCdata[i-1] & BCdata[i] & BCdata[i+1] & !BCdata[i+2])|
				 (!BCdata[i-2] & BCdata[i-1] & BCdata[i] & !BCdata[i+1])) ? 1'b1 : 1'b0;
	  end//for
     end//always
   
   // OR the results obtained after using the double and single hit masks to discard all three or more hit clusters
   
   //assign data = single | double;
   // call trial128bit.v to generate the address o the hit location
   trial128bit t1 (.single(single),
		   .double(double),
		   //.interestingCountReset(interestingCountReset),
		   .totaladdr(totaladdr),
		   .first(first), 
		   .second(second), 
		   .third(third));
   //	.interestingCount(interestingCount));
   
   
   always@(negedge BCclk)
     begin
	if ((third[6:0]==second[6:0])|(third==first)|(first==second))
	  count<= 1'b0;
	else
	  count<=  1'b1;
     end
   
   
endmodule
