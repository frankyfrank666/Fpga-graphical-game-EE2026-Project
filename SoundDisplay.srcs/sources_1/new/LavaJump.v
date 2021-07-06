`timescale 1ns / 1ps

module LavaJump(
    input sw,CLOCK, btnU,
    input [3:0]soundlevel,
    input CLK6mp25, [12:0]pixel_index,
    output reg [15:0]pixel_data = 0,
    output [6:0]seg,
    output [3:0]an,
    output reg [15:0]led = 16'b1111111111111111,
    output reg [2:0]levelup=0
    );
    
    wire [5:0]I;
    wire [6:0]J;
    IJKCoor(pixel_data,I,J);
    
    wire CLK30hz;
    MyClk(CLOCK,30000000,CLK30hz);
    wire RST;
    reg btnD = 0;
    DBCRaw(CLK30hz,btnD,RST);
    
    always @ (posedge CLK30hz) begin
        btnD = sw;
    end
    
        
    
    wire [15:0] Star;
    wire [15:0] Lava;
    wire [15:0] Volcano;
    wire [15:0] Monkey;
    wire [15:0] Safehouse;
    wire [15:0] loser;
    
    reg win = 0;
    reg lost = 0;
    reg [13:0]count = 100;

    Star Vo(CLOCK, CLK6mp25,pixel_index,Star);
    Lava Lv(CLOCK, CLK6mp25,pixel_index,Lava);
    Volcano VS(RST,win,lost, CLOCK, CLK6mp25,pixel_index,Volcano);
    Monkey mk(RST,lost, soundlevel, btnU,win,CLOCK, CLK6mp25,pixel_index,Monkey);
    Safehouse (RST,win,CLOCK,CLK6mp25,pixel_index,Safehouse);
    LOST (RST, lost, CLOCK,CLK6mp25,pixel_index,loser);
 
    always @ (posedge CLK6mp25) begin
            // monkey
            // Safehouse
            // Lost
            //volcano
            //lava
            //star
            lost = (led == 0);
            pixel_data = (Monkey <= 16'h0900)? Safehouse : Monkey;
            pixel_data = (pixel_data == 16'hffff)? loser : pixel_data;
            pixel_data = (pixel_data <= 16'h0800)? Volcano : pixel_data;
            pixel_data = (pixel_data <= 16'h0800)? Lava : pixel_data;
            pixel_data = (pixel_data <= 16'h0800)? Star : pixel_data;

    end
    reg flag=0;
    always@(posedge CLK30hz)begin 
    
        if(win==1&&flag==0)begin
        levelup<=levelup+1;
        flag=1;
        end
        if(RST) begin count = 100; win = 0; flag=0;end
        
        if (~lost) count = (count == 0) ? 0 : count-1; 
        else count = 8888;
        
        if(~(count == 0)) win = 0; 
        else win = 1;

    end 

    segment1000(CLOCK,count,seg, an);
    
    reg change = 0;
    wire sample;
    MyClk(CLOCK,500,sample);

    always@(posedge CLK6mp25)begin
            if(~win &&  J == 19 ) begin 
                if((Monkey >= 16'hb000) && (Volcano >= 16'hb000)) change = 1;
                if((Monkey >= 16'hb000) && (Volcano <= 16'h1100)) change = 0;
        end
    end
    
    always@(posedge change, posedge RST)begin
         if(RST) led = 16'b1111111111111111; 
         else led = led >> 2; 
    end


endmodule

