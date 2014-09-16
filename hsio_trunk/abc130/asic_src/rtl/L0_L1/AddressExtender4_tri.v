//Verilog HDL 
// Generates 3 addresses from one
//
// F.A. 06 June 2011
//
//
// Used now as a L0ID_Local hold value register 16.11.2011 

`timescale 1ns/1ps


module AddressExtender4(
	CLK, SoftResetB, L0IDReset, L0IDPreset, ROReadStrob,
	PreL0ID, L0ID_Local
	);
	
input				CLK, SoftResetB, L0IDReset, L0IDPreset, ROReadStrob;
input 	[`RO_ADDR_WIDTH-1:0]  	PreL0ID;
output	[`RO_ADDR_WIDTH-1:0]	L0ID_Local;

reg 	[`RO_ADDR_WIDTH-1:0]  	L0ID_Local;
reg 				ROStretch;
reg	[3:0]			stretch_RO; 

///////////////////////////////////////////////////////////////////
// Generate ROReadStrob stretched to 3 BC's //
///////////////////////////////////////////////////////////////////
  always @( posedge CLK ) begin
    if ( ~SoftResetB ) begin 
      stretch_RO <= 0;
    end else begin
      stretch_RO[0] <= ROReadStrob;
      stretch_RO[1] <= stretch_RO[0];
      stretch_RO[2] <= stretch_RO[1];
      stretch_RO[3] <= stretch_RO[2];
//      ROStretchF <=  ( |stretch_RO ); 
      ROStretch <=  ( |stretch_RO[3:1] ); 
    end
  end

  
  always @( posedge CLK ) begin
    if ( ~SoftResetB | L0IDReset ) begin
    L0ID_Local <= ((8'hFF) & {8{~L0IDPreset}} | (PreL0ID & {8{L0IDPreset}}));
    end
    else if ( stretch_RO[0] ) begin
	L0ID_Local <= L0ID_Local + 1;
    end	
   end
  
endmodule
