`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2021 03:09:14 PM
// Design Name: 
// Module Name: segment
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


module segment(input CLOCK,input [3:0]soundlevel,output reg [6:0]SEG=7'b1111111,output reg [3:0]AN=4'b1111

    );
    reg count=0;
    always@(posedge CLOCK)begin
        count<=count+1;
        if (soundlevel==4'd0)begin
            AN<=4'b1110;
            SEG<=7'b1000000;
        end else if(soundlevel==4'd1)begin
            AN<=4'b1110;
            SEG<=7'b1111001;        
        end else if(soundlevel==4'd2)begin
            AN<=4'b1110;
            SEG<=7'b0100100;        
        end else if(soundlevel==4'd3)begin
            AN<=4'b1110;
            SEG<=7'b0110000;              
        end else if(soundlevel==4'd4)begin
            AN<=4'b1110;
            SEG<=7'b0011001;             
        end else if(soundlevel==4'd5)begin
            AN<=4'b1110;
            SEG<=7'b0010010;           
        end else if(soundlevel==4'd6)begin
            AN<=4'b1110;
            SEG<=7'b0000010;                
        end else if(soundlevel==4'd7)begin
            AN<=4'b1110;
            SEG<=7'b1111000;   
        end else if(soundlevel==4'd8)begin
            AN<=4'b1110;
            SEG<=7'b0000000;           
        end else if(soundlevel==4'd9)begin
            AN<=4'b1110;
            SEG<=7'b0010000;    
        end else if(soundlevel==4'd10)begin
            if(count==0)begin
                AN<=4'b1101;
                SEG<=7'b1111001;
            end else begin
                AN<=4'b1110;
                SEG<=7'b1000000;
            end
        end else if(soundlevel==4'd11)begin
            if(count==0)begin
                AN<=4'b1101;
                SEG<=7'b1111001;
            end else begin
                AN<=4'b1110;
                SEG<=7'b1111001;
            end
        end else if(soundlevel==4'd12)begin
            if(count==0)begin
                AN<=4'b1101;
                SEG<=7'b1111001;
            end else begin
                AN<=4'b1110;
                SEG<=7'b0100100;
            end
        end else if(soundlevel==4'd13)begin
            if(count==0)begin
                AN<=4'b1101;
                SEG<=7'b1111001;
            end else begin
                AN<=4'b1110;
                SEG<=7'b0110000;
            end   
        end else if(soundlevel==4'd14)begin
            if(count==0)begin
                AN<=4'b1101;
                SEG<=7'b1111001;
            end else begin
                AN<=4'b1110;
                SEG<=7'b0011001;
            end     
        end else if(soundlevel==4'd15)begin
            if(count==0)begin
                AN<=4'b1101;
                SEG<=7'b1111001;
            end else begin
                AN<=4'b1110;
                SEG<=7'b0010010;
            end   
        end                                             
    end
endmodule
