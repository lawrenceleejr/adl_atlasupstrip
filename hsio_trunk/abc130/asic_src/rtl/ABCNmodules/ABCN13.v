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
 RSTB_pad,
 abcup_pad,
 padID,
 padTerm,
 padDisable_RegA,
 padDisable_RegD,
 padShuntCtrl,
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
 OP_DIR,
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
 padTESTCOM,
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
 BTG60,BTG61,BTG62,BTG63,TESTCOM
);

//FE pins
input [255:0] DIN;
output TESTCOM;
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
output OP_DIR;
`endif

output dataOutFC1_padP, dataOutFC1_padN, dataOutFC2_padP, dataOutFC2_padN;

input FastCLK_padP, FastCLK_padN; //160 or 320MHz or 640MHz clock diff-pair
input CLK_padP, CLK_padN; //80 or 160MHz clock diff-pair
input BC_padP, BC_padN;   //40 MHz machine clock 'bunch crossing clock'
input COM_LZERO_padP, COM_LZERO_padN; //serial command input port, embedded LZERO trigger on falling-edge
input LONERTHREE_padP, LONERTHREE_padN;   //Level-1 and R3 trigger code
input RSTB_pad, abcup_pad;     //asynchronous hard reset, single ended CMOS input
input [4:0] padID;      //Chip ID
input padTerm;
input padDisable_RegA, padDisable_RegD;
input padShuntCtrl;

inout XOFFL, XOFFLB;  
inout DATL, DATLB;  
inout XOFFR, XOFFRB;  
inout DATR, DATRB;

input padTESTCOM; 

//REG enable signals
PIO_INP_RAW_PULLDOWN E_RegA(.PAD(padDisable_RegA), .PT(Disable_RegA));
PIO_INP_RAW_PULLDOWN E_RegD(.PAD(padDisable_RegD), .PT(Disable_RegD));

// ShuntControl pad
DGNFETProt_Res50_PAD ShuntRegCtrl(.PAD(padShuntCtrl), .PT(ShuntControl));

// TESTCOM pad
PIO_ANA pad_TESTCOM(.PAD(padTESTCOM), .PT(TESTCOM));

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
wire Prompt;


PM_promptCell2x50u50u Prompt1 (
.out(Prompt_1), 
.b0(1'b1), 
.b1(1'b1), 
.b2(1'b1), 
.b3(1'b1)
);

PM_promptCell2x50u50u Prompt2 (
.out(Prompt_2), 
.b0(1'b1), 
.b1(1'b1), 
.b2(1'b1), 
.b3(1'b1)
);

PM_promptCell2x50u50u Prompt3 (
.out(Prompt_3), 
.b0(1'b1), 
.b1(1'b1), 
.b2(1'b1), 
.b3(1'b1)
);

assign Prompt = Prompt_1 && Prompt_2 && Prompt_3;

wire [31:0]  regADCS1, 
 regADCS2, 
 regADCS3, 
 regADCS6,
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
regChannel47
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
 .OP_DIR(OP_DIR),
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
 .RSTB_pad(RSTB_pad),
 .abcup_pad(abcup_pad),
 .Prompt(Prompt),
 //.RST_padN(RST_padN),
 // Towards FE
 .CalPulseTo(CalPulse),
 .regADCS1(regADCS1), 
 .regADCS2(regADCS2), 
 .regADCS3(regADCS3),
 .regADCS6(regADCS6), 
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
 .powerUpRstb(PwrResetb)
);

wire FRCREF, BGref;

ResOnPowABC2 PowerOnReset (
  .AnRes(PwrResetb) // Active low
);


//Digital regulator
STDVR LDOVR_A (
  .switch(Disable_RegA),
  .vref(BGrefA_Filter)
);

RC_delay_HCC RC_delay_A( 
   .IN(BGrefA), 
   .OUT(BGrefA_Filter), 
   .RegOnOff(Disable_RegA) 
);

BandGapCurrPMOSFinal_640mV_thermo16_new_names BandGap_A (
 .FRCREF (),
 .REF( BGrefA ),
 .EN_CTRL(regADCS7[31]),
// .S({regADCS7[15], regADCS7[16], regADCS7[17], regADCS7[18], regADCS7[19],
//   regADCS7[20], regADCS7[21], regADCS7[22], regADCS7[23], regADCS7[24],
//   regADCS7[25], regADCS7[26], regADCS7[27], regADCS7[28], regADCS7[29],
//   regADCS7[30]})
 .S1(regADCS7[15]),
 .S2(regADCS7[16]),
 .S3(regADCS7[17]),
 .S4(regADCS7[18]),
 .S5(regADCS7[19]),
 .S6(regADCS7[20]),
 .S7(regADCS7[21]),
 .S8(regADCS7[22]),
 .S9(regADCS7[23]),
 .S10(regADCS7[24]),
 .S11(regADCS7[25]),
 .S12(regADCS7[26]),
 .S13(regADCS7[27]),
 .S14(regADCS7[28]),
 .S15(regADCS7[29]),
 .S16(regADCS7[30])
);

//Analogue regulator
STDVR LDOVR_D (
  .switch(Disable_RegD),
  .vref(BGrefD_Filter)
);

RC_delay_HCC RC_delay_D( 
  .IN(BGrefD), 
  .OUT(BGrefD_Filter), 
  .RegOnOff(Disable_RegD)
);

BandGapCurrPMOSFinal_640mV_thermo16_new_names BandGap_D (
 .FRCREF (),
 .REF( BGrefD ),
 .EN_CTRL(regADCS6[16]),
// .S({regADCS6[0], regADCS6[1], regADCS6[2], regADCS6[3], regADCS6[4],
//   regADCS6[5], regADCS6[6], regADCS6[7], regADCS6[8], regADCS6[9],
//   regADCS6[10], regADCS6[11], regADCS6[12], regADCS6[13], regADCS6[14],
//   regADCS6[15]})
 .S1(regADCS6[0]),
 .S2(regADCS6[1]),
 .S3(regADCS6[2]),
 .S4(regADCS6[3]),
 .S5(regADCS6[4]),
 .S6(regADCS6[5]),
 .S7(regADCS6[6]),
 .S8(regADCS6[7]),
 .S9(regADCS6[8]),
 .S10(regADCS6[9]),
 .S11(regADCS6[10]),
 .S12(regADCS6[11]),
 .S13(regADCS6[12]),
 .S14(regADCS6[13]),
 .S15(regADCS6[14]),
 .S16(regADCS6[15])
);

//Shunt devices
SlaveShuntControl shunt_ctrl(
    .gushrt(vcontrol),
    .vcontrol(ShuntControl)
);

SlaveShunt_v2 shunt(
    .shuntGate(vcontrol)
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


// All CALENABLE on 8 regsisters
assign 
CALENABLE [31:0]     = {regChannel40[31:0]},
CALENABLE [63:32]    = {regChannel41[31:0]},
CALENABLE [95:64]    = {regChannel42[31:0]},
CALENABLE [127:96]   = {regChannel43[31:0]},
CALENABLE [159:128]  = {regChannel44[31:0]},
CALENABLE [191:160]  = {regChannel45[31:0]},
CALENABLE [223:192]  = {regChannel46[31:0]},
CALENABLE [255:224]  = {regChannel47[31:0]};


// BTG 0 to 7

assign BTG0[3:0]   = regChannel0[3:0];
assign BTG0[4]     = regChannel32[0];
assign BTG0[8:5]   = regChannel0[7:4];
assign BTG0[9]     = regChannel32[1];
assign BTG0[13:10] = regChannel0[11:8];
assign BTG0[14]    = regChannel32[2];
assign BTG0[18:15] = regChannel0[15:12];
assign BTG0[19]    = regChannel32[3];

assign BTG1[3:0]   = regChannel0[19:16];
assign BTG1[4]     = regChannel32[4];
assign BTG1[8:5]   = regChannel0[23:20];
assign BTG1[9]     = regChannel32[5];
assign BTG1[13:10] = regChannel0[27:24];
assign BTG1[14]    = regChannel32[6];
assign BTG1[18:15] = regChannel0[31:28];
assign BTG1[19]    = regChannel32[7];

assign BTG2[3:0]   = regChannel1[3:0];
assign BTG2[4]     = regChannel32[8];
assign BTG2[8:5]   = regChannel1[7:4];
assign BTG2[9]     = regChannel32[9];
assign BTG2[13:10] = regChannel1[11:8];
assign BTG2[14]    = regChannel32[10];
assign BTG2[18:15] = regChannel1[15:12];
assign BTG2[19]    = regChannel32[11];

assign BTG3[3:0]   = regChannel1[19:16];
assign BTG3[4]     = regChannel32[12];
assign BTG3[8:5]   = regChannel1[23:20];
assign BTG3[9]     = regChannel32[13];
assign BTG3[13:10] = regChannel1[27:24];
assign BTG3[14]    = regChannel32[14];
assign BTG3[18:15] = regChannel1[31:28];
assign BTG3[19]    = regChannel32[15];


assign BTG4[3:0]   = regChannel2[3:0];
assign BTG4[4]     = regChannel32[16];
assign BTG4[8:5]   = regChannel2[7:4];
assign BTG4[9]     = regChannel32[17];
assign BTG4[13:10] = regChannel2[11:8];
assign BTG4[14]    = regChannel32[18];
assign BTG4[18:15] = regChannel2[15:12];
assign BTG4[19]    = regChannel32[19];

assign BTG5[3:0]   = regChannel2[19:16];
assign BTG5[4]     = regChannel32[20];
assign BTG5[8:5]   = regChannel2[23:20];
assign BTG5[9]     = regChannel32[21];
assign BTG5[13:10] = regChannel2[27:24];
assign BTG5[14]    = regChannel32[22];
assign BTG5[18:15] = regChannel2[31:28];
assign BTG5[19]    = regChannel32[23];

assign BTG6[3:0]   = regChannel3[3:0];
assign BTG6[4]     = regChannel32[24];
assign BTG6[8:5]   = regChannel3[7:4];
assign BTG6[9]     = regChannel32[25];
assign BTG6[13:10] = regChannel3[11:8];
assign BTG6[14]    = regChannel32[26];
assign BTG6[18:15] = regChannel3[15:12];
assign BTG6[19]    = regChannel32[27];

assign BTG7[3:0]   = regChannel3[19:16];
assign BTG7[4]     = regChannel32[28];
assign BTG7[8:5]   = regChannel3[23:20];
assign BTG7[9]     = regChannel32[29];
assign BTG7[13:10] = regChannel3[27:24];
assign BTG7[14]    = regChannel32[30];
assign BTG7[18:15] = regChannel3[31:28];
assign BTG7[19]    = regChannel32[31];


// BTG 8 to 15

assign BTG8[3:0]   = regChannel4[3:0];
assign BTG8[4]     = regChannel33[0];
assign BTG8[8:5]   = regChannel4[7:4];
assign BTG8[9]     = regChannel33[1];
assign BTG8[13:10] = regChannel4[11:8];
assign BTG8[14]    = regChannel33[2];
assign BTG8[18:15] = regChannel4[15:12];
assign BTG8[19]    = regChannel33[3];

assign BTG9[3:0]   = regChannel4[19:16];
assign BTG9[4]     = regChannel33[4];
assign BTG9[8:5]   = regChannel4[23:20];
assign BTG9[9]     = regChannel33[5];
assign BTG9[13:10] = regChannel4[27:24];
assign BTG9[14]    = regChannel33[6];
assign BTG9[18:15] = regChannel4[31:28];
assign BTG9[19]    = regChannel33[7];

assign BTG10[3:0]   = regChannel5[3:0];
assign BTG10[4]     = regChannel33[8];
assign BTG10[8:5]   = regChannel5[7:4];
assign BTG10[9]     = regChannel33[9];
assign BTG10[13:10] = regChannel5[11:8];
assign BTG10[14]    = regChannel33[10];
assign BTG10[18:15] = regChannel5[15:12];
assign BTG10[19]    = regChannel33[11];

assign BTG11[3:0]   = regChannel5[19:16];
assign BTG11[4]     = regChannel33[12];
assign BTG11[8:5]   = regChannel5[23:20];
assign BTG11[9]     = regChannel33[13];
assign BTG11[13:10] = regChannel5[27:24];
assign BTG11[14]    = regChannel33[14];
assign BTG11[18:15] = regChannel5[31:28];
assign BTG11[19]    = regChannel33[15];


assign BTG12[3:0]   = regChannel6[3:0];
assign BTG12[4]     = regChannel33[16];
assign BTG12[8:5]   = regChannel6[7:4];
assign BTG12[9]     = regChannel33[17];
assign BTG12[13:10] = regChannel6[11:8];
assign BTG12[14]    = regChannel33[18];
assign BTG12[18:15] = regChannel6[15:12];
assign BTG12[19]    = regChannel33[19];

assign BTG13[3:0]   = regChannel6[19:16];
assign BTG13[4]     = regChannel33[20];
assign BTG13[8:5]   = regChannel6[23:20];
assign BTG13[9]     = regChannel33[21];
assign BTG13[13:10] = regChannel6[27:24];
assign BTG13[14]    = regChannel33[22];
assign BTG13[18:15] = regChannel6[31:28];
assign BTG13[19]    = regChannel33[23];

assign BTG14[3:0]   = regChannel7[3:0];
assign BTG14[4]     = regChannel33[24];
assign BTG14[8:5]   = regChannel7[7:4];
assign BTG14[9]     = regChannel33[25];
assign BTG14[13:10] = regChannel7[11:8];
assign BTG14[14]    = regChannel33[26];
assign BTG14[18:15] = regChannel7[15:12];
assign BTG14[19]    = regChannel33[27];

assign BTG15[3:0]   = regChannel7[19:16];
assign BTG15[4]     = regChannel33[28];
assign BTG15[8:5]   = regChannel7[23:20];
assign BTG15[9]     = regChannel33[29];
assign BTG15[13:10] = regChannel7[27:24];
assign BTG15[14]    = regChannel33[30];
assign BTG15[18:15] = regChannel7[31:28];
assign BTG15[19]    = regChannel33[31];




// BTG 16 to 23

assign BTG16[3:0]   = regChannel8[3:0];
assign BTG16[4]     = regChannel34[0];
assign BTG16[8:5]   = regChannel8[7:4];
assign BTG16[9]     = regChannel34[1];
assign BTG16[13:10] = regChannel8[11:8];
assign BTG16[14]    = regChannel34[2];
assign BTG16[18:15] = regChannel8[15:12];
assign BTG16[19]    = regChannel34[3];

assign BTG17[3:0]   = regChannel8[19:16];
assign BTG17[4]     = regChannel34[4];
assign BTG17[8:5]   = regChannel8[23:20];
assign BTG17[9]     = regChannel34[5];
assign BTG17[13:10] = regChannel8[27:24];
assign BTG17[14]    = regChannel34[6];
assign BTG17[18:15] = regChannel8[31:28];
assign BTG17[19]    = regChannel34[7];

assign BTG18[3:0]   = regChannel9[3:0];
assign BTG18[4]     = regChannel34[8];
assign BTG18[8:5]   = regChannel9[7:4];
assign BTG18[9]     = regChannel34[9];
assign BTG18[13:10] = regChannel9[11:8];
assign BTG18[14]    = regChannel34[10];
assign BTG18[18:15] = regChannel9[15:12];
assign BTG18[19]    = regChannel34[11];

assign BTG19[3:0]   = regChannel9[19:16];
assign BTG19[4]     = regChannel34[12];
assign BTG19[8:5]   = regChannel9[23:20];
assign BTG19[9]     = regChannel34[13];
assign BTG19[13:10] = regChannel9[27:24];
assign BTG19[14]    = regChannel34[14];
assign BTG19[18:15] = regChannel9[31:28];
assign BTG19[19]    = regChannel34[15];



assign BTG20[3:0]   = regChannel10[3:0];
assign BTG20[4]     = regChannel34[16];
assign BTG20[8:5]   = regChannel10[7:4];
assign BTG20[9]     = regChannel34[17];
assign BTG20[13:10] = regChannel10[11:8];
assign BTG20[14]    = regChannel34[18];
assign BTG20[18:15] = regChannel10[15:12];
assign BTG20[19]    = regChannel34[19];

assign BTG21[3:0]   = regChannel10[19:16];
assign BTG21[4]     = regChannel34[20];
assign BTG21[8:5]   = regChannel10[23:20];
assign BTG21[9]     = regChannel34[21];
assign BTG21[13:10] = regChannel10[27:24];
assign BTG21[14]    = regChannel34[22];
assign BTG21[18:15] = regChannel10[31:28];
assign BTG21[19]    = regChannel34[23];

assign BTG22[3:0]   = regChannel11[3:0];
assign BTG22[4]     = regChannel34[24];
assign BTG22[8:5]   = regChannel11[7:4];
assign BTG22[9]     = regChannel34[25];
assign BTG22[13:10] = regChannel11[11:8];
assign BTG22[14]    = regChannel34[26];
assign BTG22[18:15] = regChannel11[15:12];
assign BTG22[19]    = regChannel34[27];

assign BTG23[3:0]   = regChannel11[19:16];
assign BTG23[4]     = regChannel34[28];
assign BTG23[8:5]   = regChannel11[23:20];
assign BTG23[9]     = regChannel34[29];
assign BTG23[13:10] = regChannel11[27:24];
assign BTG23[14]    = regChannel34[30];
assign BTG23[18:15] = regChannel11[31:28];
assign BTG23[19]    = regChannel34[31];


// BTG 24 to 31

assign BTG24[3:0]   = regChannel12[3:0];
assign BTG24[4]     = regChannel35[0];
assign BTG24[8:5]   = regChannel12[7:4];
assign BTG24[9]     = regChannel35[1];
assign BTG24[13:10] = regChannel12[11:8];
assign BTG24[14]    = regChannel35[2];
assign BTG24[18:15] = regChannel12[15:12];
assign BTG24[19]    = regChannel35[3];

assign BTG25[3:0]   = regChannel12[19:16];
assign BTG25[4]     = regChannel35[4];
assign BTG25[8:5]   = regChannel12[23:20];
assign BTG25[9]     = regChannel35[5];
assign BTG25[13:10] = regChannel12[27:24];
assign BTG25[14]    = regChannel35[6];
assign BTG25[18:15] = regChannel12[31:28];
assign BTG25[19]    = regChannel35[7];

assign BTG26[3:0]   = regChannel13[3:0];
assign BTG26[4]     = regChannel35[8];
assign BTG26[8:5]   = regChannel13[7:4];
assign BTG26[9]     = regChannel35[9];
assign BTG26[13:10] = regChannel13[11:8];
assign BTG26[14]    = regChannel35[10];
assign BTG26[18:15] = regChannel13[15:12];
assign BTG26[19]    = regChannel35[11];

assign BTG27[3:0]   = regChannel13[19:16];
assign BTG27[4]     = regChannel35[12];
assign BTG27[8:5]   = regChannel13[23:20];
assign BTG27[9]     = regChannel35[13];
assign BTG27[13:10] = regChannel13[27:24];
assign BTG27[14]    = regChannel35[14];
assign BTG27[18:15] = regChannel13[31:28];
assign BTG27[19]    = regChannel35[15];



assign BTG28[3:0]   = regChannel14[3:0];
assign BTG28[4]     = regChannel35[16];
assign BTG28[8:5]   = regChannel14[7:4];
assign BTG28[9]     = regChannel35[17];
assign BTG28[13:10] = regChannel14[11:8];
assign BTG28[14]    = regChannel35[18];
assign BTG28[18:15] = regChannel14[15:12];
assign BTG28[19]    = regChannel35[19];

assign BTG29[3:0]   = regChannel14[19:16];
assign BTG29[4]     = regChannel35[20];
assign BTG29[8:5]   = regChannel14[23:20];
assign BTG29[9]     = regChannel35[21];
assign BTG29[13:10] = regChannel14[27:24];
assign BTG29[14]    = regChannel35[22];
assign BTG29[18:15] = regChannel14[31:28];
assign BTG29[19]    = regChannel35[23];

assign BTG30[3:0]   = regChannel15[3:0];
assign BTG30[4]     = regChannel35[24];
assign BTG30[8:5]   = regChannel15[7:4];
assign BTG30[9]     = regChannel35[25];
assign BTG30[13:10] = regChannel15[11:8];
assign BTG30[14]    = regChannel35[26];
assign BTG30[18:15] = regChannel15[15:12];
assign BTG30[19]    = regChannel35[27];

assign BTG31[3:0]   = regChannel15[19:16];
assign BTG31[4]     = regChannel35[28];
assign BTG31[8:5]   = regChannel15[23:20];
assign BTG31[9]     = regChannel35[29];
assign BTG31[13:10] = regChannel15[27:24];
assign BTG31[14]    = regChannel35[30];
assign BTG31[18:15] = regChannel15[31:28];
assign BTG31[19]    = regChannel35[31];



// BTG 32 to 39

assign BTG32[3:0]   = regChannel16[3:0];
assign BTG32[4]     = regChannel36[0];
assign BTG32[8:5]   = regChannel16[7:4];
assign BTG32[9]     = regChannel36[1];
assign BTG32[13:10] = regChannel16[11:8];
assign BTG32[14]    = regChannel36[2];
assign BTG32[18:15] = regChannel16[15:12];
assign BTG32[19]    = regChannel36[3];

assign BTG33[3:0]   = regChannel16[19:16];
assign BTG33[4]     = regChannel36[4];
assign BTG33[8:5]   = regChannel16[23:20];
assign BTG33[9]     = regChannel36[5];
assign BTG33[13:10] = regChannel16[27:24];
assign BTG33[14]    = regChannel36[6];
assign BTG33[18:15] = regChannel16[31:28];
assign BTG33[19]    = regChannel36[7];

assign BTG34[3:0]   = regChannel17[3:0];
assign BTG34[4]     = regChannel36[8];
assign BTG34[8:5]   = regChannel17[7:4];
assign BTG34[9]     = regChannel36[9];
assign BTG34[13:10] = regChannel17[11:8];
assign BTG34[14]    = regChannel36[10];
assign BTG34[18:15] = regChannel17[15:12];
assign BTG34[19]    = regChannel36[11];

assign BTG35[3:0]   = regChannel17[19:16];
assign BTG35[4]     = regChannel36[12];
assign BTG35[8:5]   = regChannel17[23:20];
assign BTG35[9]     = regChannel36[13];
assign BTG35[13:10] = regChannel17[27:24];
assign BTG35[14]    = regChannel36[14];
assign BTG35[18:15] = regChannel17[31:28];
assign BTG35[19]    = regChannel36[15];



assign BTG36[3:0]   = regChannel18[3:0];
assign BTG36[4]     = regChannel36[16];
assign BTG36[8:5]   = regChannel18[7:4];
assign BTG36[9]     = regChannel36[17];
assign BTG36[13:10] = regChannel18[11:8];
assign BTG36[14]    = regChannel36[18];
assign BTG36[18:15] = regChannel18[15:12];
assign BTG36[19]    = regChannel36[19];

assign BTG37[3:0]   = regChannel18[19:16];
assign BTG37[4]     = regChannel36[20];
assign BTG37[8:5]   = regChannel18[23:20];
assign BTG37[9]     = regChannel36[21];
assign BTG37[13:10] = regChannel18[27:24];
assign BTG37[14]    = regChannel36[22];
assign BTG37[18:15] = regChannel18[31:28];
assign BTG37[19]    = regChannel36[23];

assign BTG38[3:0]   = regChannel19[3:0];
assign BTG38[4]     = regChannel36[24];
assign BTG38[8:5]   = regChannel19[7:4];
assign BTG38[9]     = regChannel36[25];
assign BTG38[13:10] = regChannel19[11:8];
assign BTG38[14]    = regChannel36[26];
assign BTG38[18:15] = regChannel19[15:12];
assign BTG38[19]    = regChannel36[27];

assign BTG39[3:0]   = regChannel19[19:16];
assign BTG39[4]     = regChannel36[28];
assign BTG39[8:5]   = regChannel19[23:20];
assign BTG39[9]     = regChannel36[29];
assign BTG39[13:10] = regChannel19[27:24];
assign BTG39[14]    = regChannel36[30];
assign BTG39[18:15] = regChannel19[31:28];
assign BTG39[19]    = regChannel36[31];



// BTG 40 to 47

assign BTG40[3:0]   = regChannel20[3:0];
assign BTG40[4]     = regChannel37[0];
assign BTG40[8:5]   = regChannel20[7:4];
assign BTG40[9]     = regChannel37[1];
assign BTG40[13:10] = regChannel20[11:8];
assign BTG40[14]    = regChannel37[2];
assign BTG40[18:15] = regChannel20[15:12];
assign BTG40[19]    = regChannel37[3];

assign BTG41[3:0]   = regChannel20[19:16];
assign BTG41[4]     = regChannel37[4];
assign BTG41[8:5]   = regChannel20[23:20];
assign BTG41[9]     = regChannel37[5];
assign BTG41[13:10] = regChannel20[27:24];
assign BTG41[14]    = regChannel37[6];
assign BTG41[18:15] = regChannel20[31:28];
assign BTG41[19]    = regChannel37[7];

assign BTG42[3:0]   = regChannel21[3:0];
assign BTG42[4]     = regChannel37[8];
assign BTG42[8:5]   = regChannel21[7:4];
assign BTG42[9]     = regChannel37[9];
assign BTG42[13:10] = regChannel21[11:8];
assign BTG42[14]    = regChannel37[10];
assign BTG42[18:15] = regChannel21[15:12];
assign BTG42[19]    = regChannel37[11];

assign BTG43[3:0]   = regChannel21[19:16];
assign BTG43[4]     = regChannel37[12];
assign BTG43[8:5]   = regChannel21[23:20];
assign BTG43[9]     = regChannel37[13];
assign BTG43[13:10] = regChannel21[27:24];
assign BTG43[14]    = regChannel37[14];
assign BTG43[18:15] = regChannel21[31:28];
assign BTG43[19]    = regChannel37[15];



assign BTG44[3:0]   = regChannel22[3:0];
assign BTG44[4]     = regChannel37[16];
assign BTG44[8:5]   = regChannel22[7:4];
assign BTG44[9]     = regChannel37[17];
assign BTG44[13:10] = regChannel22[11:8];
assign BTG44[14]    = regChannel37[18];
assign BTG44[18:15] = regChannel22[15:12];
assign BTG44[19]    = regChannel37[19];

assign BTG45[3:0]   = regChannel22[19:16];
assign BTG45[4]     = regChannel37[20];
assign BTG45[8:5]   = regChannel22[23:20];
assign BTG45[9]     = regChannel37[21];
assign BTG45[13:10] = regChannel22[27:24];
assign BTG45[14]    = regChannel37[22];
assign BTG45[18:15] = regChannel22[31:28];
assign BTG45[19]    = regChannel37[23];

assign BTG46[3:0]   = regChannel23[3:0];
assign BTG46[4]     = regChannel37[24];
assign BTG46[8:5]   = regChannel23[7:4];
assign BTG46[9]     = regChannel37[25];
assign BTG46[13:10] = regChannel23[11:8];
assign BTG46[14]    = regChannel37[26];
assign BTG46[18:15] = regChannel23[15:12];
assign BTG46[19]    = regChannel37[27];

assign BTG47[3:0]   = regChannel23[19:16];
assign BTG47[4]     = regChannel37[28];
assign BTG47[8:5]   = regChannel23[23:20];
assign BTG47[9]     = regChannel37[29];
assign BTG47[13:10] = regChannel23[27:24];
assign BTG47[14]    = regChannel37[30];
assign BTG47[18:15] = regChannel23[31:28];
assign BTG47[19]    = regChannel37[31];



// BTG 48 to 55

assign BTG48[3:0]   = regChannel24[3:0];
assign BTG48[4]     = regChannel38[0];
assign BTG48[8:5]   = regChannel24[7:4];
assign BTG48[9]     = regChannel38[1];
assign BTG48[13:10] = regChannel24[11:8];
assign BTG48[14]    = regChannel38[2];
assign BTG48[18:15] = regChannel24[15:12];
assign BTG48[19]    = regChannel38[3];

assign BTG49[3:0]   = regChannel24[19:16];
assign BTG49[4]     = regChannel38[4];
assign BTG49[8:5]   = regChannel24[23:20];
assign BTG49[9]     = regChannel38[5];
assign BTG49[13:10] = regChannel24[27:24];
assign BTG49[14]    = regChannel38[6];
assign BTG49[18:15] = regChannel24[31:28];
assign BTG49[19]    = regChannel38[7];

assign BTG50[3:0]   = regChannel25[3:0];
assign BTG50[4]     = regChannel38[8];
assign BTG50[8:5]   = regChannel25[7:4];
assign BTG50[9]     = regChannel38[9];
assign BTG50[13:10] = regChannel25[11:8];
assign BTG50[14]    = regChannel38[10];
assign BTG50[18:15] = regChannel25[15:12];
assign BTG50[19]    = regChannel38[11];

assign BTG51[3:0]   = regChannel25[19:16];
assign BTG51[4]     = regChannel38[12];
assign BTG51[8:5]   = regChannel25[23:20];
assign BTG51[9]     = regChannel38[13];
assign BTG51[13:10] = regChannel25[27:24];
assign BTG51[14]    = regChannel38[14];
assign BTG51[18:15] = regChannel25[31:28];
assign BTG51[19]    = regChannel38[15];



assign BTG52[3:0]   = regChannel26[3:0];
assign BTG52[4]     = regChannel38[16];
assign BTG52[8:5]   = regChannel26[7:4];
assign BTG52[9]     = regChannel38[17];
assign BTG52[13:10] = regChannel26[11:8];
assign BTG52[14]    = regChannel38[18];
assign BTG52[18:15] = regChannel26[15:12];
assign BTG52[19]    = regChannel38[19];

assign BTG53[3:0]   = regChannel26[19:16];
assign BTG53[4]     = regChannel38[20];
assign BTG53[8:5]   = regChannel26[23:20];
assign BTG53[9]     = regChannel38[21];
assign BTG53[13:10] = regChannel26[27:24];
assign BTG53[14]    = regChannel38[22];
assign BTG53[18:15] = regChannel26[31:28];
assign BTG53[19]    = regChannel38[23];

assign BTG54[3:0]   = regChannel27[3:0];
assign BTG54[4]     = regChannel38[24];
assign BTG54[8:5]   = regChannel27[7:4];
assign BTG54[9]     = regChannel38[25];
assign BTG54[13:10] = regChannel27[11:8];
assign BTG54[14]    = regChannel38[26];
assign BTG54[18:15] = regChannel27[15:12];
assign BTG54[19]    = regChannel38[27];

assign BTG55[3:0]   = regChannel27[19:16];
assign BTG55[4]     = regChannel38[28];
assign BTG55[8:5]   = regChannel27[23:20];
assign BTG55[9]     = regChannel38[29];
assign BTG55[13:10] = regChannel27[27:24];
assign BTG55[14]    = regChannel38[30];
assign BTG55[18:15] = regChannel27[31:28];
assign BTG55[19]    = regChannel38[31];


// BTG 48 to 55

assign BTG56[3:0]   = regChannel28[3:0];
assign BTG56[4]     = regChannel39[0];
assign BTG56[8:5]   = regChannel28[7:4];
assign BTG56[9]     = regChannel39[1];
assign BTG56[13:10] = regChannel28[11:8];
assign BTG56[14]    = regChannel39[2];
assign BTG56[18:15] = regChannel28[15:12];
assign BTG56[19]    = regChannel39[3];

assign BTG57[3:0]   = regChannel28[19:16];
assign BTG57[4]     = regChannel39[4];
assign BTG57[8:5]   = regChannel28[23:20];
assign BTG57[9]     = regChannel39[5];
assign BTG57[13:10] = regChannel28[27:24];
assign BTG57[14]    = regChannel39[6];
assign BTG57[18:15] = regChannel28[31:28];
assign BTG57[19]    = regChannel39[7];

assign BTG58[3:0]   = regChannel29[3:0];
assign BTG58[4]     = regChannel39[8];
assign BTG58[8:5]   = regChannel29[7:4];
assign BTG58[9]     = regChannel39[9];
assign BTG58[13:10] = regChannel29[11:8];
assign BTG58[14]    = regChannel39[10];
assign BTG58[18:15] = regChannel29[15:12];
assign BTG58[19]    = regChannel39[11];

assign BTG59[3:0]   = regChannel29[19:16];
assign BTG59[4]     = regChannel39[12];
assign BTG59[8:5]   = regChannel29[23:20];
assign BTG59[9]     = regChannel39[13];
assign BTG59[13:10] = regChannel29[27:24];
assign BTG59[14]    = regChannel39[14];
assign BTG59[18:15] = regChannel29[31:28];
assign BTG59[19]    = regChannel39[15];



assign BTG60[3:0]   = regChannel30[3:0];
assign BTG60[4]     = regChannel39[16];
assign BTG60[8:5]   = regChannel30[7:4];
assign BTG60[9]     = regChannel39[17];
assign BTG60[13:10] = regChannel30[11:8];
assign BTG60[14]    = regChannel39[18];
assign BTG60[18:15] = regChannel30[15:12];
assign BTG60[19]    = regChannel39[19];

assign BTG61[3:0]   = regChannel30[19:16];
assign BTG61[4]     = regChannel39[20];
assign BTG61[8:5]   = regChannel30[23:20];
assign BTG61[9]     = regChannel39[21];
assign BTG61[13:10] = regChannel30[27:24];
assign BTG61[14]    = regChannel39[22];
assign BTG61[18:15] = regChannel30[31:28];
assign BTG61[19]    = regChannel39[23];

assign BTG62[3:0]   = regChannel31[3:0];
assign BTG62[4]     = regChannel39[24];
assign BTG62[8:5]   = regChannel31[7:4];
assign BTG62[9]     = regChannel39[25];
assign BTG62[13:10] = regChannel31[11:8];
assign BTG62[14]    = regChannel39[26];
assign BTG62[18:15] = regChannel31[15:12];
assign BTG62[19]    = regChannel39[27];

assign BTG63[3:0]   = regChannel31[19:16];
assign BTG63[4]     = regChannel39[28];
assign BTG63[8:5]   = regChannel31[23:20];
assign BTG63[9]     = regChannel39[29];
assign BTG63[13:10] = regChannel31[27:24];
assign BTG63[14]    = regChannel39[30];
assign BTG63[18:15] = regChannel31[31:28];
assign BTG63[19]    = regChannel39[31];


/* Old fashion
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
*/
endmodule //ABC130
