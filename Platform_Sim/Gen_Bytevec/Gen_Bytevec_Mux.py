#!/usr/bin/python3 -B

# Copyright (c) 2020-2022 Bluespec, Inc.
# Author: Rishiyur S. Nikhil

# See README for details

# ================================================================

import sys
import os
import stat
import importlib
import pprint

from Gen_Bytevec_Mux_BSV import *
from Gen_Bytevec_Mux_C   import *

pp = pprint.PrettyPrinter()

# ================================================================

def mkHelp_text (argv):
    return "Usage:    " + argv [0] + "  <spec_file.py>" + '''

    <spec_file.py> should be a Python source file defining three variables:
        C_to_BSV_structs
        BSV_to_C_structs
        package_name

    The first two are lists of 'struct specs', each of which has the following form:

        { 'struct_name': "Foo",
          'fields'     : [ { 'field_name' : 'fieldfoo', 'width_bits': width },
                           ...
                           { 'field_name' : 'fieldfoo', 'width_bits': width } ]}

    Struct names should be globally unique.
    Field names should be unique within a struct.
    It is ok for a field-width to be 0 (e.g., unused 'user' field in an AXI channel).

    Generates three output files:
        package_name.bsv
        package_name.h
        package_name.c

    The C/BSV code contains:
        Struct defs for each struct, where each field has type:
            BSV: Bit #(w) where w is the specified bit-width
            C:   uint8_t, uint16_t, uint32_t or uint64_t, as appropriate, if width <= 64 bits,
                 uint8_t [..] if wider

        A 'state' struct containing queues and communication 'credits' for each struct type,

        Functions for C application code to enqueue each type of send-struct into a pending queue
        Functions for C application code to dequeue each type of receive-struct from a pending queue

        A function for the C application code to encode an already
            queued send-struct into a bytevec ready for transmission
        A function for the C application code to decode a received
            bytevec into a queued receive-struct
'''

# ================================================================

def main (argv = None):
    if ((len (argv) != 2)
        or (argv [1] == "-h")
        or (argv [1] == "--help")):
        sys.stdout.write (mkHelp_text (argv))
        return 0

    spec_filename = argv [1]
    if spec_filename.endswith (".py"):
        spec_filename = spec_filename [:-3]

    try:
        # Warning:
        # This dynamic import of the spec_filename spec file is fragile (only works if both
        # this Python executable and spec_filename.py are in the current dir.
        # Study importlib examples where there is some notion of 'finding' from a path etc.
        spec = importlib.import_module (spec_filename)    # ("type_specs")
    except:
        sys.stdout.write ("ERROR: unable to import module '{:s}'\n".format (spec_filename))
        sys.exit (1)
    
    sys.stdout.write ("Spec file imported: '{:s}'\n".format (spec_filename))

    package_name = spec.package_name
    sys.stdout.write ("Package name: '{:s}'\n".format (package_name))

    # Compute all necessary byte-widths for transmission and C structs
    # Each of the 'field' structs extends with 'width_bytes' and 'dimension'
    sys.stdout.write ("Computing all necessary byte-widths for packet formats and C structs.\n")
    C_to_BSV_structs = [compute_width_bytes (s) for s in spec.C_to_BSV_structs]
    BSV_to_C_structs = [compute_width_bytes (s) for s in spec.BSV_to_C_structs]

    # Data structure for different parts of a packet: C to BSV
    max_C_to_BSV_struct_bytes = max ([ s ['size_bytes']  for s in C_to_BSV_structs ])
    C_to_BSV_packet_bytes = { 'packet_len'  : 1,
                              'num_credits' : len (BSV_to_C_structs),
                              'channel_id'  : 1,
                              'payload'     : max_C_to_BSV_struct_bytes }

    # Data structure for different parts of a packet: BSV to C
    max_BSV_to_C_struct_bytes = max ([ s ['size_bytes']  for s in BSV_to_C_structs ])
    BSV_to_C_packet_bytes = { 'packet_len'  : 1,
                              'num_credits' : len (C_to_BSV_structs),
                              'channel_id'  : 1,
                              'payload'     : max_BSV_to_C_struct_bytes }

    # Generate the .bsv file
    Gen_BSV  (spec_filename,
              package_name,
              C_to_BSV_structs, C_to_BSV_packet_bytes,
              BSV_to_C_structs, BSV_to_C_packet_bytes)

    # Generate .h and .c files
    Gen_C  (spec_filename,
            package_name,
            C_to_BSV_structs, C_to_BSV_packet_bytes,
            BSV_to_C_structs, BSV_to_C_packet_bytes)

    return 0

# ================================================================
# This is a struct spec -> struct spec function

# In struct_spec_in, each field spec has attributes 'field_name' and 'width_bits'
# In struct_spec_out, we add attributes 'width_bytes' and 'dimension'
#    and we add struct attribute 'size_bytes' for total # of bytes

# Fields <= 64b wide, fit in C scalars (uint8_t/uint16_t/uint32_t/uint64_t)
#     have dimension 1 and width_bytes of 1,2,4 or 8
# Larger fields are represented in C as uint8_t [N]
#     have dimension N and width_bytes 1

def compute_width_bytes (struct_spec_in):
    fields_out  = []
    size_bytes = 0
    for f in struct_spec_in ['fields']:
        field_name  = f ['field_name']
        width_bits  = f ['width_bits']
        width_bytes = 0
        dimension   = 1;
        if (width_bits == 0):
            width_bytes = 0
        elif (width_bits <= 8):
            width_bytes = 1
        elif (width_bits <= 16):
            width_bytes = 2
        elif (width_bits <= 32):
            width_bytes = 4
        elif (width_bits <= 64):
            width_bytes = 8
        else:
            width_bytes = 1
            dimension  = (width_bits + 7) // 8
        field_out = {'field_name' : field_name,
                     'width_bits' : width_bits,
                     'width_bytes': width_bytes,
                     'dimension'  : dimension}
        fields_out.append (field_out)
        size_bytes += width_bytes * dimension

    struct_spec_out = {'struct_name': struct_spec_in ['struct_name'],
                       'fields'     : fields_out,
                       'size_bytes' : size_bytes}
    return struct_spec_out

# ================================================================
# For non-interactive invocations, call main() and use its return value
# as the exit code.

if __name__ == '__main__':
  sys.exit (main (sys.argv))

