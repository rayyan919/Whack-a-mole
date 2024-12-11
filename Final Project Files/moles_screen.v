module moles_screen (
    input wire clk,
    input  G,
    input wire key_esc,
    input left_button,  // button left
    input top_button,  // button top
    input right_button,  // button right
    input bottom_button,  // button bottom
    input mid_button,  // button middle
    input enable,
    input key_space,
    output timer_done_signal,
    output wire hsync,
    output wire vsync,
    output wire [3:0] red,    // Assuming 4-bit color depth
    output wire [3:0] green,
    output wire [3:0] blue,
    output game_lose,
    output led
);

    wire [2:0] mole_current_state;  // 3-bit state output from mole_STATE MODULE
    wire [3:0] score;              // 4-bit score wire
    wire slow_clk;
   // wire slowclk;

//    wire  pause_state;
//    wire T;
    
//    assign T = (~pause_state&key_space )| (pause_state&key_space);
//    T_FlipFlop ff3 (T, clk, key_esc, pause_state);
     reg g;
     initial g=1'b1;
     reg [1:0]count;
     always @(posedge clk) begin
     //  count <= count+ 2'b01;
     if (G) begin 
       if (count < 2'b11) begin // Max score of 15
                count <= count + 1;  // Increment score
        end else begin
             g<=0;
             count <= 2'b00;
        end

      
    end
    end
      assign led = g;

   
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
      

    // Instantiate the score_correctwhack module
    score_correctwhack scw (
        .clk(slowclk),  
//        .G(G),
//        .fpause(fpause),
        .key_esc(key_esc),
        .key_space(key_space),                 
        .mole_pos(mole_current_state), 
        .A(left_button), 
        .W(top_button),
        .X(bottom_button), 
        .D(right_button), 
        .S(mid_button),
        .score(score),    
        .game_lose(game_lose)
//        .led(led)
    );

    // Instantiate the combined_display module
    combined_display combinedt (
        .clk(clk),
        .G(g),              
        .rst(key_esc),              
        .oval_select(mole_current_state), 
        .enable(1'b1),          // Enable set to 1 for now
        .score(score),          
        .pause(key_space), 
        .timer_done_signal(timer_done_signal),         
        .hsync(hsync),          
        .vsync(vsync),          
        .red(red),              
        .green(green),          
        .blue(blue)             
    );

endmodule
