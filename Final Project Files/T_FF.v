module T_FlipFlop (
    input wire T,        // Toggle input
    input wire clk,      // Clock input
    input wire reset,    // Asynchronous reset
    output reg Q         // Flip-flop output
);

always @(posedge clk or posedge reset) begin
    if (reset) 
        Q <= 1'b0;       // Reset the flip-flop to 0
    else 
        Q <= (T&~Q)|(~T&Q);         // T_FF Equation -> if T=0 state remains same else changes
  
end
endmodule
