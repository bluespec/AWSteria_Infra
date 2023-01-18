# Copyright (c) 2020-2023 Bluespec, Inc.  All Rights Reserved

# Makefile to build HW-side simulation executable (Verilator)
# for AWSteria_Infra's TestApp for VCU118 or AWS F1.

# ================================================================
.PHONY: help
help:  show_resource_paths
	@echo ""
	@echo "Available targets for 'make':"
	@echo "  generate_verilog    Generate RTL (using bsc)"
	@echo "  simulator           Create simulation executable (using Verilator)"
	@echo ""
	@echo "  clean               Remove intermediate files"
	@echo "  full_clean          Restore to pristine state"
	@echo ""
	@echo "Simulation executable: $(SIM_EXE_FILE)"
	@echo "TARGET = $(TARGET)     (can be PLATFORM_VCU118 or PLATFORM_AWSF1)"
	@echo "Current BSC_COMPILATION_FLAGS (bsc compiler flags):"
	@echo "  $(BSC_COMPILATION_FLAGS)"
	@echo "Current BSC_PATH (bsc compiler path):"
	@echo "  $(BSC_PATH)"
	@echo "Current VERILATOR_FLAGS:"
	@echo "  $(VERILATOR_FLAGS)"

# ================================================================
# Defs of resources etc.

$(info INFO: use 'make help' to show current settings.)
$(info INFO: Including Makefile_Params.mk which should define paths to external resources.)

include Makefile_Params.mk

# Default target platform
TARGET ?= PLATFORM_VCU118

# Top-level file and module
TOPFILE   ?= $(AWSTERIA_INFRA_REPO)/Platform_Sim/HW/Top_HW_Side.bsv
TOPMODULE ?= mkTop_HW_Side

# ================================================================
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

# ================================================================
# BSC_PATH for bsc to find .bsv files

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

BSC_COMPILATION_FLAGS += -keep-fires -aggressive-conditions -no-warn-action-shadowing
BSC_COMPILATION_FLAGS += -no-show-timestamps -check-assert  -show-range-conflict
BSC_COMPILATION_FLAGS += -suppress-warnings G0020
BSC_COMPILATION_FLAGS += +RTS -K128M -RTS

# ================================================================
# Generate Verilog RTL from BSV sources (needs Bluespec 'bsc' compiler)

BSC_TMP_DIR = bsc_tmp_dir
VERILOG_RTL = Verilog_RTL

RTL_GEN_DIRS = -vdir $(VERILOG_RTL)  -bdir $(BSC_TMP_DIR)  -info-dir $(BSC_TMP_DIR)

.PHONY: generate_verilog
generate_verilog:
	mkdir -p  $(BSC_TMP_DIR)
	mkdir -p  $(VERILOG_RTL)
	@echo  "INFO: Verilog RTL generation ..."
	bsc -u -elab -verilog  $(RTL_GEN_DIRS)  $(BSC_COMPILATION_FLAGS)  -p $(BSC_PATH)  $(TOPFILE)
	@echo  "INFO: Verilog RTL generated into: $(VERILOG_RTL)/"

# ----------------------------------------------------------------
# Compile and link Verilog RTL into a Verilator simulation executable

# Additional module(s) with DPI-C calls that need edits to remove '$imported_' prefix
# Each of these should have a 'sed' step (see below)
EDIT_MODULE2 = mkAWSteria_System

VTOP                = V$(TOPMODULE)
VERILATOR_RESOURCES = $(AWSTERIA_INFRA_REPO)/Platform_Sim/HW/Verilator_resources
VERILATOR_RTL       = Verilator_RTL
VERILATOR_MAKE_DIR  = Verilator_Make

# Verilator file-search paths
VERILATOR_FLAGS += -I$(BSC_LIBS)

# Verilator flags:
#   The following are recommended in verilator manual for best performance
#     -O3                          Verilator optimization level
#     --x-assign fast              Optimize X value
#     --x-initial fast             Optimize uninitialized value
#     --noassert                   Disable all assertions
#   Directory in which Verilator places verilated files, does the build, etc.
#     --Mdir <dir>
#   C++ compiler flags
#     -CFLAGS -O3
#   ld flags
#     -LDFLAGS -static
#   Generate multi-threaded simulation
#     --threads N                  Use N threads
#     --threads-dpi none/pure/all  Which DPI functions are considered thread-safe
#   Dump stats on the design, in file {prefix}__stats.txt
#     --stats
#   Generate VCDs (select trace-depth according to your module hierarchy)
#     --trace  --trace-depth 2  -CFLAGS -DVM_TRACE

VERILATOR_FLAGS += -Mdir $(VERILATOR_MAKE_DIR)
VERILATOR_FLAGS += -O3 --x-assign fast --x-initial fast --noassert
VERILATOR_FLAGS += --stats -CFLAGS -O3 -CFLAGS -DVL_DEBUG
# VERILATOR_FLAGS += -LDFLAGS -static

# VERILATOR_FLAGS += --threads 6  --threads-dpi pure
VERILATOR_FLAGS += --trace  -CFLAGS -DVM_TRACE

# The next line is needed in Verilator from v5.000 onwards
# Comment it out for earlier versions of Verilator
VERILATOR_FLAGS += --no-timing

.PHONY: simulator
simulator:
	@echo "----------------"
	@echo "INFO: Preparing RTL files for verilator"
	@echo "Copying all Verilog files from Verilog_RTL/ to $(VERILATOR_RTL)"
	mkdir -p $(VERILATOR_RTL)
	cp -p  Verilog_RTL/*.v  $(VERILATOR_RTL)/
	@echo "Copying boilerplate Verilog files to $(VERILATOR_RTL)"
	cp -p  $(VERILATOR_RESOURCES)/ClockDiv.v  $(VERILATOR_RTL)/
	@echo "----------------"
	@echo "INFO: Editing Verilog_RTL/$(TOPMODULE).v -> $(VERILATOR_RTL)/$(TOPMODULE).v for DPI-C"
	sed  -f $(VERILATOR_RESOURCES)/sed_script.txt  Verilog_RTL/$(TOPMODULE).v  > tmp1.v
	cat  $(VERILATOR_RESOURCES)/verilator_config.vlt \
	     $(VERILATOR_RESOURCES)/import_DPI_C_decls.v \
	     tmp1.v                                          > $(VERILATOR_RTL)/$(TOPMODULE).v
	rm   -f  tmp1.v
	@echo "----------------"
	@echo "INFO: Editing Verilog_RTL/$(EDIT_MODULE2).v -> $(VERILATOR_RTL)/$(EDIT_MODULE2).v for DPI-C"
	sed  -f $(VERILATOR_RESOURCES)/sed_script.txt  Verilog_RTL/$(EDIT_MODULE2).v  \
		> $(VERILATOR_RTL)/$(EDIT_MODULE2).v
	@echo "----------------"
	@echo "INFO: Verilating Verilog files (in $(VERILATOR_MAKE_DIR))"
	verilator \
		-I$(VERILATOR_RTL) \
		$(VERILATOR_FLAGS) \
		--cc  --exe --build -j 4 -o $(SIM_EXE_FILE)  $(TOPMODULE).v \
		--top-module $(TOPMODULE) \
		$(VERILATOR_RESOURCES)/sim_main.cpp \
		$(AWSTERIA_INFRA_REPO)/Platform_Sim/HW/C_Imported_Functions.c
	mv  $(VERILATOR_MAKE_DIR)/$(SIM_EXE_FILE)  .
	@echo "----------------"
	@echo "INFO: Created verilator executable:    $(SIM_EXE_FILE)"

# ================================================================

.PHONY: clean
clean:
	rm -r -f  *~  $(BSC_TMP_DIR)  $(VERILOG_RTL)  $(VERILATOR_RTL)  $(VERILATOR_MAKE_DIR)

.PHONY: full_clean
full_clean: clean
	rm -r -f  $(SIM_EXE_FILE)

# ================================================================
