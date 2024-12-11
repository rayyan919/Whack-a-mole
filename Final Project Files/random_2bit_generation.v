module two_bit_generation(
    input clk,             // Clock input
    output reg [1:0] out   // 2-bit output
);

    always @(posedge clk) begin
       out <= out+ 2'b11;
       if (out < 2'b11) begin // Max score of 15
                out <= out + 2'b01;  // Increment score
        end else begin
         out <= 2'b00;
        end

      
    end

endmodule
