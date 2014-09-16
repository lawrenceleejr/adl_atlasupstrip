//--------------------------------------------------
//--                                           
//-- version 1.6  
//--                                           
//--------------------------------------------------
//--------------------------------------------------
//  
//      Verilog code generated by Visual Elite
//
//  Design Unit:
//  ------------
//      Unit    Name  :  re_arrange
//      Library Name  :  L1_DCL
//  
//      Creation Date :  Thu Dec 01 15:18:52 2011
//      Version       :  2011.02 v4.3.0 build 24. Date: Mar 21 2011. License: 2011.3
//  
//  Options Used:
//  -------------
//      Target
//         Language   :  Verilog
//         Purpose    :  Synthesis
//         Vendor     :  Leonardo
//  
//      Style
//         Use tasks                      :  No
//         Code Destination               :  Combined file
//         Attach Directives              :  Yes
//         Structural                     :  No
//         Free text style                :  / / ...
//         Preserve spacing for free text :  Yes
//         Declaration alignment          :  No
//
//--------------------------------------------------
//--------------------------------------------------
//  
//  Library Name :  L1_DCL
//  Unit    Name :  re_arrange
//  Unit    Type :  Text Unit
//  
//----------------------------------------------------
//////////////////////////////////////////
//////////////////////////////////////////
// Date        : Tue Feb 22 10:20:32 2011
//
// Author      : Daniel La Marra
//
// Company     : Physics School - DPNC
//
// Description : Re-arrange data coming from pipeline
//
//////////////////////////////////////////
//////////////////////////////////////////

`timescale 1ns/100ps

module  re_arrange (indata, data_odd, data_even);

   input [255 : 0]  indata;
   
   output [127 : 0] data_odd;
   output [127 : 0] data_even;

   wire [255 : 0]   indata;
   wire [127 : 0]   data_odd;
   wire [127 : 0]   data_even;

   assign           data_even[0] = indata[0];
   assign           data_even[1] = indata[2];
   assign           data_even[2] = indata[4];
   assign           data_even[3] = indata[6];
   assign           data_even[4] = indata[8];
   assign           data_even[5] = indata[10];
   assign           data_even[6] = indata[12];
   assign           data_even[7] = indata[14];
   assign           data_even[8] = indata[16];
   assign           data_even[9] = indata[18];
   assign           data_even[10] = indata[20];

   assign           data_even[11] = indata[22];
   assign           data_even[12] = indata[24];
   assign           data_even[13] = indata[26];
   assign           data_even[14] = indata[28];
   assign           data_even[15] = indata[30];
   assign           data_even[16] = indata[32];
   assign           data_even[17] = indata[34];
   assign           data_even[18] = indata[36];
   assign           data_even[19] = indata[38];
   assign           data_even[20] = indata[40];
   
   assign           data_even[21] = indata[42];
   assign           data_even[22] = indata[44];
   assign           data_even[23] = indata[46];
   assign           data_even[24] = indata[48];
   assign           data_even[25] = indata[50];
   assign           data_even[26] = indata[52];
   assign           data_even[27] = indata[54];
   assign           data_even[28] = indata[56];
   assign           data_even[29] = indata[58];
   assign           data_even[30] = indata[60];

   assign           data_even[31] = indata[62];
   assign           data_even[32] = indata[64];
   assign           data_even[33] = indata[66];
   assign           data_even[34] = indata[68];
   assign           data_even[35] = indata[70];
   assign           data_even[36] = indata[72];
   assign           data_even[37] = indata[74];
   assign           data_even[38] = indata[76];
   assign           data_even[39] = indata[78];
   assign           data_even[40] = indata[80];
   
   assign           data_even[41] = indata[82];
   assign           data_even[42] = indata[84];
   assign           data_even[43] = indata[86];
   assign           data_even[44] = indata[88];
   assign           data_even[45] = indata[90];
   assign           data_even[46] = indata[92];
   assign           data_even[47] = indata[94];
   assign           data_even[48] = indata[96];
   assign           data_even[49] = indata[98];
   assign           data_even[50] = indata[100];
   
   assign           data_even[51] = indata[102];
   assign           data_even[52] = indata[104];
   assign           data_even[53] = indata[106];
   assign           data_even[54] = indata[108];
   assign           data_even[55] = indata[110];
   assign           data_even[56] = indata[112];
   assign           data_even[57] = indata[114];
   assign           data_even[58] = indata[116];
   assign           data_even[59] = indata[118];
   assign           data_even[60] = indata[120];

   assign           data_even[61] = indata[122];
   assign           data_even[62] = indata[124];
   assign           data_even[63] = indata[126];
   assign           data_even[64] = indata[128];
   assign           data_even[65] = indata[130];
   assign           data_even[66] = indata[132];
   assign           data_even[67] = indata[134];
   assign           data_even[68] = indata[136];
   assign           data_even[69] = indata[138];
   assign           data_even[70] = indata[140];
   
   assign           data_even[71] = indata[142];
   assign           data_even[72] = indata[144];
   assign           data_even[73] = indata[146];
   assign           data_even[74] = indata[148];
   assign           data_even[75] = indata[150];
   assign           data_even[76] = indata[152];
   assign           data_even[77] = indata[154];
   assign           data_even[78] = indata[156];
   assign           data_even[79] = indata[158];
   assign           data_even[80] = indata[160];

   assign           data_even[81] = indata[162];
   assign           data_even[82] = indata[164];
   assign           data_even[83] = indata[166];
   assign           data_even[84] = indata[168];
   assign           data_even[85] = indata[170];
   assign           data_even[86] = indata[172];
   assign           data_even[87] = indata[174];
   assign           data_even[88] = indata[176];
   assign           data_even[89] = indata[178];
   assign           data_even[90] = indata[180];
   
   assign           data_even[91] = indata[182];
   assign           data_even[92] = indata[184];
   assign           data_even[93] = indata[186];
   assign           data_even[94] = indata[188];
   assign           data_even[95] = indata[190];
   assign           data_even[96] = indata[192];
   assign           data_even[97] = indata[194];
   assign           data_even[98] = indata[196];
   assign           data_even[99] = indata[198];
   assign           data_even[100] = indata[200];

   assign           data_even[101] = indata[202];
   assign           data_even[102] = indata[204];
   assign           data_even[103] = indata[206];
   assign           data_even[104] = indata[208];
   assign           data_even[105] = indata[210];
   assign           data_even[106] = indata[212];
   assign           data_even[107] = indata[214];
   assign           data_even[108] = indata[216];
   assign           data_even[109] = indata[218];
   assign           data_even[110] = indata[220];

   assign           data_even[111] = indata[222];
   assign           data_even[112] = indata[224];
   assign           data_even[113] = indata[226];
   assign           data_even[114] = indata[228];
   assign           data_even[115] = indata[230];
   assign           data_even[116] = indata[232];
   assign           data_even[117] = indata[234];
   assign           data_even[118] = indata[236];
   assign           data_even[119] = indata[238];
   assign           data_even[120] = indata[240];
   
   assign           data_even[121] = indata[242];
   assign           data_even[122] = indata[244];
   assign           data_even[123] = indata[246];
   assign           data_even[124] = indata[248];
   assign           data_even[125] = indata[250];
   assign           data_even[126] = indata[252];
   assign           data_even[127] = indata[254];

   assign           data_odd[0] = indata[1];
   assign           data_odd[1] = indata[3];
   assign           data_odd[2] = indata[5];
   assign           data_odd[3] = indata[7];
   assign           data_odd[4] = indata[9];
   assign           data_odd[5] = indata[11];
   assign           data_odd[6] = indata[13];
   assign           data_odd[7] = indata[15];
   assign           data_odd[8] = indata[17];
   assign           data_odd[9] = indata[19];
   assign           data_odd[10] = indata[21];
   
   assign           data_odd[11] = indata[23];
   assign           data_odd[12] = indata[25];
   assign           data_odd[13] = indata[27];
   assign           data_odd[14] = indata[29];
   assign           data_odd[15] = indata[31];
   assign           data_odd[16] = indata[33];
   assign           data_odd[17] = indata[35];
   assign           data_odd[18] = indata[37];
   assign           data_odd[19] = indata[39];
   assign           data_odd[20] = indata[41];

   assign           data_odd[21] = indata[43];
   assign           data_odd[22] = indata[45];
   assign           data_odd[23] = indata[47];
   assign           data_odd[24] = indata[49];
   assign           data_odd[25] = indata[51];
   assign           data_odd[26] = indata[53];
   assign           data_odd[27] = indata[55];
   assign           data_odd[28] = indata[57];
   assign           data_odd[29] = indata[59];
   assign           data_odd[30] = indata[61];

   assign           data_odd[31] = indata[63];
   assign           data_odd[32] = indata[65];
   assign           data_odd[33] = indata[67];
   assign           data_odd[34] = indata[69];
   assign           data_odd[35] = indata[71];
   assign           data_odd[36] = indata[73];
   assign           data_odd[37] = indata[75];
   assign           data_odd[38] = indata[77];
   assign           data_odd[39] = indata[79];
   assign           data_odd[40] = indata[81];

   assign           data_odd[41] = indata[83];
   assign           data_odd[42] = indata[85];
   assign           data_odd[43] = indata[87];
   assign           data_odd[44] = indata[89];
   assign           data_odd[45] = indata[91];
   assign           data_odd[46] = indata[93];
   assign           data_odd[47] = indata[95];
   assign           data_odd[48] = indata[97];
   assign           data_odd[49] = indata[99];
   assign           data_odd[50] = indata[101];
   
   assign           data_odd[51] = indata[103];
   assign           data_odd[52] = indata[105];
   assign           data_odd[53] = indata[107];
   assign           data_odd[54] = indata[109];
   assign           data_odd[55] = indata[111];
   assign           data_odd[56] = indata[113];
   assign           data_odd[57] = indata[115];
   assign           data_odd[58]= indata[117];
   assign           data_odd[59] = indata[119];
   assign           data_odd[60] = indata[121];
   
   assign           data_odd[61] = indata[123];
   assign           data_odd[62] = indata[125];
   assign           data_odd[63] = indata[127];
   assign           data_odd[64] = indata[129];
   assign           data_odd[65] = indata[131];
   assign           data_odd[66] = indata[133];
   assign           data_odd[67] = indata[135];
   assign           data_odd[68] = indata[137];
   assign           data_odd[69] = indata[139];
   assign           data_odd[70] = indata[141];

   assign           data_odd[71] = indata[143];
   assign           data_odd[72] = indata[145];
   assign           data_odd[73] = indata[147];
   assign           data_odd[74] = indata[149];
   assign           data_odd[75] = indata[151];
   assign           data_odd[76] = indata[153];
   assign           data_odd[77] = indata[155];
   assign           data_odd[78] = indata[157];
   assign           data_odd[79] = indata[159];
   assign           data_odd[80] = indata[161];

   assign           data_odd[81] = indata[163];
   assign           data_odd[82] = indata[165];
   assign           data_odd[83] = indata[167];
   assign           data_odd[84] = indata[169];
   assign           data_odd[85] = indata[171];
   assign           data_odd[86] = indata[173];
   assign           data_odd[87] = indata[175];
   assign           data_odd[88] = indata[177];
   assign           data_odd[89] = indata[179];
   assign           data_odd[90] = indata[181];

   assign           data_odd[91] = indata[183];
   assign           data_odd[92] = indata[185];
   assign           data_odd[93] = indata[187];
   assign           data_odd[94] = indata[189];
   assign           data_odd[95] = indata[191];
   assign           data_odd[96] = indata[193];
   assign           data_odd[97] = indata[195];
   assign           data_odd[98] = indata[197];
   assign           data_odd[99] = indata[199];
   assign           data_odd[100] = indata[201];
   
   assign           data_odd[101] = indata[203];
   assign           data_odd[102] = indata[205];
   assign           data_odd[103] = indata[207];
   assign           data_odd[104] = indata[209];
   assign           data_odd[105] = indata[211];
   assign           data_odd[106] = indata[213];
   assign           data_odd[107] = indata[215];
   assign           data_odd[108] = indata[217];
   assign           data_odd[109] = indata[219];
   assign           data_odd[110] = indata[221];
   
   assign           data_odd[111] = indata[223];
   assign           data_odd[112] = indata[225];
   assign           data_odd[113] = indata[227];
   assign           data_odd[114] = indata[229];
   assign           data_odd[115] = indata[231];
   assign           data_odd[116] = indata[233];
   assign           data_odd[117] = indata[235];
   assign           data_odd[118] = indata[237];
   assign           data_odd[119] = indata[239];
   assign           data_odd[120] = indata[241];

   assign           data_odd[121] = indata[243];
   assign           data_odd[122] = indata[245];
   assign           data_odd[123] = indata[247];
   assign           data_odd[124] = indata[249];
   assign           data_odd[125] = indata[251];
   assign           data_odd[126] = indata[253];
   assign           data_odd[127] = indata[255];

endmodule


