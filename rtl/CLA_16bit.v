`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.06.2026 13:22:18
// Design Name: 
// Module Name: CLA_16bit
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


module CLA_16bit(
input wire [15:0]A,
input wire [15:0]B,
input wire cin,
output wire [15:0]SUM,
output wire cout

    );
    
    wire c4,c8,c12;
    
  CLA_4bit cla0(
  .A(A[3:0]),
  .B(B[3:0]),
  .cin(cin),
  .SUM(SUM[3:0]),
  .cout(c4)
  );
   CLA_4bit cla1(
  .A(A[7:4]),
  .B(B[7:4]),
  .cin(c4),
  .SUM(SUM[7:4]),
  .cout(c8)
  );
   CLA_4bit cla2(
  .A(A[11:8]),
  .B(B[11:8]),
  .cin(c8),
  .SUM(SUM[11:8]),
  .cout(c12)
  );
   CLA_4bit cla3(
  .A(A[15:12]),
  .B(B[15:12]),
  .cin(c12),
  .SUM(SUM[15:12]),
  .cout(cout)
  );
  
endmodule
