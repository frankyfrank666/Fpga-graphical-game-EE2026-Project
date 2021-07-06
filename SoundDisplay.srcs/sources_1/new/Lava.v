`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module Lava(
    input CLOCK, CLK6mp25, [12:0]pixel_index,
    output reg [15:0]pixel_data
    );
    reg [15:0] Lava[0:3199];
    initial begin
        $readmemh("Lava.mem",Lava);
        end
    
    
    wire [5:0] I;
    wire [6:0] J;
    IJKCoor(pixel_index,I,J);
    reg [7:0]Shift = 0;
    
    always @ (posedge CLK6mp25) begin
        if(I >= 44) pixel_data <=  Lava[ (I - 44) * 160 + (J + Shift) % 160]; // % by width so won't go up a line      
        else  pixel_data = 0;   
        end                                    
    
    wire CLK30hz;
    MyClk(CLOCK,1200000,CLK30hz);
    always @ (posedge CLK30hz) begin
        Shift = Shift + 1;
        if(Shift == 160) Shift = 0; // this one reduce imgage jerks transitioning to next cycle
    end


endmodule