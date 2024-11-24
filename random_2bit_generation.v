module random_2bit_generation(
    input clk,             // Clock input
    output reg [1:0] out   // 2-bit output
);

    always @(posedge clk) begin
       out <= out+ 2'b11;
      //  out <= (out + 3) % 4;  // Increment by 3 and wrap around to stay within 2-bit range
    end

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2024 05:13:37 PM
// Design Name: 
// Module Name: random_hole_gen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


//module random_hole_gen (
//    input clk,          // System clock
//    input reset,        // Reset signal
//    output reg [2:0] hole // 3-bit output representing the active hole (0 to 4)
//);

//    reg [3:0] lfsr; // 4-bit LFSR for pseudorandom generation

//    always @(posedge clk or posedge reset) begin
//        if (reset) begin
//            lfsr <= 4'b0001; // Initialize LFSR
//        end else begin
//            // Feedback from LFSR taps
//            lfsr <= {lfsr[2:0], lfsr[3] ^ lfsr[2]};
//        end
//    end

//    // Map LFSR output to 0-4
//    always @(*) begin
//        hole = lfsr % 5; // Limit the range to 0-4
//    end
//endmodule

