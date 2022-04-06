###  -*-Makefile-*-

# Copyright (c) 2020-2022 Bluespec, Inc.  All Rights Reserved

# ================================================================

.PHONY: help
help:
	@echo "Usage:"
	@echo "    make compile       Create dir RTL/ and compile/copy sources to RTL there."
	@echo "    make for_garnet    Prepare directory for Garnet flow"
	@echo ""
	@echo "    make clean         Remove build_dir (for intermediate files)."
	@echo "    make full_clean    Restore to pristine state."
	@echo ""
	@echo "  Current DDR compiler flag: $(INCLUDE_DDRS)"

# ================================================================
# Dependencies on other repos

ifndef AWSTERIA_INFRA_REPO
  $(error ERROR: please define AWSTERIA_INFRA_REPO, i.e., path to AWSteria_Infra repo)
else
  $(info  INFO: AWSTERIA_INFRA_REPO is $(AWSTERIA_INFRA_REPO))
endif

ifndef FLUTE_REPO
  $(error ERROR: please define FLUTE_REPO, i.e., path to Flute repo)
else
  $(info  INFO: FLUTE_REPO is $(FLUTE_REPO))
endif

ifndef BLUESPEC_HOME
  $(error ERROR: please define BLUESPEC_HOME, i.e., path to bsc installation)
else
  $(info  INFO: BLUESPEC_HOME is $(BLUESPEC_HOME))
endif

# ================================================================
# BSC_PATH for Test App

# The Test App
BSC_PATH := $(BSC_PATH):$(AWSTERIA_INFRA_REPO)/TestApp/HW

# From AWSteria
BSC_PATH := $(BSC_PATH):$(AWSTERIA_INFRA_REPO)/Include_API
BSC_PATH := $(BSC_PATH):$(AWSTERIA_INFRA_REPO)/Platform_VCU118/HW

# From Flute (utils, AXI4)
BSC_PATH := $(BSC_PATH):$(FLUTE_REPO)/src_Core/BSV_Additional_Libs
BSC_PATH := $(BSC_PATH):$(FLUTE_REPO)/src_Testbench/Fabrics/AXI4
BSC_PATH := $(BSC_PATH):$(FLUTE_REPO)/src_Testbench/Fabrics/AXI4_Lite
BSC_PATH := $(BSC_PATH):$(FLUTE_REPO)/src_Testbench/Fabrics/Adapters

# ================================================================
# Top-level file and module

TOPFILE   = $(AWSTERIA_INFRA_REPO)/TestApp/HW/AWSteria_HW.bsv
TOPMODULE = mkAWSteria_HW

# ================================================================
# bsc compilation flags

# VCU118 has DDR A and DDR B
INCLUDE_DDRS += -D INCLUDE_DDR_A
INCLUDE_DDRS += -D INCLUDE_DDR_B

BSC_COMPILATION_FLAGS += $(INCLUDE_DDRS) \
	-keep-fires -aggressive-conditions -no-warn-action-shadowing \
	-no-show-timestamps -check-assert \
	-suppress-warnings G0020    \
	+RTS -K128M -RTS  -show-range-conflict

# Search path for bsc for .bsv files (see also 'copy_external_BSV' above)

BSC_PATH := $(BSC_PATH):+

# ================================================================
# Generate Verilog RTL from BSV sources (needs Bluespec 'bsc' compiler)

RTL_GEN_DIRS = -vdir RTL  -bdir build_dir  -info-dir build_dir

.PHONY: compile
compile:
	mkdir -p  build_dir
	mkdir -p  RTL
	@echo  "INFO: RTL generation ..."
	bsc -u -elab -verilog  $(RTL_GEN_DIRS)  $(BSC_COMPILATION_FLAGS)  -p $(BSC_PATH)  $(TOPFILE)
	@echo  "INFO: RTL generation finished: RTL/ is ready for FPGA build."

# ================================================================
# For VCU118: collect all RTL needed for garnet flow

FOR_GARNET_DIR = garnet_TestApp_HW_250MHz

.PHONY: for_garnet
for_garnet:
	@echo "INFO: Creating and populating garnet example dir (no reclocking)"
	cp -p -R $(AWSTERIA_INFRA_REPO)/Platform_VCU118/HW/example_AWSteria_HW  $(FOR_GARNET_DIR)
	cp -p    RTL/*.v  $(FOR_GARNET_DIR)/src/
	@echo "Copying RTL from BLUESPEC_HOME = $(BLUESPEC_HOME)"
	cp -p  $(BLUESPEC_HOME)/lib/Verilog/FIFO2.v        $(FOR_GARNET_DIR)/src/
	cp -p  $(BLUESPEC_HOME)/lib/Verilog/SizedFIFO.v    $(FOR_GARNET_DIR)/src/
	@echo "INFO: garnet example dir is ready: $(FOR_GARNET_DIR)"

# ================================================================

.PHONY: clean
clean:
	rm -r -f  *~  tmp_all_srcs  build_dir

.PHONY: full_clean
full_clean: clean
	rm -r -f  *~  tmp_all_srcs  build_dir  RTL  $(FOR_GARNET_DIR)

# ================================================================
