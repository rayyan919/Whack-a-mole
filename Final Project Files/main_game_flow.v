
module game_flow (
    input wire clk,
//    input fpause,
//    input wire y,  
    input wire PS2_CLK,    // PS2 Keyboard clock
    input wire PS2_DATA,   // PS2 Keyboard data
    output wire hsync,
    output wire vsync,
    output wire [3:0] red,
    output wire [3:0] green,
    output wire [3:0] blue,
    output led
);
    // Keyboard interface signals
    wire key_A, key_W, key_D, key_S, key_X, key_space, key_esc;
	
    // Instantiate the keyboard module
    keyboard kb(
        .CLK(clk),
        .PS2_CLK(PS2_CLK),
        .PS2_DATA(PS2_DATA),
        .A(key_A),          // A key                           
        .B(key_W),          // W key maps to B
        .C(key_D),          // D key maps to C
        .D(key_X),          // X key maps to D
        .E(key_S),          // S key maps to E
        .spacebar(key_space),
        .esc(key_esc)
    );

    wire [1:0] state;
    wire TA, TB;
    

    //TIMER 0 is y , missed 3 is z
    // State transitions using keyboard input
    assign TA = (state[1] & key_esc) | (~state[1] & ~state[0] & key_space) | (state[1] & state[0] & ~key_space & ~timer_done & z);
    assign TB = (state[0] & key_esc) | (~state[1] & ~state[0] & key_space) | (state[1] & state[0] & ~key_space & timer_done);

    // T Flip-Flops
    T_FlipFlop ff1 (TA, clk, key_esc, state[1]);
    T_FlipFlop ff2 (TB, clk, key_esc, state[0]);

    // Screen module instantiations (using keyboard inputs)
    wire hsync_screen1, vsync_screen1;
    wire [3:0] red_screen1, green_screen1, blue_screen1;
    wire hsync_screen2, vsync_screen2;
    wire [3:0] red_screen2, green_screen2, blue_screen2;
    wire hsync_screen3, vsync_screen3;
    wire [3:0] red_screen3, green_screen3, blue_screen3;
    wire hsync_screen4, vsync_screen4;
    wire [3:0] red_screen4, green_screen4, blue_screen4;

    // Screen module instantiations (using keyboard inputs)
    start_screen scr1 (
        .clk(clk),
        .reset(key_esc),
        .hsync(hsync_screen1),
        .vsync(vsync_screen1),
        .red(red_screen1),
        .green(green_screen1),
        .blue(blue_screen1)
    );

    //FSM for game start logic 
    wire G;
    wire TG;
    assign TG = (state[0] | G);
    T_FlipFlop ff6 (TG, clk, key_esc, G);
    
  

    
    moles_screen scr2(
        .clk(clk),
        .G(G),
//        .fpause(fpause),
        .key_esc(key_esc),
        .left_button(key_A),      // Using keyboard A
        .top_button(key_W),      // Using keyboard W
        .right_button(key_D),      // Using keyboard D
        .bottom_button(key_X),      // Using keyboard X
        .mid_button(key_S),      // Using keyboard S
        .enable(1'b1),
        .key_space(key_space),
        .timer_done_signal(timer_done),
        .hsync(hsync_screen2),
        .vsync(vsync_screen2),
        .red(red_screen2),
        .green(green_screen2),
        .blue(blue_screen2),
        .game_lose(z), 
        .led(led)       
    );
    
    

    game_over_screen scr3 (
        .clk(clk),
        .reset(key_esc),
        .hsync(hsync_screen3),
        .vsync(vsync_screen3),
        .red(red_screen3),
        .green(green_screen3),
        .blue(blue_screen3)
    );
    
    win_screen scr4 (
        .clk(clk),
        .reset(key_esc),
        .hsync(hsync_screen4),
        .vsync(vsync_screen4),
        .red(red_screen4),
        .green(green_screen4),
        .blue(blue_screen4)
    );

    // Output multiplexing logic
    assign hsync = (state == 2'b00) ? hsync_screen1 :
                  (state == 2'b11) ? hsync_screen2 :
                  (state == 2'b01) ? hsync_screen3 :
                                     hsync_screen4;

    assign vsync = (state == 2'b00) ? vsync_screen1 :
                  (state == 2'b11) ? vsync_screen2 :
                  (state == 2'b01) ? vsync_screen3 :
                                     vsync_screen4;

    assign red   = (state == 2'b00) ? red_screen1 :
                  (state == 2'b11) ? red_screen2 :
                  (state == 2'b01) ? red_screen3 :
                                     red_screen4;

    assign green = (state == 2'b00) ? green_screen1 :
                  (state == 2'b11) ? green_screen2 :
                  (state == 2'b01) ? green_screen3 :
                                     green_screen4;

    assign blue  = (state == 2'b00) ? blue_screen1 :
                  (state == 2'b11) ? blue_screen2 :
                  (state == 2'b01) ? blue_screen3 :
                                     blue_screen4;

endmodule
