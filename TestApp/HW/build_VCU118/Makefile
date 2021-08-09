###  -*-Makefile-*-

# Copyright (c) 2020-2021 Bluespec, Inc.  All Rights Reserved

# ================================================================

.PHONY: help
help:
	@echo "Usage:"
	@echo "    make compile       Create dir RTL_from_bsc/ and compile/copy"
	@echo "                           sources to RTL there."
	@echo "    make clean         Remove build_dir (for intermediate files)."
	@echo "    make full_clean    Restore to pristine state."
	@echo ""
	@echo "  The RTL in RTL_from_bsc/ can then be copied to a Garnet example build dir."
	@echo "  Current DDR compiler flag: $(INCLUDE_DDRS)"

#================================================================
# This section copies external BSV sources (from other repos).
# We access external sources this way instead of just setting BSC_PATH
# because IOHO this way is clearer.

ifndef BLUESPEC_HOME
  $(error ERROR: please define BLUESPEC_HOME, i.e., path to Bluespec bsc installation)
endif

ifndef FLUTE_REPO
  $(error ERROR: please define FLUTE_REPO, i.e., path to Flute repository)
endif

RSYNC = rsync --times

.PHONY: copy_external_BSV
copy_external_BSV:
	mkdir -p tmp_all_srcs
	@echo "INFO: Copying BSV sources"
	$(RSYNC)  ../../../Include_API/AWSteria_HW_IFC.bsv                                    tmp_all_srcs/
	$(RSYNC)  ../AWSteria_HW.bsv                                                          tmp_all_srcs/
	@echo "INFO: Copying additional BSV sources from $(FLUTE_REPO)"
	$(RSYNC)  $(FLUTE_REPO)/src_Testbench/Fabrics/AXI4/AXI4_Types.bsv                     tmp_all_srcs/
	$(RSYNC)  $(FLUTE_REPO)/src_Testbench/Fabrics/AXI4/AXI4_Fabric.bsv                    tmp_all_srcs/
	$(RSYNC)  $(FLUTE_REPO)/src_Testbench/Fabrics/AXI4_Lite/AXI4_Lite_Types.bsv           tmp_all_srcs/
	$(RSYNC)  $(FLUTE_REPO)/src_Testbench/Fabrics/Adapters/AXI4L_S_to_AXI4_M_Adapter.bsv  tmp_all_srcs/
	$(RSYNC)  $(FLUTE_REPO)/src_Core/BSV_Additional_Libs/Cur_Cycle.bsv                    tmp_all_srcs/
	$(RSYNC)  $(FLUTE_REPO)/src_Core/BSV_Additional_Libs/GetPut_Aux.bsv                   tmp_all_srcs/
	$(RSYNC)  $(FLUTE_REPO)/src_Core/BSV_Additional_Libs/Semi_FIFOF.bsv                   tmp_all_srcs/
	$(RSYNC)  $(FLUTE_REPO)/src_Core/BSV_Additional_Libs/EdgeFIFOFs.bsv                   tmp_all_srcs/

#================================================================
# Top-level file and module

TOPFILE   = tmp_all_srcs/AWSteria_HW.bsv
TOPMODULE = mkAWSteria_HW

# ================================================================
# bsc compilation flags

# Depending on platform, can also add DDR C and D
INCLUDE_DDRS += -D INCLUDE_DDR_B

BSC_COMPILATION_FLAGS += $(INCLUDE_DDRS) \
	-keep-fires -aggressive-conditions -no-warn-action-shadowing \
	-no-show-timestamps -check-assert \
	-suppress-warnings G0020    \
	+RTS -K128M -RTS  -show-range-conflict

# Search path for bsc for .bsv files (see also 'copy_external_BSV' above)

BSC_PATH = tmp_all_srcs:+

# ================================================================
# Generate Verilog RTL from BSV sources (needs Bluespec 'bsc' compiler)

RTL_GEN_DIRS = -vdir RTL_from_bsc  -bdir build_dir  -info-dir build_dir

.PHONY: compile
compile:  copy_external_BSV
	mkdir -p  build_dir
	mkdir -p  RTL_from_bsc
	@echo  "INFO: RTL generation ..."
	bsc -u -elab -verilog  $(RTL_GEN_DIRS)  $(BSC_COMPILATION_FLAGS)  -p $(BSC_PATH)  $(TOPFILE)
	@echo  "INFO: RTL generation finished: RTL_from_bsc/ is ready for FPGA build."

# ================================================================
# For VCU118: collect all RTL needed for garnet flow

.PHONY: for_garnet
for_garnet:
	@echo "Creating and populating garnet example dir (no reclocking)"
	cp -p -R ../../../Platform_VCU118/HW/example_AWSteria_HW  .
	cp -p    RTL_from_bsc/*.v                             example_AWSteria_HW/src/
	cp -p    $(BLUESPEC_HOME)/lib/Verilog/FIFO2.v         example_AWSteria_HW/src/
	cp -p    $(BLUESPEC_HOME)/lib/Verilog/SizedFIFO.v     example_AWSteria_HW/src/

.PHONY: for_garnet_reclocked
for_garnet_reclocked:
	@echo "Creating and populating garnet example dir (reclocked)"
	cp -p -R ../../../Platform_VCU118/HW/example_AWSteria_HW_reclocked  .
	cp -p    ../../../Platform_VCU118/HW/synchronizers.v  example_AWSteria_HW_reclocked/src/
	cp -p    RTL_from_bsc/*.v                             example_AWSteria_HW_reclocked/src/
	cp -p    $(BLUESPEC_HOME)/lib/Verilog/FIFO2.v         example_AWSteria_HW_reclocked/src/
	cp -p    $(BLUESPEC_HOME)/lib/Verilog/SizedFIFO.v     example_AWSteria_HW_reclocked/src/

# ================================================================

.PHONY: clean
clean:
	rm -r -f  *~  tmp_all_srcs  build_dir

.PHONY: full_clean
full_clean: clean
	rm -r -f  *~  tmp_all_srcs  build_dir  RTL_from_bsc  example_AWSteria_HW  example_AWSteria_HW_reclocked

# ================================================================
