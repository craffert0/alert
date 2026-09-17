// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema
import Testing

struct eBirdRegionInfoTest {
    @Test func contains() {
        // lots of overlap down by Newtown Creek
        #expect(eBirdRegionInfo.kings.contains(location: .silvercup))
        #expect(eBirdRegionInfo.queens.contains(location: .silvercup))
        #expect(eBirdRegionInfo.ny.contains(location: .silvercup))

        // but not up there
        #expect(!eBirdRegionInfo.bronx.contains(location: .silvercup))
    }

    @Test func names() {
        let kings = eBirdRegionInfo.kings
        #expect(kings.fullName == "Kings, New York, United States")
        #expect(kings.regionalName == "Kings, New York")
        #expect(kings.shortName == "Kings")

        let ny = eBirdRegionInfo.ny
        #expect(ny.fullName == "New York, United States")
        #expect(ny.regionalName == "New York")
        #expect(ny.shortName == "New York")

        let us = eBirdRegionInfo.us
        #expect(us.fullName == "United States")
        #expect(us.regionalName == "United States")
        #expect(us.shortName == "United States")
    }
}
