module win_screen
    (
        input wire clk, reset,
//        input  wire [6:0] score_MSB, score_LSB,
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
    wire d[8:0];  // Changed to 8 elements for "GAME WIN!"
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

    // Define "GAME WIN!" ASCII codes
    localparam [6:0] G = 7'h47, A = 7'h41, M = 7'h4D, E = 7'h45, 
                     W = 7'h57, I = 7'h49, N = 7'h4E, EX = 7'h21, SP = 7'h20;

    // Character position (center of the screen)
    // For 640x480 display, center around x=320
    wire [9:0] x_desired[8:0];
    wire [9:0] y_desired;
    
    // Center the text - starting from x=272 to include space
    assign x_desired[0] = 10'd272;  // G
    assign x_desired[1] = 10'd280;  // A
    assign x_desired[2] = 10'd288;  // M
    assign x_desired[3] = 10'd296;  // E
    assign x_desired[4] = 10'd304;  // Space
    assign x_desired[5] = 10'd320;  // W
    assign x_desired[6] = 10'd328;  // I
    assign x_desired[7] = 10'd336;  // N
    assign x_desired[8] = 10'd344; //!
    assign y_desired = 10'd240;     // Vertical center

    // Active characters - add explicit space
    wire [6:0] asc[8:0];
    assign asc[0] = G;
    assign asc[1] = A;
    assign asc[2] = M;
    assign asc[3] = E;
    assign asc[4] = SP;  // Space
    assign asc[5] = W;
    assign asc[6] = I;
    assign asc[7] = N;
    assign asc[8] = EX;

    // Generate text instances
    textGeneration t0 (.clk(clk), .reset(reset), .ascii_In(asc[0]),
        .x(x), .y(y), .displayContents(d[0]), .x_desired(x_desired[0]), .y_desired(y_desired));
                                                                                       
    textGeneration t1 (.clk(clk), .reset(reset), .ascii_In(asc[1]),
        .x(x), .y(y), .displayContents(d[1]), .x_desired(x_desired[1]), .y_desired(y_desired));
        
    textGeneration t2 (.clk(clk), .reset(reset), .ascii_In(asc[2]),
        .x(x), .y(y), .displayContents(d[2]), .x_desired(x_desired[2]), .y_desired(y_desired));
        
    textGeneration t3 (.clk(clk), .reset(reset), .ascii_In(asc[3]),
        .x(x), .y(y), .displayContents(d[3]), .x_desired(x_desired[3]), .y_desired(y_desired));
        
    textGeneration t4 (.clk(clk), .reset(reset), .ascii_In(asc[4]),
        .x(x), .y(y), .displayContents(d[4]), .x_desired(x_desired[4]), .y_desired(y_desired));
        
    textGeneration t5 (.clk(clk), .reset(reset), .ascii_In(asc[5]),
        .x(x), .y(y), .displayContents(d[5]), .x_desired(x_desired[5]), .y_desired(y_desired));
        
    textGeneration t6 (.clk(clk), .reset(reset), .ascii_In(asc[6]),
        .x(x), .y(y), .displayContents(d[6]), .x_desired(x_desired[6]), .y_desired(y_desired));

    textGeneration t7 (.clk(clk), .reset(reset), .ascii_In(asc[7]),
        .x(x), .y(y), .displayContents(d[7]), .x_desired(x_desired[7]), .y_desired(y_desired));
    
    textGeneration t8 (.clk(clk), .reset(reset), .ascii_In(asc[8]),
        .x(x), .y(y), .displayContents(d[8]), .x_desired(x_desired[8]), .y_desired(y_desired));
        
    assign displayContents = d[0] | d[1] | d[2] | d[3] | d[4] | d[5] | 
                           d[6] | d[7] | d[8];

    // ASCII decoder                        
    assign ascii = d[0] ? asc[0] :    // G
                  d[1] ? asc[1] :    // A
                  d[2] ? asc[2] :    // M
                  d[3] ? asc[3] :    // E
                  d[4] ? asc[4] :    // Space
                  d[5] ? asc[5] :    // W
                  d[6] ? asc[6] :    // I
                  d[7] ? asc[7] :    // N
                  d[8] ? asc[8] :    //!
                  7'h20;             // Space (default)
        
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