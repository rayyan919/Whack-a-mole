////module score_correctwhack(
////    input wire clk,
////    //input fpause,
////    input wire key_esc,         // Reset signal
////    input wire key_space,       // Pause signal 
////    input [2:0] mole_pos,   // 3-bit mole position
////    input wire A,           // Button signals
////    input wire W,
////    input wire X,
////    input wire D,
////    input wire S,
////    output reg [3:0] score, // 4-bit score output
////    output reg game_lose
//////    output reg led          // Feedback LED
////);

////reg [1:0]loss;
////    // Generate `correct_whack` signal based on mole position and button press
////    wire correct_whack = ((~mole_pos[0] & mole_pos[1] & ~mole_pos[2] & A) |
////                          (mole_pos[0] & ~mole_pos[1] & ~mole_pos[2] & W) |
////                          (~mole_pos[0] & ~mole_pos[1] & mole_pos[2] & D) |
////                          (mole_pos[0] & ~mole_pos[1] & mole_pos[2] & X) |
////                          (mole_pos[0] & mole_pos[1] & ~mole_pos[2] & S));
                          
//////    reg key_pressed;

//////    reg [3:0] score;
////    // Score update logic
////    always @(posedge clk) begin
//////        key_pressed <= (A|S|W|D|X);
////         score <= score + correct_whack;  
////         loss <= loss + ~correct_whack;
         
////        if (key_esc) begin
////            score <= 4'b0000;  // Reset score
////            loss<=0;
////        end 
//////        else if (key_space)begin 
//////            score<=score;
//////        end
        
//////        else if (~fpause)begin
//////            if (key_pressed) begin 
////          //  key_pressed<=~key_pressed;
//////         score <= score + correct_whack;  
////////         loss <= loss + ~correct_whack;
//////            end
//////           else if (fpause) begin 
//////            loss<=loss;
//////            score<=score;
//////           end
////////        end

////         if (loss==2'b11)begin
////            game_lose<=1; 
////        end 
////    end
    
////endmodule


module score_correctwhack(
    input wire clk,
//    input G,
    input wire key_esc,         // Reset signal
    input wire key_space,       // Pause signal
//    input wire key_esc,  
    input [2:0] mole_pos,   // 3-bit mole position
    input wire A,           // Button signals
    input wire W,
    input wire X,
    input wire D,
    input wire S,
    output reg [3:0] score, // 4-bit score output
    output reg game_lose,
    output reg led          // Feedback LED
);
    reg  [1:0]loss;
    // Generate `correct_whack` signal based on mole position and button press
    wire correct_whack = ((~mole_pos[0] & mole_pos[1] & ~mole_pos[2] & A) |
                          (mole_pos[0] & ~mole_pos[1] & ~mole_pos[2] & W) |
                          (~mole_pos[0] & ~mole_pos[1] & mole_pos[2] & D) |
                          (mole_pos[0] & ~mole_pos[1] & mole_pos[2] & X) |
                          (mole_pos[0] & mole_pos[1] & ~mole_pos[2] & S));
                          
   // wire  key_pressed = (A|S|W|D|X);
   // wire losss= key_pressed & ~correct_whack;

   //  Score update logic
    always @(posedge clk) begin
        // key_pressed <= (A|S|W|D|X);
         //if (key_pressed) begin 
          score <= score + correct_whack;  // Increment score
         // loss <= loss + losss;
       //   end
          
         if (key_esc) begin
            score <= 4'b0000;  // Reset score

         end
         
            if (loss==2'b11)begin 
                game_lose<=1'b1;
            end
            
    end


endmodule


  
//module score_correctwhack(
//    input clk,
//    input key_esc,         // Reset signal
//    input key_space,       // Pause signal
//    input [2:0] mole_pos,   // 3-bit mole position
//    input A,           // Button signals
//    input W,
//    input X,
//    input  D,
//    input  S,
//    output reg [3:0] score, // 4-bit score output
//    output reg game_lose
////    output reg led          // Feedback LED
//);
//    reg  [1:0]loss;
//    // Generate `correct_whack` signal based on mole position and button press
//    wire correct_whack = ((~mole_pos[0] & mole_pos[1] & ~mole_pos[2] & A) |
//                          (mole_pos[0] & ~mole_pos[1] & ~mole_pos[2] & W) |
//                          (~mole_pos[0] & ~mole_pos[1] & mole_pos[2] & D) |
//                          (mole_pos[0] & ~mole_pos[1] & mole_pos[2] & X) |
//                          (mole_pos[0] & mole_pos[1] & ~mole_pos[2] & S));
                          
//   wire  key_pressed = (A|S|W|D|X);
//    wire losss= (key_pressed & ~correct_whack);

//   //  Score update logic
//    always @(posedge clk) begin
       
//          score <= score + correct_whack;  // Increment score
//          loss <= loss + losss;
    
          
//         if (key_esc) begin
//            score <= 4'b0000;  // Reset score

//         end
         
//            if (loss==2'b11)begin 
//                game_lose<=1'b1;
//            end         
//    end
//endmodule

