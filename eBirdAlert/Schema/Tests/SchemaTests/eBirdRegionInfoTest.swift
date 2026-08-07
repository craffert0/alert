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
}
