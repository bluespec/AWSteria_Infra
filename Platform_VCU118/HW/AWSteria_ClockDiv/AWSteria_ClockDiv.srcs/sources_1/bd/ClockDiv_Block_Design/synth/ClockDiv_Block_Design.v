//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.1 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
//Date        : Sat Jan 15 17:39:56 2022
//Host        : Dell-mation running 64-bit Ubuntu 18.04 LTS (beaver-three-eyed-raven X92)
//Command     : generate_target ClockDiv_Block_Design.bd
//Design      : ClockDiv_Block_Design
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "ClockDiv_Block_Design,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=ClockDiv_Block_Design,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=Global}" *) (* HW_HANDOFF = "ClockDiv_Block_Design.hwdef" *) 
module ClockDiv_Block_Design
   (CLK,
    RST_N,
    clk_out1,
    clk_out2,
    clk_out3,
    clk_out4,
    clk_out5);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK, CLK_DOMAIN ClockDiv_Block_Design_clk_in1_0, FREQ_HZ 250000000, INSERT_VIP 0, PHASE 0.000" *) input CLK;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.RST_N RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.RST_N, INSERT_VIP 0, POLARITY ACTIVE_LOW" *) input RST_N;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_OUT1 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_OUT1, CLK_DOMAIN ClockDiv_Block_Design_clk_wiz_0_0_clk_out1, FREQ_HZ 125000000, INSERT_VIP 0, PHASE 0.0" *) output clk_out1;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_OUT2 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_OUT2, CLK_DOMAIN ClockDiv_Block_Design_clk_wiz_0_0_clk_out1, FREQ_HZ 100000000, INSERT_VIP 0, PHASE 0.0" *) output clk_out2;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_OUT3 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_OUT3, CLK_DOMAIN ClockDiv_Block_Design_clk_wiz_0_0_clk_out1, FREQ_HZ 50000000, INSERT_VIP 0, PHASE 0.0" *) output clk_out3;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_OUT4 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_OUT4, CLK_DOMAIN ClockDiv_Block_Design_clk_wiz_0_0_clk_out1, FREQ_HZ 25000000, INSERT_VIP 0, PHASE 0.0" *) output clk_out4;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_OUT5 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_OUT5, CLK_DOMAIN ClockDiv_Block_Design_clk_wiz_0_0_clk_out1, FREQ_HZ 10000000, INSERT_VIP 0, PHASE 0.0" *) output clk_out5;

  wire clk_in1_0_1;
  wire clk_wiz_0_clk_out1;
  wire clk_wiz_0_clk_out2;
  wire clk_wiz_0_clk_out3;
  wire clk_wiz_0_clk_out4;
  wire clk_wiz_0_clk_out5;
  wire reset_in_250_1;

  assign clk_in1_0_1 = CLK;
  assign clk_out1 = clk_wiz_0_clk_out1;
  assign clk_out2 = clk_wiz_0_clk_out2;
  assign clk_out3 = clk_wiz_0_clk_out3;
  assign clk_out4 = clk_wiz_0_clk_out4;
  assign clk_out5 = clk_wiz_0_clk_out5;
  assign reset_in_250_1 = RST_N;
  ClockDiv_Block_Design_clk_wiz_0_0 clk_wiz_0
       (.clk_in1(clk_in1_0_1),
        .clk_out1(clk_wiz_0_clk_out1),
        .clk_out2(clk_wiz_0_clk_out2),
        .clk_out3(clk_wiz_0_clk_out3),
        .clk_out4(clk_wiz_0_clk_out4),
        .clk_out5(clk_wiz_0_clk_out5),
        .resetn(reset_in_250_1));
endmodule
