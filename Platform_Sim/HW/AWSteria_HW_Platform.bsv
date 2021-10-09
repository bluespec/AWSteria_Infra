// Copyright (c) 2021 Bluespec, Inc.  All Rights Reserved.
// Author: Rishiyur S. Nikhil

package AWSteria_HW_Platform;

// ================================================================
// Simulation-specific parameters

// ----------------
`ifdef SIM_FOR_VCU118

// WARNING: these should be same as in: Platform_VCU118/HW/AWSteria_HW_Platform.bsv

Bit #(64) ddr_A_base = 'h_0_0000_0000;
Bit #(64) ddr_A_lim  = 'h_0_8000_0000;

Bit #(64) ddr_B_base = 'h_0_8000_0000;
Bit #(64) ddr_B_lim  = 'h_1_0000_0000;

`endif

// ----------------
`ifdef SIM_FOR_AWSF1

// WARNING: these should be same as in: Platform_AWSF1/HW/AWSteria_HW_Platform.bsv

Bit #(64) ddr_A_base = 'h_00_0000_0000;
Bit #(64) ddr_A_lim  = 'h_04_0000_0000;

Bit #(64) ddr_B_base = 'h_04_0000_0000;
Bit #(64) ddr_B_lim  = 'h_08_0000_0000;

Bit #(64) ddr_C_base = 'h_08_0000_0000;
Bit #(64) ddr_C_lim  = 'h_0C_0000_0000;

Bit #(64) ddr_D_base = 'h_0C_0000_0000;
Bit #(64) ddr_D_lim  = 'h_10_0000_0000;

`endif
// ----------------

// ================================================================

endpackage
