
#include <assert.h>
#include <getopt.h>
#include <poll.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

#include <bsd/string.h>
#include <bsd/sys/time.h>
#include <sys/socket.h>
#include <sys/types.h>

#include "libawsteria.h"
#include "loadafi.h"

#define N_INT 16

bool verbose = false;

struct cfg {
	unsigned int platform;

	struct AWSteria_params_Sim sim;
	struct AWSteria_params_XDMA xdma;

	bool load_afi;
	char afi[PATH_MAX];
};

static const struct cfg default_cfg = {
	.platform = AWST_PLATFORM_SIM,
	.sim = {.hostname = "localhost", .port = 30000},
	.xdma = {.card_id = 0},
	.load_afi = false,
	.afi = "agfi-0367c200eff6ab836",
};

enum {
	__OPT_NONE,
	OPT_AFI,
	OPT_PLATFORM,
	OPT_SIM_HOSTNAME,
	OPT_SIM_PORT,
	OPT_XDMA_CARD,
};

static struct option long_options[] = {
	{"afi", optional_argument, 0, OPT_AFI},
	{"help", no_argument, 0, 'h'},
	{"platform", required_argument, 0, OPT_PLATFORM},
	{"sim-host", required_argument, 0, OPT_SIM_HOSTNAME},
	{"sim-port", required_argument, 0, OPT_SIM_PORT},
	{"xdma-card", required_argument, 0, OPT_XDMA_CARD},
	{"verbose", no_argument, 0, 'v'},
	{0}
};

static void usage(void)
{
	printf("usage: irqtest [options]\n"
	       "where [options] may include:\n");
#ifndef EXCLUDE_LOADAFI
	printf("    --afi[=<file>]\n");
#endif
	printf("    --help\n"
	       "    --jtag-vpi-port <port>\n"
	       "    --platform <platform>\n"
	       "    --verbose\n"
		);
}

static int parse_arguments(int argc, char **argv, struct cfg *cfg)
{
	assert(cfg);

	int c;
	long num;

	memcpy(cfg, &default_cfg, sizeof(default_cfg));

	while (true) {
		c = getopt_long(argc, argv, "hv", long_options, NULL);
		if (c == -1)
			break;

		switch (c) {
		case 'h':
			usage();
			exit(0);
			break;

		case OPT_PLATFORM:
			if (!strcmp(optarg, "sim"))
				cfg->platform = AWST_PLATFORM_SIM;
			else if (!strcmp(optarg, "xdma"))
				cfg->platform = AWST_PLATFORM_XDMA;
			else {
				printf("invalid platform: %s\n", optarg);
				exit(-1);
			}
			break;

		case 'v':
			verbose = true;
			break;

#ifndef EXCLUDE_LOADAFI
		case OPT_AFI:
			cfg->load_afi = true;
			if (optarg)
				strlcpy(cfg->afi, optarg, sizeof(cfg->afi));
			break;
#endif

		case OPT_SIM_HOSTNAME:
			strlcpy(cfg->sim.hostname, optarg, sizeof(cfg->sim.hostname));
			break;

		case OPT_SIM_PORT:
			num = strtol(optarg, NULL, 0);
			if (num == LONG_MAX || num == LONG_MIN) {
				perror("invalid num");
				exit(-1);
			}
			if (num < 0 || num > 65535) {
				printf("num out of range\n");
				exit(-1);
			}
			cfg->sim.port = num;
			break;

		case OPT_XDMA_CARD:
			num = strtol(optarg, NULL, 0);
			if (num == LONG_MAX || num == LONG_MIN) {
				perror("invalid num");
				exit(-1);
			}
			if (num < 0 || num > 8) {
				printf("num out of range\n");
				exit(-1);
			}
			cfg->xdma.card_id = num;
			break;

		case '?':
		default:
			printf("invalid arguments\n");
			exit(-1);
		}
	}

	if (optind < argc) {
		// non-option arguments exist
		printf("invalid arguments\n");
		exit(-1);
	}

	printf("platform = %d\n", cfg->platform);

	return 0;
}

static int get_int_count(struct AWSteria_desc *awst_desc)
{
	assert(awst_desc);

	int ret;
	awst_addr_t addr;
	uint32_t data;

	addr = 4;

	ret = AWSteria_AXI4L_read(awst_desc, addr, &data);
	if (ret)
		return ret;

	return data;
}

static int irq_req(struct AWSteria_desc *awst_desc, unsigned int n)
{
	assert(awst_desc);
	assert(n < N_INT);

	awst_addr_t addr;
	uint32_t data = n;

	addr = 0;

	return AWSteria_AXI4L_write(awst_desc, addr, data);
}

static int is_irq_pending(struct AWSteria_desc *awst_desc, unsigned int n)
{
	assert(awst_desc);
	assert(n < N_INT);

	int ret;
	uint32_t data;
	int fd;
	struct pollfd fds[1];

	fd = AWSteria_get_interrupt_fd(awst_desc, n);

	fds[0].fd = fd;
	fds[0].events = POLLIN;

	ret = poll(fds, 1, 0);
	if (ret <= 0)
		return ret;

	if ((fds[0].revents & POLLIN) == 0)
		return -1;

	ret = read(fd, &data, sizeof(data));
	if (ret <= 0)
		return ret;

	return 1;
}

static int timeout_start(struct timespec *start)
{
	return clock_gettime(CLOCK_MONOTONIC, start);
}

static int timeout_expired(struct timespec *start, unsigned long timeout)
{
	struct timespec now, tdiff;
	unsigned long nsdiff;
	int ret;

	ret = clock_gettime(CLOCK_MONOTONIC, &now);
	if (ret)
		return ret;

	timespecsub(&now, start, &tdiff);

	nsdiff = tdiff.tv_sec * 1000000000UL + tdiff.tv_nsec;

	return nsdiff >= timeout;
}

struct AWSteria_desc *do_awsteria_open(struct cfg *cfg)
{
	assert(cfg != NULL);

	switch (cfg->platform) {
	case AWST_PLATFORM_SIM:
		return AWSteria_Host_open(cfg->platform, &cfg->sim, sizeof(cfg->sim));
	case AWST_PLATFORM_XDMA:
		return AWSteria_Host_open(cfg->platform, &cfg->xdma, sizeof(cfg->xdma));
	default:
		return AWSteria_Host_open(cfg->platform, NULL, 0);
	}
}

int main(int argc, char **argv)
{
	int ret;

	struct cfg cfg;
	struct AWSteria_desc *awst_desc;
	struct timespec ts1, ts2;
	int n = 0;
	int count = 0;

	ret = parse_arguments(argc, argv, &cfg);
	if (ret)
		return ret;

#ifndef EXCLUDE_LOADAFI
	if (cfg.load_afi) {
		ret = load_afi(cfg.xdma.card_id, cfg.afi);
		assert(ret == 0);
	}
#endif

	awst_desc = do_awsteria_open(&cfg);
	assert(awst_desc);

	// check the count
	assert(get_int_count(awst_desc) == N_INT);

	timeout_start(&ts1);

	while (!timeout_expired(&ts1, 5000000000UL)) {

		// check no interrupt pending
		assert(is_irq_pending(awst_desc, n) == 0);

		// trigger an interrupt
		ret = irq_req(awst_desc, n);
		assert(ret >= 0);

		timeout_start(&ts2);

		// confirm interrupt pending
		do {
			ret = is_irq_pending(awst_desc, n);
			if (ret > 0)
				break;
		} while (!timeout_expired(&ts2, 2000000000UL));

		if (ret <= 0)
			printf("no irqs! (%d)\n", ret);

		assert(ret > 0);

		// check no other interrupts pending
		for (int i = 0; i < N_INT; i++)
			if (i != n)
				assert(is_irq_pending(awst_desc, i) == 0);

		n++;
		if (n == N_INT)
			n = 0;

		count++;
	}

	assert(count > N_INT);

	AWSteria_Host_close(awst_desc);

	printf("%d interrupts\n", count);

	return 0;
}
