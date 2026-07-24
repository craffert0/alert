// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema
import Testing

struct FixedRegionLoaderTest {
    let loader = FixedRegionLoader(infos: {
        try! .from(Bundle.module.url(forResource: "regions",
                                     withExtension: "json")!)
    }())

    @Test func ny() throws {
        let actual = try #require(loader.getInfo(for: "US-NY"))
        try #require(actual.code == "US-NY")
        try #require(actual.type == .subnational1)
        let subrs = loader.getSubRegions(of: actual)
        try #require(subrs.count == 62)
    }

    @Test func us() throws {
        let actual = try #require(loader.getInfo(for: "US"))
        try #require(actual.code == "US")
        try #require(actual.type == .country)
        let subrs = loader.getSubRegions(of: actual)
        try #require(subrs.count == 51)
    }

    @Test func brooklyn() throws {
        let actual = try #require(loader.getInfo(for: "US-NY-047"))
        try #require(actual.code == "US-NY-047")
        try #require(actual.result == "Kings, New York, United States")
        let subrs = loader.getSubRegions(of: actual)
        #expect(subrs.count == 0)
    }

    @Test func puerto_rico() {
        #expect(loader.getInfo(for: "US-PR") == nil)
    }
}
