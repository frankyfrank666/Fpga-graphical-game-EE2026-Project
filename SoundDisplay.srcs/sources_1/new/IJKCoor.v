`timescale 1ns / 1ps

module IJKCoor(
    input [12:0] pixel_index,
    output reg [5:0]i,
    output reg [6:0]j
    );
    
    always @ (*) begin
     i = pixel_index / 96;
     j = pixel_index % 96;
    end
    
endmodule
