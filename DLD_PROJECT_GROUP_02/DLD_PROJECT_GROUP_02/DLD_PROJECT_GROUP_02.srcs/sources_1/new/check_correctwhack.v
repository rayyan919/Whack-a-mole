//module pushbutton_with_logic(
//    input clk,
//    input [2:0] mole,  // 3-bit input
//    input pushbutton_1,      // Push button 1
//    input pushbutton_2,      // Push button 2
//    input pushbutton_3,      // Push button 3
//    input pushbutton_4,      // Push button 4
//    input pushbutton_5,
//    output reg output_signal // Output signal
//);
//    always @(*) begin
//        // Default output is 0
//        output_signal = 0;

//        // Conditions for each push button and input_bits value
//        if (pushbutton_1 && (mole == 3'b000))
//            output_signal = 1;
//        else if (pushbutton_2 && (mole == 3'b001))
//            output_signal = 1;
//        else if (pushbutton_3 && (mole == 3'b010))
//            output_signal = 1;
//        else if (pushbutton_4 && (mole == 3'b011))
//            output_signal = 1;
//        else if (pushbutton_5 && (mole == 3'b100))
//            output_signal = 1;
           
//    end
//endmodule


module pushbutton_with_logic(
    input clk,                 // System clock
    input [2:0] mole_pos,    // 3-bit input
    input wire pushbutton_1,        // Raw push button 1 input
    input wire pushbutton_2,        // Raw push button 2 input
    input wire pushbutton_3,        // Raw push button 3 input
    input wire pushbutton_4,        // Raw push button 4 input
    input wire pushbutton_5,
    output reg output_signal   // Final output signal
);

    // Wires for debounced push button signals
   // wire clean_1, clean_2, clean_3, clean_4, clean_5;
   // wire pushbutton_1,  pushbutton_2, pushbutton_3, pushbutton_4, pushbutton_5,

//debounce_better_version(input pb_1, clk, output pb_out);

//    // Instantiate debounce modules for each push button
//    debounce_better_version debounce_1(.clk(clk), .pb_1(pushbutton_1), .pb_out(pushbutton_1));
//    debounce_better_version debounce_2(.clk(clk), .pb_1(pushbutton_2), .pb_out(pushbutton_2));
//    debounce_better_version debounce_3(.clk(clk), .pb_1(pushbutton_3), .pb_out(pushbutton_3));
//    debounce_better_version debounce_4(.clk(clk), .pb_1(pushbutton_4), .pb_out(pushbutton_4));
//    debounce_better_version debounce_5(.clk(clk), .pb_1(pushbutton_5), .pb_out(pushbutton_5));

    // Main logic to determine output signal
    always @(*) begin
        // Default output is 0
        output_signal = 0;

//        // Output 1 when specific push button is pressed and input matches
//        if (clean_1 && (input_bits == 3'b000))
//            output_signal = 1;
//        else if (clean_2 && (input_bits == 3'b001))
//            output_signal = 1;
//        else if (clean_3 && (input_bits == 3'b010))
//            output_signal = 1;
//        else if (clean_4 && (input_bits == 3'b011))
//            output_signal = 1;
//        else if (clean_5 && (input_bits == 3'b100))
//            output_signal = 1;


        // Output 1 when specific push button is pressed and input matches
        if (pushbutton_1 && (mole_pos == 3'b000))
            output_signal = 1;
        else if (pushbutton_2 && (mole_pos == 3'b001))
            output_signal = 1;
        else if (pushbutton_3 && (mole_pos == 3'b010))
            output_signal = 1;
        else if (pushbutton_4 && (mole_pos == 3'b011))
            output_signal = 1;
        else if (pushbutton_5 && (mole_pos == 3'b100))
            output_signal = 1;
            
    end

endmodule



