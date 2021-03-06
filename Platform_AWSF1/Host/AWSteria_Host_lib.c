// Copyright (c) 2020-2022 Bluespec, Inc.  All Rights Reserved

// This library implements the AWSteria host-side API routines
// for AWS F1, linking with routines in aws-fpga SDK.

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

// ----------------
// Project includes

#include "AWSteria_Host_lib.h"

// ================================================================

typedef struct {
    int  pci_slot_id;
    int  pci_pf_id;
    int  pci_bar_id;
    pci_bar_handle_t  pci_bar_handle;

    int  pci_read_fd;     // For DMA over AXI4
    int  pci_write_fd;    // For DMA over AXI4
} AWSteria_Host_State;

static int verbosity = 0;

// ================================================================
// Initialization

void *AWSteria_Host_init (void)
{
    if (verbosity > 0)
	fprintf (stdout, "--> %s\n", __FUNCTION__);

    AWSteria_Host_State *p_state = (AWSteria_Host_State *) malloc (sizeof (AWSteria_Host_State));
    if (p_state == NULL) {
	perror ("    malloc AWSteria_Host_State");
	return NULL;
    }
    p_state->pci_slot_id    = 0;
    p_state->pci_pf_id      = 0;
    p_state->pci_bar_id     = 0;
    p_state->pci_bar_handle = PCI_BAR_HANDLE_INIT;
    p_state->pci_read_fd    = -1;
    p_state->pci_write_fd   = -1;

    int rc;

    // ----------------
    // Initialize FPGA management library
    rc = fpga_mgmt_init ();    // Note: calls fpga_pci_init ();
    if (rc != 0) {
	fprintf (stdout, "%s: fpga_mgmt_init() FAILED: rc = %0d\n",
		 __FUNCTION__, rc);
	return NULL;
    }
    if (verbosity > 0) {
	fprintf (stdout, "%s: fpga_mgmt_init() done\n", __FUNCTION__);
	fprintf (stdout, "    pci_slot_id = %0d\n", p_state->pci_slot_id);
    }

    // ----------------
    // Open file descriptor for DMA read over AXI4
    p_state->pci_read_fd = fpga_dma_open_queue (FPGA_DMA_XDMA,
						p_state->pci_slot_id,
						0,        // channel
						true);    // is_read
    if (p_state->pci_read_fd < 0) {
	fprintf (stdout, "ERROR: %s: unable to open read-dma queue\n",
		 __FUNCTION__);
	return NULL;
    }

    if (verbosity > 0)
	fprintf (stdout, "%s: opened PCI read-dma queue; pci_read_fd = %0d\n",
		 __FUNCTION__, p_state->pci_read_fd);

    // ----------------
    // Open file descriptor for DMA write over AXI4
    p_state->pci_write_fd = fpga_dma_open_queue (FPGA_DMA_XDMA,
						 p_state->pci_slot_id,
						 0,         // channel
						 false);    // is_read
    if (p_state->pci_write_fd < 0) {
	fprintf (stdout, "ERROR: %s: unable to open write-dma queue\n",
		 __FUNCTION__);
	return NULL;
    }

    if (verbosity > 0)
	fprintf (stdout, "%s: opened PCI write-dma queue; pci_write_fd = %0d\n",
		 __FUNCTION__, p_state->pci_write_fd);

    // ----------------
    // Attach to PCI for peek/poke calls

    int fpga_pci_attach_flags = 0;

    if (verbosity > 0)
	fprintf (stdout,
		 "%s: fpga_pci_attach: pci_pf_id %0d, pci_bar_id %0d, pci_bar_handle %0x\n",
		 __FUNCTION__,
		 p_state->pci_pf_id,
		 p_state->pci_bar_id,
		 p_state->pci_bar_handle);

    rc = fpga_pci_attach (p_state->pci_slot_id,
			  p_state->pci_pf_id,
			  p_state->pci_bar_id,
			  fpga_pci_attach_flags,
			  & p_state->pci_bar_handle);
    if (rc != 0) {
	fprintf (stdout, "    %s(): call to fpga_pci_attach() FAILED: rc = %0d\n", __FUNCTION__, rc);
	fprintf (stdout, "    Note: this must be run under 'sudo'\n");
	return NULL;
    }
    if (verbosity > 0)
	fprintf (stdout, "     => pci_bar_handle %0d\n", p_state->pci_bar_handle);

    // ----------------
    return p_state;
}

// ================================================================
// These are used to communicate with the host-facing AXI4 port on the HW.
// Return 0 if transfer was ok, non-zero if transfer had error.

int AWSteria_AXI4_write (void *opaque,
			 uint8_t *buffer, const size_t size, const uint64_t address)
{
    assert (opaque != NULL);

    AWSteria_Host_State *p_state = opaque;

    int rc = fpga_dma_burst_write (p_state->pci_write_fd, buffer, size, address);
    return rc;
}

int AWSteria_AXI4_read (void *opaque,
			uint8_t *buffer, const size_t size, const uint64_t address)
{
    assert (opaque != NULL);

    AWSteria_Host_State *p_state = opaque;

    int rc = fpga_dma_burst_read (p_state->pci_read_fd, buffer, size, address);
    return rc;
}

// ================================================================
// These are used to communicate with the host-facing AXI4-Lite port on the HW.
// Return 0 if transfer was ok, non-zero if transfer had error.
// Note: in AWS these invoke 'fpga_pci_{peek,poke}()', respectively.
//     p_state contains a pci_bar_handle_t handle for the two calls.

int AWSteria_AXI4L_write (void *opaque, uint64_t addr, uint32_t data)
{
    assert (opaque != NULL);

    AWSteria_Host_State *p_state = opaque;

    int rc = fpga_pci_poke (p_state->pci_bar_handle, addr, data);
    return rc;
}

int AWSteria_AXI4L_read (void *opaque, uint64_t addr, uint32_t *p_data)
{
    assert (opaque != NULL);

    AWSteria_Host_State *p_state = opaque;

    int rc = fpga_pci_peek (p_state->pci_bar_handle, addr, p_data);
    return rc;
}

// ================================================================
// Host_shutdown takes pointer to state returned by Host_init
// Return 0 if ok, non-zero if error

int AWSteria_Host_shutdown (void *opaque)
{
    AWSteria_Host_State *p_state = opaque;

    int rc = fpga_pci_detach (p_state->pci_bar_handle);
    if (rc != 0) {
	fprintf (stdout, "main: fpga_pci_detach() FAILED: rc = %0d\n", rc);
	return 1;
    }
    return 0;
}

// ================================================================
