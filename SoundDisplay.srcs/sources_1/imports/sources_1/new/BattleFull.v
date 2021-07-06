`timescale 1ns / 1ps

module BattleFull(
    input resetsw, sw, btnC,CLOCK,btnL,btnR,clk6p25m,
    input [12:0]pixel_index,
    input [1:0]phase,
    output reg [15:0]pixel_data,
    output reg [15:0]led = 0,
    output [6:0]seg,
    [3:0]an,  
    output reg [2:0]levelup =0
    );            
        
    wire [5:0] I;
    wire [6:0] J;
    IJKCoor(pixel_index,I,J);
    
    
    
    wire [5:0]dmg; //user's damage
    wire [15:0]CharData;
    Character(phase,sw,CLOCK,pixel_index,CharData,dmg);
 
    wire [15:0]Bossdata;
    Boss(CLOCK,clk6p25m,pixel_index,Bossdata);
            
    reg [5:0]bloodA = 45;
    reg [5:0]bloodB = 45;
    reg Adead = 0;
    reg Bdead = 0;
     
    //---------------------Random Modules------------------=
    wire clk3hz;                 
    MyClk(CLOCK,10000000,clk3hz);
    wire clk6hz;                 
    MyClk(CLOCK,5000000,clk6hz);
    wire [7:0]AIdecision;
    wire RESET;
    Random(RESET,clk6hz,AIdecision);

    wire [15:0]choiceUI;
    wire decision;
    wire done;
    reg X = 0;
    wire ld;
    choice(X, btnL, btnR, CLOCK, clk6p25m, pixel_index, choiceUI, ld, decision,done);
    reg [13:0] reaation;
    segment1000(CLOCK,reaation,seg,an);
    
    reg randAtk;
    
    wire reset;
    DBCRaw(clk3hz,resetsw,reset);
    
    always @ (posedge clk3hz) begin
        if(reset) begin
        Adead = 0; Bdead = 0;
        bloodA = 45; bloodB = 45;
        X = 0;
        end
        
        else begin
        if(~done) X = 0;
        if(done && ~Adead && ~Bdead) begin
        X = 1;
        reaation = {decision,AIdecision[1]};
        randAtk = AIdecision;
        case (reaation)
        2'b01: begin 
                if(bloodA <= 5) bloodA = 0;
                else bloodA = bloodA - 4;
                end
                
        2'b10: begin 
                if(bloodB <= dmg/2) bloodB = 0;
                else bloodB = bloodB - dmg/2; 
                end         
        2'b11: begin 
                if ((randAtk % 3 == 0 && sw == 0) || ( randAtk % 2 && sw == 1)) begin
                                if(bloodB <= dmg) bloodB = 0;
                                else bloodB = bloodB - dmg;     
                end 
                else begin
                                if(bloodA <= 6) bloodA = 0;
                                else bloodA = bloodA - 6;
                end
            end
        
        
        2'b00: begin end
                endcase
        if(bloodA == 0) Adead = 1;
        if(bloodB == 0) Bdead = 1;
    end
end
end


    always @ (posedge Bdead) begin
        levelup = levelup + 1;

    end

    
    reg [15:0] won[0:1439];    
    reg [15:0] loser[0:399];
    initial begin
        $readmemh("won.mem",won);
        $readmemh("lost.mem",loser);
        end
    reg [15:0]win = 0;
    reg [15:0]lost = 0;
    always @ (posedge clk6p25m) begin
        win = (I > 4 && I < 21) ? won[(I-4) * 96 + J] : 0;
        lost = ((I > 20) && (I < 31) && (J > 25) && (J < 66)) ? loser[(I-20) * 40 + J - 25]: 0;
        end



        
    wire [15:0]background;
    Background(CLOCK, clk6p25m,pixel_index,background);
    
    always @ (posedge clk6p25m) begin
        if(Adead || Bdead) led = 0;
        else led = ld;
        
        if (Adead) pixel_data = lost;
        else if(Bdead) pixel_data = win;
        else begin
        pixel_data = (CharData) | (Bossdata) | choiceUI;
        pixel_data = (I < 3 && (J < (bloodA) || J > (96 - bloodB))) ? 16'h0fe0 : pixel_data;
        pixel_data = (pixel_data <= 16'h0100) ? background : pixel_data;
        end
    end   
endmodule
