////`timescale 1ns / 1ps

////module oval_display (
////    input wire clk,
////    input wire rst,
////    input wire [2:0] oval_select,  // Selects which oval is active
////    input wire [9:0] x,            // Current pixel x position from vga_sync
////    input wire [9:0] y,            // Current pixel y position from vga_sync
////    input wire video_on,           // Video signal from vga_sync
////    output wire [3:0] red,
////    output wire [3:0] green,
////    output wire [3:0] blue
////);

////    // Parameters for oval dimensions
////    parameter X_RADIUS = 40;  // Reduced radius for better spacing
////    parameter Y_RADIUS = 30;  // Reduced radius for better spacing

////    // Coordinates for ovals (center points) in cross pattern
////    parameter [9:0] OVAL1_X = 320;  // Top center
////    parameter [9:0] OVAL1_Y = 120;
////    parameter [9:0] OVAL2_X = 320;  // Middle center
////    parameter [9:0] OVAL2_Y = 240;
////    parameter [9:0] OVAL3_X = 320;  // Bottom center
////    parameter [9:0] OVAL3_Y = 360;
////    parameter [9:0] OVAL4_X = 200;  // Middle left
////    parameter [9:0] OVAL4_Y = 240;
////    parameter [9:0] OVAL5_X = 440;  // Middle right
////    parameter [9:0] OVAL5_Y = 240;

////    // Colors
////    parameter [11:0] BG_COLOR = 12'h000;     // Black background
////    parameter [11:0] INIT_COLOR = 12'hFFF;   // White for inactive ovals
////    parameter [11:0] ACTIVE_COLOR = 12'hF00; // Red for the active oval

////    // Internal signals
////    reg [11:0] pixel_color; // Final pixel color

////    // Helper function to check if (x, y) is within an oval
////    function is_in_oval;
////        input [9:0] px, py, cx, cy;
////        input [9:0] x_rad, y_rad;
////        begin
////            is_in_oval = (((px - cx) * (px - cx)) / (x_rad * x_rad) +
////                         ((py - cy) * (py - cy)) / (y_rad * y_rad)) <= 1;
////        end
////    endfunction

////    always @(*) begin
////        if (video_on) begin
////            // Default to background color
////            pixel_color = BG_COLOR;
            
////            // Check each oval position
////            if (is_in_oval(x, y, OVAL1_X, OVAL1_Y, X_RADIUS, Y_RADIUS))
////                pixel_color = (oval_select == 3'b000) ? ACTIVE_COLOR : INIT_COLOR;
////            else if (is_in_oval(x, y, OVAL2_X, OVAL2_Y, X_RADIUS, Y_RADIUS))
////                pixel_color = (oval_select == 3'b001) ? ACTIVE_COLOR : INIT_COLOR;
////            else if (is_in_oval(x, y, OVAL3_X, OVAL3_Y, X_RADIUS, Y_RADIUS))
////                pixel_color = (oval_select == 3'b010) ? ACTIVE_COLOR : INIT_COLOR;
////            else if (is_in_oval(x, y, OVAL4_X, OVAL4_Y, X_RADIUS, Y_RADIUS))
////                pixel_color = (oval_select == 3'b011) ? ACTIVE_COLOR : INIT_COLOR;
////            else if (is_in_oval(x, y, OVAL5_X, OVAL5_Y, X_RADIUS, Y_RADIUS))
////                pixel_color = (oval_select == 3'b100) ? ACTIVE_COLOR : INIT_COLOR;
////        end else begin
////            pixel_color = BG_COLOR;
////        end
////    end

////    // Assign final RGB outputs
////    assign red = pixel_color[11:8];
////    assign green = pixel_color[7:4];
////    assign blue = pixel_color[3:0];

////endmodule
//`timescale 1ns / 1ps

//module oval_display (
//    input wire clk,
//    input wire rst,
//    input wire [2:0] oval_select,  // Select input (kept for consistency)
//    input wire [9:0] x,            // Current pixel x position from vga_sync
//    input wire [9:0] y,            // Current pixel y position from vga_sync
//    input wire video_on,           // Video signal from vga_sync
//    output wire [3:0] red,
//    output wire [3:0] green,
//    output wire [3:0] blue
//);

//    // Parameters for oval dimensions
//    parameter X_RADIUS = 40;  // Radius for better spacing
//    parameter Y_RADIUS = 30;  // Radius for better spacing

//    // Coordinates for ovals (center points) in cross pattern
//    parameter [9:0] OVAL1_X = 320;  // Top center
//    parameter [9:0] OVAL1_Y = 120;
//    parameter [9:0] OVAL2_X = 320;  // Middle center (active)
//    parameter [9:0] OVAL2_Y = 240;
//    parameter [9:0] OVAL3_X = 320;  // Bottom center
//    parameter [9:0] OVAL3_Y = 360;
//    parameter [9:0] OVAL4_X = 200;  // Middle left
//    parameter [9:0] OVAL4_Y = 240;
//    parameter [9:0] OVAL5_X = 440;  // Middle right
//    parameter [9:0] OVAL5_Y = 240;

//    // Colors
//    parameter [11:0] BG_COLOR = 12'h000;     // Black background
//    parameter [11:0] INIT_COLOR = 12'hFFF;   // White for inactive ovals
//    parameter [11:0] ACTIVE_COLOR = 12'hF00; // Red for the active oval

//    // Internal signals
//    reg [11:0] pixel_color; // Final pixel color

//    // Helper function to check if (x, y) is within an oval
//    function is_in_oval;
//        input [9:0] px, py, cx, cy;
//        input [9:0] x_rad, y_rad;
//        begin
//            is_in_oval = (((px - cx) * (px - cx)) / (x_rad * x_rad) +
//                         ((py - cy) * (py - cy)) / (y_rad * y_rad)) <= 1;
//        end
//    endfunction

//    always @(*) begin
//        if (video_on) begin
//            // Default to background color
//            pixel_color = BG_COLOR;

//            // Explicitly light only the second oval, regardless of oval_select
//            if (is_in_oval(x, y, OVAL2_X, OVAL2_Y, X_RADIUS, Y_RADIUS))
//                pixel_color = ACTIVE_COLOR;  // Second oval is red
//            else if (is_in_oval(x, y, OVAL1_X, OVAL1_Y, X_RADIUS, Y_RADIUS) ||
//                     is_in_oval(x, y, OVAL3_X, OVAL3_Y, X_RADIUS, Y_RADIUS) ||
//                     is_in_oval(x, y, OVAL4_X, OVAL4_Y, X_RADIUS, Y_RADIUS) ||
//                     is_in_oval(x, y, OVAL5_X, OVAL5_Y, X_RADIUS, Y_RADIUS))
//                pixel_color = INIT_COLOR;  // All other ovals are white
//        end else begin
//            pixel_color = BG_COLOR;  // Outside video region, keep black
//        end
//    end

//    // Assign final RGB outputs
//    assign red = pixel_color[11:8];
//    assign green = pixel_color[7:4];
//    assign blue = pixel_color[3:0];

////endmodule

//`timescale 1ns / 1ps

//module oval_display (
//    input wire clk,
//    input wire rst,
//    input wire [2:0] oval_select,  // Select input to determine which oval lights up
//    input wire [9:0] x,            // Current pixel x position from vga_sync
//    input wire [9:0] y,            // Current pixel y position from vga_sync
//    input wire video_on,           // Video signal from vga_sync
//    output wire [3:0] red,
//    output wire [3:0] green,
//    output wire [3:0] blue
//);

//    // Parameters for oval dimensions
//    parameter X_RADIUS = 40;  // Horizontal radius
//    parameter Y_RADIUS = 30;  // Vertical radius

//    // Coordinates for ovals (center points)
//    parameter [9:0] OVAL1_X = 320;  // Top center
//    parameter [9:0] OVAL1_Y = 120;
//    parameter [9:0] OVAL2_X = 320;  // Middle center
//    parameter [9:0] OVAL2_Y = 240;
//    parameter [9:0] OVAL3_X = 320;  // Bottom center
//    parameter [9:0] OVAL3_Y = 360;
//    parameter [9:0] OVAL4_X = 200;  // Middle left
//    parameter [9:0] OVAL4_Y = 240;
//    parameter [9:0] OVAL5_X = 440;  // Middle right
//    parameter [9:0] OVAL5_Y = 240;

//    // Colors
//    parameter [11:0] BG_COLOR = 12'h000;     // Black background
//    parameter [11:0] OVAL_COLOR = 12'hFFF;   // White for inactive ovals
//    parameter [11:0] ACTIVE_COLOR = 12'hF00; // Red for the active oval

//    // Internal signals
//    reg [11:0] pixel_color; // Final pixel color

//    // Helper function to check if (x, y) is within an oval
//    function is_in_oval;
//        input [9:0] px, py, cx, cy;
//        input [9:0] x_rad, y_rad;
//        reg [19:0] x_diff_squared, y_diff_squared, x_rad_squared, y_rad_squared;
//        begin
//            x_diff_squared = (px - cx) * (px - cx);  // (px - cx)^2
//            y_diff_squared = (py - cy) * (py - cy);  // (py - cy)^2
//            x_rad_squared = x_rad * x_rad;          // x_rad^2
//            y_rad_squared = y_rad * y_rad;          // y_rad^2

//            // Avoid division; use scaled comparison:
//            is_in_oval = (x_diff_squared * y_rad_squared + y_diff_squared * x_rad_squared) <= (x_rad_squared * y_rad_squared);
//        end
//    endfunction

//    always @(*) begin
//        if (video_on) begin
//            // Default to background color
//            pixel_color = BG_COLOR;

//            // Light up the selected oval in red, others in white
//            case (oval_select)
//                3'b001: begin
//                    if (is_in_oval(x, y, OVAL1_X, OVAL1_Y, X_RADIUS, Y_RADIUS))
//                        pixel_color = ACTIVE_COLOR;
//                    else if (is_in_oval(x, y, OVAL2_X, OVAL2_Y, X_RADIUS, Y_RADIUS) ||
//                             is_in_oval(x, y, OVAL3_X, OVAL3_Y, X_RADIUS, Y_RADIUS) ||
//                             is_in_oval(x, y, OVAL4_X, OVAL4_Y, X_RADIUS, Y_RADIUS) ||
//                             is_in_oval(x, y, OVAL5_X, OVAL5_Y, X_RADIUS, Y_RADIUS))
//                        pixel_color = OVAL_COLOR;
//                end
//                3'b010: begin
//                    if (is_in_oval(x, y, OVAL2_X, OVAL2_Y, X_RADIUS, Y_RADIUS))
//                        pixel_color = ACTIVE_COLOR;
//                    else if (is_in_oval(x, y, OVAL1_X, OVAL1_Y, X_RADIUS, Y_RADIUS) ||
//                             is_in_oval(x, y, OVAL3_X, OVAL3_Y, X_RADIUS, Y_RADIUS) ||
//                             is_in_oval(x, y, OVAL4_X, OVAL4_Y, X_RADIUS, Y_RADIUS) ||
//                             is_in_oval(x, y, OVAL5_X, OVAL5_Y, X_RADIUS, Y_RADIUS))
//                        pixel_color = OVAL_COLOR;
//                end
//                3'b011: begin
//                    if (is_in_oval(x, y, OVAL3_X, OVAL3_Y, X_RADIUS, Y_RADIUS))
//                        pixel_color = ACTIVE_COLOR;
//                    else if (is_in_oval(x, y, OVAL1_X, OVAL1_Y, X_RADIUS, Y_RADIUS) ||
//                             is_in_oval(x, y, OVAL2_X, OVAL2_Y, X_RADIUS, Y_RADIUS) ||
//                             is_in_oval(x, y, OVAL4_X, OVAL4_Y, X_RADIUS, Y_RADIUS) ||
//                             is_in_oval(x, y, OVAL5_X, OVAL5_Y, X_RADIUS, Y_RADIUS))
//                        pixel_color = OVAL_COLOR;
//                end
//                3'b100: begin
//                    if (is_in_oval(x, y, OVAL4_X, OVAL4_Y, X_RADIUS, Y_RADIUS))
//                        pixel_color = ACTIVE_COLOR;
//                    else if (is_in_oval(x, y, OVAL1_X, OVAL1_Y, X_RADIUS, Y_RADIUS) ||
//                             is_in_oval(x, y, OVAL2_X, OVAL2_Y, X_RADIUS, Y_RADIUS) ||
//                             is_in_oval(x, y, OVAL3_X, OVAL3_Y, X_RADIUS, Y_RADIUS) ||
//                             is_in_oval(x, y, OVAL5_X, OVAL5_Y, X_RADIUS, Y_RADIUS))
//                        pixel_color = OVAL_COLOR;
//                end
//                3'b101: begin
//                    if (is_in_oval(x, y, OVAL5_X, OVAL5_Y, X_RADIUS, Y_RADIUS))
//                        pixel_color = ACTIVE_COLOR;
//                    else if (is_in_oval(x, y, OVAL1_X, OVAL1_Y, X_RADIUS, Y_RADIUS) ||
//                             is_in_oval(x, y, OVAL2_X, OVAL2_Y, X_RADIUS, Y_RADIUS) ||
//                             is_in_oval(x, y, OVAL3_X, OVAL3_Y, X_RADIUS, Y_RADIUS) ||
//                             is_in_oval(x, y, OVAL4_X, OVAL4_Y, X_RADIUS, Y_RADIUS))
//                        pixel_color = OVAL_COLOR;
//                end
//                default: begin
//                    // All ovals white if no selection is active
//                    if (is_in_oval(x, y, OVAL1_X, OVAL1_Y, X_RADIUS, Y_RADIUS) ||
//                        is_in_oval(x, y, OVAL2_X, OVAL2_Y, X_RADIUS, Y_RADIUS) ||
//                        is_in_oval(x, y, OVAL3_X, OVAL3_Y, X_RADIUS, Y_RADIUS) ||
//                        is_in_oval(x, y, OVAL4_X, OVAL4_Y, X_RADIUS, Y_RADIUS) ||
//                        is_in_oval(x, y, OVAL5_X, OVAL5_Y, X_RADIUS, Y_RADIUS))
//                        pixel_color = OVAL_COLOR;
//                end
//            endcase
//        end else begin
//            pixel_color = BG_COLOR;  // Outside video region, keep black
//        end
//    end

//    // Assign final RGB outputs
//    assign red = pixel_color[11:8];
//    assign green = pixel_color[7:4];
//    assign blue = pixel_color[3:0];

//endmodule

//module oval_display (
//    input wire clk,
//    input wire rst,
//    input wire [2:0] oval_select,  // Selected oval
//    input wire [9:0] x,            // Current pixel x position from vga_sync
//    input wire [9:0] y,            // Current pixel y position from vga_sync
//    input wire video_on,           // Video signal from vga_sync
//    output wire [3:0] red,
//    output wire [3:0] green,
//    output wire [3:0] blue
//);

//    // Parameters for colors
//    parameter [11:0] BG_COLOR = 12'h000;     // Background color (black)
//    parameter [11:0] UNSELECTED_COLOR = 12'hFFF; // Unselected oval color (white)
//    parameter [11:0] SELECTED_COLOR = 12'h0F0;   // Selected oval color (green)

//    // Parameters for oval dimensions and positions
//    parameter [9:0] OVAL1_X = 320, OVAL1_Y = 160;
//    parameter [9:0] OVAL2_X = 240, OVAL2_Y = 240;
//    parameter [9:0] OVAL3_X = 320, OVAL3_Y = 240;
//    parameter [9:0] OVAL4_X = 400, OVAL4_Y = 240;
//    parameter [9:0] OVAL5_X = 320, OVAL5_Y = 320;
//    parameter [9:0] X_RADIUS = 50, Y_RADIUS = 30;

//    // Internal signals
//    reg [11:0] pixel_color;

//    // Helper function
//    function is_in_oval;
//        input [9:0] px, py, cx, cy;
//        input [9:0] x_rad, y_rad;
//        begin
//            is_in_oval = (((px - cx) * (px - cx)) / (x_rad * x_rad) +
//                         ((py - cy) * (py - cy)) / (y_rad * y_rad)) <= 1;
//        end
//    endfunction

//    always @(*) begin
//        // Default to background color
//        pixel_color = BG_COLOR;

//        if (video_on) begin
//            // Check each oval and apply color based on selection
//            if (is_in_oval(x, y, OVAL1_X, OVAL1_Y, X_RADIUS, Y_RADIUS))
//                pixel_color = (oval_select == 3'd0) ? SELECTED_COLOR : UNSELECTED_COLOR;
//            else if (is_in_oval(x, y, OVAL2_X, OVAL2_Y, X_RADIUS, Y_RADIUS))
//                pixel_color = (oval_select == 3'd1) ? SELECTED_COLOR : UNSELECTED_COLOR;
//            else if (is_in_oval(x, y, OVAL3_X, OVAL3_Y, X_RADIUS, Y_RADIUS))
//                pixel_color = (oval_select == 3'd2) ? SELECTED_COLOR : UNSELECTED_COLOR;
//            else if (is_in_oval(x, y, OVAL4_X, OVAL4_Y, X_RADIUS, Y_RADIUS))
//                pixel_color = (oval_select == 3'd3) ? SELECTED_COLOR : UNSELECTED_COLOR;
//            else if (is_in_oval(x, y, OVAL5_X, OVAL5_Y, X_RADIUS, Y_RADIUS))
//                pixel_color = (oval_select == 3'd4) ? SELECTED_COLOR : UNSELECTED_COLOR;
//        end
//    end

//    // Assign final RGB outputs
//    assign red = pixel_color[11:8];
//    assign green = pixel_color[7:4];
//    assign blue = pixel_color[3:0];

//endmodule

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