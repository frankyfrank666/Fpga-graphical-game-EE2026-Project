`timescale 1ns / 1ps

module dff( input CLK, D, output reg Q =0);

    always @ (posedge CLK) begin
        Q <= D;
    end
       
endmodule

