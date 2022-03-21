# Copyright (c) 2021-2022 Bluespec, Inc.  All Rights Reserved.

# These are commands to program the Xilinx PCIe-connected FPGA (e.g.,
# VCU118) with various partial bitfiles, using "partial reconfiguration".
# Uses the Xilinx XVSEC driver (and related xvsecctl command).

# ================================================================

.PHONY: help
help:
	@echo "Usage:"
	@echo "  make reconfig_Garnet_Example      Load partial bitfile"
	@echo "    $(PARTIAL_BITFILE_GARNET_EXAMPLE)"
	@echo "  make reconfig_TESTAPP_250MHZ      Load partial bitfile"
	@echo "    $(PARTIAL_BITFILE_TESTAPP_250MHZ)"
	@echo "  make reconfig_TESTAPP_100MHZ      Load partial bitfile"
	@echo "    $(PARTIAL_BITFILE_TESTAPP_100MHZ)"
	@echo "  make reconfig_TESTAPP_25MHZ      Load partial bitfile"
	@echo "    $(PARTIAL_BITFILE_TESTAPP_25MHZ)"
	@echo "  make reconfig_RISCV_VIRTIO        Load partial bitfile"
	@echo "    $(PARTIAL_BITFILE_RISCV_VIRTIO)"
	@echo "  NOTE: uses 'sudo'"

# ================================================================
# Partial-reconfig bitfiles

# Original garnet repo example
PARTIAL_BITFILE_GARNET_EXAMPLE ?= /home/nikhil/git_clones/CTSRD-CHERI_garnet/example/build/example_pblock_partition_partial.bit

# AWSteria_HW TestApp (running at 250 MHz)
PARTIAL_BITFILE_TESTAPP_250MHZ ?= ~/git_clones/CTSRD-CHERI_garnet/garnet_TestApp_HW_250MHz/build/AWSteria_pblock_partition_partial.bit

# AWSteria_HW TestApp (OLD: no reclocking, running at 250 MHz)
PARTIAL_BITFILE_TESTAPP_250MHZ ?= ~/git_clones/CTSRD-CHERI_garnet/example_TestApp/build/AWSteria_pblock_partition_partial.bit

# AWSteria_HW TestApp (with reclocking, running at 100 MHz)
PARTIAL_BITFILE_TESTAPP_100MHZ ?= ~/git_clones/CTSRD-CHERI_garnet/example_TestApp_reclocked_100MHz/build/AWSteria_pblock_partition_partial.bit

# AWSteria_HW TestApp (with reclocking, running at 25 MHz)
PARTIAL_BITFILE_TESTAPP_25MHZ ?= ~/git_clones/CTSRD-CHERI_garnet/example_TestApp_reclocked_25MHz/build/AWSteria_pblock_partition_partial.bit

# ================================================================
# Programming the bitfile and partial reconfig

BUS           = 0x07
DEVICE_NO     = 0x0
CAPABILITY_ID = 0x1

.PHONY: reconfig_Garnet_example
reconfig_Garnet_example:
	@echo "Reconfiguring partition with $(PARTIAL_BITFILE_GARNET_EXAMPLE)"
	sudo xvsecctl -b $(BUS) -F $(DEVICE_NO) -c $(CAPABILITY_ID) -p $(PARTIAL_BITFILE_GARNET_EXAMPLE)

.PHONY: reconfig_TESTAPP_250MHZ
reconfig_TESTAPP_250MHZ:
	@echo "Reconfiguring partition with $(PARTIAL_BITFILE_TESTAPP_250MHZ)"
	sudo xvsecctl -b $(BUS) -F $(DEVICE_NO) -c $(CAPABILITY_ID) -p $(PARTIAL_BITFILE_TESTAPP_250MHZ)

.PHONY: reconfig_TESTAPP_100MHZ
reconfig_TESTAPP_100MHZ:
	@echo "Reconfiguring partition with $(PARTIAL_BITFILE_TESTAPP_100MHZ)"
	sudo xvsecctl -b $(BUS) -F $(DEVICE_NO) -c $(CAPABILITY_ID) -p $(PARTIAL_BITFILE_TESTAPP_100MHZ)

.PHONY: reconfig_TESTAPP_25MHZ
reconfig_TESTAPP_25MHZ:
	@echo "Reconfiguring partition with $(PARTIAL_BITFILE_TESTAPP_25MHZ)"
	sudo xvsecctl -b $(BUS) -F $(DEVICE_NO) -c $(CAPABILITY_ID) -p $(PARTIAL_BITFILE_TESTAPP_25MHZ)

.PHONY: reconfig_RISCV_VIRTIO
reconfig_RISCV_VIRTIO:
	@echo "Reconfiguring partition with $(PARTIAL_BITFILE_RISCV_VIRTIO)"
	sudo xvsecctl -b $(BUS) -F $(DEVICE_NO) -c $(CAPABILITY_ID) -p $(PARTIAL_BITFILE_RISCV_VIRTIO)

# ================================================================
