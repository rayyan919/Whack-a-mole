module score_correctwhack(
    input wire clk,
    input wire key_esc,         // Reset signal
    input wire key_space,       // Pause signal
    input [2:0] mole_pos,   // 3-bit mole position
    input wire A,           // Button signals
    input wire W,
    input wire X,
    input wire D,
    input wire S,
    output reg [3:0] score, // 4-bit score output
    output F15,
    output F5
);

    // Generate `correct_whack` based on mole position and button press
    wire correct_whack = ((~mole_pos[0] & mole_pos[1] & ~mole_pos[2] & A) |
                          (mole_pos[0] & ~mole_pos[1] & ~mole_pos[2] & W) |
                          (~mole_pos[0] & ~mole_pos[1] & mole_pos[2] & D) |
                          (mole_pos[0] & ~mole_pos[1] & mole_pos[2] & X) |
                          (mole_pos[0] & mole_pos[1] & ~mole_pos[2] & S));
                          
   //  Score update logic
    always @(posedge clk) begin
          score <= score + correct_whack;  // Increment score
         if (key_esc) begin
            score <= 4'b0000;  // Reset score
         end            
    end
    
    wire F15, F5;
    assign F15 = score[3] & score[2] & score[1] & score[0]; //score is 15
    assign F5 = ~score[3] & ( ~score[2] | (~score[1]&~score[0])); //SCORE IS LESS THAN 5
    
endmodule
