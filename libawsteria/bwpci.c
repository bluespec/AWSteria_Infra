
#include <assert.h>
#include <errno.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <sys/socket.h>
#include <sys/types.h>
#include <sys/un.h>
#include <netinet/in.h>
#include <netinet/ip.h>
#include <netinet/tcp.h>

#include "libawsteria.h"
#include "bwsdk_pci.h"

#define VIRTIO_DMA_OFFSET_COHERENT  (1UL<<36)
#define VIRTIO_DMA_OFFSET_UNCACHED  (0)

#define AWSTERIA_MEM_BASE  (0x80000000)

#define NAP_ADDR(col,row)  (((uint64_t)((col-1) & 0xf) << 31) | ((uint64_t)((row-1) & 7) << 28) | (1UL<<38))
#define NAP_ADDR_MASK  (0x0fffffffULL)

// nap master 0 is awsteria axi4
#define NAP_0_COL  (8)
#define NAP_0_ROW  (8)
#define NAP_0_ADDR_BASE  NAP_ADDR(NAP_0_COL, NAP_0_ROW)

// nap master 1 is awsteria axi4 lite
#define NAP_1_COL  (7)
#define NAP_1_ROW  (8)
#define NAP_1_ADDR_BASE  NAP_ADDR(NAP_1_COL, NAP_1_ROW)

#define DDR_ADDR_BASE  (1ULL << 40)
#define DDR_ADDR_MASK  (0xffffffffffULL)

struct AWSteria_desc_BWPCI {
	struct AWSteria_desc desc;
	unsigned int card_id;
	HBwpciDevice device;
	int fd_int[AWSTERIA_INTERRUPT_COUNT];
	int fd_int_in[AWSTERIA_INTERRUPT_COUNT];
	pthread_t int_thread[AWSTERIA_INTERRUPT_COUNT];
};

// translate awsteria axi4 address to fpga address
static uint64_t translate_addr_axi4(awst_addr_t addr)
{
	uint64_t fpgaaddr;

	if ((addr & VIRTIO_DMA_OFFSET_COHERENT) != 0) {
		addr &= ~VIRTIO_DMA_OFFSET_COHERENT;
		addr -= AWSTERIA_MEM_BASE;

		assert((addr & ~NAP_ADDR_MASK) == 0);
		fpgaaddr = (NAP_ADDR_MASK & addr) | NAP_0_ADDR_BASE;
	}
	else {
		addr -= AWSTERIA_MEM_BASE;

		assert((addr & ~DDR_ADDR_MASK) == 0);
		fpgaaddr = (DDR_ADDR_MASK & addr) | DDR_ADDR_BASE;
	}

	return fpgaaddr;
}

// translate awsteria axi4 lite address to fpga address
static uint64_t translate_addr_axi4l(awst_addr_t addr)
{
	uint64_t fpgaaddr = addr;

	assert((addr & ~NAP_ADDR_MASK) == 0);

	fpgaaddr = (NAP_ADDR_MASK & addr) | NAP_1_ADDR_BASE;

	return fpgaaddr;
}

#define CSR_BASE (1UL<<39)
#define DDR_CSR_BASE (0x00090000000 + CSR_BASE)
#define WRITE1_REG_ADDR (0x00001340000 + DDR_CSR_BASE)
#define WRITE2_REG_ADDR (0x00001340264 + DDR_CSR_BASE)
#define WRITE3_REG_ADDR (0x00001340264 + DDR_CSR_BASE)
#define WRITE4_REG_ADDR (0x00001340264 + DDR_CSR_BASE)
#define POLL_TRAIN_ADDR (0x00001340010 + DDR_CSR_BASE)
#define PMU_MSG_READ_ADDR_C8 (0x000013400c8 + DDR_CSR_BASE)
#define PMU_MSG_READ_ADDR_C4 (0x000013400c4 + DDR_CSR_BASE)
#define WRITE1_DFI_INIT (0x000000001b0 + DDR_CSR_BASE)
#define POLL_DFI_STATUS (0x000000001bc + DDR_CSR_BASE)
#define WRITE2_DFI_MISC (0x000000001b0 + DDR_CSR_BASE)
#define WRITE3_DBG_REG1 (0x00000000304 + DDR_CSR_BASE)
#define WRITE4_SW_CNTRL (0x00000000320 + DDR_CSR_BASE)
#define POLL_SW_DONE (0x00000000324 + DDR_CSR_BASE)
#define POLL_OP_MODE (0x00000000004 + DDR_CSR_BASE)
#define WRITE1_MEMC (0x00000000490 + DDR_CSR_BASE)
#define WRITE2_MEMC (0x00000000540 + DDR_CSR_BASE)
#define WRITE3_MEMC (0x00000000030 + DDR_CSR_BASE)
#define WRITE4_FINAL (0x00001300200 + DDR_CSR_BASE)

#define EXPECTED_VAL0 0xff
#define EXPECTED_CORR 0x7

static void write32(struct AWSteria_desc_BWPCI *desc, uint64_t addr, uint32_t data)
{
	assert(desc);
	assert((addr & 3) == 0);

	int ret = bwpci_ms_write32s(desc->device, BW_MS_BAR0, addr, &data, 1);
	assert(ret == 1);
}

static uint32_t read32(struct AWSteria_desc_BWPCI *desc, uint64_t addr)
{
	assert(desc);
	assert((addr & 3) == 0);

	uint32_t data;
	int ret = bwpci_ms_read32s(desc->device, BW_MS_BAR0, addr, &data, 1);
	assert(ret == 1);

	return data;
}

// returns 1 on error, 0 on success
static int ddr_training(struct AWSteria_desc_BWPCI *desc)
{
	assert(desc);

#define WRITE(addr, val)  write32(desc, addr, val)
#define READ(addr)  read32(desc, addr)

	uint32_t data;
	bool train_done = false;

	//DELAY 10  // wait 10 cycles
	WRITE(WRITE1_REG_ADDR, 0x1);
	WRITE(WRITE1_REG_ADDR, 0x1);
	WRITE(WRITE2_REG_ADDR, 0x9);
	WRITE(WRITE3_REG_ADDR, 0x1);
	WRITE(WRITE4_REG_ADDR, 0x0);

	while (!train_done) {
		data = READ(POLL_TRAIN_ADDR);
		if (data == EXPECTED_CORR)
			break;

		if (data == EXPECTED_VAL0)
			return 1;  // error

		if (data != 0x3)
			continue;

		while (READ(POLL_TRAIN_ADDR) != 0x2)
			;  // nothing

		while (READ(POLL_TRAIN_ADDR) != 0x2)
			;  // nothing

		if (READ(PMU_MSG_READ_ADDR_C8) == 0x7)
			train_done = true;

		WRITE(PMU_MSG_READ_ADDR_C4, 0x0);
		data = READ(POLL_TRAIN_ADDR);
		// data should be 0x2, but not checked
		WRITE(PMU_MSG_READ_ADDR_C4, 0x1);
	}

	WRITE(WRITE1_DFI_INIT, 0x71);

	while (READ(POLL_DFI_STATUS) == 0)
		;  // nothing

        WRITE(WRITE2_DFI_MISC, 0x51);
        WRITE(WRITE3_DBG_REG1, 0x0);
	WRITE(WRITE4_SW_CNTRL, 0x1);

	while (READ(POLL_SW_DONE) == 0)
		;  // nothing

	while ((READ(POLL_OP_MODE) & 1) != 0)
		;  // nothing

	WRITE(WRITE1_MEMC, 0x1);
	WRITE(WRITE2_MEMC, 0x1);
	WRITE(WRITE3_MEMC, 0x1);
	WRITE(WRITE4_FINAL, 0x0);  // comment says write 0x1

	return 0;
}

struct interrupt_thread_desc {
	unsigned int nint;
	struct AWSteria_desc_BWPCI *bwpcidesc;
};

static void *interrupt_thread(void *arg) {

	struct interrupt_thread_desc *desc = arg;
	int ret;
	uint32_t count, count_last = UINT32_MAX;
	uint32_t data = 1;

	while (true) {
		ret = bwpci_int_wait(desc->bwpcidesc->device, desc->nint, 0, &count);
		if (ret != BW_SUCCESS) {
			fprintf(stdout, "WARNING: %s: bwpci_int_wait failed: %d\n",
				__FUNCTION__, ret);
			continue;
		}

		if (count == count_last)
			continue;

		count_last = count;

		ret = send(desc->bwpcidesc->fd_int_in[desc->nint],
			   &data, sizeof(data), MSG_DONTWAIT);
		if (ret == -1 && (ret == EAGAIN || ret == EWOULDBLOCK))
			fprintf(stdout, "WARNING: %s: interrupt dropped: %d\n",
				__FUNCTION__, desc->nint);
		else if (ret != sizeof(data))
			fprintf(stdout, "WARNING: %s: send failed\n", __FUNCTION__);
	}

	return NULL;
}

#define BWPCI_INTERRUPT_COUNT  (8)

static bool interrupt_init(struct AWSteria_desc_BWPCI *desc) {

	int sv[2];
	int ret;

	struct interrupt_thread_desc int_desc = { .bwpcidesc = desc };

	for (int i = 0; i < AWSTERIA_INTERRUPT_COUNT; i++) {
		if (i >= BWPCI_INTERRUPT_COUNT) {
			desc->fd_int[i] = -1;
			desc->fd_int_in[i] = -1;
			desc->int_thread[i] = -1;
			continue;
		}

		if (socketpair(AF_LOCAL, SOCK_STREAM, 0, sv)) {
			perror("socketpair() failed");
			exit (1);
		}

		desc->fd_int[i] = sv[0];
		desc->fd_int_in[i] = sv[1];

		int_desc.nint = i;

		ret = pthread_create(&desc->int_thread[i], NULL, interrupt_thread, &int_desc);
		assert(ret == 0);
	}

	// see AWSteria_Infra/Platform_Sim/Host/AWSteria_Host_lib.c

	return true;
}

struct AWSteria_desc *bwpci_open(void *param, size_t size)
{
	assert(!param || size == sizeof(struct AWSteria_params_BWPCI));

	struct AWSteria_desc_BWPCI *desc;

	desc = malloc(sizeof(struct AWSteria_desc_BWPCI));
	if (!desc)
		return NULL;

	memset(desc, 0, sizeof(*desc));

	int result = bwpci_dev_open(0, &desc->device);

	if (result != BW_SUCCESS)
		goto err;

	if (!ddr_training(desc))
		goto err;

	if (!interrupt_init(desc))
		goto err;

	return (void*)desc;

err:
	free(desc);
	return NULL;
}

void bwpci_close(struct AWSteria_desc *desc)
{
	struct AWSteria_desc_BWPCI *bwpcidesc = (void*)desc;

	assert(bwpcidesc);

	for (int i = 0; i < AWSTERIA_INTERRUPT_COUNT; i++) {
		if (i >= BWPCI_INTERRUPT_COUNT)
			continue;

		pthread_cancel(bwpcidesc->int_thread[i]);
	}

	bwpci_dev_close(bwpcidesc->device);
	free(bwpcidesc);
}

int bwpci_axi4_read(struct AWSteria_desc *desc, void *data, size_t size, awst_addr_t addr)
{
	struct AWSteria_desc_BWPCI *bwpcidesc = (void*)desc;

	assert(bwpcidesc);

	uint64_t fpgaaddr = translate_addr_axi4(addr);
	int ret;
	size_t size_next;

	// initial source alignment
	size_next = (8 - ((uintptr_t)data & 7)) & 7;

	ret = bwpci_ms_read8s(bwpcidesc->device, BW_MS_BAR0, fpgaaddr, data, size_next);
	if (ret < size_next) {
		ret = 1;
		goto out;
	}

	size -= size_next;
	if (size == 0) {
		ret = 0;
		goto out;
	}

	fpgaaddr += size_next;
	data += size_next;

	// aligned data
	size_next = size / 8;

	ret = bwpci_ms_read64s(bwpcidesc->device, BW_MS_BAR0, fpgaaddr, data, size_next);
	if (ret < size_next) {
		ret = 1;
		goto out;
	}

	size -= size_next;
	if (size == 0) {
		ret = 0;
		goto out;
	}

	fpgaaddr += size_next;
	data += size_next;

	// remainder

	ret = bwpci_ms_read8s(bwpcidesc->device, BW_MS_BAR0, fpgaaddr, data, size);
	if (ret < size) {
		ret = 1;
		goto out;
	}

	ret = 0;

out:
	return ret;
}

int bwpci_axi4_write(struct AWSteria_desc *desc, const void *data, size_t size, awst_addr_t addr)
{
	struct AWSteria_desc_BWPCI *bwpcidesc = (void*)desc;

	assert(bwpcidesc);

	uint64_t fpgaaddr = translate_addr_axi4(addr);
	int ret;
	size_t size_next;

	// initial source alignment
	size_next = (8 - ((uintptr_t)data & 7)) & 7;

	ret = bwpci_ms_write8s(bwpcidesc->device, BW_MS_BAR0, fpgaaddr, (void*)data, size_next);
	if (ret < size_next) {
		ret = 1;
		goto out;
	}

	size -= size_next;
	if (size == 0) {
		ret = 0;
		goto out;
	}

	fpgaaddr += size_next;
	data += size_next;

	// aligned data
	size_next = size / 8;

	ret = bwpci_ms_write64s(bwpcidesc->device, BW_MS_BAR0, fpgaaddr, (void*)data, size_next);
	if (ret < size_next) {
		ret = 1;
		goto out;
	}

	size -= size_next;
	if (size == 0) {
		ret = 0;
		goto out;
	}

	fpgaaddr += size_next;
	data += size_next;

	// remainder

	ret = bwpci_ms_write8s(bwpcidesc->device, BW_MS_BAR0, fpgaaddr, (void*)data, size);
	if (ret < size) {
		ret = 1;
		goto out;
	}

	ret = 0;

out:
	return ret;
}

int bwpci_axi4l_read(struct AWSteria_desc *desc, awst_addr_t addr, uint32_t *pdata)
{
	struct AWSteria_desc_BWPCI *bwpcidesc = (void*)desc;

	assert(bwpcidesc);
	assert((addr & 3) == 0);
	assert(((uintptr_t)pdata & 3) == 0);

	uint64_t fpgaaddr = translate_addr_axi4l(addr);
	int ret = bwpci_ms_read32s(bwpcidesc->device, BW_MS_BAR0, fpgaaddr, pdata, 1);

	return ret > 0 ? 0 : 1;
}

int bwpci_axi4l_write(struct AWSteria_desc *desc, awst_addr_t addr, uint32_t data)
{
	struct AWSteria_desc_BWPCI *bwpcidesc = (void*)desc;

	assert(bwpcidesc);
	assert((addr & 3) == 0);

	uint64_t fpgaaddr = translate_addr_axi4l(addr);
	int ret = bwpci_ms_write32s(bwpcidesc->device, BW_MS_BAR0, fpgaaddr, &data, 1);

	return ret > 0 ? 0 : 1;
}

int bwpci_get_interrupt_fd(struct AWSteria_desc *desc, unsigned int interrupt)
{
	struct AWSteria_desc_BWPCI *bwpcidesc = (void*)desc;

	assert(bwpcidesc);
	assert(interrupt < AWSTERIA_INTERRUPT_COUNT);

	return bwpcidesc->fd_int[interrupt];
}
