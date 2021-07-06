module Star(
    input CLOCK, CLK6mp25, [12:0]pixel_index,
    output reg [15:0]pixel_data
    );
    reg [15:0] star[0:6143];
    initial begin
        $readmemh("star.mem",star);
        end
    
    wire [5:0] I;
    wire [6:0] J;
    IJKCoor jk(pixel_index,I,J);
    
    reg [6:0]Shift = 0;
    
    always @ (posedge CLK6mp25) begin
        pixel_data <=  star[I * 96 + (J + Shift) % 96];            
        end                                    
    
    wire CLK10hz;
    MyClk(CLOCK,8000000,CLK10hz);
    always @ (posedge CLK10hz) begin
        Shift = (Shift + 1) %  96;
    end

endmodule