`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/28/2021 11:31:30 PM
// Design Name: 
// Module Name: Eureka
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


module Eureka(input CLOCK,input sw1,input sw2,input back,input [11:0]mic_in,input btnL,btnC,btnR,input [12:0]pixel_index,output reg [15:0]oled_data=0,
output reg [2:0]levelup=0,output reg exit=0,output reg [3:0]AN=4'b1111,output reg [6:0]SEG=7'b1111111
    );
    reg [15:0] array1[0:6143];
    initial begin
    $readmemh("giftbox.mem",array1);
    end
    wire CLK10;
    MyClk unit0(CLOCK, 4999999, CLK10);
    reg [2:0]count=0;
    reg flag1=0;
    reg flag2=0;
    reg [1:0]a=0;
    reg [1:0]chance=2;
    wire left;
    wire right;
    wire middle;
    wire [6:0]x;
    wire [6:0]y;
    reg errorleft=0;
    reg errormiddle=0;
    reg errorright=0;
    DBC unit1(.CLOCK(CLOCK),.D(btnL),.K(left));
    DBC unit2(.CLOCK(CLOCK),.D(btnR),.K(right));
    DBC unit3(.CLOCK(CLOCK),.D(btnC),.K(middle));   
    Cartisian unit4(.pixel_index(pixel_index),.x(x), .y(y)); 
    always@(posedge CLK10)begin
    if(exit==0)begin
        if(mic_in[5]==1)begin
            count<=count+1;
            if(count==2)begin
                flag2<=1;
            end
        end
    end else if(exit==1)begin
        count<=0;
        flag2<=0;
    end
    end
    
    always@(posedge CLOCK)begin
    if(chance==0)begin
        exit<=1;
    end

    if(back==1)begin
    if(x<32)begin
        if(errorleft==0)begin
            oled_data<=array1[pixel_index];
        end else begin
            oled_data<=0;
        end
    end else if((x>31)&&(x<64))begin
        if(errormiddle==0)begin
            oled_data<=array1[pixel_index];
        end else begin
            
        end
    end else begin
        if(errorright==0)begin
            oled_data<=array1[pixel_index];
        end else begin
            oled_data<=0;
        end
    end
        if(flag1==0)begin
            if(flag2==1)begin
                a=mic_in%3;
                flag1=1;                
            end
        end else begin
            AN<=4'b1110;
            if(sw1==0)begin
                if(chance==2)begin
                    SEG<=7'b0100100;
                end
                if(chance==1)begin
                    SEG<=7'b1111001;
                end
            end
            if(sw1==1)begin
                if(a==0)begin
                    SEG<=7'b1000111;
                end else if(a==1)begin
                    SEG<=7'b1101010;
                end else if(a==2)begin
                    SEG<=7'b0101111;
                end
            end
            if(a==0)begin
                if(left==1)begin
                    exit<=1;
                    if(chance==2)begin
                    levelup<=levelup+1; 
                    end  
                end
                if(middle==1)begin
                    chance<=chance-1;
                    errormiddle<=1;
                end
                if(right==1)begin
                    chance<=chance-1;
                    errorright<=1;
                end 
            end else if(a==1)begin  
                if(middle==1)begin
                    exit<=1;
                    if(chance==2)begin
                    levelup<=levelup+1;
                    end 
                end
                if(left==1)begin
                    chance<=chance-1;
                    errorleft<=1;
                    end
                if(right==1)begin
                    chance<=chance-1;
                    errorright<=1;
                end                  
            end else if(a==2)begin
                    if(right==1)begin
                        exit<=1;
                        if(chance==2)begin
                        levelup<=levelup+1; 
                        end  
                    end
                    if(left==1)begin
                        chance<=chance-1;
                        errorleft<=1;
                    end
                    if(middle==1)begin
                        chance<=chance-1;
                        errormiddle<=1;
                    end               
            end
        end
    end 
    else if(exit==1) begin
    flag1<=0;
    a<=0;
    chance<=2;
    errorleft<=0;
    errormiddle<=0;
    errorright<=0;
    exit<=0;
    AN<=4'b1111;
    end
    end
endmodule

