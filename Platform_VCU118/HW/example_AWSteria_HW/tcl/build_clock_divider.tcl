
create_project -in_memory -part xcvu9p-flga2104-2L-e

set_property board_part xilinx.com:vcu118:part0:2.3 [current_project]

set ip_name clk_wiz
set ip_vendor xilinx.com
set ip_library ip
set ip_version 6.0
set ip_module_name clk_div

create_ip \
  -name $ip_name \
  -vendor $ip_vendor \
  -library $ip_library \
  -version $ip_version \
  -module_name $ip_module_name \
  -dir . \
  -force

set ip [get_ips $ip_module_name]

set_property -dict [ list \
   CONFIG.CLKIN1_JITTER_PS {40.0} \
   CONFIG.CLKOUT1_JITTER {102.531} \
   CONFIG.CLKOUT1_PHASE_ERROR {85.928} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {125.000} \
   CONFIG.CLKOUT2_JITTER {107.111} \
   CONFIG.CLKOUT2_PHASE_ERROR {85.928} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {100.000} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLKOUT3_JITTER {123.073} \
   CONFIG.CLKOUT3_PHASE_ERROR {85.928} \
   CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {50.000} \
   CONFIG.CLKOUT3_USED {true} \
   CONFIG.CLKOUT4_JITTER {141.604} \
   CONFIG.CLKOUT4_PHASE_ERROR {85.928} \
   CONFIG.CLKOUT4_REQUESTED_OUT_FREQ {25.000} \
   CONFIG.CLKOUT4_USED {true} \
   CONFIG.CLKOUT5_JITTER {169.738} \
   CONFIG.CLKOUT5_PHASE_ERROR {85.928} \
   CONFIG.CLKOUT5_REQUESTED_OUT_FREQ {10.000} \
   CONFIG.CLKOUT5_USED {true} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {4.000} \
   CONFIG.MMCM_CLKIN1_PERIOD {4.000} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {8.000} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {10} \
   CONFIG.MMCM_CLKOUT2_DIVIDE {20} \
   CONFIG.MMCM_CLKOUT3_DIVIDE {40} \
   CONFIG.MMCM_CLKOUT4_DIVIDE {100} \
   CONFIG.MMCM_DIVCLK_DIVIDE {1} \
   CONFIG.NUM_OUT_CLKS {5} \
   CONFIG.PRIM_IN_FREQ {250.000} \
   CONFIG.RESET_PORT {resetn} \
   CONFIG.RESET_TYPE {ACTIVE_LOW} \
   CONFIG.USE_LOCKED {false} \
 ] $ip

set_property GENERATE_SYNTH_CHECKPOINT FALSE [get_files [get_property IP_FILE $ip]]

generate_target -force all $ip

