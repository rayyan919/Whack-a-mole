`timescale 1ns / 1ps

module score_count(clk,correct_whack,score1,score2,game_lose);
    input clk;
    input correct_whack;
    
    output reg [3:0] score1;   //first digit
    output reg [3:0] score2;   //second digit
    
    output game_lose;  // if 3 moles are missed // logic not implemented yet.
    //output Cout; 

   // wire [3:0]one;
   // assign one=4'b0001;
    //reg [3:0] temp_sum;
     
     initial begin
        score1 = 4'b0000;
        score2 = 4'b0000;
    end

    always @(posedge clk) begin
        if (correct_whack) begin
            if (score1 == 4'b1001) begin // Max score for score1 is 9
                score1 <= 4'b0000;        // Reset score1
                score2 <= score2 + 4'b0001; // Increment score2
            end else begin
                score1 <= score1 + 4'b0001; // Increment score1
            end
        end
    end            
endmodule
