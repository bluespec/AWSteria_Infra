#pragma once

// Copyright (c) 2020-2022 Bluespec, Inc.  All Rights Reserved
// Author: Rishiyur S. Nikhil

// ================================================================
// VCU118-specific parameters

// ================================================================

#define DDR_A_BASE           0x00000000llu
#define DDR_A_LIM            0x80000000llu

#define DDR_B_BASE           0x80000000llu
#define DDR_B_LIM           0x100000000llu

// ----------------
// An addr beyond the last DDR
#define OUT_OF_BOUNDS_ADDR  DDR_B_LIM
