`timescale 1ns / 1ps

/*
 * FCserializerHalf
 * 
 * Serialize the 16-bit dataIn input word with FSclk onto dataOut.
 * 
 * Nandor Dressnandt, Amogh Halgeri, Paul T. Keener, Mitch Newcomer
 * 
 * University of Pennsylvania
 * 
 * May 2013
 */
module FCserializerHalf( dataIn, dataV, FSclk, out_clk, reset_n, dataOut );
   input [15:0] dataIn;      // parallel data in
   input        dataV;       // Data Valid from latch
   input        FSclk;       // Fast (40 - 320 MHz) clock
   input        out_clk;     // Fast (80 - 640 MHz) clock for output bitstream
   input 	reset_n;

   output       dataOut;

   reg [15:0] 	Dlatch;
   reg [7:0] 	DshiftOdd;
   reg [7:0] 	DshiftEven;
   

   reg [7:0] 	counter;
   reg 		serBusy;

   wire 	data640;
   wire 	dataOutOdd;
   wire 	dataOutEven;
   
 	
   parameter BUSY = 1'b1;
   parameter IDLE = 1'b0;
   
/* 
 * Output of serializer
 */   
   assign dataOutOdd  = DshiftOdd[7];
   assign dataOutEven = DshiftEven[7];

   MUX21BAL_J outmux ( .D1( dataOutOdd ), .D0( dataOutEven ), .SD( FSclk ),


		    .Z( data640 ),.VDD(),.GND(),.NW(),.SX() );
 //  INVERTBAL_E ib1 ( .A( out_clk ), .Z( out_clk_n ) );


   INVERTBAL_E ib1 ( .A( out_clk ), .Z( d1 ),.VDD(),.GND(),.NW(),.SX() );
   DELAY4_C dl1 ( .A( d1 ), .Z( d2 ),.VDD(),.GND(),.NW(),.SX() );
   DELAY4_C dl2 ( .A( d2 ), .Z( d3 ),.VDD(),.GND(),.NW(),.SX() );
   DELAY4_C dl3 ( .A( d3 ), .Z( d4 ),.VDD(),.GND(),.NW(),.SX() );
   DELAY4_C dl4 ( .A( d4 ), .Z( out_clk_n ),.VDD(),.GND(),.NW(),.SX() );
//
//  
     
   DFFR_E dff1 ( .D( data640 ), .CLK( out_clk_n ), .RN( reset_n ),
		 .Q( dataOut ),.QBAR(), .VDD(),.GND(),.NW(),.SX() );
   
   

/*
 * Next state logic
 */

   reg 		next_state;
   

   always @ ( serBusy or dataV or counter[7] or reset_n ) 
     begin
	if ( ~reset_n )
	  next_state <= IDLE;
	else
	  begin: FSM_COMBO
	     next_state <= IDLE;
	
	     case ( serBusy )
	       BUSY:
		 begin
		    if ( counter[7] && !dataV )
		      next_state <= IDLE;
		    else
		      next_state <= BUSY;
		 end
	       IDLE:
		 begin
		    if ( dataV )
		      next_state <= BUSY;
		    else
		      next_state <= IDLE;
		 end
	     endcase // case ( serBusy )
	  end // block: FSM_COMBO
     end // always @ ( serBusy or dataV or counter[7] or negedge( reset_n ) )
   
   

/*
 * Transistion to next state
 */

   always @ ( posedge FSclk or negedge reset_n )
     begin
	if ( !reset_n )
	  serBusy <= IDLE;
	else
	  serBusy <= next_state;
     end


/*
 * Outputs
 */	      
   
   always @ ( posedge FSclk or negedge reset_n )
     begin
	if ( !reset_n )
	  begin
	     Dlatch <= 16'hFFFF;
	     
	     DshiftOdd  <= 8'h00;
	     DshiftEven <= 8'h00;
	     counter <= 8'h00;
	  end // if ( reset_n )
	else
	  begin 
	     case ( serBusy )
	       BUSY: 
		 begin
		    if ( counter[7] )
		      begin
			 counter <= 8'h01;
			 DshiftOdd[7:0] <= {Dlatch[15], Dlatch[13], Dlatch[11],
					    Dlatch[9],  Dlatch[7],  Dlatch[5],
					    Dlatch[3],  Dlatch[1] };
			 DshiftEven[7:0]<= {Dlatch[14], Dlatch[12], Dlatch[10],
					    Dlatch[8],  Dlatch[6],  Dlatch[4],
					    Dlatch[2],  Dlatch[0] };
			 
		      end
		    else
		      begin
			 counter[7:0]   <= {counter[6:0], 1'b0};
			 DshiftOdd[7:0]  <= {DshiftOdd[6:0], 1'b0};
			 DshiftEven[7:0] <= {DshiftEven[6:0], 1'b0};
		      end
		 end // case: BUSY
	       IDLE:
		 if ( dataV )
		   begin
		      counter <= 8'h01;
			 DshiftOdd[7:0] <= {Dlatch[15], Dlatch[13], Dlatch[11],
					    Dlatch[9],  Dlatch[7],  Dlatch[5],
					    Dlatch[3],  Dlatch[1] };
			 DshiftEven[7:0]<= {Dlatch[14], Dlatch[12], Dlatch[10],
					    Dlatch[8],  Dlatch[6],  Dlatch[4],
					    Dlatch[2],  Dlatch[0] };
		   end
	     endcase // case ( serBusy )
   
	
	     Dlatch[0] <= dataV ? Dlatch[0] : dataIn[0];
	     Dlatch[1] <= dataV ? Dlatch[1] : dataIn[1];
	     Dlatch[2] <= dataV ? Dlatch[2] : dataIn[2];
	     Dlatch[3] <= dataV ? Dlatch[3] : dataIn[3];
	     Dlatch[4] <= dataV ? Dlatch[4] : dataIn[4];
	
	     Dlatch[5] <= dataV ? Dlatch[5] : dataIn[5];
	     Dlatch[6] <= dataV ? Dlatch[6] : dataIn[6];
	     Dlatch[7] <= dataV ? Dlatch[7] : dataIn[7];
	     Dlatch[8] <= dataV ? Dlatch[8] : dataIn[8];
	     Dlatch[9] <= dataV ? Dlatch[9] : dataIn[9];
	
	     Dlatch[10] <= dataV ? Dlatch[10] : dataIn[10];
	     Dlatch[11] <= dataV ? Dlatch[11] : dataIn[11];
	     Dlatch[12] <= dataV ? Dlatch[12] : dataIn[12];
	     Dlatch[13] <= dataV ? Dlatch[13] : dataIn[13];
	     Dlatch[14] <= dataV ? Dlatch[14] : dataIn[14];
	     Dlatch[15] <= dataV ? Dlatch[15] : dataIn[15];
	  end // else: !if( !reset_n )
     end // always @ ( posedge FSclk )
   
	
endmodule // serialize



		 
		 
