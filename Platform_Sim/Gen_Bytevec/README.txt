This directory contains a generator to produce support code for
AWSteria_Infra/Platform_Sim, i.e., with host-side software interacting
with a simulation of the FPGA-side BSV/RTL code.

We mention only Bluesim below, but essentially the same thing will
work for Verilator simulation or any other RTL simulator.

Communication between host-side software and FPGA-side hardware in
AWSteria_Infra involves:
- transactions over AXI4
- transactions over AXI4-Lite

In simulation, we run the host-side software and Bluesim as two
separate Unix processes with some communication channel.  Currently
they communicate over TCP, but we could also use PTYs, Unix sockets,
etc.

The code created by this generator emulates these AXI4 and AXI4-Lite
transactions over the communication channel.

The generator here, given a spec of the AXI payloads (see
AWS_FPGA_Spec.py), produces code to:

- Offer separate queue interfaces for each AXI and AXI4-Lite channel,
    where C and BSV code can enqueue and dequeue payloads using
    convenient C or BSV structs.
- Internally, convert these AXI and AXI4-Lite payloads from C and BSV
    structs into byte vectors ('bytevecs') and back.
- Manage credits for a credit-based flow-control scheme for
    communicating these byte vectors, allowing streaming (pipelined)
    delivery of payloads.

- Offer simple queue interfaces for bytevecs to the communication
    channel, so that a simple mechanism (such as read()/write() on a
    TCP socket) can provide the necessary transport between the
    two processes.

Note: This is snapshot of a general-purpose and still-evolving
  'Gen_Bytevec_Mux' facility that has wider uses than the usage here
  for AWS host-side to FPGA-side communication (it can be used for
  many kinds of C/RTL inter-language working).  Since that tool is
  continuously evolving, we take a snapshot here, for stability.
  Please see the README in that tool's repo for more technical detail.


Usage:
    make gen      will generate Bytevec.{bsv,h,c}

    make install  will move Bytevec.bsv to the HW/ dir
                  and  move Bytevec.{h,c} to the Host/ dir
