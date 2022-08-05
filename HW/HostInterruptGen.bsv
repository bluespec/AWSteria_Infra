
package HostInterruptGen;

import Assert ::*;
import ClientServer ::*;
import FIFOF ::*;
import GetPut ::*;
import Vector ::*;

import AWSteria_HW_IFC ::*;

module mkFIFOF0(FIFOF#(t))
   provisos(Bits#(t, tbits));

   RWire#(t) w <- mkRWire;

   method Action enq(t x);
      w.wset(x);
   endmethod

   method Action deq if (isValid(w.wget)) = noAction;

   method t first if (isValid(w.wget));
      return fromMaybe(?, w.wget);
   endmethod

   method Action clear = noAction;

   method Bool notFull;
      return !isValid(w.wget);
   endmethod

   method Bool notEmpty;
      return isValid(w.wget);
   endmethod
endmodule

interface Host_Interrupt_Gen_IFC#(numeric type nint);
   // guest interface
   interface Vector#(nint, Server#(void, void)) interrupts;

   // host framework (aws/garnet/sim) interface
   interface Host_Interrupts_IFC#(nint) host_interrupts;
endinterface

module mkHostInterruptGen#(Bool doResponse)(Host_Interrupt_Gen_IFC#(n));

   Vector#(n, FIFOF#(void)) vf_req <- replicateM(mkFIFOF0);
   Vector#(n, FIFOF#(void)) vf_rsp <- replicateM(mkFIFOF0);

   Vector#(n, FIFOF#(void)) vf_pending <- replicateM(mkFIFOF1);
   Vector#(n, Wire#(Bit#(1))) vw_irq_req <- replicateM(mkDWire(0));

   Wire#(Bit#(n)) w_irq_req <- mkDWire(0);
   Wire#(Bit#(n)) w_irq_ack <- mkDWire(0);

   rule rl_irq_req_wire;
      w_irq_req <= pack(readVReg(vw_irq_req));
   endrule

   for (Integer i = 0; i < fromInteger(valueOf(n)); i = i + 1) begin
      rule rl_irq_req;
         vf_req[i].deq;
	 vf_pending[i].enq(?);
	 vw_irq_req[i] <= 1;
      endrule

      rule rl_irq_ack(w_irq_ack[i] == 1);
         vf_pending[i].deq;
	 if (doResponse)
	    vf_rsp[i].enq(?);
      endrule

      rule rl_irq_ack_dropped(w_irq_ack[i] == 1);
	 //dynamicAssert(!vf_rsp[i].notFull,
	//	       "Interrupt acknowledgement dropped");
	 if (!vf_rsp[i].notFull)
	    $display("Interrupt acknowledgement dropped");
      endrule

      rule rl_irq_req_unexpected;
	 //dynamicAssert(vf_pending[i].notEmpty && vf_req[i].notEmpty,
	//	       "Interrupt request before prior acknowledgement");
	 if (vf_pending[i].notEmpty && vf_req[i].notEmpty)
	    $display("Interrupt request before prior acknowledgement");
      endrule

      rule rl_irq_ack_unexpected;
	 //dynamicAssert(!vf_pending[i].notEmpty && w_irq_ack[i] == 1,
	//	       "Unexpected interrupt acknowledgement");
	 if (!vf_pending[i].notEmpty && w_irq_ack[i] == 1)
	    $display("Unexpected interrupt acknowledgement");
      endrule
   end

   function gen_interrupts(i);
      return interface Server;
		interface Put request = toPut(vf_req[i]);
		interface Get response = toGet(vf_rsp[i]);
	     endinterface;
   endfunction

   interface Vector interrupts = genWith(gen_interrupts);
   interface Host_Interrupts_IFC host_interrupts;
      method irq_req = w_irq_req._read;
      method irq_ack = w_irq_ack._write;
   endinterface

endmodule

endpackage
