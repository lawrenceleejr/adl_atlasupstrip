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
//      Unit    Name  :  controller
//      Library Name  :  L1_DCL_fast
//  
//      Creation Date :  Wed Sep 12 15:04:17 2012
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
//         IF for state selection         :  No
//         Error (default) state          :  Yes
//         String typed state variable    :  No
//         Next state assignments         :  Non blocking
//         Free text style                :  / / ...
//         Preserve spacing for free text :  Yes
//         Declaration alignment          :  No
//         Sort Ports by mode             :  No
//         New line for each Port         :  No
//         Attach comment to Port         :  No
//
//--------------------------------------------------
//--------------------------------------------------
//  
//  Library Name :  L1_DCL_fast
//  Unit    Name :  controller
//  Unit    Type :  State Machine
//  
//----------------------------------------------------
 
 
`timescale 1ns/1ps
module controller (clk, rst_b, busy, buffwr, odd_dwn_scan, even_dwn_scan,
                   odd_up_scan, even_up_scan, odd_dwn_hit_found,
                   even_dwn_hit_found, odd_up_hit_found, even_up_hit_found,
                   odd_dwn_selected, even_dwn_selected, odd_up_selected,
                   even_up_selected, next_hit, datavalid,
                   even_dwn_scan_finished, odd_dwn_scan_finished,
                   even_up_scan_finished, odd_up_scan_finished,
                   even_dwn_force_scan, odd_dwn_force_scan, even_up_force_scan,
                   odd_up_force_scan, finished, wtdg_rstrt, limit_reached
                   );
 
  input clk;
  wire clk;
  input rst_b;
  wire rst_b;
  output busy;
  reg busy;
  input buffwr;
  wire buffwr;
  output odd_dwn_scan;
  reg odd_dwn_scan;
  output even_dwn_scan;
  reg even_dwn_scan;
  output odd_up_scan;
  reg odd_up_scan;
  output even_up_scan;
  reg even_up_scan;
  input odd_dwn_hit_found;
  wire odd_dwn_hit_found;
  input even_dwn_hit_found;
  wire even_dwn_hit_found;
  input odd_up_hit_found;
  wire odd_up_hit_found;
  input even_up_hit_found;
  wire even_up_hit_found;
  output odd_dwn_selected;
  reg odd_dwn_selected;
  output even_dwn_selected;
  reg even_dwn_selected;
  output odd_up_selected;
  reg odd_up_selected;
  output even_up_selected;
  reg even_up_selected;
  input next_hit;
  wire next_hit;
  output datavalid;
  reg datavalid;
  input even_dwn_scan_finished;
  wire even_dwn_scan_finished;
  input odd_dwn_scan_finished;
  wire odd_dwn_scan_finished;
  input even_up_scan_finished;
  wire even_up_scan_finished;
  input odd_up_scan_finished;
  wire odd_up_scan_finished;
  output even_dwn_force_scan;
  reg even_dwn_force_scan;
  output odd_dwn_force_scan;
  reg odd_dwn_force_scan;
  output even_up_force_scan;
  reg even_up_force_scan;
  output odd_up_force_scan;
  reg odd_up_force_scan;
  output finished;
  wire finished;
  output wtdg_rstrt;
  reg wtdg_rstrt;
  input limit_reached;
  wire limit_reached;
  reg scan;
  reg odd_dwn_dcl_done;
  reg even_dwn_dcl_done;
  reg odd_up_dcl_done;
  reg even_up_dcl_done;
  reg odd_dwn_next;
  reg even_dwn_next;
  reg odd_up_next;
  reg even_up_next;
  reg [2:0] edwn_count;
  reg [2:0] odwn_count;
  reg [2:0] eup_count;
  reg [2:0] oup_count;
  reg lmt_reached_reg;
 
  parameter RST      = 3'b000,
            BFFWR    = 3'b001,
            EVEN_DWN = 3'b010,
            EVEN_UP  = 3'b011,
            ODD_DWN  = 3'b100,
            ODD_UP   = 3'b101;
 
 
  reg [2:0] visual_RST_current;
 
 
  parameter EDW_WAIT  = 3'b000,
            EDWCHECK  = 3'b001,
            EDW_SCAN  = 3'b010,
            EDW_SCAN4 = 3'b011,
            EDW_STP   = 3'b100;
 
 
  reg [2:0] visual_EDW_WAIT_current;
 
 
  parameter ODW_WAIT  = 3'b000,
            ODWCHECK  = 3'b001,
            ODW_SCAN  = 3'b010,
            ODW_SCAN4 = 3'b011,
            ODW_STP   = 3'b100;
 
 
  reg [2:0] visual_ODW_WAIT_current;
 
 
  parameter EUP_WAIT  = 3'b000,
            EUPCHECK  = 3'b001,
            EUP_SCAN  = 3'b010,
            EUP_SCAN4 = 3'b011,
            EUP_STP   = 3'b100;
 
 
  reg [2:0] visual_EUP_WAIT_current;
 
 
  parameter OUP_WAIT  = 3'b000,
            OUPCHECK  = 3'b001,
            OUP_SCAN  = 3'b010,
            OUP_SCAN4 = 3'b011,
            OUP_STP   = 3'b100;
 
 
  reg [2:0] visual_OUP_WAIT_current;
 
 
 
  // Synchronous process
  always  @(posedge clk)
  begin : controller_RST
 
    if (~(rst_b))
    begin
      lmt_reached_reg <= 1'b0;
      busy <= 1'b0;
      scan <= 1'b0;
      odd_dwn_next <= 1'b0;
      even_dwn_next <= 1'b0;
      odd_up_next <= 1'b0;
      even_up_next <= 1'b0;
      odd_dwn_selected <= 1'b0;
      even_dwn_selected <= 1'b0;
      odd_up_selected <= 1'b0;
      even_up_selected <= 1'b0;
      datavalid <= 1'b0;
      wtdg_rstrt <= 1'b1;
      visual_RST_current <= RST;
    end
    else
    begin
 
      case (visual_RST_current)  // exemplar parallel_case full_case
        RST:
          begin
            if (buffwr)
            begin
              wtdg_rstrt <= 1'b0;
              lmt_reached_reg <= 1'b0;
              busy<=1'b1;
              visual_RST_current <= BFFWR;
            end
            else
            begin
              visual_RST_current <= RST;
            end
          end
 
        BFFWR:
          begin
            if (finished && ~(even_dwn_dcl_done) && ~(odd_dwn_dcl_done) && ~(
                even_up_dcl_done) && ~(odd_up_dcl_done) && next_hit ||
                limit_reached)
            begin
              lmt_reached_reg <= limit_reached;
              busy <= 1'b0;
              scan <= 1'b0;
              odd_dwn_next <= 1'b0;
              even_dwn_next <= 1'b0;
              odd_up_next <= 1'b0;
              even_up_next <= 1'b0;
              odd_dwn_selected <= 1'b0;
              even_dwn_selected <= 1'b0;
              odd_up_selected <= 1'b0;
              even_up_selected <= 1'b0;
              datavalid <= 1'b0;
              wtdg_rstrt <= 1'b1;
              visual_RST_current <= RST;
            end
            else if (even_dwn_dcl_done && ~(even_dwn_next))
            begin
              even_dwn_selected <= 1'b1;
              datavalid <= 1'b1;
              odd_dwn_next <= 1'b0;
              even_up_next <= 1'b0;
              odd_up_next <= 1'b0;
              visual_RST_current <= EVEN_DWN;
            end
            else if (odd_dwn_dcl_done && ~(odd_dwn_next))
            begin
              odd_dwn_selected <= 1'b1;
              datavalid <= 1'b1;
              even_dwn_next <= 1'b0;
              even_up_next <= 1'b0;
              odd_up_next <= 1'b0;
              visual_RST_current <= ODD_DWN;
            end
            else if (even_up_dcl_done && ~(even_up_next))
            begin
              even_up_selected <= 1'b1;
              datavalid <= 1'b1;
              even_dwn_next <= 1'b0;
              odd_dwn_next <= 1'b0;
              odd_up_next <= 1'b0;
              visual_RST_current <= EVEN_UP;
            end
            else if (odd_up_dcl_done && ~(odd_up_next))
            begin
              odd_up_selected <= 1'b1;
              datavalid <= 1'b1;
              even_dwn_next <= 1'b0;
              odd_dwn_next <= 1'b0;
              even_up_next <= 1'b0;
              visual_RST_current <= ODD_UP;
            end
            else
            begin
              scan <= 1'b1;
              even_dwn_next <= 1'b0;
              odd_dwn_next <= 1'b0;
              even_up_next <= 1'b0;
              odd_up_next <= 1'b0;
              visual_RST_current <= BFFWR;
            end
          end
 
        EVEN_DWN:
          begin
            if (next_hit || limit_reached)
            begin
              even_dwn_next <= 1'b1;
              even_dwn_selected <= 1'b0;
              datavalid <= 1'b0;
              busy<=1'b1;
              visual_RST_current <= BFFWR;
            end
            else
            begin
              visual_RST_current <= EVEN_DWN;
            end
          end
 
        EVEN_UP:
          begin
            if (next_hit || limit_reached)
            begin
              even_up_next <= 1'b1;
              even_up_selected <= 1'b0;
              datavalid <= 1'b0;
              busy<=1'b1;
              visual_RST_current <= BFFWR;
            end
            else
            begin
              visual_RST_current <= EVEN_UP;
            end
          end
 
        ODD_DWN:
          begin
            if (next_hit || limit_reached)
            begin
              odd_dwn_next <= 1'b1;
              odd_dwn_selected <= 1'b0;
              datavalid <= 1'b0;
              busy<=1'b1;
              visual_RST_current <= BFFWR;
            end
            else
            begin
              visual_RST_current <= ODD_DWN;
            end
          end
 
        ODD_UP:
          begin
            if (next_hit || limit_reached)
            begin
              odd_up_next <= 1'b1;
              odd_up_selected <= 1'b0;
              datavalid <= 1'b0;
              busy<=1'b1;
              visual_RST_current <= BFFWR;
            end
            else
            begin
              visual_RST_current <= ODD_UP;
            end
          end
 
        default:
          begin
            busy <= 1'b0;
            scan <= 1'b0;
            odd_dwn_next <= 1'b0;
            even_dwn_next <= 1'b0;
            odd_up_next <= 1'b0;
            even_up_next <= 1'b0;
            odd_dwn_selected <= 1'b0;
            even_dwn_selected <= 1'b0;
            odd_up_selected <= 1'b0;
            even_up_selected <= 1'b0;
            datavalid <= 1'b0;
            wtdg_rstrt <= 1'b1;
            visual_RST_current <= RST;
          end
      endcase
    end
  end
 
 
 
  // Synchronous process
  always  @(posedge clk or negedge rst_b)
  begin : controller_EDW_WAIT
 
    if (~(rst_b))
    begin
      even_dwn_scan <= 1'b0;
      even_dwn_dcl_done <= 1'b0;
      edwn_count <= 3'b000;
      even_dwn_force_scan <= 1'b0;
      visual_EDW_WAIT_current <= EDW_WAIT;
    end
    else
    begin
 
      case (visual_EDW_WAIT_current)  // exemplar parallel_case full_case
        EDW_WAIT:
          begin
            if (scan == 1)
            begin
              visual_EDW_WAIT_current <= EDWCHECK;
            end
            else
            begin
              visual_EDW_WAIT_current <= EDW_WAIT;
            end
          end
 
        EDWCHECK:
          begin
            if (even_dwn_hit_found == 0)
            begin
              even_dwn_scan <= 1'b1;
              even_dwn_force_scan <= 1'b0;
              visual_EDW_WAIT_current <= EDW_SCAN;
            end
            else if (even_dwn_hit_found == 1)
            begin
              even_dwn_dcl_done <= 1'b1;
              even_dwn_scan <= 1'b0;
              edwn_count <= 3'b100;
              visual_EDW_WAIT_current <= EDW_STP;
            end
            else
              visual_EDW_WAIT_current <= EDWCHECK;
          end
 
        EDW_SCAN:
          begin
            if (even_dwn_hit_found == 1 && scan == 1)
            begin
              even_dwn_dcl_done <= 1'b1;
              even_dwn_scan <= 1'b0;
              edwn_count <= 3'b100;
              visual_EDW_WAIT_current <= EDW_STP;
            end
            else if (scan == 0)
            begin
              even_dwn_scan <= 1'b0;
              even_dwn_dcl_done <= 1'b0;
              edwn_count <= 3'b000;
              even_dwn_force_scan <= 1'b0;
              visual_EDW_WAIT_current <= EDW_WAIT;
            end
            else
            begin
              visual_EDW_WAIT_current <= EDW_SCAN;
            end
          end
 
        EDW_SCAN4:
          begin
            if (edwn_count != 3'b000 && scan == 1)
            begin
              edwn_count <= edwn_count - 1;
              visual_EDW_WAIT_current <= EDW_SCAN4;
            end
            else if (edwn_count == 3'b000 && scan == 1)
            begin
              even_dwn_scan <= 1'b1;
              even_dwn_force_scan <= 1'b0;
              visual_EDW_WAIT_current <= EDW_SCAN;
            end
            else if (scan == 0)
            begin
              even_dwn_scan <= 1'b0;
              even_dwn_dcl_done <= 1'b0;
              edwn_count <= 3'b000;
              even_dwn_force_scan <= 1'b0;
              visual_EDW_WAIT_current <= EDW_WAIT;
            end
            else
              visual_EDW_WAIT_current <= EDW_SCAN4;
          end
 
        EDW_STP:
          begin
            if (scan == 0)
            begin
              even_dwn_scan <= 1'b0;
              even_dwn_dcl_done <= 1'b0;
              edwn_count <= 3'b000;
              even_dwn_force_scan <= 1'b0;
              visual_EDW_WAIT_current <= EDW_WAIT;
            end
            else if (even_dwn_next == 1 && scan == 1)
            begin
              edwn_count <= edwn_count - 1;
              even_dwn_scan <= 1'b1;
              even_dwn_dcl_done <= 1'b0;
              even_dwn_force_scan <= 1'b1;
              visual_EDW_WAIT_current <= EDW_SCAN4;
            end
            else if (even_dwn_next == 0 && scan == 1)
            begin
              visual_EDW_WAIT_current <= EDW_STP;
            end
            else
              visual_EDW_WAIT_current <= EDW_STP;
          end
 
        default:
          begin
            even_dwn_scan <= 1'b0;
            even_dwn_dcl_done <= 1'b0;
            edwn_count <= 3'b000;
            even_dwn_force_scan <= 1'b0;
            visual_EDW_WAIT_current <= EDW_WAIT;
          end
      endcase
    end
  end
 
 
 
  // Synchronous process
  always  @(posedge clk or negedge rst_b)
  begin : controller_ODW_WAIT
 
    if (~(rst_b))
    begin
      odd_dwn_scan <= 1'b0;
      odd_dwn_dcl_done <= 1'b0;
      odwn_count <= 3'b000;
      odd_dwn_force_scan <= 1'b0;
      visual_ODW_WAIT_current <= ODW_WAIT;
    end
    else
    begin
 
      case (visual_ODW_WAIT_current)  // exemplar parallel_case full_case
        ODW_WAIT:
          begin
            if (scan == 1)
            begin
              visual_ODW_WAIT_current <= ODWCHECK;
            end
            else
            begin
              visual_ODW_WAIT_current <= ODW_WAIT;
            end
          end
 
        ODWCHECK:
          begin
            if (odd_dwn_hit_found == 1)
            begin
              odd_dwn_dcl_done <= 1'b1;
              odd_dwn_scan <= 1'b0;
              odwn_count <= 3'b100;
              visual_ODW_WAIT_current <= ODW_STP;
            end
            else if (odd_dwn_hit_found == 0)
            begin
              odd_dwn_scan <= 1'b1;
              odd_dwn_force_scan <= 1'b0;
              visual_ODW_WAIT_current <= ODW_SCAN;
            end
            else
              visual_ODW_WAIT_current <= ODWCHECK;
          end
 
        ODW_SCAN:
          begin
            if (odd_dwn_hit_found == 1 && scan == 1)
            begin
              odd_dwn_dcl_done <= 1'b1;
              odd_dwn_scan <= 1'b0;
              odwn_count <= 3'b100;
              visual_ODW_WAIT_current <= ODW_STP;
            end
            else if (scan == 0)
            begin
              odd_dwn_scan <= 1'b0;
              odd_dwn_dcl_done <= 1'b0;
              odwn_count <= 3'b000;
              odd_dwn_force_scan <= 1'b0;
              visual_ODW_WAIT_current <= ODW_WAIT;
            end
            else
            begin
              visual_ODW_WAIT_current <= ODW_SCAN;
            end
          end
 
        ODW_SCAN4:
          begin
            if (odwn_count != 3'b000 && scan == 1)
            begin
              odwn_count <= odwn_count - 1;
              visual_ODW_WAIT_current <= ODW_SCAN4;
            end
            else if (odwn_count == 3'b000 && scan == 1)
            begin
              odd_dwn_scan <= 1'b1;
              odd_dwn_force_scan <= 1'b0;
              visual_ODW_WAIT_current <= ODW_SCAN;
            end
            else if (scan == 0)
            begin
              odd_dwn_scan <= 1'b0;
              odd_dwn_dcl_done <= 1'b0;
              odwn_count <= 3'b000;
              odd_dwn_force_scan <= 1'b0;
              visual_ODW_WAIT_current <= ODW_WAIT;
            end
            else
              visual_ODW_WAIT_current <= ODW_SCAN4;
          end
 
        ODW_STP:
          begin
            if (scan == 0)
            begin
              odd_dwn_scan <= 1'b0;
              odd_dwn_dcl_done <= 1'b0;
              odwn_count <= 3'b000;
              odd_dwn_force_scan <= 1'b0;
              visual_ODW_WAIT_current <= ODW_WAIT;
            end
            else if (odd_dwn_next == 1 && scan == 1)
            begin
              odwn_count <= odwn_count - 1;
              odd_dwn_scan <= 1'b1;
              odd_dwn_dcl_done <= 1'b0;
              odd_dwn_force_scan <= 1'b1;
              visual_ODW_WAIT_current <= ODW_SCAN4;
            end
            else if (odd_dwn_next == 0 && scan == 1)
            begin
              visual_ODW_WAIT_current <= ODW_STP;
            end
            else
              visual_ODW_WAIT_current <= ODW_STP;
          end
 
        default:
          begin
            odd_dwn_scan <= 1'b0;
            odd_dwn_dcl_done <= 1'b0;
            odwn_count <= 3'b000;
            odd_dwn_force_scan <= 1'b0;
            visual_ODW_WAIT_current <= ODW_WAIT;
          end
      endcase
    end
  end
 
 
 
  // Synchronous process
  always  @(posedge clk or negedge rst_b)
  begin : controller_EUP_WAIT
 
    if (~(rst_b))
    begin
      even_up_scan <= 1'b0;
      even_up_dcl_done <= 1'b0;
      eup_count <= 3'b000;
      even_up_force_scan <= 1'b0;
      visual_EUP_WAIT_current <= EUP_WAIT;
    end
    else
    begin
 
      case (visual_EUP_WAIT_current)  // exemplar parallel_case full_case
        EUP_WAIT:
          begin
            if (scan == 1)
            begin
              visual_EUP_WAIT_current <= EUPCHECK;
            end
            else
            begin
              visual_EUP_WAIT_current <= EUP_WAIT;
            end
          end
 
        EUPCHECK:
          begin
            if (even_up_hit_found == 0)
            begin
              even_up_scan <= 1'b1;
              even_up_force_scan <= 1'b0;
              visual_EUP_WAIT_current <= EUP_SCAN;
            end
            else if (even_up_hit_found == 1)
            begin
              even_up_dcl_done <= 1'b1;
              even_up_scan <= 1'b0;
              eup_count <= 3'b100;
              visual_EUP_WAIT_current <= EUP_STP;
            end
            else
              visual_EUP_WAIT_current <= EUPCHECK;
          end
 
        EUP_SCAN:
          begin
            if (even_up_hit_found == 1 && scan == 1)
            begin
              even_up_dcl_done <= 1'b1;
              even_up_scan <= 1'b0;
              eup_count <= 3'b100;
              visual_EUP_WAIT_current <= EUP_STP;
            end
            else if (scan == 0)
            begin
              even_up_scan <= 1'b0;
              even_up_dcl_done <= 1'b0;
              eup_count <= 3'b000;
              even_up_force_scan <= 1'b0;
              visual_EUP_WAIT_current <= EUP_WAIT;
            end
            else
            begin
              visual_EUP_WAIT_current <= EUP_SCAN;
            end
          end
 
        EUP_SCAN4:
          begin
            if (eup_count != 3'b000 && scan == 1)
            begin
              eup_count <= eup_count - 1;
              visual_EUP_WAIT_current <= EUP_SCAN4;
            end
            else if (eup_count == 3'b000 && scan == 1)
            begin
              even_up_scan <= 1'b1;
              even_up_force_scan <= 1'b0;
              visual_EUP_WAIT_current <= EUP_SCAN;
            end
            else if (scan == 0)
            begin
              even_up_scan <= 1'b0;
              even_up_dcl_done <= 1'b0;
              eup_count <= 3'b000;
              even_up_force_scan <= 1'b0;
              visual_EUP_WAIT_current <= EUP_WAIT;
            end
            else
              visual_EUP_WAIT_current <= EUP_SCAN4;
          end
 
        EUP_STP:
          begin
            if (scan == 0)
            begin
              even_up_scan <= 1'b0;
              even_up_dcl_done <= 1'b0;
              eup_count <= 3'b000;
              even_up_force_scan <= 1'b0;
              visual_EUP_WAIT_current <= EUP_WAIT;
            end
            else if (even_up_next == 1 && scan == 1)
            begin
              eup_count <= eup_count - 1;
              even_up_scan <= 1'b1;
              even_up_dcl_done <= 1'b0;
              even_up_force_scan <= 1'b1;
              visual_EUP_WAIT_current <= EUP_SCAN4;
            end
            else if (even_up_next == 0 && scan == 1)
            begin
              visual_EUP_WAIT_current <= EUP_STP;
            end
            else
              visual_EUP_WAIT_current <= EUP_STP;
          end
 
        default:
          begin
            even_up_scan <= 1'b0;
            even_up_dcl_done <= 1'b0;
            eup_count <= 3'b000;
            even_up_force_scan <= 1'b0;
            visual_EUP_WAIT_current <= EUP_WAIT;
          end
      endcase
    end
  end
 
 
 
  // Synchronous process
  always  @(posedge clk or negedge rst_b)
  begin : controller_OUP_WAIT
 
    if (~(rst_b))
    begin
      odd_up_scan <= 1'b0;
      odd_up_dcl_done <= 1'b0;
      oup_count <= 3'b000;
      odd_up_force_scan <= 1'b0;
      visual_OUP_WAIT_current <= OUP_WAIT;
    end
    else
    begin
 
      case (visual_OUP_WAIT_current)  // exemplar parallel_case full_case
        OUP_WAIT:
          begin
            if (scan == 1)
            begin
              visual_OUP_WAIT_current <= OUPCHECK;
            end
            else
            begin
              visual_OUP_WAIT_current <= OUP_WAIT;
            end
          end
 
        OUPCHECK:
          begin
            if (odd_up_hit_found == 0)
            begin
              odd_up_scan <= 1'b1;
              odd_up_force_scan <= 1'b0;
              visual_OUP_WAIT_current <= OUP_SCAN;
            end
            else if (odd_up_hit_found == 1)
            begin
              odd_up_dcl_done <= 1'b1;
              odd_up_scan <= 1'b0;
              oup_count <= 3'b100;
              visual_OUP_WAIT_current <= OUP_STP;
            end
            else
              visual_OUP_WAIT_current <= OUPCHECK;
          end
 
        OUP_SCAN:
          begin
            if (odd_up_hit_found == 1 && scan == 1)
            begin
              odd_up_dcl_done <= 1'b1;
              odd_up_scan <= 1'b0;
              oup_count <= 3'b100;
              visual_OUP_WAIT_current <= OUP_STP;
            end
            else if (scan == 0)
            begin
              odd_up_scan <= 1'b0;
              odd_up_dcl_done <= 1'b0;
              oup_count <= 3'b000;
              odd_up_force_scan <= 1'b0;
              visual_OUP_WAIT_current <= OUP_WAIT;
            end
            else
            begin
              visual_OUP_WAIT_current <= OUP_SCAN;
            end
          end
 
        OUP_SCAN4:
          begin
            if (oup_count != 3'b000 && scan == 1)
            begin
              oup_count <= oup_count - 1;
              visual_OUP_WAIT_current <= OUP_SCAN4;
            end
            else if (oup_count == 3'b000 && scan == 1)
            begin
              odd_up_scan <= 1'b1;
              odd_up_force_scan <= 1'b0;
              visual_OUP_WAIT_current <= OUP_SCAN;
            end
            else if (scan == 0)
            begin
              odd_up_scan <= 1'b0;
              odd_up_dcl_done <= 1'b0;
              oup_count <= 3'b000;
              odd_up_force_scan <= 1'b0;
              visual_OUP_WAIT_current <= OUP_WAIT;
            end
            else
              visual_OUP_WAIT_current <= OUP_SCAN4;
          end
 
        OUP_STP:
          begin
            if (scan == 0)
            begin
              odd_up_scan <= 1'b0;
              odd_up_dcl_done <= 1'b0;
              oup_count <= 3'b000;
              odd_up_force_scan <= 1'b0;
              visual_OUP_WAIT_current <= OUP_WAIT;
            end
            else if (odd_up_next == 1 && scan == 1)
            begin
              oup_count <= oup_count - 1;
              odd_up_scan <= 1'b1;
              odd_up_dcl_done <= 1'b0;
              odd_up_force_scan <= 1'b1;
              visual_OUP_WAIT_current <= OUP_SCAN4;
            end
            else if (odd_up_next == 0 && scan == 1)
            begin
              visual_OUP_WAIT_current <= OUP_STP;
            end
            else
              visual_OUP_WAIT_current <= OUP_STP;
          end
 
        default:
          begin
            odd_up_scan <= 1'b0;
            odd_up_dcl_done <= 1'b0;
            oup_count <= 3'b000;
            odd_up_force_scan <= 1'b0;
            visual_OUP_WAIT_current <= OUP_WAIT;
          end
      endcase
    end
  end
 
  assign finished = even_dwn_scan_finished &&
  odd_dwn_scan_finished &&
  even_up_scan_finished &&
  odd_up_scan_finished &&
  ~lmt_reached_reg;
 
 
endmodule
