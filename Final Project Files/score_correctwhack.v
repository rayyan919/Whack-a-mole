//module score_correctwhack(
//    input wire clk,
//    input wire key_esc,         // Reset signal
//    input wire key_space,       // Pause signal
//    input [2:0] mole_pos,   // 3-bit mole position
//    input wire A,           // Button signals
//    input wire W,
//    input wire X,
//    input wire D,
//    input wire S,
//    output reg [3:0] score, // 4-bit score output
//    output F15,
//    output F5
//);

//    // Generate `correct_whack` based on mole position and button press
//    //correct_whack
//    wire cw = ((~mole_pos[0] & mole_pos[1] & ~mole_pos[2] & A) |
//                          (mole_pos[0] & ~mole_pos[1] & ~mole_pos[2] & W) |
//                          (~mole_pos[0] & ~mole_pos[1] & mole_pos[2] & D) |
//                          (mole_pos[0] & ~mole_pos[1] & mole_pos[2] & X) |
//                          (mole_pos[0] & mole_pos[1] & ~mole_pos[2] & S));
                          
//   //  Score update logic
//    always @(posedge clk) begin
////          //score <= score + correct_whack;  // Increment score
////            score[3]<= cw & ~score[3] & S[2] & S[1] &S[0] ;
////     score [2]<= cw & S[1] & S[0] & (~S[3] | ~S[2]);
//         if (key_esc) begin
//            score <= 4'b0000;  // Reset score
//         end            
//    end
//   //  wire [1:0]S;
//    wire TS0, TS1, TS2, TS3;
//    wire win,lose;
  
////    // Screen State transitions using using FSM using T-FlipFlops
////    assign TA = (~S[1] & ~S[0] & key_space) | (~S[1] & S[0] & key_esc) | (S[1] & S[0] & ~win & lose);
////    assign TB = (~S[1] & ~S[0] & key_space) | (S[1] & ~S[0] & key_esc)  |  (S[1] & ~key_space & key_esc & lose) | (S[1] & S[0] & ~key_esc & win) | (S[1]&key_space&key_esc&win&~lose);

////    
    
//    assign TS3= cw & ~score[3] & score[2] & score[1] & score[0] ;
//    assign TS2= cw & score[1] & score[0] & (~score[3] | ~score[2]) ;
//    assign TS1 = cw & score[0] & (~score[3] | ~score[2] | ~score[1]);
//    assign TS0 = cw & ( ~score[3] | ~score[2] | ~ score[1]);
    
//       T_FlipFlop ff11 (TS1, clk, 1'b0, score[1]);
//       T_FlipFlop ff12 (TS0, clk, 1'b0, score[0]);
//       T_FlipFlop ff13 (TS2, clk, 1'b0, score[2]);
//       T_FlipFlop ff14 (TS3, clk, 1'b0, score[3]);
    
//    //assign score[3]= key_esc | 
//   // wire F15, F5;
//    assign F15 = score[3] & score[2] & score[1] & score[0]; //score is 15
//    assign F5 = ~score[3] & ( ~score[2] | (~score[1]&~score[0])); //SCORE IS LESS THAN 5
    
//endmodule

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
    output [3:0] score, // 4-bit score output
    output F15,
    output F5,
    output wire cw
);
    // Generate `correct_whack` based on mole position and button press
    assign cw = ((~mole_pos[0] & mole_pos[1] & ~mole_pos[2] & A) |
               (mole_pos[0] & ~mole_pos[1] & ~mole_pos[2] & W) |
               (~mole_pos[0] & ~mole_pos[1] & mole_pos[2] & D) |
               (mole_pos[0] & ~mole_pos[1] & mole_pos[2] & X) |
               (mole_pos[0] & mole_pos[1] & ~mole_pos[2] & S));
                          
    // Intermediate wires for T-Flip Flop inputs
    wire TS0, TS1, TS2, TS3;
   
    // T-Flip Flop trigger conditions
    assign TS3 = (key_esc & score[3]) | (cw&~key_esc&~score[3]&score[2]&score[1]&score[0]);
    assign TS2 = (key_esc&score[2]) | (cw&~key_esc&score[1]&score[0]&(~score[3]|~score[2]));
    assign TS1 = (key_esc&score[1]) | (cw&~key_esc&score[0]&(~score[3]|~score[2]|~score[1]));
    assign TS0 = (key_esc&score[0]) | (cw&~key_esc&(~score[2] | ~score[0] | (~score[3]&score[1]) | (score[3]&~score[1])));
    
    // Instantiate T-Flip Flops with intermediate wires
    T_FlipFlop ff0 (TS0, clk, 1'b0, score[0]);
    T_FlipFlop ff1 (TS1, clk, 1'b0, score[1]);
    T_FlipFlop ff2 (TS2, clk, 1'b0, score[2]);
    T_FlipFlop ff3 (TS3, clk, 1'b0, score[3]);
    
    // Flags for score conditions
    assign F15 = score[3] & score[2] & score[1] & score[0]; // score is 15
    assign F5 = ~score[3] & (~score[2] | (~score[1] & ~score[0])); // score is less than 5
    
endmodule