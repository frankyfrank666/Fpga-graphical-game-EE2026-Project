`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2021 03:07:41 PM
// Design Name: 
// Module Name: task4a
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


module task4a(input CLOCK,input [11:0]sample,output reg [3:0]soundlevel=4'd0,output reg [15:0]LED

    );
    
    
    
    always @(posedge CLOCK)begin
        if((sample>=12'd2048)&&(sample<12'd2176))begin
            LED<=16'd1;
            soundlevel<=4'd0;
        end else if((sample>=12'd2176)&&(sample<12'd2304))begin
            LED<=16'd3;
            soundlevel<=4'd1;
        end else if((sample>=12'd2304)&&(sample<12'd2432))begin
            LED<=16'd7;
            soundlevel<=4'd2;
        end else if((sample>=12'd2432)&&(sample<12'd2560))begin
            LED<=16'd15;
            soundlevel<=4'd3;       
        end else if((sample>=12'd2560)&&(sample<12'd2688))begin
            LED<=16'd31;
            soundlevel<=4'd4;
        end else if((sample>=12'd2688)&&(sample<12'd2816))begin
            LED<=16'd63;
            soundlevel<=4'd5;
        end else if((sample>=12'd2816)&&(sample<12'd2944))begin
            LED<=16'd127;
            soundlevel<=4'd6;        
        end else if((sample>=12'd2944)&&(sample<12'd3072))begin
            LED<=16'd255;
            soundlevel<=4'd7;            
        end else if((sample>=12'd3072)&&(sample<12'd3200))begin
            LED<=16'd511;
            soundlevel<=4'd8;
        end else if((sample>=12'd3200)&&(sample<12'd3328))begin
            LED<=16'd1023;
            soundlevel<=4'd9;
        end else if((sample>=12'd3328)&&(sample<12'd3456))begin
            LED<=16'd2047;
            soundlevel<=4'd10;
        end else if((sample>=12'd3456)&&(sample<12'd3584))begin
            LED<=16'd4095;
            soundlevel<=4'd11;
        end else if((sample>=12'd3584)&&(sample<12'd3712))begin
            LED<=16'd8191;
            soundlevel<=4'd12;
        end else if((sample>=12'd3712)&&(sample<12'd3840))begin
            LED<=16'd16383;
            soundlevel<=4'd13;
        end else if((sample>=12'd3840)&&(sample<12'd3968))begin
            LED<=16'd32767;
            soundlevel<=4'd14;
        end else if((sample>=12'd3968)&&(sample<=12'd4095))begin
            LED<=16'd65535;
            soundlevel<=4'd15;
        end
    end

endmodule
