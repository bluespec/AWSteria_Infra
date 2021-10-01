vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib
vlib questa_lib/msim/xpm
vlib questa_lib/msim/axi_infrastructure_v1_1_0
vlib questa_lib/msim/fifo_generator_v13_2_4
vlib questa_lib/msim/axi_clock_converter_v2_1_18

vmap xil_defaultlib questa_lib/msim/xil_defaultlib
vmap xpm questa_lib/msim/xpm
vmap axi_infrastructure_v1_1_0 questa_lib/msim/axi_infrastructure_v1_1_0
vmap fifo_generator_v13_2_4 questa_lib/msim/fifo_generator_v13_2_4
vmap axi_clock_converter_v2_1_18 questa_lib/msim/axi_clock_converter_v2_1_18

vlog -work xil_defaultlib -64 -sv "+incdir+../../../../AWSteria_HW_reclocked.srcs/sources_1/bd/mkAWSteria_HW_reclocked/ipshared/ec67/hdl" "+incdir+../../../../AWSteria_HW_reclocked.srcs/sources_1/bd/mkAWSteria_HW_reclocked/ipshared/c923" \
"/tools/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm -64 -93 \
"/tools/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib -64 "+incdir+../../../../AWSteria_HW_reclocked.srcs/sources_1/bd/mkAWSteria_HW_reclocked/ipshared/ec67/hdl" "+incdir+../../../../AWSteria_HW_reclocked.srcs/sources_1/bd/mkAWSteria_HW_reclocked/ipshared/c923" \
"../../../bd/mkAWSteria_HW_reclocked/ip/mkAWSteria_HW_reclocked_mkAWSteria_HW_0_0/sim/mkAWSteria_HW_reclocked_mkAWSteria_HW_0_0.v" \

vlog -work axi_infrastructure_v1_1_0 -64 "+incdir+../../../../AWSteria_HW_reclocked.srcs/sources_1/bd/mkAWSteria_HW_reclocked/ipshared/ec67/hdl" "+incdir+../../../../AWSteria_HW_reclocked.srcs/sources_1/bd/mkAWSteria_HW_reclocked/ipshared/c923" \
"../../../../AWSteria_HW_reclocked.srcs/sources_1/bd/mkAWSteria_HW_reclocked/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work fifo_generator_v13_2_4 -64 "+incdir+../../../../AWSteria_HW_reclocked.srcs/sources_1/bd/mkAWSteria_HW_reclocked/ipshared/ec67/hdl" "+incdir+../../../../AWSteria_HW_reclocked.srcs/sources_1/bd/mkAWSteria_HW_reclocked/ipshared/c923" \
"../../../../AWSteria_HW_reclocked.srcs/sources_1/bd/mkAWSteria_HW_reclocked/ipshared/1f5a/simulation/fifo_generator_vlog_beh.v" \

vcom -work fifo_generator_v13_2_4 -64 -93 \
"../../../../AWSteria_HW_reclocked.srcs/sources_1/bd/mkAWSteria_HW_reclocked/ipshared/1f5a/hdl/fifo_generator_v13_2_rfs.vhd" \

vlog -work fifo_generator_v13_2_4 -64 "+incdir+../../../../AWSteria_HW_reclocked.srcs/sources_1/bd/mkAWSteria_HW_reclocked/ipshared/ec67/hdl" "+incdir+../../../../AWSteria_HW_reclocked.srcs/sources_1/bd/mkAWSteria_HW_reclocked/ipshared/c923" \
"../../../../AWSteria_HW_reclocked.srcs/sources_1/bd/mkAWSteria_HW_reclocked/ipshared/1f5a/hdl/fifo_generator_v13_2_rfs.v" \

vlog -work axi_clock_converter_v2_1_18 -64 "+incdir+../../../../AWSteria_HW_reclocked.srcs/sources_1/bd/mkAWSteria_HW_reclocked/ipshared/ec67/hdl" "+incdir+../../../../AWSteria_HW_reclocked.srcs/sources_1/bd/mkAWSteria_HW_reclocked/ipshared/c923" \
"../../../../AWSteria_HW_reclocked.srcs/sources_1/bd/mkAWSteria_HW_reclocked/ipshared/ac9d/hdl/axi_clock_converter_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 "+incdir+../../../../AWSteria_HW_reclocked.srcs/sources_1/bd/mkAWSteria_HW_reclocked/ipshared/ec67/hdl" "+incdir+../../../../AWSteria_HW_reclocked.srcs/sources_1/bd/mkAWSteria_HW_reclocked/ipshared/c923" \
"../../../bd/mkAWSteria_HW_reclocked/ip/mkAWSteria_HW_reclocked_axi_clock_converter_0_0/sim/mkAWSteria_HW_reclocked_axi_clock_converter_0_0.v" \
"../../../bd/mkAWSteria_HW_reclocked/ip/mkAWSteria_HW_reclocked_axi_clock_converter_0_1/sim/mkAWSteria_HW_reclocked_axi_clock_converter_0_1.v" \
"../../../bd/mkAWSteria_HW_reclocked/ip/mkAWSteria_HW_reclocked_host_AXI4_clock_converter_0/sim/mkAWSteria_HW_reclocked_host_AXI4_clock_converter_0.v" \
"../../../bd/mkAWSteria_HW_reclocked/ip/mkAWSteria_HW_reclocked_ddr_A_clock_converter_0/sim/mkAWSteria_HW_reclocked_ddr_A_clock_converter_0.v" \
"../../../bd/mkAWSteria_HW_reclocked/ip/mkAWSteria_HW_reclocked_clk_wiz_0_0/mkAWSteria_HW_reclocked_clk_wiz_0_0_clk_wiz.v" \
"../../../bd/mkAWSteria_HW_reclocked/ip/mkAWSteria_HW_reclocked_clk_wiz_0_0/mkAWSteria_HW_reclocked_clk_wiz_0_0.v" \
"../../../bd/mkAWSteria_HW_reclocked/ip/mkAWSteria_HW_reclocked_reset_synchronizer_0_0/sim/mkAWSteria_HW_reclocked_reset_synchronizer_0_0.v" \
"../../../bd/mkAWSteria_HW_reclocked/ip/mkAWSteria_HW_reclocked_reset_synchronizer_0_1/sim/mkAWSteria_HW_reclocked_reset_synchronizer_0_1.v" \
"../../../bd/mkAWSteria_HW_reclocked/ip/mkAWSteria_HW_reclocked_bit_1_synchronizer_0_0/sim/mkAWSteria_HW_reclocked_bit_1_synchronizer_0_0.v" \
"../../../bd/mkAWSteria_HW_reclocked/ip/mkAWSteria_HW_reclocked_bit_1_synchronizer_0_1/sim/mkAWSteria_HW_reclocked_bit_1_synchronizer_0_1.v" \
"../../../bd/mkAWSteria_HW_reclocked/ip/mkAWSteria_HW_reclocked_bit_64_synchronizer_0_0/sim/mkAWSteria_HW_reclocked_bit_64_synchronizer_0_0.v" \
"../../../bd/mkAWSteria_HW_reclocked/sim/mkAWSteria_HW_reclocked.v" \

vlog -work xil_defaultlib \
"glbl.v"

