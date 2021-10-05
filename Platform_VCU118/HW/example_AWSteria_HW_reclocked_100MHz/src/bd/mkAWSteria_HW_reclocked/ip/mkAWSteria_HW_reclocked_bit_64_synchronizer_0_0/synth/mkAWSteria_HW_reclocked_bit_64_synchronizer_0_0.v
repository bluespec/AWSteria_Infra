// (c) Copyright 1995-2021 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: xilinx.com:module_ref:bit_64_synchronizer:1.0
// IP Revision: 1

(* X_CORE_INFO = "bit_64_synchronizer,Vivado 2019.1" *)
(* CHECK_LICENSE_TYPE = "mkAWSteria_HW_reclocked_bit_64_synchronizer_0_0,bit_64_synchronizer,{}" *)
(* CORE_GENERATION_INFO = "mkAWSteria_HW_reclocked_bit_64_synchronizer_0_0,bit_64_synchronizer,{x_ipProduct=Vivado 2019.1,x_ipVendor=xilinx.com,x_ipLibrary=module_ref,x_ipName=bit_64_synchronizer,x_ipVersion=1.0,x_ipCoreRevision=1,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED}" *)
(* IP_DEFINITION_SOURCE = "module_ref" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module mkAWSteria_HW_reclocked_bit_64_synchronizer_0_0 (
  src_clk,
  src_in,
  dest_clk,
  dest_out
);

(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME src_clk, FREQ_HZ 250000000, PHASE 0.000, CLK_DOMAIN mkAWSteria_HW_reclocked_clk_in1_0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 src_clk CLK" *)
input wire src_clk;
input wire [63 : 0] src_in;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME dest_clk, FREQ_HZ 100000000, PHASE 0.0, CLK_DOMAIN mkAWSteria_HW_reclocked_clk_wiz_0_0_clk_out1, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 dest_clk CLK" *)
input wire dest_clk;
output wire [63 : 0] dest_out;

  bit_64_synchronizer inst (
    .src_clk(src_clk),
    .src_in(src_in),
    .dest_clk(dest_clk),
    .dest_out(dest_out)
  );
endmodule
