`timescale 1ns/1ps

module majority_voter (in1, in2, in3, out, err);
    // synopsys template
    
    parameter WIDTH = 1;
	parameter QUIET = 0;
    
    input   [(WIDTH-1):0]   in1, in2, in3;
    
    output  [(WIDTH-1):0]   out;
    output          	    err;
    
    reg     [(WIDTH-1):0]   out;
    reg     	    	    err;
    
    always @(in1 or in2 or in3) begin
    	err = 0;
	out = vote (in1,in2,in3);
    end
    
    function vote_atom;
    	input in1,in2,in3;
    	begin
			if (in1 != in2) begin
`ifdef DC
`else
				if (!QUIET) begin
					$display("%d: SEU!!!", $time);
					$stop;
				end
`endif
    	    	vote_atom   = in3;
		    	err     	= 1;
			end
			else begin
		    	if (in2 != in3) err = 1;
    	    	vote_atom = in1;
			end
    	end
    endfunction
    
    function [(WIDTH-1):0] vote;
        input   [(WIDTH-1):0]   in1, in2, in3;
	integer i;
    	begin
	    for (i=0; i<WIDTH; i=i+1)
	    	vote[i] = vote_atom( in1[i], in2[i], in3[i] );
	end
    endfunction
    
 
endmodule
