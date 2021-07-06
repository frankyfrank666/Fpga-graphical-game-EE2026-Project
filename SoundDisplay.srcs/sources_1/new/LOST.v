`timescale 1ns / 1ps

module LOST(
    input RST, 
    input lost,
    input CLOCK, CLK6mp25, [12:0]pixel_index,
    output reg [15:0]pixel_data
    );
    
    reg [15:0] loser[0:399];
    initial begin
        $readmemh("lost.mem",loser);
        end
    
        
    wire [5:0] I;
    wire [6:0] J;
    IJKCoor(pixel_index,I,J);
    
    reg [7:0]Shift = 0;
        
    always @ (posedge CLK6mp25) begin
    
        if((J < 96 - Shift) || (I < 6) || (I > 15) || (J > (96 - Shift + 40) )) pixel_data = 0;
        
        else pixel_data = loser[(I-6) * 40 + ((J - 96 + Shift) % 96)];
        end

    wire CLK30hz;
    MyClk(CLOCK,1200000,CLK30hz);
    
    always @ (posedge CLK30hz) begin
        if(~lost || RST) Shift = 0;
        else Shift = (Shift == 96) ? 96 : Shift + 1;
    end

    
endmodule
