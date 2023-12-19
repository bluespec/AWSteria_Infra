
#ifndef __BWPCI_H__
#define __BWPCI_H__

#include "libawsteria.h"

struct AWSteria_desc *bwpci_open(void *param, size_t size);
void bwpci_close(struct AWSteria_desc *desc);
int bwpci_axi4_read(struct AWSteria_desc *desc, void *data, size_t size, awst_addr_t addr);
int bwpci_axi4_write(struct AWSteria_desc *desc, const void *data, size_t size, awst_addr_t addr);
int bwpci_axi4l_read(struct AWSteria_desc *desc, awst_addr_t addr, uint32_t *pdata);
int bwpci_axi4l_write(struct AWSteria_desc *desc, awst_addr_t addr, uint32_t data);
int bwpci_get_interrupt_fd(struct AWSteria_desc *desc, unsigned int interrupt);

#endif
