
#include <string.h>

#include "fpga_mgmt.h"

int load_afi(unsigned int card_id, char *afi)
{
	int ret;
	struct fpga_mgmt_image_info info;

	ret = fpga_mgmt_init();
	if (ret)
		return ret;

	memset(&info, 0, sizeof(info));

	ret = fpga_mgmt_describe_local_image(card_id, &info, 0);
	if (ret)
		goto out;

	// check if afi already loaded
	if (!strncmp(afi, info.ids.afi_id, sizeof(info.ids.afi_id))) {
		ret = 0;
		goto out;
	}

	ret = fpga_mgmt_load_local_image_sync(card_id, afi, 0, 0, &info);

out:
	fpga_mgmt_close();
	return ret;
}
