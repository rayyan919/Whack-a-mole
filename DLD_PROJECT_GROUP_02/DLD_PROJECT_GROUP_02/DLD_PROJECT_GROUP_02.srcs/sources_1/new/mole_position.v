module Mole_Position(

    input [2:0] state,  // 3-bit state input
    output reg LD0,     // LED 0
    output reg LD1,     // LED 1
    output reg LD2,     // LED 2
    output reg LD3,     // LED 3
    output reg LD4      // LED 4
);

    always @(*) begin
        // Default all LEDs off
        LD0 = 0;
        LD1 = 0;
        LD2 = 0;
        LD3 = 0;
        LD4 = 0;

        // Turn on the appropriate LED based on state
        case (state)
            3'b000: LD0 = 1;  // State 000
            3'b001: LD1 = 1;  // State 001
            3'b010: LD2 = 1;  // State 010
            3'b011: LD3 = 1;  // State 011
            3'b100: LD4 = 1;  // State 100
            default: ;        // Other states keep LEDs off
        endcase
    end

endmodule


