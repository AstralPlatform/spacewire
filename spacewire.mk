# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

BENDER ?= bender
SPW_REG_DIR := $(shell $(BENDER) path register_interface)

VLOG_ARGS ?= -suppress 2583 -suppress 13314
VSIM ?= vsim

REGTOOL ?= $(SPW_REG_DIR)/vendor/lowrisc_opentitan/util/regtool.py

BENDER_ROOT ?= $(SPW_ROOT)/.bender

################
# Dependencies #
################
install-bender:
	curl --proto '=https' --tlsv1.2 https://pulp-platform.github.io/bender/init -sSf | sh

# Ensure both Bender dependencies and (essential) submodules are checked out
$(BENDER_ROOT)/.spw_deps:
	$(BENDER) checkout
	@touch $@

# Make sure dependencies are more up-to-date than any targets run
ifeq ($(shell test -f $(BENDER_ROOT)/.spw_deps && echo 1),)
-include $(BENDER_ROOT)/.spw_deps
endif

# Running this target will reset dependencies (without updating the checked-in Bender.lock)
spw-clean-deps:
	rm -rf .bender
	rm -rf hw/regs/*.sv

###############
# Generate HW #
###############

# SpW registers
$(SPW_ROOT)/hw/regs/spacewire_reg_pkg.sv $(SPW_ROOT)/hw/regs/spacewire_reg_top.sv: $(SPW_ROOT)/hw/regs/spacewire_regs.hjson
	$(REGTOOL) -r $< --outdir $(dir $@)

$(SPW_ROOT)/target/sim/vsim/compile.spacewire.tcl: $(SPW_ROOT)/Bender.yml
	$(BENDER) script vsim -t rtl --vlog-arg="$(VLOG_ARGS)" > $@
	echo 'vlog "$(realpath $(SPW_ROOT))/target/sim/src/elfloader.cpp" -ccflags "-std=c++11"' >> $@

.PHONY: spw-all spw-sw-all spw-hw-all spw-sim-all

SPW_HW_ALL += $(SPW_ROOT)/hw/regs/spacewire_reg_pkg.sv $(SPW_ROOT)/hw/regs/spacewire_reg_top.sv

SPW_SIM_ALL += $(SPW_ROOT)/target/sim/vsim/compile.spacewire.tcl

SPW_SW_ALL +=

SPW_ALL += $(SPW_SW_ALL) $(SPW_HW_ALL) $(SPW_SIM_ALL)

spw-all:     $(SPW_ALL)
spw-sw-all:  $(SPW_SW_ALL)
spw-hw-all:  $(SPW_HW_ALL)
spw-sim-all: $(SPW_SIM_ALL)
