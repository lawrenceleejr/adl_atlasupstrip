// made on 2012-01-09 18:27:54

`timescale 1ns/1ps

//***
`include "../../abc130/src/veri_globals_P5.v"

 
//`include  "majority_voter.v"
module L1detect_tri( 
			clk,
			Resetb,
			L1DataIn,
			L1detAck,
			L1L0ID
			);



///////////////////////////////////////////////////////////////////// 
/////parameters
parameter R3_IDLE    = 2'h0;
parameter R3_FIELD_1 = 2'h1;
parameter R3_FIELD_2 = 2'h2;
parameter R3_LAST = 2'h3;

///////////////////////////////////////////////////////////////////// 
/////OLD inputs tri
input clk, Resetb, L1DataIn;

///////////////////////////////////////////////////////////////////// 
/////NEW triple wires from the old inputs tri
wire clk_1, Resetb_1, L1DataIn_1;
wire clk_2, Resetb_2, L1DataIn_2;
wire clk_3, Resetb_3, L1DataIn_3;

///////////////////////////////////////////////////////////////////// 
/////assign for the triplicated wires
assign clk_1=clk;
assign clk_2=clk;
assign clk_3=clk;
assign Resetb_1=Resetb;
assign Resetb_2=Resetb;
assign Resetb_3=Resetb;
assign L1DataIn_1=L1DataIn;
assign L1DataIn_2=L1DataIn;
assign L1DataIn_3=L1DataIn;

///////////////////////////////////////////////////////////////////// 
/////NEW OUTPUTS now wires tri
wire L1detAck_o_1, R3detmade_o_1;
wire L1detAck_o_2, R3detmade_o_2;
wire L1detAck_o_3, R3detmade_o_3;

///////////////////////////////////////////////////////////////////// 
/////NEW OUTPUTS BUSES now wires tri
wire  [`RO_ADDR_WIDTH-1:0] L1L0ID_o_1;
wire  [2:0] R3detStateCounter_o_1;
wire  [1:0] R3detState_o_1;
wire  [`RO_ADDR_WIDTH-1:0] R3det_o_1;
wire  [`RO_ADDR_WIDTH-1:0] L1L0ID_o_2;
wire  [2:0] R3detStateCounter_o_2;
wire  [1:0] R3detState_o_2;
wire  [`RO_ADDR_WIDTH-1:0] R3det_o_2;
wire  [`RO_ADDR_WIDTH-1:0] L1L0ID_o_3;
wire  [2:0] R3detStateCounter_o_3;
wire  [1:0] R3detState_o_3;
wire  [`RO_ADDR_WIDTH-1:0] R3det_o_3;

///////////////////////////////////////////////////////////////////// 
/////wire from internal registers tri
wire R3detmade;

///////////////////////////////////////////////////////////////////// 
/////wire buses from internal registers tri
wire [2:0]  R3detStateCounter;
wire [1:0]  R3detState;
wire [`RO_ADDR_WIDTH-1:0]  R3det;

///////////////////////////////////////////////////////////////////// 
/////NEW OUTPUTS BUSES to the outside
output  [`RO_ADDR_WIDTH-1:0] L1L0ID;


///////////////////////////////////////////////////////////////////// 
/////OUTPUTS singles to the outside
output L1detAck;

///////////////////////////////////////////////////////////////////// 
/////triplicated instances
L1detect_internal  L1detect_internal_1( .clk(clk_1), .Resetb(Resetb_1), .L1DataIn(L1DataIn_1), .R3detmade_i(R3detmade), .R3detStateCounter_i(R3detStateCounter), .R3detState_i(R3detState), .L1detAck_o(L1detAck_o_1), .R3detmade_o(R3detmade_o_1), .L1L0ID_o(L1L0ID_o_1), .R3detStateCounter_o(R3detStateCounter_o_1), .R3detState_o(R3detState_o_1), .R3det_o(R3det_o_1));

L1detect_internal  L1detect_internal_2( .clk(clk_2), .Resetb(Resetb_2), .L1DataIn(L1DataIn_2), .R3detmade_i(R3detmade), .R3detStateCounter_i(R3detStateCounter), .R3detState_i(R3detState), .L1detAck_o(L1detAck_o_2), .R3detmade_o(R3detmade_o_2), .L1L0ID_o(L1L0ID_o_2), .R3detStateCounter_o(R3detStateCounter_o_2), .R3detState_o(R3detState_o_2), .R3det_o(R3det_o_2));

L1detect_internal  L1detect_internal_3( .clk(clk_3), .Resetb(Resetb_3), .L1DataIn(L1DataIn_3), .R3detmade_i(R3detmade), .R3detStateCounter_i(R3detStateCounter), .R3detState_i(R3detState), .L1detAck_o(L1detAck_o_3), .R3detmade_o(R3detmade_o_3), .L1L0ID_o(L1L0ID_o_3), .R3detStateCounter_o(R3detStateCounter_o_3), .R3detState_o(R3detState_o_3), .R3det_o(R3det_o_3));

majority_voter #(.WIDTH( 6 +`RO_ADDR_WIDTH-1-0+2-0+1-0+`RO_ADDR_WIDTH-1-0)) mv (
		.in1({L1detAck_o_1, R3detmade_o_1, L1L0ID_o_1, R3detStateCounter_o_1, R3detState_o_1, R3det_o_1}),
		.in2({L1detAck_o_2, R3detmade_o_2, L1L0ID_o_2, R3detStateCounter_o_2, R3detState_o_2, R3det_o_2}),
		.in3({L1detAck_o_3, R3detmade_o_3, L1L0ID_o_3, R3detStateCounter_o_3, R3detState_o_3, R3det_o_3}),
		.out({L1detAck, R3detmade, L1L0ID, R3detStateCounter, R3detState, R3det}),
		.err()
	);
endmodule
