`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2021 06:35:05 AM
// Design Name: 
// Module Name: start
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


module start(input CLOCK,input btnL,btnC,btnR,output reg count3=0,output reg next=0

    );

    wire left;
    wire right;
    wire confirm1;
    wire confirm2;
    DBC unit1(.CLOCK(CLOCK),.D(btnL),.K(left));
    DBC unit2(.CLOCK(CLOCK),.D(btnR),.K(right));
    DBC unit3(.CLOCK(CLOCK),.D(btnC),.K(confirm1));
    DBC unit4(.CLOCK(CLOCK),.D(btnC),.K(confirm2));
    always @ (posedge CLOCK) begin
    if(next==0)begin
        if(left==1)begin
            count3<=count3+1;
            end
        if(right==1)begin
            count3<=count3-1;
            end
        if(confirm1==1)begin
            next=1;
        end
    end
    end
endmodule
