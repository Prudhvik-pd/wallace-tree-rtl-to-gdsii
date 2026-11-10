`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.06.2026 08:11:10
// Design Name: 
// Module Name: full_adder
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


module full_adder(
input wire A,B,C,
output wire SUM,CARRY
);

assign SUM = A ^ B ^ C ;  // sum = A xor B xor C
assign CARRY = (A&B) | (B&C) | (C&A); // carry = A*B + B*C + C*A



endmodule
