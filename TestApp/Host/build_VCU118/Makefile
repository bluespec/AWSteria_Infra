###  -*-Makefile-*-

# Copyright (c) 2020-2021 Bluespec, Inc.  All Rights Reserved

# ================================================================

.PHONY: help
help:
	@echo "Usage:"
	@echo "    make $(EXE)        create the host-side executable"
	@echo "    make clean         delete temporary files/dirs but keep the executable"
	@echo "    make full_clean    delete temporary files/dirs and delete the executable"

#================================================================

ifndef AWSTERIA_INFRA_REPO
  $(error ERROR: please define AWSTERIA_INFRA_REPO (path to AWSteria_Infra repo))
else
  $(info  INFO: AWSTERIA_INFRA_REPO = $(AWSTERIA_INFRA_REPO))
endif

$(info INFO: Making executable $(EXE) for AWSteria TestApp host side on VCU118)

# ================================================================
# Source files

# ----------------
# App host side

SRCS_C = $(AWSTERIA_INFRA_REPO)/TestApp/Host/main.c

# ----------------
# AWSteria infra

SRCS_H += $(AWSTERIA_INFRA_REPO)/Include_API/AWSteria_Host_lib.h
SRCS_H += $(AWSTERIA_INFRA_REPO)/Platform_VCU118/Host/AWSteria_Platform.h

SRCS_C += $(AWSTERIA_INFRA_REPO)/Platform_VCU118/Host/AWSteria_Host_lib.c

# ================================================================

CFLAGS += -std=gnu11 -g -Wall -Werror

CFLAGS += -D PLATFORM_VCU118

CFLAGS += -I $(AWSTERIA_INFRA_REPO)/Include_API
CFLAGS += -I $(AWSTERIA_INFRA_REPO)/Platform_VCU118/Host

CC     = gcc $(CFLAGS)

EXE    = exe_Host_VCU118

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
