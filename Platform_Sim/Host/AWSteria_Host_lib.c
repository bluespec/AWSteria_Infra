// Copyright (c) 2020-2021 Bluespec, Inc.  All Rights Reserved

// This library implements the AWSteria host-side API routines
// Bluesim and Verilator sim.

// ================================================================
// C lib includes

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <unistd.h>
#include <assert.h>

// ----------------
// Project includes

#include "AWSteria_Host_lib.h"

#include "Bytevec.h"
#include "TCP_Client_Lib.h"

// ================================================================
// Static globals

// Default host is localhost
#define DEFAULT_HOSTNAME  "127.0.0.1"

#define DEFAULT_PORT 30000

typedef struct {
    Bytevec_state *p_bytevec_state;
} AWSteria_Host_State;

static
AWSteria_Host_State  awsteria_host_state;

// ================================================================
// Host_init returns pointer to any state needed for the remaining API calls
// Return pointer to host state (or NULL if error)

static int verbosity_init = 0;

void *AWSteria_Host_init (void)
{
    if (verbosity_init > 0)
	fprintf (stdout, "%s()\n", __FUNCTION__);

    if (awsteria_host_state.p_bytevec_state != NULL) {
	fprintf (stdout, "WARNING: %s: already initialized\n", __FUNCTION__);
	return (& awsteria_host_state);
    }

    awsteria_host_state.p_bytevec_state = mk_Bytevec_state ();
    if (awsteria_host_state.p_bytevec_state == NULL) {
	fprintf (stdout, "ERROR: %s: mk_Bytevec_state failed\n", __FUNCTION__);
	exit (1);
    }

    uint32_t status = tcp_client_open (DEFAULT_HOSTNAME, DEFAULT_PORT);
    if (status == status_err) {
	fprintf (stdout, "ERROR: %s: failed\n", __FUNCTION__);
	exit (1);
    }

    if (verbosity_init > 0)
	fprintf (stdout, "%s: initialized, connected to simulation server\n", __FUNCTION__);

    return (& awsteria_host_state);
}

static
void check_state_initialized (void)
{
    if (awsteria_host_state.p_bytevec_state != NULL) return;
    AWSteria_Host_init ();
}

// ================================================================
// Host_shutdown takes pointer to state returned by Host_init
// Return 0 if ok, non-zero if error

int AWSteria_Host_shutdown (void *awsteria_host_state)
{
    fprintf (stdout, "%s: closing TCP connection\n", __FUNCTION__);
    tcp_client_close (0);
    return 0;
}

// ================================================================

static
bool do_comms (void)
{
    int verbosity2 = 0;

    check_state_initialized ();

    uint32_t  status;
    bool activity = false;

    // Send
    if (verbosity2 > 1)
	fprintf (stdout, "%s: packet to_bytevec\n", __FUNCTION__);
    int ready = Bytevec_struct_to_bytevec (awsteria_host_state.p_bytevec_state);
    if (ready) {
	if (verbosity2 != 0) {
	    fprintf (stdout, "%s: sending %0d bytes\n  ",  __FUNCTION__,
		     awsteria_host_state.p_bytevec_state->bytevec_C_to_BSV [0]);
	    for (int j = 0; j < awsteria_host_state.p_bytevec_state->bytevec_C_to_BSV [0]; j++)
		fprintf (stdout, " %02x", awsteria_host_state.p_bytevec_state->bytevec_C_to_BSV [j]);
	    fprintf (stdout, "\n");
	}
	status = tcp_client_send (awsteria_host_state.p_bytevec_state->bytevec_C_to_BSV [0],
				  awsteria_host_state.p_bytevec_state->bytevec_C_to_BSV);
	if (status == 0) {
	    fprintf (stdout, "%s: tcp_client_send error\n",  __FUNCTION__);
	    exit (1);
	}

	activity = true;
    }
        
    // Receive
    if (verbosity2 > 1)
	fprintf (stdout, "%s: attempt receive bytevec\n",  __FUNCTION__);
    const bool poll    = true;
    status = tcp_client_recv (poll, 1, awsteria_host_state.p_bytevec_state->bytevec_BSV_to_C);
    if (status == status_ok) {
	const bool no_poll = false;
	uint32_t size = awsteria_host_state.p_bytevec_state->bytevec_BSV_to_C [0] - 1;
	status = tcp_client_recv (no_poll, size,
				  & (awsteria_host_state.p_bytevec_state->bytevec_BSV_to_C [1]));

	if (verbosity2 != 0) {
	    fprintf (stdout, "%s: received %0d bytes\n  ",  __FUNCTION__,
		     awsteria_host_state.p_bytevec_state->bytevec_BSV_to_C [0]);
	    for (int j = 0; j < awsteria_host_state.p_bytevec_state->bytevec_BSV_to_C [0]; j++)
		fprintf (stdout, " %02x", awsteria_host_state.p_bytevec_state->bytevec_BSV_to_C [j]);
	    fprintf (stdout, "\n");
	}

	if (verbosity2 != 0)
	    fprintf (stdout, "%s: packet from_bytevec\n",  __FUNCTION__);
	Bytevec_struct_from_bytevec (awsteria_host_state.p_bytevec_state);

	activity = true;
    }
    return activity;
}

// ****************************************************************
// AXI4 reads and writes
// ****************************************************************

// ================================================================
// Debugging verbosity
// 0 = quiet; 1 = full transaction; 2 = each page; 3 = AXI4 details

static const int verbosity_AXI4_read  = 0;
static const int verbosity_AXI4_write = 0;

// ================================================================
// The following defs are needed for AWSteria_AXI4_read()/write()
// tranfers use AXI4 bursts where
// - bursts should not straddle 4KB page boundaries
//    (cf. "AMBA AXI and ACE Protocol Specification, Section A3.4.1 Address structure")
// - each beat is 64-Bytes wide

// On AXI4, a full page can be sent in a single burst (64 beats x 64 Bytes)

// Page size, mask for offset-in-page, mask for truncaction to-page-start.

#define OFFSET_IN_PAGE_BITS     12
#define PAGE_SIZE               (((uint64_t) 1) << OFFSET_IN_PAGE_BITS)
#define MASK_TO_OFFSET_IN_PAGE  (((uint64_t) PAGE_SIZE) - 1)
#define MASK_TO_PAGE_START      (~ ((uint64_t) MASK_TO_OFFSET_IN_PAGE))

// AXI4 beat size, mask for offset-in-beat, mask for truncation to beat-start.

#define OFFSET_IN_BEAT_BITS     6
#define BEAT_SIZE               (((uint64_t) 1) << OFFSET_IN_BEAT_BITS)
#define MASK_TO_OFFSET_IN_BEAT  (((uint64_t) BEAT_SIZE) - 1)
#define MASK_TO_BEAT_START      (~ ((uint64_t) MASK_TO_OFFSET_IN_BEAT))

// ================================================================
// AWSteria_AXI4_read()    for simulation library
// Return 0 for ok, non-zero for error.

// The externally-called API function 'AWSteria_AXI4_read()' is
// given later, below.
// It cannot assume anything about address alignment,
// nor whether data straddles page boundaries.

// ----------------
// This 'aux' function is internal, and performs a single burst
// transaction (up to a page in size). The caller guarantees that
// 'address' and 'size' have been trimmed to be within a page.
// Note: neither the starting address nor the ending address may be
// 64-Byte aligned (beat-aligned).

static
int AWSteria_AXI4_read_aux (uint8_t *buffer, const size_t size, const uint64_t address)
{
    if (verbosity_AXI4_read >= 2)
	fprintf (stdout, "%s: size %0ld address %0lx\n", __FUNCTION__, size, address);

    bool            did_some_comms;
    const uint64_t  address_lim = address + size;

    // ----------------
    // Compose an AXI4 RD_ADDR bus request

    AXI4_Rd_Addr_i16_a64_u0   rda;

    // TODO: Check if these defaults are ok
    rda.arid     = 0;
    rda.arlock   = 0;    // "normal"
    rda.arcache  = 0;    // "dev_nonbuf"
    rda.arprot   = 0;    // { data, secure, unpriv }
    rda.arqos    = 0;
    rda.arregion = 0;
    rda.aruser   = 0;

    // Compute burst length
    const uint64_t  first_beat_num = (address           >> OFFSET_IN_BEAT_BITS);
    const uint64_t  last_beat_num  = ((address_lim - 1) >> OFFSET_IN_BEAT_BITS);
    const uint64_t  num_beats      = last_beat_num - first_beat_num + 1;

    rda.araddr  = address;
    rda.arlen   = num_beats - 1;    // AXI4 coding for num_beats
    rda.arsize  = 0x6;              // AXI4 coding for 64-Byte size
    rda.arburst = 0x1;              // AXI4 coding for 'incrementing' burst

    // ----------------
    // Send the AXI4 RD_ADDR bus request

    if (verbosity_AXI4_read >= 3)
	fprintf (stdout, "%s: araddr %0lx arlen %0d arsize %0x arburst %0x",
		 __FUNCTION__, rda.araddr, rda.arlen, rda.arsize, rda.arburst);

    while (true) {
	// Try to send request
	int status = Bytevec_enqueue_AXI4_Rd_Addr_i16_a64_u0 (awsteria_host_state.p_bytevec_state, & rda);
	if (status == 1) break;
	usleep (10);                     // Wait, if unable to send
	did_some_comms = do_comms ();    // Move data in comms channel
    }
    did_some_comms = do_comms ();        // Move data in comms channel

    // ----------------
    // Receive the AXI4 RD_DATA bus response (in num_beats).

    AXI4_Rd_Data_i16_d512_u0  rdd;

    uint8_t *pb = buffer;

    bool     ok             = true;
    uint64_t beat_addr      = (address & MASK_TO_BEAT_START);
    uint64_t next_beat_addr = beat_addr + BEAT_SIZE;

    for (int beat = 0; beat < num_beats; beat++) {
	// Read an AXI4 beat
	while (true) {
	    did_some_comms = do_comms ();    // Move data in comms channel
	    if (! did_some_comms)
		usleep (10);                 // Wait, if no activity

	    // Try to receive a beat
	    int status = Bytevec_dequeue_AXI4_Rd_Data_i16_d512_u0 (awsteria_host_state.p_bytevec_state, & rdd);
	    if (status == 1) break;          // Successfully received a beat

	    if (verbosity_AXI4_read >= 3)
		fprintf (stdout, "%s: AXI4 RD_DATA response wait loop; beat %0d beat_addr %0lx\n",
			 __FUNCTION__, beat, beat_addr);
	}

	// Debugging: show response
	if (verbosity_AXI4_read >= 3) {
	    fprintf (stdout, "%s: beat %0d  rresp %0d  rlast %0d  rdata:\n  [",
		     __FUNCTION__, beat, rdd.rresp, rdd.rlast);
	    for (int k = 0; k < 64; k++)
		fprintf (stdout, " %02x", rdd.rdata [k]);
	    fprintf (stdout, "]\n");
	}

	// Check rlast was properly set
	if (beat == (num_beats - 1)) {
	    if (rdd.rlast == 0) {
		fprintf (stdout, "ERROR: %s: rlast is 0 on last beat\n",  __FUNCTION__);
		return 1;
	    }
	}
	else {
	    if (rdd.rlast == 1) {
		fprintf (stdout, "ERROR: %s: rlast is 1 on non-last beat\n",  __FUNCTION__);
		return 1;
	    }
	}
	ok = (ok && (rdd.rresp == 0));    // AXI4: rresp is OKAY

	// Copy data from AXI4 response beat's data into buf
	uint64_t offset_in_beat = ((beat == 0)
				   ? (address & MASK_TO_OFFSET_IN_BEAT)
				   : 0);
	uint64_t size_in_beat   = ((next_beat_addr > address_lim)
				   ? ((address_lim & MASK_TO_OFFSET_IN_BEAT) - offset_in_beat)
				   : (BEAT_SIZE - offset_in_beat));

	memcpy (pb, & (rdd.rdata [offset_in_beat]), size_in_beat);

	pb            += size_in_beat;
	beat_addr      = next_beat_addr;
	next_beat_addr = next_beat_addr + BEAT_SIZE;
    }    
    if (verbosity_AXI4_read >= 2)
	fprintf (stdout, "%s: complete\n",  __FUNCTION__);

    return (! ok);
}

// ----------------
// The API function (externally visible)
// This does not assume anything about address alignment,
// nor whether data straddles page boundaries.

int AWSteria_AXI4_read (void *awsteria_host_state,
		       uint8_t *buffer, const size_t size, const uint64_t address)
{
    if (verbosity_AXI4_read >= 1)
	fprintf (stdout, "%s: size %0ld address %0lx\n", __FUNCTION__, size, address);

    check_state_initialized ();

    int       status     = 0;
    uint64_t  chunk_addr = address;
    int       num_pages  = 0;
    uint64_t  chunk_size;

    // Loop, reading chunks that do not straddle page boundaries
    while (chunk_addr < (address + size)) {
	uint64_t addr_of_next_page = (chunk_addr & MASK_TO_PAGE_START) + PAGE_SIZE;

	chunk_size = ((addr_of_next_page < (address + size))
		      ? (addr_of_next_page - chunk_addr)
		      : ((address + size) - chunk_addr));

	status = AWSteria_AXI4_read_aux (& (buffer [chunk_addr - address]), chunk_size, chunk_addr);
	if (status != 0)
	    return status;

	num_pages++;
	chunk_addr += chunk_size;
    }
    if ((verbosity_AXI4_read >= 1) && (num_pages > 0)) {
	fprintf (stdout, "%s: %0d pages (for size %0ld address %0lx)\n",
		 __FUNCTION__, num_pages, size, address);
	fprintf (stdout, "    Last chunk_addr: 0x%0lx\n", chunk_addr - chunk_size);
    }
    return 0;
}

// ================================================================
// This is a simulation model of AWS library routine 'AWSteria_AXI4_write()'
// which, in the real library aws-fpga (on real HW) operates over PCIe.
// Return 0 for ok, non-zero for error.

// The externally-called API function 'AWSteria_AXI4_write()' is
// given later, below.
// It cannot assume anything about address alignment,
// nor whether data straddles page boundaries.

// ----------------
// This 'aux' function is internal, and performs a single burst
// transaction (up to a page in size). The caller guarantees that
// 'address' and 'size' have been trimmed to be within a page.
// Note: neither the starting address nor the ending address may be
// 64-Byte aligned (beat-aligned).

static
int AWSteria_AXI4_write_aux (uint8_t *buffer, const size_t size, const uint64_t address)
{
    if (verbosity_AXI4_write >= 2) {
	fprintf (stdout, "%s: size %0ld address %0lx\r", __FUNCTION__, size, address);
	fflush (stdout);
    }

    bool            did_some_comms;
    const uint64_t  address_lim = address + size;

    // ----------------
    // Compose and AXI4 WR_ADDR bus request

    AXI4_Wr_Addr_i16_a64_u0  wra;

    // TODO: Check if these defaults are ok
    wra.awid     = 0;
    wra.awlock   = 0;    // "normal"
    wra.awcache  = 0;    // "dev_nonbuf"
    wra.awprot   = 0;    // { data, secure, unpriv }
    wra.awqos    = 0;
    wra.awregion = 0;
    wra.awuser   = 0;

    // Compute burst length
    const uint64_t  first_beat_num = (address           >> OFFSET_IN_BEAT_BITS);
    const uint64_t  last_beat_num  = ((address_lim - 1) >> OFFSET_IN_BEAT_BITS);
    const uint64_t  num_beats      = last_beat_num - first_beat_num + 1;

    wra.awaddr  = address;
    wra.awlen   = num_beats - 1;    // AXI4 coding for num_beats
    wra.awsize  = 0x6;              // AXI4 coding for 64-Byte size
    wra.awburst = 0x1;              // AXI4 coding for 'incrementing' burst

    // ----------------
    // Send the AXI4 WR_ADDR bus request

    if (verbosity_AXI4_write >= 3)
	fprintf (stdout, "\n%s: awaddr %0lx awlen %0d awsize %0x awburst %0x\n",
		 __FUNCTION__, wra.awaddr, wra.awlen, wra.awsize, wra.awburst);
    while (true) {
	// Try to send request
	int status = Bytevec_enqueue_AXI4_Wr_Addr_i16_a64_u0 (awsteria_host_state.p_bytevec_state, & wra);
	if (status == 1) break;
	usleep (10);                     // Wait, if unable to send
	did_some_comms = do_comms ();    // Move data in comms channel
    }
    did_some_comms = do_comms ();        // Move data in comms channel

    // ----------------
    // Send WR_DATA bus burst (num_beats)

    AXI4_Wr_Data_d512_u0  wrd;
    wrd.wuser = 0;

    uint8_t *pb = buffer;

    bool     ok             = true;
    uint64_t beat_addr      = (address & MASK_TO_BEAT_START);
    uint64_t next_beat_addr = beat_addr + BEAT_SIZE;

    for (int beat = 0; beat < num_beats; beat++) {
	// Copy data from buf into AXI4 write-data struct
	uint64_t offset_in_beat = ((beat == 0)
				   ? (address & MASK_TO_OFFSET_IN_BEAT)
				   : 0);
	uint64_t size_in_beat   = ((next_beat_addr > address_lim)
				   ? ((address_lim & MASK_TO_OFFSET_IN_BEAT) - offset_in_beat)
				   : (BEAT_SIZE - offset_in_beat));

	memcpy (& (wrd.wdata [offset_in_beat]), pb, size_in_beat);

	// Set strobe bits according to number of bytes in beat and lane-alignment
	uint64_t  strb = (~ ((uint64_t) 0));
	if (size_in_beat < 64) {
	    strb = 1;
	    strb = (strb << size_in_beat) - 1;    // Set 1's in LSBs
	    strb = (strb << offset_in_beat);      // Align to byte lane
	}
	wrd.wstrb = strb;

	wrd.wlast = (beat == (num_beats - 1));

	if (verbosity_AXI4_write >= 3) {
	    fprintf (stdout, "%s: beat %0d beat_addr %0lx wlast %0d wstrb %0lx wdata:\n  ",
		     __FUNCTION__, beat, beat_addr, wrd.wlast, wrd.wstrb);
	    for (int k = 0; k < 64; k++)
		fprintf (stdout, " %02x", wrd.wdata [k]);
	    fprintf (stdout, "\n");
	    fprintf (stdout, "    offset_in_beat %0ld, size_in_beat %0ld\n",
		     offset_in_beat, size_in_beat);
	}

	// Send the AXI4 write-data beat
	while (true) {
	    // Try to send the beat
	    int status = Bytevec_enqueue_AXI4_Wr_Data_d512_u0  (awsteria_host_state.p_bytevec_state, & wrd);
	    if (status == 1) break;
	    usleep (10);                     // Wait if unable to send
	    did_some_comms = do_comms ();    // Move data in comms channel
	}
	did_some_comms = do_comms ();        // Move data in comms channel

	pb             += size_in_beat;
	beat_addr       = next_beat_addr;
	next_beat_addr += BEAT_SIZE;
    }    

    // ----------------
    // Recieve AXI4 WR_RESP bus response

    AXI4_Wr_Resp_i16_u0  wrr;

    while (true) {
	did_some_comms = do_comms ();    // Move data in comms channel
	if (! did_some_comms)            // Wait if no activity
	    usleep (10);

	// Try to receive the response
	int status = Bytevec_dequeue_AXI4_Wr_Resp_i16_u0 (awsteria_host_state.p_bytevec_state, & wrr);
	if (status == 1) break;          // Successfully received

	if (verbosity_AXI4_write >= 3)
	    fprintf (stdout, "%s: AXI4 WR_RESP wait loop\n", __FUNCTION__);
    }
    if (verbosity_AXI4_write >= 3)
	fprintf (stdout, "%s: complete; bresp = %0d\n", __FUNCTION__, wrr.bresp);

    ok = (wrr.bresp == 0);
    return (! ok);
}

// ----------------
// The API function (externally visible)
// This does not assume anything about address alignment,
// nor whether data straddles page boundaries.

int AWSteria_AXI4_write (void *awsteria_host_state,
			uint8_t *buffer, const size_t size, const uint64_t address)
{
    if (verbosity_AXI4_write >= 1)
	fprintf (stdout, "%s: size %0ld address %0lx\n", __FUNCTION__, size, address);

    check_state_initialized ();

    int       status     = 0;
    uint64_t  chunk_addr = address;
    int       num_pages  = 0;
    uint64_t  chunk_size;

    // Loop, writing chunks that do not straddle page boundaries
    while (chunk_addr < (address + size)) {
	uint64_t addr_of_next_page = (chunk_addr & MASK_TO_PAGE_START) + PAGE_SIZE;

	chunk_size = ((addr_of_next_page < (address + size))
		      ? (addr_of_next_page - chunk_addr)
		      : ((address + size) - chunk_addr));

	status = AWSteria_AXI4_write_aux (& (buffer [chunk_addr - address]), chunk_size, chunk_addr);
	if (status != 0)
	    return status;

	num_pages++;
	chunk_addr += chunk_size;
    }
    if (verbosity_AXI4_write >= 1) {
	fprintf (stdout, "%s: %0d pages (for size %0ld address %0lx)\n",
		 __FUNCTION__, num_pages - 1, size, address);
	fprintf (stdout, "    Last chunk_addr: 0x%0lx\n", chunk_addr - chunk_size);
    }
    return 0;
}

// ================================================================
// This is our simulation model of the corresponding AWS library routine.

int AWSteria_AXI4L_read (void *p_state,
			uint64_t addr, uint32_t *p_data)
{
    int  verbosity2 = 0;
    bool did_some_comms;
    bool ok  = true;

    check_state_initialized ();

    AXI4L_Rd_Addr_a32_u0  rda;
    AXI4L_Rd_Data_d32_u0  rdd;

    rda.araddr = addr;
    rda.arprot = 0;
    rda.aruser = 0;

    if (verbosity2 != 0)
	fprintf (stdout, "%s: enqueue AXI4L Rd_Addr %08x\n", __FUNCTION__, rda.araddr);
    while (true) {
	int status = Bytevec_enqueue_AXI4L_Rd_Addr_a32_u0 (awsteria_host_state.p_bytevec_state,
							   & rda);
	if (status == 1) break;
	usleep (10);
	did_some_comms = do_comms ();
    }

    while (true) {
	did_some_comms = do_comms ();
	if (! did_some_comms)
	    usleep (1000);

	int status = Bytevec_dequeue_AXI4L_Rd_Data_d32_u0 (awsteria_host_state.p_bytevec_state,
							   & rdd);
	if (status == 1) {
	    *p_data = rdd.rdata;
	    ok = (ok && (rdd.rresp == 0));    // AXI4L: rresp is OKAY
	    break;
	}
    }
    if (verbosity2 != 0)
	fprintf (stdout, "%s: rresp %0d, rdata %08x\n",
		 __FUNCTION__, rdd.rresp, rdd.rdata);
    return (! ok);
}

// ================================================================
// This is our simulation model of the corresponding AWS library routine.

int AWSteria_AXI4L_write (void *p_state,
			 uint64_t addr, uint32_t data)
{
    int  verbosity2 = 0;
    bool did_some_comms;
    bool ok  = true;

    check_state_initialized ();

    AXI4L_Wr_Addr_a32_u0  wra;
    AXI4L_Wr_Data_d32     wrd;
    AXI4L_Wr_Resp_u0      wrr;

    wra.awaddr = addr;
    wra.awprot = 0;
    wra.awuser = 0;

    wrd.wdata  = data;
    wrd.wstrb  = 0xFF;

    while (true) {
	int status = Bytevec_enqueue_AXI4L_Wr_Addr_a32_u0 (awsteria_host_state.p_bytevec_state, & wra);
	if (status == 1) break;
	usleep (10);
	did_some_comms = do_comms ();
    }
    while (true) {
	int status = Bytevec_enqueue_AXI4L_Wr_Data_d32 (awsteria_host_state.p_bytevec_state, & wrd);
	if (status == 1) break;
	usleep (10);
	did_some_comms = do_comms ();
    }

    while (true) {
	did_some_comms = do_comms ();
	if (! did_some_comms)
	    usleep (10);

	int status = Bytevec_dequeue_AXI4L_Wr_Resp_u0 (awsteria_host_state.p_bytevec_state, & wrr);
	if (status == 1) {
	    ok = (ok && (wrr.bresp == 0));    // AXI4L: bresp is OKAY
	    break;
	}
    }
    if (verbosity2 != 0)
	fprintf (stdout, "%s: bresp = %0d\n", __FUNCTION__, wrr.bresp);

    return (! ok);
}

// ================================================================
