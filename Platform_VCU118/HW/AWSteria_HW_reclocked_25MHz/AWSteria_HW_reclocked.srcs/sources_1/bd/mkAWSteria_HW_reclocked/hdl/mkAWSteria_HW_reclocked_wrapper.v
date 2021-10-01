//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.1 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
//Date        : Fri Oct  1 18:53:31 2021
//Host        : Dell-mation running 64-bit Ubuntu 18.04 LTS (beaver-three-eyed-raven X92)
//Command     : generate_target mkAWSteria_HW_reclocked_wrapper.bd
//Design      : mkAWSteria_HW_reclocked_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module mkAWSteria_HW_reclocked_wrapper
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
  input CLK;
  input CLK_b_CLK;
  input RST_N;
  input RST_N_b_RST_N;
  output [63:0]ddr_A_M_araddr;
  output [1:0]ddr_A_M_arburst;
  output [3:0]ddr_A_M_arcache;
  output [15:0]ddr_A_M_arid;
  output [7:0]ddr_A_M_arlen;
  output [0:0]ddr_A_M_arlock;
  output [2:0]ddr_A_M_arprot;
  output [3:0]ddr_A_M_arqos;
  input ddr_A_M_arready;
  output [3:0]ddr_A_M_arregion;
  output [2:0]ddr_A_M_arsize;
  output ddr_A_M_arvalid;
  output [63:0]ddr_A_M_awaddr;
  output [1:0]ddr_A_M_awburst;
  output [3:0]ddr_A_M_awcache;
  output [15:0]ddr_A_M_awid;
  output [7:0]ddr_A_M_awlen;
  output [0:0]ddr_A_M_awlock;
  output [2:0]ddr_A_M_awprot;
  output [3:0]ddr_A_M_awqos;
  input ddr_A_M_awready;
  output [3:0]ddr_A_M_awregion;
  output [2:0]ddr_A_M_awsize;
  output ddr_A_M_awvalid;
  input [15:0]ddr_A_M_bid;
  output ddr_A_M_bready;
  input [1:0]ddr_A_M_bresp;
  input ddr_A_M_bvalid;
  input [511:0]ddr_A_M_rdata;
  input [15:0]ddr_A_M_rid;
  input ddr_A_M_rlast;
  output ddr_A_M_rready;
  input [1:0]ddr_A_M_rresp;
  input ddr_A_M_rvalid;
  output [511:0]ddr_A_M_wdata;
  output ddr_A_M_wlast;
  input ddr_A_M_wready;
  output [63:0]ddr_A_M_wstrb;
  output ddr_A_M_wvalid;
  output [63:0]ddr_B_M_araddr;
  output [1:0]ddr_B_M_arburst;
  output [3:0]ddr_B_M_arcache;
  output [15:0]ddr_B_M_arid;
  output [7:0]ddr_B_M_arlen;
  output [0:0]ddr_B_M_arlock;
  output [2:0]ddr_B_M_arprot;
  output [3:0]ddr_B_M_arqos;
  input ddr_B_M_arready;
  output [3:0]ddr_B_M_arregion;
  output [2:0]ddr_B_M_arsize;
  output ddr_B_M_arvalid;
  output [63:0]ddr_B_M_awaddr;
  output [1:0]ddr_B_M_awburst;
  output [3:0]ddr_B_M_awcache;
  output [15:0]ddr_B_M_awid;
  output [7:0]ddr_B_M_awlen;
  output [0:0]ddr_B_M_awlock;
  output [2:0]ddr_B_M_awprot;
  output [3:0]ddr_B_M_awqos;
  input ddr_B_M_awready;
  output [3:0]ddr_B_M_awregion;
  output [2:0]ddr_B_M_awsize;
  output ddr_B_M_awvalid;
  input [15:0]ddr_B_M_bid;
  output ddr_B_M_bready;
  input [1:0]ddr_B_M_bresp;
  input ddr_B_M_bvalid;
  input [511:0]ddr_B_M_rdata;
  input [15:0]ddr_B_M_rid;
  input ddr_B_M_rlast;
  output ddr_B_M_rready;
  input [1:0]ddr_B_M_rresp;
  input ddr_B_M_rvalid;
  output [511:0]ddr_B_M_wdata;
  output ddr_B_M_wlast;
  input ddr_B_M_wready;
  output [63:0]ddr_B_M_wstrb;
  output ddr_B_M_wvalid;
  input [31:0]host_AXI4L_S_araddr;
  input [2:0]host_AXI4L_S_arprot;
  output host_AXI4L_S_arready;
  input host_AXI4L_S_arvalid;
  input [31:0]host_AXI4L_S_awaddr;
  input [2:0]host_AXI4L_S_awprot;
  output host_AXI4L_S_awready;
  input host_AXI4L_S_awvalid;
  input host_AXI4L_S_bready;
  output [1:0]host_AXI4L_S_bresp;
  output host_AXI4L_S_bvalid;
  output [31:0]host_AXI4L_S_rdata;
  input host_AXI4L_S_rready;
  output [1:0]host_AXI4L_S_rresp;
  output host_AXI4L_S_rvalid;
  input [31:0]host_AXI4L_S_wdata;
  output host_AXI4L_S_wready;
  input [3:0]host_AXI4L_S_wstrb;
  input host_AXI4L_S_wvalid;
  input [63:0]host_AXI4_S_araddr;
  input [1:0]host_AXI4_S_arburst;
  input [3:0]host_AXI4_S_arcache;
  input [15:0]host_AXI4_S_arid;
  input [7:0]host_AXI4_S_arlen;
  input [0:0]host_AXI4_S_arlock;
  input [2:0]host_AXI4_S_arprot;
  input [3:0]host_AXI4_S_arqos;
  output host_AXI4_S_arready;
  input [3:0]host_AXI4_S_arregion;
  input [2:0]host_AXI4_S_arsize;
  input host_AXI4_S_arvalid;
  input [63:0]host_AXI4_S_awaddr;
  input [1:0]host_AXI4_S_awburst;
  input [3:0]host_AXI4_S_awcache;
  input [15:0]host_AXI4_S_awid;
  input [7:0]host_AXI4_S_awlen;
  input [0:0]host_AXI4_S_awlock;
  input [2:0]host_AXI4_S_awprot;
  input [3:0]host_AXI4_S_awqos;
  output host_AXI4_S_awready;
  input [3:0]host_AXI4_S_awregion;
  input [2:0]host_AXI4_S_awsize;
  input host_AXI4_S_awvalid;
  output [15:0]host_AXI4_S_bid;
  input host_AXI4_S_bready;
  output [1:0]host_AXI4_S_bresp;
  output host_AXI4_S_bvalid;
  output [511:0]host_AXI4_S_rdata;
  output [15:0]host_AXI4_S_rid;
  output host_AXI4_S_rlast;
  input host_AXI4_S_rready;
  output [1:0]host_AXI4_S_rresp;
  output host_AXI4_S_rvalid;
  input [511:0]host_AXI4_S_wdata;
  input host_AXI4_S_wlast;
  output host_AXI4_S_wready;
  input [63:0]host_AXI4_S_wstrb;
  input host_AXI4_S_wvalid;
  input m_env_ready_env_ready;
  input [63:0]m_glcount_glcount;
  output m_halted;

  wire CLK;
  wire CLK_b_CLK;
  wire RST_N;
  wire RST_N_b_RST_N;
  wire [63:0]ddr_A_M_araddr;
  wire [1:0]ddr_A_M_arburst;
  wire [3:0]ddr_A_M_arcache;
  wire [15:0]ddr_A_M_arid;
  wire [7:0]ddr_A_M_arlen;
  wire [0:0]ddr_A_M_arlock;
  wire [2:0]ddr_A_M_arprot;
  wire [3:0]ddr_A_M_arqos;
  wire ddr_A_M_arready;
  wire [3:0]ddr_A_M_arregion;
  wire [2:0]ddr_A_M_arsize;
  wire ddr_A_M_arvalid;
  wire [63:0]ddr_A_M_awaddr;
  wire [1:0]ddr_A_M_awburst;
  wire [3:0]ddr_A_M_awcache;
  wire [15:0]ddr_A_M_awid;
  wire [7:0]ddr_A_M_awlen;
  wire [0:0]ddr_A_M_awlock;
  wire [2:0]ddr_A_M_awprot;
  wire [3:0]ddr_A_M_awqos;
  wire ddr_A_M_awready;
  wire [3:0]ddr_A_M_awregion;
  wire [2:0]ddr_A_M_awsize;
  wire ddr_A_M_awvalid;
  wire [15:0]ddr_A_M_bid;
  wire ddr_A_M_bready;
  wire [1:0]ddr_A_M_bresp;
  wire ddr_A_M_bvalid;
  wire [511:0]ddr_A_M_rdata;
  wire [15:0]ddr_A_M_rid;
  wire ddr_A_M_rlast;
  wire ddr_A_M_rready;
  wire [1:0]ddr_A_M_rresp;
  wire ddr_A_M_rvalid;
  wire [511:0]ddr_A_M_wdata;
  wire ddr_A_M_wlast;
  wire ddr_A_M_wready;
  wire [63:0]ddr_A_M_wstrb;
  wire ddr_A_M_wvalid;
  wire [63:0]ddr_B_M_araddr;
  wire [1:0]ddr_B_M_arburst;
  wire [3:0]ddr_B_M_arcache;
  wire [15:0]ddr_B_M_arid;
  wire [7:0]ddr_B_M_arlen;
  wire [0:0]ddr_B_M_arlock;
  wire [2:0]ddr_B_M_arprot;
  wire [3:0]ddr_B_M_arqos;
  wire ddr_B_M_arready;
  wire [3:0]ddr_B_M_arregion;
  wire [2:0]ddr_B_M_arsize;
  wire ddr_B_M_arvalid;
  wire [63:0]ddr_B_M_awaddr;
  wire [1:0]ddr_B_M_awburst;
  wire [3:0]ddr_B_M_awcache;
  wire [15:0]ddr_B_M_awid;
  wire [7:0]ddr_B_M_awlen;
  wire [0:0]ddr_B_M_awlock;
  wire [2:0]ddr_B_M_awprot;
  wire [3:0]ddr_B_M_awqos;
  wire ddr_B_M_awready;
  wire [3:0]ddr_B_M_awregion;
  wire [2:0]ddr_B_M_awsize;
  wire ddr_B_M_awvalid;
  wire [15:0]ddr_B_M_bid;
  wire ddr_B_M_bready;
  wire [1:0]ddr_B_M_bresp;
  wire ddr_B_M_bvalid;
  wire [511:0]ddr_B_M_rdata;
  wire [15:0]ddr_B_M_rid;
  wire ddr_B_M_rlast;
  wire ddr_B_M_rready;
  wire [1:0]ddr_B_M_rresp;
  wire ddr_B_M_rvalid;
  wire [511:0]ddr_B_M_wdata;
  wire ddr_B_M_wlast;
  wire ddr_B_M_wready;
  wire [63:0]ddr_B_M_wstrb;
  wire ddr_B_M_wvalid;
  wire [31:0]host_AXI4L_S_araddr;
  wire [2:0]host_AXI4L_S_arprot;
  wire host_AXI4L_S_arready;
  wire host_AXI4L_S_arvalid;
  wire [31:0]host_AXI4L_S_awaddr;
  wire [2:0]host_AXI4L_S_awprot;
  wire host_AXI4L_S_awready;
  wire host_AXI4L_S_awvalid;
  wire host_AXI4L_S_bready;
  wire [1:0]host_AXI4L_S_bresp;
  wire host_AXI4L_S_bvalid;
  wire [31:0]host_AXI4L_S_rdata;
  wire host_AXI4L_S_rready;
  wire [1:0]host_AXI4L_S_rresp;
  wire host_AXI4L_S_rvalid;
  wire [31:0]host_AXI4L_S_wdata;
  wire host_AXI4L_S_wready;
  wire [3:0]host_AXI4L_S_wstrb;
  wire host_AXI4L_S_wvalid;
  wire [63:0]host_AXI4_S_araddr;
  wire [1:0]host_AXI4_S_arburst;
  wire [3:0]host_AXI4_S_arcache;
  wire [15:0]host_AXI4_S_arid;
  wire [7:0]host_AXI4_S_arlen;
  wire [0:0]host_AXI4_S_arlock;
  wire [2:0]host_AXI4_S_arprot;
  wire [3:0]host_AXI4_S_arqos;
  wire host_AXI4_S_arready;
  wire [3:0]host_AXI4_S_arregion;
  wire [2:0]host_AXI4_S_arsize;
  wire host_AXI4_S_arvalid;
  wire [63:0]host_AXI4_S_awaddr;
  wire [1:0]host_AXI4_S_awburst;
  wire [3:0]host_AXI4_S_awcache;
  wire [15:0]host_AXI4_S_awid;
  wire [7:0]host_AXI4_S_awlen;
  wire [0:0]host_AXI4_S_awlock;
  wire [2:0]host_AXI4_S_awprot;
  wire [3:0]host_AXI4_S_awqos;
  wire host_AXI4_S_awready;
  wire [3:0]host_AXI4_S_awregion;
  wire [2:0]host_AXI4_S_awsize;
  wire host_AXI4_S_awvalid;
  wire [15:0]host_AXI4_S_bid;
  wire host_AXI4_S_bready;
  wire [1:0]host_AXI4_S_bresp;
  wire host_AXI4_S_bvalid;
  wire [511:0]host_AXI4_S_rdata;
  wire [15:0]host_AXI4_S_rid;
  wire host_AXI4_S_rlast;
  wire host_AXI4_S_rready;
  wire [1:0]host_AXI4_S_rresp;
  wire host_AXI4_S_rvalid;
  wire [511:0]host_AXI4_S_wdata;
  wire host_AXI4_S_wlast;
  wire host_AXI4_S_wready;
  wire [63:0]host_AXI4_S_wstrb;
  wire host_AXI4_S_wvalid;
  wire m_env_ready_env_ready;
  wire [63:0]m_glcount_glcount;
  wire m_halted;

  mkAWSteria_HW_reclocked mkAWSteria_HW_reclocked_i
       (.CLK(CLK),
        .CLK_b_CLK(CLK_b_CLK),
        .RST_N(RST_N),
        .RST_N_b_RST_N(RST_N_b_RST_N),
        .ddr_A_M_araddr(ddr_A_M_araddr),
        .ddr_A_M_arburst(ddr_A_M_arburst),
        .ddr_A_M_arcache(ddr_A_M_arcache),
        .ddr_A_M_arid(ddr_A_M_arid),
        .ddr_A_M_arlen(ddr_A_M_arlen),
        .ddr_A_M_arlock(ddr_A_M_arlock),
        .ddr_A_M_arprot(ddr_A_M_arprot),
        .ddr_A_M_arqos(ddr_A_M_arqos),
        .ddr_A_M_arready(ddr_A_M_arready),
        .ddr_A_M_arregion(ddr_A_M_arregion),
        .ddr_A_M_arsize(ddr_A_M_arsize),
        .ddr_A_M_arvalid(ddr_A_M_arvalid),
        .ddr_A_M_awaddr(ddr_A_M_awaddr),
        .ddr_A_M_awburst(ddr_A_M_awburst),
        .ddr_A_M_awcache(ddr_A_M_awcache),
        .ddr_A_M_awid(ddr_A_M_awid),
        .ddr_A_M_awlen(ddr_A_M_awlen),
        .ddr_A_M_awlock(ddr_A_M_awlock),
        .ddr_A_M_awprot(ddr_A_M_awprot),
        .ddr_A_M_awqos(ddr_A_M_awqos),
        .ddr_A_M_awready(ddr_A_M_awready),
        .ddr_A_M_awregion(ddr_A_M_awregion),
        .ddr_A_M_awsize(ddr_A_M_awsize),
        .ddr_A_M_awvalid(ddr_A_M_awvalid),
        .ddr_A_M_bid(ddr_A_M_bid),
        .ddr_A_M_bready(ddr_A_M_bready),
        .ddr_A_M_bresp(ddr_A_M_bresp),
        .ddr_A_M_bvalid(ddr_A_M_bvalid),
        .ddr_A_M_rdata(ddr_A_M_rdata),
        .ddr_A_M_rid(ddr_A_M_rid),
        .ddr_A_M_rlast(ddr_A_M_rlast),
        .ddr_A_M_rready(ddr_A_M_rready),
        .ddr_A_M_rresp(ddr_A_M_rresp),
        .ddr_A_M_rvalid(ddr_A_M_rvalid),
        .ddr_A_M_wdata(ddr_A_M_wdata),
        .ddr_A_M_wlast(ddr_A_M_wlast),
        .ddr_A_M_wready(ddr_A_M_wready),
        .ddr_A_M_wstrb(ddr_A_M_wstrb),
        .ddr_A_M_wvalid(ddr_A_M_wvalid),
        .ddr_B_M_araddr(ddr_B_M_araddr),
        .ddr_B_M_arburst(ddr_B_M_arburst),
        .ddr_B_M_arcache(ddr_B_M_arcache),
        .ddr_B_M_arid(ddr_B_M_arid),
        .ddr_B_M_arlen(ddr_B_M_arlen),
        .ddr_B_M_arlock(ddr_B_M_arlock),
        .ddr_B_M_arprot(ddr_B_M_arprot),
        .ddr_B_M_arqos(ddr_B_M_arqos),
        .ddr_B_M_arready(ddr_B_M_arready),
        .ddr_B_M_arregion(ddr_B_M_arregion),
        .ddr_B_M_arsize(ddr_B_M_arsize),
        .ddr_B_M_arvalid(ddr_B_M_arvalid),
        .ddr_B_M_awaddr(ddr_B_M_awaddr),
        .ddr_B_M_awburst(ddr_B_M_awburst),
        .ddr_B_M_awcache(ddr_B_M_awcache),
        .ddr_B_M_awid(ddr_B_M_awid),
        .ddr_B_M_awlen(ddr_B_M_awlen),
        .ddr_B_M_awlock(ddr_B_M_awlock),
        .ddr_B_M_awprot(ddr_B_M_awprot),
        .ddr_B_M_awqos(ddr_B_M_awqos),
        .ddr_B_M_awready(ddr_B_M_awready),
        .ddr_B_M_awregion(ddr_B_M_awregion),
        .ddr_B_M_awsize(ddr_B_M_awsize),
        .ddr_B_M_awvalid(ddr_B_M_awvalid),
        .ddr_B_M_bid(ddr_B_M_bid),
        .ddr_B_M_bready(ddr_B_M_bready),
        .ddr_B_M_bresp(ddr_B_M_bresp),
        .ddr_B_M_bvalid(ddr_B_M_bvalid),
        .ddr_B_M_rdata(ddr_B_M_rdata),
        .ddr_B_M_rid(ddr_B_M_rid),
        .ddr_B_M_rlast(ddr_B_M_rlast),
        .ddr_B_M_rready(ddr_B_M_rready),
        .ddr_B_M_rresp(ddr_B_M_rresp),
        .ddr_B_M_rvalid(ddr_B_M_rvalid),
        .ddr_B_M_wdata(ddr_B_M_wdata),
        .ddr_B_M_wlast(ddr_B_M_wlast),
        .ddr_B_M_wready(ddr_B_M_wready),
        .ddr_B_M_wstrb(ddr_B_M_wstrb),
        .ddr_B_M_wvalid(ddr_B_M_wvalid),
        .host_AXI4L_S_araddr(host_AXI4L_S_araddr),
        .host_AXI4L_S_arprot(host_AXI4L_S_arprot),
        .host_AXI4L_S_arready(host_AXI4L_S_arready),
        .host_AXI4L_S_arvalid(host_AXI4L_S_arvalid),
        .host_AXI4L_S_awaddr(host_AXI4L_S_awaddr),
        .host_AXI4L_S_awprot(host_AXI4L_S_awprot),
        .host_AXI4L_S_awready(host_AXI4L_S_awready),
        .host_AXI4L_S_awvalid(host_AXI4L_S_awvalid),
        .host_AXI4L_S_bready(host_AXI4L_S_bready),
        .host_AXI4L_S_bresp(host_AXI4L_S_bresp),
        .host_AXI4L_S_bvalid(host_AXI4L_S_bvalid),
        .host_AXI4L_S_rdata(host_AXI4L_S_rdata),
        .host_AXI4L_S_rready(host_AXI4L_S_rready),
        .host_AXI4L_S_rresp(host_AXI4L_S_rresp),
        .host_AXI4L_S_rvalid(host_AXI4L_S_rvalid),
        .host_AXI4L_S_wdata(host_AXI4L_S_wdata),
        .host_AXI4L_S_wready(host_AXI4L_S_wready),
        .host_AXI4L_S_wstrb(host_AXI4L_S_wstrb),
        .host_AXI4L_S_wvalid(host_AXI4L_S_wvalid),
        .host_AXI4_S_araddr(host_AXI4_S_araddr),
        .host_AXI4_S_arburst(host_AXI4_S_arburst),
        .host_AXI4_S_arcache(host_AXI4_S_arcache),
        .host_AXI4_S_arid(host_AXI4_S_arid),
        .host_AXI4_S_arlen(host_AXI4_S_arlen),
        .host_AXI4_S_arlock(host_AXI4_S_arlock),
        .host_AXI4_S_arprot(host_AXI4_S_arprot),
        .host_AXI4_S_arqos(host_AXI4_S_arqos),
        .host_AXI4_S_arready(host_AXI4_S_arready),
        .host_AXI4_S_arregion(host_AXI4_S_arregion),
        .host_AXI4_S_arsize(host_AXI4_S_arsize),
        .host_AXI4_S_arvalid(host_AXI4_S_arvalid),
        .host_AXI4_S_awaddr(host_AXI4_S_awaddr),
        .host_AXI4_S_awburst(host_AXI4_S_awburst),
        .host_AXI4_S_awcache(host_AXI4_S_awcache),
        .host_AXI4_S_awid(host_AXI4_S_awid),
        .host_AXI4_S_awlen(host_AXI4_S_awlen),
        .host_AXI4_S_awlock(host_AXI4_S_awlock),
        .host_AXI4_S_awprot(host_AXI4_S_awprot),
        .host_AXI4_S_awqos(host_AXI4_S_awqos),
        .host_AXI4_S_awready(host_AXI4_S_awready),
        .host_AXI4_S_awregion(host_AXI4_S_awregion),
        .host_AXI4_S_awsize(host_AXI4_S_awsize),
        .host_AXI4_S_awvalid(host_AXI4_S_awvalid),
        .host_AXI4_S_bid(host_AXI4_S_bid),
        .host_AXI4_S_bready(host_AXI4_S_bready),
        .host_AXI4_S_bresp(host_AXI4_S_bresp),
        .host_AXI4_S_bvalid(host_AXI4_S_bvalid),
        .host_AXI4_S_rdata(host_AXI4_S_rdata),
        .host_AXI4_S_rid(host_AXI4_S_rid),
        .host_AXI4_S_rlast(host_AXI4_S_rlast),
        .host_AXI4_S_rready(host_AXI4_S_rready),
        .host_AXI4_S_rresp(host_AXI4_S_rresp),
        .host_AXI4_S_rvalid(host_AXI4_S_rvalid),
        .host_AXI4_S_wdata(host_AXI4_S_wdata),
        .host_AXI4_S_wlast(host_AXI4_S_wlast),
        .host_AXI4_S_wready(host_AXI4_S_wready),
        .host_AXI4_S_wstrb(host_AXI4_S_wstrb),
        .host_AXI4_S_wvalid(host_AXI4_S_wvalid),
        .m_env_ready_env_ready(m_env_ready_env_ready),
        .m_glcount_glcount(m_glcount_glcount),
        .m_halted(m_halted));
endmodule
