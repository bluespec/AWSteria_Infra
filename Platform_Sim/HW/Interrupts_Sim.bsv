
/// \todo verify when irq acknowledgement is issued by xilinx
/// hardware/driver (in hardware or only from confirmation in
/// software)
package Interrupts_Sim;

import Assert ::*;
import FIFOF ::*;
import GetPut ::*;
import Vector ::*;

import C_Imports ::*;

interface Interrupts_Sim#(numeric type n);
   method Action irq_req(Bit#(n) x);
   method Bit#(n) irq_ack;
   interface Get#(Bit#(32)) interrupts_out;
endinterface

module mkInterrupts_Sim(Interrupts_Sim#(n));

   Vector#(n, FIFOF#(void)) vf_pending <- replicateM(mkFIFOF1);
   Vector#(n, FIFOF#(void)) vf_ack <- replicateM(mkFIFOF1);
   Wire#(Bit#(n)) w_irq_req <- mkWire;
   Wire#(Bit#(n)) w_irq_ack <- mkWire;
   Vector#(n, Wire#(Bit#(1))) vw_irq_ack <- replicateM(mkDWire(0));
   FIFOF#(Bit#(32)) f_int_out <- mkFIFOF1;
   Vector#(n, FIFOF#(void)) vf_int_out <- replicateM(mkFIFOF1);

   rule rl_irq_ack_wire;
      w_irq_ack <= pack(readVReg(vw_irq_ack));
   endrule

   Rules r = emptyRules;
   for (Integer i = 0; i < valueOf(n); i = i + 1) begin
      rule rl_irq_assert(w_irq_req[i] == 1);
	 vf_pending[i].enq(?);
	 vf_int_out[i].enq(?);
      endrule

      rule rl_irq_drop(w_irq_req[i] == 1 && vf_pending[i].notEmpty);
	 $display("WARNING: Interrupt request asserted for more than one cycle");
      endrule

      rule rl_irq_deassert(w_irq_req[i] == 0);
	 vf_pending[i].deq;
	 vf_ack[i].enq(?);
      endrule

      rule rl_irq_ack;
	 vf_ack[i].deq;
	 vw_irq_ack[i] <= 1;
      endrule

      r = rJoinDescendingUrgency(r,
	 rules
	    rule rl_fifo_mux;
	       f_int_out.enq(fromInteger(i));
	       vf_int_out[i].deq;
	    endrule
	 endrules);
   end
   addRules(r);

   method irq_req = w_irq_req._write;
   method irq_ack = w_irq_ack._read;
   interface interrupts_out = toGet(f_int_out);

endmodule

module mkInterrupts_Sim_Socket#(Integer port)(Put#(Bit#(32)));
   FIFOF#(Bit#(32)) f_int_in <- mkFIFOF;

   Reg#(Int#(64)) sock <- mkReg(-1);
   Reg#(Int#(64)) fd <- mkReg(-1);

   rule rl_open(sock == -1);
      let tmp <- socket_open(fromInteger(port));
      dynamicAssert(tmp >= 0, "socket_open() failed");
      sock <= tmp;
   endrule

   rule rl_accept(sock >= 0 && fd == -1);
      let tmp <- socket_accept(sock);
      if (tmp >= 0)
	 fd <= tmp;
   endrule

   rule rl_int(fd >= 0);
      let nint = f_int_in.first;
      f_int_in.deq;

      let ret <- socket_send32(fd, nint);
      dynamicAssert(ret >= 0, "socket_send32() failed");
   endrule

   return toPut(f_int_in);
endmodule

endpackage
