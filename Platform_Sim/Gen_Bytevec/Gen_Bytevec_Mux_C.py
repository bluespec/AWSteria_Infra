#!/usr/bin/python3 -B

# Copyright (c) 2020-2021 Bluespec, Inc.
# Author: Rishiyur S. Nikhil

# See main Gen_Bytevec_Mux.py and README for details

# ================================================================

import sys
import os
import stat
import importlib
import pprint

pp = pprint.PrettyPrinter()

from Gen_Bytevec_Mux_Common import *

# ================================================================

def Gen_C  (spec_filename,
            package_name,
            C_to_BSV_structs, C_to_BSV_packet_bytes,
            BSV_to_C_structs, BSV_to_C_packet_bytes):

    output_h_filename = package_name + ".h"
    file_h = open (output_h_filename, 'w')

    output_c_filename = package_name + ".c"
    file_c = open (output_c_filename, 'w')

    # Boilerplate headers
    file_h.write ("// This file was auto-generated from spec file '{:s}'\n".format (spec_filename) +
                  "\n" +
                  "#pragma once\n")

    file_c.write ("// This file was auto-generated from spec file '{:s}'\n".format (spec_filename))
    file_c.write ("\n")
    file_c.write ("#include  <stdio.h>\n")
    file_c.write ("#include  <stdlib.h>\n")
    file_c.write ("#include  <stdint.h>\n")
    file_c.write ("#include  <inttypes.h>\n")
    file_c.write ("#include  <string.h>\n")
    file_c.write ("\n")
    file_c.write ('#include  "{:s}"\n'.format (output_h_filename))

    # ----------------
    for struct in C_to_BSV_structs + BSV_to_C_structs:
        code = gen_struct_decl (struct)
        file_h.write (code)

    # ----------------
    (h_txt, c_txt) = gen_comm_state_decls (package_name,
                                           C_to_BSV_structs, C_to_BSV_packet_bytes,
                                           BSV_to_C_structs, BSV_to_C_packet_bytes)
    file_h.write (h_txt)
    file_c.write (c_txt)

    # ----------------
    c_txt = gen_struct_bytevec_conversions (package_name,
                                            C_to_BSV_structs, C_to_BSV_packet_bytes,
                                            BSV_to_C_structs, BSV_to_C_packet_bytes)

    file_c.write (c_txt)

    # ----------------
    (h_txt, c_txt) = gen_struct_to_bytevec_function (package_name,
                                                     C_to_BSV_structs, C_to_BSV_packet_bytes,
                                                     BSV_to_C_structs, BSV_to_C_packet_bytes)
    file_h.write (h_txt)
    file_c.write (c_txt)

    # ----------------
    (h_txt, c_txt) = gen_struct_from_bytevec_function (package_name,
                                                       C_to_BSV_structs, C_to_BSV_packet_bytes,
                                                       BSV_to_C_structs, BSV_to_C_packet_bytes)
    file_h.write (h_txt)
    file_c.write (c_txt)

    # ----------------
    (h_txt, c_txt) = gen_C_to_BSV_API_enqueue_functions (package_name,
                                                         C_to_BSV_structs, C_to_BSV_packet_bytes,
                                                         BSV_to_C_structs, BSV_to_C_packet_bytes)
    file_h.write (h_txt)
    file_c.write (c_txt)

    # ----------------
    (h_txt, c_txt) = gen_BSV_to_C_API_dequeue_functions (package_name,
                                                         C_to_BSV_structs, C_to_BSV_packet_bytes,
                                                         BSV_to_C_structs, BSV_to_C_packet_bytes)
    file_h.write (h_txt)
    file_c.write (c_txt)

    # Finish up .h and .c files
    file_h.write ("\n")
    file_h.write ("// ================================================================\n")
    file_h.close ()

    file_c.write ("\n")
    file_c.write ("// ================================================================\n")
    file_c.close ()

    sys.stdout.write ("Wrote output to file: {:s}\n".format (output_h_filename))
    sys.stdout.write ("Wrote output to file: {:s}\n".format (output_c_filename))

    return 0

# ================================================================

def gen_struct_decl (struct):
    struct_name = struct ['struct_name']
    result = "\n"
    result += "// ================================================================\n"
    result += "// Size on the wire: {:d} bytes\n".format (struct ['size_bytes'])
    result += "\n"
    result += "typedef struct {\n"
    for f in struct ['fields']:
        field_name  = f ['field_name']
        width_bits  = f ['width_bits']
        width_bytes = f ['width_bytes']
        dimension   = f ['dimension']

        byte_width = 0
        if (width_bytes <= 1):    c_type = "uint8_t"
        elif (width_bytes == 2):  c_type = "uint16_t"
        elif (width_bytes == 4):  c_type = "uint32_t"
        elif (width_bytes == 8):  c_type = "uint64_t"

        field_decl = "{:12s}  {:s}".format (c_type, field_name)
        if (dimension > 1):
            field_decl += " [{:d}]".format (dimension)
        field_decl += ";"
        result += "{:30s}    // {:d} bits\n".format (field_decl, width_bits)
    result += "}} {:s};\n".format (struct_name)
    return result

# ================================================================
# Generate struct to/from bytevec functions

def gen_struct_bytevec_conversions (package_name,
                                    C_to_BSV_structs, C_to_BSV_packet_bytes,
                                    BSV_to_C_structs, BSV_to_C_packet_bytes):
    c_txt = ""

    c_txt += ("\n" +
              "// ================================================================\n" +
              "// Converters for C to BSV: struct -> bytevec\n")

    for struct in C_to_BSV_structs:
        struct_name = struct ['struct_name']
        fields      = struct ['fields']
        size_bytes  = struct ['size_bytes']

        x = "void {:s}_to_bytevec (".format (struct_name)
        y = x + "uint8_t *bytevec,\n"
        y += " ".rjust (len (x)) + "const {:s} *ps)\n".format (struct_name)

        c_txt += ("\n" +
                  "// ----------------------------------------------------------------\n" +
                  "\n" +
                  "static\n" +
                  y + "\n" +
                  "{\n" +
                  "    uint8_t *pb = bytevec;\n" +
                  "\n")

        for f in fields:
            field_name  = f ['field_name']
            width_bits  = f ['width_bits']
            width_bytes = f ['width_bytes']
            dimension   = f ['dimension']
            if (width_bytes != 0):
                c_txt += "    memcpy (pb, & ps->{:s}, {:d});".format (field_name, (width_bytes * dimension))
                c_txt += "    pb += {:d};\n".format (width_bytes * dimension)

        c_txt += "}\n"

    c_txt += ("\n" +
              "// ================================================================\n" +
              "// Converters for BSV to C: bytevec -> struct\n")

    for struct in BSV_to_C_structs:
        struct_name = struct ['struct_name']
        fields      = struct ['fields']
        size_bytes  = struct ['size_bytes']

        x = "void {:s}_from_bytevec (".format (struct_name)
        y = x + "{:s} *ps,\n".format (struct_name)
        y += " ".rjust (len (x)) + "const uint8_t *bytevec)\n"

        c_txt += ("\n" +
                  "// ----------------------------------------------------------------\n" +
                  "\n" +
                  "static\n" +
                  y + "\n" +
                  "{\n" +
                  "    const uint8_t *pb = bytevec;\n" +
                  "\n")

        for f in fields:
            field_name  = f ['field_name']
            width_bits  = f ['width_bits']
            width_bytes = f ['width_bytes']
            dimension   = f ['dimension']
            c_txt += "    memcpy (& ps->{:s}, pb, {:d});".format (field_name, (width_bytes * dimension))
            c_txt += "    pb += {:d};\n".format (width_bytes * dimension)

        c_txt += "}\n"

    return c_txt

# ================================================================
# Gen communication state struct

def gen_comm_state_decls (package_name,
                          C_to_BSV_structs, C_to_BSV_packet_bytes,
                          BSV_to_C_structs, BSV_to_C_packet_bytes):

    state_type = "{:s}_state".format (package_name)
    h_txt = ""
    c_txt = ""

    h_txt += ("\n" +
              "// ================================================================\n" +
              "// Communication state\n" +
              "\n" +
              "#define C_TO_BSV_FIFO_SIZE        0x10\n" +
              "#define C_TO_BSV_FIFO_INDEX_MASK  0x0F\n" +
              "\n" +
              "#define BSV_TO_C_FIFO_SIZE        0x80\n" +
              "#define BSV_TO_C_FIFO_INDEX_MASK  0x7F\n" +
              "\n" +
              "typedef struct {\n")

    h_txt += "   // C to BSV queues\n"
    for j in range (len (C_to_BSV_structs)):
        s = C_to_BSV_structs [j]
        struct_name = s ['struct_name']
        if (j != 0): h_txt += "\n"
        h_txt += "   {0:s}  buf_{0:s} [C_TO_BSV_FIFO_SIZE];\n".format (struct_name)
        h_txt += "   uint64_t head_{:s};\n".format (struct_name)
        h_txt += "   uint64_t size_{:s};\n".format (struct_name)
        h_txt += "   uint64_t credits_{:s};\n".format (struct_name)

    h_txt += "\n"
    h_txt += "   // BSV to C queues\n"
    for j in range (len (BSV_to_C_structs)):
        s = BSV_to_C_structs [j]
        struct_name = s ['struct_name']
        if (j != 0): h_txt += "\n"
        h_txt += "   {0:s}  buf_{0:s} [BSV_TO_C_FIFO_SIZE];\n".format (struct_name)
        h_txt += "   uint64_t head_{:s};\n".format (struct_name)
        h_txt += "   uint64_t size_{:s};\n".format (struct_name)
        h_txt += "   uint64_t credits_{:s};\n".format (struct_name)

    h_txt += ("\n" +
              "    // Bytevecs for C to BSV and BSV to C packets\n" +
              ("    uint8_t bytevec_C_to_BSV [{:d}];\n".
               format (total_packet_size_bytes (C_to_BSV_packet_bytes))) +
              ("    uint8_t bytevec_BSV_to_C [{:d}];\n".
               format (total_packet_size_bytes (BSV_to_C_packet_bytes))))
    h_txt += "}} {:s};\n".format (state_type)

    x = ("\n" +
         "// ================================================================\n" +
         "// State constructor and initializer\n" +
         "\n")
    y = "{0:s} *mk_{0:s} (void)".format (state_type)

    h_txt += (x +
              "extern\n" +
              y + ";\n")

    c_txt += (x +
              y + "\n" +
              "{\n" +
              ("    {0:s} *p_state = ({0:s} *) malloc (sizeof ({0:s}));\n".
               format (state_type)) +
              "    if (p_state == NULL) return p_state;\n" +
              "\n" +
              "    memset (p_state, 0, sizeof ({:s}));\n".format (state_type))

    c_txt += ("\n" +
              "    // Initialize credits for BSV-to-C queues\n")
    for j in range (len (BSV_to_C_structs)):
        s = BSV_to_C_structs [j]
        struct_name = s ['struct_name']
        c_txt += "    p_state->credits_{:s} = BSV_TO_C_FIFO_SIZE;\n".format (struct_name)

    c_txt += ("\n" +
              "    return p_state;\n" +
              "}\n")

    return (h_txt, c_txt)

# ================================================================
# Generate struct_to_bytevec function

x = ["",
     "// ================================================================",
     "// C to BSV struct->bytevec encoder",
     "// Returns 1: bytevec has info; should be sent",
     "//         0: bytevec has no info; should not be sent",
     ""]

h_template_struct_to_bytevec_function = (
    x +
    ["extern",
     "int @PKG_struct_to_bytevec (@PKG_state *p_state);",
     ""])

c_template_struct_to_bytevec_function = (
    x +
    ["int @PKG_struct_to_bytevec (@PKG_state *p_state)",
     "{",
     "    int verbosity = 0;    // local verbosity for this function",
     "",
     "    // ---- Fill in credits for BSV-to-C channels",
     "    uint32_t total_credits = 0;",
     ""])

# This is repeated for each BSV_to_C struct type
c_template_struct_to_bytevec_function_credits = [
    "",
    "    total_credits += p_state->credits_@BSV_TO_C_STRUCT;",
    "    p_state->bytevec_C_to_BSV [@BSV_TO_C_CREDIT_INDEX] = p_state->credits_@BSV_TO_C_STRUCT;",
    "    p_state->credits_@BSV_TO_C_STRUCT = 0;",
    ""]

# This is repeated for each C_to_BSV struct type
c_template_struct_to_bytevec_function_encode = [
    "",
    "    // C to BSV: @C_TO_BSV_STRUCT",
    "    if ((p_state->size_@C_TO_BSV_STRUCT != 0) && (p_state->credits_@C_TO_BSV_STRUCT != 0)) {",
    "        p_state->bytevec_C_to_BSV [0] = @PKT_SIZE;    // Packet size",
    "        p_state->bytevec_C_to_BSV [@CHAN_ID_INDEX] = @THIS_CHAN_ID;    // Channel Id",
    "        // ---- Payload from struct",
    "        uint64_t head_index = (p_state->head_@C_TO_BSV_STRUCT & C_TO_BSV_FIFO_INDEX_MASK);",
    "        @C_TO_BSV_STRUCT_to_bytevec (p_state->bytevec_C_to_BSV + @CHAN_ID_INDEX + 1,",
    "                        & p_state->buf_@C_TO_BSV_STRUCT [head_index]);",
    "        // ---- Dequeue the struct and return success (bytevec ready)",
    "        p_state->head_@C_TO_BSV_STRUCT += 1;",
    "        p_state->size_@C_TO_BSV_STRUCT -= 1;",
    "        p_state->credits_@C_TO_BSV_STRUCT -= 1;",
    "        if (verbosity != 0) {",
    '            fprintf (stdout, "@PKG_struct_to_bytevec: encoded @C_TO_BSV_STRUCT\\n");',
    '            fprintf (stdout, "  head %0" PRIx64 "  size %0" PRIx64 "  credits %0" PRIx64 "\\n",',
    '                     p_state->head_@C_TO_BSV_STRUCT,',
    '                     p_state->size_@C_TO_BSV_STRUCT,',
    '                     p_state->credits_@C_TO_BSV_STRUCT);',
    "        }",
    "        return 1;",
    "    }",
    ""]


c_template_struct_to_bytevec_function_final = [
    "",
    "    // Credits-only bytevec",
    "    if (total_credits != 0) {",
    "        p_state->bytevec_C_to_BSV [0] = 1 + @CHAN_ID_INDEX;    // packet size",
    "        p_state->bytevec_C_to_BSV [@CHAN_ID_INDEX] = 0;    // chan id = credits-only",
    "        if (verbosity != 0)",
    '            fprintf (stdout, "@PKG_struct_to_bytevec: bytevec is credits-only\\n");',
    "        return 1;",
    "    }",
    "",
    "    // No bytevec to send",
    "    return 0;",
    "}",
    ""
]

def gen_struct_to_bytevec_function (package_name,
                                    C_to_BSV_structs, C_to_BSV_packet_bytes,
                                    BSV_to_C_structs, BSV_to_C_packet_bytes):
    h_txt = subst (h_template_struct_to_bytevec_function,
                  [ ("@PKG", package_name) ])

    c_txt = subst (c_template_struct_to_bytevec_function,
                  [ ("@PKG", package_name) ])

    for j in range (len (BSV_to_C_structs)):
        c_txt += subst (c_template_struct_to_bytevec_function_credits,
                        [ ("@PKG", package_name),
                          ("@BSV_TO_C_STRUCT",        BSV_to_C_structs [j] ['struct_name']),
                          ("@BSV_TO_C_CREDIT_INDEX",  "{:d}".format (j + 1)) ])

    for j in range (len (C_to_BSV_structs)):
        size_bytes = "{:d}".format (this_packet_size_bytes (C_to_BSV_packet_bytes,
                                                            C_to_BSV_structs [j]['size_bytes']))
        c_txt += subst (c_template_struct_to_bytevec_function_encode,
                        [ ("@PKG", package_name),
                          ("@C_TO_BSV_STRUCT", C_to_BSV_structs [j] ['struct_name']),
                          ("@PKT_SIZE",        size_bytes),
                          ("@THIS_CHAN_ID",    "{:d}".format (j + 1)),
                          ("@CHAN_ID_INDEX",   "{:d}".format (1 + len (BSV_to_C_structs))) ])

    c_txt += subst (c_template_struct_to_bytevec_function_final,
                    [ ("@PKG", package_name),
                      ("@CHAN_ID_INDEX",   "{:d}".format (1 + len (BSV_to_C_structs))) ])
    return (h_txt, c_txt)

# ================================================================
# Generate struct_from_bytevec function

x = ["",
     "// ================================================================",
     "// BSV to C bytevec->struct decoder",
     "// p_state->bytevec_BSV_to_C contains a bytevec",
     "// Returns 1: bytevec had payload struct",
     "//         0: bytevec had credits-only",
     ""]

h_template_struct_from_bytevec_function = (
    x +
    ["extern",
     "int @PKG_struct_from_bytevec (@PKG_state *p_state);",
     ""])

c_template_struct_from_bytevec_function = (
    x +
    ["int @PKG_struct_from_bytevec (@PKG_state *p_state)",
     "{",
     "    int verbosity = 0;    // local verbosity for this function",
     "",
     "    // ---- Restore credits for remote C-to-BSV receive buffers",
     ""])

# This is repeated for each C_TO_BSV struct type
c_template_struct_from_bytevec_function_credits = [
    "    p_state->credits_@C_TO_BSV_STRUCT += p_state->bytevec_BSV_to_C [@C_TO_BSV_CREDIT_INDEX];",
    ""]

# This is repeated for each BSV_to_C struct type
c_template_struct_from_bytevec_function_decode = [
    "",
    "    // BSV to C: @BSV_TO_C_STRUCT",
    "    if (p_state->bytevec_BSV_to_C [@CHAN_ID_INDEX] == @THIS_CHAN_ID) {",
    "        // ---- Fill in struct from payload",
    "        uint64_t head_index = (p_state->head_@BSV_TO_C_STRUCT & BSV_TO_C_FIFO_INDEX_MASK);",
    "        @BSV_TO_C_STRUCT_from_bytevec (& p_state->buf_@BSV_TO_C_STRUCT [head_index],",
    "                                       p_state->bytevec_BSV_to_C + @CHAN_ID_INDEX + 1);",
    "        // ---- Enqueue the struct",
    "        p_state->size_@BSV_TO_C_STRUCT += 1;",
    "        if (verbosity != 0)",
    '            fprintf (stdout, "@PKG_struct_from_bytevec: received @BSV_TO_C_STRUCT struct\\n");',
    "        return 1;",
    "    }",
    ""
]

c_template_struct_from_bytevec_function_final = [
    "    if (verbosity != 0)",
    '        fprintf (stdout, "@PKG_struct_from_bytevec: bytevec is credits-only\\n");',
    "    return 0;",
    "}",
    ""
]

def gen_struct_from_bytevec_function (package_name,
                                      C_to_BSV_structs, C_to_BSV_packet_bytes,
                                      BSV_to_C_structs, BSV_to_C_packet_bytes):
    h_txt = subst (h_template_struct_from_bytevec_function,
                  [ ("@PKG", package_name) ])

    c_txt = subst (c_template_struct_from_bytevec_function,
                  [ ("@PKG", package_name) ])

    for j in range (len (C_to_BSV_structs)):
        c_txt += subst (c_template_struct_from_bytevec_function_credits,
                        [ ("@PKG", package_name),
                          ("@C_TO_BSV_STRUCT",        C_to_BSV_structs [j] ['struct_name']),
                          ("@C_TO_BSV_CREDIT_INDEX",  "{:d}".format (j + 1)) ])

    for j in range (len (BSV_to_C_structs)):
        c_txt += subst (c_template_struct_from_bytevec_function_decode,
                        [ ("@PKG", package_name),
                          ("@BSV_TO_C_STRUCT", BSV_to_C_structs [j] ['struct_name']),
                          ("@THIS_CHAN_ID",    "{:d}".format (j + 1)),
                          ("@CHAN_ID_INDEX",   "{:d}".format (1 + len (C_to_BSV_structs))) ])

    c_txt += subst (c_template_struct_from_bytevec_function_final,
                    [ ("@PKG", package_name) ])
    return (h_txt, c_txt)

# ================================================================
# Generate C-to-BSV API enqueue-functions

def gen_C_to_BSV_API_enqueue_functions (package_name,
                                        C_to_BSV_structs, C_to_BSV_packet_bytes,
                                        BSV_to_C_structs, BSV_to_C_packet_bytes):

    state_type = "{:s}_state".format (package_name)
    h_txt = ""
    c_txt = ""

    for s in C_to_BSV_structs:
        struct_name = s ['struct_name']
        x = ("\n" +
             "// ================================================================\n" +
             "// Enqueue a {:s} struct to be sent from C to BSV\n".format (struct_name) +
             "// Return 0 if failed (queue overflow) or 1 if success\n" +
             "// TODO: make this thread-safe\n" +
             "\n")
        function_name = "{0:s}_enqueue_{1:s}".format (package_name, struct_name)
        y  = "int {:s} (".format (function_name)
        y  = (y + "{:s} *p_state,\n".format (state_type) +
              " ".rjust (len (y)) + "{:s} *p_struct)".format (struct_name))

        h_txt += (x +
                  "extern\n" +
                  y + ";\n")

        c_txt += (x +
                  y + "\n" +
                  "{\n" +
                  "    int verbosity = 0;\n")

        c_txt += ("    if (p_state->size_{:s} >= C_TO_BSV_FIFO_SIZE) return 0;\n".format (struct_name) +
                  "\n" +
                  "    uint64_t tail_index = p_state->head_{0:s} +\n".format (struct_name) +
                  "                          p_state->size_{0:s};\n".format (struct_name) +
                  "    tail_index = (tail_index & C_TO_BSV_FIFO_INDEX_MASK);\n" +
                  "    memcpy (& (p_state->buf_{:s} [tail_index]),\n".format (struct_name) +
                  "            p_struct,\n".format (struct_name) +
                  "            sizeof ({:s}));\n".format (struct_name) +
                  "    p_state->size_{:s} += 1;\n".format (struct_name) +
                  "    if (verbosity != 0) {\n" +
                  ('        fprintf (stdout, "{:s}_enqueue_{:s}:\\n");\n'.
                   format (package_name, struct_name)) +
                  '        fprintf (stdout, "  head %0" PRIx64 "  size %0" PRIx64 "  credits %0" PRIx64 "\\n",\n' +
                  '                 p_state->head_{:s},\n'.format (struct_name) +
                  '                 p_state->size_{:s},\n'.format (struct_name) +
                  '                 p_state->credits_{:s});\n'.format (struct_name) +
                  "    }\n")

        c_txt += ("\n" +
                  "    return 1;\n" +
                  "}\n")

    return (h_txt, c_txt)

# ================================================================
# Generate BSV-to-C API dequeue-functions

def gen_BSV_to_C_API_dequeue_functions (package_name,
                                        C_to_BSV_structs, C_to_BSV_packet_bytes,
                                        BSV_to_C_structs, BSV_to_C_packet_bytes):

    state_type = "{:s}_state".format (package_name)
    h_txt = ""
    c_txt = ""

    for s in BSV_to_C_structs:
        struct_name = s ['struct_name']
        x = ("\n" +
             "// ================================================================\n" +
             "// Dequeue a {:s} struct received from BSV to C\n".format (struct_name) +
             "// Return 0 if failed (none available) or 1 if success\n" +
             "// TODO: make this thread-safe\n" +
             "\n")
        y  = "int {0:s}_dequeue_{1:s} (".format (package_name, struct_name)
        y  = (y + "{:s} *p_state,\n".format (state_type) +
              " ".rjust (len (y)) + "{:s} *p_struct)".format (struct_name))

        h_txt += (x +
                  "extern\n" +
                  y + ";\n")

        c_txt += (x +
                  y + "\n" +
                  "{\n")

        c_txt += ("    if (p_state->size_{:s} == 0) return 0;\n".format (struct_name) +
                  "\n" +
                  "    uint64_t head_index = (p_state->head_{0:s} &\n".format (struct_name) +
                  "                           BSV_TO_C_FIFO_INDEX_MASK);\n" +
                  "    memcpy (p_struct,\n".format (struct_name) +
                  "            & (p_state->buf_{0:s} [head_index]),\n".format (struct_name) +
                  "            sizeof ({:s}));\n".format (struct_name) +
                  "    p_state->head_{:s} += 1;\n".format (struct_name) +
                  "    p_state->size_{:s} -= 1;\n".format (struct_name) +
                  "    p_state->credits_{:s} += 1;\n".format (struct_name))
        c_txt += ("\n" +
                  "    return 1;\n" +
                  "}\n")

    return (h_txt, c_txt)

# ================================================================
