###  -*-Makefile-*-

# Copyright (c) 2020-2021 Bluespec, Inc.  All Rights Reserved

# ================================================================

ifndef BLUPONT_REPO
  $(error ERROR: please define BLUPONT_REPO)
endif

.PHONY: help
help:
	@echo "Usage:"
	@echo "    make compile       Create dir Verilog_RTL/ and compile/copy"
	@echo "                           sources to RTL there."
	@echo "    make clean         Remove build_dir (for intermediate files)."
	@echo "    make full_clean    Restore to pristine state."
	@echo ""
	@echo "  The RTL in Verilog_RTL/ can then be copied to a Garnet example build dir."
	@echo "  Current DDR4 compiler flag: $(INCLUDE_DDRS)"

#================================================================
# This include-file creates populates directory 'all_srcs/'
# with copies of all sources need to build (using 'rsync').
# Modify it as necessary for your application's sources.

include Copy_Sources.mk

#================================================================
# Top-level file and module

TOPFILE   = all_srcs/BluPont_HW_Side.bsv
TOPMODULE = mkBluPont_HW_Side

# ================================================================
# bsc compilation flags

# Depending on platform, can also add DDR4 C and D
INCLUDE_DDRS += -D INCLUDE_DDR4_B

BSC_COMPILATION_FLAGS += $(INCLUDE_DDRS) \
	-keep-fires -aggressive-conditions -no-warn-action-shadowing \
	-no-show-timestamps -check-assert \
	-suppress-warnings G0020    \
	+RTS -K128M -RTS  -show-range-conflict

# Search path for bsc for .bsv files

BSC_PATH = all_srcs:+

# Directories for copies of sources, intermediate build files,
# generated and copied RTL

all_srcs:
	mkdir -p $@

build_dir:
	mkdir -p $@

Verilog_RTL:
	mkdir -p $@

# ================================================================
# Generate Verilog RTL from BSV sources (needs Bluespec 'bsc' compiler)

RTL_GEN_DIRS = -vdir Verilog_RTL  -bdir build_dir  -info-dir build_dir

.PHONY: compile
compile:  build_dir  Verilog_RTL  rsync_srcs
	@echo  "INFO: RTL generation ..."
	bsc -u -elab -verilog  $(RTL_GEN_DIRS)  $(BSC_COMPILATION_FLAGS)  -p $(BSC_PATH)  $(TOPFILE)
	@echo  "INFO: RTL generation finished: Verilog_RTL/ is ready for AWS F1 DCP-build."

# ================================================================

.PHONY: clean
clean:
	rm -r -f  *~  all_srcs  build_dir

.PHONY: full_clean
full_clean: clean
	rm -r -f  all_srcs  build_dir  Verilog_RTL

# ================================================================
