#pragma once

// Copyright (c) 2020-2021 Bluespec, Inc.  All Rights Reserved
// Author: Rishiyur S. Nikhil

// ================================================================
// AWS F1-specific parameters

// ================================================================

#define DDR_A_BASE          0x000000000llu
#define DDR_A_LIM           0x400000000llu

#define DDR_B_BASE          0x400000000llu
#define DDR_B_LIM           0x800000000llu

#define DDR_C_BASE          0x800000000llu
#define DDR_C_LIM           0xC00000000llu

#define DDR_D_BASE          0xC00000000llu
#define DDR_D_LIM           0x1000000000llu

// ----------------
// An addr beyond the last DDR
#define OUT_OF_BOUNDS_ADDR  DDR_D_LIM
