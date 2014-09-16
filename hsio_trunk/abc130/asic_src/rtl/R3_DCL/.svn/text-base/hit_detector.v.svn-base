
`timescale 1ns/10ps
module hit_detector(
	input  [127:0] data_i,
	output [127:0] data_o);

	assign data_o[127] = data_i[127];

	genvar i;

	generate
  		for (i=126; i >= 0 ; i=i-1) begin : comb
     			assign data_o[i] = ~data_i[i+1] & data_i[i];
  		end
	endgenerate
endmodule
