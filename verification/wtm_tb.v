`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.06.2026 07:53:12
// Design Name: 
// Module Name: wtm_tb
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


module wtm_tb;
reg clk;
reg rst;
reg [7:0]A;
reg [7:0]B;
wire [15:0]OUT;


wallace_tree wlt(
.clk(clk),
.rst(rst),
.A(A),
.B(B),
.OUT(OUT)
);

initial clk = 0;
always #5 clk = ~clk;

initial begin 
 rst =0;
 A=0;
 B=0; // both values zeros test case
 #20;
 rst = 1;
 #10;
 A = 8'd5;
 B = 8'd10;
 #10;
 A = 8'd16;
 B = 8'd20;
 #10;
 A = 8'd7;
 B = 8'd10;
 #10;// after 3 cycles checking the values are they getting correct -----------
  if (OUT == 16'd50) $display(" 5 x 10 = %d    ---pass",OUT);
  else $display ("fail:%d",OUT);
 A = 8'd255;
 B = 8'd255;// max value test case
 #10;
  if (OUT == 16'd320) $display("16 x 20 = %d    ---pass",OUT);
 else $display ("fail:%d",OUT);
 #10;
 if (OUT == 16'd70) $display("7 x 10 = %d     ---pass",OUT);
 else $display ("fail:%d",OUT);
 #10;
 if (OUT == 16'd65025) $display(" 255x255 = %d  ---pass",OUT);
 else $display ("fail:%d",OUT);
 
#20 $finish;
end


    
endmodule
