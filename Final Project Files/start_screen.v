module start_screen
    (
        input wire clk, reset,
        input  wire [6:0] score_MSB, score_LSB,
        output wire hsync, vsync,
        output wire [3:0] red,
        output wire [3:0] green,
        output wire [3:0] blue
    );

    // VGA Signals
    wire video_on;
    wire [9:0] x, y;
    
    // Display Signals
    wire [6:0] ascii; 
    wire d[30:0];  // Enough elements for both text lines
    wire displayContents;

    // Instantiate VGA Sync Module
    vga_sync vga_sync_unit (
        .clk(clk),
        .reset(reset),
        .hsync(hsync),
        .vsync(vsync),
        .video_on(video_on),
        .x(x),
        .y(y)
    );

    // Define ASCII codes
    localparam [6:0] W = 7'h57, H = 7'h48, A = 7'h41, C = 7'h43, 
                     K = 7'h4B, M = 7'h4D, O = 7'h4F, L = 7'h4C, 
                     E = 7'h45, EX = 7'h21, SP = 7'h20, 
                     P = 7'h50, R = 7'h52, S = 7'h53, T = 7'h54;

    // Character position (center of the screen)
    wire [9:0] x_desired[30:0];
    wire [9:0] y_desired[3:0];
    
    // "WHACK" line
    assign x_desired[0] = 10'd288;  // W
    assign x_desired[1] = 10'd296;  // H
    assign x_desired[2] = 10'd304;  // A
    assign x_desired[3] = 10'd312;  // C
    assign x_desired[4] = 10'd320;  // K

    // "A" line
    assign x_desired[5] = 10'd304;  // A

    // "MOLE!" line
    assign x_desired[6] = 10'd296;  // M
    assign x_desired[7] = 10'd304;  // O
    assign x_desired[8] = 10'd312;  // L
    assign x_desired[9] = 10'd320;  // E
    assign x_desired[10] = 10'd328; // !

    // "PRESS SPACE TO START" line
    assign x_desired[11] = 10'd256;  // P
    assign x_desired[12] = 10'd264;  // R
    assign x_desired[13] = 10'd272;  // E
    assign x_desired[14] = 10'd280;  // S
    assign x_desired[15] = 10'd288;  // S
    assign x_desired[16] = 10'd296;  // SP
    assign x_desired[17] = 10'd304;  // S
    assign x_desired[18] = 10'd312;  // P
    assign x_desired[19] = 10'd320;  // A
    assign x_desired[20] = 10'd328;  // C
    assign x_desired[21] = 10'd336;  // E
    assign x_desired[22] = 10'd344;  //SP
    assign x_desired[23] = 10'd352;  // T
    assign x_desired[24] = 10'd360;  // O
    assign x_desired[25] = 10'd368;  // SP
    assign x_desired[26] = 10'd384;  // S
    assign x_desired[27] = 10'd392;  // T
    assign x_desired[28] = 10'd400;  // A
    assign x_desired[29] = 10'd408;  // R
    assign x_desired[30] = 10'd416;  // T

    // Vertical positioning - ensuring multiples of 16
    assign y_desired[0] = 10'd144;  // First "WHACK" line
    assign y_desired[1] = 10'd160; //Second "A" line
    assign y_desired[2] = 10'd176; //Third "MOLE1" line
    assign y_desired[3] = 10'd256;  // "PRESS" line

    // Active characters
    wire [6:0] asc[30:0];
    assign asc[0] = W;   // "WHACK" first line
    assign asc[1] = H;
    assign asc[2] = A;
    assign asc[3] = C;
    assign asc[4] = K;
    assign asc[5] = A;   // Standalone A
    assign asc[6] = M;   // "MOLE!" line
    assign asc[7] = O;
    assign asc[8] = L;
    assign asc[9] = E;
    assign asc[10] = EX;
    assign asc[11] = P;  // "PRESS SPACE TO START"
    assign asc[12] = R;
    assign asc[13] = E;
    assign asc[14] = S;
    assign asc[15] = S;
    assign asc[16] = SP;
    assign asc[17] = S;
    assign asc[18] = P;
    assign asc[19] = A;
    assign asc[20] = C;
    assign asc[21] = E;
    assign asc[22] = SP;
    assign asc[23] = T;
    assign asc[24] = O;
    assign asc[25] = SP;
    assign asc[26] = S;
    assign asc[27] = T;
    assign asc[28] = A;
    assign asc[29] = R;
    assign asc[30] = T;

    // Generate text instances for first line (WHACK)
    textGeneration t0 (.clk(clk), .reset(reset), .ascii_In(asc[0]),
        .x(x), .y(y), .displayContents(d[0]), .x_desired(x_desired[0]), .y_desired(y_desired[0]));
    textGeneration t1 (.clk(clk), .reset(reset), .ascii_In(asc[1]),
        .x(x), .y(y), .displayContents(d[1]), .x_desired(x_desired[1]), .y_desired(y_desired[0]));
    textGeneration t2 (.clk(clk), .reset(reset), .ascii_In(asc[2]),
        .x(x), .y(y), .displayContents(d[2]), .x_desired(x_desired[2]), .y_desired(y_desired[0]));
    textGeneration t3 (.clk(clk), .reset(reset), .ascii_In(asc[3]),
        .x(x), .y(y), .displayContents(d[3]), .x_desired(x_desired[3]), .y_desired(y_desired[0]));
    textGeneration t4 (.clk(clk), .reset(reset), .ascii_In(asc[4]),
        .x(x), .y(y), .displayContents(d[4]), .x_desired(x_desired[4]), .y_desired(y_desired[0]));

    // Standalone A
    textGeneration t5 (.clk(clk), .reset(reset), .ascii_In(asc[5]),
        .x(x), .y(y), .displayContents(d[5]), .x_desired(x_desired[5]), .y_desired(y_desired[1]));

    // "MOLE!" line
    textGeneration t6 (.clk(clk), .reset(reset), .ascii_In(asc[6]),
        .x(x), .y(y), .displayContents(d[6]), .x_desired(x_desired[6]), .y_desired(y_desired[2]));
    textGeneration t7 (.clk(clk), .reset(reset), .ascii_In(asc[7]),
        .x(x), .y(y), .displayContents(d[7]), .x_desired(x_desired[7]), .y_desired(y_desired[2]));
    textGeneration t8 (.clk(clk), .reset(reset), .ascii_In(asc[8]),
        .x(x), .y(y), .displayContents(d[8]), .x_desired(x_desired[8]), .y_desired(y_desired[2]));
    textGeneration t9 (.clk(clk), .reset(reset), .ascii_In(asc[9]),
        .x(x), .y(y), .displayContents(d[9]), .x_desired(x_desired[9]), .y_desired(y_desired[2]));
    textGeneration t10 (.clk(clk), .reset(reset), .ascii_In(asc[10]),
        .x(x), .y(y), .displayContents(d[10]), .x_desired(x_desired[10]), .y_desired(y_desired[2]));

    // "PRESS SPACE TO START" line
    textGeneration t11 (.clk(clk), .reset(reset), .ascii_In(asc[11]),
        .x(x), .y(y), .displayContents(d[11]), .x_desired(x_desired[11]), .y_desired(y_desired[3]));

    textGeneration t12 (.clk(clk), .reset(reset), .ascii_In(asc[12]),
        .x(x), .y(y), .displayContents(d[12]), .x_desired(x_desired[12]), .y_desired(y_desired[3]));

    textGeneration t13 (.clk(clk), .reset(reset), .ascii_In(asc[13]),
        .x(x), .y(y), .displayContents(d[13]), .x_desired(x_desired[13]), .y_desired(y_desired[3]));

    textGeneration t14 (.clk(clk), .reset(reset), .ascii_In(asc[14]),
        .x(x), .y(y), .displayContents(d[14]), .x_desired(x_desired[14]), .y_desired(y_desired[3]));

    textGeneration t15 (.clk(clk), .reset(reset), .ascii_In(asc[15]),
        .x(x), .y(y), .displayContents(d[15]), .x_desired(x_desired[15]), .y_desired(y_desired[3]));

    textGeneration t16 (.clk(clk), .reset(reset), .ascii_In(asc[16]),
        .x(x), .y(y), .displayContents(d[16]), .x_desired(x_desired[16]), .y_desired(y_desired[3]));

    textGeneration t17 (.clk(clk), .reset(reset), .ascii_In(asc[17]),
        .x(x), .y(y), .displayContents(d[17]), .x_desired(x_desired[17]), .y_desired(y_desired[3]));

    textGeneration t18 (.clk(clk), .reset(reset), .ascii_In(asc[18]),
        .x(x), .y(y), .displayContents(d[18]), .x_desired(x_desired[18]), .y_desired(y_desired[3]));

    textGeneration t19 (.clk(clk), .reset(reset), .ascii_In(asc[19]),
        .x(x), .y(y), .displayContents(d[19]), .x_desired(x_desired[19]), .y_desired(y_desired[3]));

    textGeneration t20 (.clk(clk), .reset(reset), .ascii_In(asc[20]),
        .x(x), .y(y), .displayContents(d[20]), .x_desired(x_desired[20]), .y_desired(y_desired[3]));

    textGeneration t21 (.clk(clk), .reset(reset), .ascii_In(asc[21]),
        .x(x), .y(y), .displayContents(d[21]), .x_desired(x_desired[21]), .y_desired(y_desired[3]));

    textGeneration t22 (.clk(clk), .reset(reset), .ascii_In(asc[22]),
        .x(x), .y(y), .displayContents(d[22]), .x_desired(x_desired[22]), .y_desired(y_desired[3]));

    textGeneration t23 (.clk(clk), .reset(reset), .ascii_In(asc[23]),
        .x(x), .y(y), .displayContents(d[23]), .x_desired(x_desired[23]), .y_desired(y_desired[3]));

    textGeneration t24 (.clk(clk), .reset(reset), .ascii_In(asc[24]),
        .x(x), .y(y), .displayContents(d[24]), .x_desired(x_desired[24]), .y_desired(y_desired[3]));

    textGeneration t25 (.clk(clk), .reset(reset), .ascii_In(asc[25]),
        .x(x), .y(y), .displayContents(d[25]), .x_desired(x_desired[25]), .y_desired(y_desired[3]));

    textGeneration t26 (.clk(clk), .reset(reset), .ascii_In(asc[26]),
        .x(x), .y(y), .displayContents(d[26]), .x_desired(x_desired[26]), .y_desired(y_desired[3]));

    textGeneration t27 (.clk(clk), .reset(reset), .ascii_In(asc[27]),
        .x(x), .y(y), .displayContents(d[27]), .x_desired(x_desired[27]), .y_desired(y_desired[3]));

    textGeneration t28 (.clk(clk), .reset(reset), .ascii_In(asc[28]),
        .x(x), .y(y), .displayContents(d[28]), .x_desired(x_desired[28]), .y_desired(y_desired[3]));

    textGeneration t29 (.clk(clk), .reset(reset), .ascii_In(asc[29]),
        .x(x), .y(y), .displayContents(d[29]), .x_desired(x_desired[29]), .y_desired(y_desired[3]));

    textGeneration t30 (.clk(clk), .reset(reset), .ascii_In(asc[30]),
        .x(x), .y(y), .displayContents(d[30]), .x_desired(x_desired[30]), .y_desired(y_desired[3]));


    // Combine display contents
    assign displayContents = d[0] | d[1] | d[2] | d[3] | d[4] | 
                             d[5] | d[6] | d[7] | d[8] | d[9] | d[10] |
                             d[11] | d[12] | d[13] | d[14] | d[15] | d[16] | d[17]
                             | d[18] | d[19] | d[20] | d[21] | d[22] | d[23] | d[24] | d[25]
                             | d[26] | d[27] | d[28] | d[29] | d[30];


    // ASCII decoder                        
    assign ascii = d[0] ? asc[0] :
                   d[1] ? asc[1] :
                   d[2] ? asc[2] :
                   d[3] ? asc[3] :
                   d[4] ? asc[4] :
                   d[5] ? asc[5] :
                   d[6] ? asc[6] :
                   d[7] ? asc[7] :
                   d[8] ? asc[8] :
                   d[9] ? asc[9] :
                   d[10] ? asc[10] :
                   d[11] ? asc[11] :
                   d[12] ? asc[12] :
                   d[13] ? asc[13] :
                   d[14] ? asc[14] :
                   d[15] ? asc[15] :
                   d[16] ? asc[16] :
                   d[17] ? asc[17] :
                   d[18] ? asc[18] :
                   d[19] ? asc[19] :
                   d[20] ? asc[20] :
                   d[21] ? asc[21] :
                   d[22] ? asc[22] :
                   d[23] ? asc[23] :
                   d[24] ? asc[24] :
                   d[25] ? asc[25] :
                   d[26] ? asc[26] :
                   d[27] ? asc[27] :
                   d[28] ? asc[28] :
                   d[29] ? asc[29] :
                   d[30] ? asc[30] :

                   7'h20;  // Space (default)
        
    // ROM connections
    wire [10:0] rom_addr;
    wire [3:0] rom_row;
    wire [2:0] rom_col;
    wire [7:0] rom_data;
    wire rom_bit;
    
    ascii_rom rom2(.clk(clk), .rom_addr(rom_addr), .data(rom_data));
    
    // ROM address calculation
    assign rom_row = y[3:0];
    assign rom_addr = {ascii, rom_row};
    assign rom_col = x[2:0];
    assign rom_bit = rom_data[~rom_col];
    
    // RGB output
    assign {red, green, blue} = video_on ? 
    (rom_bit ? 
        (displayContents ? {4'hF, 4'hF, 4'hF} : {4'h0, 4'h8, 4'h0}) 
        : {4'h0, 4'h0, 4'h8}) 
    : {4'h0, 4'h0, 4'h0};

endmodule