
package AWSteria_HW_Achronix;

import Assert ::*;
import BUtils ::*;
import Connectable ::*;
import Counter ::*;
import FIFOF ::*;
import GetPut ::*;
import Vector ::*;

import AXI4_Downsizer ::*;
import AXI4_Lite_Types ::*;
import AXI4_Types ::*;
import AXI4_Widener ::*;

import Semi_FIFOF ::*;

import AWSteria_HW_IFC ::*;
import AWSteria_HW ::*;
import MSIX ::*;

interface AWSteria_HW_Achronix;
   interface AXI4_Slave_IFC #(16, 64, 256, 0) pcie_0_AXI4_S;
   interface AXI4_Slave_IFC #(16, 32, 256, 0) pcie_1_AXI4_S;
   interface AXI4_Slave_IFC #(8, 64, 256, 0) msix_0_AXI4_S;
   interface AXI4_Master_IFC #(16, 64, 256, 0) ddr_0_AXI4_M;
   interface AXI4_Master_IFC #(8, 64, 256, 0) msix_0_AXI4_M;
endinterface

interface AXI4_Lite_Slave_Converter_IFC#(numeric type wd_id, numeric type wd_addr, numeric type wd_data, numeric type wd_user);

   interface AXI4_Lite_Master_IFC#(wd_addr, wd_data, wd_user) to_slave;
   interface AXI4_Slave_IFC#(wd_id, wd_addr, wd_data, wd_user) from_master;
endinterface

module mkAXI4_Lite_Slave_Converter(AXI4_Lite_Slave_Converter_IFC#(wd_id, wd_addr, wd_data, wd_user));

   AXI4_Slave_Xactor_IFC#(wd_id, wd_addr, wd_data, wd_user) x_axi4_slave <- mkAXI4_Slave_Xactor;
   AXI4_Lite_Master_Xactor_IFC#(wd_addr, wd_data, wd_user) x_axi4l_master <- mkAXI4_Lite_Master_Xactor;

   FIFOF#(Bit#(wd_id)) f_rid <- mkFIFOF;
   FIFOF#(Bit#(wd_id)) f_wid <- mkFIFOF;

   rule rl_ar;
      let axi4 = x_axi4_slave.o_rd_addr.first;
      x_axi4_slave.o_rd_addr.deq;

      AXI4_Lite_Rd_Addr#(wd_addr, wd_user) axi4l = AXI4_Lite_Rd_Addr {
	 araddr: axi4.araddr,
	 arprot: axi4.arprot,
	 aruser: axi4.aruser};

      dynamicAssert(axi4.arlen == 0, "unsupport ARLEN on AXI4 Lite conversion");
      dynamicAssert(axi4.arsize == fromInteger(valueOf(TSub#(TLog#(wd_data),1))), "unsupport ARSIZE on AXI4 Lite conversion");
      dynamicAssert(axi4.arlock == 0, "unsupport ARLOCK on AXI4 Lite conversion");
      dynamicAssert(axi4.arcache == 0, "unsupport ARCACHE on AXI4 Lite conversion");

      f_rid.enq(axi4.arid);
      x_axi4l_master.i_rd_addr.enq(axi4l);
   endrule

   rule rl_r;
      let axi4l = x_axi4l_master.o_rd_data.first;
      x_axi4l_master.o_rd_data.deq;

      let rid = f_rid.first;
      f_rid.deq;

      AXI4_Rd_Data#(wd_id, wd_data, wd_user) axi4 = AXI4_Rd_Data {
	 rid: rid,
	 rdata: axi4l.rdata,
	 rresp: pack(axi4l.rresp),
	 rlast: True,
	 ruser: axi4l.ruser};

      x_axi4_slave.i_rd_data.enq(axi4);
   endrule

   rule rl_aw;
      let axi4 = x_axi4_slave.o_wr_addr.first;
      x_axi4_slave.o_wr_addr.deq;

      AXI4_Lite_Wr_Addr#(wd_addr, wd_user) axi4l = AXI4_Lite_Wr_Addr {
	 awaddr: axi4.awaddr,
	 awprot: axi4.awprot,
	 awuser: axi4.awuser};

      dynamicAssert(axi4.awlen == 0, "unsupported AWLEN on AXI4 Lite conversion");
      dynamicAssert(axi4.awsize == fromInteger(valueOf(TSub#(TLog#(wd_data),1))), "unsupported AWSIZE on AXI4 Lite conversion");
      dynamicAssert(axi4.awlock == 0, "unsupported AWLOCK on AXI4 Lite conversion");
      dynamicAssert(axi4.awcache == 0, "unsupported AWCACHE on AXI4 Lite conversion");

      f_wid.enq(axi4.awid);
      x_axi4l_master.i_wr_addr.enq(axi4l);
   endrule

   rule rl_w;
      let axi4 = x_axi4_slave.o_wr_data.first;
      x_axi4_slave.o_wr_data.deq;

      AXI4_Lite_Wr_Data#(wd_data) axi4l = AXI4_Lite_Wr_Data {
	 wdata: axi4.wdata,
	 wstrb: axi4.wstrb
	 //wuser: axi4.wuser  /// \todo missing in AXI4_Lite_Types
	 };

      dynamicAssert(axi4.wlast == True, "unsupported WLAST on AXI4 Lite conversion");

      x_axi4l_master.i_wr_data.enq(axi4l);
   endrule

   rule rl_b;
      let axi4l = x_axi4l_master.o_wr_resp.first;
      x_axi4l_master.o_wr_resp.deq;

      let wid = f_wid.first;
      f_wid.deq;

      AXI4_Wr_Resp#(wd_id, wd_user) axi4 = AXI4_Wr_Resp {
	 bid: wid,
	 bresp: pack(axi4l.bresp),
	 buser: axi4l.buser};

      x_axi4_slave.i_wr_resp.enq(axi4);
   endrule

   interface to_slave = x_axi4l_master.axi_side;
   interface from_master = x_axi4_slave.axi_side;

endmodule

// (* synthesize *)
// module mkAWSteria_HW#(Clock clk1, Clock clk2, Clock clk3, Clock clk4, Clock clk5)
//    (AWSteria_HW_IFC#(AXI4_Slave_IFC #(16, 64, 512, 0),
// 		     AXI4_Lite_Slave_IFC #(32, 32, 0),
// 		     AXI4_Master_IFC #(16, 64, 512, 0)));

//    interface host_AXI4_S = ?;
//    interface host_AXI4L_S = ?;
//    interface host_interrupts = ?;

//    interface ddr_A_M = ?;

// `ifdef INCLUDE_DDR_B
//    interface ddr_B_M = ?;
// `endif

// `ifdef INCLUDE_DDR_C
//    interface ddr_C_M = ?;
// `endif

// `ifdef INCLUDE_DDR_D
//    interface ddr_D_M = ?;
// `endif

//    method Action m_env_ready(Bool env_ready) = noAction;
//    method m_halted = ?;
//    method Action m_glcount(Bit#(64) glcount) = noAction;

// endmodule

(* synthesize *)
module mkAWSteria_HW_Achronix#(Clock clk1, Clock clk2, Clock clk3, Clock clk4, Clock clk5)(AWSteria_HW_Achronix);

   AWSteria_HW_IFC#(AXI4_Slave_IFC #(16, 64, 512, 0),
		    AXI4_Lite_Slave_IFC #(32, 32, 0),
		    AXI4_Master_IFC #(16, 64, 512, 0))
   awsteria_hw <- mkAWSteria_HW(clk1, clk2, clk3, clk4, clk5);

   // widen data 256 -> 512
   AXI4_Widener_IFC#(16, 64, 256, 512, 0) pcie_0_widen <- mkAXI4_Widener;

   mkConnection(pcie_0_widen.to_slave, awsteria_hw.host_AXI4_S);

   // downsize data 256 -> 32, axi4 -> axi4l
   AXI4_Downsizer_IFC#(16, 32, 256, 32, 0) pcie_1_narrow <- mkAXI4_Downsizer;
   AXI4_Lite_Slave_Converter_IFC#(16, 32, 32, 0) pcie_1_slave_converter <- mkAXI4_Lite_Slave_Converter;

   mkConnection(pcie_1_narrow.to_slave, pcie_1_slave_converter.from_master);
   mkConnection(pcie_1_slave_converter.to_slave, awsteria_hw.host_AXI4L_S);

   // downsize data 512 -> 256
   AXI4_Downsizer_IFC#(16, 64, 512, 256, 0) ddr_0_narrow <- mkAXI4_Downsizer;

   mkConnection(awsteria_hw.ddr_A_M, ddr_0_narrow.from_master);

   // AWSteria supports 16 interrupts, but the Achronix PCIe endpoint only supports 8
   MSIX_IFC#(8, 64, 256, 0, 8) msix <- mkMSIX('h00000, 'h10000, 'h10000);

   Vector#(8, Wire#(Bit#(1))) vw_irq_ack <- replicateM(mkDWire(0));

   for (Integer i = 0; i < 8; i = i + 1) begin
      rule rl_interrupt(awsteria_hw.host_interrupts.irq_req[i] == 1);
	 msix.interrupts[i].put(?);
	 vw_irq_ack[i] <= 1;
      endrule
   end

   rule rl_irq_ack;
      awsteria_hw.host_interrupts.irq_ack(cExtend(readVReg(vw_irq_ack)));
   endrule

   rule rl_env_ready;
      awsteria_hw.m_env_ready(True);
   endrule

   Counter#(64) glcount <- mkCounter(0);

   rule rl_glcount;
      glcount.up;
   endrule

   mkConnection(awsteria_hw.m_glcount, glcount.value);

   interface pcie_0_AXI4_S = pcie_0_widen.from_master;
   interface pcie_1_AXI4_S = pcie_1_narrow.from_master;
   interface msix_0_AXI4_S = msix.axi4_slave;
   interface ddr_0_AXI4_M = ddr_0_narrow.to_slave;
   interface msix_0_AXI4_M = msix.axi4_master;

endmodule

endpackage
