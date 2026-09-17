# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

.PHONY: all lint test test_schema regen server pusher run_server test_server test_api
.PHONY: regen regen_taxon regen_regions

.DELETE_ON_ERROR:

REGIONS_CSV := eBirdAlert/eBirdAlert/Assets/regions.csv
REGIONS_SRCDIR := ~/Documents/eBirdAlert/static_regions
REGIONS_SRCFILES := $(wildcard $(REGIONS_SRCDIR)/*)

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
	cd eBirdAlert/Schema ; swift test

lint:
	swiftformat -q --swiftversion 6 --disable wrapPropertyBodies,docComments .

regen: regen_taxon regen_regions

regen_taxon:
	experiments/generate_taxonomy eBirdAlert/Schema/Sources/Schema/eBirdFamily.swift > eBirdAlert/eBirdAlert/Assets/taxonomy.csv

regen_regions: $(REGIONS_CSV)

$(REGIONS_CSV): $(REGIONS_SRCFILES)
	experiments/collate-regions $(REGIONS_SRCDIR) > $(REGIONS_CSV)
