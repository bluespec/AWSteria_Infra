// Copyright (c) 2021 Bluespec, Inc.  All Rights Reserved.
// Author: Rishiyur S. Nikhil

package AWSteria_HW_Platform;

// ================================================================
// VCU118-specific parameters

Bit #(64) ddr_A_base = 'h_0_0000_0000;
Bit #(64) ddr_A_lim  = 'h_0_8000_0000;

Bit #(64) ddr_B_base = 'h_0_8000_0000;
Bit #(64) ddr_B_lim  = 'h_1_0000_0000;

// ================================================================

endpackage
