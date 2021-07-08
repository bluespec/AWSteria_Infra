// Copyright (c) 2013-2021 Bluespec, Inc. All Rights Reserved.
// Author: Rishiyur S. Nikhil

package Top_HW_Side;

// ================================================================
// mkTop_HW_Side is the top-level module for simulating an BluPont design.

// ================================================================
// BSV lib imports

import Vector       :: *;
import FIFOF        :: *;
import GetPut       :: *;
import ClientServer :: *;
import Connectable  :: *;

// ----------------
// BSV additional libs

import Cur_Cycle  :: *;
import GetPut_Aux :: *;
import Semi_FIFOF :: *;

// ================================================================
// Project imports

import AXI4_Types      :: *;
import AXI4_Lite_Types :: *;

import BluPont_DDR4_Model   :: *;

// Communication with host
import Bytevec   :: *;
import C_Imports :: *;

// The BluPont DUT
import BluPont_HW_Side_IFC :: *;
import BluPont_HW_Side     :: *;

// ================================================================
// Top-level module.
// Instantiates the SoC.
// Instantiates a memory model.

typedef enum { STATE_CONNECTING, STATE_CONNECTED, STATE_RUNNING } State
deriving (Eq, Bits, FShow);

(* synthesize *)
module mkTop_HW_Side (Empty) ;

   // 0: quiet; 1: rules
   Integer verbosity = 0;

   Reg #(State) rg_state <- mkReg (STATE_CONNECTING);

   // The top-level of the BluPont design
   BluPont_HW_Side_IFC #(AXI4_16_64_512_0_S_IFC,
			 AXI4L_32_32_0_S_IFC,
			 AXI4_16_64_512_0_M_IFC)  blupont_hw_side <- mkBluPont_HW_Side;

   // ----------------
   // Models for the four DDR4s,
   // and their connection to blupont_hw_side.

   // DDR4 A (cached mem access, incl. bursts)
   AXI4_16_64_512_0_Slave_IFC  ddr4_A <- mkBluPont_DDR4_A_Model;
   mkConnection (blupont_hw_side.ddr4_A_M, ddr4_A);

   // DDR4 B (uncached mem access, no bursts)
   AXI4_16_64_512_0_Slave_IFC  ddr4_B <- mkBluPont_DDR4_B_Model;
   mkConnection (blupont_hw_side.ddr4_B_M, ddr4_B);

   // DDR4 C (tie-off: unused for now)
   AXI4_16_64_512_0_Slave_IFC  ddr4_C <- mkBluPont_DDR4_C_Model;
   mkConnection (blupont_hw_side.ddr4_C_M, ddr4_C);

   // DDR4 D (tie-off: unused for now)
   AXI4_16_64_512_0_Slave_IFC  ddr4_D <- mkBluPont_DDR4_D_Model;
   mkConnection (blupont_hw_side.ddr4_D_M, ddr4_D);

   // ================================================================
   // BEHAVIOR: start up

   rule rl_connecting (rg_state == STATE_CONNECTING);
      $display ("================================================================");
      $display ("Bluespec AWSteria simulation v1.0");
      $display ("Copyright (c) 2020-2021 Bluespec, Inc. All Rights Reserved.");
      $display ("================================================================");

      // Open connection to remote host (host is client, we are server)
      c_host_connect (default_tcp_port);
      rg_state <= STATE_CONNECTED;
   endrule

   rule rl_start_when_connected (rg_state == STATE_CONNECTED);

      // Any post-connection initialization goes here

      rg_state <= STATE_RUNNING;
   endrule

   // ================================================================
   // Interaction with remote host

   Integer verbosity_bytevec = 0;
   Integer verbosity_AXI     = 0;
   Integer verbosity_AXIL    = 0;

   // Communication box (converts between bytevecs and message structs)
   Bytevec_IFC comms <- mkBytevec;

   // Receive a bytevec from host and put into communication box
   rule rl_host_recv (rg_state == STATE_RUNNING);
      Bytevec_C_to_BSV bytevec = ?;

      // Try to receive a bytevec from host (into a buffer-in-C)
      Bit #(8) status <- c_host_recv2 ('hAA);

      if (status == 0)
	 // No bytes received
	 bytevec [0] = 0;
      else begin
	 // Bytes received; load them into bytevec from the buffer-in-C
	 for (Integer j = 0; j < bytevec_C_to_BSV_size; j = j + 1)
	    bytevec [j] <- c_host_recv_get_byte_j (fromInteger (j));
      end

      // Protocol: bytevec [0] is the size of the bytevec
      // 0 is used to indicate that no bytevec was available from the host
      if (bytevec [0] != 0) begin
	 comms.fi_C_to_BSV_bytevec.enq (bytevec);

	 // Debug
	 if (verbosity_bytevec != 0) begin
	    $write ("Top_HW_Side.rl_host_recv\n    [");
	    for (Integer j = 0; j < bytevec_C_to_BSV_size; j = j + 1)
	       if (fromInteger (j) < bytevec [0])
		  $write (" %02h", bytevec [j]);
	    $display ("]");
	 end
      end
   endrule

   // Get a bytevec from communication box and send to host
   rule rl_host_send (rg_state == STATE_RUNNING);
      BSV_to_C_Bytevec bytevec <- pop_o (comms.fo_BSV_to_C_bytevec);

      // Debug
      if (verbosity_bytevec != 0) begin
	 $write ("Top_HW_Side.rl_host_send\n    [");
	 for (Integer j = 0; j < fromInteger (bytevec_BSV_to_C_size); j = j + 1)
	    if (fromInteger (j) < bytevec [0])
	       $write (" %02h", bytevec [j]);
	 $display ("]");
      end

      Bit #(8) status = 0;

      for (Integer j = 0; j < bytevec_BSV_to_C_size; j = j + 1) begin
	 let status1 <- c_host_send_put_byte_j (fromInteger (j), bytevec [j]);
	 status = (status | status1);
      end
      if (status != 0)
	 c_host_send2 ('hAA);

      // c_host_send (bytevec, fromInteger (bytevec_BSV_to_C_size));
   endrule

   // ----------------
   // Connect communication box and host_AXI4 port of blupont_hw_side

   // Note: the rules rl_xxx below can't be replaced by 'mkConnection'
   // because although t1 and t2 are isomorphic types, they are
   // different BSV types coming from different declarations.

   AXI4_Master_Xactor_IFC #(16,64,512,0)  host_AXI4_xactor <- mkAXI4_Master_Xactor;

   mkConnection (host_AXI4_xactor.axi_side, blupont_hw_side.host_AXI4_S);

   // Connect AXI4 WR_ADDR channel
   // = mkConnection (comms.fo_AXI4_Wr_Addr_i16_a64_u0,  host_AXI4_xactor.i_wr_addr)
   rule rl_connect_host_AXI4_wr_addr;
      let x1 <- pop_o (comms.fo_AXI4_Wr_Addr_i16_a64_u0);
      let x2 = AXI4_Wr_Addr {awid: x1.awid,
			     awaddr: x1.awaddr,
			     awlen: x1.awlen,
			     awsize: x1.awsize,
			     awburst: x1.awburst,
			     awlock: x1.awlock,
			     awcache: x1.awcache,
			     awprot: x1.awprot,
			     awqos: x1.awqos,
			     awregion: x1.awregion,
			     awuser: x1.awuser};
      host_AXI4_xactor.i_wr_addr.enq (x2);

      if (verbosity_AXI != 0) begin
	 $display ("Top_HW_Side.rl_connect_host_AXI4_wr_addr");
	 $display ("    ", fshow (x2));
      end
   endrule

   // Connect AXI4 WR_DATA channel
   // = mkConnection (comms.fo_AXI4_Wr_Data_d512_u0,  host_AXI4_xactor.i_wr_data)
   rule rl_connect_host_AXI4_wr_data;
      let x1 <- pop_o (comms.fo_AXI4_Wr_Data_d512_u0);
      let x2 = AXI4_Wr_Data {wdata: x1.wdata,
			     wstrb: x1.wstrb,
			     wlast: unpack (x1.wlast),
			     wuser: x1.wuser};
      host_AXI4_xactor.i_wr_data.enq (x2);

      if (verbosity_AXI != 0) begin
	 $display ("Top_HW_Side.rl_connect_host_AXI4_wr_data:");
	 $display ("    ", fshow (x2));
      end
   endrule

   // Connect AXI4 RD_ADDR channel
   // = mkConnection (comms.fo_AXI4_Rd_Addr_i16_a64_u0,  host_AXI4_xactor.i_rd_addr)
   rule rl_connect_host_AXI4_rd_addr;
      let x1 <- pop_o (comms.fo_AXI4_Rd_Addr_i16_a64_u0);
      let x2 = AXI4_Rd_Addr {arid: x1.arid,
			     araddr: x1.araddr,
			     arlen: x1.arlen,
			     arsize: x1.arsize,
			     arburst: x1.arburst,
			     arlock: x1.arlock,
			     arcache: x1.arcache,
			     arprot: x1.arprot,
			     arqos: x1.arqos,
			     arregion: x1.arregion,
			     aruser: x1.aruser};
      host_AXI4_xactor.i_rd_addr.enq (x2);

      if (verbosity_AXI != 0) begin
	 $display ("Top_HW_Side.rl_connect_host_AXI4_rd_addr");
	 $display ("    ", fshow (x2));
      end
   endrule

   // Connect AXI4 WR_RESP channel
   // = mkConnection (comms.fi_AXI4_Wr_Resp_i16_u0,  host_AXI4_xactor.o_wr_resp)
   rule rl_connect_host_AXI4_wr_resp;
      let x1 <- pop_o (host_AXI4_xactor.o_wr_resp);
      let x2 = AXI4_Wr_Resp_i16_u0 {bid:   x1.bid,
				    bresp: x1.bresp,
				    buser: x1.buser};
      comms.fi_AXI4_Wr_Resp_i16_u0.enq (x2);

      if (verbosity_AXI != 0) begin
	 $display ("Top_HW_Side.rl_connect_host_AXI4_wr_resp");
	 $display ("    ", fshow (x2));
      end
   endrule

   // Connect AXI4 RD_DATA channel
   // = mkConnection (comms.fi_AXI4_Rd_Data_i16_d512_u0,  host_AXI4_xactor.o_rd_data)
   rule rl_connect_host_AXI4_rd_data;
      let x1 <- pop_o (host_AXI4_xactor.o_rd_data);
      let x2 = AXI4_Rd_Data_i16_d512_u0 {rid:   x1.rid,
					 rdata: x1.rdata,
					 rresp: x1.rresp,
					 rlast: pack (x1.rlast),
					 ruser: x1.ruser};
      comms.fi_AXI4_Rd_Data_i16_d512_u0.enq (x2);

      if (verbosity_AXI != 0) begin
	 $display ("Top_HW_Side.rl_connect_host_AXI4_rd_data");
	 $display ("    ", fshow (x2));
      end
   endrule

   // ----------------
   // Connect communication box and host AXI4-Lite port of blupont_hw_side

   AXI4_Lite_Master_Xactor_IFC #(32,32,0)  host_AXI4L_xactor <- mkAXI4_Lite_Master_Xactor;

   mkConnection (host_AXI4L_xactor.axi_side, blupont_hw_side.host_AXI4L_S);

   // Connect AXI4L WR_ADDR channel
   // = mkConnection (comms.fo_AXI4L_Wr_Addr_a32_u0,  host_AXI4L_xactor.i_wr_addr)
   rule rl_connect_host_AXI4L_wr_addr;
      let x1 <- pop_o (comms.fo_AXI4L_Wr_Addr_a32_u0);
      let x2 = AXI4_Lite_Wr_Addr {awaddr: x1.awaddr,
				  awprot: x1.awprot,
				  awuser: x1.awuser};
      host_AXI4L_xactor.i_wr_addr.enq (x2);
   endrule

   // Connect AXI4L WR_DATA channel
   // = mkConnection (comms.fo_AXI4L_Wr_Data_d32,  host_AXI4L_xactor.i_wr_data)
   rule rl_connect_host_AXI4L_wr_data;
      let x1 <- pop_o (comms.fo_AXI4L_Wr_Data_d32);
      let x2 = AXI4_Lite_Wr_Data {wdata: x1.wdata,
				  wstrb: x1.wstrb};
      host_AXI4L_xactor.i_wr_data.enq (x2);
   endrule

   // Connect AXI4L RD_ADDR channel
   // = mkConnection (comms.fo_AXI4L_Rd_Addr_a32_u0,  host_AXI4L_xactor.i_rd_addr)
   rule rl_connect_host_AXI4L_rd_addr;
      let x1 <- pop_o (comms.fo_AXI4L_Rd_Addr_a32_u0);
      let x2 = AXI4_Lite_Rd_Addr {araddr: x1.araddr,
				  arprot: x1.arprot,
				  aruser: x1.aruser};
      host_AXI4L_xactor.i_rd_addr.enq (x2);
   endrule

   // Connect AXI4L WR_RESP channel
   // = mkConnection (comms.fi_AXI4L_Wr_Resp_u0,  host_AXI4L_xactor.i_wr_resp)
   rule rl_connect_host_AXI4L_wr_resp;
      let x1 <- pop_o (host_AXI4L_xactor.o_wr_resp);
      let x2 = AXI4L_Wr_Resp_u0 {bresp: pack (x1.bresp),
				 buser: x1.buser};
      comms.fi_AXI4L_Wr_Resp_u0.enq (x2);
   endrule
   
   // Connect AXI4L RD_DATA channel
   // = mkConnection (comms.fi_AXI4L_Rd_Data_d32_u0,  host_AXI4L_xactor.o_rd_data)
   rule rl_connect_host_AXI4L_rd_data;
      let x1 <- pop_o (host_AXI4L_xactor.o_rd_data);
      let x2 = AXI4L_Rd_Data_d32_u0 {rresp: pack (x1.rresp),
				     rdata: x1.rdata,
				     ruser: x1.ruser};
      comms.fi_AXI4L_Rd_Data_d32_u0.enq (x2);
   endrule

   // ================================================================
   // Misc. other connections to Blupont_hw_side

   Reg #(Bit #(64)) rg_counter   <- mkReg (0);
   Reg #(Bit #(16)) rg_last_vled <- mkReg (0);
   Reg #(Bit #(16)) rg_vdip      <- mkReg (0);

   rule rl_status_signals;
      // ---------------- gcounts (counters)
      blupont_hw_side.m_glcount0 (rg_counter);
      blupont_hw_side.m_glcount1 (rg_counter);
      rg_counter <= rg_counter + 1;

      // ---------------- DDR ready
      blupont_hw_side.m_ddr4s_ready ('1);

      // ---------------- VDIP
      blupont_hw_side.m_vdip (rg_vdip);

      // ---------------- VLED
      let vled = blupont_hw_side.m_vled;
      for (Integer j = 0; j < 16; j = j + 1)
	 if ((rg_last_vled [j] == 0) && (vled [j] == 1)) begin
	    if (verbosity != 0)
	       $display ("vled [%0d] turned on", j);
	 end
	 else if ((rg_last_vled [j] == 1) && (vled [j] == 0)) begin
	    if (verbosity != 0)
	       $display ("vled [%0d] turned off", j);
	 end
      rg_last_vled <= vled;
   endrule

   // ================================================================
   // INTERFACE

   //  None (this is top-level)

endmodule

// ================================================================

endpackage: Top_HW_Side
