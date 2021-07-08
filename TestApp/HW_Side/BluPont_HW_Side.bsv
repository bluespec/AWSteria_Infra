// Copyright (c) 2021 Bluespec, Inc.  All Rights Reserved.
// Author: Rishiyur S. Nikhil

package BluPont_HW_Side;

// ================================================================
// This package contains the BluPont_HW_Side module.

// In this implementation:
// it contains an AXI4 fabric (64b addrs, 512b data):
//    S 0: connects to host AXI4
//    S 1: connects to host AXI4-Lite (via an AXI4-Lite-to-AXI4 adapter)
//    M 0,1,2,3: Connects to DDR4s 0,1,2,3 (A,B,C,D)

// ================================================================
// BSV library imports

import FIFOF       :: *;
import GetPut      :: *;
import Connectable :: *;

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

import BluPont_HW_Side_IFC :: *;

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
//     DDR4 A addr (server 0): base addr 0x_0_0000_0000
//     DDR4 B addr (server 1): base addr 0x_4_0000_0000
//     DDR4 C addr (server 2): base addr 0x_8_0000_0000
//     DDR4 D addr (server 3): base addr 0x_C_0000_0000

function Tuple2 #(Bool, Bit #(1))  fn_addr_to_ddr4_num (Bit #(64) addr);
   let      msbs       = addr [63:35];
   Bit #(1) server_num = addr [34:34];
   Bool     valid      = (msbs == 0);
   return tuple2 (valid, server_num);
endfunction

// ----------------
// The fabric

typedef AXI4_Fabric_IFC #(2,      // num_masters
			  2,      // num_servers
			  16,     // wd_id
			  64,     // wd_addr
			  512,    // wd_data
			  0)
        AXI4_16_64_512_0_Fabric_2_2_IFC;

(* synthesize *)
module mkAXI4_16_64_512_0_Fabric_2_2 (AXI4_16_64_512_0_Fabric_2_2_IFC);
   let fabric <- mkAXI4_Fabric (fn_addr_to_ddr4_num);
   return fabric;
endmodule

// ****************************************************************
// Module: synthesized instance of BluPont HW-side top-level (the DUT)

(* synthesize *)
module mkBluPont_HW_Side (BluPont_HW_Side_IFC #(AXI4_16_64_512_0_S_IFC,
						AXI4L_32_32_0_S_IFC,
						AXI4_16_64_512_0_M_IFC));
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
   AXI4_16_64_512_0_Fabric_2_2_IFC  fabric <- mkAXI4_16_64_512_0_Fabric_2_2;

   // Regs for control/status signals
   Reg #(Bit #(4))  rg_ddr4s_ready <- mkReg (0);
   Reg #(Bit #(64)) rg_glcount0    <- mkReg (0);
   Reg #(Bit #(64)) rg_glcount1    <- mkReg (0);
   Reg #(Bit #(16)) rg_vdip        <- mkReg (0);
   Reg #(Bit #(16)) rg_vled        <- mkReg (0);

   Reg #(Bool) rg_shutdown_received <- mkReg (False);    // For simulation shutdown

   // ================================================================
   // BEHAVIOR

   // Connect AXI4-Lite-to-AXI4-adapter to AXI4 fabric
   mkConnection (adapter_AXI4L_S_to_AXI4_M.ifc_AXI4_M,
		 fabric.v_from_masters [1]);

   /* For Debugging only
   Reg #(Bool) rg_done_once <- mkReg (False);

   rule rl_once (! rg_done_once);
      fabric.set_verbosity (1);
      rg_done_once <= True;
   endrule
   */

   // ================================================================
   // INTERFACE

   AXI4_Master_IFC #(16,64,512,0) dummy_ddr4_master = dummy_AXI4_Master_ifc;

   // Facing Host
   interface AXI4_Slave_IFC      host_AXI4_S  = fabric.v_from_masters [0];
   interface AXI4_Lite_Slave_IFC host_AXI4L_S = adapter_AXI4L_S_to_AXI4_M.ifc_AXI4L_S;

   // Facing DDR4
   interface AXI4_Master_IFC ddr4_A_M = fabric.v_to_slaves [0];
   interface AXI4_Master_IFC ddr4_B_M = fabric.v_to_slaves [1];
   interface AXI4_Master_IFC ddr4_C_M = dummy_ddr4_master;
   interface AXI4_Master_IFC ddr4_D_M = dummy_ddr4_master;

   // DDR4 ready signals
   // The BluPont environment invokes this to signal that DDR4s are ready for access
   method Action m_ddr4s_ready (Bit #(4) ddr4s_ready);
      rg_ddr4s_ready <= ddr4s_ready;
   endmethod

   // Global counters
   // The BluPont environment may provide these counters.
   // (in AWS: these tick at 4ns, irrespective of DUT clock)
   method Action m_glcount0 (Bit #(64) glcount0);
      rg_glcount0 <= glcount0;
   endmethod

   method Action m_glcount1 (Bit #(64) glcount1);
      rg_glcount1 <= glcount1;
   endmethod

   // Virtual LEDs
   // The BluPont environment may use these LED outputs.
   method Bit #(16) m_vled = rg_vled;

   // Virtual DIP Switches
   // The BluPont environment may provide these DIP switch inputs.
   method Action m_vdip (Bit #(16) vdip);
      rg_vdip <= vdip;
   endmethod

   // Final shutdown
   // The BluPont environment may use this to know the DUT has "shut down".
   method Bool m_shutdown_received = rg_shutdown_received;
endmodule

// ================================================================

endpackage
