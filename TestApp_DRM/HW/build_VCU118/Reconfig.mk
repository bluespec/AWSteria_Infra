# Copyright (c) 2021-2022 Bluespec, Inc.  All Rights Reserved.

# These are commands to program the Xilinx PCIe-connected FPGA (e.g.,
# VCU118) with various partial bitfiles, using "partial reconfiguration".
# Uses the Xilinx XVSEC driver (and related xvsecctl command).

# ================================================================

.PHONY: help
help:
	@echo "Usage:"
	@echo "  make reconfig_TESTAPP_DRM_250MHZ      Load partial bitfile"
	@echo "    $(PARTIAL_BITFILE_TESTAPP_DRM_250MHZ)"
	@echo "  make reconfig_TESTAPP_DRM_100MHZ      Load partial bitfile"
	@echo "    $(PARTIAL_BITFILE_TESTAPP_DRM_100MHZ)"
	@echo "  NOTE: uses 'sudo'"

# ================================================================
# Partial-reconfig bitfiles

# AWSteria_HW TestApp_DRM (no reclocking, running at 250 MHz)
PARTIAL_BITFILE_TESTAPP_DRM_250MHZ ?= ~/git_clones/CTSRD-CHERI_garnet/example_TestApp_DRM/build/AWSteria_pblock_partition_partial.bit

# AWSteria_HW TestApp_DRM (with reclocking, running at 100 MHz)
PARTIAL_BITFILE_TESTAPP_DRM_100MHZ ?= ~/git_clones/CTSRD-CHERI_garnet/example_TestApp_DRM_100MHz/build/AWSteria_pblock_partition_partial.bit

# ================================================================
# Programming the bitfile and partial reconfig

BUS           = 0x07
DEVICE_NO     = 0x0
CAPABILITY_ID = 0x1

.PHONY: reconfig_TESTAPP_DRM_250MHZ
reconfig_TESTAPP_DRM_250MHZ:
	@echo "Reconfiguring partition with $(PARTIAL_BITFILE_TESTAPP_DRM_250MHZ)"
	sudo xvsecctl -b $(BUS) -F $(DEVICE_NO) -c $(CAPABILITY_ID) -p $(PARTIAL_BITFILE_TESTAPP_DRM_250MHZ)

.PHONY: reconfig_TESTAPP_DRM_100MHZ
reconfig_TESTAPP_DRM_100MHZ:
	@echo "Reconfiguring partition with $(PARTIAL_BITFILE_TESTAPP_DRM_100MHZ)"
	sudo xvsecctl -b $(BUS) -F $(DEVICE_NO) -c $(CAPABILITY_ID) -p $(PARTIAL_BITFILE_TESTAPP_DRM_100MHZ)

# ================================================================
