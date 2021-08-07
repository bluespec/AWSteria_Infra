// Copyright (c) 2021 Bluespec, Inc.  All Rights Reserved.
// Author: Rishiyur S. Nikhil

// ================================================================
// When using AWSteria, the host-side software invokes this API to
// communicate with the FPGA hardware.
// The implementation of this API is specific to each platform.

// ================================================================

#pragma once

// ================================================================
// Initialize the host-side API implementation
// Returns pointer to AWSteria host-side state needed for remaining API calls
// (or NULL if error).

extern
void *AWSteria_Host_init (void);

// Note: in AWS F1, includes fpga_mgmt_init(), fpga_dma_open_queue(), fpga_pci_attach()

// ================================================================
// Takes pointer to AWSteria host-side state
// Return 0 if ok, non-zero if error

extern
int AWSteria_Host_shutdown (void *awsteria_host_state);

// Note: in AWS F1, includes fpga_pci_detach()

// ================================================================
// These are used to communicate with the host-facing AXI4 port on the HW.
// Return 0 if transfer was ok, non-zero if transfer had error.

extern
int AWSteria_AXI4_read (void *awsteria_host_state,
			uint8_t *buffer, const size_t size, const uint64_t address);

extern
int AWSteria_AXI4_write (void *awsteria_host_state,
			 uint8_t *buffer, const size_t size, const uint64_t address);

// Note: in AWS these invoke 'fpga_dma_burst_{read,write}()', respectively.
//     awsteria_host_state contains int read_fd for read and int write_fd for write.

// ================================================================
// These are used to communicate with the host-facing AXI4-Lite port on the HW.
// Return 0 if transfer was ok, non-zero if transfer had error.

extern
int AWSteria_AXI4L_read (void *awsteria_host_state,
			 uint64_t addr, uint32_t *p_data);

extern
int AWSteria_AXI4L_write (void *awsteria_host_state,
			  uint64_t addr, uint32_t data);

// Note: in AWS these invoke 'fpga_pci_{peek,poke}()', respectively.
//     awsteria_host_state contains a pci_bar_handle_t handle for the two calls.

// ================================================================
