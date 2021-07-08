RSYNC = rsync --times

PLATFORM_AWSF1 = $(BLUPONT_REPO)/Platform_AWSF1/Host_Side

.PHONY: rsync_tmpdir
rsync_tmpdir: tmpdir
	rsync  ../../*.c                                     tmpdir
	rsync  $(BLUPONT_REPO)/APIs/BluPont_Host_Side_API.h  tmpdir
	rsync  $(PLATFORM_AWSF1)/*.c                         tmpdir

tmpdir:
	mkdir -p  tmpdir
