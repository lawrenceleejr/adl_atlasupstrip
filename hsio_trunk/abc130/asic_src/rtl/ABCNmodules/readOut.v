`timescale 1ns/1ps
module readOut (
  //primary
  clk,
  bclk,
  rstb,
  //soft-error detect signals
  serReg,
  //CSR stuff
  ID,
  pryority,
  dir,
  //pad signals
  DATLoen,
  DATRoen,
  DATLi,
  DATLo,
  DATRi,
  DATRo,
  XOFFLi,
  XOFFLo,
  XOFFRi,
  XOFFRo,
  XOFFLoen,
  XOFFRoen,
  //data and flow control from above
  en_Thru,
  en_L1,
  en_R3,
  en_CSRa,
  en_CSRb,
  L1DCLdOut,
  L1push,
  R3DCLdOut,
  R3push,
  CSRa,
  CSRb,
  CSRapush,
  CSRbpush,
  registerAddress,
  //flow control back to above
  L1DCLFifoFull,
  R3DCLFifoFull,
  CSRaFifoFull,
  CSRbFifoFull,
  thruFifoFull,
  //FIFO overflows
  L1FIFOoverflow ,
  R3FIFOoverflow ,
  CSRaFIFOoverflow ,
  CSRbFIFOoverflow , 
  thruFIFOoverflow
);

//log depth of the control-status-register FIFOs
parameter logCSRFIFODEPTH=3 ;


  input clk;
  input bclk;
  input serReg;
  input rstb;
  input [4:0] ID;
  input [3:0] pryority;
  input dir;
  output DATLoen;
  output DATRoen;
  output DATLo;
  input  DATLi;
  output XOFFLo;
  input  XOFFLi;
  output DATRo;
  input  DATRi;
  output XOFFRo;
  input  XOFFRi;
  output XOFFLoen;
  output XOFFRoen;
  input [53:0] L1DCLdOut;
  input L1push;
  input [53:0] R3DCLdOut;
  input R3push;
  input [31:0] CSRa;
  input CSRapush;
  input [31:0] CSRb;
  input CSRbpush;
  input [6:0] registerAddress;
  input en_Thru; //enable pushes into the Thru FIFO
  input en_L1; //enable pushes into the L1 FIFO
  input en_R3; //enable pushes into the R3 FIFO
  input en_CSRa; //enable pushes into the CSRa FIFO
  input en_CSRb; //enable pushes into the CSRb FIFO
  output L1DCLFifoFull;
  output R3DCLFifoFull;
  output CSRaFifoFull;
  output CSRbFifoFull;
  output thruFifoFull;
  output L1FIFOoverflow;
  output R3FIFOoverflow;
  output CSRaFIFOoverflow;
  output CSRbFIFOoverflow;
  output thruFIFOoverflow;

  wire L1FIFOoverflow;
  wire R3FIFOoverflow;
  wire CSRaFIFOoverflow;
  wire CSRbFIFOoverflow;
  wire thruFIFOoverflow;
  
  wire thruFifoFull;

  

//L1 DCL interface
  wire [53:0] L1DCLdOut;
  wire L1push;  //push a value from L1 DCL into L1 DCL FIFO
  wire L1pop;
  wire L1DCLFifoFull, L1FifoEmpty;
  wire [53:0] L1dOut;  //read-out data to be sent to serializer for transmission

//R3 DCL interface
  wire [53:0] R3DCLdOut;  //payload and header, without start-bit & chip-ID
  wire R3push;  //push a value from R3 DCL into R3 DCL FIFO
  wire R3pop;
  wire R3DCLFifoFull, R3FifoEmpty;
  wire [53:0] R3dOut;  //read-out data to be sent to serializer for transmission

//Control/Status/Register read-out 32-bits high-priority
  wire [31:0] CSRa;
  wire CSRapush;  //push a value from CSR into CSR FIFO
  wire CSRapop;
  wire CSRaFifoEmpty, CSRaFifoFull;
  wire [31:0] CSRadOut;  //read-out data to be sent to serializer for transmission

//Control/Status/Register read-out 32-bits low-priority
  wire [31:0] CSRb;
  wire CSRbpush;  //push a value from CSR into CSR FIFO
  wire CSRbpop;
  wire CSRbFifoEmpty, CSRbFifoFull;
  wire [38:0] CSRbdOut;  //read-out data to be sent to serializer for transmission, including 7-bit register address
  wire [6:0] registerAddress;  //name of register being read


wire [53:0] dOut;  //read-out data to be sent to serializer for transmission
wire fifoEmpty;
wire pop;



wire NCL1almostFull;  //no-connect
wire en_L1push = L1push & en_L1;
syncFifo #(.WORDWIDTH(52), .logDEPTH(6) ) L1Fifo (
  .dIn ( L1DCLdOut[51:0] ),
  .dOut (L1dOut[51:0] ),
  .we (en_L1push),
  .re (L1pop),
  .full (L1DCLFifoFull),    
  .empty (L1FifoEmpty),
  .almostFull (NCL1almostFull),
  .overflow ( L1FIFOoverflow ),
  .clk ( bclk ),
  .rstb ( rstb )
);
assign L1dOut[53:52] = L1DCLdOut[53:52];  //bits [53:52] constant, no need to put them through the FIFO

//always @(posedge L1pop) $display("ROpkt=%b",L1dOut);
//always @(posedge en_L1push) $display("Ripkt=%b",L1DCLdOut);


wire NCR3almostFull;  //no-connect
wire en_R3push = R3push & en_R3;
syncFifo #(.WORDWIDTH(51), .logDEPTH(4)) R3Fifo (
  .dIn ( R3DCLdOut[50:0] ),
  .dOut (R3dOut[50:0] ),
  .we (en_R3push),
  .re (R3pop),
  .full (R3DCLFifoFull),    
  .almostFull (NCR3almostFull),
  .empty (R3FifoEmpty),
  .overflow ( R3FIFOoverflow ),
  .clk ( bclk ),
  .rstb (  rstb )
);
assign R3dOut[53:51] = R3DCLdOut[53:51];  //bits [53:51] constant, no need to put them through the FIFO



//high priority locally generated data (overflows, error conditions...) loads into the dataFifo
wire NCCSRAalmostFull;  //no-connect
wire en_CSRapush = CSRapush & en_CSRa;
syncFifo #(.WORDWIDTH(32), .logDEPTH(logCSRFIFODEPTH) ) CSRaFifo (
  .dIn ( CSRa),
  .dOut (CSRadOut ),
  .we (en_CSRapush ),
  .re (CSRapop),
  .full (CSRaFifoFull),    //not currently used
  .empty (CSRaFifoEmpty),
  .almostFull (NCCSRAalmostFull),
  .overflow ( CSRaFIFOoverflow ),
  .clk ( bclk ),
  .rstb (  rstb )
);



//locally generated data (push, register read, sendID...) loads into the dataFifo
wire NCCSRBalmostFull;  //no-connect
wire en_CSRbpush = CSRbpush & en_CSRb;
syncFifo #(.WORDWIDTH(39), .logDEPTH(logCSRFIFODEPTH) ) CSRbFifo (
  .dIn ( {registerAddress, CSRb}),
  .dOut (CSRbdOut ),
  .we (en_CSRbpush ),
  .re (CSRbpop),
  .full (CSRbFifoFull),    //not currently used
  .empty (CSRbFifoEmpty),
  .almostFull (NCCSRBalmostFull),
  .overflow ( CSRbFIFOoverflow ),
  .clk ( bclk ),
  .rstb (  rstb )
);


//if any of the three fifos are not empty, tell the serializer module
assign fifoEmpty = L1FifoEmpty & R3FifoEmpty & CSRbFifoEmpty;
//Priority:  CSRa > R3 > L1 > CSRb
//CSRdOut is 32 bits for register reads. dOut is 54 wide, so 34-32 padding 0's are needed
//register address in [48:42]
//register soft-error detect is in [49]
// CSRa : default Priority Register address fixed at $00 (7 bits)

assign dOut = !CSRaFifoEmpty ?  {4'b1000,serReg,7'h3f,8'b0,CSRadOut[31:0],2'b0} :
              (!R3FifoEmpty ? R3dOut : 
              ( !L1FifoEmpty ? L1dOut :  
              {4'b1000,serReg,CSRbdOut[38:32],8'b0,CSRbdOut[31:0],2'b0} )); //typ=1000 regAd[7:0],8'0
	      
reg CSRap, R3p, L1p, CSRbp;
wire freeze;

/*always @(posedge bclk ) begin
  if (freeze) begin
  dOut <= dOut;
  end else begin
  dOut <= !CSRaFifoEmpty ?  {1'b1,20'b0,serReg,CSRadOut} : 
              (!R3FifoEmpty ? R3dOut : 
              ( !L1FifoEmpty ? L1dOut :  
              {1'b1,12'b0,serReg,CSRbdOut} ));
  end
end  
*/
always @(posedge clk ) begin
  if (freeze) begin
  CSRap <= CSRap;
  R3p <= R3p;
  L1p <= L1p;
  CSRbp <= CSRbp;
  end else begin
  CSRap <=   !CSRaFifoEmpty;
  R3p <= CSRaFifoEmpty & !R3FifoEmpty;
  L1p <= CSRaFifoEmpty & R3FifoEmpty & !L1FifoEmpty;
  CSRbp <= CSRaFifoEmpty & R3FifoEmpty &  L1FifoEmpty  & !CSRbFifoEmpty;
  end
end  

assign CSRapop =   CSRap & pop;
assign R3pop =     R3p & pop; 
assign L1pop =     L1p & pop;
assign CSRbpop =   CSRbp & pop;

wire DATLoen, DATRoen;
wire XOFFLoen, XOFFRoen;
wire DATLo, DATLi;
wire DATRo, DATRi;
wire XOFFLo, XOFFRo;
serializer serializer(
  .clk (clk),
  .bclk (bclk),
  .rstb (rstb),
  .pryority ( pryority[3:0] ),
  .ID ( ID[4:0] ),
  //
  .localFifoDout ( dOut ),
  .syncLocalFifoRE  (pop),
  .freezeRE(freeze),
  .localFifoEmpty (fifoEmpty),
  //
  .thruFIFOoverflow ( thruFIFOoverflow ),
  .thruFifoFull ( thruFifoFull ),
  .enThru ( en_Thru ),
  //pad direction control
  .DIR     (dir),
  .DATLoen (DATLoen),
  .DATRoen (DATRoen),
  .XOFFLoen (XOFFLoen),
  .XOFFRoen (XOFFRoen),
  //pad data
  .DATLi (DATLi),
  .DATLo (DATLo),
  .DATRi (DATRi),
  .DATRo (DATRo),
  .XOFFLi (XOFFLi),
  .XOFFRi (XOFFRi),
  .XOFFLo (XOFFLo),
  .XOFFRo (XOFFRo)
); //serializer 

endmodule //readOut

