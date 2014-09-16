
`timescale 1ns/10ps

module zero_one_detector #(parameter BC = 3)(
  input CLK,
  input RST,
  input [255:0] MEMA,
  input [271:0] MEMC,
  input EN,
  input buffwrA, //BC -1
  input buffwrC, //BC
  input buffwrD, //BC +1
  input busy,
  output [271:0] data_out,
  output START,
  output reg NO_0_1) ;


wire buffwr;

reg [255:0] buff_old;

reg [271:0] buff_new;

wire OR_o;

reg start_q;

reg [1:0] buff_count,buff_count_q;

always @(posedge CLK)
begin
  if (!RST) begin
    buff_old <= 0;
    buff_new <= 0;
    buff_count <= 0;
  end else if (buff_count == 2'd3) buff_count <= 2'd0;
  else begin
    if (buffwr & ~busy) begin  
      if (buff_count < BC+1) buff_count <= buff_count + 1;
      if (buff_count < BC) begin
        if (buffwrA) buff_old <= MEMA[255:0];
        else if (buffwrC) buff_new <= MEMC;
      end
    end
  end
end


assign data_out = buff_new;
assign START = start_q;
//assign NO_0_1 = ((EN) && (buff_count == BC) && (~start_q))?1'b1:1'b0;


always @(posedge CLK)
begin
  if (!RST) begin
    start_q <= 1'b0;
    buff_count_q <= 1'b0;
    NO_0_1 <= 1'b0;
  end
  else begin
    buff_count_q <= buff_count;
    start_q <= 1'b0;
    NO_0_1 <= 1'b0;
    if ((~EN) && (buff_count == BC) && (buff_count_q != BC)) start_q <= 1'b1;
    // Modif MKC : else if ((OR_o) && (buff_count == BC) && (buff_count_q != BC)) start_q <= 1'b1;
    else if ((OR_o) && (buff_count == BC-2) && (buff_count_q != BC-2)) start_q <= 1'b1;
    else if ((EN) && (buff_count == BC) && (buff_count_q != BC)) NO_0_1 <= 1'b1;
  end 
  
end

assign buffwr =   buffwrA || buffwrC || buffwrD;

assign OR_o = 
(~buff_old[255] && buff_new[255]) || (~buff_old[254] && buff_new[254]) || (~buff_old[253] && buff_new[253]) 
|| (~buff_old[252] && buff_new[252]) || (~buff_old[251] && buff_new[251]) || (~buff_old[250] && buff_new[250])
|| (~buff_old[249] && buff_new[249]) || (~buff_old[248] && buff_new[248]) || (~buff_old[247] && buff_new[247])
|| (~buff_old[246] && buff_new[246]) || (~buff_old[245] && buff_new[245]) || (~buff_old[244] && buff_new[244])
|| (~buff_old[243] && buff_new[243]) || (~buff_old[242] && buff_new[242]) || (~buff_old[241] && buff_new[241])
|| (~buff_old[240] && buff_new[240]) || (~buff_old[239] && buff_new[239]) || (~buff_old[238] && buff_new[238])
|| (~buff_old[237] && buff_new[237]) || (~buff_old[236] && buff_new[236]) || (~buff_old[235] && buff_new[235])
|| (~buff_old[234] && buff_new[234]) || (~buff_old[233] && buff_new[233]) || (~buff_old[232] && buff_new[232])
|| (~buff_old[231] && buff_new[231]) || (~buff_old[230] && buff_new[230]) || (~buff_old[229] && buff_new[229])
|| (~buff_old[228] && buff_new[228]) || (~buff_old[227] && buff_new[227]) || (~buff_old[226] && buff_new[226])
|| (~buff_old[225] && buff_new[225]) || (~buff_old[224] && buff_new[224]) || (~buff_old[223] && buff_new[223])
|| (~buff_old[222] && buff_new[222]) || (~buff_old[221] && buff_new[221]) || (~buff_old[220] && buff_new[220])
|| (~buff_old[219] && buff_new[219]) || (~buff_old[218] && buff_new[218]) || (~buff_old[217] && buff_new[217])
|| (~buff_old[216] && buff_new[216]) || (~buff_old[215] && buff_new[215]) || (~buff_old[214] && buff_new[214])
|| (~buff_old[213] && buff_new[213]) || (~buff_old[212] && buff_new[212]) || (~buff_old[211] && buff_new[211])
|| (~buff_old[210] && buff_new[210]) || (~buff_old[209] && buff_new[209]) || (~buff_old[208] && buff_new[208])
|| (~buff_old[207] && buff_new[207]) || (~buff_old[206] && buff_new[206]) || (~buff_old[205] && buff_new[205])
|| (~buff_old[204] && buff_new[204]) || (~buff_old[203] && buff_new[203]) || (~buff_old[202] && buff_new[202])
|| (~buff_old[201] && buff_new[201]) || (~buff_old[200] && buff_new[200]) || (~buff_old[199] && buff_new[199])
|| (~buff_old[198] && buff_new[198]) || (~buff_old[197] && buff_new[197]) || (~buff_old[196] && buff_new[196])
|| (~buff_old[195] && buff_new[195]) || (~buff_old[194] && buff_new[194]) || (~buff_old[193] && buff_new[193])
|| (~buff_old[192] && buff_new[192]) || (~buff_old[191] && buff_new[191]) || (~buff_old[190] && buff_new[190])
|| (~buff_old[189] && buff_new[189]) || (~buff_old[188] && buff_new[188]) || (~buff_old[187] && buff_new[187])
|| (~buff_old[186] && buff_new[186]) || (~buff_old[185] && buff_new[185]) || (~buff_old[184] && buff_new[184])
|| (~buff_old[183] && buff_new[183]) || (~buff_old[182] && buff_new[182]) || (~buff_old[181] && buff_new[181])
|| (~buff_old[180] && buff_new[180]) || (~buff_old[179] && buff_new[179]) || (~buff_old[178] && buff_new[178])
|| (~buff_old[177] && buff_new[177]) || (~buff_old[176] && buff_new[176]) || (~buff_old[175] && buff_new[175])
|| (~buff_old[174] && buff_new[174]) || (~buff_old[173] && buff_new[173]) || (~buff_old[172] && buff_new[172])
|| (~buff_old[171] && buff_new[171]) || (~buff_old[170] && buff_new[170]) || (~buff_old[169] && buff_new[169])
|| (~buff_old[168] && buff_new[168]) || (~buff_old[167] && buff_new[167]) || (~buff_old[166] && buff_new[166])
|| (~buff_old[165] && buff_new[165]) || (~buff_old[164] && buff_new[164]) || (~buff_old[163] && buff_new[163])
|| (~buff_old[162] && buff_new[162]) || (~buff_old[161] && buff_new[161]) || (~buff_old[160] && buff_new[160])
|| (~buff_old[159] && buff_new[159]) || (~buff_old[158] && buff_new[158]) || (~buff_old[157] && buff_new[157])
|| (~buff_old[156] && buff_new[156]) || (~buff_old[155] && buff_new[155]) || (~buff_old[154] && buff_new[154])
|| (~buff_old[153] && buff_new[153]) || (~buff_old[152] && buff_new[152]) || (~buff_old[151] && buff_new[151])
|| (~buff_old[150] && buff_new[150]) || (~buff_old[149] && buff_new[149]) || (~buff_old[148] && buff_new[148])
|| (~buff_old[147] && buff_new[147]) || (~buff_old[146] && buff_new[146]) || (~buff_old[145] && buff_new[145])
|| (~buff_old[144] && buff_new[144]) || (~buff_old[143] && buff_new[143]) || (~buff_old[142] && buff_new[142])
|| (~buff_old[141] && buff_new[141]) || (~buff_old[140] && buff_new[140]) || (~buff_old[139] && buff_new[139])
|| (~buff_old[138] && buff_new[138]) || (~buff_old[137] && buff_new[137]) || (~buff_old[136] && buff_new[136])
|| (~buff_old[135] && buff_new[135]) || (~buff_old[134] && buff_new[134]) || (~buff_old[133] && buff_new[133])
|| (~buff_old[132] && buff_new[132]) || (~buff_old[131] && buff_new[131]) || (~buff_old[130] && buff_new[130])
|| (~buff_old[129] && buff_new[129]) || (~buff_old[128] && buff_new[128]) || (~buff_old[127] && buff_new[127])
|| (~buff_old[126] && buff_new[126]) || (~buff_old[125] && buff_new[125]) || (~buff_old[124] && buff_new[124])
|| (~buff_old[123] && buff_new[123]) || (~buff_old[122] && buff_new[122]) || (~buff_old[121] && buff_new[121])
|| (~buff_old[120] && buff_new[120]) || (~buff_old[119] && buff_new[119]) || (~buff_old[118] && buff_new[118])
|| (~buff_old[117] && buff_new[117]) || (~buff_old[116] && buff_new[116]) || (~buff_old[115] && buff_new[115])
|| (~buff_old[114] && buff_new[114]) || (~buff_old[113] && buff_new[113]) || (~buff_old[112] && buff_new[112])
|| (~buff_old[111] && buff_new[111]) || (~buff_old[110] && buff_new[110]) || (~buff_old[109] && buff_new[109])
|| (~buff_old[108] && buff_new[108]) || (~buff_old[107] && buff_new[107]) || (~buff_old[106] && buff_new[106])
|| (~buff_old[105] && buff_new[105]) || (~buff_old[104] && buff_new[104]) || (~buff_old[103] && buff_new[103])
|| (~buff_old[102] && buff_new[102]) || (~buff_old[101] && buff_new[101]) || (~buff_old[100] && buff_new[100])
|| (~buff_old[99] && buff_new[99]) || (~buff_old[98] && buff_new[98]) || (~buff_old[97] && buff_new[97])
|| (~buff_old[96] && buff_new[96]) || (~buff_old[95] && buff_new[95]) || (~buff_old[94] && buff_new[94])
|| (~buff_old[93] && buff_new[93]) || (~buff_old[92] && buff_new[92]) || (~buff_old[91] && buff_new[91])
|| (~buff_old[90] && buff_new[90]) || (~buff_old[89] && buff_new[89]) || (~buff_old[88] && buff_new[88])
|| (~buff_old[87] && buff_new[87]) || (~buff_old[86] && buff_new[86]) || (~buff_old[85] && buff_new[85])
|| (~buff_old[84] && buff_new[84]) || (~buff_old[83] && buff_new[83]) || (~buff_old[82] && buff_new[82])
|| (~buff_old[81] && buff_new[81]) || (~buff_old[80] && buff_new[80]) || (~buff_old[79] && buff_new[79])
|| (~buff_old[78] && buff_new[78]) || (~buff_old[77] && buff_new[77]) || (~buff_old[76] && buff_new[76])
|| (~buff_old[75] && buff_new[75]) || (~buff_old[74] && buff_new[74]) || (~buff_old[73] && buff_new[73])
|| (~buff_old[72] && buff_new[72]) || (~buff_old[71] && buff_new[71]) || (~buff_old[70] && buff_new[70])
|| (~buff_old[69] && buff_new[69]) || (~buff_old[68] && buff_new[68]) || (~buff_old[67] && buff_new[67])
|| (~buff_old[66] && buff_new[66]) || (~buff_old[65] && buff_new[65]) || (~buff_old[64] && buff_new[64])
|| (~buff_old[63] && buff_new[63]) || (~buff_old[62] && buff_new[62]) || (~buff_old[61] && buff_new[61])
|| (~buff_old[60] && buff_new[60]) || (~buff_old[59] && buff_new[59]) || (~buff_old[58] && buff_new[58])
|| (~buff_old[57] && buff_new[57]) || (~buff_old[56] && buff_new[56]) || (~buff_old[55] && buff_new[55])
|| (~buff_old[54] && buff_new[54]) || (~buff_old[53] && buff_new[53]) || (~buff_old[52] && buff_new[52])
|| (~buff_old[51] && buff_new[51]) || (~buff_old[50] && buff_new[50]) || (~buff_old[49] && buff_new[49])
|| (~buff_old[48] && buff_new[48]) || (~buff_old[47] && buff_new[47]) || (~buff_old[46] && buff_new[46])
|| (~buff_old[45] && buff_new[45]) || (~buff_old[44] && buff_new[44]) || (~buff_old[43] && buff_new[43])
|| (~buff_old[42] && buff_new[42]) || (~buff_old[41] && buff_new[41]) || (~buff_old[40] && buff_new[40])
|| (~buff_old[39] && buff_new[39]) || (~buff_old[38] && buff_new[38]) || (~buff_old[37] && buff_new[37])
|| (~buff_old[36] && buff_new[36]) || (~buff_old[35] && buff_new[35]) || (~buff_old[34] && buff_new[34])
|| (~buff_old[33] && buff_new[33]) || (~buff_old[32] && buff_new[32]) || (~buff_old[31] && buff_new[31])
|| (~buff_old[30] && buff_new[30]) || (~buff_old[29] && buff_new[29]) || (~buff_old[28] && buff_new[28])
|| (~buff_old[27] && buff_new[27]) || (~buff_old[26] && buff_new[26]) || (~buff_old[25] && buff_new[25])
|| (~buff_old[24] && buff_new[24]) || (~buff_old[23] && buff_new[23]) || (~buff_old[22] && buff_new[22])
|| (~buff_old[21] && buff_new[21]) || (~buff_old[20] && buff_new[20]) || (~buff_old[19] && buff_new[19])
|| (~buff_old[18] && buff_new[18]) || (~buff_old[17] && buff_new[17]) || (~buff_old[16] && buff_new[16])
|| (~buff_old[15] && buff_new[15]) || (~buff_old[14] && buff_new[14]) || (~buff_old[13] && buff_new[13])
|| (~buff_old[12] && buff_new[12]) || (~buff_old[11] && buff_new[11]) || (~buff_old[10] && buff_new[10])
|| (~buff_old[9] && buff_new[9]) || (~buff_old[8] && buff_new[8]) || (~buff_old[7] && buff_new[7])
|| (~buff_old[6] && buff_new[6]) || (~buff_old[5] && buff_new[5]) || (~buff_old[4] && buff_new[4])
|| (~buff_old[3] && buff_new[3]) || (~buff_old[2] && buff_new[2]) || (~buff_old[1] && buff_new[1])
|| (~buff_old[0] && buff_new[0]) ;

endmodule
