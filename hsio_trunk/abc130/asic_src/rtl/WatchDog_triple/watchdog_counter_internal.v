// done at 2013-01-14 15:33:41 using triple_script_v7.py






















































`timescale  1ns /  1ps

module watchdog_counter_internal ( 
	clk,
	rst_b,
	enable,
	remove_flag,
	wtdg_rstrt,
	counter_i_,
	wtdg_rst_b,
	flag_o_,
	counter_o_);


///////////////////////////////////////////////////////////////////// 
/////parameters
parameter counter_width=2;
parameter count_limit=2'h3;

///////////////////////////////////////////////////////////////////// 
/////OLD inputs
input clk, rst_b, enable, remove_flag, wtdg_rstrt;

///////////////////////////////////////////////////////////////////// 
/////OLD OUTPUTS
output wtdg_rst_b;

///////////////////////////////////////////////////////////////////// 
/////OLD wires
wire clk, rst_b, enable, remove_flag, wtdg_rstrt, wtdg_rst_b;

///////////////////////////////////////////////////////////////////// 
/////NEW INPUTS

///////////////////////////////////////////////////////////////////// 
/////NEW OUTPUTS
output flag_o_;

///////////////////////////////////////////////////////////////////// 
/////NEW INPUT BUSES
input  [(counter_width-1):0] counter_i_;

///////////////////////////////////////////////////////////////////// 
/////NEW OUTPUT BUSES
output  [(counter_width-1):0] counter_o_;

///////////////////////////////////////////////////////////////////// 
/////NEW regs
reg flag_o_;



///////////////////////////////////////////////////////////////////// 
/////NEW bus regs
reg  [(counter_width-1):0] counter_o_;

///////////////////////////////////////////////////////////////////// 
/////assign blocks
assign wtdg_rst_b = (|counter_o_) || ~enable;

///////////////////////////////////////////////////////////////////// 
/////always blocks

always @(posedge clk) begin
   if (~rst_b) begin
      flag_o_ <= 1'b0;
      counter_o_ <= count_limit;
   end
   else begin
      if (enable) begin
         if (~wtdg_rst_b) begin
            flag_o_ <= 1'b1;
         end
         else begin
            if (remove_flag) begin
               flag_o_ <= 1'b0;
            end
         end
         if (wtdg_rstrt) begin
            counter_o_ <= count_limit;
         end
         else begin
            counter_o_ <= counter_i_ - 1;
         end
      end
   end
end

endmodule
