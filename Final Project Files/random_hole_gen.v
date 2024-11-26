module random_hole_gen (
    input clk,    // System clock
    input reset,        // Reset signal
    output reg [2:0] hole // 3-bit output representing the active hole (0 to 4)
);

    reg [3:0] lfsr; // 4-bit LFSR for pseudorandom generation

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr <= 4'b0001; // Initialize LFSR
        end else begin
            // Feedback from LFSR taps
            lfsr <= {lfsr[2:0], lfsr[3] ^ lfsr[2]};
        end
    end

    // Map LFSR output to 0-4
    always @(*) begin
        hole = lfsr % 5 + 1; // Limit the range to 0-4
    end
endmodule