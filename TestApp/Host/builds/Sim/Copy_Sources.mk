RSYNC = rsync --times

PLATFORM_SIM = $(BLUPONT_REPO)/Platform_Sim/Host_Side

.PHONY: rsync_tmpdir
rsync_tmpdir: tmpdir
	rsync  ../../main.c                                  tmpdir
	rsync  $(BLUPONT_REPO)/APIs/BluPont_Host_Side_API.h  tmpdir
	rsync  $(PLATFORM_SIM)/*.h                           tmpdir
	rsync  $(PLATFORM_SIM)/*.c                           tmpdir

tmpdir:
	mkdir -p  tmpdir
