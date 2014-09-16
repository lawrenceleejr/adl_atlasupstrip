// Created by ihdl
primitive DFF_ASYNR (Q, CLK, DATA, RESET, notifier);
    output Q; reg Q;
    input CLK;
    input DATA;
    input RESET;
    input notifier;

    table
    //                   noti-| Q   : Q
    //CLK   DATA  RESET  fier | cur : next
    //------------------------|-----------
       ?      ?     ?     *   :  ?  : x ;//Timing violation
       ?      ?     0     ?   :  ?  : 0 ;//Reset (Dominant)
       ?      ?     *     ?   :  0  : 0 ;//Reset transitioning
       (01)   0     ?     ?   :  ?  : 0 ;//Normal operation
       (01)   1     1     ?   :  ?  : 1 ;//Normal operation
       *      1     1     ?   :  1  : 1 ;//pessimism reduction
       *      0     ?     ?   :  0  : 0 ;//pessimism reduction
       (?0)   ?     ?     ?   :  ?  : - ;//pessimism reduction
       (1?)   ?     ?     ?   :  ?  : - ;//pessimism reduction
       ?      *     ?     ?   :  ?  : - ;//pessimism reduction
    endtable
endprimitive
