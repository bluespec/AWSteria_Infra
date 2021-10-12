// Copyright (c) 2020-2021 Bluespec, Inc.  All Rights Reserved
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
#include "AWSteria_Host_lib.h"

// ================================================================
// A constant for the size of each of the 4 AWSteria DDRs

#ifndef DDR_A_BASE
#error DDR_A_BASE is undefined; please define it.
#endif

#ifndef DDR_B_BASE
#error DDR_B_BASE is undefined; please define it.
#endif

#ifndef OUT_OF_BOUNDS_ADDR
#error OUT_OF_BOUNDS_ADDR is undefined; please define it.
#endif


// ================================================================
// On AWS F1, FPGA Developer AMI (CentOS 7), gcc  does not seem to
// define getentropy(), so we define it here.

#ifdef PLATFORM_AWSF1
#include <sys/syscall.h>

int getentropy (void *buf, size_t buflen) {
    if (buflen > 256) return -1;

    unsigned int flags = 0;
    int n = syscall (SYS_getrandom, buf, buflen, flags);
    return ((n == buflen) ? 0 : -1);
}
#endif

// ================================================================

int verbosity_AXI4_R = 0;
int verbosity_AXI4_W = 0;
int verbosity_AXI4L_R = 1;
int verbosity_AXI4L_W = 1;

// ================================================================

void *AWSteria_Host_state = NULL;

uint64_t n_AXI4_reads    = 0;
uint64_t AXI4_read_bytes = 0;

uint64_t n_AXI4_writes    = 0;
uint64_t AXI4_write_bytes = 0;

uint64_t n_AXI4L_writes = 0;
uint64_t n_AXI4L_reads  = 0;

uint64_t num_ERRORS  = 0;

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
// MAIN

void print_help (int argc, char *argv [])
{
    fprintf (stdout, "Usage:  %s\n", argv [0]);
    fprintf (stdout, "    Assumes AWSteria HW-side is ready and awaiting contact\n");
    fprintf (stdout, "    Does various random reads and writes, exercising the API, with self-checks\n");
}

// ----------------

bool test_DDR_B = true;

int main (int argc, char *argv [])
{
    int rc;

    if ((argc > 1)
	&& ((strcmp (argv [1], "--help") == 0)
	    || (strcmp (argv [1], "-h") == 0))) {
	print_help (argc, argv);
	return 0;
    }

#ifdef SIM_FOR_VCU118
    fprintf (stdout, "INFO: Simulation built for Platform VCU118 \n");
#endif

#ifdef SIM_FOR_AWSF1
    fprintf (stdout, "INFO: Simulation built for Platform AWSF1 \n");
#endif
    fprintf (stdout, "    DDR_A_BASE = 0x%16llx  DDR_A_LIM = 0x%16llx\n", DDR_A_BASE, DDR_A_LIM);
    if (test_DDR_B) 
    fprintf (stdout, "    DDR_B_BASE = 0x%16llx  DDR_B_LIM = 0x%16llx\n", DDR_B_BASE, DDR_B_LIM);
    fprintf (stdout, "    OUT_OF_BOUNDS_ADDR                         = 0x%16llx\n", OUT_OF_BOUNDS_ADDR);

    // ----------------------------------------------------------------
    // Initialize AWSteria host-side API libs

    fprintf (stdout, "Initializing AWSteria host-side API libs\n");
    AWSteria_Host_state = AWSteria_Host_init ();
    if (AWSteria_Host_state == NULL) goto ret_err;

    // ----------------------------------------------------------------
    // Tests

    fprintf (stdout, "\n");
    fprintf (stdout, "Performing tests ...\n");

    const uint32_t word0_IP_on  = 0xDACAFE99;
    const uint32_t word0_IP_off = 0xABCDEF40;
    const uint32_t word1        = 0x32107654;

    uint32_t wdata;
    uint8_t *p_wdata = ((uint8_t *) (& wdata));
    uint32_t rdata;
    uint8_t *p_rdata = ((uint8_t *) (& rdata));

    uint32_t drm_addr_min     = 0x00000000;
    uint32_t drm_addr_max     = 0x0000FFFF;

    uint32_t adapter_addr_min = 0x80000000;
    uint32_t adapter_addr_max = 0xFFFFFFFF;

    fprintf (stdout, "---------------- Test write to DRM [0], enabling IP (lsb 1)\n");
    wdata = word0_IP_on;
    buf_write_AXI4L (p_wdata, drm_addr_min);

    fprintf (stdout, "---------------- Test read from DRM [0]\n");
    wdata = word0_IP_on;
    buf_read_AXI4L (p_rdata, drm_addr_min, p_wdata);

    fprintf (stdout, "---------------- Test write to DRM [4]\n");
    wdata = word1;
    buf_write_AXI4L (p_wdata, drm_addr_min + 4);

    fprintf (stdout, "---------------- Test read from DRM [4]\n");
    wdata = word1;
    buf_read_AXI4L (p_rdata, drm_addr_min + 4, p_wdata);

    fprintf (stdout, "---------------- Test write to DRM [0], disabling IP (lsb 0)\n");
    wdata = word0_IP_off;
    buf_write_AXI4L (p_wdata, drm_addr_min);

    fprintf (stdout, "---------------- Test read from DRM [0]\n");
    buf_read_AXI4L (p_rdata, drm_addr_min, p_wdata);

    // ----------------
    // Test unaligned read/write to DRM

    fprintf (stdout, "================================================================\n");
    fprintf (stdout, "---------------- Test unaligned write to DRM [3]\n");
    wdata = 0x11111111;
    buf_write_AXI4L (p_wdata, drm_addr_min + 3);

    fprintf (stdout, "---------------- Test read from DRM [0]\n");
    wdata = (0x11000000 | (word0_IP_off & 0x00FFFFFF));
    buf_read_AXI4L (p_rdata, drm_addr_min, p_wdata);

    fprintf (stdout, "---------------- Test read from DRM [1]\n");
    wdata = ((word1 & 0xFF000000) | 0x111111);
    buf_read_AXI4L (p_rdata, drm_addr_min + 4, p_wdata);

    fprintf (stdout, "---------------- Test unaligned read from DRM [3]\n");
    wdata = 0x11111111;
    buf_read_AXI4L (p_rdata, drm_addr_min + 3, p_wdata);

    // ----------------
    // Test illegal read/write to DRM using out-of-bounds addrs

    fprintf (stdout, "================================================================\n");
    fprintf (stdout, "---------------- Test illegal write to DRM, out-of-bounds addr 0x%0x\n", drm_addr_max + 1);
    wdata = 0x11111111;
    buf_write_AXI4L (p_wdata, drm_addr_max+1);

    fprintf (stdout, "---------------- Test legal read from DRM (should not have changed)\n");
    wdata = (0x11000000 | (word0_IP_off & 0x00FFFFFF));
    buf_read_AXI4L (p_rdata, drm_addr_min, p_wdata);

    fprintf (stdout, "---------------- Test read from DRM, out-of-bounds addr 0x%0x\n", drm_addr_max + 1);
    wdata = 0x11111111;
    buf_read_AXI4L (p_rdata, drm_addr_max+1, p_wdata);

    // ----------------
    // Test read/writes to DDR via AXI4-Lite

    fprintf (stdout, "================================================================\n");
    fprintf (stdout, "---------------- Test write to Mem via AXI4L\n");
    wdata = 0xCAFEDAD7;
    buf_write_AXI4L (p_wdata, adapter_addr_min);

    fprintf (stdout, "---------------- Test read from Mem via AXI4L\n");
    buf_read_AXI4L (p_rdata, adapter_addr_min, p_wdata);

    fprintf (stdout, "---------------- Test write to Mem via AXI4L\n");
    wdata = 0xCAFEDAD9;
    buf_write_AXI4L (p_wdata, adapter_addr_max - 3);

    fprintf (stdout, "---------------- Test read from Mem via AXI4L\n");
    buf_read_AXI4L (p_rdata, adapter_addr_max - 3, p_wdata);

    // ----------------------------------------------------------------
    // Final test stats

    fprintf (stdout, "\n");
    fprintf (stdout, "END OF TESTS; TEST STATS ----------------\n");
    fprintf (stdout, "num_ERRORS = %0ld\n", num_ERRORS);
    fprintf (stdout, "n_AXI4_reads  = %0ld, AXI4_read_bytes  = %0ld\n",
	     n_AXI4_reads, AXI4_read_bytes);

    fprintf (stdout, "n_AXI4_writes = %0ld, AXI4_write_bytes = %0ld\n",
	     n_AXI4_writes, AXI4_write_bytes);

    fprintf (stdout, "n_AXI4L_reads  = %0ld (4 bytes each)\n", n_AXI4L_reads);
    fprintf (stdout, "n_AXI4L_writes = %0ld (4 bytes each)\n", n_AXI4L_writes);
    fprintf (stdout, "----------------\n");

    // ----------------------------------------------------------------
    // Shutdown FPGA PCIe or simulation libraries

    fprintf (stdout, "Finalizing FPGA lib or simulation lib\n");
    rc = AWSteria_Host_shutdown (AWSteria_Host_state);
    if (rc != 0) goto ret_err;

    return 0;

    // ----------------
 ret_err:
    fprintf (stdout, "ERROR: rc = %0d, errno = %0d\n", rc, errno);
    return 1;
}

// ================================================================
