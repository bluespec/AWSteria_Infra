//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.1 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
//Date        : Thu Aug  5 20:38:29 2021
//Host        : Dell-mation running 64-bit Ubuntu 18.04 LTS (beaver-three-eyed-raven X92)
//Command     : generate_target mkAWSteria_HW_reclocked.bd
//Design      : mkAWSteria_HW_reclocked
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "mkAWSteria_HW_reclocked,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=mkAWSteria_HW_reclocked,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=11,numReposBlks=11,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=6,numPkgbdBlks=0,bdsource=USER,synth_mode=Global}" *) (* HW_HANDOFF = "mkAWSteria_HW_reclocked.hwdef" *) 
module mkAWSteria_HW_reclocked
   (CLK,
    CLK_b_CLK,
    RST_N,
    RST_N_b_RST_N,
    ddr_A_M_araddr,
    ddr_A_M_arburst,
    ddr_A_M_arcache,
    ddr_A_M_arid,
    ddr_A_M_arlen,
    ddr_A_M_arlock,
    ddr_A_M_arprot,
    ddr_A_M_arqos,
    ddr_A_M_arready,
    ddr_A_M_arregion,
    ddr_A_M_arsize,
    ddr_A_M_arvalid,
    ddr_A_M_awaddr,
    ddr_A_M_awburst,
    ddr_A_M_awcache,
    ddr_A_M_awid,
    ddr_A_M_awlen,
    ddr_A_M_awlock,
    ddr_A_M_awprot,
    ddr_A_M_awqos,
    ddr_A_M_awready,
    ddr_A_M_awregion,
    ddr_A_M_awsize,
    ddr_A_M_awvalid,
    ddr_A_M_bid,
    ddr_A_M_bready,
    ddr_A_M_bresp,
    ddr_A_M_bvalid,
    ddr_A_M_rdata,
    ddr_A_M_rid,
    ddr_A_M_rlast,
    ddr_A_M_rready,
    ddr_A_M_rresp,
    ddr_A_M_rvalid,
    ddr_A_M_wdata,
    ddr_A_M_wlast,
    ddr_A_M_wready,
    ddr_A_M_wstrb,
    ddr_A_M_wvalid,
    ddr_B_M_araddr,
    ddr_B_M_arburst,
    ddr_B_M_arcache,
    ddr_B_M_arid,
    ddr_B_M_arlen,
    ddr_B_M_arlock,
    ddr_B_M_arprot,
    ddr_B_M_arqos,
    ddr_B_M_arready,
    ddr_B_M_arregion,
    ddr_B_M_arsize,
    ddr_B_M_arvalid,
    ddr_B_M_awaddr,
    ddr_B_M_awburst,
    ddr_B_M_awcache,
    ddr_B_M_awid,
    ddr_B_M_awlen,
    ddr_B_M_awlock,
    ddr_B_M_awprot,
    ddr_B_M_awqos,
    ddr_B_M_awready,
    ddr_B_M_awregion,
    ddr_B_M_awsize,
    ddr_B_M_awvalid,
    ddr_B_M_bid,
    ddr_B_M_bready,
    ddr_B_M_bresp,
    ddr_B_M_bvalid,
    ddr_B_M_rdata,
    ddr_B_M_rid,
    ddr_B_M_rlast,
    ddr_B_M_rready,
    ddr_B_M_rresp,
    ddr_B_M_rvalid,
    ddr_B_M_wdata,
    ddr_B_M_wlast,
    ddr_B_M_wready,
    ddr_B_M_wstrb,
    ddr_B_M_wvalid,
    host_AXI4L_S_araddr,
    host_AXI4L_S_arprot,
    host_AXI4L_S_arready,
    host_AXI4L_S_arvalid,
    host_AXI4L_S_awaddr,
    host_AXI4L_S_awprot,
    host_AXI4L_S_awready,
    host_AXI4L_S_awvalid,
    host_AXI4L_S_bready,
    host_AXI4L_S_bresp,
    host_AXI4L_S_bvalid,
    host_AXI4L_S_rdata,
    host_AXI4L_S_rready,
    host_AXI4L_S_rresp,
    host_AXI4L_S_rvalid,
    host_AXI4L_S_wdata,
    host_AXI4L_S_wready,
    host_AXI4L_S_wstrb,
    host_AXI4L_S_wvalid,
    host_AXI4_S_araddr,
    host_AXI4_S_arburst,
    host_AXI4_S_arcache,
    host_AXI4_S_arid,
    host_AXI4_S_arlen,
    host_AXI4_S_arlock,
    host_AXI4_S_arprot,
    host_AXI4_S_arqos,
    host_AXI4_S_arready,
    host_AXI4_S_arregion,
    host_AXI4_S_arsize,
    host_AXI4_S_arvalid,
    host_AXI4_S_awaddr,
    host_AXI4_S_awburst,
    host_AXI4_S_awcache,
    host_AXI4_S_awid,
    host_AXI4_S_awlen,
    host_AXI4_S_awlock,
    host_AXI4_S_awprot,
    host_AXI4_S_awqos,
    host_AXI4_S_awready,
    host_AXI4_S_awregion,
    host_AXI4_S_awsize,
    host_AXI4_S_awvalid,
    host_AXI4_S_bid,
    host_AXI4_S_bready,
    host_AXI4_S_bresp,
    host_AXI4_S_bvalid,
    host_AXI4_S_rdata,
    host_AXI4_S_rid,
    host_AXI4_S_rlast,
    host_AXI4_S_rready,
    host_AXI4_S_rresp,
    host_AXI4_S_rvalid,
    host_AXI4_S_wdata,
    host_AXI4_S_wlast,
    host_AXI4_S_wready,
    host_AXI4_S_wstrb,
    host_AXI4_S_wvalid,
    m_env_ready_env_ready,
    m_glcount_glcount,
    m_halted);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK, ASSOCIATED_BUSIF host_AXI4L_S:host_AXI4_S:ddr_A_M:ddr_B_M, ASSOCIATED_RESET RST_N, CLK_DOMAIN mkAWSteria_HW_reclocked_clk_in1_0, FREQ_HZ 250000000, INSERT_VIP 0, PHASE 0.000" *) input CLK;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_B_CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_B_CLK, CLK_DOMAIN mkAWSteria_HW_reclocked_CLK_b_CLK, FREQ_HZ 250000000, INSERT_VIP 0, PHASE 0.000" *) input CLK_b_CLK;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.RST_N RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.RST_N, INSERT_VIP 0, POLARITY ACTIVE_LOW" *) input RST_N;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.RST_N_B_RST_N RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.RST_N_B_RST_N, INSERT_VIP 0, POLARITY ACTIVE_LOW" *) input RST_N_b_RST_N;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M " *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME ddr_A_M, ADDR_WIDTH 64, ARUSER_WIDTH 0, AWUSER_WIDTH 0, BUSER_WIDTH 0, CLK_DOMAIN mkAWSteria_HW_reclocked_clk_in1_0, DATA_WIDTH 512, FREQ_HZ 250000000, HAS_BRESP 1, HAS_BURST 1, HAS_CACHE 1, HAS_LOCK 1, HAS_PROT 1, HAS_QOS 1, HAS_REGION 1, HAS_RRESP 1, HAS_WSTRB 1, ID_WIDTH 16, INSERT_VIP 0, MAX_BURST_LENGTH 256, NUM_READ_OUTSTANDING 2, NUM_READ_THREADS 1, NUM_WRITE_OUTSTANDING 2, NUM_WRITE_THREADS 1, PHASE 0.000, PROTOCOL AXI4, READ_WRITE_MODE READ_WRITE, RUSER_BITS_PER_BYTE 0, RUSER_WIDTH 0, SUPPORTS_NARROW_BURST 1, WUSER_BITS_PER_BYTE 0, WUSER_WIDTH 0" *) output [63:0]ddr_A_M_araddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M " *) output [1:0]ddr_A_M_arburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M " *) output [3:0]ddr_A_M_arcache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M " *) output [15:0]ddr_A_M_arid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M " *) output [7:0]ddr_A_M_arlen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M " *) output [0:0]ddr_A_M_arlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M " *) output [2:0]ddr_A_M_arprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M " *) output [3:0]ddr_A_M_arqos;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M " *) input ddr_A_M_arready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M " *) output [3:0]ddr_A_M_arregion;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M " *) output [2:0]ddr_A_M_arsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M " *) output ddr_A_M_arvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M " *) output [63:0]ddr_A_M_awaddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M " *) output [1:0]ddr_A_M_awburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M " *) output [3:0]ddr_A_M_awcache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M " *) output [15:0]ddr_A_M_awid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M " *) output [7:0]ddr_A_M_awlen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M " *) output [0:0]ddr_A_M_awlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M " *) output [2:0]ddr_A_M_awprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M " *) output [3:0]ddr_A_M_awqos;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M " *) input ddr_A_M_awready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M " *) output [3:0]ddr_A_M_awregion;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M " *) output [2:0]ddr_A_M_awsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M " *) output ddr_A_M_awvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M " *) input [15:0]ddr_A_M_bid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M " *) output ddr_A_M_bready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M " *) input [1:0]ddr_A_M_bresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M " *) input ddr_A_M_bvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M " *) input [511:0]ddr_A_M_rdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M " *) input [15:0]ddr_A_M_rid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M " *) input ddr_A_M_rlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M " *) output ddr_A_M_rready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M " *) input [1:0]ddr_A_M_rresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M " *) input ddr_A_M_rvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M " *) output [511:0]ddr_A_M_wdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M " *) output ddr_A_M_wlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M " *) input ddr_A_M_wready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M " *) output [63:0]ddr_A_M_wstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M " *) output ddr_A_M_wvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M " *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME ddr_B_M, ADDR_WIDTH 64, ARUSER_WIDTH 0, AWUSER_WIDTH 0, BUSER_WIDTH 0, CLK_DOMAIN mkAWSteria_HW_reclocked_clk_in1_0, DATA_WIDTH 512, FREQ_HZ 250000000, HAS_BRESP 1, HAS_BURST 1, HAS_CACHE 1, HAS_LOCK 1, HAS_PROT 1, HAS_QOS 1, HAS_REGION 1, HAS_RRESP 1, HAS_WSTRB 1, ID_WIDTH 16, INSERT_VIP 0, MAX_BURST_LENGTH 256, NUM_READ_OUTSTANDING 2, NUM_READ_THREADS 1, NUM_WRITE_OUTSTANDING 2, NUM_WRITE_THREADS 1, PHASE 0.000, PROTOCOL AXI4, READ_WRITE_MODE READ_WRITE, RUSER_BITS_PER_BYTE 0, RUSER_WIDTH 0, SUPPORTS_NARROW_BURST 1, WUSER_BITS_PER_BYTE 0, WUSER_WIDTH 0" *) output [63:0]ddr_B_M_araddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M " *) output [1:0]ddr_B_M_arburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M " *) output [3:0]ddr_B_M_arcache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M " *) output [15:0]ddr_B_M_arid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M " *) output [7:0]ddr_B_M_arlen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M " *) output [0:0]ddr_B_M_arlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M " *) output [2:0]ddr_B_M_arprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M " *) output [3:0]ddr_B_M_arqos;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M " *) input ddr_B_M_arready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M " *) output [3:0]ddr_B_M_arregion;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M " *) output [2:0]ddr_B_M_arsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M " *) output ddr_B_M_arvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M " *) output [63:0]ddr_B_M_awaddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M " *) output [1:0]ddr_B_M_awburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M " *) output [3:0]ddr_B_M_awcache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M " *) output [15:0]ddr_B_M_awid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M " *) output [7:0]ddr_B_M_awlen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M " *) output [0:0]ddr_B_M_awlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M " *) output [2:0]ddr_B_M_awprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M " *) output [3:0]ddr_B_M_awqos;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M " *) input ddr_B_M_awready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M " *) output [3:0]ddr_B_M_awregion;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M " *) output [2:0]ddr_B_M_awsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M " *) output ddr_B_M_awvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M " *) input [15:0]ddr_B_M_bid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M " *) output ddr_B_M_bready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M " *) input [1:0]ddr_B_M_bresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M " *) input ddr_B_M_bvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M " *) input [511:0]ddr_B_M_rdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M " *) input [15:0]ddr_B_M_rid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M " *) input ddr_B_M_rlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M " *) output ddr_B_M_rready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M " *) input [1:0]ddr_B_M_rresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M " *) input ddr_B_M_rvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M " *) output [511:0]ddr_B_M_wdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M " *) output ddr_B_M_wlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M " *) input ddr_B_M_wready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M " *) output [63:0]ddr_B_M_wstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M " *) output ddr_B_M_wvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4L_S " *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME host_AXI4L_S, ADDR_WIDTH 32, ARUSER_WIDTH 0, AWUSER_WIDTH 0, BUSER_WIDTH 0, CLK_DOMAIN mkAWSteria_HW_reclocked_clk_in1_0, DATA_WIDTH 32, FREQ_HZ 250000000, HAS_BRESP 1, HAS_BURST 0, HAS_CACHE 0, HAS_LOCK 0, HAS_PROT 1, HAS_QOS 0, HAS_REGION 0, HAS_RRESP 1, HAS_WSTRB 1, ID_WIDTH 0, INSERT_VIP 0, MAX_BURST_LENGTH 1, NUM_READ_OUTSTANDING 1, NUM_READ_THREADS 1, NUM_WRITE_OUTSTANDING 1, NUM_WRITE_THREADS 1, PHASE 0.000, PROTOCOL AXI4LITE, READ_WRITE_MODE READ_WRITE, RUSER_BITS_PER_BYTE 0, RUSER_WIDTH 0, SUPPORTS_NARROW_BURST 0, WUSER_BITS_PER_BYTE 0, WUSER_WIDTH 0" *) input [31:0]host_AXI4L_S_araddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4L_S " *) input [2:0]host_AXI4L_S_arprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4L_S " *) output host_AXI4L_S_arready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4L_S " *) input host_AXI4L_S_arvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4L_S " *) input [31:0]host_AXI4L_S_awaddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4L_S " *) input [2:0]host_AXI4L_S_awprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4L_S " *) output host_AXI4L_S_awready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4L_S " *) input host_AXI4L_S_awvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4L_S " *) input host_AXI4L_S_bready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4L_S " *) output [1:0]host_AXI4L_S_bresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4L_S " *) output host_AXI4L_S_bvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4L_S " *) output [31:0]host_AXI4L_S_rdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4L_S " *) input host_AXI4L_S_rready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4L_S " *) output [1:0]host_AXI4L_S_rresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4L_S " *) output host_AXI4L_S_rvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4L_S " *) input [31:0]host_AXI4L_S_wdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4L_S " *) output host_AXI4L_S_wready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4L_S " *) input [3:0]host_AXI4L_S_wstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4L_S " *) input host_AXI4L_S_wvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S " *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME host_AXI4_S, ADDR_WIDTH 64, ARUSER_WIDTH 0, AWUSER_WIDTH 0, BUSER_WIDTH 0, CLK_DOMAIN mkAWSteria_HW_reclocked_clk_in1_0, DATA_WIDTH 512, FREQ_HZ 250000000, HAS_BRESP 1, HAS_BURST 1, HAS_CACHE 1, HAS_LOCK 1, HAS_PROT 1, HAS_QOS 1, HAS_REGION 1, HAS_RRESP 1, HAS_WSTRB 1, ID_WIDTH 16, INSERT_VIP 0, MAX_BURST_LENGTH 256, NUM_READ_OUTSTANDING 2, NUM_READ_THREADS 1, NUM_WRITE_OUTSTANDING 2, NUM_WRITE_THREADS 1, PHASE 0.000, PROTOCOL AXI4, READ_WRITE_MODE READ_WRITE, RUSER_BITS_PER_BYTE 0, RUSER_WIDTH 0, SUPPORTS_NARROW_BURST 1, WUSER_BITS_PER_BYTE 0, WUSER_WIDTH 0" *) input [63:0]host_AXI4_S_araddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S " *) input [1:0]host_AXI4_S_arburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S " *) input [3:0]host_AXI4_S_arcache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S " *) input [15:0]host_AXI4_S_arid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S " *) input [7:0]host_AXI4_S_arlen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S " *) input [0:0]host_AXI4_S_arlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S " *) input [2:0]host_AXI4_S_arprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S " *) input [3:0]host_AXI4_S_arqos;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S " *) output host_AXI4_S_arready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S " *) input [3:0]host_AXI4_S_arregion;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S " *) input [2:0]host_AXI4_S_arsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S " *) input host_AXI4_S_arvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S " *) input [63:0]host_AXI4_S_awaddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S " *) input [1:0]host_AXI4_S_awburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S " *) input [3:0]host_AXI4_S_awcache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S " *) input [15:0]host_AXI4_S_awid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S " *) input [7:0]host_AXI4_S_awlen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S " *) input [0:0]host_AXI4_S_awlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S " *) input [2:0]host_AXI4_S_awprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S " *) input [3:0]host_AXI4_S_awqos;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S " *) output host_AXI4_S_awready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S " *) input [3:0]host_AXI4_S_awregion;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S " *) input [2:0]host_AXI4_S_awsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S " *) input host_AXI4_S_awvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S " *) output [15:0]host_AXI4_S_bid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S " *) input host_AXI4_S_bready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S " *) output [1:0]host_AXI4_S_bresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S " *) output host_AXI4_S_bvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S " *) output [511:0]host_AXI4_S_rdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S " *) output [15:0]host_AXI4_S_rid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S " *) output host_AXI4_S_rlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S " *) input host_AXI4_S_rready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S " *) output [1:0]host_AXI4_S_rresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S " *) output host_AXI4_S_rvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S " *) input [511:0]host_AXI4_S_wdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S " *) input host_AXI4_S_wlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S " *) output host_AXI4_S_wready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S " *) input [63:0]host_AXI4_S_wstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S " *) input host_AXI4_S_wvalid;
  input m_env_ready_env_ready;
  input [63:0]m_glcount_glcount;
  output m_halted;

  wire [31:0]S_AXI_0_1_ARADDR;
  wire [2:0]S_AXI_0_1_ARPROT;
  wire S_AXI_0_1_ARREADY;
  wire S_AXI_0_1_ARVALID;
  wire [31:0]S_AXI_0_1_AWADDR;
  wire [2:0]S_AXI_0_1_AWPROT;
  wire S_AXI_0_1_AWREADY;
  wire S_AXI_0_1_AWVALID;
  wire S_AXI_0_1_BREADY;
  wire [1:0]S_AXI_0_1_BRESP;
  wire S_AXI_0_1_BVALID;
  wire [31:0]S_AXI_0_1_RDATA;
  wire S_AXI_0_1_RREADY;
  wire [1:0]S_AXI_0_1_RRESP;
  wire S_AXI_0_1_RVALID;
  wire [31:0]S_AXI_0_1_WDATA;
  wire S_AXI_0_1_WREADY;
  wire [3:0]S_AXI_0_1_WSTRB;
  wire S_AXI_0_1_WVALID;
  wire [63:0]S_AXI_0_2_ARADDR;
  wire [1:0]S_AXI_0_2_ARBURST;
  wire [3:0]S_AXI_0_2_ARCACHE;
  wire [15:0]S_AXI_0_2_ARID;
  wire [7:0]S_AXI_0_2_ARLEN;
  wire [0:0]S_AXI_0_2_ARLOCK;
  wire [2:0]S_AXI_0_2_ARPROT;
  wire [3:0]S_AXI_0_2_ARQOS;
  wire S_AXI_0_2_ARREADY;
  wire [3:0]S_AXI_0_2_ARREGION;
  wire [2:0]S_AXI_0_2_ARSIZE;
  wire S_AXI_0_2_ARVALID;
  wire [63:0]S_AXI_0_2_AWADDR;
  wire [1:0]S_AXI_0_2_AWBURST;
  wire [3:0]S_AXI_0_2_AWCACHE;
  wire [15:0]S_AXI_0_2_AWID;
  wire [7:0]S_AXI_0_2_AWLEN;
  wire [0:0]S_AXI_0_2_AWLOCK;
  wire [2:0]S_AXI_0_2_AWPROT;
  wire [3:0]S_AXI_0_2_AWQOS;
  wire S_AXI_0_2_AWREADY;
  wire [3:0]S_AXI_0_2_AWREGION;
  wire [2:0]S_AXI_0_2_AWSIZE;
  wire S_AXI_0_2_AWVALID;
  wire [15:0]S_AXI_0_2_BID;
  wire S_AXI_0_2_BREADY;
  wire [1:0]S_AXI_0_2_BRESP;
  wire S_AXI_0_2_BVALID;
  wire [511:0]S_AXI_0_2_RDATA;
  wire [15:0]S_AXI_0_2_RID;
  wire S_AXI_0_2_RLAST;
  wire S_AXI_0_2_RREADY;
  wire [1:0]S_AXI_0_2_RRESP;
  wire S_AXI_0_2_RVALID;
  wire [511:0]S_AXI_0_2_WDATA;
  wire S_AXI_0_2_WLAST;
  wire S_AXI_0_2_WREADY;
  wire [63:0]S_AXI_0_2_WSTRB;
  wire S_AXI_0_2_WVALID;
  wire clk_in1_0_1;
  wire clk_out1_reset_synchronizer_dest_resetn;
  wire clk_out2_reset_synchronizer_dest_resetn;
  wire clk_wiz_0_clk_out1;
  wire clk_wiz_0_clk_out2;
  wire [63:0]ddr_A_clock_converter_M_AXI_ARADDR;
  wire [1:0]ddr_A_clock_converter_M_AXI_ARBURST;
  wire [3:0]ddr_A_clock_converter_M_AXI_ARCACHE;
  wire [15:0]ddr_A_clock_converter_M_AXI_ARID;
  wire [7:0]ddr_A_clock_converter_M_AXI_ARLEN;
  wire [0:0]ddr_A_clock_converter_M_AXI_ARLOCK;
  wire [2:0]ddr_A_clock_converter_M_AXI_ARPROT;
  wire [3:0]ddr_A_clock_converter_M_AXI_ARQOS;
  wire ddr_A_clock_converter_M_AXI_ARREADY;
  wire [3:0]ddr_A_clock_converter_M_AXI_ARREGION;
  wire [2:0]ddr_A_clock_converter_M_AXI_ARSIZE;
  wire ddr_A_clock_converter_M_AXI_ARVALID;
  wire [63:0]ddr_A_clock_converter_M_AXI_AWADDR;
  wire [1:0]ddr_A_clock_converter_M_AXI_AWBURST;
  wire [3:0]ddr_A_clock_converter_M_AXI_AWCACHE;
  wire [15:0]ddr_A_clock_converter_M_AXI_AWID;
  wire [7:0]ddr_A_clock_converter_M_AXI_AWLEN;
  wire [0:0]ddr_A_clock_converter_M_AXI_AWLOCK;
  wire [2:0]ddr_A_clock_converter_M_AXI_AWPROT;
  wire [3:0]ddr_A_clock_converter_M_AXI_AWQOS;
  wire ddr_A_clock_converter_M_AXI_AWREADY;
  wire [3:0]ddr_A_clock_converter_M_AXI_AWREGION;
  wire [2:0]ddr_A_clock_converter_M_AXI_AWSIZE;
  wire ddr_A_clock_converter_M_AXI_AWVALID;
  wire [15:0]ddr_A_clock_converter_M_AXI_BID;
  wire ddr_A_clock_converter_M_AXI_BREADY;
  wire [1:0]ddr_A_clock_converter_M_AXI_BRESP;
  wire ddr_A_clock_converter_M_AXI_BVALID;
  wire [511:0]ddr_A_clock_converter_M_AXI_RDATA;
  wire [15:0]ddr_A_clock_converter_M_AXI_RID;
  wire ddr_A_clock_converter_M_AXI_RLAST;
  wire ddr_A_clock_converter_M_AXI_RREADY;
  wire [1:0]ddr_A_clock_converter_M_AXI_RRESP;
  wire ddr_A_clock_converter_M_AXI_RVALID;
  wire [511:0]ddr_A_clock_converter_M_AXI_WDATA;
  wire ddr_A_clock_converter_M_AXI_WLAST;
  wire ddr_A_clock_converter_M_AXI_WREADY;
  wire [63:0]ddr_A_clock_converter_M_AXI_WSTRB;
  wire ddr_A_clock_converter_M_AXI_WVALID;
  wire [63:0]ddr_B_clock_converter_M_AXI_ARADDR;
  wire [1:0]ddr_B_clock_converter_M_AXI_ARBURST;
  wire [3:0]ddr_B_clock_converter_M_AXI_ARCACHE;
  wire [15:0]ddr_B_clock_converter_M_AXI_ARID;
  wire [7:0]ddr_B_clock_converter_M_AXI_ARLEN;
  wire [0:0]ddr_B_clock_converter_M_AXI_ARLOCK;
  wire [2:0]ddr_B_clock_converter_M_AXI_ARPROT;
  wire [3:0]ddr_B_clock_converter_M_AXI_ARQOS;
  wire ddr_B_clock_converter_M_AXI_ARREADY;
  wire [3:0]ddr_B_clock_converter_M_AXI_ARREGION;
  wire [2:0]ddr_B_clock_converter_M_AXI_ARSIZE;
  wire ddr_B_clock_converter_M_AXI_ARVALID;
  wire [63:0]ddr_B_clock_converter_M_AXI_AWADDR;
  wire [1:0]ddr_B_clock_converter_M_AXI_AWBURST;
  wire [3:0]ddr_B_clock_converter_M_AXI_AWCACHE;
  wire [15:0]ddr_B_clock_converter_M_AXI_AWID;
  wire [7:0]ddr_B_clock_converter_M_AXI_AWLEN;
  wire [0:0]ddr_B_clock_converter_M_AXI_AWLOCK;
  wire [2:0]ddr_B_clock_converter_M_AXI_AWPROT;
  wire [3:0]ddr_B_clock_converter_M_AXI_AWQOS;
  wire ddr_B_clock_converter_M_AXI_AWREADY;
  wire [3:0]ddr_B_clock_converter_M_AXI_AWREGION;
  wire [2:0]ddr_B_clock_converter_M_AXI_AWSIZE;
  wire ddr_B_clock_converter_M_AXI_AWVALID;
  wire [15:0]ddr_B_clock_converter_M_AXI_BID;
  wire ddr_B_clock_converter_M_AXI_BREADY;
  wire [1:0]ddr_B_clock_converter_M_AXI_BRESP;
  wire ddr_B_clock_converter_M_AXI_BVALID;
  wire [511:0]ddr_B_clock_converter_M_AXI_RDATA;
  wire [15:0]ddr_B_clock_converter_M_AXI_RID;
  wire ddr_B_clock_converter_M_AXI_RLAST;
  wire ddr_B_clock_converter_M_AXI_RREADY;
  wire [1:0]ddr_B_clock_converter_M_AXI_RRESP;
  wire ddr_B_clock_converter_M_AXI_RVALID;
  wire [511:0]ddr_B_clock_converter_M_AXI_WDATA;
  wire ddr_B_clock_converter_M_AXI_WLAST;
  wire ddr_B_clock_converter_M_AXI_WREADY;
  wire [63:0]ddr_B_clock_converter_M_AXI_WSTRB;
  wire ddr_B_clock_converter_M_AXI_WVALID;
  wire [31:0]host_AXI4L_clock_converter_M_AXI_ARADDR;
  wire [2:0]host_AXI4L_clock_converter_M_AXI_ARPROT;
  wire host_AXI4L_clock_converter_M_AXI_ARREADY;
  wire host_AXI4L_clock_converter_M_AXI_ARVALID;
  wire [31:0]host_AXI4L_clock_converter_M_AXI_AWADDR;
  wire [2:0]host_AXI4L_clock_converter_M_AXI_AWPROT;
  wire host_AXI4L_clock_converter_M_AXI_AWREADY;
  wire host_AXI4L_clock_converter_M_AXI_AWVALID;
  wire host_AXI4L_clock_converter_M_AXI_BREADY;
  wire [1:0]host_AXI4L_clock_converter_M_AXI_BRESP;
  wire host_AXI4L_clock_converter_M_AXI_BVALID;
  wire [31:0]host_AXI4L_clock_converter_M_AXI_RDATA;
  wire host_AXI4L_clock_converter_M_AXI_RREADY;
  wire [1:0]host_AXI4L_clock_converter_M_AXI_RRESP;
  wire host_AXI4L_clock_converter_M_AXI_RVALID;
  wire [31:0]host_AXI4L_clock_converter_M_AXI_WDATA;
  wire host_AXI4L_clock_converter_M_AXI_WREADY;
  wire [3:0]host_AXI4L_clock_converter_M_AXI_WSTRB;
  wire host_AXI4L_clock_converter_M_AXI_WVALID;
  wire [63:0]host_AXI4_clock_converter_M_AXI_ARADDR;
  wire [1:0]host_AXI4_clock_converter_M_AXI_ARBURST;
  wire [3:0]host_AXI4_clock_converter_M_AXI_ARCACHE;
  wire [15:0]host_AXI4_clock_converter_M_AXI_ARID;
  wire [7:0]host_AXI4_clock_converter_M_AXI_ARLEN;
  wire [0:0]host_AXI4_clock_converter_M_AXI_ARLOCK;
  wire [2:0]host_AXI4_clock_converter_M_AXI_ARPROT;
  wire [3:0]host_AXI4_clock_converter_M_AXI_ARQOS;
  wire host_AXI4_clock_converter_M_AXI_ARREADY;
  wire [3:0]host_AXI4_clock_converter_M_AXI_ARREGION;
  wire [2:0]host_AXI4_clock_converter_M_AXI_ARSIZE;
  wire host_AXI4_clock_converter_M_AXI_ARVALID;
  wire [63:0]host_AXI4_clock_converter_M_AXI_AWADDR;
  wire [1:0]host_AXI4_clock_converter_M_AXI_AWBURST;
  wire [3:0]host_AXI4_clock_converter_M_AXI_AWCACHE;
  wire [15:0]host_AXI4_clock_converter_M_AXI_AWID;
  wire [7:0]host_AXI4_clock_converter_M_AXI_AWLEN;
  wire [0:0]host_AXI4_clock_converter_M_AXI_AWLOCK;
  wire [2:0]host_AXI4_clock_converter_M_AXI_AWPROT;
  wire [3:0]host_AXI4_clock_converter_M_AXI_AWQOS;
  wire host_AXI4_clock_converter_M_AXI_AWREADY;
  wire [3:0]host_AXI4_clock_converter_M_AXI_AWREGION;
  wire [2:0]host_AXI4_clock_converter_M_AXI_AWSIZE;
  wire host_AXI4_clock_converter_M_AXI_AWVALID;
  wire [15:0]host_AXI4_clock_converter_M_AXI_BID;
  wire host_AXI4_clock_converter_M_AXI_BREADY;
  wire [1:0]host_AXI4_clock_converter_M_AXI_BRESP;
  wire host_AXI4_clock_converter_M_AXI_BVALID;
  wire [511:0]host_AXI4_clock_converter_M_AXI_RDATA;
  wire [15:0]host_AXI4_clock_converter_M_AXI_RID;
  wire host_AXI4_clock_converter_M_AXI_RLAST;
  wire host_AXI4_clock_converter_M_AXI_RREADY;
  wire [1:0]host_AXI4_clock_converter_M_AXI_RRESP;
  wire host_AXI4_clock_converter_M_AXI_RVALID;
  wire [511:0]host_AXI4_clock_converter_M_AXI_WDATA;
  wire host_AXI4_clock_converter_M_AXI_WLAST;
  wire host_AXI4_clock_converter_M_AXI_WREADY;
  wire [63:0]host_AXI4_clock_converter_M_AXI_WSTRB;
  wire host_AXI4_clock_converter_M_AXI_WVALID;
  wire m_env_ready_synchronizer_dest_out;
  wire [63:0]m_glcount_synchronizer_dest_out;
  wire m_halted_synchronizer_dest_out;
  wire [63:0]mkAWSteria_HW_0_ddr_A_M_ARADDR;
  wire [1:0]mkAWSteria_HW_0_ddr_A_M_ARBURST;
  wire [3:0]mkAWSteria_HW_0_ddr_A_M_ARCACHE;
  wire [15:0]mkAWSteria_HW_0_ddr_A_M_ARID;
  wire [7:0]mkAWSteria_HW_0_ddr_A_M_ARLEN;
  wire mkAWSteria_HW_0_ddr_A_M_ARLOCK;
  wire [2:0]mkAWSteria_HW_0_ddr_A_M_ARPROT;
  wire [3:0]mkAWSteria_HW_0_ddr_A_M_ARQOS;
  wire mkAWSteria_HW_0_ddr_A_M_ARREADY;
  wire [3:0]mkAWSteria_HW_0_ddr_A_M_ARREGION;
  wire [2:0]mkAWSteria_HW_0_ddr_A_M_ARSIZE;
  wire mkAWSteria_HW_0_ddr_A_M_ARVALID;
  wire [63:0]mkAWSteria_HW_0_ddr_A_M_AWADDR;
  wire [1:0]mkAWSteria_HW_0_ddr_A_M_AWBURST;
  wire [3:0]mkAWSteria_HW_0_ddr_A_M_AWCACHE;
  wire [15:0]mkAWSteria_HW_0_ddr_A_M_AWID;
  wire [7:0]mkAWSteria_HW_0_ddr_A_M_AWLEN;
  wire mkAWSteria_HW_0_ddr_A_M_AWLOCK;
  wire [2:0]mkAWSteria_HW_0_ddr_A_M_AWPROT;
  wire [3:0]mkAWSteria_HW_0_ddr_A_M_AWQOS;
  wire mkAWSteria_HW_0_ddr_A_M_AWREADY;
  wire [3:0]mkAWSteria_HW_0_ddr_A_M_AWREGION;
  wire [2:0]mkAWSteria_HW_0_ddr_A_M_AWSIZE;
  wire mkAWSteria_HW_0_ddr_A_M_AWVALID;
  wire [15:0]mkAWSteria_HW_0_ddr_A_M_BID;
  wire mkAWSteria_HW_0_ddr_A_M_BREADY;
  wire [1:0]mkAWSteria_HW_0_ddr_A_M_BRESP;
  wire mkAWSteria_HW_0_ddr_A_M_BVALID;
  wire [511:0]mkAWSteria_HW_0_ddr_A_M_RDATA;
  wire [15:0]mkAWSteria_HW_0_ddr_A_M_RID;
  wire mkAWSteria_HW_0_ddr_A_M_RLAST;
  wire mkAWSteria_HW_0_ddr_A_M_RREADY;
  wire [1:0]mkAWSteria_HW_0_ddr_A_M_RRESP;
  wire mkAWSteria_HW_0_ddr_A_M_RVALID;
  wire [511:0]mkAWSteria_HW_0_ddr_A_M_WDATA;
  wire mkAWSteria_HW_0_ddr_A_M_WLAST;
  wire mkAWSteria_HW_0_ddr_A_M_WREADY;
  wire [63:0]mkAWSteria_HW_0_ddr_A_M_WSTRB;
  wire mkAWSteria_HW_0_ddr_A_M_WVALID;
  wire [63:0]mkAWSteria_HW_0_ddr_B_M_ARADDR;
  wire [1:0]mkAWSteria_HW_0_ddr_B_M_ARBURST;
  wire [3:0]mkAWSteria_HW_0_ddr_B_M_ARCACHE;
  wire [15:0]mkAWSteria_HW_0_ddr_B_M_ARID;
  wire [7:0]mkAWSteria_HW_0_ddr_B_M_ARLEN;
  wire mkAWSteria_HW_0_ddr_B_M_ARLOCK;
  wire [2:0]mkAWSteria_HW_0_ddr_B_M_ARPROT;
  wire [3:0]mkAWSteria_HW_0_ddr_B_M_ARQOS;
  wire mkAWSteria_HW_0_ddr_B_M_ARREADY;
  wire [3:0]mkAWSteria_HW_0_ddr_B_M_ARREGION;
  wire [2:0]mkAWSteria_HW_0_ddr_B_M_ARSIZE;
  wire mkAWSteria_HW_0_ddr_B_M_ARVALID;
  wire [63:0]mkAWSteria_HW_0_ddr_B_M_AWADDR;
  wire [1:0]mkAWSteria_HW_0_ddr_B_M_AWBURST;
  wire [3:0]mkAWSteria_HW_0_ddr_B_M_AWCACHE;
  wire [15:0]mkAWSteria_HW_0_ddr_B_M_AWID;
  wire [7:0]mkAWSteria_HW_0_ddr_B_M_AWLEN;
  wire mkAWSteria_HW_0_ddr_B_M_AWLOCK;
  wire [2:0]mkAWSteria_HW_0_ddr_B_M_AWPROT;
  wire [3:0]mkAWSteria_HW_0_ddr_B_M_AWQOS;
  wire mkAWSteria_HW_0_ddr_B_M_AWREADY;
  wire [3:0]mkAWSteria_HW_0_ddr_B_M_AWREGION;
  wire [2:0]mkAWSteria_HW_0_ddr_B_M_AWSIZE;
  wire mkAWSteria_HW_0_ddr_B_M_AWVALID;
  wire [15:0]mkAWSteria_HW_0_ddr_B_M_BID;
  wire mkAWSteria_HW_0_ddr_B_M_BREADY;
  wire [1:0]mkAWSteria_HW_0_ddr_B_M_BRESP;
  wire mkAWSteria_HW_0_ddr_B_M_BVALID;
  wire [511:0]mkAWSteria_HW_0_ddr_B_M_RDATA;
  wire [15:0]mkAWSteria_HW_0_ddr_B_M_RID;
  wire mkAWSteria_HW_0_ddr_B_M_RLAST;
  wire mkAWSteria_HW_0_ddr_B_M_RREADY;
  wire [1:0]mkAWSteria_HW_0_ddr_B_M_RRESP;
  wire mkAWSteria_HW_0_ddr_B_M_RVALID;
  wire [511:0]mkAWSteria_HW_0_ddr_B_M_WDATA;
  wire mkAWSteria_HW_0_ddr_B_M_WLAST;
  wire mkAWSteria_HW_0_ddr_B_M_WREADY;
  wire [63:0]mkAWSteria_HW_0_ddr_B_M_WSTRB;
  wire mkAWSteria_HW_0_ddr_B_M_WVALID;
  wire mkAWSteria_HW_0_m_halted;
  wire resetn_0_1;
  wire src_in_0_1;
  wire [63:0]src_in_0_2;

  assign S_AXI_0_1_ARADDR = host_AXI4L_S_araddr[31:0];
  assign S_AXI_0_1_ARPROT = host_AXI4L_S_arprot[2:0];
  assign S_AXI_0_1_ARVALID = host_AXI4L_S_arvalid;
  assign S_AXI_0_1_AWADDR = host_AXI4L_S_awaddr[31:0];
  assign S_AXI_0_1_AWPROT = host_AXI4L_S_awprot[2:0];
  assign S_AXI_0_1_AWVALID = host_AXI4L_S_awvalid;
  assign S_AXI_0_1_BREADY = host_AXI4L_S_bready;
  assign S_AXI_0_1_RREADY = host_AXI4L_S_rready;
  assign S_AXI_0_1_WDATA = host_AXI4L_S_wdata[31:0];
  assign S_AXI_0_1_WSTRB = host_AXI4L_S_wstrb[3:0];
  assign S_AXI_0_1_WVALID = host_AXI4L_S_wvalid;
  assign S_AXI_0_2_ARADDR = host_AXI4_S_araddr[63:0];
  assign S_AXI_0_2_ARBURST = host_AXI4_S_arburst[1:0];
  assign S_AXI_0_2_ARCACHE = host_AXI4_S_arcache[3:0];
  assign S_AXI_0_2_ARID = host_AXI4_S_arid[15:0];
  assign S_AXI_0_2_ARLEN = host_AXI4_S_arlen[7:0];
  assign S_AXI_0_2_ARLOCK = host_AXI4_S_arlock[0];
  assign S_AXI_0_2_ARPROT = host_AXI4_S_arprot[2:0];
  assign S_AXI_0_2_ARQOS = host_AXI4_S_arqos[3:0];
  assign S_AXI_0_2_ARREGION = host_AXI4_S_arregion[3:0];
  assign S_AXI_0_2_ARSIZE = host_AXI4_S_arsize[2:0];
  assign S_AXI_0_2_ARVALID = host_AXI4_S_arvalid;
  assign S_AXI_0_2_AWADDR = host_AXI4_S_awaddr[63:0];
  assign S_AXI_0_2_AWBURST = host_AXI4_S_awburst[1:0];
  assign S_AXI_0_2_AWCACHE = host_AXI4_S_awcache[3:0];
  assign S_AXI_0_2_AWID = host_AXI4_S_awid[15:0];
  assign S_AXI_0_2_AWLEN = host_AXI4_S_awlen[7:0];
  assign S_AXI_0_2_AWLOCK = host_AXI4_S_awlock[0];
  assign S_AXI_0_2_AWPROT = host_AXI4_S_awprot[2:0];
  assign S_AXI_0_2_AWQOS = host_AXI4_S_awqos[3:0];
  assign S_AXI_0_2_AWREGION = host_AXI4_S_awregion[3:0];
  assign S_AXI_0_2_AWSIZE = host_AXI4_S_awsize[2:0];
  assign S_AXI_0_2_AWVALID = host_AXI4_S_awvalid;
  assign S_AXI_0_2_BREADY = host_AXI4_S_bready;
  assign S_AXI_0_2_RREADY = host_AXI4_S_rready;
  assign S_AXI_0_2_WDATA = host_AXI4_S_wdata[511:0];
  assign S_AXI_0_2_WLAST = host_AXI4_S_wlast;
  assign S_AXI_0_2_WSTRB = host_AXI4_S_wstrb[63:0];
  assign S_AXI_0_2_WVALID = host_AXI4_S_wvalid;
  assign clk_in1_0_1 = CLK;
  assign ddr_A_M_araddr[63:0] = ddr_A_clock_converter_M_AXI_ARADDR;
  assign ddr_A_M_arburst[1:0] = ddr_A_clock_converter_M_AXI_ARBURST;
  assign ddr_A_M_arcache[3:0] = ddr_A_clock_converter_M_AXI_ARCACHE;
  assign ddr_A_M_arid[15:0] = ddr_A_clock_converter_M_AXI_ARID;
  assign ddr_A_M_arlen[7:0] = ddr_A_clock_converter_M_AXI_ARLEN;
  assign ddr_A_M_arlock[0] = ddr_A_clock_converter_M_AXI_ARLOCK;
  assign ddr_A_M_arprot[2:0] = ddr_A_clock_converter_M_AXI_ARPROT;
  assign ddr_A_M_arqos[3:0] = ddr_A_clock_converter_M_AXI_ARQOS;
  assign ddr_A_M_arregion[3:0] = ddr_A_clock_converter_M_AXI_ARREGION;
  assign ddr_A_M_arsize[2:0] = ddr_A_clock_converter_M_AXI_ARSIZE;
  assign ddr_A_M_arvalid = ddr_A_clock_converter_M_AXI_ARVALID;
  assign ddr_A_M_awaddr[63:0] = ddr_A_clock_converter_M_AXI_AWADDR;
  assign ddr_A_M_awburst[1:0] = ddr_A_clock_converter_M_AXI_AWBURST;
  assign ddr_A_M_awcache[3:0] = ddr_A_clock_converter_M_AXI_AWCACHE;
  assign ddr_A_M_awid[15:0] = ddr_A_clock_converter_M_AXI_AWID;
  assign ddr_A_M_awlen[7:0] = ddr_A_clock_converter_M_AXI_AWLEN;
  assign ddr_A_M_awlock[0] = ddr_A_clock_converter_M_AXI_AWLOCK;
  assign ddr_A_M_awprot[2:0] = ddr_A_clock_converter_M_AXI_AWPROT;
  assign ddr_A_M_awqos[3:0] = ddr_A_clock_converter_M_AXI_AWQOS;
  assign ddr_A_M_awregion[3:0] = ddr_A_clock_converter_M_AXI_AWREGION;
  assign ddr_A_M_awsize[2:0] = ddr_A_clock_converter_M_AXI_AWSIZE;
  assign ddr_A_M_awvalid = ddr_A_clock_converter_M_AXI_AWVALID;
  assign ddr_A_M_bready = ddr_A_clock_converter_M_AXI_BREADY;
  assign ddr_A_M_rready = ddr_A_clock_converter_M_AXI_RREADY;
  assign ddr_A_M_wdata[511:0] = ddr_A_clock_converter_M_AXI_WDATA;
  assign ddr_A_M_wlast = ddr_A_clock_converter_M_AXI_WLAST;
  assign ddr_A_M_wstrb[63:0] = ddr_A_clock_converter_M_AXI_WSTRB;
  assign ddr_A_M_wvalid = ddr_A_clock_converter_M_AXI_WVALID;
  assign ddr_A_clock_converter_M_AXI_ARREADY = ddr_A_M_arready;
  assign ddr_A_clock_converter_M_AXI_AWREADY = ddr_A_M_awready;
  assign ddr_A_clock_converter_M_AXI_BID = ddr_A_M_bid[15:0];
  assign ddr_A_clock_converter_M_AXI_BRESP = ddr_A_M_bresp[1:0];
  assign ddr_A_clock_converter_M_AXI_BVALID = ddr_A_M_bvalid;
  assign ddr_A_clock_converter_M_AXI_RDATA = ddr_A_M_rdata[511:0];
  assign ddr_A_clock_converter_M_AXI_RID = ddr_A_M_rid[15:0];
  assign ddr_A_clock_converter_M_AXI_RLAST = ddr_A_M_rlast;
  assign ddr_A_clock_converter_M_AXI_RRESP = ddr_A_M_rresp[1:0];
  assign ddr_A_clock_converter_M_AXI_RVALID = ddr_A_M_rvalid;
  assign ddr_A_clock_converter_M_AXI_WREADY = ddr_A_M_wready;
  assign ddr_B_M_araddr[63:0] = ddr_B_clock_converter_M_AXI_ARADDR;
  assign ddr_B_M_arburst[1:0] = ddr_B_clock_converter_M_AXI_ARBURST;
  assign ddr_B_M_arcache[3:0] = ddr_B_clock_converter_M_AXI_ARCACHE;
  assign ddr_B_M_arid[15:0] = ddr_B_clock_converter_M_AXI_ARID;
  assign ddr_B_M_arlen[7:0] = ddr_B_clock_converter_M_AXI_ARLEN;
  assign ddr_B_M_arlock[0] = ddr_B_clock_converter_M_AXI_ARLOCK;
  assign ddr_B_M_arprot[2:0] = ddr_B_clock_converter_M_AXI_ARPROT;
  assign ddr_B_M_arqos[3:0] = ddr_B_clock_converter_M_AXI_ARQOS;
  assign ddr_B_M_arregion[3:0] = ddr_B_clock_converter_M_AXI_ARREGION;
  assign ddr_B_M_arsize[2:0] = ddr_B_clock_converter_M_AXI_ARSIZE;
  assign ddr_B_M_arvalid = ddr_B_clock_converter_M_AXI_ARVALID;
  assign ddr_B_M_awaddr[63:0] = ddr_B_clock_converter_M_AXI_AWADDR;
  assign ddr_B_M_awburst[1:0] = ddr_B_clock_converter_M_AXI_AWBURST;
  assign ddr_B_M_awcache[3:0] = ddr_B_clock_converter_M_AXI_AWCACHE;
  assign ddr_B_M_awid[15:0] = ddr_B_clock_converter_M_AXI_AWID;
  assign ddr_B_M_awlen[7:0] = ddr_B_clock_converter_M_AXI_AWLEN;
  assign ddr_B_M_awlock[0] = ddr_B_clock_converter_M_AXI_AWLOCK;
  assign ddr_B_M_awprot[2:0] = ddr_B_clock_converter_M_AXI_AWPROT;
  assign ddr_B_M_awqos[3:0] = ddr_B_clock_converter_M_AXI_AWQOS;
  assign ddr_B_M_awregion[3:0] = ddr_B_clock_converter_M_AXI_AWREGION;
  assign ddr_B_M_awsize[2:0] = ddr_B_clock_converter_M_AXI_AWSIZE;
  assign ddr_B_M_awvalid = ddr_B_clock_converter_M_AXI_AWVALID;
  assign ddr_B_M_bready = ddr_B_clock_converter_M_AXI_BREADY;
  assign ddr_B_M_rready = ddr_B_clock_converter_M_AXI_RREADY;
  assign ddr_B_M_wdata[511:0] = ddr_B_clock_converter_M_AXI_WDATA;
  assign ddr_B_M_wlast = ddr_B_clock_converter_M_AXI_WLAST;
  assign ddr_B_M_wstrb[63:0] = ddr_B_clock_converter_M_AXI_WSTRB;
  assign ddr_B_M_wvalid = ddr_B_clock_converter_M_AXI_WVALID;
  assign ddr_B_clock_converter_M_AXI_ARREADY = ddr_B_M_arready;
  assign ddr_B_clock_converter_M_AXI_AWREADY = ddr_B_M_awready;
  assign ddr_B_clock_converter_M_AXI_BID = ddr_B_M_bid[15:0];
  assign ddr_B_clock_converter_M_AXI_BRESP = ddr_B_M_bresp[1:0];
  assign ddr_B_clock_converter_M_AXI_BVALID = ddr_B_M_bvalid;
  assign ddr_B_clock_converter_M_AXI_RDATA = ddr_B_M_rdata[511:0];
  assign ddr_B_clock_converter_M_AXI_RID = ddr_B_M_rid[15:0];
  assign ddr_B_clock_converter_M_AXI_RLAST = ddr_B_M_rlast;
  assign ddr_B_clock_converter_M_AXI_RRESP = ddr_B_M_rresp[1:0];
  assign ddr_B_clock_converter_M_AXI_RVALID = ddr_B_M_rvalid;
  assign ddr_B_clock_converter_M_AXI_WREADY = ddr_B_M_wready;
  assign host_AXI4L_S_arready = S_AXI_0_1_ARREADY;
  assign host_AXI4L_S_awready = S_AXI_0_1_AWREADY;
  assign host_AXI4L_S_bresp[1:0] = S_AXI_0_1_BRESP;
  assign host_AXI4L_S_bvalid = S_AXI_0_1_BVALID;
  assign host_AXI4L_S_rdata[31:0] = S_AXI_0_1_RDATA;
  assign host_AXI4L_S_rresp[1:0] = S_AXI_0_1_RRESP;
  assign host_AXI4L_S_rvalid = S_AXI_0_1_RVALID;
  assign host_AXI4L_S_wready = S_AXI_0_1_WREADY;
  assign host_AXI4_S_arready = S_AXI_0_2_ARREADY;
  assign host_AXI4_S_awready = S_AXI_0_2_AWREADY;
  assign host_AXI4_S_bid[15:0] = S_AXI_0_2_BID;
  assign host_AXI4_S_bresp[1:0] = S_AXI_0_2_BRESP;
  assign host_AXI4_S_bvalid = S_AXI_0_2_BVALID;
  assign host_AXI4_S_rdata[511:0] = S_AXI_0_2_RDATA;
  assign host_AXI4_S_rid[15:0] = S_AXI_0_2_RID;
  assign host_AXI4_S_rlast = S_AXI_0_2_RLAST;
  assign host_AXI4_S_rresp[1:0] = S_AXI_0_2_RRESP;
  assign host_AXI4_S_rvalid = S_AXI_0_2_RVALID;
  assign host_AXI4_S_wready = S_AXI_0_2_WREADY;
  assign m_halted = m_halted_synchronizer_dest_out;
  assign resetn_0_1 = RST_N;
  assign src_in_0_1 = m_env_ready_env_ready;
  assign src_in_0_2 = m_glcount_glcount[63:0];
  mkAWSteria_HW_reclocked_reset_synchronizer_0_0 clk_out1_reset_synchronizer
       (.dest_clk(clk_wiz_0_clk_out1),
        .dest_resetn(clk_out1_reset_synchronizer_dest_resetn),
        .src_resetn(resetn_0_1));
  mkAWSteria_HW_reclocked_reset_synchronizer_0_1 clk_out2_reset_synchronizer
       (.dest_clk(clk_wiz_0_clk_out2),
        .dest_resetn(clk_out2_reset_synchronizer_dest_resetn),
        .src_resetn(resetn_0_1));
  mkAWSteria_HW_reclocked_clk_wiz_0_0 clk_wiz_0
       (.clk_in1(clk_in1_0_1),
        .clk_out1(clk_wiz_0_clk_out1),
        .clk_out2(clk_wiz_0_clk_out2),
        .resetn(resetn_0_1));
  mkAWSteria_HW_reclocked_host_AXI4_clock_converter_0 ddr_A_clock_converter
       (.m_axi_aclk(clk_in1_0_1),
        .m_axi_araddr(ddr_A_clock_converter_M_AXI_ARADDR),
        .m_axi_arburst(ddr_A_clock_converter_M_AXI_ARBURST),
        .m_axi_arcache(ddr_A_clock_converter_M_AXI_ARCACHE),
        .m_axi_aresetn(resetn_0_1),
        .m_axi_arid(ddr_A_clock_converter_M_AXI_ARID),
        .m_axi_arlen(ddr_A_clock_converter_M_AXI_ARLEN),
        .m_axi_arlock(ddr_A_clock_converter_M_AXI_ARLOCK),
        .m_axi_arprot(ddr_A_clock_converter_M_AXI_ARPROT),
        .m_axi_arqos(ddr_A_clock_converter_M_AXI_ARQOS),
        .m_axi_arready(ddr_A_clock_converter_M_AXI_ARREADY),
        .m_axi_arregion(ddr_A_clock_converter_M_AXI_ARREGION),
        .m_axi_arsize(ddr_A_clock_converter_M_AXI_ARSIZE),
        .m_axi_arvalid(ddr_A_clock_converter_M_AXI_ARVALID),
        .m_axi_awaddr(ddr_A_clock_converter_M_AXI_AWADDR),
        .m_axi_awburst(ddr_A_clock_converter_M_AXI_AWBURST),
        .m_axi_awcache(ddr_A_clock_converter_M_AXI_AWCACHE),
        .m_axi_awid(ddr_A_clock_converter_M_AXI_AWID),
        .m_axi_awlen(ddr_A_clock_converter_M_AXI_AWLEN),
        .m_axi_awlock(ddr_A_clock_converter_M_AXI_AWLOCK),
        .m_axi_awprot(ddr_A_clock_converter_M_AXI_AWPROT),
        .m_axi_awqos(ddr_A_clock_converter_M_AXI_AWQOS),
        .m_axi_awready(ddr_A_clock_converter_M_AXI_AWREADY),
        .m_axi_awregion(ddr_A_clock_converter_M_AXI_AWREGION),
        .m_axi_awsize(ddr_A_clock_converter_M_AXI_AWSIZE),
        .m_axi_awvalid(ddr_A_clock_converter_M_AXI_AWVALID),
        .m_axi_bid(ddr_A_clock_converter_M_AXI_BID),
        .m_axi_bready(ddr_A_clock_converter_M_AXI_BREADY),
        .m_axi_bresp(ddr_A_clock_converter_M_AXI_BRESP),
        .m_axi_bvalid(ddr_A_clock_converter_M_AXI_BVALID),
        .m_axi_rdata(ddr_A_clock_converter_M_AXI_RDATA),
        .m_axi_rid(ddr_A_clock_converter_M_AXI_RID),
        .m_axi_rlast(ddr_A_clock_converter_M_AXI_RLAST),
        .m_axi_rready(ddr_A_clock_converter_M_AXI_RREADY),
        .m_axi_rresp(ddr_A_clock_converter_M_AXI_RRESP),
        .m_axi_rvalid(ddr_A_clock_converter_M_AXI_RVALID),
        .m_axi_wdata(ddr_A_clock_converter_M_AXI_WDATA),
        .m_axi_wlast(ddr_A_clock_converter_M_AXI_WLAST),
        .m_axi_wready(ddr_A_clock_converter_M_AXI_WREADY),
        .m_axi_wstrb(ddr_A_clock_converter_M_AXI_WSTRB),
        .m_axi_wvalid(ddr_A_clock_converter_M_AXI_WVALID),
        .s_axi_aclk(clk_wiz_0_clk_out1),
        .s_axi_araddr(mkAWSteria_HW_0_ddr_A_M_ARADDR),
        .s_axi_arburst(mkAWSteria_HW_0_ddr_A_M_ARBURST),
        .s_axi_arcache(mkAWSteria_HW_0_ddr_A_M_ARCACHE),
        .s_axi_aresetn(clk_out1_reset_synchronizer_dest_resetn),
        .s_axi_arid(mkAWSteria_HW_0_ddr_A_M_ARID),
        .s_axi_arlen(mkAWSteria_HW_0_ddr_A_M_ARLEN),
        .s_axi_arlock(mkAWSteria_HW_0_ddr_A_M_ARLOCK),
        .s_axi_arprot(mkAWSteria_HW_0_ddr_A_M_ARPROT),
        .s_axi_arqos(mkAWSteria_HW_0_ddr_A_M_ARQOS),
        .s_axi_arready(mkAWSteria_HW_0_ddr_A_M_ARREADY),
        .s_axi_arregion(mkAWSteria_HW_0_ddr_A_M_ARREGION),
        .s_axi_arsize(mkAWSteria_HW_0_ddr_A_M_ARSIZE),
        .s_axi_arvalid(mkAWSteria_HW_0_ddr_A_M_ARVALID),
        .s_axi_awaddr(mkAWSteria_HW_0_ddr_A_M_AWADDR),
        .s_axi_awburst(mkAWSteria_HW_0_ddr_A_M_AWBURST),
        .s_axi_awcache(mkAWSteria_HW_0_ddr_A_M_AWCACHE),
        .s_axi_awid(mkAWSteria_HW_0_ddr_A_M_AWID),
        .s_axi_awlen(mkAWSteria_HW_0_ddr_A_M_AWLEN),
        .s_axi_awlock(mkAWSteria_HW_0_ddr_A_M_AWLOCK),
        .s_axi_awprot(mkAWSteria_HW_0_ddr_A_M_AWPROT),
        .s_axi_awqos(mkAWSteria_HW_0_ddr_A_M_AWQOS),
        .s_axi_awready(mkAWSteria_HW_0_ddr_A_M_AWREADY),
        .s_axi_awregion(mkAWSteria_HW_0_ddr_A_M_AWREGION),
        .s_axi_awsize(mkAWSteria_HW_0_ddr_A_M_AWSIZE),
        .s_axi_awvalid(mkAWSteria_HW_0_ddr_A_M_AWVALID),
        .s_axi_bid(mkAWSteria_HW_0_ddr_A_M_BID),
        .s_axi_bready(mkAWSteria_HW_0_ddr_A_M_BREADY),
        .s_axi_bresp(mkAWSteria_HW_0_ddr_A_M_BRESP),
        .s_axi_bvalid(mkAWSteria_HW_0_ddr_A_M_BVALID),
        .s_axi_rdata(mkAWSteria_HW_0_ddr_A_M_RDATA),
        .s_axi_rid(mkAWSteria_HW_0_ddr_A_M_RID),
        .s_axi_rlast(mkAWSteria_HW_0_ddr_A_M_RLAST),
        .s_axi_rready(mkAWSteria_HW_0_ddr_A_M_RREADY),
        .s_axi_rresp(mkAWSteria_HW_0_ddr_A_M_RRESP),
        .s_axi_rvalid(mkAWSteria_HW_0_ddr_A_M_RVALID),
        .s_axi_wdata(mkAWSteria_HW_0_ddr_A_M_WDATA),
        .s_axi_wlast(mkAWSteria_HW_0_ddr_A_M_WLAST),
        .s_axi_wready(mkAWSteria_HW_0_ddr_A_M_WREADY),
        .s_axi_wstrb(mkAWSteria_HW_0_ddr_A_M_WSTRB),
        .s_axi_wvalid(mkAWSteria_HW_0_ddr_A_M_WVALID));
  mkAWSteria_HW_reclocked_ddr_A_clock_converter_0 ddr_B_clock_converter
       (.m_axi_aclk(clk_in1_0_1),
        .m_axi_araddr(ddr_B_clock_converter_M_AXI_ARADDR),
        .m_axi_arburst(ddr_B_clock_converter_M_AXI_ARBURST),
        .m_axi_arcache(ddr_B_clock_converter_M_AXI_ARCACHE),
        .m_axi_aresetn(resetn_0_1),
        .m_axi_arid(ddr_B_clock_converter_M_AXI_ARID),
        .m_axi_arlen(ddr_B_clock_converter_M_AXI_ARLEN),
        .m_axi_arlock(ddr_B_clock_converter_M_AXI_ARLOCK),
        .m_axi_arprot(ddr_B_clock_converter_M_AXI_ARPROT),
        .m_axi_arqos(ddr_B_clock_converter_M_AXI_ARQOS),
        .m_axi_arready(ddr_B_clock_converter_M_AXI_ARREADY),
        .m_axi_arregion(ddr_B_clock_converter_M_AXI_ARREGION),
        .m_axi_arsize(ddr_B_clock_converter_M_AXI_ARSIZE),
        .m_axi_arvalid(ddr_B_clock_converter_M_AXI_ARVALID),
        .m_axi_awaddr(ddr_B_clock_converter_M_AXI_AWADDR),
        .m_axi_awburst(ddr_B_clock_converter_M_AXI_AWBURST),
        .m_axi_awcache(ddr_B_clock_converter_M_AXI_AWCACHE),
        .m_axi_awid(ddr_B_clock_converter_M_AXI_AWID),
        .m_axi_awlen(ddr_B_clock_converter_M_AXI_AWLEN),
        .m_axi_awlock(ddr_B_clock_converter_M_AXI_AWLOCK),
        .m_axi_awprot(ddr_B_clock_converter_M_AXI_AWPROT),
        .m_axi_awqos(ddr_B_clock_converter_M_AXI_AWQOS),
        .m_axi_awready(ddr_B_clock_converter_M_AXI_AWREADY),
        .m_axi_awregion(ddr_B_clock_converter_M_AXI_AWREGION),
        .m_axi_awsize(ddr_B_clock_converter_M_AXI_AWSIZE),
        .m_axi_awvalid(ddr_B_clock_converter_M_AXI_AWVALID),
        .m_axi_bid(ddr_B_clock_converter_M_AXI_BID),
        .m_axi_bready(ddr_B_clock_converter_M_AXI_BREADY),
        .m_axi_bresp(ddr_B_clock_converter_M_AXI_BRESP),
        .m_axi_bvalid(ddr_B_clock_converter_M_AXI_BVALID),
        .m_axi_rdata(ddr_B_clock_converter_M_AXI_RDATA),
        .m_axi_rid(ddr_B_clock_converter_M_AXI_RID),
        .m_axi_rlast(ddr_B_clock_converter_M_AXI_RLAST),
        .m_axi_rready(ddr_B_clock_converter_M_AXI_RREADY),
        .m_axi_rresp(ddr_B_clock_converter_M_AXI_RRESP),
        .m_axi_rvalid(ddr_B_clock_converter_M_AXI_RVALID),
        .m_axi_wdata(ddr_B_clock_converter_M_AXI_WDATA),
        .m_axi_wlast(ddr_B_clock_converter_M_AXI_WLAST),
        .m_axi_wready(ddr_B_clock_converter_M_AXI_WREADY),
        .m_axi_wstrb(ddr_B_clock_converter_M_AXI_WSTRB),
        .m_axi_wvalid(ddr_B_clock_converter_M_AXI_WVALID),
        .s_axi_aclk(clk_wiz_0_clk_out1),
        .s_axi_araddr(mkAWSteria_HW_0_ddr_B_M_ARADDR),
        .s_axi_arburst(mkAWSteria_HW_0_ddr_B_M_ARBURST),
        .s_axi_arcache(mkAWSteria_HW_0_ddr_B_M_ARCACHE),
        .s_axi_aresetn(clk_out1_reset_synchronizer_dest_resetn),
        .s_axi_arid(mkAWSteria_HW_0_ddr_B_M_ARID),
        .s_axi_arlen(mkAWSteria_HW_0_ddr_B_M_ARLEN),
        .s_axi_arlock(mkAWSteria_HW_0_ddr_B_M_ARLOCK),
        .s_axi_arprot(mkAWSteria_HW_0_ddr_B_M_ARPROT),
        .s_axi_arqos(mkAWSteria_HW_0_ddr_B_M_ARQOS),
        .s_axi_arready(mkAWSteria_HW_0_ddr_B_M_ARREADY),
        .s_axi_arregion(mkAWSteria_HW_0_ddr_B_M_ARREGION),
        .s_axi_arsize(mkAWSteria_HW_0_ddr_B_M_ARSIZE),
        .s_axi_arvalid(mkAWSteria_HW_0_ddr_B_M_ARVALID),
        .s_axi_awaddr(mkAWSteria_HW_0_ddr_B_M_AWADDR),
        .s_axi_awburst(mkAWSteria_HW_0_ddr_B_M_AWBURST),
        .s_axi_awcache(mkAWSteria_HW_0_ddr_B_M_AWCACHE),
        .s_axi_awid(mkAWSteria_HW_0_ddr_B_M_AWID),
        .s_axi_awlen(mkAWSteria_HW_0_ddr_B_M_AWLEN),
        .s_axi_awlock(mkAWSteria_HW_0_ddr_B_M_AWLOCK),
        .s_axi_awprot(mkAWSteria_HW_0_ddr_B_M_AWPROT),
        .s_axi_awqos(mkAWSteria_HW_0_ddr_B_M_AWQOS),
        .s_axi_awready(mkAWSteria_HW_0_ddr_B_M_AWREADY),
        .s_axi_awregion(mkAWSteria_HW_0_ddr_B_M_AWREGION),
        .s_axi_awsize(mkAWSteria_HW_0_ddr_B_M_AWSIZE),
        .s_axi_awvalid(mkAWSteria_HW_0_ddr_B_M_AWVALID),
        .s_axi_bid(mkAWSteria_HW_0_ddr_B_M_BID),
        .s_axi_bready(mkAWSteria_HW_0_ddr_B_M_BREADY),
        .s_axi_bresp(mkAWSteria_HW_0_ddr_B_M_BRESP),
        .s_axi_bvalid(mkAWSteria_HW_0_ddr_B_M_BVALID),
        .s_axi_rdata(mkAWSteria_HW_0_ddr_B_M_RDATA),
        .s_axi_rid(mkAWSteria_HW_0_ddr_B_M_RID),
        .s_axi_rlast(mkAWSteria_HW_0_ddr_B_M_RLAST),
        .s_axi_rready(mkAWSteria_HW_0_ddr_B_M_RREADY),
        .s_axi_rresp(mkAWSteria_HW_0_ddr_B_M_RRESP),
        .s_axi_rvalid(mkAWSteria_HW_0_ddr_B_M_RVALID),
        .s_axi_wdata(mkAWSteria_HW_0_ddr_B_M_WDATA),
        .s_axi_wlast(mkAWSteria_HW_0_ddr_B_M_WLAST),
        .s_axi_wready(mkAWSteria_HW_0_ddr_B_M_WREADY),
        .s_axi_wstrb(mkAWSteria_HW_0_ddr_B_M_WSTRB),
        .s_axi_wvalid(mkAWSteria_HW_0_ddr_B_M_WVALID));
  mkAWSteria_HW_reclocked_axi_clock_converter_0_0 host_AXI4L_clock_converter
       (.m_axi_aclk(clk_wiz_0_clk_out1),
        .m_axi_araddr(host_AXI4L_clock_converter_M_AXI_ARADDR),
        .m_axi_aresetn(clk_out1_reset_synchronizer_dest_resetn),
        .m_axi_arprot(host_AXI4L_clock_converter_M_AXI_ARPROT),
        .m_axi_arready(host_AXI4L_clock_converter_M_AXI_ARREADY),
        .m_axi_arvalid(host_AXI4L_clock_converter_M_AXI_ARVALID),
        .m_axi_awaddr(host_AXI4L_clock_converter_M_AXI_AWADDR),
        .m_axi_awprot(host_AXI4L_clock_converter_M_AXI_AWPROT),
        .m_axi_awready(host_AXI4L_clock_converter_M_AXI_AWREADY),
        .m_axi_awvalid(host_AXI4L_clock_converter_M_AXI_AWVALID),
        .m_axi_bready(host_AXI4L_clock_converter_M_AXI_BREADY),
        .m_axi_bresp(host_AXI4L_clock_converter_M_AXI_BRESP),
        .m_axi_bvalid(host_AXI4L_clock_converter_M_AXI_BVALID),
        .m_axi_rdata(host_AXI4L_clock_converter_M_AXI_RDATA),
        .m_axi_rready(host_AXI4L_clock_converter_M_AXI_RREADY),
        .m_axi_rresp(host_AXI4L_clock_converter_M_AXI_RRESP),
        .m_axi_rvalid(host_AXI4L_clock_converter_M_AXI_RVALID),
        .m_axi_wdata(host_AXI4L_clock_converter_M_AXI_WDATA),
        .m_axi_wready(host_AXI4L_clock_converter_M_AXI_WREADY),
        .m_axi_wstrb(host_AXI4L_clock_converter_M_AXI_WSTRB),
        .m_axi_wvalid(host_AXI4L_clock_converter_M_AXI_WVALID),
        .s_axi_aclk(clk_in1_0_1),
        .s_axi_araddr(S_AXI_0_1_ARADDR),
        .s_axi_aresetn(resetn_0_1),
        .s_axi_arprot(S_AXI_0_1_ARPROT),
        .s_axi_arready(S_AXI_0_1_ARREADY),
        .s_axi_arvalid(S_AXI_0_1_ARVALID),
        .s_axi_awaddr(S_AXI_0_1_AWADDR),
        .s_axi_awprot(S_AXI_0_1_AWPROT),
        .s_axi_awready(S_AXI_0_1_AWREADY),
        .s_axi_awvalid(S_AXI_0_1_AWVALID),
        .s_axi_bready(S_AXI_0_1_BREADY),
        .s_axi_bresp(S_AXI_0_1_BRESP),
        .s_axi_bvalid(S_AXI_0_1_BVALID),
        .s_axi_rdata(S_AXI_0_1_RDATA),
        .s_axi_rready(S_AXI_0_1_RREADY),
        .s_axi_rresp(S_AXI_0_1_RRESP),
        .s_axi_rvalid(S_AXI_0_1_RVALID),
        .s_axi_wdata(S_AXI_0_1_WDATA),
        .s_axi_wready(S_AXI_0_1_WREADY),
        .s_axi_wstrb(S_AXI_0_1_WSTRB),
        .s_axi_wvalid(S_AXI_0_1_WVALID));
  mkAWSteria_HW_reclocked_axi_clock_converter_0_1 host_AXI4_clock_converter
       (.m_axi_aclk(clk_wiz_0_clk_out1),
        .m_axi_araddr(host_AXI4_clock_converter_M_AXI_ARADDR),
        .m_axi_arburst(host_AXI4_clock_converter_M_AXI_ARBURST),
        .m_axi_arcache(host_AXI4_clock_converter_M_AXI_ARCACHE),
        .m_axi_aresetn(clk_out1_reset_synchronizer_dest_resetn),
        .m_axi_arid(host_AXI4_clock_converter_M_AXI_ARID),
        .m_axi_arlen(host_AXI4_clock_converter_M_AXI_ARLEN),
        .m_axi_arlock(host_AXI4_clock_converter_M_AXI_ARLOCK),
        .m_axi_arprot(host_AXI4_clock_converter_M_AXI_ARPROT),
        .m_axi_arqos(host_AXI4_clock_converter_M_AXI_ARQOS),
        .m_axi_arready(host_AXI4_clock_converter_M_AXI_ARREADY),
        .m_axi_arregion(host_AXI4_clock_converter_M_AXI_ARREGION),
        .m_axi_arsize(host_AXI4_clock_converter_M_AXI_ARSIZE),
        .m_axi_arvalid(host_AXI4_clock_converter_M_AXI_ARVALID),
        .m_axi_awaddr(host_AXI4_clock_converter_M_AXI_AWADDR),
        .m_axi_awburst(host_AXI4_clock_converter_M_AXI_AWBURST),
        .m_axi_awcache(host_AXI4_clock_converter_M_AXI_AWCACHE),
        .m_axi_awid(host_AXI4_clock_converter_M_AXI_AWID),
        .m_axi_awlen(host_AXI4_clock_converter_M_AXI_AWLEN),
        .m_axi_awlock(host_AXI4_clock_converter_M_AXI_AWLOCK),
        .m_axi_awprot(host_AXI4_clock_converter_M_AXI_AWPROT),
        .m_axi_awqos(host_AXI4_clock_converter_M_AXI_AWQOS),
        .m_axi_awready(host_AXI4_clock_converter_M_AXI_AWREADY),
        .m_axi_awregion(host_AXI4_clock_converter_M_AXI_AWREGION),
        .m_axi_awsize(host_AXI4_clock_converter_M_AXI_AWSIZE),
        .m_axi_awvalid(host_AXI4_clock_converter_M_AXI_AWVALID),
        .m_axi_bid(host_AXI4_clock_converter_M_AXI_BID),
        .m_axi_bready(host_AXI4_clock_converter_M_AXI_BREADY),
        .m_axi_bresp(host_AXI4_clock_converter_M_AXI_BRESP),
        .m_axi_bvalid(host_AXI4_clock_converter_M_AXI_BVALID),
        .m_axi_rdata(host_AXI4_clock_converter_M_AXI_RDATA),
        .m_axi_rid(host_AXI4_clock_converter_M_AXI_RID),
        .m_axi_rlast(host_AXI4_clock_converter_M_AXI_RLAST),
        .m_axi_rready(host_AXI4_clock_converter_M_AXI_RREADY),
        .m_axi_rresp(host_AXI4_clock_converter_M_AXI_RRESP),
        .m_axi_rvalid(host_AXI4_clock_converter_M_AXI_RVALID),
        .m_axi_wdata(host_AXI4_clock_converter_M_AXI_WDATA),
        .m_axi_wlast(host_AXI4_clock_converter_M_AXI_WLAST),
        .m_axi_wready(host_AXI4_clock_converter_M_AXI_WREADY),
        .m_axi_wstrb(host_AXI4_clock_converter_M_AXI_WSTRB),
        .m_axi_wvalid(host_AXI4_clock_converter_M_AXI_WVALID),
        .s_axi_aclk(clk_in1_0_1),
        .s_axi_araddr(S_AXI_0_2_ARADDR),
        .s_axi_arburst(S_AXI_0_2_ARBURST),
        .s_axi_arcache(S_AXI_0_2_ARCACHE),
        .s_axi_aresetn(resetn_0_1),
        .s_axi_arid(S_AXI_0_2_ARID),
        .s_axi_arlen(S_AXI_0_2_ARLEN),
        .s_axi_arlock(S_AXI_0_2_ARLOCK),
        .s_axi_arprot(S_AXI_0_2_ARPROT),
        .s_axi_arqos(S_AXI_0_2_ARQOS),
        .s_axi_arready(S_AXI_0_2_ARREADY),
        .s_axi_arregion(S_AXI_0_2_ARREGION),
        .s_axi_arsize(S_AXI_0_2_ARSIZE),
        .s_axi_arvalid(S_AXI_0_2_ARVALID),
        .s_axi_awaddr(S_AXI_0_2_AWADDR),
        .s_axi_awburst(S_AXI_0_2_AWBURST),
        .s_axi_awcache(S_AXI_0_2_AWCACHE),
        .s_axi_awid(S_AXI_0_2_AWID),
        .s_axi_awlen(S_AXI_0_2_AWLEN),
        .s_axi_awlock(S_AXI_0_2_AWLOCK),
        .s_axi_awprot(S_AXI_0_2_AWPROT),
        .s_axi_awqos(S_AXI_0_2_AWQOS),
        .s_axi_awready(S_AXI_0_2_AWREADY),
        .s_axi_awregion(S_AXI_0_2_AWREGION),
        .s_axi_awsize(S_AXI_0_2_AWSIZE),
        .s_axi_awvalid(S_AXI_0_2_AWVALID),
        .s_axi_bid(S_AXI_0_2_BID),
        .s_axi_bready(S_AXI_0_2_BREADY),
        .s_axi_bresp(S_AXI_0_2_BRESP),
        .s_axi_bvalid(S_AXI_0_2_BVALID),
        .s_axi_rdata(S_AXI_0_2_RDATA),
        .s_axi_rid(S_AXI_0_2_RID),
        .s_axi_rlast(S_AXI_0_2_RLAST),
        .s_axi_rready(S_AXI_0_2_RREADY),
        .s_axi_rresp(S_AXI_0_2_RRESP),
        .s_axi_rvalid(S_AXI_0_2_RVALID),
        .s_axi_wdata(S_AXI_0_2_WDATA),
        .s_axi_wlast(S_AXI_0_2_WLAST),
        .s_axi_wready(S_AXI_0_2_WREADY),
        .s_axi_wstrb(S_AXI_0_2_WSTRB),
        .s_axi_wvalid(S_AXI_0_2_WVALID));
  mkAWSteria_HW_reclocked_bit_1_synchronizer_0_0 m_env_ready_synchronizer
       (.dest_clk(clk_wiz_0_clk_out1),
        .dest_out(m_env_ready_synchronizer_dest_out),
        .src_clk(clk_in1_0_1),
        .src_in(src_in_0_1));
  mkAWSteria_HW_reclocked_bit_64_synchronizer_0_0 m_glcount_synchronizer
       (.dest_clk(clk_wiz_0_clk_out1),
        .dest_out(m_glcount_synchronizer_dest_out),
        .src_clk(clk_in1_0_1),
        .src_in(src_in_0_2));
  mkAWSteria_HW_reclocked_bit_1_synchronizer_0_1 m_halted_synchronizer
       (.dest_clk(clk_in1_0_1),
        .dest_out(m_halted_synchronizer_dest_out),
        .src_clk(clk_wiz_0_clk_out1),
        .src_in(mkAWSteria_HW_0_m_halted));
  mkAWSteria_HW_reclocked_mkAWSteria_HW_0_0 mkAWSteria_HW_0
       (.CLK(clk_wiz_0_clk_out1),
        .CLK_b_CLK(clk_wiz_0_clk_out2),
        .RST_N(clk_out1_reset_synchronizer_dest_resetn),
        .RST_N_b_RST_N(clk_out2_reset_synchronizer_dest_resetn),
        .ddr_A_M_araddr(mkAWSteria_HW_0_ddr_A_M_ARADDR),
        .ddr_A_M_arburst(mkAWSteria_HW_0_ddr_A_M_ARBURST),
        .ddr_A_M_arcache(mkAWSteria_HW_0_ddr_A_M_ARCACHE),
        .ddr_A_M_arid(mkAWSteria_HW_0_ddr_A_M_ARID),
        .ddr_A_M_arlen(mkAWSteria_HW_0_ddr_A_M_ARLEN),
        .ddr_A_M_arlock(mkAWSteria_HW_0_ddr_A_M_ARLOCK),
        .ddr_A_M_arprot(mkAWSteria_HW_0_ddr_A_M_ARPROT),
        .ddr_A_M_arqos(mkAWSteria_HW_0_ddr_A_M_ARQOS),
        .ddr_A_M_arready(mkAWSteria_HW_0_ddr_A_M_ARREADY),
        .ddr_A_M_arregion(mkAWSteria_HW_0_ddr_A_M_ARREGION),
        .ddr_A_M_arsize(mkAWSteria_HW_0_ddr_A_M_ARSIZE),
        .ddr_A_M_arvalid(mkAWSteria_HW_0_ddr_A_M_ARVALID),
        .ddr_A_M_awaddr(mkAWSteria_HW_0_ddr_A_M_AWADDR),
        .ddr_A_M_awburst(mkAWSteria_HW_0_ddr_A_M_AWBURST),
        .ddr_A_M_awcache(mkAWSteria_HW_0_ddr_A_M_AWCACHE),
        .ddr_A_M_awid(mkAWSteria_HW_0_ddr_A_M_AWID),
        .ddr_A_M_awlen(mkAWSteria_HW_0_ddr_A_M_AWLEN),
        .ddr_A_M_awlock(mkAWSteria_HW_0_ddr_A_M_AWLOCK),
        .ddr_A_M_awprot(mkAWSteria_HW_0_ddr_A_M_AWPROT),
        .ddr_A_M_awqos(mkAWSteria_HW_0_ddr_A_M_AWQOS),
        .ddr_A_M_awready(mkAWSteria_HW_0_ddr_A_M_AWREADY),
        .ddr_A_M_awregion(mkAWSteria_HW_0_ddr_A_M_AWREGION),
        .ddr_A_M_awsize(mkAWSteria_HW_0_ddr_A_M_AWSIZE),
        .ddr_A_M_awvalid(mkAWSteria_HW_0_ddr_A_M_AWVALID),
        .ddr_A_M_bid(mkAWSteria_HW_0_ddr_A_M_BID),
        .ddr_A_M_bready(mkAWSteria_HW_0_ddr_A_M_BREADY),
        .ddr_A_M_bresp(mkAWSteria_HW_0_ddr_A_M_BRESP),
        .ddr_A_M_bvalid(mkAWSteria_HW_0_ddr_A_M_BVALID),
        .ddr_A_M_rdata(mkAWSteria_HW_0_ddr_A_M_RDATA),
        .ddr_A_M_rid(mkAWSteria_HW_0_ddr_A_M_RID),
        .ddr_A_M_rlast(mkAWSteria_HW_0_ddr_A_M_RLAST),
        .ddr_A_M_rready(mkAWSteria_HW_0_ddr_A_M_RREADY),
        .ddr_A_M_rresp(mkAWSteria_HW_0_ddr_A_M_RRESP),
        .ddr_A_M_rvalid(mkAWSteria_HW_0_ddr_A_M_RVALID),
        .ddr_A_M_wdata(mkAWSteria_HW_0_ddr_A_M_WDATA),
        .ddr_A_M_wlast(mkAWSteria_HW_0_ddr_A_M_WLAST),
        .ddr_A_M_wready(mkAWSteria_HW_0_ddr_A_M_WREADY),
        .ddr_A_M_wstrb(mkAWSteria_HW_0_ddr_A_M_WSTRB),
        .ddr_A_M_wvalid(mkAWSteria_HW_0_ddr_A_M_WVALID),
        .ddr_B_M_araddr(mkAWSteria_HW_0_ddr_B_M_ARADDR),
        .ddr_B_M_arburst(mkAWSteria_HW_0_ddr_B_M_ARBURST),
        .ddr_B_M_arcache(mkAWSteria_HW_0_ddr_B_M_ARCACHE),
        .ddr_B_M_arid(mkAWSteria_HW_0_ddr_B_M_ARID),
        .ddr_B_M_arlen(mkAWSteria_HW_0_ddr_B_M_ARLEN),
        .ddr_B_M_arlock(mkAWSteria_HW_0_ddr_B_M_ARLOCK),
        .ddr_B_M_arprot(mkAWSteria_HW_0_ddr_B_M_ARPROT),
        .ddr_B_M_arqos(mkAWSteria_HW_0_ddr_B_M_ARQOS),
        .ddr_B_M_arready(mkAWSteria_HW_0_ddr_B_M_ARREADY),
        .ddr_B_M_arregion(mkAWSteria_HW_0_ddr_B_M_ARREGION),
        .ddr_B_M_arsize(mkAWSteria_HW_0_ddr_B_M_ARSIZE),
        .ddr_B_M_arvalid(mkAWSteria_HW_0_ddr_B_M_ARVALID),
        .ddr_B_M_awaddr(mkAWSteria_HW_0_ddr_B_M_AWADDR),
        .ddr_B_M_awburst(mkAWSteria_HW_0_ddr_B_M_AWBURST),
        .ddr_B_M_awcache(mkAWSteria_HW_0_ddr_B_M_AWCACHE),
        .ddr_B_M_awid(mkAWSteria_HW_0_ddr_B_M_AWID),
        .ddr_B_M_awlen(mkAWSteria_HW_0_ddr_B_M_AWLEN),
        .ddr_B_M_awlock(mkAWSteria_HW_0_ddr_B_M_AWLOCK),
        .ddr_B_M_awprot(mkAWSteria_HW_0_ddr_B_M_AWPROT),
        .ddr_B_M_awqos(mkAWSteria_HW_0_ddr_B_M_AWQOS),
        .ddr_B_M_awready(mkAWSteria_HW_0_ddr_B_M_AWREADY),
        .ddr_B_M_awregion(mkAWSteria_HW_0_ddr_B_M_AWREGION),
        .ddr_B_M_awsize(mkAWSteria_HW_0_ddr_B_M_AWSIZE),
        .ddr_B_M_awvalid(mkAWSteria_HW_0_ddr_B_M_AWVALID),
        .ddr_B_M_bid(mkAWSteria_HW_0_ddr_B_M_BID),
        .ddr_B_M_bready(mkAWSteria_HW_0_ddr_B_M_BREADY),
        .ddr_B_M_bresp(mkAWSteria_HW_0_ddr_B_M_BRESP),
        .ddr_B_M_bvalid(mkAWSteria_HW_0_ddr_B_M_BVALID),
        .ddr_B_M_rdata(mkAWSteria_HW_0_ddr_B_M_RDATA),
        .ddr_B_M_rid(mkAWSteria_HW_0_ddr_B_M_RID),
        .ddr_B_M_rlast(mkAWSteria_HW_0_ddr_B_M_RLAST),
        .ddr_B_M_rready(mkAWSteria_HW_0_ddr_B_M_RREADY),
        .ddr_B_M_rresp(mkAWSteria_HW_0_ddr_B_M_RRESP),
        .ddr_B_M_rvalid(mkAWSteria_HW_0_ddr_B_M_RVALID),
        .ddr_B_M_wdata(mkAWSteria_HW_0_ddr_B_M_WDATA),
        .ddr_B_M_wlast(mkAWSteria_HW_0_ddr_B_M_WLAST),
        .ddr_B_M_wready(mkAWSteria_HW_0_ddr_B_M_WREADY),
        .ddr_B_M_wstrb(mkAWSteria_HW_0_ddr_B_M_WSTRB),
        .ddr_B_M_wvalid(mkAWSteria_HW_0_ddr_B_M_WVALID),
        .host_AXI4L_S_araddr(host_AXI4L_clock_converter_M_AXI_ARADDR),
        .host_AXI4L_S_arprot(host_AXI4L_clock_converter_M_AXI_ARPROT),
        .host_AXI4L_S_arready(host_AXI4L_clock_converter_M_AXI_ARREADY),
        .host_AXI4L_S_arvalid(host_AXI4L_clock_converter_M_AXI_ARVALID),
        .host_AXI4L_S_awaddr(host_AXI4L_clock_converter_M_AXI_AWADDR),
        .host_AXI4L_S_awprot(host_AXI4L_clock_converter_M_AXI_AWPROT),
        .host_AXI4L_S_awready(host_AXI4L_clock_converter_M_AXI_AWREADY),
        .host_AXI4L_S_awvalid(host_AXI4L_clock_converter_M_AXI_AWVALID),
        .host_AXI4L_S_bready(host_AXI4L_clock_converter_M_AXI_BREADY),
        .host_AXI4L_S_bresp(host_AXI4L_clock_converter_M_AXI_BRESP),
        .host_AXI4L_S_bvalid(host_AXI4L_clock_converter_M_AXI_BVALID),
        .host_AXI4L_S_rdata(host_AXI4L_clock_converter_M_AXI_RDATA),
        .host_AXI4L_S_rready(host_AXI4L_clock_converter_M_AXI_RREADY),
        .host_AXI4L_S_rresp(host_AXI4L_clock_converter_M_AXI_RRESP),
        .host_AXI4L_S_rvalid(host_AXI4L_clock_converter_M_AXI_RVALID),
        .host_AXI4L_S_wdata(host_AXI4L_clock_converter_M_AXI_WDATA),
        .host_AXI4L_S_wready(host_AXI4L_clock_converter_M_AXI_WREADY),
        .host_AXI4L_S_wstrb(host_AXI4L_clock_converter_M_AXI_WSTRB),
        .host_AXI4L_S_wvalid(host_AXI4L_clock_converter_M_AXI_WVALID),
        .host_AXI4_S_araddr(host_AXI4_clock_converter_M_AXI_ARADDR),
        .host_AXI4_S_arburst(host_AXI4_clock_converter_M_AXI_ARBURST),
        .host_AXI4_S_arcache(host_AXI4_clock_converter_M_AXI_ARCACHE),
        .host_AXI4_S_arid(host_AXI4_clock_converter_M_AXI_ARID),
        .host_AXI4_S_arlen(host_AXI4_clock_converter_M_AXI_ARLEN),
        .host_AXI4_S_arlock(host_AXI4_clock_converter_M_AXI_ARLOCK),
        .host_AXI4_S_arprot(host_AXI4_clock_converter_M_AXI_ARPROT),
        .host_AXI4_S_arqos(host_AXI4_clock_converter_M_AXI_ARQOS),
        .host_AXI4_S_arready(host_AXI4_clock_converter_M_AXI_ARREADY),
        .host_AXI4_S_arregion(host_AXI4_clock_converter_M_AXI_ARREGION),
        .host_AXI4_S_arsize(host_AXI4_clock_converter_M_AXI_ARSIZE),
        .host_AXI4_S_arvalid(host_AXI4_clock_converter_M_AXI_ARVALID),
        .host_AXI4_S_awaddr(host_AXI4_clock_converter_M_AXI_AWADDR),
        .host_AXI4_S_awburst(host_AXI4_clock_converter_M_AXI_AWBURST),
        .host_AXI4_S_awcache(host_AXI4_clock_converter_M_AXI_AWCACHE),
        .host_AXI4_S_awid(host_AXI4_clock_converter_M_AXI_AWID),
        .host_AXI4_S_awlen(host_AXI4_clock_converter_M_AXI_AWLEN),
        .host_AXI4_S_awlock(host_AXI4_clock_converter_M_AXI_AWLOCK),
        .host_AXI4_S_awprot(host_AXI4_clock_converter_M_AXI_AWPROT),
        .host_AXI4_S_awqos(host_AXI4_clock_converter_M_AXI_AWQOS),
        .host_AXI4_S_awready(host_AXI4_clock_converter_M_AXI_AWREADY),
        .host_AXI4_S_awregion(host_AXI4_clock_converter_M_AXI_AWREGION),
        .host_AXI4_S_awsize(host_AXI4_clock_converter_M_AXI_AWSIZE),
        .host_AXI4_S_awvalid(host_AXI4_clock_converter_M_AXI_AWVALID),
        .host_AXI4_S_bid(host_AXI4_clock_converter_M_AXI_BID),
        .host_AXI4_S_bready(host_AXI4_clock_converter_M_AXI_BREADY),
        .host_AXI4_S_bresp(host_AXI4_clock_converter_M_AXI_BRESP),
        .host_AXI4_S_bvalid(host_AXI4_clock_converter_M_AXI_BVALID),
        .host_AXI4_S_rdata(host_AXI4_clock_converter_M_AXI_RDATA),
        .host_AXI4_S_rid(host_AXI4_clock_converter_M_AXI_RID),
        .host_AXI4_S_rlast(host_AXI4_clock_converter_M_AXI_RLAST),
        .host_AXI4_S_rready(host_AXI4_clock_converter_M_AXI_RREADY),
        .host_AXI4_S_rresp(host_AXI4_clock_converter_M_AXI_RRESP),
        .host_AXI4_S_rvalid(host_AXI4_clock_converter_M_AXI_RVALID),
        .host_AXI4_S_wdata(host_AXI4_clock_converter_M_AXI_WDATA),
        .host_AXI4_S_wlast(host_AXI4_clock_converter_M_AXI_WLAST),
        .host_AXI4_S_wready(host_AXI4_clock_converter_M_AXI_WREADY),
        .host_AXI4_S_wstrb(host_AXI4_clock_converter_M_AXI_WSTRB),
        .host_AXI4_S_wvalid(host_AXI4_clock_converter_M_AXI_WVALID),
        .m_env_ready_env_ready(m_env_ready_synchronizer_dest_out),
        .m_glcount_glcount(m_glcount_synchronizer_dest_out),
        .m_halted(mkAWSteria_HW_0_m_halted));
endmodule
