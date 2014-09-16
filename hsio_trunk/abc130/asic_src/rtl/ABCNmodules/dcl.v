`timescale 1ns/1ps
module dcl (
  clock,
  rst_b,
  mode,
  mcluster,
  nbpacket,
  ask_data,
  buffwr,
  fifo_full,
  push,
  datain,
  trigger,	//an output for the triggerCounters
  packet
);



input clock;	//40 MHz beam clock
input rst_b;
input buffwr;     //buffwr triggers a new word push into the fifo. As of 9apr11, this word is generated within this module
input mcluster;    //compatibility input for Daniel's port list
input [2:0] nbpacket;    //compatibility  max number of packets per event port width TBD
output      ask_data;    //compatibility ask L1 buffer for another packet to process
input fifo_full;       //fifo is full, suppress futher pushes
output push;     //push the current packet value onto the fifo
output [53:0] packet;    //the oldest word in the fifo 
input [2:0] mode;     //TEMPorary, to embed
input [271:0] datain;

output trigger;

assign ask_data = 1'b0;  //not used at the moment

reg [53:0] packet;  //this will become a port when the locally generated word function becomes obsolete
wire fifo_full;

wire [7:0] L0ID;
assign L0ID = datain[271:264];

wire [7:0] BCID;
assign BCID = datain[263:256];


reg [9:0] triggerData; //L1: {110,L0ID[7:0]}  R3: {101,L0ID[7:0]}
reg [3:0] triggerDatCount;
reg       receivingTriggerData;
reg	  trigger;
//trigger detection
always @(posedge clock or  negedge rst_b ) 
   if ( rst_b == 1'b0  ) begin
     triggerData = 'b0;
     triggerDatCount = 'b0;
     receivingTriggerData = 'b0;
     trigger = 1'b0;
   end
   else  begin
    trigger = 1'b0;
    if ( receivingTriggerData == 1'b0 && buffwr == 1'b1 ) begin  //start of a new word
      receivingTriggerData = 1'b1;
      triggerDatCount = 10;
    end
    else if (receivingTriggerData == 1'b1 ) begin
       if (triggerDatCount  == 'b0 ) begin
          receivingTriggerData = 1'b0;
	  if ( triggerData[9:8] == mode[1:0] ) trigger = 1'b1;
	  triggerData  = 'b0;
       end
       else begin
	 triggerDatCount = triggerDatCount - 1'b1;
         triggerData = triggerData << 1;
         triggerData[0] = buffwr;
       end
    end
   end



//do a conversion, in a purely behavioral manner
integer index;
integer clusterCount;
reg     lastBit;
reg     inCluster1, inCluster2, inCluster3, inCluster4;
reg [7:0] cluster1add, cluster2add, cluster3add, cluster4add;
reg [2:0] cluster1width, cluster2width, cluster3width, cluster4width;
reg di;
always @(posedge clock or  negedge rst_b ) begin
   if ( rst_b == 1'b0  ) begin
      cluster1add = 8'b0;
      cluster2add = 8'b0;
      cluster3add = 8'b0;
      cluster4add = 8'b0;
      cluster1width = 3'b0;
      cluster2width = 3'b0;
      cluster3width = 3'b0;
      inCluster1 = 1'b0;
      inCluster2 = 1'b0;
      inCluster3 = 1'b0;
      inCluster4 = 1'b0;
      lastBit = 1'b0;
   end // reset
   else if ( trigger == 1'b1 ) begin
      cluster1add = 8'b0;
      cluster2add = 8'b0;
      cluster3add = 8'b0;
      cluster4add = 8'b0;
      cluster1width = 3'b0;
      cluster2width = 3'b0;
      cluster3width = 3'b0;
      cluster4width = 3'b0;
      inCluster1 = 1'b0;
      inCluster2 = 1'b0;
      inCluster3 = 1'b0;
      inCluster4 = 1'b0;
     clusterCount = 0;  //number of clusters found so far
     lastBit = 1'b0;
     di = 1'b0;
     for ( index = 0; index < 256 ; index = index + 1 ) begin
       lastBit = di;
       di = datain[index];
       if ( datain[index] == 1'b1) begin
         if ( lastBit == 1'b0) begin  //leading bit of a new cluster
           case ( clusterCount )
             0: begin
                  cluster1add = index;
                  inCluster1 = 1'b1;
                  cluster1width = 1'b1;
                end
             1: begin
                  cluster2add = index;
                  inCluster2 = 1'b1;
                  cluster2width = 1'b1;
                end
             2: begin
                  cluster3add = index;
                  inCluster3 = 1'b1;
                  cluster3width = 1'b1;
                end
             3: begin
                  cluster4add = index;
                  inCluster4 = 1'b1;
                  cluster4width = 1'b1;
                end
             default: begin
                   $display("DCL: Found more than three clusters in a 256-bit hit-pattern!");
                end
            endcase
            clusterCount = clusterCount + 1;
         end //leading edge of the cluster
         else begin  //already in a cluster
           if ( inCluster1 == 1'b1 ) begin cluster1width = cluster1width << 1; cluster1width[0] = 1'b1; end
           if ( inCluster2 == 1'b1 ) begin cluster2width = cluster2width << 1; cluster2width[0] = 1'b1; end
           if ( inCluster3 == 1'b1 ) begin cluster3width = cluster3width << 1; cluster3width[0] = 1'b1; end
           if ( inCluster4 == 1'b1 ) begin cluster4width = cluster4width << 1; cluster4width[0] = 1'b1; end
         end //mid-cluster handling
       end
       else begin
         inCluster1 = 1'b0;
         inCluster2 = 1'b0;
         inCluster3 = 1'b0;
         inCluster4 = 1'b0;
       end //else
     end //for index
   end //if trigger
end //always clock

//mode 1 = R3, mode 2 = L1 
//payload is 34 bits for 3 clusters/packet, OVF, end bit
wire [33:0] payload;
assign payload[33:0] = ( mode[2:0] == 3'h1 ) ? 
            { cluster4add, cluster3add, cluster2add, cluster1add, 2'b01 } :
            { cluster3add[7:0], cluster3width[2:0], cluster2add[7:0], cluster2width[2:0], cluster1add[7:0], cluster1width[2:0], 1'b1 };


reg push;
//respond to pushs or other local-data generating events
always @(posedge clock or negedge rst_b ) begin
   if ( rst_b == 1'b0 ) begin
   packet <= 'h0;
   push <= 1'b0;
  end//reset
  else begin
     if ( trigger == 1'b1 ) begin
      if ( fifo_full == 1'b1 ) $display ("[%d]%m:dcl received local-data FIFO overflow flag from readOut",`TB.cycle);
      else begin
         push <= 1'b1;
	 packet[53:50] <=  ( mode[2:0] == 3'h2 ) ? 4'b0000 : 4'b0100;  //TYP
         //ID bits lead the packet, but are DC so added at the end of the parallel data-path in serializer module
         packet[49:42] <= L0ID;    //this should actually be L0 trigger count for both DCLs
         packet[41:34] <= BCID;     
         #1  //kludge for behavioral. payload gets calculated in response to clock rising edge
         packet[33:0] <= payload[33:0];
      end //not overflow
    end //trigger
    else push <= 1'b0;
 end //not reset
end//always


endmodule
