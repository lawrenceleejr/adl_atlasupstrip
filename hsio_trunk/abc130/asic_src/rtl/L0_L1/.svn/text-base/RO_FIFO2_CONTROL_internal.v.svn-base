// made on 2011-08-17 10:41:05











`timescale  1ns /  1ps

module RO_FIFO2_CONTROL_internal ( 
	BC,
	ResetB,
	SyncWrite,
	ReadEnable,
	Empty_i,
	Full_i,
	FWriteAddress_i,
	FReadAddress_i,
	FLastAddress_i,
	WriteFIFO,
	ReadFIFO,
	ROReadStrob,
	Empty_o,
	Full_o,
	FWriteStrob_o,
	FReadStrob_o,
	FWriteAddress_o,
	FReadAddress_o,
	FLastAddress_o);


///////////////////////////////////////////////////////////////////// 
/////parameters
parameter RO_FIFO_max_depth =	(1<<(`FIFO_ADDR_WIDTH));

///////////////////////////////////////////////////////////////////// 
/////OLD inputs
input BC, ResetB, SyncWrite, ReadEnable;

///////////////////////////////////////////////////////////////////// 
/////OLD OUTPUTS
output WriteFIFO, ReadFIFO, ROReadStrob;

///////////////////////////////////////////////////////////////////// 
/////OLD wires
wire WriteFIFO, ReadFIFO, ROReadStrob;

///////////////////////////////////////////////////////////////////// 
/////NEW INPUTS
input Empty_i;
input Full_i;

///////////////////////////////////////////////////////////////////// 
/////NEW OUTPUTS
output Empty_o, Full_o, FWriteStrob_o, FReadStrob_o;

///////////////////////////////////////////////////////////////////// 
/////NEW INPUT BUSES
input  [`FIFO_ADDR_WIDTH-1:0] FWriteAddress_i;
input  [`FIFO_ADDR_WIDTH-1:0] FReadAddress_i;
input  [`FIFO_ADDR_WIDTH-1:0] FLastAddress_i;

///////////////////////////////////////////////////////////////////// 
/////NEW OUTPUT BUSES
output  [`FIFO_ADDR_WIDTH-1:0] FWriteAddress_o;
output  [`FIFO_ADDR_WIDTH-1:0] FReadAddress_o, FLastAddress_o;

///////////////////////////////////////////////////////////////////// 
/////NEW regs
reg Empty_o, Full_o, FWriteStrob_o, FReadStrob_o;



///////////////////////////////////////////////////////////////////// 
/////NEW bus regs
reg  [`FIFO_ADDR_WIDTH-1:0] FWriteAddress_o;
reg  [`FIFO_ADDR_WIDTH-1:0] FReadAddress_o, FLastAddress_o;

///////////////////////////////////////////////////////////////////// 
/////assign blocks
assign WriteFIFO = FWriteStrob_o;
assign ROReadStrob = FReadStrob_o;
assign ReadFIFO = FReadStrob_o;

///////////////////////////////////////////////////////////////////// 
/////always blocks



  



  always @( posedge BC ) begin
    if ( ~ResetB ) begin 
      Full_o <= 0;
    end else begin
    if ( FLastAddress_i >= FWriteAddress_i ) begin  
	  if ( (FLastAddress_i - FWriteAddress_i) > 1 )
      	    Full_o <= 0;
	  else 
	    Full_o <= 1;
          end 
    else if ( FLastAddress_i < FWriteAddress_i ) begin
	  if ( (`RO_FIFO_max_depth + FLastAddress_i - FWriteAddress_i ) > 1 ) 
	    Full_o <= 0;
	  else
	    Full_o <= 1;
	end
      
    end
  end

 

  always @( posedge BC ) begin
    if ( ~ResetB ) begin
      FWriteStrob_o <= 0;
      FWriteAddress_o <= 0;
    end else begin
      if ( Full_i ) FWriteStrob_o <= 0;
      else begin
        if ( SyncWrite ) begin 
	  if  ( FWriteAddress_i == (`RO_FIFO_max_depth-1)) begin
	  FWriteStrob_o <= 1;
          FWriteAddress_o <= 0;
	  end else begin
	  FWriteStrob_o <= 1;
          FWriteAddress_o <= FWriteAddress_i + 1;
	end 
	end else FWriteStrob_o <= 0;
      end
    end
  end


  






  always @( posedge BC ) begin
	if ( ~ResetB ) begin 
		FLastAddress_o <= `RO_FIFO_max_depth-1;
	end else begin
	if  ( FReadAddress_i == 0 ) begin
          FLastAddress_o <= `RO_FIFO_max_depth-1;
	  end else begin
          FLastAddress_o <= FReadAddress_i - 1;
	end 
	end
   	
  end


  



  always @( posedge BC ) begin
    if ( ~ResetB ) begin 
      Empty_o <= 1;
    end else if ( FWriteAddress_i == FReadAddress_i ) begin
	Empty_o <= 1;
    end else if ( FWriteAddress_i > FReadAddress_i ) begin   
    	if ( (FWriteAddress_i - FReadAddress_i) > 0 ) begin
		Empty_o <= 0;
	end
	else Empty_o <= 1;
    end else if ( FWriteAddress_i < FReadAddress_i ) begin
	if ( (`RO_FIFO_max_depth + FWriteAddress_i - FReadAddress_i) > 0 ) begin
	    Empty_o <= 0;
	end
    end else Empty_o <= 1;
  end

  

 always @( posedge BC ) begin
    if ( ~ResetB ) begin
      FReadStrob_o <= 0;
      FReadAddress_o <= 0;
    end else begin
      if ( Empty_i ) FReadStrob_o <= 0;
      else begin
        if ( ReadEnable ) begin  
	  if  ( FReadAddress_i == (`RO_FIFO_max_depth-1)) begin
	  FReadStrob_o <= 1;
          FReadAddress_o <= 0;
	  end else begin
	  FReadStrob_o <= 1;
          FReadAddress_o <= FReadAddress_i + 1;
	end 
	end else FReadStrob_o <= 0;
      end
    end
  end


///////////////////////////////////////////////////////////////////// 
/////instances
  
  
 


endmodule
