`timescale 1ns/1ps

module ABCN13 (
//bottom edge signals
 FastCLK_padP,
 FastCLK_padN,
 CLK_padP,
 CLK_padN,
 BC_padP,
 BC_padN,
 COM_LZERO_padP, 
 COM_LZERO_padN,
 LONERTHREE_padP,
 LONERTHREE_padN,
 RST_padP,
 RST_padN,
 padID,
 padTerm,
 padEnable_RegA,
 padEnable_RegD,
//verification testbench I/O's.  Not part of the actual chip
`ifdef VTB
 R3_ReadEnable,
 L1_ReadEnable,
 L1_DCL_Packet,
 L1_DCL_busy,
 L1_DCL_fifowr,
 L1_DCL_Mcluster,
 R3_DCL_fifowr,
 R3_DCL_busy,
 R3_DCL_PCKT_o,
// OP_DIR,
`endif
//left edge signals
 XOFFL,
 XOFFLB,
 DATL,
 DATLB,
//right edge signals
 XOFFR,
 XOFFRB,
 DATR,
 DATRB,
 dataOutFC1_padP,
 dataOutFC1_padN,
 dataOutFC2_padP,
 dataOutFC2_padN,
 //FE pins
 DIN,
 B8BREF, BIFEED, BIPRE, BIREF, BTRANGE, BVREF, COMBIAS,
 STR_DEL,
 BCAL, BVT,
 BTMUX,
 BTMUXD,
 STR_DEL_RANGE,
 CALENABLE,
 CalPulse, //STROBE in FE
 BTG0, BTG1, BTG2, BTG3, BTG4, BTG5, BTG6, BTG7, BTG8, BTG9,
 BTG10,BTG11,BTG12,BTG13,BTG14,BTG15,BTG16,BTG17,BTG18,BTG19,
 BTG20,BTG21,BTG22,BTG23,BTG24,BTG25,BTG26,BTG27,BTG28,BTG29,
 BTG30,BTG31,BTG32,BTG33,BTG34,BTG35,BTG36,BTG37,BTG38,BTG39,
 BTG40,BTG41,BTG42,BTG43,BTG44,BTG45,BTG46,BTG47,BTG48,BTG49,
 BTG50,BTG51,BTG52,BTG53,BTG54,BTG55,BTG56,BTG57,BTG58,BTG59,
 BTG60,BTG61,BTG62,BTG63
);

//FE pins
input [255:0] DIN;
output [4:0] B8BREF, BIFEED, BIPRE, BIREF, BTRANGE, BVREF, COMBIAS;
output [5:0] STR_DEL;
output [7:0] BCAL, BVT;
output [13:0] BTMUX;
output BTMUXD;
output [1:0] STR_DEL_RANGE;
output [255:0] CALENABLE;
output CalPulse; //STROBE in FE
output [19:0] BTG0, BTG1, BTG2, BTG3, BTG4, BTG5, BTG6, BTG7, BTG8, BTG9;
output [19:0] BTG10,BTG11,BTG12,BTG13,BTG14,BTG15,BTG16,BTG17,BTG18,BTG19;
output [19:0] BTG20,BTG21,BTG22,BTG23,BTG24,BTG25,BTG26,BTG27,BTG28,BTG29;
output [19:0] BTG30,BTG31,BTG32,BTG33,BTG34,BTG35,BTG36,BTG37,BTG38,BTG39;
output [19:0] BTG40,BTG41,BTG42,BTG43,BTG44,BTG45,BTG46,BTG47,BTG48,BTG49;
output [19:0] BTG50,BTG51,BTG52,BTG53,BTG54,BTG55,BTG56,BTG57,BTG58,BTG59;
output [19:0] BTG60,BTG61,BTG62,BTG63;


`ifdef VTB
input R3_ReadEnable;
input L1_ReadEnable;
output [`PW:0] L1_DCL_Packet;  //maybe assigned to l1_dcl_data[50:0]?
output [`PW:0] R3_DCL_PCKT_o;  
output L1_DCL_busy;
output L1_DCL_fifowr;
output L1_DCL_Mcluster;
output R3_DCL_fifowr;
output R3_DCL_busy;
`endif

output dataOutFC1_padP, dataOutFC1_padN, dataOutFC2_padP, dataOutFC2_padN;

input FastCLK_padP, FastCLK_padN; //160 or 320MHz or 640MHz clock diff-pair
input CLK_padP, CLK_padN; //80 or 160MHz clock diff-pair
input BC_padP, BC_padN;   //40 MHz machine clock 'bunch crossing clock'
input COM_LZERO_padP, COM_LZERO_padN; //serial command input port, embedded LZERO trigger on falling-edge
input LONERTHREE_padP, LONERTHREE_padN;   //Level-1 and R3 trigger code
input RST_padP, RST_padN;     //asynchronous hard reset
input [4:0] padID;      //Chip ID
input padTerm;
input padEnable_RegA, padEnable_RegD;

inout XOFFL, XOFFLB;  
inout DATL, DATLB;  
inout XOFFR, XOFFRB;  
inout DATR, DATRB; 

//REG enable signals
PIO_INP E_RegA(.PAD(padEnable_RegA), .PT(Enable_RegA));
PIO_INP E_RegD(.PAD(padEnable_RegD), .PT(Enable_RegD));

// DIGITAL SECTION

wire [255:0] DIN_DIG;

assign DIN_DIG[0] = DIN[0];
assign DIN_DIG[2] = DIN[1];
assign DIN_DIG[1] = DIN[2];
assign DIN_DIG[3] = DIN[3];
assign DIN_DIG[4] = DIN[4];
assign DIN_DIG[6] = DIN[5];
assign DIN_DIG[5] = DIN[6];
assign DIN_DIG[7] = DIN[7];
assign DIN_DIG[8] = DIN[8];
assign DIN_DIG[10] = DIN[9];
assign DIN_DIG[9] = DIN[10];
assign DIN_DIG[11] = DIN[11];
assign DIN_DIG[12] = DIN[12];
assign DIN_DIG[14] = DIN[13];
assign DIN_DIG[13] = DIN[14];
assign DIN_DIG[15] = DIN[15];
//
assign DIN_DIG[16+0] = DIN[16+0];
assign DIN_DIG[16+2] = DIN[16+1];
assign DIN_DIG[16+1] = DIN[16+2];
assign DIN_DIG[16+3] = DIN[16+3];
assign DIN_DIG[16+4] = DIN[16+4];
assign DIN_DIG[16+6] = DIN[16+5];
assign DIN_DIG[16+5] = DIN[16+6];
assign DIN_DIG[16+7] = DIN[16+7];
assign DIN_DIG[16+8] = DIN[16+8];
assign DIN_DIG[16+10] = DIN[16+9];
assign DIN_DIG[16+9] = DIN[16+10];
assign DIN_DIG[16+11] = DIN[16+11];
assign DIN_DIG[16+12] = DIN[16+12];
assign DIN_DIG[16+14] = DIN[16+13];
assign DIN_DIG[16+13] = DIN[16+14];
assign DIN_DIG[16+15] = DIN[16+15];
//
assign DIN_DIG[2*16+0] = DIN[2*16+0];
assign DIN_DIG[2*16+2] = DIN[2*16+1];
assign DIN_DIG[2*16+1] = DIN[2*16+2];
assign DIN_DIG[2*16+3] = DIN[2*16+3];
assign DIN_DIG[2*16+4] = DIN[2*16+4];
assign DIN_DIG[2*16+6] = DIN[2*16+5];
assign DIN_DIG[2*16+5] = DIN[2*16+6];
assign DIN_DIG[2*16+7] = DIN[2*16+7];
assign DIN_DIG[2*16+8] = DIN[2*16+8];
assign DIN_DIG[2*16+10] = DIN[2*16+9];
assign DIN_DIG[2*16+9] = DIN[2*16+10];
assign DIN_DIG[2*16+11] = DIN[2*16+11];
assign DIN_DIG[2*16+12] = DIN[2*16+12];
assign DIN_DIG[2*16+14] = DIN[2*16+13];
assign DIN_DIG[2*16+13] = DIN[2*16+14];
assign DIN_DIG[2*16+15] = DIN[2*16+15];
//
assign DIN_DIG[3*16+0] = DIN[3*16+0];
assign DIN_DIG[3*16+2] = DIN[3*16+1];
assign DIN_DIG[3*16+1] = DIN[3*16+2];
assign DIN_DIG[3*16+3] = DIN[3*16+3];
assign DIN_DIG[3*16+4] = DIN[3*16+4];
assign DIN_DIG[3*16+6] = DIN[3*16+5];
assign DIN_DIG[3*16+5] = DIN[3*16+6];
assign DIN_DIG[3*16+7] = DIN[3*16+7];
assign DIN_DIG[3*16+8] = DIN[3*16+8];
assign DIN_DIG[3*16+10] = DIN[3*16+9];
assign DIN_DIG[3*16+9] = DIN[3*16+10];
assign DIN_DIG[3*16+11] = DIN[3*16+11];
assign DIN_DIG[3*16+12] = DIN[3*16+12];
assign DIN_DIG[3*16+14] = DIN[3*16+13];
assign DIN_DIG[3*16+13] = DIN[3*16+14];
assign DIN_DIG[3*16+15] = DIN[3*16+15];
//
assign DIN_DIG[4*16+0] = DIN[4*16+0];
assign DIN_DIG[4*16+2] = DIN[4*16+1];
assign DIN_DIG[4*16+1] = DIN[4*16+2];
assign DIN_DIG[4*16+3] = DIN[4*16+3];
assign DIN_DIG[4*16+4] = DIN[4*16+4];
assign DIN_DIG[4*16+6] = DIN[4*16+5];
assign DIN_DIG[4*16+5] = DIN[4*16+6];
assign DIN_DIG[4*16+7] = DIN[4*16+7];
assign DIN_DIG[4*16+8] = DIN[4*16+8];
assign DIN_DIG[4*16+10] = DIN[4*16+9];
assign DIN_DIG[4*16+9] = DIN[4*16+10];
assign DIN_DIG[4*16+11] = DIN[4*16+11];
assign DIN_DIG[4*16+12] = DIN[4*16+12];
assign DIN_DIG[4*16+14] = DIN[4*16+13];
assign DIN_DIG[4*16+13] = DIN[4*16+14];
assign DIN_DIG[4*16+15] = DIN[4*16+15];
//
assign DIN_DIG[5*16+0] = DIN[5*16+0];
assign DIN_DIG[5*16+2] = DIN[5*16+1];
assign DIN_DIG[5*16+1] = DIN[5*16+2];
assign DIN_DIG[5*16+3] = DIN[5*16+3];
assign DIN_DIG[5*16+4] = DIN[5*16+4];
assign DIN_DIG[5*16+6] = DIN[5*16+5];
assign DIN_DIG[5*16+5] = DIN[5*16+6];
assign DIN_DIG[5*16+7] = DIN[5*16+7];
assign DIN_DIG[5*16+8] = DIN[5*16+8];
assign DIN_DIG[5*16+10] = DIN[5*16+9];
assign DIN_DIG[5*16+9] = DIN[5*16+10];
assign DIN_DIG[5*16+11] = DIN[5*16+11];
assign DIN_DIG[5*16+12] = DIN[5*16+12];
assign DIN_DIG[5*16+14] = DIN[5*16+13];
assign DIN_DIG[5*16+13] = DIN[5*16+14];
assign DIN_DIG[5*16+15] = DIN[5*16+15];
//
assign DIN_DIG[6*16+0] = DIN[6*16+0];
assign DIN_DIG[6*16+2] = DIN[6*16+1];
assign DIN_DIG[6*16+1] = DIN[6*16+2];
assign DIN_DIG[6*16+3] = DIN[6*16+3];
assign DIN_DIG[6*16+4] = DIN[6*16+4];
assign DIN_DIG[6*16+6] = DIN[6*16+5];
assign DIN_DIG[6*16+5] = DIN[6*16+6];
assign DIN_DIG[6*16+7] = DIN[6*16+7];
assign DIN_DIG[6*16+8] = DIN[6*16+8];
assign DIN_DIG[6*16+10] = DIN[6*16+9];
assign DIN_DIG[6*16+9] = DIN[6*16+10];
assign DIN_DIG[6*16+11] = DIN[6*16+11];
assign DIN_DIG[6*16+12] = DIN[6*16+12];
assign DIN_DIG[6*16+14] = DIN[6*16+13];
assign DIN_DIG[6*16+13] = DIN[6*16+14];
assign DIN_DIG[6*16+15] = DIN[6*16+15];
//
assign DIN_DIG[7*16+0] = DIN[7*16+0];
assign DIN_DIG[7*16+2] = DIN[7*16+1];
assign DIN_DIG[7*16+1] = DIN[7*16+2];
assign DIN_DIG[7*16+3] = DIN[7*16+3];
assign DIN_DIG[7*16+4] = DIN[7*16+4];
assign DIN_DIG[7*16+6] = DIN[7*16+5];
assign DIN_DIG[7*16+5] = DIN[7*16+6];
assign DIN_DIG[7*16+7] = DIN[7*16+7];
assign DIN_DIG[7*16+8] = DIN[7*16+8];
assign DIN_DIG[7*16+10] = DIN[7*16+9];
assign DIN_DIG[7*16+9] = DIN[7*16+10];
assign DIN_DIG[7*16+11] = DIN[7*16+11];
assign DIN_DIG[7*16+12] = DIN[7*16+12];
assign DIN_DIG[7*16+14] = DIN[7*16+13];
assign DIN_DIG[7*16+13] = DIN[7*16+14];
assign DIN_DIG[7*16+15] = DIN[7*16+15];
//
assign DIN_DIG[8*16+0] = DIN[8*16+0];
assign DIN_DIG[8*16+2] = DIN[8*16+1];
assign DIN_DIG[8*16+1] = DIN[8*16+2];
assign DIN_DIG[8*16+3] = DIN[8*16+3];
assign DIN_DIG[8*16+4] = DIN[8*16+4];
assign DIN_DIG[8*16+6] = DIN[8*16+5];
assign DIN_DIG[8*16+5] = DIN[8*16+6];
assign DIN_DIG[8*16+7] = DIN[8*16+7];
assign DIN_DIG[8*16+8] = DIN[8*16+8];
assign DIN_DIG[8*16+10] = DIN[8*16+9];
assign DIN_DIG[8*16+9] = DIN[8*16+10];
assign DIN_DIG[8*16+11] = DIN[8*16+11];
assign DIN_DIG[8*16+12] = DIN[8*16+12];
assign DIN_DIG[8*16+14] = DIN[8*16+13];
assign DIN_DIG[8*16+13] = DIN[8*16+14];
assign DIN_DIG[8*16+15] = DIN[8*16+15];
//
assign DIN_DIG[9*16+0] = DIN[9*16+0];
assign DIN_DIG[9*16+2] = DIN[9*16+1];
assign DIN_DIG[9*16+1] = DIN[9*16+2];
assign DIN_DIG[9*16+3] = DIN[9*16+3];
assign DIN_DIG[9*16+4] = DIN[9*16+4];
assign DIN_DIG[9*16+6] = DIN[9*16+5];
assign DIN_DIG[9*16+5] = DIN[9*16+6];
assign DIN_DIG[9*16+7] = DIN[9*16+7];
assign DIN_DIG[9*16+8] = DIN[9*16+8];
assign DIN_DIG[9*16+10] = DIN[9*16+9];
assign DIN_DIG[9*16+9] = DIN[9*16+10];
assign DIN_DIG[9*16+11] = DIN[9*16+11];
assign DIN_DIG[9*16+12] = DIN[9*16+12];
assign DIN_DIG[9*16+14] = DIN[9*16+13];
assign DIN_DIG[9*16+13] = DIN[9*16+14];
assign DIN_DIG[9*16+15] = DIN[9*16+15];
//
assign DIN_DIG[10*16+0] = DIN[10*16+0];
assign DIN_DIG[10*16+2] = DIN[10*16+1];
assign DIN_DIG[10*16+1] = DIN[10*16+2];
assign DIN_DIG[10*16+3] = DIN[10*16+3];
assign DIN_DIG[10*16+4] = DIN[10*16+4];
assign DIN_DIG[10*16+6] = DIN[10*16+5];
assign DIN_DIG[10*16+5] = DIN[10*16+6];
assign DIN_DIG[10*16+7] = DIN[10*16+7];
assign DIN_DIG[10*16+8] = DIN[10*16+8];
assign DIN_DIG[10*16+10] = DIN[10*16+9];
assign DIN_DIG[10*16+9] = DIN[10*16+10];
assign DIN_DIG[10*16+11] = DIN[10*16+11];
assign DIN_DIG[10*16+12] = DIN[10*16+12];
assign DIN_DIG[10*16+14] = DIN[10*16+13];
assign DIN_DIG[10*16+13] = DIN[10*16+14];
assign DIN_DIG[10*16+15] = DIN[10*16+15];
//
assign DIN_DIG[11*16+0] = DIN[11*16+0];
assign DIN_DIG[11*16+2] = DIN[11*16+1];
assign DIN_DIG[11*16+1] = DIN[11*16+2];
assign DIN_DIG[11*16+3] = DIN[11*16+3];
assign DIN_DIG[11*16+4] = DIN[11*16+4];
assign DIN_DIG[11*16+6] = DIN[11*16+5];
assign DIN_DIG[11*16+5] = DIN[11*16+6];
assign DIN_DIG[11*16+7] = DIN[11*16+7];
assign DIN_DIG[11*16+8] = DIN[11*16+8];
assign DIN_DIG[11*16+10] = DIN[11*16+9];
assign DIN_DIG[11*16+9] = DIN[11*16+10];
assign DIN_DIG[11*16+11] = DIN[11*16+11];
assign DIN_DIG[11*16+12] = DIN[11*16+12];
assign DIN_DIG[11*16+14] = DIN[11*16+13];
assign DIN_DIG[11*16+13] = DIN[11*16+14];
assign DIN_DIG[11*16+15] = DIN[11*16+15];
//
assign DIN_DIG[12*16+0] = DIN[12*16+0];
assign DIN_DIG[12*16+2] = DIN[12*16+1];
assign DIN_DIG[12*16+1] = DIN[12*16+2];
assign DIN_DIG[12*16+3] = DIN[12*16+3];
assign DIN_DIG[12*16+4] = DIN[12*16+4];
assign DIN_DIG[12*16+6] = DIN[12*16+5];
assign DIN_DIG[12*16+5] = DIN[12*16+6];
assign DIN_DIG[12*16+7] = DIN[12*16+7];
assign DIN_DIG[12*16+8] = DIN[12*16+8];
assign DIN_DIG[12*16+10] = DIN[12*16+9];
assign DIN_DIG[12*16+9] = DIN[12*16+10];
assign DIN_DIG[12*16+11] = DIN[12*16+11];
assign DIN_DIG[12*16+12] = DIN[12*16+12];
assign DIN_DIG[12*16+14] = DIN[12*16+13];
assign DIN_DIG[12*16+13] = DIN[12*16+14];
assign DIN_DIG[12*16+15] = DIN[12*16+15];
//
assign DIN_DIG[13*16+0] = DIN[13*16+0];
assign DIN_DIG[13*16+2] = DIN[13*16+1];
assign DIN_DIG[13*16+1] = DIN[13*16+2];
assign DIN_DIG[13*16+3] = DIN[13*16+3];
assign DIN_DIG[13*16+4] = DIN[13*16+4];
assign DIN_DIG[13*16+6] = DIN[13*16+5];
assign DIN_DIG[13*16+5] = DIN[13*16+6];
assign DIN_DIG[13*16+7] = DIN[13*16+7];
assign DIN_DIG[13*16+8] = DIN[13*16+8];
assign DIN_DIG[13*16+10] = DIN[13*16+9];
assign DIN_DIG[13*16+9] = DIN[13*16+10];
assign DIN_DIG[13*16+11] = DIN[13*16+11];
assign DIN_DIG[13*16+12] = DIN[13*16+12];
assign DIN_DIG[13*16+14] = DIN[13*16+13];
assign DIN_DIG[13*16+13] = DIN[13*16+14];
assign DIN_DIG[13*16+15] = DIN[13*16+15];
//
assign DIN_DIG[14*16+0] = DIN[14*16+0];
assign DIN_DIG[14*16+2] = DIN[14*16+1];
assign DIN_DIG[14*16+1] = DIN[14*16+2];
assign DIN_DIG[14*16+3] = DIN[14*16+3];
assign DIN_DIG[14*16+4] = DIN[14*16+4];
assign DIN_DIG[14*16+6] = DIN[14*16+5];
assign DIN_DIG[14*16+5] = DIN[14*16+6];
assign DIN_DIG[14*16+7] = DIN[14*16+7];
assign DIN_DIG[14*16+8] = DIN[14*16+8];
assign DIN_DIG[14*16+10] = DIN[14*16+9];
assign DIN_DIG[14*16+9] = DIN[14*16+10];
assign DIN_DIG[14*16+11] = DIN[14*16+11];
assign DIN_DIG[14*16+12] = DIN[14*16+12];
assign DIN_DIG[14*16+14] = DIN[14*16+13];
assign DIN_DIG[14*16+13] = DIN[14*16+14];
assign DIN_DIG[14*16+15] = DIN[14*16+15];
//
assign DIN_DIG[15*16+0] = DIN[15*16+0];
assign DIN_DIG[15*16+2] = DIN[15*16+1];
assign DIN_DIG[15*16+1] = DIN[15*16+2];
assign DIN_DIG[15*16+3] = DIN[15*16+3];
assign DIN_DIG[15*16+4] = DIN[15*16+4];
assign DIN_DIG[15*16+6] = DIN[15*16+5];
assign DIN_DIG[15*16+5] = DIN[15*16+6];
assign DIN_DIG[15*16+7] = DIN[15*16+7];
assign DIN_DIG[15*16+8] = DIN[15*16+8];
assign DIN_DIG[15*16+10] = DIN[15*16+9];
assign DIN_DIG[15*16+9] = DIN[15*16+10];
assign DIN_DIG[15*16+11] = DIN[15*16+11];
assign DIN_DIG[15*16+12] = DIN[15*16+12];
assign DIN_DIG[15*16+14] = DIN[15*16+13];
assign DIN_DIG[15*16+13] = DIN[15*16+14];
assign DIN_DIG[15*16+15] = DIN[15*16+15];
//



wire PwrResetb;


wire [31:0]  regADCS1, 
 regADCS2, 
 regADCS3, 
 regADCS7,
 regChannel0, 
 regChannel1, 
 regChannel2, 
 regChannel3, 
 regChannel4, 
 regChannel5, 
 regChannel6, 
 regChannel7, 
 regChannel8, 
 regChannel9,
regChannel10, 
regChannel11, 
regChannel12, 
regChannel13, 
regChannel14,
regChannel15, 
regChannel16, 
regChannel17, 
regChannel18, 
regChannel19,
regChannel20, 
regChannel21, 
regChannel22, 
regChannel23, 
regChannel24,
regChannel25, 
regChannel26, 
regChannel27, 
regChannel28, 
regChannel29,
regChannel30, 
regChannel31, 
regChannel32, 
regChannel33, 
regChannel34,
regChannel35, 
regChannel36, 
regChannel37, 
regChannel38, 
regChannel39,
regChannel40, 
regChannel41, 
regChannel42, 
regChannel43, 
regChannel44,
regChannel45, 
regChannel46, 
regChannel47, 
regChannel48, 
regChannel49,
regChannel50, 
regChannel51, 
regChannel52, 
regChannel53, 
regChannel54,
regChannel55, 
regChannel56, 
regChannel57, 
regChannel58, 
regChannel59,
regChannel60, 
regChannel61, 
regChannel62, 
regChannel63
;


 ABCN13_DIG ABCN13_D (
 //verification testbench I/O's.  Not part of the actual chip
`ifdef VTB
 .R3_ReadEnable(R3_ReadEnable),
 .L1_ReadEnable(L1_ReadEnable),
 .L1_DCL_Packet(L1_DCL_Packet),
 .L1_DCL_busy(L1_DCL_busy),
 .L1_DCL_fifowr(L1_DCL_fifowr),
 .L1_DCL_Mcluster(L1_DCL_Mcluster),
 .R3_DCL_fifowr(R3_DCL_fifowr),
 .R3_DCL_busy(R3_DCL_busy),
 .R3_DCL_PCKT_o(R3_DCL_PCKT_o),
// .OP_DIR(OP_DIR),
`endif
//data from the FE
 .DIN(DIN_DIG[255:0]),
//bottom edge signals
 .CLK_padP(CLK_padP),
 .CLK_padN(CLK_padN),
 .BC_padP(BC_padP),
 .BC_padN(BC_padN),
 .COM_LZERO_padP(COM_LZERO_padP), 
 .COM_LZERO_padN(COM_LZERO_padN),
 .LONERTHREE_padP(LONERTHREE_padP),
 .LONERTHREE_padN(LONERTHREE_padN),
//right edge signals
 .padID(padID),
 .padTerm(padTerm),
 .FastCLK_padP(FastCLK_padP),
 .FastCLK_padN(FastCLK_padN),
 .XOFFL(XOFFL),
 .XOFFLB(XOFFLB),
 .DATL(DATL),
 .DATLB(DATLB),
 .XOFFR(XOFFR),
 .XOFFRB(XOFFRB),
 .DATR(DATR),
 .DATRB(DATRB),
 .dataOutFC1_padP(dataOutFC1_padP),
 .dataOutFC1_padN(dataOutFC1_padN),
 .dataOutFC2_padP(dataOutFC2_padP),
 .dataOutFC2_padN(dataOutFC2_padN),
 //top edge signals 
 .RST_padP(RST_padP),
 .RST_padN(RST_padN),
 // Towards FE
 .CalPulseTo(CalPulse),
 .regADCS1(regADCS1), 
 .regADCS2(regADCS2), 
 .regADCS3(regADCS3), 
 .regADCS7(regADCS7),
 .regChannel0(regChannel0), 
 .regChannel1(regChannel1), 
 .regChannel2(regChannel2), 
 .regChannel3(regChannel3), 
 .regChannel4(regChannel4), 
 .regChannel5(regChannel5), 
 .regChannel6(regChannel6), 
 .regChannel7(regChannel7), 
 .regChannel8(regChannel8), 
 .regChannel9(regChannel9),
 .regChannel10(regChannel10), 
 .regChannel11(regChannel11), 
 .regChannel12(regChannel12), 
 .regChannel13(regChannel13), 
 .regChannel14(regChannel14),
 .regChannel15(regChannel15), 
 .regChannel16(regChannel16), 
 .regChannel17(regChannel17), 
 .regChannel18(regChannel18), 
 .regChannel19(regChannel19),
 .regChannel20(regChannel20), 
 .regChannel21(regChannel21), 
 .regChannel22(regChannel22), 
 .regChannel23(regChannel23), 
 .regChannel24(regChannel24),
 .regChannel25(regChannel25), 
 .regChannel26(regChannel26), 
 .regChannel27(regChannel27), 
 .regChannel28(regChannel28), 
 .regChannel29(regChannel29),
 .regChannel30(regChannel30), 
 .regChannel31(regChannel31), 
 .regChannel32(regChannel32), 
 .regChannel33(regChannel33), 
 .regChannel34(regChannel34),
 .regChannel35(regChannel35), 
 .regChannel36(regChannel36), 
 .regChannel37(regChannel37), 
 .regChannel38(regChannel38), 
 .regChannel39(regChannel39),
 .regChannel40(regChannel40), 
 .regChannel41(regChannel41), 
 .regChannel42(regChannel42), 
 .regChannel43(regChannel43), 
 .regChannel44(regChannel44),
 .regChannel45(regChannel45), 
 .regChannel46(regChannel46), 
 .regChannel47(regChannel47), 
 .regChannel48(regChannel48), 
 .regChannel49(regChannel49),
 .regChannel50(regChannel50), 
 .regChannel51(regChannel51), 
 .regChannel52(regChannel52), 
 .regChannel53(regChannel53), 
 .regChannel54(regChannel54),
 .regChannel55(regChannel55), 
 .regChannel56(regChannel56), 
 .regChannel57(regChannel57), 
 .regChannel58(regChannel58), 
 .regChannel59(regChannel59),
 .regChannel60(regChannel60), 
 .regChannel61(regChannel61), 
 .regChannel62(regChannel62), 
 .regChannel63(regChannel63),
 .powerUpRstb(PwrResetb)
);

wire FRCREF, BGref;

ResOnPowABC2 PowerOnReset (
  .AnRes(PwrResetb) // Active low
);

//`define OLD_REGS

LDOVR_ABCN LDOVR_A (
  .A1(regADCS7[23]),
  .A2(regADCS7[23]),
  .A3(regADCS7[23]),
  .A4(regADCS7[23]),
  .A5(regADCS7[23]),
  .A6(regADCS7[23]),
  .A7(regADCS7[23]),
  .S1(regADCS7[16]),
  .S2(regADCS7[17]),
  .S3(regADCS7[18]),
  .S4(regADCS7[19]),
  .S5(regADCS7[20]),
  .S6(regADCS7[21]),
  .S7(regADCS7[22]),  
  .switch(Enable_RegA),
  .vref(BGref)
   
);

LDOVR_ABCN LDOVR_D (
  .A1(regADCS7[31]),
  .A2(regADCS7[31]),
  .A3(regADCS7[31]),
  .A4(regADCS7[31]),
  .A5(regADCS7[31]),
  .A6(regADCS7[31]),
  .A7(regADCS7[31]),
  .S1(regADCS7[24]),
  .S2(regADCS7[25]),
  .S3(regADCS7[26]),
  .S4(regADCS7[27]),
  .S5(regADCS7[28]),
  .S6(regADCS7[29]),
  .S7(regADCS7[30]),  
  .switch(Enable_RegD),
  .vref(BGref)
   
);

BandGapCurrPMOSFinal BandGap_D (
 .FRCREF (FRCREF),
 .REF( BGref )
   
);


assign B8BREF[4:0] = regADCS1[20:16];
assign BCAL[7:0] = regADCS3[23:16];
assign BIFEED[4:0] = regADCS2[20:16];
assign BIPRE[4:0] = regADCS2[28:24];
assign BIREF[4:0] = regADCS1[12:8];
assign BTMUX[13:0] = regADCS7[13:0];
assign BTMUXD = regADCS7[14];
assign BTRANGE[4:0] = regADCS1[28:24];
assign BVREF[4:0] = regADCS1[4:0];
assign BVT[7:0] = regADCS2[7:0];
assign COMBIAS[4:0] = regADCS2[12:8];
assign STR_DEL[5:0] = regADCS3[13:8];
assign STR_DEL_RANGE[1:0] = regADCS3[1:0];



assign BTG0[19:0] = {regChannel0[28:24], regChannel0[22:16], regChannel0[12:8], regChannel0[4:0]};
assign BTG1[19:0] = {regChannel1[28:24], regChannel1[22:16], regChannel1[12:8], regChannel1[4:0]};
assign BTG2[19:0] = {regChannel2[28:24], regChannel2[22:16], regChannel2[12:8], regChannel2[4:0]};
assign BTG3[19:0] = {regChannel3[28:24], regChannel3[22:16], regChannel3[12:8], regChannel3[4:0]};
assign BTG4[19:0] = {regChannel4[28:24], regChannel4[22:16], regChannel4[12:8], regChannel4[4:0]};
assign BTG5[19:0] = {regChannel5[28:24], regChannel5[22:16], regChannel5[12:8], regChannel5[4:0]};
assign BTG6[19:0] = {regChannel6[28:24], regChannel6[22:16], regChannel6[12:8], regChannel6[4:0]};
assign BTG7[19:0] = {regChannel7[28:24], regChannel7[22:16], regChannel7[12:8], regChannel7[4:0]};
assign BTG8[19:0] = {regChannel8[28:24], regChannel8[22:16], regChannel8[12:8], regChannel8[4:0]};
assign BTG9[19:0] = {regChannel9[28:24], regChannel9[22:16], regChannel9[12:8], regChannel9[4:0]};
assign BTG10[19:0] = {regChannel10[28:24], regChannel10[22:16], regChannel10[12:8], regChannel10[4:0]};
assign BTG11[19:0] = {regChannel11[28:24], regChannel11[22:16], regChannel11[12:8], regChannel11[4:0]};
assign BTG12[19:0] = {regChannel12[28:24], regChannel12[22:16], regChannel12[12:8], regChannel12[4:0]};
assign BTG13[19:0] = {regChannel13[28:24], regChannel13[22:16], regChannel13[12:8], regChannel13[4:0]};
assign BTG14[19:0] = {regChannel14[28:24], regChannel14[22:16], regChannel14[12:8], regChannel14[4:0]};
assign BTG15[19:0] = {regChannel15[28:24], regChannel15[22:16], regChannel15[12:8], regChannel15[4:0]};
assign BTG16[19:0] = {regChannel16[28:24], regChannel16[22:16], regChannel16[12:8], regChannel16[4:0]};
assign BTG17[19:0] = {regChannel17[28:24], regChannel17[22:16], regChannel17[12:8], regChannel17[4:0]};
assign BTG18[19:0] = {regChannel18[28:24], regChannel18[22:16], regChannel18[12:8], regChannel18[4:0]};
assign BTG19[19:0] = {regChannel19[28:24], regChannel19[22:16], regChannel19[12:8], regChannel19[4:0]};
assign BTG20[19:0] = {regChannel20[28:24], regChannel20[22:16], regChannel20[12:8], regChannel20[4:0]};
assign BTG21[19:0] = {regChannel21[28:24], regChannel21[22:16], regChannel21[12:8], regChannel21[4:0]};
assign BTG22[19:0] = {regChannel22[28:24], regChannel22[22:16], regChannel22[12:8], regChannel22[4:0]};
assign BTG23[19:0] = {regChannel23[28:24], regChannel23[22:16], regChannel23[12:8], regChannel23[4:0]};
assign BTG24[19:0] = {regChannel24[28:24], regChannel24[22:16], regChannel24[12:8], regChannel24[4:0]};
assign BTG25[19:0] = {regChannel25[28:24], regChannel25[22:16], regChannel25[12:8], regChannel25[4:0]};
assign BTG26[19:0] = {regChannel26[28:24], regChannel26[22:16], regChannel26[12:8], regChannel26[4:0]};
assign BTG27[19:0] = {regChannel27[28:24], regChannel27[22:16], regChannel27[12:8], regChannel27[4:0]};
assign BTG28[19:0] = {regChannel28[28:24], regChannel28[22:16], regChannel28[12:8], regChannel28[4:0]};
assign BTG29[19:0] = {regChannel29[28:24], regChannel29[22:16], regChannel29[12:8], regChannel29[4:0]};
assign BTG30[19:0] = {regChannel30[28:24], regChannel30[22:16], regChannel30[12:8], regChannel30[4:0]};
assign BTG31[19:0] = {regChannel31[28:24], regChannel31[22:16], regChannel31[12:8], regChannel31[4:0]};
assign BTG32[19:0] = {regChannel32[28:24], regChannel32[22:16], regChannel32[12:8], regChannel32[4:0]};
assign BTG33[19:0] = {regChannel33[28:24], regChannel33[22:16], regChannel33[12:8], regChannel33[4:0]};
assign BTG34[19:0] = {regChannel34[28:24], regChannel34[22:16], regChannel34[12:8], regChannel34[4:0]};
assign BTG35[19:0] = {regChannel35[28:24], regChannel35[22:16], regChannel35[12:8], regChannel35[4:0]};
assign BTG36[19:0] = {regChannel36[28:24], regChannel36[22:16], regChannel36[12:8], regChannel36[4:0]};
assign BTG37[19:0] = {regChannel37[28:24], regChannel37[22:16], regChannel37[12:8], regChannel37[4:0]};
assign BTG38[19:0] = {regChannel38[28:24], regChannel38[22:16], regChannel38[12:8], regChannel38[4:0]};
assign BTG39[19:0] = {regChannel39[28:24], regChannel39[22:16], regChannel39[12:8], regChannel39[4:0]};
assign BTG40[19:0] = {regChannel40[28:24], regChannel40[22:16], regChannel40[12:8], regChannel40[4:0]};
assign BTG41[19:0] = {regChannel41[28:24], regChannel41[22:16], regChannel41[12:8], regChannel41[4:0]};
assign BTG42[19:0] = {regChannel42[28:24], regChannel42[22:16], regChannel42[12:8], regChannel42[4:0]};
assign BTG43[19:0] = {regChannel43[28:24], regChannel43[22:16], regChannel43[12:8], regChannel43[4:0]};
assign BTG44[19:0] = {regChannel44[28:24], regChannel44[22:16], regChannel44[12:8], regChannel44[4:0]};
assign BTG45[19:0] = {regChannel45[28:24], regChannel45[22:16], regChannel45[12:8], regChannel45[4:0]};
assign BTG46[19:0] = {regChannel46[28:24], regChannel46[22:16], regChannel46[12:8], regChannel46[4:0]};
assign BTG47[19:0] = {regChannel47[28:24], regChannel47[22:16], regChannel47[12:8], regChannel47[4:0]};
assign BTG48[19:0] = {regChannel48[28:24], regChannel48[22:16], regChannel48[12:8], regChannel48[4:0]};
assign BTG49[19:0] = {regChannel49[28:24], regChannel49[22:16], regChannel49[12:8], regChannel49[4:0]};
assign BTG50[19:0] = {regChannel50[28:24], regChannel50[22:16], regChannel50[12:8], regChannel50[4:0]};
assign BTG51[19:0] = {regChannel51[28:24], regChannel51[22:16], regChannel51[12:8], regChannel51[4:0]};
assign BTG52[19:0] = {regChannel52[28:24], regChannel52[22:16], regChannel52[12:8], regChannel52[4:0]};
assign BTG53[19:0] = {regChannel53[28:24], regChannel53[22:16], regChannel53[12:8], regChannel53[4:0]};
assign BTG54[19:0] = {regChannel54[28:24], regChannel54[22:16], regChannel54[12:8], regChannel54[4:0]};
assign BTG55[19:0] = {regChannel55[28:24], regChannel55[22:16], regChannel55[12:8], regChannel55[4:0]};
assign BTG56[19:0] = {regChannel56[28:24], regChannel56[22:16], regChannel56[12:8], regChannel56[4:0]};
assign BTG57[19:0] = {regChannel57[28:24], regChannel57[22:16], regChannel57[12:8], regChannel57[4:0]};
assign BTG58[19:0] = {regChannel58[28:24], regChannel58[22:16], regChannel58[12:8], regChannel58[4:0]};
assign BTG59[19:0] = {regChannel59[28:24], regChannel59[22:16], regChannel59[12:8], regChannel59[4:0]};
assign BTG60[19:0] = {regChannel60[28:24], regChannel60[22:16], regChannel60[12:8], regChannel60[4:0]};
assign BTG61[19:0] = {regChannel61[28:24], regChannel61[22:16], regChannel61[12:8], regChannel61[4:0]};
assign BTG62[19:0] = {regChannel62[28:24], regChannel62[22:16], regChannel62[12:8], regChannel62[4:0]};
assign BTG63[19:0] = {regChannel63[28:24], regChannel63[22:16], regChannel63[12:8], regChannel63[4:0]};


assign 
CALENABLE [3:0] = {regChannel0[31],regChannel0[23],regChannel0[15],regChannel0[7]},
CALENABLE [7:4] = {regChannel1[31],regChannel1[23],regChannel1[15],regChannel1[7]},
CALENABLE [11:8] = {regChannel2[31],regChannel2[23],regChannel2[15],regChannel2[7]},
CALENABLE [15:12] = {regChannel3[31],regChannel3[23],regChannel3[15],regChannel3[7]},
CALENABLE [19:16] = {regChannel4[31],regChannel4[23],regChannel4[15],regChannel4[7]},
CALENABLE [23:20] = {regChannel5[31],regChannel5[23],regChannel5[15],regChannel5[7]},
CALENABLE [27:24] = {regChannel6[31],regChannel6[23],regChannel6[15],regChannel6[7]},
CALENABLE [31:28] = {regChannel7[31],regChannel7[23],regChannel7[15],regChannel7[7]},
CALENABLE [35:32] = {regChannel8[31],regChannel8[23],regChannel8[15],regChannel8[7]},
CALENABLE [39:36] = {regChannel9[31],regChannel9[23],regChannel9[15],regChannel9[7]},
CALENABLE [43:40] = {regChannel10[31],regChannel10[23],regChannel10[15],regChannel10[7]},
CALENABLE [47:44] = {regChannel11[31],regChannel11[23],regChannel11[15],regChannel11[7]},
CALENABLE [51:48] = {regChannel12[31],regChannel12[23],regChannel12[15],regChannel12[7]},
CALENABLE [55:52] = {regChannel13[31],regChannel13[23],regChannel13[15],regChannel13[7]},
CALENABLE [59:56] = {regChannel14[31],regChannel14[23],regChannel14[15],regChannel14[7]},
CALENABLE [63:60] = {regChannel15[31],regChannel15[23],regChannel15[15],regChannel15[7]},
CALENABLE [67:64] = {regChannel16[31],regChannel16[23],regChannel16[15],regChannel16[7]},
CALENABLE [71:68] = {regChannel17[31],regChannel17[23],regChannel17[15],regChannel17[7]},
CALENABLE [75:72] = {regChannel18[31],regChannel18[23],regChannel18[15],regChannel18[7]},
CALENABLE [79:76] = {regChannel19[31],regChannel19[23],regChannel19[15],regChannel19[7]},
CALENABLE [83:80] = {regChannel20[31],regChannel20[23],regChannel20[15],regChannel20[7]},
CALENABLE [87:84] = {regChannel21[31],regChannel21[23],regChannel21[15],regChannel21[7]},
CALENABLE [91:88] = {regChannel22[31],regChannel22[23],regChannel22[15],regChannel22[7]},
CALENABLE [95:92] = {regChannel23[31],regChannel23[23],regChannel23[15],regChannel23[7]},
CALENABLE [99:96] = {regChannel24[31],regChannel24[23],regChannel24[15],regChannel24[7]},
CALENABLE [103:100] = {regChannel25[31],regChannel25[23],regChannel25[15],regChannel25[7]},
CALENABLE [107:104] = {regChannel26[31],regChannel26[23],regChannel26[15],regChannel26[7]},
CALENABLE [111:108] = {regChannel27[31],regChannel27[23],regChannel27[15],regChannel27[7]},
CALENABLE [115:112] = {regChannel28[31],regChannel28[23],regChannel28[15],regChannel28[7]},
CALENABLE [119:116] = {regChannel29[31],regChannel29[23],regChannel29[15],regChannel29[7]},
CALENABLE [123:120] = {regChannel30[31],regChannel30[23],regChannel30[15],regChannel30[7]},
CALENABLE [127:124] = {regChannel31[31],regChannel31[23],regChannel31[15],regChannel31[7]},
CALENABLE [131:128] = {regChannel32[31],regChannel32[23],regChannel32[15],regChannel32[7]},
CALENABLE [135:132] = {regChannel33[31],regChannel33[23],regChannel33[15],regChannel33[7]},
CALENABLE [139:136] = {regChannel34[31],regChannel34[23],regChannel34[15],regChannel34[7]},
CALENABLE [143:140] = {regChannel35[31],regChannel35[23],regChannel35[15],regChannel35[7]},
CALENABLE [147:144] = {regChannel36[31],regChannel36[23],regChannel36[15],regChannel36[7]},
CALENABLE [151:148] = {regChannel37[31],regChannel37[23],regChannel37[15],regChannel37[7]},
CALENABLE [155:152] = {regChannel38[31],regChannel38[23],regChannel38[15],regChannel38[7]},
CALENABLE [159:156] = {regChannel39[31],regChannel39[23],regChannel39[15],regChannel39[7]},
CALENABLE [163:160] = {regChannel40[31],regChannel40[23],regChannel40[15],regChannel40[7]},
CALENABLE [167:164] = {regChannel41[31],regChannel41[23],regChannel41[15],regChannel41[7]},
CALENABLE [171:168] = {regChannel42[31],regChannel42[23],regChannel42[15],regChannel42[7]},
CALENABLE [175:172] = {regChannel43[31],regChannel43[23],regChannel43[15],regChannel43[7]},
CALENABLE [179:176] = {regChannel44[31],regChannel44[23],regChannel44[15],regChannel44[7]},
CALENABLE [183:180] = {regChannel45[31],regChannel45[23],regChannel45[15],regChannel45[7]},
CALENABLE [187:184] = {regChannel46[31],regChannel46[23],regChannel46[15],regChannel46[7]},
CALENABLE [191:188] = {regChannel47[31],regChannel47[23],regChannel47[15],regChannel47[7]},
CALENABLE [195:192] = {regChannel48[31],regChannel48[23],regChannel48[15],regChannel48[7]},
CALENABLE [199:196] = {regChannel49[31],regChannel49[23],regChannel49[15],regChannel49[7]},
CALENABLE [203:200] = {regChannel50[31],regChannel50[23],regChannel50[15],regChannel50[7]},
CALENABLE [207:204] = {regChannel51[31],regChannel51[23],regChannel51[15],regChannel51[7]},
CALENABLE [211:208] = {regChannel52[31],regChannel52[23],regChannel52[15],regChannel52[7]},
CALENABLE [215:212] = {regChannel53[31],regChannel53[23],regChannel53[15],regChannel53[7]},
CALENABLE [219:216] = {regChannel54[31],regChannel54[23],regChannel54[15],regChannel54[7]},
CALENABLE [223:220] = {regChannel55[31],regChannel55[23],regChannel55[15],regChannel55[7]},
CALENABLE [227:224] = {regChannel56[31],regChannel56[23],regChannel56[15],regChannel56[7]},
CALENABLE [231:228] = {regChannel57[31],regChannel57[23],regChannel57[15],regChannel57[7]},
CALENABLE [235:232] = {regChannel58[31],regChannel58[23],regChannel58[15],regChannel54[7]},
CALENABLE [239:236] = {regChannel59[31],regChannel59[23],regChannel59[15],regChannel59[7]},
CALENABLE [243:240] = {regChannel60[31],regChannel60[23],regChannel60[15],regChannel60[7]},
CALENABLE [247:244] = {regChannel61[31],regChannel61[23],regChannel61[15],regChannel61[7]},
CALENABLE [251:248] = {regChannel62[31],regChannel62[23],regChannel62[15],regChannel62[7]},
CALENABLE [255:252] = {regChannel63[31],regChannel63[23],regChannel63[15],regChannel63[7]};

endmodule //ABC130
