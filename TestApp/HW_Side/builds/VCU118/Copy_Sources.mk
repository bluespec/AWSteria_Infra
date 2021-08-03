ifndef BLUPONT_REPO
  $(error ERROR: please define BLUESPEC_HOME, i.e., path to Bluespec bsc installation)
endif

ifndef BLUESPEC_HOME
  $(error ERROR: please define BLUESPEC_HOME, i.e., path to Bluespec bsc installation)
endif

ifndef FLUTE_REPO
  $(error ERROR: please define FLUTE_REPO, i.e., path to Flute repository)
endif

RSYNC = rsync --times

.PHONY: rsync_srcs
rsync_srcs: all_srcs  Verilog_RTL  rsync_RTL
	@echo "INFO: Copying BSV sources"
	$(RSYNC)  ../../BluPont_HW_Side.bsv                                                   all_srcs/
	$(RSYNC)  $(BLUPONT_REPO)/APIs/*.bsv                                                  all_srcs/
	@echo "INFO: Copying additional BSV sources from $(FLUTE_REPO)"
	$(RSYNC)  $(FLUTE_REPO)/src_Testbench/Fabrics/AXI4/AXI4_Types.bsv                     all_srcs/
	$(RSYNC)  $(FLUTE_REPO)/src_Testbench/Fabrics/AXI4/AXI4_Fabric.bsv                    all_srcs/
	$(RSYNC)  $(FLUTE_REPO)/src_Testbench/Fabrics/AXI4_Lite/AXI4_Lite_Types.bsv           all_srcs/
	$(RSYNC)  $(FLUTE_REPO)/src_Testbench/Fabrics/Adapters/AXI4L_S_to_AXI4_M_Adapter.bsv  all_srcs/
	$(RSYNC)  $(FLUTE_REPO)/src_Core/BSV_Additional_Libs/Cur_Cycle.bsv                    all_srcs/
	$(RSYNC)  $(FLUTE_REPO)/src_Core/BSV_Additional_Libs/GetPut_Aux.bsv                   all_srcs/
	$(RSYNC)  $(FLUTE_REPO)/src_Core/BSV_Additional_Libs/Semi_FIFOF.bsv                   all_srcs/
	$(RSYNC)  $(FLUTE_REPO)/src_Core/BSV_Additional_Libs/EdgeFIFOFs.bsv                   all_srcs/


#	$(RSYNC)  ../../BluPont_HW_Side_Depth1.bsv                                            all_srcs/
#	$(RSYNC)  $(FLUTE_REPO)/src_Testbench/Fabrics/AXI4/AXI_SyncBuffer.bsv                 all_srcs/


# ================================================================
# These files are boilerplate, from the 'bsc' libraries, that are
# used by the BSV module hierarchy inside BluPont_HW_Side.bsv.
# Edit this section to use any additional library files your app needs.

.PHONY: rsync_RTL
rsync_RTL: Verilog_RTL
	@echo "INFO: Copying RTL from this project sources"
	$(RSYNC)  ../../reset_synchronizer.v               Verilog_RTL/

	@echo "INFO: Copying RTL from BLUESPEC_HOME = $(BLUESPEC_HOME)"
	cp -p  $(BLUESPEC_HOME)/lib/Verilog/FIFO2.v        Verilog_RTL/
	cp -p  $(BLUESPEC_HOME)/lib/Verilog/SizedFIFO.v    Verilog_RTL/

#	cp -p  $(BLUESPEC_HOME)/lib/Verilog/ClockDiv.v     Verilog_RTL/
#	cp -p  $(BLUESPEC_HOME)/lib/Verilog/SyncFIFO.v     Verilog_RTL/
#	cp -p  $(BLUESPEC_HOME)/lib/Verilog/SyncResetA.v   Verilog_RTL/

# ================================================================
