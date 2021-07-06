`timescale 1ns / 1ps

module Boss(
    input CLOCK,
    input CLK6p25m,
    input [12:0]pixel_index,
    output reg [15:0]CharData
    );
    
    reg [15:0]thunder[0:2559];
    
    initial begin
    $readmemh("thunder.mem",thunder);
    end
    wire [5:0] I;
    wire [6:0] J;
    IJKCoor(pixel_index,I,J);
    
    reg [12:0]idx = 0;
    always @ (posedge CLK6p25m) begin
        if(J >= 56) begin
            idx = (I + 3) * 40 + J - 56 ; 
            CharData = thunder[idx];
        end
        else CharData = 0;
    end

endmodule