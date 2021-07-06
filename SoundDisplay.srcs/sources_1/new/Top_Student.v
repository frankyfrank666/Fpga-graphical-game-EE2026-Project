`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//
//  LAB SESSION DAY (Delete where applicable): MONDAY P.M, TUESDAY P.M, WEDNESDAY P.M, THURSDAY A.M., THURSDAY P.M
//
//  STUDENT A NAME: 
//  STUDENT A MATRICULATION NUMBER: 
//
//  STUDENT B NAME: 
//  STUDENT B MATRICULATION NUMBER: 
//
//////////////////////////////////////////////////////////////////////////////////


module Top_Student (
    input CLOCK,btnC,btnL,btnR,btnU,btnD,
    input [15:0]sw,
    input  J_MIC3_Pin3,   // Connect from this signal to Audio_Capture.v
    output J_MIC3_Pin1,   // Connect to this signal from Audio_Capture.v
    output J_MIC3_Pin4,    // Connect to this signal from Audio_Capture.v
    output [15:0]led,
    output [6:0]seg,
    output [3:0]an,
    output [0:7]JB
    );
    
    wire CLK20k;
    wire clk6p25m;
    wire CLK10;
    wire clk381hz;
    MyClk c0(CLOCK, 7, clk6p25m); 
    MyClk c1(CLOCK, 2499, CLK20k); 
    MyClk c2(CLOCK, 4999000, CLK10); 
    MyClk c3(CLOCK, 131000, clk381hz); 
    wire clk_samp,sclk;
    wire [11:0]sample;
    Audio_Capture AD(
        .CLK(CLOCK),                  // 100MHz clock
        .cs(CLK20k),                   // sampling clock, 20kHz
        .MISO(J_MIC3_Pin3),                 // J_MIC3_Pin3, serial mic input
        .clk_samp(J_MIC3_Pin1),            // J_MIC3_Pin1
        .sclk(J_MIC3_Pin4),            // J_MIC3_Pin4, MIC3 serial clock
        .sample(sample)     // 12-bit audio sample data
        );
    
    wire frame_begin, sending_pixels, sample_pixel;
    wire [12:0]pixel_index;
    wire reset;
    DBC db(CLOCK,btnC,reset);
    wire [15:0] pixel_data;
    wire [4:0]teststate;
    Oled_Display od0 (.clk(clk6p25m), .reset(reset), .pixel_data(pixel_data), .frame_begin(frame_begin), 
        .sending_pixels(sending_pixels), .sample_pixel(sample_pixel), .pixel_index(pixel_index), 
        .cs(JB[0]), .sdin(JB[1]), .sclk(JB[3]), .d_cn(JB[4]), .resn(JB[5]), .vccen(JB[6]), 
        .pmoden(JB[7]), .teststate(teststate));

///*-------------------------task4a----------------------------------------*/
    wire [3:0]soundlevel;
    wire [3:0]soundlevel1;
    wire [3:0]soundlevel2;
    wire [15:0]LED1;
    wire [15:0]LED2;
    wire [6:0]SEG1;
    wire [6:0]SEG2;
    wire [3:0]AN1;
    wire [3:0]AN2;
    wire [11:0]peak;
    wire [11:0]mic_in;
    task4a unit3(.CLOCK(CLK10),.sample(sample),.soundlevel(soundlevel1),.LED(LED1));
    segment unit4(.CLOCK(clk381hz),.soundlevel(soundlevel),.SEG(SEG1),.AN(AN1));
    intensity unit5(.CLOCK(CLK20k),.sample(sample),.soundlevel(soundlevel2),.peak(peak),.LED(LED2));
    peaksegment unit6(.CLOCK(CLK10),.peak(mic_in),.AN(AN2),.SEG(SEG2));
    
//    sw[11] is master switch, nothing is on when 13 is on

/*-------------------task4b--------------------------*/    
   wire [6:0]X,Y;
   Cartisian ct(pixel_index,X,Y);  
   wire [15:0]pixel_data1;
   Oled4b unit7(
   .CLK20k(CLK20k),
   .mic_in(mic_in),
   .X(X), .Y(Y),
   .CLOCK(CLOCK),.slowCLOCK(clk6p25m),.sw(sw),.soundlevel(soundlevel),.pixel_index(pixel_index),.btnL(btnL),.btnR(btnR),.btnD(btnD),.btnU(btnU), .pixel_data(pixel_data1));   

/*-------------------Frank lava jump game--------------------------*/    

    //CLOCK = 100mhz, btnU for jump, btnD for Resets
    // sound level must use peak data
    wire [6:0]SEG3;
    wire [3:0]AN3;
    wire [15:0]LED3;
    wire [15:0]pixel_data2;
    wire [2:0]levelup2;
    LavaJump(sw[4],CLOCK,btnU,soundlevel2,clk6p25m,pixel_index,pixel_data2,SEG3,AN3,LED3,levelup2);
    
       wire [10:0]row;
    wire [10:0]column;
    wire [15:0]pixel_data3;
    wire [15:0]pixel_data4;
    wire [15:0]pixel_data5;
   // assign pixel_data=(sw==0)?pixel_data2:pixel_data1;
    assign row = pixel_index / 96;
    assign column = pixel_index % 96;
    wire [1:0]leftcount;
    wire [1:0]rightcount;
    wire confirmflag;
    wire [2:0]levelup1;
    wire back;
    wire exit3;
  
     wire [3:0]AN4;
     wire [6:0]SEG4;
     wire count3;
     wire next;
     wire [1:0]phase;
     wire [3:0]levelup;
      wire [15:0]LED4;
     wire [6:0]SEG5;
     wire [3:0]AN5;
     wire [15:0]pixel_data6;
     wire [2:0]levelup3;
     assign levelup=levelup1+levelup2+levelup3;
     BattleFull(sw[5],count3,btnC,CLOCK,btnL,btnR,clk6p25m,pixel_index,phase,pixel_data6,LED4,SEG5,AN5,levelup3); 
     start unita(.CLOCK(CLOCK),.btnL(btnL),.btnC(btnC),.btnR(btnR),.count3(count3),.next(next));
     start_display unitb(.CLOCK(CLOCK),.pixel_index(pixel_index),.next(next),.count3(count3),.oled_data(pixel_data3));
     menu unitc(.exit3(exit3),.next(next),.count3(count3),.CLOCK(CLOCK),.btnL(btnL),.btnC(btnC),.btnR(btnU),.back(back));
     menu_display unitd(.CLOCK(CLOCK),.pixel_index(pixel_index),.levelup(levelup),.count3(count3),.oled_data(pixel_data4),.phase(phase));
     Eureka game1(.CLOCK(CLOCK),.sw1(sw[3]),.sw2(sw[4]),.back(back),.mic_in(sample),.btnL(btnL),.btnC(btnC),.btnR(btnR),.pixel_index(pixel_index),.oled_data(pixel_data5),.levelup(levelup1),.exit(exit3),.AN(AN4),.SEG(SEG4));

    assign soundlevel = (sw[0]==0)?soundlevel1:soundlevel2;
    
    
    
    assign mic_in = (sw[0]==0)?sample:peak;
    assign seg = (sw[11]==0)?((sw[1] == 0)? SEG1:SEG2):((count3==0)?((sw[5]==1)?SEG5:((sw[4]==1)?SEG3:7'b1111111)):((back==1)?SEG4:(sw[5]==1)?SEG5:7'b1111111));
    assign an =  (sw[11]==0)?((sw[1] == 0)? AN1:AN2):((count3==0)?((sw[5]==1)?AN5:((sw[4]==1)?AN3:4'b1111)):((back==1)?AN4:(sw[5]==1)?AN5:4'b1111));
    assign led = (sw[11]==0)?((sw[1] == 0)? LED1:LED2):((count3==0)?((sw[4]==1)?LED3:16'b0):16'b0);
    assign pixel_data = (sw[11]==0)?pixel_data1:((next==0)?pixel_data3:(count3==0)?(sw[5]==1)?pixel_data6:((sw[4]==1)?pixel_data2:pixel_data4):((back==1)?pixel_data5:(sw[5]==1)?pixel_data6:pixel_data4));
endmodule