
`timescale 1ns/10ps
module reg_128_1(
	input CLK,
	input RST,
	input WR,
	input [127:0] data_i,
	output reg [127:0] data_o);

always @(posedge CLK)
begin
	if (!RST) data_o <= 0;
	else if (WR) data_o <= data_i;
end

endmodule
