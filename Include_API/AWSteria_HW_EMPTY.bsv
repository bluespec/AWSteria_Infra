// Copyright (c) 2021 Bluespec, Inc.  All Rights Reserved.
// Author: Rishiyur S. Nikhil

package AWSteria_HW;

// ================================================================
// This package contains the mkAWSteria_HW module with AWSteria_HW_IFC interface.

// In this implementation:
// it contains an AXI4 fabric (64b addrs, 512b data):
//    S 0: connects to host_AXI4_S
//    S 1: connects to host_AXI4L_S (via an AXI4-Lite-to-AXI4 adapter)
//    M 0,1,2,3: Connect to DDRs 0,1,2,3 (A,B,C,D)

// ================================================================
// BSV library imports

import FIFOF       :: *;
import GetPut      :: *;
import Connectable :: *;
import Clocks      :: *;

// ----------------
// BSV additional libs

import Semi_FIFOF :: *;
import GetPut_Aux :: *;

// ================================================================
// Project imports

import AXI4_Types           :: *;
import AXI4_Fabric          :: *;
import AXI4_Lite_Types      :: *;

import AWSteria_HW_IFC    :: *;

// ================================================================

export mkAWSteria_HW;

// ****************************************************************
// Module: synthesized instance of AWSteria HW-side top-level (the DUT)

// For host_AXI4_S interface (wd_id, wd_addr, wd_data, wd_user)
typedef AXI4_Slave_IFC #(16, 64, 512, 0)  AXI4_16_64_512_0_S_IFC;

// For host_AXI4L_S interface (wd_addr, wd_data, wd_user)
typedef AXI4_Lite_Slave_IFC #(32, 32, 0)  AXI4L_32_32_0_S_IFC;

// For each DDR connection
typedef AXI4_Master_IFC #(16, 64, 512, 0)  AXI4_16_64_512_0_M_IFC;

(* synthesize *)
module mkAWSteria_HW #(Clock b_CLK, Reset b_RST_N)
   (AWSteria_HW_IFC #(AXI4_Slave_IFC #(16, 64, 512, 0),
		      AXI4_Lite_Slave_IFC #(32, 32, 0),
		      AXI4_Master_IFC #(16, 64, 512, 0)));

   // ... fill in instantiations of state, sub-modules ...

   // ================================================================
   // BEHAVIOR

   // ... fill in rules, connections, etc ...

   // ================================================================
   // INTERFACE

   // Facing Host
   interface AXI4_Slave_IFC      host_AXI4_S  = ...;    // fill in details
   interface AXI4_Lite_Slave_IFC host_AXI4L_S = ...;    // fill in details

   // Facing DDR
   interface AXI4_Master_IFC ddr_A_M = ...;    // fill in details

`ifdef INCLUDE_DDR_B
   interface AXI4_Master_IFC ddr_B_M = ...;    // fill in details
`endif

`ifdef INCLUDE_DDR_C
   interface AXI4_Master_IFC ddr_C_M = ...;    // fill in details
`endif

`ifdef INCLUDE_DDR_D
   interface AXI4_Master_IFC ddr_D_M = ...;    // fill in details
`endif

   // ================
   // Status signals

   // The AWSteria environment asserts this to inform the DUT that it is ready
   method Action m_env_ready (Bool env_ready);
      // ... fill in details ...
   endmethod

   // The DUT asserts this to inform the AWSteria environment that it has "halted"
   method Bool m_halted;
      // ... fill in details ...
   endmethod

   // ================
   // Real-time counter (in AWS and VCU118: 4ns period, irrespective of DUT clock)

   method Action m_glcount (Bit #(64) glcount);
      // ... fill in details ...
   endmethod
endmodule

// ================================================================

endpackage
