// Debouncer module
module debouncer(
    input clk,
    input I,
    output reg O
);
    parameter COUNT_MAX=255, COUNT_WIDTH=8;
    reg [COUNT_WIDTH-1:0] count;
    reg Iv=0;
    
    always@(posedge clk)
        if (I == Iv) begin
            if (count == COUNT_MAX)
                O <= I;
            else
                count <= count + 1'b1;
        end else begin
            count <= 'b0;
            Iv <= I;
        end
endmodule

// PS2 Receiver module
module PS2Receiver(
    input clk,
    input kclk,
    input kdata,
    output reg [15:0] keycode=0,
    output reg oflag
);
    wire kclkf, kdataf;
    reg [7:0] datacur=0;
    reg [7:0] dataprev=0;
    reg [3:0] cnt=0;
    reg flag=0;
    
    debouncer #(
        .COUNT_MAX(19),
        .COUNT_WIDTH(5)
    ) db_clk(
        .clk(clk),
        .I(kclk),
        .O(kclkf)
    );
    
    debouncer #(
        .COUNT_MAX(19),
        .COUNT_WIDTH(5)
    ) db_data(
        .clk(clk),
        .I(kdata),
        .O(kdataf)
    );
    
    always@(negedge(kclkf))begin
        case(cnt)
            0:;//Start bit
            1:datacur[0]<=kdataf;
            2:datacur[1]<=kdataf;
            3:datacur[2]<=kdataf;
            4:datacur[3]<=kdataf;
            5:datacur[4]<=kdataf;
            6:datacur[5]<=kdataf;
            7:datacur[6]<=kdataf;
            8:datacur[7]<=kdataf;
            9:flag<=1'b1;
            10:flag<=1'b0;
        endcase
        if(cnt<=9) cnt<=cnt+1;
        else if(cnt==10) cnt<=0;
    end

    reg pflag;
    always@(posedge clk) begin
        if (flag == 1'b1 && pflag == 1'b0) begin
            keycode <= {dataprev, datacur};
            oflag <= 1'b1;
            dataprev <= datacur;
        end else
            oflag <= 'b0;
        pflag <= flag;
    end
endmodule

// Main Keyboard Module
module keyboard(
    input CLK,
    input PS2_CLK,
    input PS2_DATA,
    output reg A,    // 1 when A is pressed, 0 otherwise
    output reg B,    // 1 when W is pressed, 0 otherwise (W maps to B)
    output reg C,    // 1 when D is pressed, 0 otherwise (D maps to C)
    output reg D,    // 1 when X is pressed, 0 otherwise (X maps to D)
    output reg E,    // 1 when S is pressed, 0 otherwise (S maps to E)
    output reg spacebar,
    output reg esc
);
    // PS/2 scan codes for the keys we're interested in
    parameter [7:0] CODE_W     = 8'h1D;  // Maps to B
    parameter [7:0] CODE_A     = 8'h1C;  // Maps to A
    parameter [7:0] CODE_S     = 8'h1B;  // Maps to E
    parameter [7:0] CODE_D     = 8'h23;  // Maps to C
    parameter [7:0] CODE_X     = 8'h22;  // Maps to D
    parameter [7:0] CODE_SPACE = 8'h29;
    parameter [7:0] CODE_ESC   = 8'h76;
    parameter [7:0] CODE_BREAK = 8'hF0;

    // Internal signals
    wire [15:0] keycode;
    wire oflag;

    // Instantiate the PS2 receiver
    PS2Receiver ps2_rx (
        .clk(CLK),
        .kclk(PS2_CLK),
        .kdata(PS2_DATA),
        .keycode(keycode),
        .oflag(oflag)
    );

    // Key processing logic
    always @(posedge CLK) begin
        if (oflag) begin
            // Check if it's a break code (key release)
            if (keycode[15:8] == CODE_BREAK) begin
                case (keycode[7:0])
                    CODE_W: B <= 1'b0;     // W maps to B
                    CODE_A: A <= 1'b0;     // A maps to A
                    CODE_S: E <= 1'b0;     // S maps to E
                    CODE_D: C <= 1'b0;     // D maps to C
                    CODE_X: D <= 1'b0;     // X maps to D
                    CODE_SPACE: spacebar <= 1'b0;
                    CODE_ESC: esc <= 1'b0;
                endcase
            end
            // Check if it's a make code (key press)
            else if (keycode[15:8] != CODE_BREAK && keycode[7:0] != CODE_BREAK) begin
                case (keycode[7:0])
                    CODE_W: B <= 1'b1;     // W maps to B
                    CODE_A: A <= 1'b1;     // A maps to A
                    CODE_S: E <= 1'b1;     // S maps to E
                    CODE_D: C <= 1'b1;     // D maps to C
                    CODE_X: D <= 1'b1;     // X maps to D
                    CODE_SPACE: spacebar <= 1'b1;
                    CODE_ESC: esc <= 1'b1;
                endcase
            end
        end
    end

    // Initialize all outputs to 0
    initial begin
        A <= 1'b0;
        B <= 1'b0;
        C <= 1'b0;
        D <= 1'b0;
        E <= 1'b0;
        spacebar <= 1'b0;
        esc <= 1'b0;
    end

endmodule