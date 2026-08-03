// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema
import Testing

struct eBirdRegionServiceTest {
    let service = try! FakeRegionService.from(resource: "SampleRegionData")

    @Test func getRegionsAround() throws {
        let result =
            try service.getRegions(
                at: .prospectPark,
                around: .init(latitudeDelta: 0.40, longitudeDelta: 0.30)
            ).sorted(by: { a, b in a.code < b.code })
        try #require(result.count == 6)
        #expect(result[0].result == "Hudson, New Jersey, United States")
        #expect(result[1].result == "Bronx, New York, United States")
        #expect(result[2].result == "Kings, New York, United States")
        #expect(result[3].result == "New York, New York, United States")
        #expect(result[4].result == "Queens, New York, United States")
        #expect(result[5].result == "Richmond, New York, United States")
    }

    @Test func getRegionsAt() throws {
        let result = try service.getRegions(at: .prospectPark)
        try #require(result.count == 1)
        #expect(result[0].result == "Kings, New York, United States")
    }

    @Test func getRegionsAtMany() throws {
        let result = try service.getRegions(at: .silvercup)
        try #require(result.count == 3)
        #expect(result[0].result == "Kings, New York, United States")
        #expect(result[1].result == "New York, New York, United States")
        #expect(result[2].result == "Queens, New York, United States")
    }

    @Test func getRegionsAtCross() throws {
        let result = try service.getRegions(at: .hudsonRiver)
        try #require(result.count == 2)
        #expect(result[0].result == "Hudson, New Jersey, United States")
        #expect(result[1].result == "New York, New York, United States")
    }

    @Test func getRegionVariations() throws {
        try #expect(service.getRegion(at: .prospectPark) == .kings)
        try #expect(service.getRegion(at: .silvercup) == .nyc)
        try #expect(service.getRegion(at: .hudsonRiver)?.code == "US-NJ-017")
    }
}
