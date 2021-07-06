`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module Random( input RST, CLK,  output reg [7:0] Q = 7);
    always @ (posedge CLK, posedge RST)
        begin
            if (RST) Q <= 7;
            else begin 
                Q <= { Q[2:0], ~(Q[2]^Q[3]) } ; 
                Q[7] <= Q[3] ;
                Q[6] <= Q[0] ;
                Q[5] <= Q[2] ;
                Q[4] <= ~(Q[2]^Q[1]) ;
            end 
        end
endmodule