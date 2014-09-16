//handles payload data transfer functions
`timescale 1ns/1ps
module serializer(
  clk,
  bclk,
  rstb,
  pryority,
  ID,
  //
  localFifoDout,
  syncLocalFifoRE,
  freezeRE,
  localFifoEmpty,
  //pad control
  DIR,
  DATLoen,
  DATRoen,
  XOFFLoen,
  XOFFRoen,
  //pad data
  DATLi,
  DATLo,
  DATRi,
  DATRo,
  XOFFLi,
  XOFFLo,
  XOFFRi,
  XOFFRo,
  thruFIFOoverflow,
  thruFifoFull,
  enThru
); //commandRegister port list

//log-depth of the chip/cip FIFO
parameter logThruFIFODEPTH=2;

input bclk, clk, rstb;  	//primary
input [3:0] pryority; //output priority of this chip
input [4:0] ID; //name of this chip

input [53:0] localFifoDout;
output syncLocalFifoRE, freezeRE;
input localFifoEmpty;
//port-direction control
input  DIR;
output DATLoen, DATRoen;
output XOFFLoen, XOFFRoen;

output thruFIFOoverflow, thruFifoFull;
wire thruFIFOoverflow;
input enThru;


//port data
input DATLi, DATRi;
input XOFFLi, XOFFRi;
output DATLo, DATRo;
output XOFFLo, XOFFRo;
wire DATLoen;
wire DATRoen;
wire XOFFLoen;
wire XOFFRoen;
wire DATLi, DATRi;
wire XOFFLi, XOFFRi;
reg DATLo, DATRo;
reg XOFFLo, XOFFRo;
wire dataDirection;  //0:drive left  1: drive right
assign dataDirection = DIR;
assign DATLoen = dataDirection;
assign DATRoen = !dataDirection;
assign XOFFRoen = dataDirection;
assign XOFFLoen = !dataDirection;
wire clk;
wire rstb;
reg localFifoRE;
reg syncLocalFifoRE2, LocalFlag, freezeRE;

 

stretchRE sync (
  .clk ( clk ),
  .bclk ( bclk ),
  .rstb ( rstb ),
  .reI ( localFifoRE ),
  .reO ( syncLocalFifoRE )
);

// Generate FreezeRE veto signal
reg outputPendingFlag;  //true if this chip is sending a packet indicates serializer status
reg [5:0] outPacketCounter; //keep track of where we are in the send packet (msb first)
                            //counts from 58-1 to 0
reg [3:0] priorityCounter;//used to determine if it is the local chip's turn to unload a packet
always @(posedge clk ) begin
   if ( rstb == 1'b0 ) begin
   syncLocalFifoRE2 <= 1'b0;
//   freezeRE <= 1'b0;
   end else begin 
   syncLocalFifoRE2 <= syncLocalFifoRE;
//   if ( syncLocalFifoRE2 & !syncLocalFifoRE ) begin
//    freezeRE <= 1'b0;
//   end 
  end
 end  

//the received XOFF signal, suppresses transmission
//if dataDirection=0(left) respond to left chip's XOFF
//if dataDirection=1(right) respond to right chip's XOFF
wire XOFFi; // = dataDirection ? XOFFRi : XOFFLi;

//the input data signal
wire dIn;

//horizontal pass-through FIFO related signals
wire [58:0] thruFifoDout;
reg thruFifoWE;
reg thruFifoRE;
wire thruFifoFull;
wire thruFifoAlmostFull;
wire thruFifoEmpty;

//packet output
 

reg [59:0] outputSR ;  //msb: start-bit next 5 msb's: ID  remaining: payload
wire   dOut;  //current output bit
assign dOut = outputSR[59];//msb of output shift register

//packet input
reg inputPendingFlag;  //true if this chip is receiving a packet  
reg [5:0] inPacketCounter; //keep track of where we are in the receive packet (msb first)
                          //counts from 59-1 to 0
reg [58:0] inputSR ;  //input shift reg

// Synchro on input and output signals from and to distant pads

reg DInL, DInR, XInL, XInR;

always @(posedge clk ) begin

	DATLo <= ~dataDirection & dOut;
        DATRo <= dataDirection & dOut;
//the almostFull & packetCounter clause is to assert XOFF one clock early, giving then transmitting chip a chance to hear it
        XOFFRo <= ~dataDirection & (thruFifoFull || (thruFifoAlmostFull)); // & inPacketCounter == 6'b0 )); 
        XOFFLo <= dataDirection & (thruFifoFull || (thruFifoAlmostFull)); // & inPacketCounter == 6'b0 )); 
end

        //assign XOFFRo = ~dataDirection & (thruFifoFull || (thruFifoAlmostFull )); // & inPacketCounter == 6'b0 )); 
        //assign XOFFLo = dataDirection & (thruFifoFull || (thruFifoAlmostFull )); // & inPacketCounter == 6'b0 )); 

always @(posedge clk ) begin

	
	DInL <= DATLi;
	DInR <= DATRi;
	XInL <= XOFFLi;
	XInR <= XOFFRi;
	
end
	
//  assign dIn = dataDirection  ? DATLi : DATRi;  //0: data flows from right to left 1: from left to right	
  assign dIn = dataDirection  ? DInL : DInR;  //0: data flows from right to left 1: from left to right
  assign XOFFi = dataDirection ? XInR : XInL;

//this is the serial input register.  In response to a leading 1, 58 bits are received
always @(posedge clk ) 
   if ( rstb == 1'b0 ) begin
    inPacketCounter <= 6'd59 ;
    inputPendingFlag <= 1'b0;
    inputSR <= 'b0;
    thruFifoWE <= 1'b0; //moves a word from the input shift register to the chip-through-chip fifo
   end //if reset
  else   //not reset
    if (inputPendingFlag == 1'b1 ) begin       //an incomming packet is already in progress
      //if ( thruFifoFull == 1'b1 ) ;$display ("[%d]%m:through-data FIFO full",`TB.cycle);
      if ( thruFifoFull == 1'b0 &&  inPacketCounter == 6'h1 && enThru == 1'b1 ) thruFifoWE <= 1'b1;  //tell fifo to capture on the next clock
      else thruFifoWE <= 1'b0;
     if ( inPacketCounter == 6'h0 ) begin              //reception completed
        inPacketCounter <= 6'd59 ;
        //put in idle mode
        inputPendingFlag <= 1'b0;
        inputSR <= 'b0;
     end  //inPacketCounter == 0
     else begin                                 //shift in the next bit
       inPacketCounter <= inPacketCounter - 6'b1;
       inputSR[58:1] <= inputSR[57:0] ;
       inputSR[0] <= dIn;
     end //else not outPacketCounter == 0
   end //not pending
  else  //not reset, pending
   begin
     if ( dIn == 1'b1 ) inputPendingFlag <= 1'b1;
   end
  //else not reset, not pending

//the input serial register loads into the thru (ABC through ABC) FIFO
syncFifo   #( .WORDWIDTH(59), .logDEPTH(logThruFIFODEPTH)) thruDataFifo (
  .dIn ( inputSR[58:0]),
  .dOut (thruFifoDout[58:0]),
  .we (thruFifoWE),
  .re (thruFifoRE),
  .full (thruFifoFull),
  .almostFull (thruFifoAlmostFull),
  .empty (thruFifoEmpty),
  .overflow (thruFIFOoverflow),
  .clk ( clk ),
  .rstb ( rstb)
);


//this is the serial output register.  In response to a leading 1, 59 bits are produced
//services  right/left transmission
//services local-data (triggered, reg read, etc) transmission

always @(posedge clk ) 
   if ( rstb == 1'b0  ) begin
    outPacketCounter <= 6'd61  ; 
    outputPendingFlag <= 1'b0;
    outputSR <= 'b0;
    thruFifoRE <= 1'b0;
    localFifoRE <= 1'b0;
    priorityCounter <= 4'h0;
    LocalFlag <= 1'b0;
    freezeRE <= 1'b0;
  end //reset clause
  else   //not reset
    if (outputPendingFlag == 1'b1 ) begin   	//a transmission is already in progress
     //thruFifoRE <= 1'b0;  //clear this if it was set on the previous clock, going into the pending state
     //localFifoRE <= 1'b0;  //clear this if it was set on the previous clock, going into the pending state
     if ( outPacketCounter == 6'h0 ) begin		//transmission completed
        //put in idle mode
        outPacketCounter <= 6'd61 ;
        outputPendingFlag <= 1'b0;
        outputSR <= 'b0;
     end  //outPacketCounter == 0
     else if ( outPacketCounter == 6'd61 ) begin
       outPacketCounter <= 6'd60;
       if (  localFifoEmpty == 1'b0 && (thruFifoEmpty == 1'b1 || priorityCounter == pryority) ) begin  //it's my turn!
            //outputSR[58:0] <= {ID[4:0],localFifoDout[53:0]};  //captured a value out of the fifo, now pulse fifo read to move the pointer
            localFifoRE <= 1'b1;  //pop the fifo with 1-clock long pulse
	    freezeRE <= 1'b1;
            priorityCounter <= 4'h0;
	    LocalFlag <= 1'b1;
         end //local's turn
         else //not localFifoEmpty == 1'b0 a word received from another ABCN to be transmitted
            if ( thruFifoEmpty == 1'b0 ) begin   //  1111
               //outputSR[58:0] <= thruFifoDout[58:0];  //captured a value out of the fifo, now pulse fifo read to move the pointer
               thruFifoRE <= 1'b1;  //pop the fifo with 1-clock long pulse
	       LocalFlag <= 1'b0;
	       if ( priorityCounter != pryority) priorityCounter <= priorityCounter + 1'b1;  //count up to priority and stop
           end //thruFifoEmpty  == 1'b0        //1111
       // FreezeRE <= 1'b1;
       //outputSR[59] <= 1'b1;  //start bit
     end
     else if ( outPacketCounter == 6'd60 ) begin
       outPacketCounter <= 6'd59;
       localFifoRE <= 1'b0;
       thruFifoRE <= 1'b0;
       outputSR[59] <= 1'b1;  //start bit
       outputSR[58:0] <= ({59{LocalFlag}} & {ID[4:0],localFifoDout[53:0]}) | ({59{~LocalFlag}} & {thruFifoDout[58:0]});
     end
     else begin					//shift out the next bit
       outPacketCounter <= outPacketCounter - 6'b1;
       outputSR[59:1] <= outputSR[58:0] ;
       outputSR[0] <= 1'b0;
       if ( syncLocalFifoRE2 & !syncLocalFifoRE ) freezeRE <= 1'b0;
     end //else not outPacketCounter == 0
   end //not pending
  else begin  //not reset, pending
    if (  XOFFi == 1'b0 && ~( thruFifoEmpty == 1'b1 && inputPendingFlag == 1'b1 )) begin   //if not XOFF (pushback from receiving chip,  
     if ( (localFifoEmpty == 1'b0 || thruFifoEmpty == 1'b0) ) begin    //someone wants to talk, start the next packet transmission
         outputPendingFlag <= 1'b1;
         // outputSR[58] <= 1'b1;  //start bit
         // priority encoder decides whose turn it is to transmit
	 end
     end
    end
  
   
/*always @(posedge clk )
       if (  outputPendingFlag == 1'b1 && outPacketCounter == 6'd61 ) begin        	 
         if (  localFifoEmpty == 1'b0 && (thruFifoEmpty == 1'b1 || priorityCounter == pryority) ) begin  //it's my turn!
            //outputSR[58:0] <= {ID[4:0],localFifoDout[53:0]};  //captured a value out of the fifo, now pulse fifo read to move the pointer
            localFifoRE <= 1'b1;  //pop the fifo with 1-clock long pulse
	    freezeRE <= 1'b1;
            priorityCounter <= 4'h0;
	    LocalFlag <= 1'b1;
         end //local's turn
         else //not localFifoEmpty == 1'b0 a word received from another ABCN to be transmitted
            if ( thruFifoEmpty == 1'b0 ) begin   //  1111
               //outputSR[58:0] <= thruFifoDout[58:0];  //captured a value out of the fifo, now pulse fifo read to move the pointer
               thruFifoRE <= 1'b1;  //pop the fifo with 1-clock long pulse
	       LocalFlag <= 1'b0;
	       if ( priorityCounter != pryority) priorityCounter <= priorityCounter + 1'b1;  //count up to priority and stop
           end //thruFifoEmpty  == 1'b0        //1111
     end  
*/


endmodule //serializer
