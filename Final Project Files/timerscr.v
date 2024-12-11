  module combined_display (
    input wire clk,
    input wire rst,
    input wire [2:0] oval_select,
    input wire enable,
    input wire [3:0]score,
    input wire pause,
    output wire timer_done_signal,
    output wire [6:0] score_MSB, score_LSB,
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
    
    // New register to hold the selected oval during pause
    reg [2:0] paused_oval_select;

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
        .oval_select(pause ? paused_oval_select : oval_select),
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

    wire [6:0] time_MSB, time_LSB;
    game_timer game_timer_unit (
        .clk(slow_clk),
        .rst(rst),
        .enable(enable),
        .pause(pause),
        .time_MSB_ascii(time_MSB),
        .time_LSB_ascii(time_LSB),
        .timer_done(timer_done_signal)
    );
    
//    wire [6:0] score_MSB, score_LSB;
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
                    pixel_color = (pause ? (paused_oval_select == 3'd1) : (oval_select == 3'd1)) ? SELECTED_COLOR : UNSELECTED_COLOR;
                else if (is_in_oval(x, y, OVAL2_X, OVAL2_Y, X_RADIUS, Y_RADIUS))
                    pixel_color = (pause ? (paused_oval_select == 3'd2) : (oval_select == 3'd2)) ? SELECTED_COLOR : UNSELECTED_COLOR;
                else if (is_in_oval(x, y, OVAL3_X, OVAL3_Y, X_RADIUS, Y_RADIUS))
                    pixel_color = (pause ? (paused_oval_select == 3'd3) : (oval_select == 3'd3)) ? SELECTED_COLOR : UNSELECTED_COLOR;
                else if (is_in_oval(x, y, OVAL4_X, OVAL4_Y, X_RADIUS, Y_RADIUS))
                    pixel_color = (pause ? (paused_oval_select == 3'd4) : (oval_select == 3'd4)) ? SELECTED_COLOR : UNSELECTED_COLOR;
                else if (is_in_oval(x, y, OVAL5_X, OVAL5_Y, X_RADIUS, Y_RADIUS))
                    pixel_color = (pause ? (paused_oval_select == 3'd5) : (oval_select == 3'd5)) ? SELECTED_COLOR : UNSELECTED_COLOR;
            end
        end
        else
            pixel_color = 12'h000;
    end

    // Capture the current oval selection when pause is activated
    always @(posedge clk or posedge rst) begin
        if (rst)
            paused_oval_select <= 3'd0;
        else if (pause && !paused_oval_select)
            paused_oval_select <= oval_select;
        else if (!pause)
            paused_oval_select <= 3'd0;
    end

    // Output color blending (to incorporate mole)
    wire [3:0] final_red, final_green, final_blue;
    assign final_red = (mole_red != 4'h0) ? mole_red : pixel_color[11:8];
    assign final_green = (mole_green != 4'h0) ? mole_green : pixel_color[7:4];
    assign final_blue = (mole_blue != 4'h0) ? mole_blue : pixel_color[3:0];
    
    // Assign final colors
    assign red = final_red;
    assign green = final_green;
    assign blue = final_blue;

endmodule

