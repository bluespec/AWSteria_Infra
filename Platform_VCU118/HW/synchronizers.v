// Copyright (c) 2021-2022 Rishiyur S. Nikhil and Bluespec, Inc.

// This is mostly a Verilog Wrapper for Xilinx IP modules
//     'xpm_cdc_sync_rst'
//     'xpm_cdc_single'
//     'xpm_cdc_array_single'
// found in:
//     /tools/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv
// because Vivado's IP Integrator (Block Design) only accepts
// Verilog modules (and not SystemVerilog) for the "Add Module"
// function on the Block Design canvas.

// Since we're doing wrappers, we also take the opportunity to: fix
// parameters for the Xilinx IP SV modules.

// ================================================================
// RSTN synchronizer

module reset_synchronizer (input wire   src_resetn,
			   input wire   dest_clk,
			   output wire  dest_resetn);

   xpm_cdc_sync_rst #(.INIT (0))    // for active low reset
   xpm_cdc_sync_rst_inst (.src_rst  (src_resetn),
			  .dest_clk (dest_clk),
			  .dest_rst (dest_resetn));
endmodule // reset_synchronizer

// ================================================================
// 1-bit synchronizer

module bit_1_synchronizer (input  wire  src_clk,
			   input  wire  src_in,
			   input  wire  dest_clk,
			   output wire  dest_out
);

   xpm_cdc_single
     xpm_cdc_single (.src_clk  (src_clk),
		     .src_in   (src_in),
		     .dest_clk (dest_clk),
		     .dest_out (dest_out));
endmodule

// ================================================================
// 64-bit synchronizer

module bit_64_synchronizer (input  wire        src_clk,
			    input wire [63:0]  src_in,
			    input wire 	       dest_clk,
			    output wire [63:0] dest_out
);

   xpm_cdc_array_single #(.WIDTH (64))
   xpm_cdc_array_single (.src_clk  (src_clk),
			 .src_in   (src_in),
			 .dest_clk (dest_clk),
			 .dest_out (dest_out));
endmodule

// ================================================================
