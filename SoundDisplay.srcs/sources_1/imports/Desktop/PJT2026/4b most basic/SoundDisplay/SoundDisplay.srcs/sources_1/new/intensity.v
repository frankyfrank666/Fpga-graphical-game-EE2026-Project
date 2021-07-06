`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2021 03:52:45 PM
// Design Name: 
// Module Name: intensity
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


module intensity(input CLOCK,input [11:0]sample,output reg [3:0]soundlevel=4'd0,output reg [11:0]peak=12'd0,output reg [15:0]LED=0

    );
    reg [25:0]count=0;
    reg [11:0]high=12'd0;
    always @(posedge CLOCK)begin
        count <= (count ==26'd1999)?0:count+1;
        peak <= (count == 0) ? sample : ((peak < sample ) ? sample: peak);
        if(count==0)begin
        if((peak>=12'd2048)&&(peak<12'd2176))begin
            LED<=16'd1;
            soundlevel<=4'd0;
        end else if((peak>=12'd2176)&&(peak<12'd2304))begin
            LED<=16'd3;
            soundlevel<=4'd1;
        end else if((peak>=12'd2304)&&(peak<12'd2432))begin
            LED<=16'd7;
            soundlevel<=4'd2;
        end else if((peak>=12'd2432)&&(peak<12'd2560))begin
            LED<=16'd15;   
            soundlevel<=4'd3;
        end else if((peak>=12'd2560)&&(peak<12'd2688))begin
            LED<=16'd31;
            soundlevel<=4'd4;
        end else if((peak>=12'd2688)&&(peak<12'd2816))begin
            LED<=16'd63;
            soundlevel<=4'd5;
        end else if((peak>=12'd2816)&&(peak<12'd2944))begin
            LED<=16'd127; 
            soundlevel<=4'd6;       
        end else if((peak>=12'd2944)&&(peak<12'd3072))begin
            LED<=16'd255; 
            soundlevel<=4'd7;           
        end else if((peak>=12'd3072)&&(peak<12'd3200))begin
            LED<=16'd511;
            soundlevel<=4'd8;
        end else if((peak>=12'd3200)&&(peak<12'd3328))begin
            LED<=16'd1023;
            soundlevel<=4'd9;
        end else if((peak>=12'd3328)&&(peak<12'd3456))begin
            LED<=16'd2047;
            soundlevel<=4'd10;
        end else if((peak>=12'd3456)&&(peak<12'd3584))begin
            LED<=16'd4095;
            soundlevel<=4'd11;
        end else if((peak>=12'd3584)&&(peak<12'd3712))begin
            LED<=16'd8191;
            soundlevel<=4'd12;
        end else if((peak>=12'd3712)&&(peak<12'd3840))begin
            LED<=16'd16383;
            soundlevel<=4'd13;
        end else if((peak>=12'd3840)&&(peak<12'd3968))begin
            LED<=16'd32767;
            soundlevel<=4'd14;
        end else if((peak>=12'd3968)&&(peak<=12'd4095))begin
            LED<=16'd65535;
            soundlevel<=4'd15;
        end        
    end
    end
   
endmodule
