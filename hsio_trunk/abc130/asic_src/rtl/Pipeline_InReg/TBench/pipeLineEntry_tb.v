`timescale 1ns / 1ps


module pipeLineEntry_tb;

//Width of the pipeline may be 256 or 264 bits
parameter pipelineWidth = 255;

	// Inputs
	reg [pipelineWidth:0] stripData;
	reg [pipelineWidth:0] maskBits;
	reg [7:0] BCID;
	reg BCclk;
	reg hrdrstb;
	reg [1:0] mode;
	reg [5:0] counter;
	integer pipeLineOut,pipeLine1;

	// Outputs
	wire [pipelineWidth:0] pipeLine;
	wire [pipelineWidth:0] diagnostic;
	

	// Instantiate the Unit Under Test (UUT)
	pipeLineEntry uut (
		.stripData(stripData), 
		.maskBits(maskBits), 
		.BCID(BCID), 
		.BCclk(BCclk), 
		.hrdrstb(hrdrstb), 
		.mode(mode), 
		.pipeLine(pipeLine), 
		.diagnostic(diagnostic)
		);

	initial begin
		// Initialize Inputs these are random values
		stripData = 256'h777777777777733333333333333555555555555555;
		maskBits  = 256'h0000000000000000000fffffffffffffffffffffff;
		BCID = 8'd5;
		BCclk = 0;
		hrdrstb = 1'b1;
		mode = 2'b00;
		// counter is used to change the mode every 16 clock cycles
		counter = 6'b000000;
		
      pipeLineOut = $fopen ("pipelineInputAndOutput.txt","w");
      //pipeLine1 = $fopen("pipelinestream.txt","w");
      
		// Wait 100 ns for global reset to finish
		//#100;
		repeat(128)
		begin
		#12.5 BCclk <= ~BCclk;
		end
		// Add stimulus here
	end
	
	always @ (posedge BCclk)
	begin
	counter <= counter + 1'b1;
	stripData <= ~stripData;// stripData is neagted every clock cycle
  
   $fstrobe(pipeLineOut,"strip_data-\t%b;\nmaskBits-\t%b;\npipeline-\t%b;\nmode-\t%b;\n\n",stripData,maskBits,pipeLine,mode);
   //$fstrobe(pipeLine1, "%b%b%b%b",stripData,maskBits,mode,pipeLine);
	end
	
	always @ (counter[4])
	begin
	// this negates maskBits every 16 clock cycles. 
	 
	maskBits <= ~ maskBits;
	if (counter < 5)//this statement is to ensure that the mode is 00
			//atleast once
	mode = 2'b00;
	else
	mode <= mode + 1'b1;
	end
endmodule

