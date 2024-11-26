`timescale 1ns / 1ps 



module game_timer (
    input wire clk,
    input wire rst,
    input wire enable,
    input wire pause,
    output reg [7:0] time_MSB_ascii,
    output reg [7:0] time_LSB_ascii,
    output reg timer_done
);
    reg [4:0] time_left;
    reg counting;
   
    // Hardcoded ASCII conversion logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            time_left <= 5'd31;
            timer_done <= 0;
            time_MSB_ascii <= 8'h33;    // ASCII '3'
            time_LSB_ascii <= 8'h31;    // ASCII '1'
            counting <= 1;
        end
        else if (pause) begin
            counting <= 0;
        end
        else if (!pause && enable && counting) begin
            if (time_left > 0) begin
                time_left <= time_left - 1;
               
                // Hardcoded conversion based on time_left
                case (time_left - 1)  // Using time_left - 1 since this is the next value
                    // 31-30: MSB='3', LSB='1','0'
                    31: begin time_MSB_ascii <= 8'h33; time_LSB_ascii <= 8'h31; end
                    30: begin time_MSB_ascii <= 8'h33; time_LSB_ascii <= 8'h30; end
                   
                    // 29-20: MSB='2', LSB='9'-'0'
                    29: begin time_MSB_ascii <= 8'h32; time_LSB_ascii <= 8'h39; end
                    28: begin time_MSB_ascii <= 8'h32; time_LSB_ascii <= 8'h38; end
                    27: begin time_MSB_ascii <= 8'h32; time_LSB_ascii <= 8'h37; end
                    26: begin time_MSB_ascii <= 8'h32; time_LSB_ascii <= 8'h36; end
                    25: begin time_MSB_ascii <= 8'h32; time_LSB_ascii <= 8'h35; end
                    24: begin time_MSB_ascii <= 8'h32; time_LSB_ascii <= 8'h34; end
                    23: begin time_MSB_ascii <= 8'h32; time_LSB_ascii <= 8'h33; end
                    22: begin time_MSB_ascii <= 8'h32; time_LSB_ascii <= 8'h32; end
                    21: begin time_MSB_ascii <= 8'h32; time_LSB_ascii <= 8'h31; end
                    20: begin time_MSB_ascii <= 8'h32; time_LSB_ascii <= 8'h30; end
                   
                    // 19-10: MSB='1', LSB='9'-'0'
                    19: begin time_MSB_ascii <= 8'h31; time_LSB_ascii <= 8'h39; end
                    18: begin time_MSB_ascii <= 8'h31; time_LSB_ascii <= 8'h38; end
                    17: begin time_MSB_ascii <= 8'h31; time_LSB_ascii <= 8'h37; end
                    16: begin time_MSB_ascii <= 8'h31; time_LSB_ascii <= 8'h36; end
                    15: begin time_MSB_ascii <= 8'h31; time_LSB_ascii <= 8'h35; end
                    14: begin time_MSB_ascii <= 8'h31; time_LSB_ascii <= 8'h34; end
                    13: begin time_MSB_ascii <= 8'h31; time_LSB_ascii <= 8'h33; end
                    12: begin time_MSB_ascii <= 8'h31; time_LSB_ascii <= 8'h32; end
                    11: begin time_MSB_ascii <= 8'h31; time_LSB_ascii <= 8'h31; end
                    10: begin time_MSB_ascii <= 8'h31; time_LSB_ascii <= 8'h30; end
                   
                    // 9-0: MSB='0', LSB='9'-'0'
                    9: begin time_MSB_ascii <= 8'h30; time_LSB_ascii <= 8'h39; end
                    8: begin time_MSB_ascii <= 8'h30; time_LSB_ascii <= 8'h38; end
                    7: begin time_MSB_ascii <= 8'h30; time_LSB_ascii <= 8'h37; end
                    6: begin time_MSB_ascii <= 8'h30; time_LSB_ascii <= 8'h36; end
                    5: begin time_MSB_ascii <= 8'h30; time_LSB_ascii <= 8'h35; end
                    4: begin time_MSB_ascii <= 8'h30; time_LSB_ascii <= 8'h34; end
                    3: begin time_MSB_ascii <= 8'h30; time_LSB_ascii <= 8'h33; end
                    2: begin time_MSB_ascii <= 8'h30; time_LSB_ascii <= 8'h32; end
                    1: begin time_MSB_ascii <= 8'h30; time_LSB_ascii <= 8'h31; end
                    0: begin time_MSB_ascii <= 8'h30; time_LSB_ascii <= 8'h30; end
                   
                    // Default case
                    default: begin
                        time_MSB_ascii <= 8'h30;
                        time_LSB_ascii <= 8'h30;
                    end
                endcase
            end
           
            if (time_left == 1) begin
                timer_done <= 1;
            end
        end
        else if (!pause && !counting) begin
            counting <= 1;
        end
    end
endmodule

module score_display (
    input wire clk,
    input wire rst,
    input wire [3:0] score,
    output reg [7:0] score_MSB_ascii,
    output reg [7:0] score_LSB_ascii
);
    // ASCII Conversion Logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            score_MSB_ascii <= 8'h30; // ASCII '0'
            score_LSB_ascii <= 8'h30; // ASCII '0'
        end
        else begin
            case (score)
                4'd0: begin score_MSB_ascii <= 8'h30; score_LSB_ascii <= 8'h30; end // "00"
                4'd1: begin score_MSB_ascii <= 8'h30; score_LSB_ascii <= 8'h31; end // "01"
                4'd2: begin score_MSB_ascii <= 8'h30; score_LSB_ascii <= 8'h32; end // "02"
                4'd3: begin score_MSB_ascii <= 8'h30; score_LSB_ascii <= 8'h33; end // "03"
                4'd4: begin score_MSB_ascii <= 8'h30; score_LSB_ascii <= 8'h34; end // "04"
                4'd5: begin score_MSB_ascii <= 8'h30; score_LSB_ascii <= 8'h35; end // "05"
                4'd6: begin score_MSB_ascii <= 8'h30; score_LSB_ascii <= 8'h36; end // "06"
                4'd7: begin score_MSB_ascii <= 8'h30; score_LSB_ascii <= 8'h37; end // "07"
                4'd8: begin score_MSB_ascii <= 8'h30; score_LSB_ascii <= 8'h38; end // "08"
                4'd9: begin score_MSB_ascii <= 8'h30; score_LSB_ascii <= 8'h39; end // "09"
                4'd10: begin score_MSB_ascii <= 8'h31; score_LSB_ascii <= 8'h30; end // "10"
                4'd11: begin score_MSB_ascii <= 8'h31; score_LSB_ascii <= 8'h31; end // "11"
                4'd12: begin score_MSB_ascii <= 8'h31; score_LSB_ascii <= 8'h32; end // "12"
                4'd13: begin score_MSB_ascii <= 8'h31; score_LSB_ascii <= 8'h33; end // "13"
                4'd14: begin score_MSB_ascii <= 8'h31; score_LSB_ascii <= 8'h34; end // "14"
                4'd15: begin score_MSB_ascii <= 8'h31; score_LSB_ascii <= 8'h35; end // "15"
                default: begin score_MSB_ascii <= 8'h30; score_LSB_ascii <= 8'h30; end // Default "00"
            endcase
        end
    end
endmodule
