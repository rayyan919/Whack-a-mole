module moles_screen (
    input wire clk,
    input wire key_esc,
    input left_button,  // button left
    input top_button,  // button top
    input right_button,  // button right
    input bottom_button,  // button bottom
    input mid_button,  // button middle
    input enable,
    input key_space,
    output [6:0] score_MSB, score_LSB,
    output wire hsync,
    output wire vsync,
    output wire [3:0] red,    // Assuming 4-bit color depth
    output wire [3:0] green,
    output wire [3:0] blue,
    output wire win,
    output wire lose
);
    
    wire [2:0] mole_current_state;  // 3-bit state output from mole_STATE MODULE
    wire [3:0] score;              // 4-bit score wire
    wire slow_clk;
 
   
    ClockDivider clk_div(
        .clk(clk),          // Fast clock from FPGA
        .reset(1'b0),       // No reset
        .slow_clk(slow_clk) // Slower clock output
    );
      
    // Instantiate the main_mole_module
    mole_state ms (
        .clk(slow_clk),                  
        .mole_current_state(mole_current_state) 
    );
    
     ScoreClockDivider clk_div2(
        .clk(clk),          // Fast clock from FPGA
        .reset(1'b0),       // No reset
        .slow_clk(slowclk) // Slower clock output
    );
      
    
    wire F5, F15;
    // Instantiate the score_correctwhack module
    score_correctwhack scw (
        .clk(slowclk),  
        .key_esc(key_esc),
        .key_space(key_space),                 
        .mole_pos(mole_current_state), 
        .A(left_button), 
        .W(top_button),
        .X(bottom_button), 
        .D(right_button), 
        .S(mid_button),
        .score(score),    
        .F15(F15),
        .F5(F5)
    );
    
    wire timer_done;
    // Instantiate the combined_display module
    combined_display combinedt (
        .clk(clk),          
        .rst(key_esc),              
        .oval_select(mole_current_state), 
        .enable(1'b1),          // Enable set to 1 for now
        .score(score),          
        .pause(key_space), 
        .timer_done_signal(timer_done),    
        .score_MSB(score_MSB),
        .score_LSB(score_LSB),     
        .hsync(hsync),          
        .vsync(vsync),          
        .red(red),              
        .green(green),          
        .blue(blue)             
    );
    
    assign win = (F15&~timer_done)|(~F5&timer_done);
    assign lose = (F5 & timer_done);

endmodule
