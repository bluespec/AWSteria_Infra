// Copyright (c) 2021 Bluespec, Inc.  All Rights Reserved.
// Author: Rishiyur S. Nikhil

// ================================================================
// When using BluPont, the host-side software invokes this API to
// communicate with the FPGA hardware.

// ================================================================

#pragma once

// ================================================================
// These are used to intialize and shutdown the host-side API library

// Host_init returns pointer to any state needed for the remaining API calls
// Return pointer to host state (or NULL if error)
extern
void *BluPont_Host_Side_init (void);

// Host_shutdown takes pointer to state returned by Host_init
// Return 0 if ok, non-zero if error
extern
int BluPont_Host_Side_shutdown (void *blupont_host_state);

// Note: in AWS F1
// - Host_Side_init includes fpga_mgmt_init(), fpga_dma_open_queue(), fpga_pci_attach()
// - Host_Side_shutdown includes fpga_pci_detach()

// ================================================================
// These are used to communicate with the host-facing AXI4 port on the HW.
// Return 0 if transfer was ok, non-zero if transfer had error.

extern
int BluPont_AXI4_read (void *blupont_host_state,
		       uint8_t *buffer, const size_t size, const uint64_t address);

extern
int BluPont_AXI4_write (void *blupont_host_state,
			uint8_t *buffer, const size_t size, const uint64_t address);

// Note: in AWS these invoke 'fpga_dma_burst_{read,write}()', respectively.
//     blupont_host_state contains int read_fd for read and int write_fd for write.

// ================================================================
// These are used to communicate with the host-facing AXI4-Lite port on the HW.
// Return 0 if transfer was ok, non-zero if transfer had error.

extern
int BluPont_AXI4L_read (void *blupont_host_state,
			uint64_t addr, uint32_t *p_data);

extern
int BluPont_AXI4L_write (void *blupont_host_state,
			 uint64_t addr, uint32_t data);

// Note: in AWS these invoke 'fpga_pci_{peek,poke}()', respectively.
//     blupont_host_state contains a pci_bar_handle_t handle for the two calls.

// ================================================================
