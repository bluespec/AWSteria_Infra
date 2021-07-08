###  -*-Makefile-*-

# Copyright (c) 2020-2021 Bluespec, Inc.  All Rights Reserved

# ================================================================

ifndef BLUPONT_REPO
  $(error ERROR: please define BLUPONT_REPO)
endif

#================================================================
# This include file copies all sources locally

include Copy_Sources.mk

#================================================================
# Common boilerplate rules

BSC_COMPILATION_FLAGS += -D INCLUDE_DDR4_B -D INCLUDE_DDR4_C -D INCLUDE_DDR4_D

include $(BLUPONT_REPO)/Platform_Sim/Resources/Include_HW_Side_Common.mk
include $(BLUPONT_REPO)/Platform_Sim/Resources/Include_HW_Side_Verilator.mk

# ================================================================
