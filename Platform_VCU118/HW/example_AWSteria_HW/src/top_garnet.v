//-
// Copyright (c) 2020-2021 Jessica Clarke
//
// @BERI_LICENSE_HEADER_START@
//
// Licensed to BERI Open Systems C.I.C. (BERI) under one or more contributor
// license agreements.  See the NOTICE file distributed with this work for
// additional information regarding copyright ownership.  BERI licenses this
// file to you under the BERI Hardware-Software License, Version 1.0 (the
// "License"); you may not use this file except in compliance with the
// License.  You may obtain a copy of the License at:
//
//   http://www.beri-open-systems.org/legal/license-1-0.txt
//
// Unless required by applicable law or agreed to in writing, Work distributed
// under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations under the License.
//
// @BERI_LICENSE_HEADER_END@
//

// Modified by Rishiyur S. Nikhil for AWSteria, 2021-2022

module top_garnet_AWSteria (
  `include "partition_ports.vh"
);

   // ================================================================
   // Interrupts; we don't generate interrupts, and we ignore acks

   assign irq_req = 16'b0;

   // ================================================================
   // Signals for narrowing AXI ID signals emerging from blupont_HW_Side
   // and driving outputs of this top-module.

   // ----------------
   // Facing host (via PCIe)

   wire [15:0] DMA_S_AXI_bid_16;
   assign DMA_S_AXI_bid = DMA_S_AXI_bid_16 [3:0];
   
   wire [15:0] DMA_S_AXI_rid_16;
   assign DMA_S_AXI_rid = DMA_S_AXI_rid_16 [3:0];
   
   // ----------------
   // Facing DDR A

   wire [15:0] DDRA_M_AXI_arid_16;
   assign DDRA_M_AXI_arid = DDRA_M_AXI_arid_16 [5:0];

   wire [15:0] DDRA_M_AXI_awid_16;
   assign DDRA_M_AXI_awid = DDRA_M_AXI_awid_16 [5:0];

   // ----------------
   // Facing DDR B

   wire [15:0] DDRB_M_AXI_arid_16;
   assign DDRB_M_AXI_arid = DDRB_M_AXI_arid_16 [5:0];

   wire [15:0] DDRB_M_AXI_awid_16;
   assign DDRB_M_AXI_awid = DDRB_M_AXI_awid_16 [5:0];

   // ================================================================
   // Instant

   wire        clk1;
   wire        clk2;
   wire        clk3;
   wire        clk4;
   wire        clk5;

   ClockDiv_Block_Design #()
   clockdiv_block_design_inst (.CLK (clk),
			       .RST_N (resetn),
			       .clk_out1 (clk1),
			       .clk_out2 (clk2),
			       .clk_out3 (clk3),
			       .clk_out4 (clk4),
			       .clk_out5 (clk5));

   // ================================================================
   // mkBluPont_HW_Side instantiation

   // NOTE: mkAWSteria_HW_reclocked is the reclocking wrapper, containing
   //     a clock divider,
   //     mkAWSteria_HW (the original DUT, at a slower clock speed)
   //     and suitable clock-crossing synchronizers.
   //     mkAWSteria_HW_reclocked and mkAWSteria_HW have the same port list.
   //     This module is created using a Vivado Block diagram.

   mkAWSteria_HW #()
   mkAWSteria_HW_inst (.CLK   (clk),
		       .RST_N (resetn),

		       .CLK_clk1 (clk1),
		       .CLK_clk2 (clk2),
		       .CLK_clk3 (clk3),
		       .CLK_clk4 (clk4),
		       .CLK_clk5 (clk5),

		       // ----------------
		       // AXI4 (DMA_PCIS) S connection
		       .host_AXI4_S_arvalid  (DMA_S_AXI_arvalid),
		       .host_AXI4_S_arready  (DMA_S_AXI_arready),
		       .host_AXI4_S_arid     ({12'b0, DMA_S_AXI_arid}),
		       .host_AXI4_S_araddr   (DMA_S_AXI_araddr),
		       .host_AXI4_S_arburst  (DMA_S_AXI_arburst),
		       .host_AXI4_S_arlen    (DMA_S_AXI_arlen),
		       .host_AXI4_S_arsize   (DMA_S_AXI_arsize),
		       .host_AXI4_S_arcache  (DMA_S_AXI_arcache),
		       .host_AXI4_S_arlock   (DMA_S_AXI_arlock),
		       .host_AXI4_S_arprot   (DMA_S_AXI_arprot),
		       .host_AXI4_S_arqos    (4'b0),     // unused
		       .host_AXI4_S_arregion (4'b0),     // unused

		       .host_AXI4_S_awvalid  (DMA_S_AXI_awvalid),
		       .host_AXI4_S_awready  (DMA_S_AXI_awready),
		       .host_AXI4_S_awid     ({12'b0, DMA_S_AXI_awid}),
		       .host_AXI4_S_awaddr   (DMA_S_AXI_awaddr),
		       .host_AXI4_S_awburst  (DMA_S_AXI_awburst),
		       .host_AXI4_S_awlen    (DMA_S_AXI_awlen),
		       .host_AXI4_S_awsize   (DMA_S_AXI_awsize),
		       .host_AXI4_S_awcache  (DMA_S_AXI_awcache),
		       .host_AXI4_S_awlock   (DMA_S_AXI_awlock),
		       .host_AXI4_S_awprot   (DMA_S_AXI_awprot),
		       .host_AXI4_S_awqos    (4'b0),     // unused
		       .host_AXI4_S_awregion (4'b0),     // unused

		       .host_AXI4_S_wvalid   (DMA_S_AXI_wvalid),
		       .host_AXI4_S_wready   (DMA_S_AXI_wready),
		       .host_AXI4_S_wdata    (DMA_S_AXI_wdata),
		       .host_AXI4_S_wstrb    (DMA_S_AXI_wstrb),
		       .host_AXI4_S_wlast    (DMA_S_AXI_wlast),

		       .host_AXI4_S_bvalid   (DMA_S_AXI_bvalid),
		       .host_AXI4_S_bready   (DMA_S_AXI_bready),
		       .host_AXI4_S_bid      (DMA_S_AXI_bid_16),
		       .host_AXI4_S_bresp    (DMA_S_AXI_bresp),

		       .host_AXI4_S_rvalid   (DMA_S_AXI_rvalid),
		       .host_AXI4_S_rready   (DMA_S_AXI_rready),
		       .host_AXI4_S_rid      (DMA_S_AXI_rid_16),
		       .host_AXI4_S_rresp    (DMA_S_AXI_rresp),
		       .host_AXI4_S_rdata    (DMA_S_AXI_rdata),
		       .host_AXI4_S_rlast    (DMA_S_AXI_rlast),

		       // ----------------
		       // AXI4_Lite_32_32 (OCL) S connection
		       .host_AXI4L_S_arvalid (CTL_S_AXI_LITE_arvalid),
		       .host_AXI4L_S_arready (CTL_S_AXI_LITE_arready),
		       .host_AXI4L_S_araddr  (CTL_S_AXI_LITE_araddr),
		       .host_AXI4L_S_arprot  (CTL_S_AXI_LITE_arprot),

		       .host_AXI4L_S_awvalid (CTL_S_AXI_LITE_awvalid),
		       .host_AXI4L_S_awready (CTL_S_AXI_LITE_awready),
		       .host_AXI4L_S_awaddr  (CTL_S_AXI_LITE_awaddr),
		       .host_AXI4L_S_awprot  (CTL_S_AXI_LITE_awprot),

		       .host_AXI4L_S_wvalid  (CTL_S_AXI_LITE_wvalid),
		       .host_AXI4L_S_wready  (CTL_S_AXI_LITE_wready),
		       .host_AXI4L_S_wdata   (CTL_S_AXI_LITE_wdata),
		       .host_AXI4L_S_wstrb   (CTL_S_AXI_LITE_wstrb),

		       .host_AXI4L_S_bvalid  (CTL_S_AXI_LITE_bvalid),
		       .host_AXI4L_S_bready  (CTL_S_AXI_LITE_bready),
		       .host_AXI4L_S_bresp   (CTL_S_AXI_LITE_bresp),

		       .host_AXI4L_S_rvalid  (CTL_S_AXI_LITE_rvalid),
		       .host_AXI4L_S_rready  (CTL_S_AXI_LITE_rready),
		       .host_AXI4L_S_rresp   (CTL_S_AXI_LITE_rresp),
		       .host_AXI4L_S_rdata   (CTL_S_AXI_LITE_rdata),

		       // ----------------
		       // DDR A (AXI4 M) connection
		       .ddr_A_M_arvalid  (DDRA_M_AXI_arvalid),
		       .ddr_A_M_arready  (DDRA_M_AXI_arready),
		       .ddr_A_M_arid     (DDRA_M_AXI_arid_16),
		       .ddr_A_M_araddr   (DDRA_M_AXI_araddr),
		       .ddr_A_M_arburst  (DDRA_M_AXI_arburst),
		       .ddr_A_M_arlen    (DDRA_M_AXI_arlen),
		       .ddr_A_M_arsize   (DDRA_M_AXI_arsize),
		       .ddr_A_M_arcache  (DDRA_M_AXI_arcache),
		       .ddr_A_M_arlock   (DDRA_M_AXI_arlock),
		       .ddr_A_M_arprot   (DDRA_M_AXI_arprot),
		       .ddr_A_M_arqos    (DDRA_M_AXI_arqos),
		       .ddr_A_M_arregion (DDRA_M_AXI_arregion),

		       .ddr_A_M_awvalid  (DDRA_M_AXI_awvalid),
		       .ddr_A_M_awready  (DDRA_M_AXI_awready),
		       .ddr_A_M_awid     (DDRA_M_AXI_awid_16),
		       .ddr_A_M_awaddr   (DDRA_M_AXI_awaddr),
		       .ddr_A_M_awburst  (DDRA_M_AXI_awburst),
		       .ddr_A_M_awlen    (DDRA_M_AXI_awlen),
		       .ddr_A_M_awsize   (DDRA_M_AXI_awsize),
		       .ddr_A_M_awcache  (DDRA_M_AXI_awcache),
		       .ddr_A_M_awlock   (DDRA_M_AXI_awlock),
		       .ddr_A_M_awprot   (DDRA_M_AXI_awprot),
		       .ddr_A_M_awqos    (DDRA_M_AXI_awqos),
		       .ddr_A_M_awregion (DDRA_M_AXI_awregion),

		       .ddr_A_M_wvalid   (DDRA_M_AXI_wvalid),
		       .ddr_A_M_wready   (DDRA_M_AXI_wready),
		       .ddr_A_M_wdata    (DDRA_M_AXI_wdata),
		       .ddr_A_M_wstrb    (DDRA_M_AXI_wstrb),
		       .ddr_A_M_wlast    (DDRA_M_AXI_wlast),

		       .ddr_A_M_bvalid   (DDRA_M_AXI_bvalid),
		       .ddr_A_M_bready   (DDRA_M_AXI_bready),
		       .ddr_A_M_bid      ({10'b0, DDRA_M_AXI_bid}),
		       .ddr_A_M_bresp    (DDRA_M_AXI_bresp),

		       .ddr_A_M_rvalid   (DDRA_M_AXI_rvalid),
		       .ddr_A_M_rready   (DDRA_M_AXI_rready),
		       .ddr_A_M_rid      ({10'b0, DDRA_M_AXI_rid}),
		       .ddr_A_M_rresp    (DDRA_M_AXI_rresp),
		       .ddr_A_M_rdata    (DDRA_M_AXI_rdata),
		       .ddr_A_M_rlast    (DDRA_M_AXI_rlast),

		       // ----------------
		       // DDR B (AXI4 M) connection
		       .ddr_B_M_arvalid  (DDRB_M_AXI_arvalid),
		       .ddr_B_M_arready  (DDRB_M_AXI_arready),
		       .ddr_B_M_arid     (DDRB_M_AXI_arid_16),
		       .ddr_B_M_araddr   (DDRB_M_AXI_araddr),
		       .ddr_B_M_arburst  (DDRB_M_AXI_arburst),
		       .ddr_B_M_arlen    (DDRB_M_AXI_arlen),
		       .ddr_B_M_arsize   (DDRB_M_AXI_arsize),
		       .ddr_B_M_arcache  (DDRB_M_AXI_arcache),
		       .ddr_B_M_arlock   (DDRB_M_AXI_arlock),
		       .ddr_B_M_arprot   (DDRB_M_AXI_arprot),
		       .ddr_B_M_arqos    (DDRB_M_AXI_arqos),
		       .ddr_B_M_arregion (DDRB_M_AXI_arregion),

		       .ddr_B_M_awvalid  (DDRB_M_AXI_awvalid),
		       .ddr_B_M_awready  (DDRB_M_AXI_awready),
		       .ddr_B_M_awid     (DDRB_M_AXI_awid_16),
		       .ddr_B_M_awaddr   (DDRB_M_AXI_awaddr),
		       .ddr_B_M_awburst  (DDRB_M_AXI_awburst),
		       .ddr_B_M_awlen    (DDRB_M_AXI_awlen),
		       .ddr_B_M_awsize   (DDRB_M_AXI_awsize),
		       .ddr_B_M_awcache  (DDRB_M_AXI_awcache),
		       .ddr_B_M_awlock   (DDRB_M_AXI_awlock),
		       .ddr_B_M_awprot   (DDRB_M_AXI_awprot),
		       .ddr_B_M_awqos    (DDRB_M_AXI_awqos),
		       .ddr_B_M_awregion (DDRB_M_AXI_awregion),

		       .ddr_B_M_wvalid   (DDRB_M_AXI_wvalid),
		       .ddr_B_M_wready   (DDRB_M_AXI_wready),
		       .ddr_B_M_wdata    (DDRB_M_AXI_wdata),
		       .ddr_B_M_wstrb    (DDRB_M_AXI_wstrb),
		       .ddr_B_M_wlast    (DDRB_M_AXI_wlast),

		       .ddr_B_M_bvalid   (DDRB_M_AXI_bvalid),
		       .ddr_B_M_bready   (DDRB_M_AXI_bready),
		       .ddr_B_M_bid      ({10'b0, DDRB_M_AXI_bid}),
		       .ddr_B_M_bresp    (DDRB_M_AXI_bresp),

		       .ddr_B_M_rvalid   (DDRB_M_AXI_rvalid),
		       .ddr_B_M_rready   (DDRB_M_AXI_rready),
		       .ddr_B_M_rid      ({10'b0, DDRB_M_AXI_rid}),
		       .ddr_B_M_rresp    (DDRB_M_AXI_rresp),
		       .ddr_B_M_rdata    (DDRB_M_AXI_rdata),
		       .ddr_B_M_rlast    (DDRB_M_AXI_rlast),

		       // ----------------
		       // Misc module inputs

		       .m_env_ready_env_ready  (1),
		       .m_glcount_glcount      (0),

		       // ----------------
		       // Misc module outputs

		       .m_halted               ()    // ignored
		       );

// ****************************************************************
// ****************************************************************

endmodule
