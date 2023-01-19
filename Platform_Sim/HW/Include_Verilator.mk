###  -*-Makefile-*-

# Copyright (c) 2018-2023 Bluespec, Inc. All Rights Reserved

# This file is not a standalone Makefile, but 'include'd by other Makefiles

# ================================================================
# Generate Verilog RTL from BSV sources (needs Bluespec 'bsc' compiler)

RTL_GEN_DIRS = -vdir Verilog_RTL  -bdir build_dir  -info-dir build_dir

build_dir:
	mkdir -p $@

Verilog_RTL:
	mkdir -p $@

.PHONY: compile
compile:  build_dir  Verilog_RTL
	@echo  "INFO: Verilog RTL generation ..."
	bsc -u -elab -verilog  $(RTL_GEN_DIRS)  $(BSC_COMPILATION_FLAGS)  -p $(BSC_PATH)  $(TOPFILE)
	@echo  "INFO: Verilog RTL generation finished"

# ================================================================
# Compile and link Verilog RTL sources into an verilator executable

# Additional module(s) with DPI-C calls that need edits to remove '$imported_' prefix
# Each of these should have a 'sed' step (see below)
EDIT_MODULE2 = mkAWSteria_System

VTOP                = V$(TOPMODULE)
VERILATOR_RESOURCES = $(AWSTERIA_INFRA_REPO)/Platform_Sim/HW/Verilator_resources
VERILATOR_MAKE_DIR  = Verilator_Make

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

# The next line is needed for Verilator 5.000 onwards
VERILATOR_FLAGS += --no-timing

.PHONY: simulator
simulator:
	@echo "----------------"
	@echo "INFO: Preparing RTL files for verilator"
	@echo "Copying all Verilog files from Verilog_RTL/ to Verilator_RTL"
	mkdir -p Verilator_RTL
	cp -p  Verilog_RTL/*.v  Verilator_RTL/
	@echo "Copying boilerplate Verilog files to Verilator_RTL"
	cp -p  $(VERILATOR_RESOURCES)/ClockDiv.v  Verilator_RTL/
	@echo "----------------"
	@echo "INFO: Editing Verilog_RTL/$(TOPMODULE).v -> Verilator_RTL/$(TOPMODULE).v for DPI-C"
	sed  -f $(VERILATOR_RESOURCES)/sed_script.txt  Verilog_RTL/$(TOPMODULE).v  > tmp1.v
	cat  $(VERILATOR_RESOURCES)/verilator_config.vlt \
	     $(VERILATOR_RESOURCES)/import_DPI_C_decls.v \
	     tmp1.v                                          > Verilator_RTL/$(TOPMODULE).v
	rm   -f  tmp1.v
	@echo "----------------"
	@echo "INFO: Editing Verilog_RTL/$(EDIT_MODULE2).v -> Verilator_RTL/$(EDIT_MODULE2).v for DPI-C"
	sed  -f $(VERILATOR_RESOURCES)/sed_script.txt  Verilog_RTL/$(EDIT_MODULE2).v  > Verilator_RTL/$(EDIT_MODULE2).v
	@echo "----------------"
	@echo "INFO: Verilating Verilog files (in $(VERILATOR_MAKE_DIR))"
	verilator \
		-IVerilator_RTL \
		$(VERILATOR_FLAGS) \
		--cc  --exe --build -j 4 -o $(SIM_EXE_FILE)  $(TOPMODULE).v \
		--top-module $(TOPMODULE) \
		$(VERILATOR_RESOURCES)/sim_main.cpp \
		$(AWSTERIA_INFRA_REPO)/Platform_Sim/HW/C_Imported_Functions.c
	mv  $(VERILATOR_MAKE_DIR)/$(SIM_EXE_FILE)  .
	@echo "----------------"
	@echo "INFO: Created verilator executable:    $(SIM_EXE_FILE)"

# ================================================================
