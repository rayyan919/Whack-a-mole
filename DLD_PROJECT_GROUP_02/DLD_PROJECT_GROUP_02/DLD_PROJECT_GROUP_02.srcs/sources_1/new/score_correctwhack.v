`timescale 1ns / 1ps

module score_correctwhack(
    input clk,
    input [2:0] mole_pos,      // 3-bit input for pushbutton logic
    input pushbutton_1,          // Push button inputs
    input pushbutton_2,
    input pushbutton_3,
    input pushbutton_4,
    input pushbutton_5,
    // input [1:0] select,          // Selector for Multiplexer to choose between score1 and score2
    // output [6:0] seg_display,     // Seven-segment display output
    output score1, //first digit
    output score2, //second digit
    output game_lose
);


     wire slow_clk;               // Clock divider output
    wire [3:0] score1, score2;   // Scores from the score module
    wire [3:0] selected_score;   // Output from Multiplexer to drive Segment Decoder
    wire correct_whack;          // Signal from pushbutton logic to the score module

//    wire [3:0] C, D;             // Unused multiplexer inputs
//    assign C = 4'b0000; 
//    assign D = 4'b0000;

ClockDivider clk_div(
    .clk(clk),          // Fast clock from FPGA
    .reset(1'b0),       // No reset
    .slow_clk(slow_clk) // Slower clock output
);

    // Pushbutton with Logic Module
    pushbutton_with_logic pb_logic (
        .clk(clk),                // System clock
        .mole_pos(mole_pos),      // current state of mole
        .pushbutton_1(pushbutton_1),  // Push button inputs
        .pushbutton_2(pushbutton_2),
        .pushbutton_3(pushbutton_3),
        .pushbutton_4(pushbutton_4),
        .pushbutton_5(pushbutton_5),
        .output_signal(correct_whack) // Output is 1 if correct_whack
    );


       // Instantiate the Score module
    score_count s(
        .clk(slow_clk),           // Slow clock
        .correct_whack(correct_whack), //correctwhack
        .score1(score1),          // Output score1
        .score2(score2),          // Output score2
        .game_lose(game_lose)     //game_lose=1 if missed 3 moles
    );
    
//    // Instantiate the Multiplexer module
//    Multiplexer mux (
//        score1, 
//        score2, 
//        C,  // Unused for now, default to 0
//        D,  // Unused for now, default to 0
//        select, 
//        selected_score
//    );
    
    
    
    // Instantiate the Segment Decoder module
//    Segment_Decoder decoder (
//        selected_score,
//        seg_display
//    );
    
    
//    // Instantiate the Segment Decoder module
//    Segment_Decoder decoder (
//        .input(selected_score),   // Selected score
//        .output(seg_display)      // Seven-segment display output
//    );

endmodule
