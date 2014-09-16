`timescale 1ns/1ps

module regF(CK, WR, D, Q);

output  [`RO_ADDR_WIDTH-1:0] Q;
input   [`RO_ADDR_WIDTH-1:0] D;
input                          CK, WR;

reg     [`RO_ADDR_WIDTH-1:0] Q;

always @ (posedge CK) begin
   if ( WR ) Q <= D;
   end

endmodule
