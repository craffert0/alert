// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema
import Testing

@Suite struct eBirdRegionServiceTest {
    @Test func math() {
        #expect(2 + 2 == 4)
    }

    @Test func basics() async throws {
        let service = try FakeRegionService.from(resource: "SampleRegionData")
        let result =
            try await service.getRegions(
                near: Coordinate(latitude: 40.67, longitude: -73.97)
            ).sorted(by: { a, b in a.code < b.code })
        try #require(result.count == 7)
        #expect(result[0].result == "Bergen, New Jersey, United States")
        #expect(result[1].result == "Hudson, New Jersey, United States")
        #expect(result[2].result == "Bronx, New York, United States")
        #expect(result[3].result == "Kings, New York, United States")
        #expect(result[4].result == "New York, New York, United States")
        #expect(result[5].result == "Queens, New York, United States")
        #expect(result[6].result == "Richmond, New York, United States")
    }
}
