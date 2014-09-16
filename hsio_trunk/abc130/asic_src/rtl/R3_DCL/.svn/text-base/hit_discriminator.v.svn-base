
`timescale 1ns/10ps
/////////////////////////////////////
// data_i    V  P                  //
//  1000     0  0                  //
//  1100     0  0                  //
//  1110     0  1                  // 
//  1111     1  0                  //
/////////////////////////////////////
module hit_discriminator(
	input  [3:0] data_i,
	output Vn,
	output P);

	
	assign Vn = data_i[2] & data_i[1] & data_i[0];  //V
	assign P = data_i[2] & data_i[1] & ~data_i[0]; //P
endmodule
