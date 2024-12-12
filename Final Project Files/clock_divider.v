module ClockDivider(
    input clk,               // Input clock (fast clock from FPGA, e.g., 100 MHz)
    input reset,             // Reset signal
    output reg slow_clk      // Output slower clock
);
    reg [31:0] counter = 0;  // 32-bit counter

// Adjust to 0.75 seconds
 parameter DIV_FACTOR = 37500000;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            slow_clk <= 0;
        end else if (counter == (DIV_FACTOR)) begin
            counter <= 0;
            slow_clk <= ~slow_clk;  // Toggle slow clock
        end else begin
            counter <= counter + 1;
        end
    end
endmodule
