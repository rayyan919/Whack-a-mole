module mole_state(
    input clk,         
    output [2:0]mole_current_state
);

    wire [1:0] X;  // Output of random 2bit
    
   //  Instantiate increment_by_3 module
    two_bit_generation r1 (
        .clk(clk),
        .out(X)
    );
    
    wire [2:0] S; //MOLE STATE
    wire TS1, TS2, TS0;
    
    // Mole state transitions using 2 bit input
    assign TS2 = (X[0] & S[1]) | (X[0] & S[2]) | (X[1] & ~S[0]) | (~X[1] & S[1] & S[0]) | (~X[1] & S[2] & S[0]) | (X[1] & ~X[0] & ~S[2] & ~S[1]) ;
    assign TS1 = (S[1] & S[0]) | (X[0] & ~S[2]) | (X[0] & S[0]) | (X[1] & ~X[0]) | (~X[1] & ~S[2] & S[0]);
    assign TS0 = (~X[0] & ~S[0]) | (~X[1] & ~X[0] & ~S[2]) | (~X[1] & ~S[1] & ~S[0]) | (X[0] & ~S[2] & ~S[1]) | (X[1] & ~X[0] & S[2]);

    // T Flip-Flops
    T_FlipFlop tff1 (TS2, clk, key_esc, S[2]);
    T_FlipFlop tff2 (TS1, clk, key_esc, S[1]);
    T_FlipFlop tff3 (TS0, clk, key_esc, S[0]);
    
    assign mole_current_state = S;

endmodule
