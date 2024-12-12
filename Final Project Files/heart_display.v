module heart_display (
    input wire clk,          // System clock
    input wire reset,        // Reset signal
    input wire heart_enable, // Enable input to control heart display
    output wire hsync,       
    output wire vsync,       
    output reg [3:0] red,   
    output reg [3:0] green,  
    output reg [3:0] blue    
);

    // Internal signals
    wire [9:0] pixel_x, pixel_y;  
    wire video_on;                
    wire [63:0] heart_pattern;
   
    // Heart dimensions
    localparam HEART_WIDTH = 64;  // Width of heart pattern
    localparam HEART_HEIGHT = 32; // Height of heart pattern
   
    // Color values
    localparam [11:0] HEART_COLOR = 12'hF00;   // Pure Red
    localparam [11:0] BG_COLOR = 12'h000;      // Black background

    // Fixed heart location
    parameter [9:0] HEART_X = 10'd128 - (HEART_WIDTH/2);  // Centered x
    parameter [9:0] HEART_Y = 10'd48 - (HEART_HEIGHT/2);  // Centered y
   
    // Instantiate VGA sync circuit
    vga_sync vga_sync_unit (
        .clk(clk),
        .reset(reset),
        .hsync(hsync),
        .vsync(vsync),
        .video_on(video_on),
        .x(pixel_x),
        .y(pixel_y)
    );
   
    // Instantiate heart ROM
    wire [4:0] rom_addr;
    wire [63:0] internal_heart_pattern;
   
    heart_rom_ascii heart_rom (
        .row(rom_addr),
        .heart_pattern(internal_heart_pattern)
    );
   
    // Conditionally assign heart pattern based on enable
    assign heart_pattern = heart_enable ? internal_heart_pattern : 64'b0;
   
    // Calculate relative position within heart area
    wire [9:0] heart_x_rel = pixel_x - HEART_X;
    wire [9:0] heart_y_rel = pixel_y - HEART_Y;
   
    // Generate ROM address from y position with boundary checks
    assign rom_addr = (heart_enable &&
                       pixel_y >= HEART_Y &&
                       pixel_y < HEART_Y + HEART_HEIGHT) ?
                     pixel_y - HEART_Y : 5'd0;
   
    // Generate RGB values with heart enable condition
    always @* begin
        if (!video_on) begin
            // During blanking, output black
            red = 4'h0;
            green = 4'h0;
            blue = 4'h0;
        end
        else if (heart_enable &&
                 pixel_x >= HEART_X &&
                 pixel_x < HEART_X + HEART_WIDTH &&
                 pixel_y >= HEART_Y &&
                 pixel_y < HEART_Y + HEART_HEIGHT) begin
            // Inside heart display area
            if (heart_pattern[HEART_WIDTH-1 - heart_x_rel]) begin
                // Heart pixel is on - display heart color (red)
                red = HEART_COLOR[11:8];
                green = HEART_COLOR[7:4];
                blue = HEART_COLOR[3:0];
            end
            else begin
                // Heart pixel is off - display background color
                red = BG_COLOR[11:8];
                green = BG_COLOR[7:4];
                blue = BG_COLOR[3:0];
            end
        end
        else begin
            // Outside heart area - display background color
            red = BG_COLOR[11:8];
            green = BG_COLOR[7:4];
            blue = BG_COLOR[3:0];
        end
    end

endmodule


`timescale 1ns / 1ps

module heart_rom_ascii(
 input [4:0] row,  // 6-bit row address (0 to 15)
    output reg [63:0] heart_pattern  // 32-bit pattern for each row
);
    always @(*) begin
        case (row)
            5'd0: heart_pattern = 64'b0000000000000000000000000000000000000000000000000000000000000000;  // Row 1
            5'd1: heart_pattern = 64'b0000000000000000000000000000000000000000000000000000000000000000;
            5'd2: heart_pattern = 64'b0000000000000000000000000000000000000000000000000000000000000000;
            5'd3: heart_pattern = 64'b0000000000000000000000000000000000000000000000000000000000000000;
            5'd4: heart_pattern = 64'b0000000000000000000000000000000000000000000000000000000000000000;
            5'd5: heart_pattern = 64'b0000000000011111111000000000000000000000000001111111100000000000;
            5'd6: heart_pattern = 64'b0000000011111111111111000000000000000000001111111111111100000000;
            5'd7: heart_pattern = 64'b0001111111111111111111111000000000000111111111111111111111100000;
            5'd8: heart_pattern = 64'b1111111111111111111111111111110001111111111111111111111111111111; 
            5'd9: heart_pattern = 64'b1111111111111111111111111111110001111111111111111111111111111111; // Row 10
            5'd10: heart_pattern = 64'b1111111111111111111111111111110111111111111111111111111111111111; // Row 11
            5'd11: heart_pattern = 64'b1111111111111111111111111111111111111111111111111111111111111111; // Row 12
            5'd12: heart_pattern = 64'b1111111111111111111111111111111111111111111111111111111111111111; // Row 13
            5'd13: heart_pattern = 64'b1111111111111111111111111111111111111111111111111111111111111111; // Row 14
            5'd14: heart_pattern = 64'b1111111111111111111111111111111111111111111111111111111111111111; // Row 15
            5'd15: heart_pattern = 64'b1111111111111111111111111111111111111111111111111111111111111111; // Blank Row (Row 16)
            5'd16: heart_pattern = 64'b1111111111111111111111111111111111111111111111111111111111111111; // Blank Row (Row 16)
            5'd17: heart_pattern = 64'b0001111111111111111111111111111111111111111111111111111111111000; // Blank Row (Row 16)
            5'd18: heart_pattern = 64'b0000001111111111111111111111111111111111111111111111111111000000; // Blank Row (Row 16)
            5'd19: heart_pattern = 64'b0000000001111111111111111111111111111111111111111111111000000000; // Blank Row (Row 16)
            5'd20: heart_pattern = 64'b0000000000001111111111111111111111111111111111111111000000000000; // Blank Row (Row 16)
            5'd21: heart_pattern = 64'b0000000000000001111111111111111111111111111111111000000000000000; // Blank Row (Row 16)
            5'd22: heart_pattern = 64'b0000000000000000001111111111111111111111111111000000000000000000; // Blank Row (Row 16)
            5'd23: heart_pattern = 64'b0000000000000000000001111111111111111111111000000000000000000000; // Blank Row (Row 16)
            5'd24: heart_pattern = 64'b0000000000000000000000001111111111111111000000000000000000000000; // Blank Row (Row 16)
            5'd25: heart_pattern = 64'b0000000000000000000000000001111111111000000000000000000000000000; // Blank Row (Row 16)
            5'd26: heart_pattern = 64'b0000000000000000000000000000001111000000000000000000000000000000; // Blank Row (Row 16)
            5'd27: heart_pattern = 64'b0000000000000000000000000000000110000000000000000000000000000000; // Blank Row (Row 16)
            5'd28: heart_pattern = 64'b0000000000000000000000000000000000000000000000000000000000000000; // Blank Row (Row 16)
            5'd29: heart_pattern = 64'b0000000000000000000000000000000000000000000000000000000000000000; // Blank Row (Row 16)
            5'd30: heart_pattern = 64'b0000000000000000000000000000000000000000000000000000000000000000; // Blank Row (Row 16)
            5'd31: heart_pattern = 64'b0000000000000000000000000000000000000000000000000000000000000000; // Blank Row (Row 16)
            default: heart_pattern = 64'b0000000000000000000000000000000000000000000000000000000000000000; // Default Blank
        endcase
    end
endmodule