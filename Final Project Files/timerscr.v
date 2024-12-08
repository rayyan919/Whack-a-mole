module combined_display (
    input wire clk,
    input wire rst,
    input wire [2:0] oval_select,
    input wire enable,
    input wire [3:0]score,
    input wire pause,
    output wire hsync, vsync,
    output wire [3:0] red,
    output wire [3:0] green,
    output wire [3:0] blue
);

    // VGA signals
    wire video_on;
    wire [9:0] x, y;
    wire [11:0] rgb;

    wire [3:0] mole_red, mole_green, mole_blue;
    wire mole_hsync, mole_vsync;
    // VGA sync
    vga_sync vga_sync_unit (
        .clk(clk),
        .reset(rst),
        .hsync(hsync),
        .vsync(vsync),
        .video_on(video_on),
        .x(x),
        .y(y)
    );

    mole_display mole_display_unit (
        .clk(clk),
        .reset(rst),
        .oval_select(oval_select),
        .hsync(mole_hsync),
        .vsync(mole_vsync),
        .red(mole_red),
        .green(mole_green),
        .blue(mole_blue)
    );

    // Clock divider
    wire slow_clk;
    ClockDivider cd (
        .clk(clk),
        .reset(1'b0),
        .slow_clk(slow_clk)
    );

    // Counter and Timer
    wire [6:0] counterValue;
    counter counter1(
        .clk(clk),
        .reset(rst),
        .out(counterValue)
    );

    wire [6:0] time_MSB, time_LSB;
    wire timer_done_signal;
    game_timer game_timer_unit (
        .clk(slow_clk),
        .rst(rst),
        .enable(enable),
        .pause(pause),
        .time_MSB_ascii(time_MSB),
        .time_LSB_ascii(time_LSB),
        .timer_done(timer_done_signal)
    );
    
    wire [6:0] score_MSB, score_LSB;
    score_display score_unit(
        .clk(slow_clk),
        .rst(rst),
        .score(score),
        .score_MSB_ascii(score_MSB),
        .score_LSB_ascii(score_LSB)
    );

    // Parameters for colors
    parameter [11:0] BG_COLOR = 12'h000;
    parameter [11:0] UNSELECTED_COLOR = 12'hFFF;
    parameter [11:0] SELECTED_COLOR = 12'h0F0;

    // Parameters for oval positions
    parameter [9:0] OVAL1_X = 320, OVAL1_Y = 120;
    parameter [9:0] OVAL2_X = 220, OVAL2_Y = 220;
    parameter [9:0] OVAL3_X = 320, OVAL3_Y = 220;
    parameter [9:0] OVAL4_X = 420, OVAL4_Y = 220;
    parameter [9:0] OVAL5_X = 320, OVAL5_Y = 320;
    parameter [9:0] X_RADIUS = 40, Y_RADIUS = 20;

    // ASCII array for text
    wire [6:0] a[15:0];
    // Score text (left side)
    assign a[0] = 7'h53;  // 'S'
    assign a[1] = 7'h43;  // 'C'
    assign a[2] = 7'h4F;  // 'O'
    assign a[3] = 7'h52;  // 'R'
    assign a[4] = 7'h45;  // 'E'
    assign a[5] = 7'h20;  // ' '
    assign a[6] = score_MSB;
    assign a[7] = score_LSB;

    // Timer text (right side)
    assign a[8] = 7'h54;  // 'T'
    assign a[9] = 7'h49;  // 'I'
    assign a[10] = 7'h4D; // 'M'
    assign a[11] = 7'h45; // 'E'
    assign a[12] = 7'h52; // 'R'
    assign a[13] = 7'h20; // ' '
    assign a[14] = time_MSB;
    assign a[15] = time_LSB;

    // Text generation instances
    wire [15:0] d;  // Changed to a single wire vector
    
        // Score text generation (left side)
    textGeneration score0 (.clk(clk), .reset(rst), .ascii_In(a[0]), .x(x), .y(y), .displayContents(d[0]), .x_desired(10'd16), .y_desired(10'd32));
    textGeneration score1 (.clk(clk), .reset(rst), .ascii_In(a[1]), .x(x), .y(y), .displayContents(d[1]), .x_desired(10'd24), .y_desired(10'd32));
    textGeneration score2 (.clk(clk), .reset(rst), .ascii_In(a[2]), .x(x), .y(y), .displayContents(d[2]), .x_desired(10'd32), .y_desired(10'd32));
    textGeneration score3 (.clk(clk), .reset(rst), .ascii_In(a[3]), .x(x), .y(y), .displayContents(d[3]), .x_desired(10'd40), .y_desired(10'd32));
    textGeneration score4 (.clk(clk), .reset(rst), .ascii_In(a[4]), .x(x), .y(y), .displayContents(d[4]), .x_desired(10'd48), .y_desired(10'd32));
    textGeneration score5 (.clk(clk), .reset(rst), .ascii_In(a[5]), .x(x), .y(y), .displayContents(d[5]), .x_desired(10'd56), .y_desired(10'd32));
    textGeneration score6 (.clk(clk), .reset(rst), .ascii_In(a[6]), .x(x), .y(y), .displayContents(d[6]), .x_desired(10'd64), .y_desired(10'd32));
    textGeneration score7 (.clk(clk), .reset(rst), .ascii_In(a[7]), .x(x), .y(y), .displayContents(d[7]), .x_desired(10'd72), .y_desired(10'd32));

    // Timer text generation (right side)
    textGeneration timer0 (.clk(clk), .reset(rst), .ascii_In(a[8]), .x(x), .y(y), .displayContents(d[8]), .x_desired(10'd496), .y_desired(10'd32));
    textGeneration timer1 (.clk(clk), .reset(rst), .ascii_In(a[9]), .x(x), .y(y), .displayContents(d[9]), .x_desired(10'd504), .y_desired(10'd32));
    textGeneration timer2 (.clk(clk), .reset(rst), .ascii_In(a[10]), .x(x), .y(y), .displayContents(d[10]), .x_desired(10'd512), .y_desired(10'd32));
    textGeneration timer3 (.clk(clk), .reset(rst), .ascii_In(a[11]), .x(x), .y(y), .displayContents(d[11]), .x_desired(10'd520), .y_desired(10'd32));
    textGeneration timer4 (.clk(clk), .reset(rst), .ascii_In(a[12]), .x(x), .y(y), .displayContents(d[12]), .x_desired(10'd528), .y_desired(10'd32));
    textGeneration timer5 (.clk(clk), .reset(rst), .ascii_In(a[13]), .x(x), .y(y), .displayContents(d[13]), .x_desired(10'd536), .y_desired(10'd32));
    textGeneration timer6 (.clk(clk), .reset(rst), .ascii_In(a[14]), .x(x), .y(y), .displayContents(d[14]), .x_desired(10'd544), .y_desired(10'd32));
    textGeneration timer7 (.clk(clk), .reset(rst), .ascii_In(a[15]), .x(x), .y(y), .displayContents(d[15]), .x_desired(10'd552), .y_desired(10'd32));

    // Text display logic
    wire displayContents;
    assign displayContents = |d;

    wire [6:0] ascii;
    assign ascii = d[0] ? a[0] : d[1] ? a[1] : d[2] ? a[2] : d[3] ? a[3] :
                  d[4] ? a[4] : d[5] ? a[5] : d[6] ? a[6] : d[7] ? a[7] :
                  d[8] ? a[8] : d[9] ? a[9] : d[10] ? a[10] : d[11] ? a[11] :
                  d[12] ? a[12] : d[13] ? a[13] : d[14] ? a[14] : d[15] ? a[15] : 7'h20;

    // ASCII ROM connections
    wire [10:0] rom_addr;
    wire [3:0] rom_row;
    wire [2:0] rom_col;
    wire [7:0] rom_data;
    wire rom_bit;
    
    ascii_rom rom1(
        .clk(clk),
        .rom_addr(rom_addr),
        .data(rom_data)
    );

    assign rom_row = y[3:0];
    assign rom_addr = {ascii, rom_row};
    assign rom_col = x[2:0];
    assign rom_bit = rom_data[~rom_col];

    // Oval helper function
    function is_in_oval;
        input [9:0] px, py, cx, cy;
        input [9:0] x_rad, y_rad;
        begin
            is_in_oval = (((px - cx) * (px - cx)) / (x_rad * x_rad) +
                         ((py - cy) * (py - cy)) / (y_rad * y_rad)) <= 1;
        end
    endfunction

    // Pixel color determination
    reg [11:0] pixel_color;
    always @(*) begin
        if (video_on) begin
            if (rom_bit && displayContents)
                pixel_color = 12'hFFF;  // Text color
            else begin
                // Default to background
                pixel_color = BG_COLOR;
                // Check ovals
                if (is_in_oval(x, y, OVAL1_X, OVAL1_Y, X_RADIUS, Y_RADIUS))
                    pixel_color = (oval_select == 3'd1) ? SELECTED_COLOR : UNSELECTED_COLOR;
                else if (is_in_oval(x, y, OVAL2_X, OVAL2_Y, X_RADIUS, Y_RADIUS))
                    pixel_color = (oval_select == 3'd2) ? SELECTED_COLOR : UNSELECTED_COLOR;
                else if (is_in_oval(x, y, OVAL3_X, OVAL3_Y, X_RADIUS, Y_RADIUS))
                    pixel_color = (oval_select == 3'd3) ? SELECTED_COLOR : UNSELECTED_COLOR;
                else if (is_in_oval(x, y, OVAL4_X, OVAL4_Y, X_RADIUS, Y_RADIUS))
                    pixel_color = (oval_select == 3'd4) ? SELECTED_COLOR : UNSELECTED_COLOR;
                else if (is_in_oval(x, y, OVAL5_X, OVAL5_Y, X_RADIUS, Y_RADIUS))
                    pixel_color = (oval_select == 3'd5) ? SELECTED_COLOR : UNSELECTED_COLOR;
            end
        end
        else
            pixel_color = 12'h000;
    end

    // Output color blending (to incorporate mole)
    wire [3:0] final_red, final_green, final_blue;
    assign final_red = (mole_red != 4'h0) ? mole_red : red;
    assign final_green = (mole_green != 4'h0) ? mole_green : green;
    assign final_blue = (mole_blue != 4'h0) ? mole_blue : blue;

    // Output assignment
    assign red = final_red;
    assign green = final_green;
    assign blue = final_blue;
    
    // Output assignment
    assign red = pixel_color[11:8];
    assign green = pixel_color[7:4];
    assign blue = pixel_color[3:0];

endmodule


module vga_sync
      (
            input wire clk, reset, //We need a 25MHz clock, and resettable through button press
            output wire hsync, vsync, video_on,//We signal whether hsync, vsync, and video should be on
            //Hsync and vsync should be on at all times but within the retrace period
            //Video on only within the 640x480 pixel display zone
            output wire [9:0] x, y //Multi-bit wire data for pixel position(x,y)
      );
      
      // constant declarations for VGA sync parameters
      localparam H_DISPLAY       = 640; // horizontal display area
      localparam H_L_BORDER      =  48; // horizontal left border //same as back porch
      localparam H_R_BORDER      =  16; // horizontal right border //same as front porch
      localparam H_RETRACE       =  96; // horizontal retrace
      localparam H_MAX           = H_DISPLAY + H_L_BORDER + H_R_BORDER + H_RETRACE - 1; //799
      localparam START_H_RETRACE = H_DISPLAY + H_R_BORDER; //640+16 = 656
      localparam END_H_RETRACE   = H_DISPLAY + H_R_BORDER + H_RETRACE - 1; //640+16+96-1 = 751
      
      localparam V_DISPLAY       = 480; // vertical display area
      localparam V_T_BORDER      =  10; // vertical top border
      localparam V_B_BORDER      =  33; // vertical bottom border
      localparam V_RETRACE       =   2; // vertical retrace
      localparam V_MAX           = V_DISPLAY + V_T_BORDER + V_B_BORDER + V_RETRACE - 1; //524
    localparam START_V_RETRACE = V_DISPLAY + V_B_BORDER; //480+33 = 513
      localparam END_V_RETRACE   = V_DISPLAY + V_B_BORDER + V_RETRACE - 1; //514
      
      // mod-4 counter to generate 25 MHz pixel tick
      reg [1:0] pixel_reg; //Current-State
      wire [1:0] pixel_next; //Nextstate
      wire pixel_tick; //Increment signal
      
      always @(posedge clk, posedge reset) //Uses internal clock
            if(reset)
              pixel_reg <= 0; //Reset signal
            else
              pixel_reg <= pixel_next; //Get the nextstate
      
      assign pixel_next = pixel_reg + 1; // increment pixel_reg
      
      assign pixel_tick = (pixel_reg == 0); //When pixel_reg becomes 2'b11 it will roll over to 0 on next pos clock edge
      
      // registers to keep track of current pixel location
      reg [9:0] h_count_reg, h_count_next, v_count_reg, v_count_next;
      
      // register to keep track of vsync and hsync signal states
      reg vsync_reg, hsync_reg;
      wire vsync_next, hsync_next;
 
      // infer registers
      always @(posedge clk, posedge reset)
            if(reset)
                begin //Default state
                    v_count_reg <= 0;
                    h_count_reg <= 0;
                    vsync_reg   <= 0;
                    hsync_reg   <= 0;
                end
            else
                begin //Next state
                    v_count_reg <= v_count_next;
                    h_count_reg <= h_count_next;
                    vsync_reg   <= vsync_next;
                    hsync_reg   <= hsync_next;
                end
                  
      // next-state logic of horizontal vertical sync counters
      always @* //combinational
            begin
            h_count_next = pixel_tick ? //Check if pixel_tick is true then check if h_count_reg is at the max and needs to roll-over  to 0
                           (h_count_reg == H_MAX ? 0 : h_count_reg + 1)
                         : h_count_reg;
            
            v_count_next = pixel_tick && h_count_reg == H_MAX ? //If we are at bottom of screen we retrace back to top
                           (v_count_reg == V_MAX ? 0 : v_count_reg + 1)
                         : v_count_reg;
            end
            
        // hsync and vsync are active low signals
        // hsync signal asserted during horizontal retrace
        assign hsync_next = h_count_reg >= START_H_RETRACE
                            && h_count_reg <= END_H_RETRACE;
   
        // vsync signal asserted during vertical retrace
        assign vsync_next = v_count_reg >= START_V_RETRACE
                            && v_count_reg <= END_V_RETRACE;

        // video only on when pixels are in both horizontal and vertical display region
        assign video_on = (h_count_reg < H_DISPLAY)
                          && (v_count_reg < V_DISPLAY);

        // output signals
        assign hsync  = hsync_reg;
        assign vsync  = vsync_reg;
        assign x      = h_count_reg;
        assign y      = v_count_reg;
endmodule

module counter(input clk, reset, output [6:0] out);
     //1 Hz frequency counter
    /////////////////////////////////////////////////////////////
   
    reg [26:0] counter;
    wire [26:0] counter_NS;
    reg [6:0] ascii;
    wire [6:0] ascii_NS;
    wire nextOp;
   
    //CS
    always @ (posedge clk, posedge reset)
          if(reset)
          begin
              counter<=0;
              ascii <= 7'h30;
          end
          else
          begin
              counter <= counter_NS;
              ascii <= ascii_NS;
          end
    //NS
    assign counter_NS = (counter < 99999999) ? counter + 1 : 0; //1Hz
    assign nextOp = (counter == 0);
    assign ascii_NS = nextOp ? ascii < 7'h39 ? ascii + 7'h1 : 7'h30 : ascii;
    assign out = ascii;
endmodule


module textGeneration(
    input clk,
    input reset,
    input [6:0] ascii_In,           // ASCII code input (hexadecimal format)
    input [9:0] x_desired, y_desired, // Desired character's top-left position
    input [9:0] x, y,                // Current pixel position
    output displayContents           // Indicates whether to display character content
);
    wire horizontalOn, verticalOn;

    // Assert horizontalOn for 7 more pixels from x_desired
    assign horizontalOn = (x >= x_desired && x < x_desired + 10'd8) ? 1 : 0;
    // Assert verticalOn for 15 more pixels from y_desired
    assign verticalOn = (y >= y_desired && y < y_desired + 10'd16) ? 1 : 0;

    // Determine whether the pixel is within the character display area
    assign displayContents = horizontalOn && verticalOn;

endmodule

module ascii_rom(clk, rom_addr, data);
        input clk;
        input wire [10:0] rom_addr;
        output reg [7:0] data;
        reg [10:0] rom_addr_next;
        //Since there is going to be a lot of data stored here
        //Infer a block ram
        (* rom_style = "block" *)
       
        //Buffer  of rom_addr coming in from vga_test
        always @ (posedge clk)
            rom_addr_next <= rom_addr;
       
        //Topmost 7 bits of rom_addr is the ascii value, bottom 4 bits is counting the 16 rows
        always @*
        case(rom_addr_next)
            // code x20 (space)
                  11'h200: data = 8'b00000000;  //
                  11'h201: data = 8'b00000000;  //
                  11'h202: data = 8'b00000000;  //  
                  11'h203: data = 8'b00000000;  //
                  11'h204: data = 8'b00000000;  //
                  11'h205: data = 8'b00000000;  //
                  11'h206: data = 8'b00000000;  //
                  11'h207: data = 8'b00000000;  //
                  11'h208: data = 8'b00000000;  //    
                  11'h209: data = 8'b00000000;  //    
                  11'h20a: data = 8'b00000000;  //    
                  11'h20b: data = 8'b00000000;  //    
                  11'h20c: data = 8'b00000000;  //
                  11'h20d: data = 8'b00000000;  //
                  11'h20e: data = 8'b00000000;  //
                  11'h20f: data = 8'b00000000;  //
            // code x30 (0)
                  11'h300: data = 8'b00000000;  //
                  11'h301: data = 8'b00000000;  //
                  11'h302: data = 8'b00111000;  //  ***  
                  11'h303: data = 8'b01101100;  // ** **
                  11'h304: data = 8'b11000110;  //**   **
                  11'h305: data = 8'b11000110;  //**   **
                  11'h306: data = 8'b11000110;  //**   **
                  11'h307: data = 8'b11000110;  //**   **
                  11'h308: data = 8'b11000110;  //**   **
                  11'h309: data = 8'b11000110;  //**   **
                  11'h30a: data = 8'b01101100;  // ** **
                  11'h30b: data = 8'b00111000;  //  ***
                  11'h30c: data = 8'b00000000;  //
                  11'h30d: data = 8'b00000000;  //
                  11'h30e: data = 8'b00000000;  //
                  11'h30f: data = 8'b00000000;  //
                  // code x31 (1)
                  11'h310: data = 8'b00000000;  //
                  11'h311: data = 8'b00000000;  //
                  11'h312: data = 8'b00011000;  //   **  
                  11'h313: data = 8'b00111000;  //  ***
                  11'h314: data = 8'b01111000;  // ****
                  11'h315: data = 8'b00011000;  //   **
                  11'h316: data = 8'b00011000;  //   **
                  11'h317: data = 8'b00011000;  //   **
                  11'h318: data = 8'b00011000;  //   **
                  11'h319: data = 8'b00011000;  //   **
                  11'h31a: data = 8'b01111110;  // ******
                  11'h31b: data = 8'b01111110;  // ******
                  11'h31c: data = 8'b00000000;  //
                  11'h31d: data = 8'b00000000;  //
                  11'h31e: data = 8'b00000000;  //
                  11'h31f: data = 8'b00000000;  //
                  // code x32 (2)
                  11'h320: data = 8'b00000000;  //
                  11'h321: data = 8'b00000000;  //
                  11'h322: data = 8'b11111110;  //*******  
                  11'h323: data = 8'b11111110;  //*******
                  11'h324: data = 8'b00000110;  //     **
                  11'h325: data = 8'b00000110;  //     **
                  11'h326: data = 8'b11111110;  //*******
                  11'h327: data = 8'b11111110;  //*******
                  11'h328: data = 8'b11000000;  //**
                  11'h329: data = 8'b11000000;  //**
                  11'h32a: data = 8'b11111110;  //*******
                  11'h32b: data = 8'b11111110;  //*******
                  11'h32c: data = 8'b00000000;  //
                  11'h32d: data = 8'b00000000;  //
                  11'h32e: data = 8'b00000000;  //
                  11'h32f: data = 8'b00000000;  //
                  // code x33 (3)
                  11'h330: data = 8'b00000000;  //
                  11'h331: data = 8'b00000000;  //
                  11'h332: data = 8'b11111110;  //*******  
                  11'h333: data = 8'b11111110;  //*******
                  11'h334: data = 8'b00000110;  //     **
                  11'h335: data = 8'b00000110;  //     **
                  11'h336: data = 8'b00111110;  //  *****
                  11'h337: data = 8'b00111110;  //  *****
                  11'h338: data = 8'b00000110;  //     **
                  11'h339: data = 8'b00000110;  //     **
                  11'h33a: data = 8'b11111110;  //*******
                  11'h33b: data = 8'b11111110;  //*******
                  11'h33c: data = 8'b00000000;  //
                  11'h33d: data = 8'b00000000;  //
                  11'h33e: data = 8'b00000000;  //
                  11'h33f: data = 8'b00000000;  //
                  // code x34 (4)
                  11'h340: data = 8'b00000000;  //
                  11'h341: data = 8'b00000000;  //
                  11'h342: data = 8'b11000110;  //**   **  
                  11'h343: data = 8'b11000110;  //**   **
                  11'h344: data = 8'b11000110;  //**   **
                  11'h345: data = 8'b11000110;  //**   **
                  11'h346: data = 8'b11111110;  //*******
                  11'h347: data = 8'b11111110;  //*******
                  11'h348: data = 8'b00000110;  //     **
                  11'h349: data = 8'b00000110;  //     **
                  11'h34a: data = 8'b00000110;  //     **
                  11'h34b: data = 8'b00000110;  //     **
                  11'h34c: data = 8'b00000000;  //
                  11'h34d: data = 8'b00000000;  //
                  11'h34e: data = 8'b00000000;  //
                  11'h34f: data = 8'b00000000;  //
                  // code x35 (5)
                  11'h350: data = 8'b00000000;  //
                  11'h351: data = 8'b00000000;  //
                  11'h352: data = 8'b11111110;  //*******  
                  11'h353: data = 8'b11111110;  //*******
                  11'h354: data = 8'b11000000;  //**
                  11'h355: data = 8'b11000000;  //**
                  11'h356: data = 8'b11111110;  //*******
                  11'h357: data = 8'b11111110;  //*******
                  11'h358: data = 8'b00000110;  //     **
                  11'h359: data = 8'b00000110;  //     **
                  11'h35a: data = 8'b11111110;  //*******
                  11'h35b: data = 8'b11111110;  //*******
                  11'h35c: data = 8'b00000000;  //
                  11'h35d: data = 8'b00000000;  //
                  11'h35e: data = 8'b00000000;  //
                  11'h35f: data = 8'b00000000;  //
                  // code x36 (6)
                  11'h360: data = 8'b00000000;  //
                  11'h361: data = 8'b00000000;  //
                  11'h362: data = 8'b11111110;  //*******  
                  11'h363: data = 8'b11111110;  //*******
                  11'h364: data = 8'b11000000;  //**
                  11'h365: data = 8'b11000000;  //**
                  11'h366: data = 8'b11111110;  //*******
                  11'h367: data = 8'b11111110;  //*******
                  11'h368: data = 8'b11000110;  //**   **
                  11'h369: data = 8'b11000110;  //**   **
                  11'h36a: data = 8'b11111110;  //*******
                  11'h36b: data = 8'b11111110;  //*******
                  11'h36c: data = 8'b00000000;  //
                  11'h36d: data = 8'b00000000;  //
                  11'h36e: data = 8'b00000000;  //
                  11'h36f: data = 8'b00000000;  //
                  // code x37 (7)
                  11'h370: data = 8'b00000000;  //
                  11'h371: data = 8'b00000000;  //
                  11'h372: data = 8'b11111110;  //*******  
                  11'h373: data = 8'b11111110;  //*******
                  11'h374: data = 8'b00000110;  //     **
                  11'h375: data = 8'b00000110;  //     **
                  11'h376: data = 8'b00000110;  //     **
                  11'h377: data = 8'b00000110;  //     **
                  11'h378: data = 8'b00000110;  //     **
                  11'h379: data = 8'b00000110;  //     **
                  11'h37a: data = 8'b00000110;  //     **
                  11'h37b: data = 8'b00000110;  //     **
                  11'h37c: data = 8'b00000000;  //
                  11'h37d: data = 8'b00000000;  //
                  11'h37e: data = 8'b00000000;  //
                  11'h37f: data = 8'b00000000;  //
                  // code x38 (8)
                  11'h380: data = 8'b00000000;  //
                  11'h381: data = 8'b00000000;  //
                  11'h382: data = 8'b11111110;  //*******  
                  11'h383: data = 8'b11111110;  //*******
                  11'h384: data = 8'b11000110;  //**   **
                  11'h385: data = 8'b11000110;  //**   **
                  11'h386: data = 8'b11111110;  //*******
                  11'h387: data = 8'b11111110;  //*******
                  11'h388: data = 8'b11000110;  //**   **
                  11'h389: data = 8'b11000110;  //**   **
                  11'h38a: data = 8'b11111110;  //*******
                  11'h38b: data = 8'b11111110;  //*******
                  11'h38c: data = 8'b00000000;  //
                  11'h38d: data = 8'b00000000;  //
                  11'h38e: data = 8'b00000000;  //
                  11'h38f: data = 8'b00000000;  //
                  // code x39 (9)
                  11'h390: data = 8'b00000000;  //
                  11'h391: data = 8'b00000000;  //
                  11'h392: data = 8'b11111110;  //*******  
                  11'h393: data = 8'b11111110;  //*******
                  11'h394: data = 8'b11000110;  //**   **
                  11'h395: data = 8'b11000110;  //**   **
                  11'h396: data = 8'b11111110;  //*******
                  11'h397: data = 8'b11111110;  //*******
                  11'h398: data = 8'b00000110;  //     **
                  11'h399: data = 8'b00000110;  //     **
                  11'h39a: data = 8'b11111110;  //*******
                  11'h39b: data = 8'b11111110;  //*******
                  11'h39c: data = 8'b00000000;  //
                  11'h39d: data = 8'b00000000;  //
                  11'h39e: data = 8'b00000000;  //
                  11'h39f: data = 8'b00000000;  //
                  // code x41 (A)
                  11'h410: data = 8'b00000000;  //
                  11'h411: data = 8'b00000000;  //
                  11'h412: data = 8'b00010000;  //   *
                  11'h413: data = 8'b00111000;  //  ***
                  11'h414: data = 8'b01101100;  // ** **  
                  11'h415: data = 8'b11000110;  //**   **  
                  11'h416: data = 8'b11000110;  //**   **
                  11'h417: data = 8'b11111110;  //*******
                  11'h418: data = 8'b11111110;  //*******
                  11'h419: data = 8'b11000110;  //**   **
                  11'h41a: data = 8'b11000110;  //**   **
                  11'h41b: data = 8'b11000110;  //**   **
                  11'h41c: data = 8'b00000000;  //
                  11'h41d: data = 8'b00000000;  //
                  11'h41e: data = 8'b00000000;  //
                  11'h41f: data = 8'b00000000;  //
                  // code x42 (B)
                  11'h420: data = 8'b00000000;  //
                  11'h421: data = 8'b00000000;  //
                  11'h422: data = 8'b11111100;  //******
                  11'h423: data = 8'b11111110;  //*******
                  11'h424: data = 8'b11000110;  //**   **
                  11'h425: data = 8'b11000110;  //**   **  
                  11'h426: data = 8'b11111100;  //******
                  11'h427: data = 8'b11111100;  //******
                  11'h428: data = 8'b11000110;  //**   **
                  11'h429: data = 8'b11000110;  //**   **
                  11'h42a: data = 8'b11111110;  //*******
                  11'h42b: data = 8'b11111100;  //******
                  11'h42c: data = 8'b00000000;  //
                  11'h42d: data = 8'b00000000;  //
                  11'h42e: data = 8'b00000000;  //
                  11'h42f: data = 8'b00000000;  //
                  // code x43 (C)
                  11'h430: data = 8'b00000000;  //
                  11'h431: data = 8'b00000000;  //
                  11'h432: data = 8'b01111100;  // *****
                  11'h433: data = 8'b11111110;  //*******
                  11'h434: data = 8'b11000000;  //**
                  11'h435: data = 8'b11000000;  //**  
                  11'h436: data = 8'b11000000;  //**
                  11'h437: data = 8'b11000000;  //**
                  11'h438: data = 8'b11000000;  //**
                  11'h439: data = 8'b11000000;  //**
                  11'h43a: data = 8'b11111110;  //*******
                  11'h43b: data = 8'b01111100;  // *****
                  11'h43c: data = 8'b00000000;  //
                  11'h43d: data = 8'b00000000;  //
                  11'h43e: data = 8'b00000000;  //
                  11'h43f: data = 8'b00000000;  //
                  // code x44 (D)
                  11'h440: data = 8'b00000000;  //
                  11'h441: data = 8'b00000000;  //
                  11'h442: data = 8'b11111100;  //******
                  11'h443: data = 8'b11111110;  //*******
                  11'h444: data = 8'b11000110;  //**   **
                  11'h445: data = 8'b11000110;  //**   **  
                  11'h446: data = 8'b11000110;  //**   **
                  11'h447: data = 8'b11000110;  //**   **
                  11'h448: data = 8'b11000110;  //**   **
                  11'h449: data = 8'b11000110;  //**   **
                  11'h44a: data = 8'b11111110;  //*******
                  11'h44b: data = 8'b11111100;  //******
                  11'h44c: data = 8'b00000000;  //
                  11'h44d: data = 8'b00000000;  //
                  11'h44e: data = 8'b00000000;  //
                  11'h44f: data = 8'b00000000;  //
                  // code x45 (E)
                  11'h450: data = 8'b00000000;  //
                  11'h451: data = 8'b00000000;  //
                  11'h452: data = 8'b11111110;  //*******
                  11'h453: data = 8'b11111110;  //*******
                  11'h454: data = 8'b11000000;  //**
                  11'h455: data = 8'b11000000;  //**  
                  11'h456: data = 8'b11111100;  //******
                  11'h457: data = 8'b11111100;  //******
                  11'h458: data = 8'b11000000;  //**
                  11'h459: data = 8'b11000000;  //**
                  11'h45a: data = 8'b11111110;  //*******
                  11'h45b: data = 8'b11111110;  //*******
                  11'h45c: data = 8'b00000000;  //
                  11'h45d: data = 8'b00000000;  //
                  11'h45e: data = 8'b00000000;  //
                  11'h45f: data = 8'b00000000;  //
                  // code x46 (F)
                  11'h460: data = 8'b00000000;  //
                  11'h461: data = 8'b00000000;  //
                  11'h462: data = 8'b11111110;  //*******
                  11'h463: data = 8'b11111110;  //*******
                  11'h464: data = 8'b11000000;  //**
                  11'h465: data = 8'b11000000;  //**  
                  11'h466: data = 8'b11111100;  //******
                  11'h467: data = 8'b11111100;  //******
                  11'h468: data = 8'b11000000;  //**
                  11'h469: data = 8'b11000000;  //**
                  11'h46a: data = 8'b11000000;  //**
                  11'h46b: data = 8'b11000000;  //**
                  11'h46c: data = 8'b00000000;  //
                  11'h46d: data = 8'b00000000;  //
                  11'h46e: data = 8'b00000000;  //
                  11'h46f: data = 8'b00000000;  //
                  // code x47 (G)
                  11'h470: data = 8'b00000000;  //
                  11'h471: data = 8'b00000000;  //
                  11'h472: data = 8'b01111100;  // *****
                  11'h473: data = 8'b11111110;  //*******
                  11'h474: data = 8'b11000000;  //**
                  11'h475: data = 8'b11000000;  //**  
                  11'h476: data = 8'b11111110;  //*******
                  11'h477: data = 8'b11111110;  //*******
                  11'h478: data = 8'b11000110;  //**   **
                  11'h479: data = 8'b11000110;  //**   **
                  11'h47a: data = 8'b11111110;  //*******
                  11'h47b: data = 8'b01110110;  // *** **
                  11'h47c: data = 8'b00000000;  //
                  11'h47d: data = 8'b00000000;  //
                  11'h47e: data = 8'b00000000;  //
                  11'h47f: data = 8'b00000000;  //
                  // code x48 (H)
                  11'h480: data = 8'b00000000;  //
                  11'h481: data = 8'b00000000;  //
                  11'h482: data = 8'b11000110;  //**   **
                  11'h483: data = 8'b11000110;  //**   **
                  11'h484: data = 8'b11000110;  //**   **
                  11'h485: data = 8'b11000110;  //**   **
                  11'h486: data = 8'b11111110;  //*******
                  11'h487: data = 8'b11111110;  //*******
                  11'h488: data = 8'b11000110;  //**   **
                  11'h489: data = 8'b11000110;  //**   **
                  11'h48a: data = 8'b11000110;  //**   **
                  11'h48b: data = 8'b11000110;  //**   **
                  11'h48c: data = 8'b00000000;  //
                  11'h48d: data = 8'b00000000;  //
                  11'h48e: data = 8'b00000000;  //
                  11'h48f: data = 8'b00000000;  //
                  // code x49 (I)
                  11'h490: data = 8'b00000000;  //
                  11'h491: data = 8'b00000000;  //
                  11'h492: data = 8'b11111110;  //*******
                  11'h493: data = 8'b11111110;  //*******
                  11'h494: data = 8'b00110000;  //  **
                  11'h495: data = 8'b00110000;  //  **
                  11'h496: data = 8'b00110000;  //  **
                  11'h497: data = 8'b00110000;  //  **
                  11'h498: data = 8'b00110000;  //  **
                  11'h499: data = 8'b00110000;  //  **
                  11'h49a: data = 8'b11111110;  //*******
                  11'h49b: data = 8'b11111110;  //*******
                  11'h49c: data = 8'b00000000;  //
                  11'h49d: data = 8'b00000000;  //
                  11'h49e: data = 8'b00000000;  //
                  11'h49f: data = 8'b00000000;  //
                  // code x4a (J)
                  11'h4a0: data = 8'b00000000;  //
                  11'h4a1: data = 8'b00000000;  //
                  11'h4a2: data = 8'b11111110;  //*******
                  11'h4a3: data = 8'b11111110;  //*******
                  11'h4a4: data = 8'b00011000;  //   **
                  11'h4a5: data = 8'b00011000;  //   **
                  11'h4a6: data = 8'b00011000;  //   **
                  11'h4a7: data = 8'b00011000;  //   **
                  11'h4a8: data = 8'b00011000;  //   **
                  11'h4a9: data = 8'b00011000;  //   **
                  11'h4aa: data = 8'b11111000;  //*****
                  11'h4ab: data = 8'b01111000;  // ****
                  11'h4ac: data = 8'b00000000;  //
                  11'h4ad: data = 8'b00000000;  //
                  11'h4ae: data = 8'b00000000;  //
                  11'h4af: data = 8'b00000000;  //
                  // code x4b (K)
                  11'h4b0: data = 8'b00000000;  //
                  11'h4b1: data = 8'b00000000;  //
                  11'h4b2: data = 8'b11000110;  //**   **
                  11'h4b3: data = 8'b11001100;  //**  **
                  11'h4b4: data = 8'b11011000;  //** **
                  11'h4b5: data = 8'b11110000;  //****
                  11'h4b6: data = 8'b11100000;  //***
                  11'h4b7: data = 8'b11100000;  //***
                  11'h4b8: data = 8'b11110000;  //****
                  11'h4b9: data = 8'b11011000;  //** **
                  11'h4ba: data = 8'b11001100;  //**  **
                  11'h4bb: data = 8'b11000110;  //**   **
                  11'h4bc: data = 8'b00000000;  //
                  11'h4bd: data = 8'b00000000;  //
                  11'h4be: data = 8'b00000000;  //
                  11'h4bf: data = 8'b00000000;  //
                  // code x4c (L)
                  11'h4c0: data = 8'b00000000;  //
                  11'h4c1: data = 8'b00000000;  //
                  11'h4c2: data = 8'b11000000;  //**
                  11'h4c3: data = 8'b11000000;  //**
                  11'h4c4: data = 8'b11000000;  //**
                  11'h4c5: data = 8'b11000000;  //**
                  11'h4c6: data = 8'b11000000;  //**
                  11'h4c7: data = 8'b11000000;  //**
                  11'h4c8: data = 8'b11000000;  //**
                  11'h4c9: data = 8'b11000000;  //**
                  11'h4ca: data = 8'b11111110;  //*******
                  11'h4cb: data = 8'b11111110;  //*******
                  11'h4cc: data = 8'b00000000;  //
                  11'h4cd: data = 8'b00000000;  //
                  11'h4ce: data = 8'b00000000;  //
                  11'h4cf: data = 8'b00000000;  //
                  // code x4d (M)
                  11'h4d0: data = 8'b00000000;  //
                  11'h4d1: data = 8'b00000000;  //
                  11'h4d2: data = 8'b11000110;  //**   **
                  11'h4d3: data = 8'b11000110;  //**   **
                  11'h4d4: data = 8'b11101110;  //*** ***
                  11'h4d5: data = 8'b11111110;  //*******
                  11'h4d6: data = 8'b11010110;  //** * **
                  11'h4d7: data = 8'b11000110;  //**   **
                  11'h4d8: data = 8'b11000110;  //**   **
                  11'h4d9: data = 8'b11000110;  //**   **
                  11'h4da: data = 8'b11000110;  //**   **
                  11'h4db: data = 8'b11000110;  //**   **
                  11'h4dc: data = 8'b00000000;  //
                  11'h4dd: data = 8'b00000000;  //
                  11'h4de: data = 8'b00000000;  //
                  11'h4df: data = 8'b00000000;  //
                  // code x4e (N)
                  11'h4e0: data = 8'b00000000;  //
                  11'h4e1: data = 8'b00000000;  //
                  11'h4e2: data = 8'b11000110;  //**   **
                  11'h4e3: data = 8'b11000110;  //**   **
                  11'h4e4: data = 8'b11100110;  //***  **
                  11'h4e5: data = 8'b11110110;  //**** **
                  11'h4e6: data = 8'b11111110;  //*******
                  11'h4e7: data = 8'b11011110;  //** ****
                  11'h4e8: data = 8'b11001110;  //**  ***
                  11'h4e9: data = 8'b11000110;  //**   **
                  11'h4ea: data = 8'b11000110;  //**   **
                  11'h4eb: data = 8'b11000110;  //**   **
                  11'h4ec: data = 8'b00000000;  //
                  11'h4ed: data = 8'b00000000;  //
                  11'h4ee: data = 8'b00000000;  //
                  11'h4ef: data = 8'b00000000;  //
                  // code x4f (O)
                  11'h4f0: data = 8'b00000000;  //
                  11'h4f1: data = 8'b00000000;  //
                  11'h4f2: data = 8'b01111100;  // *****
                  11'h4f3: data = 8'b11111110;  //*******
                  11'h4f4: data = 8'b11000110;  //**   **
                  11'h4f5: data = 8'b11000110;  //**   **
                  11'h4f6: data = 8'b11000110;  //**   **
                  11'h4f7: data = 8'b11000110;  //**   **
                  11'h4f8: data = 8'b11000110;  //**   **
                  11'h4f9: data = 8'b11000110;  //**   **
                  11'h4fa: data = 8'b11111110;  //*******
                  11'h4fb: data = 8'b01111100;  // *****
                  11'h4fc: data = 8'b00000000;  //
                  11'h4fd: data = 8'b00000000;  //
                  11'h4fe: data = 8'b00000000;  //
                  11'h4ff: data = 8'b00000000;  //
                  // code x50 (P)
                  11'h500: data = 8'b00000000;  //
                  11'h501: data = 8'b00000000;  //
                  11'h502: data = 8'b11111100;  //******
                  11'h503: data = 8'b11111110;  //*******
                  11'h504: data = 8'b11000110;  //**   **
                  11'h505: data = 8'b11000110;  //**   **
                  11'h506: data = 8'b11111110;  //*******
                  11'h507: data = 8'b11111100;  //******  
                  11'h508: data = 8'b11000000;  //**  
                  11'h509: data = 8'b11000000;  //**  
                  11'h50a: data = 8'b11000000;  //**
                  11'h50b: data = 8'b11000000;  //**
                  11'h50c: data = 8'b00000000;  //
                  11'h50d: data = 8'b00000000;  //
                  11'h50e: data = 8'b00000000;  //
                  11'h50f: data = 8'b00000000;  //
                  // code x51 (Q)
                  11'h510: data = 8'b00000000;  //
                  11'h511: data = 8'b00000000;  //
                  11'h512: data = 8'b11111100;  // *****
                  11'h513: data = 8'b11111110;  //*******
                  11'h514: data = 8'b11000110;  //**   **
                  11'h515: data = 8'b11000110;  //**   **
                  11'h516: data = 8'b11000110;  //**   **
                  11'h517: data = 8'b11000110;  //**   **  
                  11'h518: data = 8'b11010110;  //** * **
                  11'h519: data = 8'b11111110;  //*******
                  11'h51a: data = 8'b01101100;  // ** **
                  11'h51b: data = 8'b00000110;  //     **
                  11'h51c: data = 8'b00000000;  //
                  11'h51d: data = 8'b00000000;  //
                  11'h51e: data = 8'b00000000;  //
                  11'h51f: data = 8'b00000000;  //
                  // code x52 (R)
                  11'h520: data = 8'b00000000;  //
                  11'h521: data = 8'b00000000;  //
                  11'h522: data = 8'b11111100;  //******
                  11'h523: data = 8'b11111110;  //*******
                  11'h524: data = 8'b11000110;  //**   **
                  11'h525: data = 8'b11000110;  //**   **
                  11'h526: data = 8'b11111110;  //*******
                  11'h527: data = 8'b11111100;  //******  
                  11'h528: data = 8'b11011000;  //** **  
                  11'h529: data = 8'b11001100;  //**  **
                  11'h52a: data = 8'b11000110;  //**   **
                  11'h52b: data = 8'b11000110;  //**   **
                  11'h52c: data = 8'b00000000;  //
                  11'h52d: data = 8'b00000000;  //
                  11'h52e: data = 8'b00000000;  //
                  11'h52f: data = 8'b00000000;  //
                  // code x53 (S)
                  11'h530: data = 8'b00000000;  //
                  11'h531: data = 8'b00000000;  //
                  11'h532: data = 8'b01111100;  // *****
                  11'h533: data = 8'b11111110;  //*******
                  11'h534: data = 8'b11000000;  //**  
                  11'h535: data = 8'b11000000;  //**  
                  11'h536: data = 8'b11111100;  //******
                  11'h537: data = 8'b01111110;  // ******  
                  11'h538: data = 8'b00000110;  //     **  
                  11'h539: data = 8'b00000110;  //     **
                  11'h53a: data = 8'b11111110;  //*******  
                  11'h53b: data = 8'b01111100;  // *****
                  11'h53c: data = 8'b00000000;  //
                  11'h53d: data = 8'b00000000;  //
                  11'h53e: data = 8'b00000000;  //
                  11'h53f: data = 8'b00000000;  //
                  // code x54 (T)
                  11'h540: data = 8'b00000000;  //
                  11'h541: data = 8'b00000000;  //
                  11'h542: data = 8'b11111110;  //*******
                  11'h543: data = 8'b11111110;  //*******
                  11'h544: data = 8'b00110000;  //  **
                  11'h545: data = 8'b00110000;  //  **
                  11'h546: data = 8'b00110000;  //  **
                  11'h547: data = 8'b00110000;  //  **  
                  11'h548: data = 8'b00110000;  //  **  
                  11'h549: data = 8'b00110000;  //  **
                  11'h54a: data = 8'b00110000;  //  **  
                  11'h54b: data = 8'b00110000;  //  **
                  11'h54c: data = 8'b00000000;  //
                  11'h54d: data = 8'b00000000;  //
                  11'h54e: data = 8'b00000000;  //
                  11'h54f: data = 8'b00000000;  //
                  // code x55 (U)
                  11'h550: data = 8'b00000000;  //
                  11'h551: data = 8'b00000000;  //
                  11'h552: data = 8'b11000110;  //**   **
                  11'h553: data = 8'b11000110;  //**   **
                  11'h554: data = 8'b11000110;  //**   **
                  11'h555: data = 8'b11000110;  //**   **
                  11'h556: data = 8'b11000110;  //**   **
                  11'h557: data = 8'b11000110;  //**   **
                  11'h558: data = 8'b11000110;  //**   **
                  11'h559: data = 8'b11000110;  //**   **
                  11'h55a: data = 8'b11111110;  //*******
                  11'h55b: data = 8'b01111100;  // *****
                  11'h55c: data = 8'b00000000;  //
                  11'h55d: data = 8'b00000000;  //
                  11'h55e: data = 8'b00000000;  //
                  11'h55f: data = 8'b00000000;  //
                  // code x56 (V)
                  11'h560: data = 8'b00000000;  //
                  11'h561: data = 8'b00000000;  //
                  11'h562: data = 8'b11000110;  //**   **
                  11'h563: data = 8'b11000110;  //**   **
                  11'h564: data = 8'b11000110;  //**   **
                  11'h565: data = 8'b11000110;  //**   **
                  11'h566: data = 8'b11000110;  //**   **
                  11'h567: data = 8'b11000110;  //**   **
                  11'h568: data = 8'b11000110;  //**   **
                  11'h569: data = 8'b01101100;  // ** **
                  11'h56a: data = 8'b00111000;  //  ***  
                  11'h56b: data = 8'b00010000;  //   *
                  11'h56c: data = 8'b00000000;  //
                  11'h56d: data = 8'b00000000;  //
                  11'h56e: data = 8'b00000000;  //
                  11'h56f: data = 8'b00000000;  //
                  // code x57 (W)
                  11'h570: data = 8'b00000000;  //
                  11'h571: data = 8'b00000000;  //
                  11'h572: data = 8'b11000110;  //**   **
                  11'h573: data = 8'b11000110;  //**   **
                  11'h574: data = 8'b11000110;  //**   **
                  11'h575: data = 8'b11000110;  //**   **
                  11'h576: data = 8'b11000110;  //**   **
                  11'h577: data = 8'b11000110;  //**   **
                  11'h578: data = 8'b11010110;  //** * **
                  11'h579: data = 8'b11111110;  //*******
                  11'h57a: data = 8'b11101110;  //*** ***  
                  11'h57b: data = 8'b11000110;  //**   **
                  11'h57c: data = 8'b00000000;  //
                  11'h57d: data = 8'b00000000;  //
                  11'h57e: data = 8'b00000000;  //
                  11'h57f: data = 8'b00000000;  //
                  // code x58 (X)
                  11'h580: data = 8'b00000000;  //
                  11'h581: data = 8'b00000000;  //
                  11'h582: data = 8'b11000110;  //**   **
                  11'h583: data = 8'b11000110;  //**   **
                  11'h584: data = 8'b01101100;  // ** **
                  11'h585: data = 8'b00111000;  //  ***
                  11'h586: data = 8'b00111000;  //  ***
                  11'h587: data = 8'b00111000;  //  ***
                  11'h588: data = 8'b00111000;  //  ***
                  11'h589: data = 8'b01101100;  // ** **
                  11'h58a: data = 8'b11000110;  //**   **  
                  11'h58b: data = 8'b11000110;  //**   **
                  11'h58c: data = 8'b00000000;  //
                  11'h58d: data = 8'b00000000;  //
                  11'h58e: data = 8'b00000000;  //
                  11'h58f: data = 8'b00000000;  //
                  // code x59 (Y)
                  11'h590: data = 8'b00000000;  //
                  11'h591: data = 8'b00000000;  //
                  11'h592: data = 8'b11000110;  //**   **
                  11'h593: data = 8'b11000110;  //**   **
                  11'h594: data = 8'b01101100;  // ** **
                  11'h595: data = 8'b00111000;  //  ***
                  11'h596: data = 8'b00011000;  //   **
                  11'h597: data = 8'b00011000;  //   **
                  11'h598: data = 8'b00011000;  //   **
                  11'h599: data = 8'b00011000;  //   **
                  11'h59a: data = 8'b00011000;  //   **  
                  11'h59b: data = 8'b00011000;  //   **
                  11'h59c: data = 8'b00000000;  //
                  11'h59d: data = 8'b00000000;  //
                  11'h59e: data = 8'b00000000;  //
                  11'h59f: data = 8'b00000000;  //
                  // code x5a (Z)
                  11'h5a0: data = 8'b00000000;  //
                  11'h5a1: data = 8'b00000000;  //
                  11'h5a2: data = 8'b11111110;  //*******
                  11'h5a3: data = 8'b11111110;  //*******
                  11'h5a4: data = 8'b00000110;  //     **  
                  11'h5a5: data = 8'b00001100;  //    **
                  11'h5a6: data = 8'b00011000;  //   **
                  11'h5a7: data = 8'b00110000;  //  **
                  11'h5a8: data = 8'b01100000;  // **
                  11'h5a9: data = 8'b11000000;  //**
                  11'h5aa: data = 8'b11111110;  //*******  
                  11'h5ab: data = 8'b11111110;  //*******
                  11'h5ac: data = 8'b00000000;  //
                  11'h5ad: data = 8'b00000000;  //
                  11'h5ae: data = 8'b00000000;  //
                  11'h5af: data = 8'b00000000;  //
        endcase
         
endmodule

