//
// Generated by Bluespec Compiler (build 0fccbb13)
//
//
// Ports:
// Name                         I/O  size props
// ifc_AXI4L_S_awready            O     1 reg
// ifc_AXI4L_S_wready             O     1 reg
// ifc_AXI4L_S_bvalid             O     1 reg
// ifc_AXI4L_S_bresp              O     2 reg
// ifc_AXI4L_S_arready            O     1 reg
// ifc_AXI4L_S_rvalid             O     1 reg
// ifc_AXI4L_S_rresp              O     2 reg
// ifc_AXI4L_S_rdata              O    32 reg
// ifc_AXI4_M_awvalid             O     1 reg
// ifc_AXI4_M_awid                O    16 reg
// ifc_AXI4_M_awaddr              O    64 reg
// ifc_AXI4_M_awlen               O     8 reg
// ifc_AXI4_M_awsize              O     3 reg
// ifc_AXI4_M_awburst             O     2 reg
// ifc_AXI4_M_awlock              O     1 reg
// ifc_AXI4_M_awcache             O     4 reg
// ifc_AXI4_M_awprot              O     3 reg
// ifc_AXI4_M_awqos               O     4 reg
// ifc_AXI4_M_awregion            O     4 reg
// ifc_AXI4_M_wvalid              O     1 reg
// ifc_AXI4_M_wdata               O   512 reg
// ifc_AXI4_M_wstrb               O    64 reg
// ifc_AXI4_M_wlast               O     1 reg
// ifc_AXI4_M_bready              O     1 reg
// ifc_AXI4_M_arvalid             O     1 reg
// ifc_AXI4_M_arid                O    16 reg
// ifc_AXI4_M_araddr              O    64 reg
// ifc_AXI4_M_arlen               O     8 reg
// ifc_AXI4_M_arsize              O     3 reg
// ifc_AXI4_M_arburst             O     2 reg
// ifc_AXI4_M_arlock              O     1 reg
// ifc_AXI4_M_arcache             O     4 reg
// ifc_AXI4_M_arprot              O     3 reg
// ifc_AXI4_M_arqos               O     4 reg
// ifc_AXI4_M_arregion            O     4 reg
// ifc_AXI4_M_rready              O     1 reg
// CLK                            I     1 clock
// RST_N                          I     1 reset
// ifc_AXI4L_S_awvalid            I     1
// ifc_AXI4L_S_awaddr             I    32 reg
// ifc_AXI4L_S_awprot             I     3 reg
// ifc_AXI4L_S_wvalid             I     1
// ifc_AXI4L_S_wdata              I    32 reg
// ifc_AXI4L_S_wstrb              I     4 reg
// ifc_AXI4L_S_bready             I     1
// ifc_AXI4L_S_arvalid            I     1
// ifc_AXI4L_S_araddr             I    32 reg
// ifc_AXI4L_S_arprot             I     3 reg
// ifc_AXI4L_S_rready             I     1
// ifc_AXI4_M_awready             I     1
// ifc_AXI4_M_wready              I     1
// ifc_AXI4_M_bvalid              I     1
// ifc_AXI4_M_bid                 I    16 reg
// ifc_AXI4_M_bresp               I     2 reg
// ifc_AXI4_M_arready             I     1
// ifc_AXI4_M_rvalid              I     1
// ifc_AXI4_M_rid                 I    16 reg
// ifc_AXI4_M_rdata               I   512 reg
// ifc_AXI4_M_rresp               I     2 reg
// ifc_AXI4_M_rlast               I     1 reg
//
// No combinational paths from inputs to outputs
//
//

`ifdef BSV_ASSIGNMENT_DELAY
`else
  `define BSV_ASSIGNMENT_DELAY
`endif

`ifdef BSV_POSITIVE_RESET
  `define BSV_RESET_VALUE 1'b1
  `define BSV_RESET_EDGE posedge
`else
  `define BSV_RESET_VALUE 1'b0
  `define BSV_RESET_EDGE negedge
`endif

module mkAXI4L_S_to_AXI4_M_Adapter_synth(CLK,
					 RST_N,

					 ifc_AXI4L_S_awvalid,
					 ifc_AXI4L_S_awaddr,
					 ifc_AXI4L_S_awprot,

					 ifc_AXI4L_S_awready,

					 ifc_AXI4L_S_wvalid,
					 ifc_AXI4L_S_wdata,
					 ifc_AXI4L_S_wstrb,

					 ifc_AXI4L_S_wready,

					 ifc_AXI4L_S_bvalid,

					 ifc_AXI4L_S_bresp,

					 ifc_AXI4L_S_bready,

					 ifc_AXI4L_S_arvalid,
					 ifc_AXI4L_S_araddr,
					 ifc_AXI4L_S_arprot,

					 ifc_AXI4L_S_arready,

					 ifc_AXI4L_S_rvalid,

					 ifc_AXI4L_S_rresp,

					 ifc_AXI4L_S_rdata,

					 ifc_AXI4L_S_rready,

					 ifc_AXI4_M_awvalid,

					 ifc_AXI4_M_awid,

					 ifc_AXI4_M_awaddr,

					 ifc_AXI4_M_awlen,

					 ifc_AXI4_M_awsize,

					 ifc_AXI4_M_awburst,

					 ifc_AXI4_M_awlock,

					 ifc_AXI4_M_awcache,

					 ifc_AXI4_M_awprot,

					 ifc_AXI4_M_awqos,

					 ifc_AXI4_M_awregion,

					 ifc_AXI4_M_awready,

					 ifc_AXI4_M_wvalid,

					 ifc_AXI4_M_wdata,

					 ifc_AXI4_M_wstrb,

					 ifc_AXI4_M_wlast,

					 ifc_AXI4_M_wready,

					 ifc_AXI4_M_bvalid,
					 ifc_AXI4_M_bid,
					 ifc_AXI4_M_bresp,

					 ifc_AXI4_M_bready,

					 ifc_AXI4_M_arvalid,

					 ifc_AXI4_M_arid,

					 ifc_AXI4_M_araddr,

					 ifc_AXI4_M_arlen,

					 ifc_AXI4_M_arsize,

					 ifc_AXI4_M_arburst,

					 ifc_AXI4_M_arlock,

					 ifc_AXI4_M_arcache,

					 ifc_AXI4_M_arprot,

					 ifc_AXI4_M_arqos,

					 ifc_AXI4_M_arregion,

					 ifc_AXI4_M_arready,

					 ifc_AXI4_M_rvalid,
					 ifc_AXI4_M_rid,
					 ifc_AXI4_M_rdata,
					 ifc_AXI4_M_rresp,
					 ifc_AXI4_M_rlast,

					 ifc_AXI4_M_rready);
  input  CLK;
  input  RST_N;

  // action method ifc_AXI4L_S_m_awvalid
  input  ifc_AXI4L_S_awvalid;
  input  [31 : 0] ifc_AXI4L_S_awaddr;
  input  [2 : 0] ifc_AXI4L_S_awprot;

  // value method ifc_AXI4L_S_m_awready
  output ifc_AXI4L_S_awready;

  // action method ifc_AXI4L_S_m_wvalid
  input  ifc_AXI4L_S_wvalid;
  input  [31 : 0] ifc_AXI4L_S_wdata;
  input  [3 : 0] ifc_AXI4L_S_wstrb;

  // value method ifc_AXI4L_S_m_wready
  output ifc_AXI4L_S_wready;

  // value method ifc_AXI4L_S_m_bvalid
  output ifc_AXI4L_S_bvalid;

  // value method ifc_AXI4L_S_m_bresp
  output [1 : 0] ifc_AXI4L_S_bresp;

  // value method ifc_AXI4L_S_m_buser

  // action method ifc_AXI4L_S_m_bready
  input  ifc_AXI4L_S_bready;

  // action method ifc_AXI4L_S_m_arvalid
  input  ifc_AXI4L_S_arvalid;
  input  [31 : 0] ifc_AXI4L_S_araddr;
  input  [2 : 0] ifc_AXI4L_S_arprot;

  // value method ifc_AXI4L_S_m_arready
  output ifc_AXI4L_S_arready;

  // value method ifc_AXI4L_S_m_rvalid
  output ifc_AXI4L_S_rvalid;

  // value method ifc_AXI4L_S_m_rresp
  output [1 : 0] ifc_AXI4L_S_rresp;

  // value method ifc_AXI4L_S_m_rdata
  output [31 : 0] ifc_AXI4L_S_rdata;

  // value method ifc_AXI4L_S_m_ruser

  // action method ifc_AXI4L_S_m_rready
  input  ifc_AXI4L_S_rready;

  // value method ifc_AXI4_M_m_awvalid
  output ifc_AXI4_M_awvalid;

  // value method ifc_AXI4_M_m_awid
  output [15 : 0] ifc_AXI4_M_awid;

  // value method ifc_AXI4_M_m_awaddr
  output [63 : 0] ifc_AXI4_M_awaddr;

  // value method ifc_AXI4_M_m_awlen
  output [7 : 0] ifc_AXI4_M_awlen;

  // value method ifc_AXI4_M_m_awsize
  output [2 : 0] ifc_AXI4_M_awsize;

  // value method ifc_AXI4_M_m_awburst
  output [1 : 0] ifc_AXI4_M_awburst;

  // value method ifc_AXI4_M_m_awlock
  output ifc_AXI4_M_awlock;

  // value method ifc_AXI4_M_m_awcache
  output [3 : 0] ifc_AXI4_M_awcache;

  // value method ifc_AXI4_M_m_awprot
  output [2 : 0] ifc_AXI4_M_awprot;

  // value method ifc_AXI4_M_m_awqos
  output [3 : 0] ifc_AXI4_M_awqos;

  // value method ifc_AXI4_M_m_awregion
  output [3 : 0] ifc_AXI4_M_awregion;

  // value method ifc_AXI4_M_m_awuser

  // action method ifc_AXI4_M_m_awready
  input  ifc_AXI4_M_awready;

  // value method ifc_AXI4_M_m_wvalid
  output ifc_AXI4_M_wvalid;

  // value method ifc_AXI4_M_m_wdata
  output [511 : 0] ifc_AXI4_M_wdata;

  // value method ifc_AXI4_M_m_wstrb
  output [63 : 0] ifc_AXI4_M_wstrb;

  // value method ifc_AXI4_M_m_wlast
  output ifc_AXI4_M_wlast;

  // value method ifc_AXI4_M_m_wuser

  // action method ifc_AXI4_M_m_wready
  input  ifc_AXI4_M_wready;

  // action method ifc_AXI4_M_m_bvalid
  input  ifc_AXI4_M_bvalid;
  input  [15 : 0] ifc_AXI4_M_bid;
  input  [1 : 0] ifc_AXI4_M_bresp;

  // value method ifc_AXI4_M_m_bready
  output ifc_AXI4_M_bready;

  // value method ifc_AXI4_M_m_arvalid
  output ifc_AXI4_M_arvalid;

  // value method ifc_AXI4_M_m_arid
  output [15 : 0] ifc_AXI4_M_arid;

  // value method ifc_AXI4_M_m_araddr
  output [63 : 0] ifc_AXI4_M_araddr;

  // value method ifc_AXI4_M_m_arlen
  output [7 : 0] ifc_AXI4_M_arlen;

  // value method ifc_AXI4_M_m_arsize
  output [2 : 0] ifc_AXI4_M_arsize;

  // value method ifc_AXI4_M_m_arburst
  output [1 : 0] ifc_AXI4_M_arburst;

  // value method ifc_AXI4_M_m_arlock
  output ifc_AXI4_M_arlock;

  // value method ifc_AXI4_M_m_arcache
  output [3 : 0] ifc_AXI4_M_arcache;

  // value method ifc_AXI4_M_m_arprot
  output [2 : 0] ifc_AXI4_M_arprot;

  // value method ifc_AXI4_M_m_arqos
  output [3 : 0] ifc_AXI4_M_arqos;

  // value method ifc_AXI4_M_m_arregion
  output [3 : 0] ifc_AXI4_M_arregion;

  // value method ifc_AXI4_M_m_aruser

  // action method ifc_AXI4_M_m_arready
  input  ifc_AXI4_M_arready;

  // action method ifc_AXI4_M_m_rvalid
  input  ifc_AXI4_M_rvalid;
  input  [15 : 0] ifc_AXI4_M_rid;
  input  [511 : 0] ifc_AXI4_M_rdata;
  input  [1 : 0] ifc_AXI4_M_rresp;
  input  ifc_AXI4_M_rlast;

  // value method ifc_AXI4_M_m_rready
  output ifc_AXI4_M_rready;

  // signals for module outputs
  wire [511 : 0] ifc_AXI4_M_wdata;
  wire [63 : 0] ifc_AXI4_M_araddr, ifc_AXI4_M_awaddr, ifc_AXI4_M_wstrb;
  wire [31 : 0] ifc_AXI4L_S_rdata;
  wire [15 : 0] ifc_AXI4_M_arid, ifc_AXI4_M_awid;
  wire [7 : 0] ifc_AXI4_M_arlen, ifc_AXI4_M_awlen;
  wire [3 : 0] ifc_AXI4_M_arcache,
	       ifc_AXI4_M_arqos,
	       ifc_AXI4_M_arregion,
	       ifc_AXI4_M_awcache,
	       ifc_AXI4_M_awqos,
	       ifc_AXI4_M_awregion;
  wire [2 : 0] ifc_AXI4_M_arprot,
	       ifc_AXI4_M_arsize,
	       ifc_AXI4_M_awprot,
	       ifc_AXI4_M_awsize;
  wire [1 : 0] ifc_AXI4L_S_bresp,
	       ifc_AXI4L_S_rresp,
	       ifc_AXI4_M_arburst,
	       ifc_AXI4_M_awburst;
  wire ifc_AXI4L_S_arready,
       ifc_AXI4L_S_awready,
       ifc_AXI4L_S_bvalid,
       ifc_AXI4L_S_rvalid,
       ifc_AXI4L_S_wready,
       ifc_AXI4_M_arlock,
       ifc_AXI4_M_arvalid,
       ifc_AXI4_M_awlock,
       ifc_AXI4_M_awvalid,
       ifc_AXI4_M_bready,
       ifc_AXI4_M_rready,
       ifc_AXI4_M_wlast,
       ifc_AXI4_M_wvalid;

  // ports of submodule ifc_f_rd_addrs
  wire [31 : 0] ifc_f_rd_addrs$D_IN, ifc_f_rd_addrs$D_OUT;
  wire ifc_f_rd_addrs$CLR,
       ifc_f_rd_addrs$DEQ,
       ifc_f_rd_addrs$EMPTY_N,
       ifc_f_rd_addrs$ENQ,
       ifc_f_rd_addrs$FULL_N;

  // ports of submodule ifc_xactor_AXI4L_S_f_rd_addr
  wire [34 : 0] ifc_xactor_AXI4L_S_f_rd_addr$D_IN,
		ifc_xactor_AXI4L_S_f_rd_addr$D_OUT;
  wire ifc_xactor_AXI4L_S_f_rd_addr$CLR,
       ifc_xactor_AXI4L_S_f_rd_addr$DEQ,
       ifc_xactor_AXI4L_S_f_rd_addr$EMPTY_N,
       ifc_xactor_AXI4L_S_f_rd_addr$ENQ,
       ifc_xactor_AXI4L_S_f_rd_addr$FULL_N;

  // ports of submodule ifc_xactor_AXI4L_S_f_rd_data
  wire [33 : 0] ifc_xactor_AXI4L_S_f_rd_data$D_IN,
		ifc_xactor_AXI4L_S_f_rd_data$D_OUT;
  wire ifc_xactor_AXI4L_S_f_rd_data$CLR,
       ifc_xactor_AXI4L_S_f_rd_data$DEQ,
       ifc_xactor_AXI4L_S_f_rd_data$EMPTY_N,
       ifc_xactor_AXI4L_S_f_rd_data$ENQ,
       ifc_xactor_AXI4L_S_f_rd_data$FULL_N;

  // ports of submodule ifc_xactor_AXI4L_S_f_wr_addr
  wire [34 : 0] ifc_xactor_AXI4L_S_f_wr_addr$D_IN,
		ifc_xactor_AXI4L_S_f_wr_addr$D_OUT;
  wire ifc_xactor_AXI4L_S_f_wr_addr$CLR,
       ifc_xactor_AXI4L_S_f_wr_addr$DEQ,
       ifc_xactor_AXI4L_S_f_wr_addr$EMPTY_N,
       ifc_xactor_AXI4L_S_f_wr_addr$ENQ,
       ifc_xactor_AXI4L_S_f_wr_addr$FULL_N;

  // ports of submodule ifc_xactor_AXI4L_S_f_wr_data
  wire [35 : 0] ifc_xactor_AXI4L_S_f_wr_data$D_IN,
		ifc_xactor_AXI4L_S_f_wr_data$D_OUT;
  wire ifc_xactor_AXI4L_S_f_wr_data$CLR,
       ifc_xactor_AXI4L_S_f_wr_data$DEQ,
       ifc_xactor_AXI4L_S_f_wr_data$EMPTY_N,
       ifc_xactor_AXI4L_S_f_wr_data$ENQ,
       ifc_xactor_AXI4L_S_f_wr_data$FULL_N;

  // ports of submodule ifc_xactor_AXI4L_S_f_wr_resp
  wire [1 : 0] ifc_xactor_AXI4L_S_f_wr_resp$D_IN,
	       ifc_xactor_AXI4L_S_f_wr_resp$D_OUT;
  wire ifc_xactor_AXI4L_S_f_wr_resp$CLR,
       ifc_xactor_AXI4L_S_f_wr_resp$DEQ,
       ifc_xactor_AXI4L_S_f_wr_resp$EMPTY_N,
       ifc_xactor_AXI4L_S_f_wr_resp$ENQ,
       ifc_xactor_AXI4L_S_f_wr_resp$FULL_N;

  // ports of submodule ifc_xactor_AXI4_M_f_rd_addr
  wire [108 : 0] ifc_xactor_AXI4_M_f_rd_addr$D_IN,
		 ifc_xactor_AXI4_M_f_rd_addr$D_OUT;
  wire ifc_xactor_AXI4_M_f_rd_addr$CLR,
       ifc_xactor_AXI4_M_f_rd_addr$DEQ,
       ifc_xactor_AXI4_M_f_rd_addr$EMPTY_N,
       ifc_xactor_AXI4_M_f_rd_addr$ENQ,
       ifc_xactor_AXI4_M_f_rd_addr$FULL_N;

  // ports of submodule ifc_xactor_AXI4_M_f_rd_data
  wire [530 : 0] ifc_xactor_AXI4_M_f_rd_data$D_IN,
		 ifc_xactor_AXI4_M_f_rd_data$D_OUT;
  wire ifc_xactor_AXI4_M_f_rd_data$CLR,
       ifc_xactor_AXI4_M_f_rd_data$DEQ,
       ifc_xactor_AXI4_M_f_rd_data$EMPTY_N,
       ifc_xactor_AXI4_M_f_rd_data$ENQ,
       ifc_xactor_AXI4_M_f_rd_data$FULL_N;

  // ports of submodule ifc_xactor_AXI4_M_f_wr_addr
  wire [108 : 0] ifc_xactor_AXI4_M_f_wr_addr$D_IN,
		 ifc_xactor_AXI4_M_f_wr_addr$D_OUT;
  wire ifc_xactor_AXI4_M_f_wr_addr$CLR,
       ifc_xactor_AXI4_M_f_wr_addr$DEQ,
       ifc_xactor_AXI4_M_f_wr_addr$EMPTY_N,
       ifc_xactor_AXI4_M_f_wr_addr$ENQ,
       ifc_xactor_AXI4_M_f_wr_addr$FULL_N;

  // ports of submodule ifc_xactor_AXI4_M_f_wr_data
  wire [576 : 0] ifc_xactor_AXI4_M_f_wr_data$D_IN,
		 ifc_xactor_AXI4_M_f_wr_data$D_OUT;
  wire ifc_xactor_AXI4_M_f_wr_data$CLR,
       ifc_xactor_AXI4_M_f_wr_data$DEQ,
       ifc_xactor_AXI4_M_f_wr_data$EMPTY_N,
       ifc_xactor_AXI4_M_f_wr_data$ENQ,
       ifc_xactor_AXI4_M_f_wr_data$FULL_N;

  // ports of submodule ifc_xactor_AXI4_M_f_wr_resp
  wire [17 : 0] ifc_xactor_AXI4_M_f_wr_resp$D_IN,
		ifc_xactor_AXI4_M_f_wr_resp$D_OUT;
  wire ifc_xactor_AXI4_M_f_wr_resp$CLR,
       ifc_xactor_AXI4_M_f_wr_resp$DEQ,
       ifc_xactor_AXI4_M_f_wr_resp$EMPTY_N,
       ifc_xactor_AXI4_M_f_wr_resp$ENQ,
       ifc_xactor_AXI4_M_f_wr_resp$FULL_N;

  // rule scheduling signals
  wire CAN_FIRE_RL_ifc_rl_rd_addr,
       CAN_FIRE_RL_ifc_rl_rd_data,
       CAN_FIRE_RL_ifc_rl_wr_addr_data,
       CAN_FIRE_RL_ifc_rl_wr_resp,
       CAN_FIRE_ifc_AXI4L_S_m_arvalid,
       CAN_FIRE_ifc_AXI4L_S_m_awvalid,
       CAN_FIRE_ifc_AXI4L_S_m_bready,
       CAN_FIRE_ifc_AXI4L_S_m_rready,
       CAN_FIRE_ifc_AXI4L_S_m_wvalid,
       CAN_FIRE_ifc_AXI4_M_m_arready,
       CAN_FIRE_ifc_AXI4_M_m_awready,
       CAN_FIRE_ifc_AXI4_M_m_bvalid,
       CAN_FIRE_ifc_AXI4_M_m_rvalid,
       CAN_FIRE_ifc_AXI4_M_m_wready,
       WILL_FIRE_RL_ifc_rl_rd_addr,
       WILL_FIRE_RL_ifc_rl_rd_data,
       WILL_FIRE_RL_ifc_rl_wr_addr_data,
       WILL_FIRE_RL_ifc_rl_wr_resp,
       WILL_FIRE_ifc_AXI4L_S_m_arvalid,
       WILL_FIRE_ifc_AXI4L_S_m_awvalid,
       WILL_FIRE_ifc_AXI4L_S_m_bready,
       WILL_FIRE_ifc_AXI4L_S_m_rready,
       WILL_FIRE_ifc_AXI4L_S_m_wvalid,
       WILL_FIRE_ifc_AXI4_M_m_arready,
       WILL_FIRE_ifc_AXI4_M_m_awready,
       WILL_FIRE_ifc_AXI4_M_m_bvalid,
       WILL_FIRE_ifc_AXI4_M_m_rvalid,
       WILL_FIRE_ifc_AXI4_M_m_wready;

  // remaining internal signals
  reg [31 : 0] CASE_ifc_f_rd_addrsD_OUT_BITS_5_TO_2_0_ifc_xa_ETC__q1;
  wire [511 : 0] wdata_AXI4_wdata__h1258;
  wire [63 : 0] addr_AXI4__h1149, addr_AXI4__h5531, wdata_AXI4_wstrb__h1259;

  // action method ifc_AXI4L_S_m_awvalid
  assign CAN_FIRE_ifc_AXI4L_S_m_awvalid = 1'd1 ;
  assign WILL_FIRE_ifc_AXI4L_S_m_awvalid = 1'd1 ;

  // value method ifc_AXI4L_S_m_awready
  assign ifc_AXI4L_S_awready = ifc_xactor_AXI4L_S_f_wr_addr$FULL_N ;

  // action method ifc_AXI4L_S_m_wvalid
  assign CAN_FIRE_ifc_AXI4L_S_m_wvalid = 1'd1 ;
  assign WILL_FIRE_ifc_AXI4L_S_m_wvalid = 1'd1 ;

  // value method ifc_AXI4L_S_m_wready
  assign ifc_AXI4L_S_wready = ifc_xactor_AXI4L_S_f_wr_data$FULL_N ;

  // value method ifc_AXI4L_S_m_bvalid
  assign ifc_AXI4L_S_bvalid = ifc_xactor_AXI4L_S_f_wr_resp$EMPTY_N ;

  // value method ifc_AXI4L_S_m_bresp
  assign ifc_AXI4L_S_bresp = ifc_xactor_AXI4L_S_f_wr_resp$D_OUT ;

  // action method ifc_AXI4L_S_m_bready
  assign CAN_FIRE_ifc_AXI4L_S_m_bready = 1'd1 ;
  assign WILL_FIRE_ifc_AXI4L_S_m_bready = 1'd1 ;

  // action method ifc_AXI4L_S_m_arvalid
  assign CAN_FIRE_ifc_AXI4L_S_m_arvalid = 1'd1 ;
  assign WILL_FIRE_ifc_AXI4L_S_m_arvalid = 1'd1 ;

  // value method ifc_AXI4L_S_m_arready
  assign ifc_AXI4L_S_arready = ifc_xactor_AXI4L_S_f_rd_addr$FULL_N ;

  // value method ifc_AXI4L_S_m_rvalid
  assign ifc_AXI4L_S_rvalid = ifc_xactor_AXI4L_S_f_rd_data$EMPTY_N ;

  // value method ifc_AXI4L_S_m_rresp
  assign ifc_AXI4L_S_rresp = ifc_xactor_AXI4L_S_f_rd_data$D_OUT[33:32] ;

  // value method ifc_AXI4L_S_m_rdata
  assign ifc_AXI4L_S_rdata = ifc_xactor_AXI4L_S_f_rd_data$D_OUT[31:0] ;

  // action method ifc_AXI4L_S_m_rready
  assign CAN_FIRE_ifc_AXI4L_S_m_rready = 1'd1 ;
  assign WILL_FIRE_ifc_AXI4L_S_m_rready = 1'd1 ;

  // value method ifc_AXI4_M_m_awvalid
  assign ifc_AXI4_M_awvalid = ifc_xactor_AXI4_M_f_wr_addr$EMPTY_N ;

  // value method ifc_AXI4_M_m_awid
  assign ifc_AXI4_M_awid = ifc_xactor_AXI4_M_f_wr_addr$D_OUT[108:93] ;

  // value method ifc_AXI4_M_m_awaddr
  assign ifc_AXI4_M_awaddr = ifc_xactor_AXI4_M_f_wr_addr$D_OUT[92:29] ;

  // value method ifc_AXI4_M_m_awlen
  assign ifc_AXI4_M_awlen = ifc_xactor_AXI4_M_f_wr_addr$D_OUT[28:21] ;

  // value method ifc_AXI4_M_m_awsize
  assign ifc_AXI4_M_awsize = ifc_xactor_AXI4_M_f_wr_addr$D_OUT[20:18] ;

  // value method ifc_AXI4_M_m_awburst
  assign ifc_AXI4_M_awburst = ifc_xactor_AXI4_M_f_wr_addr$D_OUT[17:16] ;

  // value method ifc_AXI4_M_m_awlock
  assign ifc_AXI4_M_awlock = ifc_xactor_AXI4_M_f_wr_addr$D_OUT[15] ;

  // value method ifc_AXI4_M_m_awcache
  assign ifc_AXI4_M_awcache = ifc_xactor_AXI4_M_f_wr_addr$D_OUT[14:11] ;

  // value method ifc_AXI4_M_m_awprot
  assign ifc_AXI4_M_awprot = ifc_xactor_AXI4_M_f_wr_addr$D_OUT[10:8] ;

  // value method ifc_AXI4_M_m_awqos
  assign ifc_AXI4_M_awqos = ifc_xactor_AXI4_M_f_wr_addr$D_OUT[7:4] ;

  // value method ifc_AXI4_M_m_awregion
  assign ifc_AXI4_M_awregion = ifc_xactor_AXI4_M_f_wr_addr$D_OUT[3:0] ;

  // action method ifc_AXI4_M_m_awready
  assign CAN_FIRE_ifc_AXI4_M_m_awready = 1'd1 ;
  assign WILL_FIRE_ifc_AXI4_M_m_awready = 1'd1 ;

  // value method ifc_AXI4_M_m_wvalid
  assign ifc_AXI4_M_wvalid = ifc_xactor_AXI4_M_f_wr_data$EMPTY_N ;

  // value method ifc_AXI4_M_m_wdata
  assign ifc_AXI4_M_wdata = ifc_xactor_AXI4_M_f_wr_data$D_OUT[576:65] ;

  // value method ifc_AXI4_M_m_wstrb
  assign ifc_AXI4_M_wstrb = ifc_xactor_AXI4_M_f_wr_data$D_OUT[64:1] ;

  // value method ifc_AXI4_M_m_wlast
  assign ifc_AXI4_M_wlast = ifc_xactor_AXI4_M_f_wr_data$D_OUT[0] ;

  // action method ifc_AXI4_M_m_wready
  assign CAN_FIRE_ifc_AXI4_M_m_wready = 1'd1 ;
  assign WILL_FIRE_ifc_AXI4_M_m_wready = 1'd1 ;

  // action method ifc_AXI4_M_m_bvalid
  assign CAN_FIRE_ifc_AXI4_M_m_bvalid = 1'd1 ;
  assign WILL_FIRE_ifc_AXI4_M_m_bvalid = 1'd1 ;

  // value method ifc_AXI4_M_m_bready
  assign ifc_AXI4_M_bready = ifc_xactor_AXI4_M_f_wr_resp$FULL_N ;

  // value method ifc_AXI4_M_m_arvalid
  assign ifc_AXI4_M_arvalid = ifc_xactor_AXI4_M_f_rd_addr$EMPTY_N ;

  // value method ifc_AXI4_M_m_arid
  assign ifc_AXI4_M_arid = ifc_xactor_AXI4_M_f_rd_addr$D_OUT[108:93] ;

  // value method ifc_AXI4_M_m_araddr
  assign ifc_AXI4_M_araddr = ifc_xactor_AXI4_M_f_rd_addr$D_OUT[92:29] ;

  // value method ifc_AXI4_M_m_arlen
  assign ifc_AXI4_M_arlen = ifc_xactor_AXI4_M_f_rd_addr$D_OUT[28:21] ;

  // value method ifc_AXI4_M_m_arsize
  assign ifc_AXI4_M_arsize = ifc_xactor_AXI4_M_f_rd_addr$D_OUT[20:18] ;

  // value method ifc_AXI4_M_m_arburst
  assign ifc_AXI4_M_arburst = ifc_xactor_AXI4_M_f_rd_addr$D_OUT[17:16] ;

  // value method ifc_AXI4_M_m_arlock
  assign ifc_AXI4_M_arlock = ifc_xactor_AXI4_M_f_rd_addr$D_OUT[15] ;

  // value method ifc_AXI4_M_m_arcache
  assign ifc_AXI4_M_arcache = ifc_xactor_AXI4_M_f_rd_addr$D_OUT[14:11] ;

  // value method ifc_AXI4_M_m_arprot
  assign ifc_AXI4_M_arprot = ifc_xactor_AXI4_M_f_rd_addr$D_OUT[10:8] ;

  // value method ifc_AXI4_M_m_arqos
  assign ifc_AXI4_M_arqos = ifc_xactor_AXI4_M_f_rd_addr$D_OUT[7:4] ;

  // value method ifc_AXI4_M_m_arregion
  assign ifc_AXI4_M_arregion = ifc_xactor_AXI4_M_f_rd_addr$D_OUT[3:0] ;

  // action method ifc_AXI4_M_m_arready
  assign CAN_FIRE_ifc_AXI4_M_m_arready = 1'd1 ;
  assign WILL_FIRE_ifc_AXI4_M_m_arready = 1'd1 ;

  // action method ifc_AXI4_M_m_rvalid
  assign CAN_FIRE_ifc_AXI4_M_m_rvalid = 1'd1 ;
  assign WILL_FIRE_ifc_AXI4_M_m_rvalid = 1'd1 ;

  // value method ifc_AXI4_M_m_rready
  assign ifc_AXI4_M_rready = ifc_xactor_AXI4_M_f_rd_data$FULL_N ;

  // submodule ifc_f_rd_addrs
  SizedFIFO #(.p1width(32'd32),
	      .p2depth(32'd32),
	      .p3cntr_width(32'd5),
	      .guarded(1'd1)) ifc_f_rd_addrs(.RST(RST_N),
					     .CLK(CLK),
					     .D_IN(ifc_f_rd_addrs$D_IN),
					     .ENQ(ifc_f_rd_addrs$ENQ),
					     .DEQ(ifc_f_rd_addrs$DEQ),
					     .CLR(ifc_f_rd_addrs$CLR),
					     .D_OUT(ifc_f_rd_addrs$D_OUT),
					     .FULL_N(ifc_f_rd_addrs$FULL_N),
					     .EMPTY_N(ifc_f_rd_addrs$EMPTY_N));

  // submodule ifc_xactor_AXI4L_S_f_rd_addr
  FIFO2 #(.width(32'd35),
	  .guarded(1'd1)) ifc_xactor_AXI4L_S_f_rd_addr(.RST(RST_N),
						       .CLK(CLK),
						       .D_IN(ifc_xactor_AXI4L_S_f_rd_addr$D_IN),
						       .ENQ(ifc_xactor_AXI4L_S_f_rd_addr$ENQ),
						       .DEQ(ifc_xactor_AXI4L_S_f_rd_addr$DEQ),
						       .CLR(ifc_xactor_AXI4L_S_f_rd_addr$CLR),
						       .D_OUT(ifc_xactor_AXI4L_S_f_rd_addr$D_OUT),
						       .FULL_N(ifc_xactor_AXI4L_S_f_rd_addr$FULL_N),
						       .EMPTY_N(ifc_xactor_AXI4L_S_f_rd_addr$EMPTY_N));

  // submodule ifc_xactor_AXI4L_S_f_rd_data
  FIFO2 #(.width(32'd34),
	  .guarded(1'd1)) ifc_xactor_AXI4L_S_f_rd_data(.RST(RST_N),
						       .CLK(CLK),
						       .D_IN(ifc_xactor_AXI4L_S_f_rd_data$D_IN),
						       .ENQ(ifc_xactor_AXI4L_S_f_rd_data$ENQ),
						       .DEQ(ifc_xactor_AXI4L_S_f_rd_data$DEQ),
						       .CLR(ifc_xactor_AXI4L_S_f_rd_data$CLR),
						       .D_OUT(ifc_xactor_AXI4L_S_f_rd_data$D_OUT),
						       .FULL_N(ifc_xactor_AXI4L_S_f_rd_data$FULL_N),
						       .EMPTY_N(ifc_xactor_AXI4L_S_f_rd_data$EMPTY_N));

  // submodule ifc_xactor_AXI4L_S_f_wr_addr
  FIFO2 #(.width(32'd35),
	  .guarded(1'd1)) ifc_xactor_AXI4L_S_f_wr_addr(.RST(RST_N),
						       .CLK(CLK),
						       .D_IN(ifc_xactor_AXI4L_S_f_wr_addr$D_IN),
						       .ENQ(ifc_xactor_AXI4L_S_f_wr_addr$ENQ),
						       .DEQ(ifc_xactor_AXI4L_S_f_wr_addr$DEQ),
						       .CLR(ifc_xactor_AXI4L_S_f_wr_addr$CLR),
						       .D_OUT(ifc_xactor_AXI4L_S_f_wr_addr$D_OUT),
						       .FULL_N(ifc_xactor_AXI4L_S_f_wr_addr$FULL_N),
						       .EMPTY_N(ifc_xactor_AXI4L_S_f_wr_addr$EMPTY_N));

  // submodule ifc_xactor_AXI4L_S_f_wr_data
  FIFO2 #(.width(32'd36),
	  .guarded(1'd1)) ifc_xactor_AXI4L_S_f_wr_data(.RST(RST_N),
						       .CLK(CLK),
						       .D_IN(ifc_xactor_AXI4L_S_f_wr_data$D_IN),
						       .ENQ(ifc_xactor_AXI4L_S_f_wr_data$ENQ),
						       .DEQ(ifc_xactor_AXI4L_S_f_wr_data$DEQ),
						       .CLR(ifc_xactor_AXI4L_S_f_wr_data$CLR),
						       .D_OUT(ifc_xactor_AXI4L_S_f_wr_data$D_OUT),
						       .FULL_N(ifc_xactor_AXI4L_S_f_wr_data$FULL_N),
						       .EMPTY_N(ifc_xactor_AXI4L_S_f_wr_data$EMPTY_N));

  // submodule ifc_xactor_AXI4L_S_f_wr_resp
  FIFO2 #(.width(32'd2),
	  .guarded(1'd1)) ifc_xactor_AXI4L_S_f_wr_resp(.RST(RST_N),
						       .CLK(CLK),
						       .D_IN(ifc_xactor_AXI4L_S_f_wr_resp$D_IN),
						       .ENQ(ifc_xactor_AXI4L_S_f_wr_resp$ENQ),
						       .DEQ(ifc_xactor_AXI4L_S_f_wr_resp$DEQ),
						       .CLR(ifc_xactor_AXI4L_S_f_wr_resp$CLR),
						       .D_OUT(ifc_xactor_AXI4L_S_f_wr_resp$D_OUT),
						       .FULL_N(ifc_xactor_AXI4L_S_f_wr_resp$FULL_N),
						       .EMPTY_N(ifc_xactor_AXI4L_S_f_wr_resp$EMPTY_N));

  // submodule ifc_xactor_AXI4_M_f_rd_addr
  FIFO2 #(.width(32'd109),
	  .guarded(1'd1)) ifc_xactor_AXI4_M_f_rd_addr(.RST(RST_N),
						      .CLK(CLK),
						      .D_IN(ifc_xactor_AXI4_M_f_rd_addr$D_IN),
						      .ENQ(ifc_xactor_AXI4_M_f_rd_addr$ENQ),
						      .DEQ(ifc_xactor_AXI4_M_f_rd_addr$DEQ),
						      .CLR(ifc_xactor_AXI4_M_f_rd_addr$CLR),
						      .D_OUT(ifc_xactor_AXI4_M_f_rd_addr$D_OUT),
						      .FULL_N(ifc_xactor_AXI4_M_f_rd_addr$FULL_N),
						      .EMPTY_N(ifc_xactor_AXI4_M_f_rd_addr$EMPTY_N));

  // submodule ifc_xactor_AXI4_M_f_rd_data
  FIFO2 #(.width(32'd531),
	  .guarded(1'd1)) ifc_xactor_AXI4_M_f_rd_data(.RST(RST_N),
						      .CLK(CLK),
						      .D_IN(ifc_xactor_AXI4_M_f_rd_data$D_IN),
						      .ENQ(ifc_xactor_AXI4_M_f_rd_data$ENQ),
						      .DEQ(ifc_xactor_AXI4_M_f_rd_data$DEQ),
						      .CLR(ifc_xactor_AXI4_M_f_rd_data$CLR),
						      .D_OUT(ifc_xactor_AXI4_M_f_rd_data$D_OUT),
						      .FULL_N(ifc_xactor_AXI4_M_f_rd_data$FULL_N),
						      .EMPTY_N(ifc_xactor_AXI4_M_f_rd_data$EMPTY_N));

  // submodule ifc_xactor_AXI4_M_f_wr_addr
  FIFO2 #(.width(32'd109),
	  .guarded(1'd1)) ifc_xactor_AXI4_M_f_wr_addr(.RST(RST_N),
						      .CLK(CLK),
						      .D_IN(ifc_xactor_AXI4_M_f_wr_addr$D_IN),
						      .ENQ(ifc_xactor_AXI4_M_f_wr_addr$ENQ),
						      .DEQ(ifc_xactor_AXI4_M_f_wr_addr$DEQ),
						      .CLR(ifc_xactor_AXI4_M_f_wr_addr$CLR),
						      .D_OUT(ifc_xactor_AXI4_M_f_wr_addr$D_OUT),
						      .FULL_N(ifc_xactor_AXI4_M_f_wr_addr$FULL_N),
						      .EMPTY_N(ifc_xactor_AXI4_M_f_wr_addr$EMPTY_N));

  // submodule ifc_xactor_AXI4_M_f_wr_data
  FIFO2 #(.width(32'd577),
	  .guarded(1'd1)) ifc_xactor_AXI4_M_f_wr_data(.RST(RST_N),
						      .CLK(CLK),
						      .D_IN(ifc_xactor_AXI4_M_f_wr_data$D_IN),
						      .ENQ(ifc_xactor_AXI4_M_f_wr_data$ENQ),
						      .DEQ(ifc_xactor_AXI4_M_f_wr_data$DEQ),
						      .CLR(ifc_xactor_AXI4_M_f_wr_data$CLR),
						      .D_OUT(ifc_xactor_AXI4_M_f_wr_data$D_OUT),
						      .FULL_N(ifc_xactor_AXI4_M_f_wr_data$FULL_N),
						      .EMPTY_N(ifc_xactor_AXI4_M_f_wr_data$EMPTY_N));

  // submodule ifc_xactor_AXI4_M_f_wr_resp
  FIFO2 #(.width(32'd18),
	  .guarded(1'd1)) ifc_xactor_AXI4_M_f_wr_resp(.RST(RST_N),
						      .CLK(CLK),
						      .D_IN(ifc_xactor_AXI4_M_f_wr_resp$D_IN),
						      .ENQ(ifc_xactor_AXI4_M_f_wr_resp$ENQ),
						      .DEQ(ifc_xactor_AXI4_M_f_wr_resp$DEQ),
						      .CLR(ifc_xactor_AXI4_M_f_wr_resp$CLR),
						      .D_OUT(ifc_xactor_AXI4_M_f_wr_resp$D_OUT),
						      .FULL_N(ifc_xactor_AXI4_M_f_wr_resp$FULL_N),
						      .EMPTY_N(ifc_xactor_AXI4_M_f_wr_resp$EMPTY_N));

  // rule RL_ifc_rl_wr_addr_data
  assign CAN_FIRE_RL_ifc_rl_wr_addr_data =
	     ifc_xactor_AXI4L_S_f_wr_addr$EMPTY_N &&
	     ifc_xactor_AXI4L_S_f_wr_data$EMPTY_N &&
	     ifc_xactor_AXI4_M_f_wr_addr$FULL_N &&
	     ifc_xactor_AXI4_M_f_wr_data$FULL_N ;
  assign WILL_FIRE_RL_ifc_rl_wr_addr_data = CAN_FIRE_RL_ifc_rl_wr_addr_data ;

  // rule RL_ifc_rl_wr_resp
  assign CAN_FIRE_RL_ifc_rl_wr_resp =
	     ifc_xactor_AXI4_M_f_wr_resp$EMPTY_N &&
	     ifc_xactor_AXI4L_S_f_wr_resp$FULL_N ;
  assign WILL_FIRE_RL_ifc_rl_wr_resp = CAN_FIRE_RL_ifc_rl_wr_resp ;

  // rule RL_ifc_rl_rd_addr
  assign CAN_FIRE_RL_ifc_rl_rd_addr =
	     ifc_xactor_AXI4L_S_f_rd_addr$EMPTY_N &&
	     ifc_xactor_AXI4_M_f_rd_addr$FULL_N &&
	     ifc_f_rd_addrs$FULL_N ;
  assign WILL_FIRE_RL_ifc_rl_rd_addr = CAN_FIRE_RL_ifc_rl_rd_addr ;

  // rule RL_ifc_rl_rd_data
  assign CAN_FIRE_RL_ifc_rl_rd_data =
	     ifc_xactor_AXI4_M_f_rd_data$EMPTY_N && ifc_f_rd_addrs$EMPTY_N &&
	     ifc_xactor_AXI4L_S_f_rd_data$FULL_N ;
  assign WILL_FIRE_RL_ifc_rl_rd_data = CAN_FIRE_RL_ifc_rl_rd_data ;

  // submodule ifc_f_rd_addrs
  assign ifc_f_rd_addrs$D_IN = ifc_xactor_AXI4L_S_f_rd_addr$D_OUT[34:3] ;
  assign ifc_f_rd_addrs$ENQ = CAN_FIRE_RL_ifc_rl_rd_addr ;
  assign ifc_f_rd_addrs$DEQ = CAN_FIRE_RL_ifc_rl_rd_data ;
  assign ifc_f_rd_addrs$CLR = 1'b0 ;

  // submodule ifc_xactor_AXI4L_S_f_rd_addr
  assign ifc_xactor_AXI4L_S_f_rd_addr$D_IN =
	     { ifc_AXI4L_S_araddr, ifc_AXI4L_S_arprot } ;
  assign ifc_xactor_AXI4L_S_f_rd_addr$ENQ =
	     ifc_AXI4L_S_arvalid && ifc_xactor_AXI4L_S_f_rd_addr$FULL_N ;
  assign ifc_xactor_AXI4L_S_f_rd_addr$DEQ = CAN_FIRE_RL_ifc_rl_rd_addr ;
  assign ifc_xactor_AXI4L_S_f_rd_addr$CLR = 1'b0 ;

  // submodule ifc_xactor_AXI4L_S_f_rd_data
  assign ifc_xactor_AXI4L_S_f_rd_data$D_IN =
	     { ifc_xactor_AXI4_M_f_rd_data$D_OUT[2:1],
	       CASE_ifc_f_rd_addrsD_OUT_BITS_5_TO_2_0_ifc_xa_ETC__q1 } ;
  assign ifc_xactor_AXI4L_S_f_rd_data$ENQ = CAN_FIRE_RL_ifc_rl_rd_data ;
  assign ifc_xactor_AXI4L_S_f_rd_data$DEQ =
	     ifc_AXI4L_S_rready && ifc_xactor_AXI4L_S_f_rd_data$EMPTY_N ;
  assign ifc_xactor_AXI4L_S_f_rd_data$CLR = 1'b0 ;

  // submodule ifc_xactor_AXI4L_S_f_wr_addr
  assign ifc_xactor_AXI4L_S_f_wr_addr$D_IN =
	     { ifc_AXI4L_S_awaddr, ifc_AXI4L_S_awprot } ;
  assign ifc_xactor_AXI4L_S_f_wr_addr$ENQ =
	     ifc_AXI4L_S_awvalid && ifc_xactor_AXI4L_S_f_wr_addr$FULL_N ;
  assign ifc_xactor_AXI4L_S_f_wr_addr$DEQ = CAN_FIRE_RL_ifc_rl_wr_addr_data ;
  assign ifc_xactor_AXI4L_S_f_wr_addr$CLR = 1'b0 ;

  // submodule ifc_xactor_AXI4L_S_f_wr_data
  assign ifc_xactor_AXI4L_S_f_wr_data$D_IN =
	     { ifc_AXI4L_S_wdata, ifc_AXI4L_S_wstrb } ;
  assign ifc_xactor_AXI4L_S_f_wr_data$ENQ =
	     ifc_AXI4L_S_wvalid && ifc_xactor_AXI4L_S_f_wr_data$FULL_N ;
  assign ifc_xactor_AXI4L_S_f_wr_data$DEQ = CAN_FIRE_RL_ifc_rl_wr_addr_data ;
  assign ifc_xactor_AXI4L_S_f_wr_data$CLR = 1'b0 ;

  // submodule ifc_xactor_AXI4L_S_f_wr_resp
  assign ifc_xactor_AXI4L_S_f_wr_resp$D_IN =
	     ifc_xactor_AXI4_M_f_wr_resp$D_OUT[1:0] ;
  assign ifc_xactor_AXI4L_S_f_wr_resp$ENQ = CAN_FIRE_RL_ifc_rl_wr_resp ;
  assign ifc_xactor_AXI4L_S_f_wr_resp$DEQ =
	     ifc_AXI4L_S_bready && ifc_xactor_AXI4L_S_f_wr_resp$EMPTY_N ;
  assign ifc_xactor_AXI4L_S_f_wr_resp$CLR = 1'b0 ;

  // submodule ifc_xactor_AXI4_M_f_rd_addr
  assign ifc_xactor_AXI4_M_f_rd_addr$D_IN =
	     { 16'd1,
	       addr_AXI4__h5531,
	       18'd256,
	       ifc_xactor_AXI4L_S_f_rd_addr$D_OUT[2:0],
	       8'd0 } ;
  assign ifc_xactor_AXI4_M_f_rd_addr$ENQ = CAN_FIRE_RL_ifc_rl_rd_addr ;
  assign ifc_xactor_AXI4_M_f_rd_addr$DEQ =
	     ifc_xactor_AXI4_M_f_rd_addr$EMPTY_N && ifc_AXI4_M_arready ;
  assign ifc_xactor_AXI4_M_f_rd_addr$CLR = 1'b0 ;

  // submodule ifc_xactor_AXI4_M_f_rd_data
  assign ifc_xactor_AXI4_M_f_rd_data$D_IN =
	     { ifc_AXI4_M_rid,
	       ifc_AXI4_M_rdata,
	       ifc_AXI4_M_rresp,
	       ifc_AXI4_M_rlast } ;
  assign ifc_xactor_AXI4_M_f_rd_data$ENQ =
	     ifc_AXI4_M_rvalid && ifc_xactor_AXI4_M_f_rd_data$FULL_N ;
  assign ifc_xactor_AXI4_M_f_rd_data$DEQ = CAN_FIRE_RL_ifc_rl_rd_data ;
  assign ifc_xactor_AXI4_M_f_rd_data$CLR = 1'b0 ;

  // submodule ifc_xactor_AXI4_M_f_wr_addr
  assign ifc_xactor_AXI4_M_f_wr_addr$D_IN =
	     { 16'd1,
	       addr_AXI4__h1149,
	       18'd256,
	       ifc_xactor_AXI4L_S_f_wr_addr$D_OUT[2:0],
	       8'd0 } ;
  assign ifc_xactor_AXI4_M_f_wr_addr$ENQ = CAN_FIRE_RL_ifc_rl_wr_addr_data ;
  assign ifc_xactor_AXI4_M_f_wr_addr$DEQ =
	     ifc_xactor_AXI4_M_f_wr_addr$EMPTY_N && ifc_AXI4_M_awready ;
  assign ifc_xactor_AXI4_M_f_wr_addr$CLR = 1'b0 ;

  // submodule ifc_xactor_AXI4_M_f_wr_data
  assign ifc_xactor_AXI4_M_f_wr_data$D_IN =
	     { wdata_AXI4_wdata__h1258, wdata_AXI4_wstrb__h1259, 1'd1 } ;
  assign ifc_xactor_AXI4_M_f_wr_data$ENQ = CAN_FIRE_RL_ifc_rl_wr_addr_data ;
  assign ifc_xactor_AXI4_M_f_wr_data$DEQ =
	     ifc_xactor_AXI4_M_f_wr_data$EMPTY_N && ifc_AXI4_M_wready ;
  assign ifc_xactor_AXI4_M_f_wr_data$CLR = 1'b0 ;

  // submodule ifc_xactor_AXI4_M_f_wr_resp
  assign ifc_xactor_AXI4_M_f_wr_resp$D_IN =
	     { ifc_AXI4_M_bid, ifc_AXI4_M_bresp } ;
  assign ifc_xactor_AXI4_M_f_wr_resp$ENQ =
	     ifc_AXI4_M_bvalid && ifc_xactor_AXI4_M_f_wr_resp$FULL_N ;
  assign ifc_xactor_AXI4_M_f_wr_resp$DEQ = CAN_FIRE_RL_ifc_rl_wr_resp ;
  assign ifc_xactor_AXI4_M_f_wr_resp$CLR = 1'b0 ;

  // remaining internal signals
  assign addr_AXI4__h1149 =
	     { 32'd0, ifc_xactor_AXI4L_S_f_wr_addr$D_OUT[34:3] } ;
  assign addr_AXI4__h5531 =
	     { 32'd0, ifc_xactor_AXI4L_S_f_rd_addr$D_OUT[34:3] } ;
  assign wdata_AXI4_wdata__h1258 =
	     { (ifc_xactor_AXI4L_S_f_wr_addr$D_OUT[8:5] == 4'd15) ?
		 ifc_xactor_AXI4L_S_f_wr_data$D_OUT[35:4] :
		 32'd0,
	       (ifc_xactor_AXI4L_S_f_wr_addr$D_OUT[8:5] == 4'd14) ?
		 ifc_xactor_AXI4L_S_f_wr_data$D_OUT[35:4] :
		 32'd0,
	       (ifc_xactor_AXI4L_S_f_wr_addr$D_OUT[8:5] == 4'd13) ?
		 ifc_xactor_AXI4L_S_f_wr_data$D_OUT[35:4] :
		 32'd0,
	       (ifc_xactor_AXI4L_S_f_wr_addr$D_OUT[8:5] == 4'd12) ?
		 ifc_xactor_AXI4L_S_f_wr_data$D_OUT[35:4] :
		 32'd0,
	       (ifc_xactor_AXI4L_S_f_wr_addr$D_OUT[8:5] == 4'd11) ?
		 ifc_xactor_AXI4L_S_f_wr_data$D_OUT[35:4] :
		 32'd0,
	       (ifc_xactor_AXI4L_S_f_wr_addr$D_OUT[8:5] == 4'd10) ?
		 ifc_xactor_AXI4L_S_f_wr_data$D_OUT[35:4] :
		 32'd0,
	       (ifc_xactor_AXI4L_S_f_wr_addr$D_OUT[8:5] == 4'd9) ?
		 ifc_xactor_AXI4L_S_f_wr_data$D_OUT[35:4] :
		 32'd0,
	       (ifc_xactor_AXI4L_S_f_wr_addr$D_OUT[8:5] == 4'd8) ?
		 ifc_xactor_AXI4L_S_f_wr_data$D_OUT[35:4] :
		 32'd0,
	       (ifc_xactor_AXI4L_S_f_wr_addr$D_OUT[8:5] == 4'd7) ?
		 ifc_xactor_AXI4L_S_f_wr_data$D_OUT[35:4] :
		 32'd0,
	       (ifc_xactor_AXI4L_S_f_wr_addr$D_OUT[8:5] == 4'd6) ?
		 ifc_xactor_AXI4L_S_f_wr_data$D_OUT[35:4] :
		 32'd0,
	       (ifc_xactor_AXI4L_S_f_wr_addr$D_OUT[8:5] == 4'd5) ?
		 ifc_xactor_AXI4L_S_f_wr_data$D_OUT[35:4] :
		 32'd0,
	       (ifc_xactor_AXI4L_S_f_wr_addr$D_OUT[8:5] == 4'd4) ?
		 ifc_xactor_AXI4L_S_f_wr_data$D_OUT[35:4] :
		 32'd0,
	       (ifc_xactor_AXI4L_S_f_wr_addr$D_OUT[8:5] == 4'd3) ?
		 ifc_xactor_AXI4L_S_f_wr_data$D_OUT[35:4] :
		 32'd0,
	       (ifc_xactor_AXI4L_S_f_wr_addr$D_OUT[8:5] == 4'd2) ?
		 ifc_xactor_AXI4L_S_f_wr_data$D_OUT[35:4] :
		 32'd0,
	       (ifc_xactor_AXI4L_S_f_wr_addr$D_OUT[8:5] == 4'd1) ?
		 ifc_xactor_AXI4L_S_f_wr_data$D_OUT[35:4] :
		 32'd0,
	       (ifc_xactor_AXI4L_S_f_wr_addr$D_OUT[8:5] == 4'd0) ?
		 ifc_xactor_AXI4L_S_f_wr_data$D_OUT[35:4] :
		 32'd0 } ;
  assign wdata_AXI4_wstrb__h1259 =
	     { (ifc_xactor_AXI4L_S_f_wr_addr$D_OUT[8:5] == 4'd15) ?
		 ifc_xactor_AXI4L_S_f_wr_data$D_OUT[3:0] :
		 4'd0,
	       (ifc_xactor_AXI4L_S_f_wr_addr$D_OUT[8:5] == 4'd14) ?
		 ifc_xactor_AXI4L_S_f_wr_data$D_OUT[3:0] :
		 4'd0,
	       (ifc_xactor_AXI4L_S_f_wr_addr$D_OUT[8:5] == 4'd13) ?
		 ifc_xactor_AXI4L_S_f_wr_data$D_OUT[3:0] :
		 4'd0,
	       (ifc_xactor_AXI4L_S_f_wr_addr$D_OUT[8:5] == 4'd12) ?
		 ifc_xactor_AXI4L_S_f_wr_data$D_OUT[3:0] :
		 4'd0,
	       (ifc_xactor_AXI4L_S_f_wr_addr$D_OUT[8:5] == 4'd11) ?
		 ifc_xactor_AXI4L_S_f_wr_data$D_OUT[3:0] :
		 4'd0,
	       (ifc_xactor_AXI4L_S_f_wr_addr$D_OUT[8:5] == 4'd10) ?
		 ifc_xactor_AXI4L_S_f_wr_data$D_OUT[3:0] :
		 4'd0,
	       (ifc_xactor_AXI4L_S_f_wr_addr$D_OUT[8:5] == 4'd9) ?
		 ifc_xactor_AXI4L_S_f_wr_data$D_OUT[3:0] :
		 4'd0,
	       (ifc_xactor_AXI4L_S_f_wr_addr$D_OUT[8:5] == 4'd8) ?
		 ifc_xactor_AXI4L_S_f_wr_data$D_OUT[3:0] :
		 4'd0,
	       (ifc_xactor_AXI4L_S_f_wr_addr$D_OUT[8:5] == 4'd7) ?
		 ifc_xactor_AXI4L_S_f_wr_data$D_OUT[3:0] :
		 4'd0,
	       (ifc_xactor_AXI4L_S_f_wr_addr$D_OUT[8:5] == 4'd6) ?
		 ifc_xactor_AXI4L_S_f_wr_data$D_OUT[3:0] :
		 4'd0,
	       (ifc_xactor_AXI4L_S_f_wr_addr$D_OUT[8:5] == 4'd5) ?
		 ifc_xactor_AXI4L_S_f_wr_data$D_OUT[3:0] :
		 4'd0,
	       (ifc_xactor_AXI4L_S_f_wr_addr$D_OUT[8:5] == 4'd4) ?
		 ifc_xactor_AXI4L_S_f_wr_data$D_OUT[3:0] :
		 4'd0,
	       (ifc_xactor_AXI4L_S_f_wr_addr$D_OUT[8:5] == 4'd3) ?
		 ifc_xactor_AXI4L_S_f_wr_data$D_OUT[3:0] :
		 4'd0,
	       (ifc_xactor_AXI4L_S_f_wr_addr$D_OUT[8:5] == 4'd2) ?
		 ifc_xactor_AXI4L_S_f_wr_data$D_OUT[3:0] :
		 4'd0,
	       (ifc_xactor_AXI4L_S_f_wr_addr$D_OUT[8:5] == 4'd1) ?
		 ifc_xactor_AXI4L_S_f_wr_data$D_OUT[3:0] :
		 4'd0,
	       (ifc_xactor_AXI4L_S_f_wr_addr$D_OUT[8:5] == 4'd0) ?
		 ifc_xactor_AXI4L_S_f_wr_data$D_OUT[3:0] :
		 4'd0 } ;
  always@(ifc_f_rd_addrs$D_OUT or ifc_xactor_AXI4_M_f_rd_data$D_OUT)
  begin
    case (ifc_f_rd_addrs$D_OUT[5:2])
      4'd0:
	  CASE_ifc_f_rd_addrsD_OUT_BITS_5_TO_2_0_ifc_xa_ETC__q1 =
	      ifc_xactor_AXI4_M_f_rd_data$D_OUT[34:3];
      4'd1:
	  CASE_ifc_f_rd_addrsD_OUT_BITS_5_TO_2_0_ifc_xa_ETC__q1 =
	      ifc_xactor_AXI4_M_f_rd_data$D_OUT[66:35];
      4'd2:
	  CASE_ifc_f_rd_addrsD_OUT_BITS_5_TO_2_0_ifc_xa_ETC__q1 =
	      ifc_xactor_AXI4_M_f_rd_data$D_OUT[98:67];
      4'd3:
	  CASE_ifc_f_rd_addrsD_OUT_BITS_5_TO_2_0_ifc_xa_ETC__q1 =
	      ifc_xactor_AXI4_M_f_rd_data$D_OUT[130:99];
      4'd4:
	  CASE_ifc_f_rd_addrsD_OUT_BITS_5_TO_2_0_ifc_xa_ETC__q1 =
	      ifc_xactor_AXI4_M_f_rd_data$D_OUT[162:131];
      4'd5:
	  CASE_ifc_f_rd_addrsD_OUT_BITS_5_TO_2_0_ifc_xa_ETC__q1 =
	      ifc_xactor_AXI4_M_f_rd_data$D_OUT[194:163];
      4'd6:
	  CASE_ifc_f_rd_addrsD_OUT_BITS_5_TO_2_0_ifc_xa_ETC__q1 =
	      ifc_xactor_AXI4_M_f_rd_data$D_OUT[226:195];
      4'd7:
	  CASE_ifc_f_rd_addrsD_OUT_BITS_5_TO_2_0_ifc_xa_ETC__q1 =
	      ifc_xactor_AXI4_M_f_rd_data$D_OUT[258:227];
      4'd8:
	  CASE_ifc_f_rd_addrsD_OUT_BITS_5_TO_2_0_ifc_xa_ETC__q1 =
	      ifc_xactor_AXI4_M_f_rd_data$D_OUT[290:259];
      4'd9:
	  CASE_ifc_f_rd_addrsD_OUT_BITS_5_TO_2_0_ifc_xa_ETC__q1 =
	      ifc_xactor_AXI4_M_f_rd_data$D_OUT[322:291];
      4'd10:
	  CASE_ifc_f_rd_addrsD_OUT_BITS_5_TO_2_0_ifc_xa_ETC__q1 =
	      ifc_xactor_AXI4_M_f_rd_data$D_OUT[354:323];
      4'd11:
	  CASE_ifc_f_rd_addrsD_OUT_BITS_5_TO_2_0_ifc_xa_ETC__q1 =
	      ifc_xactor_AXI4_M_f_rd_data$D_OUT[386:355];
      4'd12:
	  CASE_ifc_f_rd_addrsD_OUT_BITS_5_TO_2_0_ifc_xa_ETC__q1 =
	      ifc_xactor_AXI4_M_f_rd_data$D_OUT[418:387];
      4'd13:
	  CASE_ifc_f_rd_addrsD_OUT_BITS_5_TO_2_0_ifc_xa_ETC__q1 =
	      ifc_xactor_AXI4_M_f_rd_data$D_OUT[450:419];
      4'd14:
	  CASE_ifc_f_rd_addrsD_OUT_BITS_5_TO_2_0_ifc_xa_ETC__q1 =
	      ifc_xactor_AXI4_M_f_rd_data$D_OUT[482:451];
      4'd15:
	  CASE_ifc_f_rd_addrsD_OUT_BITS_5_TO_2_0_ifc_xa_ETC__q1 =
	      ifc_xactor_AXI4_M_f_rd_data$D_OUT[514:483];
    endcase
  end
endmodule  // mkAXI4L_S_to_AXI4_M_Adapter_synth

