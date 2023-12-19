
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
#include "acxpcie.h"
#include "Achronix_PCI.h"

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

#define PCIE_CSR_BAR  (0)
#define AXI4L_BAR  (1)
#define DDR_CSR_BAR  (3)

struct AWSteria_desc_ACXPCIE {
	struct AWSteria_desc desc;
	unsigned int card_id;
	acxsdk::PCIDevice *dev;
	ACX_BAR_handle *bar_axi4l;
	ACX_BAR_handle *bar_ddr_csr;
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
		fpgaaddr = (NAP_ADDR_MASK & addr) | acxsdk::util_calc_nap_absolute_addr(acxsdk::AC7t1500, NAP_0_COL, NAP_0_ROW);
	}
	else {
		addr -= AWSTERIA_MEM_BASE;

		assert((addr & ~DDR_ADDR_MASK) == 0);
		fpgaaddr = (DDR_ADDR_MASK & addr) | DDR_ADDR_BASE;
	}

	return fpgaaddr;
}

//#define CSR_BASE (1UL<<39)
//#define DDR_CSR_BASE (0x00090000000 + CSR_BASE)
#define DDR_CSR_BASE (0x100000)
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

static void write32(struct AWSteria_desc_ACXPCIE *desc, uint64_t addr, uint32_t data)
{
	assert(desc);
	assert((addr & 3) == 0);

	int ret = acx_write_uint32(desc->dev->get_device(), desc->bar_ddr_csr, addr, &data, 1);
	assert(ret == 1);
}

static uint32_t read32(struct AWSteria_desc_ACXPCIE *desc, uint64_t addr)
{
	assert(desc);
	assert((addr & 3) == 0);

	uint32_t data;
	int ret = acx_read_uint32(desc->dev->get_device(), desc->bar_ddr_csr, addr, &data, 1);
	assert(ret == 1);

	return data;
}

// returns 1 on error, 0 on success
static int ddr_training(struct AWSteria_desc_ACXPCIE *desc)
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
	struct AWSteria_desc_ACXPCIE *acxpciedesc;
};

static void *interrupt_thread(void *arg) {

	struct interrupt_thread_desc *desc = (struct interrupt_thread_desc *)arg;
	int ret;
	MsixStatus status;
	uint32_t count, count_last = UINT32_MAX;
	uint32_t data = 1;

	while (true) {
		status = acxsdk::msix_interrupt_wait(desc->acxpciedesc->dev->get_device(), desc->nint, 0, &count);
		if (status != MSIX_SUCCESS) {
			fprintf(stdout, "WARNING: %s: msix_interrupt_wait failed: %d\n",
				__FUNCTION__, status);
			continue;
		}

		if (count == count_last)
			continue;

		count_last = count;

		ret = send(desc->acxpciedesc->fd_int_in[desc->nint],
			   &data, sizeof(data), MSG_DONTWAIT);
		if (ret == -1 && (ret == EAGAIN || ret == EWOULDBLOCK))
			fprintf(stdout, "WARNING: %s: interrupt dropped: %d\n",
				__FUNCTION__, desc->nint);
		else if (ret != sizeof(data))
			fprintf(stdout, "WARNING: %s: send failed\n", __FUNCTION__);
	}

	return NULL;
}

#define ACXPCIE_INTERRUPT_COUNT  (8)

static bool interrupt_init(struct AWSteria_desc_ACXPCIE *desc) {

	int sv[2];
	int ret;

	struct interrupt_thread_desc int_desc = { .acxpciedesc = desc };

	for (int i = 0; i < AWSTERIA_INTERRUPT_COUNT; i++) {
		if (i >= ACXPCIE_INTERRUPT_COUNT) {
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

struct AWSteria_desc *acxpcie_open(void *param, size_t size)
{
	assert(!param || size == sizeof(struct AWSteria_params_ACXPCIE));

	struct AWSteria_desc_ACXPCIE *desc;

	desc = (struct AWSteria_desc_ACXPCIE *)malloc(sizeof(struct AWSteria_desc_ACXPCIE));
	if (!desc)
		return NULL;

	memset(desc, 0, sizeof(*desc));

	desc->dev = new acxsdk::PCIDevice(0);
	if (desc->dev->get_pci_status() != acxsdk::PCIDevice::STATUS_OK)
		goto err;

	if (!ddr_training(desc))
		goto err;

	if (!interrupt_init(desc))
		goto err;

	desc->bar_axi4l = desc->dev->get_bar_handle(AXI4L_BAR);
	assert(desc->bar_axi4l != NULL);

	desc->bar_ddr_csr = desc->dev->get_bar_handle(DDR_CSR_BAR);
	assert(desc->bar_ddr_csr != NULL);

	return (struct AWSteria_desc *)desc;

err:
	delete desc->dev;
	free(desc);
	return NULL;
}

void acxpcie_close(struct AWSteria_desc *desc)
{
	struct AWSteria_desc_ACXPCIE *acxpciedesc = (struct AWSteria_desc_ACXPCIE *)desc;

	assert(acxpciedesc);

	for (int i = 0; i < AWSTERIA_INTERRUPT_COUNT; i++) {
		if (i >= ACXPCIE_INTERRUPT_COUNT)
			continue;

		pthread_cancel(acxpciedesc->int_thread[i]);
	}

	delete acxpciedesc->dev;
	free(acxpciedesc);
}

int acxpcie_axi4_read(struct AWSteria_desc *desc, void *data, size_t size, awst_addr_t addr)
{
	struct AWSteria_desc_ACXPCIE *acxpciedesc = (struct AWSteria_desc_ACXPCIE *)desc;

	assert(acxpciedesc);

	acxsdk::DMAHostBuffer buf(acxpciedesc->dev, size);
	assert(buf.get_status() == acxsdk::DMAHostBuffer::STATUS_OK);

	acxsdk::DmaCommand cmd = {
		.csr_bar = PCIE_CSR_BAR,
		.pcie_core = acxsdk::PCIE_1,
		.dma_direction = acxsdk::DEVICE_TO_HOST,
		.dma_channel = 0,
		.device_address = translate_addr_axi4(addr),
		.host_address = buf.get_phys_addr(),
		.descriptor_list_address = 0,
		.size_in_bytes = size,
		.verbosity = 0,
	};

	acxsdk::dma_config(acxpciedesc->dev->get_device(), cmd);
	acxsdk::DmaStatus status = acxsdk::dma_start(acxpciedesc->dev->get_device(), cmd);
	assert(status == acxsdk::DMA_OK);

	status = acxsdk::dma_wait(acxpciedesc->dev->get_device(), cmd, INT_MAX);
	assert(status == acxsdk::DMA_COMPLETE);

	memcpy(data, (void*)buf.get_virt_addr(), size);

	return 0;
}

int acxpcie_axi4_write(struct AWSteria_desc *desc, const void *data, size_t size, awst_addr_t addr)
{
	struct AWSteria_desc_ACXPCIE *acxpciedesc = (struct AWSteria_desc_ACXPCIE *)desc;

	assert(acxpciedesc);

	acxsdk::DMAHostBuffer buf(acxpciedesc->dev, size);
	assert(buf.get_status() == acxsdk::DMAHostBuffer::STATUS_OK);

	acxsdk::DmaCommand cmd = {
		.csr_bar = PCIE_CSR_BAR,
		.pcie_core = acxsdk::PCIE_1,
		.dma_direction = acxsdk::HOST_TO_DEVICE,
		.dma_channel = 0,
		.device_address = translate_addr_axi4(addr),
		.host_address = buf.get_phys_addr(),
		.descriptor_list_address = 0,
		.size_in_bytes = size,
		.verbosity = 0,
	};

	memcpy((void*)buf.get_virt_addr(), data, size);

	acxsdk::dma_config(acxpciedesc->dev->get_device(), cmd);
	acxsdk::DmaStatus status = acxsdk::dma_start(acxpciedesc->dev->get_device(), cmd);
	assert(status == acxsdk::DMA_OK);

	status = acxsdk::dma_wait(acxpciedesc->dev->get_device(), cmd, INT_MAX);
	assert(status == acxsdk::DMA_COMPLETE);

	return 0;
}

int acxpcie_axi4l_read(struct AWSteria_desc *desc, awst_addr_t addr, uint32_t *pdata)
{
	struct AWSteria_desc_ACXPCIE *acxpciedesc = (struct AWSteria_desc_ACXPCIE *)desc;

	assert(acxpciedesc);
	assert((addr & 3) == 0);
	assert(((uintptr_t)pdata & 3) == 0);

	int ret = acx_read_uint32(acxpciedesc->dev->get_device(), acxpciedesc->bar_axi4l, addr, pdata, 1);

	return ret > 0 ? 0 : 1;
}

int acxpcie_axi4l_write(struct AWSteria_desc *desc, awst_addr_t addr, uint32_t data)
{
	struct AWSteria_desc_ACXPCIE *acxpciedesc = (struct AWSteria_desc_ACXPCIE *)desc;

	assert(acxpciedesc);
	assert((addr & 3) == 0);

	int ret = acx_write_uint32(acxpciedesc->dev->get_device(), acxpciedesc->bar_axi4l, addr, &data, 1);

	return ret > 0 ? 0 : 1;
}

int acxpcie_get_interrupt_fd(struct AWSteria_desc *desc, unsigned int interrupt)
{
	struct AWSteria_desc_ACXPCIE *acxpciedesc = (struct AWSteria_desc_ACXPCIE *)desc;

	assert(acxpciedesc);
	assert(interrupt < AWSTERIA_INTERRUPT_COUNT);

	return acxpciedesc->fd_int[interrupt];
}
