`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module VolcanoOnce(
    input acc, CLOCK, CLK6mp25, [12:0]pixel_index,
    output reg [15:0]pixel_data,output reg done = 1

    );
    wire CLK30hz;
    MyClk(CLOCK,1200000,CLK30hz);

    wire activate;
    DBCRaw(CLK30hz,acc,activate);

    
    reg [15:0] Volcano[0:1919];
    initial begin
    $readmemh("Volcano.mem",Volcano);
    end
    
    reg [7:0]Shift = 0; //shift == 96 then enter, shift > 126 disappear
  
    wire [5:0] I;
    wire [6:0] J;
    IJKCoor(pixel_index,I,J);
    
    always @ (posedge CLK6mp25) begin
        if( (Shift <= 96 && J < 96 - Shift ) || (J > 96 + 30 - Shift) ) pixel_data = 0;
        else pixel_data = Volcano[I * 30 + (J - 30 + Shift)];
    end
    
    always @ (posedge CLK30hz) begin
        if(activate && Shift == 0) begin Shift = 1; done = 0; end
        if(~(Shift == 0)) Shift = (Shift == 126) ? 0 : Shift + 1;
        if(Shift == 50) done = 1;
    end


endmodule