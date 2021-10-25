###  -*-Makefile-*-

# ================================================================

.PHONY: help
help:
	@echo "Usage:"
	@echo "    make compile       Use bsc to compile for Bluesim"
	@echo "    make simulator     Use bsc create Bluesim executable"
	@echo ""
	@echo "    make clean         Remove build_dir (for intermediate files)."
	@echo "    make full_clean    Restore to pristine state."
	@echo ""
	@echo "  Current bsc compiler flags: $(BSC_COMPILATION_FLAGS)"
	@echo "  Please define TARGET=VCU118 or TARGET=AWSF1 for proper DDR setup"

# ================================================================
# Defs

ifndef FLUTE_REPO
  $(error ERROR: please define FLUTE_REPO, i.e., path to Flute repo)
else
  $(info  INFO: FLUTE_REPO is $(FLUTE_REPO))
endif

ifndef AWSTERIA_INFRA_REPO
  $(error ERROR: please define AWSTERIA_INFRA_REPO, i.e., path to AWSteria_Infra repo)
else
  $(info  INFO: AWSTERIA_INFRA_REPO is $(AWSTERIA_INFRA_REPO))
endif

ifndef BLUESPEC_HOME
  $(error ERROR: please define BLUESPEC_HOME, i.e., path to bsc installation)
else
  $(info  INFO: BLUESPEC_HOME is $(BLUESPEC_HOME))
endif

PLATFORM_SIM = $(AWSTERIA_INFRA_REPO)/Platform_Sim

# Default target
TARGET ?= VCU118

#================================================================
# BSC flags

ifeq ($(TARGET),VCU118)

  BSC_COMPILATION_FLAGS += -D SIM_FOR_VCU118
  BSC_COMPILATION_FLAGS += -D INCLUDE_DDR_A
  BSC_COMPILATION_FLAGS += -D INCLUDE_DDR_B
  $(info  INFO: TARGET is VCU118 (has DDR A and B))

else ifeq ($(TARGET),AWSF1)

  BSC_COMPILATION_FLAGS += -D SIM_FOR_AWSF1
  BSC_COMPILATION_FLAGS += -D INCLUDE_DDR_A
  BSC_COMPILATION_FLAGS += -D INCLUDE_DDR_B
  BSC_COMPILATION_FLAGS += -D INCLUDE_DDR_C
  BSC_COMPILATION_FLAGS += -D INCLUDE_DDR_D
  $(info  INFO: TARGET is AWSF1 (has DDR A, B, C and D))

else
  $(error ERROR: please define TARGET=VCU118 or TARGET=AWSF1 for proper DDR setup)
endif

#================================================================
# BSC_PATH for AWSteria_Infra TestApp

# The Test App
BSC_PATH := $(BSC_PATH):$(AWSTERIA_INFRA_REPO)/TestApp/HW

# From AWSteria_Infra
BSC_PATH := $(BSC_PATH):$(AWSTERIA_INFRA_REPO)/Include_API
BSC_PATH := $(BSC_PATH):$(AWSTERIA_INFRA_REPO)/Platform_Sim/HW

# From Flute
BSC_PATH := $(BSC_PATH):$(FLUTE_REPO)/src_Core/BSV_Additional_Libs
BSC_PATH := $(BSC_PATH):$(FLUTE_REPO)/src_Testbench/Fabrics/AXI4
BSC_PATH := $(BSC_PATH):$(FLUTE_REPO)/src_Testbench/Fabrics/AXI4_Lite
BSC_PATH := $(BSC_PATH):$(FLUTE_REPO)/src_Testbench/Fabrics/Adapters

#================================================================
# Common boilerplate rules, and simulator-specific rules

include $(PLATFORM_SIM)/HW/Include_Common.mk
include $(PLATFORM_SIM)/HW/Include_Bluesim.mk

# ================================================================
