// 32-bit serial loading register
`timescale 1ns/1ps
module reg32 (
  clkEn,
  bclk,
  rstb,
  shiftEn,
  latchIn,
  latchOut,
  shiftIn,
  shiftOut,
  dataOut
); 
parameter RESET_VALUE = 32'b0;
input clkEn;
input  bclk;   
input  rstb;  
output [31:0] dataOut;  
input shiftEn; 
input shiftIn; 
output shiftOut; 
input latchIn;	//load a write value from the shifter into the register
input latchOut; //load a read value from the register into the shifter

wire [31:0] dataOut;  
reg [31:0] shifter;  

reg[31:0] SR;  //state-reg 



assign dataOut[31:0] = SR[31:0];


//the input,output shift register
always @(posedge bclk ) 
  if ( clkEn == 1'b1) begin
   if ( rstb == 1'b0 )  begin
     shifter <= 32'h0;
   end
   else  begin
     if (shiftEn == 1'b1 & latchIn == 1'b0 & latchOut == 1'b0 )  begin
       shifter[31:1] <= shifter[30:0];   //bits arrive as msb->lsb
       shifter[0] <= shiftIn;
     end
     else 
       if ( latchOut == 1'b1 ) //load into the shift register
         shifter <= dataOut;  
   end  //not reset
  end //if ( clkEn == 1'b1)

always @(posedge bclk )
  if ( clkEn == 1'b1) begin
   if ( rstb == 1'b0 )  
     SR <= RESET_VALUE;
   else begin
     if ( latchIn == 1'b1)  //load from the shift register
        SR <= shifter;
     else 
       SR <=  dataOut;  
   end //not reset
  end //if ( clkEn == 1'b1)


assign shiftOut = (shiftEn == 1'b1 & latchOut == 1'b0 ) ? shifter[31] : 0;//shift out bits msb->lsb so they get heard in the correct order

endmodule //reg32
