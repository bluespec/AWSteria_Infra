# Copyright (c) 2021 Bluespec, Inc.  All Rights Reserved.

# ================================================================

HELP_TEXT = \
"Usage:\n" \
"  make load_shell        One-time load of Garnet 'shell' bitfile\n" \
"    GARNET_SHELL_BITFILE = $(GARNET_SHELL_BITFILE)\n" \
"    Override this with your Garnet shell bitfile location, if necessary."

GARNET_SHELL_BITFILE ?= ~/git_clones/CTSRD-CHERI_garnet/shell/prebuilt/empty.bit

# ================================================================

.PHONY: help
help:
	@echo $(HELP_TEXT)

.PHONY: load_shell
load_shell:
	@echo "INFO: Loading garnet shell (fixed PCIe and DDR infrastructure)"
	./program_fpga  $(GARNET_SHELL_BITFILE)

# ================================================================
