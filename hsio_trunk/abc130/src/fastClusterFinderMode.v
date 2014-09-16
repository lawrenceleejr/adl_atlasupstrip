`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////
//Code by : Vinata Koppal, Madhura Kamat Upenn
// Date: 08/27/2012
// Description: fastClusterFinder - fastReadOut, hitLocLatch and serializer put 
// together generates the hit location and sends the it serially .     ///
/////////////////////////////////////////////////////////////////////////////

module fastClusterFinderMode(inputFrntEnd, BCclk, control, reset_n, module_en, 
			     to_serial, dataV );
      
   
   input [255:0] inputFrntEnd;
   input 	 BCclk;
   //input 	 interestingCountReset;
   input [1:0] 	 control;
   input 	 reset_n;

   output 	 module_en;
   output [31:0] to_serial;
   output 	 dataV;
	 

   
  // wire count3CL, count3CH;
   wire serialOutL, serialOutM;
   wire [31:0] 	 hitLocation;

   reg [255:0] 	 data_in;
   
   reg [31:0] 	 to_serial;
   wire [1:0] 	 module_mode;

   reg 		 clk_en;

   wire 	 clk;
   wire 	 gclk;
   
   
   integer 	 i;
   
   reg   [127:0] BCdataLowerbits,BCdataHigherbits;
   //reg 	 [15:0]	 dataInL, dataInM;
   reg 	 [15:0]	 dataInLreg, dataInMreg;
 //reg 	 [15:0]	 dataInL16SB, dataInM16SB;
   reg 	[127:0]	 BCdataLower, BCdataHigher;
   
   wire [31:0] latchedHitLocation;
   //reg 		 DFFreset;
   //reg [15:0] 	 interestingCountreg1, interestingCountreg2;
	wire [15:0]	 dataInL, dataInM;
   wire DFFreset;
   //assign interestingCount = {interestingCountreg2,interestingCountreg1};

   
   parameter ZERO = 2'b00;
   parameter LOW  = 2'b01;
   parameter HIGH = 2'b10;
   parameter NORM = 2'b11;

   /*
    * Comment out for synthesis
    *
   assign    clk = BCclk;
    */
   
   /*
    * Uncomment for synthesis
    */
   // *** i_bufferDriver ibuf( .in( BCclk ), .out( clk ) );
	assign clk = BCclk;
/*    */

   
   module_control mc1 ( .control( control ), .clk( clk ), .reset_n( reset_n ),
			.module_en( module_en ), .module_mode( module_mode ) );

   // *** clock_gate cg1 ( .enable( module_en ), .clk_in( clk ), .clk_out( gclk ) );
   assign gclk = clk;

   
		
    
   always @ (posedge gclk or negedge reset_n)
     begin
	if ( !reset_n )
	  begin
	       data_in <= 256'b0;
	  end
	else
	  begin
	     if ( !module_en )
	       data_in <= 256'b0;
	     else
	       data_in <= inputFrntEnd;
	  end
     end // always @ (posedge gclk or negedge reset_n)
   
   
   FcF_slow fs1 (.inputFrntEnd( data_in ), .BCclk( gclk ), .reset_n( reset_n ),
		.dataV( dataV ), .latchedHitLocation( latchedHitLocation ) );


   always @ ( posedge gclk or negedge reset_n )
     begin
	if ( !reset_n )
	  to_serial <= 32'h0000_0000;
	else
          case ( module_mode )
            ZERO: 
              begin
		 to_serial <= 32'h0000_0000;
              end
            LOW:  
              begin
		 to_serial <= 32'h0000_00ff;
              end
            HIGH:
              begin
		 to_serial <= 32'h00ff_0000;
              end
            NORM:
              begin
		 to_serial <= latchedHitLocation;
              end
          endcase // case ( control )
     end

   
   
   
endmodule // CompleteSystem


