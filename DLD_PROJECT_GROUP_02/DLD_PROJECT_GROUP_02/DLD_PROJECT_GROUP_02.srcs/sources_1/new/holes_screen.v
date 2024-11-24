module holes_screen (
    input wire clk,
    input wire reset,
    input  wire [2:0] oval_select,
    output wire hsync,
    output wire vsync,
    output wire [3:0] red,
    output wire [3:0] green,
    output wire [3:0] blue
);

    wire video_on;
    wire [9:0] x, y;
//    wire [2:0] oval_select;

    // Instantiate vga_sync
    vga_sync sync_unit (
        .clk(clk),
        .reset(reset),
        .hsync(hsync),
        .vsync(vsync),
        .video_on(video_on),
        .x(x),
        .y(y)
    );

//    // Instantiate random oval selector
//    random_oval_selector selector_unit (
//        .clk(clk),
//        .rst(reset),
//        .oval_select(oval_select)
//    );

        
    ClockDivider clk_div(
        .clk(clk),          // Fast clock from FPGA
        .reset(1'b0),       // No reset
        .slow_clk(slow_clk) // Slower clock output
    );

    // Instantiate oval_display
    oval_display display_unit (
        .clk(slow_clk),
        .rst(reset),
        .oval_select(oval_select),  // Connect selector
        .x(x),
        .y(y),
        .video_on(video_on),
        .red(red),
        .green(green),
        .blue(blue)
    );

endmodule