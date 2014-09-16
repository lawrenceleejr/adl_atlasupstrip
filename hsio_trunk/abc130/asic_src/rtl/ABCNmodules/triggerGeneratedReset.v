`timescale 1ns/1ps
//generate a reset if 32 consecutive L1, R3 triggers are received
module triggerGeneratedReset (
  BC,
  syncRstb,
  LONE,
  RTHREE,
  tgRstb
);


input BC;    
input syncRstb;
input LONE;
input RTHREE;
output tgRstb;
reg tgRstb;

reg lastL1, lastR3;
always @(posedge BC or negedge syncRstb) begin  // added or negedge syncRstb 10-04-2013 F.A.
   if ( syncRstb == 1'b0 ) begin
     lastL1 <= 0;
     lastR3 <= 0;
   end
   else begin
     lastL1 <= LONE;
     lastR3 <= RTHREE;
   end
end//always

//registers to mark 32 consecutive L1 & R3's
reg  [4:0] count;

always @(posedge BC or negedge syncRstb) begin  // added or negedge syncRstb 10-04-2013 F.A.
   if ( syncRstb == 1'b0 ) 
       count <= 5'h0;
   else begin
    if ( LONE == 1'b1 && lastL1 == 1'b1 && RTHREE == 1'b1 && lastR3 == 1'b1 ) 
      count <= count + 1'b1;
    else
      count <= 5'h0;
   end  //else
end //always BC

always @(posedge BC or negedge syncRstb) begin  // added or negedge syncRstb 10-04-2013 F.A.
   if ( syncRstb == 1'b0 )
      tgRstb <= 1'b1;
   else begin
     if (count[4:0] == 5'h1f ) begin
        tgRstb <= 1'b0;
     end
     else
        tgRstb <= 1'b1;
   end //else not reset
end//always
     

endmodule

