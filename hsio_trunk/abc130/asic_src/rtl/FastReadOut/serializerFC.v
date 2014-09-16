`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Code by: Amogh Halgeri,Vinata Koppal, Madhura Kamat  Upenn
// Date: 09/01/2012
// Description: Accepts a sixteen bit data and pumps it out serially. Adding lockout (Madhura)
//////////////////////////////////////////////////////////////////////////////////

module serializerFC(dataIn, reset, FSclk, dataOut, serializing, control);

   input  [15:0]      dataIn;
   input   	      FSclk;
   input   	      reset;
   input [1:0] 	      control;
   
   output 	      dataOut; 
   output 	      serializing;
   
   reg 		      serializerBusy;
   reg [15:0] 	      dataBuffer;
   reg [4:0] 	      counter; 
   reg [15:0] 	      outputReg;
   

   

   assign dataOut = outputReg[15];//LSB of the output given out
   assign serializing = serializerBusy;
   

  always @ (posedge FSclk)
     begin
	
	     if (reset)
	       begin
		  serializerBusy <= 1'b0;
		  counter <= 5'd0;
		  dataBuffer <= 0;
	       end
	
	     else
	       begin
	       	if (control == 2'b11)
		begin
			outputReg[15:1] <= outputReg[14:0];
			outputReg[0] <= 1'b1;
			
			if (serializerBusy == 1'b0)// && dataIn != 16'hffff)
			begin
				outputReg <= dataIn;
				serializerBusy <= 1'b1;
				counter <= counter + 1'b1;
			end
			
//			else if (serializerBusy == 1'b0 && dataIn == 16'hffff)
	//			outputReg <= 16'hffff;
				
			if (serializerBusy == 1'b1)
			begin
				counter <= counter + 1'b1;
			end
			
			if (counter == 5'd15)
			begin
				counter <= 0;
				serializerBusy <= 0;
				//outputReg <= 0;
			end
		 end// control == 2'b11
		 
		 else if (control != 2'b11)
		 begin
		 	outputReg <= 0;
		 end
	    end // else
	end//always
		
endmodule // serializer

