`timescale 1ns / 1ps

module NumToSeg(input CLOCK,input [3:0]num,output reg [6:0]dsp = 7'b1111111);
        always @ (CLOCK) begin 
                 if(num== 4'b0000) dsp <=7'b1000000;
            else if(num== 4'b0001) dsp <=7'b1111001;        
            else if(num== 4'b0010) dsp <=7'b0100100;        
            else if(num== 4'b0011) dsp <=7'b0110000;          
            else if(num== 4'b0100) dsp <=7'b0011001;          
            else if(num== 4'b0101) dsp <=7'b0010010;          
            else if(num== 4'b0110) dsp <=7'b0000010;          
            else if(num== 4'b0111) dsp <=7'b1111000;   
            else if(num== 4'b1000) dsp <=7'b0000000;          
            else if(num== 4'b1001) dsp <=7'b0010000;          
            else dsp <= 7'b0000001;
    end
endmodule
