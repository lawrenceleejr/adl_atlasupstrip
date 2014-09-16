`timescale 1ns/1ps
module commandControl(
  clk,	 //connect to the slow clock
  clk1, // copy for triplication
  clk2, // copy for triplication
  bclk,  //not used, required for synthesis at the moment
  abcup,
  rstb,
  powerUpRstb,
  tgRstb,
  Prompt,
  com,
  id,
  //various events
  syncRstb,
  hardRstb,
  BCreset,
  FCRstb,
  L0IDpreset,
  SEUreset,
  EvtBufRstb,
  hardL0,
  hardL1,
  hardR3,
  //synchronized com signal
  com_int,
  //special command reg  @address 0, in ADCS address range
  regWriteDisable,
  L0mode,
  shiftSCReg, loadSCReg, unloadSCReg,
  //Analog & DCS registers address range  0F:00
  shiftADCSReg1, loadADCSReg1, unloadADCSReg1,
  shiftADCSReg2, loadADCSReg2, unloadADCSReg2,
  shiftADCSReg3, loadADCSReg3, unloadADCSReg3,
  shiftADCSReg6, loadADCSReg6, unloadADCSReg6,
  shiftADCSReg7, loadADCSReg7, unloadADCSReg7,
  //input reg signals  address range 1F:10
  shiftInputReg0, loadInputReg0, unloadInputReg0,
  shiftInputReg1, loadInputReg1, unloadInputReg1,
  shiftInputReg2, loadInputReg2, unloadInputReg2,
  shiftInputReg3, loadInputReg3, unloadInputReg3,
  shiftInputReg4, loadInputReg4, unloadInputReg4,
  shiftInputReg5, loadInputReg5, unloadInputReg5,
  shiftInputReg6, loadInputReg6, unloadInputReg6,
  shiftInputReg7, loadInputReg7, unloadInputReg7,
  shiftInputReg8,  unloadInputReg8,
  shiftInputReg9,  unloadInputReg9,
  shiftInputReg10,  unloadInputReg10,
  shiftInputReg11,  unloadInputReg11,
  shiftInputReg12,  unloadInputReg12,
  shiftInputReg13,  unloadInputReg13,
  shiftInputReg14,  unloadInputReg14,
  shiftInputReg15,  unloadInputReg15,
  //Status registers 3F:30  read only
  shiftStatusReg0,  unloadStatusReg0,
  shiftStatusReg1,  unloadStatusReg1,
  shiftStatusReg2,  unloadStatusReg2,
  shiftStatusReg3,  unloadStatusReg3,
  //config reg signals  address range 2F:20
  shiftConfigReg0, loadConfigReg0, unloadConfigReg0,
  shiftConfigReg1, loadConfigReg1, unloadConfigReg1,
  shiftConfigReg2, loadConfigReg2, unloadConfigReg2,
  shiftConfigReg3, loadConfigReg3, unloadConfigReg3,
  //afe channel reg signals	address range 7F:40
  shiftChannelReg0, loadChannelReg0, unloadChannelReg0,
  shiftChannelReg1, loadChannelReg1, unloadChannelReg1,
  shiftChannelReg2, loadChannelReg2, unloadChannelReg2,
  shiftChannelReg3, loadChannelReg3, unloadChannelReg3,
  shiftChannelReg4, loadChannelReg4, unloadChannelReg4,
  shiftChannelReg5, loadChannelReg5, unloadChannelReg5,
  shiftChannelReg6, loadChannelReg6, unloadChannelReg6,
  shiftChannelReg7, loadChannelReg7, unloadChannelReg7,
  shiftChannelReg8, loadChannelReg8, unloadChannelReg8,
  shiftChannelReg9, loadChannelReg9, unloadChannelReg9,
  shiftChannelReg10, loadChannelReg10, unloadChannelReg10,
  shiftChannelReg11, loadChannelReg11, unloadChannelReg11,
  shiftChannelReg12, loadChannelReg12, unloadChannelReg12,
  shiftChannelReg13, loadChannelReg13, unloadChannelReg13,
  shiftChannelReg14, loadChannelReg14, unloadChannelReg14,
  shiftChannelReg15, loadChannelReg15, unloadChannelReg15,
  shiftChannelReg16, loadChannelReg16, unloadChannelReg16,
  shiftChannelReg17, loadChannelReg17, unloadChannelReg17,
  shiftChannelReg18, loadChannelReg18, unloadChannelReg18,
  shiftChannelReg19, loadChannelReg19, unloadChannelReg19,
  shiftChannelReg20, loadChannelReg20, unloadChannelReg20,
  shiftChannelReg21, loadChannelReg21, unloadChannelReg21,
  shiftChannelReg22, loadChannelReg22, unloadChannelReg22,
  shiftChannelReg23, loadChannelReg23, unloadChannelReg23,
  shiftChannelReg24, loadChannelReg24, unloadChannelReg24,
  shiftChannelReg25, loadChannelReg25, unloadChannelReg25,
  shiftChannelReg26, loadChannelReg26, unloadChannelReg26,
  shiftChannelReg27, loadChannelReg27, unloadChannelReg27,
  shiftChannelReg28, loadChannelReg28, unloadChannelReg28,
  shiftChannelReg29, loadChannelReg29, unloadChannelReg29,
  shiftChannelReg30, loadChannelReg30, unloadChannelReg30,
  shiftChannelReg31, loadChannelReg31, unloadChannelReg31,
  shiftChannelReg32, loadChannelReg32, unloadChannelReg32,
  shiftChannelReg33, loadChannelReg33, unloadChannelReg33,
  shiftChannelReg34, loadChannelReg34, unloadChannelReg34,
  shiftChannelReg35, loadChannelReg35, unloadChannelReg35,
  shiftChannelReg36, loadChannelReg36, unloadChannelReg36,
  shiftChannelReg37, loadChannelReg37, unloadChannelReg37,
  shiftChannelReg38, loadChannelReg38, unloadChannelReg38,
  shiftChannelReg39, loadChannelReg39, unloadChannelReg39,
  shiftChannelReg40, loadChannelReg40, unloadChannelReg40,
  shiftChannelReg41, loadChannelReg41, unloadChannelReg41,
  shiftChannelReg42, loadChannelReg42, unloadChannelReg42,
  shiftChannelReg43, loadChannelReg43, unloadChannelReg43,
  shiftChannelReg44, loadChannelReg44, unloadChannelReg44,
  shiftChannelReg45, loadChannelReg45, unloadChannelReg45,
  shiftChannelReg46, loadChannelReg46, unloadChannelReg46,
  shiftChannelReg47, loadChannelReg47, unloadChannelReg47,
  //the read landing register output value and push signal
  regReadVal,
  regReadPush,
  registerAddress,
  //from SCReg
  //regWriteDisable,
  //return signals from the registers
  SCReg,
  ADCSreg1, ADCSreg2, ADCSreg3, ADCSreg6, ADCSreg7,
  STATUSreg0, STATUSreg1, STATUSreg2, STATUSreg3,
  Ireg0, Ireg1, Ireg2, Ireg3,
  Ireg4, Ireg5, Ireg6, Ireg7,
  Ireg8, Ireg9, Ireg10, Ireg11,
  Ireg12, Ireg13, Ireg14, Ireg15,
  Creg0, Creg1, Creg2, Creg3,
  CHreg0, CHreg1, CHreg2, CHreg3,CHreg4,CHreg5,CHreg6,CHreg7,CHreg8,CHreg9,
  CHreg10, CHreg11, CHreg12, CHreg13,CHreg14,CHreg15,CHreg16,CHreg17,CHreg18,CHreg19,
  CHreg20, CHreg21, CHreg22, CHreg23,CHreg24,CHreg25,CHreg26,CHreg27,CHreg28,CHreg29,
  CHreg30, CHreg31, CHreg32, CHreg33,CHreg34,CHreg35,CHreg36,CHreg37,CHreg38,CHreg39,
  CHreg40, CHreg41, CHreg42, CHreg43,CHreg44,CHreg45,CHreg46,CHreg47,
  //the trigger signals
  L0,
  L1,
  R3,
  regClkEn   //gated-clock enable for the registers
); //commandRegister port list
input clk, rstb, powerUpRstb, tgRstb, com, abcup; //serial interface input signals & resets
input bclk;
input clk1, clk2;
input [4:0] id;       //bondpad-configured chip-ID
input hardL0, hardL1, hardR3; //L0, L1,R3 triggers from pads
input regWriteDisable;
input L0mode;
input Prompt;
//the outputs
output com_int;
output syncRstb;
output hardRstb;
output BCreset;
output FCRstb;
output L0IDpreset;
output SEUreset;
output EvtBufRstb;
output L0;  //OR of hard (from pads) and soft (from command) L0
output L1;  //OR of hard (from pads) and soft (from command) L1
output R3;  //OR of hard (from pads) and soft (from command) R3
output regClkEn;  //gated-clock enable for the registers

output regReadPush;
wire   regReadPush;
output [6:0] registerAddress;
output [31:0] regReadVal;
wire [31:0] regReadVal;
reg    com_int;
reg shiftReadReg, loadReadReg;
output shiftSCReg, loadSCReg, unloadSCReg;
reg    shiftSCReg, loadSCReg, unloadSCReg;
output shiftADCSReg1, loadADCSReg1, unloadADCSReg1;
reg    shiftADCSReg1, loadADCSReg1, unloadADCSReg1;
output shiftADCSReg2, loadADCSReg2, unloadADCSReg2;
reg    shiftADCSReg2, loadADCSReg2, unloadADCSReg2;
output shiftADCSReg3, loadADCSReg3, unloadADCSReg3;
reg    shiftADCSReg3, loadADCSReg3, unloadADCSReg3;
output shiftADCSReg6, loadADCSReg6, unloadADCSReg6;
reg    shiftADCSReg6, loadADCSReg6, unloadADCSReg6;
output shiftADCSReg7, loadADCSReg7, unloadADCSReg7;
reg    shiftADCSReg7, loadADCSReg7, unloadADCSReg7;
output shiftInputReg0, loadInputReg0, unloadInputReg0;
reg    shiftInputReg0, loadInputReg0, unloadInputReg0;
output shiftInputReg1, loadInputReg1, unloadInputReg1;
reg    shiftInputReg1, loadInputReg1, unloadInputReg1;
output shiftInputReg2, loadInputReg2, unloadInputReg2;
reg    shiftInputReg2, loadInputReg2, unloadInputReg2;
output shiftInputReg3, loadInputReg3, unloadInputReg3;
reg    shiftInputReg3, loadInputReg3, unloadInputReg3;
output shiftInputReg4, loadInputReg4, unloadInputReg4;
reg    shiftInputReg4, loadInputReg4, unloadInputReg4;
output shiftInputReg5, loadInputReg5, unloadInputReg5;
reg    shiftInputReg5, loadInputReg5, unloadInputReg5;
output shiftInputReg6, loadInputReg6, unloadInputReg6;
reg    shiftInputReg6, loadInputReg6, unloadInputReg6;
output shiftInputReg7, loadInputReg7, unloadInputReg7;
reg    shiftInputReg7, loadInputReg7, unloadInputReg7;
output shiftInputReg8, unloadInputReg8;
reg    shiftInputReg8, unloadInputReg8;
output shiftInputReg9, unloadInputReg9;
reg    shiftInputReg9, unloadInputReg9;
output shiftInputReg10, unloadInputReg10;
reg    shiftInputReg10, unloadInputReg10;
output shiftInputReg11, unloadInputReg11;
reg    shiftInputReg11, unloadInputReg11;
output shiftInputReg12, unloadInputReg12;
reg    shiftInputReg12, unloadInputReg12;
output shiftInputReg13, unloadInputReg13;
reg    shiftInputReg13, unloadInputReg13;
output shiftInputReg14, unloadInputReg14;
reg    shiftInputReg14, unloadInputReg14;
output shiftInputReg15, unloadInputReg15;
reg    shiftInputReg15, unloadInputReg15;

output  shiftStatusReg0,  unloadStatusReg0;
output  shiftStatusReg1,  unloadStatusReg1;
output  shiftStatusReg2,  unloadStatusReg2;
output  shiftStatusReg3,  unloadStatusReg3;
reg  shiftStatusReg0,  unloadStatusReg0;
reg  shiftStatusReg1,  unloadStatusReg1;
reg  shiftStatusReg2,  unloadStatusReg2;
reg  shiftStatusReg3,  unloadStatusReg3;

output shiftConfigReg0, loadConfigReg0, unloadConfigReg0;
reg shiftConfigReg0, loadConfigReg0, unloadConfigReg0;
output shiftConfigReg1, loadConfigReg1, unloadConfigReg1;
reg shiftConfigReg1, loadConfigReg1, unloadConfigReg1;
output shiftConfigReg2, loadConfigReg2, unloadConfigReg2;
reg shiftConfigReg2, loadConfigReg2, unloadConfigReg2;
output shiftConfigReg3, loadConfigReg3, unloadConfigReg3;
reg shiftConfigReg3, loadConfigReg3, unloadConfigReg3;

output shiftChannelReg0, loadChannelReg0, unloadChannelReg0;
output shiftChannelReg1, loadChannelReg1, unloadChannelReg1;
output shiftChannelReg2, loadChannelReg2, unloadChannelReg2;
output shiftChannelReg3, loadChannelReg3, unloadChannelReg3;
output shiftChannelReg4, loadChannelReg4, unloadChannelReg4;
output shiftChannelReg5, loadChannelReg5, unloadChannelReg5;
output shiftChannelReg6, loadChannelReg6, unloadChannelReg6;
output shiftChannelReg7, loadChannelReg7, unloadChannelReg7;
output shiftChannelReg8, loadChannelReg8, unloadChannelReg8;
output shiftChannelReg9, loadChannelReg9, unloadChannelReg9;
output shiftChannelReg10, loadChannelReg10, unloadChannelReg10;
output shiftChannelReg11, loadChannelReg11, unloadChannelReg11;
output shiftChannelReg12, loadChannelReg12, unloadChannelReg12;
output shiftChannelReg13, loadChannelReg13, unloadChannelReg13;
output shiftChannelReg14, loadChannelReg14, unloadChannelReg14;
output shiftChannelReg15, loadChannelReg15, unloadChannelReg15;
output shiftChannelReg16, loadChannelReg16, unloadChannelReg16;
output shiftChannelReg17, loadChannelReg17, unloadChannelReg17;
output shiftChannelReg18, loadChannelReg18, unloadChannelReg18;
output shiftChannelReg19, loadChannelReg19, unloadChannelReg19;
output shiftChannelReg20, loadChannelReg20, unloadChannelReg20;
output shiftChannelReg21, loadChannelReg21, unloadChannelReg21;
output shiftChannelReg22, loadChannelReg22, unloadChannelReg22;
output shiftChannelReg23, loadChannelReg23, unloadChannelReg23;
output shiftChannelReg24, loadChannelReg24, unloadChannelReg24;
output shiftChannelReg25, loadChannelReg25, unloadChannelReg25;
output shiftChannelReg26, loadChannelReg26, unloadChannelReg26;
output shiftChannelReg27, loadChannelReg27, unloadChannelReg27;
output shiftChannelReg28, loadChannelReg28, unloadChannelReg28;
output shiftChannelReg29, loadChannelReg29, unloadChannelReg29;
output shiftChannelReg30, loadChannelReg30, unloadChannelReg30;
output shiftChannelReg31, loadChannelReg31, unloadChannelReg31;
output shiftChannelReg32, loadChannelReg32, unloadChannelReg32;
output shiftChannelReg33, loadChannelReg33, unloadChannelReg33;
output shiftChannelReg34, loadChannelReg34, unloadChannelReg34;
output shiftChannelReg35, loadChannelReg35, unloadChannelReg35;
output shiftChannelReg36, loadChannelReg36, unloadChannelReg36;
output shiftChannelReg37, loadChannelReg37, unloadChannelReg37;
output shiftChannelReg38, loadChannelReg38, unloadChannelReg38;
output shiftChannelReg39, loadChannelReg39, unloadChannelReg39;
output shiftChannelReg40, loadChannelReg40, unloadChannelReg40;
output shiftChannelReg41, loadChannelReg41, unloadChannelReg41;
output shiftChannelReg42, loadChannelReg42, unloadChannelReg42;
output shiftChannelReg43, loadChannelReg43, unloadChannelReg43;
output shiftChannelReg44, loadChannelReg44, unloadChannelReg44;
output shiftChannelReg45, loadChannelReg45, unloadChannelReg45;
output shiftChannelReg46, loadChannelReg46, unloadChannelReg46;
output shiftChannelReg47, loadChannelReg47, unloadChannelReg47;
reg shiftChannelReg0, loadChannelReg0, unloadChannelReg0;
reg shiftChannelReg1, loadChannelReg1, unloadChannelReg1;
reg shiftChannelReg2, loadChannelReg2, unloadChannelReg2;
reg shiftChannelReg3, loadChannelReg3, unloadChannelReg3;
reg shiftChannelReg4, loadChannelReg4, unloadChannelReg4;
reg shiftChannelReg5, loadChannelReg5, unloadChannelReg5;
reg shiftChannelReg6, loadChannelReg6, unloadChannelReg6;
reg shiftChannelReg7, loadChannelReg7, unloadChannelReg7;
reg shiftChannelReg8, loadChannelReg8, unloadChannelReg8;
reg shiftChannelReg9, loadChannelReg9, unloadChannelReg9;
reg shiftChannelReg10, loadChannelReg10, unloadChannelReg10;
reg shiftChannelReg11, loadChannelReg11, unloadChannelReg11;
reg shiftChannelReg12, loadChannelReg12, unloadChannelReg12;
reg shiftChannelReg13, loadChannelReg13, unloadChannelReg13;
reg shiftChannelReg14, loadChannelReg14, unloadChannelReg14;
reg shiftChannelReg15, loadChannelReg15, unloadChannelReg15;
reg shiftChannelReg16, loadChannelReg16, unloadChannelReg16;
reg shiftChannelReg17, loadChannelReg17, unloadChannelReg17;
reg shiftChannelReg18, loadChannelReg18, unloadChannelReg18;
reg shiftChannelReg19, loadChannelReg19, unloadChannelReg19;
reg shiftChannelReg20, loadChannelReg20, unloadChannelReg20;
reg shiftChannelReg21, loadChannelReg21, unloadChannelReg21;
reg shiftChannelReg22, loadChannelReg22, unloadChannelReg22;
reg shiftChannelReg23, loadChannelReg23, unloadChannelReg23;
reg shiftChannelReg24, loadChannelReg24, unloadChannelReg24;
reg shiftChannelReg25, loadChannelReg25, unloadChannelReg25;
reg shiftChannelReg26, loadChannelReg26, unloadChannelReg26;
reg shiftChannelReg27, loadChannelReg27, unloadChannelReg27;
reg shiftChannelReg28, loadChannelReg28, unloadChannelReg28;
reg shiftChannelReg29, loadChannelReg29, unloadChannelReg29;
reg shiftChannelReg30, loadChannelReg30, unloadChannelReg30;
reg shiftChannelReg31, loadChannelReg31, unloadChannelReg31;
reg shiftChannelReg32, loadChannelReg32, unloadChannelReg32;
reg shiftChannelReg33, loadChannelReg33, unloadChannelReg33;
reg shiftChannelReg34, loadChannelReg34, unloadChannelReg34;
reg shiftChannelReg35, loadChannelReg35, unloadChannelReg35;
reg shiftChannelReg36, loadChannelReg36, unloadChannelReg36;
reg shiftChannelReg37, loadChannelReg37, unloadChannelReg37;
reg shiftChannelReg38, loadChannelReg38, unloadChannelReg38;
reg shiftChannelReg39, loadChannelReg39, unloadChannelReg39;
reg shiftChannelReg40, loadChannelReg40, unloadChannelReg40;
reg shiftChannelReg41, loadChannelReg41, unloadChannelReg41;
reg shiftChannelReg42, loadChannelReg42, unloadChannelReg42;
reg shiftChannelReg43, loadChannelReg43, unloadChannelReg43;
reg shiftChannelReg44, loadChannelReg44, unloadChannelReg44;
reg shiftChannelReg45, loadChannelReg45, unloadChannelReg45;
reg shiftChannelReg46, loadChannelReg46, unloadChannelReg46;
reg shiftChannelReg47, loadChannelReg47, unloadChannelReg47;



input  SCReg;

input ADCSreg1, ADCSreg2, ADCSreg3, ADCSreg6, ADCSreg7;
wire  ADCSreg1, ADCSreg2, ADCSreg3, ADCSreg6, ADCSreg7;
input STATUSreg0, STATUSreg1, STATUSreg2, STATUSreg3;
wire STATUSreg0, STATUSreg1, STATUSreg2, STATUSreg3;
input Creg0, Creg1, Creg2, Creg3;
wire  Creg0, Creg1, Creg2, Creg3;
input Ireg0, Ireg1, Ireg2, Ireg3;
wire  Ireg0, Ireg1, Ireg2, Ireg3;
input Ireg4, Ireg5, Ireg6, Ireg7;
wire  Ireg4, Ireg5, Ireg6, Ireg7;
input Ireg8, Ireg9, Ireg10, Ireg11;
wire  Ireg8, Ireg9, Ireg10, Ireg11;
input Ireg12, Ireg13, Ireg14, Ireg15;
wire  Ireg12, Ireg13, Ireg14, Ireg15;

input  CHreg0, CHreg1, CHreg2, CHreg3,CHreg4,CHreg5,CHreg6,CHreg7,CHreg8,CHreg9;
input  CHreg10, CHreg11, CHreg12, CHreg13,CHreg14,CHreg15,CHreg16,CHreg17,CHreg18,CHreg19;
input  CHreg20, CHreg21, CHreg22, CHreg23,CHreg24,CHreg25,CHreg26,CHreg27,CHreg28,CHreg29;
input  CHreg30, CHreg31, CHreg32, CHreg33,CHreg34,CHreg35,CHreg36,CHreg37,CHreg38,CHreg39;
input  CHreg40, CHreg41, CHreg42, CHreg43,CHreg44,CHreg45,CHreg46,CHreg47;
wire  CHreg0, CHreg1, CHreg2, CHreg3,CHreg4,CHreg5,CHreg6,CHreg7,CHreg8,CHreg9;
wire  CHreg10, CHreg11, CHreg12, CHreg13,CHreg14,CHreg15,CHreg16,CHreg17,CHreg18,CHreg19;
wire  CHreg20, CHreg21, CHreg22, CHreg23,CHreg24,CHreg25,CHreg26,CHreg27,CHreg28,CHreg29;
wire  CHreg30, CHreg31, CHreg32, CHreg33,CHreg34,CHreg35,CHreg36,CHreg37,CHreg38,CHreg39;
wire  CHreg40, CHreg41, CHreg42, CHreg43,CHreg44,CHreg45,CHreg46,CHreg47;

reg softRstb, last_softRstb;
wire hardRstb;
wire L0;
wire L1;
wire R3;
wire softL0;
reg BCreset;
reg FCRstb;
reg L0IDpreset;
reg SEUreset;
reg EvtBufRstb;
reg softL00, softL01, softL02;
reg softL1;
reg softR3;

assign L0 = (L0mode ? softL0 : hardL0);
assign R3 = softR3 || hardR3;
assign L1 = softL1 || hardL1;


assign hardRstb = (powerUpRstb && rstb && tgRstb && ~Prompt)^abcup;

assign syncRstb = softRstb && last_softRstb;  //two-clock-long synchronous reset

//syncRstb is to last two clocks
//syncRstb ANDs softRstb and last_softRstb 
//hardRstb  produces a syncRstb for the rest of the chip
always @(posedge clk or negedge hardRstb )   // added or negedge hardRstb 10-04-2013 F.A.
  if ( hardRstb == 1'b0 ) begin
    last_softRstb <= 1'b1;
  end  //if hardRstb
  else begin
    last_softRstb <= softRstb;
  end //else



reg [6:0] registerAddress;  //address of register being or most recently addressed, used by readOut to label register-read packets
reg writePending, readPending;
wire regClkEn ; //signal to enable gated clocks to the registers
//soft triggers are not implemented yet, if they should be at all
always @(posedge clk or negedge hardRstb ) 
  if ( hardRstb == 1'b0 ) begin
   com_int <= 1'b0;
//   softL0 <= 1'b0;
   softL1 <= 1'b0;
   softR3 <= 1'b0;
  end
  else begin  
    com_int <= com;
    // self-reseting after one clock of assertion.
//    if ( softL0 == 1'b1)  softL0 <= 1'b0;
    if ( softL1 == 1'b1)  softL1 <= 1'b0;
    if ( softR3 == 1'b1)  softR3 <= 1'b0;
  end


// softL0 detection
reg [3:0] L0shiftIn0;
reg [3:0] L0shiftIn1;
reg [3:0] L0shiftIn2;
always @(posedge clk or negedge hardRstb ) 
if ( hardRstb == 1'b0 ) begin
   softL00 <= 1'b0;
  end
  else begin
  if (L0shiftIn0 == 4'b0110) begin
  	softL00 <= 1'b1;
	L0shiftIn0 <= {L0shiftIn0[3:0], hardL0};
	end else begin
	softL00 <= 1'b0;
	L0shiftIn0 <= {L0shiftIn0[3:0], hardL0};
	end
  end
  
always @(posedge clk1 or negedge hardRstb ) 
if ( hardRstb == 1'b0 ) begin
   softL01 <= 1'b0;
  end
  else begin
  if (L0shiftIn1 == 4'b0110) begin
  	softL01 <= 1'b1;
	L0shiftIn1 <= {L0shiftIn1[3:0], hardL0};
	end else begin
	softL01 <= 1'b0;
	L0shiftIn1 <= {L0shiftIn1[3:0], hardL0};
	end
  end
  
  always @(posedge clk2 or negedge hardRstb ) 
if ( hardRstb == 1'b0 ) begin
   softL02 <= 1'b0;
  end
  else begin
  if (L0shiftIn2 == 4'b0110) begin
  	softL02 <= 1'b1;
	L0shiftIn2 <= {L0shiftIn2[3:0], hardL0};
	end else begin
	softL02 <= 1'b0;
	L0shiftIn2 <= {L0shiftIn2[3:0], hardL0};
	end
  end
    
assign softL0 = ~((~(softL00 & softL01)) &
		  (~(softL01 & softL02)) &
		  (~(softL00 & softL02)));

//The serial-loading command register.  Hardwired to capture 57+1 bits for the Feb 2012 command protocol
wire [5:0] commandBitCounter;//counter to keep track of number of bits so far received
wire [56:0] commandReg;      //incomming bits of the command word
wire       commandPending;   //true if a command is being received
reg lastCommandPending, llc;

assign regClkEn =  commandPending || lastCommandPending || llc || ~softRstb; 

reg [4:0] hccID, abcID;
reg [6:0] regAdd;
reg       rw;


//used to mark the end of a command
always @(posedge clk or negedge hardRstb ) 
  if ( hardRstb == 1'b0 ) 
   begin
     lastCommandPending <= 1'b0;
     llc <= 1'b0;
   end
  else
   begin
     lastCommandPending <= commandPending;
     llc <= lastCommandPending;
   end

cmdReg cmdReg (
  .clk (clk),
  .rstb (hardRstb),
  .com (com),
  .commandReg (commandReg),
  .commandPending (commandPending),
  .count (commandBitCounter )
);


//register access
always @(posedge clk or negedge hardRstb ) 
 if ( hardRstb == 1'b0 ) begin
   //if comment 4 next lines removed all sync reset from the async hardRstb
   softRstb <= 1'b0;	//change reset value to 0 if you want a soft(synchronous) reset generated on hardRstb
   L0IDpreset <= 1'b0;
   SEUreset <= 1'b0;
   EvtBufRstb <= 1'b1;
   BCreset <= 1'b0;
   FCRstb <= 1'b1;
   registerAddress[6:0] <= 7'b0;
   writePending <= 1'b0;
   readPending <= 1'b0;
   shiftReadReg <= 1'b0; loadReadReg <= 1'b0;
   shiftSCReg <= 1'b0; loadSCReg <= 1'b0; unloadSCReg <= 1'b0;
   shiftADCSReg1 <= 1'b0; loadADCSReg1 <= 1'b0; unloadADCSReg1 <= 1'b0;
   shiftADCSReg2 <= 1'b0; loadADCSReg2 <= 1'b0; unloadADCSReg2 <= 1'b0;
   shiftADCSReg3 <= 1'b0; loadADCSReg3 <= 1'b0; unloadADCSReg3 <= 1'b0;
   shiftADCSReg6 <= 1'b0; loadADCSReg6 <= 1'b0; unloadADCSReg6 <= 1'b0;
   shiftADCSReg7 <= 1'b0; loadADCSReg7 <= 1'b0; unloadADCSReg7 <= 1'b0;
   shiftInputReg0 <= 1'b0; loadInputReg0 <= 1'b0; unloadInputReg0 <= 1'b0;
   shiftInputReg1 <= 1'b0; loadInputReg1 <= 1'b0; unloadInputReg1 <= 1'b0;
   shiftInputReg2 <= 1'b0; loadInputReg2 <= 1'b0; unloadInputReg2 <= 1'b0;
   shiftInputReg3 <= 1'b0; loadInputReg3 <= 1'b0; unloadInputReg3 <= 1'b0;
   shiftInputReg4 <= 1'b0; loadInputReg4 <= 1'b0; unloadInputReg4 <= 1'b0;
   shiftInputReg5 <= 1'b0; loadInputReg5 <= 1'b0; unloadInputReg5 <= 1'b0;
   shiftInputReg6 <= 1'b0; loadInputReg6 <= 1'b0; unloadInputReg6 <= 1'b0;
   shiftInputReg7 <= 1'b0; loadInputReg7 <= 1'b0; unloadInputReg7 <= 1'b0;
   shiftInputReg8 <= 1'b0; unloadInputReg8 <= 1'b0;
   shiftInputReg9 <= 1'b0; unloadInputReg9 <= 1'b0;
   shiftInputReg10 <= 1'b0; unloadInputReg10 <= 1'b0;
   shiftInputReg11 <= 1'b0; unloadInputReg11 <= 1'b0;
   shiftInputReg12 <= 1'b0; unloadInputReg12 <= 1'b0;
   shiftInputReg13 <= 1'b0; unloadInputReg13 <= 1'b0;
   shiftInputReg14 <= 1'b0; unloadInputReg14 <= 1'b0;
   shiftInputReg15 <= 1'b0; unloadInputReg15 <= 1'b0;
   shiftStatusReg0 <= 1'b0; unloadStatusReg0 <= 1'b0;
   shiftStatusReg1 <= 1'b0; unloadStatusReg1 <= 1'b0;
   shiftStatusReg2 <= 1'b0; unloadStatusReg2 <= 1'b0;
   shiftStatusReg3 <= 1'b0; unloadStatusReg3 <= 1'b0;
   shiftConfigReg0 <= 1'b0; loadConfigReg0 <= 1'b0; unloadConfigReg0 <= 1'b0;
   shiftConfigReg1 <= 1'b0; loadConfigReg1 <= 1'b0; unloadConfigReg1 <= 1'b0;
   shiftConfigReg2 <= 1'b0; loadConfigReg2 <= 1'b0; unloadConfigReg2 <= 1'b0;
   shiftConfigReg3 <= 1'b0; loadConfigReg3 <= 1'b0; unloadConfigReg3 <= 1'b0;
   /* ***
   shiftChannelReg0 <= 1'b0; loadChannelReg0 <= 1'b0; unloadChannelReg0 <= 1'b0;
   shiftChannelReg1 <= 1'b0; loadChannelReg1 <= 1'b0; unloadChannelReg1 <= 1'b0;
   shiftChannelReg2 <= 1'b0; loadChannelReg2 <= 1'b0; unloadChannelReg2 <= 1'b0;
   shiftChannelReg3 <= 1'b0; loadChannelReg3 <= 1'b0; unloadChannelReg3 <= 1'b0;
   shiftChannelReg4 <= 1'b0; loadChannelReg4 <= 1'b0; unloadChannelReg4 <= 1'b0;
   shiftChannelReg5 <= 1'b0; loadChannelReg5 <= 1'b0; unloadChannelReg5 <= 1'b0;
   shiftChannelReg6 <= 1'b0; loadChannelReg6 <= 1'b0; unloadChannelReg6 <= 1'b0;
   shiftChannelReg7 <= 1'b0; loadChannelReg7 <= 1'b0; unloadChannelReg7 <= 1'b0;
   shiftChannelReg8 <= 1'b0; loadChannelReg8 <= 1'b0; unloadChannelReg8 <= 1'b0;
   shiftChannelReg9 <= 1'b0; loadChannelReg9 <= 1'b0; unloadChannelReg9 <= 1'b0;
   shiftChannelReg10 <= 1'b0; loadChannelReg10 <= 1'b0; unloadChannelReg10 <= 1'b0;
   shiftChannelReg11 <= 1'b0; loadChannelReg11 <= 1'b0; unloadChannelReg11 <= 1'b0;
   shiftChannelReg12 <= 1'b0; loadChannelReg12 <= 1'b0; unloadChannelReg12 <= 1'b0;
   shiftChannelReg13 <= 1'b0; loadChannelReg13 <= 1'b0; unloadChannelReg13 <= 1'b0;
   shiftChannelReg14 <= 1'b0; loadChannelReg14 <= 1'b0; unloadChannelReg14 <= 1'b0;
   shiftChannelReg15 <= 1'b0; loadChannelReg15 <= 1'b0; unloadChannelReg15 <= 1'b0;
   shiftChannelReg16 <= 1'b0; loadChannelReg16 <= 1'b0; unloadChannelReg16 <= 1'b0;
   shiftChannelReg17 <= 1'b0; loadChannelReg17 <= 1'b0; unloadChannelReg17 <= 1'b0;
   shiftChannelReg18 <= 1'b0; loadChannelReg18 <= 1'b0; unloadChannelReg18 <= 1'b0;
   shiftChannelReg19 <= 1'b0; loadChannelReg19 <= 1'b0; unloadChannelReg19 <= 1'b0;
   shiftChannelReg20 <= 1'b0; loadChannelReg20 <= 1'b0; unloadChannelReg20 <= 1'b0;
   shiftChannelReg21 <= 1'b0; loadChannelReg21 <= 1'b0; unloadChannelReg21 <= 1'b0;
   shiftChannelReg22 <= 1'b0; loadChannelReg22 <= 1'b0; unloadChannelReg22 <= 1'b0;
   shiftChannelReg23 <= 1'b0; loadChannelReg23 <= 1'b0; unloadChannelReg23 <= 1'b0;
   shiftChannelReg24 <= 1'b0; loadChannelReg24 <= 1'b0; unloadChannelReg24 <= 1'b0;
   shiftChannelReg25 <= 1'b0; loadChannelReg25 <= 1'b0; unloadChannelReg25 <= 1'b0;
   shiftChannelReg26 <= 1'b0; loadChannelReg26 <= 1'b0; unloadChannelReg26 <= 1'b0;
   shiftChannelReg27 <= 1'b0; loadChannelReg27 <= 1'b0; unloadChannelReg27 <= 1'b0;
   shiftChannelReg28 <= 1'b0; loadChannelReg28 <= 1'b0; unloadChannelReg28 <= 1'b0;
   shiftChannelReg29 <= 1'b0; loadChannelReg29 <= 1'b0; unloadChannelReg29 <= 1'b0;
   shiftChannelReg30 <= 1'b0; loadChannelReg30 <= 1'b0; unloadChannelReg30 <= 1'b0;
   shiftChannelReg31 <= 1'b0; loadChannelReg31 <= 1'b0; unloadChannelReg31 <= 1'b0;
   shiftChannelReg32 <= 1'b0; loadChannelReg32 <= 1'b0; unloadChannelReg32 <= 1'b0;
   shiftChannelReg33 <= 1'b0; loadChannelReg33 <= 1'b0; unloadChannelReg33 <= 1'b0;
   shiftChannelReg34 <= 1'b0; loadChannelReg34 <= 1'b0; unloadChannelReg34 <= 1'b0;
   shiftChannelReg35 <= 1'b0; loadChannelReg35 <= 1'b0; unloadChannelReg35 <= 1'b0;
   shiftChannelReg36 <= 1'b0; loadChannelReg36 <= 1'b0; unloadChannelReg36 <= 1'b0;
   shiftChannelReg37 <= 1'b0; loadChannelReg37 <= 1'b0; unloadChannelReg37 <= 1'b0;
   shiftChannelReg38 <= 1'b0; loadChannelReg38 <= 1'b0; unloadChannelReg38 <= 1'b0;
   shiftChannelReg39 <= 1'b0; loadChannelReg39 <= 1'b0; unloadChannelReg39 <= 1'b0;
   shiftChannelReg40 <= 1'b0; loadChannelReg40 <= 1'b0; unloadChannelReg40 <= 1'b0;
   shiftChannelReg41 <= 1'b0; loadChannelReg41 <= 1'b0; unloadChannelReg41 <= 1'b0;
   shiftChannelReg42 <= 1'b0; loadChannelReg42 <= 1'b0; unloadChannelReg42 <= 1'b0;
   shiftChannelReg43 <= 1'b0; loadChannelReg43 <= 1'b0; unloadChannelReg43 <= 1'b0;
   shiftChannelReg44 <= 1'b0; loadChannelReg44 <= 1'b0; unloadChannelReg44 <= 1'b0;
   shiftChannelReg45 <= 1'b0; loadChannelReg45 <= 1'b0; unloadChannelReg45 <= 1'b0;
   shiftChannelReg46 <= 1'b0; loadChannelReg46 <= 1'b0; unloadChannelReg46 <= 1'b0;
   shiftChannelReg47 <= 1'b0; loadChannelReg47 <= 1'b0; unloadChannelReg47 <= 1'b0;
   */ 
 end
 else begin
  if ( commandBitCounter == 6'd7  & commandReg[7:4] == 4'b1010 ) begin  //short command decode
    //6:4	header=(start-bit)010
    //3:0       typ+parity
    //$display ("Short Command %h %t detected", commandReg[3:0], $time);
    case ( commandReg[3:0] )  
        4'b0000 : 	FCRstb <= 1'b0;      //Fast Cluster detect Reset-bar
        4'b0101:	BCreset <= 1'b1 ;    //BC reset
        4'b0110:	L0IDpreset <= 1'b1 ; //L0ID preset
        4'b1001: 	softRstb <= 1'b0;   //soft reset-bar
        4'b1010:   	SEUreset <= 1'b1;   //SER registers Reset
        4'b0011:   	EvtBufRstb <= 1'b0; //Event Buffer reset registers Reset-bar
        default: ;
    endcase
  end//if shortCommand
  else begin //clear the short-command signals
    softRstb <= 1'b1;      //softRstb might have become 0 due to a shortCommand
    L0IDpreset <= 1'b0;  //L0IDpreset might have become 1 due to a shortCommand
    SEUreset <= 1'b0;  	   //SEUreset might have become 1 due to a shortCommand
    EvtBufRstb <= 1'b1;     //EvtBufRstb might have become 0 due to a shortCommand
    BCreset <= 1'b0;  	   //BCreset might have become 1 due to a shortCommand
    FCRstb <= 1'b1;  	   //FCRstb might have become 0 due to a shortCommand
  end //not shortCommand
  if ( commandBitCounter == 6'd25 ) begin
    //$display("25 bits received");
    //implicit start bit (not in the count)
    //24:22	header
    //21:18     typ+parity
    //17:13     HCC ID
    hccID = commandReg[17:13];
    //12:8      ABC ID
    abcID = commandReg[12:8];
    //7:10	Register Address
    regAdd = commandReg[7:1];
    //0		RW
    rw = commandReg[0];
    //$display("[%d]Header=%b\tField2=%b\tHCCID=%h\tABCID=%h\tField4=%h\tW/R=%b",commandBitCounter, commandReg[19:17],commandReg[16:13],commandReg[12:9],commandReg[8:1], commandReg[0]);
    if ( commandReg[24:18] == 7'b0111110 ) begin  //register access  (1)011 type=111 parity=1  command-protocol-description 6/8/2012 table 1
      //ignore HCC address
      //this chip has been addressed
      if ( commandReg[12:8]  == id[4:0] || commandReg[12:8] == 5'b11111) begin
        case ( commandReg[7:1] )  
            //set the appropriate shift signal, same for read & write
	    7'h00 : shiftSCReg <= 1'b1;
	    7'h01 : shiftADCSReg1 <= 1'b1;
	    7'h02 : shiftADCSReg2 <= 1'b1;
	    7'h03 : shiftADCSReg3 <= 1'b1;
	    7'h06 : shiftADCSReg6 <= 1'b1;
	    7'h07 : shiftADCSReg7 <= 1'b1;
	    7'h10 : shiftInputReg0 <= 1'b1;
	    7'h11 : shiftInputReg1 <= 1'b1;
	    7'h12 : shiftInputReg2 <= 1'b1;
	    7'h13 : shiftInputReg3 <= 1'b1;
	    7'h14 : shiftInputReg4 <= 1'b1;
	    7'h15 : shiftInputReg5 <= 1'b1;
	    7'h16 : shiftInputReg6 <= 1'b1;
	    7'h17 : shiftInputReg7 <= 1'b1;
	    7'h18 : shiftInputReg8 <= 1'b1;
	    7'h19 : shiftInputReg9 <= 1'b1;
	    7'h1a : shiftInputReg10 <= 1'b1;
	    7'h1b : shiftInputReg11 <= 1'b1;
	    7'h1c : shiftInputReg12 <= 1'b1;
	    7'h1d : shiftInputReg13 <= 1'b1;
	    7'h1e : shiftInputReg14 <= 1'b1;
	    7'h1f : shiftInputReg15 <= 1'b1;
            //config registers
	    7'h20 : shiftConfigReg0 <= 1'b1;
	    7'h21 : shiftConfigReg1 <= 1'b1;
	    7'h22 : shiftConfigReg2 <= 1'b1;
	    7'h23 : shiftConfigReg3 <= 1'b1;
            //status registers
	    7'h30 : shiftStatusReg0 <= 1'b1;
	    7'h31 : shiftStatusReg1 <= 1'b1;
	    7'h32 : shiftStatusReg2 <= 1'b1;
	    7'h33 : shiftStatusReg3 <= 1'b1;
            //channel registers
      /* ***
	    7'h40 : shiftChannelReg0 <= 1'b1;
	    7'h41 : shiftChannelReg1 <= 1'b1;
	    7'h42 : shiftChannelReg2 <= 1'b1;
	    7'h43 : shiftChannelReg3 <= 1'b1;
	    7'h44 : shiftChannelReg4 <= 1'b1;
	    7'h45 : shiftChannelReg5 <= 1'b1;
	    7'h46 : shiftChannelReg6 <= 1'b1;
	    7'h47 : shiftChannelReg7 <= 1'b1;
	    7'h48 : shiftChannelReg8 <= 1'b1;
	    7'h49 : shiftChannelReg9 <= 1'b1;
	    7'h4a : shiftChannelReg10 <= 1'b1;
	    7'h4b : shiftChannelReg11 <= 1'b1;
	    7'h4c : shiftChannelReg12 <= 1'b1;
	    7'h4d : shiftChannelReg13 <= 1'b1;
	    7'h4e : shiftChannelReg14 <= 1'b1;
	    7'h4f : shiftChannelReg15 <= 1'b1;
	    7'h50 : shiftChannelReg16 <= 1'b1;
	    7'h51 : shiftChannelReg17 <= 1'b1;
	    7'h52 : shiftChannelReg18 <= 1'b1;
	    7'h53 : shiftChannelReg19 <= 1'b1;
	    7'h54 : shiftChannelReg20 <= 1'b1;
	    7'h55 : shiftChannelReg21 <= 1'b1;
	    7'h56 : shiftChannelReg22 <= 1'b1;
	    7'h57 : shiftChannelReg23 <= 1'b1;
	    7'h58 : shiftChannelReg24 <= 1'b1;
	    7'h59 : shiftChannelReg25 <= 1'b1;
	    7'h5a : shiftChannelReg26 <= 1'b1;
	    7'h5b : shiftChannelReg27 <= 1'b1;
	    7'h5c : shiftChannelReg28 <= 1'b1;
	    7'h5d : shiftChannelReg29 <= 1'b1;
	    7'h5e : shiftChannelReg30 <= 1'b1;
	    7'h5f : shiftChannelReg31 <= 1'b1;
	    7'h60 : shiftChannelReg32 <= 1'b1;
	    7'h61 : shiftChannelReg33 <= 1'b1;
	    7'h62 : shiftChannelReg34 <= 1'b1;
	    7'h63 : shiftChannelReg35 <= 1'b1;
	    7'h64 : shiftChannelReg36 <= 1'b1;
	    7'h65 : shiftChannelReg37 <= 1'b1;
	    7'h66 : shiftChannelReg38 <= 1'b1;
	    7'h67 : shiftChannelReg39 <= 1'b1;
          */
          // CAL_EN registers
	    7'h68 : shiftChannelReg40 <= 1'b1;
	    7'h69 : shiftChannelReg41 <= 1'b1;
	    7'h6a : shiftChannelReg42 <= 1'b1;
	    7'h6b : shiftChannelReg43 <= 1'b1;
	    7'h6c : shiftChannelReg44 <= 1'b1;
	    7'h6d : shiftChannelReg45 <= 1'b1;
	    7'h6e : shiftChannelReg46 <= 1'b1;
	    7'h6f : shiftChannelReg47 <= 1'b1;
	    
            //other shift signals go here
            default : ;
        endcase
        //enter write condition if write command bit is set and not write inhibited.
        //register 0 is special, write-inhibit does not apply to it
 	if (commandReg[0] == 1'b1 && (!regWriteDisable || commandReg[7:1] == 7'h00) ) begin  //beginning of write condition
          writePending <= 1'b1;
	  //$display("Register write to chip %d",id[4:0]);
	end
	else if ( !(commandReg[0] == 1'b1 && regWriteDisable )) begin   //extra if logic so suppressed writes don't turn into reads
          readPending <= 1'b1;
          shiftReadReg <= 1'b1;
          registerAddress <= commandReg[7:1];//capture register being addressed for communication to readOut
          case ( commandReg[7:1] )  
            7'h00 : unloadSCReg <= 1'b1;
            7'h01 : unloadADCSReg1 <= 1'b1;
            7'h02 : unloadADCSReg2 <= 1'b1;
            7'h03 : unloadADCSReg3 <= 1'b1;
            7'h06 : unloadADCSReg6 <= 1'b1;
            7'h07 : unloadADCSReg7 <= 1'b1;
            7'h10 : unloadInputReg0 <= 1'b1;
            7'h11 : unloadInputReg1 <= 1'b1;
            7'h12 : unloadInputReg2 <= 1'b1;
            7'h13 : unloadInputReg3 <= 1'b1;
            7'h14 : unloadInputReg4 <= 1'b1;
            7'h15 : unloadInputReg5 <= 1'b1;
            7'h16 : unloadInputReg6 <= 1'b1;
            7'h17 : unloadInputReg7 <= 1'b1;
            7'h18 : unloadInputReg8 <= 1'b1;
            7'h19 : unloadInputReg9 <= 1'b1;
            7'h1a : unloadInputReg10 <= 1'b1;
            7'h1b : unloadInputReg11 <= 1'b1;
            7'h1c : unloadInputReg12 <= 1'b1;
            7'h1d : unloadInputReg13 <= 1'b1;
            7'h1e : unloadInputReg14 <= 1'b1;
            7'h1f : unloadInputReg15 <= 1'b1;
            7'h20 : unloadConfigReg0 <= 1'b1;
            7'h21 : unloadConfigReg1 <= 1'b1;
            7'h22 : unloadConfigReg2 <= 1'b1;
            7'h23 : unloadConfigReg3 <= 1'b1;
            7'h30 : unloadStatusReg0 <= 1'b1;
            7'h31 : unloadStatusReg1 <= 1'b1;
            7'h32 : unloadStatusReg2 <= 1'b1;
            7'h33 : unloadStatusReg3 <= 1'b1;
            /* ***
            7'h40 : unloadChannelReg0 <= 1'b1;
            7'h41 : unloadChannelReg1 <= 1'b1;
            7'h42 : unloadChannelReg2 <= 1'b1;
            7'h43 : unloadChannelReg3 <= 1'b1;
            7'h44 : unloadChannelReg4 <= 1'b1;
            7'h45 : unloadChannelReg5 <= 1'b1;
            7'h46 : unloadChannelReg6 <= 1'b1;
            7'h47 : unloadChannelReg7 <= 1'b1;
            7'h48 : unloadChannelReg8 <= 1'b1;
            7'h49 : unloadChannelReg9 <= 1'b1;
            7'h4a : unloadChannelReg10 <= 1'b1;
            7'h4b : unloadChannelReg11 <= 1'b1;
            7'h4c : unloadChannelReg12 <= 1'b1;
            7'h4d : unloadChannelReg13 <= 1'b1;
            7'h4e : unloadChannelReg14 <= 1'b1;
            7'h4f : unloadChannelReg15 <= 1'b1;
            7'h50 : unloadChannelReg16 <= 1'b1;
            7'h51 : unloadChannelReg17 <= 1'b1;
            7'h52 : unloadChannelReg18 <= 1'b1;
            7'h53 : unloadChannelReg19 <= 1'b1;
            7'h54 : unloadChannelReg20 <= 1'b1;
            7'h55 : unloadChannelReg21 <= 1'b1;
            7'h56 : unloadChannelReg22 <= 1'b1;
            7'h57 : unloadChannelReg23 <= 1'b1;
            7'h58 : unloadChannelReg24 <= 1'b1;
            7'h59 : unloadChannelReg25 <= 1'b1;
            7'h5a : unloadChannelReg26 <= 1'b1;
            7'h5b : unloadChannelReg27 <= 1'b1;
            7'h5c : unloadChannelReg28 <= 1'b1;
            7'h5d : unloadChannelReg29 <= 1'b1;
            7'h5e : unloadChannelReg30 <= 1'b1;
            7'h5f : unloadChannelReg31 <= 1'b1;
            7'h60 : unloadChannelReg32 <= 1'b1;
            7'h61 : unloadChannelReg33 <= 1'b1;
            7'h62 : unloadChannelReg34 <= 1'b1;
            7'h63 : unloadChannelReg35 <= 1'b1;
            7'h64 : unloadChannelReg36 <= 1'b1;
            7'h65 : unloadChannelReg37 <= 1'b1;
            7'h66 : unloadChannelReg38 <= 1'b1;
            7'h67 : unloadChannelReg39 <= 1'b1;
            */ 
            // CAL_EN            
            7'h68 : unloadChannelReg40 <= 1'b1;
            7'h69 : unloadChannelReg41 <= 1'b1;
            7'h6a : unloadChannelReg42 <= 1'b1;
            7'h6b : unloadChannelReg43 <= 1'b1;
            7'h6c : unloadChannelReg44 <= 1'b1;
            7'h6d : unloadChannelReg45 <= 1'b1;
            7'h6e : unloadChannelReg46 <= 1'b1;
            7'h6f : unloadChannelReg47 <= 1'b1;
            
            //other unload signals go here
            default : ;
          endcase
 	  //$display("Register read to chip %d",id[4:0]);
	end
      end //if id
    end  //register access
  end  //if commandBitCounter == 6'd25
  else begin  //not commandBitCounter == 6'd25
     unloadSCReg <= 1'b0;
     unloadADCSReg1 <= 1'b0;
     unloadADCSReg2 <= 1'b0;
     unloadADCSReg3 <= 1'b0;
     unloadADCSReg6 <= 1'b0;
     unloadADCSReg7 <= 1'b0;
     unloadConfigReg0 <= 1'b0;
     unloadConfigReg1 <= 1'b0;
     unloadConfigReg2 <= 1'b0;
     unloadConfigReg3 <= 1'b0;
     unloadInputReg0 <= 1'b0;
     unloadInputReg1 <= 1'b0;
     unloadInputReg2 <= 1'b0;
     unloadInputReg3 <= 1'b0;
     unloadInputReg4 <= 1'b0;
     unloadInputReg5 <= 1'b0;
     unloadInputReg6 <= 1'b0;
     unloadInputReg7 <= 1'b0;
     unloadInputReg8 <= 1'b0;
     unloadInputReg9 <= 1'b0;
     unloadInputReg10 <= 1'b0;
     unloadInputReg11 <= 1'b0;
     unloadInputReg12 <= 1'b0;
     unloadInputReg13 <= 1'b0;
     unloadInputReg14 <= 1'b0;
     unloadInputReg15 <= 1'b0;
     unloadStatusReg0 <= 1'b0; unloadStatusReg1 <= 1'b0; unloadStatusReg2 <= 1'b0; unloadStatusReg3 <= 1'b0;
     /* ***
     unloadChannelReg0 <= 1'b0; unloadChannelReg1 <= 1'b0; unloadChannelReg2 <= 1'b0; unloadChannelReg3 <= 1'b0;
     unloadChannelReg4 <= 1'b0; unloadChannelReg5 <= 1'b0; unloadChannelReg6 <= 1'b0; unloadChannelReg7 <= 1'b0;
     unloadChannelReg8 <= 1'b0; unloadChannelReg9 <= 1'b0; unloadChannelReg10 <= 1'b0; unloadChannelReg11 <= 1'b0;
     unloadChannelReg12 <= 1'b0; unloadChannelReg13 <= 1'b0; unloadChannelReg14 <= 1'b0; unloadChannelReg15 <= 1'b0;
     unloadChannelReg16 <= 1'b0; unloadChannelReg17 <= 1'b0; unloadChannelReg18 <= 1'b0; unloadChannelReg19 <= 1'b0;
     unloadChannelReg20 <= 1'b0; unloadChannelReg21 <= 1'b0; unloadChannelReg22 <= 1'b0; unloadChannelReg23 <= 1'b0;
     unloadChannelReg24 <= 1'b0; unloadChannelReg25 <= 1'b0; unloadChannelReg26 <= 1'b0; unloadChannelReg27 <= 1'b0;
     unloadChannelReg28 <= 1'b0; unloadChannelReg29 <= 1'b0; unloadChannelReg30 <= 1'b0; unloadChannelReg31 <= 1'b0;
     unloadChannelReg32 <= 1'b0; unloadChannelReg33 <= 1'b0; unloadChannelReg34 <= 1'b0; unloadChannelReg35 <= 1'b0;
     unloadChannelReg36 <= 1'b0; unloadChannelReg37 <= 1'b0; unloadChannelReg38 <= 1'b0; unloadChannelReg39 <= 1'b0;
     */
     // CAL_EN
     unloadChannelReg40 <= 1'b0; unloadChannelReg41 <= 1'b0; unloadChannelReg42 <= 1'b0; unloadChannelReg43 <= 1'b0;
     unloadChannelReg44 <= 1'b0; unloadChannelReg45 <= 1'b0; unloadChannelReg46 <= 1'b0; unloadChannelReg47 <= 1'b0;
    
  end //not commandBitCounter == 6'd25
  if ( commandBitCounter == 6'd57 & writePending == 1'b1 )  begin
     if ( shiftSCReg == 1'b1 )  loadSCReg <= 1'b1;
     if ( shiftADCSReg1 == 1'b1 )  loadADCSReg1 <= 1'b1;
     if ( shiftADCSReg2 == 1'b1 )  loadADCSReg2 <= 1'b1;
     if ( shiftADCSReg3 == 1'b1 )  loadADCSReg3 <= 1'b1;
     if ( shiftADCSReg6 == 1'b1 )  loadADCSReg6 <= 1'b1;
     if ( shiftADCSReg7 == 1'b1 )  loadADCSReg7 <= 1'b1;
     if ( shiftInputReg0 == 1'b1 )  loadInputReg0 <= 1'b1;
     if ( shiftInputReg1 == 1'b1 )  loadInputReg1 <= 1'b1;
     if ( shiftInputReg2 == 1'b1 )  loadInputReg2 <= 1'b1;
     if ( shiftInputReg3 == 1'b1 )  loadInputReg3 <= 1'b1;
     if ( shiftInputReg4 == 1'b1 )  loadInputReg4 <= 1'b1;
     if ( shiftInputReg5 == 1'b1 )  loadInputReg5 <= 1'b1;
     if ( shiftInputReg6 == 1'b1 )  loadInputReg6 <= 1'b1;
     if ( shiftInputReg7 == 1'b1 )  loadInputReg7 <= 1'b1;
     if ( shiftConfigReg0 == 1'b1 )  loadConfigReg0 <= 1'b1;
     if ( shiftConfigReg1 == 1'b1 )  loadConfigReg1 <= 1'b1;
     if ( shiftConfigReg2 == 1'b1 )  loadConfigReg2 <= 1'b1;
     if ( shiftConfigReg3 == 1'b1 )  loadConfigReg3 <= 1'b1;
     /* ***
     if ( shiftChannelReg0 == 1'b1 )  loadChannelReg0 <= 1'b1;
     if ( shiftChannelReg1 == 1'b1 )  loadChannelReg1 <= 1'b1;
     if ( shiftChannelReg2 == 1'b1 )  loadChannelReg2 <= 1'b1;
     if ( shiftChannelReg3 == 1'b1 )  loadChannelReg3 <= 1'b1;
     if ( shiftChannelReg4 == 1'b1 )  loadChannelReg4 <= 1'b1;
     if ( shiftChannelReg5 == 1'b1 )  loadChannelReg5 <= 1'b1;
     if ( shiftChannelReg6 == 1'b1 )  loadChannelReg6 <= 1'b1;
     if ( shiftChannelReg7 == 1'b1 )  loadChannelReg7 <= 1'b1;
     if ( shiftChannelReg8 == 1'b1 )  loadChannelReg8 <= 1'b1;
     if ( shiftChannelReg9 == 1'b1 )  loadChannelReg9 <= 1'b1;
     if ( shiftChannelReg10 == 1'b1 )  loadChannelReg10 <= 1'b1;
     if ( shiftChannelReg11 == 1'b1 )  loadChannelReg11 <= 1'b1;
     if ( shiftChannelReg12 == 1'b1 )  loadChannelReg12 <= 1'b1;
     if ( shiftChannelReg13 == 1'b1 )  loadChannelReg13 <= 1'b1;
     if ( shiftChannelReg14 == 1'b1 )  loadChannelReg14 <= 1'b1;
     if ( shiftChannelReg15 == 1'b1 )  loadChannelReg15 <= 1'b1;
     if ( shiftChannelReg16 == 1'b1 )  loadChannelReg16 <= 1'b1;
     if ( shiftChannelReg17 == 1'b1 )  loadChannelReg17 <= 1'b1;
     if ( shiftChannelReg18 == 1'b1 )  loadChannelReg18 <= 1'b1;
     if ( shiftChannelReg19 == 1'b1 )  loadChannelReg19 <= 1'b1;
     if ( shiftChannelReg20 == 1'b1 )  loadChannelReg20 <= 1'b1;
     if ( shiftChannelReg21 == 1'b1 )  loadChannelReg21 <= 1'b1;
     if ( shiftChannelReg22 == 1'b1 )  loadChannelReg22 <= 1'b1;
     if ( shiftChannelReg23 == 1'b1 )  loadChannelReg23 <= 1'b1;
     if ( shiftChannelReg24 == 1'b1 )  loadChannelReg24 <= 1'b1;
     if ( shiftChannelReg25 == 1'b1 )  loadChannelReg25 <= 1'b1;
     if ( shiftChannelReg26 == 1'b1 )  loadChannelReg26 <= 1'b1;
     if ( shiftChannelReg27 == 1'b1 )  loadChannelReg27 <= 1'b1;
     if ( shiftChannelReg28 == 1'b1 )  loadChannelReg28 <= 1'b1;
     if ( shiftChannelReg29 == 1'b1 )  loadChannelReg29 <= 1'b1;
     if ( shiftChannelReg30 == 1'b1 )  loadChannelReg30 <= 1'b1;
     if ( shiftChannelReg31 == 1'b1 )  loadChannelReg31 <= 1'b1;
     if ( shiftChannelReg32 == 1'b1 )  loadChannelReg32 <= 1'b1;
     if ( shiftChannelReg33 == 1'b1 )  loadChannelReg33 <= 1'b1;
     if ( shiftChannelReg34 == 1'b1 )  loadChannelReg34 <= 1'b1;
     if ( shiftChannelReg35 == 1'b1 )  loadChannelReg35 <= 1'b1;
     if ( shiftChannelReg36 == 1'b1 )  loadChannelReg36 <= 1'b1;
     if ( shiftChannelReg37 == 1'b1 )  loadChannelReg37 <= 1'b1;
     if ( shiftChannelReg38 == 1'b1 )  loadChannelReg38 <= 1'b1;
     if ( shiftChannelReg39 == 1'b1 )  loadChannelReg39 <= 1'b1;
     */
     // CAL_EN
     if ( shiftChannelReg40 == 1'b1 )  loadChannelReg40 <= 1'b1;
     if ( shiftChannelReg41 == 1'b1 )  loadChannelReg41 <= 1'b1;
     if ( shiftChannelReg42 == 1'b1 )  loadChannelReg42 <= 1'b1;
     if ( shiftChannelReg43 == 1'b1 )  loadChannelReg43 <= 1'b1;
     if ( shiftChannelReg44 == 1'b1 )  loadChannelReg44 <= 1'b1;
     if ( shiftChannelReg45 == 1'b1 )  loadChannelReg45 <= 1'b1;
     if ( shiftChannelReg46 == 1'b1 )  loadChannelReg46 <= 1'b1;
     if ( shiftChannelReg47 == 1'b1 )  loadChannelReg47 <= 1'b1;
     
     writePending <= 1'b0;
     shiftSCReg <= 1'b0;
     shiftADCSReg1 <= 1'b0;
     shiftADCSReg2 <= 1'b0;
     shiftADCSReg3 <= 1'b0;
     shiftADCSReg6 <= 1'b0;
     shiftADCSReg7 <= 1'b0;
     shiftInputReg0 <= 1'b0;
     shiftInputReg1 <= 1'b0;
     shiftInputReg2 <= 1'b0;
     shiftInputReg3 <= 1'b0;
     shiftInputReg4 <= 1'b0;
     shiftInputReg5 <= 1'b0;
     shiftInputReg6 <= 1'b0;
     shiftInputReg7 <= 1'b0;
     shiftInputReg8 <= 1'b0;
     shiftInputReg9 <= 1'b0;
     shiftInputReg10 <= 1'b0;
     shiftInputReg11 <= 1'b0;
     shiftInputReg12 <= 1'b0;
     shiftInputReg13 <= 1'b0;
     shiftInputReg14 <= 1'b0;
     shiftInputReg15 <= 1'b0;
     shiftConfigReg0 <= 1'b0;
     shiftConfigReg1 <= 1'b0;
     shiftConfigReg2 <= 1'b0;
     shiftConfigReg3 <= 1'b0;
     shiftStatusReg0 <= 1'b0; shiftStatusReg1 <= 1'b0; shiftStatusReg2 <= 1'b0; shiftStatusReg3 <= 1'b0;
     /* ***
     shiftChannelReg0 <= 1'b0; shiftChannelReg1 <= 1'b0; shiftChannelReg2 <= 1'b0; shiftChannelReg3 <= 1'b0;
     shiftChannelReg4 <= 1'b0; shiftChannelReg5 <= 1'b0; shiftChannelReg6 <= 1'b0; shiftChannelReg7 <= 1'b0;
     shiftChannelReg8 <= 1'b0; shiftChannelReg9 <= 1'b0; shiftChannelReg10 <= 1'b0; shiftChannelReg11 <= 1'b0;
     shiftChannelReg12 <= 1'b0; shiftChannelReg13 <= 1'b0; shiftChannelReg14 <= 1'b0; shiftChannelReg15 <= 1'b0;
     shiftChannelReg16 <= 1'b0; shiftChannelReg17 <= 1'b0; shiftChannelReg18 <= 1'b0; shiftChannelReg19 <= 1'b0;
     shiftChannelReg20 <= 1'b0; shiftChannelReg21 <= 1'b0; shiftChannelReg22 <= 1'b0; shiftChannelReg23 <= 1'b0;
     shiftChannelReg24 <= 1'b0; shiftChannelReg25 <= 1'b0; shiftChannelReg26 <= 1'b0; shiftChannelReg27 <= 1'b0;
     shiftChannelReg28 <= 1'b0; shiftChannelReg29 <= 1'b0; shiftChannelReg30 <= 1'b0; shiftChannelReg31 <= 1'b0;
     shiftChannelReg32 <= 1'b0; shiftChannelReg33 <= 1'b0; shiftChannelReg34 <= 1'b0; shiftChannelReg35 <= 1'b0;
     shiftChannelReg36 <= 1'b0; shiftChannelReg37 <= 1'b0; shiftChannelReg38 <= 1'b0; shiftChannelReg39 <= 1'b0;
     */
     shiftChannelReg40 <= 1'b0; shiftChannelReg41 <= 1'b0; shiftChannelReg42 <= 1'b0; shiftChannelReg43 <= 1'b0;
     shiftChannelReg44 <= 1'b0; shiftChannelReg45 <= 1'b0; shiftChannelReg46 <= 1'b0; shiftChannelReg47 <= 1'b0;
     
  end
  if ( commandBitCounter != 6'd57  )  begin
      loadSCReg <= 1'b0;
      loadADCSReg1 <= 1'b0;
      loadADCSReg2 <= 1'b0;
      loadADCSReg3 <= 1'b0;
      loadADCSReg6 <= 1'b0;
      loadADCSReg7 <= 1'b0;
      loadInputReg0 <= 1'b0;
      loadInputReg1 <= 1'b0;
      loadInputReg2 <= 1'b0;
      loadInputReg3 <= 1'b0;
      loadInputReg4 <= 1'b0;
      loadInputReg5 <= 1'b0;
      loadInputReg6 <= 1'b0;
      loadInputReg7 <= 1'b0;
      loadConfigReg0 <= 1'b0;
      loadConfigReg1 <= 1'b0;
      loadConfigReg2 <= 1'b0;
      loadConfigReg3 <= 1'b0;
      /* ***
      loadChannelReg0 <= 1'b0; loadChannelReg1 <= 1'b0; loadChannelReg2 <= 1'b0; loadChannelReg3 <= 1'b0;
      loadChannelReg4 <= 1'b0; loadChannelReg5 <= 1'b0; loadChannelReg6 <= 1'b0; loadChannelReg7 <= 1'b0;
      loadChannelReg8 <= 1'b0; loadChannelReg9 <= 1'b0; loadChannelReg10 <= 1'b0; loadChannelReg11 <= 1'b0;
      loadChannelReg12 <= 1'b0; loadChannelReg13 <= 1'b0; loadChannelReg14 <= 1'b0; loadChannelReg15 <= 1'b0;
      loadChannelReg16 <= 1'b0; loadChannelReg17 <= 1'b0; loadChannelReg18 <= 1'b0; loadChannelReg19 <= 1'b0;
      loadChannelReg20 <= 1'b0; loadChannelReg21 <= 1'b0; loadChannelReg22 <= 1'b0; loadChannelReg23 <= 1'b0;
      loadChannelReg24 <= 1'b0; loadChannelReg25 <= 1'b0; loadChannelReg26 <= 1'b0; loadChannelReg27 <= 1'b0;
      loadChannelReg28 <= 1'b0; loadChannelReg29 <= 1'b0; loadChannelReg30 <= 1'b0; loadChannelReg31 <= 1'b0;
      loadChannelReg32 <= 1'b0; loadChannelReg33 <= 1'b0; loadChannelReg34 <= 1'b0; loadChannelReg35 <= 1'b0;
      loadChannelReg36 <= 1'b0; loadChannelReg37 <= 1'b0; loadChannelReg38 <= 1'b0; loadChannelReg39 <= 1'b0;
      */     
      loadChannelReg40 <= 1'b0; loadChannelReg41 <= 1'b0; loadChannelReg42 <= 1'b0; loadChannelReg43 <= 1'b0;
      loadChannelReg44 <= 1'b0; loadChannelReg45 <= 1'b0; loadChannelReg46 <= 1'b0; loadChannelReg47 <= 1'b0;
       
  end //not 57, clear the load signals
//this is to extend the read-shifts by one clock to make up for the load occurring in the first clock
  if ( commandPending == 1'b0 & lastCommandPending == 1'b1 & readPending == 1'b1  )  begin  //equivalent to commandBitCounter == 58
     readPending <= 1'b0;
     shiftReadReg <= 1'b0;
     shiftSCReg <= 1'b0;
     shiftADCSReg1 <= 1'b0;
     shiftADCSReg2 <= 1'b0;
     shiftADCSReg3 <= 1'b0;
     shiftADCSReg6 <= 1'b0;
     shiftADCSReg7 <= 1'b0;
     shiftInputReg0 <= 1'b0;
     shiftInputReg1 <= 1'b0;
     shiftInputReg2 <= 1'b0;
     shiftInputReg3 <= 1'b0;
     shiftInputReg4 <= 1'b0;
     shiftInputReg5 <= 1'b0;
     shiftInputReg6 <= 1'b0;
     shiftInputReg7 <= 1'b0;
     shiftInputReg8 <= 1'b0;
     shiftInputReg9 <= 1'b0;
     shiftInputReg10 <= 1'b0;
     shiftInputReg11 <= 1'b0;
     shiftInputReg12 <= 1'b0;
     shiftInputReg13 <= 1'b0;
     shiftInputReg14 <= 1'b0;
     shiftInputReg15 <= 1'b0;
     shiftConfigReg0 <= 1'b0;
     shiftConfigReg1 <= 1'b0;
     shiftConfigReg2 <= 1'b0;
     shiftConfigReg3 <= 1'b0; 
     shiftStatusReg0 <= 1'b0; shiftStatusReg1 <= 1'b0; shiftStatusReg2 <= 1'b0; shiftStatusReg3 <= 1'b0;
     /* ***
     shiftChannelReg0 <= 1'b0; shiftChannelReg1 <= 1'b0; shiftChannelReg2 <= 1'b0; shiftChannelReg3 <= 1'b0;
     shiftChannelReg4 <= 1'b0; shiftChannelReg5 <= 1'b0; shiftChannelReg6 <= 1'b0; shiftChannelReg7 <= 1'b0;
     shiftChannelReg8 <= 1'b0; shiftChannelReg9 <= 1'b0; shiftChannelReg10 <= 1'b0; shiftChannelReg11 <= 1'b0;
     shiftChannelReg12 <= 1'b0; shiftChannelReg13 <= 1'b0; shiftChannelReg14 <= 1'b0; shiftChannelReg15 <= 1'b0;
     shiftChannelReg16 <= 1'b0; shiftChannelReg17 <= 1'b0; shiftChannelReg18 <= 1'b0; shiftChannelReg19 <= 1'b0;
     shiftChannelReg20 <= 1'b0; shiftChannelReg21 <= 1'b0; shiftChannelReg22 <= 1'b0; shiftChannelReg23 <= 1'b0;
     shiftChannelReg24 <= 1'b0; shiftChannelReg25 <= 1'b0; shiftChannelReg26 <= 1'b0; shiftChannelReg27 <= 1'b0;
     shiftChannelReg28 <= 1'b0; shiftChannelReg29 <= 1'b0; shiftChannelReg30 <= 1'b0; shiftChannelReg31 <= 1'b0;
     shiftChannelReg32 <= 1'b0; shiftChannelReg33 <= 1'b0; shiftChannelReg34 <= 1'b0; shiftChannelReg35 <= 1'b0;
     shiftChannelReg36 <= 1'b0; shiftChannelReg37 <= 1'b0; shiftChannelReg38 <= 1'b0; shiftChannelReg39 <= 1'b0;
     */
     shiftChannelReg40 <= 1'b0; shiftChannelReg41 <= 1'b0; shiftChannelReg42 <= 1'b0; shiftChannelReg43 <= 1'b0;
     shiftChannelReg44 <= 1'b0; shiftChannelReg45 <= 1'b0; shiftChannelReg46 <= 1'b0; shiftChannelReg47 <= 1'b0;
     loadReadReg <= 1'b1;
  end
  else
    loadReadReg <= 1'b0;
 end //not reset

//register data moves through the chip serially.  When a register is read,
//its serial contents must be parallelized in the read-landing-reg to be passed into the readOut module
//1-hot mux to steer serial register outputs into read landing reg
wire selectedRegRead;
assign selectedRegRead =  shiftSCReg  ? SCReg :
                     (shiftADCSReg1  ? ADCSreg1 :
                     (shiftADCSReg2  ? ADCSreg2 :
                     (shiftADCSReg3  ? ADCSreg3 :
                     (shiftADCSReg6  ? ADCSreg6 :
                     (shiftADCSReg7  ? ADCSreg7 :
                     (shiftConfigReg0  ? Creg0 :
                     (shiftConfigReg1 ? Creg1 :
                     (shiftConfigReg2 ? Creg2 :
                     (shiftConfigReg3 ? Creg3 :
                     ( shiftInputReg0 ? Ireg0 :
                     ( shiftInputReg1 ? Ireg1 :
                     ( shiftInputReg2 ? Ireg2 :
                     ( shiftInputReg3 ? Ireg3 :
                     ( shiftInputReg4 ? Ireg4 :
                     ( shiftInputReg5 ? Ireg5 :
                     ( shiftInputReg6 ? Ireg6 :
                     ( shiftInputReg7 ? Ireg7 :
                     ( shiftInputReg8 ? Ireg8 :
                     ( shiftInputReg9 ? Ireg9 :
                     ( shiftInputReg10 ? Ireg10 :
                     ( shiftInputReg11 ? Ireg11 :
                     ( shiftInputReg12 ? Ireg12 :
                     ( shiftInputReg13 ? Ireg13 :
                     ( shiftInputReg14 ? Ireg14 :
                     ( shiftInputReg15 ? Ireg15 :
                     ( shiftStatusReg0 ? STATUSreg0 :
                     ( shiftStatusReg1 ? STATUSreg1 :
                     ( shiftStatusReg2 ? STATUSreg2 :
                     ( shiftStatusReg3 ? STATUSreg3 :
                     /* ***
                     ( shiftChannelReg0 ? CHreg0 :
                     ( shiftChannelReg1 ? CHreg1 :
                     ( shiftChannelReg2 ? CHreg2 :
                     ( shiftChannelReg3 ? CHreg3 :
                     ( shiftChannelReg4 ? CHreg4 :
                     ( shiftChannelReg5 ? CHreg5 :
                     ( shiftChannelReg6 ? CHreg6 :
                     ( shiftChannelReg7 ? CHreg7 :
                     ( shiftChannelReg8 ? CHreg8 :
                     ( shiftChannelReg9 ? CHreg9 :
                     ( shiftChannelReg10 ? CHreg10 :
                     ( shiftChannelReg11 ? CHreg11 :
                     ( shiftChannelReg12 ? CHreg12 : ( shiftChannelReg13 ? CHreg13 : ( shiftChannelReg14 ? CHreg14 : ( shiftChannelReg15 ? CHreg15 :
                     ( shiftChannelReg16 ? CHreg16 : ( shiftChannelReg17 ? CHreg17 : ( shiftChannelReg18 ? CHreg18 : ( shiftChannelReg19 ? CHreg19 :
                     ( shiftChannelReg20 ? CHreg20 : ( shiftChannelReg21 ? CHreg21 : ( shiftChannelReg22 ? CHreg22 : ( shiftChannelReg23 ? CHreg23 :
                     ( shiftChannelReg24 ? CHreg24 : ( shiftChannelReg25 ? CHreg25 : ( shiftChannelReg26 ? CHreg26 : ( shiftChannelReg27 ? CHreg27 :
                     ( shiftChannelReg28 ? CHreg28 : ( shiftChannelReg29 ? CHreg29 : ( shiftChannelReg30 ? CHreg30 : ( shiftChannelReg31 ? CHreg31 :
                     ( shiftChannelReg32 ? CHreg32 : ( shiftChannelReg33 ? CHreg33 : ( shiftChannelReg34 ? CHreg34 : ( shiftChannelReg35 ? CHreg35 :
                     ( shiftChannelReg36 ? CHreg36 : ( shiftChannelReg37 ? CHreg37 : ( shiftChannelReg38 ? CHreg38 : ( shiftChannelReg39 ? CHreg39 :
                     */
                     ( shiftChannelReg40 ? CHreg40 : ( shiftChannelReg41 ? CHreg41 : ( shiftChannelReg42 ? CHreg42 : ( shiftChannelReg43 ? CHreg43 :
                     ( shiftChannelReg44 ? CHreg44 : ( shiftChannelReg45 ? CHreg45 : ( shiftChannelReg46 ? CHreg46 : ( shiftChannelReg47 ? CHreg47 :
                     
                      1'b0  
                     
                      )))))))))))))))))))))))))))))
               // *** ))))))))))))))))))))))))))))))))))))))))
                      ))))))));

               //     012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
               //               1         2         3         4         5         6         7         8 
//parallelizes serial read value from register being read for presentation to readOut module

readReg readLandingReg(
  .clk ( clk ),
  .rstb ( hardRstb ),
  .shiftIn ( selectedRegRead ),
  .shiftEn (shiftReadReg),
  .latchIn ( loadReadReg ),
  .dataOut ( regReadVal ),
  .push ( regReadPush )
);

endmodule //commandRegister

