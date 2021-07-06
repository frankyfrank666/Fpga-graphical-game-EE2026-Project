`timescale 1ns / 1ps

module Cartisian(
    input [12:0] pixel_index,
    output [6:0] x, y
    );
    
    assign x = pixel_index % 96;
    assign y = 64 - pixel_index / 96;
    
endmodule
