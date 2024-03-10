# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

SPW_ROOT ?= $(shell pwd)
BENDER	 ?= bender -d $(SPW_ROOT)

include spacewire.mk

all:
	@$(MAKE) spw-all

%-all:
	@$(MAKE) spw-$*-all

clean-%:
	@$(MAKE) spw-clean-$*
