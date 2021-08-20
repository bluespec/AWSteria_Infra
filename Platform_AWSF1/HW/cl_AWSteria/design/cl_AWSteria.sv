// This code borrows excerpts from the Amazon AWS-FPGA examples.
// Original copyrignt and license:
//    // Amazon FPGA Hardware Development Kit
//    //
//    // Copyright 2016 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//    //
//    // Licensed under the Amazon Software License (the "License"). You may not use
//    // this file except in compliance with the License. A copy of the License is
//    // located at
//    //
//    //    http://aws.amazon.com/asl/
//    //
//    // or in the "license" file accompanying this file. This file is distributed on
//    // an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, express or
//    // implied. See the License for the specific language governing permissions and
//    // limitations under the License.
//
// Modifications Copyright (c) 2020-2021, Bluespec, Inc.
// Author: Rishiyur S. Nikhil
//
// ================================================================
// HW-side designs written in BSV AWSteria for Amazon AWS-FPGA sit inside two
// outermost modules that are generic infrastructure (not design-specific):
//
//    cl_AWSteria           (this module, written in SV)
//    │
//    ├─── mkAWSteria_HW    (written in BSV)
//    │    │
//    │    └─── <design>    (written in BSV)
//    │
//    └─── sh_ddr           (written in SV, provided by AWS-FPGA)
//
// This module is the 'CL' top-level, connecting to the AWS 'SH'.
// The following SH<->CL ports are used/unused by mkAWSteria_HW.
// (cf. standard CL port-list at:
//      aws-fpga/hdk/common/shell_stable/design/interfaces/cl_ports.vh)

// Used:
//    clk_main0, rst_main_n
//    sh_cl_flr_assert, cl_sh_flr_done
//    cl_sh_id0, ch_sh_id1
//    CLK_300M_DIMM0_*, M_A_*, cl_RST_DIMM_A_N    DDR A physical interfaces
//    CLK_300M_DIMM1_*, M_B_*, cl_RST_DIMM_B_N    DDR B physical interfaces
//    CLK_300M_DIMM2_*, M_D_*, cl_RST_DIMM_D_N    DDR D physical interfaces
//    sh_ddr_stat_*, ddr_sh_stat_*                DDR A,B,D stats interfaces
//    cl_sh_ddr_*, sh_cl_ddr_*                    DDR C AXI4 interfaces, ready signal
//    sh_cl_dma_pcis_*, cl_sh_dma_pcis_*          DMA_PCIS AXI4 interface, ready signal
//    sh_ocl_*, ocl_sh_*                          OCL AXI4-Lite interface, ready signal
//    sh_cl_glcount0/1                            4ns counters

// Unused: all other ports are unused (see 'tie off unused interfaces' section below)

// This wrapper instantiates the standard 'sh_ddr' for DDRs A, B and D
// - The physical and stats interfaces are connected to cl_ports as usual.
// - The AXI4 ports are connected inside this module to mkAWSteria_HW ports.

// This module's organization (with '*****' dividers):
//    - Tie-off unused interfaces
//    - Local Buses/Signals
//    - sh_ddr instantiation
//    - mkAWSteria_HW instantiation

// ================================================================

module cl_AWSteria #(parameter NUM_DDR=4)

(
   `include "cl_ports.vh"
);

`include "cl_id_defines.vh"          // Defines for ID0 and ID1 (PCI ID's)
`include "cl_AWSteria_defines.vh"

   // ****************************************************************
   // ****************************************************************
   // TIE OFF UNUSED INTERFACES
   // cf. aws-fpga/hdk/common/shell_stable/design/interfaces/unused_*

`include "unused_pcim_template.inc"
`include "unused_cl_sda_template.inc"
`include "unused_sh_bar1_template.inc"
`include "unused_apppf_irq_template.inc"

   // Unused 'full' signals
   assign  cl_sh_dma_rd_full = 1'b0;
   assign  cl_sh_dma_wr_full = 1'b0;

   // Unused 'vled' signals
   assign  cl_sh_status_vled = 16'b0;

   // The functionality for these signals is TBD so they can can be tied-off.
   assign  cl_sh_status0 = 32'h0;
   assign  cl_sh_status1 = 32'h0;

   // ****************************************************************
   // ****************************************************************
   // PCIe ID signals
   // CL_SH_ID0:  31:16: PCIe Device ID     15: 0: PCIe Vendor ID
   // CL_SH_ID1:  31:16: PCIe Subsystem ID  15: 0: PCIe Subsystem Vendor ID

   assign cl_sh_id0 [31:0] = `CL_SH_ID0;
   assign cl_sh_id1 [31:0] = `CL_SH_ID1;

   // ****************************************************************
   // ****************************************************************
   // LOCAL BUSES/SIGNALS

   // ================================================================
   // Reset synchronization

   (* dont_touch = "true" *)
   logic pipe_rst_n;

   logic pre_sync_rst_n;

   (* dont_touch = "true" *)
   logic sync_rst_n;

   lib_pipe #(.WIDTH(1), .STAGES(4))
   PIPE_RST_N (.clk(clk_main_a0), .rst_n(1'b1), .in_bus(rst_main_n), .out_bus(pipe_rst_n));
   
   always_ff @(negedge pipe_rst_n or posedge clk_main_a0)
     if (! pipe_rst_n)
       begin
	  pre_sync_rst_n <= 0;
	  sync_rst_n <= 0;
       end
     else
       begin
	  pre_sync_rst_n <= 1;
	  sync_rst_n <= pre_sync_rst_n;
       end

   // ================================================================
   // FLR signals

   logic sh_cl_flr_assert_q;

   //FLR response 
   always_ff @(negedge sync_rst_n or posedge clk_main_a0)
     if (! sync_rst_n)
       begin
	  sh_cl_flr_assert_q <= 0;
	  cl_sh_flr_done     <= 0;
       end
     else
       begin
	  sh_cl_flr_assert_q <= sh_cl_flr_assert;
	  cl_sh_flr_done     <= sh_cl_flr_assert_q && !cl_sh_flr_done;
       end

   // ================================================================
   // Width adjustment for DMA_PCIS bid and rid buses.
   // mkAWSteria_HW drives bid and rid as 16b outputs.
   // But the corresponding CL inputs are only 6b.

   logic [15:0] cl_sh_dma_pcis_bid_16b;
   logic [15:0] cl_sh_dma_pcis_rid_16b;

   assign cl_sh_dma_pcis_bid = cl_sh_dma_pcis_bid_16b [5:0];
   assign cl_sh_dma_pcis_rid = cl_sh_dma_pcis_rid_16b [5:0];

   // ================================================================
   // DDR

   // Ready signals from DDRs
   logic [2:0] ddr4_A_B_D_ready;    // from sh_ddr, for DDR A, B, D
   logic       ddr4_C_ready_q;      // from cl_ports, for DDR C
   logic [3:0] ddr4_A_B_C_D_ready;

   always_ff @(posedge clk_main_a0 or negedge sync_rst_n)
     if (! sync_rst_n)
       begin
	  ddr4_C_ready_q <= 1'b0;
       end
     else
       begin
	  ddr4_C_ready_q <= sh_cl_ddr_is_ready;
       end

   assign ddr4_A_B_C_D_ready = {ddr4_A_B_D_ready[2], ddr4_C_ready_q, ddr4_A_B_D_ready[1:0]};

   // Vector-of-buses view of DDR4 A, B, D AXI4 ports, as expected by sh_ddr
   logic [15:0]  v_ddr4_axi4_awid    [2:0];
   logic [63:0]  v_ddr4_axi4_awaddr  [2:0];
   logic [7:0] 	 v_ddr4_axi4_awlen   [2:0];
   logic [2:0] 	 v_ddr4_axi4_awsize  [2:0];
   logic [1:0] 	 v_ddr4_axi4_awburst [2:0];
   logic 	 v_ddr4_axi4_awvalid [2:0];
   logic [2:0] 	 v_ddr4_axi4_awready;

   logic [15:0]  v_ddr4_axi4_wid     [2:0];
   logic [511:0] v_ddr4_axi4_wdata   [2:0];
   logic [63:0]  v_ddr4_axi4_wstrb   [2:0];
   logic [2:0] 	 v_ddr4_axi4_wlast;
   logic [2:0] 	 v_ddr4_axi4_wvalid;
   logic [2:0] 	 v_ddr4_axi4_wready;

   logic [15:0]  v_ddr4_axi4_bid     [2:0];
   logic [1:0] 	 v_ddr4_axi4_bresp   [2:0];
   logic [2:0] 	 v_ddr4_axi4_bvalid;
   logic [2:0] 	 v_ddr4_axi4_bready;

   logic [15:0]  v_ddr4_axi4_arid    [2:0];
   logic [63:0]  v_ddr4_axi4_araddr  [2:0];
   logic [7:0] 	 v_ddr4_axi4_arlen   [2:0];
   logic [2:0] 	 v_ddr4_axi4_arsize  [2:0];
   logic [1:0] 	 v_ddr4_axi4_arburst [2:0];
   logic [2:0] 	 v_ddr4_axi4_arvalid;
   logic [2:0] 	 v_ddr4_axi4_arready;

   logic [15:0]  v_ddr4_axi4_rid     [2:0];
   logic [511:0] v_ddr4_axi4_rdata   [2:0];
   logic [1:0] 	 v_ddr4_axi4_rresp   [2:0];
   logic [2:0] 	 v_ddr4_axi4_rlast;
   logic [2:0] 	 v_ddr4_axi4_rvalid;
   logic [2:0] 	 v_ddr4_axi4_rready;

   // Vector-of-buses view of DDR4 A, B, D stats ports, as expected by sh_ddr
   // From cl_ports to sh_ddr
   logic [7:0]  v_ddr4_stats_addr_q[2:0];
   logic [2:0]  v_ddr4_stats_wr_q;
   logic [2:0]  v_ddr4_stats_rd_q; 
   logic [31:0] v_ddr4_stats_wdata_q[2:0];

   // From sh_ddr to cl_ports
   logic [2:0] 	v_ddr4_stats_ack_q;
   logic [31:0] v_ddr4_stats_rdata_q[2:0];
   logic [7:0] 	v_ddr4_stats_int_q[2:0];

   // ****************************************************************
   // ****************************************************************
   // MODULE INSTANTIATIONS ETC.

   // ================================================================
   // DDR A, B, D INSTANTIATION

   // ----------------
   // Synchronize and connect stats signals between cl_ports and v_ddr4_stats_* (which connects to sh_ddr)

   localparam NUM_CFG_STGS_CL_DDR_ATG = 8;

   // DDR A
   lib_pipe #(.WIDTH(1+1+8+32), .STAGES(NUM_CFG_STGS_CL_DDR_ATG))
   PIPE_DDR_STAT0 (.clk(clk_main_a0), .rst_n(sync_rst_n),
		   .in_bus({sh_ddr_stat_wr0, sh_ddr_stat_rd0, sh_ddr_stat_addr0, sh_ddr_stat_wdata0}),
		   .out_bus({v_ddr4_stats_wr_q[0], v_ddr4_stats_rd_q[0], v_ddr4_stats_addr_q[0], v_ddr4_stats_wdata_q[0]})
		   );


   lib_pipe #(.WIDTH(1+8+32), .STAGES(NUM_CFG_STGS_CL_DDR_ATG))
   PIPE_DDR_STAT_ACK0 (.clk(clk_main_a0), .rst_n(sync_rst_n),
		       .in_bus({v_ddr4_stats_ack_q[0], v_ddr4_stats_int_q[0], v_ddr4_stats_rdata_q[0]}),
		       .out_bus({ddr_sh_stat_ack0, ddr_sh_stat_int0, ddr_sh_stat_rdata0})
		       );

   // DDR B
   lib_pipe #(.WIDTH(1+1+8+32), .STAGES(NUM_CFG_STGS_CL_DDR_ATG))
   PIPE_DDR_STAT1 (.clk(clk_main_a0), .rst_n(sync_rst_n),
		   .in_bus({sh_ddr_stat_wr1, sh_ddr_stat_rd1, sh_ddr_stat_addr1, sh_ddr_stat_wdata1}),
		   .out_bus({v_ddr4_stats_wr_q[1], v_ddr4_stats_rd_q[1], v_ddr4_stats_addr_q[1], v_ddr4_stats_wdata_q[1]})
		   );


   lib_pipe #(.WIDTH(1+8+32), .STAGES(NUM_CFG_STGS_CL_DDR_ATG))
   PIPE_DDR_STAT_ACK1 (.clk(clk_main_a0), .rst_n(sync_rst_n),
		       .in_bus({v_ddr4_stats_ack_q[1], v_ddr4_stats_int_q[1], v_ddr4_stats_rdata_q[1]}),
		       .out_bus({ddr_sh_stat_ack1, ddr_sh_stat_int1, ddr_sh_stat_rdata1})
		       );

   // DDR D
   lib_pipe #(.WIDTH(1+1+8+32), .STAGES(NUM_CFG_STGS_CL_DDR_ATG))
   PIPE_DDR_STAT2 (.clk(clk_main_a0), .rst_n(sync_rst_n),
		   .in_bus({sh_ddr_stat_wr2, sh_ddr_stat_rd2, sh_ddr_stat_addr2, sh_ddr_stat_wdata2}),
		   .out_bus({v_ddr4_stats_wr_q[2], v_ddr4_stats_rd_q[2], v_ddr4_stats_addr_q[2], v_ddr4_stats_wdata_q[2]})
		   );


   lib_pipe #(.WIDTH(1+8+32), .STAGES(NUM_CFG_STGS_CL_DDR_ATG))
   PIPE_DDR_STAT_ACK2 (.clk(clk_main_a0), .rst_n(sync_rst_n),
		       .in_bus({v_ddr4_stats_ack_q[2], v_ddr4_stats_int_q[2], v_ddr4_stats_rdata_q[2]}),
		       .out_bus({ddr_sh_stat_ack2, ddr_sh_stat_int2, ddr_sh_stat_rdata2})
		       ); 

   assign v_ddr4_axi4_awburst [0] = 2'b01;
   assign v_ddr4_axi4_awburst [1] = 2'b01;
   assign v_ddr4_axi4_awburst [2] = 2'b01;

   assign v_ddr4_axi4_arburst [0] = 2'b01;
   assign v_ddr4_axi4_arburst [1] = 2'b01;
   assign v_ddr4_axi4_arburst [2] = 2'b01;

   // ================================================================
   // Instantiate sh_ddr (for DDRs A, B, D)

   (* dont_touch = "true" *)
   logic  sh_ddr_sync_rst_n;

   lib_pipe #(.WIDTH(1), .STAGES(4))
   SH_DDR_SLC_RST_N (.clk(clk_main_a0), .rst_n(1'b1), .in_bus(sync_rst_n), .out_bus(sh_ddr_sync_rst_n));

   sh_ddr #(
            .DDR_A_PRESENT(`DDR_A_PRESENT),
            .DDR_B_PRESENT(`DDR_B_PRESENT),
            .DDR_D_PRESENT(`DDR_D_PRESENT)
	    ) SH_DDR
     (
      .clk(clk_main_a0),
      .rst_n(sh_ddr_sync_rst_n),

      .stat_clk(clk_main_a0),
      .stat_rst_n(sh_ddr_sync_rst_n),

      // ----------------------------------------------------------------
      // Physical A, B, D interfaces connected directly to cl_ports

      .CLK_300M_DIMM0_DP(CLK_300M_DIMM0_DP),
      .CLK_300M_DIMM0_DN(CLK_300M_DIMM0_DN),
      .M_A_ACT_N(M_A_ACT_N),
      .M_A_MA(M_A_MA),
      .M_A_BA(M_A_BA),
      .M_A_BG(M_A_BG),
      .M_A_CKE(M_A_CKE),
      .M_A_ODT(M_A_ODT),
      .M_A_CS_N(M_A_CS_N),
      .M_A_CLK_DN(M_A_CLK_DN),
      .M_A_CLK_DP(M_A_CLK_DP),
      .M_A_PAR(M_A_PAR),
      .M_A_DQ(M_A_DQ),
      .M_A_ECC(M_A_ECC),
      .M_A_DQS_DP(M_A_DQS_DP),
      .M_A_DQS_DN(M_A_DQS_DN),
      .cl_RST_DIMM_A_N(cl_RST_DIMM_A_N),
   
   
      .CLK_300M_DIMM1_DP(CLK_300M_DIMM1_DP),
      .CLK_300M_DIMM1_DN(CLK_300M_DIMM1_DN),
      .M_B_ACT_N(M_B_ACT_N),
      .M_B_MA(M_B_MA),
      .M_B_BA(M_B_BA),
      .M_B_BG(M_B_BG),
      .M_B_CKE(M_B_CKE),
      .M_B_ODT(M_B_ODT),
      .M_B_CS_N(M_B_CS_N),
      .M_B_CLK_DN(M_B_CLK_DN),
      .M_B_CLK_DP(M_B_CLK_DP),
      .M_B_PAR(M_B_PAR),
      .M_B_DQ(M_B_DQ),
      .M_B_ECC(M_B_ECC),
      .M_B_DQS_DP(M_B_DQS_DP),
      .M_B_DQS_DN(M_B_DQS_DN),
      .cl_RST_DIMM_B_N(cl_RST_DIMM_B_N),

      .CLK_300M_DIMM3_DP(CLK_300M_DIMM3_DP),
      .CLK_300M_DIMM3_DN(CLK_300M_DIMM3_DN),
      .M_D_ACT_N(M_D_ACT_N),
      .M_D_MA(M_D_MA),
      .M_D_BA(M_D_BA),
      .M_D_BG(M_D_BG),
      .M_D_CKE(M_D_CKE),
      .M_D_ODT(M_D_ODT),
      .M_D_CS_N(M_D_CS_N),
      .M_D_CLK_DN(M_D_CLK_DN),
      .M_D_CLK_DP(M_D_CLK_DP),
      .M_D_PAR(M_D_PAR),
      .M_D_DQ(M_D_DQ),
      .M_D_ECC(M_D_ECC),
      .M_D_DQS_DP(M_D_DQS_DP),
      .M_D_DQS_DN(M_D_DQS_DN),
      .cl_RST_DIMM_D_N(cl_RST_DIMM_D_N),

      // ----------------------------------------------------------------
      // AXI4 A, B, D interfaces connected to local AXI4 buses

      .cl_sh_ddr_awid    (v_ddr4_axi4_awid),
      .cl_sh_ddr_awaddr  (v_ddr4_axi4_awaddr),
      .cl_sh_ddr_awlen   (v_ddr4_axi4_awlen),
      .cl_sh_ddr_awsize  (v_ddr4_axi4_awsize),
      .cl_sh_ddr_awvalid (v_ddr4_axi4_awvalid),
      .cl_sh_ddr_awburst (v_ddr4_axi4_awburst),
      .sh_cl_ddr_awready (v_ddr4_axi4_awready),

      .cl_sh_ddr_wid     (v_ddr4_axi4_wid),
      .cl_sh_ddr_wdata   (v_ddr4_axi4_wdata),
      .cl_sh_ddr_wstrb   (v_ddr4_axi4_wstrb),
      .cl_sh_ddr_wlast   (v_ddr4_axi4_wlast),
      .cl_sh_ddr_wvalid  (v_ddr4_axi4_wvalid),
      .sh_cl_ddr_wready  (v_ddr4_axi4_wready),

      .sh_cl_ddr_bid     (v_ddr4_axi4_bid),
      .sh_cl_ddr_bresp   (v_ddr4_axi4_bresp),
      .sh_cl_ddr_bvalid  (v_ddr4_axi4_bvalid),
      .cl_sh_ddr_bready  (v_ddr4_axi4_bready),

      .cl_sh_ddr_arid    (v_ddr4_axi4_arid),
      .cl_sh_ddr_araddr  (v_ddr4_axi4_araddr),
      .cl_sh_ddr_arlen   (v_ddr4_axi4_arlen),
      .cl_sh_ddr_arsize  (v_ddr4_axi4_arsize),
      .cl_sh_ddr_arvalid (v_ddr4_axi4_arvalid),
      .cl_sh_ddr_arburst (v_ddr4_axi4_arburst),
      .sh_cl_ddr_arready (v_ddr4_axi4_arready),

      .sh_cl_ddr_rid    (v_ddr4_axi4_rid),
      .sh_cl_ddr_rdata  (v_ddr4_axi4_rdata),
      .sh_cl_ddr_rresp  (v_ddr4_axi4_rresp),
      .sh_cl_ddr_rlast  (v_ddr4_axi4_rlast),
      .sh_cl_ddr_rvalid (v_ddr4_axi4_rvalid),
      .cl_sh_ddr_rready (v_ddr4_axi4_rready),

      // ----------------------------------------------------------------
      // DDR A, B, D ready signals

      .sh_cl_ddr_is_ready(ddr4_A_B_D_ready),

      // ----------------------------------------------------------------
      // DDR A, B, D stats connected to local ddr4 stats bus

      .sh_ddr_stat_addr0  (v_ddr4_stats_addr_q[0]) ,
      .sh_ddr_stat_wr0    (v_ddr4_stats_wr_q[0]     ) , 
      .sh_ddr_stat_rd0    (v_ddr4_stats_rd_q[0]     ) , 
      .sh_ddr_stat_wdata0 (v_ddr4_stats_wdata_q[0]  ) , 
      .ddr_sh_stat_ack0   (v_ddr4_stats_ack_q[0]    ) ,
      .ddr_sh_stat_rdata0 (v_ddr4_stats_rdata_q[0]  ),
      .ddr_sh_stat_int0   (v_ddr4_stats_int_q[0]    ),

      .sh_ddr_stat_addr1  (v_ddr4_stats_addr_q[1]) ,
      .sh_ddr_stat_wr1    (v_ddr4_stats_wr_q[1]     ) , 
      .sh_ddr_stat_rd1    (v_ddr4_stats_rd_q[1]     ) , 
      .sh_ddr_stat_wdata1 (v_ddr4_stats_wdata_q[1]  ) , 
      .ddr_sh_stat_ack1   (v_ddr4_stats_ack_q[1]    ) ,
      .ddr_sh_stat_rdata1 (v_ddr4_stats_rdata_q[1]  ),
      .ddr_sh_stat_int1   (v_ddr4_stats_int_q[1]    ),

      .sh_ddr_stat_addr2  (v_ddr4_stats_addr_q[2]) ,
      .sh_ddr_stat_wr2    (v_ddr4_stats_wr_q[2]     ) , 
      .sh_ddr_stat_rd2    (v_ddr4_stats_rd_q[2]     ) , 
      .sh_ddr_stat_wdata2 (v_ddr4_stats_wdata_q[2]  ) , 
      .ddr_sh_stat_ack2   (v_ddr4_stats_ack_q[2]    ) ,
      .ddr_sh_stat_rdata2 (v_ddr4_stats_rdata_q[2]  ),
      .ddr_sh_stat_int2   (v_ddr4_stats_int_q[2]    ) 
      );

   // ================================================================
   // The AWS DDR4 interfaces have a 'wid' bus, which is actually not
   // legal for AXI4 ('wid' only exists for AXI3), per ARM
   // documentation.
   // Here we drive those buses with 0.

   assign  v_ddr4_axi4_wid [0] = 16'b0;    // DDR A
   assign  v_ddr4_axi4_wid [1] = 16'b0;    // DDR B
   assign  cl_sh_ddr_wid       = 16'b0;    // DDR C
   assign  v_ddr4_axi4_wid [2] = 16'b0;    // DDR D

   // ================================================================
   // Tie-off AXI4 for unused DDR C
   assign cl_sh_ddr_awvalid = 1'b0;
   assign cl_sh_ddr_wvalid  = 1'b0;
   assign cl_sh_ddr_arvalid = 1'b0;
   assign cl_sh_ddr_bready  = 1'b0;
   assign cl_sh_ddr_rready  = 1'b0;

   // ================================================================
   // Tie-off AXI4 for Unused DDR D
   assign v_ddr4_axi4_awvalid [2] = 1'b0;
   assign v_ddr4_axi4_wvalid [2]  = 1'b0;
   assign v_ddr4_axi4_arvalid [2] = 1'b0;
   assign v_ddr4_axi4_bready [2]  = 1'b0;
   assign v_ddr4_axi4_rready [2]  = 1'b0;

   // ================================================================
   // mkAWSteria_HW instantiation

   (* dont_touch = "true" *)
   logic mkAWSteria_HW_sync_rst_n;

   lib_pipe #(.WIDTH(1), .STAGES(4))
   mkAWSteria_HW_SLC_RST_N (.clk     (clk_main_a0),
			    .rst_n   (1'b1),
			    .in_bus  (sync_rst_n),
			    .out_bus (mkAWSteria_HW_sync_rst_n));

   mkAWSteria_HW #()
   awsteria_HW   (.CLK   (clk_main_a0),
		  .RST_N (mkAWSteria_HW_sync_rst_n),

		  .CLK_b_CLK (),     // Unused
		  .RST_N_b_RST_N (),    // Unused

		  // ----------------
		  // DMA_PCIS connection
		  .host_AXI4_S_awvalid  (sh_cl_dma_pcis_awvalid),
		  .host_AXI4_S_awid     ({ 10'b0, sh_cl_dma_pcis_awid }),
		  .host_AXI4_S_awaddr   (sh_cl_dma_pcis_awaddr),
		  .host_AXI4_S_awlen    (sh_cl_dma_pcis_awlen),
		  .host_AXI4_S_awsize   (sh_cl_dma_pcis_awsize),
		  .host_AXI4_S_awburst  (2'b01),    // INCR only
		  .host_AXI4_S_awlock   (1'b0),     // unused
		  .host_AXI4_S_awcache  (4'b0),     // unused
		  .host_AXI4_S_awprot   (3'b0),     // unused
		  .host_AXI4_S_awqos    (4'b0),     // unused
		  .host_AXI4_S_awregion (4'b0),     // unused
		  .host_AXI4_S_awready  (cl_sh_dma_pcis_awready),

		  .host_AXI4_S_wvalid   (sh_cl_dma_pcis_wvalid),
		  .host_AXI4_S_wdata    (sh_cl_dma_pcis_wdata),
		  .host_AXI4_S_wstrb    (sh_cl_dma_pcis_wstrb),
		  .host_AXI4_S_wlast    (sh_cl_dma_pcis_wlast),
		  .host_AXI4_S_wready   (cl_sh_dma_pcis_wready),

		  .host_AXI4_S_bvalid   (cl_sh_dma_pcis_bvalid),
		  .host_AXI4_S_bid      (cl_sh_dma_pcis_bid_16b),
		  .host_AXI4_S_bresp    (cl_sh_dma_pcis_bresp),
		  .host_AXI4_S_bready   (sh_cl_dma_pcis_bready),

		  .host_AXI4_S_arvalid  (sh_cl_dma_pcis_arvalid),
		  .host_AXI4_S_arid     ({ 10'b0, sh_cl_dma_pcis_arid }),
		  .host_AXI4_S_araddr   (sh_cl_dma_pcis_araddr),
		  .host_AXI4_S_arlen    (sh_cl_dma_pcis_arlen),
		  .host_AXI4_S_arsize   (sh_cl_dma_pcis_arsize),
		  .host_AXI4_S_arburst  (2'b01),    // INCR only
		  .host_AXI4_S_arlock   (1'b0),     // unused
		  .host_AXI4_S_arcache  (4'b0),     // unused
		  .host_AXI4_S_arprot   (3'b0),     // unused
		  .host_AXI4_S_arqos    (4'b0),     // unused
		  .host_AXI4_S_arregion (4'b0),     // unused
		  .host_AXI4_S_arready  (cl_sh_dma_pcis_arready),

		  .host_AXI4_S_rvalid   (cl_sh_dma_pcis_rvalid),
		  .host_AXI4_S_rid      (cl_sh_dma_pcis_rid_16b),
		  .host_AXI4_S_rdata    (cl_sh_dma_pcis_rdata),
		  .host_AXI4_S_rresp    (cl_sh_dma_pcis_rresp),
		  .host_AXI4_S_rlast    (cl_sh_dma_pcis_rlast),
		  .host_AXI4_S_rready   (sh_cl_dma_pcis_rready),

		  // ----------------
		  // OCL SLAVE (AXI4_Lite_32_32 Slave)
		  .host_AXI4L_S_awvalid (sh_ocl_awvalid),
		  .host_AXI4L_S_awaddr  (sh_ocl_awaddr),
		  .host_AXI4L_S_awprot  (3'b0),        // unused
		  .host_AXI4L_S_awready (ocl_sh_awready),

		  .host_AXI4L_S_wvalid  (sh_ocl_wvalid),
		  .host_AXI4L_S_wdata   (sh_ocl_wdata),
		  .host_AXI4L_S_wstrb   (sh_ocl_wstrb),
		  .host_AXI4L_S_wready  (ocl_sh_wready),

		  .host_AXI4L_S_bvalid  (ocl_sh_bvalid),
		  .host_AXI4L_S_bresp   (ocl_sh_bresp),
		  .host_AXI4L_S_bready  (sh_ocl_bready),

		  .host_AXI4L_S_arvalid (sh_ocl_arvalid),
		  .host_AXI4L_S_araddr  (sh_ocl_araddr),
		  .host_AXI4L_S_arprot  (3'b0),        // unused
		  .host_AXI4L_S_arready (ocl_sh_arready),

		  .host_AXI4L_S_rvalid  (ocl_sh_rvalid),
		  .host_AXI4L_S_rresp   (ocl_sh_rresp),
		  .host_AXI4L_S_rdata   (ocl_sh_rdata),
		  .host_AXI4L_S_rready  (sh_ocl_rready),

		  // ----------------
		  // DDR A
		  .ddr_A_M_awvalid  (v_ddr4_axi4_awvalid [0]),
		  .ddr_A_M_awid     (v_ddr4_axi4_awid [0]),
		  .ddr_A_M_awaddr   (v_ddr4_axi4_awaddr [0]),
		  .ddr_A_M_awlen    (v_ddr4_axi4_awlen [0]),
		  .ddr_A_M_awsize   (v_ddr4_axi4_awsize [0]),
		  .ddr_A_M_awburst  (),    // Unused; we drive 2'b01 (INCR) into sh_ddr
		  .ddr_A_M_awlock   (),    // Unused
		  .ddr_A_M_awcache  (),    // Unused
		  .ddr_A_M_awprot   (),    // Unused
		  .ddr_A_M_awqos    (),    // Unused
		  .ddr_A_M_awregion (),    // Unused
		  .ddr_A_M_awready  (v_ddr4_axi4_awready [0]),

		  .ddr_A_M_wvalid   (v_ddr4_axi4_wvalid [0]),
		  .ddr_A_M_wdata    (v_ddr4_axi4_wdata [0]),
		  .ddr_A_M_wstrb    (v_ddr4_axi4_wstrb [0]),
		  .ddr_A_M_wlast    (v_ddr4_axi4_wlast [0]),
		  .ddr_A_M_wready   (v_ddr4_axi4_wready [0]),

		  .ddr_A_M_bvalid   (v_ddr4_axi4_bvalid [0]),
		  .ddr_A_M_bid      (v_ddr4_axi4_bid [0]),
		  .ddr_A_M_bresp    (v_ddr4_axi4_bresp [0]),
		  .ddr_A_M_bready   (v_ddr4_axi4_bready [0]),

		  .ddr_A_M_arvalid  (v_ddr4_axi4_arvalid [0]),
		  .ddr_A_M_arid     (v_ddr4_axi4_arid [0]),
		  .ddr_A_M_araddr   (v_ddr4_axi4_araddr [0]),
		  .ddr_A_M_arlen    (v_ddr4_axi4_arlen [0]),
		  .ddr_A_M_arsize   (v_ddr4_axi4_arsize [0]),
		  .ddr_A_M_arburst  (),    // Unused; we drive 2'b01 (INCR) into sh_ddr
		  .ddr_A_M_arlock   (),    // Unused
		  .ddr_A_M_arcache  (),    // Unused
		  .ddr_A_M_arprot   (),    // Unused
		  .ddr_A_M_arqos    (),    // Unused
		  .ddr_A_M_arregion (),    // Unused
		  .ddr_A_M_arready  (v_ddr4_axi4_arready [0]),

		  .ddr_A_M_rvalid   (v_ddr4_axi4_rvalid [0]),
		  .ddr_A_M_rid      (v_ddr4_axi4_rid [0]),
		  .ddr_A_M_rdata    (v_ddr4_axi4_rdata [0]),
		  .ddr_A_M_rresp    (v_ddr4_axi4_rresp [0]),
		  .ddr_A_M_rlast    (v_ddr4_axi4_rlast [0]),
		  .ddr_A_M_rready   (v_ddr4_axi4_rready [0]),

		  // ----------------
		  // DDR B
		  .ddr_B_M_awvalid  (v_ddr4_axi4_awvalid [1]),
		  .ddr_B_M_awid     (v_ddr4_axi4_awid [1]),
		  .ddr_B_M_awaddr   (v_ddr4_axi4_awaddr [1]),
		  .ddr_B_M_awlen    (v_ddr4_axi4_awlen [1]),
		  .ddr_B_M_awsize   (v_ddr4_axi4_awsize [1]),
		  .ddr_B_M_awburst  (),    // Unused; we drive 2'b01 (INCR) into sh_ddr
		  .ddr_B_M_awlock   (),    // Unused
		  .ddr_B_M_awcache  (),    // Unused
		  .ddr_B_M_awprot   (),    // Unused
		  .ddr_B_M_awqos    (),    // Unused
		  .ddr_B_M_awregion (),    // Unused
		  .ddr_B_M_awready  (v_ddr4_axi4_awready [1]),

		  .ddr_B_M_wvalid   (v_ddr4_axi4_wvalid [1]),
		  .ddr_B_M_wdata    (v_ddr4_axi4_wdata [1]),
		  .ddr_B_M_wstrb    (v_ddr4_axi4_wstrb [1]),
		  .ddr_B_M_wlast    (v_ddr4_axi4_wlast [1]),
		  .ddr_B_M_wready   (v_ddr4_axi4_wready [1]),

		  .ddr_B_M_bvalid   (v_ddr4_axi4_bvalid [1]),
		  .ddr_B_M_bid      (v_ddr4_axi4_bid [1]),
		  .ddr_B_M_bresp    (v_ddr4_axi4_bresp [1]),
		  .ddr_B_M_bready   (v_ddr4_axi4_bready [1]),

		  .ddr_B_M_arvalid  (v_ddr4_axi4_arvalid [1]),
		  .ddr_B_M_arid     (v_ddr4_axi4_arid [1]),
		  .ddr_B_M_araddr   (v_ddr4_axi4_araddr [1]),
		  .ddr_B_M_arlen    (v_ddr4_axi4_arlen [1]),
		  .ddr_B_M_arsize   (v_ddr4_axi4_arsize [1]),
		  .ddr_B_M_arburst  (),    // unused; we drive 2'b01 (INCR) into sh_ddr
		  .ddr_B_M_arlock   (),    // Unused
		  .ddr_B_M_arcache  (),    // Unused
		  .ddr_B_M_arprot   (),    // Unused
		  .ddr_B_M_arqos    (),    // Unused
		  .ddr_B_M_arregion (),    // Unused
		  .ddr_B_M_arready  (v_ddr4_axi4_arready [1]),

		  .ddr_B_M_rvalid   (v_ddr4_axi4_rvalid [1]),
		  .ddr_B_M_rid      (v_ddr4_axi4_rid [1]),
		  .ddr_B_M_rdata    (v_ddr4_axi4_rdata [1]),
		  .ddr_B_M_rresp    (v_ddr4_axi4_rresp [1]),
		  .ddr_B_M_rlast    (v_ddr4_axi4_rlast [1]),
		  .ddr_B_M_rready   (v_ddr4_axi4_rready [1]),

		  // ----------------
		  // Misc signals

		  .m_env_ready_env_ready (ddr4_A_B_C_D_ready [0] & ddr4_A_B_C_D_ready [1]),
		  .m_halted (),
		  .m_glcount_glcount (sh_cl_glcount)
		  );

// ****************************************************************
// ****************************************************************

endmodule   
