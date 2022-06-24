import FIFOF ::*;
import GetPut ::*;
import ClientServer ::*;
import Clocks ::*;
import SpecialFIFOs ::*;


(* always_ready *)
interface URAM_PORT_BE#(type addr, type data, type wren);
   method Action put(wren writeen, addr address, data datain);
   method data   read();
endinterface

import "BVI" xilinx_ultraram_single_port_no_change =
module vURAM1BE #(parameter Integer nbPipe)(URAM_PORT_BE#(addr, data, wren))
   provisos(
	    Bits#(addr, addr_sz),
	    Bits#(data, data_sz),
	    Bits#(wren, wren_sz),
	    Div#(data_sz, 8, wren_sz),
	    Mul#(wren_sz, 8, data_sz)
	    );

   let rstn <- exposeCurrentReset();
   let rst  <- mkResetInverter(rstn);

   input_reset    (rst) = rst;

   default_clock   clk(clk, (*unused*)CLK_GATE);
   default_reset   rstn();

   parameter AWIDTH  = valueof(addr_sz);
   parameter NUM_COL = valueof(wren_sz);
   parameter DWIDTH  = valueof(data_sz);
   parameter NBPIPE  = nbPipe;

   port regce  = 1;

   method put((* reg *)we, (* reg *)addr, (* reg *)din) enable(mem_en);
   method dout  read();

   schedule (put, read) CF (put, read);
endmodule: vURAM1BE
/*
module mkURAMCore1BE#(
                      Integer memSize,
                      Bool hasOutputRegister
                     ) (URAM_PORT_BE#(addr, data, n))
   provisos(
            Bits#(addr, addr_sz),
            Bits#(data, data_sz),
            Div#(data_sz, n, chunk_sz),
            Mul#(chunk_sz, n, data_sz)
           );
   URAM_PORT_BE#(addr, data, n) _i <- vURAM1BE (memSize, hasOutputRegister) ;
   return _i;
endmodule

typedef struct {
                wren    writeen;
                addr    address;
                data    datain;
                } URAMRequestBE#(type addr, type data, type wren) deriving (Bits, Eq, FShow);

typedef Server#(URAMRequestBE#(addr, data, wren), data) URAMServerBE#(type addr, type data, type wren);

module mkURAM1BE (URAMServerBE#(addr, data, wren))
   provisos(
	    Bits#(addr, addr_sz),
	    Bits#(data, data_sz),
	    Bits#(wren, be_sz),
	    Div#(data_sz, 8, be_sz),
	    Mul#(8, be_sz, data_sz),
	    Bounded#(addr)
	    );

   ////////////////////////////////////////////////////////////////////////////////
   /// Design Elements
   ////////////////////////////////////////////////////////////////////////////////
   URAM_PORT_BE#(addr, data, wren) memory <- vURAM1BE;

   FIFOF#(URAMRequestBE#(addr, data, wren))  fifoReq          <- mkBypassFIFOF;
   FIFOF#(data)                              fifoResp         <- mkBypassFIFOF;

   Wire#(addr)     wAddr       <- mkDWire(unpack(0));
   PulseWire       pwActive    <- mkPulseWire;
   Reg#(Bool)      rActive     <- mkReg(False);
   Reg#(Bool)      rActiveD1   <- mkReg(False);
   Wire#(data)     wData       <- mkDWire(unpack(0));
   Wire#(wren)     wWrite      <- mkDWire(unpack(0));

   ////////////////////////////////////////////////////////////////////////////////
   /// Rules
   ////////////////////////////////////////////////////////////////////////////////
   (* no_implicit_conditions, fire_when_enabled *)
   rule connect;
      memory.put(wWrite, wAddr, wData);
   endrule

   (* no_implicit_conditions, fire_when_enabled *)
   rule register_active;
      rActive   <= pwActive;
      rActiveD1 <= rActive;
   endrule

   Bool hasOutputRegister = True;  // XXX needs fixing when we know latency

   rule get_read_response((rActive && !hasOutputRegister) || (rActiveD1 && hasOutputRegister));
      fifoResp.enq(memory.read());
   endrule

   rule process_read_request(pack(fifoReq.first.writeen) == 0 &&
			     fifoResp.notFull);
      let request = fifoReq.first; fifoReq.deq;
      wAddr <= request.address;
      pwActive.send;
   endrule

   rule process_write_request(pack(fifoReq.first.writeen) != 0 &&
			      fifoResp.notFull);
      let request = fifoReq.first; fifoReq.deq;
      wAddr  <= request.address;
      wData  <= request.datain;
      wWrite <= request.writeen;
   endrule

   ////////////////////////////////////////////////////////////////////////////////
   /// Interface Connections / Methods
   ////////////////////////////////////////////////////////////////////////////////

   interface Put request  = toPut(fifoReq);
   interface Get response = toGet(fifoResp);
endmodule: mkURAM1BE
*/
