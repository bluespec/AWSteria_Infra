
#ifndef __LIBAWSTERIA_COMPAT_H__
#define __LIBAWSTERIA_COMPAT_H__

#include <stdint.h>

#ifndef EXCLUDE_SIM
void *AWSteria_Host_init_Sim(void);
int AWSteria_Host_shutdown_Sim(void *awsteria_host_state);
int AWSteria_AXI4_read_Sim(void *awsteria_host_state, uint8_t *buffer, const size_t size, const uint64_t address);
int AWSteria_AXI4_write_Sim(void *awsteria_host_state, uint8_t *buffer, const size_t size, const uint64_t address);
int AWSteria_AXI4L_read_Sim(void *awsteria_host_state, uint64_t addr, uint32_t *p_data);
int AWSteria_AXI4L_write_Sim(void *awsteria_host_state, uint64_t addr, uint32_t data);
int AWSteria_get_interrupt_fd_Sim(void *awsteria_host_state, unsigned int interrupt);
#endif

#ifndef EXCLUDE_XDMA
void *AWSteria_Host_init_XDMA(void);
int AWSteria_Host_shutdown_XDMA(void *awsteria_host_state);
int AWSteria_AXI4_read_XDMA(void *awsteria_host_state, uint8_t *buffer, const size_t size, const uint64_t address);
int AWSteria_AXI4_write_XDMA(void *awsteria_host_state, uint8_t *buffer, const size_t size, const uint64_t address);
int AWSteria_AXI4L_read_XDMA(void *awsteria_host_state, uint64_t addr, uint32_t *p_data);
int AWSteria_AXI4L_write_XDMA(void *awsteria_host_state, uint64_t addr, uint32_t data);
int AWSteria_get_interrupt_fd_XDMA(void *awsteria_host_state, unsigned int interrupt);
#endif

#endif
