`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2021 07:04:25 AM
// Design Name: 
// Module Name: menu
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


module menu(input exit1,exit2,exit3,input next,input count3,input CLOCK,input btnL,btnC,btnR,output reg back=0

    ); 
    wire left;
    wire right;   
    DBC unit1(.CLOCK(CLOCK),.D(btnL),.K(left));
    DBC unit2(.CLOCK(CLOCK),.D(btnR),.K(right));
    always@(posedge CLOCK)begin
    if(next==1)begin
    if(exit1==1||exit2==1||exit3==1)begin
        back<=0;
    end

    if(count3==1) begin
        if(back==0)begin
        if(right==1)begin
        back<=3'b001;
        end 
        end   
    end
    end
    end

endmodule
