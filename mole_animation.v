module mole_animation (
    input wire clk,
    input wire rst,
    input wire [2:0] oval_select,
    input wire [9:0] x,
    input wire [9:0] y,
    input wire video_on,
    output reg [11:0] mole_color
);

    // Position parameters (same as before)
    parameter [9:0] OVAL1_X = 320, OVAL1_Y = 120;
    parameter [9:0] OVAL2_X = 220, OVAL2_Y = 220;
    parameter [9:0] OVAL3_X = 320, OVAL3_Y = 220;
    parameter [9:0] OVAL4_X = 420, OVAL4_Y = 220;
    parameter [9:0] OVAL5_X = 320, OVAL5_Y = 320;
    
    // Adjusted mole size to make sprite clearer
    parameter MOLE_WIDTH = 30;
    parameter MOLE_HEIGHT = 20;
    
    // Colors for better visibility
    parameter [11:0] MOLE_DARK = 12'h642;     // Dark brown for main body
    parameter [11:0] MOLE_LIGHT = 12'h853;    // Lighter brown for snout
    parameter [11:0] MOLE_EYES = 12'h111;     // Dark for eyes
    parameter [11:0] MOLE_NOSE = 12'h000;     // Black for nose
    parameter [11:0] TRANSPARENT = 12'hFFF;    // Transparent
    
    // Animation parameters
    parameter ANIMATION_STEPS = 4;
    reg [1:0] animation_state;
    reg [19:0] animation_counter;
    parameter ANIMATION_SPEED = 500000;
    
    reg [9:0] mole_x, mole_y;
    
    // Position logic (same as before)
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
    
    // Animation counter (same as before)
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
    
    // Improved mole sprite generation
    always @(*) begin
        // Default: transparent
        mole_color = TRANSPARENT;
        
        if (video_on) begin
            if (x >= mole_x && x < mole_x + MOLE_WIDTH &&
                y >= mole_y && y < mole_y + MOLE_HEIGHT) begin
                
                reg [9:0] rel_x = x - mole_x;
                reg [9:0] rel_y = y - mole_y;
                
                case(animation_state)
                    2'b00: begin // Just peeking
                        if (rel_y >= MOLE_HEIGHT-5) begin
                            if (rel_x >= 8 && rel_x < MOLE_WIDTH-8)
                                mole_color = MOLE_DARK;
                        end
                    end
                    
                    2'b01: begin // Quarter visible
                        if (rel_y >= MOLE_HEIGHT-10) begin
                            if (rel_x >= 6 && rel_x < MOLE_WIDTH-6)
                                mole_color = MOLE_DARK;
                        end
                    end
                    
                    2'b10: begin // Half visible
                        if (rel_y >= MOLE_HEIGHT-15) begin
                            // Body shape
                            if (rel_x >= 4 && rel_x < MOLE_WIDTH-4)
                                mole_color = MOLE_DARK;
                            // Start showing snout
                            if (rel_y >= MOLE_HEIGHT-8 && 
                                rel_x >= (MOLE_WIDTH/2)-6 && 
                                rel_x <= (MOLE_WIDTH/2)+6)
                                mole_color = MOLE_LIGHT;
                        end
                    end
                    
                    2'b11: begin // Fully visible
                        // Main body
                        if (rel_y >= 4 && rel_x >= 4 && rel_x < MOLE_WIDTH-4)
                            mole_color = MOLE_DARK;
                            
                        // Lighter snout area
                        if (rel_y >= 8 && rel_y <= 16 && 
                            rel_x >= (MOLE_WIDTH/2)-6 && 
                            rel_x <= (MOLE_WIDTH/2)+6)
                            mole_color = MOLE_LIGHT;
                            
                        // Eyes
                        if (rel_y >= 7 && rel_y <= 9) begin
                            if ((rel_x >= 8 && rel_x <= 10) || 
                                (rel_x >= MOLE_WIDTH-10 && rel_x <= MOLE_WIDTH-8))
                                mole_color = MOLE_EYES;
                        end
                        
                        // Nose
                        if (rel_y >= 12 && rel_y <= 13 &&
                            rel_x >= (MOLE_WIDTH/2)-1 && 
                            rel_x <= (MOLE_WIDTH/2)+1)
                            mole_color = MOLE_NOSE;
                    end
                endcase
            end
        end
    end

endmodule