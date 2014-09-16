// done at 2013-01-14 15:33:41 using triple_script_v7.py






















































`timescale  1ns /  1ps


module watchdog_counter_tri( 
			clk_1,
			rst_b_1,
			enable_1,
			remove_flag_1,
			wtdg_rstrt_1,
			clk_2,
			rst_b_2,
			enable_2,
			remove_flag_2,
			wtdg_rstrt_2,
			clk_3,
			rst_b_3,
			enable_3,
			remove_flag_3,
			wtdg_rstrt_3,
			wtdg_rst_b,
			flag
			);



///////////////////////////////////////////////////////////////////// 
/////parameters
parameter counter_width=2;
parameter count_limit=2'h3;

///////////////////////////////////////////////////////////////////// 
/////NEW triple inputs from the the top tripled inputs
input clk_1, rst_b_1, enable_1, remove_flag_1, wtdg_rstrt_1;
input clk_2, rst_b_2, enable_2, remove_flag_2, wtdg_rstrt_2;
input clk_3, rst_b_3, enable_3, remove_flag_3, wtdg_rstrt_3;

///////////////////////////////////////////////////////////////////// 
/////NEW OUTPUTS now wires tri
wire flag_o__1;
wire flag_o__2;
wire flag_o__3;

///////////////////////////////////////////////////////////////////// 
/////NEW OUTPUTS BUSES now wires tri
wire  [(counter_width-1):0] counter_o__1;
wire  [(counter_width-1):0] counter_o__2;
wire  [(counter_width-1):0] counter_o__3;

///////////////////////////////////////////////////////////////////// 
/////wire buses from internal registers tri
wire [(counter_width-1):0]  counter;

///////////////////////////////////////////////////////////////////// 
/////OLD OUTPUTS now wires
wire wtdg_rst_b_1;
wire wtdg_rst_b_2;
wire wtdg_rst_b_3;

///////////////////////////////////////////////////////////////////// 
/////OUTPUTS singles to the outside
output wtdg_rst_b, flag;

///////////////////////////////////////////////////////////////////// 
/////triplicated instances
watchdog_counter_internal #( .counter_width(counter_width), .count_limit(count_limit)) watchdog_counter_internal_1( .clk(clk_1), .rst_b(rst_b_1), .enable(enable_1), .remove_flag(remove_flag_1), .wtdg_rstrt(wtdg_rstrt_1), .counter_i_(counter), .wtdg_rst_b(wtdg_rst_b_1), .flag_o_(flag_o__1), .counter_o_(counter_o__1));

watchdog_counter_internal #( .counter_width(counter_width), .count_limit(count_limit)) watchdog_counter_internal_2( .clk(clk_2), .rst_b(rst_b_2), .enable(enable_2), .remove_flag(remove_flag_2), .wtdg_rstrt(wtdg_rstrt_2), .counter_i_(counter), .wtdg_rst_b(wtdg_rst_b_2), .flag_o_(flag_o__2), .counter_o_(counter_o__2));

watchdog_counter_internal #( .counter_width(counter_width), .count_limit(count_limit)) watchdog_counter_internal_3( .clk(clk_3), .rst_b(rst_b_3), .enable(enable_3), .remove_flag(remove_flag_3), .wtdg_rstrt(wtdg_rstrt_3), .counter_i_(counter), .wtdg_rst_b(wtdg_rst_b_3), .flag_o_(flag_o__3), .counter_o_(counter_o__3));

majority_voter #(.WIDTH( 2 +(counter_width-1)-0+1)) mv (
		.in1({wtdg_rst_b_1, flag_o__1, counter_o__1}),
		.in2({wtdg_rst_b_2, flag_o__2, counter_o__2}),
		.in3({wtdg_rst_b_3, flag_o__3, counter_o__3}),
		.out({wtdg_rst_b, flag, counter}),
		.err()
	);
endmodule
