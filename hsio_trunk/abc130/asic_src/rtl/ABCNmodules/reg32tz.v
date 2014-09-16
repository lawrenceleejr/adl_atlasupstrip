// 32-bit serial loading register with triplication
// special version with a reset for the analog and digital calibration bits, [0] and [1] respectively
// all 4 LSB bits [3:0] with a single pulse reset, all other static
`timescale 1ns/1ps
module reg32tz (
  clkEn,
  bclka,
  bclkb,
  bclkc,
  rstb,
  pulseRst,
  serIn,
  serOut,
  shiftEn,
  latchIn,
  latchOut,
  shiftIn,
  shiftOut,
  dataOut
); 
input clkEn;  //requires set_attribute lp_insert_clock_gating true
input  bclka;   
input  bclkb;   
input  bclkc;   
input  rstb;  
input  pulseRst;  
input  serIn;  	//indicates some previous register has had a soft-error
output serOut;  //indicates this or some previous register has had a soft-error
output [31:0] dataOut;  
input shiftEn; 
input shiftIn; 
output shiftOut; 
input latchIn;	//load a write value from the shifter into the register
input latchOut; //load a read value from the register into the shifter

wire [31:0] dataOut;  
reg [31:0] shifter;  

reg[31:0] SRa;  //state-reg A copy
reg[31:0] SRb;  //state-reg B copy
reg[31:0] SRc;  //state-reg C copy



//majority logic
assign dataOut[0] = (SRa[0] & SRb[0]) | (SRa[0] & SRc[0]) | (SRb[0] & SRc[0]);
assign dataOut[1] = (SRa[1] & SRb[1]) | (SRa[1] & SRc[1]) | (SRb[1] & SRc[1]);
assign dataOut[2] = (SRa[2] & SRb[2]) | (SRa[2] & SRc[2]) | (SRb[2] & SRc[2]);
assign dataOut[3] = (SRa[3] & SRb[3]) | (SRa[3] & SRc[3]) | (SRb[3] & SRc[3]);
assign dataOut[4] = (SRa[4] & SRb[4]) | (SRa[4] & SRc[4]) | (SRb[4] & SRc[4]);
assign dataOut[5] = (SRa[5] & SRb[5]) | (SRa[5] & SRc[5]) | (SRb[5] & SRc[5]);
assign dataOut[6] = (SRa[6] & SRb[6]) | (SRa[6] & SRc[6]) | (SRb[6] & SRc[6]);
assign dataOut[7] = (SRa[7] & SRb[7]) | (SRa[7] & SRc[7]) | (SRb[7] & SRc[7]);
assign dataOut[8] = (SRa[8] & SRb[8]) | (SRa[8] & SRc[8]) | (SRb[8] & SRc[8]);
assign dataOut[9] = (SRa[9] & SRb[9]) | (SRa[9] & SRc[9]) | (SRb[9] & SRc[9]);
assign dataOut[10] = (SRa[10] & SRb[10]) | (SRa[10] & SRc[10]) | (SRb[10] & SRc[10]);
assign dataOut[11] = (SRa[11] & SRb[11]) | (SRa[11] & SRc[11]) | (SRb[11] & SRc[11]);
assign dataOut[12] = (SRa[12] & SRb[12]) | (SRa[12] & SRc[12]) | (SRb[12] & SRc[12]);
assign dataOut[13] = (SRa[13] & SRb[13]) | (SRa[13] & SRc[13]) | (SRb[13] & SRc[13]);
assign dataOut[14] = (SRa[14] & SRb[14]) | (SRa[14] & SRc[14]) | (SRb[14] & SRc[14]);
assign dataOut[15] = (SRa[15] & SRb[15]) | (SRa[15] & SRc[15]) | (SRb[15] & SRc[15]);
assign dataOut[16] = (SRa[16] & SRb[16]) | (SRa[16] & SRc[16]) | (SRb[16] & SRc[16]);
assign dataOut[17] = (SRa[17] & SRb[17]) | (SRa[17] & SRc[17]) | (SRb[17] & SRc[17]);
assign dataOut[18] = (SRa[18] & SRb[18]) | (SRa[18] & SRc[18]) | (SRb[18] & SRc[18]);
assign dataOut[19] = (SRa[19] & SRb[19]) | (SRa[19] & SRc[19]) | (SRb[19] & SRc[19]);
assign dataOut[20] = (SRa[20] & SRb[20]) | (SRa[20] & SRc[20]) | (SRb[20] & SRc[20]);
assign dataOut[21] = (SRa[21] & SRb[21]) | (SRa[21] & SRc[21]) | (SRb[21] & SRc[21]);
assign dataOut[22] = (SRa[22] & SRb[22]) | (SRa[22] & SRc[22]) | (SRb[22] & SRc[22]);
assign dataOut[23] = (SRa[23] & SRb[23]) | (SRa[23] & SRc[23]) | (SRb[23] & SRc[23]);
assign dataOut[24] = (SRa[24] & SRb[24]) | (SRa[24] & SRc[24]) | (SRb[24] & SRc[24]);
assign dataOut[25] = (SRa[25] & SRb[25]) | (SRa[25] & SRc[25]) | (SRb[25] & SRc[25]);
assign dataOut[26] = (SRa[26] & SRb[26]) | (SRa[26] & SRc[26]) | (SRb[26] & SRc[26]);
assign dataOut[27] = (SRa[27] & SRb[27]) | (SRa[27] & SRc[27]) | (SRb[27] & SRc[27]);
assign dataOut[28] = (SRa[28] & SRb[28]) | (SRa[28] & SRc[28]) | (SRb[28] & SRc[28]);
assign dataOut[29] = (SRa[29] & SRb[29]) | (SRa[29] & SRc[29]) | (SRb[29] & SRc[29]);
assign dataOut[30] = (SRa[30] & SRb[30]) | (SRa[30] & SRc[30]) | (SRb[30] & SRc[30]);
assign dataOut[31] = (SRa[31] & SRb[31]) | (SRa[31] & SRc[31]) | (SRb[31] & SRc[31]);

//soft-error detect
assign serOut = (SRa[0] ^ SRb[0])  | (SRa[0] ^ SRc[0]) | (SRb[0] ^ SRc[0])
		| (SRa[1] ^ SRb[1])  | (SRa[1] ^ SRc[1]) | (SRb[1] ^ SRc[1])
		| (SRa[2] ^ SRb[2])  | (SRa[2] ^ SRc[2]) | (SRb[2] ^ SRc[2])
		| (SRa[3] ^ SRb[3])  | (SRa[3] ^ SRc[3]) | (SRb[3] ^ SRc[3])
		| (SRa[4] ^ SRb[4])  | (SRa[4] ^ SRc[4]) | (SRb[4] ^ SRc[4])
		| (SRa[5] ^ SRb[5])  | (SRa[5] ^ SRc[5]) | (SRb[5] ^ SRc[5])
		| (SRa[6] ^ SRb[6])  | (SRa[6] ^ SRc[6]) | (SRb[6] ^ SRc[6])
		| (SRa[7] ^ SRb[7])  | (SRa[7] ^ SRc[7]) | (SRb[7] ^ SRc[7])
		| (SRa[8] ^ SRb[8])  | (SRa[8] ^ SRc[8]) | (SRb[8] ^ SRc[8])
		| (SRa[9] ^ SRb[9])  | (SRa[9] ^ SRc[9]) | (SRb[9] ^ SRc[9])
		| (SRa[10] ^ SRb[10])  | (SRa[10] ^ SRc[10]) | (SRb[10] ^ SRc[10])
		| (SRa[11] ^ SRb[11])  | (SRa[11] ^ SRc[11]) | (SRb[11] ^ SRc[11])
		| (SRa[12] ^ SRb[12])  | (SRa[12] ^ SRc[12]) | (SRb[12] ^ SRc[12])
		| (SRa[13] ^ SRb[13])  | (SRa[13] ^ SRc[13]) | (SRb[13] ^ SRc[13])
		| (SRa[14] ^ SRb[14])  | (SRa[14] ^ SRc[14]) | (SRb[14] ^ SRc[14])
		| (SRa[15] ^ SRb[15])  | (SRa[15] ^ SRc[15]) | (SRb[15] ^ SRc[15])
		| (SRa[16] ^ SRb[16])  | (SRa[16] ^ SRc[16]) | (SRb[16] ^ SRc[16])
		| (SRa[17] ^ SRb[17])  | (SRa[17] ^ SRc[17]) | (SRb[17] ^ SRc[17])
		| (SRa[18] ^ SRb[18])  | (SRa[18] ^ SRc[18]) | (SRb[18] ^ SRc[18])
		| (SRa[19] ^ SRb[19])  | (SRa[19] ^ SRc[19]) | (SRb[19] ^ SRc[19])
		| (SRa[20] ^ SRb[20])  | (SRa[20] ^ SRc[20]) | (SRb[20] ^ SRc[20])
		| (SRa[21] ^ SRb[21])  | (SRa[21] ^ SRc[21]) | (SRb[21] ^ SRc[21])
		| (SRa[22] ^ SRb[22])  | (SRa[22] ^ SRc[22]) | (SRb[22] ^ SRc[22])
		| (SRa[23] ^ SRb[23])  | (SRa[23] ^ SRc[23]) | (SRb[23] ^ SRc[23])
		| (SRa[24] ^ SRb[24])  | (SRa[24] ^ SRc[24]) | (SRb[24] ^ SRc[24])
		| (SRa[25] ^ SRb[25])  | (SRa[25] ^ SRc[25]) | (SRb[25] ^ SRc[25])
		| (SRa[26] ^ SRb[26])  | (SRa[26] ^ SRc[26]) | (SRb[26] ^ SRc[26])
		| (SRa[27] ^ SRb[27])  | (SRa[27] ^ SRc[27]) | (SRb[27] ^ SRc[27])
		| (SRa[28] ^ SRb[28])  | (SRa[28] ^ SRc[28]) | (SRb[28] ^ SRc[28])
		| (SRa[29] ^ SRb[29])  | (SRa[29] ^ SRc[29]) | (SRb[29] ^ SRc[29])
		| (SRa[30] ^ SRb[30])  | (SRa[30] ^ SRc[30]) | (SRb[30] ^ SRc[30])
		| (SRa[31] ^ SRb[31])  | (SRa[31] ^ SRc[31]) | (SRb[31] ^ SRc[31])
                | serIn;

//the input,output shift register
always @(posedge bclka ) 
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
  end // if ( clkEn == 1'b1)

always @(posedge bclka )
  if ( clkEn == 1'b1 || pulseRst == 1'b1) begin
   if ( rstb == 1'b0 )  
     SRa <= 32'h0;
   else begin
     if ( latchIn == 1'b1)  //load from the shift register
        SRa <= shifter;
     else begin
       SRa[31:4] <=  dataOut[31:4];  // refresh majority-logic'ed value to clean up possible bit flips in this register
       SRa[3:0] <= pulseRst ? 4'b0 : dataOut[3:0];
     end
   end //not reset
  end // if ( clkEn == 1'b1)

always @(posedge bclkb )
  if ( clkEn == 1'b1 || pulseRst == 1'b1) begin
   if ( rstb == 1'b0 )  
     SRb <= 32'h0;
   else begin
     if ( latchIn == 1'b1)  //load from the shift register
        SRb <= shifter;
     else begin
       SRb[31:4] <=  dataOut[31:4];  // refresh majority-logic'ed value to clean up possible bit flips in this register
       SRb[3:0] <= pulseRst ? 4'b0 : dataOut[3:0];
     end
   end //not reset
  end // if ( clkEn == 1'b1)

always @(posedge bclkc )
  if ( clkEn == 1'b1 || pulseRst == 1'b1 ) begin
   if ( rstb == 1'b0 )
     SRc <= 32'h0;
   else begin
     if ( pulseRst == 1'b1 ) SRc[3:0] <= 4'b0;
     if ( latchIn == 1'b1)  //load from the shift register
        SRc <= shifter;
     else begin
       SRc[31:4] <=  dataOut[31:4];  // refresh majority-logic'ed value to clean up possible bit flips in this register
       SRc[3:0] <= pulseRst ? 4'b0 : dataOut[3:0];
     end
   end //not reset
  end // if ( clkEn == 1'b1)


assign shiftOut = (shiftEn == 1'b1 & latchOut == 1'b0 ) ? shifter[31] : 0;//shift out bits msb->lsb so they get heard in the correct order

endmodule //reg32
