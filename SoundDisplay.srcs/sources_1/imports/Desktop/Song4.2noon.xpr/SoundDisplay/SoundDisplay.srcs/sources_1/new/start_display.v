`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2021 06:48:04 AM
// Design Name: 
// Module Name: start_display
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


module start_display(input CLOCK,input [12:0]pixel_index,input next,input count3,output reg [15:0]oled_data=0

    );
    reg [15:0] array1[0:6143];
    reg [15:0] array2[0:6143];
    initial begin
    $readmemh("start1.mem",array1);
    $readmemh("start4.mem",array2);
    end
    always@(posedge CLOCK)begin
    if(next==0)begin
        case(count3)
        0:begin oled_data<=array1[pixel_index];end
        1:begin oled_data<=array2[pixel_index];end
        endcase
    end else begin
        oled_data<=0;
    end
    end
endmodule
