###  -*-Makefile-*-

# Copyright (c) 2020-2021 Bluespec, Inc.  All Rights Reserved

# This is not a standalone Makefile, but 'include'd by other Makefiles
# for building host-side executable (x86-64 Linux) for BluPont
# for various platforms (Bluesim, Verilator Sim, AWS F1, VCU 118, ...)

# ================================================================

CFLAGS += -std=gnu11 -g -Wall -Werror
OBJS   += HS_main.o

CC     = gcc $(CFLAGS)

SRC = $(BLUPONT_REPO)/src_Host_Side

SIM_LIB_DIR = $(BLUPONT_REPO)/Platform_Sim/Host_Side

# ================================================================
# Top-level command to build EXE

$(EXE): $(OBJS)
	$(CC) -g  -o $(EXE) \
	$(OBJS) \
	$(LDLIBS)

# ================================================================

HS_MAIN_SRCS_H = $(SIM_LIB_DIR)/AWS_Sim_Lib.h  $(SIM_LIB_DIR)/AWS_Sim_Lib_protos.h

HS_main.o: $(SRC)/HS_main.c  $(HS_MAIN_SRCS_H)
	$(CC) -c  -I $(SRC)  -I $(SIM_LIB_DIR) -DSV_TEST  $(SRC)/HS_main.c

# ================================================================
# Simulation library, to simulate the AWSteria FPGA communication infrastructure

AWS_Sim_Lib.o:  $(SIM_LIB_DIR)/AWS_Sim_Lib.h  $(SIM_LIB_DIR)/AWS_Sim_Lib_protos.h  $(SIM_LIB_DIR)/AWS_Sim_Lib.c
	$(CC) -c  $(SIM_LIB_DIR)/AWS_Sim_Lib.c

AWS_Sim_Lib_protos.h: $(SIM_LIB_DIR)/AWS_Sim_Lib.c
	$(C_PROTO_EXTRACT)  $(SIM_LIB_DIR)/AWS_Sim_Lib.c

# ================================================================

Bytevec.o: $(SIM_LIB_DIR)/Bytevec.h  $(SIM_LIB_DIR)/Bytevec.c
	$(CC) -c  $(SIM_LIB_DIR)/Bytevec.c

# ================================================================

TCP_Client_Lib.o:  $(SIM_LIB_DIR)/TCP_Client_Lib.h  $(SIM_LIB_DIR)/TCP_Client_Lib_protos.h  $(SIM_LIB_DIR)/TCP_Client_Lib.c
	$(CC) -c  $(SIM_LIB_DIR)/TCP_Client_Lib.c

$(SIM_LIB_DIR)/TCP_Client_Lib_protos.h: $(SIM_LIB_DIR)/TCP_Client_Lib.c
	$(C_PROTO_EXTRACT)  $(SIM_LIB_DIR)/TCP_Client_Lib.c

# ================================================================

.PHONY: clean
clean:
	rm -f  *.*~  Makefile*~  *.o

.PHONY: full_clean
full_clean:
	rm -f  *.*~  Makefile*~  *.o  exe_*

# ================================================================
