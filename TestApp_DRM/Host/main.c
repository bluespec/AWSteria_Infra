// Copyright (c) 2020-2022 Bluespec, Inc.  All Rights Reserved
// Author: Rishiyur S. Nikhil

// This program performs a series of AXI4 and AXI4L reads and writes
// to test AWSteria_Infra.

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

#include "AWSteria_Platform.h"
#include "accelize/drmc.h"
#include "AWSteria_Host_lib.h"


#include <stdio.h>

// Define functions to read and write FPGA registers to use them as
// callbacks in DrmManager.
#define drm_controller_base_addr 0x100000
void *AWSteria_Host_state = NULL;


int read_register( uint32_t offset, uint32_t* value, void* user_p ) {
  return  AWSteria_AXI4L_read (AWSteria_Host_state, drm_controller_base_addr + offset, value);
}

int write_register( uint32_t offset, uint32_t value, void* user_p ) {

  return  AWSteria_AXI4L_write (AWSteria_Host_state, drm_controller_base_addr + offset, value);

}

// Define asynchronous error callback
void asynch_error( const char* err_msg, void* user_p ) {
    fprintf( stderr, "%s", err_msg );
}

// ================================================================

int verbosity_AXI4_R = 0;
int verbosity_AXI4_W = 0;
int verbosity_AXI4L_R = 0;
int verbosity_AXI4L_W = 0;

// ================================================================


uint64_t n_AXI4_reads    = 0;
uint64_t AXI4_read_bytes = 0;

uint64_t n_AXI4_writes    = 0;
uint64_t AXI4_write_bytes = 0;

uint64_t n_AXI4L_writes = 0;
uint64_t n_AXI4L_reads  = 0;

uint64_t num_ERRORS          = 0;
uint64_t num_expected_ERRORS = 0;
uint64_t num_ERRORS_save;

// ================================================================
// Write to FPGA DDR4 using HW-side AXI4 port

void buf_write_AXI4 (uint8_t *wbuf, const int n_bytes, const uint64_t addr)
{
    int rc;

    if (verbosity_AXI4_W != 0)
	fprintf (stdout, "%s: %0d bytes to addr 0x%0lx\n",
		 __FUNCTION__, n_bytes, addr);

    rc = AWSteria_AXI4_write (AWSteria_Host_state, wbuf, n_bytes, addr);
    if (rc != 0) {
	if (verbosity_AXI4_W == 0)
	    fprintf (stdout, "ERROR: %s: %0d bytes to addr 0x%0lx\n",
		     __FUNCTION__, n_bytes, addr);
	fprintf (stdout, "    FAILED: rc = %0d\n", rc);
	num_ERRORS++;
    }
    else {
	n_AXI4_writes++;
	AXI4_write_bytes += n_bytes;
    }
}

// ================================================================
// Read from FPGA DDR4 using HW-side AXI4 port, and check against wbuf

void buf_read_AXI4 (uint8_t *rbuf, const int n_bytes, const uint64_t addr,
		    const uint8_t *wbuf)
{
    int rc;

    if (verbosity_AXI4_R != 0)
	fprintf (stdout, "%s: %0d bytes from addr 0x%0lx\n",
		 __FUNCTION__, n_bytes, addr);

    rc = AWSteria_AXI4_read (AWSteria_Host_state, rbuf, n_bytes, addr);
    if (rc != 0) {
	if (verbosity_AXI4_R == 0)
	    fprintf (stdout, "ERROR: %s: %0d bytes from addr 0x%0lx\n",
		     __FUNCTION__, n_bytes, addr);
	fprintf (stdout, "    FAILED: rc = %0d\n", rc);
	num_ERRORS++;
	return;
    }

    int n_mismatches = 0;
    for (int j = 0; j < n_bytes; j++) {
	if (wbuf [j] != rbuf [j]) {
	    if (verbosity_AXI4_R > 1)
		fprintf (stdout, "    Wrote %02x readback %02x\n",
			 wbuf [j], rbuf [j]);
	    n_mismatches++;
	}
    }

    if (n_mismatches == 0) {
	n_AXI4_reads++;
	AXI4_read_bytes += n_bytes;

	if (verbosity_AXI4_R != 0)
	    fprintf (stdout, "    Readback check OK\n");
    }
    else {
	if (verbosity_AXI4_R == 0)
	    fprintf (stdout, "ERROR: %s: %0d bytes from addr 0x%0lx\n",
		     __FUNCTION__, n_bytes, addr);
	fprintf (stdout, "    Readback check FAILED with %0d mismatches\n", n_mismatches);
	num_ERRORS += n_mismatches;
    }
}

// ================================================================
// Write to FPGA DDR4 using HW-side AXI4-Lite port

void buf_write_AXI4L (uint8_t *wbuf, const uint64_t addr)
{
    int rc;
    uint32_t *p32 = (uint32_t *) wbuf;
  
   if (verbosity_AXI4L_W != 0)
	fprintf (stdout, "%s: addr 0x%0lx  data 0x%0x\n",
		 __FUNCTION__, addr, *p32);

    if ((addr & 0xFFFFFFFF00000000llu) != 0) {
	fprintf (stdout, "ERROR: %s: addr %0lx is > 32 bits\n", __FUNCTION__, addr);
	return;
    }

    rc = AWSteria_AXI4L_write (AWSteria_Host_state, addr, *p32);
    if (rc != 0) {
	fprintf (stdout, "ERROR: %s: 4 bytes to addr 0x%0lx\n", __FUNCTION__, addr);
	fprintf (stdout, "    FAILED: rc = %0d\n", rc);
	num_ERRORS++;
    }
    else {
	n_AXI4L_writes++;
    }
}

// ================================================================
// Read from FPGA DDR4 using HW-side AXI4-Lite port, and check against wbuf

void buf_read_AXI4L (uint8_t *rbuf, const uint64_t addr, const uint8_t *wbuf)
{
    int rc;

    if (verbosity_AXI4L_R != 0)
	fprintf (stdout, "%s: addr 0x%0lx\n",
		 __FUNCTION__, addr);

     if ((addr & 0xFFFFFFFF00000000llu) != 0) {
	fprintf (stdout, "ERROR: %s: addr %0lx is > 32 bits\n", __FUNCTION__, addr);
	return;
    }

    rc = AWSteria_AXI4L_read (AWSteria_Host_state, addr, (uint32_t *) rbuf);
    if (rc != 0) {
	fprintf (stdout, "ERROR: %s: 4 bytes from addr 0x%0lx\n", __FUNCTION__, addr);
	fprintf (stdout, "    FAILED: rc = %0d\n", rc);
	num_ERRORS++;
	return;
    }

    int n_mismatches = 0;
    for (int j = 0; j < 4; j++) {
	if (wbuf [j] != rbuf [j]) {
	    if (verbosity_AXI4L_R > 0) {
		fprintf (stdout, "ERROR: %s addr 0x%0lx [%0d]\n", __FUNCTION__, addr, j);
		fprintf (stdout, "    Wrote %02x readback %02x\n", wbuf [j], rbuf [j]);
	    }
	    n_mismatches++;
	}
    }

    if (n_mismatches == 0) {
	n_AXI4L_reads++;
	if (verbosity_AXI4L_R != 0)
	    fprintf (stdout, "    Readback check OK\n");
    }
    else {
	fprintf (stdout, "ERROR: %s: 4 bytes from addr 0x%0lx\n", __FUNCTION__, addr);
	fprintf (stdout, "    Readback check FAILED with %0d mismatches\n", n_mismatches);
	num_ERRORS += n_mismatches;
    }
}

// ****************************************************************
// TESTS

// Buffers for data read and write

#define BUFSIZE 0x2000
uint8_t wbuf [BUFSIZE];
uint8_t rbuf [BUFSIZE];

void test0 (uint64_t base_addr)
{
    fprintf (stdout, "\n");
    fprintf (stdout, "%s: ----------------\n", __FUNCTION__);
    fprintf (stdout, "AXI4: Single-byte write, base_addr 0x%0lx\n", base_addr);
    buf_write_AXI4 (wbuf, 1, base_addr);
    fprintf (stdout, "AXI4: Single-byte read, base_addr 0x%0lx\n", base_addr);
    buf_read_AXI4  (rbuf, 1, base_addr, wbuf);
}

void test50 (uint64_t base_addr)
{
    fprintf (stdout, "\n");
    fprintf (stdout, "%s: ----------------\n", __FUNCTION__);
    fprintf (stdout, "AXI4: Series of small writes/reads across first 128 bytes\n");
    fprintf (stdout, "    base_addr = 0x%0lx\n", base_addr);
    fprintf (stdout, "    at sizes 1, 2, 4, 8 bytes\n");

    for (int size = 1; size <= 8; size = 2 * size) {
	for (int j = 0; j < 128; j += size)
	    buf_write_AXI4 (& (wbuf [j]), size, base_addr + j);

	for (int j = 0; j < 128; j += size)
	    buf_read_AXI4  (& (rbuf [j]), size, base_addr + j, & (wbuf [j]));
    }
}

void test60 (int size, uint64_t base_addr)
{
    fprintf (stdout, "\n");
    fprintf (stdout, "%s: ----------------\n", __FUNCTION__);
    fprintf (stdout, "AXI4: write/read 0x%0x bytes, base_addr 0x%0lx\n", size, base_addr);
    buf_write_AXI4 (wbuf, size, base_addr);
    buf_read_AXI4  (rbuf, size, base_addr, wbuf);
}

void test70 ()
{
    int size   = 0x100;
    int offset = 0x1000;
    fprintf (stdout, "\n");
    fprintf (stdout, "%s: ----------------\n", __FUNCTION__);

    fprintf (stdout, "AXI4: write DDR_A (addr 0x%0llx); data 0x%0x to 0x%0x\n", DDR_A_BASE, 0, size);
    buf_write_AXI4 (wbuf, size, DDR_A_BASE);

    fprintf (stdout, "AXI4: write DDR_B (addr 0x%0llx); data 0x%0x to 0x%0x\n", DDR_B_BASE, offset, offset + size);
    buf_write_AXI4 (& (wbuf [offset]), size, DDR_B_BASE);

    fprintf (stdout, "AXI4: read back DDR_A, testing write B did not overwrite A\n");
    buf_read_AXI4  (rbuf, size, 0, wbuf);

    fprintf (stdout, "AXI4: write DDR_A (addr 0x%0llx); data 0x%0x to %0x\n", DDR_A_BASE, 0, size);
    buf_write_AXI4 (wbuf, size, DDR_A_BASE);

    fprintf (stdout, "AXI4: readback DDR_B, testing write A did not overwrite B)\n");
    buf_read_AXI4  (& (rbuf [offset]), size, DDR_B_BASE, & (wbuf [offset]));
}

void test80 ()
{
    fprintf (stdout, "\n");
    fprintf (stdout, "%s: ----------------\n", __FUNCTION__);
    fprintf (stdout, "AXI4L: Series of 4 byte write/read across first 128 bytes\n");

    for (int addr = 0; addr < 128; addr += 4) {
	buf_write_AXI4L (wbuf, addr);
	buf_read_AXI4L  (rbuf, addr, wbuf);
    }
}

void test90 (uint32_t base_addr)
{
    fprintf (stdout, "\n");
    fprintf (stdout, "%s: ----------------\n", __FUNCTION__);
    fprintf (stdout, "AXI4 write, AXI4-Lite read, base_addr 0x%0x\n", base_addr);
    if (base_addr >= 0x8000) {
	fprintf (stdout, "ERROR: only addrs < 0x8000\n");
	return;
    }

    // Write via AXI4
    fprintf (stdout, "AXI4 write 128 bytes\n");
    buf_write_AXI4 (wbuf, 128, base_addr);

    // Readback via AXI4L
    fprintf (stdout, "AXI4L: readback 128 bytes\n");
    for (int j = 0; j < 128; j += 4)
	buf_read_AXI4L (& (rbuf [j]), base_addr + j, & (wbuf [j]));
}

void test100 (uint32_t base_addr)
{
    fprintf (stdout, "\n");
    fprintf (stdout, "%s: ----------------\n", __FUNCTION__);
    fprintf (stdout, "\n");
    fprintf (stdout, "AXI4 write, AXI4-Lite read, base_addr 0x%0x\n", base_addr);
    if (base_addr >= 0x8000) {
	fprintf (stdout, "ERROR: only addrs < 0x8000\n");
	return;
    }

    // Write via AXI4L
    fprintf (stdout, "AXI4L write 128 bytes\n");
    for (int j = 0; j < 128; j += 4)
	buf_write_AXI4L (& (wbuf [j]), base_addr + j);

    // Readback via AXI4
    fprintf (stdout, "AXI4: readback 128 bytes\n");
    buf_read_AXI4 (rbuf, 128, base_addr, wbuf);
}

void test990 ()
{
    fprintf (stdout, "\n");
    fprintf (stdout, "%s: ----------------\n", __FUNCTION__);

    fprintf (stdout, "AXI4: Single-byte write, out-of-bounds addr 0x%0llx\n", OUT_OF_BOUNDS_ADDR);
    buf_write_AXI4 (wbuf, 1, OUT_OF_BOUNDS_ADDR);

    fprintf (stdout, "----\n");
    fprintf (stdout, "AXI4: Single-byte read, out-of-bounds addr 0x%0llx\n", OUT_OF_BOUNDS_ADDR);
    buf_read_AXI4  (rbuf, 1, OUT_OF_BOUNDS_ADDR, wbuf);
}

// ****************************************************************
// MAIN

void print_help (int argc, char *argv [])
{
    fprintf (stdout, "Usage:  %s\n", argv [0]);
    fprintf (stdout, "    Assumes AWSteria HW-side is ready and awaiting contact\n");
    fprintf (stdout, "    Does various random reads and writes, exercising the API, with self-checks\n");
}

// ----------------

int main (int argc, char *argv [])
{
    int rc=0;



    if ((argc > 1)
	&& ((strcmp (argv [1], "--help") == 0)
	    || (strcmp (argv [1], "-h") == 0))) {
	print_help (argc, argv);
	return 0;
    }

    // ----------------------------------------------------------------
    // Initialize AWSteria host-side API libs

    fprintf (stdout, "Initializing AWSteria host-side API libs\n");
    AWSteria_Host_state = AWSteria_Host_init ();
    if (AWSteria_Host_state == NULL) goto ret_err;

    // Instantiate DrmManager with previously defined functions and
    // configuration files

     DrmManager* drm_manager = NULL;
    int ctx = 0;
    const uint32_t word_IP_on  = 0xDACAFE99;
    const uint32_t word_IP_off = 0xABCDEF40;

    if (DrmManager_alloc(


        &drm_manager,
        // Configuration files paths
        "./conf.json",
        "./cred.json",
        // Read/write register functions callbacks
        read_register,
        write_register,
        // Asynchronous error callback
        asynch_error,
        &ctx))
        {
        // In the C case, the last error message is stored inside the
        // "DrmManager"
        fprintf( stderr, "%s", drm_manager->error_message );
        } 

    if ( DrmManager_activate( drm_manager, false ) )
    fprintf( stderr, "%s", drm_manager->error_message );
    fprintf (stdout, "DRM_activation_done\n");

    // ----------------------------------------------------------------
    // Fill wbuf with random data

    fprintf (stdout, "Filling wbuf with random data\n");
    // Note: getentropy() man page says its size argument must be <= 256
    // so we fill this buffer in chunks of 256
    for (int j = 0; j < BUFSIZE; j += 256) {
	size_t len = (BUFSIZE -j);
	if (len > 256) len = 256;

	int n = getentropy (& (wbuf [j]), len);
	if (n != 0) {
	    fprintf (stdout, "    getentropy(buf, %0ld) failed; => %0d\n", len, n);
	    rc = 1;
	    goto ret_err;
	}
    }
    fprintf (stdout, "    filled wbuf with random data\n");

    // ----------------------------------------------------------------
    // Tests

    fprintf (stdout, "\n");
    fprintf (stdout, "Performing tests ...\n");

    // ----------------
    test0 (DDR_A_BASE);
    if (test_DDR_B) test0 (DDR_B_BASE);

    // ----------------
    test50 (DDR_A_BASE);
    if (test_DDR_B) test50 (DDR_B_BASE);

    // ----------------
    test60 (0x2000, DDR_A_BASE);
    if (test_DDR_B) test60 (0x2000, DDR_B_BASE);

    test60 (0x1001, DDR_A_BASE + 5);
    if (test_DDR_B) test60 (0x1001, DDR_B_BASE + 5);

    // ----------------
    if (test_DDR_B) test70 ();

    // ----------------
    test80 ();

    // ----------------
    test90 (0);

    // ----------------
    test100 (0);

    // ----------------
    test990 ();
    fprintf (stdout, "---- Test write to DRM [0], enabling IP (lsb 1)\n");
    wdata = word_IP_on;
    buf_write_AXI4L (p_wdata, drm_addr_min);

    fprintf (stdout, "---- Test read from DRM [0]\n");
    buf_read_AXI4L (p_rdata, drm_addr_min, p_wdata);

    fprintf (stdout, "---- Test write to DRM [0], disabling IP (lsb 0)\n");
    wdata = word_IP_off;
    buf_write_AXI4L (p_wdata, drm_addr_min);

    fprintf (stdout, "---- Test read from DRM [0]\n");
    buf_read_AXI4L (p_rdata, drm_addr_min, p_wdata);

    fprintf (stdout, "---- Test write to DRM [0], enabling IP (lsb 1)\n");
    wdata = word_IP_on;
    buf_write_AXI4L (p_wdata, drm_addr_min);

    fprintf (stdout, "---- Test read from DRM [0]\n");
    buf_read_AXI4L (p_rdata, drm_addr_min, p_wdata);

    // ----------------
    // Test unaligned read/write to DRM

    fprintf (stdout, "================================================================\n");
    fprintf (stdout, "---- Test unaligned write to DRM [3] (expect error)\n");
    wdata = 0x11111111;
    num_ERRORS_save = num_ERRORS;
    buf_write_AXI4L (p_wdata, drm_addr_min + 3);
    num_expected_ERRORS += num_ERRORS - num_ERRORS_save;
    num_ERRORS = num_ERRORS_save;

    // Readback aligned word containing DRM [3]; should not have changed
    fprintf (stdout, "---- Test read from DRM [0]\n");
    wdata = word_IP_on;    // last-written word
    buf_read_AXI4L (p_rdata, drm_addr_min, p_wdata);

    fprintf (stdout, "---- Test unaligned read from DRM [3] (expect error)\n");
    wdata = 0x11111111;
    num_ERRORS_save = num_ERRORS;
    buf_read_AXI4L (p_rdata, drm_addr_min + 3, p_wdata);
    num_expected_ERRORS += num_ERRORS - num_ERRORS_save;
    num_ERRORS = num_ERRORS_save;

    // ----------------
    // Test illegal read/write to DRM using out-of-bounds addrs

    fprintf (stdout, "================================================================\n");
    fprintf (stdout, "---- Test illegal write to DRM, out-of-bounds addr 0x%0x (expect err)\n",
	     drm_addr_max + 1);
    wdata = 0x11111111;
    num_ERRORS_save = num_ERRORS;
    buf_write_AXI4L (p_wdata, drm_addr_max+1);
    num_expected_ERRORS += num_ERRORS - num_ERRORS_save;
    num_ERRORS = num_ERRORS_save;

    fprintf (stdout, "---- Test legal read from DRM (should not have changed)\n");
    wdata = word_IP_on;    // last-written word
    buf_read_AXI4L (p_rdata, drm_addr_min, p_wdata);

    fprintf (stdout, "---- Test illegal read from DRM, out-of-bounds addr 0x%0x (expect err)\n",
	     drm_addr_max + 1);
    wdata = 0x11111111;
    num_ERRORS_save = num_ERRORS;
    buf_read_AXI4L (p_rdata, drm_addr_max+1, p_wdata);
    num_expected_ERRORS += num_ERRORS - num_ERRORS_save;
    num_ERRORS = num_ERRORS_save;

    // ----------------
    // Test read/writes to DDR via AXI4-Lite
    // Assumes adapter_addr_min and adapter_addr_max are legitimate DDR addrs

    fprintf (stdout, "================================================================\n");
    fprintf (stdout, "---- Test write to Mem via AXI4L\n");
    wdata = 0xCAFEDAD7;
    buf_write_AXI4L (p_wdata, adapter_addr_min);

    fprintf (stdout, "---- Test read from Mem via AXI4L\n");
    buf_read_AXI4L (p_rdata, adapter_addr_min, p_wdata);

    fprintf (stdout, "---- Test write to Mem via AXI4L\n");
    wdata = 0xDADABABA;
    buf_write_AXI4L (p_wdata, adapter_addr_max - 3);

    fprintf (stdout, "---- Test read from Mem via AXI4L\n");
    buf_read_AXI4L (p_rdata, adapter_addr_max - 3, p_wdata);

    // ----------------------------------------------------------------
    // Final test stats

    fprintf (stdout, "\n");
    fprintf (stdout, "END OF TESTS; TEST STATS ----------------\n");
    fprintf (stdout, "num_ERRORS = %0ld\n", num_ERRORS);
    fprintf (stdout, "num_expected_ERRORS = %0ld\n", num_expected_ERRORS);
    fprintf (stdout, "n_AXI4_reads  = %0ld, AXI4_read_bytes  = %0ld\n",
	     n_AXI4_reads, AXI4_read_bytes);

    fprintf (stdout, "n_AXI4_writes = %0ld, AXI4_write_bytes = %0ld\n",
	     n_AXI4_writes, AXI4_write_bytes);

    fprintf (stdout, "n_AXI4L_reads  = %0ld (4 bytes each)\n", n_AXI4L_reads);
    fprintf (stdout, "n_AXI4L_writes = %0ld (4 bytes each)\n", n_AXI4L_writes);
    fprintf (stdout, "----------------\n");

       // DRM deactivate and free    
    if ( DrmManager_deactivate( drm_manager, false ) )
    fprintf( stderr, "%s", drm_manager->error_message );
    if ( DrmManager_free( &drm_manager ) )
    fprintf( stderr, "%s", drm_manager->error_message );

  
    // ================================================================
    // Disable DRM and try some reads/writes (should hang/timeout)

    fprintf (stdout, "================================================================\n");
    fprintf (stdout, "---- Test write to DRM [0], disabling IP (lsb 0)\n");
    wdata = word_IP_off;
    buf_write_AXI4L (p_wdata, drm_addr_min);

    fprintf (stdout, "---- Test read from DRM [0]\n");
    buf_read_AXI4L (p_rdata, drm_addr_min, p_wdata);

    fprintf (stdout, "Subsequent reads/writes from AXI4 or AXI4L should hang/timeout\n");

    // ----------------
    // Try write/read to AXI4L to app: should hang/timeout
    if (true) {
	fprintf (stdout, "---- Test write to Mem via AXI4L (expect hang/timeout)\n");
	wdata = 0xCAFEDAD7;
	buf_write_AXI4L (p_wdata, adapter_addr_min);
    }

    if (true) {
	fprintf (stdout, "---- Test read from Mem via AXI4L (expect hang/timeout)\n");
	buf_read_AXI4L (p_rdata, adapter_addr_min, p_wdata);
    }

    // ----------------
    // Try write/read to AXI4 to app: should hang/timeout
    if (true) {
	fprintf (stdout, "---- Test write to Mem via AXI4 (expect hang/timeout)\n");
	wdata = 0xCAFEDAD7;
	buf_write_AXI4 (p_wdata, 4, adapter_addr_min);
    }

    if (true) {
	fprintf (stdout, "---- Test read from Mem via AXI4 (expect hang/timeout)\n");
	buf_read_AXI4 (p_rdata, 4, adapter_addr_min, p_wdata);
    }

    // ----------------------------------------------------------------
    // Shutdown FPGA PCIe or simulation libraries

    fprintf (stdout, "Finalizing FPGA lib or simulation lib\n");
    rc = AWSteria_Host_shutdown (AWSteria_Host_state);
    if (rc != 0) goto ret_err;
    // ----------------------------------------------------------------

    return 0;

    // ----------------
 ret_err:
    fprintf (stdout, "ERROR: rc = %0d, errno = %0d\n", rc, errno);
    return 1;
}

// ================================================================
