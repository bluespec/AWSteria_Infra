
#ifndef __LIBAWSTERIA_H__
#define __LIBAWSTERIA_H__

#include <limits.h>
#include <pthread.h>
#include <stdint.h>

#define AWSTERIA_INTERRUPT_COUNT 16

// guest address
typedef uint64_t awst_addr_t;

enum {
	AWST_PLATFORM_SIM,
	AWST_PLATFORM_XDMA,

	AWST_PLATFORM_COUNT,  // this must be last
};

struct AWSteria_desc;

struct AWSteria_ops {
	struct AWSteria_desc *(*open)(void *, size_t);
	void (*close)(struct AWSteria_desc *);
	int (*axi4_read)(struct AWSteria_desc *, void *, size_t, awst_addr_t);
	int (*axi4_write)(struct AWSteria_desc *, const void *, size_t, awst_addr_t);
	int (*axi4l_read)(struct AWSteria_desc *, awst_addr_t, uint32_t *);
	int (*axi4l_write)(struct AWSteria_desc *, awst_addr_t, uint32_t);
	int (*get_interrupt_fd)(struct AWSteria_desc *, unsigned int);
};

struct AWSteria_desc {
	unsigned int platform;
	struct AWSteria_ops *ops;
};

struct AWSteria_desc_Sim {
	struct AWSteria_desc desc;
	void *state;
	pthread_mutex_t mutex;
};

struct AWSteria_desc_XDMA {
	struct AWSteria_desc desc;
	unsigned int card_id;
	void *state;
};

struct AWSteria_params_Sim {
	char hostname[PATH_MAX];
	unsigned int port;
};

struct AWSteria_params_XDMA {
	unsigned int card_id;
};

struct AWSteria_desc *AWSteria_Host_open(unsigned int platform, void *param, size_t size);

static inline void AWSteria_Host_close(struct AWSteria_desc *desc)
{
	desc->ops->close(desc);
}

static inline int AWSteria_AXI4_read(struct AWSteria_desc *desc, void *data, size_t size, awst_addr_t addr)
{
	return desc->ops->axi4_read(desc, data, size, addr);
}

static inline int AWSteria_AXI4_write(struct AWSteria_desc *desc, const void *data, size_t size, awst_addr_t addr)
{
	return desc->ops->axi4_write(desc, data, size, addr);
}

static inline int AWSteria_AXI4L_read(struct AWSteria_desc *desc, awst_addr_t addr, uint32_t *pdata)
{
	return desc->ops->axi4l_read(desc, addr, pdata);
}

static inline int AWSteria_AXI4L_write(struct AWSteria_desc *desc, awst_addr_t addr, uint32_t data)
{
	return desc->ops->axi4l_write(desc, addr, data);
}

static inline int AWSteria_get_interrupt_fd(struct AWSteria_desc *desc, unsigned int interrupt)
{
	return desc->ops->get_interrupt_fd(desc, interrupt);
}

static inline int AWSteria_get_platform(struct AWSteria_desc *desc)
{
	return desc->platform;
}

#endif
