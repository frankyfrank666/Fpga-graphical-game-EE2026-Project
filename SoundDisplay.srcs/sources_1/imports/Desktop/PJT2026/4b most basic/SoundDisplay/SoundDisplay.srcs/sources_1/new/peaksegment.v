`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2021 04:10:39 PM
// Design Name: 
// Module Name: peaksegment
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


module peaksegment(input CLOCK,input [11:0]peak,output reg [3:0]AN=0,output reg [6:0]SEG=0

    );
    always@(posedge CLOCK)begin
        if((peak>=12'd2048)&&(peak<12'd2730))begin
            AN<=4'b1110;
            SEG<=7'b1000111;
        end else if ((peak>=12'd2730)&&(peak<12'd3412))begin
            AN<=4'b1110;
            SEG<=7'b1101010;
        end else if ((peak>=12'd3412)&&(peak<=12'd4095))begin
            AN<=4'b1110;
            SEG<=7'b0001001;
        end 
    end
endmodule
