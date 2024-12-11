

module start_screen
	(
    input wire clk, reset,
    output wire hsync, vsync,
     output wire [3:0] red,
    output wire [3:0] green,
    output wire [3:0] blue
	);
	
	// video status output from vga_sync to tell when to route out rgb signal to DAC
	wire video_on;
    wire [9:0] x,y; //Pixel location
    // instantiate vga_sync for the monitor sync and x,y pixel tracing
    vga_sync vga_sync_unit (.clk(clk), .reset(reset), .hsync(hsync), .vsync(vsync), .video_on(video_on), .x(x), .y(y));

    //READ MEMORY FILE FOR INPUT ASCII ARRAY, CREATE SIGNAL ARRAY                       
    wire [6:0] ascii;  //Signal is concatenated with X coordinate to get a value for the ROM address                 
    wire [6:0] a[14:0]; //Each index of this array holds a 7-bit ASCII value
    wire d[34:0]; //Each index of this array holds a signal that says whether the i-th item in array a above should display
    wire displayContents; //Control signal to determine whether a character should be displayed on the screen

    assign a[0] = 7'd87;  // ASCII for 'W'
    assign a[1] = 7'd72;  // ASCII for 'H'
    assign a[2] = 7'd65;  // ASCII for 'A'
    assign a[3] = 7'd67;  // ASCII for 'C'
    assign a[4] = 7'd75;  // ASCII for 'K'
    assign a[5] = 7'd32;  // ASCII for ' '
    assign a[6] = 7'd77;  // ASCII for 'M'
    assign a[7] = 7'd79;  // ASCII for 'O'
    assign a[8] = 7'd76;  // ASCII for 'L'
    assign a[9] = 7'd69;  // ASCII for 'E'
    assign a[10]= 7'd80;  // ASCII for 'P'
    assign a[11]= 7'd82;  // ASCII for 'R'
    assign a[12]= 7'd83;  // ASCII for 'S'
    assign a[13]= 7'd84;  // ASCII for 'T'
    assign a[14]= 7'd66;  // ASCII for 'B'

    // WHACK A MOLE - Centered at y=240, starting at x=256
    textGeneration c0 (.clk(clk), .reset(reset), .ascii_In(7'h57),
    .x(x), .y(y), .displayContents(d[0]), .x_desired(10'd256), .y_desired(10'd240));
    
    textGeneration c1 (.clk(clk), .reset(reset), .ascii_In(7'h48),
    .x(x), .y(y), .displayContents(d[1]), .x_desired(10'd264), .y_desired(10'd240));
    
    textGeneration c2 (.clk(clk), .reset(reset), .ascii_In(7'h41),
    .x(x), .y(y), .displayContents(d[2]), .x_desired(10'd272), .y_desired(10'd240));
    
    textGeneration c3 (.clk(clk), .reset(reset), .ascii_In(7'h43),
    .x(x), .y(y), .displayContents(d[3]), .x_desired(10'd280), .y_desired(10'd240));
    
    textGeneration c4 (.clk(clk), .reset(reset), .ascii_In(7'h4B),
    .x(x), .y(y), .displayContents(d[4]), .x_desired(10'd288), .y_desired(10'd240));
    
    textGeneration c5 (.clk(clk), .reset(reset), .ascii_In(7'h20),
    .x(x), .y(y), .displayContents(d[5]), .x_desired(10'd296), .y_desired(10'd240));
    
    textGeneration c6 (.clk(clk), .reset(reset), .ascii_In(7'h41),
    .x(x), .y(y), .displayContents(d[6]), .x_desired(10'd304), .y_desired(10'd240));
    
    textGeneration c7 (.clk(clk), .reset(reset), .ascii_In(7'h20),
    .x(x), .y(y), .displayContents(d[7]), .x_desired(10'd312), .y_desired(10'd240));
    
    textGeneration c8 (.clk(clk), .reset(reset), .ascii_In(7'H4D),
    .x(x), .y(y), .displayContents(d[8]), .x_desired(10'd320), .y_desired(10'd240));
    
    textGeneration c9 (.clk(clk), .reset(reset), .ascii_In(7'h4F),
    .x(x), .y(y), .displayContents(d[9]), .x_desired(10'd328), .y_desired(10'd240));
    
    textGeneration c10 (.clk(clk), .reset(reset), .ascii_In(7'h4C),
    .x(x), .y(y), .displayContents(d[10]), .x_desired(10'd336), .y_desired(10'd240));
    
    textGeneration c11 (.clk(clk), .reset(reset), .ascii_In(7'h45),
    .x(x), .y(y), .displayContents(d[11]), .x_desired(10'd344), .y_desired(10'd240));

    // PRESS SPACEBAR TO START - Centered at y=300, starting at x=208
    textGeneration c12 (.clk(clk), .reset(reset), .ascii_In(7'h50),
    .x(x), .y(y), .displayContents(d[12]), .x_desired(10'd208), .y_desired(10'd300));
    
    textGeneration c13 (.clk(clk), .reset(reset), .ascii_In(7'h52),
    .x(x), .y(y), .displayContents(d[13]), .x_desired(10'd216), .y_desired(10'd300));
    
    textGeneration c14 (.clk(clk), .reset(reset), .ascii_In(7'h45),
    .x(x), .y(y), .displayContents(d[14]), .x_desired(10'd224), .y_desired(10'd300));
    
    textGeneration c15 (.clk(clk), .reset(reset), .ascii_In(7'h53),
    .x(x), .y(y), .displayContents(d[15]), .x_desired(10'd232), .y_desired(10'd300));
    
    textGeneration c16 (.clk(clk), .reset(reset), .ascii_In(7'h53),
    .x(x), .y(y), .displayContents(d[16]), .x_desired(10'd240), .y_desired(10'd300));
    
    textGeneration c17 (.clk(clk), .reset(reset), .ascii_In(7'h20),
    .x(x), .y(y), .displayContents(d[17]), .x_desired(10'd248), .y_desired(10'd300));
    
    textGeneration c18 (.clk(clk), .reset(reset), .ascii_In(7'h53),
    .x(x), .y(y), .displayContents(d[18]), .x_desired(10'd256), .y_desired(10'd300));
    
    textGeneration c19 (.clk(clk), .reset(reset), .ascii_In(7'h50),
    .x(x), .y(y), .displayContents(d[19]), .x_desired(10'd264), .y_desired(10'd300));
    
    textGeneration c20 (.clk(clk), .reset(reset), .ascii_In(7'h41),
    .x(x), .y(y), .displayContents(d[20]), .x_desired(10'd272), .y_desired(10'd300));
    
    textGeneration c21 (.clk(clk), .reset(reset), .ascii_In(7'h43),
    .x(x), .y(y), .displayContents(d[21]), .x_desired(10'd280), .y_desired(10'd300));
    
    textGeneration c22 (.clk(clk), .reset(reset), .ascii_In(7'h45),
    .x(x), .y(y), .displayContents(d[22]), .x_desired(10'd288), .y_desired(10'd300));
    
    textGeneration c23 (.clk(clk), .reset(reset), .ascii_In(7'h42),
    .x(x), .y(y), .displayContents(d[23]), .x_desired(10'd296), .y_desired(10'd300));
    
    textGeneration c24 (.clk(clk), .reset(reset), .ascii_In(7'h41),
    .x(x), .y(y), .displayContents(d[24]), .x_desired(10'd304), .y_desired(10'd300));
    
    textGeneration c25 (.clk(clk), .reset(reset), .ascii_In(7'h52),
    .x(x), .y(y), .displayContents(d[25]), .x_desired(10'd312), .y_desired(10'd300));
    
    textGeneration c26 (.clk(clk), .reset(reset), .ascii_In(7'h20),
    .x(x), .y(y), .displayContents(d[26]), .x_desired(10'd320), .y_desired(10'd300));
    
    textGeneration c27 (.clk(clk), .reset(reset), .ascii_In(7'h54),
    .x(x), .y(y), .displayContents(d[27]), .x_desired(10'd328), .y_desired(10'd300));
    
    textGeneration c28 (.clk(clk), .reset(reset), .ascii_In(7'h4F),
    .x(x), .y(y), .displayContents(d[28]), .x_desired(10'd336), .y_desired(10'd300));
    
    textGeneration c29 (.clk(clk), .reset(reset), .ascii_In(7'h20),
    .x(x), .y(y), .displayContents(d[29]), .x_desired(10'd344), .y_desired(10'd300));
    
    textGeneration c30 (.clk(clk), .reset(reset), .ascii_In(7'h53),
    .x(x), .y(y), .displayContents(d[30]), .x_desired(10'd352), .y_desired(10'd300));
    
    textGeneration c31 (.clk(clk), .reset(reset), .ascii_In(7'h54),
    .x(x), .y(y), .displayContents(d[31]), .x_desired(10'd360), .y_desired(10'd300));
    
    textGeneration c32 (.clk(clk), .reset(reset), .ascii_In(7'h41),
    .x(x), .y(y), .displayContents(d[32]), .x_desired(10'd368), .y_desired(10'd300));
    
    textGeneration c33 (.clk(clk), .reset(reset), .ascii_In(7'h52),
    .x(x), .y(y), .displayContents(d[33]), .x_desired(10'd376), .y_desired(10'd300));
    
    textGeneration c34 (.clk(clk), .reset(reset), .ascii_In(7'h54),
    .x(x), .y(y), .displayContents(d[34]), .x_desired(10'd384), .y_desired(10'd300));

    // OR gate for displayContents
    assign displayContents = d[0] | d[1] | d[2] | d[3] | d[4] | d[5] | 
                           d[6] | d[7] | d[8] | d[9] | d[10] | d[11] |
                           d[12] | d[13] | d[14] | d[15] | d[16] | d[17] |
                           d[18] | d[19] | d[20] | d[21] | d[22] | d[23] |
                           d[24] | d[25] | d[26] | d[27] | d[28] | d[29] |
                           d[30] | d[31] | d[32] | d[33] | d[34];

    // ASCII decoder
    assign ascii = d[0] ? a[0] :      //W
                  d[1] ? a[1] :       //H
                  d[2] ? a[2] :       //A
                  d[3] ? a[3] :       //C
                  d[4] ? a[4] :       //K
                  d[5] ? a[5] :       //
                  d[6] ? a[2] :       //A
                  d[7] ? a[5] :       //
                  d[8] ? a[6] :       //M
                  d[9] ? a[7] :       //O
                  d[10] ? a[8] :      //L
                  d[11] ? a[9] :      //E
                  d[12] ? a[10] :     //P
                  d[13] ? a[11] :     //R
                  d[14] ? a[9] :      //E
                  d[15] ? a[12] :     //S
                  d[16] ? a[12] :     //S
                  d[17] ? a[5] :      //
                  d[18] ? a[12] :     //S
                  d[19] ? a[10] :     //P
                  d[20] ? a[2] :      //A
                  d[21] ? a[3] :      //C
                  d[22] ? a[9] :      //E
                  d[23] ? a[14] :     //B
                  d[24] ? a[2] :      //A
                  d[25] ? a[11] :     //R
                  d[26] ? a[5] :      //
                  d[27] ? a[13] :     //T
                  d[28] ? a[7] :      //O
                  d[29] ? a[5] :      //
                  d[30] ? a[12] :     //S
                  d[31] ? a[13] :     //T
                  d[32] ? a[2] :      //A
                  d[33] ? a[11] :     //R
                  d[34] ? a[13] : 7'h31;  //T
 
    // ASCII ROM connections
    wire [10:0] rom_addr;
    wire [3:0] rom_row;
    wire [2:0] rom_col;
    wire [7:0] rom_data;
    wire rom_bit;
   
    ascii_rom rom1(.clk(clk), .rom_addr(rom_addr), .data(rom_data));

    //Concatenate to get 11 bit rom_addr
    assign rom_row = y[3:0];
    assign rom_addr = {ascii, rom_row};
    assign rom_col = x[2:0];
    assign rom_bit = rom_data[~rom_col]; //need to negate since it initially displays mirrored
    
//    assign rgb = (video_on && displayContents) ? 12'hFFF : 12'h000;  // White for active pixel, else black
    assign {red, green, blue} = video_on ? 
    (rom_bit ? 
        (displayContents ? {4'hF, 4'hF, 4'hF} : {4'h0, 4'h8, 4'h0}) 
        : {4'h0, 4'h0, 4'h8}) 
    : {4'h0, 4'h0, 4'h0};
   // assign rgb = video_on ? (rom_bit ? ((displayContents) ? 12'hFFF: 12'h8): 12'h8) : 12'b0; //blue background white text
endmodule
