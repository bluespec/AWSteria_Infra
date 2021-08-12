###  -*-Makefile-*-

# ================================================================
# Defs

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

ifndef AWSTERIA_INFRA_REPO
  $(error ERROR: please define AWSTERIA_INFRA_REPO, i.e., path to AWSteria_Infra repo)
else
  $(info  INFO: AWSTERIA_INFRA_REPO is $(AWSTERIA_INFRA_REPO))
endif

PLATFORM_SIM = $(AWSTERIA_INFRA_REPO)/Platform_Sim

#================================================================
# Common boilerplate rules, and simulator-specific rules

include $(PLATFORM_SIM)/HW/Include_Common.mk
include $(PLATFORM_SIM)/HW/Include_Verilator.mk

BSC_PATH := all_srcs:$(BSC_PATH)

# ================================================================
# This is the manifest of all sources needed for the build
# Creates symlinks in all_srcs/ to all required sources

LN = ln -s -r -f

.PHONY: collect_srcs
collect_srcs:
	mkdir -p all_srcs
# DUT sources
	$(LN) ../AWSteria_HW.bsv        all_srcs/
# AWSteria_Infra sources
	$(LN) $(AWSTERIA_INFRA_REPO)/Include_API/AWSteria_HW_IFC.bsv  all_srcs/
	$(LN) $(AWSTERIA_INFRA_REPO)/Platform_Sim/HW/*.bsv            all_srcs/
	$(LN) $(AWSTERIA_INFRA_REPO)/Platform_Sim/HW/*.c              all_srcs/
	$(LN) $(AWSTERIA_INFRA_REPO)/Platform_Sim/HW/*.h              all_srcs/
# AXI4 and AXI4-Lite lib sources
	$(LN) $(FLUTE_REPO)/src_Testbench/Fabrics/AXI4/AXI4_Types.bsv      all_srcs/
	$(LN) $(FLUTE_REPO)/src_Testbench/Fabrics/AXI4/AXI4_Fabric.bsv     all_srcs/
	$(LN) $(FLUTE_REPO)/src_Testbench/Fabrics/AXI4/AXI4_Deburster.bsv  all_srcs/
	$(LN) $(FLUTE_REPO)/src_Testbench/Fabrics/AXI4_Lite/AXI4_Lite_Types.bsv  all_srcs/
	$(LN) $(FLUTE_REPO)/src_Testbench/Fabrics/Adapters/AXI4L_S_to_AXI4_M_Adapter.bsv  all_srcs
# BSV additional libs sources
	$(LN) $(FLUTE_REPO)/src_Core/BSV_Additional_Libs/Cur_Cycle.bsv   all_srcs/
	$(LN) $(FLUTE_REPO)/src_Core/BSV_Additional_Libs/GetPut_Aux.bsv  all_srcs/
	$(LN) $(FLUTE_REPO)/src_Core/BSV_Additional_Libs/Semi_FIFOF.bsv  all_srcs/
	$(LN) $(FLUTE_REPO)/src_Core/BSV_Additional_Libs/EdgeFIFOFs.bsv  all_srcs/
# Verilog from bsc libs
	$(LN) $(BLUESPEC_HOME)/lib/Verilog/RegFile.v    all_srcs/
	$(LN) $(BLUESPEC_HOME)/lib/Verilog/FIFO2.v      all_srcs/
	$(LN) $(BLUESPEC_HOME)/lib/Verilog/SizedFIFO.v  all_srcs/

# ================================================================
