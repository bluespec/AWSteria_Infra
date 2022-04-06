// Copyright (c) 2021-2022 Bluespec, Inc.  All Rights Reserved.
// Author: Rishiyur S. Nikhil

package AWSteria_HW_IFC;

// ================================================================
// This package contains the interface definition for the top-level of
// a BSV AWSteria app.

// The BSV AWSteria app should have a top-level module
// 'mkAWSteria_HW' module with this interface.

// ****************************************************************
// Number of DDRs supported
// Options: A, AB, ABC, ABCD

`ifdef INCLUDE_DDR_D
typedef 4  N_DDRs;
`elsif INCLUDE_DDR_C
typedef 3  N_DDRs;
`elsif INCLUDE_DDR_B
typedef 2  N_DDRs;
`else
typedef 1  N_DDRs;
`endif

// ****************************************************************
// The top-level interface for the BSV design inside AWSteria

interface AWSteria_HW_IFC #(type host_AXI4_S_IFC,     // facing host
			    type host_AXI4L_S_IFC,    // facing host
			    type ddr_AXI4_M_IFC);     // facing DDRs

   // AXI4 facing host (in AWS, this connects to the 'DMA_PCIS' interface)
   interface host_AXI4_S_IFC   host_AXI4_S;

   // AXI4-Lite facing host (in AWS, this connects to the 'OCL' interface)
   interface host_AXI4L_S_IFC  host_AXI4L_S;

   // Facing from 1 to 4 DDRs
   interface ddr_AXI4_M_IFC  ddr_A_M;

`ifdef INCLUDE_DDR_B
   interface ddr_AXI4_M_IFC  ddr_B_M;
`endif

`ifdef INCLUDE_DDR_C
   interface ddr_AXI4_M_IFC  ddr_C_M;
`endif

`ifdef INCLUDE_DDR_D
   interface ddr_AXI4_M_IFC  ddr_D_M;
`endif

   // ================
   // Status signals

   // The AWSteria environment asserts this to inform the DUT that it is ready
   (* always_ready, always_enabled *)
   method Action m_env_ready (Bool env_ready);

   // The DUT asserts this to inform the AWSteria environment that it has "halted"
   (* always_ready *)
   method Bool m_halted;

   // ================
   // Real-time counter (in AWS and VCU118: 4ns period, irrespective of DUT clock)

   (* always_ready, always_enabled *)
   method Action m_glcount (Bit #(64) glcount);
endinterface

// ================================================================

endpackage
