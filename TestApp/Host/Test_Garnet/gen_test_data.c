#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <assert.h>

// ================================================================

void print_usage (FILE *fp, int argc, char *argv[])
{
	fprintf (fp, "Usage:  %s  <size in bytes>  <outfile name>\n", argv [0]);
}

// ================================================================

int main (int argc, char *argv[])
{
	if (argc != 3) {
		print_usage (stderr, argc, argv);
		return 1;
	}

	if ((strcmp (argv [1], "-h") == 0)
	    || (strcmp (argv [1], "-help") == 0)
	    || (strcmp (argv [1], "--help") == 0)) {
		print_usage (stdout, argc, argv);
		return 0;
	}

	char *p;
	long long n_bytes = strtoll (argv [1], & p, 0); // 0 => read decimal or 0xHex
	if (p == argv [1]) {
		fprintf (stdout, "ERROR: could not parse <size in bytes> arg\n");
		print_usage (stderr, argc, argv);
		return 1;
	}

	FILE *fout = fopen (argv [2], "w");
	if (fout == NULL) {
		fprintf (stdout, "ERROR: could not open <outfile name> for writing\n");
		print_usage (stderr, argc, argv);
		return 1;
	}

	long long n = 0, linenum = 0;
	char charbuf [128];
	while (n < n_bytes) {
		int k = sprintf (charbuf, "%s:L%0lld:", argv [2], linenum);
		assert (k < 128);
		fprintf (fout, "%s", charbuf);
		n += k;

		for (int j = 0; j < 10; j++) {
			int k = sprintf (charbuf, " %0d", j);
			assert (k < 128);
			fprintf (fout, "%s", charbuf);
			n += k;
		}
		fprintf (fout, "\n");
		n++;
		linenum++;
	}
	fclose (fout);
	fprintf (stdout, "Wrote %0lld bytes to file %s\n", n, argv [2]);
	return 0;
}
