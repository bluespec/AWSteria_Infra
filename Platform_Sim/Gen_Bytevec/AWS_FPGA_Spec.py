# This is a spec for host-BSV communication in the AWS FPGA environment.
# We use two buses:
#    DMA_PCIS  AXI4       i16_a64_d512_u0 bus  host master  FPGA slave
#    OCL       AXI4-Lite  a32_d32_u0 bus       host master  FPGA slave

# ================================================================
# These are generic spec constructors for AXI4 channels
# Apply them to specific width parameters to get actual channel specs

def mkAXI4_Wr_Addr_spec (wd_id, wd_addr, wd_user):
    struct_name = ("AXI4_Wr_Addr_i{:d}_a{:d}_u{:d}".format (wd_id, wd_addr, wd_user))
    return {'struct_name': struct_name,
            'fields'     : [ {'field_name': "awid",     'width_bits': wd_id},
                             {'field_name': "awaddr",   'width_bits': wd_addr},
                             {'field_name': "awlen",    'width_bits': 8},
                             {'field_name': "awsize",   'width_bits': 3},
                             {'field_name': "awburst",  'width_bits': 2},
                             {'field_name': "awlock",   'width_bits': 1},
                             {'field_name': "awcache",  'width_bits': 4},
                             {'field_name': "awprot",   'width_bits': 3},
                             {'field_name': "awqos",    'width_bits': 4},
                             {'field_name': "awregion", 'width_bits': 4},
                             {'field_name': "awuser",   'width_bits': wd_user} ]}

def mkAXI4_Wr_Data_spec (wd_data, wd_user):
    struct_name = ("AXI4_Wr_Data_d{:d}_u{:d}".format (wd_data, wd_user))
    return {'struct_name': struct_name,
            'fields'     : [ {'field_name': "wdata", 'width_bits': wd_data},
                             {'field_name': "wstrb", 'width_bits': wd_data // 8},    # WARNING: assuming wd_data is a multiple of 8
                             {'field_name': "wlast", 'width_bits': 1},
                             {'field_name': "wuser", 'width_bits': wd_user} ]}

def mkAXI4_Rd_Addr_spec (wd_id, wd_addr, wd_user):
    struct_name = ("AXI4_Rd_Addr_i{:d}_a{:d}_u{:d}".format (wd_id, wd_addr, wd_user))
    return {'struct_name': struct_name,
            'fields'     : [ {'field_name': "arid",     'width_bits': wd_id},
                             {'field_name': "araddr",   'width_bits': wd_addr},
                             {'field_name': "arlen",    'width_bits': 8},
                             {'field_name': "arsize",   'width_bits': 3},
                             {'field_name': "arburst",  'width_bits': 2},
                             {'field_name': "arlock",   'width_bits': 1},
                             {'field_name': "arcache",  'width_bits': 4},
                             {'field_name': "arprot",   'width_bits': 3},
                             {'field_name': "arqos",    'width_bits': 4},
                             {'field_name': "arregion", 'width_bits': 4},
                             {'field_name': "aruser",   'width_bits': wd_user} ]}

def mkAXI4_Wr_Resp_spec (wd_id, wd_user):
    struct_name = ("AXI4_Wr_Resp_i{:d}_u{:d}".format (wd_id, wd_user))
    return {'struct_name': struct_name,
            'fields'     : [ {'field_name': "bid", 'width_bits': wd_id},
                             {'field_name': "bresp", 'width_bits': 2},
                             {'field_name': "buser", 'width_bits': wd_user} ]}

def mkAXI4_Rd_Data_spec (wd_id, wd_data, wd_user):
    struct_name = ("AXI4_Rd_Data_i{:d}_d{:d}_u{:d}".format (wd_id, wd_data, wd_user))
    return {'struct_name': struct_name,
            'fields'     : [ {'field_name': "rid",   'width_bits': wd_id},
                             {'field_name': "rdata", 'width_bits': wd_data},
                             {'field_name': "rresp", 'width_bits': 2},
                             {'field_name': "rlast", 'width_bits': 1},
                             {'field_name': "ruser", 'width_bits': wd_user} ]}

# ================================================================
# These are generic spec constructors for AXI4 channels
# Apply them to specific width parameters to get actual channel specs

def mkAXI4L_Wr_Addr_spec (wd_addr, wd_user):
    struct_name = ("AXI4L_Wr_Addr_a{:d}_u{:d}".format (wd_addr, wd_user))
    return {'struct_name': struct_name,
            'fields'     : [ {'field_name': "awaddr",   'width_bits': wd_addr},
                             {'field_name': "awprot",   'width_bits': 3},
                             {'field_name': "awuser",   'width_bits': wd_user} ]}

def mkAXI4L_Wr_Data_spec (wd_data):
    struct_name = ("AXI4L_Wr_Data_d{:d}".format (wd_data))
    return {'struct_name': struct_name,
            'fields'     : [ {'field_name': "wdata", 'width_bits': wd_data},
                             {'field_name': "wstrb", 'width_bits': wd_data // 8} ]}

def mkAXI4L_Rd_Addr_spec (wd_addr, wd_user):
    struct_name = ("AXI4L_Rd_Addr_a{:d}_u{:d}".format (wd_addr, wd_user))
    return {'struct_name': struct_name,
            'fields'     : [ {'field_name': "araddr",   'width_bits': wd_addr},
                             {'field_name': "arprot",   'width_bits': 3},
                             {'field_name': "aruser",   'width_bits': wd_user} ]}

def mkAXI4L_Wr_Resp_spec (wd_user):
    struct_name = ("AXI4L_Wr_Resp_u{:d}".format (wd_user))
    return {'struct_name': struct_name,
            'fields'     : [ {'field_name': "bresp", 'width_bits': 2},
                             {'field_name': "buser", 'width_bits': wd_user} ]}

def mkAXI4L_Rd_Data_spec (wd_data, wd_user):
    struct_name = ("AXI4L_Rd_Data_d{:d}_u{:d}".format (wd_data, wd_user))
    return {'struct_name': struct_name,
            'fields'     : [ {'field_name': "rdata", 'width_bits': wd_data},
                             {'field_name': "rresp", 'width_bits': 2},
                             {'field_name': "ruser", 'width_bits': wd_user} ]}

# ================================================================

def mk_C_to_BSV_AXI4_structs (wd_id, wd_addr, wd_data, wd_user):
    return [mkAXI4_Wr_Addr_spec (wd_id, wd_addr, wd_user),
            mkAXI4_Wr_Data_spec (wd_data, wd_user),
            mkAXI4_Rd_Addr_spec (wd_id, wd_addr, wd_user)]

def mk_C_to_BSV_AXI4L_structs (wd_addr, wd_data, wd_user):
    return [mkAXI4L_Wr_Addr_spec (wd_addr, wd_user),
            mkAXI4L_Wr_Data_spec (wd_data),
            mkAXI4L_Rd_Addr_spec (wd_addr, wd_user) ]

def mk_BSV_to_C_AXI4_structs (wd_id, wd_data, wd_user):
    return [mkAXI4_Wr_Resp_spec (wd_id, wd_user),
            mkAXI4_Rd_Data_spec (wd_id, wd_data, wd_user)]

def mk_BSV_to_C_AXI4L_structs (wd_data, wd_user):
    return [mkAXI4L_Wr_Resp_spec (wd_user),
            mkAXI4L_Rd_Data_spec (wd_data, wd_user) ]

# ================================================================
# This is the final result of this spec,
# used by the 'bytevec mux generator' program to generate BSV code for
# the 'hw side' and C code for the 'host-side'.

C_to_BSV_structs = (mk_C_to_BSV_AXI4_structs  (16, 64, 512, 0) +
                    mk_C_to_BSV_AXI4L_structs (32, 32, 0))

BSV_to_C_structs = (mk_BSV_to_C_AXI4_structs (16, 512, 0) +
                    mk_BSV_to_C_AXI4L_structs (32, 0))

package_name = "Bytevec"

# ================================================================
