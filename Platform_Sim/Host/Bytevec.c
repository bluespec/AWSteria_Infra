// This file was generated from spec file 'AWS_FPGA_Spec'

#include  <stdio.h>
#include  <stdlib.h>
#include  <stdint.h>
#include  <string.h>

#include  "Bytevec.h"

// static int verbosity = 0;

// ================================================================
// State constructor and initializer

Bytevec_state *mk_Bytevec_state (void)
{
    Bytevec_state *p_state = (Bytevec_state *) malloc (sizeof (Bytevec_state));
    if (p_state == NULL) return p_state;

    memset (p_state, 0, sizeof (Bytevec_state));

    // Initialize credits for BSV-to-C queues
    p_state->credits_AXI4_Wr_Resp_i16_u0 = BSV_TO_C_FIFO_SIZE;
    p_state->credits_AXI4_Rd_Data_i16_d512_u0 = BSV_TO_C_FIFO_SIZE;
    p_state->credits_AXI4L_Wr_Resp_u0 = BSV_TO_C_FIFO_SIZE;
    p_state->credits_AXI4L_Rd_Data_d32_u0 = BSV_TO_C_FIFO_SIZE;

    return p_state;
}

// ================================================================
// Converters for C to BSV: struct -> bytevec

// ----------------------------------------------------------------

static
void AXI4_Wr_Addr_i16_a64_u0_to_bytevec (uint8_t *bytevec,
                                         const AXI4_Wr_Addr_i16_a64_u0 *ps)

{
    uint8_t *pb = bytevec;

    memcpy (pb, & ps->awid, 2);    pb += 2;
    memcpy (pb, & ps->awaddr, 8);    pb += 8;
    memcpy (pb, & ps->awlen, 1);    pb += 1;
    memcpy (pb, & ps->awsize, 1);    pb += 1;
    memcpy (pb, & ps->awburst, 1);    pb += 1;
    memcpy (pb, & ps->awlock, 1);    pb += 1;
    memcpy (pb, & ps->awcache, 1);    pb += 1;
    memcpy (pb, & ps->awprot, 1);    pb += 1;
    memcpy (pb, & ps->awqos, 1);    pb += 1;
    memcpy (pb, & ps->awregion, 1);    pb += 1;
}

// ----------------------------------------------------------------

static
void AXI4_Wr_Data_d512_u0_to_bytevec (uint8_t *bytevec,
                                      const AXI4_Wr_Data_d512_u0 *ps)

{
    uint8_t *pb = bytevec;

    memcpy (pb, & ps->wdata, 64);    pb += 64;
    memcpy (pb, & ps->wstrb, 8);    pb += 8;
    memcpy (pb, & ps->wlast, 1);    pb += 1;
}

// ----------------------------------------------------------------

static
void AXI4_Rd_Addr_i16_a64_u0_to_bytevec (uint8_t *bytevec,
                                         const AXI4_Rd_Addr_i16_a64_u0 *ps)

{
    uint8_t *pb = bytevec;

    memcpy (pb, & ps->arid, 2);    pb += 2;
    memcpy (pb, & ps->araddr, 8);    pb += 8;
    memcpy (pb, & ps->arlen, 1);    pb += 1;
    memcpy (pb, & ps->arsize, 1);    pb += 1;
    memcpy (pb, & ps->arburst, 1);    pb += 1;
    memcpy (pb, & ps->arlock, 1);    pb += 1;
    memcpy (pb, & ps->arcache, 1);    pb += 1;
    memcpy (pb, & ps->arprot, 1);    pb += 1;
    memcpy (pb, & ps->arqos, 1);    pb += 1;
    memcpy (pb, & ps->arregion, 1);    pb += 1;
}

// ----------------------------------------------------------------

static
void AXI4L_Wr_Addr_a32_u0_to_bytevec (uint8_t *bytevec,
                                      const AXI4L_Wr_Addr_a32_u0 *ps)

{
    uint8_t *pb = bytevec;

    memcpy (pb, & ps->awaddr, 4);    pb += 4;
    memcpy (pb, & ps->awprot, 1);    pb += 1;
}

// ----------------------------------------------------------------

static
void AXI4L_Wr_Data_d32_to_bytevec (uint8_t *bytevec,
                                   const AXI4L_Wr_Data_d32 *ps)

{
    uint8_t *pb = bytevec;

    memcpy (pb, & ps->wdata, 4);    pb += 4;
    memcpy (pb, & ps->wstrb, 1);    pb += 1;
}

// ----------------------------------------------------------------

static
void AXI4L_Rd_Addr_a32_u0_to_bytevec (uint8_t *bytevec,
                                      const AXI4L_Rd_Addr_a32_u0 *ps)

{
    uint8_t *pb = bytevec;

    memcpy (pb, & ps->araddr, 4);    pb += 4;
    memcpy (pb, & ps->arprot, 1);    pb += 1;
}

// ================================================================
// Converters for BSV to C: bytevec -> struct

// ----------------------------------------------------------------

static
void AXI4_Wr_Resp_i16_u0_from_bytevec (AXI4_Wr_Resp_i16_u0 *ps,
                                       const uint8_t *bytevec)

{
    const uint8_t *pb = bytevec;

    memcpy (& ps->bid, pb, 2);    pb += 2;
    memcpy (& ps->bresp, pb, 1);    pb += 1;
    memcpy (& ps->buser, pb, 0);    pb += 0;
}

// ----------------------------------------------------------------

static
void AXI4_Rd_Data_i16_d512_u0_from_bytevec (AXI4_Rd_Data_i16_d512_u0 *ps,
                                            const uint8_t *bytevec)

{
    const uint8_t *pb = bytevec;

    memcpy (& ps->rid, pb, 2);    pb += 2;
    memcpy (& ps->rdata, pb, 64);    pb += 64;
    memcpy (& ps->rresp, pb, 1);    pb += 1;
    memcpy (& ps->rlast, pb, 1);    pb += 1;
    memcpy (& ps->ruser, pb, 0);    pb += 0;
}

// ----------------------------------------------------------------

static
void AXI4L_Wr_Resp_u0_from_bytevec (AXI4L_Wr_Resp_u0 *ps,
                                    const uint8_t *bytevec)

{
    const uint8_t *pb = bytevec;

    memcpy (& ps->bresp, pb, 1);    pb += 1;
    memcpy (& ps->buser, pb, 0);    pb += 0;
}

// ----------------------------------------------------------------

static
void AXI4L_Rd_Data_d32_u0_from_bytevec (AXI4L_Rd_Data_d32_u0 *ps,
                                        const uint8_t *bytevec)

{
    const uint8_t *pb = bytevec;

    memcpy (& ps->rdata, pb, 4);    pb += 4;
    memcpy (& ps->rresp, pb, 1);    pb += 1;
    memcpy (& ps->ruser, pb, 0);    pb += 0;
}

// ================================================================
// C to BSV struct->bytevec encoder
// Returns 1: bytevec has info; should be sent
//         0: bytevec has no info; should not be sent

int Bytevec_struct_to_bytevec (Bytevec_state *p_state)
{
    int verbosity2 = 0;    // local verbosity for this function

    // ---- Fill in credits for BSV-to-C channels
    uint32_t total_credits = 0;

    total_credits += p_state->credits_AXI4_Wr_Resp_i16_u0;
    p_state->bytevec_C_to_BSV [1] = p_state->credits_AXI4_Wr_Resp_i16_u0;
    p_state->credits_AXI4_Wr_Resp_i16_u0 = 0;

    total_credits += p_state->credits_AXI4_Rd_Data_i16_d512_u0;
    p_state->bytevec_C_to_BSV [2] = p_state->credits_AXI4_Rd_Data_i16_d512_u0;
    p_state->credits_AXI4_Rd_Data_i16_d512_u0 = 0;

    total_credits += p_state->credits_AXI4L_Wr_Resp_u0;
    p_state->bytevec_C_to_BSV [3] = p_state->credits_AXI4L_Wr_Resp_u0;
    p_state->credits_AXI4L_Wr_Resp_u0 = 0;

    total_credits += p_state->credits_AXI4L_Rd_Data_d32_u0;
    p_state->bytevec_C_to_BSV [4] = p_state->credits_AXI4L_Rd_Data_d32_u0;
    p_state->credits_AXI4L_Rd_Data_d32_u0 = 0;

    // C to BSV: AXI4_Wr_Addr_i16_a64_u0
    if ((p_state->size_AXI4_Wr_Addr_i16_a64_u0 != 0) && (p_state->credits_AXI4_Wr_Addr_i16_a64_u0 != 0)) {
        p_state->bytevec_C_to_BSV [0] = 24;    // Packet size
        p_state->bytevec_C_to_BSV [5] = 1;    // Channel Id
        // ---- Payload from struct
        uint64_t head_index = (p_state->head_AXI4_Wr_Addr_i16_a64_u0 & C_TO_BSV_FIFO_INDEX_MASK);
        AXI4_Wr_Addr_i16_a64_u0_to_bytevec (p_state->bytevec_C_to_BSV + 5 + 1,
                        & p_state->buf_AXI4_Wr_Addr_i16_a64_u0 [head_index]);
        // ---- Dequeue the struct and return success (bytevec ready)
        p_state->head_AXI4_Wr_Addr_i16_a64_u0 += 1;
        p_state->size_AXI4_Wr_Addr_i16_a64_u0 -= 1;
        p_state->credits_AXI4_Wr_Addr_i16_a64_u0 -= 1;
        if (verbosity2 != 0) {
            fprintf (stdout, "Bytevec_struct_to_bytevec: encoded AXI4_Wr_Addr_i16_a64_u0\n");
            fprintf (stdout, "  head %0lx  size %0lx  credits %0lx\n",
                     p_state->head_AXI4_Wr_Addr_i16_a64_u0,
                     p_state->size_AXI4_Wr_Addr_i16_a64_u0,
                     p_state->credits_AXI4_Wr_Addr_i16_a64_u0);
        }
        return 1;
    }

    // C to BSV: AXI4_Wr_Data_d512_u0
    if ((p_state->size_AXI4_Wr_Data_d512_u0 != 0) && (p_state->credits_AXI4_Wr_Data_d512_u0 != 0)) {
        p_state->bytevec_C_to_BSV [0] = 79;    // Packet size
        p_state->bytevec_C_to_BSV [5] = 2;    // Channel Id
        // ---- Payload from struct
        uint64_t head_index = (p_state->head_AXI4_Wr_Data_d512_u0 & C_TO_BSV_FIFO_INDEX_MASK);
        AXI4_Wr_Data_d512_u0_to_bytevec (p_state->bytevec_C_to_BSV + 5 + 1,
                        & p_state->buf_AXI4_Wr_Data_d512_u0 [head_index]);
        // ---- Dequeue the struct and return success (bytevec ready)
        p_state->head_AXI4_Wr_Data_d512_u0 += 1;
        p_state->size_AXI4_Wr_Data_d512_u0 -= 1;
        p_state->credits_AXI4_Wr_Data_d512_u0 -= 1;
        if (verbosity2 != 0) {
            fprintf (stdout, "Bytevec_struct_to_bytevec: encoded AXI4_Wr_Data_d512_u0\n");
            fprintf (stdout, "  head %0lx  size %0lx  credits %0lx\n",
                     p_state->head_AXI4_Wr_Data_d512_u0,
                     p_state->size_AXI4_Wr_Data_d512_u0,
                     p_state->credits_AXI4_Wr_Data_d512_u0);
        }
        return 1;
    }

    // C to BSV: AXI4_Rd_Addr_i16_a64_u0
    if ((p_state->size_AXI4_Rd_Addr_i16_a64_u0 != 0) && (p_state->credits_AXI4_Rd_Addr_i16_a64_u0 != 0)) {
        p_state->bytevec_C_to_BSV [0] = 24;    // Packet size
        p_state->bytevec_C_to_BSV [5] = 3;    // Channel Id
        // ---- Payload from struct
        uint64_t head_index = (p_state->head_AXI4_Rd_Addr_i16_a64_u0 & C_TO_BSV_FIFO_INDEX_MASK);
        AXI4_Rd_Addr_i16_a64_u0_to_bytevec (p_state->bytevec_C_to_BSV + 5 + 1,
                        & p_state->buf_AXI4_Rd_Addr_i16_a64_u0 [head_index]);
        // ---- Dequeue the struct and return success (bytevec ready)
        p_state->head_AXI4_Rd_Addr_i16_a64_u0 += 1;
        p_state->size_AXI4_Rd_Addr_i16_a64_u0 -= 1;
        p_state->credits_AXI4_Rd_Addr_i16_a64_u0 -= 1;
        if (verbosity2 != 0) {
            fprintf (stdout, "Bytevec_struct_to_bytevec: encoded AXI4_Rd_Addr_i16_a64_u0\n");
            fprintf (stdout, "  head %0lx  size %0lx  credits %0lx\n",
                     p_state->head_AXI4_Rd_Addr_i16_a64_u0,
                     p_state->size_AXI4_Rd_Addr_i16_a64_u0,
                     p_state->credits_AXI4_Rd_Addr_i16_a64_u0);
        }
        return 1;
    }

    // C to BSV: AXI4L_Wr_Addr_a32_u0
    if ((p_state->size_AXI4L_Wr_Addr_a32_u0 != 0) && (p_state->credits_AXI4L_Wr_Addr_a32_u0 != 0)) {
        p_state->bytevec_C_to_BSV [0] = 11;    // Packet size
        p_state->bytevec_C_to_BSV [5] = 4;    // Channel Id
        // ---- Payload from struct
        uint64_t head_index = (p_state->head_AXI4L_Wr_Addr_a32_u0 & C_TO_BSV_FIFO_INDEX_MASK);
        AXI4L_Wr_Addr_a32_u0_to_bytevec (p_state->bytevec_C_to_BSV + 5 + 1,
                        & p_state->buf_AXI4L_Wr_Addr_a32_u0 [head_index]);
        // ---- Dequeue the struct and return success (bytevec ready)
        p_state->head_AXI4L_Wr_Addr_a32_u0 += 1;
        p_state->size_AXI4L_Wr_Addr_a32_u0 -= 1;
        p_state->credits_AXI4L_Wr_Addr_a32_u0 -= 1;
        if (verbosity2 != 0) {
            fprintf (stdout, "Bytevec_struct_to_bytevec: encoded AXI4L_Wr_Addr_a32_u0\n");
            fprintf (stdout, "  head %0lx  size %0lx  credits %0lx\n",
                     p_state->head_AXI4L_Wr_Addr_a32_u0,
                     p_state->size_AXI4L_Wr_Addr_a32_u0,
                     p_state->credits_AXI4L_Wr_Addr_a32_u0);
        }
        return 1;
    }

    // C to BSV: AXI4L_Wr_Data_d32
    if ((p_state->size_AXI4L_Wr_Data_d32 != 0) && (p_state->credits_AXI4L_Wr_Data_d32 != 0)) {
        p_state->bytevec_C_to_BSV [0] = 11;    // Packet size
        p_state->bytevec_C_to_BSV [5] = 5;    // Channel Id
        // ---- Payload from struct
        uint64_t head_index = (p_state->head_AXI4L_Wr_Data_d32 & C_TO_BSV_FIFO_INDEX_MASK);
        AXI4L_Wr_Data_d32_to_bytevec (p_state->bytevec_C_to_BSV + 5 + 1,
                        & p_state->buf_AXI4L_Wr_Data_d32 [head_index]);
        // ---- Dequeue the struct and return success (bytevec ready)
        p_state->head_AXI4L_Wr_Data_d32 += 1;
        p_state->size_AXI4L_Wr_Data_d32 -= 1;
        p_state->credits_AXI4L_Wr_Data_d32 -= 1;
        if (verbosity2 != 0) {
            fprintf (stdout, "Bytevec_struct_to_bytevec: encoded AXI4L_Wr_Data_d32\n");
            fprintf (stdout, "  head %0lx  size %0lx  credits %0lx\n",
                     p_state->head_AXI4L_Wr_Data_d32,
                     p_state->size_AXI4L_Wr_Data_d32,
                     p_state->credits_AXI4L_Wr_Data_d32);
        }
        return 1;
    }

    // C to BSV: AXI4L_Rd_Addr_a32_u0
    if ((p_state->size_AXI4L_Rd_Addr_a32_u0 != 0) && (p_state->credits_AXI4L_Rd_Addr_a32_u0 != 0)) {
        p_state->bytevec_C_to_BSV [0] = 11;    // Packet size
        p_state->bytevec_C_to_BSV [5] = 6;    // Channel Id
        // ---- Payload from struct
        uint64_t head_index = (p_state->head_AXI4L_Rd_Addr_a32_u0 & C_TO_BSV_FIFO_INDEX_MASK);
        AXI4L_Rd_Addr_a32_u0_to_bytevec (p_state->bytevec_C_to_BSV + 5 + 1,
                        & p_state->buf_AXI4L_Rd_Addr_a32_u0 [head_index]);
        // ---- Dequeue the struct and return success (bytevec ready)
        p_state->head_AXI4L_Rd_Addr_a32_u0 += 1;
        p_state->size_AXI4L_Rd_Addr_a32_u0 -= 1;
        p_state->credits_AXI4L_Rd_Addr_a32_u0 -= 1;
        if (verbosity2 != 0) {
            fprintf (stdout, "Bytevec_struct_to_bytevec: encoded AXI4L_Rd_Addr_a32_u0\n");
            fprintf (stdout, "  head %0lx  size %0lx  credits %0lx\n",
                     p_state->head_AXI4L_Rd_Addr_a32_u0,
                     p_state->size_AXI4L_Rd_Addr_a32_u0,
                     p_state->credits_AXI4L_Rd_Addr_a32_u0);
        }
        return 1;
    }

    // Credits-only bytevec
    if (total_credits != 0) {
        p_state->bytevec_C_to_BSV [0] = 1 + 5;    // packet size
        p_state->bytevec_C_to_BSV [5] = 0;    // chan id = credits-only
        if (verbosity2 != 0)
            fprintf (stdout, "Bytevec_struct_to_bytevec: bytevec is credits-only\n");
        return 1;
    }

    // No bytevec to send
    return 0;
}

// ================================================================
// BSV to C bytevec->struct decoder
// p_state->bytevec_BSV_to_C contains a bytevec
// Returns 1: bytevec had payload struct
//         0: bytevec had credits-only

int Bytevec_struct_from_bytevec (Bytevec_state *p_state)
{
    int verbosity2 = 0;    // local verbosity for this function

    // ---- Restore credits for remote C-to-BSV receive buffers
    p_state->credits_AXI4_Wr_Addr_i16_a64_u0 += p_state->bytevec_BSV_to_C [1];
    p_state->credits_AXI4_Wr_Data_d512_u0 += p_state->bytevec_BSV_to_C [2];
    p_state->credits_AXI4_Rd_Addr_i16_a64_u0 += p_state->bytevec_BSV_to_C [3];
    p_state->credits_AXI4L_Wr_Addr_a32_u0 += p_state->bytevec_BSV_to_C [4];
    p_state->credits_AXI4L_Wr_Data_d32 += p_state->bytevec_BSV_to_C [5];
    p_state->credits_AXI4L_Rd_Addr_a32_u0 += p_state->bytevec_BSV_to_C [6];

    // BSV to C: AXI4_Wr_Resp_i16_u0
    if (p_state->bytevec_BSV_to_C [7] == 1) {
        // ---- Fill in struct from payload
        uint64_t head_index = (p_state->head_AXI4_Wr_Resp_i16_u0 & BSV_TO_C_FIFO_INDEX_MASK);
        AXI4_Wr_Resp_i16_u0_from_bytevec (& p_state->buf_AXI4_Wr_Resp_i16_u0 [head_index],
                                       p_state->bytevec_BSV_to_C + 7 + 1);
        // ---- Enqueue the struct
        p_state->size_AXI4_Wr_Resp_i16_u0 += 1;
        if (verbosity2 != 0)
            fprintf (stdout, "Bytevec_struct_from_bytevec: received AXI4_Wr_Resp_i16_u0 struct\n");
        return 1;
    }

    // BSV to C: AXI4_Rd_Data_i16_d512_u0
    if (p_state->bytevec_BSV_to_C [7] == 2) {
        // ---- Fill in struct from payload
        uint64_t head_index = (p_state->head_AXI4_Rd_Data_i16_d512_u0 & BSV_TO_C_FIFO_INDEX_MASK);
        AXI4_Rd_Data_i16_d512_u0_from_bytevec (& p_state->buf_AXI4_Rd_Data_i16_d512_u0 [head_index],
                                       p_state->bytevec_BSV_to_C + 7 + 1);
        // ---- Enqueue the struct
        p_state->size_AXI4_Rd_Data_i16_d512_u0 += 1;
        if (verbosity2 != 0)
            fprintf (stdout, "Bytevec_struct_from_bytevec: received AXI4_Rd_Data_i16_d512_u0 struct\n");
        return 1;
    }

    // BSV to C: AXI4L_Wr_Resp_u0
    if (p_state->bytevec_BSV_to_C [7] == 3) {
        // ---- Fill in struct from payload
        uint64_t head_index = (p_state->head_AXI4L_Wr_Resp_u0 & BSV_TO_C_FIFO_INDEX_MASK);
        AXI4L_Wr_Resp_u0_from_bytevec (& p_state->buf_AXI4L_Wr_Resp_u0 [head_index],
                                       p_state->bytevec_BSV_to_C + 7 + 1);
        // ---- Enqueue the struct
        p_state->size_AXI4L_Wr_Resp_u0 += 1;
        if (verbosity2 != 0)
            fprintf (stdout, "Bytevec_struct_from_bytevec: received AXI4L_Wr_Resp_u0 struct\n");
        return 1;
    }

    // BSV to C: AXI4L_Rd_Data_d32_u0
    if (p_state->bytevec_BSV_to_C [7] == 4) {
        // ---- Fill in struct from payload
        uint64_t head_index = (p_state->head_AXI4L_Rd_Data_d32_u0 & BSV_TO_C_FIFO_INDEX_MASK);
        AXI4L_Rd_Data_d32_u0_from_bytevec (& p_state->buf_AXI4L_Rd_Data_d32_u0 [head_index],
                                       p_state->bytevec_BSV_to_C + 7 + 1);
        // ---- Enqueue the struct
        p_state->size_AXI4L_Rd_Data_d32_u0 += 1;
        if (verbosity2 != 0)
            fprintf (stdout, "Bytevec_struct_from_bytevec: received AXI4L_Rd_Data_d32_u0 struct\n");
        return 1;
    }
    if (verbosity2 != 0)
        fprintf (stdout, "Bytevec_struct_from_bytevec: bytevec is credits-only\n");
    return 0;
}

// ================================================================
// Enqueue a AXI4_Wr_Addr_i16_a64_u0 struct to be sent from C to BSV
// Return 0 if failed (queue overflow) or 1 if success
// TODO: make this thread-safe

int Bytevec_enqueue_AXI4_Wr_Addr_i16_a64_u0 (Bytevec_state *p_state,
                                             AXI4_Wr_Addr_i16_a64_u0 *p_struct)
{
    int verbosity2 = 0;
    if (p_state->size_AXI4_Wr_Addr_i16_a64_u0 >= C_TO_BSV_FIFO_SIZE) return 0;

    uint64_t tail_index = p_state->head_AXI4_Wr_Addr_i16_a64_u0 +
                          p_state->size_AXI4_Wr_Addr_i16_a64_u0;
    tail_index = (tail_index & C_TO_BSV_FIFO_INDEX_MASK);
    memcpy (& (p_state->buf_AXI4_Wr_Addr_i16_a64_u0 [tail_index]),
            p_struct,
            sizeof (AXI4_Wr_Addr_i16_a64_u0));
    p_state->size_AXI4_Wr_Addr_i16_a64_u0 += 1;
    if (verbosity2 != 0) {
        fprintf (stdout, "Bytevec_enqueue_AXI4_Wr_Addr_i16_a64_u0:\n");
        fprintf (stdout, "  head %0lx  size %0lx  credits %0lx\n",
                 p_state->head_AXI4_Wr_Addr_i16_a64_u0,
                 p_state->size_AXI4_Wr_Addr_i16_a64_u0,
                 p_state->credits_AXI4_Wr_Addr_i16_a64_u0);
    }

    return 1;
}

// ================================================================
// Enqueue a AXI4_Wr_Data_d512_u0 struct to be sent from C to BSV
// Return 0 if failed (queue overflow) or 1 if success
// TODO: make this thread-safe

int Bytevec_enqueue_AXI4_Wr_Data_d512_u0 (Bytevec_state *p_state,
                                          AXI4_Wr_Data_d512_u0 *p_struct)
{
    int verbosity2 = 0;
    if (p_state->size_AXI4_Wr_Data_d512_u0 >= C_TO_BSV_FIFO_SIZE) return 0;

    uint64_t tail_index = p_state->head_AXI4_Wr_Data_d512_u0 +
                          p_state->size_AXI4_Wr_Data_d512_u0;
    tail_index = (tail_index & C_TO_BSV_FIFO_INDEX_MASK);
    memcpy (& (p_state->buf_AXI4_Wr_Data_d512_u0 [tail_index]),
            p_struct,
            sizeof (AXI4_Wr_Data_d512_u0));
    p_state->size_AXI4_Wr_Data_d512_u0 += 1;
    if (verbosity2 != 0) {
        fprintf (stdout, "Bytevec_enqueue_AXI4_Wr_Data_d512_u0:\n");
        fprintf (stdout, "  head %0lx  size %0lx  credits %0lx\n",
                 p_state->head_AXI4_Wr_Data_d512_u0,
                 p_state->size_AXI4_Wr_Data_d512_u0,
                 p_state->credits_AXI4_Wr_Data_d512_u0);
    }

    return 1;
}

// ================================================================
// Enqueue a AXI4_Rd_Addr_i16_a64_u0 struct to be sent from C to BSV
// Return 0 if failed (queue overflow) or 1 if success
// TODO: make this thread-safe

int Bytevec_enqueue_AXI4_Rd_Addr_i16_a64_u0 (Bytevec_state *p_state,
                                             AXI4_Rd_Addr_i16_a64_u0 *p_struct)
{
    int verbosity2 = 0;
    if (p_state->size_AXI4_Rd_Addr_i16_a64_u0 >= C_TO_BSV_FIFO_SIZE) return 0;

    uint64_t tail_index = p_state->head_AXI4_Rd_Addr_i16_a64_u0 +
                          p_state->size_AXI4_Rd_Addr_i16_a64_u0;
    tail_index = (tail_index & C_TO_BSV_FIFO_INDEX_MASK);
    memcpy (& (p_state->buf_AXI4_Rd_Addr_i16_a64_u0 [tail_index]),
            p_struct,
            sizeof (AXI4_Rd_Addr_i16_a64_u0));
    p_state->size_AXI4_Rd_Addr_i16_a64_u0 += 1;
    if (verbosity2 != 0) {
        fprintf (stdout, "Bytevec_enqueue_AXI4_Rd_Addr_i16_a64_u0:\n");
        fprintf (stdout, "  head %0lx  size %0lx  credits %0lx\n",
                 p_state->head_AXI4_Rd_Addr_i16_a64_u0,
                 p_state->size_AXI4_Rd_Addr_i16_a64_u0,
                 p_state->credits_AXI4_Rd_Addr_i16_a64_u0);
    }

    return 1;
}

// ================================================================
// Enqueue a AXI4L_Wr_Addr_a32_u0 struct to be sent from C to BSV
// Return 0 if failed (queue overflow) or 1 if success
// TODO: make this thread-safe

int Bytevec_enqueue_AXI4L_Wr_Addr_a32_u0 (Bytevec_state *p_state,
                                          AXI4L_Wr_Addr_a32_u0 *p_struct)
{
    int verbosity2 = 0;
    if (p_state->size_AXI4L_Wr_Addr_a32_u0 >= C_TO_BSV_FIFO_SIZE) return 0;

    uint64_t tail_index = p_state->head_AXI4L_Wr_Addr_a32_u0 +
                          p_state->size_AXI4L_Wr_Addr_a32_u0;
    tail_index = (tail_index & C_TO_BSV_FIFO_INDEX_MASK);
    memcpy (& (p_state->buf_AXI4L_Wr_Addr_a32_u0 [tail_index]),
            p_struct,
            sizeof (AXI4L_Wr_Addr_a32_u0));
    p_state->size_AXI4L_Wr_Addr_a32_u0 += 1;
    if (verbosity2 != 0) {
        fprintf (stdout, "Bytevec_enqueue_AXI4L_Wr_Addr_a32_u0:\n");
        fprintf (stdout, "  head %0lx  size %0lx  credits %0lx\n",
                 p_state->head_AXI4L_Wr_Addr_a32_u0,
                 p_state->size_AXI4L_Wr_Addr_a32_u0,
                 p_state->credits_AXI4L_Wr_Addr_a32_u0);
    }

    return 1;
}

// ================================================================
// Enqueue a AXI4L_Wr_Data_d32 struct to be sent from C to BSV
// Return 0 if failed (queue overflow) or 1 if success
// TODO: make this thread-safe

int Bytevec_enqueue_AXI4L_Wr_Data_d32 (Bytevec_state *p_state,
                                       AXI4L_Wr_Data_d32 *p_struct)
{
    int verbosity2 = 0;
    if (p_state->size_AXI4L_Wr_Data_d32 >= C_TO_BSV_FIFO_SIZE) return 0;

    uint64_t tail_index = p_state->head_AXI4L_Wr_Data_d32 +
                          p_state->size_AXI4L_Wr_Data_d32;
    tail_index = (tail_index & C_TO_BSV_FIFO_INDEX_MASK);
    memcpy (& (p_state->buf_AXI4L_Wr_Data_d32 [tail_index]),
            p_struct,
            sizeof (AXI4L_Wr_Data_d32));
    p_state->size_AXI4L_Wr_Data_d32 += 1;
    if (verbosity2 != 0) {
        fprintf (stdout, "Bytevec_enqueue_AXI4L_Wr_Data_d32:\n");
        fprintf (stdout, "  head %0lx  size %0lx  credits %0lx\n",
                 p_state->head_AXI4L_Wr_Data_d32,
                 p_state->size_AXI4L_Wr_Data_d32,
                 p_state->credits_AXI4L_Wr_Data_d32);
    }

    return 1;
}

// ================================================================
// Enqueue a AXI4L_Rd_Addr_a32_u0 struct to be sent from C to BSV
// Return 0 if failed (queue overflow) or 1 if success
// TODO: make this thread-safe

int Bytevec_enqueue_AXI4L_Rd_Addr_a32_u0 (Bytevec_state *p_state,
                                          AXI4L_Rd_Addr_a32_u0 *p_struct)
{
    int verbosity2 = 0;
    if (p_state->size_AXI4L_Rd_Addr_a32_u0 >= C_TO_BSV_FIFO_SIZE) return 0;

    uint64_t tail_index = p_state->head_AXI4L_Rd_Addr_a32_u0 +
                          p_state->size_AXI4L_Rd_Addr_a32_u0;
    tail_index = (tail_index & C_TO_BSV_FIFO_INDEX_MASK);
    memcpy (& (p_state->buf_AXI4L_Rd_Addr_a32_u0 [tail_index]),
            p_struct,
            sizeof (AXI4L_Rd_Addr_a32_u0));
    p_state->size_AXI4L_Rd_Addr_a32_u0 += 1;
    if (verbosity2 != 0) {
        fprintf (stdout, "Bytevec_enqueue_AXI4L_Rd_Addr_a32_u0:\n");
        fprintf (stdout, "  head %0lx  size %0lx  credits %0lx\n",
                 p_state->head_AXI4L_Rd_Addr_a32_u0,
                 p_state->size_AXI4L_Rd_Addr_a32_u0,
                 p_state->credits_AXI4L_Rd_Addr_a32_u0);
    }

    return 1;
}

// ================================================================
// Dequeue a AXI4_Wr_Resp_i16_u0 struct received from BSV to C
// Return 0 if failed (none available) or 1 if success
// TODO: make this thread-safe

int Bytevec_dequeue_AXI4_Wr_Resp_i16_u0 (Bytevec_state *p_state,
                                         AXI4_Wr_Resp_i16_u0 *p_struct)
{
    if (p_state->size_AXI4_Wr_Resp_i16_u0 == 0) return 0;

    uint64_t head_index = (p_state->head_AXI4_Wr_Resp_i16_u0 &
                           BSV_TO_C_FIFO_INDEX_MASK);
    memcpy (p_struct,
            & (p_state->buf_AXI4_Wr_Resp_i16_u0 [head_index]),
            sizeof (AXI4_Wr_Resp_i16_u0));
    p_state->head_AXI4_Wr_Resp_i16_u0 += 1;
    p_state->size_AXI4_Wr_Resp_i16_u0 -= 1;
    p_state->credits_AXI4_Wr_Resp_i16_u0 += 1;

    return 1;
}

// ================================================================
// Dequeue a AXI4_Rd_Data_i16_d512_u0 struct received from BSV to C
// Return 0 if failed (none available) or 1 if success
// TODO: make this thread-safe

int Bytevec_dequeue_AXI4_Rd_Data_i16_d512_u0 (Bytevec_state *p_state,
                                              AXI4_Rd_Data_i16_d512_u0 *p_struct)
{
    if (p_state->size_AXI4_Rd_Data_i16_d512_u0 == 0) return 0;

    uint64_t head_index = (p_state->head_AXI4_Rd_Data_i16_d512_u0 &
                           BSV_TO_C_FIFO_INDEX_MASK);
    memcpy (p_struct,
            & (p_state->buf_AXI4_Rd_Data_i16_d512_u0 [head_index]),
            sizeof (AXI4_Rd_Data_i16_d512_u0));
    p_state->head_AXI4_Rd_Data_i16_d512_u0 += 1;
    p_state->size_AXI4_Rd_Data_i16_d512_u0 -= 1;
    p_state->credits_AXI4_Rd_Data_i16_d512_u0 += 1;

    return 1;
}

// ================================================================
// Dequeue a AXI4L_Wr_Resp_u0 struct received from BSV to C
// Return 0 if failed (none available) or 1 if success
// TODO: make this thread-safe

int Bytevec_dequeue_AXI4L_Wr_Resp_u0 (Bytevec_state *p_state,
                                      AXI4L_Wr_Resp_u0 *p_struct)
{
    if (p_state->size_AXI4L_Wr_Resp_u0 == 0) return 0;

    uint64_t head_index = (p_state->head_AXI4L_Wr_Resp_u0 &
                           BSV_TO_C_FIFO_INDEX_MASK);
    memcpy (p_struct,
            & (p_state->buf_AXI4L_Wr_Resp_u0 [head_index]),
            sizeof (AXI4L_Wr_Resp_u0));
    p_state->head_AXI4L_Wr_Resp_u0 += 1;
    p_state->size_AXI4L_Wr_Resp_u0 -= 1;
    p_state->credits_AXI4L_Wr_Resp_u0 += 1;

    return 1;
}

// ================================================================
// Dequeue a AXI4L_Rd_Data_d32_u0 struct received from BSV to C
// Return 0 if failed (none available) or 1 if success
// TODO: make this thread-safe

int Bytevec_dequeue_AXI4L_Rd_Data_d32_u0 (Bytevec_state *p_state,
                                          AXI4L_Rd_Data_d32_u0 *p_struct)
{
    if (p_state->size_AXI4L_Rd_Data_d32_u0 == 0) return 0;

    uint64_t head_index = (p_state->head_AXI4L_Rd_Data_d32_u0 &
                           BSV_TO_C_FIFO_INDEX_MASK);
    memcpy (p_struct,
            & (p_state->buf_AXI4L_Rd_Data_d32_u0 [head_index]),
            sizeof (AXI4L_Rd_Data_d32_u0));
    p_state->head_AXI4L_Rd_Data_d32_u0 += 1;
    p_state->size_AXI4L_Rd_Data_d32_u0 -= 1;
    p_state->credits_AXI4L_Rd_Data_d32_u0 += 1;

    return 1;
}

// ================================================================
