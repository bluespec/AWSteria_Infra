// Amazon FPGA Hardware Development Kit
//
// Copyright 2016 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//
// Licensed under the Amazon Software License (the "License"). You may not use
// this file except in compliance with the License. A copy of the License is
// located at
//
//    http://aws.amazon.com/asl/
//
// or in the "license" file accompanying this file. This file is distributed on
// an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, express or
// implied. See the License for the specific language governing permissions and
// limitations under the License.

`ifndef CL_AWSTERIA_DEFINES
`define CL_AWSTERIA_DEFINES

//Put module name of the CL design here.  This is used to instantiate in top.sv
`define CL_NAME cl_AWSteria

//Highly recommeneded.  For lib FIFO block, uses less async reset (take advantage of
// FPGA flop init capability).  This will help with routing resources.
`define FPGA_LESS_RST

`define SH_SDA
//uncomment below to make SH and CL async
`define SH_CL_ASYNC

// Uncomment to disable Virtual JTAG
//`define DISABLE_VJTAG_DEBUG

// Defining local macros that will instantiate the desired DDR controllers in
// the CL.
`ifndef DDR_A_ABSENT
  `define DDR_A_PRESENT 1
`else
  `define DDR_A_PRESENT 0
`endif

`ifndef DDR_B_ABSENT
  `define DDR_B_PRESENT 1
`else
  `define DDR_B_PRESENT 0
`endif

`ifndef DDR_D_ABSENT
  `define DDR_D_PRESENT 1
`else
  `define DDR_D_PRESENT 0
`endif

`endif

