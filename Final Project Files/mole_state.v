module mole_state(
    input clk,         
    output [2:0]mole_current_state
);

    wire [1:0] X;  // Output of random 2bit
//    wire [2:0] s;      // Output of flipflop_state

    
   //  Instantiate increment_by_3 module
    random_2bit_generation r1 (
        .clk(clk),
        .out(X)
    );

//    // Instantiate flipflop_state module
//    flipflop ffs (
//        .clk(clk),
//        .x(increment_out[1]),  // MSB of incremented 2-bit number
//        .y(increment_out[0]),  // LSB of incremented 2-bit number
//        .state(state_out)
//    );
    
  
    
    wire [2:0] S; //STATE
    wire TA, TB;
    

    //TIMER 0 is y , missed 3 is z
    // State transitions using keyboard input
    assign TS2 = (X[0] & S[1]) | (X[0] & S[2]) | (X[1] & ~S[0]) | (~X[1] & S[1] & S[0]) | (~X[1] & S[2] & S[0]) | (X[1] & ~X[0] & ~S[2] & ~S[1]) ;
    assign TS1 = (S[1] & S[0]) | (X[0] & ~S[2]) | (X[0] & S[0]) | (X[1] & ~X[0]) | (~X[1] & ~S[2] & S[0]);
    assign TS0 = (~X[0] & ~S[0]) | (~X[1] & ~X[0] & ~S[2]) | (~X[1] & ~S[1] & ~S[0]) | (X[0] & ~S[2] & ~S[1]) | (X[1] & ~X[0] & S[2]);

    // T Flip-Flops
    T_FlipFlop tff1 (TS2, clk, key_esc, S[2]);
    T_FlipFlop tff2 (TS1, clk, key_esc, S[1]);
    T_FlipFlop tff3 (TS0, clk, key_esc, S[0]);
    
      assign mole_current_state = S;

endmodule
