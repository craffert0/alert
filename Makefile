# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

.PHONY: all lint test test_schema

all: test

test: test_schema

test_schema:
	cd eBirdAlert/Schema ; swift test -q

lint:
	swiftformat -q --swiftversion 6 .
