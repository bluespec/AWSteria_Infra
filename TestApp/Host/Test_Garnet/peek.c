#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <string.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#include <sys/mman.h>

#define MAP_SIZE (32*1024UL)
#define MAP_MASK (MAP_SIZE - 1)

// ================================================================

char device_name [] = "/dev/xdma0_user";

// ================================================================

void fprint_usage (FILE *fout, int argc, char **argv)
{
	fprintf (fout, "Usage: %s  <addr>    (can use decimal or 0xHEX format)\n",
		 argv [0]);
}

// ================================================================

int main (int argc, char **argv)
{
	if ((argc == 1)
	    || (strcmp (argv [1], "-h") == 0)
	    || (strcmp (argv [1], "--help") == 0)) {
		fprint_usage (stdout, argc, argv);
		return 0;
	}

	uint32_t addr = strtoul (argv[1], 0, 0);

	fprintf (stdout, "Opening device %s\n", device_name);
	int fd = open (device_name, O_RDWR | O_SYNC);
	if (fd == -1) {
		fprintf (stdout, "ERROR: Unable to open device %s\n", device_name);
		return -1;
	}

	fprintf (stdout, "Map one page\n");
	void *map_base = mmap (0, MAP_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
	if (map_base == (void *)-1) {
		fprintf (stdout, "ERROR: Unable to mmap\n");
		return -1;
	}
	printf("Memory mapped at address %p.\n", map_base);
	fflush(stdout);

	// Do the peek
	void    *virt_addr = map_base + addr;
	uint32_t rdata     = *((uint32_t *) virt_addr);
	fprintf (stdout, "Peek address 0x%08x => 0x%08x\n", addr, rdata);

	if (munmap (map_base, MAP_SIZE) == -1) {
		fprintf (stdout, "ERROR: Unable to munmap\n");
		return -1;
	}
	close (fd);
	return 0;
}
