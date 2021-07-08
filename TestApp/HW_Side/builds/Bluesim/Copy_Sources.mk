ifndef FLUTE_REPO
  $(error ERROR: please define FLUTE_REPO)
endif

RSYNC = rsync --times
.PHONY: rsync_srcs
rsync_srcs: all_srcs
	$(RSYNC)  ../../BluPont_HW_Side.bsv                                                   all_srcs/
	$(RSYNC)  $(BLUPONT_REPO)/APIs/*.bsv                                                  all_srcs/
	$(RSYNC)  $(BLUPONT_REPO)/Platform_Sim/HW_Side/*.bsv                                  all_srcs/
	$(RSYNC)  $(BLUPONT_REPO)/Platform_Sim/HW_Side/*.h                                    all_srcs/
	$(RSYNC)  $(BLUPONT_REPO)/Platform_Sim/HW_Side/*.c                                    all_srcs/
	$(RSYNC)  $(FLUTE_REPO)/src_Testbench/Fabrics/AXI4/AXI4_Types.bsv                     all_srcs/
	$(RSYNC)  $(FLUTE_REPO)/src_Testbench/Fabrics/AXI4/AXI4_Fabric.bsv                    all_srcs/
	$(RSYNC)  $(FLUTE_REPO)/src_Testbench/Fabrics/AXI4/AXI4_Deburster.bsv                 all_srcs/
	$(RSYNC)  $(FLUTE_REPO)/src_Testbench/Fabrics/AXI4_Lite/AXI4_Lite_Types.bsv           all_srcs/
	$(RSYNC)  $(FLUTE_REPO)/src_Testbench/Fabrics/Adapters/AXI4L_S_to_AXI4_M_Adapter.bsv  all_srcs/
	$(RSYNC)  $(FLUTE_REPO)/src_Core/BSV_Additional_Libs/Cur_Cycle.bsv                    all_srcs/
	$(RSYNC)  $(FLUTE_REPO)/src_Core/BSV_Additional_Libs/GetPut_Aux.bsv                   all_srcs/
	$(RSYNC)  $(FLUTE_REPO)/src_Core/BSV_Additional_Libs/Semi_FIFOF.bsv                   all_srcs/
	$(RSYNC)  $(FLUTE_REPO)/src_Core/BSV_Additional_Libs/EdgeFIFOFs.bsv                   all_srcs/
