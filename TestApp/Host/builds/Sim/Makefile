###  -*-Makefile-*-

# Copyright (c) 2020-2021 Bluespec, Inc.  All Rights Reserved

# ================================================================

ifndef BLUPONT_REPO
  $(error ERROR: please define BLUPONT_REPO)
endif

EXE = exe_Host_Side_Sim

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

CFLAGS += -DIN_SIMULATION
CFLAGS += -I tmpdir
CFLAGS += -std=gnu11 -g -Wall -Werror

OBJS   += tmpdir/main.o
OBJS   += tmpdir/BluPont_Host_Side_API.o  tmpdir/Bytevec.o  tmpdir/TCP_Client_Lib.o

LDLIBS = -lpthread

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
