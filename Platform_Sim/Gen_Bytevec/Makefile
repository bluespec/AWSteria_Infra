# Copyright (c) 2020-2022 Bluespec, Inc.
# Author: Rishiyur S. Nikhil

BYTEVEC_FILES = Bytevec.bsv  Bytevec.c  Bytevec.h

HELP_GEN     = "Generate files {$(BYTEVEC_FILES)} locally"
HELP_INSTALL = "Move {$(BYTEVEC_FILES)} files to relevant dirs"

GEN_PY      = Gen_Bytevec_Mux.py

# ================================================================

.PHONY: help
help:
	@echo  "Usage:"
	@echo  "    make gen        $(HELP_GEN)    (using tool $(GEN_PY))"
	@echo  "    make install    $(HELP_INSTALL)"

# ================================================================

.PHONY: gen
gen:
	@echo "---- $(HELP_GEN)    (Needs tool $(GEN_PY))"
	./$(GEN_PY)  AWS_FPGA_Spec.py

.PHONY: install
install:
	@echo "---- $(HELP_INSTALL)"
	mv  Bytevec.c  Bytevec.h  ../Host/
	mv  Bytevec.bsv           ../HW/

# ================================================================

.PHONY: clean
clean:
	rm -f  *~

.PHONY: full_clean
full_clean:
	rm -f  *~  $(BYTEVEC_FILES)
