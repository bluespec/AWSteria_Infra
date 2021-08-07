// (c) Copyright 1995-2021 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: xilinx.com:module_ref:mkAWSteria_HW:1.0
// IP Revision: 1

(* X_CORE_INFO = "mkAWSteria_HW,Vivado 2019.1" *)
(* CHECK_LICENSE_TYPE = "mkAWSteria_HW_reclocked_mkAWSteria_HW_0_0,mkAWSteria_HW,{}" *)
(* CORE_GENERATION_INFO = "mkAWSteria_HW_reclocked_mkAWSteria_HW_0_0,mkAWSteria_HW,{x_ipProduct=Vivado 2019.1,x_ipVendor=xilinx.com,x_ipLibrary=module_ref,x_ipName=mkAWSteria_HW,x_ipVersion=1.0,x_ipCoreRevision=1,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED}" *)
(* IP_DEFINITION_SOURCE = "module_ref" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module mkAWSteria_HW_reclocked_mkAWSteria_HW_0_0 (
  CLK_b_CLK,
  RST_N_b_RST_N,
  CLK,
  RST_N,
  host_AXI4_S_awvalid,
  host_AXI4_S_awid,
  host_AXI4_S_awaddr,
  host_AXI4_S_awlen,
  host_AXI4_S_awsize,
  host_AXI4_S_awburst,
  host_AXI4_S_awlock,
  host_AXI4_S_awcache,
  host_AXI4_S_awprot,
  host_AXI4_S_awqos,
  host_AXI4_S_awregion,
  host_AXI4_S_awready,
  host_AXI4_S_wvalid,
  host_AXI4_S_wdata,
  host_AXI4_S_wstrb,
  host_AXI4_S_wlast,
  host_AXI4_S_wready,
  host_AXI4_S_bvalid,
  host_AXI4_S_bid,
  host_AXI4_S_bresp,
  host_AXI4_S_bready,
  host_AXI4_S_arvalid,
  host_AXI4_S_arid,
  host_AXI4_S_araddr,
  host_AXI4_S_arlen,
  host_AXI4_S_arsize,
  host_AXI4_S_arburst,
  host_AXI4_S_arlock,
  host_AXI4_S_arcache,
  host_AXI4_S_arprot,
  host_AXI4_S_arqos,
  host_AXI4_S_arregion,
  host_AXI4_S_arready,
  host_AXI4_S_rvalid,
  host_AXI4_S_rid,
  host_AXI4_S_rdata,
  host_AXI4_S_rresp,
  host_AXI4_S_rlast,
  host_AXI4_S_rready,
  host_AXI4L_S_awvalid,
  host_AXI4L_S_awaddr,
  host_AXI4L_S_awprot,
  host_AXI4L_S_awready,
  host_AXI4L_S_wvalid,
  host_AXI4L_S_wdata,
  host_AXI4L_S_wstrb,
  host_AXI4L_S_wready,
  host_AXI4L_S_bvalid,
  host_AXI4L_S_bresp,
  host_AXI4L_S_bready,
  host_AXI4L_S_arvalid,
  host_AXI4L_S_araddr,
  host_AXI4L_S_arprot,
  host_AXI4L_S_arready,
  host_AXI4L_S_rvalid,
  host_AXI4L_S_rresp,
  host_AXI4L_S_rdata,
  host_AXI4L_S_rready,
  ddr_A_M_awvalid,
  ddr_A_M_awid,
  ddr_A_M_awaddr,
  ddr_A_M_awlen,
  ddr_A_M_awsize,
  ddr_A_M_awburst,
  ddr_A_M_awlock,
  ddr_A_M_awcache,
  ddr_A_M_awprot,
  ddr_A_M_awqos,
  ddr_A_M_awregion,
  ddr_A_M_awready,
  ddr_A_M_wvalid,
  ddr_A_M_wdata,
  ddr_A_M_wstrb,
  ddr_A_M_wlast,
  ddr_A_M_wready,
  ddr_A_M_bvalid,
  ddr_A_M_bid,
  ddr_A_M_bresp,
  ddr_A_M_bready,
  ddr_A_M_arvalid,
  ddr_A_M_arid,
  ddr_A_M_araddr,
  ddr_A_M_arlen,
  ddr_A_M_arsize,
  ddr_A_M_arburst,
  ddr_A_M_arlock,
  ddr_A_M_arcache,
  ddr_A_M_arprot,
  ddr_A_M_arqos,
  ddr_A_M_arregion,
  ddr_A_M_arready,
  ddr_A_M_rvalid,
  ddr_A_M_rid,
  ddr_A_M_rdata,
  ddr_A_M_rresp,
  ddr_A_M_rlast,
  ddr_A_M_rready,
  ddr_B_M_awvalid,
  ddr_B_M_awid,
  ddr_B_M_awaddr,
  ddr_B_M_awlen,
  ddr_B_M_awsize,
  ddr_B_M_awburst,
  ddr_B_M_awlock,
  ddr_B_M_awcache,
  ddr_B_M_awprot,
  ddr_B_M_awqos,
  ddr_B_M_awregion,
  ddr_B_M_awready,
  ddr_B_M_wvalid,
  ddr_B_M_wdata,
  ddr_B_M_wstrb,
  ddr_B_M_wlast,
  ddr_B_M_wready,
  ddr_B_M_bvalid,
  ddr_B_M_bid,
  ddr_B_M_bresp,
  ddr_B_M_bready,
  ddr_B_M_arvalid,
  ddr_B_M_arid,
  ddr_B_M_araddr,
  ddr_B_M_arlen,
  ddr_B_M_arsize,
  ddr_B_M_arburst,
  ddr_B_M_arlock,
  ddr_B_M_arcache,
  ddr_B_M_arprot,
  ddr_B_M_arqos,
  ddr_B_M_arregion,
  ddr_B_M_arready,
  ddr_B_M_rvalid,
  ddr_B_M_rid,
  ddr_B_M_rdata,
  ddr_B_M_rresp,
  ddr_B_M_rlast,
  ddr_B_M_rready,
  m_env_ready_env_ready,
  m_halted,
  m_glcount_glcount
);

(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK_b_CLK, FREQ_HZ 50000000, PHASE 0.0, CLK_DOMAIN mkAWSteria_HW_reclocked_clk_wiz_0_0_clk_out1, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK_b_CLK CLK" *)
input wire CLK_b_CLK;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST_N_b_RST_N, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST_N_b_RST_N RST" *)
input wire RST_N_b_RST_N;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK, ASSOCIATED_BUSIF ddr_A_M:ddr_B_M:host_AXI4L_S:host_AXI4_S, FREQ_HZ 100000000, PHASE 0.0, CLK_DOMAIN mkAWSteria_HW_reclocked_clk_wiz_0_0_clk_out1, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK CLK" *)
input wire CLK;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST_N, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST_N RST" *)
input wire RST_N;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S AWVALID" *)
input wire host_AXI4_S_awvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S AWID" *)
input wire [15 : 0] host_AXI4_S_awid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S AWADDR" *)
input wire [63 : 0] host_AXI4_S_awaddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S AWLEN" *)
input wire [7 : 0] host_AXI4_S_awlen;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S AWSIZE" *)
input wire [2 : 0] host_AXI4_S_awsize;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S AWBURST" *)
input wire [1 : 0] host_AXI4_S_awburst;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S AWLOCK" *)
input wire host_AXI4_S_awlock;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S AWCACHE" *)
input wire [3 : 0] host_AXI4_S_awcache;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S AWPROT" *)
input wire [2 : 0] host_AXI4_S_awprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S AWQOS" *)
input wire [3 : 0] host_AXI4_S_awqos;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S AWREGION" *)
input wire [3 : 0] host_AXI4_S_awregion;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S AWREADY" *)
output wire host_AXI4_S_awready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S WVALID" *)
input wire host_AXI4_S_wvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S WDATA" *)
input wire [511 : 0] host_AXI4_S_wdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S WSTRB" *)
input wire [63 : 0] host_AXI4_S_wstrb;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S WLAST" *)
input wire host_AXI4_S_wlast;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S WREADY" *)
output wire host_AXI4_S_wready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S BVALID" *)
output wire host_AXI4_S_bvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S BID" *)
output wire [15 : 0] host_AXI4_S_bid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S BRESP" *)
output wire [1 : 0] host_AXI4_S_bresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S BREADY" *)
input wire host_AXI4_S_bready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S ARVALID" *)
input wire host_AXI4_S_arvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S ARID" *)
input wire [15 : 0] host_AXI4_S_arid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S ARADDR" *)
input wire [63 : 0] host_AXI4_S_araddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S ARLEN" *)
input wire [7 : 0] host_AXI4_S_arlen;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S ARSIZE" *)
input wire [2 : 0] host_AXI4_S_arsize;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S ARBURST" *)
input wire [1 : 0] host_AXI4_S_arburst;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S ARLOCK" *)
input wire host_AXI4_S_arlock;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S ARCACHE" *)
input wire [3 : 0] host_AXI4_S_arcache;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S ARPROT" *)
input wire [2 : 0] host_AXI4_S_arprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S ARQOS" *)
input wire [3 : 0] host_AXI4_S_arqos;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S ARREGION" *)
input wire [3 : 0] host_AXI4_S_arregion;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S ARREADY" *)
output wire host_AXI4_S_arready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S RVALID" *)
output wire host_AXI4_S_rvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S RID" *)
output wire [15 : 0] host_AXI4_S_rid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S RDATA" *)
output wire [511 : 0] host_AXI4_S_rdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S RRESP" *)
output wire [1 : 0] host_AXI4_S_rresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S RLAST" *)
output wire host_AXI4_S_rlast;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME host_AXI4_S, DATA_WIDTH 512, PROTOCOL AXI4, FREQ_HZ 100000000, ID_WIDTH 16, ADDR_WIDTH 64, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 1, HAS_LOCK 1, HAS_PROT 1, HAS_CACHE 1, HAS_QOS 1, HAS_REGION 1, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 1, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 256, PHASE 0.0, CLK_DOMAIN mkAWSteria_HW_reclocked_clk_wiz_0_0_clk_out1, NUM_READ\
_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4_S RREADY" *)
input wire host_AXI4_S_rready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4L_S AWVALID" *)
input wire host_AXI4L_S_awvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4L_S AWADDR" *)
input wire [31 : 0] host_AXI4L_S_awaddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4L_S AWPROT" *)
input wire [2 : 0] host_AXI4L_S_awprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4L_S AWREADY" *)
output wire host_AXI4L_S_awready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4L_S WVALID" *)
input wire host_AXI4L_S_wvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4L_S WDATA" *)
input wire [31 : 0] host_AXI4L_S_wdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4L_S WSTRB" *)
input wire [3 : 0] host_AXI4L_S_wstrb;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4L_S WREADY" *)
output wire host_AXI4L_S_wready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4L_S BVALID" *)
output wire host_AXI4L_S_bvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4L_S BRESP" *)
output wire [1 : 0] host_AXI4L_S_bresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4L_S BREADY" *)
input wire host_AXI4L_S_bready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4L_S ARVALID" *)
input wire host_AXI4L_S_arvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4L_S ARADDR" *)
input wire [31 : 0] host_AXI4L_S_araddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4L_S ARPROT" *)
input wire [2 : 0] host_AXI4L_S_arprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4L_S ARREADY" *)
output wire host_AXI4L_S_arready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4L_S RVALID" *)
output wire host_AXI4L_S_rvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4L_S RRESP" *)
output wire [1 : 0] host_AXI4L_S_rresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4L_S RDATA" *)
output wire [31 : 0] host_AXI4L_S_rdata;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME host_AXI4L_S, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 100000000, ID_WIDTH 0, ADDR_WIDTH 32, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 1, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1, MAX_BURST_LENGTH 1, PHASE 0.0, CLK_DOMAIN mkAWSteria_HW_reclocked_clk_wiz_0_0_clk_out1, NUM_REA\
D_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 host_AXI4L_S RREADY" *)
input wire host_AXI4L_S_rready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M AWVALID" *)
output wire ddr_A_M_awvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M AWID" *)
output wire [15 : 0] ddr_A_M_awid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M AWADDR" *)
output wire [63 : 0] ddr_A_M_awaddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M AWLEN" *)
output wire [7 : 0] ddr_A_M_awlen;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M AWSIZE" *)
output wire [2 : 0] ddr_A_M_awsize;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M AWBURST" *)
output wire [1 : 0] ddr_A_M_awburst;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M AWLOCK" *)
output wire ddr_A_M_awlock;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M AWCACHE" *)
output wire [3 : 0] ddr_A_M_awcache;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M AWPROT" *)
output wire [2 : 0] ddr_A_M_awprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M AWQOS" *)
output wire [3 : 0] ddr_A_M_awqos;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M AWREGION" *)
output wire [3 : 0] ddr_A_M_awregion;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M AWREADY" *)
input wire ddr_A_M_awready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M WVALID" *)
output wire ddr_A_M_wvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M WDATA" *)
output wire [511 : 0] ddr_A_M_wdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M WSTRB" *)
output wire [63 : 0] ddr_A_M_wstrb;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M WLAST" *)
output wire ddr_A_M_wlast;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M WREADY" *)
input wire ddr_A_M_wready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M BVALID" *)
input wire ddr_A_M_bvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M BID" *)
input wire [15 : 0] ddr_A_M_bid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M BRESP" *)
input wire [1 : 0] ddr_A_M_bresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M BREADY" *)
output wire ddr_A_M_bready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M ARVALID" *)
output wire ddr_A_M_arvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M ARID" *)
output wire [15 : 0] ddr_A_M_arid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M ARADDR" *)
output wire [63 : 0] ddr_A_M_araddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M ARLEN" *)
output wire [7 : 0] ddr_A_M_arlen;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M ARSIZE" *)
output wire [2 : 0] ddr_A_M_arsize;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M ARBURST" *)
output wire [1 : 0] ddr_A_M_arburst;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M ARLOCK" *)
output wire ddr_A_M_arlock;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M ARCACHE" *)
output wire [3 : 0] ddr_A_M_arcache;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M ARPROT" *)
output wire [2 : 0] ddr_A_M_arprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M ARQOS" *)
output wire [3 : 0] ddr_A_M_arqos;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M ARREGION" *)
output wire [3 : 0] ddr_A_M_arregion;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M ARREADY" *)
input wire ddr_A_M_arready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M RVALID" *)
input wire ddr_A_M_rvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M RID" *)
input wire [15 : 0] ddr_A_M_rid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M RDATA" *)
input wire [511 : 0] ddr_A_M_rdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M RRESP" *)
input wire [1 : 0] ddr_A_M_rresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M RLAST" *)
input wire ddr_A_M_rlast;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME ddr_A_M, DATA_WIDTH 512, PROTOCOL AXI4, FREQ_HZ 100000000, ID_WIDTH 16, ADDR_WIDTH 64, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 1, HAS_LOCK 1, HAS_PROT 1, HAS_CACHE 1, HAS_QOS 1, HAS_REGION 1, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 1, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 256, PHASE 0.0, CLK_DOMAIN mkAWSteria_HW_reclocked_clk_wiz_0_0_clk_out1, NUM_READ_THR\
EADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_A_M RREADY" *)
output wire ddr_A_M_rready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M AWVALID" *)
output wire ddr_B_M_awvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M AWID" *)
output wire [15 : 0] ddr_B_M_awid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M AWADDR" *)
output wire [63 : 0] ddr_B_M_awaddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M AWLEN" *)
output wire [7 : 0] ddr_B_M_awlen;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M AWSIZE" *)
output wire [2 : 0] ddr_B_M_awsize;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M AWBURST" *)
output wire [1 : 0] ddr_B_M_awburst;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M AWLOCK" *)
output wire ddr_B_M_awlock;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M AWCACHE" *)
output wire [3 : 0] ddr_B_M_awcache;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M AWPROT" *)
output wire [2 : 0] ddr_B_M_awprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M AWQOS" *)
output wire [3 : 0] ddr_B_M_awqos;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M AWREGION" *)
output wire [3 : 0] ddr_B_M_awregion;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M AWREADY" *)
input wire ddr_B_M_awready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M WVALID" *)
output wire ddr_B_M_wvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M WDATA" *)
output wire [511 : 0] ddr_B_M_wdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M WSTRB" *)
output wire [63 : 0] ddr_B_M_wstrb;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M WLAST" *)
output wire ddr_B_M_wlast;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M WREADY" *)
input wire ddr_B_M_wready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M BVALID" *)
input wire ddr_B_M_bvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M BID" *)
input wire [15 : 0] ddr_B_M_bid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M BRESP" *)
input wire [1 : 0] ddr_B_M_bresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M BREADY" *)
output wire ddr_B_M_bready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M ARVALID" *)
output wire ddr_B_M_arvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M ARID" *)
output wire [15 : 0] ddr_B_M_arid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M ARADDR" *)
output wire [63 : 0] ddr_B_M_araddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M ARLEN" *)
output wire [7 : 0] ddr_B_M_arlen;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M ARSIZE" *)
output wire [2 : 0] ddr_B_M_arsize;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M ARBURST" *)
output wire [1 : 0] ddr_B_M_arburst;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M ARLOCK" *)
output wire ddr_B_M_arlock;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M ARCACHE" *)
output wire [3 : 0] ddr_B_M_arcache;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M ARPROT" *)
output wire [2 : 0] ddr_B_M_arprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M ARQOS" *)
output wire [3 : 0] ddr_B_M_arqos;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M ARREGION" *)
output wire [3 : 0] ddr_B_M_arregion;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M ARREADY" *)
input wire ddr_B_M_arready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M RVALID" *)
input wire ddr_B_M_rvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M RID" *)
input wire [15 : 0] ddr_B_M_rid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M RDATA" *)
input wire [511 : 0] ddr_B_M_rdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M RRESP" *)
input wire [1 : 0] ddr_B_M_rresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M RLAST" *)
input wire ddr_B_M_rlast;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME ddr_B_M, DATA_WIDTH 512, PROTOCOL AXI4, FREQ_HZ 100000000, ID_WIDTH 16, ADDR_WIDTH 64, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 1, HAS_LOCK 1, HAS_PROT 1, HAS_CACHE 1, HAS_QOS 1, HAS_REGION 1, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 1, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 256, PHASE 0.0, CLK_DOMAIN mkAWSteria_HW_reclocked_clk_wiz_0_0_clk_out1, NUM_READ_THR\
EADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 ddr_B_M RREADY" *)
output wire ddr_B_M_rready;
input wire m_env_ready_env_ready;
output wire m_halted;
input wire [63 : 0] m_glcount_glcount;

  mkAWSteria_HW inst (
    .CLK_b_CLK(CLK_b_CLK),
    .RST_N_b_RST_N(RST_N_b_RST_N),
    .CLK(CLK),
    .RST_N(RST_N),
    .host_AXI4_S_awvalid(host_AXI4_S_awvalid),
    .host_AXI4_S_awid(host_AXI4_S_awid),
    .host_AXI4_S_awaddr(host_AXI4_S_awaddr),
    .host_AXI4_S_awlen(host_AXI4_S_awlen),
    .host_AXI4_S_awsize(host_AXI4_S_awsize),
    .host_AXI4_S_awburst(host_AXI4_S_awburst),
    .host_AXI4_S_awlock(host_AXI4_S_awlock),
    .host_AXI4_S_awcache(host_AXI4_S_awcache),
    .host_AXI4_S_awprot(host_AXI4_S_awprot),
    .host_AXI4_S_awqos(host_AXI4_S_awqos),
    .host_AXI4_S_awregion(host_AXI4_S_awregion),
    .host_AXI4_S_awready(host_AXI4_S_awready),
    .host_AXI4_S_wvalid(host_AXI4_S_wvalid),
    .host_AXI4_S_wdata(host_AXI4_S_wdata),
    .host_AXI4_S_wstrb(host_AXI4_S_wstrb),
    .host_AXI4_S_wlast(host_AXI4_S_wlast),
    .host_AXI4_S_wready(host_AXI4_S_wready),
    .host_AXI4_S_bvalid(host_AXI4_S_bvalid),
    .host_AXI4_S_bid(host_AXI4_S_bid),
    .host_AXI4_S_bresp(host_AXI4_S_bresp),
    .host_AXI4_S_bready(host_AXI4_S_bready),
    .host_AXI4_S_arvalid(host_AXI4_S_arvalid),
    .host_AXI4_S_arid(host_AXI4_S_arid),
    .host_AXI4_S_araddr(host_AXI4_S_araddr),
    .host_AXI4_S_arlen(host_AXI4_S_arlen),
    .host_AXI4_S_arsize(host_AXI4_S_arsize),
    .host_AXI4_S_arburst(host_AXI4_S_arburst),
    .host_AXI4_S_arlock(host_AXI4_S_arlock),
    .host_AXI4_S_arcache(host_AXI4_S_arcache),
    .host_AXI4_S_arprot(host_AXI4_S_arprot),
    .host_AXI4_S_arqos(host_AXI4_S_arqos),
    .host_AXI4_S_arregion(host_AXI4_S_arregion),
    .host_AXI4_S_arready(host_AXI4_S_arready),
    .host_AXI4_S_rvalid(host_AXI4_S_rvalid),
    .host_AXI4_S_rid(host_AXI4_S_rid),
    .host_AXI4_S_rdata(host_AXI4_S_rdata),
    .host_AXI4_S_rresp(host_AXI4_S_rresp),
    .host_AXI4_S_rlast(host_AXI4_S_rlast),
    .host_AXI4_S_rready(host_AXI4_S_rready),
    .host_AXI4L_S_awvalid(host_AXI4L_S_awvalid),
    .host_AXI4L_S_awaddr(host_AXI4L_S_awaddr),
    .host_AXI4L_S_awprot(host_AXI4L_S_awprot),
    .host_AXI4L_S_awready(host_AXI4L_S_awready),
    .host_AXI4L_S_wvalid(host_AXI4L_S_wvalid),
    .host_AXI4L_S_wdata(host_AXI4L_S_wdata),
    .host_AXI4L_S_wstrb(host_AXI4L_S_wstrb),
    .host_AXI4L_S_wready(host_AXI4L_S_wready),
    .host_AXI4L_S_bvalid(host_AXI4L_S_bvalid),
    .host_AXI4L_S_bresp(host_AXI4L_S_bresp),
    .host_AXI4L_S_bready(host_AXI4L_S_bready),
    .host_AXI4L_S_arvalid(host_AXI4L_S_arvalid),
    .host_AXI4L_S_araddr(host_AXI4L_S_araddr),
    .host_AXI4L_S_arprot(host_AXI4L_S_arprot),
    .host_AXI4L_S_arready(host_AXI4L_S_arready),
    .host_AXI4L_S_rvalid(host_AXI4L_S_rvalid),
    .host_AXI4L_S_rresp(host_AXI4L_S_rresp),
    .host_AXI4L_S_rdata(host_AXI4L_S_rdata),
    .host_AXI4L_S_rready(host_AXI4L_S_rready),
    .ddr_A_M_awvalid(ddr_A_M_awvalid),
    .ddr_A_M_awid(ddr_A_M_awid),
    .ddr_A_M_awaddr(ddr_A_M_awaddr),
    .ddr_A_M_awlen(ddr_A_M_awlen),
    .ddr_A_M_awsize(ddr_A_M_awsize),
    .ddr_A_M_awburst(ddr_A_M_awburst),
    .ddr_A_M_awlock(ddr_A_M_awlock),
    .ddr_A_M_awcache(ddr_A_M_awcache),
    .ddr_A_M_awprot(ddr_A_M_awprot),
    .ddr_A_M_awqos(ddr_A_M_awqos),
    .ddr_A_M_awregion(ddr_A_M_awregion),
    .ddr_A_M_awready(ddr_A_M_awready),
    .ddr_A_M_wvalid(ddr_A_M_wvalid),
    .ddr_A_M_wdata(ddr_A_M_wdata),
    .ddr_A_M_wstrb(ddr_A_M_wstrb),
    .ddr_A_M_wlast(ddr_A_M_wlast),
    .ddr_A_M_wready(ddr_A_M_wready),
    .ddr_A_M_bvalid(ddr_A_M_bvalid),
    .ddr_A_M_bid(ddr_A_M_bid),
    .ddr_A_M_bresp(ddr_A_M_bresp),
    .ddr_A_M_bready(ddr_A_M_bready),
    .ddr_A_M_arvalid(ddr_A_M_arvalid),
    .ddr_A_M_arid(ddr_A_M_arid),
    .ddr_A_M_araddr(ddr_A_M_araddr),
    .ddr_A_M_arlen(ddr_A_M_arlen),
    .ddr_A_M_arsize(ddr_A_M_arsize),
    .ddr_A_M_arburst(ddr_A_M_arburst),
    .ddr_A_M_arlock(ddr_A_M_arlock),
    .ddr_A_M_arcache(ddr_A_M_arcache),
    .ddr_A_M_arprot(ddr_A_M_arprot),
    .ddr_A_M_arqos(ddr_A_M_arqos),
    .ddr_A_M_arregion(ddr_A_M_arregion),
    .ddr_A_M_arready(ddr_A_M_arready),
    .ddr_A_M_rvalid(ddr_A_M_rvalid),
    .ddr_A_M_rid(ddr_A_M_rid),
    .ddr_A_M_rdata(ddr_A_M_rdata),
    .ddr_A_M_rresp(ddr_A_M_rresp),
    .ddr_A_M_rlast(ddr_A_M_rlast),
    .ddr_A_M_rready(ddr_A_M_rready),
    .ddr_B_M_awvalid(ddr_B_M_awvalid),
    .ddr_B_M_awid(ddr_B_M_awid),
    .ddr_B_M_awaddr(ddr_B_M_awaddr),
    .ddr_B_M_awlen(ddr_B_M_awlen),
    .ddr_B_M_awsize(ddr_B_M_awsize),
    .ddr_B_M_awburst(ddr_B_M_awburst),
    .ddr_B_M_awlock(ddr_B_M_awlock),
    .ddr_B_M_awcache(ddr_B_M_awcache),
    .ddr_B_M_awprot(ddr_B_M_awprot),
    .ddr_B_M_awqos(ddr_B_M_awqos),
    .ddr_B_M_awregion(ddr_B_M_awregion),
    .ddr_B_M_awready(ddr_B_M_awready),
    .ddr_B_M_wvalid(ddr_B_M_wvalid),
    .ddr_B_M_wdata(ddr_B_M_wdata),
    .ddr_B_M_wstrb(ddr_B_M_wstrb),
    .ddr_B_M_wlast(ddr_B_M_wlast),
    .ddr_B_M_wready(ddr_B_M_wready),
    .ddr_B_M_bvalid(ddr_B_M_bvalid),
    .ddr_B_M_bid(ddr_B_M_bid),
    .ddr_B_M_bresp(ddr_B_M_bresp),
    .ddr_B_M_bready(ddr_B_M_bready),
    .ddr_B_M_arvalid(ddr_B_M_arvalid),
    .ddr_B_M_arid(ddr_B_M_arid),
    .ddr_B_M_araddr(ddr_B_M_araddr),
    .ddr_B_M_arlen(ddr_B_M_arlen),
    .ddr_B_M_arsize(ddr_B_M_arsize),
    .ddr_B_M_arburst(ddr_B_M_arburst),
    .ddr_B_M_arlock(ddr_B_M_arlock),
    .ddr_B_M_arcache(ddr_B_M_arcache),
    .ddr_B_M_arprot(ddr_B_M_arprot),
    .ddr_B_M_arqos(ddr_B_M_arqos),
    .ddr_B_M_arregion(ddr_B_M_arregion),
    .ddr_B_M_arready(ddr_B_M_arready),
    .ddr_B_M_rvalid(ddr_B_M_rvalid),
    .ddr_B_M_rid(ddr_B_M_rid),
    .ddr_B_M_rdata(ddr_B_M_rdata),
    .ddr_B_M_rresp(ddr_B_M_rresp),
    .ddr_B_M_rlast(ddr_B_M_rlast),
    .ddr_B_M_rready(ddr_B_M_rready),
    .m_env_ready_env_ready(m_env_ready_env_ready),
    .m_halted(m_halted),
    .m_glcount_glcount(m_glcount_glcount)
  );
endmodule
