// Created by ihdl
primitive MUX21_UDP (MUXOUT, SEL, DATA0, DATA1);
    output MUXOUT;
    input SEL;
    input DATA0;
    input DATA1;
    table
    //  SEL  DATA0 DATA1 : MUXOUT
         0     0     ?    :  0 ;// Note that inputs not specif.
         0     1     ?    :  1 ;// (like x) will make out=x
         1     ?     0    :  0 ;
         1     ?     1    :  1 ;
         x     0     0    :  0 ;
         x     1     1    :  1 ;
    endtable
endprimitive
