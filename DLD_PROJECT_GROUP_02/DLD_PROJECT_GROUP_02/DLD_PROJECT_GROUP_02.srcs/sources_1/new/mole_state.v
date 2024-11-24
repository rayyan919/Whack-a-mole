module mole_state(
    input clk,           // Clock input
    output [4:0] LEDs ,   // LEDs for states 000, 001, 010, 011, 100
    output [2:0]mole_current_state
);

    wire [1:0] increment_out;  // Output of increment_by_3
    wire [2:0] state_out;      // Output of flipflop_state
     wire slow_clk;
     
    ClockDivider clk_div(
    .clk(clk),          // Fast clock from FPGA
    .reset(1'b0),       // No reset
    .slow_clk(slow_clk) // Slower clock output
);
    
    // Instantiate increment_by_3 module
    random_2bit_generation r1 (
        .clk(slow_clk),
        .out(increment_out)
    );

    // Instantiate flipflop_state module
    flipflop ffs (
        .clk(slow_clk),
        .x(increment_out[1]),  // MSB of incremented 2-bit number
        .y(increment_out[0]),  // LSB of incremented 2-bit number
        .state(state_out)
    );
    
    assign mole_current_state = state_out;

    // Instantiate MOLE_LED module
    Mole_Position mole (
        .state(state_out),
        .LD0(LEDs[0]),
        .LD1(LEDs[1]),
        .LD2(LEDs[2]),
        .LD3(LEDs[3]),
        .LD4(LEDs[4])
    );

endmodule
