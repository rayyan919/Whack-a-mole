

module game_flow (
    input wire clk,
    input wire PS2_CLK,    // PS2 Keyboard clock
    input wire PS2_DATA,   // PS2 Keyboard data
    output wire hsync,
    output wire vsync,
    output wire [3:0] red,
    output wire [3:0] green,
    output wire [3:0] blue
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

    wire [1:0]S;
    wire TA, TB;
    wire win,lose;
  
    // Screen State transitions using using FSM using T-FlipFlops
    assign TA = (~S[1] & ~S[0] & key_space) | (~S[1] & S[0] & key_esc) | (S[1] & S[0] & ~win & lose);
    assign TB = (~S[1] & ~S[0] & key_space) | (S[1] & ~S[0] & key_esc)  |  (S[1] & ~key_space & key_esc & lose) | (S[1] & S[0] & ~key_esc & win) | (S[1]&key_space&key_esc&win&~lose);

    // T Flip-Flops
    T_FlipFlop ff1 (TA, clk, 1'b0, S[1]);
    T_FlipFlop ff2 (TB, clk, 1'b0, S[0]);

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
    
   // wire [6:0] score_MSB, score_LSB;
    moles_screen scr2(
        .clk(clk),
        .key_esc(key_esc),
        .left_button(key_A),      // Using keyboard A
        .top_button(key_W),      // Using keyboard W
        .right_button(key_D),      // Using keyboard D
        .bottom_button(key_X),      // Using keyboard X
        .mid_button(key_S),      // Using keyboard S
        .enable(1'b1),
        .key_space(key_space),
//        .score_MSB(score_MSB),
//        .score_LSB(score_LSB),
        .hsync(hsync_screen2),
        .vsync(vsync_screen2),
        .red(red_screen2),
        .green(green_screen2),
        .blue(blue_screen2),
        .win(win),
        .lose(lose)  
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
//        .score_MSB(score_MSB),
//        .score_LSB(score_LSB),
        .hsync(hsync_screen4),
        .vsync(vsync_screen4),
        .red(red_screen4),
        .green(green_screen4),
        .blue(blue_screen4)
    );

    // Output multiplexing logic
    assign hsync = (S == 2'b00) ? hsync_screen1 :
                   (S == 2'b11) ? hsync_screen2 :
                   (S == 2'b01) ? hsync_screen3 :
                                  hsync_screen4 ;

    assign vsync = (S == 2'b00) ? vsync_screen1 :
                   (S == 2'b11) ? vsync_screen2 :
                   (S == 2'b01) ? vsync_screen3 :
                                  vsync_screen4;

    assign red  = (S == 2'b00) ? red_screen1 :
                  (S == 2'b11) ? red_screen2 :
                  (S == 2'b01) ? red_screen3 :
                                 red_screen4;

    assign green = (S == 2'b00) ? green_screen1 :
                   (S == 2'b11) ? green_screen2 :
                   (S == 2'b01) ? green_screen3 :
                                  green_screen4 ;

    assign blue  = (S == 2'b00) ? blue_screen1 :
                   (S == 2'b11) ? blue_screen2 :
                   (S == 2'b01) ? blue_screen3 :
                                  blue_screen4;

endmodule