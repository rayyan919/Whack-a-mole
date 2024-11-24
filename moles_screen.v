`timescale 1ns / 1ps


module moles_screen (
    input wire clk,
    input wire rst,
    input A,  //button 1
    input B,  //button 2
    input C,   //button 3
    input D,  //button 4
    input E,   //button 5
   // input [1:0] select,
   // output [4:0] LEDs ,   // LEDs for states 000, 001, 010, 011, 100
    output wire hsync,
    output wire vsync,
    output wire [3:0] red,    // Assuming 8-bit color depth
    output wire [3:0] green,
    output wire [3:0] blue
   // output [6:0]seg_display    // Seven-segment display output
);

//    wire [2:0] active;
//    reg timer = 5'b11101;
   
//    random_hole_gen holeState(.clk(clk), .reset(rst), .hole(active));
//    wire x = active[0];
//    wire y = active[1];
//    wire z = active[2];
   
//    debounce_better_version top(.clk(clk), .pb_1(A), .pb_out(A));
//    debounce_better_version centre(.clk(clk), .pb_1(B), .pb_out(B));
//    debounce_better_version bottom(.clk(clk), .pb_1(C), .pb_out(C));
//    debounce_better_version right(.clk(clk), .pb_1(D), .pb_out(D));
//    debounce_better_version left(.clk(clk), .pb_1(E), .pb_out(E));
   
    //wire S;
   // assign S = (~x&~y&z&A)|(~x&y&~z&B)|(~x&y&z&C)|(x&~y&~z&D)|(x&~y&z&E); //score increment or not
        wire score1, score2, game_lose;
        wire [4:0] LEDs;
      wire [2:0] mole_current_state; // 3-bit state output from main_mole_module
      wire correct_whack;            // Signal from pushbutton_with_logic in TopModule
      
       // Instantiate the main_mole_module
    mole_state ms (
        .clk(clk),                   // System clock input
        .LEDs(LEDs),                 // LED outputs for states
        .mole_current_state(mole_current_state) // 3-bit mole state output
    );

       // Instantiate the TopModule
    score_correctwhack scw (
        .clk(clk),                   // System clock input
        .mole_pos(mole_current_state), // 3-bit input from main_mole_module
        .pushbutton_1(A), // Push button inputs
        .pushbutton_2(B),
        .pushbutton_3(C),
        .pushbutton_4(D),
        .pushbutton_5(E),
        .score1(score1),             // Selector for multiplexer
        .score2(score2),    // Seven-segment display output
        .game_lose(game_lose)
    );



    // Instantiate all modules
    holes_screen scr2 (
    .clk(clk),
    .reset(rst),          
    .oval_select(mole_current_state),
    .hsync(hsync),
    .vsync(vsync),
    .red(red),
    .green(green),
    .blue(blue)
);




endmodule