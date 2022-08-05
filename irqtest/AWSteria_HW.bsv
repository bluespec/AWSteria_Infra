
package AWSteria_HW;

import Assert ::*;
import ClientServer ::*;
import DummyDriver ::*;
import GetPut ::*;
import Vector ::*;

import AXI4_Lite_Types ::*;
import AXI4_Types ::*;
import Semi_FIFOF ::*;

import AWSteria_HW_IFC ::*;
import HostInterruptGen ::*;

instance DummyDriver#(FIFOF_I#(t));
   module mkStub(FIFOF_I#(t));
      method enq(x) if (False) = noAction;
      method notFull = False;
   endmodule
endinstance

instance DummyDriver#(FIFOF_O#(t));
   module mkStub(FIFOF_O#(t));
      method first if (False) = ?;
      method deq if (False) = noAction;
      method notEmpty = False;
   endmodule
endinstance

instance DummyDriver#(AXI4_Slave_IFC#(wd_id, wd_addr, wd_data, wd_user));
   module mkStub(AXI4_Slave_IFC#(wd_id, wd_addr, wd_data, wd_user));
      method m_awvalid = ?;//noAction;
      method m_awready = False;
      method m_wvalid = ?;//noAction;
      method m_wready = False;
      method m_bvalid = False;
      method m_bid = ?;
      method m_bresp = ?;
      method m_buser = ?;
      method m_bready = ?;//noAction;
      method m_arvalid = ?;//noAction;
      method m_arready = False;
      method m_rvalid = False;
      method m_rid = ?;
      method m_rdata = ?;
      method m_rresp = ?;
      method m_rlast = ?;
      method m_ruser = ?;
      method m_rready = ?;//noAction;
   endmodule
endinstance

instance DummyDriver#(AXI4_Lite_Slave_IFC#(wd_addr, wd_data, wd_user));
   module mkStub(AXI4_Lite_Slave_IFC#(wd_addr, wd_data, wd_user));
      method m_awvalid = ?;//noAction;
      method m_awready = False;
      method m_wvalid = ?;//noAction;
      method m_wready = False;
      method m_bvalid = False;
      method m_bresp = ?;
      method m_buser = ?;
      method m_bready = ?;//noAction;
      method m_arvalid = ?;//noAction;
      method m_arready = False;
      method m_rvalid = False;
      method m_rdata = ?;
      method m_rresp = ?;
      method m_ruser = ?;
      method m_rready = ?;//noAction;
   endmodule
endinstance

instance DummyDriver#(AXI4_Master_IFC#(wd_id, wd_addr, wd_data, wd_user));
   module mkStub(AXI4_Master_IFC#(wd_id, wd_addr, wd_data, wd_user));
      method m_awvalid = False;
      method m_awid = ?;
      method m_awaddr = ?;
      method m_awlen = ?;
      method m_awsize = ?;
      method m_awburst = ?;
      method m_awlock = ?;
      method m_awcache = ?;
      method m_awprot = ?;
      method m_awqos = ?;
      method m_awregion = ?;
      method m_awuser = ?;
      method m_awready = ?;//noAction;
      method m_wvalid = False;
      method m_wdata = ?;
      method m_wstrb = ?;
      method m_wlast = ?;
      method m_wuser = ?;
      method m_wready = ?;//noAction;
      method m_bvalid = ?;//noAction;
      method m_bready = False;
      method m_arvalid = False;
      method m_arid = ?;
      method m_araddr = ?;
      method m_arlen = ?;
      method m_arsize = ?;
      method m_arburst = ?;
      method m_arlock = ?;
      method m_arcache = ?;
      method m_arprot = ?;
      method m_arqos = ?;
      method m_arregion = ?;
      method m_aruser = ?;
      method m_arready = ?;//noAction;
      method m_rvalid = ?;//noAction;
      method m_rready = False;
   endmodule
endinstance

interface IrqTest_IFC#(numeric type wd_addr, numeric type wd_data, numeric type wd_user, numeric type nint);
   interface AXI4_Lite_Slave_IFC#(wd_addr, wd_data, wd_user) axi4l;
   interface Host_Interrupts_IFC#(nint) host_interrupts;
endinterface

module mkIrqTest(IrqTest_IFC#(axi4l_wd_addr, axi4l_wd_data, axi4l_wd_user, nint));
   AXI4_Lite_Slave_Xactor_IFC#(axi4l_wd_addr, axi4l_wd_data, axi4l_wd_user) x_axi4l <- mkAXI4_Lite_Slave_Xactor;

   Host_Interrupt_Gen_IFC#(nint) host_int <- mkHostInterruptGen(False);

   rule rl_read;
      let addr = x_axi4l.o_rd_addr.first;
      x_axi4l.o_rd_addr.deq;

      AXI4_Lite_Rd_Data#(axi4l_wd_data, axi4l_wd_user) data = AXI4_Lite_Rd_Data {
	 rresp: AXI4_LITE_OKAY,
	 rdata: ?,
	 ruser: 0};

      case (addr.araddr) matches
	 0: noAction;
	 4: data.rdata = fromInteger(valueOf(N_INT));
	 default: data.rresp = AXI4_LITE_SLVERR;
      endcase

      x_axi4l.i_rd_data.enq(data);
   endrule

   function fn_irq_req(i);
      action
	 if (i < fromInteger(valueOf(N_INT))) begin
	    host_int.interrupts[i].request.put(?);
	 end
      endaction
   endfunction

   rule rl_write;
      let addr = x_axi4l.o_wr_addr.first;
      let data = x_axi4l.o_wr_data.first;
      x_axi4l.o_wr_addr.deq;
      x_axi4l.o_wr_data.deq;

      AXI4_Lite_Wr_Resp#(axi4l_wd_user) resp = AXI4_Lite_Wr_Resp {
	 bresp: AXI4_LITE_OKAY,
	 buser: 0};

      if (data.wstrb != '1) begin
	 resp.bresp = AXI4_LITE_SLVERR;
      end
      else begin
	 case (addr.awaddr) matches
	    0: fn_irq_req(data.wdata);
	    4: noAction;
	    default: resp.bresp = AXI4_LITE_SLVERR;
	 endcase
      end

      x_axi4l.i_wr_resp.enq(resp);
   endrule

   interface axi4l = x_axi4l.axi_side;
   interface host_interrupts = host_int.host_interrupts;

endmodule

module mkAWSteria_HW_Template#(Clock clk1, Clock clk2, Clock clk3, Clock clk4, Clock clk5)
   (AWSteria_HW_IFC#(
      AXI4_Slave_IFC#(axi4_wd_id, axi4_wd_addr, axi4_wd_data, axi4_wd_user),
      AXI4_Lite_Slave_IFC#(axi4l_wd_addr, axi4l_wd_data, axi4l_wd_user),
      AXI4_Master_IFC#(axi4_wd_id, axi4_wd_addr, axi4_wd_data, axi4_wd_user)));

   IrqTest_IFC#(axi4l_wd_addr, axi4l_wd_data, axi4l_wd_user, N_INT) irqtest <- mkIrqTest;

   let host_AXI4_S_stub <- mkStub;

   let ddr_A_M_stub <- mkStub;

`ifdef INCLUDE_DDR_B
   let ddr_B_M_stub <- mkStub;
`endif

`ifdef INCLUDE_DDR_C
   let ddr_C_M_stub <- mkStub;
`endif

`ifdef INCLUDE_DDR_D
   let ddr_D_M_stub <- mkStub;
`endif

   interface host_AXI4_S = host_AXI4_S_stub;

   interface host_AXI4L_S = irqtest.axi4l;
   interface host_interrupts = irqtest.host_interrupts;

   interface ddr_A_M = ddr_A_M_stub;

`ifdef INCLUDE_DDR_B
   interface ddr_B_M = ddr_B_M_stub;
`endif

`ifdef INCLUDE_DDR_C
   interface ddr_C_M = ddr_C_M_stub;
`endif

`ifdef INCLUDE_DDR_D
   interface ddr_D_M = ddr_D_M_stub;
`endif

   method m_env_ready = ?;//noAction;
   method m_halted = False;
   method m_glcount = ?;//noAction;

endmodule

(* synthesize *)
module mkAWSteria_HW#(Clock clk1, Clock clk2, Clock clk3, Clock clk4, Clock clk5)
   (AWSteria_HW_IFC#(
      AXI4_Slave_IFC#(16, 64, 512, 0),
      AXI4_Lite_Slave_IFC#(32, 32, 0),
      AXI4_Master_IFC#(16, 64, 512, 0)));
   let _ifc <- mkAWSteria_HW_Template(clk1, clk2, clk3, clk4, clk5);
   return _ifc;
endmodule

// derp
(* synthesize *)
module mkAWSteria_System (Empty);
endmodule

endpackage
