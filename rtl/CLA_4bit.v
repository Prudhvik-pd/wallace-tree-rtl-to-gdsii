`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.06.2026 13:10:01
// Design Name: 
// Module Name: CLA_4bit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module CLA_4bit(
input wire [3:0]A,
input wire [3:0]B,
input wire cin,
output wire [3:0]SUM,
output wire cout
    );
    
   wire [3:0] P,G;
   wire  [4:0]C;
   
   // Step1:Calculate Propagate and Generate
    assign P = A ^ B;
    assign G= A & B;
    
    // Step2:The Lookahead Carry Equations
  assign C[0] = cin;
 assign C[1] = G[0] | (P[0] & C[0]);
  assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
 assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    
    // The final carry out of this 4-bit block
 assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) |
     (P[3] & P[2] & P[1] & P[0] & C[0]);

    // Step 3: Calculate the Sum
assign SUM = P ^ C[3:0];
 assign cout = C[4];
    
endmodule
