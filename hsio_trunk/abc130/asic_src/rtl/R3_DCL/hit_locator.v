`resetall
`timescale 1ns/10ps
module hit_locator(
	input [127:0] data_i,
	output [127:0] next_hit,
	output [6:0] hit_pos,
	output no_hits);

	wire [7:0] pos;
	assign pos =  (data_i[127]==1)?127:
                    (data_i[126]==1)?126:
                    (data_i[125]==1)?125:
                    (data_i[124]==1)?124:
                    (data_i[123]==1)?123:
                    (data_i[122]==1)?122:
                    (data_i[121]==1)?121:
                    (data_i[120]==1)?120:
                    (data_i[119]==1)?119:
                    (data_i[118]==1)?118:
                    (data_i[117]==1)?117:
                    (data_i[116]==1)?116:
                    (data_i[115]==1)?115:
                    (data_i[114]==1)?114:
                    (data_i[113]==1)?113:
                    (data_i[112]==1)?112:
                    (data_i[111]==1)?111:
                    (data_i[110]==1)?110:
                    (data_i[109]==1)?109:
                    (data_i[108]==1)?108:
                    (data_i[107]==1)?107:
                    (data_i[106]==1)?106:
                    (data_i[105]==1)?105:
                    (data_i[104]==1)?104:
                    (data_i[103]==1)?103:
                    (data_i[102]==1)?102:
                    (data_i[101]==1)?101:
                    (data_i[100]==1)?100:
                    (data_i[99]==1)?99:
                    (data_i[98]==1)?98:
                    (data_i[97]==1)?97:
                    (data_i[96]==1)?96:
                    (data_i[95]==1)?95:
                    (data_i[94]==1)?94:
                    (data_i[93]==1)?93:
                    (data_i[92]==1)?92:
                    (data_i[91]==1)?91:
                    (data_i[90]==1)?90:
                    (data_i[89]==1)?89:
                    (data_i[88]==1)?88:
                    (data_i[87]==1)?87:
                    (data_i[86]==1)?86:
                    (data_i[85]==1)?85:
                    (data_i[84]==1)?84:
                    (data_i[83]==1)?83:
                    (data_i[82]==1)?82:
                    (data_i[81]==1)?81:
                    (data_i[80]==1)?80:
                    (data_i[79]==1)?79:
                    (data_i[78]==1)?78:
                    (data_i[77]==1)?77:
                    (data_i[76]==1)?76:
                    (data_i[75]==1)?75:
                    (data_i[74]==1)?74:
                    (data_i[73]==1)?73:
                    (data_i[72]==1)?72:
                    (data_i[71]==1)?71:
                    (data_i[70]==1)?70:
                    (data_i[69]==1)?69:
                    (data_i[68]==1)?68:
                    (data_i[67]==1)?67:
                    (data_i[66]==1)?66:
                    (data_i[65]==1)?65:
                    (data_i[64]==1)?64:
                    (data_i[63]==1)?63:
                    (data_i[62]==1)?62:
                    (data_i[61]==1)?61:
                    (data_i[60]==1)?60:
                    (data_i[59]==1)?59:
                    (data_i[58]==1)?58:
                    (data_i[57]==1)?57:
                    (data_i[56]==1)?56:
                    (data_i[55]==1)?55:
                    (data_i[54]==1)?54:
                    (data_i[53]==1)?53:
                    (data_i[52]==1)?52:
                    (data_i[51]==1)?51:
                    (data_i[50]==1)?50:
                    (data_i[49]==1)?49:
                    (data_i[48]==1)?48:
                    (data_i[47]==1)?47:
                    (data_i[46]==1)?46:
                    (data_i[45]==1)?45:
                    (data_i[44]==1)?44:
                    (data_i[43]==1)?43:
                    (data_i[42]==1)?42:
                    (data_i[41]==1)?41:
                    (data_i[40]==1)?40:
                    (data_i[39]==1)?39:
                    (data_i[38]==1)?38:
                    (data_i[37]==1)?37:
                    (data_i[36]==1)?36:
                    (data_i[35]==1)?35:
                    (data_i[34]==1)?34:
                    (data_i[33]==1)?33:
                    (data_i[32]==1)?32:
                    (data_i[31]==1)?31:
                    (data_i[30]==1)?30:
                    (data_i[29]==1)?29:
                    (data_i[28]==1)?28:
                    (data_i[27]==1)?27:
                    (data_i[26]==1)?26:
                    (data_i[25]==1)?25:
                    (data_i[24]==1)?24:
                    (data_i[23]==1)?23:
                    (data_i[22]==1)?22:
                    (data_i[21]==1)?21:
                    (data_i[20]==1)?20:
                    (data_i[19]==1)?19:
                    (data_i[18]==1)?18:
                    (data_i[17]==1)?17:
                    (data_i[16]==1)?16:
                    (data_i[15]==1)?15:
                    (data_i[14]==1)?14:
                    (data_i[13]==1)?13:
                    (data_i[12]==1)?12:
                    (data_i[11]==1)?11:
                    (data_i[10]==1)?10:
                    (data_i[9]==1)?9:
                    (data_i[8]==1)?8:
                    (data_i[7]==1)?7:
                    (data_i[6]==1)?6:
                    (data_i[5]==1)?5:
                    (data_i[4]==1)?4:
                    (data_i[3]==1)?3:
                    (data_i[2]==1)?2:
                    (data_i[1]==1)?1:
		    (data_i[0]==1)?0:128;
	genvar i;
	generate 
	  for (i=127; i >= 0 ; i=i-1) begin : nexthit
		  assign next_hit[i] = (hit_pos==i)?0:data_i[i];
		end
	endgenerate
	
	assign no_hits = pos[7];
	assign hit_pos = pos[6:0];

endmodule
