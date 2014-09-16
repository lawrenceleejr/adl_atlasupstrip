`timescale 1ns/1ps

module RAM_80x8 (BC, FWriteStrob,
		FWriteAddress,
		DataIn,
		FReadStrob,
		FReadAddress,
		Dout );
input BC, FWriteStrob, FReadStrob;
input[`FIFO_ADDR_WIDTH-1:0] FWriteAddress, FReadAddress;
input[`RO_ADDR_WIDTH-1:0] DataIn;
output[`RO_ADDR_WIDTH-1:0] Dout;

//parameter total = 85;

wire [(`RO_FIFO_max_depth*8)-1:0] data_bus;
//wire [(`RO_FIFO_max_depth-1):0] wea; � � � // write-enables
//wire [(`RO_FIFO_max_depth-1):0] web; � � � // write-enables
wire [(`RO_FIFO_max_depth-1):0] we;

assign  we = (2 ** FWriteAddress) & {85{FWriteStrob}}; 
//assign  web = {85{FWriteStrob}};  
//assign  we = wea & web;
assign  Dout = data_bus[(8*FReadAddress)+:8];

genvar nreg;
generate
for (nreg = 0; nreg<`RO_FIFO_max_depth; nreg=nreg+1)
begin: ram_gen
		regF ramA(.CK(BC),
		.WR(we[nreg]),
		.D(DataIn),
		.Q(data_bus[(8*nreg)+7:8*nreg])
		);
end
		endgenerate
		
endmodule
