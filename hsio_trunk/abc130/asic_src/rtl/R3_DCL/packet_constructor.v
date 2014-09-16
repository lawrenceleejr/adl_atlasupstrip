
`timescale 1ns/10ps
module packet_constructor #(parameter CLSTR_NUM=4)(
	input CLK,
	input RST,
	input CLSTR_RDY,
	input PCKT_RST,
	input SEG_ID,
	input [15:0] L0_BC_ID,
	input [6:0] DATA_I,
	input NO_0_1,
	output [50:0] PCKT_O,
	output OVERFLOW);

	reg [50:0] PCKT;
	reg [2:0] pckt_count;
	/////// PCKT ////////
	//L0ID/BCID [50:35]
	//HIT 0     [34:27]
	//HIT 1     [26:19]
	//HIT 2     [18:11]
	//HIT 3     [10:3]
	//No 01     [2]
	//OVERFLOW  [1]
	//NOT_EMPTY [0]
	/////////////////////
	always @ (posedge CLK)
	begin
		if (!RST) begin
			PCKT = 51'd0;
			pckt_count = 0;
		end
		else if (PCKT_RST) begin
			PCKT = 51'd0;
			pckt_count = 0;
			PCKT[50:35] = L0_BC_ID;
		end
		else if (NO_0_1) PCKT[2] = 1'b1;
		else if (CLSTR_RDY) begin
		  PCKT[0] = 1'b1; //set as not empty
			if (pckt_count < CLSTR_NUM) begin
			  case (pckt_count) 
			    0: PCKT[34:27]={SEG_ID,DATA_I};
			    1: PCKT[26:19]={SEG_ID,DATA_I};
			    2: PCKT[18:11]={SEG_ID,DATA_I};
			    3: PCKT[10:3]={SEG_ID,DATA_I};
			  endcase
				PCKT[1] = 1'b0;
			end 
			else if (pckt_count == CLSTR_NUM) PCKT[1] = 1'b1;
			  pckt_count = pckt_count + 1;
		end
	end
	assign PCKT_O = PCKT;
	assign OVERFLOW = PCKT[1];
endmodule
