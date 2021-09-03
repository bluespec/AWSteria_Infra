###  -*-Makefile-*-

# Copyright (c) 2018-2021 Bluespec, Inc. All Rights Reserved

# This file is not a standalone Makefile, but 'include'd by other Makefiles

# ================================================================

.PHONY: help
help:
	@echo '    make  compile      Recompile HW-side'
	@echo '    make  simulator    Compiles and links intermediate files/RTL to create simulation executable'
	@echo '                           (Bluesim or verilator)'
	@echo '    make  all          = make  compile  simulator'
	@echo ''
	@echo '    make  clean        Remove intermediate build-files unnecessary for execution'
	@echo '    make  full_clean   Restore to pristine state (pre-building anything)'

.PHONY: all
all: compile  simulator

# ================================================================
# Search path for bsc for .bsv files

BSC_PATH := $(BSC_PATH):+

# ----------------
# Top-level file and module

TOPFILE   ?= $(AWSTERIA_INFRA_REPO)/Platform_Sim/HW/Top_HW_Side.bsv
TOPMODULE ?= mkTop_HW_Side

# ----------------
# Final simulation executable

SIM_EXE_FILE = exe_HW_sim

# ================================================================
# bsc compilation flags

BSC_COMPILATION_FLAGS += \
	-D INCLUDE_DDR_B \
	-keep-fires -aggressive-conditions -no-warn-action-shadowing -no-show-timestamps -check-assert \
	-suppress-warnings G0020    \
	+RTS -K128M -RTS  -show-range-conflict

# ================================================================

.PHONY: clean
clean:
	rm -r -f  *~  build_dir  obj_dir

.PHONY: full_clean
full_clean: clean
	rm -r -f  $(SIM_EXE_FILE)*  Verilog_RTL  Verilator_RTL  Verilator_Make

# ================================================================
