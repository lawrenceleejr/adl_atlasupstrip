
`timescale 1ns / 1ps

module clock_gate_bs( enable, clk_in, clk_out );

   input enable;
   input clk_in;

   output clk_out;

   assign clk_out = enable & clk_in;

endmodule // clock_gate

/*
 * Broken
 *
   
   always @ ( module_en or clk )
     if ( !clk )
       clk_en = module_en;
   assign gclk = clk && clk_en;
  
 */
