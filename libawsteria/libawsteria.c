
#include <assert.h>
#include <fcntl.h>
#include <limits.h>
#include <pthread.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>

#include "libawsteria.h"
#include "libawsteria_compat.h"

#ifndef EXCLUDE_SIM

static struct AWSteria_desc *sim_open(void *param, size_t size)
{
	assert(!param || size == sizeof(struct AWSteria_params_Sim));

	struct AWSteria_desc_Sim *desc;

	desc = malloc(sizeof(struct AWSteria_desc_Sim));
	if (!desc)
		return NULL;

	memset(desc, 0, sizeof(*desc));

	desc->state = AWSteria_Host_init_Sim();
	if (!desc->state) {
		free(desc);
		return NULL;
	}

	// The communication channel used by Platform_Sim (bytevec) is
	// not reentrant, so all calls require a mutex.

	pthread_mutex_init(&desc->mutex, NULL);

	return (void*)desc;
}

static void sim_close(struct AWSteria_desc *desc)
{
	struct AWSteria_desc_Sim *simdesc = (void*)desc;

	assert(simdesc);
	assert(simdesc->state);

	pthread_mutex_destroy(&simdesc->mutex);

	AWSteria_Host_shutdown_Sim(simdesc->state);
	free(simdesc);
}

static int sim_axi4_read(struct AWSteria_desc *desc, void *data, size_t size, awst_addr_t addr)
{
	struct AWSteria_desc_Sim *simdesc = (void*)desc;

	assert(simdesc);
	assert(simdesc->state);

	int ret;

	pthread_mutex_lock(&simdesc->mutex);

	ret = AWSteria_AXI4_read_Sim(simdesc->state, data, size, addr);

	pthread_mutex_unlock(&simdesc->mutex);

	return ret;
}

static int sim_axi4_write(struct AWSteria_desc *desc, const void *data, size_t size, awst_addr_t addr)
{
	struct AWSteria_desc_Sim *simdesc = (void*)desc;

	assert(simdesc);
	assert(simdesc->state);

	int ret;

	pthread_mutex_lock(&simdesc->mutex);

	ret = AWSteria_AXI4_write_Sim(simdesc->state, (void*)data, size, addr);

	pthread_mutex_unlock(&simdesc->mutex);

	return ret;
}

static int sim_axi4l_read(struct AWSteria_desc *desc, awst_addr_t addr, uint32_t *pdata)
{
	struct AWSteria_desc_Sim *simdesc = (void*)desc;

	assert(simdesc);
	assert(simdesc->state);

	int ret;

	pthread_mutex_lock(&simdesc->mutex);

	ret = AWSteria_AXI4L_read_Sim(simdesc->state, addr, pdata);

	pthread_mutex_unlock(&simdesc->mutex);

	return ret;
}

static int sim_axi4l_write(struct AWSteria_desc *desc, awst_addr_t addr, uint32_t data)
{
	struct AWSteria_desc_Sim *simdesc = (void*)desc;

	assert(simdesc);
	assert(simdesc->state);

	int ret;

	pthread_mutex_lock(&simdesc->mutex);

	ret = AWSteria_AXI4L_write_Sim(simdesc->state, addr, data);

	pthread_mutex_unlock(&simdesc->mutex);

	return ret;
}

static int sim_get_interrupt_fd(struct AWSteria_desc *desc, unsigned int interrupt)
{
	struct AWSteria_desc_Sim *simdesc = (void*)desc;

	assert(simdesc);
	assert(simdesc->state);
	assert(interrupt < AWSTERIA_INTERRUPT_COUNT);

	int ret;

	pthread_mutex_lock(&simdesc->mutex);

	ret = AWSteria_get_interrupt_fd_Sim(simdesc->state, interrupt);

	pthread_mutex_unlock(&simdesc->mutex);

	return ret;
}
#endif

#ifndef EXCLUDE_XDMA
static struct AWSteria_desc *xdma_open(void *param, size_t size)
{
	assert(!param || size == sizeof(struct AWSteria_params_XDMA));

	struct AWSteria_desc_XDMA *desc;

	desc = malloc(sizeof(struct AWSteria_desc_XDMA));
	if (!desc)
		return NULL;

	memset(desc, 0, sizeof(*desc));

	desc->state = AWSteria_Host_init_XDMA();
	if (!desc->state) {
		free(desc);
		return NULL;
	}

	return (void*)desc;
}

static void xdma_close(struct AWSteria_desc *desc)
{
	struct AWSteria_desc_XDMA *xdmadesc = (void*)desc;

	assert(xdmadesc);
	assert(xdmadesc->state);

	AWSteria_Host_shutdown_XDMA(xdmadesc->state);
	free(xdmadesc);
}

static int xdma_axi4_read(struct AWSteria_desc *desc, void *data, size_t size, awst_addr_t addr)
{
	struct AWSteria_desc_XDMA *xdmadesc = (void*)desc;

	assert(xdmadesc);
	assert(xdmadesc->state);

	return AWSteria_AXI4_read_XDMA(xdmadesc->state, data, size, addr);
}

static int xdma_axi4_write(struct AWSteria_desc *desc, const void *data, size_t size, awst_addr_t addr)
{
	struct AWSteria_desc_XDMA *xdmadesc = (void*)desc;

	assert(xdmadesc);
	assert(xdmadesc->state);

	return AWSteria_AXI4_write_XDMA(xdmadesc->state, (void*)data, size, addr);
}

static int xdma_axi4l_read(struct AWSteria_desc *desc, awst_addr_t addr, uint32_t *pdata)
{
	struct AWSteria_desc_XDMA *xdmadesc = (void*)desc;

	assert(xdmadesc);
	assert(xdmadesc->state);

	return AWSteria_AXI4L_read_XDMA(xdmadesc->state, addr, pdata);
}

static int xdma_axi4l_write(struct AWSteria_desc *desc, awst_addr_t addr, uint32_t data)
{
	struct AWSteria_desc_XDMA *xdmadesc = (void*)desc;

	assert(xdmadesc);
	assert(xdmadesc->state);

	return AWSteria_AXI4L_write_XDMA(xdmadesc->state, addr, data);
}

static int xdma_get_interrupt_fd(struct AWSteria_desc *desc, unsigned int interrupt)
{
	struct AWSteria_desc_XDMA *xdmadesc = (void*)desc;

	assert(xdmadesc);
	assert(xdmadesc->state);
	assert(interrupt < AWSTERIA_INTERRUPT_COUNT);

	return AWSteria_get_interrupt_fd_XDMA(xdmadesc->state, interrupt);
}
#endif

static struct AWSteria_ops platform_ops[] = {
#ifndef EXCLUDE_SIM
	[AWST_PLATFORM_SIM] = {
		.open = sim_open,
		.close = sim_close,
		.axi4_read = sim_axi4_read,
		.axi4_write = sim_axi4_write,
		.axi4l_read = sim_axi4l_read,
		.axi4l_write = sim_axi4l_write,
		.get_interrupt_fd = sim_get_interrupt_fd,
	},
#endif
#ifndef EXCLUDE_XDMA
	[AWST_PLATFORM_XDMA] = {
		.open = xdma_open,
		.close = xdma_close,
		.axi4_read = xdma_axi4_read,
		.axi4_write = xdma_axi4_write,
		.axi4l_read = xdma_axi4l_read,
		.axi4l_write = xdma_axi4l_write,
		.get_interrupt_fd = xdma_get_interrupt_fd,
	},
#endif
};

struct AWSteria_desc *AWSteria_Host_open(unsigned int platform, void *param, size_t size)
{
	assert(!param || size > 0);

	struct AWSteria_desc *desc;
	struct AWSteria_ops *ops;

	if (platform >= AWST_PLATFORM_COUNT)
		return NULL;

	ops = &platform_ops[platform];

	if (!ops->open)
		return NULL;

	desc = ops->open(param, size);
	if (!desc)
		return NULL;

	desc->platform = platform;
	desc->ops = ops;

	return desc;
}
