`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.06.2026 12:08:24
// Design Name: 
// Module Name: wallace_tree
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


module wallace_tree(
input wire clk,
input wire rst,
input wire [7:0] A, // input 1 - 8bit 
input wire [7:0] B,  // input 2- 8bit

output wire [15:0] OUT // output of  16bit (for 8x8 maximum bits it can proudce are 16 bits)

  );
  
  wire [63:0] ppg_wires;   // wires which are lies in between partial product generator and first stage pipeline registers
  
  partial_products_generator ppg (
  .A(A) , 
  .B(B) ,
  .PPG(ppg_wires)
  );
  
  reg [63:0] ppg_reg;
  always@(posedge clk) begin 
  if (!rst)begin    // active low reset
   ppg_reg <= 64'd0;  
  end
  else begin
    ppg_reg <= ppg_wires;  // connecting partial product generator and pipeline registers
    end
  end 
      
  // separating  the partial products into columns  fromm the stage 1 registers
  // column 0;
  wire col0;
  assign col0 = ppg_reg[0];
  // column 14;
  wire col14;
  assign col14 = ppg_reg[63];
  
 // column 1; 
  wire [1:0]col1;
  
  assign col1[0] = ppg_reg[1];
  assign col1[1] = ppg_reg[8];
   
  // column 13;
  wire [1:0]col13;
  
  assign col13[0] = ppg_reg[55];
  assign col13[1] = ppg_reg[62];
  
  
  
  // column 2
  wire [2:0]col2;
  assign col2[0]  = ppg_reg[2];
  assign col2[1]  = ppg_reg[9];
  assign col2[2]  = ppg_reg[16];
  
  // column 12
  wire [2:0]col12;
  assign col12[0]  = ppg_reg[47];
  assign col12[1]  = ppg_reg[54];
  assign col12[2]  = ppg_reg[61];
  
  // column 3;
  wire [3:0]col3;
  assign col3[0]  = ppg_reg[3];
  assign col3[1]  = ppg_reg[10];
  assign col3[2]  = ppg_reg[17];
  assign col3[3]  = ppg_reg[24];
  
  
  // column 4;
 wire [4:0]col4;
 assign col4[0]  = ppg_reg[4];
 assign col4[1]  = ppg_reg[11];assign col4[3]  = ppg_reg[25];
 assign col4[2]  = ppg_reg[18];assign col4[4]  = ppg_reg[32];
 
 // column 5; 
 wire [5:0]col5;
 assign col5[0]  = ppg_reg[5];assign col5[3]  = ppg_reg[26];
 assign col5[1]  = ppg_reg[12];assign col5[4]  = ppg_reg[33];
 assign col5[2]  = ppg_reg[19];assign col5[5]  = ppg_reg[40];
 
 // column 6;
 wire [6:0]col6;
 assign col6[0] = ppg_reg[6];assign col6[4] = ppg_reg[34];
 assign col6[1] = ppg_reg[13];assign col6[5] = ppg_reg[41];
 assign col6[2] = ppg_reg[20];assign col6[6] = ppg_reg[48];
 assign col6[3] = ppg_reg[27];
 
 // column 7;
 wire [7:0]col7;
 assign col7[0] = ppg_reg[7];assign col7[4] = ppg_reg[35];
 assign col7[1] = ppg_reg[14];assign col7[5] = ppg_reg[42];
 assign col7[2] = ppg_reg[21];assign col7[6] = ppg_reg[49];
 assign col7[3] = ppg_reg[28];assign col7[7] = ppg_reg[56];
 
 // column 8;
 wire [6:0]col8;
 assign col8[0] = ppg_reg[15];assign col8[4] = ppg_reg[43];
 assign col8[1] = ppg_reg[22];assign col8[5] = ppg_reg[50];
 assign col8[2] = ppg_reg[29];assign col8[6] = ppg_reg[57];
 assign col8[3] = ppg_reg[36];
 
 // column 9;
 wire [5:0]col9;
 assign col9 [0] = ppg_reg[23];assign col9 [3] = ppg_reg[44];
 assign col9 [1] = ppg_reg[30];assign col9 [4] = ppg_reg[51];
 assign col9 [2] = ppg_reg[37];assign col9 [5] = ppg_reg[58];
 
 // column 10;
 wire [4:0]col10;
 assign col10[0] = ppg_reg[31];assign col10[3] = ppg_reg[52];
 assign col10[1] = ppg_reg[38];assign col10[4] = ppg_reg[59];
 assign col10[2] = ppg_reg[45];
 
 // column 11;
 wire [3:0]col11;
 assign col11[0] = ppg_reg[39];assign col11[2] = ppg_reg[53];
 assign col11[1] = ppg_reg[46];assign col11[3] = ppg_reg[60];
 
 
 
 //---------------------------------------- stage1 redcution----------------//
 //    WALLACE TREE REDUCTION - PHASE 1
// ----------------------------------------------------------------------------
// Compresses the 64 partial products using the first layer of Half Adders (HA) 
// and Full Adders (FA).
//   si_cj_X ===> si represents the which stage of reduction we performing ,,
//           ===> cj represents the which column is that ;
// x may vary like sum , carry , pass;
   
 wire s1_c0_pass;
 assign s1_c0_pass = col0;
 // column 1 reduction 
 wire s1_c1_sum;
 wire s1_c2_carry;
 
 half_adder ha_s1_c1(
 .A(col1[0]),
 .B(col1[1]),
 .SUM(s1_c1_sum),
 .CARRY(s1_c2_carry)
 );
 // column 2 reduction
 wire s1_c2_sum;
 wire s1_c3_carry;
 
 full_adder fa_s1_c2(
 .A(col2[0]),
 .B(col2[1]),
 .C(col2[2]),
 .SUM(s1_c2_sum),
 .CARRY(s1_c3_carry)
 );
 // column 3 reduction 
 wire s1_c3_sum;
 wire s1_c4_carry;
 wire s1_c3_pass;
 full_adder fa_s1_c3(
 .A(col3[0]),
 .B(col3[1]),
 .C(col3[2]),
 .SUM(s1_c3_sum),
 .CARRY(s1_c4_carry)
 );
 assign s1_c3_pass = col3[3];
 
 // column 4 reduction 
 wire s1_c4_sum1;
 wire s1_c5_carry1;
 wire s1_c4_sum2;
 wire s1_c5_carry2;
 
 full_adder fa_s1_c4(
 .A(col4[0]),
 .B(col4[1]),
 .C(col4[2]),
 .SUM(s1_c4_sum1),
 .CARRY(s1_c5_carry1)
 );
 
 half_adder ha_s1_c4(
   .A(col4[3]),
   .B(col4[4]),
   .SUM(s1_c4_sum2),
   .CARRY(s1_c5_carry2)
 );
 // column 5 reduction 
 
 wire s1_c5_sum1;
 wire s1_c6_carry1;
 wire s1_c5_sum2;
 wire s1_c6_carry2;
 
 full_adder fa1_s1_c5 (
 .A(col5[0]),
 .B(col5[1]),
 .C(col5[2]),
 .SUM(s1_c5_sum1),
 .CARRY(s1_c6_carry1)
   );
    full_adder fa2_s1_c5 (
 .A(col5[3]),
 .B(col5[4]),
 .C(col5[5]),
 .SUM(s1_c5_sum2),
 .CARRY(s1_c6_carry2)
   );
  // column 6 redcution 
 wire s1_c6_sum1;
 wire s1_c7_carry1;
 wire s1_c6_sum2;
 wire s1_c7_carry2;
 wire s1_c6_pass;
 
  full_adder fa1_s1_c6(
 .A(col6[0]),
 .B(col6[1]),
 .C(col6[2]),
 .SUM(s1_c6_sum1),
 .CARRY(s1_c7_carry1)
   );
    full_adder fa2_s1_c6 (
 .A(col6[3]),
 .B(col6[4]),
 .C(col6[5]),
 .SUM(s1_c6_sum2),
 .CARRY(s1_c7_carry2)
   );
   
 assign s1_c6_pass = col6[6];
 
 // column 7 reduction 
 
 wire s1_c7_sum1;
 wire s1_c8_carry1;
 wire s1_c7_sum2;
 wire s1_c8_carry2;
 wire s1_c7_sum3;
 wire s1_c8_carry3;
 
  full_adder fa1_s1_c7 (
 .A(col7[0]),
 .B(col7[1]),
 .C(col7[2]),
 .SUM(s1_c7_sum1),
 .CARRY(s1_c8_carry1)
   );
    full_adder fa2_s1_c7 (
 .A(col7[3]),
 .B(col7[4]),
 .C(col7[5]),
 .SUM(s1_c7_sum2),
 .CARRY(s1_c8_carry2)
   );
  half_adder ha_s1_c7(
   .A(col7[6]),
   .B(col7[7]),
   .SUM(s1_c7_sum3),
   .CARRY(s1_c8_carry3)
 );
 // column 8 reduction
   
 wire s1_c8_sum1;
 wire s1_c9_carry1;
 wire s1_c8_sum2;
 wire s1_c9_carry2;
 wire s1_c8_pass;
 
  full_adder fa1_s1_c8(
 .A(col8[0]),
 .B(col8[1]),
 .C(col8[2]),
 .SUM(s1_c8_sum1),
 .CARRY(s1_c9_carry1)
   );
    full_adder fa2_s1_c8 (
 .A(col8[3]),
 .B(col8[4]),
 .C(col8[5]),
 .SUM(s1_c8_sum2),
 .CARRY(s1_c9_carry2)
   );
   
 assign s1_c8_pass = col8[6];
 // column 9 redcution 
   wire s1_c9_sum1;
 wire s1_c10_carry1;
 wire s1_c9_sum2;
 wire s1_c10_carry2;
 
 full_adder fa1_s1_c9 (
 .A(col9[0]),
 .B(col9[1]),
 .C(col9[2]),
 .SUM(s1_c9_sum1),
 .CARRY(s1_c10_carry1)
   );
    full_adder fa2_s1_c9 (
 .A(col9[3]),
 .B(col9[4]),
 .C(col9[5]),
 .SUM(s1_c9_sum2),
 .CARRY(s1_c10_carry2)
   );
 // column 10 reduction 
  wire s1_c10_sum1;
 wire s1_c11_carry1;
 wire s1_c10_sum2;
 wire s1_c11_carry2;
 
 full_adder fa_s1_c10(
 .A(col10[0]),
 .B(col10[1]),
 .C(col10[2]),
 .SUM(s1_c10_sum1),
 .CARRY(s1_c11_carry1)
 );
 
 half_adder ha_s1_c10(
   .A(col10[3]),
   .B(col10[4]),
   .SUM(s1_c10_sum2),
   .CARRY(s1_c11_carry2)
 );
 // column 11 reduction
 
 wire s1_c11_sum;
 wire s1_c12_carry;
 wire s1_c11_pass;
 full_adder fa_s1_c11(
 .A(col11[0]),
 .B(col11[1]),
 .C(col11[2]),
 .SUM(s1_c11_sum),
 .CARRY(s1_c12_carry)
 );
 assign s1_c11_pass = col11[3];
 // column 12 reduction
  wire s1_c12_sum;
 wire s1_c13_carry;
 
 full_adder fa_s1_c12(
 .A(col12[0]),
 .B(col12[1]),
 .C(col12[2]),
 .SUM(s1_c12_sum),
 .CARRY(s1_c13_carry)
 );
  // column 13 reduction 
 wire s1_c13_sum;
 wire s1_c14_carry;
 
 half_adder ha_s1_c13(
 .A(col13[0]),
 .B(col13[1]),
 .SUM(s1_c13_sum),
 .CARRY(s1_c14_carry)
 );
 //column 14 reduction
  wire s1_c14_pass;
 assign s1_c14_pass = col14;
 
 // we compressed  64 partial products into 49 partial prodcuts  
 
 // ---------------------------------------------------staage 2 reduction of wallace tree---------------------//
 // again compressing the partial products in stage of reduciton 
 
// column 0
 wire s2_c0_p;
 assign s2_c0_p = s1_c0_pass;
 
 // column 1
 
 wire s2_c1_p;
 assign s2_c1_p = s1_c1_sum;
 
 // column 2
 wire s2_c2_s;
 wire s2_c3_c;
 
 half_adder ha_s2_c2(
 .A(s1_c2_sum),
 .B(s1_c2_carry),
 .SUM(s2_c2_s),
 .CARRY(s2_c3_c)
 );
 
 // column 3 
 
 wire s2_c3_s;
 wire s2_c4_c;
 
 
 full_adder fa_s2_c3(
 .A(s1_c3_sum),
 .B(s1_c3_carry),
 .C(s1_c3_pass),
 .SUM(s2_c3_s),
 .CARRY(s2_c4_c)
 );
 
 // column 4
 wire s2_c4_s;
 wire s2_c5_c;
 
 full_adder fa_s2_c4(
 .A(s1_c4_sum1),
 .B(s1_c4_sum2),
 .C(s1_c4_carry),
 .SUM(s2_c4_s),
 .CARRY(s2_c5_c)
 );
 
 // column 5
 
 wire s2_c5_s;
 wire s2_c6_c;
 wire s2_c5_p;
 
 full_adder fa_s2_c5(
 .A(s1_c5_sum1),
 .B(s1_c5_sum2),
 .C(s1_c5_carry1),
 .SUM(s2_c5_s),
 .CARRY(s2_c6_c)
 );
 
 assign s2_c5_p = s1_c5_carry2;
 
 //column 6 reduction
 
 wire s2_c6_s1;
 wire s2_c6_s2;
 wire s2_c7_c1;
 wire s2_c7_c2;
 
 full_adder fa_s2_col6(
 .A(s1_c6_sum1),
 .B(s1_c6_sum2),
 .C(s1_c6_pass),
 .SUM(s2_c6_s1),
 .CARRY(s2_c7_c1)
 );
 half_adder ha_s2_col6(
 .A(s1_c6_carry1),
 .B(s1_c6_carry2),
 .SUM(s2_c6_s2),
 .CARRY(s2_c7_c2));
 
 // column 7 reduction
 
 wire s2_c7_s1;
 wire s2_c7_s2;
 wire s2_c8_c1;
 wire s2_c8_c2;
 
 full_adder fa_s2_col7(
 .A(s1_c7_sum1),
 .B(s1_c7_sum2),
 .C(s1_c7_sum3),
 .SUM(s2_c7_s1),
 .CARRY(s2_c8_c1)
 );
  
  half_adder ha_s2_col7(
 .A(s1_c7_carry1),
 .B(s1_c7_carry2),
 .SUM(s2_c7_s2),
 .CARRY(s2_c8_c2));
 
 // column 8 reduction
 
 wire s2_c8_s1;
 wire s2_c8_s2;
 wire s2_c9_c1;
 wire s2_c9_c2;
 
 full_adder fa1_s2_col8(
 .A(s1_c8_sum1),
 .B(s1_c8_sum2),
 .C(s1_c8_pass),
 .SUM(s2_c8_s1),
 .CARRY(s2_c9_c1)
 );
 
 full_adder fa2_s2_col8(
 .A(s1_c8_carry1),
 .B(s1_c8_carry2),
 .C(s1_c8_carry3),
 .SUM(s2_c8_s2),
 .CARRY(s2_c9_c2)
 );
 
 // column 9 reduction 
   
 wire s2_c9_s;
 wire s2_c10_c;
 wire s2_c9_p;
 
 full_adder fa_s2_c9(
 .A(s1_c9_sum1),
 .B(s1_c9_sum2),
 .C(s1_c9_carry1),
 .SUM(s2_c9_s),
 .CARRY(s2_c10_c)
 );
 
 assign s2_c9_p = s1_c9_carry2;
 // column 10 reduction
  
 wire s2_c10_s;
 wire s2_c11_c;
 wire s2_c10_p;
 
 full_adder fa_s2_c10(
 .A(s1_c10_sum1),
 .B(s1_c10_sum2),
 .C(s1_c10_carry1),
 .SUM(s2_c10_s),
 .CARRY(s2_c11_c)
 );
 
 assign s2_c10_p = s1_c10_carry2;
 
 // column 11 reduction 
 
  
 wire s2_c11_s;
 wire s2_c12_c;
 wire s2_c11_p;
 
 full_adder fa_s2_c11(
 .A(s1_c11_sum),
 .B(s1_c11_pass),
 .C(s1_c11_carry1),
 .SUM(s2_c11_s),
 .CARRY(s2_c12_c)
 );
 
 assign s2_c11_p = s1_c11_carry2;
 
 // column 12 reduction 
 
 wire s2_c12_s;
 wire s2_c13_c;
 
 half_adder ha_s2_c12(
 .A(s1_c12_sum),
 .B(s1_c12_carry),
 .SUM(s2_c12_s),
 .CARRY(s2_c13_c)
 );
 
 // column 13 reduction
 wire s2_c13_s;
 wire s2_c14_c;
 
 half_adder ha_s2_c13(
 .A(s1_c13_sum),
 .B(s1_c13_carry),
 .SUM(s2_c13_s),
 .CARRY(s2_c14_c)
 );
 
 // column 14 reduction
 
 wire s2_c14_s;
 wire s2_c15_c;
 
 half_adder ha_s2_c14(
 .A(s1_c14_pass),
 .B(s1_c14_carry),
 .SUM(s2_c14_s),
 .CARRY(s2_c15_c)
 );
  // we compressed 49 pp into 38 pp;
 
//---------------------------------------------------------------------------stage -2  pipeline register---------------------------------------------
 
    reg[37:0] s2_reg;
 
   always@(posedge clk) begin
      if (!rst)begin 
        s2_reg <= 38'd0;
      end
   else begin
      //col0
     s2_reg[0] <= s2_c0_p;
     // col1
     s2_reg[1] <= s2_c1_p;
     //col2
     s2_reg[2] <= s2_c2_s;
     //col3
     s2_reg[3] <= s2_c3_c;
     s2_reg[4] <= s2_c3_s;
     //col4
     s2_reg[5] <= s2_c4_c;
     s2_reg[6] <= s2_c4_s;
     //col5
     s2_reg[7] <= s2_c5_c;
     s2_reg[8] <= s2_c5_p;
     s2_reg[9] <= s2_c5_s;
     //col6
     s2_reg[10] <= s2_c6_c;
     s2_reg[11] <= s2_c6_s1;
     s2_reg[12] <= s2_c6_s2;
     //col7
     s2_reg[13] <= s2_c7_c1;
     s2_reg[14] <= s2_c7_c2;
     s2_reg[15] <= s2_c7_s1;
     s2_reg[16] <= s2_c7_s2;
     //col8
     s2_reg[17] <= s2_c8_c1;
     s2_reg[18] <= s2_c8_c2;
     s2_reg[19] <= s2_c8_s1;
     s2_reg[20] <= s2_c8_s2;
     
     //col9
     s2_reg[21] <= s2_c9_c1;
     s2_reg[22] <= s2_c9_c2;
     s2_reg[23] <= s2_c9_p;
     s2_reg[24] <= s2_c9_s;
     
     //col10
     s2_reg[25] <= s2_c10_c;
     s2_reg[26] <= s2_c10_s;
     s2_reg[27] <= s2_c10_p;
     
     //col11
     s2_reg[28] <= s2_c11_c;
     s2_reg[29] <= s2_c11_s;
     s2_reg[30] <= s2_c11_p;
     
     //col12
     
     s2_reg[31] <= s2_c12_c;
     s2_reg[32] <= s2_c12_s;
     
     //col13
     
     s2_reg[33] <= s2_c13_c;
     s2_reg[34] <= s2_c13_s;
     
     // col14
     s2_reg[35] <= s2_c14_c;
     s2_reg[36] <= s2_c14_s;
     
     //col15
     s2_reg[37] <= s2_c15_c;
     
    end 
    end 
    
    // ------------------------------------------------------------------stage - 3 of reduction -----------------------------------
    //col0
    wire s3_c0_p;
    assign s3_c0_p = s2_reg[0];
    
    //col1
    wire s3_c1_p;
    assign s3_c1_p = s2_reg[1];
    //col2
    wire s3_c2_p;
    assign s3_c2_p = s2_reg[2];
    //col3
    wire s3_c3_s;
    wire s3_c4_c;
    half_adder ha_s3_col3(
    .A(s2_reg[3]),
    .B(s2_reg[4]),
    .SUM(s3_c3_s),
   .CARRY(s3_c4_c));
   
   //col4
    wire s3_c4_s;
    wire s3_c5_c;
    half_adder ha_s3_col4(
    .A(s2_reg[5]),
    .B(s2_reg[6]),
    .SUM(s3_c4_s),
   .CARRY(s3_c5_c));
   
   //col5
   wire s3_c5_s;
   wire s3_c6_c;
   
   full_adder fa_s3_col5(
 .A(s2_reg[7]),
 .B(s2_reg[8]),
 .C(s2_reg[9]),
 .SUM(s3_c5_s),
 .CARRY(s3_c6_c)
 );
   
   //col6
   wire s3_c6_s;
   wire s3_c7_c;
   full_adder fa_s3_col6(
 .A(s2_reg[10]),
 .B(s2_reg[11]),
 .C(s2_reg[12]),
 .SUM(s3_c6_s),
 .CARRY(s3_c7_c)
 );
 
  //col7
  wire s3_c7_s;
  wire s3_c7_p;
  wire s3_c8_c;
  
  full_adder fa_s3_col7(
 .A(s2_reg[13]),
 .B(s2_reg[14]),
 .C(s2_reg[15]),
 .SUM(s3_c7_s),
 .CARRY(s3_c8_c)
 );
 assign s3_c7_p = s2_reg[16];
 
 //col8
   wire s3_c8_s;
  wire s3_c8_p;
  wire s3_c9_c;
  
  full_adder fa_s3_col8(
 .A(s2_reg[17]),
 .B(s2_reg[18]),
 .C(s2_reg[19]),
 .SUM(s3_c8_s),
 .CARRY(s3_c9_c)
 );
 assign s3_c8_p = s2_reg[20];
 
 //col9
 
  wire s3_c9_s;
  wire s3_c9_p;
  wire s3_c10_c;
  
  full_adder fa_s3_col9(
 .A(s2_reg[21]),
 .B(s2_reg[22]),
 .C(s2_reg[23]),
 .SUM(s3_c9_s),
 .CARRY(s3_c10_c)
 );
 assign s3_c9_p = s2_reg[24];
 
 //col10
  
   wire s3_c10_s;
   wire s3_c11_c;
   
  full_adder fa_s3_col10(
 .A(s2_reg[25]),
 .B(s2_reg[26]),
 .C(s2_reg[27]),
 .SUM(s3_c10_s),
 .CARRY(s3_c11_c)
 );
 
 //col11
 
   wire s3_c11_s;
   wire s3_c12_c;
   
   full_adder fa_s3_col11(
 .A(s2_reg[28]),
 .B(s2_reg[29]),
 .C(s2_reg[30]),
 .SUM(s3_c11_s),
 .CARRY(s3_c12_c)
 );
 
 //col12
   wire s3_c12_s;
    wire s3_c13_c;
    half_adder ha_s3_col12(
    .A(s2_reg[31]),
    .B(s2_reg[32]),
    .SUM(s3_c12_s),
   .CARRY(s3_c13_c));
   
   //col13
   
   wire s3_c13_s;
    wire s3_c14_c;
    half_adder ha_s3_col13(
    .A(s2_reg[33]),
    .B(s2_reg[34]),
    .SUM(s3_c13_s),
   .CARRY(s3_c14_c));
   
   //col14
   wire s3_c14_s;
    wire s3_c15_c;
    half_adder ha_s3_col14(
    .A(s2_reg[35]),
    .B(s2_reg[36]),
    .SUM(s3_c14_s),
   .CARRY(s3_c15_c));
   
   wire s3_c15_p;
   assign s3_c15_p = s2_reg[37];
   
   ////------------------------------------stage -4 of reduction-------------------------------------------------///////////////////////////////////
   
   
   wire s4_c0_p;wire s4_c2_p;wire s4_c4_p1;wire s4_c5_p1;wire s4_c6_p1;
   wire s4_c1_p;wire s4_c3_p;wire s4_c4_p2;wire s4_c5_p2;wire s4_c6_p2;
   // col0- col 6 redcution stage 4
   assign s4_c0_p = s3_c0_p;
   assign s4_c1_p = s3_c1_p;
   assign s4_c2_p = s3_c2_p;
   assign s4_c3_p = s3_c3_s;
   assign s4_c4_p1 = s3_c4_c;
   assign s4_c4_p2 = s3_c4_s;
   assign s4_c5_p1 = s3_c5_c;
   assign s4_c5_p2 = s3_c5_s;
   assign s4_c6_p1 = s3_c6_s;
   assign s4_c6_p2 = s3_c6_c;
   
  //col7
  wire s4_c7_s;
  wire s4_c8_c;
  full_adder fa_s4_col7(
 .A(s3_c7_c),
 .B(s3_c7_p),
 .C(s3_c7_s),
 .SUM(s4_c7_s),
 .CARRY(s4_c8_c)
 ); 
   
  //col8
  wire s4_c8_s;
  wire s4_c9_c;
  full_adder fa_s4_col8(
 .A(s3_c8_c),
 .B(s3_c8_p),
 .C(s3_c8_s),
 .SUM(s4_c8_s),
 .CARRY(s4_c9_c)
 ); 
   
  //col9
  wire s4_c9_s;
  wire s4_c10_c;
  full_adder fa_s4_col9(
 .A(s3_c9_c),
 .B(s3_c9_p),
 .C(s3_c9_s),
 .SUM(s4_c9_s),
 .CARRY(s4_c10_c)
 ); 
 
 //col10
 
 wire s4_c10_s;
 wire s4_c11_c;
 half_adder ha_s4_col10(
    .A(s3_c10_c),
    .B(s3_c10_s),
    .SUM(s4_c10_s),
   .CARRY(s4_c11_c)); 
   
 //col11
 wire s4_c11_s;
 wire s4_c12_c;
 half_adder ha_s4_col11(
    .A(s3_c11_c),
    .B(s3_c11_s),
    .SUM(s4_c11_s),
   .CARRY(s4_c12_c));


//col12  
  wire s4_c12_s;
 wire s4_c13_c;
 half_adder ha_s4_col12(
    .A(s3_c12_c),
    .B(s3_c12_s),
    .SUM(s4_c12_s),
   .CARRY(s4_c13_c));

 //col13  
 wire s4_c13_s;
 wire s4_c14_c;
 half_adder ha_s4_col13(
    .A(s3_c13_c),
    .B(s3_c13_s),
    .SUM(s4_c13_s),
   .CARRY(s4_c14_c));
   
  //col14  
  wire s4_c14_s;
 wire s4_c15_c;
 half_adder ha_s4_col14(
    .A(s3_c14_c),
    .B(s3_c14_s),
    .SUM(s4_c14_s),
   .CARRY(s4_c15_c));
   
 //col15
 wire s4_c15_s;
 wire s4_c16_c;
 half_adder ha_s4_col15(
    .A(s3_c15_c),
    .B(s3_c15_p),
    .SUM(s4_c15_s),
   .CARRY(s4_c16_c));
   
 //------------------------------------------------------stage 3 pipeline -----------------------------------------------//
 //---------------------------------addition of last two rows achived from wallace reduction stages of 1,2,3,4---------//
 
 reg [15:0] row_a_reg;
 reg [15:0] row_b_reg;
 
 always@(posedge clk)begin
  
  if (!rst)begin 
      row_a_reg <= 16'd0;
      row_b_reg <= 16'd0;
  end
  else begin // providing the values to row_a_registers from wires of stage 4 for next addition
     row_a_reg <= {s4_c15_s ,s4_c14_s ,s4_c13_s ,s4_c12_s ,s4_c11_s,
                    s4_c10_s,s4_c9_s,s4_c8_s,s4_c7_s,s4_c6_p1,s4_c5_p1,
                     s4_c4_p1,s4_c3_p,s4_c2_p,s4_c1_p,s4_c0_p}; 
                     
    row_b_reg <= {s4_c15_c ,s4_c14_c ,s4_c13_c ,s4_c12_c ,s4_c11_c,
                    s4_c10_c,s4_c9_c,s4_c8_c,1'd0,s4_c6_p2,s4_c5_p2,
                     s4_c4_p2,1'd0,1'd0,1'd0,1'd0}; 
                     
  end  
  
 end
 // summing two rows
 
 CLA_16bit cla(
 .A(row_a_reg),
 .B(row_b_reg),
 .cin(1'd0),
 .SUM(OUT),
 .cout()
 );   
    
     endmodule
