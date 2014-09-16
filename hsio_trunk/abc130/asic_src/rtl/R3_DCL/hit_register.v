
`timescale 1ns/10ps
module hit_register(
	input CLK,
	input RST,
	input WR1,
	input WR2,
	input [127:0] data_i1,
	input [127:0] data_i2,
	output reg [127:0] data_o);

always @(posedge CLK)
begin
	if (!RST) data_o <= 0;
	else if (WR1) data_o <= data_i1;
	else if (WR2) data_o <= data_i2;
end

endmodule
