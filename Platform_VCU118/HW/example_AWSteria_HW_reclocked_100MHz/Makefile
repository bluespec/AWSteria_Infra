#-
# Copyright (c) 2020-2021 Jessica Clarke
#
# @BERI_LICENSE_HEADER_START@
#
# Licensed to BERI Open Systems C.I.C. (BERI) under one or more contributor
# license agreements.  See the NOTICE file distributed with this work for
# additional information regarding copyright ownership.  BERI licenses this
# file to you under the BERI Hardware-Software License, Version 1.0 (the
# "License"); you may not use this file except in compliance with the
# License.  You may obtain a copy of the License at:
#
#   http://www.beri-open-systems.org/legal/license-1-0.txt
#
# Unless required by applicable law or agreed to in writing, Work distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations under the License.
#
# @BERI_LICENSE_HEADER_END@
#

PROJECT=	example

FILENAMES=	$(PROJECT).bit $(PROJECT).ltx
BUILD_FILES=	$(addprefix build/,$(FILENAMES))

.PNONY: all
all: $(BUILD_FILES)

.PHONY: clean
clean:
	rm -rf build

build:
	mkdir -p $@

# Replace .INTERMEDIATE with grouped targets once GNU Make 4.3 is widespread
.INTERMEDIATE: build.intermediate
$(BUILD_FILES): build.intermediate ;
build.intermediate: tcl/build.tcl | build
	cd build && vivado -mode batch -source ../tcl/build.tcl
