module game_timer (
    input wire clk,
    input wire rst,
    input wire enable,      // Enable counting
    output reg [3:0] time_MSB, // Most significant BCD digit
    output reg [3:0] time_LSB, // Least significant BCD digit
    output reg timer_done
);
    // Generate 1Hz clock from system clock (assuming 100MHz)
    reg [26:0] count = 0;
    reg one_sec_pulse = 0;
    reg [4:0] time_left;  // Changed to 5-bit
    
    // 1 Hz clock generation (same as before)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            one_sec_pulse <= 0;
        end
        else if (count == 100000000-1) begin  // Adjust based on your actual clock frequency
            count <= 0;
            one_sec_pulse <= 1;
        end
        else begin
            count <= count + 1;
            one_sec_pulse <= 0;
        end
    end
    
    // Five-bit BCD converter instantiation
    wire [3:0] bcd_msb, bcd_lsb;
    five_bit_bcd bcd_converter (
        .bin(time_left),
        .x(bcd_lsb),
        .y(bcd_msb)
    );
    
    // Timer counter
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            time_left <= 5'd30;  // 30 seconds as a 5-bit value
            timer_done <= 0;
            time_MSB <= 4'd3;    // Initialize MSB to 3 for 30
            time_LSB <= 4'd0;    // Initialize LSB to 0
        end
        else if (enable && one_sec_pulse) begin
            if (time_left > 0) begin
                time_left <= time_left - 1;
                // Update BCD outputs
                time_MSB <= bcd_msb;
                time_LSB <= bcd_lsb;
            end
            
            if (time_left == 1)  // Will be 0 next cycle
                timer_done <= 1;
        end
    end
endmodule