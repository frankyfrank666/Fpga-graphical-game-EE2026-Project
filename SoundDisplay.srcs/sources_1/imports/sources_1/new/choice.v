`timescale 1ns / 1ps


module choice( // give a reset signal,(2hz wide) 
    input btnC, btnL, btnR, CLOCK, CLK6mp25, [12:0]pixel_index,
    output reg [15:0]pixel_data, output reg [15:0]led = 16'b1111111111111111, output reg decision = 0, output reg done = 1);
    wire RST;
    wire clk3hz;                 
    MyClk(CLOCK,10000000,clk3hz);
    DBCRaw(clk3hz,btnC,RST);
    reg enable = 1;
    reg [15:0] menu[0:1247];
    
    initial begin 
    $readmemh("snsmenu.mem",menu); 
    end
    
    wire L,R;
    
    dff (CLK6mp25,btnL,L);
    dff (CLK6mp25,btnR,R);

    wire [5:0] I;
    wire [6:0] J;
    IJKCoor(pixel_index,I,J);
    
    always @ (posedge CLK6mp25) begin
        pixel_data = enable ?  (I < 51 ? 0 : menu[(I-51) * 96 + J + 1]) : 0;
        pixel_data = (enable && L && J < 30 && I > 51 && pixel_data <16'h1500 ) ? 16'hF800 : pixel_data;
        pixel_data = (enable && R && J > 65 && I > 51 && pixel_data <16'h1500 ) ? 16'hF800 : pixel_data;
    end
    
    reg  [25:0] countL = 0;
    reg  [25:0] countR = 0;

    always @ (posedge CLOCK) begin
    
    if(RST) begin countL = 0; countR = 0; enable = 1; done = 0; end
    if(enable) begin
        if(L) countL = countL +1;
        if(R) countR = countR +1; // need to press hald a second
        
        if(countL >= 50000000) begin decision = 0;  enable = 0; done = 1; end
        else if (countR >= 50000000) begin decision = 1; enable = 0; done = 1;end
        else if(led == 0) begin decision = 0; enable = 0; done = 1;end
        end

    end    
    wire clk2hz;
    MyClk(CLOCK,50000000,clk2hz); //5 scends to decide
    always @ (posedge clk2hz , posedge RST) begin
        if(RST)begin 
        led = 16'b1111111111111111;
        end
        else if (~done)begin 
            led = led >> 1;
        end
    
    end
endmodule
