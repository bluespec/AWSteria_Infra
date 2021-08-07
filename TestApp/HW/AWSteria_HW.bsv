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

import Cur_Cycle  :: *;
import Semi_FIFOF :: *;
import GetPut_Aux :: *;

// ================================================================
// Project imports

import AXI4_Types           :: *;
import AXI4_Fabric          :: *;
import AXI4_Lite_Types      :: *;

import AXI4L_S_to_AXI4_M_Adapter :: *;

import AWSteria_HW_IFC    :: *;

// ================================================================

export mkAWSteria_HW;
export AXI4_16_64_512_0_S_IFC;
export AXI4L_32_32_0_S_IFC;
export AXI4_16_64_512_0_M_IFC;

// ****************************************************************
// Module: synthesized instance of AXI4L_S to AXI4_M adapter

(* synthesize *)
module mkAXI4L_S_to_AXI4_M_Adapter_synth (AXI4L_S_to_AXI4_M_Adapter_IFC #(// AXI4L_S
									  32,    // wd_addr
									  32,    // wd_data
									  0,     // wd_user
									  // AXI4L_M
									  16,    // wd_id
									  64,    // wd_addr
									  512,   // wd_data
									  0));   // wd_user
   let ifc <- mkAXI4L_S_to_AXI4_M_Adapter;
   return ifc;
endmodule

// ****************************************************************
// Module: synthesized instance of AXI4 fabric connecting the host
// AXI4 and AXI4-Lite to the AXI4 DDRs

// ----------------
// Address-Decode function to route requests to appropriate server
//     DDR A addr (server 0): base addr 0x_0_0000_0000
//     DDR B addr (server 1): base addr 0x_4_0000_0000    (16GB)
//     DDR C addr (server 2): base addr 0x_8_0000_0000    (32GB)
//     DDR D addr (server 3): base addr 0x_C_0000_0000    (48GB)

function Tuple2 #(Bool, Bit #(TLog #(N_DDRs)))  fn_addr_to_ddr_num (Bit #(64) addr);
   Bit #(TLog #(N_DDRs)) ddr_num = truncate (addr [63:34]);
   Bit #(TSub #(64, TAdd #(TLog #(N_DDRs), 33))) msbs = truncateLSB (addr);
   Bool                  valid   = (msbs == 0);
   return tuple2 (valid, ddr_num);
endfunction

// ----------------
// The fabric

typedef AXI4_Fabric_IFC #(2,       // num M ports
			  N_DDRs,  // num S ports
			  16,      // wd_id
			  64,      // wd_addr
			  512,     // wd_data
			  0)
        AXI4_16_64_512_0_Fabric_2_N_IFC;

(* synthesize *)
module mkAXI4_16_64_512_0_Fabric_2_N (AXI4_16_64_512_0_Fabric_2_N_IFC);
   let fabric <- mkAXI4_Fabric (fn_addr_to_ddr_num);
   return fabric;
endmodule

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

   // AXI4-Lite to AXI4 adapter
   AXI4L_S_to_AXI4_M_Adapter_IFC #(32,    // wd_addr_AXI4L_S
				   32,    // wd_data_AXI4L_S
				   0,     // wd_user_AXI4L_S
				   16,      // wd_id_AXI4_M
				   64,    // wd_addr_AXI4_M
				   512,   // wd_data_AXI4_M
				   0)     // wd_user_AXI4_M)
       adapter_AXI4L_S_to_AXI4_M <- mkAXI4L_S_to_AXI4_M_Adapter_synth;

   // AXI4 Fabric
   AXI4_16_64_512_0_Fabric_2_N_IFC  fabric <- mkAXI4_16_64_512_0_Fabric_2_N;

   // Regs for control/status signals
   Reg #(Bool)      rg_env_ready <- mkReg (False);
   Reg #(Bit #(64)) rg_glcount   <- mkReg (0);
   Reg #(Bool)      rg_halted    <- mkReg (False);    // For simulation shutdown

   // ================================================================
   // BEHAVIOR

   // Connect AXI4-Lite-to-AXI4-adapter to AXI4 fabric
   mkConnection (adapter_AXI4L_S_to_AXI4_M.ifc_AXI4_M,
		 fabric.v_from_masters [1]);

   // Tie off DDR B if not included
`ifndef INCLUDE_DDR_B
   AXI4_Slave_IFC #(16,64,512,0) dummy_ddr_S = dummy_AXI4_Slave_ifc;

   mkConnection (fabric.v_to_slaves [1], dummy_ddr_S);
`endif

   // ================================================================
   // INTERFACE

   AXI4_16_64_512_0_M_IFC dummy_ddr_master = dummy_AXI4_Master_ifc;

   // Facing Host
   interface AXI4_Slave_IFC      host_AXI4_S  = fabric.v_from_masters [0];
   interface AXI4_Lite_Slave_IFC host_AXI4L_S = adapter_AXI4L_S_to_AXI4_M.ifc_AXI4L_S;

   // Facing DDR
   interface AXI4_Master_IFC ddr_A_M = fabric.v_to_slaves [0];

`ifdef INCLUDE_DDR_B
   interface AXI4_Master_IFC ddr_B_M = fabric.v_to_slaves [1];
`endif

`ifdef INCLUDE_DDR_C
   interface AXI4_Master_IFC ddr_C_M = dummy_ddr_master;
`endif

`ifdef INCLUDE_DDR_D
   interface AXI4_Master_IFC ddr_D_M = dummy_ddr_master;
`endif

   // ================
   // Status signals

   // The AWSteria environment asserts this to inform the DUT that it is ready
   method Action m_env_ready (Bool env_ready);
      rg_env_ready <= env_ready;
   endmethod

   // The DUT asserts this to inform the AWSteria environment that it has "halted"
   method Bool m_halted = rg_halted;

   // ================
   // Real-time counter (in AWS and VCU118: 4ns period, irrespective of DUT clock)

   method Action m_glcount (Bit #(64) glcount);
      rg_glcount <= glcount;
   endmethod
endmodule

// ================================================================

endpackage
