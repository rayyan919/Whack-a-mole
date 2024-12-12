

module game_timer (
    input wire clk,
    input wire rst,
    input wire enable,
    input wire pause,
    output reg [6:0] time_MSB_ascii,
    output reg [6:0] time_LSB_ascii,
    output reg timer_done
);
    // State encoding using standard parameters
    parameter IDLE = 2'b00;
    parameter RUNNING = 2'b01;
    parameter PAUSED = 2'b10;
    parameter DONE = 2'b11;

    // State and timer variables
    reg [1:0] current_state, next_state;
    reg [4:0] time_left;

    // Combinational logic for next state and outputs
    always @(*) begin
        // Default assignments
        next_state = current_state;
        timer_done = 1'b0;

        case (current_state)
            IDLE: begin
                // Move to RUNNING when enabled
                if (enable) begin
                    next_state = RUNNING;
                end
            end

            RUNNING: begin
                // Pause logic
                if (pause) begin
                    next_state = PAUSED;
                end
                // Timer completion logic
                else if (time_left == 5'd1) begin
                    next_state = DONE;
                end
            end

            PAUSED: begin
                // Resume or stay paused
                if (!pause && enable) begin
                    next_state = RUNNING;
                end
            end

            DONE: begin
                // Stay in DONE state until reset
                timer_done = 1'b1;
            end
        endcase
    end

    // Sequential logic for state and timer updates
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset to initial state
            current_state <= IDLE;
            time_left <= 5'd31;
            time_MSB_ascii <= 8'h33;  // ASCII '3'
            time_LSB_ascii <= 8'h31;  // ASCII '1'
        end
        else begin
            // State transition
            current_state <= next_state;

            // Timer logic for RUNNING state
            if (current_state == RUNNING) begin
                if (time_left > 5'd1) begin
                    time_left <= time_left - 1;

                    // ASCII conversion logic
                    case (time_left - 1)
                        5'd31: begin time_MSB_ascii <= 8'h33; time_LSB_ascii <= 8'h31; end
                        5'd30: begin time_MSB_ascii <= 8'h33; time_LSB_ascii <= 8'h30; end
                        5'd29: begin time_MSB_ascii <= 8'h32; time_LSB_ascii <= 8'h39; end
                        5'd28: begin time_MSB_ascii <= 8'h32; time_LSB_ascii <= 8'h38; end
                        5'd27: begin time_MSB_ascii <= 8'h32; time_LSB_ascii <= 8'h37; end
                        5'd26: begin time_MSB_ascii <= 8'h32; time_LSB_ascii <= 8'h36; end
                        5'd25: begin time_MSB_ascii <= 8'h32; time_LSB_ascii <= 8'h35; end
                        5'd24: begin time_MSB_ascii <= 8'h32; time_LSB_ascii <= 8'h34; end
                        5'd23: begin time_MSB_ascii <= 8'h32; time_LSB_ascii <= 8'h33; end
                        5'd22: begin time_MSB_ascii <= 8'h32; time_LSB_ascii <= 8'h32; end
                        5'd21: begin time_MSB_ascii <= 8'h32; time_LSB_ascii <= 8'h31; end
                        5'd20: begin time_MSB_ascii <= 8'h32; time_LSB_ascii <= 8'h30; end
                        5'd19: begin time_MSB_ascii <= 8'h31; time_LSB_ascii <= 8'h39; end
                        5'd18: begin time_MSB_ascii <= 8'h31; time_LSB_ascii <= 8'h38; end
                        5'd17: begin time_MSB_ascii <= 8'h31; time_LSB_ascii <= 8'h37; end
                        5'd16: begin time_MSB_ascii <= 8'h31; time_LSB_ascii <= 8'h36; end
                        5'd15: begin time_MSB_ascii <= 8'h31; time_LSB_ascii <= 8'h35; end
                        5'd14: begin time_MSB_ascii <= 8'h31; time_LSB_ascii <= 8'h34; end
                        5'd13: begin time_MSB_ascii <= 8'h31; time_LSB_ascii <= 8'h33; end
                        5'd12: begin time_MSB_ascii <= 8'h31; time_LSB_ascii <= 8'h32; end
                        5'd11: begin time_MSB_ascii <= 8'h31; time_LSB_ascii <= 8'h31; end
                        5'd10: begin time_MSB_ascii <= 8'h31; time_LSB_ascii <= 8'h30; end
                        5'd9:  begin time_MSB_ascii <= 8'h30; time_LSB_ascii <= 8'h39; end
                        5'd8:  begin time_MSB_ascii <= 8'h30; time_LSB_ascii <= 8'h38; end
                        5'd7:  begin time_MSB_ascii <= 8'h30; time_LSB_ascii <= 8'h37; end
                        5'd6:  begin time_MSB_ascii <= 8'h30; time_LSB_ascii <= 8'h36; end
                        5'd5:  begin time_MSB_ascii <= 8'h30; time_LSB_ascii <= 8'h35; end
                        5'd4:  begin time_MSB_ascii <= 8'h30; time_LSB_ascii <= 8'h34; end
                        5'd3:  begin time_MSB_ascii <= 8'h30; time_LSB_ascii <= 8'h33; end
                        5'd2:  begin time_MSB_ascii <= 8'h30; time_LSB_ascii <= 8'h32; end
                        5'd1:  begin time_MSB_ascii <= 8'h30; time_LSB_ascii <= 8'h31; end
                        5'd0:  begin time_MSB_ascii <= 8'h30; time_LSB_ascii <= 8'h30; end
                        default: begin
                            time_MSB_ascii <= 8'h30;
                            time_LSB_ascii <= 8'h30;
                        end
                    endcase
                end
                else if (time_left == 5'd1) begin
                    // Last second
                    time_left <= 5'd0;
                    time_MSB_ascii <= 8'h30;
                    time_LSB_ascii <= 8'h30;
                end
            end
            // Maintain time_left and time_ascii values when PAUSED
            else if (current_state == PAUSED) begin
                // Explicitly maintain the current state when paused
                time_left <= time_left;
                // time_MSB_ascii and time_LSB_ascii remain unchanged
            end
        end
    end
endmodule

module score_display (
    input wire clk,
    input wire rst,
    input wire [3:0] score,
    output reg [6:0] score_MSB_ascii,
    output reg [6:0] score_LSB_ascii
);
    // Mealy FSM implementation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset to initial state
            score_MSB_ascii <= 8'h30;
            score_LSB_ascii <= 8'h30;
        end
        else begin
            // Mealy machine: outputs directly depend on current input and state
            case (score)
                4'd0: begin
                    score_MSB_ascii <= 8'h30;
                    score_LSB_ascii <= 8'h30;
                end
                4'd1: begin
                    score_MSB_ascii <= 8'h30;
                    score_LSB_ascii <= 8'h31;
                end
                4'd2: begin
                    score_MSB_ascii <= 8'h30;
                    score_LSB_ascii <= 8'h32;
                end
                4'd3: begin
                    score_MSB_ascii <= 8'h30;
                    score_LSB_ascii <= 8'h33;
                end
                4'd4: begin
                    score_MSB_ascii <= 8'h30;
                    score_LSB_ascii <= 8'h34;
                end
                4'd5: begin
                    score_MSB_ascii <= 8'h30;
                    score_LSB_ascii <= 8'h35;
                end
                4'd6: begin
                    score_MSB_ascii <= 8'h30;
                    score_LSB_ascii <= 8'h36;
                end
                4'd7: begin
                    score_MSB_ascii <= 8'h30;
                    score_LSB_ascii <= 8'h37;
                end
                4'd8: begin
                    score_MSB_ascii <= 8'h30;
                    score_LSB_ascii <= 8'h38;
                end
                4'd9: begin
                    score_MSB_ascii <= 8'h30;
                    score_LSB_ascii <= 8'h39;
                end
                4'd10: begin
                    score_MSB_ascii <= 8'h31;
                    score_LSB_ascii <= 8'h30;
                end
                4'd11: begin
                    score_MSB_ascii <= 8'h31;
                    score_LSB_ascii <= 8'h31;
                end
                4'd12: begin
                    score_MSB_ascii <= 8'h31;
                    score_LSB_ascii <= 8'h32;
                end
                4'd13: begin
                    score_MSB_ascii <= 8'h31;
                    score_LSB_ascii <= 8'h33;
                end
                4'd14: begin
                    score_MSB_ascii <= 8'h31;
                    score_LSB_ascii <= 8'h34;
                end
                4'd15: begin
                    score_MSB_ascii <= 8'h31;
                    score_LSB_ascii <= 8'h35;
                end
                default: begin
                    score_MSB_ascii <= 8'h30;
                    score_LSB_ascii <= 8'h30;
                end
            endcase
        end
    end
endmodule