`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////
//Code by : Vinata Koppal, Madhura Kamat Upenn
// Date: 08/27/2012
// Description: fastClusterFinder - fastReadOut, hitLocLatch and serializer put 
// together generates the hit location and sends the it serially .     ///
/////////////////////////////////////////////////////////////////////////////

module FcF_slow(inputFrntEnd, BCclk, reset_n, 
		dataV, latchedHitLocation);
   
   input [255:0] inputFrntEnd;
   input 	 BCclk;
   input  	 reset_n;
   output [31:0] latchedHitLocation;
   output 	 dataV;
   
   wire [31:0] 	 hitLocation;
   wire 	 dataV;
   
   wire [127:0] 	 BCdataLowerbits,BCdataHigherbits;
//   reg [127:0] 	 BCdataLower, BCdataHigher;
   reg [31:0] 	 latchedHitLocation;
   
   integer 	 i;


	 assign BCdataLowerbits[0]  = inputFrntEnd[0];
	 assign BCdataHigherbits[0]  = inputFrntEnd[1];
	 assign BCdataLowerbits[1]  = inputFrntEnd[2];
	 assign BCdataHigherbits[1]  = inputFrntEnd[3];
	 assign BCdataLowerbits[2]  = inputFrntEnd[4];
	 assign BCdataHigherbits[2]  = inputFrntEnd[5];
	 assign BCdataLowerbits[3]  = inputFrntEnd[6];
	 assign BCdataHigherbits[3]  = inputFrntEnd[7];
	 assign BCdataLowerbits[4]  = inputFrntEnd[8];
	 assign BCdataHigherbits[4]  = inputFrntEnd[9];
	 assign BCdataLowerbits[5]  = inputFrntEnd[10];
	 assign BCdataHigherbits[5]  = inputFrntEnd[11];
	 assign BCdataLowerbits[6]  = inputFrntEnd[12];
	 assign BCdataHigherbits[6]  = inputFrntEnd[13];
	 assign BCdataLowerbits[7]  = inputFrntEnd[14];
	 assign BCdataHigherbits[7]  = inputFrntEnd[15];
	 assign BCdataLowerbits[8]  = inputFrntEnd[16];
	 assign BCdataHigherbits[8]  = inputFrntEnd[17];
	 assign BCdataLowerbits[9]  = inputFrntEnd[18];
	 assign BCdataHigherbits[9]  = inputFrntEnd[19];
	 assign BCdataLowerbits[10]  = inputFrntEnd[20];
	 assign BCdataHigherbits[10]  = inputFrntEnd[21];
	 assign BCdataLowerbits[11]  = inputFrntEnd[22];
	 assign BCdataHigherbits[11]  = inputFrntEnd[23];
	 assign BCdataLowerbits[12]  = inputFrntEnd[24];
	 assign BCdataHigherbits[12]  = inputFrntEnd[25];
	 assign BCdataLowerbits[13]  = inputFrntEnd[26];
	 assign BCdataHigherbits[13]  = inputFrntEnd[27];
	 assign BCdataLowerbits[14]  = inputFrntEnd[28];
	 assign BCdataHigherbits[14]  = inputFrntEnd[29];
	 assign BCdataLowerbits[15]  = inputFrntEnd[30];
	 assign BCdataHigherbits[15]  = inputFrntEnd[31];
	 assign BCdataLowerbits[16]  = inputFrntEnd[32];
	 assign BCdataHigherbits[16]  = inputFrntEnd[33];
	 assign BCdataLowerbits[17]  = inputFrntEnd[34];
	 assign BCdataHigherbits[17]  = inputFrntEnd[35];
	 assign BCdataLowerbits[18]  = inputFrntEnd[36];
	 assign BCdataHigherbits[18]  = inputFrntEnd[37];
	 assign BCdataLowerbits[19]  = inputFrntEnd[38];
	 assign BCdataHigherbits[19]  = inputFrntEnd[39];
	 assign BCdataLowerbits[20]  = inputFrntEnd[40];
	 assign BCdataHigherbits[20]  = inputFrntEnd[41];
	 assign BCdataLowerbits[21]  = inputFrntEnd[42];
	 assign BCdataHigherbits[21]  = inputFrntEnd[43];
	 assign BCdataLowerbits[22]  = inputFrntEnd[44];
	 assign BCdataHigherbits[22]  = inputFrntEnd[45];
	 assign BCdataLowerbits[23]  = inputFrntEnd[46];
	 assign BCdataHigherbits[23]  = inputFrntEnd[47];
	 assign BCdataLowerbits[24]  = inputFrntEnd[48];
	 assign BCdataHigherbits[24]  = inputFrntEnd[49];
	 assign BCdataLowerbits[25]  = inputFrntEnd[50];
	 assign BCdataHigherbits[25]  = inputFrntEnd[51];
	 assign BCdataLowerbits[26]  = inputFrntEnd[52];
	 assign BCdataHigherbits[26]  = inputFrntEnd[53];
	 assign BCdataLowerbits[27]  = inputFrntEnd[54];
	 assign BCdataHigherbits[27]  = inputFrntEnd[55];
	 assign BCdataLowerbits[28]  = inputFrntEnd[56];
	 assign BCdataHigherbits[28]  = inputFrntEnd[57];
	 assign BCdataLowerbits[29]  = inputFrntEnd[58];
	 assign BCdataHigherbits[29]  = inputFrntEnd[59];
	 assign BCdataLowerbits[30]  = inputFrntEnd[60];
	 assign BCdataHigherbits[30]  = inputFrntEnd[61];
	 assign BCdataLowerbits[31]  = inputFrntEnd[62];
	 assign BCdataHigherbits[31]  = inputFrntEnd[63];
	 assign BCdataLowerbits[32]  = inputFrntEnd[64];
	 assign BCdataHigherbits[32]  = inputFrntEnd[65];
	 assign BCdataLowerbits[33]  = inputFrntEnd[66];
	 assign BCdataHigherbits[33]  = inputFrntEnd[67];
	 assign BCdataLowerbits[34]  = inputFrntEnd[68];
	 assign BCdataHigherbits[34]  = inputFrntEnd[69];
	 assign BCdataLowerbits[35]  = inputFrntEnd[70];
	 assign BCdataHigherbits[35]  = inputFrntEnd[71];
	 assign BCdataLowerbits[36]  = inputFrntEnd[72];
	 assign BCdataHigherbits[36]  = inputFrntEnd[73];
	 assign BCdataLowerbits[37]  = inputFrntEnd[74];
	 assign BCdataHigherbits[37]  = inputFrntEnd[75];
	 assign BCdataLowerbits[38]  = inputFrntEnd[76];
	 assign BCdataHigherbits[38]  = inputFrntEnd[77];
	 assign BCdataLowerbits[39]  = inputFrntEnd[78];
	 assign BCdataHigherbits[39]  = inputFrntEnd[79];
	 assign BCdataLowerbits[40]  = inputFrntEnd[80];
	 assign BCdataHigherbits[40]  = inputFrntEnd[81];
	 assign BCdataLowerbits[41]  = inputFrntEnd[82];
	 assign BCdataHigherbits[41]  = inputFrntEnd[83];
	 assign BCdataLowerbits[42]  = inputFrntEnd[84];
	 assign BCdataHigherbits[42]  = inputFrntEnd[85];
	 assign BCdataLowerbits[43]  = inputFrntEnd[86];
	 assign BCdataHigherbits[43]  = inputFrntEnd[87];
	 assign BCdataLowerbits[44]  = inputFrntEnd[88];
	 assign BCdataHigherbits[44]  = inputFrntEnd[89];
	 assign BCdataLowerbits[45]  = inputFrntEnd[90];
	 assign BCdataHigherbits[45]  = inputFrntEnd[91];
	 assign BCdataLowerbits[46]  = inputFrntEnd[92];
	 assign BCdataHigherbits[46]  = inputFrntEnd[93];
	 assign BCdataLowerbits[47]  = inputFrntEnd[94];
	 assign BCdataHigherbits[47]  = inputFrntEnd[95];
	 assign BCdataLowerbits[48]  = inputFrntEnd[96];
	 assign BCdataHigherbits[48]  = inputFrntEnd[97];
	 assign BCdataLowerbits[49]  = inputFrntEnd[98];
	 assign BCdataHigherbits[49]  = inputFrntEnd[99];
	 assign BCdataLowerbits[50]  = inputFrntEnd[100];
	 assign BCdataHigherbits[50]  = inputFrntEnd[101];
	 assign BCdataLowerbits[51]  = inputFrntEnd[102];
	 assign BCdataHigherbits[51]  = inputFrntEnd[103];
	 assign BCdataLowerbits[52]  = inputFrntEnd[104];
	 assign BCdataHigherbits[52]  = inputFrntEnd[105];
	 assign BCdataLowerbits[53]  = inputFrntEnd[106];
	 assign BCdataHigherbits[53]  = inputFrntEnd[107];
	 assign BCdataLowerbits[54]  = inputFrntEnd[108];
	 assign BCdataHigherbits[54]  = inputFrntEnd[109];
	 assign BCdataLowerbits[55]  = inputFrntEnd[110];
	 assign BCdataHigherbits[55]  = inputFrntEnd[111];
	 assign BCdataLowerbits[56]  = inputFrntEnd[112];
	 assign BCdataHigherbits[56]  = inputFrntEnd[113];
	 assign BCdataLowerbits[57]  = inputFrntEnd[114];
	 assign BCdataHigherbits[57]  = inputFrntEnd[115];
	 assign BCdataLowerbits[58]  = inputFrntEnd[116];
	 assign BCdataHigherbits[58]  = inputFrntEnd[117];
	 assign BCdataLowerbits[59]  = inputFrntEnd[118];
	 assign BCdataHigherbits[59]  = inputFrntEnd[119];
	 assign BCdataLowerbits[60]  = inputFrntEnd[120];
	 assign BCdataHigherbits[60]  = inputFrntEnd[121];
	 assign BCdataLowerbits[61]  = inputFrntEnd[122];
	 assign BCdataHigherbits[61]  = inputFrntEnd[123];
	 assign BCdataLowerbits[62]  = inputFrntEnd[124];
	 assign BCdataHigherbits[62]  = inputFrntEnd[125];
	 assign BCdataLowerbits[63]  = inputFrntEnd[126];
	 assign BCdataHigherbits[63]  = inputFrntEnd[127];
	 assign BCdataLowerbits[64]  = inputFrntEnd[128];
	 assign BCdataHigherbits[64]  = inputFrntEnd[129];
	 assign BCdataLowerbits[65]  = inputFrntEnd[130];
	 assign BCdataHigherbits[65]  = inputFrntEnd[131];
	 assign BCdataLowerbits[66]  = inputFrntEnd[132];
	 assign BCdataHigherbits[66]  = inputFrntEnd[133];
	 assign BCdataLowerbits[67]  = inputFrntEnd[134];
	 assign BCdataHigherbits[67]  = inputFrntEnd[135];
	 assign BCdataLowerbits[68]  = inputFrntEnd[136];
	 assign BCdataHigherbits[68]  = inputFrntEnd[137];
	 assign BCdataLowerbits[69]  = inputFrntEnd[138];
	 assign BCdataHigherbits[69]  = inputFrntEnd[139];
	 assign BCdataLowerbits[70]  = inputFrntEnd[140];
	 assign BCdataHigherbits[70]  = inputFrntEnd[141];
	 assign BCdataLowerbits[71]  = inputFrntEnd[142];
	 assign BCdataHigherbits[71]  = inputFrntEnd[143];
	 assign BCdataLowerbits[72]  = inputFrntEnd[144];
	 assign BCdataHigherbits[72]  = inputFrntEnd[145];
	 assign BCdataLowerbits[73]  = inputFrntEnd[146];
	 assign BCdataHigherbits[73]  = inputFrntEnd[147];
	 assign BCdataLowerbits[74]  = inputFrntEnd[148];
	 assign BCdataHigherbits[74]  = inputFrntEnd[149];
	 assign BCdataLowerbits[75]  = inputFrntEnd[150];
	 assign BCdataHigherbits[75]  = inputFrntEnd[151];
	 assign BCdataLowerbits[76]  = inputFrntEnd[152];
	 assign BCdataHigherbits[76]  = inputFrntEnd[153];
	 assign BCdataLowerbits[77]  = inputFrntEnd[154];
	 assign BCdataHigherbits[77]  = inputFrntEnd[155];
	 assign BCdataLowerbits[78]  = inputFrntEnd[156];
	 assign BCdataHigherbits[78]  = inputFrntEnd[157];
	 assign BCdataLowerbits[79]  = inputFrntEnd[158];
	 assign BCdataHigherbits[79]  = inputFrntEnd[159];
	 assign BCdataLowerbits[80]  = inputFrntEnd[160];
	 assign BCdataHigherbits[80]  = inputFrntEnd[161];
	 assign BCdataLowerbits[81]  = inputFrntEnd[162];
	 assign BCdataHigherbits[81]  = inputFrntEnd[163];
	 assign BCdataLowerbits[82]  = inputFrntEnd[164];
	 assign BCdataHigherbits[82]  = inputFrntEnd[165];
	 assign BCdataLowerbits[83]  = inputFrntEnd[166];
	 assign BCdataHigherbits[83]  = inputFrntEnd[167];
	 assign BCdataLowerbits[84]  = inputFrntEnd[168];
	 assign BCdataHigherbits[84]  = inputFrntEnd[169];
	 assign BCdataLowerbits[85]  = inputFrntEnd[170];
	 assign BCdataHigherbits[85]  = inputFrntEnd[171];
	 assign BCdataLowerbits[86]  = inputFrntEnd[172];
	 assign BCdataHigherbits[86]  = inputFrntEnd[173];
	 assign BCdataLowerbits[87]  = inputFrntEnd[174];
	 assign BCdataHigherbits[87]  = inputFrntEnd[175];
	 assign BCdataLowerbits[88]  = inputFrntEnd[176];
	 assign BCdataHigherbits[88]  = inputFrntEnd[177];
	 assign BCdataLowerbits[89]  = inputFrntEnd[178];
	 assign BCdataHigherbits[89]  = inputFrntEnd[179];
	 assign BCdataLowerbits[90]  = inputFrntEnd[180];
	 assign BCdataHigherbits[90]  = inputFrntEnd[181];
	 assign BCdataLowerbits[91]  = inputFrntEnd[182];
	 assign BCdataHigherbits[91]  = inputFrntEnd[183];
	 assign BCdataLowerbits[92]  = inputFrntEnd[184];
	 assign BCdataHigherbits[92]  = inputFrntEnd[185];
	 assign BCdataLowerbits[93]  = inputFrntEnd[186];
	 assign BCdataHigherbits[93]  = inputFrntEnd[187];
	 assign BCdataLowerbits[94]  = inputFrntEnd[188];
	 assign BCdataHigherbits[94]  = inputFrntEnd[189];
	 assign BCdataLowerbits[95]  = inputFrntEnd[190];
	 assign BCdataHigherbits[95]  = inputFrntEnd[191];
	 assign BCdataLowerbits[96]  = inputFrntEnd[192];
	 assign BCdataHigherbits[96]  = inputFrntEnd[193];
	 assign BCdataLowerbits[97]  = inputFrntEnd[194];
	 assign BCdataHigherbits[97]  = inputFrntEnd[195];
	 assign BCdataLowerbits[98]  = inputFrntEnd[196];
	 assign BCdataHigherbits[98]  = inputFrntEnd[197];
	 assign BCdataLowerbits[99]  = inputFrntEnd[198];
	 assign BCdataHigherbits[99]  = inputFrntEnd[199];
	 assign BCdataLowerbits[100]  = inputFrntEnd[200];
	 assign BCdataHigherbits[100]  = inputFrntEnd[201];
	 assign BCdataLowerbits[101]  = inputFrntEnd[202];
	 assign BCdataHigherbits[101]  = inputFrntEnd[203];
	 assign BCdataLowerbits[102]  = inputFrntEnd[204];
	 assign BCdataHigherbits[102]  = inputFrntEnd[205];
	 assign BCdataLowerbits[103]  = inputFrntEnd[206];
	 assign BCdataHigherbits[103]  = inputFrntEnd[207];
	 assign BCdataLowerbits[104]  = inputFrntEnd[208];
	 assign BCdataHigherbits[104]  = inputFrntEnd[209];
	 assign BCdataLowerbits[105]  = inputFrntEnd[210];
	 assign BCdataHigherbits[105]  = inputFrntEnd[211];
	 assign BCdataLowerbits[106]  = inputFrntEnd[212];
	 assign BCdataHigherbits[106]  = inputFrntEnd[213];
	 assign BCdataLowerbits[107]  = inputFrntEnd[214];
	 assign BCdataHigherbits[107]  = inputFrntEnd[215];
	 assign BCdataLowerbits[108]  = inputFrntEnd[216];
	 assign BCdataHigherbits[108]  = inputFrntEnd[217];
	 assign BCdataLowerbits[109]  = inputFrntEnd[218];
	 assign BCdataHigherbits[109]  = inputFrntEnd[219];
	 assign BCdataLowerbits[110]  = inputFrntEnd[220];
	 assign BCdataHigherbits[110]  = inputFrntEnd[221];
	 assign BCdataLowerbits[111]  = inputFrntEnd[222];
	 assign BCdataHigherbits[111]  = inputFrntEnd[223];
	 assign BCdataLowerbits[112]  = inputFrntEnd[224];
	 assign BCdataHigherbits[112]  = inputFrntEnd[225];
	 assign BCdataLowerbits[113]  = inputFrntEnd[226];
	 assign BCdataHigherbits[113]  = inputFrntEnd[227];
	 assign BCdataLowerbits[114]  = inputFrntEnd[228];
	 assign BCdataHigherbits[114]  = inputFrntEnd[229];
	 assign BCdataLowerbits[115]  = inputFrntEnd[230];
	 assign BCdataHigherbits[115]  = inputFrntEnd[231];
	 assign BCdataLowerbits[116]  = inputFrntEnd[232];
	 assign BCdataHigherbits[116]  = inputFrntEnd[233];
	 assign BCdataLowerbits[117]  = inputFrntEnd[234];
	 assign BCdataHigherbits[117]  = inputFrntEnd[235];
	 assign BCdataLowerbits[118]  = inputFrntEnd[236];
	 assign BCdataHigherbits[118]  = inputFrntEnd[237];
	 assign BCdataLowerbits[119]  = inputFrntEnd[238];
	 assign BCdataHigherbits[119]  = inputFrntEnd[239];
	 assign BCdataLowerbits[120]  = inputFrntEnd[240];
	 assign BCdataHigherbits[120]  = inputFrntEnd[241];
	 assign BCdataLowerbits[121]  = inputFrntEnd[242];
	 assign BCdataHigherbits[121]  = inputFrntEnd[243];
	 assign BCdataLowerbits[122]  = inputFrntEnd[244];
	 assign BCdataHigherbits[122]  = inputFrntEnd[245];
	 assign BCdataLowerbits[123]  = inputFrntEnd[246];
	 assign BCdataHigherbits[123]  = inputFrntEnd[247];
	 assign BCdataLowerbits[124]  = inputFrntEnd[248];
	 assign BCdataHigherbits[124]  = inputFrntEnd[249];
	 assign BCdataLowerbits[125]  = inputFrntEnd[250];
	 assign BCdataHigherbits[125]  = inputFrntEnd[251];
	 assign BCdataLowerbits[126]  = inputFrntEnd[252];
	 assign BCdataHigherbits[126]  = inputFrntEnd[253];
	 assign BCdataLowerbits[127]  = inputFrntEnd[254];
	 assign BCdataHigherbits[127]  = inputFrntEnd[255];
   
    
//Generate 32 bit hit location
   fastReadOut uut      (.BCclk(BCclk),.BCdataLowerbits(BCdataLowerbits),

			 .BCdataHigherbits(BCdataHigherbits),
			 .hitLocation(hitLocation));

      

// Latching the hit location at the negative edge
   /*
   hitLocLatch hitloclat (.hitLocation(hitLocation),
			  .BCclk(BCclk),
			  .DFFreset( ~resetB );
			  .latchedHitLocation(latchedHitLocation),
			  .dataV( dataV ) );
    */

   assign dataV = reset_n ? ~BCclk : 1'b0;

   always @ (negedge BCclk or negedge reset_n)
   begin
   	if (!reset_n)
		latchedHitLocation <= 32'hffff_ffff;
	else 
		latchedHitLocation <= hitLocation;
   end// always
   
   
endmodule // CompleteSystem


