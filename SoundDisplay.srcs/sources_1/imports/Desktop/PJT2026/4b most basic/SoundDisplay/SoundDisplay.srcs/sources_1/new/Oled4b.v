module Oled4b (
    input CLOCK, slowCLOCK,btnL,btnR,btnU,btnD,
    input [15:0]sw,   
    input [3:0]soundlevel,
    input [12:0]pixel_index, 
    
    
    input CLK20k,
    input [11:0] mic_in,
    input [6:0] X, Y,
    
    
    output reg [15:0] pixel_data = 0
    );
    
//  Position
    reg [2:0]location = 2; //0 1 2 3 4
    wire Left;
    DBC L(CLOCK,btnL,Left);
    wire Right;
    DBC R(CLOCK,btnR,Right);
    always @ (posedge CLOCK)
    begin
        if(Left) location <= (location == 0)?  4 : location - 1;
        else if (Right) location <= (location + 1) % 5;
    end
    
///// Background color ///////////////////////////////////////////
    reg [15:0] background = 16'h0000;
    reg [1:0] turn = 2'b0;
    wire Up;
    DBC U(CLOCK,btnU,Up);

    always @ (posedge CLOCK) begin
        if (Up) begin
            turn = turn + 1;
            case (turn)
                2'b00 : background <= 16'h0000;
                2'b01 : background <= 16'h06F8;
                2'b10 : background <= 16'h2898;
                2'b11 : background <= 16'hB075;
            endcase
        end
    end
    //////////////////////////////////////////////////////////////////
    
    reg [1:0]boarderThick = 1;
    reg [10:0]row;
    reg [10:0]colum;

///// Boarder color ///////////////////////////////////////////     
    reg [15:0] boarder = 16'hFFFF;                                  
    reg [1:0] cnt = 2'b0;                                             
    wire Down;                                                           
    DBC D(CLOCK,btnD,Down);                                              
                                                                       
    always @ (posedge CLOCK) begin                                      
        if (Down) begin                                                  
            cnt = cnt + 1;                                           
            case (cnt)                                                
                2'b00 : boarder <= 16'hFFFF;                        
                2'b01 : boarder <= 16'h06DF;                        
                2'b10 : boarder <= 16'h07EE;                        
                2'b11 : boarder <= 16'hF01F;                        
            endcase                                                    
        end                                                            
    end                      
    ////////////////////////////////////////////////////////////////
    wire [15:0] wave;
    AppWav wv(
        .hold(sw[10]),.mode(sw[0]), 
        .clk(CLK20k),
        .mic_in(mic_in),
        .x(X), .y(Y),
        .soundlevel(soundlevel),
        .pixel_data(wave)
        );
                                        
    //////////////////////////////////////////////////////////////////     
    reg [1:0] bar = 0;
    always @ (posedge CLOCK) begin
        if(~sw[13] && ~sw[12]) bar = 0;
        else if(sw[13] && ~sw[12]) bar = 1;
        else if(~sw[13] && sw[12]) bar = 2;     
        else if(sw[13] && sw[12]) bar = 3;  
    end
    //////////////////////////////////////////////////////////////////
    always @ (posedge slowCLOCK) //90 / 5 = 18)     3 4 0 1 2 
    begin
        
        row = pixel_index / 96;
        colum = pixel_index % 96;
        
        boarderThick = sw[15]? 3:1;                                                                                       
        boarderThick = sw[14]? 0:boarderThick;  //turn off boarder
        
        if (sw[11]) begin //display big cross meaning null, turn off
            if (row * 3 == colum * 2 || row * 3 == (colum-1) * 2 || row * 3 == (colum-2) * 2 || 
                192 - row * 3 == colum * 2 || 192 - row * 3 == (colum-1) * 2 || 192 - row * 3 == (colum-2) * 2)
                pixel_data <= 16'hFFFF;
            else pixel_data <= 16'h0;
            end
            
        //boarder
        else if (colum < boarderThick || colum >= 96-boarderThick || row < boarderThick || row >= 64 - boarderThick) begin pixel_data <= boarder;end
     
        //wave overrides  bar position
        else if (bar == 2) pixel_data <= wave;           

         //state 3 == turn off the bar
        else if (bar == 3 || colum < location * 18 + 3+1 || colum > location * 18 + 3 + 17) pixel_data <= background;
        
        else if (bar == 0
        && ((soundlevel>= 0   && row <= 60 && row > 58) 
        || (soundlevel >= 1 && row <= 57 && row > 55) 
        || (soundlevel >= 2 && row <= 54 && row > 52) 
        || (soundlevel >= 3 && row <= 51 && row > 49) 
        || (soundlevel >= 4 && row <= 48 && row > 46) 
        || (soundlevel >= 5  && row <= 45 && row > 42))) pixel_data <= 16'h4FE0;
        
        else if(bar == 0
        && ((soundlevel>= 6 && row <= 41 && row > 38)
        || (soundlevel >= 7  && row <= 37 && row > 34)
        || (soundlevel >= 8  && row <= 33 && row > 30)
        || (soundlevel >= 9   && row <= 29 && row > 26)
        || (soundlevel >= 10 && row <= 25 && row > 22))) pixel_data <= 16'hEFE0;
                          
        else if (bar == 0
        && ((soundlevel>= 11 && row <= 21 && row > 18)
        || (soundlevel >= 12 && row <= 17 && row > 14) 
        || (soundlevel >= 13 && row <= 13 && row > 10) 
        || (soundlevel >= 14 && row <= 9  && row > 6 ) 
        || (soundlevel >= 15 && row <= 5  && row >= 3))) pixel_data <= 16'hF800;    
                          
       else if (bar == 1) begin
                if (soundlevel >= 0  && row > 57 ) pixel_data <= 16'h17E0; 
                if (soundlevel >= 1  && row > 54 ) pixel_data <= 16'h47E0; 
                if (soundlevel >= 2  && row > 51 ) pixel_data <= 16'h5FE0; 
                if (soundlevel >= 3  && row > 48 ) pixel_data <= 16'h77E0; 
                if (soundlevel >= 4  && row > 45 ) pixel_data <= 16'h7FE0; 
                if (soundlevel >= 5  && row > 41 ) pixel_data <= 16'h97E0; 
                if (soundlevel >= 6  && row > 37 ) pixel_data <= 16'h9FE0; 
                if (soundlevel >= 7  && row > 33 ) pixel_data <= 16'hAFE0; 
                if (soundlevel >= 8  && row > 29 ) pixel_data <= 16'hCFE0; 
                if (soundlevel >= 9  && row > 25 ) pixel_data <= 16'hE7E0; 
                if (soundlevel >= 10 && row > 21 ) pixel_data <= 16'hFF80; 
                if (soundlevel >= 11 && row > 17 ) pixel_data <= 16'hFE60; 
                if (soundlevel >= 12 && row > 13 ) pixel_data <= 16'hFD00; 
                if (soundlevel >= 13 && row > 9  ) pixel_data <= 16'hFBE0; 
                if (soundlevel >= 14 && row > 5  ) pixel_data <= 16'hFAE0; 
                if (soundlevel >= 15 && row > 2  ) pixel_data <= 16'hF800;  
        end
        
        
        else pixel_data <= background;
        
        end
    
    endmodule