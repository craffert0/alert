# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

.PHONY: all lint test test_schema regen server pusher run_server test_server test_api

all: test pusher server

pusher:
	cd pusher ; swift build --configuration release

server:
	cd eBirdAlert/Server ; swift build --configuration release

run_server: 
	cd eBirdAlert/Server ; swift run

test_server: 
	cd eBirdAlert/Server ; swift test

test_api: 
	cd eBirdAlert/AlertAPI ; swift test

test_pusher:
	cd pusher ; swift test

test: test_schema test_pusher test_server test_api

test_schema:
	cd eBirdAlert/Schema ; swift test -q

lint:
	swiftformat -q --swiftversion 6 --disable wrapPropertyBodies,docComments .

regen:
	cd experiments ; ./generate_taxonomy ../eBirdAlert/Schema/Sources/Schema/eBirdOrder.swift > ../eBirdAlert/eBirdAlert/Assets/taxonomy.json
