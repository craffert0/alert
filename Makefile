# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

.PHONY: all lint test test_schema, regen

all: test pusher

pusher: $(TEST_PUSHER_APP)
	cd pusher ; swift build --configuration release

test: test_schema test_pusher test_bazel

test_schema:
	cd eBirdAlert/Schema ; swift test -q

lint:
	swiftformat -q --swiftversion 6 .

regen:
	cd experiments ; ./generate_taxonomy ../eBirdAlert/Schema/Sources/Schema/eBirdOrder.swift > ../eBirdAlert/eBirdAlert/Assets/taxonomy.json
