###  -*-Makefile-*-

# Copyright (c) 2020-2022 Bluespec, Inc.  All Rights Reserved

# Makefile to build HW-side simulation (Bluesim)
# for AWSteria_Infra's TestApp for VCU118 or AWS F1.

# ================================================================
.PHONY: help
help:  show_resource_paths
	@echo "Available targets for 'make':"
	@echo "  compile       Use bsc to compile for Bluesim"
	@echo "  simulator     Create Bluesim executable $(SIM_EXE_FILE)"
	@echo ""
	@echo "  clean         Remove intermediate files."
	@echo "  full_clean    Restore to pristine state."
	@echo ""
	@echo "Simulation executable: $(SIM_EXE_FILE)"
	@echo "TARGET = $(TARGET)     (can be PLATFORM_VCU118 or PLATFORM_AWSF1)"
	@echo "Current BSC_COMPILATION_FLAGS (bsc compiler flags):"
	@echo "  $(BSC_COMPILATION_FLAGS)"
	@echo "Current BSC_PATH (bsc compiler path):"
	@echo "  $(BSC_PATH)"

# ================================================================
# Defs of resources etc.

$(info INFO: use 'make help' to show current settings.)
$(info INFO: Including Makefile_Params.mk which should define paths to external resources.)

include Makefile_Params.mk

# Default target platform
TARGET ?= PLATFORM_AWSF1

# Top-level file and module
TOPFILE   ?= $(AWSTERIA_INFRA_REPO)/Platform_Sim/HW/Top_HW_Side.bsv
TOPMODULE ?= mkTop_HW_Side

#================================================================
# Target-specific defs

ifeq ($(TARGET),PLATFORM_VCU118)

  BSC_COMPILATION_FLAGS += -D INCLUDE_DDR_A
  BSC_COMPILATION_FLAGS += -D INCLUDE_DDR_B
  BSC_PATH := $(AWSTERIA_INFRA_REPO)/Platform_VCU118/HW

  SIM_EXE_FILE ?= exe_HW_VCU118_sim

else ifeq ($(TARGET),PLATFORM_AWSF1)

  BSC_COMPILATION_FLAGS += -D INCLUDE_DDR_A
  BSC_COMPILATION_FLAGS += -D INCLUDE_DDR_B
  BSC_COMPILATION_FLAGS += -D INCLUDE_DDR_C
  BSC_COMPILATION_FLAGS += -D INCLUDE_DDR_D
  BSC_PATH := $(AWSTERIA_INFRA_REPO)/Platform_AWSF1/HW

  SIM_EXE_FILE ?= exe_HW_AWSF1_sim

else
  $(error ERROR: please define TARGET=PLATFORM_VCU118 or TARGET=PLATFORM_AWSF1 for proper DDR setup)
endif

#================================================================
# BSC_PATH for AWSteria_Infra TestApp

# The Test App
BSC_PATH := $(BSC_PATH):$(AWSTERIA_INFRA_REPO)/TestApp/HW

# From AWSteria_Infra
BSC_PATH := $(BSC_PATH):$(AWSTERIA_INFRA_REPO)/Include_API
BSC_PATH := $(BSC_PATH):$(AWSTERIA_INFRA_REPO)/Platform_Sim/HW

# From External Resources
BSC_PATH := $(BSC_PATH):$(BSV_ADDITIONAL_LIBS)
BSC_PATH := $(BSC_PATH):$(AMBA_FABRICS)/AXI4
BSC_PATH := $(BSC_PATH):$(AMBA_FABRICS)/AXI4_Lite
BSC_PATH := $(BSC_PATH):$(AMBA_FABRICS)/Adapters

# Path to default bsc libs
BSC_PATH := $(BSC_PATH):+

# ================================================================
# bsc compilation flags

BSC_COMPILATION_FLAGS += \
	-keep-fires -aggressive-conditions -no-warn-action-shadowing -no-show-timestamps -check-assert \
	-suppress-warnings G0020    \
	+RTS -K128M -RTS  -show-range-conflict

# ================================================================
# Compile Bluesim intermediate files from BSV sources (needs Bluespec 'bsc' compiler)

TMP_DIRS  = -bdir build_dir  -simdir build_dir  -info-dir build_dir

build_dir:
	mkdir -p $@

.PHONY: compile
compile: build_dir
	@echo "INFO: Re-compiling Core (CPU, Caches)"
	bsc -u -elab -sim  $(TMP_DIRS)  $(BSC_COMPILATION_FLAGS)  -p $(BSC_PATH)  $(TOPFILE)
	@echo "INFO: Re-compiled  Core (CPU, Caches)"

# ----------------------------------------------------------------
# Compile and link intermediate files into a Bluesim executable

BSC_C_FLAGS += \
	-Xl -v \
	-Xc -O3 -Xc++ -O3 \

# You may have to remove this line above
# for Bluespec_2019.05.beta2-debian9stretch-amd64
#	-Xc++  -D_GLIBCXX_USE_CXX11_ABI=0 \

.PHONY: simulator
simulator:
	@echo "INFO: linking bsc-compiled objects into Bluesim executable"
	bsc -sim -parallel-sim-link 8  +RTS -K1G -RTS \
		$(TMP_DIRS) \
		-e $(TOPMODULE) -o ./$(SIM_EXE_FILE) \
		$(BSC_C_FLAGS) \
		$(AWSTERIA_INFRA_REPO)/Platform_Sim/HW/C_Imported_Functions.c
	@echo "INFO: linked bsc-compiled objects into Bluesim executable"

# ================================================================

.PHONY: clean
clean:
	rm -r -f  *~  build_dir  obj_dir

.PHONY: full_clean
full_clean: clean
	rm -r -f  $(SIM_EXE_FILE)  $(SIM_EXE_FILE).so

# ================================================================
