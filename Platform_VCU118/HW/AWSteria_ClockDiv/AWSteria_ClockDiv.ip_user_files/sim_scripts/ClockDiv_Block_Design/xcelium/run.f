-makelib xcelium_lib/xil_defaultlib -sv \
  "/tools/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "/tools/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/ClockDiv_Block_Design/ip/ClockDiv_Block_Design_clk_wiz_0_0/ClockDiv_Block_Design_clk_wiz_0_0_clk_wiz.v" \
  "../../../bd/ClockDiv_Block_Design/ip/ClockDiv_Block_Design_clk_wiz_0_0/ClockDiv_Block_Design_clk_wiz_0_0.v" \
  "../../../bd/ClockDiv_Block_Design/sim/ClockDiv_Block_Design.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

