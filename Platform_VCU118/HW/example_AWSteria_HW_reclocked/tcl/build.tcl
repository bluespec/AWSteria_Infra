#-
# Copyright (c) 2020-2021 Jessica Clarke
#
# @BERI_LICENSE_HEADER_START@
#
# Licensed to BERI Open Systems C.I.C. (BERI) under one or more contributor
# license agreements.  See the NOTICE file distributed with this work for
# additional information regarding copyright ownership.  BERI licenses this
# file to you under the BERI Hardware-Software License, Version 1.0 (the
# "License"); you may not use this file except in compliance with the
# License.  You may obtain a copy of the License at:
#
#   http://www.beri-open-systems.org/legal/license-1-0.txt
#
# Unless required by applicable law or agreed to in writing, Work distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations under the License.
#
# @BERI_LICENSE_HEADER_END@
#

set project_dir ".."
set garnet_dir "$project_dir/.."

set project_name "AWSteria"
set partition_module "top_garnet_AWSteria"
# set disable_ddrb 1

source "$garnet_dir/tcl/build.tcl"

garnet_create_synth_project

# Tie-offs deliberately drive ports with constant 0
set_msg_config -id {Synth 8-3917} -suppress
# Many inputs deliberately left unused
set_msg_config -id {Synth 8-3331} -suppress

add_files [list \
  "$project_dir/src/bd/mkAWSteria_HW_reclocked/mkAWSteria_HW_reclocked.bd" \
  "$project_dir/src/synchronizers.v" \
  "$project_dir/src/top_garnet.v" \
  "$project_dir/src/mkAWSteria_HW.v" \
]

# Note: The following sources are for the hierarchy below
# mkAWSteria_HW, and will be different for different AWSteria designs.

add_files [list \
  "$project_dir/src/mkAXI4_16_64_512_0_Fabric_2_N.v" \
  "$project_dir/src/mkAXI4L_S_to_AXI4_M_Adapter_synth.v" \
  "$project_dir/src/SizedFIFO.v" \
  "$project_dir/src/FIFO2.v" \
]

garnet_synth_design
close_project

garnet_create_impl_project

garnet_link_design

garnet_opt_design
garnet_place_design
garnet_route_design

garnet_report_timing
garnet_write_artifacts

close_project
