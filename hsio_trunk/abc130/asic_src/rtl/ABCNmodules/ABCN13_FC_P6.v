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
//data from the detector
 DIN,
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
 dataOutFC2_padN
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
assign L1_DCL_Packet[50:0] = l1_dcl_data[50:0];
assign R3_DCL_Packet[50:0] = r3_dcl_data[50:0];
assign L1_DCL_Mcluster = mcluster;
assign R3_DCL_fifowr = R3_DCL_FIFO_wr;
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
input [255:0] DIN;    //Strip Data

inout XOFFL, XOFFLB;  
inout DATL, DATLB;  
inout XOFFR, XOFFRB;  
inout DATR, DATRB;  

//register output buses  //likely to get renamed
wire [31:0] regADCS1, regADCS2, regADCS3, regADCS7;
wire [31:0] regInput0, regInput1, regInput2, regInput3;
wire [31:0] regInput4, regInput5, regInput6, regInput7;
wire [31:0] regConfig0, regConfig1, regConfig2, regConfig3;
wire [31:0] regChannel0, regChannel1, regChannel2, regChannel3, regChannel4;
wire [31:0] regChannel5, regChannel6, regChannel7, regChannel8, regChannel9;
wire [31:0] regChannel10, regChannel11, regChannel12, regChannel13, regChannel14;
wire [31:0] regChannel15, regChannel16, regChannel17, regChannel18, regChannel19;
wire [31:0] regChannel20, regChannel21, regChannel22, regChannel23, regChannel24;
wire [31:0] regChannel25, regChannel26, regChannel27, regChannel28, regChannel29;
wire [31:0] regChannel30, regChannel31, regChannel32, regChannel33, regChannel34;
wire [31:0] regChannel35, regChannel36, regChannel37, regChannel38, regChannel39;
wire [31:0] regChannel40, regChannel41, regChannel42, regChannel43, regChannel44;
wire [31:0] regChannel45, regChannel46, regChannel47, regChannel48, regChannel49;
wire [31:0] regChannel50, regChannel51, regChannel52, regChannel53, regChannel54;
wire [31:0] regChannel55, regChannel56, regChannel57, regChannel58, regChannel59;
wire [31:0] regChannel60, regChannel61, regChannel62, regChannel63;

wire FastCLK;
wire CLK;
wire BC;
wire COM;
wire RST;
wire LZERO;
wire LONERTHREE;

wire RSTB = ~RST;

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
PIO_REC160 padRST(
   .TERM(TERM),
	.out(RST),
	.LVDS_P(RST_padP),
	.LVDS_N(RST_padN)
	);
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
PIO_INP padTERM(.PAD(padTerm), .PT(TERM));

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

//FC signals outputs
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
pipeLineEntry pipeLineEntry(
  .stripData (DIN),
  .maskBits( {regInput7, regInput6, regInput5, regInput4, regInput3, regInput2, regInput1, regInput0}),
  .BCID (BCID), 
  .BCclk (BC), 
  .hrdrstb (syncRstb),
  .mode ( regConfig0[17:16]),
  .pipeLine(masked_dIn),
  .diagnostic ( diagnostic)
);

// Preliminary outputs from FastClusterFinder(To be connected as a register)
wire [2:0] count3CL, count3CH;
wire  [31:0] interestingCount;

fastClusterFinderMode fastClusterFinder1(
	.inputFrntEnd(masked_dIn), 
	.BCclk(BC), 
	.FSclk(FastCLK),  
	.reset(~syncRstb),
	.interestingCountReset(syncRstb), // where to connect to later on : one of the $00 register bit ? 
	.control(regConfig0[29:28]),
	.dataOutL16SB(dataOutFC1), 
	.dataOutM16SB(dataOutFC2),
	.interestingCount(interestingCount)
	 
	);

assign powerUpRstb = 1'b1;

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

commandControl commandControl (
  .clk (BC),  //slow clock
  .bclk (BC), //not used, needed for synthesis
  .rstb (RSTB),			//i reset pin
  .powerUpRstb (powerUpRstb),	//i power-on reset
  .tgRstb (tgRstb),	        //i trigger generated reset
  .com (COM),
  .com_int (com_int),
  .id (ID[4:0]),
  //various events
  .syncRstb (syncRstb),		//o  command-generated reset, synchronous
  .hardRstb (hardRstb),	        //o  pad-reset plus power-on-reset, asynchronous
  .BCreset (BCreset),
  .SEUreset (SEUreset),
  .L0IDpreset (L0IDreset),
  .hardL0 (LZERO),   //from pads
  .hardL1 (LONE),
  .hardR3 (RTHREE),
  .regWriteDisable (regWriteDisable),
  .SCReg(SCReg0),
  .shiftSCReg(shiftSCReg), .loadSCReg(loadSCReg), .unloadSCReg(unloadSCReg),    //special command register controls
  //register read, write controls
  .regReadVal ( regReadVal),
  .regReadPush  ( regReadPush),
  .registerAddress ( registerAddress ),
  .shiftADCSReg1 (shiftADCSReg1), .loadADCSReg1 (loadADCSReg1), .unloadADCSReg1 (unloadADCSReg1),      
  .shiftADCSReg2 (shiftADCSReg2), .loadADCSReg2 (loadADCSReg2), .unloadADCSReg2 (unloadADCSReg2),      
  .shiftADCSReg3 (shiftADCSReg3), .loadADCSReg3 (loadADCSReg3), .unloadADCSReg3 (unloadADCSReg3),      
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
  .shiftChannelReg48 (shiftChannelReg48), .loadChannelReg48 (loadChannelReg48), .unloadChannelReg48 (unloadChannelReg48),      
  .shiftChannelReg49 (shiftChannelReg49), .loadChannelReg49 (loadChannelReg49), .unloadChannelReg49 (unloadChannelReg49),      
  .shiftChannelReg50 (shiftChannelReg50), .loadChannelReg50 (loadChannelReg50), .unloadChannelReg50 (unloadChannelReg50),      
  .shiftChannelReg51 (shiftChannelReg51), .loadChannelReg51 (loadChannelReg51), .unloadChannelReg51 (unloadChannelReg51),      
  .shiftChannelReg52 (shiftChannelReg52), .loadChannelReg52 (loadChannelReg52), .unloadChannelReg52 (unloadChannelReg52),      
  .shiftChannelReg53 (shiftChannelReg53), .loadChannelReg53 (loadChannelReg53), .unloadChannelReg53 (unloadChannelReg53),      
  .shiftChannelReg54 (shiftChannelReg54), .loadChannelReg54 (loadChannelReg54), .unloadChannelReg54 (unloadChannelReg54),      
  .shiftChannelReg55 (shiftChannelReg55), .loadChannelReg55 (loadChannelReg55), .unloadChannelReg55 (unloadChannelReg55),      
  .shiftChannelReg56 (shiftChannelReg56), .loadChannelReg56 (loadChannelReg56), .unloadChannelReg56 (unloadChannelReg56),      
  .shiftChannelReg57 (shiftChannelReg57), .loadChannelReg57 (loadChannelReg57), .unloadChannelReg57 (unloadChannelReg57),      
  .shiftChannelReg58 (shiftChannelReg58), .loadChannelReg58 (loadChannelReg58), .unloadChannelReg58 (unloadChannelReg58),      
  .shiftChannelReg59 (shiftChannelReg59), .loadChannelReg59 (loadChannelReg59), .unloadChannelReg59 (unloadChannelReg59),      
  .shiftChannelReg60 (shiftChannelReg60), .loadChannelReg60 (loadChannelReg60), .unloadChannelReg60 (unloadChannelReg60),      
  .shiftChannelReg61 (shiftChannelReg61), .loadChannelReg61 (loadChannelReg61), .unloadChannelReg61 (unloadChannelReg61),      
  .shiftChannelReg62 (shiftChannelReg62), .loadChannelReg62 (loadChannelReg62), .unloadChannelReg62 (unloadChannelReg62),      
  .shiftChannelReg63 (shiftChannelReg63), .loadChannelReg63 (loadChannelReg63), .unloadChannelReg63 (unloadChannelReg63),      
   //register returns
  .ADCSreg1( ADCSreg1), .ADCSreg2( ADCSreg2),.ADCSreg3( ADCSreg3),.ADCSreg7( ADCSreg7),
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
  .CHreg45 (CHreg45), .CHreg46 (CHreg46), .CHreg47 (CHreg47), .CHreg48(CHreg48), .CHreg49(CHreg49),
  .CHreg50 (CHreg50), .CHreg51 (CHreg51), .CHreg52 (CHreg52), .CHreg53(CHreg53), .CHreg54(CHreg54),
  .CHreg55 (CHreg55), .CHreg56 (CHreg56), .CHreg57 (CHreg57), .CHreg58(CHreg58), .CHreg59(CHreg59),
  .CHreg60 (CHreg60), .CHreg61 (CHreg61), .CHreg62 (CHreg62), .CHreg63(CHreg63),
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

wire calPulseTo;
wire calPulsePolarity = regConfig1[12];
assign calPulseTo = calPulsePolarity ? calPulse : !calPulse; //dataOut[3] sets calPulse polarity.  1: high pulse    0: low pulse


//Input registers generate 256 bits to configure the input mask register.
//These will probably get moved into the input mask register iteslf to avoid a 256-bit bus
reg32 inputReg0(
  .clkEn (regClkEn),
  .bclk (BC),  
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut ( Ireg0 ),
  .shiftEn (shiftInputReg0),
  .latchIn ( loadInputReg0 ),
  .latchOut ( unloadInputReg0 ),
  .dataOut ( regInput0 )
);
reg32 inputReg1(
  .clkEn (regClkEn),
  .bclk (BC),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut ( Ireg1 ),
  .shiftEn (shiftInputReg1),
  .latchIn ( loadInputReg1 ),
  .latchOut ( unloadInputReg1 ),
  .dataOut ( regInput1 )
);
reg32 inputReg2(
  .clkEn (regClkEn),
  .bclk (BC),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut ( Ireg2 ),
  .shiftEn (shiftInputReg2),
  .latchIn ( loadInputReg2 ),
  .latchOut ( unloadInputReg2 ),
  .dataOut ( regInput2 )
);
reg32 inputReg3(
  .clkEn (regClkEn),
  .bclk (BC),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut ( Ireg3 ),
  .shiftEn (shiftInputReg3),
  .latchIn ( loadInputReg3 ),
  .latchOut ( unloadInputReg3 ),
  .dataOut ( regInput3 )
);
reg32 inputReg4(
  .clkEn (regClkEn),
  .bclk (BC),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut ( Ireg4 ),
  .shiftEn (shiftInputReg4),
  .latchIn ( loadInputReg4 ),
  .latchOut ( unloadInputReg4 ),
  .dataOut ( regInput4 )
);
reg32 inputReg5(
  .clkEn (regClkEn),
  .bclk (BC),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut ( Ireg5 ),
  .shiftEn (shiftInputReg5),
  .latchIn ( loadInputReg5 ),
  .latchOut ( unloadInputReg5 ),
  .dataOut ( regInput5 )
);
reg32 inputReg6(
  .clkEn (regClkEn),
  .bclk (BC),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut ( Ireg6 ),
  .shiftEn (shiftInputReg6),
  .latchIn ( loadInputReg6 ),
  .latchOut ( unloadInputReg6 ),
  .dataOut ( regInput6 )
);
reg32 inputReg7(
  .clkEn (regClkEn),
  .bclk (BC),
  .rstb ( syncRstb),
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
  .dataIn ( {22'h0, TopLSEUL, serSCL, serNC7L, serNC3L, serNC2L, serNC1L, serLL, serKL, serJL, serIL} ),
  .shiftOut ( STATUSreg0 ),
  .shiftEn (shiftStatusReg0),
  .latchOut ( unloadStatusReg0 )
);
reg32ro StatusReg1(
  .clkEn (regClkEn),
  .bclk (BC),
  .rstb ( syncRstb),
  .dataIn ( 32'h0 ),
  .shiftOut ( STATUSreg1 ),
  .shiftEn (shiftStatusReg1),
  .latchOut ( unloadStatusReg1 )
);
reg32ro StatusReg2(
  .clkEn (regClkEn),
  .bclk (BC),
  .rstb ( syncRstb),
  .dataIn ( 32'h0 ),
  .shiftOut ( STATUSreg2 ),
  .shiftEn (shiftStatusReg2),
  .latchOut ( unloadStatusReg2 )
);
reg32ro StatusReg3(
  .clkEn (regClkEn),
  .bclk (BC),
  .rstb ( syncRstb),
  .dataIn ( interestingCount ),
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
reg32t #(.RESET_VALUE(32'h1F1F1F1F)) ADCSReg1(
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
reg32t #(.RESET_VALUE(32'h1F1F1F1F)) ADCSReg2(
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
reg32t #(.RESET_VALUE(32'h00000000)) ADCSReg3(
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
reg32t #(.RESET_VALUE(32'h00000000)) ADCSReg7(
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
reg32t #(.RESET_VALUE(32'h00000000)) configReg0(
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
reg32t #(.RESET_VALUE(32'h00000444)) configReg1(
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
reg32t #(.RESET_VALUE(32'h0000000F)) configReg2(
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
reg32t #(.RESET_VALUE(32'h00000000)) configReg3(
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



triggerCounter BCcounter (
  .clk ( BC ),
  .rstb ( syncRstb & ~BCreset),
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
                          .rst_b         (syncRstb),
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


  // Instantiate the L0_L1 Buffer
  wire [271:0] L1B_DataOutA;
  wire [271:0] L1B_DataOutC;
  wire [271:0] L1B_DataOutD;
  

  
  L0L1TOP L0L1TOP 	( .CLK             (BC),
                       .SoftResetB      (syncRstb),
                       .L0A             (L0),
                       .L0IDReset       (L0IDreset),
		       .L0IDPreset      (regConfig2[16]),  
                       .R3DataIn        (R3),	//serial 11-bit input from HCC, 101 followed by 8-bit R3L0ID
                       .L1DataIn        (L1),   //serial 11-bit input from HCC, 110 followed by 8-bit L1L0ID
                       .R3_ReadEnable   (R3_rden), //from TOP_LOGIC
                       .L1_ReadEnable   (L1_rden),//from TOP_LOGIC
		       .L1BReadVetoIn   (zero),
                       .L1B_Read_R3_A(L1B_Read_R3_A), .L1B_Read_R3_C(L1B_Read_R3_C), .L1B_Read_R3_D(L1B_Read_R3_D), 
		       .L1B_Read_L1_A(L1B_Read_L1_A), .L1B_Read_L1_C(L1B_Read_L1_C), .L1B_Read_L1_D(L1B_Read_L1_D), //output or of above 2 signals, maybe not use
		       .L1BReadVetoOut  (L1BReadVetoOut),
                       .R3_Empty        (R3_Empty),
                       .R3_Full         (R3_Full),
                       .L1_Empty        (L1_Empty), 
                       .L1_Full         (L1_Full),
                       .PipeHoldAddress (regConfig2[7:0]), 
		       .PreL0ID         (regConfig2[15:8]), 
                       .Data            ( {56'b0,BCID,masked_dIn[255:0]}), 	    
                       .L1B_DataOutA     (L1B_DataOutA),  //272 bits, into the L1 and R3 DCLs
		       .L1B_DataOutC     (L1B_DataOutC),
		       .L1B_DataOutD     (L1B_DataOutD)
  ); 
  //Instantiate the L1 DCL
  wire [50:0] l1_dcl_data;
  wire mcluster = regConfig3[2];
  top_l1_dcl top_l1_dcl       (.clk        (BC),
                            .packet     (l1_dcl_data),
                            .wtdg_rst_b     (L1_wtdg_rst_b),	
                            .wtdg_rstrt     (L1_wtdg_rstrt),
                            .rst_b      (syncRstb),
                            .buff_wra     (L1B_Read_L1_A), 
			    .buff_wrc     (L1B_Read_L1_C), 
			    .buff_wrd     (L1B_Read_L1_D), 
                            .in_mema     (L1B_DataOutA),
			    .in_memc     (L1B_DataOutC),
			    .in_memd     (L1B_DataOutD),
                            .fifo_full  (L1DCLfifoFull),
                            .busy       (L1_DCL_busy),
                            .fifowr     (L1_DCL_fifowr),
                            .mode       (regConfig3[1:0]),	
                            .mcluster   (mcluster),
			    .limit_enable (regConfig3[18]),
			    .packet_limit (regConfig3[17:12])		
  );

  //the L1 watchdog counter
  watchdog_counter #( .counter_width(11), .count_limit(11'd1023)) L1_watchdog_counter (
	.clk(BC),
	.rst_b (syncRstb),
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
   .CLK       (BC), 
   .wtdg_rst_b (R3_wtdg_rst_b),     //i was CLR_INHIBIT
   .wtdg_rstrt  (R3_wtdg_rstrt),    //o was INHIBIT
   .busy       (R3_DCL_busy),	    //to Top_Logic
   .EN_01   (regConfig3[3]),			
   .FIFO_full (R3DCLfifoFull), 
   .rst_b       (syncRstb),       
   .buffwrA    (L1B_Read_R3_A),
   .buffwrC    (L1B_Read_R3_C),
   .buffwrD    (L1B_Read_R3_D),
   .MEMA   (L1B_DataOutA),
   .MEMC   (L1B_DataOutC),
   .FIFO_wr   (R3_DCL_FIFO_wr),
   .PCKT_o    (r3_dcl_data)
  );
  //the R3 watchdog counter
  watchdog_counter #( .counter_width(8), .count_limit(8'd200)) R3_watchdog_counter (
	.clk(BC),
	.rst_b (syncRstb),
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
  .rstb (syncRstb),
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
	.direction(~DATLoen), 
	.data_in(DATLo), 
	.currDrv1(regConfig1[0]), 
	.currDrv2(regConfig1[1]), 
	.currDrv3(regConfig1[2]),  
	.data_out(DATLi)
	);
	
PIO_TRCVR160 padDATR(
	.LVDS_P(DATR), 
	.LVDS_N(DATRB), 
	.direction(~DATRoen), 
	.data_in(DATRo), 
	.currDrv1(regConfig1[4]), 
	.currDrv2(regConfig1[5]), 
	.currDrv3(regConfig1[6]),  
	.data_out(DATRi)
	);

PIO_TRCVR160 padXOFFL(
	.LVDS_P(XOFFL), 
	.LVDS_N(XOFFLB), 
	.direction(~XOFFLoen), 
	.data_in(XOFFLo), 
	.currDrv1(regConfig1[0]), 
	.currDrv2(regConfig1[1]), 
	.currDrv3(regConfig1[2]),  
	.data_out(XOFFLi)
	);

PIO_TRCVR160 padXOFFR(
	.LVDS_P(XOFFR), 
	.LVDS_N(XOFFRB), 
	.direction(~XOFFRoen), 
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
reg32t channelReg0(
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
reg32t channelReg1(
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
reg32t channelReg2(
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
reg32t channelReg3(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn (ser_2),.serOut( ser_3),
  .shiftOut (            CHreg3 ),
  .shiftEn (   shiftChannelReg3),
  .latchIn (    loadChannelReg3 ),
  .latchOut ( unloadChannelReg3 ),
  .dataOut (        regChannel3 )
);
reg32t channelReg4(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut (            CHreg4 ),
  .serIn (ser_3),.serOut( ser_4),
  .shiftEn (   shiftChannelReg4),
  .latchIn (    loadChannelReg4 ),
  .latchOut ( unloadChannelReg4 ),
  .dataOut (        regChannel4 )
);
reg32t channelReg5(
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
reg32t channelReg6(
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
reg32t channelReg7(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut (            CHreg7 ),
  .serIn (ser_6),.serOut( ser_7),
  .shiftEn (   shiftChannelReg7),
  .latchIn (    loadChannelReg7 ),
  .latchOut ( unloadChannelReg7 ),
  .dataOut (        regChannel7 )
);
reg32t channelReg8(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut (            CHreg8 ),
  .serIn (ser_7),.serOut( ser_8),
  .shiftEn (   shiftChannelReg8),
  .latchIn (    loadChannelReg8 ),
  .latchOut ( unloadChannelReg8 ),
  .dataOut (        regChannel8 )
);
reg32t channelReg9(
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

reg32t channelReg10(
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
reg32t channelReg11(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn (ser_10),.serOut(ser_11),
  .shiftOut (            CHreg11 ),
  .shiftEn (   shiftChannelReg11),
  .latchIn (    loadChannelReg11 ),
  .latchOut ( unloadChannelReg11 ),
  .dataOut (        regChannel11 )
);
reg32t channelReg12(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn(ser_11),.serOut( ser_12),
  .shiftOut (            CHreg12 ),
  .shiftEn (   shiftChannelReg12),
  .latchIn (    loadChannelReg12 ),
  .latchOut ( unloadChannelReg12 ),
  .dataOut (        regChannel12 )
);
reg32t channelReg13(
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
reg32t channelReg14(
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
reg32t channelReg15(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut (            CHreg15 ),
  .serIn(ser_14),.serOut( ser_15),
  .shiftEn (   shiftChannelReg15),
  .latchIn (    loadChannelReg15 ),
  .latchOut ( unloadChannelReg15 ),
  .dataOut (        regChannel15 )
);
reg32t channelReg16(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn(ser_15),.serOut( ser_16),
  .shiftOut (            CHreg16 ),
  .shiftEn (   shiftChannelReg16),
  .latchIn (    loadChannelReg16 ),
  .latchOut ( unloadChannelReg16 ),
  .dataOut (        regChannel16 )
);
reg32t channelReg17(
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
reg32t channelReg18(
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
reg32t channelReg19(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut (            CHreg19 ),
  .serIn(ser_18),.serOut( ser_19),
  .shiftEn (   shiftChannelReg19),
  .latchIn (    loadChannelReg19 ),
  .latchOut ( unloadChannelReg19 ),
  .dataOut (        regChannel19 )
);

reg32t channelReg20(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn (ser_19),.serOut(ser_20),
  .shiftOut (            CHreg20 ),
  .shiftEn (   shiftChannelReg20),
  .latchIn (    loadChannelReg20 ),
  .latchOut ( unloadChannelReg20 ),
  .dataOut (        regChannel20 )
);
reg32t channelReg21(
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
reg32t channelReg22(
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
reg32t channelReg23(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn(ser_22),.serOut( ser_23),
  .shiftOut (            CHreg23 ),
  .shiftEn (   shiftChannelReg23),
  .latchIn (    loadChannelReg23 ),
  .latchOut ( unloadChannelReg23 ),
  .dataOut (        regChannel23 )
);
reg32t channelReg24(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut (            CHreg24 ),
  .serIn(ser_23),.serOut( ser_24),
  .shiftEn (   shiftChannelReg24),
  .latchIn (    loadChannelReg24 ),
  .latchOut ( unloadChannelReg24 ),
  .dataOut (        regChannel24 )
);
reg32t channelReg25(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut (            CHreg25 ),
  .serIn(ser_24),.serOut( ser_25),
  .shiftEn (   shiftChannelReg25),
  .latchIn (    loadChannelReg25 ),
  .latchOut ( unloadChannelReg25 ),
  .dataOut (        regChannel25 )
);
reg32t channelReg26(
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
reg32t channelReg27(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut (            CHreg27 ),
  .serIn(ser_26),.serOut( ser_27),
  .shiftEn (   shiftChannelReg27),
  .latchIn (    loadChannelReg27 ),
  .latchOut ( unloadChannelReg27 ),
  .dataOut (        regChannel27 )
);
reg32t channelReg28(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut (            CHreg28 ),
  .serIn(ser_27),.serOut( ser_28),
  .shiftEn (   shiftChannelReg28),
  .latchIn (    loadChannelReg28 ),
  .latchOut ( unloadChannelReg28 ),
  .dataOut (        regChannel28 )
);
reg32t channelReg29(
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

reg32t channelReg30(
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
reg32t channelReg31(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn (ser_30),.serOut(ser_31),
  .shiftOut (            CHreg31 ),
  .shiftEn (   shiftChannelReg31),
  .latchIn (    loadChannelReg31 ),
  .latchOut ( unloadChannelReg31 ),
  .dataOut (        regChannel31 )
);
reg32t channelReg32(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn(ser_31),.serOut( ser_32),
  .shiftOut (            CHreg32 ),
  .shiftEn (   shiftChannelReg32),
  .latchIn (    loadChannelReg32 ),
  .latchOut ( unloadChannelReg32 ),
  .dataOut (        regChannel32 )
);
reg32t channelReg33(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn(ser_32),.serOut( ser_33),
  .shiftOut (            CHreg33 ),
  .shiftEn (   shiftChannelReg33),
  .latchIn (    loadChannelReg33 ),
  .latchOut ( unloadChannelReg33 ),
  .dataOut (        regChannel33 )
);
reg32t channelReg34(
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
reg32t channelReg35(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut (            CHreg35 ),
  .serIn(ser_34),.serOut( ser_35),
  .shiftEn (   shiftChannelReg35),
  .latchIn (    loadChannelReg35 ),
  .latchOut ( unloadChannelReg35 ),
  .dataOut (        regChannel35 )
);
reg32t channelReg36(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn(ser_35),.serOut( ser_36),
  .shiftOut (            CHreg36 ),
  .shiftEn (   shiftChannelReg36),
  .latchIn (    loadChannelReg36 ),
  .latchOut ( unloadChannelReg36 ),
  .dataOut (        regChannel36 )
);
reg32t channelReg37(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut (            CHreg37 ),
  .serIn(ser_36),.serOut( ser_37),
  .shiftEn (   shiftChannelReg37),
  .latchIn (    loadChannelReg37 ),
  .latchOut ( unloadChannelReg37 ),
  .dataOut (        regChannel37 )
);
reg32t channelReg38(
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
reg32t channelReg39(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut (            CHreg39 ),
  .serIn(ser_38),.serOut( ser_39),
  .shiftEn (   shiftChannelReg39),
  .latchIn (    loadChannelReg39 ),
  .latchOut ( unloadChannelReg39 ),
  .dataOut (        regChannel39 )
);
reg32t channelReg40(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn (ser_39),.serOut(ser_40),
  .shiftOut (            CHreg40 ),
  .shiftEn (   shiftChannelReg40),
  .latchIn (    loadChannelReg40 ),
  .latchOut ( unloadChannelReg40 ),
  .dataOut (        regChannel40 )
);
reg32t channelReg41(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn (ser_40),.serOut(ser_41),
  .shiftOut (            CHreg41 ),
  .shiftEn (   shiftChannelReg41),
  .latchIn (    loadChannelReg41 ),
  .latchOut ( unloadChannelReg41 ),
  .dataOut (        regChannel41 )
);
reg32t channelReg42(
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
reg32t channelReg43(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn(ser_42),.serOut( ser_43),
  .shiftOut (            CHreg43 ),
  .shiftEn (   shiftChannelReg43),
  .latchIn (    loadChannelReg43 ),
  .latchOut ( unloadChannelReg43 ),
  .dataOut (        regChannel43 )
);
reg32t channelReg44(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut (            CHreg44 ),
  .serIn(ser_43),.serOut( ser_44),
  .shiftEn (   shiftChannelReg44),
  .latchIn (    loadChannelReg44 ),
  .latchOut ( unloadChannelReg44 ),
  .dataOut (        regChannel44 )
);
reg32t channelReg45(
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
reg32t channelReg46(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn(ser_45),.serOut( ser_46),
  .shiftOut (            CHreg46 ),
  .shiftEn (   shiftChannelReg46),
  .latchIn (    loadChannelReg46 ),
  .latchOut ( unloadChannelReg46 ),
  .dataOut (        regChannel46 )
);
reg32t channelReg47(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut (            CHreg47 ),
  .serIn(ser_46),.serOut( ser_47),
  .shiftEn (   shiftChannelReg47),
  .latchIn (    loadChannelReg47 ),
  .latchOut ( unloadChannelReg47 ),
  .dataOut (        regChannel47 )
);
reg32t channelReg48(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut (            CHreg48 ),
  .serIn(ser_47),.serOut( ser_48),
  .shiftEn (   shiftChannelReg48),
  .latchIn (    loadChannelReg48 ),
  .latchOut ( unloadChannelReg48 ),
  .dataOut (        regChannel48 )
);
reg32t channelReg49(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut (            CHreg49 ),
  .serIn(ser_48),.serOut( ser_49),
  .shiftEn (   shiftChannelReg49),
  .latchIn (    loadChannelReg49 ),
  .latchOut ( unloadChannelReg49 ),
  .dataOut (        regChannel49 )
);
reg32t channelReg50(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn (ser_49),.serOut(ser_50),
  .shiftOut (            CHreg50 ),
  .shiftEn (   shiftChannelReg50),
  .latchIn (    loadChannelReg50 ),
  .latchOut ( unloadChannelReg50 ),
  .dataOut (        regChannel50 )
);
reg32t channelReg51(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn (ser_50),.serOut(ser_51),
  .shiftOut (            CHreg51 ),
  .shiftEn (   shiftChannelReg51),
  .latchIn (    loadChannelReg51 ),
  .latchOut ( unloadChannelReg51 ),
  .dataOut (        regChannel51 )
);
reg32t channelReg52(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn(ser_51),.serOut( ser_52),
  .shiftOut (            CHreg52 ),
  .shiftEn (   shiftChannelReg52),
  .latchIn (    loadChannelReg52 ),
  .latchOut ( unloadChannelReg52 ),
  .dataOut (        regChannel52 )
);
reg32t channelReg53(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn(ser_52),.serOut( ser_53),
  .shiftOut (            CHreg53 ),
  .shiftEn (   shiftChannelReg53),
  .latchIn (    loadChannelReg53 ),
  .latchOut ( unloadChannelReg53 ),
  .dataOut (        regChannel53 )
);
reg32t channelReg54(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut (            CHreg54 ),
  .serIn(ser_53),.serOut( ser_54),
  .shiftEn (   shiftChannelReg54),
  .latchIn (    loadChannelReg54 ),
  .latchOut ( unloadChannelReg54 ),
  .dataOut (        regChannel54 )
);
reg32t channelReg55(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut (            CHreg55 ),
  .serIn(ser_54),.serOut( ser_55),
  .shiftEn (   shiftChannelReg55),
  .latchIn (    loadChannelReg55 ),
  .latchOut ( unloadChannelReg55 ),
  .dataOut (        regChannel55 )
);
reg32t channelReg56(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn(ser_55),.serOut( ser_56),
  .shiftOut (            CHreg56 ),
  .shiftEn (   shiftChannelReg56),
  .latchIn (    loadChannelReg56 ),
  .latchOut ( unloadChannelReg56 ),
  .dataOut (        regChannel56 )
);
reg32t channelReg57(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut (            CHreg57 ),
  .serIn(ser_56),.serOut( ser_57),
  .shiftEn (   shiftChannelReg57),
  .latchIn (    loadChannelReg57 ),
  .latchOut ( unloadChannelReg57 ),
  .dataOut (        regChannel57 )
);
reg32t channelReg58(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut (            CHreg58 ),
  .serIn(ser_57),.serOut( ser_58),
  .shiftEn (   shiftChannelReg58),
  .latchIn (    loadChannelReg58 ),
  .latchOut ( unloadChannelReg58 ),
  .dataOut (        regChannel58 )
);
reg32t channelReg59(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .shiftOut (            CHreg59 ),
  .serIn(ser_58),.serOut( ser_59),
  .shiftEn (   shiftChannelReg59),
  .latchIn (    loadChannelReg59 ),
  .latchOut ( unloadChannelReg59 ),
  .dataOut (        regChannel59 )
);
reg32t channelReg60(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn (ser_59),.serOut(ser_60),
  .shiftOut (            CHreg60 ),
  .shiftEn (   shiftChannelReg60),
  .latchIn (    loadChannelReg60 ),
  .latchOut ( unloadChannelReg60 ),
  .dataOut (        regChannel60 )
);
reg32t channelReg61(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn (ser_60),.serOut(ser_61),
  .shiftOut (            CHreg61 ),
  .shiftEn (   shiftChannelReg61),
  .latchIn (    loadChannelReg61 ),
  .latchOut ( unloadChannelReg61 ),
  .dataOut (        regChannel61 )
);
reg32t channelReg62(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn(ser_61),.serOut( ser_62),
  .shiftOut (            CHreg62 ),
  .shiftEn (   shiftChannelReg62),
  .latchIn (    loadChannelReg62 ),
  .latchOut ( unloadChannelReg62 ),
  .dataOut (        regChannel62 )
);
reg32t channelReg63(
  .clkEn (regClkEn),
  .bclka (BCa), .bclkb (BCb), .bclkc (BCc),
  .rstb ( syncRstb),
  .shiftIn ( com_int ),
  .serIn(ser_62),.serOut( ser_63),
  .shiftOut (            CHreg63 ),
  .shiftEn (   shiftChannelReg63),
  .latchIn (    loadChannelReg63 ),
  .latchOut ( unloadChannelReg63 ),
  .dataOut (        regChannel63 )
);


endmodule //ABC
