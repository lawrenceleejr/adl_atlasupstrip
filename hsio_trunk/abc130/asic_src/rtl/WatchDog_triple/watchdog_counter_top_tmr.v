// done at 2013-01-14 15:33:41 using triple_script_v7.py






















































`timescale  1ns /  1ps


module watchdog_counter_top_tmr( 
			clk,
			rst_b,
			enable,
			remove_flag,
			wtdg_rstrt,
			wtdg_rst_b,
			flag
			);



///////////////////////////////////////////////////////////////////// 
/////parameters of top
parameter counter_width=2;
parameter count_limit=2'h3;

///////////////////////////////////////////////////////////////////// 
/////OLD inputs top_text of top
input clk, rst_b, enable, remove_flag, wtdg_rstrt;

///////////////////////////////////////////////////////////////////// 
/////NEW triple wires from the old inputs top_text of top
wire clk_1, rst_b_1, enable_1, remove_flag_1, wtdg_rstrt_1;
wire clk_2, rst_b_2, enable_2, remove_flag_2, wtdg_rstrt_2;
wire clk_3, rst_b_3, enable_3, remove_flag_3, wtdg_rstrt_3;

///////////////////////////////////////////////////////////////////// 
/////assign for the triplicated wires of top
assign clk_1=clk;
assign clk_2=clk;
assign clk_3=clk;
assign rst_b_1=rst_b;
assign rst_b_2=rst_b;
assign rst_b_3=rst_b;
assign enable_1=enable;
assign enable_2=enable;
assign enable_3=enable;
assign remove_flag_1=remove_flag;
assign remove_flag_2=remove_flag;
assign remove_flag_3=remove_flag;
assign wtdg_rstrt_1=wtdg_rstrt;
assign wtdg_rstrt_2=wtdg_rstrt;
assign wtdg_rstrt_3=wtdg_rstrt;

///////////////////////////////////////////////////////////////////// 
/////OUTPUTS singles to the outside of top
output wtdg_rst_b, flag;

///////////////////////////////////////////////////////////////////// 
/////_tri instance
watchdog_counter_tri  #( .counter_width(counter_width), .count_limit(count_limit)) watchdog_counter_1( .clk_1(clk_1), .rst_b_1(rst_b_1), .enable_1(enable_1), .remove_flag_1(remove_flag_1), .wtdg_rstrt_1(wtdg_rstrt_1), .clk_2(clk_2), .rst_b_2(rst_b_2), .enable_2(enable_2), .remove_flag_2(remove_flag_2), .wtdg_rstrt_2(wtdg_rstrt_2), .clk_3(clk_3), .rst_b_3(rst_b_3), .enable_3(enable_3), .remove_flag_3(remove_flag_3), .wtdg_rstrt_3(wtdg_rstrt_3), .wtdg_rst_b(wtdg_rst_b), .flag(flag));


endmodule
