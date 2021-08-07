// Copyright (c) 2020-2021 Bluespec, Inc.  All Rights Reserved
// Author: Rishiyur S. Nikhil

// This module encapsulates communication with a tty (keyboard + screen)

// For now, it's very limited, just for testing: no keyboard input,
// and screen data is immediately written to stdout.  Eventually, this
// should connect to a separate terminal window.

// ================================================================
// C lib includes

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <unistd.h>
#include <sys/time.h>
#include <errno.h>

// ================
// Project includes

#include "BluPont_Host_Side_API.h"

// ================================================================
// On AWS F1, FPGA Developer AMI (CentOS 7), gcc  does not seem to
// define getentropy(), so we define it here.

#if IN_AWSF1
#include <sys/syscall.h>

int getentropy (void *buf, size_t buflen) {
    unsigned int flags = 0;
    return syscall (SYS_getrandom, buf, buflen, flags);
}
#endif

// ================================================================

int verbosity = 0;

// ================================================================

void *blupont_host_state = NULL;

uint64_t n_burst_reads    = 0;
uint64_t burst_read_bytes = 0;

uint64_t n_burst_writes    = 0;
uint64_t burst_write_bytes = 0;

uint64_t n_pokes = 0;
uint64_t n_peeks = 0;

// ================================================================
// Write to FPGA DDR4 using HW-side AXI4 port

void buf_write_AXI4 (uint8_t *wbuf, const int n_bytes, const uint64_t addr)
{
    int rc;

    if (verbosity != 0)
	fprintf (stdout, "%s: %0d bytes to addr 0x%0lx\n",
		 __FUNCTION__, n_bytes, addr);

    rc = BluPont_AXI4_write (blupont_host_state, wbuf, n_bytes, addr);
    if (rc != 0)
	fprintf (stdout, "    FAILED: rc = %0d\n", rc);
    else {
	n_burst_writes++;
	burst_write_bytes += n_bytes;
    }
}

// ================================================================
// Read from FPGA DDR4 using HW-side AXI4 port, and check against wbuf

void buf_read_AXI4 (uint8_t *rbuf, const int n_bytes, const uint64_t addr,
		    const uint8_t *wbuf)
{
    int rc;

    if (verbosity != 0)
	fprintf (stdout, "%s: %0d bytes from addr 0x%0lx\n",
		 __FUNCTION__, n_bytes, addr);

    rc = BluPont_AXI4_read (blupont_host_state, rbuf, n_bytes, addr);
    if (rc != 0) {
	fprintf (stdout, "    FAILED: rc = %0d\n", rc);
	return;
    }

    int n_mismatches = 0;
    for (int j = 0; j < n_bytes; j++) {
	if (wbuf [j] != rbuf [j]) {
	    if (verbosity > 1)
		fprintf (stdout, "    Wrote %02x readback %02x\n",
			 wbuf [j], rbuf [j]);
	    n_mismatches++;
	}
    }
    if (n_mismatches == 0) {
	n_burst_reads++;
	burst_read_bytes += n_bytes;

	if (verbosity != 0)
	    fprintf (stdout, "    Readback check OK\n");
    }
    else {
	fprintf (stdout, "ERROR: %s: %0d bytes from addr 0x%0lx\n", __FUNCTION__, n_bytes, addr);
	fprintf (stdout, "    Readback check FAILED with %0d mismatches\n", n_mismatches);
    }
}

// ================================================================
// Write to FPGA DDR4 using HW-side AXI4-Lite port

void buf_write_AXI4L (uint8_t *wbuf, const uint64_t addr)
{
    int rc;

    uint32_t *p32 = (uint32_t *) wbuf;

    if ((addr & 0xFFFFFFFF00000000llu) != 0) {
	fprintf (stdout, "ERROR: %s: addr %0lx is > 32 bits\n", __FUNCTION__, addr);
	return;
    }

    rc = BluPont_AXI4L_write (blupont_host_state, addr, *p32);
    if (rc != 0) {
	fprintf (stdout, "%s: 4 bytes to addr 0x%0lx\n", __FUNCTION__, addr);
	fprintf (stdout, "    FAILED: rc = %0d\n", rc);
    }
    else {
	n_pokes++;
    }
}

// ================================================================
// Read from FPGA DDR4 using HW-side AXI4-Lite port, and check against wbuf

void buf_read_AXI4L (uint8_t *rbuf, const uint64_t addr, const uint8_t *wbuf)
{
    int rc;

    if ((addr & 0xFFFFFFFF00000000llu) != 0) {
	fprintf (stdout, "ERROR: %s: addr %0lx is > 32 bits\n", __FUNCTION__, addr);
	return;
    }

    rc = BluPont_AXI4L_read (blupont_host_state, addr, (uint32_t *) rbuf);
    if (rc != 0) {
	fprintf (stdout, "%s: 4bytes from addr 0x%0lx\n", __FUNCTION__, addr);
	fprintf (stdout, "    FAILED: rc = %0d\n", rc);
	return;
    }

    int n_mismatches = 0;
    for (int j = 0; j < 4; j++) {
	if (wbuf [j] != rbuf [j]) {
	    if (verbosity > 1)
		fprintf (stdout, "    Wrote %02x readback %02x\n", wbuf [j], rbuf [j]);
	    n_mismatches++;
	}
    }
    if (n_mismatches == 0) {
	n_peeks++;
	if (verbosity != 0)
	    fprintf (stdout, "    Readback check OK\n");
    }
    else {
	fprintf (stdout, "ERROR: %s: 4 bytes from addr 0x%0lx\n", __FUNCTION__, addr);
	fprintf (stdout, "    Readback check FAILED with %0d mismatches\n", n_mismatches);
    }
}

// ****************************************************************
// TESTS

// ================================================================
// A constant for the size of each of the 4 BluPont DDRs

uint64_t MEM_16G = 0x400000000llu;
uint64_t MEM_4G  = 0x100000000llu;

// Buffers for bulk-data read and write

#define BUFSIZE 0x2000
uint8_t wbuf [BUFSIZE];
uint8_t rbuf [BUFSIZE];

int sizes [] = { 0, 1, 2, 3, 4, 5, 6, 7, 8 };

void test0 (int size, uint64_t base_addr)
{
    // Series of writes/reads over first 128 bytes
    for (int j = 0; j < 128; j += size)
	buf_write_AXI4 (& (wbuf [j]), sizes [size], base_addr + j);

    for (int j = 0; j < 128; j += size)
	buf_read_AXI4 (& (rbuf [j]), sizes [size], base_addr + j, & (wbuf [j]));
}

void test1 (int size, uint64_t base_addr)
{
    buf_write_AXI4 (wbuf, size, base_addr);
    buf_read_AXI4  (rbuf, size, base_addr, wbuf);
}

void test2 (uint64_t addr)
{
    buf_write_AXI4L (wbuf, addr);
    buf_read_AXI4L  (rbuf, addr, wbuf);
}

void test3 (uint32_t base_addr)
{
    // Write via AXI4
    buf_write_AXI4 (wbuf, 128, base_addr);
    // Readback via AXI4L
    for (int j = 0; j < 128; j += 4)
	buf_read_AXI4L (& (rbuf [j]), base_addr + j, & (wbuf [j]));
}

void test4 (uint32_t base_addr)
{
    // Write via AXI4L
    for (int j = 0; j < 128; j += 4)
	buf_write_AXI4L (& (wbuf [j]), base_addr + j);

    // Readback via AXI4
    buf_read_AXI4 (rbuf, 128, base_addr, wbuf);
}

// ****************************************************************
// MAIN

void print_help (int argc, char *argv [])
{
    fprintf (stdout, "Usage:  %s\n", argv [0]);
    fprintf (stdout, "    Assumes BluPont HW-side is ready and awaiting contact\n");
    fprintf (stdout, "    Does various random reads and writes, exercising the API, with self-checks\n");
}

// ----------------

int main (int argc, char *argv [])
{
    int rc;

    if ((argc > 1)
	&& ((strcmp (argv [1], "--help") == 0)
	    || (strcmp (argv [1], "-h") == 0))) {
	print_help (argc, argv);
	return 0;
    }

    // ----------------------------------------------------------------
    // Initialize BluPont host-side API libs

    fprintf (stdout, "Initializing BluPont host-side API libs\n");
    blupont_host_state = BluPont_Host_Side_init ();
    if (blupont_host_state == NULL) goto ret_err;

    // ----------------------------------------------------------------
    // Fill wbuf with random data

    fprintf (stdout, "Filling wbuf with random data\n");
    // Note: getentropy() man page says its size argument must be <= 256
    // so we fill this buffer in chunks of 256
    for (int j = 0; j < BUFSIZE; j += 256) {
	size_t len = (BUFSIZE -j);
	if (len > 256) len = 256;

	int n = getentropy (& (wbuf [j]), len);
	if (n != len) {
	    fprintf (stdout, "    getentropy(buf, %0ld) failed; => %0d\n", len, n);
	    rc = 1;
	    goto ret_err;
	}
    }
    fprintf (stdout, "    filled wbuf with random data\n");

    // ----------------------------------------------------------------
    // Tests

    fprintf (stdout, "TESTS ----------------\n");
    fprintf (stdout, "\n");
    fprintf (stdout, "AXI4: Single write/read to DDR4 A\n");
    buf_write_AXI4 (wbuf, 1, 0);
    buf_read_AXI4  (rbuf, 1, 0, wbuf);

    fprintf (stdout, "AXI4: Single write/read to DDR4 B\n");
    buf_write_AXI4 (wbuf, 1, MEM_16G);
    buf_read_AXI4  (rbuf, 1, MEM_16G, wbuf);

    // ----------------

    fprintf (stdout, "\n");
    fprintf (stdout, "AXI4: Series of small writes/reads across first 128 bytes, to DDR4 A\n");
    fprintf (stdout, "    at sizes 1, 2, 4, 8 bytes\n");
    for (int size = 1; size <= 8; size = 2 * size) {
	test0 (size, 0);
    }
    fprintf (stdout, "AXI4: Series of small writes/reads across first 128 bytes, to DDR4 B\n");
    fprintf (stdout, "    at sizes 1, 2, 4, 8 bytes\n");
    for (int size = 1; size <= 8; size = 2 * size) {
	test0 (size, MEM_16G);
    }

    // ----------------

    fprintf (stdout, "\n");
    fprintf (stdout, "AXI4: 8KB write/read, aligned, to DDR4 A\n");
    test1 (0x2000, 0);
    fprintf (stdout, "AXI4: 8KB write/read, aligned, to DDR4 B\n");
    test1 (0x2000, MEM_16G);

    // ----------------

    fprintf (stdout, "\n");
    fprintf (stdout, "AXI4: 4KB+1 write/read, unaligned, to DDR4 A\n");
    test1 (0x1001, 5);
    fprintf (stdout, "AXI4: 4KB+1 write/read, unaligned, to DDR4 B\n");
    test1 (0x1001, MEM_16G + 5);

    // ----------------

    fprintf (stdout, "\n");
    fprintf (stdout, "AXI4L: Series of 4 byte write/read across first 128 bytes\n");

    for (int addr = 0; addr < 128; addr += 4)
	test2 (addr);

    // ----------------

    fprintf (stdout, "\n");

    fprintf (stdout, "AXI4: Write 128 bytes to DDR4 A\n");
    fprintf (stdout, "AXI4L: readback 128 bytes from DDR4 A\n");
    test3 (0);

    fprintf (stdout, "AXI4: Write 128 bytes to DDR4 B\n");
    fprintf (stdout, "AXI4L: readback 128 bytes from DDR4 B\n");
    test3 (MEM_16G);

    // ----------------

    fprintf (stdout, "\n");

    fprintf (stdout, "AXI4L: Write 128 bytes to DDR4 A\n");
    fprintf (stdout, "AXI4: readback 128 bytes from DDR4 A\n");
    test4 (0);

    fprintf (stdout, "AXI4L: Write 128 bytes to DDR4 B\n");
    fprintf (stdout, "AXI4: readback 128 bytes from DDR4 B\n");
    test4 (MEM_16G);

    // ----------------------------------------------------------------
    // Final test stats

    fprintf (stdout, "\n");
    fprintf (stdout, "END OF TESTS; TEST STATS ----------------\n");
    fprintf (stdout, "n_burst_reads  = %0ld, burst_read_bytes  = %0ld\n",
	     n_burst_reads, burst_read_bytes);

    fprintf (stdout, "n_burst_writes = %0ld, burst_write_bytes = %0ld\n",
	     n_burst_writes, burst_write_bytes);

    fprintf (stdout, "n_peeks = %0ld\n", n_peeks);
    fprintf (stdout, "n_pokes = %0ld\n", n_pokes);
    fprintf (stdout, "----------------\n");

    // ----------------------------------------------------------------
    // Shutdown FPGA PCIe or simulation libraries

    fprintf (stdout, "Finalizing FPGA lib or simulation lib\n");
    rc = BluPont_Host_Side_shutdown (blupont_host_state);
    if (rc != 0) goto ret_err;

    return 0;

    // ----------------
 ret_err:
    fprintf (stdout, "ERROR: rc = %0d, errno = %0d\n", rc, errno);
    return 1;
}

// ================================================================
