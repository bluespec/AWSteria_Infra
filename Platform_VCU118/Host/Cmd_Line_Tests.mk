# This is not really a Makefile to build anything, but just a
# packaging of various tests of the AWSteria_Infra TestApp HW side
# using Xilinx XDMA command-line tools on the host side.

# It assumes you have build the tools in:
#    https://github.com/Xilinx/dma_ip_drivers.git
#        XDMA/linux-kernel/tools
# and the Xilinx partial-reconfig driver in:
#        XVSEC/

# Some of these tests require a dataA.txt or dataB.txt as input data
# to be written to the FPGA.  Any files will do, or you can generate
# bogus files using gen_test_data.c.  The files should be larger than
# the amount of data you write/read to the FPGA.

DMA_IP_DRIVERS_TOOLS = ~/git_clones/Xilinx/dma_ip_drivers/XDMA/linux-kernel/tools
GARNET_REPO = ~/git_clones/CTSRD-CHERI_garnet

BASE   ?= 0
SIZE   ?= 64
DATA_A ?= dataA.txt
DATA_B ?= dataB.txt
RDATA  ?= rdata.txt
WDATA  ?= wdata.txt

# ================================================================
# Partial-reconfig bitfiles

# Original garnet repo example
# BITFILE ?= /home/nikhil/git_clones/CTSRD-CHERI_garnet/example/build/example_pblock_partition_partial.bit

# AWSteria_HW (no reclocking) with TestApp
# BITFILE ?= ~/git_clones/CTSRD-CHERI_garnet/example_AWSteria_HW/build/AWSteria_pblock_partition_partial.bit

# AWSteria_HW_reclocked (reclocked) with TestApp
# BITFILE ?= ~/git_clones/CTSRD-CHERI_garnet/example_AWSteria_HW_reclocked/build/AWSteria_pblock_partition_partial.bit

# AWSteria RISCV reclocked
BITFILE=~/git_clones/CTSRD-CHERI_garnet/example_RISCV_AWSteria_HW_reclocked/build/AWSteria_pblock_partition_partial.bit

# ================================================================

.PHONY: help
help:
	@echo "Usage:"
	@echo "    make dmaw         Does an AXI4 (DMA) write test"
	@echo "    make dmar         Does an AXI4 (DMA) read  test"
	@echo "    make peek_poke    Does an AXI4 Lite (OCL) read and write  test"
	@echo "    make reconfig     Partial reconfig"
	@echo "    make load_xvsec   Installs XVSEC kernel driver"
	@echo "    make load_shell   Writes bitfile for shell, with empty example module"
	@echo "  Current settings"
	@echo "    BITFILE  = $(BITFILE)"
	@echo "    BASE     = $(BASE)"
	@echo "    SIZE     = $(SIZE)"
	@echo "    DATA_A   = $(DATA_A)"
	@echo "    LOGFILE  = $(WDATA)"
	@echo "    DATAFROM = $(RDATA)"

# ================================================================
# Checking the VCU118 card

.PHONY: probe
probe:
	sudo lspci -d 10ee:903f  $(V)

# ================================================================
# Programming the bitfile and partial reconfig

BUS           = 0x07
DEVICE_NO     = 0x0
CAPABILITY_ID = 0x1

.PHONY: reconfig
reconfig:
	@echo "Reconfiguring partition with $(BITFILE)"
	sudo xvsecctl -b $(BUS) -F $(DEVICE_NO) -c $(CAPABILITY_ID) -p $(BITFILE)

.PHONY: load_xvsec
load_xvsec:
	sudo modprobe xvsec

.PHONY: load_shell
load_shell:
	~/bin/program_fpga  $(GARNET_REPO)/shell/prebuilt/empty.bit

# ================================================================
# Exercising the AXI4 port (DMA_PCIS)

.PHONY: dmaw
dmaw:
	sudo $(DMA_IP_DRIVERS_TOOLS)/dma_to_device \
	    -a $(BASE) -s $(SIZE) -f $(DATA_A)  -w $(WDATA)
	ls -als $(WDATA)

.PHONY: dmar
dmar:
	sudo $(DMA_IP_DRIVERS_TOOLS)/dma_from_device -a $(BASE) -s $(SIZE) -f $(RDATA)
	ls -als $(WDATA) $(RDATA)
	diff -s $(WDATA) $(RDATA)

.PHONY: dma_A_lo
dma_A_lo:
	sudo $(DMA_IP_DRIVERS_TOOLS)/dma_to_device   -a 0x0 -s 0x40 -f $(DATA_A)  -w $(WDATA)
	sudo $(DMA_IP_DRIVERS_TOOLS)/dma_from_device -a 0x0 -s 0x40 -f $(RDATA)
	ls -als $(WDATA) $(RDATA)
	diff -s $(WDATA) $(RDATA)

.PHONY: dma_A_hi
dma_A_hi:
	sudo $(DMA_IP_DRIVERS_TOOLS)/dma_to_device   -a 0x7FFFFFC0 -s 0x40 -f $(DATA_A) -w $(WDATA)
	sudo $(DMA_IP_DRIVERS_TOOLS)/dma_from_device -a 0x7FFFFFC0 -s 0x40 -f $(RDATA)
	ls -als $(WDATA) $(RDATA)
	diff -s $(WDATA) $(RDATA)

.PHONY: dma_A_out
dma_A_out:
	sudo $(DMA_IP_DRIVERS_TOOLS)/dma_to_device   -a 0x3FFFFFFC0 -s 0x40 -f $(DATA_A) -w $(WDATA)
	sudo $(DMA_IP_DRIVERS_TOOLS)/dma_from_device -a 0x3FFFFFFC0 -s 0x40 -f $(RDATA)
	ls -als $(WDATA) $(RDATA)
	diff -s $(WDATA) $(RDATA)

.PHONY: dma_B_lo
dma_B_lo:
	sudo $(DMA_IP_DRIVERS_TOOLS)/dma_to_device   -a 0x400000000 -s 0x40 -f $(DATA_B)  -w $(WDATA)
	sudo $(DMA_IP_DRIVERS_TOOLS)/dma_from_device -a 0x400000000 -s 0x40 -f $(RDATA)
	ls -als $(WDATA) $(RDATA)
	diff -s $(WDATA) $(RDATA)

.PHONY: dma_B_hi
dma_B_hi:
	sudo $(DMA_IP_DRIVERS_TOOLS)/dma_to_device   -a 0x47FFFFFC0 -s 0x40 -f $(DATA_B) -w $(WDATA)
	sudo $(DMA_IP_DRIVERS_TOOLS)/dma_from_device -a 0x47FFFFFC0 -s 0x40 -f $(RDATA)
	ls -als $(WDATA) $(RDATA)
	diff -s $(WDATA) $(RDATA)

.PHONY: dma_B_out
dma_B_out:
	sudo $(DMA_IP_DRIVERS_TOOLS)/dma_to_device   -a 0x7FFFFFFC0 -s 0x40 -f $(DATA_B) -w $(WDATA)
	sudo $(DMA_IP_DRIVERS_TOOLS)/dma_from_device -a 0x7FFFFFFC0 -s 0x40 -f $(RDATA)
	ls -als $(WDATA) $(RDATA)
	diff -s $(WDATA) $(RDATA)

# ================================================================
# Exercising the AXI4-Lite port (OCL)
# We use '-sudo' below because reg_rw returns the value read,
# which is interpreted as an error when non-zero.

.PHONY: peek_poke
peek_poke:
	-sudo $(DMA_IP_DRIVERS_TOOLS)/reg_rw /dev/xdma0_user 8 w
	@echo "---------------- See ack count above"
	-sudo $(DMA_IP_DRIVERS_TOOLS)/reg_rw /dev/xdma0_user 8 w 0
	-sudo $(DMA_IP_DRIVERS_TOOLS)/reg_rw /dev/xdma0_user 8 w 1
	-sudo $(DMA_IP_DRIVERS_TOOLS)/reg_rw /dev/xdma0_user 8 w
	@echo "---------------- See ack count above"
	-sudo $(DMA_IP_DRIVERS_TOOLS)/reg_rw /dev/xdma0_user 8 w 0
	-sudo $(DMA_IP_DRIVERS_TOOLS)/reg_rw /dev/xdma0_user 8 w 1
	-sudo $(DMA_IP_DRIVERS_TOOLS)/reg_rw /dev/xdma0_user 8 w
	@echo "---------------- See ack count above"

.PHONY: peek_poke2
peek_poke2:
	@echo "---------------- Writing 0 in first 4 words"
	-sudo $(DMA_IP_DRIVERS_TOOLS)/reg_rw /dev/xdma0_user 0x0 w 0
	-sudo $(DMA_IP_DRIVERS_TOOLS)/reg_rw /dev/xdma0_user 0x4 w 0
	-sudo $(DMA_IP_DRIVERS_TOOLS)/reg_rw /dev/xdma0_user 0x8 w 0
	-sudo $(DMA_IP_DRIVERS_TOOLS)/reg_rw /dev/xdma0_user 0xC w 0
	@echo "---------------- Readback first 4 words"
	-sudo $(DMA_IP_DRIVERS_TOOLS)/reg_rw /dev/xdma0_user 0x0 w
	-sudo $(DMA_IP_DRIVERS_TOOLS)/reg_rw /dev/xdma0_user 0x4 w
	-sudo $(DMA_IP_DRIVERS_TOOLS)/reg_rw /dev/xdma0_user 0x8 w
	-sudo $(DMA_IP_DRIVERS_TOOLS)/reg_rw /dev/xdma0_user 0xC w
	@echo "---------------- Writing data in first 4 words"
	-sudo $(DMA_IP_DRIVERS_TOOLS)/reg_rw /dev/xdma0_user 0x0 w 0xdead
	-sudo $(DMA_IP_DRIVERS_TOOLS)/reg_rw /dev/xdma0_user 0x4 w 0xbeef
	-sudo $(DMA_IP_DRIVERS_TOOLS)/reg_rw /dev/xdma0_user 0x8 w 0xface
	-sudo $(DMA_IP_DRIVERS_TOOLS)/reg_rw /dev/xdma0_user 0xC w 0xcede
	@echo "---------------- Readback first 4 words"
	-sudo $(DMA_IP_DRIVERS_TOOLS)/reg_rw /dev/xdma0_user 0x0 w
	-sudo $(DMA_IP_DRIVERS_TOOLS)/reg_rw /dev/xdma0_user 0x4 w
	-sudo $(DMA_IP_DRIVERS_TOOLS)/reg_rw /dev/xdma0_user 0x8 w
	-sudo $(DMA_IP_DRIVERS_TOOLS)/reg_rw /dev/xdma0_user 0xC w

# ================================================================

.PHONY: clean
clean:
	rm -r -f  *~

.PHONY: full_clean
full_clean:
	rm -r -f  *~  $(WDATA)  $(RDATA)

# ================================================================
