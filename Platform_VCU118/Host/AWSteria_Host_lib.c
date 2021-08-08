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
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#include <sys/types.h>
#include <sys/mman.h>

// ----------------
// Project includes

#include "AWSteria_Host_lib.h"

// ================================================================

static char AXI4_r_devname[] = "/dev/xdma0_c2h_0";
static char AXI4_w_devname[] = "/dev/xdma0_h2c_0";
static char AXI4L_devname[]  = "/dev/xdma0_user";

#define RW_MAX_SIZE  0x7ffff000

#define MAP_SIZE     (32*1024UL)

typedef struct {
    // For AXI4
    int  pci_AXI4_w_fd;
    int  pci_AXI4_r_fd;

    // For AXI4L
    int  pci_AXI4L_fd;
    void *map_base;
} AWSteria_Host_State;

// ================================================================
// Initialization

void *AWSteria_Host_init (void)
{
    fprintf (stdout, "%s: AWSteria_Host_init\n", __FUNCTION__);

    AWSteria_Host_State *p_state = (AWSteria_Host_State *) malloc (sizeof (AWSteria_Host_State));
    if (p_state == NULL) {
	perror ("    malloc AWSteria_Host_State");
	return NULL;
    }

    // ----------------
    fprintf (stdout, "    Opening PCIe/AXI4 write device: %s\n", AXI4_w_devname);
    p_state->pci_AXI4_w_fd = open (AXI4_w_devname, O_RDWR);
    if (p_state->pci_AXI4_w_fd < 0) {
	perror("    open device");
	return NULL;
    }
    fprintf (stdout, "        pci_AXI4_w_fd = %0d\n", p_state->pci_AXI4_w_fd);

    // ----------------
    fprintf (stdout, "    Opening PCIe/AXI4 read device: %s\n", AXI4_r_devname);
    p_state->pci_AXI4_r_fd = open (AXI4_r_devname, O_RDWR);
    if (p_state->pci_AXI4_r_fd < 0) {
	perror("open device");
	return NULL;
    }
    fprintf (stdout, "        pci_AXI4_r_fd = %0d\n", p_state->pci_AXI4_r_fd);

    // ----------------
    fprintf (stdout, "    Opening PCIe/AXI4-Lite read/write device: %s\n", AXI4L_devname);
    p_state->pci_AXI4L_fd = open (AXI4L_devname, O_RDWR | O_SYNC);
    if (p_state->pci_AXI4L_fd < 0) {
	perror("open device");
	return NULL;
    }
    fprintf (stdout, "        pci_AXI4L_fd = %0d\n", p_state->pci_AXI4L_fd);

    // Memory-map the device
    fprintf (stdout, "    mmap'ing the AXI4-Lite device\n");
    p_state->map_base = mmap (0, MAP_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED,
					 p_state->pci_AXI4L_fd, 0);
    if (p_state->map_base == (void *)-1) {
	perror("mmap device");
	return NULL;
    }
    fprintf (stdout, "        Memory map address base: %p\n", p_state->map_base);

    // ----------------

    return p_state;
}

// ================================================================
// These are used to communicate with the host-facing AXI4 port on the HW.
// Return 0 if transfer was ok, non-zero if transfer had error.

int AWSteria_AXI4_write (void *opaque,
			 uint8_t *buffer, const size_t size, const uint64_t address)
{
    AWSteria_Host_State *p_state = opaque;

    for (uint64_t n_sent = 0; n_sent < size; ) {
	off_t  rc;

	// Set address
	rc = lseek (p_state->pci_AXI4_r_fd, address + n_sent, SEEK_SET);
	if (rc != (address + n_sent)) {
	    perror("seek device");
	    fprintf (stdout, "ERROR: %s (size 0x%lx address 0x%0lx)\n",
		     __FUNCTION__, size, address);
	    fprintf (stdout, "    seek => rc 0x%lx != address + n_sent 0x%0lx\n",
		     rc, n_sent);
	    return -1;
	}

	// Write data from buffer
	size_t count = size - n_sent;
	if (count > RW_MAX_SIZE) count = RW_MAX_SIZE;

	rc = write (p_state->pci_AXI4_w_fd, & (buffer [n_sent]), count);
	if (rc < 0) {
	    perror("write device");
	    fprintf (stdout, "ERROR: %s (size 0x%lx address 0x%0lx)\n",
		     __FUNCTION__, size, address);
	    fprintf (stdout, "    write => rc %0ld; n_sent 0x%lx, count 0x%lx\n",
		     rc, n_sent, count);
	    return -1;
	}
	if (rc != count) {
	    fprintf (stdout, "NOTE: %s (size 0x%lx address 0x%0lx)\n",
		     __FUNCTION__, size, address);
	    fprintf (stdout, "    write => rc %0lx; n_sent 0x%lx, count 0x%lx\n",
		     rc, n_sent, count);
	}
	count += rc;
    }
    return 0;
}

int AWSteria_AXI4_read (void *opaque,
			uint8_t *buffer, const size_t size, const uint64_t address)
{
    AWSteria_Host_State *p_state = opaque;

    for (uint64_t n_sent = 0; n_sent < size; ) {
	off_t  rc;

	// Set address
	rc = lseek (p_state->pci_AXI4_r_fd, address + n_sent, SEEK_SET);
	if (rc != (address + n_sent)) {
	    perror("seek device");
	    fprintf (stdout, "ERROR: %s (size 0x%lx address 0x%0lx)\n",
		     __FUNCTION__, size, address);
	    fprintf (stdout, "    seek => rc 0x%lx != address + n_sent 0x%0lx\n",
		     rc, n_sent);
	    return -1;
	}

	// Read data into buffer
	size_t count = size - n_sent;
	if (count > RW_MAX_SIZE) count = RW_MAX_SIZE;

	rc = read (p_state->pci_AXI4_r_fd, & (buffer [n_sent]), count);
	if (rc < 0) {
	    perror("read device");
	    fprintf (stdout, "ERROR: %s (size 0x%lx address 0x%0lx)\n",
		     __FUNCTION__, size, address);
	    fprintf (stdout, "    read => rc %0ld; n_sent 0x%lx, count 0x%lx\n",
		     rc, n_sent, count);
	    return -1;
	}
	if (rc != count) {
	    fprintf (stdout, "NOTE: %s (size 0x%lx address 0x%0lx)\n",
		     __FUNCTION__, size, address);
	    fprintf (stdout, "    read => rc %0lx; n_sent 0x%lx, count 0x%lx\n",
		     rc, n_sent, count);
	}
	n_sent += rc;
    }
    return 0;
}

// ================================================================
// These are used to communicate with the host-facing AXI4-Lite port on the HW.
// Return 0 if transfer was ok, non-zero if transfer had error.

int AWSteria_AXI4L_write (void *opaque, uint64_t addr, uint32_t data)
{
    AWSteria_Host_State *p_state = opaque;

    uint32_t *p = (uint32_t *) p_state->map_base + addr;

    *p = data;
    return 0;
}

int AWSteria_AXI4L_read (void *opaque, uint64_t addr, uint32_t *p_data)
{
    assert (p_data != NULL);

    AWSteria_Host_State *p_state = opaque;

    uint32_t *p = (uint32_t *) p_state->map_base + addr;

    *p_data = *p;
    return 0;
}

// ================================================================
// Host_shutdown takes pointer to state returned by Host_init
// Return 0 if ok, non-zero if error

int AWSteria_Host_shutdown (void *opaque)
{
    int rc;

    AWSteria_Host_State *p_state = opaque;

    fprintf (stdout, "%s: AWSteria_Host_shutdown\n", __FUNCTION__);

    fprintf (stdout, "    munmap'ing the AXI4-Lite device\n");
    rc = munmap (p_state->map_base, MAP_SIZE);
    if (rc < 0) {
	perror ("munmap device");
	return rc;
    }

    fprintf (stdout, "    Closing PCIe/AXI4-Lite read/write device: %s\n", AXI4L_devname);
    rc = close (p_state->pci_AXI4L_fd);
    if (rc < 0) {
	perror ("close device");
	return rc;
    }

    fprintf (stdout, "    Closing PCIe/AXI4 write device: %s\n", AXI4_w_devname);
    rc = close (p_state->pci_AXI4_w_fd);
    if (rc < 0) {
	perror("close device");
	return rc;
    }

    fprintf (stdout, "    Closing PCIe/AXI4 read device: %s\n", AXI4_r_devname);
    rc = close (p_state->pci_AXI4_r_fd);
    if (rc < 0) {
	perror("close device");
	return rc;
    }

    return 0;
}

// ================================================================
