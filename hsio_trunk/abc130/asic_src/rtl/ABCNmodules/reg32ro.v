// 32-bit parallel-loading read-only register
`timescale 1ns/1ps
module reg32ro (
  clkEn,
  bclk,
  rstb,
  shiftEn,
  latchOut,
  shiftOut,
  dataIn
); 
input clkEn;
input  bclk;   
input  rstb;  
input [31:0] dataIn;   //value to be parallel-loaded for readout
input shiftEn; 
output shiftOut; 
input latchOut; //load a read value from the register into the shifter

wire [31:0] dataOut;  
reg [31:0] shifter;  


//the input,output shift register
always @(posedge bclk ) 
  if ( clkEn == 1'b1) begin
   if ( rstb == 1'b0 )  begin
     shifter <= 32'h0;
   end
   else  begin
     if (shiftEn == 1'b1 & latchOut == 1'b0 )  begin
       shifter[31:1] <= shifter[30:0];   //bits arrive as msb->lsb
       shifter[0] <= 1'b0;
     end
     else 
       if ( latchOut == 1'b1 ) //load into the shift register
         shifter <= dataIn;  
   end  //not reset
  end //if ( clkEn == 1'b1)


assign shiftOut = (shiftEn == 1'b1 & latchOut == 1'b0 ) ? shifter[31] : 0;//shift out bits msb->lsb so they get heard in the correct order

endmodule //reg32
