#!/usr/bin/python3 -B

# Copyright (c) 2020-2022 Bluespec, Inc.
# Author: Rishiyur S. Nikhil

# See main Gen.py and README for details

# ================================================================

import sys
import os
import stat
import importlib
import pprint

pp = pprint.PrettyPrinter()

from Gen_Bytevec_Mux_Common import *

# ================================================================

def Gen_BSV  (spec_filename,
              package_name,
              C_to_BSV_structs, C_to_BSV_packet_bytes,
              BSV_to_C_structs, BSV_to_C_packet_bytes):

    output_bsv_filename = package_name + ".bsv"
    file_bsv = open (output_bsv_filename, 'w')

    file_bsv.write ("// This file was auto-generated from spec file '{:s}'\n".format (spec_filename))
    file_bsv.write ("\n")
    file_bsv.write ("package {:s};\n".format (package_name))
    file_bsv.write ("\n")
    file_bsv.write ("import Vector     :: *;\n")
    file_bsv.write ("import FIFOF      :: *;\n")
    file_bsv.write ("import Semi_FIFOF :: *;\n")
    file_bsv.write ("\n")

    for struct in C_to_BSV_structs + BSV_to_C_structs:
        code = gen_struct_decl (struct)
        file_bsv.write (code)

    file_bsv.write (gen_interface (package_name,
                                C_to_BSV_structs, C_to_BSV_packet_bytes,
                                BSV_to_C_structs, BSV_to_C_packet_bytes))

    file_bsv.write (gen_module (package_name,
                                C_to_BSV_structs, C_to_BSV_packet_bytes,
                                BSV_to_C_structs, BSV_to_C_packet_bytes))

    file_bsv.write ("// ================================================================\n")
    file_bsv.write ("\n")
    file_bsv.write ("endpackage\n")

    file_bsv.close ()
    sys.stdout.write ("Wrote output to file: {:s}\n".format (output_bsv_filename))

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
        width_bytes = f ['width_bytes']
        dimension   = f ['dimension']
        bsv_type   = "Bit #({:d})".format (f ['width_bits'])
        result  += "    {:14s}  {:s};    // {:d} bytes\n".format (bsv_type, field_name, (width_bytes * dimension))
    result += "}} {:s}\n".format (struct_name)
    result += "deriving (Bits, FShow);\n"
    return result

# ================================================================

def gen_interface (package_name,
                   C_to_BSV_structs, C_to_BSV_packet_bytes,
                   BSV_to_C_structs, BSV_to_C_packet_bytes):

    Bytevec_C_to_BSV_Size = total_packet_size_bytes (C_to_BSV_packet_bytes)
    Bytevec_BSV_to_C_Size = total_packet_size_bytes (BSV_to_C_packet_bytes)
    result = "\n"
    result += "// ================================================================\n"
    result += "// Bytevecs\n"
    result += "\n"
    result += "typedef  {:d}  Bytevec_C_to_BSV_Size;\n".format (Bytevec_C_to_BSV_Size)
    result += "Integer  bytevec_C_to_BSV_size = {:d};\n".format (Bytevec_C_to_BSV_Size)
    result += "typedef  Vector #(Bytevec_C_to_BSV_Size, Bit #(8))  Bytevec_C_to_BSV;\n"
    result += "\n"
    result += "typedef  {:d}  BSV_to_C_Bytevec_Size;\n".format (Bytevec_BSV_to_C_Size)
    result += "Integer  bytevec_BSV_to_C_size = {:d};\n".format (Bytevec_BSV_to_C_Size)
    result += "typedef  Vector #(BSV_to_C_Bytevec_Size, Bit #(8))  BSV_to_C_Bytevec;\n"
    result += "\n"
    result += "// ================================================================\n"
    result += "// INTERFACE\n"
    result += "\n"
    result += "interface {:s}_IFC;\n".format (package_name)

    result += "    // ---------------- Facing BSV\n"

    w_format = max ([len (s ['struct_name']) for s in C_to_BSV_structs])
    result += "    // C to BSV\n"
    for s in C_to_BSV_structs:
        text = "interface FIFOF_O #({:s})".format (s ['struct_name'])
        text = text.ljust (len ("interface FIFOF_I #()") + w_format)
        result += "    {:s}  fo_{:s};\n".format (text, s ['struct_name'])
    result += "\n"

    w_format = max ([len (s ['struct_name']) for s in BSV_to_C_structs])
    result += "    // BSV to C\n"
    for s in BSV_to_C_structs:
        text = "interface FIFOF_I #({:s})".format (s ['struct_name'])
        text = text.ljust (len ("interface FIFOF_I #()") + w_format)
        result += "    {:s}  fi_{:s};\n".format (text, s ['struct_name'])

    result += "\n"
    result += "    // ---------------- Facing C\n"
    result += "    interface FIFOF_I #(Bytevec_C_to_BSV) fi_C_to_BSV_bytevec;\n"
    result += "    interface FIFOF_O #(BSV_to_C_Bytevec) fo_BSV_to_C_bytevec;\n"

    result += "endinterface\n"
    result += "\n"

    return result

# ================================================================

def gen_module (package_name,
                   C_to_BSV_structs, C_to_BSV_packet_bytes,
                   BSV_to_C_structs, BSV_to_C_packet_bytes):

    result = ("// ================================================================\n" +
              "\n" +
              "(* synthesize *)\n" +
              "module mk{0:s} ({0:s}_IFC);\n".format (package_name) +
              "   Integer verbosity = 0;\n")

    result += "\n"
    result += "   // FIFOs and credit counters for C_to_BSV\n"
    result += "   FIFOF #(Bytevec_C_to_BSV) f_C_to_BSV_bytevec <- mkFIFOF;\n"
    for s in C_to_BSV_structs:
        struct_name = s ['struct_name']
        result += "\n"
        result += "   FIFOF #({0:s}) f_{0:s} <- mkSizedFIFOF (128);\n".format (struct_name)
        result += "   Reg #(Bit #(8)) rg_credits_{:s} <- mkReg (128);\n".format (struct_name)

    result += "\n"
    result += "   // FIFOs and credit counters for BSV_to_C\n"
    result += "   FIFOF #(BSV_to_C_Bytevec) f_BSV_to_C_bytevec <- mkFIFOF;\n"
    for s in BSV_to_C_structs:
        struct_name = s ['struct_name']
        result += "\n"
        result += "   FIFOF #({0:s}) f_{0:s} <- mkFIFOF;\n".format (struct_name)
        result += "   Reg #(Bit #(8)) rg_credits_{:s} <- mkReg (0);\n".format (struct_name)

    result += "\n"
    result += "   // ================================================================\n"
    result += "   // BEHAVIOR: C to BSV packets\n"

    type_C_to_BSV = C_to_BSV_packet_bytes ['packet_len'] + C_to_BSV_packet_bytes ['num_credits']

    result += "\n"
    result += "   let bytevec_C_to_BSV = f_C_to_BSV_bytevec.first;\n"

    result += ("\n" +
               "   rule rl_debug_bytevec_C_to_BSV (False);\n" +
               '      $write ("{:s}.rl_debug\\n  ");\n'.format (package_name) + 
               "      for (Integer j = 0; j < valueOf (Bytevec_C_to_BSV_Size); j = j + 1)\n" +
               "         if (fromInteger (j) < bytevec_C_to_BSV [0])\n" +
               '            $write (" %02h", bytevec_C_to_BSV [j]);\n' +
               '      $display ("\\n");\n' + 
               "   endrule\n")

    result += ("\n" +
               "   // Common function to restore credits for BSV-to-C channels\n" +
               "   function Action restore_credits_for_BSV_to_C ();\n" +
               "      action\n")
    for j in range (1, type_C_to_BSV):
        s_BSV_to_C = BSV_to_C_structs [j-1]
        rg_credits = "rg_credits_{:s}".format (s_BSV_to_C ['struct_name'])
        result += "         {0:s} <= {0:s} + bytevec_C_to_BSV [{1:d}];\n".format (rg_credits, j)
    result += ("      endaction\n" +
               "   endfunction\n")

    # C-to-BSV credits-only packet
    result += ("\n" +
               "   rule rl_C_to_BSV_credits_only (bytevec_C_to_BSV [5] == 0);\n" +
               "\n" +
               "      restore_credits_for_BSV_to_C;\n" +
               "\n" +
               "      f_C_to_BSV_bytevec.deq;\n" +
               "      if (verbosity != 0)\n" +
               '         $display ("{:s}.rl_C_to_BSV_credits_only");\n'.format (package_name) +
               "   endrule\n")

    # C-to-BSV packets for each struct type
    for j in range (len (C_to_BSV_structs)):
        s = C_to_BSV_structs [j]
        chan_id = j + 1
        struct_name = s ['struct_name']
        result += "\n"
        result += ("   rule rl_C_to_BSV_{:s} (bytevec_C_to_BSV [{:d}] == {:d});\n".
                   format (struct_name, type_C_to_BSV, chan_id))

        result += ("\n" +
                   "      restore_credits_for_BSV_to_C;\n")

        result += "\n"
        result += "      // Build a C-to-BSV struct from the bytevec\n"
        result += "\n"
        result += "      let s = {:s} {{\n".format (struct_name)
        offset = type_C_to_BSV + 1
        fields = s ['fields']
        for fj in range (len (fields)):
            f            = fields [fj]
            field_name  = f ['field_name']
            width_bytes = f ['width_bytes'] 
            dimension   = f ['dimension']
            if (width_bytes == 0):
                result += ("                  {:s} : ?".format (field_name))
            elif ((dimension * width_bytes) == 1):
                result += ("                  {:s} : truncate (bytevec_C_to_BSV [{:d}])".
                           format (field_name, offset))
            else:
                line = "                  {:s} : truncate ({{ ".format (field_name)
                result += line
                for j in reversed (range (offset, offset + (dimension * width_bytes))):
                    term = "bytevec_C_to_BSV [{:d}]".format (j)
                    if (j == offset + (dimension * width_bytes) - 1):
                        result += term
                    else:
                        result += " ".rjust (len (line)) + term
                    if (j != offset):
                        result += ",\n"
                result += " } )"
            if fj < (len (fields) - 1):
                result += ",\n"
            else:
                result += " };\n"
            offset += (dimension * width_bytes)

        result += "\n"
        result += "      // Enqueue the C-to-BSV struct and dequeue the bytevec\n"
        result += "      f_{:s}.enq (s);\n".format (struct_name)
        result += "      f_C_to_BSV_bytevec.deq;\n"
        result += "      if (verbosity != 0)\n"
        result += ('         $display ("{:s}: received {:s}: ", fshow (s));\n'.
                   format (package_name, struct_name))
        result += "   endrule\n"

    # ================================================================
    # Process BSV-to-C packets

    result += "\n"
    result += "   // ================================================================\n"
    result += "   // BEHAVIOR: BSV to C structs\n"

    type_BSV_to_C = BSV_to_C_packet_bytes ['packet_len'] + BSV_to_C_packet_bytes ['num_credits']

    result += ("\n" +
               "   // Common function to fill in credits for C_to_BSV channels\n" +
               "   function ActionValue #(BSV_to_C_Bytevec) fill_credits_for_C_to_BSV (BSV_to_C_Bytevec bv);\n" +
               "      actionvalue\n")
    for j in range (1, type_BSV_to_C):
        s_C_to_BSV = C_to_BSV_structs [j-1]
        rg_credits = "rg_credits_{:s}".format (s_C_to_BSV ['struct_name'])
        result += ("         bv [{:d}] = {:s};".format (j, rg_credits) +
                   "    {:s} <= 0;\n".format (rg_credits))
    result += ("         return bv;\n" +
               "      endactionvalue\n" +
               "   endfunction\n")

    for j in range (len (BSV_to_C_structs)):
        s = BSV_to_C_structs [j]
        chan_id = j + 1
        struct_name = s ['struct_name']
        size_bytes  = s ['size_bytes']
        result += ("\n" +
                   "   Bool ready_{:s} =\n".format(struct_name) +
                   "              (f_{:s}.notEmpty\n".format (struct_name) +
                   "               && (rg_credits_{:s} != 0));\n".format (struct_name) +
                   "\n" +
                   "   rule rl_BSV_to_C_{0:s} (ready_{0:s});\n".format (struct_name))

        result += ("      BSV_to_C_Bytevec bytevec_BSV_to_C = replicate (0);\n" +
                   "      bytevec_BSV_to_C [0] = {:d};\n".
                   format (this_packet_size_bytes (BSV_to_C_packet_bytes, size_bytes)) +
                   "\n" +
                   "      bytevec_BSV_to_C <- fill_credits_for_C_to_BSV (bytevec_BSV_to_C);\n" +
                   "\n" +
                   "      bytevec_BSV_to_C [{:d}] = {:d};\n".format (type_BSV_to_C, chan_id))

        result += "\n"
        result += "      // Unpack the BSV-to-C struct into the bytevec\n"
        result += "      let s = f_{:s}.first;\n".format (struct_name)
        result += "      f_{:s}.deq;\n".format (struct_name)
        byte_offset = type_BSV_to_C + 1
        for f in s ['fields']:
            field_name  = f ['field_name']
            width_bytes = f ['width_bytes'] 
            width_bits  = f ['width_bits'] 
            dimension   = f ['dimension']
            bit_lo      = 0
            while (bit_lo < width_bits):
                bit_hi = bit_lo + 7;
                if (bit_hi >= width_bits):
                   bit_hi = width_bits - 1
                result += ("      bytevec_BSV_to_C [{:d}] = zeroExtend (s.{:s} [{:d}:{:d}]);\n".
                           format (byte_offset, field_name, bit_hi, bit_lo))
                bit_lo       = bit_hi + 1
                byte_offset += 1

        result += "\n"
        result += "      // Send the bytevec to C\n"
        result += "      f_BSV_to_C_bytevec.enq (bytevec_BSV_to_C);\n"
        result += "      rg_credits_{0:s} <= rg_credits_{0:s} - 1;\n".format (struct_name)
        result += "      if (verbosity != 0)\n"
        result += '         $display ("{:s}: sent: ", fshow (s));\n'.format (package_name)
        result += "   endrule\n"

    # ----------------------------------------------------------------
    # Gen Rule for credits-only bytevec
    x = "   rule rl_BSV_to_C_credits_only ("
    result += ("\n" +
               "   // If no struct to send, send a 'credits-only' bytevec\n" +
               x)
    for j in range (len (BSV_to_C_structs)):
        s = BSV_to_C_structs [j]
        chan_id = j + 1
        struct_name = s ['struct_name']
        size_bytes  = s ['size_bytes']
        if (j != 0):
            result += " ".rjust (len (x))
        result += "(! ready_{:s})".format (struct_name)
        if (j < len (BSV_to_C_structs) - 1):
            result += " &&\n"
        else:
            result += ");\n"

    result += ("      BSV_to_C_Bytevec  bytevec_BSV_to_C = replicate (0);\n" +
               "      bytevec_BSV_to_C [0] = {:d};\n".
               format (this_packet_size_bytes (BSV_to_C_packet_bytes, 0)) +
               "\n" +
               "      bytevec_BSV_to_C <- fill_credits_for_C_to_BSV (bytevec_BSV_to_C);\n" +
               "\n" +
               ("      bytevec_BSV_to_C [{:d}] = {:d};    // type 0 = credits-only\n".
                format (type_BSV_to_C, 0)) +
               "\n" +
               "      // Send the bytevec to C if any non-zero credits\n" +
               "      Bool non_zero = False;\n")

    for j in range (len (C_to_BSV_structs)):
        result += ("      non_zero = non_zero || (bytevec_BSV_to_C [{:d}] != 0);\n".
                   format (j + 1))

    result += ("      if (non_zero) begin\n" +
               "         f_BSV_to_C_bytevec.enq (bytevec_BSV_to_C);\n" +
               "         if (verbosity != 0) begin\n" +
               ('            $display ("{:s}.rl_BSV_to_C_credits_only");\n'.
                format (package_name)))
    for j in range (len (C_to_BSV_structs)):
        struct_name = C_to_BSV_structs [j] ['struct_name']
        result += ('            $display ("    %0d {:s}", bytevec_BSV_to_C [{:d}]);\n'.
                   format (struct_name, j + 1))
    result += ("         end\n" +
               "      end\n" +
               "   endrule\n")

    # ----------------------------------------------------------------
    # Gen urgency-scheduling attributes
    rule_list = ""
    for s in C_to_BSV_structs:
        struct_name = s ['struct_name'];
        if (rule_list != ""):
            rule_list += ", "
        rule_list += "rl_C_to_BSV_{:s}".format (struct_name)
    for s in BSV_to_C_structs:
        struct_name = s ['struct_name'];
        if (s != ""):
            rule_list += ", "
        rule_list += "rl_BSV_to_C_{:s}".format (struct_name)
    if (rule_list != ""):
        rule_list += ", "
    rule_list += "rl_BSV_to_C_credits_only"

    result += ("\n" +
               "   // Bogus rule, just for anchoring this urgency attribute\n" +
               '   (* descending_urgency = "' + rule_list + '" *)\n' +
               "   rule rl_bogus (False);\n" +
               "      noAction;\n" +
               "   endrule\n")

    result += "\n"
    result += "   // ================================================================\n"
    result += "   // INTERFACE\n"

    result += "\n"
    result += "    // ---------------- Facing BSV\n"
    result += "    // C to BSV\n"
    for s in C_to_BSV_structs:
        struct_name = s ['struct_name']
        result += "\n"
        result += "   interface FIFOF_O fo_{:s};\n".format (struct_name)
        result += "      method {:s} first;\n".format (struct_name)
        result += "         return f_{:s}.first;\n".format (struct_name)
        result += "      endmethod\n"
        result += "      method Action deq;\n"
        result += "         rg_credits_{0:s} <= rg_credits_{0:s} + 1;\n".format (struct_name)
        result += "         f_{:s}.deq;\n".format (struct_name)
        result += "      endmethod\n"
        result += "      method Bool notEmpty;\n"
        result += "         return f_{:s}.notEmpty;\n".format (struct_name)
        result += "      endmethod\n"
        result += "   endinterface\n"

    result += "\n"
    result += "    // BSV to C\n"
    for s in BSV_to_C_structs:
        result += "   interface FIFOF_I fi_{0:s} = to_FIFOF_I (f_{0:s});\n".format (s ['struct_name'])

    result += "\n"
    result += "    // ---------------- Facing C\n"
    result += "   interface FIFOF_I fi_C_to_BSV_bytevec = to_FIFOF_I (f_C_to_BSV_bytevec);\n"
    result += "   interface FIFOF_O fo_BSV_to_C_bytevec = to_FIFOF_O (f_BSV_to_C_bytevec);\n"

    result += "\n"
    result += "endmodule\n"
    result += "\n"
    return result

# ================================================================
