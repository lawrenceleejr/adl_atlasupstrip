//Verilog HDL 
// Generates 3 addresses from one
//
// F.A. 06 June 2011
//
//
// Used now as a L0ID_Local hold value register 16.11.2011 

`timescale 1ns/1ps

`include "../../abc130/src/veri_globals_P5.v" // ***

module LocalL0ID_tri(
	CLK1, CLK2, CLK3, SoftResetB, L0IDReset, L0IDPreset, ROReadStrob,
	PreL0ID, L0ID_Local
	);
	
input				CLK1, CLK2, CLK3, SoftResetB, L0IDReset, L0IDPreset, ROReadStrob;
input 	[`RO_ADDR_WIDTH-1:0]  	PreL0ID;
output	[`RO_ADDR_WIDTH-1:0]	L0ID_Local;

reg 	[`RO_ADDR_WIDTH-1:0]  	L0ID_Local1, L0ID_Local2, L0ID_Local3 ;

wire 	[`RO_ADDR_WIDTH-1:0] 	L0Count;
wire 	[`RO_ADDR_WIDTH-1:0] 	L0ID_Local;

assign L0ID_Local[`RO_ADDR_WIDTH-1:0] = L0Count[`RO_ADDR_WIDTH-1:0];


//reg 				ROStretch;
//reg	[3:0]			stretch_RO; 

///////////////////////////////////////////////////////////////////
// Generate ROReadStrob stretched to 3 BC's //
///////////////////////////////////////////////////////////////////
//  always @( posedge CLK ) begin
//    if ( ~SoftResetB ) begin 
//      stretch_RO <= 0;
//    end else begin
//      stretch_RO[0] <= ROReadStrob;
//      stretch_RO[1] <= stretch_RO[0];
//      stretch_RO[2] <= stretch_RO[1];
//      stretch_RO[3] <= stretch_RO[2];
//      ROStretchF <=  ( |stretch_RO ); 
//      ROStretch <=  ( |stretch_RO[3:1] ); 
//    end
//  end

//majority logic
assign L0Count[0] = L0ID_Local1[0];
assign L0Count[1] = L0ID_Local1[1];
assign L0Count[2] = L0ID_Local1[2];
assign L0Count[3] = L0ID_Local1[3];
assign L0Count[4] = L0ID_Local1[4];
assign L0Count[5] = L0ID_Local1[5];
assign L0Count[6] = L0ID_Local1[6];
assign L0Count[7] = L0ID_Local1[7];
  
  always @( posedge CLK1 ) begin
    if ( ~SoftResetB | L0IDReset ) begin
    L0ID_Local1 <= ((8'hFF) & {8{~L0IDPreset}} | (PreL0ID & {8{L0IDPreset}}));
    end
    else if ( ROReadStrob ) begin
	L0ID_Local1 <= L0Count + 1;
    end	
   end
   
  
endmodule
