###  -*-Makefile-*-

# Copyright (c) 2020-2021 Bluespec, Inc.  All Rights Reserved

#================================================================

ifndef AWSTERIA_INFRA_REPO
  $(error ERROR: please define AWSTERIA_INFRA_REPO (path to AWSteria_Infra repo))
else
  $(info  INFO: AWSTERIA_INFRA_REPO = $(AWSTERIA_INFO_REPO))
endif

$(info INFO: Making executable for AWSteria TestApp host side on VCU118)

EXE    = exe_host_side_VCU118

# ================================================================

CFLAGS += -std=gnu11 -g -Wall -Werror \
	-I $(AWSTERIA_INFRA_REPO)/Include_API

CC     = gcc $(CFLAGS)

SRCS_H = \
	$(AWSTERIA_INFRA_REPO)/Include_API/AWSteria_Host_lib.h \

SRCS_C = ../main.c \
	$(AWSTERIA_INFRA_REPO)/Platform_VCU118/Host/AWSteria_Host_lib.c \

# ================================================================
# Top-level target: the executable

$(EXE): $(SRCS_H) $(SRCS_C)
	$(CC) -g  -o $(EXE) $(SRCS_C)

# ================================================================

.PHONY: clean
clean:
	rm -f  *.*~  Makefile*~  *.o

.PHONY: full_clean
full_clean:
	rm -f  *.*~  Makefile*~  *.o  exe_*

# ================================================================
