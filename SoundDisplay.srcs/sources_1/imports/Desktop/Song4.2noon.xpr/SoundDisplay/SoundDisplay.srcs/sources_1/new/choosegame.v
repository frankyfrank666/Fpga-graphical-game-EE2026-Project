`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2021 11:25:33 PM
// Design Name: 
// Module Name: choosegame
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module choosegame(
    input [1:0]phase,
    input Char,
    input CLOCK,
    input [12:0]pixel_index,
    output reg [15:0]CharData=0
    );
    reg [15:0]fire[0:2559];
    reg [15:0]dragon[0:2559];
    initial begin
    $readmemh("firechoose.mem",fire);
    $readmemh("dragonchoose.mem",dragon);  
    end  
    wire clk6p25m;
    MyClk c0(CLOCK, 7, clk6p25m); 
    wire CLK30;
    MyClk hh(CLOCK, 30000000, CLK30); 
        reg [12:0]idx;
    wire [5:0]I;
    wire [6:0]J;
    IJKCoor(pixel_index,I,J);
    always @ (posedge clk6p25m) begin
    
    idx = I * 56 + J-40; 
    if(J <= 40)begin 
    CharData = 0;
    end
    else begin
        
    if(Char == 0) begin
    CharData<=fire[idx];
    end else begin
    CharData<=dragon[idx];
    end
    end
    end
endmodule
