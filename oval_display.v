

module oval_display (
    input wire clk,
    input wire rst,
    input wire [2:0] oval_select,  // Selected oval
    input wire [9:0] x,            // Current pixel x position from vga_sync
    input wire [9:0] y,            // Current pixel y position from vga_sync
    input wire video_on,           // Video signal from vga_sync
    output wire [3:0] red,
    output wire [3:0] green,
    output wire [3:0] blue
);

    // Parameters for colors
    parameter [11:0] BG_COLOR = 12'h000;     // Background color (black)
    parameter [11:0] UNSELECTED_COLOR = 12'hFFF; // Unselected oval color (white)
    parameter [11:0] SELECTED_COLOR = 12'h0F0;   // Selected oval color (green)

    // Parameters for oval dimensions and positions
    parameter [9:0] OVAL1_X = 320, OVAL1_Y = 120;
    parameter [9:0] OVAL2_X = 220, OVAL2_Y = 220;
    parameter [9:0] OVAL3_X = 320, OVAL3_Y = 220;
    parameter [9:0] OVAL4_X = 420, OVAL4_Y = 220;
    parameter [9:0] OVAL5_X = 320, OVAL5_Y = 320;
    parameter [9:0] X_RADIUS = 40, Y_RADIUS = 20; // Reduced size

    // Internal signals
    reg [11:0] pixel_color;

    // Helper function
    function is_in_oval;
        input [9:0] px, py, cx, cy;
        input [9:0] x_rad, y_rad;
        begin
            is_in_oval = (((px - cx) * (px - cx)) / (x_rad * x_rad) +
                         ((py - cy) * (py - cy)) / (y_rad * y_rad)) <= 1;
        end
    endfunction

    always @(*) begin
        // Default to background color
        pixel_color = BG_COLOR;

        if (video_on) begin
            // Check each oval and apply color based on selection
            if (is_in_oval(x, y, OVAL1_X, OVAL1_Y, X_RADIUS, Y_RADIUS))
                pixel_color = (oval_select == 3'd0) ? SELECTED_COLOR : UNSELECTED_COLOR;
            else if (is_in_oval(x, y, OVAL2_X, OVAL2_Y, X_RADIUS, Y_RADIUS))
                pixel_color = (oval_select == 3'd1) ? SELECTED_COLOR : UNSELECTED_COLOR;
            else if (is_in_oval(x, y, OVAL3_X, OVAL3_Y, X_RADIUS, Y_RADIUS))
                pixel_color = (oval_select == 3'd2) ? SELECTED_COLOR : UNSELECTED_COLOR;
            else if (is_in_oval(x, y, OVAL4_X, OVAL4_Y, X_RADIUS, Y_RADIUS))
                pixel_color = (oval_select == 3'd3) ? SELECTED_COLOR : UNSELECTED_COLOR;
            else if (is_in_oval(x, y, OVAL5_X, OVAL5_Y, X_RADIUS, Y_RADIUS))
                pixel_color = (oval_select == 3'd4) ? SELECTED_COLOR : UNSELECTED_COLOR;
        end
    end

    // Assign final RGB outputs
    assign red = pixel_color[11:8];
    assign green = pixel_color[7:4];
    assign blue = pixel_color[3:0];

endmodule