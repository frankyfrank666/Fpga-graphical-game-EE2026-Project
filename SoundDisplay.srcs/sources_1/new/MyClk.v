`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module MyClk(
    input CLOCK, 
    input [31:0] m,
    output reg slowclk = 0
    );
    reg [31:0] count = 0;
    
    always @ (posedge CLOCK) begin
        count <= (count == m) ? 0 : count + 1;
        slowclk <= (count == 0) ? ~slowclk : slowclk;
    end
    endmodule

