`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2021 07:27:24 AM
// Design Name: 
// Module Name: menu_display
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


module menu_display(input CLOCK,input [12:0]pixel_index,input [3:0]levelup,input count3,output reg [15:0]oled_data=0,reg[1:0]phase=0

    );

    wire clk6p25m;
    MyClk c0(CLOCK, 7, clk6p25m);
    always@(posedge CLOCK)begin
    
    if(levelup==2)begin
        phase=1;
    end
    if(levelup>3)begin
        phase=2;
    end       
    end
    wire [15:0]CharData1;
    wire [15:0]CharData2;
    
    reg [15:0]monkey1[0:2559];
    reg [15:0]monkeybig1[0:2559];
    reg [15:0]monkeybigger1[0:2559];
    reg [15:0]dragon1[0:2559];        
    reg [15:0]dragonbig1[0:2559];     
    reg [15:0]dragonbigger1[0:2559];  

    initial begin
    $readmemh("monkey11.mem",monkey1);
    $readmemh("monkeybig11.mem",monkeybig1);
    $readmemh("monkeybigger11.mem",monkeybigger1);
    $readmemh("dragon11.mem",dragon1);
    $readmemh("dragonbig11.mem",dragonbig1);
    $readmemh("dragonbigger11.mem",dragonbigger1);
    end
    
    reg [15:0]CharData=0;
    reg [12:0]idx;
    wire [5:0]I;
    wire [6:0]J;
    IJKCoor(pixel_index,I,J); 
    
    choosegame unit1(.phase(phase),.Char(count3),.CLOCK(CLOCK),.pixel_index(pixel_index),.CharData(CharData2));
    wire [6:0]x;
    wire [6:0]y;
    Cartisian unit2(.pixel_index(pixel_index),.x(x), .y(y));
    always @ (posedge clk6p25m) begin
    
    idx = I * 40 + J; 
    if(J >= 40)begin 
    CharData = CharData2;
    end
    else begin
    if(count3==0) begin 
    if(phase == 0) CharData = monkey1[idx];
    if(phase == 1) CharData = monkeybig1[idx];    
    if(phase == 2) CharData = monkeybigger1[idx];  
    end else begin
    if(phase == 0) CharData = dragon1[idx];
    if(phase == 1) CharData = dragonbig1[idx];    
    if(phase == 2) CharData = dragonbigger1[idx];    
    end
    end
    oled_data<=CharData;
end



    
        
    
endmodule
