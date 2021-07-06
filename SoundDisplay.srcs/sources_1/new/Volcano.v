`timescale 1ns / 1ps

module Volcano(
    input RST, 
    input win,lose,
    input CLOCK, CLK6mp25, [12:0]pixel_index,
    output reg [15:0]pixel_data
    );
    
    wire [15:0]A;
    wire [15:0]B;
    wire [15:0]C;
    wire endA;
    wire endB;
    wire endC;
    reg SetA = 0;
    reg SetB = 0;
    reg SetC = 0;

    VolcanoOnce a(SetA, CLOCK, CLK6mp25,pixel_index,A,endA);
    VolcanoOnce b(SetB, CLOCK, CLK6mp25,pixel_index,B,endB);
    VolcanoOnce c(SetC, CLOCK, CLK6mp25,pixel_index,C,endC);
    
    
    wire CLK2hz;

    wire [7:0]random;
    Random(RST,CLK2hz,random);
    
    MyClk sd(CLOCK,30000000,CLK2hz); //density?
    reg [1:0]count = 0;
        
    always @ (posedge CLK2hz) begin
            count = (count + 1) % 3;
    
            if (count == 0) begin
                SetA = (endC && endB) ? random[3] : 0;
                SetB = 0;
                SetC = 0;
            end
            else if (count == 1) begin
                SetA = 0;
                SetB = (endC && endA) ? random[7] :0;
                SetC = 0;
            end
            else if (count == 2) begin
                SetA = 0;
                SetB = 0;
                SetC = (endA && endB) ? random[0] :0;
            end
            
            if (win || lose || RST) begin SetA=0; SetB=0; SetC=0; end
    end
    
    always @ (posedge CLK6mp25) begin
        pixel_data = A|B|C;
        end


endmodule