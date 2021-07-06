`timescale 1ns / 1ps

module AppWav(
    input hold,mode, 
    input clk,
    input [11:0] mic_in,
    input [6:0] x, y,
    input [3:0] soundlevel,
    output [15:0] pixel_data
    );
    
    reg [11:0] mic_data [95:0];
    integer i;
    initial begin
        for (i = 0; i < 96; i = i+1) begin
            mic_data[i] <= 12'b0;
        end
    end
    
    reg [6:0] X = 0; // X-axis
    
    always @ (posedge clk) begin
        if (X == 95) X = 0;
        else X = (X + 1);
        
        if( ~hold ) mic_data[X] = (X < 95) ? mic_data[X+1] : mic_in;
    end
    
    SoundWaveHeight ht(mic_data[x],mode, x, y,soundlevel, pixel_data);
    
endmodule
