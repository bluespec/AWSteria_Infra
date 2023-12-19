
#ifndef __ACXPCIE_H__
#define __ACXPCIE_H__

#include "libawsteria.h"

#ifdef __cplusplus
extern "C"
{
#endif

struct AWSteria_desc *acxpcie_open(void *param, size_t size);
void acxpcie_close(struct AWSteria_desc *desc);
int acxpcie_axi4_read(struct AWSteria_desc *desc, void *data, size_t size, awst_addr_t addr);
int acxpcie_axi4_write(struct AWSteria_desc *desc, const void *data, size_t size, awst_addr_t addr);
int acxpcie_axi4l_read(struct AWSteria_desc *desc, awst_addr_t addr, uint32_t *pdata);
int acxpcie_axi4l_write(struct AWSteria_desc *desc, awst_addr_t addr, uint32_t data);
int acxpcie_get_interrupt_fd(struct AWSteria_desc *desc, unsigned int interrupt);

#ifdef __cplusplus
}
#endif

#endif
