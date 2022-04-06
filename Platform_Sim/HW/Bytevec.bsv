// This file was auto-generated from spec file 'AWS_FPGA_Spec'

package Bytevec;

import Vector     :: *;
import FIFOF      :: *;
import Semi_FIFOF :: *;


// ================================================================
// Size on the wire: 18 bytes

typedef struct {
    Bit #(16)       awid;    // 2 bytes
    Bit #(64)       awaddr;    // 8 bytes
    Bit #(8)        awlen;    // 1 bytes
    Bit #(3)        awsize;    // 1 bytes
    Bit #(2)        awburst;    // 1 bytes
    Bit #(1)        awlock;    // 1 bytes
    Bit #(4)        awcache;    // 1 bytes
    Bit #(3)        awprot;    // 1 bytes
    Bit #(4)        awqos;    // 1 bytes
    Bit #(4)        awregion;    // 1 bytes
    Bit #(0)        awuser;    // 0 bytes
} AXI4_Wr_Addr_i16_a64_u0
deriving (Bits, FShow);

// ================================================================
// Size on the wire: 73 bytes

typedef struct {
    Bit #(512)      wdata;    // 64 bytes
    Bit #(64)       wstrb;    // 8 bytes
    Bit #(1)        wlast;    // 1 bytes
    Bit #(0)        wuser;    // 0 bytes
} AXI4_Wr_Data_d512_u0
deriving (Bits, FShow);

// ================================================================
// Size on the wire: 18 bytes

typedef struct {
    Bit #(16)       arid;    // 2 bytes
    Bit #(64)       araddr;    // 8 bytes
    Bit #(8)        arlen;    // 1 bytes
    Bit #(3)        arsize;    // 1 bytes
    Bit #(2)        arburst;    // 1 bytes
    Bit #(1)        arlock;    // 1 bytes
    Bit #(4)        arcache;    // 1 bytes
    Bit #(3)        arprot;    // 1 bytes
    Bit #(4)        arqos;    // 1 bytes
    Bit #(4)        arregion;    // 1 bytes
    Bit #(0)        aruser;    // 0 bytes
} AXI4_Rd_Addr_i16_a64_u0
deriving (Bits, FShow);

// ================================================================
// Size on the wire: 5 bytes

typedef struct {
    Bit #(32)       awaddr;    // 4 bytes
    Bit #(3)        awprot;    // 1 bytes
    Bit #(0)        awuser;    // 0 bytes
} AXI4L_Wr_Addr_a32_u0
deriving (Bits, FShow);

// ================================================================
// Size on the wire: 5 bytes

typedef struct {
    Bit #(32)       wdata;    // 4 bytes
    Bit #(4)        wstrb;    // 1 bytes
} AXI4L_Wr_Data_d32
deriving (Bits, FShow);

// ================================================================
// Size on the wire: 5 bytes

typedef struct {
    Bit #(32)       araddr;    // 4 bytes
    Bit #(3)        arprot;    // 1 bytes
    Bit #(0)        aruser;    // 0 bytes
} AXI4L_Rd_Addr_a32_u0
deriving (Bits, FShow);

// ================================================================
// Size on the wire: 3 bytes

typedef struct {
    Bit #(16)       bid;    // 2 bytes
    Bit #(2)        bresp;    // 1 bytes
    Bit #(0)        buser;    // 0 bytes
} AXI4_Wr_Resp_i16_u0
deriving (Bits, FShow);

// ================================================================
// Size on the wire: 68 bytes

typedef struct {
    Bit #(16)       rid;    // 2 bytes
    Bit #(512)      rdata;    // 64 bytes
    Bit #(2)        rresp;    // 1 bytes
    Bit #(1)        rlast;    // 1 bytes
    Bit #(0)        ruser;    // 0 bytes
} AXI4_Rd_Data_i16_d512_u0
deriving (Bits, FShow);

// ================================================================
// Size on the wire: 1 bytes

typedef struct {
    Bit #(2)        bresp;    // 1 bytes
    Bit #(0)        buser;    // 0 bytes
} AXI4L_Wr_Resp_u0
deriving (Bits, FShow);

// ================================================================
// Size on the wire: 5 bytes

typedef struct {
    Bit #(32)       rdata;    // 4 bytes
    Bit #(2)        rresp;    // 1 bytes
    Bit #(0)        ruser;    // 0 bytes
} AXI4L_Rd_Data_d32_u0
deriving (Bits, FShow);

// ================================================================
// Bytevecs

typedef  79  Bytevec_C_to_BSV_Size;
Integer  bytevec_C_to_BSV_size = 79;
typedef  Vector #(Bytevec_C_to_BSV_Size, Bit #(8))  Bytevec_C_to_BSV;

typedef  76  BSV_to_C_Bytevec_Size;
Integer  bytevec_BSV_to_C_size = 76;
typedef  Vector #(BSV_to_C_Bytevec_Size, Bit #(8))  BSV_to_C_Bytevec;

// ================================================================
// INTERFACE

interface Bytevec_IFC;
    // ---------------- Facing BSV
    // C to BSV
    interface FIFOF_O #(AXI4_Wr_Addr_i16_a64_u0)  fo_AXI4_Wr_Addr_i16_a64_u0;
    interface FIFOF_O #(AXI4_Wr_Data_d512_u0)     fo_AXI4_Wr_Data_d512_u0;
    interface FIFOF_O #(AXI4_Rd_Addr_i16_a64_u0)  fo_AXI4_Rd_Addr_i16_a64_u0;
    interface FIFOF_O #(AXI4L_Wr_Addr_a32_u0)     fo_AXI4L_Wr_Addr_a32_u0;
    interface FIFOF_O #(AXI4L_Wr_Data_d32)        fo_AXI4L_Wr_Data_d32;
    interface FIFOF_O #(AXI4L_Rd_Addr_a32_u0)     fo_AXI4L_Rd_Addr_a32_u0;

    // BSV to C
    interface FIFOF_I #(AXI4_Wr_Resp_i16_u0)       fi_AXI4_Wr_Resp_i16_u0;
    interface FIFOF_I #(AXI4_Rd_Data_i16_d512_u0)  fi_AXI4_Rd_Data_i16_d512_u0;
    interface FIFOF_I #(AXI4L_Wr_Resp_u0)          fi_AXI4L_Wr_Resp_u0;
    interface FIFOF_I #(AXI4L_Rd_Data_d32_u0)      fi_AXI4L_Rd_Data_d32_u0;

    // ---------------- Facing C
    interface FIFOF_I #(Bytevec_C_to_BSV) fi_C_to_BSV_bytevec;
    interface FIFOF_O #(BSV_to_C_Bytevec) fo_BSV_to_C_bytevec;
endinterface

// ================================================================

(* synthesize *)
module mkBytevec (Bytevec_IFC);
   Integer verbosity = 0;

   // FIFOs and credit counters for C_to_BSV
   FIFOF #(Bytevec_C_to_BSV) f_C_to_BSV_bytevec <- mkFIFOF;

   FIFOF #(AXI4_Wr_Addr_i16_a64_u0) f_AXI4_Wr_Addr_i16_a64_u0 <- mkSizedFIFOF (128);
   Reg #(Bit #(8)) rg_credits_AXI4_Wr_Addr_i16_a64_u0 <- mkReg (128);

   FIFOF #(AXI4_Wr_Data_d512_u0) f_AXI4_Wr_Data_d512_u0 <- mkSizedFIFOF (128);
   Reg #(Bit #(8)) rg_credits_AXI4_Wr_Data_d512_u0 <- mkReg (128);

   FIFOF #(AXI4_Rd_Addr_i16_a64_u0) f_AXI4_Rd_Addr_i16_a64_u0 <- mkSizedFIFOF (128);
   Reg #(Bit #(8)) rg_credits_AXI4_Rd_Addr_i16_a64_u0 <- mkReg (128);

   FIFOF #(AXI4L_Wr_Addr_a32_u0) f_AXI4L_Wr_Addr_a32_u0 <- mkSizedFIFOF (128);
   Reg #(Bit #(8)) rg_credits_AXI4L_Wr_Addr_a32_u0 <- mkReg (128);

   FIFOF #(AXI4L_Wr_Data_d32) f_AXI4L_Wr_Data_d32 <- mkSizedFIFOF (128);
   Reg #(Bit #(8)) rg_credits_AXI4L_Wr_Data_d32 <- mkReg (128);

   FIFOF #(AXI4L_Rd_Addr_a32_u0) f_AXI4L_Rd_Addr_a32_u0 <- mkSizedFIFOF (128);
   Reg #(Bit #(8)) rg_credits_AXI4L_Rd_Addr_a32_u0 <- mkReg (128);

   // FIFOs and credit counters for BSV_to_C
   FIFOF #(BSV_to_C_Bytevec) f_BSV_to_C_bytevec <- mkFIFOF;

   FIFOF #(AXI4_Wr_Resp_i16_u0) f_AXI4_Wr_Resp_i16_u0 <- mkFIFOF;
   Reg #(Bit #(8)) rg_credits_AXI4_Wr_Resp_i16_u0 <- mkReg (0);

   FIFOF #(AXI4_Rd_Data_i16_d512_u0) f_AXI4_Rd_Data_i16_d512_u0 <- mkFIFOF;
   Reg #(Bit #(8)) rg_credits_AXI4_Rd_Data_i16_d512_u0 <- mkReg (0);

   FIFOF #(AXI4L_Wr_Resp_u0) f_AXI4L_Wr_Resp_u0 <- mkFIFOF;
   Reg #(Bit #(8)) rg_credits_AXI4L_Wr_Resp_u0 <- mkReg (0);

   FIFOF #(AXI4L_Rd_Data_d32_u0) f_AXI4L_Rd_Data_d32_u0 <- mkFIFOF;
   Reg #(Bit #(8)) rg_credits_AXI4L_Rd_Data_d32_u0 <- mkReg (0);

   // ================================================================
   // BEHAVIOR: C to BSV packets

   let bytevec_C_to_BSV = f_C_to_BSV_bytevec.first;

   rule rl_debug_bytevec_C_to_BSV (False);
      $write ("Bytevec.rl_debug\n  ");
      for (Integer j = 0; j < valueOf (Bytevec_C_to_BSV_Size); j = j + 1)
         if (fromInteger (j) < bytevec_C_to_BSV [0])
            $write (" %02h", bytevec_C_to_BSV [j]);
      $display ("\n");
   endrule

   // Common function to restore credits for BSV-to-C channels
   function Action restore_credits_for_BSV_to_C ();
      action
         rg_credits_AXI4_Wr_Resp_i16_u0 <= rg_credits_AXI4_Wr_Resp_i16_u0 + bytevec_C_to_BSV [1];
         rg_credits_AXI4_Rd_Data_i16_d512_u0 <= rg_credits_AXI4_Rd_Data_i16_d512_u0 + bytevec_C_to_BSV [2];
         rg_credits_AXI4L_Wr_Resp_u0 <= rg_credits_AXI4L_Wr_Resp_u0 + bytevec_C_to_BSV [3];
         rg_credits_AXI4L_Rd_Data_d32_u0 <= rg_credits_AXI4L_Rd_Data_d32_u0 + bytevec_C_to_BSV [4];
      endaction
   endfunction

   rule rl_C_to_BSV_credits_only (bytevec_C_to_BSV [5] == 0);

      restore_credits_for_BSV_to_C;

      f_C_to_BSV_bytevec.deq;
      if (verbosity != 0)
         $display ("Bytevec.rl_C_to_BSV_credits_only");
   endrule

   rule rl_C_to_BSV_AXI4_Wr_Addr_i16_a64_u0 (bytevec_C_to_BSV [5] == 1);

      restore_credits_for_BSV_to_C;

      // Build a C-to-BSV struct from the bytevec

      let s = AXI4_Wr_Addr_i16_a64_u0 {
                  awid : truncate ({ bytevec_C_to_BSV [7],
                                     bytevec_C_to_BSV [6] } ),
                  awaddr : truncate ({ bytevec_C_to_BSV [15],
                                       bytevec_C_to_BSV [14],
                                       bytevec_C_to_BSV [13],
                                       bytevec_C_to_BSV [12],
                                       bytevec_C_to_BSV [11],
                                       bytevec_C_to_BSV [10],
                                       bytevec_C_to_BSV [9],
                                       bytevec_C_to_BSV [8] } ),
                  awlen : truncate (bytevec_C_to_BSV [16]),
                  awsize : truncate (bytevec_C_to_BSV [17]),
                  awburst : truncate (bytevec_C_to_BSV [18]),
                  awlock : truncate (bytevec_C_to_BSV [19]),
                  awcache : truncate (bytevec_C_to_BSV [20]),
                  awprot : truncate (bytevec_C_to_BSV [21]),
                  awqos : truncate (bytevec_C_to_BSV [22]),
                  awregion : truncate (bytevec_C_to_BSV [23]),
                  awuser : ? };

      // Enqueue the C-to-BSV struct and dequeue the bytevec
      f_AXI4_Wr_Addr_i16_a64_u0.enq (s);
      f_C_to_BSV_bytevec.deq;
      if (verbosity != 0)
         $display ("Bytevec: received AXI4_Wr_Addr_i16_a64_u0: ", fshow (s));
   endrule

   rule rl_C_to_BSV_AXI4_Wr_Data_d512_u0 (bytevec_C_to_BSV [5] == 2);

      restore_credits_for_BSV_to_C;

      // Build a C-to-BSV struct from the bytevec

      let s = AXI4_Wr_Data_d512_u0 {
                  wdata : truncate ({ bytevec_C_to_BSV [69],
                                      bytevec_C_to_BSV [68],
                                      bytevec_C_to_BSV [67],
                                      bytevec_C_to_BSV [66],
                                      bytevec_C_to_BSV [65],
                                      bytevec_C_to_BSV [64],
                                      bytevec_C_to_BSV [63],
                                      bytevec_C_to_BSV [62],
                                      bytevec_C_to_BSV [61],
                                      bytevec_C_to_BSV [60],
                                      bytevec_C_to_BSV [59],
                                      bytevec_C_to_BSV [58],
                                      bytevec_C_to_BSV [57],
                                      bytevec_C_to_BSV [56],
                                      bytevec_C_to_BSV [55],
                                      bytevec_C_to_BSV [54],
                                      bytevec_C_to_BSV [53],
                                      bytevec_C_to_BSV [52],
                                      bytevec_C_to_BSV [51],
                                      bytevec_C_to_BSV [50],
                                      bytevec_C_to_BSV [49],
                                      bytevec_C_to_BSV [48],
                                      bytevec_C_to_BSV [47],
                                      bytevec_C_to_BSV [46],
                                      bytevec_C_to_BSV [45],
                                      bytevec_C_to_BSV [44],
                                      bytevec_C_to_BSV [43],
                                      bytevec_C_to_BSV [42],
                                      bytevec_C_to_BSV [41],
                                      bytevec_C_to_BSV [40],
                                      bytevec_C_to_BSV [39],
                                      bytevec_C_to_BSV [38],
                                      bytevec_C_to_BSV [37],
                                      bytevec_C_to_BSV [36],
                                      bytevec_C_to_BSV [35],
                                      bytevec_C_to_BSV [34],
                                      bytevec_C_to_BSV [33],
                                      bytevec_C_to_BSV [32],
                                      bytevec_C_to_BSV [31],
                                      bytevec_C_to_BSV [30],
                                      bytevec_C_to_BSV [29],
                                      bytevec_C_to_BSV [28],
                                      bytevec_C_to_BSV [27],
                                      bytevec_C_to_BSV [26],
                                      bytevec_C_to_BSV [25],
                                      bytevec_C_to_BSV [24],
                                      bytevec_C_to_BSV [23],
                                      bytevec_C_to_BSV [22],
                                      bytevec_C_to_BSV [21],
                                      bytevec_C_to_BSV [20],
                                      bytevec_C_to_BSV [19],
                                      bytevec_C_to_BSV [18],
                                      bytevec_C_to_BSV [17],
                                      bytevec_C_to_BSV [16],
                                      bytevec_C_to_BSV [15],
                                      bytevec_C_to_BSV [14],
                                      bytevec_C_to_BSV [13],
                                      bytevec_C_to_BSV [12],
                                      bytevec_C_to_BSV [11],
                                      bytevec_C_to_BSV [10],
                                      bytevec_C_to_BSV [9],
                                      bytevec_C_to_BSV [8],
                                      bytevec_C_to_BSV [7],
                                      bytevec_C_to_BSV [6] } ),
                  wstrb : truncate ({ bytevec_C_to_BSV [77],
                                      bytevec_C_to_BSV [76],
                                      bytevec_C_to_BSV [75],
                                      bytevec_C_to_BSV [74],
                                      bytevec_C_to_BSV [73],
                                      bytevec_C_to_BSV [72],
                                      bytevec_C_to_BSV [71],
                                      bytevec_C_to_BSV [70] } ),
                  wlast : truncate (bytevec_C_to_BSV [78]),
                  wuser : ? };

      // Enqueue the C-to-BSV struct and dequeue the bytevec
      f_AXI4_Wr_Data_d512_u0.enq (s);
      f_C_to_BSV_bytevec.deq;
      if (verbosity != 0)
         $display ("Bytevec: received AXI4_Wr_Data_d512_u0: ", fshow (s));
   endrule

   rule rl_C_to_BSV_AXI4_Rd_Addr_i16_a64_u0 (bytevec_C_to_BSV [5] == 3);

      restore_credits_for_BSV_to_C;

      // Build a C-to-BSV struct from the bytevec

      let s = AXI4_Rd_Addr_i16_a64_u0 {
                  arid : truncate ({ bytevec_C_to_BSV [7],
                                     bytevec_C_to_BSV [6] } ),
                  araddr : truncate ({ bytevec_C_to_BSV [15],
                                       bytevec_C_to_BSV [14],
                                       bytevec_C_to_BSV [13],
                                       bytevec_C_to_BSV [12],
                                       bytevec_C_to_BSV [11],
                                       bytevec_C_to_BSV [10],
                                       bytevec_C_to_BSV [9],
                                       bytevec_C_to_BSV [8] } ),
                  arlen : truncate (bytevec_C_to_BSV [16]),
                  arsize : truncate (bytevec_C_to_BSV [17]),
                  arburst : truncate (bytevec_C_to_BSV [18]),
                  arlock : truncate (bytevec_C_to_BSV [19]),
                  arcache : truncate (bytevec_C_to_BSV [20]),
                  arprot : truncate (bytevec_C_to_BSV [21]),
                  arqos : truncate (bytevec_C_to_BSV [22]),
                  arregion : truncate (bytevec_C_to_BSV [23]),
                  aruser : ? };

      // Enqueue the C-to-BSV struct and dequeue the bytevec
      f_AXI4_Rd_Addr_i16_a64_u0.enq (s);
      f_C_to_BSV_bytevec.deq;
      if (verbosity != 0)
         $display ("Bytevec: received AXI4_Rd_Addr_i16_a64_u0: ", fshow (s));
   endrule

   rule rl_C_to_BSV_AXI4L_Wr_Addr_a32_u0 (bytevec_C_to_BSV [5] == 4);

      restore_credits_for_BSV_to_C;

      // Build a C-to-BSV struct from the bytevec

      let s = AXI4L_Wr_Addr_a32_u0 {
                  awaddr : truncate ({ bytevec_C_to_BSV [9],
                                       bytevec_C_to_BSV [8],
                                       bytevec_C_to_BSV [7],
                                       bytevec_C_to_BSV [6] } ),
                  awprot : truncate (bytevec_C_to_BSV [10]),
                  awuser : ? };

      // Enqueue the C-to-BSV struct and dequeue the bytevec
      f_AXI4L_Wr_Addr_a32_u0.enq (s);
      f_C_to_BSV_bytevec.deq;
      if (verbosity != 0)
         $display ("Bytevec: received AXI4L_Wr_Addr_a32_u0: ", fshow (s));
   endrule

   rule rl_C_to_BSV_AXI4L_Wr_Data_d32 (bytevec_C_to_BSV [5] == 5);

      restore_credits_for_BSV_to_C;

      // Build a C-to-BSV struct from the bytevec

      let s = AXI4L_Wr_Data_d32 {
                  wdata : truncate ({ bytevec_C_to_BSV [9],
                                      bytevec_C_to_BSV [8],
                                      bytevec_C_to_BSV [7],
                                      bytevec_C_to_BSV [6] } ),
                  wstrb : truncate (bytevec_C_to_BSV [10]) };

      // Enqueue the C-to-BSV struct and dequeue the bytevec
      f_AXI4L_Wr_Data_d32.enq (s);
      f_C_to_BSV_bytevec.deq;
      if (verbosity != 0)
         $display ("Bytevec: received AXI4L_Wr_Data_d32: ", fshow (s));
   endrule

   rule rl_C_to_BSV_AXI4L_Rd_Addr_a32_u0 (bytevec_C_to_BSV [5] == 6);

      restore_credits_for_BSV_to_C;

      // Build a C-to-BSV struct from the bytevec

      let s = AXI4L_Rd_Addr_a32_u0 {
                  araddr : truncate ({ bytevec_C_to_BSV [9],
                                       bytevec_C_to_BSV [8],
                                       bytevec_C_to_BSV [7],
                                       bytevec_C_to_BSV [6] } ),
                  arprot : truncate (bytevec_C_to_BSV [10]),
                  aruser : ? };

      // Enqueue the C-to-BSV struct and dequeue the bytevec
      f_AXI4L_Rd_Addr_a32_u0.enq (s);
      f_C_to_BSV_bytevec.deq;
      if (verbosity != 0)
         $display ("Bytevec: received AXI4L_Rd_Addr_a32_u0: ", fshow (s));
   endrule

   // ================================================================
   // BEHAVIOR: BSV to C structs

   // Common function to fill in credits for C_to_BSV channels
   function ActionValue #(BSV_to_C_Bytevec) fill_credits_for_C_to_BSV (BSV_to_C_Bytevec bv);
      actionvalue
         bv [1] = rg_credits_AXI4_Wr_Addr_i16_a64_u0;    rg_credits_AXI4_Wr_Addr_i16_a64_u0 <= 0;
         bv [2] = rg_credits_AXI4_Wr_Data_d512_u0;    rg_credits_AXI4_Wr_Data_d512_u0 <= 0;
         bv [3] = rg_credits_AXI4_Rd_Addr_i16_a64_u0;    rg_credits_AXI4_Rd_Addr_i16_a64_u0 <= 0;
         bv [4] = rg_credits_AXI4L_Wr_Addr_a32_u0;    rg_credits_AXI4L_Wr_Addr_a32_u0 <= 0;
         bv [5] = rg_credits_AXI4L_Wr_Data_d32;    rg_credits_AXI4L_Wr_Data_d32 <= 0;
         bv [6] = rg_credits_AXI4L_Rd_Addr_a32_u0;    rg_credits_AXI4L_Rd_Addr_a32_u0 <= 0;
         return bv;
      endactionvalue
   endfunction

   Bool ready_AXI4_Wr_Resp_i16_u0 =
              (f_AXI4_Wr_Resp_i16_u0.notEmpty
               && (rg_credits_AXI4_Wr_Resp_i16_u0 != 0));

   rule rl_BSV_to_C_AXI4_Wr_Resp_i16_u0 (ready_AXI4_Wr_Resp_i16_u0);
      BSV_to_C_Bytevec bytevec_BSV_to_C = replicate (0);
      bytevec_BSV_to_C [0] = 11;

      bytevec_BSV_to_C <- fill_credits_for_C_to_BSV (bytevec_BSV_to_C);

      bytevec_BSV_to_C [7] = 1;

      // Unpack the BSV-to-C struct into the bytevec
      let s = f_AXI4_Wr_Resp_i16_u0.first;
      f_AXI4_Wr_Resp_i16_u0.deq;
      bytevec_BSV_to_C [8] = zeroExtend (s.bid [7:0]);
      bytevec_BSV_to_C [9] = zeroExtend (s.bid [15:8]);
      bytevec_BSV_to_C [10] = zeroExtend (s.bresp [1:0]);

      // Send the bytevec to C
      f_BSV_to_C_bytevec.enq (bytevec_BSV_to_C);
      rg_credits_AXI4_Wr_Resp_i16_u0 <= rg_credits_AXI4_Wr_Resp_i16_u0 - 1;
      if (verbosity != 0)
         $display ("Bytevec: sent: ", fshow (s));
   endrule

   Bool ready_AXI4_Rd_Data_i16_d512_u0 =
              (f_AXI4_Rd_Data_i16_d512_u0.notEmpty
               && (rg_credits_AXI4_Rd_Data_i16_d512_u0 != 0));

   rule rl_BSV_to_C_AXI4_Rd_Data_i16_d512_u0 (ready_AXI4_Rd_Data_i16_d512_u0);
      BSV_to_C_Bytevec bytevec_BSV_to_C = replicate (0);
      bytevec_BSV_to_C [0] = 76;

      bytevec_BSV_to_C <- fill_credits_for_C_to_BSV (bytevec_BSV_to_C);

      bytevec_BSV_to_C [7] = 2;

      // Unpack the BSV-to-C struct into the bytevec
      let s = f_AXI4_Rd_Data_i16_d512_u0.first;
      f_AXI4_Rd_Data_i16_d512_u0.deq;
      bytevec_BSV_to_C [8] = zeroExtend (s.rid [7:0]);
      bytevec_BSV_to_C [9] = zeroExtend (s.rid [15:8]);
      bytevec_BSV_to_C [10] = zeroExtend (s.rdata [7:0]);
      bytevec_BSV_to_C [11] = zeroExtend (s.rdata [15:8]);
      bytevec_BSV_to_C [12] = zeroExtend (s.rdata [23:16]);
      bytevec_BSV_to_C [13] = zeroExtend (s.rdata [31:24]);
      bytevec_BSV_to_C [14] = zeroExtend (s.rdata [39:32]);
      bytevec_BSV_to_C [15] = zeroExtend (s.rdata [47:40]);
      bytevec_BSV_to_C [16] = zeroExtend (s.rdata [55:48]);
      bytevec_BSV_to_C [17] = zeroExtend (s.rdata [63:56]);
      bytevec_BSV_to_C [18] = zeroExtend (s.rdata [71:64]);
      bytevec_BSV_to_C [19] = zeroExtend (s.rdata [79:72]);
      bytevec_BSV_to_C [20] = zeroExtend (s.rdata [87:80]);
      bytevec_BSV_to_C [21] = zeroExtend (s.rdata [95:88]);
      bytevec_BSV_to_C [22] = zeroExtend (s.rdata [103:96]);
      bytevec_BSV_to_C [23] = zeroExtend (s.rdata [111:104]);
      bytevec_BSV_to_C [24] = zeroExtend (s.rdata [119:112]);
      bytevec_BSV_to_C [25] = zeroExtend (s.rdata [127:120]);
      bytevec_BSV_to_C [26] = zeroExtend (s.rdata [135:128]);
      bytevec_BSV_to_C [27] = zeroExtend (s.rdata [143:136]);
      bytevec_BSV_to_C [28] = zeroExtend (s.rdata [151:144]);
      bytevec_BSV_to_C [29] = zeroExtend (s.rdata [159:152]);
      bytevec_BSV_to_C [30] = zeroExtend (s.rdata [167:160]);
      bytevec_BSV_to_C [31] = zeroExtend (s.rdata [175:168]);
      bytevec_BSV_to_C [32] = zeroExtend (s.rdata [183:176]);
      bytevec_BSV_to_C [33] = zeroExtend (s.rdata [191:184]);
      bytevec_BSV_to_C [34] = zeroExtend (s.rdata [199:192]);
      bytevec_BSV_to_C [35] = zeroExtend (s.rdata [207:200]);
      bytevec_BSV_to_C [36] = zeroExtend (s.rdata [215:208]);
      bytevec_BSV_to_C [37] = zeroExtend (s.rdata [223:216]);
      bytevec_BSV_to_C [38] = zeroExtend (s.rdata [231:224]);
      bytevec_BSV_to_C [39] = zeroExtend (s.rdata [239:232]);
      bytevec_BSV_to_C [40] = zeroExtend (s.rdata [247:240]);
      bytevec_BSV_to_C [41] = zeroExtend (s.rdata [255:248]);
      bytevec_BSV_to_C [42] = zeroExtend (s.rdata [263:256]);
      bytevec_BSV_to_C [43] = zeroExtend (s.rdata [271:264]);
      bytevec_BSV_to_C [44] = zeroExtend (s.rdata [279:272]);
      bytevec_BSV_to_C [45] = zeroExtend (s.rdata [287:280]);
      bytevec_BSV_to_C [46] = zeroExtend (s.rdata [295:288]);
      bytevec_BSV_to_C [47] = zeroExtend (s.rdata [303:296]);
      bytevec_BSV_to_C [48] = zeroExtend (s.rdata [311:304]);
      bytevec_BSV_to_C [49] = zeroExtend (s.rdata [319:312]);
      bytevec_BSV_to_C [50] = zeroExtend (s.rdata [327:320]);
      bytevec_BSV_to_C [51] = zeroExtend (s.rdata [335:328]);
      bytevec_BSV_to_C [52] = zeroExtend (s.rdata [343:336]);
      bytevec_BSV_to_C [53] = zeroExtend (s.rdata [351:344]);
      bytevec_BSV_to_C [54] = zeroExtend (s.rdata [359:352]);
      bytevec_BSV_to_C [55] = zeroExtend (s.rdata [367:360]);
      bytevec_BSV_to_C [56] = zeroExtend (s.rdata [375:368]);
      bytevec_BSV_to_C [57] = zeroExtend (s.rdata [383:376]);
      bytevec_BSV_to_C [58] = zeroExtend (s.rdata [391:384]);
      bytevec_BSV_to_C [59] = zeroExtend (s.rdata [399:392]);
      bytevec_BSV_to_C [60] = zeroExtend (s.rdata [407:400]);
      bytevec_BSV_to_C [61] = zeroExtend (s.rdata [415:408]);
      bytevec_BSV_to_C [62] = zeroExtend (s.rdata [423:416]);
      bytevec_BSV_to_C [63] = zeroExtend (s.rdata [431:424]);
      bytevec_BSV_to_C [64] = zeroExtend (s.rdata [439:432]);
      bytevec_BSV_to_C [65] = zeroExtend (s.rdata [447:440]);
      bytevec_BSV_to_C [66] = zeroExtend (s.rdata [455:448]);
      bytevec_BSV_to_C [67] = zeroExtend (s.rdata [463:456]);
      bytevec_BSV_to_C [68] = zeroExtend (s.rdata [471:464]);
      bytevec_BSV_to_C [69] = zeroExtend (s.rdata [479:472]);
      bytevec_BSV_to_C [70] = zeroExtend (s.rdata [487:480]);
      bytevec_BSV_to_C [71] = zeroExtend (s.rdata [495:488]);
      bytevec_BSV_to_C [72] = zeroExtend (s.rdata [503:496]);
      bytevec_BSV_to_C [73] = zeroExtend (s.rdata [511:504]);
      bytevec_BSV_to_C [74] = zeroExtend (s.rresp [1:0]);
      bytevec_BSV_to_C [75] = zeroExtend (s.rlast [0:0]);

      // Send the bytevec to C
      f_BSV_to_C_bytevec.enq (bytevec_BSV_to_C);
      rg_credits_AXI4_Rd_Data_i16_d512_u0 <= rg_credits_AXI4_Rd_Data_i16_d512_u0 - 1;
      if (verbosity != 0)
         $display ("Bytevec: sent: ", fshow (s));
   endrule

   Bool ready_AXI4L_Wr_Resp_u0 =
              (f_AXI4L_Wr_Resp_u0.notEmpty
               && (rg_credits_AXI4L_Wr_Resp_u0 != 0));

   rule rl_BSV_to_C_AXI4L_Wr_Resp_u0 (ready_AXI4L_Wr_Resp_u0);
      BSV_to_C_Bytevec bytevec_BSV_to_C = replicate (0);
      bytevec_BSV_to_C [0] = 9;

      bytevec_BSV_to_C <- fill_credits_for_C_to_BSV (bytevec_BSV_to_C);

      bytevec_BSV_to_C [7] = 3;

      // Unpack the BSV-to-C struct into the bytevec
      let s = f_AXI4L_Wr_Resp_u0.first;
      f_AXI4L_Wr_Resp_u0.deq;
      bytevec_BSV_to_C [8] = zeroExtend (s.bresp [1:0]);

      // Send the bytevec to C
      f_BSV_to_C_bytevec.enq (bytevec_BSV_to_C);
      rg_credits_AXI4L_Wr_Resp_u0 <= rg_credits_AXI4L_Wr_Resp_u0 - 1;
      if (verbosity != 0)
         $display ("Bytevec: sent: ", fshow (s));
   endrule

   Bool ready_AXI4L_Rd_Data_d32_u0 =
              (f_AXI4L_Rd_Data_d32_u0.notEmpty
               && (rg_credits_AXI4L_Rd_Data_d32_u0 != 0));

   rule rl_BSV_to_C_AXI4L_Rd_Data_d32_u0 (ready_AXI4L_Rd_Data_d32_u0);
      BSV_to_C_Bytevec bytevec_BSV_to_C = replicate (0);
      bytevec_BSV_to_C [0] = 13;

      bytevec_BSV_to_C <- fill_credits_for_C_to_BSV (bytevec_BSV_to_C);

      bytevec_BSV_to_C [7] = 4;

      // Unpack the BSV-to-C struct into the bytevec
      let s = f_AXI4L_Rd_Data_d32_u0.first;
      f_AXI4L_Rd_Data_d32_u0.deq;
      bytevec_BSV_to_C [8] = zeroExtend (s.rdata [7:0]);
      bytevec_BSV_to_C [9] = zeroExtend (s.rdata [15:8]);
      bytevec_BSV_to_C [10] = zeroExtend (s.rdata [23:16]);
      bytevec_BSV_to_C [11] = zeroExtend (s.rdata [31:24]);
      bytevec_BSV_to_C [12] = zeroExtend (s.rresp [1:0]);

      // Send the bytevec to C
      f_BSV_to_C_bytevec.enq (bytevec_BSV_to_C);
      rg_credits_AXI4L_Rd_Data_d32_u0 <= rg_credits_AXI4L_Rd_Data_d32_u0 - 1;
      if (verbosity != 0)
         $display ("Bytevec: sent: ", fshow (s));
   endrule

   // If no struct to send, send a 'credits-only' bytevec
   rule rl_BSV_to_C_credits_only ((! ready_AXI4_Wr_Resp_i16_u0) &&
                                  (! ready_AXI4_Rd_Data_i16_d512_u0) &&
                                  (! ready_AXI4L_Wr_Resp_u0) &&
                                  (! ready_AXI4L_Rd_Data_d32_u0));
      BSV_to_C_Bytevec  bytevec_BSV_to_C = replicate (0);
      bytevec_BSV_to_C [0] = 8;

      bytevec_BSV_to_C <- fill_credits_for_C_to_BSV (bytevec_BSV_to_C);

      bytevec_BSV_to_C [7] = 0;    // type 0 = credits-only

      // Send the bytevec to C if any non-zero credits
      Bool non_zero = False;
      non_zero = non_zero || (bytevec_BSV_to_C [1] != 0);
      non_zero = non_zero || (bytevec_BSV_to_C [2] != 0);
      non_zero = non_zero || (bytevec_BSV_to_C [3] != 0);
      non_zero = non_zero || (bytevec_BSV_to_C [4] != 0);
      non_zero = non_zero || (bytevec_BSV_to_C [5] != 0);
      non_zero = non_zero || (bytevec_BSV_to_C [6] != 0);
      if (non_zero) begin
         f_BSV_to_C_bytevec.enq (bytevec_BSV_to_C);
         if (verbosity != 0) begin
            $display ("Bytevec.rl_BSV_to_C_credits_only");
            $display ("    %0d AXI4_Wr_Addr_i16_a64_u0", bytevec_BSV_to_C [1]);
            $display ("    %0d AXI4_Wr_Data_d512_u0", bytevec_BSV_to_C [2]);
            $display ("    %0d AXI4_Rd_Addr_i16_a64_u0", bytevec_BSV_to_C [3]);
            $display ("    %0d AXI4L_Wr_Addr_a32_u0", bytevec_BSV_to_C [4]);
            $display ("    %0d AXI4L_Wr_Data_d32", bytevec_BSV_to_C [5]);
            $display ("    %0d AXI4L_Rd_Addr_a32_u0", bytevec_BSV_to_C [6]);
         end
      end
   endrule

   // Bogus rule, just for anchoring this urgency attribute
   (* descending_urgency = "rl_C_to_BSV_AXI4_Wr_Addr_i16_a64_u0, rl_C_to_BSV_AXI4_Wr_Data_d512_u0, rl_C_to_BSV_AXI4_Rd_Addr_i16_a64_u0, rl_C_to_BSV_AXI4L_Wr_Addr_a32_u0, rl_C_to_BSV_AXI4L_Wr_Data_d32, rl_C_to_BSV_AXI4L_Rd_Addr_a32_u0, rl_BSV_to_C_AXI4_Wr_Resp_i16_u0, rl_BSV_to_C_AXI4_Rd_Data_i16_d512_u0, rl_BSV_to_C_AXI4L_Wr_Resp_u0, rl_BSV_to_C_AXI4L_Rd_Data_d32_u0, rl_BSV_to_C_credits_only" *)
   rule rl_bogus (False);
      noAction;
   endrule

   // ================================================================
   // INTERFACE

    // ---------------- Facing BSV
    // C to BSV

   interface FIFOF_O fo_AXI4_Wr_Addr_i16_a64_u0;
      method AXI4_Wr_Addr_i16_a64_u0 first;
         return f_AXI4_Wr_Addr_i16_a64_u0.first;
      endmethod
      method Action deq;
         rg_credits_AXI4_Wr_Addr_i16_a64_u0 <= rg_credits_AXI4_Wr_Addr_i16_a64_u0 + 1;
         f_AXI4_Wr_Addr_i16_a64_u0.deq;
      endmethod
      method Bool notEmpty;
         return f_AXI4_Wr_Addr_i16_a64_u0.notEmpty;
      endmethod
   endinterface

   interface FIFOF_O fo_AXI4_Wr_Data_d512_u0;
      method AXI4_Wr_Data_d512_u0 first;
         return f_AXI4_Wr_Data_d512_u0.first;
      endmethod
      method Action deq;
         rg_credits_AXI4_Wr_Data_d512_u0 <= rg_credits_AXI4_Wr_Data_d512_u0 + 1;
         f_AXI4_Wr_Data_d512_u0.deq;
      endmethod
      method Bool notEmpty;
         return f_AXI4_Wr_Data_d512_u0.notEmpty;
      endmethod
   endinterface

   interface FIFOF_O fo_AXI4_Rd_Addr_i16_a64_u0;
      method AXI4_Rd_Addr_i16_a64_u0 first;
         return f_AXI4_Rd_Addr_i16_a64_u0.first;
      endmethod
      method Action deq;
         rg_credits_AXI4_Rd_Addr_i16_a64_u0 <= rg_credits_AXI4_Rd_Addr_i16_a64_u0 + 1;
         f_AXI4_Rd_Addr_i16_a64_u0.deq;
      endmethod
      method Bool notEmpty;
         return f_AXI4_Rd_Addr_i16_a64_u0.notEmpty;
      endmethod
   endinterface

   interface FIFOF_O fo_AXI4L_Wr_Addr_a32_u0;
      method AXI4L_Wr_Addr_a32_u0 first;
         return f_AXI4L_Wr_Addr_a32_u0.first;
      endmethod
      method Action deq;
         rg_credits_AXI4L_Wr_Addr_a32_u0 <= rg_credits_AXI4L_Wr_Addr_a32_u0 + 1;
         f_AXI4L_Wr_Addr_a32_u0.deq;
      endmethod
      method Bool notEmpty;
         return f_AXI4L_Wr_Addr_a32_u0.notEmpty;
      endmethod
   endinterface

   interface FIFOF_O fo_AXI4L_Wr_Data_d32;
      method AXI4L_Wr_Data_d32 first;
         return f_AXI4L_Wr_Data_d32.first;
      endmethod
      method Action deq;
         rg_credits_AXI4L_Wr_Data_d32 <= rg_credits_AXI4L_Wr_Data_d32 + 1;
         f_AXI4L_Wr_Data_d32.deq;
      endmethod
      method Bool notEmpty;
         return f_AXI4L_Wr_Data_d32.notEmpty;
      endmethod
   endinterface

   interface FIFOF_O fo_AXI4L_Rd_Addr_a32_u0;
      method AXI4L_Rd_Addr_a32_u0 first;
         return f_AXI4L_Rd_Addr_a32_u0.first;
      endmethod
      method Action deq;
         rg_credits_AXI4L_Rd_Addr_a32_u0 <= rg_credits_AXI4L_Rd_Addr_a32_u0 + 1;
         f_AXI4L_Rd_Addr_a32_u0.deq;
      endmethod
      method Bool notEmpty;
         return f_AXI4L_Rd_Addr_a32_u0.notEmpty;
      endmethod
   endinterface

    // BSV to C
   interface FIFOF_I fi_AXI4_Wr_Resp_i16_u0 = to_FIFOF_I (f_AXI4_Wr_Resp_i16_u0);
   interface FIFOF_I fi_AXI4_Rd_Data_i16_d512_u0 = to_FIFOF_I (f_AXI4_Rd_Data_i16_d512_u0);
   interface FIFOF_I fi_AXI4L_Wr_Resp_u0 = to_FIFOF_I (f_AXI4L_Wr_Resp_u0);
   interface FIFOF_I fi_AXI4L_Rd_Data_d32_u0 = to_FIFOF_I (f_AXI4L_Rd_Data_d32_u0);

    // ---------------- Facing C
   interface FIFOF_I fi_C_to_BSV_bytevec = to_FIFOF_I (f_C_to_BSV_bytevec);
   interface FIFOF_O fo_BSV_to_C_bytevec = to_FIFOF_O (f_BSV_to_C_bytevec);

endmodule

// ================================================================

endpackage
