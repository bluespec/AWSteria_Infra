// Copyright (c) 2021 Bluespec, Inc.  All Rights Reserved.
// Author: Rishiyur S. Nikhil

package BluPont_HW_Side_IFC;

// ================================================================
// This package contains the interface definition for the top-level of
// a BSV app that plugs into the BluPont frame.
// The BSV app's top-level should be a 'mkBluPont_HW_Side' module
// presenting this interface.

// ================================================================
// The top-level interface for the BSV design inside BluPont

interface BluPont_HW_Side_IFC #(type host_AXI4_S_IFC,     // facing host
				type host_AXI4L_S_IFC,    // facing host
				type ddr4_AXI4_M_IFC);    // facing DDR4s

   // AXI4 facing host (in AWS, this is the 'DMA_PCIS' interface)
   interface host_AXI4_S_IFC   host_AXI4_S;

   // AXI4-Lite facing host (in AWS, this is the 'OCL' interface)
   interface host_AXI4L_S_IFC  host_AXI4L_S;

   // Facing DDR4
   interface ddr4_AXI4_M_IFC  ddr4_A_M;

`ifdef INCLUDE_DDR4_B
   interface ddr4_AXI4_M_IFC  ddr4_B_M;
`endif

`ifdef INCLUDE_DDR4_C
   interface ddr4_AXI4_M_IFC  ddr4_C_M;
`endif

`ifdef INCLUDE_DDR4_D
   interface ddr4_AXI4_M_IFC  ddr4_D_M;
`endif

   // DDR4 ready signals
   // The BluPont environment invokes this to signal that DDR4s are ready for access
   (* always_ready, always_enabled *)
   method Action m_ddr4s_ready (Bit #(4) ddr4s_ready);

   // ================
   // Convenience interfaces from other FPGA resources

   // Global counters
   // The BluPont environment may provide these counters.
   // (in AWS: these tick at 4ns, irrespective of DUT clock)
   (* always_ready, always_enabled *)
   method Action m_glcount0 (Bit #(64) glcount0);
   (* always_ready, always_enabled *)
   method Action m_glcount1 (Bit #(64) glcount1);

   // Virtual LEDs
   // The BluPont environment may use these LED outputs.
   (* always_ready *)
   method Bit #(16) m_vled;

   // Virtual DIP Switches
   // The BluPont environment may provide DIP switch inputs.
   (* always_enabled, always_ready *)
   method Action m_vdip (Bit #(16) vdip);

   // Final shutdown
   // The BluPont environment may use this to know the DUT has "shut down".
   method Bool m_shutdown_received;
endinterface

// ================================================================

endpackage
