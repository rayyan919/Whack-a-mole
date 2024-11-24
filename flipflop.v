module flipflop(
    input clk,        // Clock input
    input x,          // Input x
    input y,          // Input y
    output reg [2:0]state     // State bit A

);

    // Intermediate wires for next state logic
    wire [2:0]next_A;
//    wire A;
//    wire B;
//    wire C;
    
//    assign A=next_A[2];
//    assign B=next_A[1];
//    assign C=next_A[0];
    
//    wire next_B;
//    wire next_C;

//    // Next-state equations
//    assign next_A[2] = (~B & C & ~x) | (B & ~C & ~x &y) | (B & C & x & y);
//    assign next_A[1] = (A & ~y) | (B & C & ~x) | (~A & ~B & x & y) | (~A & ~C & ~x & y);
//    assign next_A[0] = (~C & x & y) | (B & ~C & y) | (~B & ~C & ~x & ~y) | (B&C&~y);

    // Next-state equations using current state
    assign next_A[2] = (~state[1] & state[0] & ~x) | (state[1] & ~state[0] & ~x & y) | (state[1] & state[0] & x & y);
    assign next_A[1] = (state[2] & ~y) | (state[1] & state[0] & ~x) | (~state[2] & ~state[1] & x & y) | (~state[2] & ~state[0] & ~x & y);
    assign next_A[0] = (~state[0] & x & y) | (state[1] & ~state[0] & y) | (~state[1] & ~state[0] & ~x & ~y) | (state[1] & state[0] & ~y);


//    // Update state on every clock edge
//    always @(posedge clk) begin
//        state[2] <= next_A[2];
//        state[1] <= next_A[1];
//        state[0] <= next_A[0];
//    end
        always @(posedge clk) begin
        state <= next_A;  // Directly update state from next_A
    end


endmodule
