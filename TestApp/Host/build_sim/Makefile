###  -*-Makefile-*-

# Copyright (c) 2020-2023 Bluespec, Inc.  All Rights Reserved

# Makefile to create Host-side executable
# for AWSteria_Infra's TestApp
# where HW-side is Bluesim or Verilator simulation for VCU118 or AWS F1.

# ================================================================
.PHONY: help
help:  show_resource_paths
	@echo "Available targets for 'make':"
	@echo "  $(HOST_EXE_FILE)        create the host-side executable"
	@echo ""
	@echo "  clean         delete temporary files/dirs but keep the executable"
	@echo "  full_clean    delete temporary files/dirs and delete the executable"
	@echo ""
	@echo "TARGET = $(TARGET)     (can be PLATFORM_VCU118 or PLATFORM_AWSF1)"
	@echo "Host-side executable: $(HOST_EXE_FILE)"
	@echo "Current CFLAGS (C compiler flags):"
	@echo "  $(CFLAGS)"
	@echo "Current CPATH (C compiler path):"
	@echo "  $(CPATH)"

# ================================================================
# Defs of resources etc.

$(info INFO: use 'make help' to show current settings.)
$(info INFO: Including Makefile_Params.mk which should define paths to external resources.)

include Makefile_Params.mk

# Default target platform
TARGET ?= PLATFORM_AWSF1

#================================================================
# Target-specific defs

ifeq ($(TARGET),PLATFORM_VCU118)

  SRCS_H += $(AWSTERIA_INFRA_REPO)/Platform_VCU118/Host/AWSteria_Platform.h

  CPATH += -I $(AWSTERIA_INFRA_REPO)/Platform_VCU118/Host

  HOST_EXE_FILE ?= exe_Host_VCU118

else ifeq ($(TARGET),PLATFORM_AWSF1)

  SRCS_H += $(AWSTERIA_INFRA_REPO)/Platform_AWSF1/Host/AWSteria_Platform.h

  CPATH += -I $(AWSTERIA_INFRA_REPO)/Platform_AWSF1/Host

  HOST_EXE_FILE ?= exe_Host_AWSF1

else
  $(error ERROR: please define TARGET=PLATFORM_VCU118 or TARGET=PLATFORM_AWSF1 for proper DDR setup)
endif

# ================================================================
# Source files

# ----------------
# App host side

SRCS_C = $(AWSTERIA_INFRA_REPO)/TestApp/Host/main.c

# ----------------
# AWSteria infra

SRCS_H += \
	$(AWSTERIA_INFRA_REPO)/Include_API/AWSteria_Host_lib.h \
	$(AWSTERIA_INFRA_REPO)/Platform_Sim/Host/Bytevec.h \
	$(AWSTERIA_INFRA_REPO)/Platform_Sim/Host/TCP_Client_Lib.h

SRCS_C += \
	$(AWSTERIA_INFRA_REPO)/Platform_Sim/Host/AWSteria_Host_lib.c \
	$(AWSTERIA_INFRA_REPO)/Platform_Sim/Host/Bytevec.c \
	$(AWSTERIA_INFRA_REPO)/Platform_Sim/Host/TCP_Client_Lib.c

# ================================================================
# C compilation

CFLAGS += -D $(TARGET)
CFLAGS += -std=gnu11 -g -Wall -Werror

CPATH  += -I $(AWSTERIA_INFRA_REPO)/Include_API
CPATH  += -I $(AWSTERIA_INFRA_REPO)/Platform_Sim/Host

CC     = gcc $(CFLAGS)

EXE    = exe_Host_sim

# ================================================================
# Top-level target: the executable

$(HOST_EXE_FILE): $(SRCS_H) $(SRCS_C)
	$(CC) -o $(HOST_EXE_FILE) $(CFLAGS) $(CPATH) $(SRCS_C)
	@echo "INFO: Created host-side executable $(HOST_EXE_FILE)"

# ================================================================

.PHONY: clean
clean:
	rm -f  *.*~  Makefile*~  *.o

.PHONY: full_clean
full_clean:
	rm -f  *.*~  Makefile*~  *.o  exe_Host_*

# ================================================================
