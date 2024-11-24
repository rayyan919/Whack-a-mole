module mole_animation (
    input wire clk,
    input wire rst,
    input wire [2:0] oval_select,    // Selected oval (0-4)
    input wire [9:0] x,              // Current pixel x position from vga_sync
    input wire [9:0] y,              // Current pixel y position from vga_sync
    input wire video_on,             // Video signal from vga_sync
    output reg [11:0] mole_color     // 12-bit RGB color output
);

    // Parameters for oval positions (matching oval_display module)
    parameter [9:0] OVAL1_X = 320, OVAL1_Y = 120;
    parameter [9:0] OVAL2_X = 220, OVAL2_Y = 220;
    parameter [9:0] OVAL3_X = 320, OVAL3_Y = 220;
    parameter [9:0] OVAL4_X = 420, OVAL4_Y = 220;
    parameter [9:0] OVAL5_X = 320, OVAL5_Y = 320;
    
    // Mole size parameters (smaller than oval)
    parameter MOLE_WIDTH = 30;  // Smaller than oval X_RADIUS*2
    parameter MOLE_HEIGHT = 15; // Smaller than oval Y_RADIUS*2
    
    // Animation parameters
    parameter ANIMATION_STEPS = 4;
    reg [1:0] animation_state;
    reg [19:0] animation_counter;
    parameter ANIMATION_SPEED = 500000;
    
    // Colors
    parameter [11:0] MOLE_COLOR = 12'h642;    // Brown color for mole
    parameter [11:0] MOLE_EYES = 12'hFFF;     // White for eyes
    parameter [11:0] TRANSPARENT = 12'hFFF;    // Transparent (same as unselected oval)
    
    // Current mole position
    reg [9:0] mole_x, mole_y;
    
    // Position selection based on oval_select
    always @(*) begin
        case(oval_select)
            3'd0: begin mole_x = OVAL1_X - (MOLE_WIDTH/2); mole_y = OVAL1_Y - (MOLE_HEIGHT/2); end
            3'd1: begin mole_x = OVAL2_X - (MOLE_WIDTH/2); mole_y = OVAL2_Y - (MOLE_HEIGHT/2); end
            3'd2: begin mole_x = OVAL3_X - (MOLE_WIDTH/2); mole_y = OVAL3_Y - (MOLE_HEIGHT/2); end
            3'd3: begin mole_x = OVAL4_X - (MOLE_WIDTH/2); mole_y = OVAL4_Y - (MOLE_HEIGHT/2); end
            3'd4: begin mole_x = OVAL5_X - (MOLE_WIDTH/2); mole_y = OVAL5_Y - (MOLE_HEIGHT/2); end
            default: begin mole_x = 0; mole_y = 0; end
        endcase
    end
    
    // Animation counter
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            animation_counter <= 0;
            animation_state <= 0;
        end
        else begin
            if (animation_counter == ANIMATION_SPEED) begin
                animation_counter <= 0;
                if (animation_state == ANIMATION_STEPS-1)
                    animation_state <= 0;
                else
                    animation_state <= animation_state + 1;
            end
            else
                animation_counter <= animation_counter + 1;
        end
    end
    
    // Mole pixel generation
    always @(*) begin
        // Default: transparent (matches unselected oval color)
        mole_color = TRANSPARENT;
        
        if (video_on) begin
            // Check if current pixel is within mole area
            if (x >= mole_x && x < mole_x + MOLE_WIDTH &&
                y >= mole_y && y < mole_y + MOLE_HEIGHT) begin
                
                // Calculate relative position within mole sprite
                reg [9:0] rel_x = x - mole_x;
                reg [9:0] rel_y = y - mole_y;
                
                // Animation states
                case(animation_state)
                    2'b00: begin // Hidden
                        if (rel_y >= MOLE_HEIGHT-4)
                            mole_color = MOLE_COLOR;
                    end
                    
                    2'b01: begin // Partially visible
                        if (rel_y >= MOLE_HEIGHT-8)
                            mole_color = MOLE_COLOR;
                    end
                    
                    2'b10: begin // More visible
                        if (rel_y >= MOLE_HEIGHT-12)
                            mole_color = MOLE_COLOR;
                    end
                    
                    2'b11: begin // Fully visible
                        // Basic mole shape
                        if (rel_y >= 4) begin
                            // Body
                            if (rel_x >= 4 && rel_x < MOLE_WIDTH-4)
                                mole_color = MOLE_COLOR;
                            
                            // Eyes
                            if (rel_y >= 6 && rel_y <= 8) begin
                                if ((rel_x >= 8 && rel_x <= 10) || 
                                    (rel_x >= MOLE_WIDTH-10 && rel_x <= MOLE_WIDTH-8))
                                    mole_color = MOLE_EYES;
                            end
                        end
                    end
                endcase
            end
        end
    end

endmodule