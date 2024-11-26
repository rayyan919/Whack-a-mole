


//module main_game_flow (
//    input wire clk,
//    input wire rst,
//    input wire x, //button to change restart game
//    input wire y,  //for now using this button to indicate that timer has become zero
//    input wire z,  //using this switch for now to indicate that user has missed 3 moles
//    input pushbutton_1,          // Push button inputs
//    input pushbutton_2,
//    input pushbutton_3,
//    input pushbutton_4,
//    input pushbutton_5,
//   // input [1:0] select,
//    output wire hsync,
//    output wire vsync,
//    output wire [3:0] red,    // Assuming 8-bit color depth
//    output wire [3:0] green,
//    output wire [3:0] blue
//   // output [6:0] seg_display    // Seven-segment display output
//);
//      // wire [1:0]state;
//    wire A,B, notA, notB;
//    wire [1:0]state;
//    wire DA,DB;
    
    
//   assign  DA = (x&~B)|| (~y&~z&A&B);
//   assign  DB= (x&~A)||(y&A&B);
   
    
//    D_FF d1 (clk, DA, A, notA);
//    D_FF d2 (clk, DB, B, notB);
    
//    assign state[1]=A;
//    assign state[0]=B;
    

//    wire hsync_screen1, vsync_screen1;
//    wire [3:0] red_screen1, green_screen1, blue_screen1;

//    wire hsync_screen2, vsync_screen2;
//    wire [3:0] red_screen2, green_screen2, blue_screen2;

//    wire hsync_screen3, vsync_screen3;
//    wire [3:0] red_screen3, green_screen3, blue_screen3;

//    // Instantiate all modules

//start_screen scr1 (
//    .clk(clk),
//    .reset(rst),          // Adjusted signal name from `rst` to `reset`
//    .hsync(hsync_screen1),
//    .vsync(vsync_screen1),
//    .red(red_screen1),
//    .green(green_screen1),
//    .blue(blue_screen1)
//);



//moles_screen  scr4(
//    .clk(clk),
//    .rst(rst),
//    .A(pushbutton_1),  //button 1
//    .B(pushbutton_2),  //button 2
//    .C(pushbutton_3),   //button 3
//    .D(pushbutton_4),  //button 4
//    .E(pushbutton_5),   //button 5
  
//    .hsync(hsync_screen2),
//    .vsync(vsync_screen2),
//    .red(red_screen2),
//    .green(green_screen2),
//    .blue(blue_screen2)
//   // .seg_display(seg_display)
//);



//game_over_screen scr3 (
//    .clk(clk),
//    .reset(rst),          // Adjusted signal name from `rst` to `reset`
//    .hsync(hsync_screen3),
//    .vsync(vsync_screen3),
//    .red(red_screen3),
//    .green(green_screen3),
//    .blue(blue_screen3)
//);


//    // Multiplex the outputs based on the state
//    assign hsync = (state == 2'b00) ? hsync_screen1 :
//                   (state == 2'b01) ? hsync_screen2 :
//                                      hsync_screen3;

//    assign vsync = (state == 2'b00) ? vsync_screen1 :
//                   (state == 2'b01) ? vsync_screen2 :
//                                      vsync_screen3;

//    assign red   = (state == 2'b00) ? red_screen1 :
//                   (state == 2'b01) ? red_screen2 :
//                                      red_screen3;

//    assign green = (state == 2'b00) ? green_screen1 :
//                   (state == 2'b01) ? green_screen2 :
//                                      green_screen3;

//    assign blue  = (state == 2'b00) ? blue_screen1 :
//                   (state == 2'b01) ? blue_screen2 :
//                                      blue_screen3;

//endmodule
module main_game_flow (
    input wire clk,
    input wire rst,
    input wire x, //button to change restart game
    input wire y,  //for now using this button to indicate that timer has become zero
    input wire z,  //using this switch for now to indicate that user has missed 3 moles
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
        .E(key_S),          // S key maps to E
        .D(key_X),          // X key maps to D
        .spacebar(key_space),
        .esc(key_esc)
    );

    wire A, B;
    wire [1:0] state;
    wire TA, TB;
    reg S;
    wire [2:0] active;
    reg [3:0] score;
    reg [3:0] loss;
    reg [4:0] timer;

//    // Random hole generator (where mole appears)
    random_hole_gen holeState(
        .clk(clk), 
        .reset(rst), 
        .hole(active)
    );

//    // Modify the combinational logic to use keyboard inputs
//    always @(*) begin
//        S = (~active[0] & ~active[1] & active[2] & key_A) |
//            (~active[0] & active[1] & ~active[2] & key_W) |
//            (~active[0] & active[1] & active[2] & key_D) |
//            (active[0] & ~active[1] & ~active[2] & key_X) |
//            (active[0] & ~active[1] & active[2] & key_S);
//    end
    
    // Score and loss updates (assuming this is part of your original code)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            score <= 0;
            loss <= 0;
        end else begin
            score <= score + S;
            loss <= loss + ~S;
        end
    end
    
    // State transitions using keyboard input
    assign TA = (x & ~B) || (~y & ~z & A & B);
    assign TB = (x & ~A) || (y & A & B);
    
    // Rest of your original logic remains the same
    T_FlipFlop f1 (TA, clk, rst, A);
    T_FlipFlop f2 (clk, DB, B, notB);
    
    //should A and be initialized too??
    assign state[1] = A;
    assign state[0] = B;
    
    // Your screen module instantiations and output multiplexing remain the same
    wire hsync_screen1, vsync_screen1;
    wire [3:0] red_screen1, green_screen1, blue_screen1;
    wire hsync_screen2, vsync_screen2;
    wire [3:0] red_screen2, green_screen2, blue_screen2;
    wire hsync_screen3, vsync_screen3;
    wire [3:0] red_screen3, green_screen3, blue_screen3;

    // Screen module instantiations (using keyboard inputs)
    start_screen scr1 (
        .clk(clk),
        .reset(rst),
        .hsync(hsync_screen1),
        .vsync(vsync_screen1),
        .red(red_screen1),
        .green(green_screen1),
        .blue(blue_screen1)
    );

    combined_display scr4(
        .clk(clk),
        .rst(rst),
 
        .hsync(hsync_screen2),
        .vsync(vsync_screen2),
        .red(red_screen2),
        .green(green_screen2),
        .blue(blue_screen2)
    );

    game_over_screen scr3 (
        .clk(clk),
        .reset(rst),
        .hsync(hsync_screen3),
        .vsync(vsync_screen3),
        .red(red_screen3),
        .green(green_screen3),
        .blue(blue_screen3)
    );

    // Output multiplexing logic
    assign hsync = (state == 2'b00) ? hsync_screen1 :
                  (state == 2'b01) ? hsync_screen2 :
                                    hsync_screen3;
    assign vsync = (state == 2'b00) ? vsync_screen1 :
                  (state == 2'b01) ? vsync_screen2 :
                                    vsync_screen3;
    assign red   = (state == 2'b00) ? red_screen1 :
                  (state == 2'b01) ? red_screen2 :
                                    red_screen3;
    assign green = (state == 2'b00) ? green_screen1 :
                  (state == 2'b01) ? green_screen2 :
                                    green_screen2;
    assign blue  = (state == 2'b00) ? blue_screen1 :
                  (state == 2'b01) ? blue_screen2 :
                                    blue_screen3;

endmodule