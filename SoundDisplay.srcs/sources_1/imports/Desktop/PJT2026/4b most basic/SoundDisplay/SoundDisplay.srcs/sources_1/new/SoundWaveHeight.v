`timescale 1ns / 1ps

module SoundWaveHeight(
    input [11:0] mic_data,
    input mode,
    input [6:0] x,y,
    input [3:0]soundlevel,
    output reg [15:0] oled_data = 0
    );
    
    reg [5:0]  height = 0;
    reg [15:0] color = 0;
    
    always @ (soundlevel) begin
        if (soundlevel >= 0 ) color <= 16'h17E0; 
        if (soundlevel >= 1 ) color <= 16'h47E0; 
        if (soundlevel >= 2 ) color <= 16'h5FE0; 
        if (soundlevel >= 3 ) color <= 16'h77E0; 
        if (soundlevel >= 4 ) color <= 16'h7FE0; 
        if (soundlevel >= 5 ) color <= 16'h97E0; 
        if (soundlevel >= 6 ) color <= 16'h9FE0; 
        if (soundlevel >= 7 ) color <= 16'hAFE0; 
        if (soundlevel >= 8 ) color <= 16'hCFE0; 
        if (soundlevel >= 9 ) color <= 16'hE7E0; 
        if (soundlevel >= 10) color <= 16'hFF80; 
        if (soundlevel >= 11) color <= 16'hFE60; 
        if (soundlevel >= 12) color <= 16'hFD00; 
        if (soundlevel >= 13) color <= 16'hFBE0; 
        if (soundlevel >= 14) color <= 16'hFAE0; 
        if (soundlevel >= 15) color <= 16'hF800;  
    end
    
    
    always @ (*) begin
        height = (mic_data % 4096)/ 64;
        if(~mode) begin
            if ((y >= height && y < 32) || (y <= height && y >= 32)) oled_data = color;
            else oled_data = 0;
        end 
        else begin
            if ( (y >= 32 -height + 32) && (y <= 32 + height-32) && (x % 2 == 1)) oled_data = color;
            else oled_data = 0;
        end 
        
    end

endmodule
