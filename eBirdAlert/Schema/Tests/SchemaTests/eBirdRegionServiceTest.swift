// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import CoreLocation
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
                near: CLLocation(latitude: 40.67, longitude: -73.97)
            ).sorted()
        try #require(result.count == 7)
        #expect(result[0].name == "Bergen")
        #expect(result[1].name == "Hudson")
        #expect(result[2].name == "Bronx")
        #expect(result[3].name == "Kings")
        #expect(result[4].name == "New York")
        #expect(result[5].name == "Queens")
        #expect(result[6].name == "Richmond")
    }
}
