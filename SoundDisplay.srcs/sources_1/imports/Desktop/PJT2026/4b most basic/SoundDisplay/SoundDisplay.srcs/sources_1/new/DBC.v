`timescale 1ns / 1ps

module DBC(
    input CLOCK,
    input D,
    output K
    );
    
    reg [20:0]count2 = 0;
    reg active = 0;
    always @ (posedge CLOCK) begin
        count2 = count2 + 1;
        if(D) begin
            active = 1;
            count2 = 0;
            end
        if(count2 == 21'b111111111111111111111) active <= 0;
    end

//    wire Q0;
//    dff a(Clk, D, Q0); //introduce a delay to prevent double clicking
    
    wire Q1;
    wire Q2;

    dff c(CLOCK, active, Q1);
    dff d(CLOCK, Q1, Q2);
    assign K = (~Q2) & Q1;
    
endmodule