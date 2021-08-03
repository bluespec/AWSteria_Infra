// Copyright (c) 2021 Rishiyur S. Nikhil and Bluespec, Inc.

// This is mostly a Verilog Wrapper for the Xilinx IP module 'xpm_cdc_sync_rst' in:
//     /tools/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv
// because Vivado's IP Integrator (Block Design) only accepts
// Verilog modules (and not SystemVerilog) for the "Add Module"
// function on the Block Design canvas.

// Since we're doing a wrapper, we also take the opportunity to: fix
// parameters for the Xilinx IP SV module so that it uses active-low
// resets.

module reset_synchronizer (input wire   src_resetn,
			   input wire   dest_clk,
			   output wire  dest_resetn);

   xpm_cdc_sync_rst #(.INIT (0))    // for active low reset
   xpm_cdc_sync_rst_inst (.src_rst  (src_resetn),
			  .dest_clk (dest_clk),
			  .dest_rst (dest_resetn));
endmodule // reset_synchronizer
