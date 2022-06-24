// Copyright (c) 2016-2022 Bluespec, Inc. All Rights Reserved

package UltraRAM;

// ================================================================
// This module is a slave on the interconnect Fabric.
//
// ----------------
// This slave IP can be attached to fabrics with 32b- or 64b-wide data channels.
//    (NOTE: this is the width of the fabric, which can be chosen
//      independently of the native width of a CPU master on the
//      fabric (such as RV32/RV64 for a RISC-V CPU).
// When attached to 32b-wide fabric, 64-bit locations must be
// read/written in two 32b transaction, once for the lower 32b and
// once for the upper 32b.
// ================================================================

export

Bits_per_Raw_Mem_Addr,
Raw_Mem_Addr,

Bits_per_Raw_Mem_Word,
Raw_Mem_Word,

UltraRAM_IFC (..),
mkUltraRAM;

// ================================================================
// BSV library imports

import  Vector       :: *;
import  FIFO         :: *;
import  FIFOF        :: *;
import  SpecialFIFOs :: *;
import  GetPut       :: *;
import  ClientServer :: *;
import  Memory       :: *;
import  ConfigReg    :: *;

// ----------------
// BSV additional libs

import Cur_Cycle  :: *;
import GetPut_Aux :: *;
import Semi_FIFOF :: *;
import ByteLane   :: *;

// ================================================================
// Project imports

import Fabric_Defs :: *;
import SoC_Map     :: *;
import AXI4_Types  :: *;
import BVI_UltraRAM ::*;

// ================================================================
// Raw mem address width: 64  (arbitrarily chosen generously large)

typedef 19  Bits_per_Raw_Mem_Addr;  // Size of URAM: 4MiB, 8-byte words

typedef Bit #(Bits_per_Raw_Mem_Addr)  Raw_Mem_Addr;
typedef 64  Bits_per_Raw_Mem_Word;
typedef Bit #(Bits_per_Raw_Mem_Word)  Raw_Mem_Word;

// ----------------
// Views of raw mem word as bytes, word32s and word64s
// Example values on the right based on 256b raw mem data width
typedef TDiv #(Bits_per_Raw_Mem_Word,  8)              Bytes_per_Raw_Mem_Word;             // 8 bytes
Integer bytes_per_raw_mem_word = valueOf (Bytes_per_Raw_Mem_Word);

// # of addr lsbs to index a byte in a Raw_Mem_Word
typedef TLog #(Bytes_per_Raw_Mem_Word)                 Bits_per_Byte_in_Raw_Mem_Word;      //  3
Integer bits_per_byte_in_raw_mem_word = valueOf (Bits_per_Byte_in_Raw_Mem_Word);
Integer hi_byte_in_raw_mem_word = bits_per_byte_in_raw_mem_word - 1;                       //  2

typedef TDiv #(Bits_per_Raw_Mem_Word, 32)              Word32s_per_Raw_Mem_Word;           //  2 x 32b words
Integer word32s_per_raw_mem_word = valueOf (Word32s_per_Raw_Mem_Word);
// # of addr lsbs to index a Word32 in a Raw_Mem_Word seen as a vector of Word32s
typedef TLog #(Word32s_per_Raw_Mem_Word)               Bits_per_Word32_in_Raw_Mem_Word;    //  1
// Type of index of a Word32 in a Raw_Mem_Word seen as a vector of Word32s
typedef Bit #(Bits_per_Word32_in_Raw_Mem_Word)         Word32_in_Raw_Mem_Word;

typedef TDiv #(Bits_per_Raw_Mem_Word, 64)              Word64s_per_Raw_Mem_Word;           //  1 x 64b word
Integer word64s_per_raw_mem_word = valueOf (Word64s_per_Raw_Mem_Word);
// # of addr lsbs to index a Word64 in a Raw_Mem_Word seen as a vector of Word64s
typedef TLog #(Word64s_per_Raw_Mem_Word)               Bits_per_Word64_in_Raw_Mem_Word;    //  0
// Type of index of a Word64 in a Raw_Mem_Word seen as a vector of Word64s
typedef Bit #(Bits_per_Word64_in_Raw_Mem_Word)         Word64_in_Raw_Mem_Word;

typedef TDiv #(Bytes_per_Raw_Mem_Word, Bytes_per_Fabric_Data)  Fabric_Data_per_Raw_Mem_Word;

// Index of bit that selects a fabric data word in an address
`ifdef FABRIC32
Integer  lo_fabric_data = 2;
`endif

`ifdef FABRIC64
Integer  lo_fabric_data = 3;
`endif

// ================================================================

function Bool fn_addr_is_aligned (Fabric_Addr  addr, AXI4_Size  size);
   Bool is_aligned = (   (size == axsize_1)
		      || ((size == axsize_2)    && (addr [0]   == 1'h0))
		      || ((size == axsize_4)    && (addr [1:0] == 2'h0))
		      || ((size == axsize_8)    && (addr [2:0] == 3'h0))
		      || ((size == axsize_16)   && (addr [3:0] == 4'h0))
		      || ((size == axsize_32)   && (addr [4:0] == 5'h0))
		      || ((size == axsize_64)   && (addr [5:0] == 6'h0))
		      || ((size == axsize_128)  && (addr [6:0] == 7'h0)));
   return is_aligned;
endfunction

function Bool fn_addr_is_in_range (Fabric_Addr addr_base, Fabric_Addr addr, Fabric_Addr addr_lim);
   // Note: 'in_range' is redundant if the fabric only delivers
   // relevant addresses to this module so this is just a bit of
   // defensive programming.

   return ((addr_base <= addr) && (addr < addr_lim));
endfunction

function Bool fn_addr_is_ok (Fabric_Addr addr_base, Fabric_Addr addr, Fabric_Addr addr_lim, AXI4_Size  size);
   return (   fn_addr_is_aligned (addr, size)
	   && fn_addr_is_in_range (addr_base, addr, addr_lim));
endfunction

// Compute raw mem addr that holds a given fabric addr
function Raw_Mem_Addr fn_addr_to_raw_mem_addr (Fabric_Addr addr);
   Fabric_Addr a1 = addr >> log2 (bytes_per_raw_mem_word);
   return truncate (a1);
endfunction

// Compute # of raw mem words from base to lim fabric addrs
function Raw_Mem_Addr fn_raw_mem_words_per_mem (Fabric_Addr base, Fabric_Addr lim);
   return fn_addr_to_raw_mem_addr (lim - base);
endfunction

// ================================================================
// Local constants and types

typedef 26 NBPipe;

// Module state
typedef enum {STATE_POWER_ON_RESET,
	      STATE_READY
   } State
deriving (Bits, Eq, FShow);

// ================================================================
// Interface

interface UltraRAM_IFC;
   // Reset
   interface Server #(Bit #(0), Bit #(0)) server_reset;

   // set_addr_map should be called after this module's reset
   method Action set_addr_map (Fabric_Addr addr_base, Fabric_Addr addr_lim);

   // Main Fabric Reqs/Rsps
   interface AXI4_Slave_IFC #(Wd_Id, Wd_Addr, Wd_Data, Wd_User) slave;
endinterface

// ================================================================
// AXI4 has independent read and write channels and does not specify
// which one should be prioritized if requests are available on both
// channels.  We merge them into a single queue.

typedef enum { REQ_OP_RD, REQ_OP_WR } Req_Op
deriving (Bits, Eq, FShow);

typedef struct {Req_Op                     req_op;

		// AW and AR channel info
		Fabric_Id                  id;
		Fabric_Addr                addr;
		AXI4_Len                   len;
		AXI4_Size                  size;
		AXI4_Burst                 burst;
		AXI4_Lock                  lock;
		AXI4_Cache                 cache;
		AXI4_Prot                  prot;
		AXI4_QoS                   qos;
		AXI4_Region                region;
		Bit #(Wd_User)             user;

		// Write data info
		Bit #(TDiv #(Wd_Data, 8))  wstrb;
		Fabric_Data                data;
   } Req
deriving (Bits, FShow);

// ================================================================

(* synthesize *)
module mkUltraRAM (UltraRAM_IFC);

   // verbosity 0: quiet
   // verbosity 1: reset, initialized
   // verbosity 2: reads, writes
   // verbosity 3: more detail of local raw_mem interactions
   Reg #(Bit #(4)) cfg_verbosity <- mkConfigReg (1);

   Reg #(State)       rg_state     <- mkReg (STATE_POWER_ON_RESET);
   Reg #(Fabric_Addr) rg_addr_base <- mkRegU;
   Reg #(Fabric_Addr) rg_addr_lim  <- mkRegU;

   FIFOF #(Bit #(0)) f_reset_reqs <- mkFIFOF;
   FIFOF #(Bit #(0)) f_reset_rsps <- mkFIFOF;

   // Memory
   URAM_PORT_BE#(Raw_Mem_Addr, Fabric_Data, Bit #(TDiv #(Wd_Data, 8))) memory
                                                 <- vURAM1BE(valueof(NBPipe));

   // Communication with fabric
   AXI4_Slave_Xactor_IFC #(Wd_Id, Wd_Addr, Wd_Data, Wd_User) slave_xactor <- mkAXI4_Slave_Xactor;

   // Requests merged from the (WrA, WrD) and RdA channels
   FIFOF #(Req) f_reqs <- mkPipelineFIFOF;

   // Pipeline for AXI4 rresp values (True: okay, False: slverr, Invalid: none)
   Vector #(TAdd#(NBPipe,2), Reg #(Maybe #(Bool))) rresp_pipe <- replicateM(mkReg(Invalid));

   // ================================================================
   // BEHAVIOR

   (* no_implicit_conditions, fire_when_enabled *)
   rule rl_move_rresp_pipe;
      Integer n;
      for (n=0; n <= valueof(NBPipe); n=n+1)
	 rresp_pipe[n+1] <= rresp_pipe[n];
   endrule
   // ----------------------------------------------------------------
   // Reset

   function Action fa_reset_actions;
      action
	 slave_xactor.reset;
      endaction
   endfunction

   rule rl_power_on_reset (rg_state == STATE_POWER_ON_RESET);
      if (cfg_verbosity > 1)
	 $display ("%0d: UltraRAM.rl_power_on_reset", cur_cycle);
      fa_reset_actions ();
      rg_state <= STATE_READY;
   endrule

   rule rl_external_reset (rg_state == STATE_READY);
      if (cfg_verbosity > 1)
	 $display ("%0d: UltraRAM.rl_external_reset => STATE_RESET_RELOAD_CACHE", cur_cycle);
      f_reset_reqs.deq;
      fa_reset_actions ();
      f_reset_rsps.enq (?);
   endrule

   // ----------------------------------------------------------------
   // Merge requests into a single queue, prioritizing reads over writes

   rule rl_merge_rd_req;
      let rda <- pop_o (slave_xactor.o_rd_addr);
      let req = Req {req_op:     REQ_OP_RD,
		     id:         rda.arid,
		     addr:       rda.araddr,
		     len:        rda.arlen,
		     size:       rda.arsize,
		     burst:      rda.arburst,
		     lock:       rda.arlock,
		     cache:      rda.arcache,
		     prot:       rda.arprot,
		     qos:        rda.arqos,
		     region:     rda.arregion,
		     user:       rda.aruser,
		     wstrb:      ?,
		     data:       ?};
      f_reqs.enq (req);

      if (cfg_verbosity > 2) begin
	 $display ("%0d: UltraRAM.rl_merge_rd_req", cur_cycle);
	 $display ("        ", fshow (rda));
      end
   endrule

   (* descending_urgency = "rl_merge_rd_req, rl_merge_wr_req" *)
   rule rl_merge_wr_req;
      let wra <- pop_o (slave_xactor.o_wr_addr);
      let wrd <- pop_o (slave_xactor.o_wr_data);
      let req = Req {req_op:     REQ_OP_WR,
		     id:         wra.awid,
		     addr:       wra.awaddr,
		     len:        wra.awlen,
		     size:       wra.awsize,
		     burst:      wra.awburst,
		     lock:       wra.awlock,
		     cache:      wra.awcache,
		     prot:       wra.awprot,
		     qos:        wra.awqos,
		     region:     wra.awregion,
		     user:       wra.awuser,
		     wstrb:      wrd.wstrb,
		     data:       wrd.wdata};
      f_reqs.enq (req);

      if (cfg_verbosity > 2) begin
	 $display ("%0d: UltraRAM.rl_merge_wr_req", cur_cycle);
	 $display ("        ", fshow (wra));
	 $display ("        ", fshow (wrd));
      end
   endrule

   // ----------------------------------------------------------------
   // Handle request from fabric

   let req_byte_offset  = f_reqs.first.addr - rg_addr_base;    // within this memory unit
   Raw_Mem_Addr req_raw_mem_addr = fn_addr_to_raw_mem_addr (req_byte_offset);

   // ----------------------------------------------------------------
   // READS

   FIFO #(Bit #(Wd_Id)) ff_id <- mkSizedFIFO (8); // TODO: tune this number

   (* preempts = "rl_external_reset, rl_process_rd_req" *)
   rule rl_process_rd_req  (   (rg_state == STATE_READY)
			    && fn_addr_is_ok (rg_addr_base, f_reqs.first.addr, rg_addr_lim, f_reqs.first.size)
			    && (f_reqs.first.req_op == REQ_OP_RD));

      memory.put(0, req_raw_mem_addr, (?));
      rresp_pipe[0] <= tagged Valid True;
      ff_id.enq(f_reqs.first.id);
      f_reqs.deq;

      if (cfg_verbosity > 1) begin
	 $display ("%0d: UltraRAM.rl_process_rd_req: ", cur_cycle);
	 $display ("        ", fshow (f_reqs.first));
      end
   endrule

   rule rl_invalid_rd_address (   (rg_state == STATE_READY)
			       && (! fn_addr_is_ok (rg_addr_base, f_reqs.first.addr, rg_addr_lim, f_reqs.first.size))
			       && (f_reqs.first.req_op == REQ_OP_RD));
      Fabric_Data rdata = zeroExtend (f_reqs.first.addr);

      f_reqs.deq;
      rresp_pipe[0] <= tagged Valid False;

      $write ("%0d: ERROR: UltraRAM:", cur_cycle);
      if (! fn_addr_is_aligned (f_reqs.first.addr, f_reqs.first.size))
	 $display (" read-addr is misaligned");
      else
	 $display (" read-addr is out of bounds");
      $display ("        rg_addr_base 0x%0h  rg_addr_lim 0x%0h", rg_addr_base, rg_addr_lim);
      $display ("        ", fshow (f_reqs.first));
   endrule

   (* preempts = "rl_process_rd_req,     rl_null_rd_req" *)
   (* preempts = "rl_invalid_rd_address, rl_null_rd_req" *)
   rule rl_null_rd_req;
      rresp_pipe[0] <= tagged Invalid;
   endrule

   // TODO: Dangerous! Assumes that there's always space in the slave_xactor
   // i_rd_data FIFO.  Prove or fix.
   rule rl_process_rd_rsp  (rg_state == STATE_READY &&&
			    rresp_pipe[valueof(NBPipe)+1] matches tagged Valid .ok);

      let rdr = AXI4_Rd_Data {rid:   ff_id.first,
			      rdata: memory.read(),
			      rresp: (ok ? axi4_resp_okay : axi4_resp_slverr),
			      rlast: True,
			      ruser: 0}; // TODO
      ff_id.deq;
      slave_xactor.i_rd_data.enq(rdr);

      if (cfg_verbosity > 1) begin
	 $display ("%0d: UltraRAM.rl_process_rd_rsp: ", cur_cycle);
	 $display ("        ", fshow ((AXI4_Rd_Data#(Wd_Id,Wd_Data,Wd_User))'(rdr)));
      end
   endrule

   // ----------------------------------------------------------------
   // WRITES

   rule rl_process_wr_req  (   (rg_state == STATE_READY)
			    && fn_addr_is_ok (rg_addr_base, f_reqs.first.addr, rg_addr_lim, f_reqs.first.size)
			    && (f_reqs.first.req_op == REQ_OP_WR));
      // Lane-adjust the new word64
      Bit #(64) word64_new = zeroExtend (f_reqs.first.data);
      Bit #(8)  strobe     = zeroExtend (f_reqs.first.wstrb);
      if ((valueOf (Wd_Data) == 32) && (f_reqs.first.addr [2] == 1'b1)) begin
	 // Upper 32b only
	 word64_new = { word64_new [31:0], 0 };
	 strobe     = { strobe     [3:0],  0 };
      end

      memory.put(strobe, req_raw_mem_addr, word64_new);

      let wrr = AXI4_Wr_Resp {bid:   f_reqs.first.id,
			      bresp: axi4_resp_okay,
			      buser: f_reqs.first.user};
      slave_xactor.i_wr_resp.enq (wrr);
      f_reqs.deq;

      if (cfg_verbosity > 1) begin
	 $display ("%0d: UltraRAM.rl_process_wr_req: ", cur_cycle);
	 $display ("        ", fshow (f_reqs.first));
      end
   endrule

   rule rl_invalid_wr_address (   (rg_state == STATE_READY)
			       && (! fn_addr_is_ok (rg_addr_base, f_reqs.first.addr, rg_addr_lim, f_reqs.first.size))
			       && (f_reqs.first.req_op == REQ_OP_WR));
      let wrr = AXI4_Wr_Resp {bid:   f_reqs.first.id,
			      bresp: axi4_resp_slverr,
			      buser: f_reqs.first.user};
      slave_xactor.i_wr_resp.enq (wrr);
      f_reqs.deq;

      $write ("%0d: ERROR: UltraRAM:", cur_cycle);
      if (! fn_addr_is_aligned (f_reqs.first.addr, f_reqs.first.size))
	 $display (" write-addr is misaligned");
      else
	 $display (" write-addr is out of bounds");
      $display ("        rg_addr_base 0x%0h  rg_addr_lim 0x%0h", rg_addr_base, rg_addr_lim);
      $display ("        ", fshow (f_reqs.first));
      $display ("     => ", fshow (wrr));
   endrule

   // ================================================================
   // INTERFACE

   // Reset
   interface  server_reset = toGPServer (f_reset_reqs, f_reset_rsps);

   // set_addr_map should be called after this module's reset
   method Action  set_addr_map (Fabric_Addr addr_base, Fabric_Addr addr_lim) if (rg_state == STATE_READY);
      rg_addr_base <= addr_base;
      rg_addr_lim  <= addr_lim;
      $display ("%0d: UltraRAM.set_addr_map: addr_base 0x%0h addr_lim 0x%0h",
		cur_cycle, addr_base, addr_lim);
   endmethod

   // Main Fabric Reqs/Rsps
   interface  slave = slave_xactor.axi_side;
endmodule

// ================================================================

endpackage
