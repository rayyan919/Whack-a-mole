module win_screen
      (
            input wire clk, reset,
            output wire hsync, vsync,
             output wire [3:0] red,
    output wire [3:0] green,
    output wire [3:0] blue
      );
       wire [11:0] rgb;
      
      // video status output from vga_sync to tell when to route out rgb signal to DAC
      wire video_on;
    wire [9:0] x,y; //Pixel location
    // instantiate vga_sync for the monitor sync and x,y pixel tracing
    vga_sync vga_sync_unit (.clk(clk), .reset(reset), .hsync(hsync), .vsync(vsync), .video_on(video_on), .x(x), .y(y));

    //READ MEMORY FILE FOR INPUT ASCII ARRAY, CREATE SIGNAL ARRAY                      
    wire [6:0] ascii;  //Signal is concatenated with X coordinate to get a value for the ROM address                
    wire [6:0] a[7:0]; //Each index of this array holds a 7-bit ASCII value
    wire d[7:0]; //Each index of this array holds a signal that says whether the i-th item in array a above should display
    wire displayContents; //Control signal to determine whether a character should be displayed on the screen

    assign a[0] = 7'h47;  // ASCII for 'G'
    assign a[1] = 7'h41;  // ASCII for 'A'
    assign a[2] = 7'h4D;  // ASCII for 'M'
    assign a[3] = 7'h45;  // ASCII for 'E'
    assign a[4] = 7'h20;  // ASCII for ' '
    assign a[5] = 7'h57;  // ASCII for 'W'
    assign a[6] = 7'h49;  // ASCII for 'I'
    assign a[7] = 7'h4E;  // ASCII for 'N'
    

    // WHACK A MOLE - Centered at y=240, starting at x=256
    textGeneration c0 (.clk(clk), .reset(reset), .ascii_In(7'h47),
    .x(x), .y(y), .displayContents(d[0]), .x_desired(10'd256), .y_desired(10'd240));
   
    textGeneration c1 (.clk(clk), .reset(reset), .ascii_In(7'h41),
    .x(x), .y(y), .displayContents(d[1]), .x_desired(10'd264), .y_desired(10'd240));
   
    textGeneration c2 (.clk(clk), .reset(reset), .ascii_In(7'h4D),
    .x(x), .y(y), .displayContents(d[2]), .x_desired(10'd272), .y_desired(10'd240));
   
    textGeneration c3 (.clk(clk), .reset(reset), .ascii_In(7'h45),
    .x(x), .y(y), .displayContents(d[3]), .x_desired(10'd280), .y_desired(10'd240));
   
    textGeneration c4 (.clk(clk), .reset(reset), .ascii_In(7'h20),
    .x(x), .y(y), .displayContents(d[4]), .x_desired(10'd288), .y_desired(10'd240));
   
    textGeneration c5 (.clk(clk), .reset(reset), .ascii_In(7'h57),
    .x(x), .y(y), .displayContents(d[5]), .x_desired(10'd296), .y_desired(10'd240));
   
    textGeneration c6 (.clk(clk), .reset(reset), .ascii_In(7'h49),
    .x(x), .y(y), .displayContents(d[6]), .x_desired(10'd304), .y_desired(10'd240));
   
    textGeneration c7 (.clk(clk), .reset(reset), .ascii_In(7'h4E),
    .x(x), .y(y), .displayContents(d[7]), .x_desired(10'd312), .y_desired(10'd240));
   
    
    // OR gate for displayContents
    assign displayContents = d[0] | d[1] | d[2] | d[3] | d[4] | d[5] |
                           d[6] | d[7] ;

    // ASCII decoder
    assign ascii = d[0] ? a[0] :      //G
                  d[1] ? a[1] :       //A
                  d[2] ? a[2] :       //M
                  d[3] ? a[3] :       //E
                  d[4] ? a[4] :       //
                  d[5] ? a[5] :       //W
                  d[6] ? a[6] :       //I
                  d[7] ? a[7] :       //N
                               7'h31;  
 
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
   
assign rgb = (video_on && displayContents) ? 12'hFFF : 12'h000;  // White for active pixel, else black

   // assign rgb = video_on ? (rom_bit ? ((displayContents) ? 12'hFFF: 12'h8): 12'h8) : 12'b0; //blue background white text

  assign red[0]=rgb[4];
    assign red[1]=rgb[5];
    assign red[2]=rgb[6];
    assign red[3]=rgb[7];
   
    assign blue[0]=rgb[8];
    assign blue[0]=rgb[9];
    assign blue[0]=rgb[10];
    assign blue[0]=rgb[11];
   
    assign green[0]=rgb[0];
    assign green[1]=rgb[1];
    assign green[2]=rgb[2];
    assign green[3]=rgb[3];
endmodule