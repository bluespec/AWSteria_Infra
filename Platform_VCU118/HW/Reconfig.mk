# These are commands for programming the full bitfile (once) and
# partial bitfiles (repeatedly, as design is iterated) on the VCU118
# FPGA.

# ================================================================

.PHONY: help
help:
	@echo "Usage:"
	@echo "    make load_shell    One-time load of Garnet 'shell' bitfile (PCIe and DDR support)"
	@echo "    make reconfig      Load of Garnet app partial bitfile"
	@echo "    make probe         probe PCIe for Xilinx boards"
	@echo "    make load_xvsec    Installing the Xilinx XVSEC driver"

# ================================================================
# Partial-reconfig bitfiles

# Original garnet repo example
# BITFILE ?= /home/nikhil/git_clones/CTSRD-CHERI_garnet/example/build/example_pblock_partition_partial.bit

# AWSteria_HW TestApp (no reclocking, running at 250 MHz)
# BITFILE ?= ~/git_clones/CTSRD-CHERI_garnet/example_TestApp/build/AWSteria_pblock_partition_partial.bit

# AWSteria_HW TestApp (with reclocking, running at 100 MHz)
BITFILE ?= ~/git_clones/CTSRD-CHERI_garnet/example_TestApp_reclocked/build/AWSteria_pblock_partition_partial.bit

# AWSteria_HW_RISCV_Virtio reclocked
# BITFILE=~/git_clones/CTSRD-CHERI_garnet/example_RISCV_AWSteria_HW_reclocked/build/AWSteria_pblock_partition_partial.bit

# ================================================================
# Programming the bitfile and partial reconfig

BUS           = 0x07
DEVICE_NO     = 0x0
CAPABILITY_ID = 0x1

.PHONY: reconfig
reconfig:
	@echo "Reconfiguring partition with $(BITFILE)"
	sudo xvsecctl -b $(BUS) -F $(DEVICE_NO) -c $(CAPABILITY_ID) -p $(BITFILE)

# ================================================================

GARNET_REPO = ~/git_clones/CTSRD-CHERI_garnet

.PHONY: load_shell
load_shell:
	~/bin/program_fpga  $(GARNET_REPO)/shell/prebuilt/empty.bit

# ================================================================
# PCIe probing and driver loading

.PHONY: probe
probe:
	sudo lspci -d 10ee:903f  $(V)

.PHONY: load_xvsec
load_xvsec:
	sudo modprobe xvsec

# ================================================================
