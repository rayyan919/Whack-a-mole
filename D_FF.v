//module D_FF (
//    input wire clk,      // Clock input
//       // Synchronous reset
//    input wire d,        // Data input
//    output reg q    ,     // Data output
//     output reg qnot
//);
 
    
//    always @(posedge clk) begin
//        if (d) 
//            qnot <= ~d;   // Reset the output to 0
//        else 
//            q <= d;      // Store the data input on the rising edge of clk
//    end

//endmodule
module D_FF (
    input wire clk,    // Clock input
    input wire d,      // Data input
    output reg q=0,      // Data output
    output reg qnot=1    // Complement of data output
);
    always @(posedge clk) begin
        q <= d;          // Update q on the rising edge of the clock
        qnot <= ~d;      // Complement q
    end
endmodule
