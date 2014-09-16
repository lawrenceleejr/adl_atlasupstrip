`timescale 1n / 1ps

module placeBlackBoxes( dataIn, BCclk, control, reset_n, fs_clk,
			dataOut1, dataOut2 );
   
   input [255:0] dataIn;
   input 	BCclk;
   input [1:0] control;
   input reset_n;
   input fs_clk;
   
   output dataOut1;
   output dataOut2;

   wire   n1, n2;

   wire VDD,GND;

   // instantiate FCF_top //
  
//module fastClusterFinderMode(inputFrntEnd, BCclk, control, reset_n, module_en, to_serial, dataV );
//module BigSerialize( dataIn, dataV, enable, FSclk, reset_n, dataOut1, dataOut2 );
////module FCF_top( inputFrntEnd, BCclk, fs_clk, control, reset_n, data_out1, data_out2 );

FCF_top dev1 ( .inputFrntEnd(dataIn[255:0]),
	   .BCclk(BCclk),
	   .fs_clk(fs_clk),
	   .control(control), 
	   .reset_n(reset_n),
	   .data_out1(n1), 
	   .data_out2(n2),
           .VDD(VDD),
	   .GND(GND) );
 

// instantiate buffers //
bufferDriver driver1 (.in(n1),.out(dataOut1));
bufferDriver driver2 (.in(n2),.out(dataOut2));

   
endmodule // place_black_boxes

