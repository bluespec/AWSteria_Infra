# ================================================================

def total_packet_size_bytes (s):
    return (s ['packet_len'] +
            s ['num_credits'] +
            s ['channel_id'] +
            s ['payload'])

def this_packet_size_bytes (s, n):
    return (s ['packet_len'] +
            s ['num_credits'] +
            s ['channel_id'] +
            n)

# ================================================================
# Substitution function to expand a template into code.
#     'template' is a list of strings
#     Each string represents a line of text,
#         and may contain '@FOO' variables to be substituted.
#     'substs' is list of (@FOO, string) substitutions.
# Returns a string which concatenates the lines and substitutes the vars.

def subst (template, substs):
    s = "\n".join (template)
    for (var, val) in substs:
        s = s.replace (var, val)
    return s

# ================================================================
