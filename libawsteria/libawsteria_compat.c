
/*
  This is is a hack to faciliate development in branch and avoid
  conflicts merging potential changes to the various
  AWSteria_Host_lib.c implementations from the master branch.  This
  should be eliminated once these changes are propagated to master.
*/

#ifndef EXCLUDE_SIM

#undef AWSteria_Host_State
#undef verbosity_init
#undef AWSteria_Host_init
#undef AWSteria_Host_shutdown
#undef AWSteria_AXI4_read
#undef AWSteria_AXI4_write
#undef AWSteria_AXI4L_read
#undef AWSteria_AXI4L_write
#undef AWSteria_get_interrupt_fd

#define AWSteria_Host_State AWSteria_Host_State_Sim
#define verbosity_init verbosity_init_Sim
#define AWSteria_Host_init AWSteria_Host_init_Sim
#define AWSteria_Host_shutdown AWSteria_Host_shutdown_Sim
#define AWSteria_AXI4_read AWSteria_AXI4_read_Sim
#define AWSteria_AXI4_write AWSteria_AXI4_write_Sim
#define AWSteria_AXI4L_read AWSteria_AXI4L_read_Sim
#define AWSteria_AXI4L_write AWSteria_AXI4L_write_Sim
#define AWSteria_get_interrupt_fd AWSteria_get_interrupt_fd_Sim

#include "../../AWSteria_Infra/Platform_Sim/Host/AWSteria_Host_lib.c"

#endif

#ifndef EXCLUDE_XDMA

#undef AWSteria_Host_State
#undef verbosity_init
#undef AWSteria_Host_init
#undef AWSteria_Host_shutdown
#undef AWSteria_AXI4_read
#undef AWSteria_AXI4_write
#undef AWSteria_AXI4L_read
#undef AWSteria_AXI4L_write
#undef AWSteria_get_interrupt_fd

#define AWSteria_Host_State AWSteria_Host_State_XDMA
#define verbosity_init verbosity_init_XDMA
#define AWSteria_Host_init AWSteria_Host_init_XDMA
#define AWSteria_Host_shutdown AWSteria_Host_shutdown_XDMA
#define AWSteria_AXI4_read AWSteria_AXI4_read_XDMA
#define AWSteria_AXI4_write AWSteria_AXI4_write_XDMA
#define AWSteria_AXI4L_read AWSteria_AXI4L_read_XDMA
#define AWSteria_AXI4L_write AWSteria_AXI4L_write_XDMA
#define AWSteria_get_interrupt_fd AWSteria_get_interrupt_fd_XDMA

#include "../../AWSteria_Infra/Platform_VCU118/Host/AWSteria_Host_lib.c"

#endif
