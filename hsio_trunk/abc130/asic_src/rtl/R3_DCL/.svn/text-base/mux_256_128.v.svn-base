
`timescale 1ns/10ps
module mux_256_128(

	input [271:0] data_i,

	input sel,
	output [15:0] L0_BC_ID,
	
	output [127:0] data_o);

assign L0_BC_ID = data_i[271:256];

genvar i;

 generate
  for (i=0; i < 128; i=i+1) begin : mux
      assign data_o[127 - i] = (sel)?data_i[1+(2*i)]:data_i[(2*i)]; //odd (sel=0) even (sel=1)
  end
 endgenerate


endmodule
