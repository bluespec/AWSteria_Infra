vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib
vlib questa_lib/msim/xpm

vmap xil_defaultlib questa_lib/msim/xil_defaultlib
vmap xpm questa_lib/msim/xpm

vlog -work xil_defaultlib -64 -sv "+incdir+../../../../AWSteria_ClockDiv.srcs/sources_1/bd/ClockDiv_Block_Design/ipshared/c923" \
"/tools/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm -64 -93 \
"/tools/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib -64 "+incdir+../../../../AWSteria_ClockDiv.srcs/sources_1/bd/ClockDiv_Block_Design/ipshared/c923" \
"../../../bd/ClockDiv_Block_Design/ip/ClockDiv_Block_Design_clk_wiz_0_0/ClockDiv_Block_Design_clk_wiz_0_0_clk_wiz.v" \
"../../../bd/ClockDiv_Block_Design/ip/ClockDiv_Block_Design_clk_wiz_0_0/ClockDiv_Block_Design_clk_wiz_0_0.v" \
"../../../bd/ClockDiv_Block_Design/sim/ClockDiv_Block_Design.v" \

vlog -work xil_defaultlib \
"glbl.v"

