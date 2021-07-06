`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module Safehouse(
    input RST, win, CLOCK, CLK6mp25, [12:0]pixel_index,
    output reg [15:0]pixel_data
    );
    reg [15:0] House[0:6143];

    initial begin
    $readmemh("House.mem",House);
    end
    
    wire [5:0] I;
    wire [6:0] J;
    IJKCoor jk(pixel_index,I,J);
    
    reg [7:0]Shift = 0;
        
    always @ (posedge CLK6mp25) begin
        if(J < 96 - Shift) pixel_data = 16'hffff;
        else pixel_data = House[I * 96 + (J-95 + Shift)];
        end

    wire CLK30hz;
    MyClk(CLOCK,1200000,CLK30hz);
    always @ (posedge CLK30hz) begin
        if(~win || RST) Shift = 0;
        else Shift = (Shift == 96) ? 96 : Shift + 1;
    end

endmodule