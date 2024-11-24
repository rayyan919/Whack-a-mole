


module main_game_flow (
    input wire clk,
    input wire rst,
    input wire x, //button to change restart game
    input wire y,  //for now using this button to indicate that timer has become zero
    input wire z,  //using this switch for now to indicate that user has missed 3 moles
    input pushbutton_1,          // Push button inputs
    input pushbutton_2,
    input pushbutton_3,
    input pushbutton_4,
    input pushbutton_5,
   // input [1:0] select,
    output wire hsync,
    output wire vsync,
    output wire [3:0] red,    // Assuming 8-bit color depth
    output wire [3:0] green,
    output wire [3:0] blue
   // output [6:0] seg_display    // Seven-segment display output
);
      // wire [1:0]state;
    wire A,B, notA, notB;
    wire [1:0]state;
    wire DA,DB;
    
    
   assign  DA = (x&~B)|| (~y&~z&A&B);
   assign  DB= (x&~A)||(y&A&B);
   
    
    D_FF d1 (clk, DA, A, notA);
    D_FF d2 (clk, DB, B, notB);
    
    assign state[1]=A;
    assign state[0]=B;
    

    wire hsync_screen1, vsync_screen1;
    wire [3:0] red_screen1, green_screen1, blue_screen1;

    wire hsync_screen2, vsync_screen2;
    wire [3:0] red_screen2, green_screen2, blue_screen2;

    wire hsync_screen3, vsync_screen3;
    wire [3:0] red_screen3, green_screen3, blue_screen3;

    // Instantiate all modules

start_screen scr1 (
    .clk(clk),
    .reset(rst),          // Adjusted signal name from `rst` to `reset`
    .hsync(hsync_screen1),
    .vsync(vsync_screen1),
    .red(red_screen1),
    .green(green_screen1),
    .blue(blue_screen1)
);



moles_screen  scr4(
    .clk(clk),
    .rst(rst),
    .A(pushbutton_1),  //button 1
    .B(pushbutton_2),  //button 2
    .C(pushbutton_3),   //button 3
    .D(pushbutton_4),  //button 4
    .E(pushbutton_5),   //button 5
  
    .hsync(hsync_screen2),
    .vsync(vsync_screen2),
    .red(red_screen2),
    .green(green_screen2),
    .blue(blue_screen2)
   // .seg_display(seg_display)
);



game_over_screen scr3 (
    .clk(clk),
    .reset(rst),          // Adjusted signal name from `rst` to `reset`
    .hsync(hsync_screen3),
    .vsync(vsync_screen3),
    .red(red_screen3),
    .green(green_screen3),
    .blue(blue_screen3)
);


    // Multiplex the outputs based on the state
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
                                      green_screen3;

    assign blue  = (state == 2'b00) ? blue_screen1 :
                   (state == 2'b01) ? blue_screen2 :
                                      blue_screen3;

endmodule
