
# This is a hack because I don't want to deal with writing makefiles
# for AWSteria.  With a little help from sed, the makefiles for
# TestApp are reused.

NAME=$(notdir $(CURDIR))

default:
-include config.mk

# board is one of: vcu118 awsf1
#
# simulator is unset for fpga or one of: bluesim verilator
#
# Valid combinations of board and simulator are determined by the
# presence of a gen_recipe_$(SIMULATOR)_$(BOARD) variable, defined
# below, which generates the recipes for that configuration.
BOARD?=vcu118
SIMULATOR?=

AWSTERIA_INFRA_REPO ?= $(realpath $(CURDIR)/..)
FLUTE_REPO ?= $(realpath ../..)/Flute
BLUESPEC_HOME ?= $(realpath ../..)/bsc/inst
AMBA_FABRICS ?= $(realpath ../..)/AMBA_Fabrics
BSV_ADDITIONAL_LIBS ?= $(realpath ../..)/BSV_Additional_Libs
BSC_LIBS ?= $(BLUESPEC_HOME)/lib/Verilog
GARNET_DIR ?= $(realpath ../..)/garnet
AWS_FPGA_REPO_DIR ?= $(realpath ../../aws-fpga)

export AWSTERIA_INFRA_REPO FLUTE_REPO BLUESPEC_HOME AMBA_FABRICS BSV_ADDITIONAL_LIBS BSC_LIBS

# Derp.  This is because the example makefiles are insistent that they
# be provided BLUESPEC_HOME, but apparently not clever enough to use
# that to find the bsc executable.
export PATH:=$(PATH):$(BLUESPEC_HOME)/bin

define gen_recipes__awsf1 =
export CL_DIR=$$(realpath .)/cl_AWSteria_irqtest
default: synth
synth: awsf1.mk
	$$(MAKE) -f $$^ compile
	$$(MAKE) -f $$^ for_AWSF1_HDK
	sed -i -e 's,^encrypt,#encrypt,' $$(CL_DIR)/build/scripts/encrypt.tcl
	sed -i -e 's,write_checkpoint -encrypt,write_checkpoint,' $$(CL_DIR)/build/scripts/create_dcp_from_cl.tcl
	cp $(BLUESPEC_HOME)/lib/Verilog/FIFO10.v $$(CL_DIR)/design/
	cd $$(CL_DIR)/build/scripts && aws-hdk ./aws_build_dcp_from_cl.sh -foreground
clean: clean_awsf1
clean_awsf1:
	$(RM) -r $$(CL_DIR)
.PHONY: clean_awsf1
endef

define gen_recipes__vcu118 =
default: synth
synth: vcu118.mk
	$$(MAKE) -f $$^ compile
	$$(MAKE) -f $$^ for_garnet
	sed -i -e 's,set garnet_dir "$$$$project_dir/..",set garnet_dir "$(GARNET_DIR)",' garnet_$(NAME)_HW_250MHz/tcl/build.tcl
	cp $(BLUESPEC_HOME)/lib/Verilog/FIFO10.v garnet_$(NAME)_HW_250MHz/src/
	$(MAKE) -C garnet_$(NAME)_HW_250MHz
	ln -sf garnet_$(NAME)_HW_250MHz/build/AWSteria_pblock_partition_partial.bit $(NAME)_pblock_partition_partial.bit
clean: clean_vcu118
clean_vcu118:
	$(RM) $(NAME)_pblock_partition_partial.bit
.PHONY: clean_vcu118
endef

define gen_recipes_bluesim_awsf1 =
default: sim
sim: bluesim.mk
	$$(MAKE) -f $$^ TARGET=PLATFORM_AWSF1 compile
	$$(MAKE) -f $$^ TARGET=PLATFORM_AWSF1 simulator
	ln -sf exe_HW_sim sim
endef

define gen_recipes_bluesim_vcu118 =
default: sim
sim: bluesim.mk
	$$(MAKE) -f $$^ TARGET=PLATFORM_VCU118 compile
	$$(MAKE) -f $$^ TARGET=PLATFORM_VCU118 simulator
	ln -sf exe_HW_sim sim
endef

define gen_recipes_verilator_awsf1 =
default: sim
sim: verilator.mk
	$$(MAKE) -f $$^ TARGET=PLATFORM_AWSF1 generate_verilog
	$$(MAKE) -f $$^ TARGET=PLATFORM_AWSF1 simulator
	ln -sf exe_HW_AWSF1_sim sim
endef

define gen_recipes_verilator_vcu118 =
default: sim
sim: verilator.mk
	$$(MAKE) -f $$^ TARGET=PLATFORM_VCU118 generate_verilog
	$$(MAKE) -f $$^ TARGET=PLATFORM_VCU118 simulator
	ln -sf exe_HW_VCU118_sim sim
endef

awsf1.mk: ../TestApp/HW/build_AWSF1/Makefile
	sed -e 's,TestApp/HW,$(NAME),g;s,TestApp,$(NAME),g;/# BSC_PATH for/a BSC_PATH := $$(BSC_PATH):$$(AWSTERIA_INFRA_REPO)/HW' $^ > $@

vcu118.mk: ../TestApp/HW/build_VCU118/Makefile
	sed -e 's,TestApp/HW,$(NAME),g;s,TestApp,$(NAME),g;/# BSC_PATH for/a BSC_PATH := $$(BSC_PATH):$$(AWSTERIA_INFRA_REPO)/HW' $^ > $@

bluesim.mk: ../TestApp/HW/build_Bluesim/Makefile
	sed -e 's,TestApp/HW,$(NAME),g;s,TestApp,$(NAME),g;/# BSC_PATH for/a BSC_PATH := $$(BSC_PATH):$$(AWSTERIA_INFRA_REPO)/HW' -e 's,C_Imported_Functions.c,& $$(AWSTERIA_INFRA_REPO)/Platform_Sim/HW/sim_socket.c,' $^ > $@

verilator.mk: ../TestApp/HW/build_Verilator/Makefile
	sed -e 's,TestApp/HW,$(NAME),g;s,TestApp,$(NAME),g;/# BSC_PATH for/a BSC_PATH := $$(BSC_PATH):$$(AWSTERIA_INFRA_REPO)/HW' -e 's,C_Imported_Functions.c,& $$(AWSTERIA_INFRA_REPO)/Platform_Sim/HW/sim_socket.c,' $^ > $@

ifndef gen_recipes_$(SIMULATOR)_$(BOARD)
$(error Unsupported simulator ($(SIMULATOR)) and board ($(BOARD)) combination)
else
$(eval $(call gen_recipes_$(SIMULATOR)_$(BOARD)))
endif

CFLAGS+=-O2 -g -Wall
CFLAGS+=-I../Include_API
CFLAGS+=-I../libawsteria
LDLIBS+=-lbsd

ifneq ($(wildcard $(AWS_FPGA_REPO_DIR)),)
# Really amazon?  The AWS SDK unconditionally installs the library in
# /usr/local/lib, but not the corresponding headers.
CFLAGS+=-I$(AWS_FPGA_REPO_DIR)/sdk/userspace/include
LDLIBS+=-lfpga_mgmt
loadafi=loadafi.o
else
$(warning Excluding support for AFI loading)
CFLAGS+=-DEXCLUDE_LOADAFI
endif

VPATH=../libawsteria:../Platform_Sim/Host

default: software
software: $(NAME)

obj=$(NAME).o libawsteria.o libawsteria_compat.o Bytevec.o TCP_Client_Lib.o $(loadafi)
$(NAME): $(obj)

clean:
	-$(MAKE) -f awsf1.mk full_clean
	-$(MAKE) -f vcu118.mk full_clean
	-$(MAKE) -f bluesim.mk full_clean
	-$(MAKE) -f verilator.mk full_clean
	$(RM) awsf1.mk vcu118.mk bluesim.mk verilator.mk
	$(RM) $(NAME) sim
	$(RM) $(obj)

.PHONY: default software synth sim clean
