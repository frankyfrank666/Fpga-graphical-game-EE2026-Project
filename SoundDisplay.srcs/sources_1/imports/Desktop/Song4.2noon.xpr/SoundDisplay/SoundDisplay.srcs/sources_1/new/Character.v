`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module Character(
    input [1:0]phase,
    input Char,
    input CLOCK,
    input [12:0]pixel_index,
    
    output reg [15:0]CharData=0,
    output reg [5:0]dmg = 0,
    output man
    );
    

    
    assign man = Char;
    
    reg [15:0]monkey1[0:2559];
    reg [15:0]monkey2[0:2559];
    reg [15:0]monkeybig1[0:2559];
    reg [15:0]monkeybig2[0:2559];
    reg [15:0]monkeybigger1[0:2559];
    reg [15:0]monkeybigger2[0:2559];
    reg [15:0]dragon1[0:2559];        
    reg [15:0]dragon2[0:2559];              
    reg [15:0]dragonbig1[0:2559];     
    reg [15:0]dragonbig2[0:2559];          
    reg [15:0]dragonbigger1[0:2559];  
    reg [15:0]dragonbigger2[0:2559];  

    initial begin
    $readmemh("monkey11.mem",monkey1);
    $readmemh("monkey12.mem",monkey2);
    $readmemh("monkeybig11.mem",monkeybig1);
    $readmemh("monkeybig12.mem",monkeybig2);
    $readmemh("monkeybigger11.mem",monkeybigger1);
    $readmemh("monkeybigger12.mem",monkeybigger2);  
    $readmemh("dragon11.mem",dragon1);
    $readmemh("dragon12.mem",dragon2);
    $readmemh("dragonbig11.mem",dragonbig1);
    $readmemh("dragonbig12.mem",dragonbig2);
    $readmemh("dragonbigger11.mem",dragonbigger1);
    $readmemh("dragonbigger12.mem",dragonbigger2);
    end
    
    wire clk6p25m;
    MyClk c0(CLOCK, 7, clk6p25m); 
    wire CLK30;
    MyClk hh(CLOCK, 30000000, CLK30); 
   
    
    reg [12:0]idx;
    wire [5:0]I;
    wire [6:0]J;
    IJKCoor(pixel_index,I,J);
    always @ (posedge clk6p25m) begin
    
    idx = I * 40 + J; 
    if(J >= 40)begin 
    CharData = 0;
    end
    else begin
        
    if(Char == 0) begin
        if(phase == 0) begin
            dmg = 3;
            CharData = monkey1[idx];

        end
        else if(phase == 1) begin
            dmg = 5;

            CharData = monkeybig1[idx];    

        end
        else if(phase == 2) begin
            dmg = 8;
            
            CharData = monkeybigger1[idx];       
       
        end
    end
    
    else begin                                                 
        if(phase == 0) begin
            dmg = 2;

            CharData = dragon1[idx];

        end                           
        else if(phase == 1) begin      
            dmg = 4;
            CharData = dragonbig1[idx];    
 
        end   
        else if(phase == 2) begin      
            dmg = 6;
            CharData = dragonbigger1[idx];        
        end                           
    end
    end
    end


endmodule