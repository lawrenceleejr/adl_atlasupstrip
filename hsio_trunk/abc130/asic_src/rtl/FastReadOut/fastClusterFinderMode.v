
`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////
//Code by : Vinata Koppal, Madhura Kamat Upenn
// Date: 08/27/2012
// Description: fastClusterFinder - fastReadOut, hitLocLatch and serializer put 
// together generates the hit location and sends the it serially .     ///
/////////////////////////////////////////////////////////////////////////////

module fastClusterFinderMode(inputFrntEnd, BCclk, FSclk,reset, interestingCountReset, control, dataOutL16SB, dataOutM16SB,interestingCount, serializingL, serializingM);
   
   input [255:0] inputFrntEnd;
   input 	 BCclk;
   input 	 FSclk;
   input 	 reset;
   input 	 interestingCountReset;
   input [1:0] 	 control;
   output 	 dataOutL16SB;
   output	 dataOutM16SB;
   output [31:0] interestingCount;
   output 	 serializingL, serializingM;
   
 
   wire count3CL, count3CH;
   wire [31:0] 	 hitLocation;
   wire [31:0] 	 latchedHitLocation;
 
   
   integer 	 i;
   
   reg   [127:0] BCdataLowerbits,BCdataHigherbits;
   reg 	 [15:0]	 dataInL, dataInM;
   reg 	 [15:0]	 dataInLreg, dataInMreg;
 //reg 	 [15:0]	 dataInL16SB, dataInM16SB;
   reg 	[127:0]	 BCdataLower, BCdataHigher;
   reg 		 DFFreset;
   reg [15:0] 	 interestingCountreg1, interestingCountreg2;
		 
   assign interestingCount = {interestingCountreg2,interestingCountreg1};
  
   
//Generate 32 bit hit location
   fastReadOut uut      (.BCclk(BCclk),.BCdataLowerbits(BCdataLowerbits),

			 .BCdataHigherbits(BCdataHigherbits),
//			 .interestingCountReset(interestingCountReset),
			 .hitLocation(hitLocation),
			 .count3CL(count3CL),
			 .count3CH(count3CH));
   
//			 .interestingCountL(interestingCountL),
//			 .interestingCountH(interestingCountH));

      

// Latching the hit location at the negative edge
   hitLocLatch hitloclat (.hitLocation(hitLocation),
			  .BCclk(BCclk),
			  .DFFreset(DFFreset),
			  .latchedHitLocation(latchedHitLocation));

   
   
// pump out the lower 16 bits of address serially
   serializerFC serializerA (.dataIn(dataInM),
			     .reset(reset),
			     .FSclk(FSclk),
			     .dataOut(dataOutM16SB),
			     .serializing(serializingM),
			     .control(control));
   

// pump out the upper 16 bits of address serially
   serializerFC serializerB (.dataIn(dataInL),
			     .reset(reset),
			     .FSclk(FSclk),
			     .dataOut(dataOutL16SB),
			     .serializing(serializingL),
			     .control(control));


  //  always @ (control or inputFrntEnd /*or latchedHitLocation*/)
   always @ (posedge BCclk)
     begin
	
	if (inputFrntEnd != 16'h0)
	  begin
	     for(i = 0; i < 128; i = i+1)
	       begin
		  BCdataLowerbits[i]  <= inputFrntEnd[2*i];
		  BCdataHigherbits[i] <= inputFrntEnd[(2*i) + 1];
		  
	       end
	  end
	else
	  begin
	     BCdataLowerbits  <= 16'h0;
	     BCdataHigherbits <= 16'h0;
	  end // else: !if(inputFrntEnd != 16'h0)
	
	
	
	if (control == 2'b00)
	  begin
	     DFFreset <= 1'b1;
	     dataInL  <= 16'h0000;
	     dataInM  <= 16'h0000;
	  end
	else if (control == 2'b01)
	  begin
	     dataInL  <= 16'h0000;
	     dataInM  <= 16'h00FF;
	     DFFreset <= 1'b1;
	  end
	else if (control == 2'b10)
	  begin
	     dataInL  <= 16'h00FF;
	     dataInM  <= 16'h0000;
	     DFFreset <= 1'b1;
	  end
	
	else if (control == 2'b11)
	  begin
	     dataInL  <= latchedHitLocation[15:0];
	     dataInM  <= latchedHitLocation[31:16];
	     DFFreset <= 1'b0;
	  end
     end // always @ (posedge BCclk)
   
   
   


always @ (negedge BCclk or negedge interestingCountReset)
  begin
	     if (~interestingCountReset)
	       begin
		  interestingCountreg1 <= 16'h0;
		  interestingCountreg2 <= 16'h0;
	       end
	
	     
	     else
	       if(control == 2'b11)
		 begin
		    if (count3CL==1'b1)
		      begin
			 interestingCountreg1 <= interestingCountreg1 + 16'h1;
		      end
		    
		    if (count3CH==1'b1)
		      begin
		    interestingCountreg2 <= interestingCountreg2 + 16'h1;
		      end
		 end // else: !if(~interestingCountReset)
	       else
		 begin
		    interestingCountreg1 <= 16'h0;
		    interestingCountreg2 <= 16'h0;
		 end
	     
	  end // always @ (negedge BCclk or negedge interestingCountReset)
   
   
   
   
endmodule // CompleteSystem


