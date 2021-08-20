###  -*-Makefile-*-

# Copyright (c) 2020-2021 Bluespec, Inc.  All Rights Reserved

# ================================================================

.PHONY: help
help:
	@echo "Usage:"
	@echo "    make $(EXE)        create the host-side executable"
	@echo "    make clean         keep excutable; delete temporary build dir 'tmpdir'"
	@echo "    make full_clean    delete excutable and temporary build dir 'tmpdir'"

#================================================================

ifndef AWSTERIA_INFRA_REPO
  $(error ERROR: please define AWSTERIA_INFRA_REPO (path to AWSteria_Infra repo))
else
  $(info  INFO: AWSTERIA_INFRA_REPO = $(AWSTERIA_INFO_REPO))
endif

EXE = exe_Host_VCU118

$(info INFO: Making executable $(EXE) for AWSteria TestApp host side on VCU118)

# ================================================================

CFLAGS += -I $(AWSTERIA_INFRA_REPO)/Include_API
CFLAGS += -std=gnu11 -g -Wall -Werror

CC     = gcc $(CFLAGS)

SRCS_H = \
	$(AWSTERIA_INFRA_REPO)/Include_API/AWSteria_Host_lib.h \

SRCS_C = ../main.c \
	$(AWSTERIA_INFRA_REPO)/Platform_VCU118/Host/AWSteria_Host_lib.c \

# ================================================================
# Top-level target: the executable

$(EXE): $(SRCS_H) $(SRCS_C)
	$(CC) -g  -o $(EXE) $(SRCS_C)
	@echo "INFO: created '$(EXE)'"

# ================================================================

.PHONY: clean
clean:
	rm -f  *.*~  Makefile*~  *.o

.PHONY: full_clean
full_clean:
	rm -f  *.*~  Makefile*~  *.o  exe_*

# ================================================================
