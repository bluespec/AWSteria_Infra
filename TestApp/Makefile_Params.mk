# This file is included by other Makefiles, and defines paths to
# various external resources.  These defs can be overridden with
# environment variables or with command-line args to 'make'.

# Defaults
AWSTERIA_INFRA_REPO ?= $(HOME)/Git/BlueCloudV_Infra
AMBA_FABRICS        ?= $(HOME)/Git/AMBA_Fabrics
BSV_ADDITIONAL_LIBS ?= $(HOME)/Git/BSV_Additional_Libs
BSC_LIBS            ?= $(BLUESPEC_HOME)/lib/Verilog

.PHONY: show_resource_paths
show_resource_paths:
	@echo ""
	@echo "Makefile params:"
	@echo "  AWSTERIA_INFRA_REPO = $(AWSTERIA_INFRA_REPO)"
	@echo "  AMBA_FABRICS        = $(AMBA_FABRICS)"
	@echo "  BSV_ADDITIONAL_LIBS = $(BSV_ADDITIONAL_LIBS)"
	@echo "  BSC_LIBS            = $(BSC_LIBS)"
