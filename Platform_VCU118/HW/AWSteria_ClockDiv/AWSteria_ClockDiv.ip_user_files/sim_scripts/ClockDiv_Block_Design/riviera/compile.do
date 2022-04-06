vlib work
vlib riviera

vlib riviera/xil_defaultlib
vlib riviera/xpm

vmap xil_defaultlib riviera/xil_defaultlib
vmap xpm riviera/xpm

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../AWSteria_ClockDiv.srcs/sources_1/bd/ClockDiv_Block_Design/ipshared/c923" \
"/tools/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm -93 \
"/tools/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../AWSteria_ClockDiv.srcs/sources_1/bd/ClockDiv_Block_Design/ipshared/c923" \
"../../../bd/ClockDiv_Block_Design/ip/ClockDiv_Block_Design_clk_wiz_0_0/ClockDiv_Block_Design_clk_wiz_0_0_clk_wiz.v" \
"../../../bd/ClockDiv_Block_Design/ip/ClockDiv_Block_Design_clk_wiz_0_0/ClockDiv_Block_Design_clk_wiz_0_0.v" \
"../../../bd/ClockDiv_Block_Design/sim/ClockDiv_Block_Design.v" \

vlog -work xil_defaultlib \
"glbl.v"

