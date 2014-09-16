`timescale 1ns/1ps
module ABCN13_DIG (
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
//data from the detector
 DIN,
//bottom edge signals
 CLK_padP,
 CLK_padN,
 BC_padP,
 BC_padN,
 COM_LZERO_padP, 
 COM_LZERO_padN,
 LONERTHREE_padP,
 LONERTHREE_padN,
 //right edge signals
 padID,
 padTerm,
 FastCLK_padP,
 FastCLK_padN,
 XOFFL,
 XOFFLB,
 DATL,
 DATLB,
 XOFFR,
 XOFFRB,
 DATR,
 DATRB,
 dataOutFC1_padP,
 dataOutFC1_padN,
 dataOutFC2_padP,
 dataOutFC2_padN,
 //top edge signals
 RSTB_pad,
 abcup_pad,
 Prompt,
// RST_padN,
// Towards FE
 CalPulseTo,
 regADCS1, 
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
regChannel47, 
// from Power circuit
powerUpRstb
);

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
//assign L1_DCL_packet[50:0] = l1_dcl_data[50:0];
//assign R3_DCL_PCKT_o[50:0] = r3_dcl_data[50:0];
//assign L1_DCL_Mcluster = mcluster;
//assign R3_DCL_fifowr = R3_DCL_FIFO_wr;
`endif

output dataOutFC1_padP, dataOutFC1_padN, dataOutFC2_padP, dataOutFC2_padN;

input FastCLK_padP, FastCLK_padN; //160 or 320MHz or 640MHz clock diff-pair
input CLK_padP, CLK_padN; //80 or 160MHz clock diff-pair
input BC_padP, BC_padN;   //40 MHz machine clock 'bunch crossing clock'
input COM_LZERO_padP, COM_LZERO_padN; //serial command input port, embedded LZERO trigger on falling-edge
input LONERTHREE_padP, LONERTHREE_padN;   //Level-1 and R3 trigger code
input RSTB_pad;     //asynchronous hard reset
input Prompt;
input abcup_pad;
input [4:0] padID;      //Chip ID
input padTerm;
input [255:0] DIN;    //Strip Data

inout XOFFL, XOFFLB;  
inout DATL, DATLB;  
inout XOFFR, XOFFRB;  
inout DATR, DATRB;  

output CalPulseTo;
//register output buses  //likely to get renamed
output [31:0] regADCS1, regADCS2, regADCS3, regADCS6, regADCS7;
wire [31:0] regInput0, regInput1, regInput2, regInput3;
wire [31:0] regInput4, regInput5, regInput6, regInput7;
wire [31:0] regConfig0, regConfig1, regConfig2, regConfig3;
output [31:0] regChannel0, regChannel1, regChannel2, regChannel3, regChannel4;
output [31:0] regChannel5, regChannel6, regChannel7, regChannel8, regChannel9;
output [31:0] regChannel10, regChannel11, regChannel12, regChannel13, regChannel14;
output [31:0] regChannel15, regChannel16, regChannel17, regChannel18, regChannel19;
output [31:0] regChannel20, regChannel21, regChannel22, regChannel23, regChannel24;
output [31:0] regChannel25, regChannel26, regChannel27, regChannel28, regChannel29;
output [31:0] regChannel30, regChannel31, regChannel32, regChannel33, regChannel34;
output [31:0] regChannel35, regChannel36, regChannel37, regChannel38, regChannel39;
output [31:0] regChannel40, regChannel41, regChannel42, regChannel43, regChannel44;
output [31:0] regChannel45, regChannel46, regChannel47;

input powerUpRstb;

wire FastCLK;
wire CLK;
wire BC;
wire COM;
wire RSTB;
wire LZERO;
wire LONERTHREE;

//wire RSTB = ~RST;

wire [7:0] BCID;
wire [6:0] ID; //internal chip ID field

//receive differential signals

PIO_REC160 padFastCLK(
   .TERM(TERM),
	.out(FastCLK),
	.LVDS_P(FastCLK_padP),
	.LVDS_N(FastCLK_padN)
	);
PIO_REC160 padCLK(
   .TERM(TERM),
	.out(CLK),
	.LVDS_P(CLK_padP),
	.LVDS_N(CLK_padN)
	);
PIO_REC160 padBC(
   .TERM(TERM),
	.out(BC),
	.LVDS_P(BC_padP),
	.LVDS_N(BC_padN)
	);
PIO_REC160 padCOM_L0(
   .TERM(TERM),
	.out(COM_L0),
	.LVDS_P(COM_LZERO_padP),
	.LVDS_N(COM_LZERO_padN)
	);
PIO_INP padRSTB(.PAD(RSTB_pad), .PT(RSTB));
PIO_INP_PD padabcup(.PAD(abcup_pad), .PT(abcup));
	
PIO_REC160 padL1_R3(
   .TERM(TERM),
	.out(LONERTHREE),
	.LVDS_P(LONERTHREE_padP),
	.LVDS_N(LONERTHREE_padN)
	);
	
//receive SE signals
PIO_INP padID0(.PAD(padID[0]), .PT(ID[0]));
PIO_INP padID1(.PAD(padID[1]), .PT(ID[1]));
PIO_INP padID2(.PAD(padID[2]), .PT(ID[2]));
PIO_INP padID3(.PAD(padID[3]), .PT(ID[3]));
PIO_INP padID4(.PAD(padID[4]), .PT(ID[4]));

//TERM signal
PIO_INP_PD padTERM(.PAD(padTerm), .PT(TERM));

wire hardRstb;

dmux dmuxCOM_L0(
  .clk ( BC ),
  .rstb ( hardRstb ),
  .in ( COM_L0 ),
  .outR ( COM ),
  .outF ( LZERO )
);

dmux dmuxCOM_L1R3(
  .clk ( BC ),
  .rstb ( hardRstb ),
  .in ( LONERTHREE ),
  .outR ( LONE ),
  .outF ( RTHREE )
);

wire syncRstb;
  wire zero;
  assign zero = {1'b0};
  wire one;
  assign one = {1'b1};

////FC signals outputs
PIO_DRV160 padFC1(.in(dataOutFC1), .cur0(regConfig1[8]), .cur1(regConfig1[9]), .cur2(regConfig1[10]), .LVDS_P(dataOutFC1_padP), .LVDS_N(dataOutFC1_padN));
PIO_DRV160 padFC2(.in(dataOutFC2), .cur0(regConfig1[8]), .cur1(regConfig1[9]), .cur2(regConfig1[10]), .LVDS_P(dataOutFC2_padP), .LVDS_N(dataOutFC2_padN));
  
//generate a reset signal in response to 32 consecutive L1, R3
wire tgRstb;
triggerGeneratedReset tgr(
  .BC (BC),
  .syncRstb (syncRstb),
  .LONE (LONE),
  .RTHREE (RTHREE),
  .tgRstb (tgRstb)
);   

//the mask register
wire [255:0] masked_dIn;  
wire [255:0] diagnostic;  //these don't go anywhere at the moment
wire EvtBufRstb;
pipeLineEntry pipeLineEntry(
  .stripData (DIN),
  .maskBits( {regInput7, regInput6, regInput5, regInput4, regInput3, regInput2, regInput1, regInput0}),
  .BCID (BCID), 
  .BCclk (BC), 
  .hrdrstb (syncRstb & EvtBufRstb),
  .mode ( regConfig0[17:16]),
  .pipeLine(masked_dIn),
  .diagnostic ( diagnostic)
);


FCF_top FCF1(
	.inputFrntEnd(masked_dIn), 
	.BCclk(BC), 
	.fs_clk(FastCLK),  
	.reset_n(syncRstb && FCRstb),
	.control(regConfig0[29:28]),
	.data_out1(dataOutFC1), 
	.data_out2(dataOutFC2)
	);
//assign dataOutFC1 = 1'b0;
//assign dataOutFC2 = 1'b0;


//assign powerUpRstb = 1'b1;

//the command/control serial interface & decode register
//decodes the Chip modes, command-driven events, and register accesses
//from the serial command port

wire  L0, L1, BCreset, SEUreset;

wire com_int;

wire shiftInputReg0, loadInputReg0, unloadInputReg0;
wire shiftInputReg1, loadInputReg1, unloadInputReg1;
wire shiftInputReg2, loadInputReg2, unloadInputReg2;
wire shiftInputReg3, loadInputReg3, unloadInputReg3;

wire shiftConfigReg0, loadConfigReg0, unloadConfigReg0;
wire shiftConfigReg1, loadConfigReg1, unloadConfigReg1;
wire shiftConfigReg2, loadConfigReg2, unloadConfigReg2;
wire shiftConfigReg3, loadConfigReg3, unloadConfigReg3;

wire [31:0] regReadVal;  //register read value from commandControl to readOut
wire        regReadPush; //push a register read value into the readOut
wire [6:0]  registerAddress; //commandControl reports address of register being read for readOut to add to reg-read packet
wire regWriteDisable;
wire [7:0]  L0ID_Local;

commandControl commandControl (
  .clk (BC),  //slow clock
  .clk1 (BC),  //slow clock
  .clk2 (BC),  //slow clock
  .bclk (BC), //not used, needed for synthesis
  .abcup (abcup),
  .rstb (RSTB),			//i reset pin
  .powerUpRstb (powerUpRstb),	//i power-on reset
  .tgRstb (tgRstb),       // Trigger generated Reset
  .Prompt (Prompt),	        
  .com (COM),
  .com_int (com_int),
  .id (ID[4:0]),
  //various events
  .syncRstb (syncRstb),		//o  command-generated reset, synchronous
  .hardRstb (hardRstb),	        //o  pad-reset plus power-on-reset, asynchronous
  .BCreset (BCreset),
  .FCRstb (FCRstb),
  .SEUreset (SEUreset),
  .L0IDpreset (L0IDreset),
  .EvtBufRstb (EvtBufRstb),
  .hardL0 (LZERO),   //from pads
  .hardL1 (LONE),
  .hardR3 (RTHREE),
  .regWriteDisable (regWriteDisable),
  .L0mode ( regConfig0[5] ),
  .SCReg(SCReg0),
  .shiftSCReg(shiftSCReg), .loadSCReg(loadSCReg), .unloadSCReg(unloadSCReg),    //special command register controls
  //register read, write controls
  .regReadVal ( regReadVal),
  .regReadPush  ( regReadPush),
  .registerAddress ( registerAddress ),
  .shiftADCSReg1 (shiftADCSReg1), .loadADCSReg1 (loadADCSReg1), .unloadADCSReg1 (unloadADCSReg1),      
  .shiftADCSReg2 (shiftADCSReg2), .loadADCSReg2 (loadADCSReg2), .unloadADCSReg2 (unloadADCSReg2),      
  .shiftADCSReg3 (shiftADCSReg3), .loadADCSReg3 (loadADCSReg3), .unloadADCSReg3 (unloadADCSReg3),      
  .shiftADCSReg6 (shiftADCSReg6), .loadADCSReg6 (loadADCSReg6), .unloadADCSReg6 (unloadADCSReg6),    
  .shiftADCSReg7 (shiftADCSReg7), .loadADCSReg7 (loadADCSReg7), .unloadADCSReg7 (unloadADCSReg7),      
  .shiftInputReg0 (shiftInputReg0), .loadInputReg0 (loadInputReg0), .unloadInputReg0 (unloadInputReg0),      
  .shiftInputReg1 (shiftInputReg1), .loadInputReg1 (loadInputReg1), .unloadInputReg1 (unloadInputReg1),      
  .shiftInputReg2 (shiftInputReg2), .loadInputReg2 (loadInputReg2), .unloadInputReg2 (unloadInputReg2),      
  .shiftInputReg3 (shiftInputReg3), .loadInputReg3 (loadInputReg3), .unloadInputReg3 (unloadInputReg3),      
  .shiftInputReg4 (shiftInputReg4), .loadInputReg4 (loadInputReg4), .unloadInputReg4 (unloadInputReg4),      
  .shiftInputReg5 (shiftInputReg5), .loadInputReg5 (loadInputReg5), .unloadInputReg5 (unloadInputReg5),      
  .shiftInputReg6 (shiftInputReg6), .loadInputReg6 (loadInputReg6), .unloadInputReg6 (unloadInputReg6),      
  .shiftInputReg7 (shiftInputReg7), .loadInputReg7 (loadInputReg7), .unloadInputReg7 (unloadInputReg7),      
  .shiftInputReg8 (shiftInputReg8), .unloadInputReg8 (unloadInputReg8),      
  .shiftInputReg9 (shiftInputReg9), .unloadInputReg9 (unloadInputReg9), 
  .shiftInputReg10 (shiftInputReg10), .unloadInputReg10 (unloadInputReg10),      
  .shiftInputReg11 (shiftInputReg11), .unloadInputReg11 (unloadInputReg11),      
  .shiftInputReg12 (shiftInputReg12), .unloadInputReg12 (unloadInputReg12),      
  .shiftInputReg13 (shiftInputReg13), .unloadInputReg13 (unloadInputReg13),      
  .shiftInputReg14 (shiftInputReg14), .unloadInputReg14 (unloadInputReg14),      
  .shiftInputReg15 (shiftInputReg15), .unloadInputReg15 (unloadInputReg15),      
  .shiftStatusReg0 (shiftStatusReg0), .unloadStatusReg0 (unloadStatusReg0),      
  .shiftStatusReg1 (shiftStatusReg1), .unloadStatusReg1 (unloadStatusReg1),      
  .shiftStatusReg2 (shiftStatusReg2), .unloadStatusReg2 (unloadStatusReg2),      
  .shiftStatusReg3 (shiftStatusReg3), .unloadStatusReg3 (unloadStatusReg3),      
  .shiftConfigReg0 (shiftConfigReg0), .loadConfigReg0 (loadConfigReg0), .unloadConfigReg0 (unloadConfigReg0),      
  .shiftConfigReg1 (shiftConfigReg1), .loadConfigReg1 (loadConfigReg1), .unloadConfigReg1 (unloadConfigReg1),      
  .shiftConfigReg2 (shiftConfigReg2), .loadConfigReg2 (loadConfigReg2), .unloadConfigReg2 (unloadConfigReg2),      
  .shiftConfigReg3 (shiftConfigReg3), .loadConfigReg3 (loadConfigReg3), .unloadConfigReg3 (unloadConfigReg3),      
  .shiftChannelReg0 (shiftChannelReg0), .loadChannelReg0 (loadChannelReg0), .unloadChannelReg0 (unloadChannelReg0),      
  .shiftChannelReg1 (shiftChannelReg1), .loadChannelReg1 (loadChannelReg1), .unloadChannelReg1 (unloadChannelReg1),      
  .shiftChannelReg2 (shiftChannelReg2), .loadChannelReg2 (loadChannelReg2), .unloadChannelReg2 (unloadChannelReg2),      
  .shiftChannelReg3 (shiftChannelReg3), .loadChannelReg3 (loadChannelReg3), .unloadChannelReg3 (unloadChannelReg3),      
  .shiftChannelReg4 (shiftChannelReg4), .loadChannelReg4 (loadChannelReg4), .unloadChannelReg4 (unloadChannelReg4),      
  .shiftChannelReg5 (shiftChannelReg5), .loadChannelReg5 (loadChannelReg5), .unloadChannelReg5 (unloadChannelReg5),      
  .shiftChannelReg6 (shiftChannelReg6), .loadChannelReg6 (loadChannelReg6), .unloadChannelReg6 (unloadChannelReg6),      
  .shiftChannelReg7 (shiftChannelReg7), .loadChannelReg7 (loadChannelReg7), .unloadChannelReg7 (unloadChannelReg7),      
  .shiftChannelReg8 (shiftChannelReg8), .loadChannelReg8 (loadChannelReg8), .unloadChannelReg8 (unloadChannelReg8),      
  .shiftChannelReg9 (shiftChannelReg9), .loadChannelReg9 (loadChannelReg9), .unloadChannelReg9 (unloadChannelReg9),      
  .shiftChannelReg10 (shiftChannelReg10), .loadChannelReg10 (loadChannelReg10), .unloadChannelReg10 (unloadChannelReg10),      
  .shiftChannelReg11 (shiftChannelReg11), .loadChannelReg11 (loadChannelReg11), .unloadChannelReg11 (unloadChannelReg11),      
  .shiftChannelReg12 (shiftChannelReg12), .loadChannelReg12 (loadChannelReg12), .unloadChannelReg12 (unloadChannelReg12),      
  .shiftChannelReg13 (shiftChannelReg13), .loadChannelReg13 (loadChannelReg13), .unloadChannelReg13 (unloadChannelReg13),      
  .shiftChannelReg14 (shiftChannelReg14), .loadChannelReg14 (loadChannelReg14), .unloadChannelReg14 (unloadChannelReg14),      
  .shiftChannelReg15 (shiftChannelReg15), .loadChannelReg15 (loadChannelReg15), .unloadChannelReg15 (unloadChannelReg15),      
  .shiftChannelReg16 (shiftChannelReg16), .loadChannelReg16 (loadChannelReg16), .unloadChannelReg16 (unloadChannelReg16),      
  .shiftChannelReg17 (shiftChannelReg17), .loadChannelReg17 (loadChannelReg17), .unloadChannelReg17 (unloadChannelReg17),      
  .shiftChannelReg18 (shiftChannelReg18), .loadChannelReg18 (loadChannelReg18), .unloadChannelReg18 (unloadChannelReg18),      
  .shiftChannelReg19 (shiftChannelReg19), .loadChannelReg19 (loadChannelReg19), .unloadChannelReg19 (unloadChannelReg19),      
  .shiftChannelReg20 (shiftChannelReg20), .loadChannelReg20 (loadChannelReg20), .unloadChannelReg20 (unloadChannelReg20),      
  .shiftChannelReg21 (shiftChannelReg21), .loadChannelReg21 (loadChannelReg21), .unloadChannelReg21 (unloadChannelReg21),      
  .shiftChannelReg22 (shiftChannelReg22), .loadChannelReg22 (loadChannelReg22), .unloadChannelReg22 (unloadChannelReg22),      
  .shiftChannelReg23 (shiftChannelReg23), .loadChannelReg23 (loadChannelReg23), .unloadChannelReg23 (unloadChannelReg23),      
  .shiftChannelReg24 (shiftChannelReg24), .loadChannelReg24 (loadChannelReg24), .unloadChannelReg24 (unloadChannelReg24),      
  .shiftChannelReg25 (shiftChannelReg25), .loadChannelReg25 (loadChannelReg25), .unloadChannelReg25 (unloadChannelReg25),      
  .shiftChannelReg26 (shiftChannelReg26), .loadChannelReg26 (loadChannelReg26), .unloadChannelReg26 (unloadChannelReg26),      
  .shiftChannelReg27 (shiftChannelReg27), .loadChannelReg27 (loadChannelReg27), .unloadChannelReg27 (unloadChannelReg27),      
  .shiftChannelReg28 (shiftChannelReg28), .loadChannelReg28 (loadChannelReg28), .unloadChannelReg28 (unloadChannelReg28),      
  .shiftChannelReg29 (shiftChannelReg29), .loadChannelReg29 (loadChannelReg29), .unloadChannelReg29 (unloadChannelReg29),      
  .shiftChannelReg30 (shiftChannelReg30), .loadChannelReg30 (loadChannelReg30), .unloadChannelReg30 (unloadChannelReg30),      
  .shiftChannelReg31 (shiftChannelReg31), .loadChannelReg31 (loadChannelReg31), .unloadChannelReg31 (unloadChannelReg31),      
  .shiftChannelReg32 (shiftChannelReg32), .loadChannelReg32 (loadChannelReg32), .unloadChannelReg32 (unloadChannelReg32),      
  .shiftChannelReg33 (shiftChannelReg33), .loadChannelReg33 (loadChannelReg33), .unloadChannelReg33 (unloadChannelReg33),      
  .shiftChannelReg34 (shiftChannelReg34), .loadChannelReg34 (loadChannelReg34), .unloadChannelReg34 (unloadChannelReg34),      
  .shiftChannelReg35 (shiftChannelReg35), .loadChannelReg35 (loadChannelReg35), .unloadChannelReg35 (unloadChannelReg35),      
  .shiftChannelReg36 (shiftChannelReg36), .loadChannelReg36 (loadChannelReg36), .unloadChannelReg36 (unloadChannelReg36),      
  .shiftChannelReg37 (shiftChannelReg37), .loadChannelReg37 (loadChannelReg37), .unloadChannelReg37 (unloadChannelReg37),      
  .shiftChannelReg38 (shiftChannelReg38), .loadChannelReg38 (loadChannelReg38), .unloadChannelReg38 (unloadChannelReg38),      
  .shiftChannelReg39 (shiftChannelReg39), .loadChannelReg39 (loadChannelReg39), .unloadChannelReg39 (unloadChannelReg39),      
  .shiftChannelReg40 (shiftChannelReg40), .loadChannelReg40 (loadChannelReg40), .unloadChannelReg40 (unloadChannelReg40),      
  .shiftChannelReg41 (shiftChannelReg41), .loadChannelReg41 (loadChannelReg41), .unloadChannelReg41 (unloadChannelReg41),      
  .shiftChannelReg42 (shiftChannelReg42), .loadChannelReg42 (loadChannelReg42), .unloadChannelReg42 (unloadChannelReg42),      
  .shiftChannelReg43 (shiftChannelReg43), .loadChannelReg43 (loadChannelReg43), .unloadChannelReg43 (unloadChannelReg43),      
  .shiftChannelReg44 (shiftChannelReg44), .loadChannelReg44 (loadChannelReg44), .unloadChannelReg44 (unloadChannelReg44),      
  .shiftChannelReg45 (shiftChannelReg45), .loadChannelReg45 (loadChannelReg45), .unloadChannelReg45 (unloadChannelReg45),      
  .shiftChannelReg46 (shiftChannelReg46), .loadChannelReg46 (loadChannelReg46), .unloadChannelReg46 (unloadChannelReg46),      
  .shiftChannelReg47 (shiftChannelReg47), .loadChannelReg47 (loadChannelReg47), .unloadChannelReg47 (unloadChannelReg47),      
   //register returns
  .ADCSreg1( ADCSreg1), .ADCSreg2( ADCSreg2),.ADCSreg3( ADCSreg3),.ADCSreg6( ADCSreg6),.ADCSreg7( ADCSreg7),
  .Ireg0 (Ireg0), .Ireg1 (Ireg1), .Ireg2 (Ireg2), .Ireg3(Ireg3),
  .Ireg4 (Ireg4), .Ireg5 (Ireg5), .Ireg6 (Ireg6), .Ireg7(Ireg7),
  .Ireg8 (Ireg8), .Ireg9 (Ireg9), .Ireg10 (Ireg10), .Ireg11(Ireg11),
  .Ireg12 (Ireg12), .Ireg13 (Ireg13), .Ireg14 (Ireg14), .Ireg15(Ireg15),
  .STATUSreg0 (STATUSreg0), .STATUSreg1 (STATUSreg1), .STATUSreg2 (STATUSreg2), .STATUSreg3 (STATUSreg3),
  .Creg0 (Creg0), .Creg1 (Creg1), .Creg2 (Creg2), .Creg3(Creg3),
  .CHreg0 (CHreg0), .CHreg1 (CHreg1), .CHreg2 (CHreg2), .CHreg3(CHreg3), .CHreg4(CHreg4),
  .CHreg5 (CHreg5), .CHreg6 (CHreg6), .CHreg7 (CHreg7), .CHreg8(CHreg8), .CHreg9(CHreg9),
  .CHreg10 (CHreg10), .CHreg11 (CHreg11), .CHreg12 (CHreg12), .CHreg13(CHreg13), .CHreg14(CHreg14),
  .CHreg15 (CHreg15), .CHreg16 (CHreg16), .CHreg17 (CHreg17), .CHreg18(CHreg18), .CHreg19(CHreg19),
  .CHreg20 (CHreg20), .CHreg21 (CHreg21), .CHreg22 (CHreg22), .CHreg23(CHreg23), .CHreg24(CHreg24),
  .CHreg25 (CHreg25), .CHreg26 (CHreg26), .CHreg27 (CHreg27), .CHreg28(CHreg28), .CHreg29(CHreg29),
  .CHreg30 (CHreg30), .CHreg31 (CHreg31), .CHreg32 (CHreg32), .CHreg33(CHreg33), .CHreg34(CHreg34),
  .CHreg35 (CHreg35), .CHreg36 (CHreg36), .CHreg37 (CHreg37), .CHreg38(CHreg38), .CHreg39(CHreg39),
  .CHreg40 (CHreg40), .CHreg41 (CHreg41), .CHreg42 (CHreg42), .CHreg43(CHreg43), .CHreg44(CHreg44),
  .CHreg45 (CHreg45), .CHreg46 (CHreg46), .CHreg47 (CHreg47),
  .L0   (L0),	      //pad L0 plus command-generated L0
  .L1   (L1),
  .R3   (R3),
  .regClkEn ( regClkEn )  //register gated-clock enable
); //commandRegister port list


//clock-gating control signal for the registers
//wire regClkEn;
//assign regClkEn = 1'b1;

//Special Command Register:  address 0, handles write-disable, calibration pulses, etc
SCReg SCReg(
  .clkEn (regClkEn),
  .bclka (BC),
  .bclkb (BC),
  .bclkc (BC),
  .rstb ( syncRstb),
  .calPulse (calPulse),
  .digitalTestPulse (digitalTestPulse),
  .regWriteDisable (regWriteDisable),
  .HPRClear ( HPRClear),
  .serIn (  1'b0 ),
  .serOut ( serSC ),
  .shiftIn ( com_int ),
  .shiftOut ( SCReg0 ), 
  .shiftEn (shiftSCReg),
  .latchIn ( loadSCReg ),
  .latchOut ( unloadSCReg )
);

wire CalPulseTo;
wire calPulsePolarity = regConfig1[12];
assign CalPulseTo = calPulsePolarity ? calPulse : !calPulse; //dataOut[3] sets calPulse polarity.  1: high pulse    0: low pulse


//Input registers generate 256 bits to configure the input mask register.
//These will probably get moved into the input mask register iteslf to avoid a 256-bit bus
reg32tr inputReg0(
  .clkEn (regClkEn),
  .bclka (BC),
  .bclkb (BC),
  .bclkc (BC),  
  .rstb ( syncRstb),
  .serIn (  1'b0 ),
  .serOut ( serMT0 ),
  .shiftIn ( com_int ),
  .shiftOut ( Ireg0 ),
  .shiftEn (shiftInputReg0),
  .latchIn ( loadInputReg0 ),
  .latchOut ( unloadInputReg0 ),
  .dataOut ( regInput0 )
);
reg32tr inputReg1(
  .clkEn (regClkEn),
  .bclka (BC),
  .bclkb (BC),
  .bclkc (BC),
  .rstb ( syncRstb),
  .serIn (  1'b0 ),
  .serOut ( serMT1 ),
  .shiftIn ( com_int ),
  .shiftOut ( Ireg1 ),
  .shiftEn (shiftInputReg1),
  .latchIn ( loadInputReg1 ),
  .latchOut ( unloadInputReg1 ),
  .dataOut ( regInput1 )
);
reg32tr inputReg2(
  .clkEn (regClkEn),
  .bclka (BC),
  .bclkb (BC),
  .bclkc (BC),
  .rstb ( syncRstb),
  .serIn (  1'b0 ),
  .serOut ( serMT2 ),
  .shiftIn ( com_int ),
  .shiftOut ( Ireg2 ),
  .shiftEn (shiftInputReg2),
  .latchIn ( loadInputReg2 ),
  .latchOut ( unloadInputReg2 ),
  .dataOut ( regInput2 )
);
reg32tr inputReg3(
  .clkEn (regClkEn),
  .bclka (BC),
  .bclkb (BC),
  .bclkc (BC),
  .rstb ( syncRstb),
  .serIn (  1'b0 ),
  .serOut ( serMT3 ),
  .shiftIn ( com_int ),
  .shiftOut ( Ireg3 ),
  .shiftEn (shiftInputReg3),
  .latchIn ( loadInputReg3 ),
  .latchOut ( unloadInputReg3 ),
  .dataOut ( regInput3 )
);
reg32tr inputReg4(
  .clkEn (regClkEn),
  .bclka (BC),
  .bclkb (BC),
  .bclkc (BC),
  .rstb ( syncRstb),
  .serIn (  1'b0 ),
  .serOut ( serMT4 ),
  .shiftIn ( com_int ),
  .shiftOut ( Ireg4 ),
  .shiftEn (shiftInputReg4),
  .latchIn ( loadInputReg4 ),
  .latchOut ( unloadInputReg4 ),
  .dataOut ( regInput4 )
);
reg32tr inputReg5(
  .clkEn (regClkEn),
  .bclka (BC),
  .bclkb (BC),
  .bclkc (BC),
  .rstb ( syncRstb),
  .serIn (  1'b0 ),
  .serOut ( serMT5 ),
  .shiftIn ( com_int ),
  .shiftOut ( Ireg5 ),
  .shiftEn (shiftInputReg5),
  .latchIn ( loadInputReg5 ),
  .latchOut ( unloadInputReg5 ),
  .dataOut ( regInput5 )
);
reg32tr inputReg6(
  .clkEn (regClkEn),
  .bclka (BC),
  .bclkb (BC),
  .bclkc (BC),
  .rstb ( syncRstb),
  .serIn (  1'b0 ),
  .serOut ( serMT6 ),
  .shiftIn ( com_int ),
  .shiftOut ( Ireg6 ),
  .shiftEn (shiftInputReg6),
  .latchIn ( loadInputReg6 ),
  .latchOut ( unloadInputReg6 ),
  .dataOut ( regInput6 )
);
reg32tr inputReg7(
  .clkEn (regClkEn),
  .bclka (BC),
  .bclkb (BC),
  .bclkc (BC),
  .rstb ( syncRstb),
  .serIn (  1'b0 ),
  .serOut ( serMT7 ),
  .shiftIn ( com_int ),
  .shiftOut ( Ireg7 ),
  .shiftEn (shiftInputReg7),
  .latchIn ( loadInputReg7 ),
  .latchOut ( unloadInputReg7 ),
  .dataOut ( regInput7 )
);

//status registers - read-only
reg32ro StatusReg0(
  .clkEn (regClkEn),
  .bclk (BC),
  .rstb ( syncRstb),
  .dataIn ( {1'h0, 
   Cregser_47L,
   Cregser_43L,   
   Cregser_39L,
   Cregser_35L,
   Cregser_31L,
   Cregser_27L,
   Cregser_23L,
   Cregser_19L,   
   Cregser_15L,
   Cregser_11L,
   Cregser_7L,
   Cregser_3L,
   serMT7L, 
   serMT6L, 
   serMT5L, 
   serMT4L, 
   serMT3L, 
   serMT2L, 
   serMT1L, 
   serMT0L, 
   TopLSEUL, 
   serSCL, 
   serNC7L, 
   serNC6L, 
   serNC3L, 
   serNC2L, 
   serNC1L, 
   serLL, 
   serKL, 
   serJL, 
   serIL} ),
  .shiftOut ( STATUSreg0 ),
  .shiftEn (shiftStatusReg0),
  .latchOut ( unloadStatusReg0 )
);
reg32ro StatusReg1(
  .clkEn (regClkEn),
  .bclk (BC),
  .rstb ( syncRstb),
  .dataIn ( {22'b0,CSRaFIFOoverflow,thruFIFOoverflow,L1FIFOoverflow,R3FIFOoverflow,CSRbFIFOoverflow,CSRaFifoFull,thruFifoFull,L1DCLfifoFull,R3DCLfifoFull,CSRbFifoFull} ),
  .shiftOut ( STATUSreg1 ),
  .shiftEn (shiftStatusReg1),
  .latchOut ( unloadStatusReg1 )
);
reg32ro StatusReg2(
  .clkEn (regClkEn),
  .bclk (BC),
  .rstb ( syncRstb),
  .dataIn ( {24'b0, L0ID_Local} ),
  .shiftOut ( STATUSreg2 ),
  .shiftEn (shiftStatusReg2),
  .latchOut ( unloadStatusReg2 )
);
reg32ro StatusReg3(
  .clkEn (regClkEn),
  .bclk (BC),
  .rstb ( syncRstb),
  .dataIn ( 32'b0 ),
  .shiftOut ( STATUSreg3 ),
  .shiftEn (shiftStatusReg3),
  .latchOut ( unloadStatusReg3 )
);




//capture register to allow read-out of the masked strip values
//masked_dIn
reg32ro inputReg8(
  .clkEn (regClkEn),
  .bclk (BC),
  .rstb ( syncRstb),
  .dataIn ( masked_dIn[31:0] ),
  .shiftOut ( Ireg8 ),
  .shiftEn (shiftInputReg8),
  .latchOut ( unloadInputReg8 )
);

reg32ro inputReg9(
  .clkEn (regClkEn),
  .bclk (BC),
  .rstb ( syncRstb),
  .dataIn ( masked_dIn[63:32] ),
  .shiftOut ( Ireg9 ),
  .shiftEn (shiftInputReg9),
  .latchOut ( unloadInputReg9 )
);
reg32ro inputReg10(
  .clkEn (regClkEn),
  .bclk (BC),
  .rstb ( syncRstb),
  .dataIn ( masked_dIn[95:64] ),
  .shiftOut ( Ireg10 ),
  .shiftEn (shiftInputReg10),
  .latchOut ( unloadInputReg10 )
);

reg32ro inputReg11(
  .clkEn (regClkEn),
  .bclk (BC),
  .rstb ( syncRstb),
  .dataIn ( masked_dIn[127:96] ),
  .shiftOut ( Ireg11 ),
  .shiftEn (shiftInputReg11),
  .latchOut ( unloadInputReg11 )
);

reg32ro inputReg12(
  .clkEn (regClkEn),
  .bclk (BC),
  .rstb ( syncRstb),
  .dataIn ( masked_dIn[159:128] ),
  .shiftOut ( Ireg12 ),
  .shiftEn (shiftInputReg12),
  .latchOut ( unloadInputReg12 )
);
reg32ro inputReg13(
  .clkEn (regClkEn),
  .bclk (BC),
  .rstb ( syncRstb),
  .dataIn ( masked_dIn[191:160] ),
  .shiftOut ( Ireg13 ),
  .shiftEn (shiftInputReg13),
  .latchOut ( unloadInputReg13 )
);
reg32ro inputReg14(
  .clkEn (regClkEn),
  .bclk (BC),
  .rstb ( syncRstb),
  .dataIn ( masked_dIn[223:192] ),
  .shiftOut ( Ireg14 ),
  .shiftEn (shiftInputReg14),
  .latchOut ( unloadInputReg14 )
);
reg32ro inputReg15(
  .clkEn (regClkEn),
  .bclk (BC),
  .rstb ( syncRstb),
  .dataIn ( masked_dIn[255:224] ),
  .shiftOut ( Ireg15 ),
  .shiftEn (shiftInputReg15),
  .latchOut ( unloadInputReg15 )
);

//ADCS registers  with triplication
reg32tr #(.RESET_VALUE(32'h00000000)) ADCSReg1(
  .clkEn (regClkEn),
  .bclka (BC),
  .bclkb (BC),
  .bclkc (BC),
  .rstb ( syncRstb),   
  .serIn (  1'b0 ),
  .serOut ( serNC1 ),
  .shiftIn ( com_int ),
  .shiftOut ( ADCSreg1 ),
  .shiftEn (shiftADCSReg1),
  .latchIn ( loadADCSReg1 ),
  .latchOut ( unloadADCSReg1 ),
  .dataOut ( regADCS1 )
);
reg32tr #(.RESET_VALUE(32'h000000FF)) ADCSReg2(
  .clkEn (regClkEn),
  .bclka (BC),
  .bclkb (BC),
  .bclkc (BC),
  .rstb ( syncRstb),
  .serIn (  1'b0 ),
  .serOut ( serNC2 ),
  .shiftIn ( com_int ),
  .shiftOut ( ADCSreg2 ),
  .shiftEn (shiftADCSReg2),
  .latchIn ( loadADCSReg2 ),
  .latchOut ( unloadADCSReg2 ),
  .dataOut ( regADCS2 )
);
reg32tr #(.RESET_VALUE(32'h00000000)) ADCSReg3(
  .clkEn (regClkEn),
  .bclka (BC),
  .bclkb (BC),
  .bclkc (BC),
  .rstb ( syncRstb),
  .serIn (  1'b0 ),
  .serOut ( serNC3 ),
  .shiftIn ( com_int ),
  .shiftOut ( ADCSreg3 ),
  .shiftEn (shiftADCSReg3),
  .latchIn ( loadADCSReg3 ),
  .latchOut ( unloadADCSReg3 ),
  .dataOut ( regADCS3 )
);
reg32tr #(.RESET_VALUE(32'h00000000)) ADCSReg6(
  .clkEn (regClkEn),
  .bclka (BC),
  .bclkb (BC),
  .bclkc (BC),
  .rstb ( syncRstb),
  .serIn (  1'b0 ),
  .serOut ( serNC6 ),
  .shiftIn ( com_int ),
  .shiftOut ( ADCSreg6 ),
  .shiftEn (shiftADCSReg6),
  .latchIn ( loadADCSReg6 ),
  .latchOut ( unloadADCSReg6 ),
  .dataOut ( regADCS6 )
);
reg32tr #(.RESET_VALUE(32'h00000000)) ADCSReg7(
  .clkEn (regClkEn),
  .bclka (BC),
  .bclkb (BC),
  .bclkc (BC),
  .rstb ( syncRstb),
  .serIn (  1'b0 ),
  .serOut ( serNC7 ),
  .shiftIn ( com_int ),
  .shiftOut ( ADCSreg7 ),
  .shiftEn (shiftADCSReg7),
  .latchIn ( loadADCSReg7 ),
  .latchOut ( unloadADCSReg7 ),
  .dataOut ( regADCS7 )
);







//Config registers
reg32tr #(.RESET_VALUE(32'h00000000)) configReg0(
  .clkEn (regClkEn),
  .bclka (BC),
  .bclkb (BC),
  .bclkc (BC),
  .rstb ( syncRstb),   
  .serIn (  1'b0 ),
  .serOut ( serI ),
  .shiftIn ( com_int ),
  .shiftOut ( Creg0 ),
  .shiftEn (shiftConfigReg0),
  .latchIn ( loadConfigReg0 ),
  .latchOut ( unloadConfigReg0 ),
  .dataOut ( regConfig0 )
);
reg32tr #(.RESET_VALUE(32'h00000444)) configReg1(
  .clkEn (regClkEn),
  .bclka (BC),
  .bclkb (BC),
  .bclkc (BC),
  .rstb ( syncRstb),
  .serIn (  1'b0 ),
  .serOut ( serJ ),
  .shiftIn ( com_int ),
  .shiftOut ( Creg1 ),
  .shiftEn (shiftConfigReg1),
  .latchIn ( loadConfigReg1 ),
  .latchOut ( unloadConfigReg1 ),
  .dataOut ( regConfig1 )
);
reg32tr #(.RESET_VALUE(32'h0000000F)) configReg2(
  .clkEn (regClkEn),
  .bclka (BC),
  .bclkb (BC),
  .bclkc (BC),
  .rstb ( syncRstb),
  .serIn (  1'b0 ),
  .serOut ( serK ),
  .shiftIn ( com_int ),
  .shiftOut ( Creg2 ),
  .shiftEn (shiftConfigReg2),
  .latchIn ( loadConfigReg2 ),
  .latchOut ( unloadConfigReg2 ),
  .dataOut ( regConfig2 )
);
reg32tr #(.RESET_VALUE(32'h00000000)) configReg3(
  .clkEn (regClkEn),
  .bclka (BC),
  .bclkb (BC),
  .bclkc (BC),
  .rstb ( syncRstb),
  .serIn (  1'b0 ),
  .serOut ( serL ),
  .shiftIn ( com_int ),
  .shiftOut ( Creg3 ),
  .shiftEn (shiftConfigReg3),
  .latchIn ( loadConfigReg3 ),
  .latchOut ( unloadConfigReg3 ),
  .dataOut ( regConfig3 )
);


// Introduce SEU Latch elements as SEU Registers

StatusLatch SEUCFG0 (
  .clk(BC),
  .rstb ( syncRstb && ~SEUreset ),
  .SigIn ( serI ),
  .SigOut ( serIL )
  );
StatusLatch SEUCFG1 (
  .clk(BC),
  .rstb ( syncRstb && ~SEUreset ),
  .SigIn ( serJ ),
  .SigOut ( serJL )
  );
StatusLatch SEUCFG2 (
  .clk(BC),
  .rstb ( syncRstb && ~SEUreset ),
  .SigIn ( serK ),
  .SigOut ( serKL )
  );
StatusLatch SEUCFG3 (
  .clk(BC),
  .rstb ( syncRstb && ~SEUreset ),
  .SigIn ( serL ),
  .SigOut ( serLL )
  );
StatusLatch SEUADCS1 (
  .clk(BC),
  .rstb ( syncRstb && ~SEUreset ),
  .SigIn ( serNC1 ),
  .SigOut ( serNC1L )
  );
StatusLatch SEUADCS2 (
  .clk(BC),
  .rstb ( syncRstb && ~SEUreset ),
  .SigIn ( serNC2 ),
  .SigOut ( serNC2L )
  );
StatusLatch SEUADCS3 (
  .clk(BC),
  .rstb ( syncRstb && ~SEUreset ),
  .SigIn ( serNC3 ),
  .SigOut ( serNC3L )
  );
StatusLatch SEUADCS6 (
  .clk(BC),
  .rstb ( syncRstb && ~SEUreset ),
  .SigIn ( serNC6 ),
  .SigOut ( serNC6L )
  );
StatusLatch SEUADCS7 (
  .clk(BC),
  .rstb ( syncRstb && ~SEUreset ),
  .SigIn ( serNC7 ),
  .SigOut ( serNC7L )
  );
StatusLatch SEUADCS0 (
  .clk(BC),
  .rstb ( syncRstb && ~SEUreset ),
  .SigIn ( serSC ),
  .SigOut ( serSCL )
  );
StatusLatch SEUTOP (
  .clk(BC),
  .rstb ( syncRstb && ~SEUreset ),
  .SigIn ( TopLSEU ),
  .SigOut ( TopLSEUL )
  );
StatusLatch SEUMT7 (
  .clk(BC),
  .rstb ( syncRstb && ~SEUreset ),
  .SigIn ( serMT7 ),
  .SigOut ( serMT7L )
  );
StatusLatch SEUMT6 (
  .clk(BC),
  .rstb ( syncRstb && ~SEUreset ),
  .SigIn ( serMT6 ),
  .SigOut ( serMT6L )
  );
StatusLatch SEUMT5 (
  .clk(BC),
  .rstb ( syncRstb && ~SEUreset ),
  .SigIn ( serMT5 ),
  .SigOut ( serMT5L )
  );
StatusLatch SEUMT4 (
  .clk(BC),
  .rstb ( syncRstb && ~SEUreset ),
  .SigIn ( serMT4 ),
  .SigOut ( serMT4L )
  );
StatusLatch SEUMT3 (
  .clk(BC),
  .rstb ( syncRstb && ~SEUreset ),
  .SigIn ( serMT3 ),
  .SigOut ( serMT3L )
  );
StatusLatch SEUMT2 (
  .clk(BC),
  .rstb ( syncRstb && ~SEUreset ),
  .SigIn ( serMT2 ),
  .SigOut ( serMT2L )
  );
StatusLatch SEUMT1 (
  .clk(BC),
  .rstb ( syncRstb && ~SEUreset ),
  .SigIn ( serMT1 ),
  .SigOut ( serMT1L )
  );
StatusLatch SEUMT0 (
  .clk(BC),
  .rstb ( syncRstb && ~SEUreset ),
  .SigIn ( serMT0 ),
  .SigOut ( serMT0L )
  );
// TrimDAC SEU Flags
StatusLatch SEUCR47 (
  .clk(BC),
  .rstb ( syncRstb && ~SEUreset ),
  .SigIn ( Cregser_47 ),
  .SigOut ( Cregser_47L )
  );
StatusLatch SEUCR43 (
  .clk(BC),
  .rstb ( syncRstb && ~SEUreset ),
  .SigIn ( Cregser_43 ),
  .SigOut ( Cregser_43L )
  );
StatusLatch SEUCR39 (
  .clk(BC),
  .rstb ( syncRstb && ~SEUreset ),
  .SigIn ( Cregser_39 ),
  .SigOut ( Cregser_39L )
  );
StatusLatch SEUCR35 (
  .clk(BC),
  .rstb ( syncRstb && ~SEUreset ),
  .SigIn ( Cregser_35 ),
  .SigOut ( Cregser_35L )
  );
StatusLatch SEUCR31 (
  .clk(BC),
  .rstb ( syncRstb && ~SEUreset ),
  .SigIn ( Cregser_31 ),
  .SigOut ( Cregser_31L )
  );
StatusLatch SEUCR27 (
  .clk(BC),
  .rstb ( syncRstb && ~SEUreset ),
  .SigIn ( Cregser_27 ),
  .SigOut ( Cregser_27L )
  );
StatusLatch SEUCR23 (
  .clk(BC),
  .rstb ( syncRstb && ~SEUreset ),
  .SigIn ( Cregser_23 ),
  .SigOut ( Cregser_23L )
  );
StatusLatch SEUCR19 (
  .clk(BC),
  .rstb ( syncRstb && ~SEUreset ),
  .SigIn ( Cregser_19 ),
  .SigOut ( Cregser_19L )
  );
StatusLatch SEUCR15 (
  .clk(BC),
  .rstb ( syncRstb && ~SEUreset ),
  .SigIn ( Cregser_15 ),
  .SigOut ( Cregser_15L )
  );
StatusLatch SEUCR11 (
  .clk(BC),
  .rstb ( syncRstb && ~SEUreset ),
  .SigIn ( Cregser_11 ),
  .SigOut ( Cregser_11L )
  );
StatusLatch SEUCR7 (
  .clk(BC),
  .rstb ( syncRstb && ~SEUreset ),
  .SigIn ( Cregser_7 ),
  .SigOut ( Cregser_7L )
  );
StatusLatch SEUCR3 (
  .clk(BC),
  .rstb ( syncRstb && ~SEUreset ),
  .SigIn ( Cregser_3 ),
  .SigOut ( Cregser_3L )
  );





triggerCounter BCcounter (
  .clk ( BC ),
  .rstb ( syncRstb & EvtBufRstb & ~BCreset),
  .trigger ( 1'b1 ),
  .count ( BCID )
);




wire L1_rden, R3_rden;
wire L0IDReset, L1BreadVetoOut;



// wire [53:0] dOut;  //read-out data to be sent to serializer for transmission

wire DATLoen, DATRoen;
wire XOFFLoen, XOFFRoen;
wire DATLo, DATLi;
wire DATRo, DATRi;
wire XOFFLo, XOFFRo;


wire [53:0] R3_packet;
wire [53:0] L1_packet;
  // Instantiate Top Logic
  Top_Logic Top_Logic 	 (.clk           (BC),
                          .rst_b         (syncRstb & EvtBufRstb),
                          .empty_fifo_L1 (L1_Empty),
                          .empty_fifo_R3 (R3_Empty),
                          .L1_DCL_busy   (L1_DCL_busy),	
                          .R3_DCL_busy   (R3_DCL_busy),	
                          .L1_rden       (L1_rden),
                          .R3_rden       (R3_rden),
			  .read_veto     (L1BReadVetoOut),
			  .delay_reg     (regConfig3[9:4]),
			  .SEUFlag       (TopLSEU)
                         );


  // Modif MKC
  // Instantiate the L0_L1 Buffer
  wire [`L1B_DATA_WIDTH-65:0] L1B_DataOutA;
  wire [`L1B_DATA_WIDTH-1:0] L1B_DataOutC;
  wire [`L1B_DATA_WIDTH-65:0] L1B_DataOutD;
   
  L0L1TOP L0L1TOP     ( 
                       .CLK             (BC),
                       .SoftResetB      (syncRstb & EvtBufRstb),
                       .L0A             (L0),
                       .L0IDReset       (L0IDreset),
		       .L0IDPreset      (regConfig2[16]),  
		       .L0ID_Local	(L0ID_Local),
                       .R3DataIn        (R3),	             // serial 11-bit input from HCC, 101 followed by 8-bit R3L0ID
                       .L1DataIn        (L1),                // serial 11-bit input from HCC, 110 followed by 8-bit L1L0ID
                       .R3_ReadEnable   (R3_rden),           // from TOP_LOGIC
                       .L1_ReadEnable   (L1_rden),           // from TOP_LOGIC
		       .L1BReadVetoIn   (zero),
                       .L1B_Read_R3_A   (L1B_Read_R3_A), 
                       .L1B_Read_R3_C   (L1B_Read_R3_C), 
                       .L1B_Read_R3_D   (L1B_Read_R3_D), 
		       .L1B_Read_L1_A   (L1B_Read_L1_A), 
                       .L1B_Read_L1_C   (L1B_Read_L1_C), 
                       .L1B_Read_L1_D   (L1B_Read_L1_D),     // output or of above 2 signals, maybe not use
		       .L1BReadVetoOut  (L1BReadVetoOut),
                       .R3_Empty        (R3_Empty),
                       .R3_Full         (R3_Full),
                       .L1_Empty        (L1_Empty), 
                       .L1_Full         (L1_Full),
                       .PipeHoldAddress (regConfig2[7:0]), 
		       .PreL0ID         (regConfig2[15:8]), 
                       .Data            ({56'b0,BCID,masked_dIn[255:0]}), 	    
                       .L1B_DataOutA    (L1B_DataOutA),      // 272 bits, into the L1 and R3 DCLs
		       .L1B_DataOutC    (L1B_DataOutC),
		       .L1B_DataOutD    (L1B_DataOutD)
  ); 

  //Instantiate the L1 DCL
  wire [50:0] l1_dcl_data;
  wire mcluster = regConfig3[2];

  top_l1_dcl top_l1_dcl       (.clk            (BC),
                               .packet         (l1_dcl_data),
                               .wtdg_rst_b     (L1_wtdg_rst_b),	
                               .wtdg_rstrt     (L1_wtdg_rstrt),
                               .rst_b          (syncRstb & EvtBufRstb),
                               .buff_wra       (L1B_Read_L1_A), 
			       .buff_wrc       (L1B_Read_L1_C), 
			       .buff_wrd       (L1B_Read_L1_D), 
                               .in_mema        (L1B_DataOutA[255:0]),
			       .in_memc        (L1B_DataOutC[271:0]),
			       .in_memd        (L1B_DataOutD[255:0]),
                               .fifo_full      (L1DCLfifoFull),
                               .busy           (L1_DCL_busy),
                               .two_cluster    (regConfig3[20]),
                               .fifowr         (L1_DCL_fifowr),
                               .mode           (regConfig3[1:0]),	
                               .mcluster       (mcluster),
			       .limit_enable   (regConfig3[18]),
			       .packet_limit   (regConfig3[17:12])		
  );

  // the L1 watchdog counter
  watchdog_counter #( .counter_width(11), .count_limit(11'd1023)) L1_watchdog_counter (
	.clk(BC),
	.rst_b (syncRstb & EvtBufRstb),
	.enable (one),
	.remove_flag (zero),
	.wtdg_rstrt(L1_wtdg_rstrt),
	.wtdg_rst_b(L1_wtdg_rst_b),
	.flag(NC_L1_flag)
  );


  assign L1_packet[53:52] = {~mcluster, 1'b1};   //TYP high 2 bits indicating L11BC(mcluster=1) or L13BC packet (mcluster=0). The low 2 bits are l1_dcl_data[34:33]
  assign L1_packet[51:50] = {l1_dcl_data[33], l1_dcl_data[34]};   //TYP low 2 bits indicating packet info (last, empty)
  assign L1_packet[49:1] =  {l1_dcl_data[50:35], l1_dcl_data[32:0]};
  assign L1_packet[0]    =  1'b1;  //end bit 1:normal, 0: error condition

  wire [50:0] r3_dcl_data;
//Instantiate the R3 DCL
  R3_DCL #(.CLSTR_NUM(4)) R3_DCL ( 
   .CLK        (BC), 
   .wtdg_rst_b (R3_wtdg_rst_b),     // i was CLR_INHIBIT
   .wtdg_rstrt (R3_wtdg_rstrt),     // o was INHIBIT
   .busy       (R3_DCL_busy),	    // to Top_Logic
   .EN_01      (regConfig3[3]),			
   .FIFO_full  (R3DCLfifoFull), 
   .rst_b      (syncRstb & EvtBufRstb),       
   .buffwrA    (L1B_Read_R3_A),
   .buffwrC    (L1B_Read_R3_C),
   .buffwrD    (L1B_Read_R3_D),
   .MEMA       (L1B_DataOutA[255:0]),
   .MEMC       (L1B_DataOutC[271:0]),
   .FIFO_wr    (R3_DCL_FIFO_wr),
   .PCKT_o     (r3_dcl_data)
  );

  //the R3 watchdog counter
  watchdog_counter #( .counter_width(8), .count_limit(8'd200)) R3_watchdog_counter (
	.clk(BC),
	.rst_b (syncRstb & EvtBufRstb),
	.enable (one),
	.remove_flag (zero),
	.wtdg_rstrt(R3_wtdg_rstrt),
	.wtdg_rst_b(R3_wtdg_rst_b),
	.flag(NC_R3_flag)
  );

  assign R3_packet[53:52] = 2'b00;   //TYP high 2 bits indicating R3 packet. The low 2 bits are r3_dcl_data[1:0]
  assign R3_packet[51:50] =  {1'b1, ~r3_dcl_data[0]};
  assign R3_packet[49:1] =  {r3_dcl_data[50:3], r3_dcl_data[1]};
  assign R3_packet[0]    =  1'b1;  //end bit 1:normal, 0: error condition
//always @(posedge L1_DCL_fifowr) $display("L1-Packet= %b",L1_packet);

`ifdef VTB

////////////////////////////////////////////////////////////////
// R3_DCL packet definition: 
// 'Readout Packet Description' - Version 2 - 08 June 2012
////////////////////////////////////////////////////////////////
assign R3_DCL_PCKT_o[59]    =  1'b1;                                   // START_BIT
assign R3_DCL_PCKT_o[58:54] =  ID[4:0];                                // CHIP_ID[4:0]
assign R3_DCL_PCKT_o[53:52] =  2'b00;                                  // TYP high 2 bits indicating R3 packet. The low 2 bits are r3_dcl_data[1:0]
assign R3_DCL_PCKT_o[51:50] =  {1'b1, ~r3_dcl_data[0]};
assign R3_DCL_PCKT_o[49:1]  =  {r3_dcl_data[50:3], r3_dcl_data[1]};
assign R3_DCL_PCKT_o[0]     =  1'b1;                                   // end bit 1:normal, 0: error condition
assign R3_DCL_fifowr = R3_DCL_FIFO_wr;

////////////////////////////////////////////////////////////////
// L1_DCL packet definition: 
// 'Readout Packet Description' - Version 2 - 08 June 2012
////////////////////////////////////////////////////////////////
assign L1_DCL_Mcluster      =  mcluster;

assign L1_DCL_Packet[59]    =  1'b1;                                   // START_BIT
assign L1_DCL_Packet[58:54] =  ID[4:0];                                // CHIP_ID[4:0]
assign L1_DCL_Packet[53:52] = {~mcluster, 1'b1};                       // TYP higher 2 bits indicating L1_1BC(mcluster=1) or L1_3BC packet (mcluster=0). 
                                                                       // The lower 2 bits are l1_dcl_data[34:33]
assign L1_DCL_Packet[51:50] = {l1_dcl_data[33], l1_dcl_data[34]};      // TYP lower 2 bits indicating packet info (last, empty)
assign L1_DCL_Packet[49:1] =  {l1_dcl_data[50:35], l1_dcl_data[32:0]};
assign L1_DCL_Packet[0]    =  1'b1;  //end bit 1:normal, 0: error condition

// OP_DIR configuration
assign OP_DIR = regConfig0[4];

`endif

wire [31:0] ofRegReadVal;
/*
overflowReg overflowReg (
  .bclk (BC),
  .rstb (syncRstb),
  .ofA (L1FIFOoverflow), //0
  .ofB (R3FIFOoverflow),
  .ofC (CSRaFIFOoverflow),
  .ofD (CSRbFIFOoverflow),
  .ofE (thruFIFOoverflow),
  .dataOut (ofRegReadVal), //4
  .push (ofRegPush )
);
*/

//wire [31:0] wireof;
//assign wireof[31:0] = {22'b0,CSRaFIFOoverflow,thruFIFOoverflow,L1FIFOoverflow,R3FIFOoverflow,CSRbFIFOoverflow,1'b0,1'b0,L1DCLfifoFull,R3DCLfifoFull,1'b0};
//assign wireof[31:0] = {32'b0};
overflowReg overflowReg (
  .bclk (BC),
  .rstb (syncRstb & ~HPRClear),
  .of ( {22'b0,CSRaFIFOoverflow,thruFIFOoverflow,L1FIFOoverflow,R3FIFOoverflow,CSRbFIFOoverflow,CSRaFifoFull,thruFifoFull,L1DCLfifoFull,R3DCLfifoFull,CSRbFifoFull} ),
  .dataOut (ofRegReadVal), //32
  .push (ofRegPush )
);


readOut readOut (
  //primary
  .clk (CLK),
  .bclk (BC),
  .rstb (syncRstb & EvtBufRstb),
  //soft error detect from register system
  .serReg ( serK ),
  //CSR stuff
  .ID ( ID[4:0] ),
  .pryority ( regConfig0[3:0] ),
  .dir ( regConfig0[4] ),
  //pad signals
  .DATLoen (DATLoen),
  .DATRoen (DATRoen),
  .DATLi (DATLi),
  .DATLo (DATLo),
  .DATRi (DATRi),
  .DATRo (DATRo),
  .XOFFLi (XOFFLi),
  .XOFFLo (XOFFLo),
  .XOFFRi (XOFFRi),
  .XOFFRo (XOFFRo),
  .XOFFLoen (XOFFLoen),
  .XOFFRoen (XOFFRoen),
  //data and flow control from above
  .en_Thru ( regConfig0[12] ),
  .en_L1 ( regConfig0[10] ),
  .en_R3 ( regConfig0[9] ),
  .en_CSRa ( regConfig0[11]  ),	//high-priority CSR
  .en_CSRb ( regConfig0[8] ),	//low-priority  CSR
  .L1DCLdOut (L1_packet),
  .L1push (L1_DCL_fifowr),
  .R3DCLdOut (R3_packet),
  .R3push (R3_DCL_FIFO_wr),
  .CSRa (ofRegReadVal), 
  .CSRapush (ofRegPush), 
  .CSRb (regReadVal), //the low priority CSR port hard-wired to read register 1 for the moment
  .CSRbpush (regReadPush),  //read-reg
  .registerAddress ( registerAddress ) , //name of register currently being read
   //flow-control back to above
  .L1DCLFifoFull (L1DCLfifoFull),		
  .R3DCLFifoFull (R3DCLfifoFull),
  .CSRaFifoFull (CSRaFifoFull),
  .CSRbFifoFull (CSRbFifoFull),
  .thruFifoFull (thruFifoFull),
  .L1FIFOoverflow (L1FIFOoverflow),
  .R3FIFOoverflow (R3FIFOoverflow),
  .CSRaFIFOoverflow (CSRaFIFOoverflow),
  .CSRbFIFOoverflow (CSRbFIFOoverflow),
  .thruFIFOoverflow (thruFIFOoverflow)
);

//The ABCN<->ABCN data signals
PIO_TRCVR160 padDATL(
	.LVDS_P(DATL), 
	.LVDS_N(DATLB), 
	.dir(~DATLoen), 
	.data_in(DATLo), 
	.currDrv1(regConfig1[0]), 
	.currDrv2(regConfig1[1]), 
	.currDrv3(regConfig1[2]),  
	.data_out(DATLi)
	);
	
PIO_TRCVR160 padDATR(
	.LVDS_P(DATR), 
	.LVDS_N(DATRB), 
	.dir(~DATRoen), 
	.data_in(DATRo), 
	.currDrv1(regConfig1[4]), 
	.currDrv2(regConfig1[5]), 
	.currDrv3(regConfig1[6]),  
	.data_out(DATRi)
	);

PIO_TRCVR160 padXOFFL(
	.LVDS_P(XOFFL), 
	.LVDS_N(XOFFLB), 
	.dir(~XOFFLoen), 
	.data_in(XOFFLo), 
	.currDrv1(regConfig1[0]), 
	.currDrv2(regConfig1[1]), 
	.currDrv3(regConfig1[2]),  
	.data_out(XOFFLi)
	);

PIO_TRCVR160 padXOFFR(
	.LVDS_P(XOFFR), 
	.LVDS_N(XOFFRB), 
	.dir(~XOFFRoen), 
	.data_in(XOFFRo), 
	.currDrv1(regConfig1[4]), 
	.currDrv2(regConfig1[5]), 
	.currDrv3(regConfig1[6]),  
	.data_out(XOFFRi)
	);



/*
padIO padDATL(
  .oen (DATLoen),
  .padP(DATL),
  .padN(DATLB),
  .dataIn(DATLi),
  .dataOut(DATLo)
);

padIO padDATR(
  .oen (DATRoen),
  .padP(DATR),
  .padN(DATRB),
  .dataIn(DATRi),
  .dataOut(DATRo)
);

//The ABCN<->ABCN flow-control signals
padIO padXOFFL(
  .oen (XOFFLoen),
  .padP(XOFFL),
  .padN(XOFFLB),
  .dataIn(XOFFLi),
  .dataOut(XOFFLo)
);

padIO padXOFFR(
  .oen (XOFFRoen),
  .padP(XOFFR),
  .padN(XOFFRB),
  .dataIn(XOFFRi),
  .dataOut(XOFFRo)
);
*/



//the 64 channel registers
//`include "/tape/mitch_sim/joeld/SVN/abcnasic/abcn/branches/rtl/ABCNmodules/channelReg.inc"
wire BCa, BCb, BCc;
assign BCa = BC;
assign BCb = BC;
assign BCc = BC;
reg32tr channelReg0(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn (1'b0), .serOut( ser_0),
  .shiftOut (            CHreg0 ),
  .shiftEn (   shiftChannelReg0),
  .latchIn (    loadChannelReg0 ),
  .latchOut ( unloadChannelReg0 ),
  .dataOut (        regChannel0 )
);
reg32tr channelReg1(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn (ser_0),.serOut( ser_1),
  .shiftOut (            CHreg1 ),
  .shiftEn (   shiftChannelReg1),
  .latchIn (    loadChannelReg1 ),
  .latchOut ( unloadChannelReg1 ),
  .dataOut (        regChannel1 )
);
reg32tr channelReg2(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn (ser_1),.serOut( ser_2),
  .shiftOut (            CHreg2 ),
  .shiftEn (   shiftChannelReg2),
  .latchIn (    loadChannelReg2 ),
  .latchOut ( unloadChannelReg2 ),
  .dataOut (        regChannel2 )
);
reg32tr channelReg3(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn (ser_2),.serOut( Cregser_3),
  .shiftOut (            CHreg3 ),
  .shiftEn (   shiftChannelReg3),
  .latchIn (    loadChannelReg3 ),
  .latchOut ( unloadChannelReg3 ),
  .dataOut (        regChannel3 )
);
reg32tr channelReg4(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut (            CHreg4 ),
  .serIn (1'b0),.serOut( ser_4),
  .shiftEn (   shiftChannelReg4),
  .latchIn (    loadChannelReg4 ),
  .latchOut ( unloadChannelReg4 ),
  .dataOut (        regChannel4 )
);
reg32tr channelReg5(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut (            CHreg5 ),
  .serIn (ser_4),.serOut( ser_5),
  .shiftEn (   shiftChannelReg5),
  .latchIn (    loadChannelReg5 ),
  .latchOut ( unloadChannelReg5 ),
  .dataOut (        regChannel5 )
);
reg32tr channelReg6(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn (ser_5),.serOut( ser_6),
  .shiftOut (            CHreg6 ),
  .shiftEn (   shiftChannelReg6),
  .latchIn (    loadChannelReg6 ),
  .latchOut ( unloadChannelReg6 ),
  .dataOut (        regChannel6 )
);
reg32tr channelReg7(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut (            CHreg7 ),
  .serIn (ser_6),.serOut( Cregser_7),
  .shiftEn (   shiftChannelReg7),
  .latchIn (    loadChannelReg7 ),
  .latchOut ( unloadChannelReg7 ),
  .dataOut (        regChannel7 )
);
reg32tr channelReg8(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut (            CHreg8 ),
  .serIn (1'b0),.serOut( ser_8),
  .shiftEn (   shiftChannelReg8),
  .latchIn (    loadChannelReg8 ),
  .latchOut ( unloadChannelReg8 ),
  .dataOut (        regChannel8 )
);
reg32tr channelReg9(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut (            CHreg9 ),
  .serIn (ser_8),.serOut( ser_9),
  .shiftEn (   shiftChannelReg9),
  .latchIn (    loadChannelReg9 ),
  .latchOut ( unloadChannelReg9 ),
  .dataOut (        regChannel9 )
);

reg32tr channelReg10(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn (ser_9),.serOut( ser_10),
  .shiftOut (            CHreg10 ),
  .shiftEn (   shiftChannelReg10),
  .latchIn (    loadChannelReg10 ),
  .latchOut ( unloadChannelReg10 ),
  .dataOut (        regChannel10 )
);
reg32tr channelReg11(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn (ser_10),.serOut(Cregser_11),
  .shiftOut (            CHreg11 ),
  .shiftEn (   shiftChannelReg11),
  .latchIn (    loadChannelReg11 ),
  .latchOut ( unloadChannelReg11 ),
  .dataOut (        regChannel11 )
);
reg32tr channelReg12(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn(1'b0),.serOut( ser_12),
  .shiftOut (            CHreg12 ),
  .shiftEn (   shiftChannelReg12),
  .latchIn (    loadChannelReg12 ),
  .latchOut ( unloadChannelReg12 ),
  .dataOut (        regChannel12 )
);
reg32tr channelReg13(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn(ser_12),.serOut( ser_13),
  .shiftOut (            CHreg13 ),
  .shiftEn (   shiftChannelReg13),
  .latchIn (    loadChannelReg13 ),
  .latchOut ( unloadChannelReg13 ),
  .dataOut (        regChannel13 )
);
reg32tr channelReg14(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut (            CHreg14 ),
  .serIn(ser_13),.serOut( ser_14),
  .shiftEn (   shiftChannelReg14),
  .latchIn (    loadChannelReg14 ),
  .latchOut ( unloadChannelReg14 ),
  .dataOut (        regChannel14 )
);
reg32tr channelReg15(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut (            CHreg15 ),
  .serIn(ser_14),.serOut( Cregser_15),
  .shiftEn (   shiftChannelReg15),
  .latchIn (    loadChannelReg15 ),
  .latchOut ( unloadChannelReg15 ),
  .dataOut (        regChannel15 )
);
reg32tr channelReg16(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn(1'b0),.serOut( ser_16),
  .shiftOut (            CHreg16 ),
  .shiftEn (   shiftChannelReg16),
  .latchIn (    loadChannelReg16 ),
  .latchOut ( unloadChannelReg16 ),
  .dataOut (        regChannel16 )
);
reg32tr channelReg17(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut (            CHreg17 ),
  .serIn(ser_16),.serOut( ser_17),
  .shiftEn (   shiftChannelReg17),
  .latchIn (    loadChannelReg17 ),
  .latchOut ( unloadChannelReg17 ),
  .dataOut (        regChannel17 )
);
reg32tr channelReg18(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut (            CHreg18 ),
  .serIn(ser_17),.serOut( ser_18),
  .shiftEn (   shiftChannelReg18),
  .latchIn (    loadChannelReg18 ),
  .latchOut ( unloadChannelReg18 ),
  .dataOut (        regChannel18 )
);
reg32tr channelReg19(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut (            CHreg19 ),
  .serIn(ser_18),.serOut( Cregser_19),
  .shiftEn (   shiftChannelReg19),
  .latchIn (    loadChannelReg19 ),
  .latchOut ( unloadChannelReg19 ),
  .dataOut (        regChannel19 )
);

reg32tr channelReg20(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn (1'b0),.serOut( ser_20),
  .shiftOut (            CHreg20 ),
  .shiftEn (   shiftChannelReg20),
  .latchIn (    loadChannelReg20 ),
  .latchOut ( unloadChannelReg20 ),
  .dataOut (        regChannel20 )
);
reg32tr channelReg21(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn (ser_20),.serOut(ser_21),
  .shiftOut (            CHreg21 ),
  .shiftEn (   shiftChannelReg21),
  .latchIn (    loadChannelReg21 ),
  .latchOut ( unloadChannelReg21 ),
  .dataOut (        regChannel21 )
);
reg32tr channelReg22(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn(ser_21),.serOut( ser_22),
  .shiftOut (            CHreg22 ),
  .shiftEn (   shiftChannelReg22),
  .latchIn (    loadChannelReg22 ),
  .latchOut ( unloadChannelReg22 ),
  .dataOut (        regChannel22 )
);
reg32tr channelReg23(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn(ser_22),.serOut( Cregser_23),
  .shiftOut (            CHreg23 ),
  .shiftEn (   shiftChannelReg23),
  .latchIn (    loadChannelReg23 ),
  .latchOut ( unloadChannelReg23 ),
  .dataOut (        regChannel23 )
);
reg32tr channelReg24(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut (            CHreg24 ),
  .serIn(1'b0),.serOut( ser_24),
  .shiftEn (   shiftChannelReg24),
  .latchIn (    loadChannelReg24 ),
  .latchOut ( unloadChannelReg24 ),
  .dataOut (        regChannel24 )
);
reg32tr channelReg25(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut (            CHreg25 ),
  .serIn( ser_24),.serOut( ser_25),
  .shiftEn (   shiftChannelReg25),
  .latchIn (    loadChannelReg25 ),
  .latchOut ( unloadChannelReg25 ),
  .dataOut (        regChannel25 )
);
reg32tr channelReg26(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn(ser_25),.serOut( ser_26),
  .shiftOut (            CHreg26 ),
  .shiftEn (   shiftChannelReg26),
  .latchIn (    loadChannelReg26 ),
  .latchOut ( unloadChannelReg26 ),
  .dataOut (        regChannel26 )
);
reg32tr channelReg27(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut (            CHreg27 ),
  .serIn(ser_26),.serOut( Cregser_27),
  .shiftEn (   shiftChannelReg27),
  .latchIn (    loadChannelReg27 ),
  .latchOut ( unloadChannelReg27 ),
  .dataOut (        regChannel27 )
);
reg32tr channelReg28(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut (            CHreg28 ),
  .serIn(1'b0),.serOut( ser_28),
  .shiftEn (   shiftChannelReg28),
  .latchIn (    loadChannelReg28 ),
  .latchOut ( unloadChannelReg28 ),
  .dataOut (        regChannel28 )
);
reg32tr channelReg29(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut (            CHreg29 ),
  .serIn(ser_28),.serOut( ser_29),
  .shiftEn (   shiftChannelReg29),
  .latchIn (    loadChannelReg29 ),
  .latchOut ( unloadChannelReg29 ),
  .dataOut (        regChannel29 )
);

reg32tr channelReg30(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn (ser_29),.serOut(ser_30),
  .shiftOut (            CHreg30 ),
  .shiftEn (   shiftChannelReg30),
  .latchIn (    loadChannelReg30 ),
  .latchOut ( unloadChannelReg30 ),
  .dataOut (        regChannel30 )
);
reg32tr channelReg31(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn (ser_30),.serOut(Cregser_31),
  .shiftOut (            CHreg31 ),
  .shiftEn (   shiftChannelReg31),
  .latchIn (    loadChannelReg31 ),
  .latchOut ( unloadChannelReg31 ),
  .dataOut (        regChannel31 )
);
reg32tr channelReg32(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn(1'b0),.serOut( ser_32),
  .shiftOut (            CHreg32 ),
  .shiftEn (   shiftChannelReg32),
  .latchIn (    loadChannelReg32 ),
  .latchOut ( unloadChannelReg32 ),
  .dataOut (        regChannel32 )
);
reg32tr channelReg33(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn( ser_32),.serOut( ser_33),
  .shiftOut (            CHreg33 ),
  .shiftEn (   shiftChannelReg33),
  .latchIn (    loadChannelReg33 ),
  .latchOut ( unloadChannelReg33 ),
  .dataOut (        regChannel33 )
);
reg32tr channelReg34(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut (            CHreg34 ),
  .serIn(ser_33),.serOut( ser_34),
  .shiftEn (   shiftChannelReg34),
  .latchIn (    loadChannelReg34 ),
  .latchOut ( unloadChannelReg34 ),
  .dataOut (        regChannel34 )
);
reg32tr channelReg35(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut (            CHreg35 ),
  .serIn(ser_34),.serOut( Cregser_35),
  .shiftEn (   shiftChannelReg35),
  .latchIn (    loadChannelReg35 ),
  .latchOut ( unloadChannelReg35 ),
  .dataOut (        regChannel35 )
);
reg32tr channelReg36(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn(1'b0),.serOut( ser_36),
  .shiftOut (            CHreg36 ),
  .shiftEn (   shiftChannelReg36),
  .latchIn (    loadChannelReg36 ),
  .latchOut ( unloadChannelReg36 ),
  .dataOut (        regChannel36 )
);
reg32tr channelReg37(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut (            CHreg37 ),
  .serIn( ser_36),.serOut( ser_37),
  .shiftEn (   shiftChannelReg37),
  .latchIn (    loadChannelReg37 ),
  .latchOut ( unloadChannelReg37 ),
  .dataOut (        regChannel37 )
);
reg32tr channelReg38(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut (            CHreg38 ),
  .serIn(ser_37),.serOut( ser_38),
  .shiftEn (   shiftChannelReg38),
  .latchIn (    loadChannelReg38 ),
  .latchOut ( unloadChannelReg38 ),
  .dataOut (        regChannel38 )
);
reg32tr channelReg39(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut (            CHreg39 ),
  .serIn(ser_38),.serOut( Cregser_39),
  .shiftEn (   shiftChannelReg39),
  .latchIn (    loadChannelReg39 ),
  .latchOut ( unloadChannelReg39 ),
  .dataOut (        regChannel39 )
);
reg32tr channelReg40(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn (1'b0),.serOut( ser_40),
  .shiftOut (            CHreg40 ),
  .shiftEn (   shiftChannelReg40),
  .latchIn (    loadChannelReg40 ),
  .latchOut ( unloadChannelReg40 ),
  .dataOut (        regChannel40 )
);
reg32tr channelReg41(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn ( ser_40),.serOut(ser_41),
  .shiftOut (            CHreg41 ),
  .shiftEn (   shiftChannelReg41),
  .latchIn (    loadChannelReg41 ),
  .latchOut ( unloadChannelReg41 ),
  .dataOut (        regChannel41 )
);
reg32tr channelReg42(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn(ser_41),.serOut( ser_42),
  .shiftOut (            CHreg42 ),
  .shiftEn (   shiftChannelReg42),
  .latchIn (    loadChannelReg42 ),
  .latchOut ( unloadChannelReg42 ),
  .dataOut (        regChannel42 )
);
reg32tr channelReg43(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn(ser_42),.serOut( Cregser_43),
  .shiftOut (            CHreg43 ),
  .shiftEn (   shiftChannelReg43),
  .latchIn (    loadChannelReg43 ),
  .latchOut ( unloadChannelReg43 ),
  .dataOut (        regChannel43 )
);
reg32tr channelReg44(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut (            CHreg44 ),
  .serIn(1'b0),.serOut( ser_44),
  .shiftEn (   shiftChannelReg44),
  .latchIn (    loadChannelReg44 ),
  .latchOut ( unloadChannelReg44 ),
  .dataOut (        regChannel44 )
);
reg32tr channelReg45(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut (            CHreg45 ),
  .serIn(ser_44),.serOut( ser_45),
  .shiftEn (   shiftChannelReg45),
  .latchIn (    loadChannelReg45 ),
  .latchOut ( unloadChannelReg45 ),
  .dataOut (        regChannel45 )
);
reg32tr channelReg46(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn( ser_45),.serOut( ser_46),
  .shiftOut (            CHreg46 ),
  .shiftEn (   shiftChannelReg46),
  .latchIn (    loadChannelReg46 ),
  .latchOut ( unloadChannelReg46 ),
  .dataOut (        regChannel46 )
);
reg32tr channelReg47(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut (            CHreg47 ),
  .serIn(ser_46),.serOut( Cregser_47),
  .shiftEn (   shiftChannelReg47),
  .latchIn (    loadChannelReg47 ),
  .latchOut ( unloadChannelReg47 ),
  .dataOut (        regChannel47 )
);


endmodule //ABC
