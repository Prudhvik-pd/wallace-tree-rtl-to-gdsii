`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.06.2026 08:31:36
// Design Name: 
// Module Name: partial_products_generator
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


module partial_products_generator(
input wire [7:0] A,B,
output wire [63:0]PPG
 );
 //PARTIAL PRODUCTS GENERATION (PPG)
// ----------------------------------------------------------------------------
// Generates the 64 partial products 
// The results are captured into the 64-bit 'ppg_reg' on the clock edge.
assign PPG[7:0] = B[0] ? A : 8'd0; // if B[i]  = 0 ; it always gives 0 because anything multiply with zero is zero
assign PPG[15:8] = B[1] ? A : 8'd0; // if B[i] = 1; it always gives what ever value we mutliplied 
assign PPG[23:16] = B[2] ? A : 8'd0;// so we using ternary operator 
assign PPG[31:24] = B[3] ? A : 8'd0;
assign PPG[39:32] = B[4] ? A : 8'd0;
assign PPG[47:40] = B[5] ? A : 8'd0;
assign PPG[55:48] = B[6] ? A : 8'd0;
assign PPG[63:56] = B[7] ? A : 8'd0;
 
endmodule
