

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
