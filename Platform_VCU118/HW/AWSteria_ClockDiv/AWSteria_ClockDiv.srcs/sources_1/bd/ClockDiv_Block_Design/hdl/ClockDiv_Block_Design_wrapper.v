//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.1 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
//Date        : Sat Jan 15 17:39:56 2022
//Host        : Dell-mation running 64-bit Ubuntu 18.04 LTS (beaver-three-eyed-raven X92)
//Command     : generate_target ClockDiv_Block_Design_wrapper.bd
//Design      : ClockDiv_Block_Design_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module ClockDiv_Block_Design_wrapper
   (CLK,
    RST_N,
    clk_out1,
    clk_out2,
    clk_out3,
    clk_out4,
    clk_out5);
  input CLK;
  input RST_N;
  output clk_out1;
  output clk_out2;
  output clk_out3;
  output clk_out4;
  output clk_out5;

  wire CLK;
  wire RST_N;
  wire clk_out1;
  wire clk_out2;
  wire clk_out3;
  wire clk_out4;
  wire clk_out5;

  ClockDiv_Block_Design ClockDiv_Block_Design_i
       (.CLK(CLK),
        .RST_N(RST_N),
        .clk_out1(clk_out1),
        .clk_out2(clk_out2),
        .clk_out3(clk_out3),
        .clk_out4(clk_out4),
        .clk_out5(clk_out5));
endmodule
