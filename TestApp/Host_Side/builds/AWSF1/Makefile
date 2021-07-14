###  -*-Makefile-*-

# Copyright (c) 2020-2021 Bluespec, Inc.  All Rights Reserved

# ================================================================

ifndef BLUPONT_REPO
  $(error ERROR: please define BLUPONT_REPO)
endif

ifndef SDK_DIR
  $(error ERROR: please define SDK_DIR (path to aws-fpga repo))
endif

EXE = exe_Host_Side_AWSF1

.PHONY: help
help:
	@echo "Usage:"
	@echo "    make exe           create the host-side executable '$(EXE)'"
	@echo "    make clean         keep excutable; delete temporary build dir 'tmpdir'"
	@echo "    make full_clean    delete excutable and temporary build dir 'tmpdir'"

# ================================================================
# Create 'tmpdir' for local copy of all relevant source files and all
# intermediate object files.  Copy all sources.

include Copy_Sources.mk

# ================================================================

INCLUDES = -I$(SDK_DIR)/userspace/include

CFLAGS += -D IN_AWSF1
CFLAGS += -I tmpdir  $(INCLUDES)
CFLAGS += -std=gnu11 -g -Wall -Werror

OBJS   += tmpdir/main.o
OBJS   += tmpdir/BluPont_Host_Side_API.o

LDLIBS = -lfpga_mgmt -lcrypto -lpthread

CC     = gcc

# ================================================================
# Top-level command to build EXE

.PHONY: exe
exe: rsync_tmpdir  $(OBJS)
	$(CC) -g  -o $(EXE) $(OBJS) $(LDLIBS)
	@echo "INFO: created '$(EXE)'"

# ================================================================

.PHONY: clean
clean:
	rm -r -f  *.*~  Makefile*~  tmpdir

.PHONY: full_clean
full_clean:
	rm -r -f  *.*~  Makefile*~  tmpdir  exe_*

# ================================================================
