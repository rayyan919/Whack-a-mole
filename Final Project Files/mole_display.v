`timescale 1ns / 1ps



module mole_display (
    input wire clk,          // System clock
    input wire reset,        // Reset signal
    output wire hsync,       // Horizontal sync
    output wire vsync,       // Vertical sync
    output reg [3:0] red,    // Red color (4 bits)
    output reg [3:0] green,  // Green color (4 bits)
    output reg [3:0] blue    // Blue color (4 bits)
);

    // Internal signals
    wire [9:0] pixel_x, pixel_y;  // Current pixel coordinates
    wire video_on;                // Video active region flag
    wire [63:0] mole_pattern;     // Current row's mole pattern
    
    // Position of mole (you can adjust these values)
    localparam MOLE_X = 100;  // Starting X position
    localparam MOLE_Y = 100;  // Starting Y position
    localparam MOLE_WIDTH = 64;  // Width of mole pattern
    localparam MOLE_HEIGHT = 32; // Height of mole pattern
    
    // Color values (you can adjust these)
    localparam [11:0] MOLE_COLOR = 12'hFFF;    // White mole
    localparam [11:0] BG_COLOR = 12'h000;      // Black background
    
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
    
    // Instantiate ASCII ROM
    wire [4:0] rom_addr;  // Row address for mole pattern
    ascii_rom mole_rom (
        .row(rom_addr),
        .mole_pattern(mole_pattern)
    );
    
    // Calculate relative position within mole area
    wire [9:0] mole_x_rel = pixel_x - MOLE_X;
    wire [9:0] mole_y_rel = pixel_y - MOLE_Y;
    
    // Generate ROM address from y position
    assign rom_addr = (pixel_y >= MOLE_Y && pixel_y < MOLE_Y + MOLE_HEIGHT) ?
                     pixel_y - MOLE_Y : 5'd0;
    
    // Generate RGB values
    always @* begin
        if (!video_on) begin
            // During blanking, output black
            red = 4'h0;
            green = 4'h0;
            blue = 4'h0;
        end
        else if (pixel_x >= MOLE_X && pixel_x < MOLE_X + MOLE_WIDTH &&
                pixel_y >= MOLE_Y && pixel_y < MOLE_Y + MOLE_HEIGHT) begin
            // Inside mole display area
            if (mole_pattern[MOLE_WIDTH-1 - mole_x_rel]) begin
                // Mole pixel is on - display mole color
                red = MOLE_COLOR[11:8];
                green = MOLE_COLOR[7:4];
                blue = MOLE_COLOR[3:0];
            end
            else begin
                // Mole pixel is off - display background color
                red = BG_COLOR[11:8];
                green = BG_COLOR[7:4];
                blue = BG_COLOR[3:0];
            end
        end
        else begin
            // Outside mole area - display background color
            red = BG_COLOR[11:8];
            green = BG_COLOR[7:4];
            blue = BG_COLOR[3:0];
        end
    end

endmodule
