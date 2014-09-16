
`timescale 1ns/10ps
module clstr_adrs_adder(
	input [6:0] clstr_pos,
	input head_pos,
	output [6:0] clstr_adrs);

assign clstr_adrs = ~(clstr_pos) + head_pos; 
	

endmodule
