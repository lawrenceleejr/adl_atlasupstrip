
`timescale 1ns/10ps

module state_machine(
	input  CLK,
	input  RST,
	input  EN,
	input  NO_HITS,
	input  PCKT_OVER_FLOW,
	input Vn,
	input fifo_full,
	input NO_0_1,
	output WR1,
	output WR2,
	output PCKT_RDY,
	output reg CLSTR_RDY,
	output PCKT_RST,
	output busy,
  output wtdg_rstrt,
	output NO_0_1_o,
	output reg SEG_ID);

	reg [3:0] CS,NS;
  reg CLSTR_RDY_q1;
  wire CLSTR_RDY_q;
	parameter s_idle       = 4'b0000,
	    s_pckt_rst   = 4'b0001,
		  s_pckt_rst_empty   = 4'b1110,
		  s_NO_0_1 = 4'b0011,
		  s_wr1        = 4'b1001,
		  s_wr2        = 4'b1100,
		  s_wait       = 4'b0101,
		  s_nxt_seg    = 4'b1101,
		  s_pckt_rdy   = 4'b1000;



	always@(posedge CLK)
	begin
		if (!RST) CS <= s_idle;
		else CS <= NS;
	end

	always@(posedge CLK)
	begin
		if (!RST) SEG_ID = 1'b0;
		else if (CS == s_idle) SEG_ID = 1'b0;
		else if (CS == s_nxt_seg) SEG_ID = 1'b1;
	end

	always@(CS,EN,PCKT_OVER_FLOW,NO_HITS,fifo_full,NO_0_1,SEG_ID)
	begin
		case (CS)
			s_idle: begin
				if (EN) NS <= s_pckt_rst;
				else if (NO_0_1) NS <= s_pckt_rst_empty;
				else NS <= s_idle;
			end
			s_pckt_rst_empty: begin
			  NS <= s_NO_0_1;
			end
			s_NO_0_1: begin
			  NS <= s_pckt_rdy;
			end
			s_pckt_rst: begin
			  NS <= s_wr1;
			end
			s_wr1: begin
				NS <= s_wait;
			end
			s_wr2: begin
				NS <= s_wait;
			end
			s_wait: begin
			  if (fifo_full == 0)  begin
  				  if (PCKT_OVER_FLOW) NS <= s_pckt_rdy;
  				  else if (NO_HITS) begin
  					 if (SEG_ID) NS <= s_pckt_rdy;
  					 else NS <= s_nxt_seg;
  				  end 
  				  else NS <= s_wr2;
				end else NS <= s_wait;
			end
			s_nxt_seg: begin
				NS <= s_wr1;
			end
			s_pckt_rdy: begin
				NS <= s_idle;
			end
			default: NS <= s_idle;
		endcase

	end
	
	always @(posedge CLK)
	begin
	  if (!RST) CLSTR_RDY <= 0;
	  else begin
	    if ({CLSTR_RDY_q1,CLSTR_RDY_q} == 2'b01) CLSTR_RDY <= 1;
	    else CLSTR_RDY <= 0;
	    CLSTR_RDY_q1 <= CLSTR_RDY_q;
	  end
	end
	      


	assign WR1 = (CS==s_wr1)?1'b1:1'b0;
	assign WR2 = (CS==s_wr2)?1'b1:1'b0;
	assign CLSTR_RDY_q = ((!Vn) && (CS == s_wait) && (NO_HITS==0))?1'b1:1'b0;
	assign PCKT_RDY = (CS==s_pckt_rdy)?1'b1:1'b0;
	assign PCKT_RST = ((CS==s_pckt_rst) || (CS==s_pckt_rst_empty))?1'b1:1'b0;
	assign NO_0_1_o = (CS==s_NO_0_1)?1'b1:1'b0;
	assign wtdg_rstrt = ((CS==s_idle) || (fifo_full==1))?1'b1:1'b0;
	assign busy = (CS==s_idle)?1'b0:1'b1;
endmodule
