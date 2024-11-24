`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////


module four_bit_bcd(
input [3:0] bin,
output [3:0] x, 
output [3:0]y

    );
    wire A, B,C,D; 
    
    assign A=bin[3];
    assign B=bin[2];
    assign C=bin[1];
    assign D=bin[0];
    
    assign x[3]= (A&~B&~C);
    assign x[2]= (B&C)|(~A&B); 
    assign x[1]= (~A&C)|(A&B&~C); 
    assign x[0] = D;
    
    assign y[3]= 0;
    assign y[2]= 0;
    assign y[1]= 0;
    assign y[0]= (A&C)|(A&B);
    
        
    
endmodule


module five_bit_bcd(
input [4:0] bin,
output [3:0] x, 
output [3:0]y

    );
    wire A, B,C,D,E; 
    
    assign A=bin[4];
    assign B=bin[3];
    assign C=bin[2];
    assign D=bin[1];
    assign E= bin[0];
    
    assign x[3]= (~A&B&~C&D)|(A&~B&~C&D)|(A&B&C&~D);
    assign x[2]= (~A&~B&C)|(~A&C&D)|(A&~C&~B)|(A&B&~C); 
    assign x[1]= (~A&~B&D)|(~B&C&D)|(~A&B&C&D)|(A&~B&~C&~D)|(A&B&~C&D); 
    assign x[0] = E;
    
    assign y[3]= 0;
    assign y[2]= 0;
    assign y[1]= (A&C)|(A&B);
    assign y[0]= (~A&B&D)|(~A&B&C)|(B&C&D)|(A&~B&~C);
    
        
    
endmodule

