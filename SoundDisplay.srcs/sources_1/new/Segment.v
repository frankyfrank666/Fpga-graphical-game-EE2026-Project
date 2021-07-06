`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module segment1000(input CLOCK,input [13:0]number,output reg [6:0]seg = 0, output reg [3:0]an =4'b1111
    );
    reg [1:0]count=0;
    wire slowClock;
    MyClk(CLOCK,200000,slowClock);
    always@(posedge slowClock)begin
            count <= count+1;
            end

    reg [3:0]one = 0;  wire [6:0]A;
    reg [3:0]ten = 0;  wire [6:0]B;
    reg [3:0]hun = 0;  wire [6:0]C;
    reg [3:0]tha = 0;  wire [6:0]D;
    
    NumToSeg tr(CLOCK,one,A);
    NumToSeg t2(CLOCK,ten,B);
    NumToSeg t3(CLOCK,hun,C);
    NumToSeg t4(CLOCK,tha,D);
    
    
    always @ (CLOCK)begin
        one = number % 10;
        ten = (number / 10) % 10;
        hun = (number / 100) % 10;
        tha = (number / 1000) % 10;
        
        if(count == 0)      begin an = 4'b1110; seg = A; end
        else if(count == 1) begin an = 4'b1101; seg = B; end
        else if(count == 2) begin an = 4'b1011; seg = C; end
        else if(count == 3) begin an = 4'b0111; seg = D; end 
        
    end

endmodule
