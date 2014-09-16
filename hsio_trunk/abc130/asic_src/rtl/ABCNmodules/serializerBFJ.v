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
  XOFFRo
); //commandRegister port list

//log-depth of the chip/cip FIFO
parameter logThruFIFODEPTH=4;

input bclk, clk, rstb;  	//primary
input [3:0] pryority; //output priority of this chip
input [3:0] ID; //name of this chip

input [53:0] localFifoDout;
output syncLocalFifoRE;
input localFifoEmpty;
//port-direction control
input  DIR;
output DATLoen, DATRoen;
output XOFFLoen, XOFFRoen;

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
wire DATLo, DATRo;
wire XOFFLo, XOFFRo;
wire dataDirection;  //0:drive left  1: drive right
assign dataDirection = DIR;
assign DATLoen = dataDirection;
assign DATRoen = !dataDirection;
assign XOFFRoen = dataDirection;
assign XOFFLoen = !dataDirection;
wire clk;
wire rstb;
reg localFifoRE;

stretchRE sync (
  .clk ( clk ),
  .bclk ( bclk ),
  .rstb ( rstb ),
  .reI ( localFifoRE ),
  .reO ( syncLocalFifoRE )
);

//the received XOFF signal, suppresses transmission
//if dataDirection=0(left) respond to left chip's XOFF
//if dataDirection=1(right) respond to right chip's XOFF
wire XOFFi = dataDirection ? XOFFRi : XOFFLi;

//the input data signal
wire dIn;
assign dIn = dataDirection  ? DATLi : DATRi;  //0: data flows from right to left 1: from left to right


//horizontal pass-through FIFO related signals
wire [57:0] thruFifoDout;
reg thruFifoWE;
reg thruFifoRE;
wire thruFifoFull;
wire thruFifoAlmostFull;
wire thruFifoEmpty;

//packet output
reg outputPendingFlag;  //true if this chip is sending a packet  
reg [5:0] outPacketCounter; //keep track of where we are in the send packet (msb first)
                            //counts from 58-1 to 0
reg [58:0] outputSR ;  //msb: start-bit next 4 msb's: ID  remaining: payload
wire   dOut;  //current output bit
assign dOut = outputSR[58];//msb of output shift register

//packet input
reg inputPendingFlag;  //true if this chip is receiving a packet  
reg [5:0] inPacketCounter; //keep track of where we are in the receive packet (msb first)
                          //counts from 58-1 to 0
reg [57:0] inputSR ;  //input shift reg

assign DATLo = dOut;
assign DATRo = dOut;
//the almostFull & packetCounter clause is to assert XOFF one clock early, giving then transmitting chip a chance to hear it
assign XOFFRo = thruFifoFull || (thruFifoAlmostFull & inPacketCounter == 6'b0 ); 
assign XOFFLo = thruFifoFull || (thruFifoAlmostFull & inPacketCounter == 6'b0 ); 


//this is the serial input register.  In response to a leading 1, 58 bits are received
always @(posedge clk ) 
   if ( rstb == 1'b0 ) begin
    inPacketCounter <= 6'd58 ;
    inputPendingFlag <= 1'b0;
    inputSR <= 'b0;
    thruFifoWE <= 1'b0; //moves a word from the input shift register to the chip-through-chip fifo
   end //if reset
  else   //not reset
    if (inputPendingFlag == 1'b1 ) begin       //an incomming packet is already in progress
      //if ( thruFifoFull == 1'b1 ) ;$display ("[%d]%m:through-data FIFO full",`TB.cycle);
      if ( thruFifoFull == 1'b0 &&  inPacketCounter == 6'h1 ) thruFifoWE <= 1'b1;  //tell fifo to capture on the next clock
      else thruFifoWE <= 1'b0;
     if ( inPacketCounter == 6'h0 ) begin              //reception completed
        inPacketCounter <= 6'd58 ;
        //put in idle mode
        inputPendingFlag <= 1'b0;
        inputSR <= 'b0;
     end  //inPacketCounter == 0
     else begin                                 //shift in the next bit
       inPacketCounter <= inPacketCounter - 6'b1;
       inputSR[57:1] <= inputSR[56:0] ;
       inputSR[0] <= dIn;
     end //else not outPacketCounter == 0
   end //not pending
  else  //not reset, pending
   begin
     if ( dIn == 1'b1 ) inputPendingFlag <= 1'b1;
   end
  //else not reset, not pending

//the input serial register loads into the thru (ABC through ABC) FIFO
syncFifo   #( .WORDWIDTH(58), .logDEPTH(logThruFIFODEPTH)) thruDataFifo (
  .dIn ( inputSR[57:0]),
  .dOut (thruFifoDout[58-1:0]),
  .we (thruFifoWE),
  .re (thruFifoRE),
  .full (thruFifoFull),
  .almostFull (thruFifoAlmostFull),
  .empty (thruFifoEmpty),
  .clk ( clk ),
  .rstb ( rstb)
);



//this is the serial output register.  In response to a leading 1, 58 bits are produced
//services  right/left transmission
//services local-data (triggered, reg read, etc) transmission
reg [3:0] priorityCounter;//used to determine if it is the local chip's turn to unload a packet
always @(posedge clk ) 
   if ( rstb == 1'b0  ) begin
    outPacketCounter <= 6'd58  ; 
    outputPendingFlag <= 1'b0;
    outputSR <= 'b0;
    thruFifoRE <= 1'b0;
    localFifoRE <= 1'b0;
    priorityCounter <= 4'h0;
  end //reset clause
  else   //not reset
    if (outputPendingFlag == 1'b1 ) begin   	//a transmission is already in progress
     thruFifoRE <= 1'b0;  //clear this if it was set on the previous clock, going into the pending state
     localFifoRE <= 1'b0;  //clear this if it was set on the previous clock, going into the pending state
     if ( outPacketCounter == 6'h0 ) begin		//transmission completed
        //put in idle mode
        outPacketCounter <= 6'd58 ;
        outputPendingFlag <= 1'b0;
        outputSR <= 'b0;
     end  //outPacketCounter == 0
     else begin					//shift out the next bit
       outPacketCounter <= outPacketCounter - 6'b1;
       outputSR[58:1] <= outputSR[57:0] ;
       outputSR[0] <= 1'b0;
     end //else not outPacketCounter == 0
   end //not pending
  else begin  //not reset, pending
    if (  XOFFi == 1'b0 && ~( thruFifoEmpty == 1'b1 && inputPendingFlag == 1'b1 )) begin   //if not XOFF (pushback from receiving chip,  
     if ( (localFifoEmpty == 1'b0 || thruFifoEmpty == 1'b0) ) begin    //someone wants to talk, start the next packet transmission
         outputPendingFlag <= 1'b1;
         outputSR[58] <= 1'b1;  //start bit
         // priority encoder decides whose turn it is to transmit
         if (  localFifoEmpty == 1'b0 && (thruFifoEmpty == 1'b1 || priorityCounter == pryority)) begin  //it's my turn!
            outputSR[57:0] <= {ID[3:0],localFifoDout[53:0]};  //captured a value out of the fifo, now pulse fifo read to move the pointer
            localFifoRE <= 1'b1;  //pop the fifo with 1-clock long pulse
            priorityCounter <= 4'h0;
         end //local's turn
         else //not localFifoEmpty == 1'b0 a word received from another ABCN to be transmitted
            if ( thruFifoEmpty == 1'b0 ) begin   //  1111
               outputSR[57:0] <= thruFifoDout[57:0];  //captured a value out of the fifo, now pulse fifo read to move the pointer
               thruFifoRE <= 1'b1;  //pop the fifo with 1-clock long pulse
               if ( priorityCounter != pryority) priorityCounter <= priorityCounter + 1'b1;  //count up to priority and stop
            end //thruFifoEmpty  == 1'b0        //1111
     end  //localFifoEmpty == 1'b0 || thruFifoEmpty == 1'b0
    end //if ( XOFFi == 1'b0 ) 
  end//else not reset, not pending


endmodule //serializer
