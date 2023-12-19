
package MSIX;

import Assert ::*;
import BUtils ::*;
import FIFO ::*;
import GetPut ::*;
import Vector ::*;

import Semi_FIFOF ::*;

import AXI4_Types ::*;

interface MSIX_IFC#(numeric type wd_id, numeric type wd_addr, numeric type wd_data, numeric type wd_user, numeric type entries);
   interface AXI4_Slave_IFC#(wd_id, wd_addr, wd_data, wd_user) axi4_slave;
   interface AXI4_Master_IFC#(wd_id, wd_addr, wd_data, wd_user) axi4_master;
   interface Vector #(entries, Put#(void)) interrupts;
endinterface

typedef struct {
   UInt#(64) addr;
   UInt#(32) data;
   UInt#(1) mask;
   } MSIX_Table_Entry deriving (Bits, Eq);

module mkMSIX#(Integer table_offset, Integer pba_offset, Integer offset_mask)(MSIX_IFC#(wd_id, wd_addr, wd_data, wd_user, entries))
   provisos(
      Add#(16, a__, wd_addr),
      Mul#(64, b__, wd_data),
      Add#(entries, c__, 2048),  // PCIe spec limit
      // per bsc
      Add#(d__, TLog#(TDiv#(wd_data, 32)), wd_addr),
      Add#(e__, TLog#(TDiv#(wd_data, 64)), wd_addr),
      Mul#(32, f__, wd_data),
      Add#(g__, TLog#(TDiv#(wd_data, 32)), 64)
      );

   Bit#(wd_addr) table_offset_bits = fromInteger(table_offset);
   Bit#(wd_addr) pba_offset_bits = fromInteger(pba_offset);
   Bit#(wd_addr) offset_mask_bits = fromInteger(offset_mask);

   //staticAssert(log(fromInteger(table_offset)) < fromInteger(valueOf(wd_addr)), "table offset must fit within address range");
   //staticAssert(log(fromInteger(pba_offset)) < fromInteger(valueOf(wd_addr)), "pba offset must fit within address range");
   staticAssert(table_offset_bits != pba_offset_bits, "offets cannot overlap");
   staticAssert((table_offset_bits & ~offset_mask_bits) == 0, "table offset must fit within mask");
   staticAssert((pba_offset_bits & ~offset_mask_bits) == 0, "pba offset must fit within mask");
   staticAssert((table_offset_bits & 'h7fff) == 0, "table offset must be aligned to 'h8000");
   staticAssert((pba_offset_bits & 'h7fff) == 0, "pba offset must be aligned to 'h8000");
   
   AXI4_Slave_Xactor_IFC#(wd_id, wd_addr, wd_data, wd_user) x_axi4_slave <- mkAXI4_Slave_Xactor;
   AXI4_Master_Xactor_IFC#(wd_id, wd_addr, wd_data, wd_user) x_axi4_master <- mkAXI4_Master_Xactor;

   Vector#(entries, Reg#(MSIX_Table_Entry)) vr_msix_table <- replicateM(mkReg(unpack(0)));
   Vector#(entries, Array#(Reg#(UInt#(1)))) vr_pending <- replicateM(mkCReg(2, 0));

   function f_valid_addr(addr);
      return (addr & 3) == 0;
   endfunction

   function f_valid_size(size);
      return size == axsize_4;
   endfunction

   function f_valid_len(len);
      return len == 0;
   endfunction

   function f_valid_strb_32(addr, strb);
      Bit#(TDiv#(wd_data,8)) strb_mask = 'b1111;
      Bit#(TLog#(TDiv#(wd_data,32))) offset = truncate(addr >> 2);
      Bit#(TDiv#(wd_data,8)) offset2 = zExtend(offset) << 2;
      strb_mask = strb_mask << offset2;
      return strb == strb_mask;
   endfunction

   function f_valid_strb_64(addr, strb);
      Bit#(TDiv#(wd_data,8)) strb_mask = 'b11111111;
      Bit#(TLog#(TDiv#(wd_data,64))) offset = truncate(addr >> 3);
      Bit#(TDiv#(wd_data,8)) offset2 = zExtend(offset) << 3;
      strb_mask = strb_mask << offset2;
      return strb == strb_mask;
   endfunction

   function f_valid_strb(addr, strb, size);
      if (size == axsize_4)
	 return f_valid_strb_32(addr, strb);
      else if (size == axsize_8)
	 return f_valid_strb_64(addr, strb);
      else
	 return False;
   endfunction

   function f_addr_table(addr);
      return (addr & fromInteger(offset_mask)) == fromInteger(table_offset);
   endfunction

   function f_addr_pba(addr);
      return (addr & fromInteger(offset_mask)) == fromInteger(pba_offset);
   endfunction

   function f_data_32(addr, data);
      Bit#(TLog#(TDiv#(wd_data,32))) offset = truncate(addr >> 2);
      Bit#(TDiv#(wd_data,8)) offset2 = zExtend(offset) << 5;
      return data >> offset2;
   endfunction

   function f_data_64(addr, data);
      Bit#(TLog#(TDiv#(wd_data,64))) offset = truncate(addr >> 3);
      Bit#(TDiv#(wd_data,8)) offset2 = zExtend(offset) << 5;
      return data >> offset2;
   endfunction

   function f_data(addr, data, size);
      if (size == axsize_4)
	 return f_data_32(addr, data);
      else if (size == axsize_8)
	 return f_data_64(addr, data);
      else
	 return ?;
   endfunction

   function f_read_table(addr);
      Bit#(wd_addr) entry = addr >> 4;
      Bit#(wd_addr) offset = addr & 'hf;
      Bit#(64) data = 0;

      if (entry >= fromInteger(valueOf(entries))) begin
	 // nothing
      end
      else begin
	 let table_entry = vr_msix_table[entry];

      // addr and data are undefined on read
      // if (offset == 'h0) begin
      // 	 data = pack(table_entry.addr);
      // end
      // else if (offset == 'h8) begin
      // 	 data = {31'h0, pack(table_entry.mask), pack(table_entry.data)};
      // end

	 if (offset == 'h8) begin
	    data = {31'h0, pack(table_entry.mask), 32'h0};
	 end
      end

      return duplicate(data);
   endfunction

   function get_pending(n);
      return vr_pending[n][1];
   endfunction

   function f_read_pba(addr);
      Bit#(wd_addr) u64_addr = addr >> 3;
      Bit#(64) data = 0;

      if (u64_addr >= (fromInteger(valueOf(entries)) >> 6)) begin
	 // nothing
      end
      else begin
	 // todo: confirm vector pack puts element 0 at msb
	 Bit#(entries) pba = reverseBits(pack(genWith(get_pending)));

	 data = cExtend(pba >> (u64_addr * 64));
      end

      return duplicate(data);
   endfunction

   function f_write_table(addr, data, size);
      action
	 Bit#(wd_addr) entry = addr >> 4;
	 Bit#(wd_addr) offset = addr & 'hf;

	 if (entry >= fromInteger(valueOf(entries))) begin
	    // nothing
	 end
	 else begin
	    let table_entry = vr_msix_table[entry];

	    if (size == axsize_8) begin
               if (offset == 'h0) begin
		  table_entry.addr = unpack(data);
	       end
	       else if (offset == 'h8) begin
		  table_entry.data = unpack(data[31:0]);
		  table_entry.mask = unpack(data[32]);
	       end
	    end
	    else if (size == axsize_4) begin
               if (offset == 'h0) begin
		  table_entry.addr = unpack({pack(table_entry.addr)[63:32], data[31:0]});
	       end
               else if (offset == 'h4) begin
		  table_entry.addr = unpack({data[31:0], pack(table_entry.addr)[31:0]});
	       end
	       else if (offset == 'h8) begin
		  table_entry.data = unpack(data[31:0]);
	       end
	       else if (offset == 'hc) begin
		  table_entry.mask = unpack(data[0]);
	       end
	    end

	    vr_msix_table[entry] <= table_entry;
	 end
      endaction
   endfunction

   (* descending_urgency = "rl_read, rl_write" *)
   rule rl_read;
      let addr = x_axi4_slave.o_rd_addr.first;
      x_axi4_slave.o_rd_addr.deq;

      AXI4_Rd_Data#(wd_id, wd_data, wd_user) data = AXI4_Rd_Data {
	 rresp: axi4_resp_slverr,
	 rid: addr.arid,
	 rdata: ?,
	 rlast: True,
	 ruser: addr.aruser};

      if (!f_valid_addr(addr.araddr) || !f_valid_size(addr.arsize) || !f_valid_len(addr.arlen)) begin
	 noAction;
      end
      else if (f_addr_table(addr.araddr)) begin
	 data.rresp = axi4_resp_okay;
	 data.rdata = f_read_table(addr.araddr);
      end
      else if (f_addr_pba(addr.araddr)) begin
	 data.rresp = axi4_resp_okay;
	 data.rdata = f_read_pba(addr.araddr);
      end

      x_axi4_slave.i_rd_data.enq(data);
   endrule

   rule rl_write;
      let addr = x_axi4_slave.o_wr_addr.first;
      let data = x_axi4_slave.o_wr_data.first;
      x_axi4_slave.o_wr_addr.deq;
      x_axi4_slave.o_wr_data.deq;

      AXI4_Wr_Resp#(wd_id, wd_user) resp = AXI4_Wr_Resp {
	 bresp: axi4_resp_slverr,
	 bid: addr.awid,
	 buser: addr.awuser};

      if (!f_valid_addr(addr.awaddr) || !f_valid_size(addr.awsize) || !f_valid_len(addr.awlen) || !f_valid_strb(addr.awaddr, data.wstrb, addr.awsize)) begin
	 noAction;
      end
      else if (f_addr_table(addr.awaddr)) begin
	 resp.bresp = axi4_resp_okay;
	 f_write_table(addr.awaddr, cExtend(f_data(addr.awaddr, data.wdata, addr.awsize)), addr.awsize);
      end
      else if (f_addr_pba(addr.awaddr)) begin
	 // undefined, so just ignore it
	 resp.bresp = axi4_resp_okay;
      end

      x_axi4_slave.i_wr_resp.enq(resp);
   endrule

   function get_mask(n);
      return vr_msix_table[n].mask;
   endfunction

   Bit#(entries) pending = reverseBits(pack(genWith(get_pending)));
   Bit#(entries) mask = reverseBits(pack(genWith(get_mask)));
   let raise_interrupt = countZerosLSB(pending & ~mask);

   function f_strb_32(addr);
      Bit#(TDiv#(wd_data,8)) strb_mask = 'b1111;
      Bit#(TLog#(TDiv#(wd_data,32))) offset = truncate(addr >> 2);
      Bit#(TDiv#(wd_data,8)) offset2 = zExtend(offset) << 2;
      strb_mask = strb_mask << offset2;
      return strb_mask;
   endfunction

   rule rl_interrupt_write(raise_interrupt < fromInteger(valueOf(entries)));
      let table_entry = vr_msix_table[raise_interrupt];

      AXI4_Wr_Addr#(wd_id, wd_addr, wd_user) addr = AXI4_Wr_Addr {
	 awid: 0,
	 awaddr: cExtend(table_entry.addr),
	 awlen: 0,
	 awsize: axsize_4,
	 awburst: axburst_fixed,
	 awlock: axlock_normal,
	 awcache: awcache_dev_nonbuf,
	 awprot: 0,
	 awqos: 0,
	 awregion: 0,
	 awuser: 0};

      AXI4_Wr_Data#(wd_data, wd_user) data = AXI4_Wr_Data {
	 wdata: duplicate(pack(table_entry.data)),
	 wstrb: f_strb_32(pack(table_entry.addr)),
	 wlast: True,
	 wuser: 0};

      x_axi4_master.i_wr_addr.enq(addr);
      x_axi4_master.i_wr_data.enq(data);

      vr_pending[raise_interrupt][1] <= 0;
   endrule

   rule rl_interrupt_write_response;
      let resp = x_axi4_master.o_wr_resp.first;
      x_axi4_master.o_wr_resp.deq;

      // 🤷
   endrule

   function gen_interrupts(n);
      return interface Put;
		method Action put(void x);
		   vr_pending[n][0]._write(1);
		endmethod
	     endinterface;
   endfunction

   interface axi4_slave = x_axi4_slave.axi_side;
   interface axi4_master = x_axi4_master.axi_side;
   interface interrupts = genWith(gen_interrupts);

endmodule

endpackage
