// 6-bit counter, command register, status bits 
`timescale 1ns/1ps
module cmdReg (
  clk,
  rstb,
  com,
  commandReg,
  commandPending,
  count
); 
input  clk;   
input  rstb;  
input  com;  
output [56:0] commandReg;
output [5:0] count;  
output commandPending;
//triplicated 6-bit counter
wire [5:0] count;
reg [5:0] countA;  
//reg [5:0] countB;  
//reg [5:0] countC;  

//tripilcated 57-bit shift register
wire[56:0] commandReg;
reg[56:0] commandRegA;
//reg[56:0] commandRegB;
//reg[56:0] commandRegC;

//triplicate a couple of state bits
wire commandPending;
reg commandPendingA;
//reg commandPendingB;
//reg commandPendingC;
wire shortCommandCompleted;
reg shortCommandCompletedA;
//reg shortCommandCompletedB;
//reg shortCommandCompletedC;


//count logic
always @(posedge clk or negedge rstb )
  if ( rstb == 1'b0 ) begin
    countA <= 6'b0;
  //  countB <= 6'b0;
  //  countC <= 6'b0;
  end
  else begin
    //if currently receiving a command
    if ( commandPending == 1'b1 ) begin
       if (count == 6'd57 || shortCommandCompleted == 1 ) begin  //completed receiving a command
           countA <= 6'b0;
    //       countB <= 6'b0;
    //       countC <= 6'b0;
       end
       else begin      //shift in a new bit
          countA <= count + 6'b1;
    //      countB <= count + 6'b1;
    //      countC <= count + 6'b1;
       end
    end //if commandPending
  end //else
//commandReg logic
always @(posedge clk or negedge rstb )
  if ( rstb == 1'b0 ) begin
    commandRegA <= 57'b0;
//    commandRegB <= 57'b0;
//    commandRegC <= 57'b0;
  end
  else begin
    //if not currently receiving a command, a true incomming bit is a start bit
    if ( commandPending == 1'b0 & com == 1'b1 ) begin
      commandRegA <= 57'b1;     //clear the command reg for incomming bits but first bit set at one (as com=1)
    //  commandRegB <= 57'b1; 
    //  commandRegC <= 57'b1; 
    end
    //if currently receiving a command
    if ( commandPending == 1'b1 ) begin
       if ( (count != 6'd57 && shortCommandCompleted != 1) ) begin  //still receiving a command
          //shift in a new bit
          commandRegA[56:1] <= commandReg[55:0];  //note that the commandReg skips the leading 1 start-bit
     //     commandRegB[56:1] <= commandReg[55:0];  
     //     commandRegC[56:1] <= commandReg[55:0];  
          commandRegA[0] <= com;
     //     commandRegB[0] <= com;
     //     commandRegC[0] <= com;
       end
    end //if commandPending
  end //else

//shortCommandComplete logic
always @(posedge clk or negedge rstb )
  if ( rstb == 1'b0 ) begin
    shortCommandCompletedA <= 1'b0;
 //   shortCommandCompletedB <= 1'b0;
 //   shortCommandCompletedC <= 1'b0;
  end
  else begin
    if ( count == 6'd7  & commandReg[7:4] == 4'b1010 ) 
      begin
          shortCommandCompletedA <= 1'b1;
   //       shortCommandCompletedB <= 1'b1;
   //       shortCommandCompletedC <= 1'b1;
      end //if
    //if currently receiving a command
    else begin
      if ( commandPending == 1'b1 && (count == 6'd57 || shortCommandCompleted == 1 )) //completed receiving a command
         begin
             shortCommandCompletedA <= 1'b0;
//             shortCommandCompletedB <= 1'b0;
//             shortCommandCompletedC <= 1'b0;
         end//if commandPending == 1'b1 && (count == 6'd57 || shortCommandCompleted == 1 )
      else  //do nothing
         begin
             shortCommandCompletedA <= shortCommandCompleted;
    //         shortCommandCompletedB <= shortCommandCompleted;
    //         shortCommandCompletedC <= shortCommandCompleted;
         end
    end //if commandPending
  end //else not reset
//commandPending logic
always @(posedge clk or negedge rstb )
  if ( rstb == 1'b0 ) begin
    commandPendingA <= 1'b0;
  //  commandPendingB <= 1'b0;
  //  commandPendingC <= 1'b0;
  end
  else begin
    //if not currently receiving a command, a true incomming bit is a start bit
    if ( commandPending == 1'b0 & com == 1'b1 ) begin
      commandPendingA <= 1'b1;
   //   commandPendingB <= 1'b1;
   //   commandPendingC <= 1'b1;
    end
    else 
      begin
        //if currently receiving a command
        if ( commandPending == 1'b1 ) 
         begin
           if (count == 6'd57 || shortCommandCompleted == 1 ) begin  //completed receiving a command
             commandPendingA <= 1'b0;
     //        commandPendingB <= 1'b0;
     //        commandPendingC <= 1'b0;
           end
         else begin  //do nothing
             commandPendingA <= commandPending;
     //        commandPendingB <= commandPending;
     //        commandPendingC <= commandPending;
         end
         end //if commandPending
      end //else ( commandPending == 1'b0 & com == 1'b1 )
  end //else not reset

//misc majority logic
assign commandPending = commandPendingA; // & commandPendingB) | (commandPendingA & commandPendingC) | (commandPendingB & commandPendingC);
assign shortCommandCompleted = shortCommandCompletedA; // & shortCommandCompletedB ) | (shortCommandCompletedA & shortCommandCompletedC ) | (shortCommandCompletedB & shortCommandCompletedC );
//count majority logic 
assign count[5] = countA[5];// & countB[5]) | (countA[5] & countC[5]) | (countB[5] & countC[5]);
assign count[4] = countA[4];// & countB[4]) | (countA[4] & countC[4]) | (countB[4] & countC[4]);
assign count[3] = countA[3];// & countB[3]) | (countA[3] & countC[3]) | (countB[3] & countC[3]);
assign count[2] = countA[2];// & countB[2]) | (countA[2] & countC[2]) | (countB[2] & countC[2]);
assign count[1] = countA[1];// & countB[1]) | (countA[1] & countC[1]) | (countB[1] & countC[1]);
assign count[0] = countA[0];// & countB[0]) | (countA[0] & countC[0]) | (countB[0] & countC[0]);
//command register shiter majority logic
assign commandReg[0] = commandRegA[0]; // & commandRegB[0]) | (commandRegA[0] & commandRegC[0]) | (commandRegB[0] & commandRegC[0]);
assign commandReg[1] = commandRegA[1]; // & commandRegB[1]) | (commandRegA[1] & commandRegC[1]) | (commandRegB[1] & commandRegC[1]);
assign commandReg[2] = commandRegA[2]; // & commandRegB[2]) | (commandRegA[2] & commandRegC[2]) | (commandRegB[2] & commandRegC[2]);
assign commandReg[3] = commandRegA[3]; // & commandRegB[3]) | (commandRegA[3] & commandRegC[3]) | (commandRegB[3] & commandRegC[3]);
assign commandReg[4] = commandRegA[4]; //  & commandRegB[4]) | (commandRegA[4] & commandRegC[4]) | (commandRegB[4] & commandRegC[4]);
assign commandReg[5] = commandRegA[5]; //  & commandRegB[5]) | (commandRegA[5] & commandRegC[5]) | (commandRegB[5] & commandRegC[5]);
assign commandReg[6] = commandRegA[6]; //  & commandRegB[6]) | (commandRegA[6] & commandRegC[6]) | (commandRegB[6] & commandRegC[6]);
assign commandReg[7] = commandRegA[7]; //  & commandRegB[7]) | (commandRegA[7] & commandRegC[7]) | (commandRegB[7] & commandRegC[7]);
assign commandReg[8] = commandRegA[8]; //  & commandRegB[8]) | (commandRegA[8] & commandRegC[8]) | (commandRegB[8] & commandRegC[8]);
assign commandReg[9] = commandRegA[9]; //  & commandRegB[9]) | (commandRegA[9] & commandRegC[9]) | (commandRegB[9] & commandRegC[9]);
assign commandReg[10] = commandRegA[10]; //  & commandRegB[10]) | (commandRegA[10] & commandRegC[10]) | (commandRegB[10] & commandRegC[10]);
assign commandReg[11] = commandRegA[11]; //  & commandRegB[11]) | (commandRegA[11] & commandRegC[11]) | (commandRegB[11] & commandRegC[11]);
assign commandReg[12] = commandRegA[12]; //  & commandRegB[12]) | (commandRegA[12] & commandRegC[12]) | (commandRegB[12] & commandRegC[12]);
assign commandReg[13] = commandRegA[13]; //  & commandRegB[13]) | (commandRegA[13] & commandRegC[13]) | (commandRegB[13] & commandRegC[13]);
assign commandReg[14] = commandRegA[14]; //  & commandRegB[14]) | (commandRegA[14] & commandRegC[14]) | (commandRegB[14] & commandRegC[14]);
assign commandReg[15] = commandRegA[15]; //  & commandRegB[15]) | (commandRegA[15] & commandRegC[15]) | (commandRegB[15] & commandRegC[15]);
assign commandReg[16] = commandRegA[16]; //  & commandRegB[16]) | (commandRegA[16] & commandRegC[16]) | (commandRegB[16] & commandRegC[16]);
assign commandReg[17] = commandRegA[17]; //  & commandRegB[17]) | (commandRegA[17] & commandRegC[17]) | (commandRegB[17] & commandRegC[17]);
assign commandReg[18] = commandRegA[18]; //  & commandRegB[18]) | (commandRegA[18] & commandRegC[18]) | (commandRegB[18] & commandRegC[18]);
assign commandReg[19] = commandRegA[19]; //  & commandRegB[19]) | (commandRegA[19] & commandRegC[19]) | (commandRegB[19] & commandRegC[19]);
assign commandReg[20] = commandRegA[20]; //  & commandRegB[20]) | (commandRegA[20] & commandRegC[20]) | (commandRegB[20] & commandRegC[20]);
assign commandReg[21] = commandRegA[21]; //  & commandRegB[21]) | (commandRegA[21] & commandRegC[21]) | (commandRegB[21] & commandRegC[21]);
assign commandReg[22] = commandRegA[22]; //  & commandRegB[22]) | (commandRegA[22] & commandRegC[22]) | (commandRegB[22] & commandRegC[22]);
assign commandReg[23] = commandRegA[23]; //  & commandRegB[23]) | (commandRegA[23] & commandRegC[23]) | (commandRegB[23] & commandRegC[23]);
assign commandReg[24] = commandRegA[24]; //  & commandRegB[24]) | (commandRegA[24] & commandRegC[24]) | (commandRegB[24] & commandRegC[24]);
assign commandReg[25] = commandRegA[25] ; //& commandRegB[25]) | (commandRegA[25] & commandRegC[25]) | (commandRegB[25] & commandRegC[25]);
assign commandReg[26] = commandRegA[26] ; //& commandRegB[26]) | (commandRegA[26] & commandRegC[26]) | (commandRegB[26] & commandRegC[26]);
assign commandReg[27] = commandRegA[27] ; //& commandRegB[27]) | (commandRegA[27] & commandRegC[27]) | (commandRegB[27] & commandRegC[27]);
assign commandReg[28] = commandRegA[28] ; //& commandRegB[28]) | (commandRegA[28] & commandRegC[28]) | (commandRegB[28] & commandRegC[28]);
assign commandReg[29] = commandRegA[29] ; //& commandRegB[29]) | (commandRegA[29] & commandRegC[29]) | (commandRegB[29] & commandRegC[29]);
assign commandReg[30] = commandRegA[30] ; //& commandRegB[30]) | (commandRegA[30] & commandRegC[30]) | (commandRegB[30] & commandRegC[30]);
assign commandReg[31] = commandRegA[31] ; //& commandRegB[31]) | (commandRegA[31] & commandRegC[31]) | (commandRegB[31] & commandRegC[31]);
assign commandReg[32] = commandRegA[32] ; //& commandRegB[32]) | (commandRegA[32] & commandRegC[32]) | (commandRegB[32] & commandRegC[32]);
assign commandReg[33] = commandRegA[33] ; //& commandRegB[33]) | (commandRegA[33] & commandRegC[33]) | (commandRegB[33] & commandRegC[33]);
assign commandReg[34] = commandRegA[34] ; //& commandRegB[34]) | (commandRegA[34] & commandRegC[34]) | (commandRegB[34] & commandRegC[34]);
assign commandReg[35] = commandRegA[35] ; //& commandRegB[35]) | (commandRegA[35] & commandRegC[35]) | (commandRegB[35] & commandRegC[35]);
assign commandReg[36] = commandRegA[36] ; //& commandRegB[36]) | (commandRegA[36] & commandRegC[36]) | (commandRegB[36] & commandRegC[36]);
assign commandReg[37] = commandRegA[37] ; //& commandRegB[37]) | (commandRegA[37] & commandRegC[37]) | (commandRegB[37] & commandRegC[37]);
assign commandReg[38] = commandRegA[38] ; //& commandRegB[38]) | (commandRegA[38] & commandRegC[38]) | (commandRegB[38] & commandRegC[38]);
assign commandReg[39] = commandRegA[39] ; //& commandRegB[39]) | (commandRegA[39] & commandRegC[39]) | (commandRegB[39] & commandRegC[39]);
assign commandReg[40] = commandRegA[40] ; //& commandRegB[40]) | (commandRegA[40] & commandRegC[40]) | (commandRegB[40] & commandRegC[40]);
assign commandReg[41] = commandRegA[41] ; //& commandRegB[41]) | (commandRegA[41] & commandRegC[41]) | (commandRegB[41] & commandRegC[41]);
assign commandReg[42] = commandRegA[42] ; //& commandRegB[42]) | (commandRegA[42] & commandRegC[42]) | (commandRegB[42] & commandRegC[42]);
assign commandReg[43] = commandRegA[43] ; //& commandRegB[43]) | (commandRegA[43] & commandRegC[43]) | (commandRegB[43] & commandRegC[43]);
assign commandReg[44] = commandRegA[44] ; //& commandRegB[44]) | (commandRegA[44] & commandRegC[44]) | (commandRegB[44] & commandRegC[44]);
assign commandReg[45] = commandRegA[45] ; //& commandRegB[45]) | (commandRegA[45] & commandRegC[45]) | (commandRegB[45] & commandRegC[45]);
assign commandReg[46] = commandRegA[46] ; //& commandRegB[46]) | (commandRegA[46] & commandRegC[46]) | (commandRegB[46] & commandRegC[46]);
assign commandReg[47] = commandRegA[47] ; //& commandRegB[47]) | (commandRegA[47] & commandRegC[47]) | (commandRegB[47] & commandRegC[47]);
assign commandReg[48] = commandRegA[48] ; //& commandRegB[48]) | (commandRegA[48] & commandRegC[48]) | (commandRegB[48] & commandRegC[48]);
assign commandReg[49] = commandRegA[49] ; //& commandRegB[49]) | (commandRegA[49] & commandRegC[49]) | (commandRegB[49] & commandRegC[49]);
assign commandReg[50] = commandRegA[50] ; //& commandRegB[50]) | (commandRegA[50] & commandRegC[50]) | (commandRegB[50] & commandRegC[50]);
assign commandReg[51] = commandRegA[51] ; //& commandRegB[51]) | (commandRegA[51] & commandRegC[51]) | (commandRegB[51] & commandRegC[51]);
assign commandReg[52] = commandRegA[52] ; //& commandRegB[52]) | (commandRegA[52] & commandRegC[52]) | (commandRegB[52] & commandRegC[52]);
assign commandReg[53] = commandRegA[53] ; //& commandRegB[53]) | (commandRegA[53] & commandRegC[53]) | (commandRegB[53] & commandRegC[53]);
assign commandReg[54] = commandRegA[54] ; //& commandRegB[54]) | (commandRegA[54] & commandRegC[54]) | (commandRegB[54] & commandRegC[54]);
assign commandReg[55] = commandRegA[55] ; //& commandRegB[55]) | (commandRegA[55] & commandRegC[55]) | (commandRegB[55] & commandRegC[55]);
assign commandReg[56] = commandRegA[56] ; //& commandRegB[56]) | (commandRegA[56] & commandRegC[56]) | (commandRegB[56] & commandRegC[56]);
endmodule //cmdReg
