// Copyright (c) 2021 Bluespec, Inc.  All Rights Reserved.
// Author: Rishiyur S. Nikhil

package BluPont_HW_Side;

// ================================================================
// This package contains the BluPont_HW_Side module.

// It instantiates a BluPont_HW_Side_Depth1 module and connects the 3
// AXI4 interfaces and one AXI4 Lite interfaces to it after passing
// them through clock-domain-crossings.

// The inner module runs at slower clock (1/2, 13, 1/4, ... speed)

// ================================================================
// BSV library imports

import FIFOF       :: *;
import GetPut      :: *;
import Connectable :: *;
import Clocks      :: *;

// ----------------
// BSV additional libs

import Cur_Cycle  :: *;
import Semi_FIFOF :: *;
import GetPut_Aux :: *;

// ================================================================
// Project imports

import AXI4_Types           :: *;
import AXI4_Fabric          :: *;
import AXI4_Lite_Types      :: *;
import AXI_SyncBuffer       :: *;

import AXI4L_S_to_AXI4_M_Adapter :: *;

import BluPont_HW_Side_IFC    :: *;
import BluPont_HW_Side_Depth1 :: *;

// ================================================================

export mkBluPont_HW_Side;
export AXI4_16_64_512_0_S_IFC;
export AXI4L_32_32_0_S_IFC;
export AXI4_16_64_512_0_M_IFC;

// ================================================================
// AWS Specific interfaces

// For 'DMA PCIS' connection to PCIe to host (wd_id, wd_addr, wd_data, wd_user)
typedef AXI4_Slave_IFC #(16, 64, 512, 0)  AXI4_16_64_512_0_S_IFC;

// For 'OCL' connection to PCie to host (wd_addr, wd_data, wd_user)
typedef AXI4_Lite_Slave_IFC #(32, 32, 0)  AXI4L_32_32_0_S_IFC;

// For four DDR4 connections
typedef AXI4_Master_IFC #(16, 64, 512, 0)  AXI4_16_64_512_0_M_IFC;

// ****************************************************************
// Module: synthesized instance of BluPont HW-side top-level (the DUT)

(* synthesize *)
module mkBluPont_HW_Side (BluPont_HW_Side_IFC #(AXI4_16_64_512_0_S_IFC,
						AXI4L_32_32_0_S_IFC,
						AXI4_16_64_512_0_M_IFC));

   // Expose current clock/reset and derive slow versions
   Clock fast_CLK  <- exposeCurrentClock;
   Reset fast_RSTN <- exposeCurrentReset;

   ClockDividerIfc clock_divider <- mkClockDivider (2);    // 250 MHz => 125 MHz

   Clock slow_CLK  = clock_divider.slowClock;
   Reset slow_RSTN <- mkAsyncResetFromCR (5, slow_CLK);

   Integer depth = 2;    // of SyncFIFOs

   // ----------------
   // Instantiate the next layer, using the slower clock

   BluPont_HW_Side_IFC #(AXI4_16_64_512_0_S_IFC,
			 AXI4L_32_32_0_S_IFC,
			 AXI4_16_64_512_0_M_IFC)
   hw_side_depth1 <- mkBluPont_HW_Side_Depth1 (clocked_by slow_CLK,
					       reset_by   slow_RSTN);

   // ----------------
   // host AXI4 S clock crossing

   AXI4_Slave_Xactor_IFC  #(16, 64, 512, 0) host_AXI4_S_xactor <- mkAXI4_Slave_Xactor;

   AXI_SyncBuffer_IFC #(AXI4_Wr_Addr #(16, 64,      0),    // wd_id, wd_addr,          wd_user
			AXI4_Wr_Data #(        512, 0),    //                 wd_data, wd_user
			AXI4_Wr_Resp #(16,          0),    // wd_id,                   wd_user
			AXI4_Rd_Addr #(16, 64,      0),    // wd_id, wd_addr,          wd_user
			AXI4_Rd_Data #(16,     512, 0))    // wd_id,          wd_data, wd_user
   host_AXI4_S_SyncBuffer <- mkAXI_SyncBuffer (depth,
					       fast_CLK, fast_RSTN,
					       slow_CLK, slow_RSTN);

   AXI4_Master_Xactor_IFC #(16, 64, 512, 0) host_AXI4_M_xactor <- mkAXI4_Master_Xactor (clocked_by slow_CLK,
										       reset_by   slow_RSTN);

   mkConnection (host_AXI4_S_xactor.o_wr_addr, host_AXI4_S_SyncBuffer.from_M.i_aw);
   mkConnection (host_AXI4_S_xactor.o_wr_data, host_AXI4_S_SyncBuffer.from_M.i_w);
   mkConnection (host_AXI4_S_xactor.i_wr_resp, host_AXI4_S_SyncBuffer.from_M.o_b);
   mkConnection (host_AXI4_S_xactor.o_rd_addr, host_AXI4_S_SyncBuffer.from_M.i_ar);
   mkConnection (host_AXI4_S_xactor.i_rd_data, host_AXI4_S_SyncBuffer.from_M.o_r);

   mkConnection (host_AXI4_S_SyncBuffer.to_S.o_aw, host_AXI4_M_xactor.i_wr_addr);
   mkConnection (host_AXI4_S_SyncBuffer.to_S.o_w,  host_AXI4_M_xactor.i_wr_data);
   mkConnection (host_AXI4_S_SyncBuffer.to_S.i_b,  host_AXI4_M_xactor.o_wr_resp);
   mkConnection (host_AXI4_S_SyncBuffer.to_S.o_ar, host_AXI4_M_xactor.i_rd_addr);
   mkConnection (host_AXI4_S_SyncBuffer.to_S.i_r,  host_AXI4_M_xactor.o_rd_data);

   mkConnection (host_AXI4_M_xactor.axi_side, hw_side_depth1.host_AXI4_S);

   // ----------------
   // host AXI4L S clock crossing

   AXI4_Lite_Slave_Xactor_IFC  #(32, 32, 0) host_AXI4L_S_xactor <- mkAXI4_Lite_Slave_Xactor;

   AXI_SyncBuffer_IFC #(AXI4_Lite_Wr_Addr #(32,     0),    // wd_addr,          wd_user
			AXI4_Lite_Wr_Data #(    32   ),    //          wd_data
			AXI4_Lite_Wr_Resp #(        0),    //                   wd_user
			AXI4_Lite_Rd_Addr #(32,     0),    // wd_addr,          wd_user
			AXI4_Lite_Rd_Data #(    32, 0))    //          wd_data, wd_user
   host_AXI4L_S_SyncBuffer <- mkAXI_SyncBuffer (depth,
						fast_CLK, fast_RSTN,
						slow_CLK, slow_RSTN);
   
   AXI4_Lite_Master_Xactor_IFC #(32, 32, 0) host_AXI4L_M_xactor <- mkAXI4_Lite_Master_Xactor (clocked_by slow_CLK,
											      reset_by   slow_RSTN);

   mkConnection (host_AXI4L_S_xactor.o_wr_addr, host_AXI4L_S_SyncBuffer.from_M.i_aw);
   mkConnection (host_AXI4L_S_xactor.o_wr_data, host_AXI4L_S_SyncBuffer.from_M.i_w);
   mkConnection (host_AXI4L_S_xactor.i_wr_resp, host_AXI4L_S_SyncBuffer.from_M.o_b);
   mkConnection (host_AXI4L_S_xactor.o_rd_addr, host_AXI4L_S_SyncBuffer.from_M.i_ar);
   mkConnection (host_AXI4L_S_xactor.i_rd_data, host_AXI4L_S_SyncBuffer.from_M.o_r);

   mkConnection (host_AXI4L_S_SyncBuffer.to_S.o_aw, host_AXI4L_M_xactor.i_wr_addr);
   mkConnection (host_AXI4L_S_SyncBuffer.to_S.o_w,  host_AXI4L_M_xactor.i_wr_data);
   mkConnection (host_AXI4L_S_SyncBuffer.to_S.i_b,  host_AXI4L_M_xactor.o_wr_resp);
   mkConnection (host_AXI4L_S_SyncBuffer.to_S.o_ar, host_AXI4L_M_xactor.i_rd_addr);
   mkConnection (host_AXI4L_S_SyncBuffer.to_S.i_r,  host_AXI4L_M_xactor.o_rd_data);

   mkConnection (host_AXI4L_M_xactor.axi_side, hw_side_depth1.host_AXI4L_S);

   // ----------------
   // ddr4 A M clock crossing

   AXI4_Slave_Xactor_IFC  #(16, 64, 512, 0) ddr4_A_AXI4_S_xactor <- mkAXI4_Slave_Xactor (clocked_by slow_CLK,
											 reset_by   slow_RSTN);

   AXI_SyncBuffer_IFC #(AXI4_Wr_Addr #(16, 64,      0),    // wd_id, wd_addr,          wd_user
			AXI4_Wr_Data #(        512, 0),    //                 wd_data, wd_user
			AXI4_Wr_Resp #(16,          0),    // wd_id,                   wd_user
			AXI4_Rd_Addr #(16, 64,      0),    // wd_id, wd_addr,          wd_user
			AXI4_Rd_Data #(16,     512, 0))    // wd_id,          wd_data, wd_user
   ddr4_A_SyncBuffer <- mkAXI_SyncBuffer (depth,
						 slow_CLK, slow_RSTN,
						 fast_CLK, fast_RSTN);
   
   AXI4_Master_Xactor_IFC #(16, 64, 512, 0) ddr4_A_AXI4_M_xactor <- mkAXI4_Master_Xactor;

   mkConnection (hw_side_depth1.ddr4_A_M, ddr4_A_AXI4_S_xactor.axi_side);

   mkConnection (ddr4_A_AXI4_S_xactor.o_wr_addr, ddr4_A_SyncBuffer.from_M.i_aw);
   mkConnection (ddr4_A_AXI4_S_xactor.o_wr_data, ddr4_A_SyncBuffer.from_M.i_w);
   mkConnection (ddr4_A_AXI4_S_xactor.i_wr_resp, ddr4_A_SyncBuffer.from_M.o_b);
   mkConnection (ddr4_A_AXI4_S_xactor.o_rd_addr, ddr4_A_SyncBuffer.from_M.i_ar);
   mkConnection (ddr4_A_AXI4_S_xactor.i_rd_data, ddr4_A_SyncBuffer.from_M.o_r);

   mkConnection (ddr4_A_SyncBuffer.to_S.o_aw, ddr4_A_AXI4_M_xactor.i_wr_addr);
   mkConnection (ddr4_A_SyncBuffer.to_S.o_w,  ddr4_A_AXI4_M_xactor.i_wr_data);
   mkConnection (ddr4_A_SyncBuffer.to_S.i_b,  ddr4_A_AXI4_M_xactor.o_wr_resp);
   mkConnection (ddr4_A_SyncBuffer.to_S.o_ar, ddr4_A_AXI4_M_xactor.i_rd_addr);
   mkConnection (ddr4_A_SyncBuffer.to_S.i_r,  ddr4_A_AXI4_M_xactor.o_rd_data);

   // ----------------
   // ddr4 B M clock crossing

`ifdef INCLUDE_DDR4_B

   AXI4_Slave_Xactor_IFC  #(16, 64, 512, 0) ddr4_B_AXI4_S_xactor <- mkAXI4_Slave_Xactor (clocked_by slow_CLK,
											 reset_by   slow_RSTN);

   AXI_SyncBuffer_IFC #(AXI4_Wr_Addr #(16, 64,      0),    // wd_id, wd_addr,          wd_user
			AXI4_Wr_Data #(        512, 0),    //                 wd_data, wd_user
			AXI4_Wr_Resp #(16,          0),    // wd_id,                   wd_user
			AXI4_Rd_Addr #(16, 64,      0),    // wd_id, wd_addr,          wd_user
			AXI4_Rd_Data #(16,     512, 0))    // wd_id,          wd_data, wd_user
   ddr4_B_SyncBuffer <- mkAXI_SyncBuffer (depth,
						 slow_CLK, slow_RSTN,
						 fast_CLK, fast_RSTN);
   
   AXI4_Master_Xactor_IFC #(16, 64, 512, 0) ddr4_B_AXI4_M_xactor <- mkAXI4_Master_Xactor;

   mkConnection (hw_side_depth1.ddr4_B_M, ddr4_B_AXI4_S_xactor.axi_side);

   mkConnection (ddr4_B_AXI4_S_xactor.o_wr_addr, ddr4_B_SyncBuffer.from_M.i_aw);
   mkConnection (ddr4_B_AXI4_S_xactor.o_wr_data, ddr4_B_SyncBuffer.from_M.i_w);
   mkConnection (ddr4_B_AXI4_S_xactor.i_wr_resp, ddr4_B_SyncBuffer.from_M.o_b);
   mkConnection (ddr4_B_AXI4_S_xactor.o_rd_addr, ddr4_B_SyncBuffer.from_M.i_ar);
   mkConnection (ddr4_B_AXI4_S_xactor.i_rd_data, ddr4_B_SyncBuffer.from_M.o_r);

   mkConnection (ddr4_B_SyncBuffer.to_S.o_aw, ddr4_B_AXI4_M_xactor.i_wr_addr);
   mkConnection (ddr4_B_SyncBuffer.to_S.o_w,  ddr4_B_AXI4_M_xactor.i_wr_data);
   mkConnection (ddr4_B_SyncBuffer.to_S.i_b,  ddr4_B_AXI4_M_xactor.o_wr_resp);
   mkConnection (ddr4_B_SyncBuffer.to_S.o_ar, ddr4_B_AXI4_M_xactor.i_rd_addr);
   mkConnection (ddr4_B_SyncBuffer.to_S.i_r,  ddr4_B_AXI4_M_xactor.o_rd_data);

`endif

   // ================================================================
   // BEHAVIOR
   // TODO: clock-cross these from depth 0?

   rule rl_drive_unused_ddr4s_ready;
      hw_side_depth1.m_ddr4s_ready ('1);
   endrule

   rule rl_drive_unused_glcount0;
      hw_side_depth1.m_glcount0 (0);
   endrule

   rule rl_drive_unused_glcount1;
      hw_side_depth1.m_glcount1 (0);
   endrule

   rule rl_drive_unused_vdip;
      hw_side_depth1.m_vdip (0);
   endrule

   // ================================================================
   // INTERFACE

   AXI4_Master_IFC #(16,64,512,0) dummy_ddr4_master = dummy_AXI4_Master_ifc;

   // Facing Host
   interface AXI4_Slave_IFC      host_AXI4_S  = host_AXI4_S_xactor.axi_side;
   interface AXI4_Lite_Slave_IFC host_AXI4L_S = host_AXI4L_S_xactor.axi_side;

   // Facing DDR4
   interface AXI4_Master_IFC ddr4_A_M = ddr4_A_AXI4_M_xactor.axi_side;

`ifdef INCLUDE_DDR4_B
   interface AXI4_Master_IFC ddr4_B_M = ddr4_B_AXI4_M_xactor.axi_side;
`endif

`ifdef INCLUDE_DDR4_C
   interface AXI4_Master_IFC ddr4_C_M = dummy_ddr4_master;
`endif

`ifdef INCLUDE_DDR4_D
   interface AXI4_Master_IFC ddr4_D_M = dummy_ddr4_master;
`endif

   // DDR4 ready signals
   // The BluPont environment invokes this to signal that DDR4s are ready for access
   method Action m_ddr4s_ready (Bit #(N_DDR4s) ddr4s_ready);
      noAction;    // TODO: clock-cross into Depth 1
   endmethod

   // Global counters
   // The BluPont environment may provide these counters.
   // (in AWS: these tick at 4ns, irrespective of DUT clock)
   method Action m_glcount0 (Bit #(64) glcount0);
      noAction;    // TODO: clock-cross into Depth 1
   endmethod

   method Action m_glcount1 (Bit #(64) glcount1);
      noAction;    // TODO: clock-cross into Depth 1
   endmethod

   // Virtual LEDs
   // The BluPont environment may use these LED outputs.
   method Bit #(16) m_vled = 0;    // TODO: clock-cross from Depth 1

   // Virtual DIP Switches
   // The BluPont environment may provide these DIP switch inputs.
   method Action m_vdip (Bit #(16) vdip);
      noAction;    // TODO: clock-cross into Depth 1
   endmethod

   // Final shutdown
   // The BluPont environment may use this to know the DUT has "shut down".
   method Bool m_shutdown_received = False;    // TODO: clock-cross from Depth 1
endmodule

// ================================================================

endpackage
