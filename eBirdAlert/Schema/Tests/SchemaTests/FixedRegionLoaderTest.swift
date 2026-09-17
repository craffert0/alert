// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema
import Testing

private extension FixedRegionLoader {
    func getChildren(of parent: eBirdRegionInfo) throws -> [eBirdRegionInfo] {
        try getSubRegions(of: parent).map {
            try #require(getInfo(for: $0.code))
        }
    }
}

struct FixedRegionLoaderTest {
    let loader = FixedRegionLoader(infos: {
        try! .fromCSV(Bundle.module.url(forResource: "regions",
                                        withExtension: "csv")!)
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

    @Test func parents() throws {
        let us = try #require(loader.getInfo(for: "US"))
        let ny = try #require(loader.getInfo(for: "US-NY"))
        let bk = try #require(loader.getInfo(for: "US-NY-047"))
        #expect(bk.parent == ny)
        #expect(ny.parent == us)
        #expect(us.parent == nil)
    }

    @Test func validateChildren() throws {
        for parent in loader.infos {
            if parent.code != "world" {
                for child in try loader.getChildren(of: parent) {
                    #expect(child.parent == parent)
                }
            }
        }
    }

    @Test func validateRegionType() {
        for region in loader.infos {
            switch region.type {
            case .custom, .country:
                #expect(region.parent == nil)
            case .subnational1:
                #expect(region.parent != nil)
                #expect(region.grandParent == nil)
            case .subnational2:
                #expect(region.grandParent != nil)
            }
        }
    }
}
