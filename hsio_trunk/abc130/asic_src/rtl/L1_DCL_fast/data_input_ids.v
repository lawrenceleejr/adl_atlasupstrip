//--------------------------------------------------
//--                                                                                                                                                  
//--version 1.3  
//--                                                                                                                                                  
//--------------------------------------------------
//--------------------------------------------------
//  
//      Verilog code generated by Visual Elite
//
//  Design Unit:
//  ------------
//      Unit    Name  :  data_input_ids
//      Library Name  :  L1_DCL_fast
//  
//      Creation Date :  Wed Sep 12 15:04:53 2012
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
//  Library Name :  L1_DCL_fast
//  Unit    Name :  data_input_ids
//  Unit    Type :  Text Unit
//  
//----------------------------------------------------
//////////////////////////////////////////
//////////////////////////////////////////
// Date        : Fri May 13 09:44:46 2011
//
// Author      : Daniel La Marra
//
// Company     : Physics school - DPNC
//
// Description : Load the L0ID & the BCID
//
//////////////////////////////////////////
//////////////////////////////////////////

`timescale  1ns/1ps

module  data_input_ids(clk, rst_b, buffwr, indata, L1_BCids);

   input [15:0]  indata;
   input         clk, rst_b, buffwr;

   output [15:0] L1_BCids;

   wire [15:0] L1_BCids;

   reg [15:0]    BCids_reg_middle;

   assign L1_BCids = BCids_reg_middle;

   always @(posedge clk) begin
      if (~rst_b) begin
         BCids_reg_middle <= 16'h0000;
      end
      else begin
         if (buffwr) begin
            BCids_reg_middle <= indata[15:0];
         end
      end
   end
   
endmodule




