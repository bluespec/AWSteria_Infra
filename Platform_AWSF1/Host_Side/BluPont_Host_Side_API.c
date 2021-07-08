// Copyright (c) 2020-2021 Bluespec, Inc.  All Rights Reserved

// This library implements the BluPont host-side API routines
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
// AWS FPGA SDK includes

#include "fpga_pci.h"

// This defines:
//   int fpga_pci_attach(int slot_id, int pf_id, int bar_id, uint32_t flags, pci_bar_handle_t *handle);
//   int fpga_pci_poke(pci_bar_handle_t handle, uint64_t offset, uint32_t value);
//   int fpga_pci_peek(pci_bar_handle_t handle, uint64_t offset, uint32_t *value);
//   int fpga_pci_detach(pci_bar_handle_t handle);

#include "fpga_mgmt.h"
#include "fpga_dma.h"
#include "utils/lcd.h"

#include <sys/syscall.h>

/*
static inline ssize_t getentropy (void *buf, size_t buflen) {
    unsigned int flags = 0;
    return syscall (SYS_getrandom, buf, buflen, flags);
}
*/

// ----------------
// Project includes

#include "BluPont_Host_Side_API.h"

// ================================================================

typedef struct {
    int  pci_slot_id;
    int  pci_pf_id;
    int  pci_bar_id;
    pci_bar_handle_t  pci_bar_handle;

    int  pci_read_fd;     // For DMA over AXI4
    int  pci_write_fd;    // For DMA over AXI4
} BluPont_Host_State;

static
BluPont_Host_State  blupont_host_state = { 0, 0, 0, PCI_BAR_HANDLE_INIT, -1, -1 };

// ================================================================
// Initialization

void *BluPont_Host_Side_init (void)
{
    int rc;

    // ----------------
    // Initialize FPGA management library
    rc = fpga_mgmt_init ();    // Note: calls fpga_pci_init ();
    if (rc != 0) {
	fprintf (stdout, "%s: fpga_mgmt_init() FAILED: rc = %0d\n",
		 __FUNCTION__, rc);
	return NULL;
    }
    fprintf (stdout, "%s: fpga_mgmt_init() done\n", __FUNCTION__);
    fprintf (stdout, "    pci_slot_id = %0d\n", blupont_host_state.pci_slot_id);

    // ----------------
    // Open file descriptor for DMA read over AXI4
    blupont_host_state.pci_read_fd = fpga_dma_open_queue (FPGA_DMA_XDMA,
							  blupont_host_state.pci_slot_id,
							  0,        // channel
							  true);    // is_read
    if (blupont_host_state.pci_read_fd < 0) {
	fprintf (stdout, "ERROR: %s: unable to open read-dma queue\n",
		 __FUNCTION__);
	return NULL;
    }
    fprintf (stdout, "%s: opened PCI read-dma queue; pci_read_fd = %0d\n",
	     __FUNCTION__, blupont_host_state.pci_read_fd);

    // ----------------
    // Open file descriptor for DMA write over AXI4
    blupont_host_state.pci_write_fd = fpga_dma_open_queue(FPGA_DMA_XDMA,
							  blupont_host_state.pci_slot_id,
							  0,         // channel
							  false);    // is_read
    if (blupont_host_state.pci_write_fd < 0) {
	fprintf (stdout, "ERROR: %s: unable to open write-dma queue\n",
		 __FUNCTION__);
	return NULL;
    }
    fprintf (stdout, "%s: opened PCI write-dma queue; pci_write_fd = %0d\n",
	     __FUNCTION__, blupont_host_state.pci_write_fd);

    // ----------------
    // Attach to PCI for peek/poke calls

    int fpga_pci_attach_flags = 0;

    fprintf (stdout, "%s: fpga_pci_attach: pci_pf_id %0d, pci_bar_id %0d, pci_bar_handle %0x\n",
	     __FUNCTION__,
	     blupont_host_state.pci_pf_id,
	     blupont_host_state.pci_bar_id,
	     blupont_host_state.pci_bar_handle);

    rc = fpga_pci_attach (blupont_host_state.pci_slot_id,
			  blupont_host_state.pci_pf_id,
			  blupont_host_state.pci_bar_id,
			  fpga_pci_attach_flags,
			  & blupont_host_state.pci_bar_handle);
    if (rc != 0) {
	fprintf (stdout, "    FAILED: rc = %0d\n", rc);
	return NULL;
    }
    fprintf (stdout, "     => pci_bar_handle %0d\n", blupont_host_state.pci_bar_handle);
    return & blupont_host_state;
}

// ================================================================
// These are used to communicate with the host-facing AXI4 port on the HW.
// Return 0 if transfer was ok, non-zero if transfer had error.

int BluPont_AXI4_read (void *opaque,
		       uint8_t *buffer, const size_t size, const uint64_t address)
{
    BluPont_Host_State *blupont_host_state = opaque;

    int rc = fpga_dma_burst_read (blupont_host_state->pci_read_fd, buffer, size, address);
    return rc;
}

int BluPont_AXI4_write (void *opaque,
			uint8_t *buffer, const size_t size, const uint64_t address)
{
    BluPont_Host_State *blupont_host_state = opaque;

    int rc = fpga_dma_burst_write (blupont_host_state->pci_write_fd, buffer, size, address);
    return rc;
}

// ================================================================
// These are used to communicate with the host-facing AXI4-Lite port on the HW.
// Return 0 if transfer was ok, non-zero if transfer had error.

int BluPont_AXI4L_read (void *opaque, uint64_t addr, uint32_t *p_data)
{
    BluPont_Host_State *blupont_host_state = opaque;

    int rc = fpga_pci_peek (blupont_host_state->pci_bar_handle, addr, p_data);
    return rc;
}

int BluPont_AXI4L_write (void *opaque, uint64_t addr, uint32_t data)
{
    BluPont_Host_State *blupont_host_state = opaque;

    int rc = fpga_pci_poke (blupont_host_state->pci_bar_handle, addr, data);
    return rc;
}

// Note: in AWS these invoke 'fpga_pci_{peek,poke}()', respectively.
//     blupont_host_state contains a pci_bar_handle_t handle for the two calls.

// ================================================================
// Host_shutdown takes pointer to state returned by Host_init
// Return 0 if ok, non-zero if error

int BluPont_Host_Side_shutdown (void *opaque)
{
    BluPont_Host_State *blupont_host_state = opaque;

    int rc = fpga_pci_detach (blupont_host_state->pci_bar_handle);
    if (rc != 0) {
	fprintf (stdout, "main: fpga_pci_detach() FAILED: rc = %0d\n", rc);
	return 1;
    }
    return 0;
}

// ================================================================
