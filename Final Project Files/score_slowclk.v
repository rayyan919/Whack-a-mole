 
 module ScoreClockDivider(
    input clk,               // Input clock (fast clock from FPGA, e.g., 100 MHz)
    input reset,             // Reset signal
    output reg slow_clk      // Output slower clock
);
    reg [31:0] counter = 0;  // 32-bit counter

    parameter DIV_FACTOR = 9990000; // Adjust to desired frequency (e.g., 1 Hz if clk = 100 MHz)

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
