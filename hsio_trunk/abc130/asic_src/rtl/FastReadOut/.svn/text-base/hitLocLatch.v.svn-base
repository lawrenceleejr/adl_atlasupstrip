`timescale 1ns/1ps

///////////////////////////////////////////////////////////////////////////////
// Code by :  Vinata Koppal from Upenn
// Date:   1/19/2012 
// Module Name:    hitLocLatch.v
// Description: Latching the hit location at the negative edge
//
//////////////////////////////////////////////////////////////////////////////////

module hitLocLatch(hitLocation,BCclk,DFFreset,latchedHitLocation);
     
   input [31:0] hitLocation;
   input        BCclk;
   input 	DFFreset;
   output [31:0]latchedHitLocation;
   reg [31:0] 	negLatHitLocA,negLatHitLocB;
   reg          DFFd,DFFq;
   
            
  assign latchedHitLocation = DFFq ? negLatHitLocA:negLatHitLocB ;
         

   always @ (negedge BCclk or posedge DFFreset)
     begin
	if (DFFreset)
	  begin
	     DFFq = 1'b0;
	     negLatHitLocA = 32'hFFFFFFFF;
	     negLatHitLocB = 32'hFFFFFFFF;
	     DFFd = 1'b0;
	  end
	else
	  begin
	     DFFq = DFFd;
	     DFFd = ~DFFq;
	     if (DFFq == 1'b1)
	       begin
		  negLatHitLocA = hitLocation;
	       end
	     else
	       begin
		  negLatHitLocB =  hitLocation;
	       end
	  end // else: !if(DFFreset)
	  
     end // always @ (negedge BCclk or negedge DFFreset)
   
	
      
      
    
endmodule // hitLocLatch


 
