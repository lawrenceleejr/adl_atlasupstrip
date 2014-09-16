// made on 2012-01-09 18:27:54

`timescale 1ns/1ps

//***
`include "../../abc130/src/veri_globals_P5.v"



module L1detect_internal ( 
	clk,
	Resetb,
	L1DataIn,
	R3detmade_i,
	R3detStateCounter_i,
	R3detState_i,
	L1detAck_o,
	R3detmade_o,
	L1L0ID_o,
	R3detStateCounter_o,
	R3detState_o,
	R3det_o);


///////////////////////////////////////////////////////////////////// 
/////parameters
parameter R3_IDLE    = 2'h0;
parameter R3_FIELD_1 = 2'h1;
parameter R3_FIELD_2 = 2'h2;
parameter R3_LAST = 2'h3;

///////////////////////////////////////////////////////////////////// 
/////OLD inputs
input clk, Resetb, L1DataIn;

///////////////////////////////////////////////////////////////////// 
/////OLD wires
wire R3RegActive;

///////////////////////////////////////////////////////////////////// 
/////NEW INPUTS
input R3detmade_i;

///////////////////////////////////////////////////////////////////// 
/////NEW OUTPUTS
output L1detAck_o, R3detmade_o;

///////////////////////////////////////////////////////////////////// 
/////NEW INPUT BUSES
input  [2:0] R3detStateCounter_i;
input  [1:0] R3detState_i;

///////////////////////////////////////////////////////////////////// 
/////NEW OUTPUT BUSES
output  [`RO_ADDR_WIDTH-1:0] L1L0ID_o;
output  [2:0] R3detStateCounter_o;
output  [1:0] R3detState_o;
output  [`RO_ADDR_WIDTH-1:0] R3det_o;

///////////////////////////////////////////////////////////////////// 
/////NEW regs
reg L1detAck_o, R3detmade_o;



///////////////////////////////////////////////////////////////////// 
/////NEW bus regs
reg  [`RO_ADDR_WIDTH-1:0] L1L0ID_o;
reg  [2:0] R3detStateCounter_o;
reg  [1:0] R3detState_o;
reg  [`RO_ADDR_WIDTH-1:0] R3det_o;

///////////////////////////////////////////////////////////////////// 
/////assign blocks
assign R3RegActive = R3detState_o[1] || R3detState_o[0];

///////////////////////////////////////////////////////////////////// 
/////always blocks


always @( posedge clk ) begin
  if ( Resetb == 1'b0 ) 
      R3detStateCounter_o <= 0;
  else 
    if ( R3RegActive )  begin 
      if ( R3detState_i == R3_FIELD_1  && R3detStateCounter_i == 3'b010  )      
                                                                           
        R3detStateCounter_o <= 0;
      else if ( R3detState_i == R3_FIELD_2  && R3detStateCounter_i == 3'b111  ) 
        R3detStateCounter_o <= 0;
      else 
        R3detStateCounter_o <= R3detStateCounter_i + 1'b1;
    end else
    	R3detStateCounter_o <= 0; 
 
end

 



always @(posedge clk) begin
  if ( Resetb == 1'b0 ) begin
    R3det_o[`RO_ADDR_WIDTH-1:0] <= 8'h0;
  end else begin
    R3det_o[`RO_ADDR_WIDTH-1:0] <= {R3det_o[`RO_ADDR_WIDTH-2:0], L1DataIn};
  end
end

 


always @(posedge clk) begin
  L1detAck_o <= R3detmade_i;    
end

 





always @(posedge clk ) 
 begin
  if ( Resetb == 1'b0 ) begin
          R3detState_o <= R3_IDLE;
	  R3detmade_o <= 1'b0;
  end else 
   case (R3detState_o)

    R3_IDLE:
      if ( L1DataIn == 1'b1 )     
          R3detState_o <= R3_FIELD_1;


    R3_FIELD_1: 
      if (R3detStateCounter_i == 3'b010 ) 
        if ( R3det_o[2:0] != 3'b110 )       
          R3detState_o <= R3_IDLE;
        else                          
          R3detState_o <= R3_FIELD_2;


    R3_FIELD_2:
      if ( R3detStateCounter_i == 3'b111) begin 
          R3detState_o <= R3_LAST;
	  L1L0ID_o <= R3det_o[7:0];      
	  R3detmade_o <= 1'b1;
        end 



    R3_LAST:
      begin
         R3detmade_o <= 1'b0;
         R3detState_o <= R3_IDLE;
	 end


     default: 
     	R3detState_o <= R3_IDLE;
   
    endcase

end


///////////////////////////////////////////////////////////////////// 
/////instances
         
   


endmodule
