// This file was auto-generated from spec file 'AWS_FPGA_Spec'

#pragma once

// ================================================================
// Size on the wire: 18 bytes

typedef struct {
uint16_t      awid;               // 16 bits
uint64_t      awaddr;             // 64 bits
uint8_t       awlen;              // 8 bits
uint8_t       awsize;             // 3 bits
uint8_t       awburst;            // 2 bits
uint8_t       awlock;             // 1 bits
uint8_t       awcache;            // 4 bits
uint8_t       awprot;             // 3 bits
uint8_t       awqos;              // 4 bits
uint8_t       awregion;           // 4 bits
uint8_t       awuser;             // 0 bits
} AXI4_Wr_Addr_i16_a64_u0;

// ================================================================
// Size on the wire: 73 bytes

typedef struct {
uint8_t       wdata [64];         // 512 bits
uint64_t      wstrb;              // 64 bits
uint8_t       wlast;              // 1 bits
uint8_t       wuser;              // 0 bits
} AXI4_Wr_Data_d512_u0;

// ================================================================
// Size on the wire: 18 bytes

typedef struct {
uint16_t      arid;               // 16 bits
uint64_t      araddr;             // 64 bits
uint8_t       arlen;              // 8 bits
uint8_t       arsize;             // 3 bits
uint8_t       arburst;            // 2 bits
uint8_t       arlock;             // 1 bits
uint8_t       arcache;            // 4 bits
uint8_t       arprot;             // 3 bits
uint8_t       arqos;              // 4 bits
uint8_t       arregion;           // 4 bits
uint8_t       aruser;             // 0 bits
} AXI4_Rd_Addr_i16_a64_u0;

// ================================================================
// Size on the wire: 5 bytes

typedef struct {
uint32_t      awaddr;             // 32 bits
uint8_t       awprot;             // 3 bits
uint8_t       awuser;             // 0 bits
} AXI4L_Wr_Addr_a32_u0;

// ================================================================
// Size on the wire: 5 bytes

typedef struct {
uint32_t      wdata;              // 32 bits
uint8_t       wstrb;              // 4 bits
} AXI4L_Wr_Data_d32;

// ================================================================
// Size on the wire: 5 bytes

typedef struct {
uint32_t      araddr;             // 32 bits
uint8_t       arprot;             // 3 bits
uint8_t       aruser;             // 0 bits
} AXI4L_Rd_Addr_a32_u0;

// ================================================================
// Size on the wire: 3 bytes

typedef struct {
uint16_t      bid;                // 16 bits
uint8_t       bresp;              // 2 bits
uint8_t       buser;              // 0 bits
} AXI4_Wr_Resp_i16_u0;

// ================================================================
// Size on the wire: 68 bytes

typedef struct {
uint16_t      rid;                // 16 bits
uint8_t       rdata [64];         // 512 bits
uint8_t       rresp;              // 2 bits
uint8_t       rlast;              // 1 bits
uint8_t       ruser;              // 0 bits
} AXI4_Rd_Data_i16_d512_u0;

// ================================================================
// Size on the wire: 1 bytes

typedef struct {
uint8_t       bresp;              // 2 bits
uint8_t       buser;              // 0 bits
} AXI4L_Wr_Resp_u0;

// ================================================================
// Size on the wire: 5 bytes

typedef struct {
uint32_t      rdata;              // 32 bits
uint8_t       rresp;              // 2 bits
uint8_t       ruser;              // 0 bits
} AXI4L_Rd_Data_d32_u0;

// ================================================================
// Communication state

#define C_TO_BSV_FIFO_SIZE        0x10
#define C_TO_BSV_FIFO_INDEX_MASK  0x0F

#define BSV_TO_C_FIFO_SIZE        0x80
#define BSV_TO_C_FIFO_INDEX_MASK  0x7F

typedef struct {
   // C to BSV queues
   AXI4_Wr_Addr_i16_a64_u0  buf_AXI4_Wr_Addr_i16_a64_u0 [C_TO_BSV_FIFO_SIZE];
   uint64_t head_AXI4_Wr_Addr_i16_a64_u0;
   uint64_t size_AXI4_Wr_Addr_i16_a64_u0;
   uint64_t credits_AXI4_Wr_Addr_i16_a64_u0;

   AXI4_Wr_Data_d512_u0  buf_AXI4_Wr_Data_d512_u0 [C_TO_BSV_FIFO_SIZE];
   uint64_t head_AXI4_Wr_Data_d512_u0;
   uint64_t size_AXI4_Wr_Data_d512_u0;
   uint64_t credits_AXI4_Wr_Data_d512_u0;

   AXI4_Rd_Addr_i16_a64_u0  buf_AXI4_Rd_Addr_i16_a64_u0 [C_TO_BSV_FIFO_SIZE];
   uint64_t head_AXI4_Rd_Addr_i16_a64_u0;
   uint64_t size_AXI4_Rd_Addr_i16_a64_u0;
   uint64_t credits_AXI4_Rd_Addr_i16_a64_u0;

   AXI4L_Wr_Addr_a32_u0  buf_AXI4L_Wr_Addr_a32_u0 [C_TO_BSV_FIFO_SIZE];
   uint64_t head_AXI4L_Wr_Addr_a32_u0;
   uint64_t size_AXI4L_Wr_Addr_a32_u0;
   uint64_t credits_AXI4L_Wr_Addr_a32_u0;

   AXI4L_Wr_Data_d32  buf_AXI4L_Wr_Data_d32 [C_TO_BSV_FIFO_SIZE];
   uint64_t head_AXI4L_Wr_Data_d32;
   uint64_t size_AXI4L_Wr_Data_d32;
   uint64_t credits_AXI4L_Wr_Data_d32;

   AXI4L_Rd_Addr_a32_u0  buf_AXI4L_Rd_Addr_a32_u0 [C_TO_BSV_FIFO_SIZE];
   uint64_t head_AXI4L_Rd_Addr_a32_u0;
   uint64_t size_AXI4L_Rd_Addr_a32_u0;
   uint64_t credits_AXI4L_Rd_Addr_a32_u0;

   // BSV to C queues
   AXI4_Wr_Resp_i16_u0  buf_AXI4_Wr_Resp_i16_u0 [BSV_TO_C_FIFO_SIZE];
   uint64_t head_AXI4_Wr_Resp_i16_u0;
   uint64_t size_AXI4_Wr_Resp_i16_u0;
   uint64_t credits_AXI4_Wr_Resp_i16_u0;

   AXI4_Rd_Data_i16_d512_u0  buf_AXI4_Rd_Data_i16_d512_u0 [BSV_TO_C_FIFO_SIZE];
   uint64_t head_AXI4_Rd_Data_i16_d512_u0;
   uint64_t size_AXI4_Rd_Data_i16_d512_u0;
   uint64_t credits_AXI4_Rd_Data_i16_d512_u0;

   AXI4L_Wr_Resp_u0  buf_AXI4L_Wr_Resp_u0 [BSV_TO_C_FIFO_SIZE];
   uint64_t head_AXI4L_Wr_Resp_u0;
   uint64_t size_AXI4L_Wr_Resp_u0;
   uint64_t credits_AXI4L_Wr_Resp_u0;

   AXI4L_Rd_Data_d32_u0  buf_AXI4L_Rd_Data_d32_u0 [BSV_TO_C_FIFO_SIZE];
   uint64_t head_AXI4L_Rd_Data_d32_u0;
   uint64_t size_AXI4L_Rd_Data_d32_u0;
   uint64_t credits_AXI4L_Rd_Data_d32_u0;

    // Bytevecs for C to BSV and BSV to C packets
    uint8_t bytevec_C_to_BSV [79];
    uint8_t bytevec_BSV_to_C [76];
} Bytevec_state;

// ================================================================
// State constructor and initializer

extern
Bytevec_state *mk_Bytevec_state (void);

// ================================================================
// C to BSV struct->bytevec encoder
// Returns 1: bytevec has info; should be sent
//         0: bytevec has no info; should not be sent

extern
int Bytevec_struct_to_bytevec (Bytevec_state *p_state);

// ================================================================
// BSV to C bytevec->struct decoder
// p_state->bytevec_BSV_to_C contains a bytevec
// Returns 1: bytevec had payload struct
//         0: bytevec had credits-only

extern
int Bytevec_struct_from_bytevec (Bytevec_state *p_state);

// ================================================================
// Enqueue a AXI4_Wr_Addr_i16_a64_u0 struct to be sent from C to BSV
// Return 0 if failed (queue overflow) or 1 if success
// TODO: make this thread-safe

extern
int Bytevec_enqueue_AXI4_Wr_Addr_i16_a64_u0 (Bytevec_state *p_state,
                                             AXI4_Wr_Addr_i16_a64_u0 *p_struct);

// ================================================================
// Enqueue a AXI4_Wr_Data_d512_u0 struct to be sent from C to BSV
// Return 0 if failed (queue overflow) or 1 if success
// TODO: make this thread-safe

extern
int Bytevec_enqueue_AXI4_Wr_Data_d512_u0 (Bytevec_state *p_state,
                                          AXI4_Wr_Data_d512_u0 *p_struct);

// ================================================================
// Enqueue a AXI4_Rd_Addr_i16_a64_u0 struct to be sent from C to BSV
// Return 0 if failed (queue overflow) or 1 if success
// TODO: make this thread-safe

extern
int Bytevec_enqueue_AXI4_Rd_Addr_i16_a64_u0 (Bytevec_state *p_state,
                                             AXI4_Rd_Addr_i16_a64_u0 *p_struct);

// ================================================================
// Enqueue a AXI4L_Wr_Addr_a32_u0 struct to be sent from C to BSV
// Return 0 if failed (queue overflow) or 1 if success
// TODO: make this thread-safe

extern
int Bytevec_enqueue_AXI4L_Wr_Addr_a32_u0 (Bytevec_state *p_state,
                                          AXI4L_Wr_Addr_a32_u0 *p_struct);

// ================================================================
// Enqueue a AXI4L_Wr_Data_d32 struct to be sent from C to BSV
// Return 0 if failed (queue overflow) or 1 if success
// TODO: make this thread-safe

extern
int Bytevec_enqueue_AXI4L_Wr_Data_d32 (Bytevec_state *p_state,
                                       AXI4L_Wr_Data_d32 *p_struct);

// ================================================================
// Enqueue a AXI4L_Rd_Addr_a32_u0 struct to be sent from C to BSV
// Return 0 if failed (queue overflow) or 1 if success
// TODO: make this thread-safe

extern
int Bytevec_enqueue_AXI4L_Rd_Addr_a32_u0 (Bytevec_state *p_state,
                                          AXI4L_Rd_Addr_a32_u0 *p_struct);

// ================================================================
// Dequeue a AXI4_Wr_Resp_i16_u0 struct received from BSV to C
// Return 0 if failed (none available) or 1 if success
// TODO: make this thread-safe

extern
int Bytevec_dequeue_AXI4_Wr_Resp_i16_u0 (Bytevec_state *p_state,
                                         AXI4_Wr_Resp_i16_u0 *p_struct);

// ================================================================
// Dequeue a AXI4_Rd_Data_i16_d512_u0 struct received from BSV to C
// Return 0 if failed (none available) or 1 if success
// TODO: make this thread-safe

extern
int Bytevec_dequeue_AXI4_Rd_Data_i16_d512_u0 (Bytevec_state *p_state,
                                              AXI4_Rd_Data_i16_d512_u0 *p_struct);

// ================================================================
// Dequeue a AXI4L_Wr_Resp_u0 struct received from BSV to C
// Return 0 if failed (none available) or 1 if success
// TODO: make this thread-safe

extern
int Bytevec_dequeue_AXI4L_Wr_Resp_u0 (Bytevec_state *p_state,
                                      AXI4L_Wr_Resp_u0 *p_struct);

// ================================================================
// Dequeue a AXI4L_Rd_Data_d32_u0 struct received from BSV to C
// Return 0 if failed (none available) or 1 if success
// TODO: make this thread-safe

extern
int Bytevec_dequeue_AXI4L_Rd_Data_d32_u0 (Bytevec_state *p_state,
                                          AXI4L_Rd_Data_d32_u0 *p_struct);

// ================================================================
