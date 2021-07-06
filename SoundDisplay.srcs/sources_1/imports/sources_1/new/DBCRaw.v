`timescale 1ns / 1ps

module DBCRaw(
    input CLOCK,
    input D,
    output K
    );
    
    wire A;
    wire B;
    dff c(CLOCK, D, A);
    dff d(CLOCK, A, B);

    assign K = (~B) & A;
  
    
endmodule