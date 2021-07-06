`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module Monkey(
    input RST, lost, [3:0]soundlevel, btnU,win, CLOCK, CLK6mp25, [12:0]pixel_index,
    output reg [15:0]pixel_data
    );
    reg [15:0] array1[0:6143];
    reg [15:0] array2[0:6143];
    reg [15:0] array3[0:6143];

    initial begin
    $readmemh("monkey1.mem",array1);
    $readmemh("monkey2.mem",array2);
    $readmemh("monkey3.mem",array3);
    end

    wire clkcnt;
    MyClk(CLOCK,3000000,clkcnt);
    reg [1:0] count = 0;
    always@(posedge clkcnt)begin
        count<= (count+1) % 3; 
    end
        
    wire push;
    DBCRaw(clkcnt,btnU,push);   
        
    wire jump;
    reg [5:0]up = 0;
    reg down = 0;
    reg stop = 1;
    assign jump = stop ?  (push || soundlevel > 10) : 0;
    
    wire Jumpfast;
    MyClk(CLOCK,900000,Jumpfast);
    reg [10:0]waits = 13;

    always @ (posedge Jumpfast) begin
        if(RST) begin
            down = 0;stop = 1;up = 0;waits = 13;
            end
            
        if(jump) stop = 0;
        
        if(stop == 0) begin
            if (down == 1) begin
                if(waits) waits = waits -1;
                else up = up - 1; 
                end
            else up = up + 1;
            
            if (up == 30) down = 1; 
            
            if (down == 1 && up == 0) 
            begin stop = 1; down = 0;waits = 13; end
            
        end
    end

    wire [5:0] I;
    wire [6:0] J;
    IJKCoor(pixel_index,I,J);
    
    wire clkwalk;
    MyClk(CLOCK,3000000,clkwalk);
    
    reg [5:0] shift = 0;
    reg [6:0] hold = 0;
    reg [6:0]lostshift = 0;
    always @ (posedge clkwalk) begin
        if(RST) begin
            hold = 0;
            shift = 0;
            lostshift = 0;
        end
        
        if(lost) begin
            lostshift = (lostshift == 40) ? 40 : lostshift+1;
        end

        if(win) begin
            shift = (shift == 31) ? 31 : (hold == 35 ? shift + 1 : 0);
            hold = (hold == 35) ? 35 : hold + 1;
        end
        
        else begin
        hold = 0;
        shift = 0;
        end
    end
    
    reg [12:0]idx = 0;
    always@(pixel_index) begin
        if(lost) begin 
            if (J >= 40) pixel_data = 0;
            else pixel_data <= array1[96 * I + J + lostshift];
        end
        else begin
       idx = (J < 40) ? ((I + up) * 96 + (J - shift) % 96) : 0;
       
       if(shift == 31) pixel_data <= array1[idx];
       else begin
            if(count==0) pixel_data <= array1[idx];
       else if(count==1) pixel_data <= array2[idx];
       else if(count==2) pixel_data <= array3[idx];
       end
       end
   end
   
endmodule
