
################################################################
# This is a generated script based on design: mkAWSteria_HW_reclocked
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2019.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source mkAWSteria_HW_reclocked_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# reset_synchronizer, reset_synchronizer, bit_1_synchronizer, bit_64_synchronizer, bit_1_synchronizer, mkAWSteria_HW

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcvu9p-flga2104-2L-e
   set_property BOARD_PART xilinx.com:vcu118:part0:2.3 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name mkAWSteria_HW_reclocked

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:axi_clock_converter:2.1\
"

   set list_ips_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
reset_synchronizer\
reset_synchronizer\
bit_1_synchronizer\
bit_64_synchronizer\
bit_1_synchronizer\
mkAWSteria_HW\
"

   set list_mods_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_msg_id "BD_TCL-008" "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "BD_TCL-1003" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set ddr_A_M [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 ddr_A_M ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {64} \
   CONFIG.DATA_WIDTH {512} \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4} \
   ] $ddr_A_M

  set ddr_B_M [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 ddr_B_M ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {64} \
   CONFIG.DATA_WIDTH {512} \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4} \
   ] $ddr_B_M

  set host_AXI4L_S [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 host_AXI4L_S ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {0} \
   CONFIG.HAS_CACHE {0} \
   CONFIG.HAS_LOCK {0} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.MAX_BURST_LENGTH {1} \
   CONFIG.NUM_READ_OUTSTANDING {1} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {1} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4LITE} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {0} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $host_AXI4L_S

  set host_AXI4_S [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 host_AXI4_S ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {64} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {512} \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {16} \
   CONFIG.MAX_BURST_LENGTH {256} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $host_AXI4_S


  # Create ports
  set CLK [ create_bd_port -dir I -type clk CLK ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
 ] $CLK
  set CLK_b_CLK [ create_bd_port -dir I -type clk CLK_b_CLK ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
 ] $CLK_b_CLK
  set RST_N [ create_bd_port -dir I -type rst RST_N ]
  set RST_N_b_RST_N [ create_bd_port -dir I -type rst RST_N_b_RST_N ]
  set m_env_ready_env_ready [ create_bd_port -dir I m_env_ready_env_ready ]
  set m_glcount_glcount [ create_bd_port -dir I -from 63 -to 0 m_glcount_glcount ]
  set m_halted [ create_bd_port -dir O m_halted ]

  # Create instance: clk_out1_reset_synchronizer, and set properties
  set block_name reset_synchronizer
  set block_cell_name clk_out1_reset_synchronizer
  if { [catch {set clk_out1_reset_synchronizer [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $clk_out1_reset_synchronizer eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: clk_out2_reset_synchronizer, and set properties
  set block_name reset_synchronizer
  set block_cell_name clk_out2_reset_synchronizer
  if { [catch {set clk_out2_reset_synchronizer [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $clk_out2_reset_synchronizer eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLKIN1_JITTER_PS {40.0} \
   CONFIG.CLKOUT1_JITTER {134.506} \
   CONFIG.CLKOUT1_PHASE_ERROR {154.678} \
   CONFIG.CLKOUT2_JITTER {153.164} \
   CONFIG.CLKOUT2_PHASE_ERROR {154.678} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {50.000} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {24.000} \
   CONFIG.MMCM_CLKIN1_PERIOD {4.000} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {24} \
   CONFIG.MMCM_DIVCLK_DIVIDE {5} \
   CONFIG.NUM_OUT_CLKS {2} \
   CONFIG.PRIM_IN_FREQ {250.000} \
   CONFIG.RESET_PORT {resetn} \
   CONFIG.RESET_TYPE {ACTIVE_LOW} \
   CONFIG.USE_LOCKED {false} \
 ] $clk_wiz_0

  # Create instance: ddr_A_clock_converter, and set properties
  set ddr_A_clock_converter [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_clock_converter:2.1 ddr_A_clock_converter ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {64} \
   CONFIG.DATA_WIDTH {512} \
   CONFIG.ID_WIDTH {16} \
 ] $ddr_A_clock_converter

  # Create instance: ddr_B_clock_converter, and set properties
  set ddr_B_clock_converter [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_clock_converter:2.1 ddr_B_clock_converter ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {64} \
   CONFIG.DATA_WIDTH {512} \
   CONFIG.ID_WIDTH {16} \
 ] $ddr_B_clock_converter

  # Create instance: host_AXI4L_clock_converter, and set properties
  set host_AXI4L_clock_converter [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_clock_converter:2.1 host_AXI4L_clock_converter ]
  set_property -dict [ list \
   CONFIG.PROTOCOL {AXI4LITE} \
 ] $host_AXI4L_clock_converter

  # Create instance: host_AXI4_clock_converter, and set properties
  set host_AXI4_clock_converter [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_clock_converter:2.1 host_AXI4_clock_converter ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {64} \
   CONFIG.DATA_WIDTH {512} \
   CONFIG.ID_WIDTH {16} \
 ] $host_AXI4_clock_converter

  # Create instance: m_env_ready_synchronizer, and set properties
  set block_name bit_1_synchronizer
  set block_cell_name m_env_ready_synchronizer
  if { [catch {set m_env_ready_synchronizer [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $m_env_ready_synchronizer eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: m_glcount_synchronizer, and set properties
  set block_name bit_64_synchronizer
  set block_cell_name m_glcount_synchronizer
  if { [catch {set m_glcount_synchronizer [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $m_glcount_synchronizer eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: m_halted_synchronizer, and set properties
  set block_name bit_1_synchronizer
  set block_cell_name m_halted_synchronizer
  if { [catch {set m_halted_synchronizer [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $m_halted_synchronizer eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: mkAWSteria_HW_0, and set properties
  set block_name mkAWSteria_HW
  set block_cell_name mkAWSteria_HW_0
  if { [catch {set mkAWSteria_HW_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $mkAWSteria_HW_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create interface connections
  connect_bd_intf_net -intf_net S_AXI_0_1 [get_bd_intf_ports host_AXI4L_S] [get_bd_intf_pins host_AXI4L_clock_converter/S_AXI]
  connect_bd_intf_net -intf_net S_AXI_0_2 [get_bd_intf_ports host_AXI4_S] [get_bd_intf_pins host_AXI4_clock_converter/S_AXI]
  connect_bd_intf_net -intf_net ddr_A_clock_converter_M_AXI [get_bd_intf_ports ddr_A_M] [get_bd_intf_pins ddr_A_clock_converter/M_AXI]
  connect_bd_intf_net -intf_net ddr_B_clock_converter_M_AXI [get_bd_intf_ports ddr_B_M] [get_bd_intf_pins ddr_B_clock_converter/M_AXI]
  connect_bd_intf_net -intf_net host_AXI4L_clock_converter_M_AXI [get_bd_intf_pins host_AXI4L_clock_converter/M_AXI] [get_bd_intf_pins mkAWSteria_HW_0/host_AXI4L_S]
  connect_bd_intf_net -intf_net host_AXI4_clock_converter_M_AXI [get_bd_intf_pins host_AXI4_clock_converter/M_AXI] [get_bd_intf_pins mkAWSteria_HW_0/host_AXI4_S]
  connect_bd_intf_net -intf_net mkAWSteria_HW_0_ddr_A_M [get_bd_intf_pins ddr_A_clock_converter/S_AXI] [get_bd_intf_pins mkAWSteria_HW_0/ddr_A_M]
  connect_bd_intf_net -intf_net mkAWSteria_HW_0_ddr_B_M [get_bd_intf_pins ddr_B_clock_converter/S_AXI] [get_bd_intf_pins mkAWSteria_HW_0/ddr_B_M]

  # Create port connections
  connect_bd_net -net clk_in1_0_1 [get_bd_ports CLK] [get_bd_pins clk_wiz_0/clk_in1] [get_bd_pins ddr_A_clock_converter/m_axi_aclk] [get_bd_pins ddr_B_clock_converter/m_axi_aclk] [get_bd_pins host_AXI4L_clock_converter/s_axi_aclk] [get_bd_pins host_AXI4_clock_converter/s_axi_aclk] [get_bd_pins m_env_ready_synchronizer/src_clk] [get_bd_pins m_glcount_synchronizer/src_clk] [get_bd_pins m_halted_synchronizer/dest_clk]
  connect_bd_net -net clk_out1_reset_synchronizer_dest_resetn [get_bd_pins clk_out1_reset_synchronizer/dest_resetn] [get_bd_pins ddr_A_clock_converter/s_axi_aresetn] [get_bd_pins ddr_B_clock_converter/s_axi_aresetn] [get_bd_pins host_AXI4L_clock_converter/m_axi_aresetn] [get_bd_pins host_AXI4_clock_converter/m_axi_aresetn] [get_bd_pins mkAWSteria_HW_0/RST_N]
  connect_bd_net -net clk_out2_reset_synchronizer_dest_resetn [get_bd_pins clk_out2_reset_synchronizer/dest_resetn] [get_bd_pins mkAWSteria_HW_0/RST_N_b_RST_N]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins clk_out1_reset_synchronizer/dest_clk] [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins ddr_A_clock_converter/s_axi_aclk] [get_bd_pins ddr_B_clock_converter/s_axi_aclk] [get_bd_pins host_AXI4L_clock_converter/m_axi_aclk] [get_bd_pins host_AXI4_clock_converter/m_axi_aclk] [get_bd_pins m_env_ready_synchronizer/dest_clk] [get_bd_pins m_glcount_synchronizer/dest_clk] [get_bd_pins m_halted_synchronizer/src_clk] [get_bd_pins mkAWSteria_HW_0/CLK]
  connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_out2_reset_synchronizer/dest_clk] [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins mkAWSteria_HW_0/CLK_b_CLK]
  connect_bd_net -net m_env_ready_synchronizer_dest_out [get_bd_pins m_env_ready_synchronizer/dest_out] [get_bd_pins mkAWSteria_HW_0/m_env_ready_env_ready]
  connect_bd_net -net m_glcount_synchronizer_dest_out [get_bd_pins m_glcount_synchronizer/dest_out] [get_bd_pins mkAWSteria_HW_0/m_glcount_glcount]
  connect_bd_net -net m_halted_synchronizer_dest_out [get_bd_ports m_halted] [get_bd_pins m_halted_synchronizer/dest_out]
  connect_bd_net -net mkAWSteria_HW_0_m_halted [get_bd_pins m_halted_synchronizer/src_in] [get_bd_pins mkAWSteria_HW_0/m_halted]
  connect_bd_net -net resetn_0_1 [get_bd_ports RST_N] [get_bd_pins clk_out1_reset_synchronizer/src_resetn] [get_bd_pins clk_out2_reset_synchronizer/src_resetn] [get_bd_pins clk_wiz_0/resetn] [get_bd_pins ddr_A_clock_converter/m_axi_aresetn] [get_bd_pins ddr_B_clock_converter/m_axi_aresetn] [get_bd_pins host_AXI4L_clock_converter/s_axi_aresetn] [get_bd_pins host_AXI4_clock_converter/s_axi_aresetn]
  connect_bd_net -net src_in_0_1 [get_bd_ports m_env_ready_env_ready] [get_bd_pins m_env_ready_synchronizer/src_in]
  connect_bd_net -net src_in_0_2 [get_bd_ports m_glcount_glcount] [get_bd_pins m_glcount_synchronizer/src_in]

  # Create address segments

  # Exclude Address Segments
  create_bd_addr_seg -range 0x000100000000 -offset 0x00000000 [get_bd_addr_spaces host_AXI4L_S] [get_bd_addr_segs mkAWSteria_HW_0/host_AXI4L_S/reg0] SEG_mkAWSteria_HW_0_reg0
  exclude_bd_addr_seg [get_bd_addr_segs host_AXI4L_S/SEG_mkAWSteria_HW_0_reg0]

  create_bd_addr_seg -range 0x00010000000000000000 -offset 0x00000000 [get_bd_addr_spaces host_AXI4_S] [get_bd_addr_segs mkAWSteria_HW_0/host_AXI4_S/reg0] SEG_mkAWSteria_HW_0_reg0
  exclude_bd_addr_seg [get_bd_addr_segs host_AXI4_S/SEG_mkAWSteria_HW_0_reg0]

  create_bd_addr_seg -range 0x00010000 -offset 0x44A00000 [get_bd_addr_spaces mkAWSteria_HW_0/ddr_A_M] [get_bd_addr_segs ddr_A_M/Reg] SEG_ddr_A_M_Reg
  exclude_bd_addr_seg [get_bd_addr_segs mkAWSteria_HW_0/ddr_A_M/SEG_ddr_A_M_Reg]

  create_bd_addr_seg -range 0x00010000 -offset 0x44A00000 [get_bd_addr_spaces mkAWSteria_HW_0/ddr_B_M] [get_bd_addr_segs ddr_B_M/Reg] SEG_ddr_B_M_Reg
  exclude_bd_addr_seg [get_bd_addr_segs mkAWSteria_HW_0/ddr_B_M/SEG_ddr_B_M_Reg]



  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


